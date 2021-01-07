/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace)

Include EnsHL7

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.IdentifyMessageProcessor Extends MessageProcessor
{

Property RigSchemas As RigSchemaCollection [ Private ];

Property Version As %String [ Private ];

Property Combine As %Boolean [ Private ];

Property Quiet As %Boolean [ Private ];

Property MultiMessageReportList As list Of MultiMessageReport [ Private ];

Property RigSchemaIndex As RigSchemaIndex [ Private ];

Property MatchCache As MatchCache [ Private ];

/// MessageTypeMappings=$LB($LB(MESSAGETYPE,SCHEMA),..)
Property MessageTypeMappings As %List [ Private ];

/// Cached from the config MESSAGETYPEONLY flag value on construction
Property MessageTypeOnly As %Boolean [ Private ];

/// pLogger can be passed as "" for a console logger
Method %OnNew(pRigSchemas As RigSchemaCollection, pConfig As Config, pVersion As %String, pLogger As Logger, pCombine As %Boolean, pQuiet As %Boolean) As %Status
{
	Set ..RigSchemas=pRigSchemas
	Set ..Config=pConfig
	Set ..Version=pVersion
	Set ..Logger=$Select(pLogger="":##class(Logger).%New(,,..Config),1:pLogger)
	Set ..FolderType=##class(FolderType).%New()
	Set ..Combine=pCombine
	Set ..Quiet=pQuiet
	Do ..RefreshIndexPossiblyCache()
	Set ..MessageTypeMappings=..MakeMessageTypeMappings(pConfig.GetOptionValue("MESSAGETYPEMAPPINGS"))
	Set ..MessageTypeOnly=..Config.IsFlagSet("MESSAGETYPEONLY")
	
	Quit $$$OK
}

Method GetMessageParentFolders(pReportIndex As %Integer) As %List [ CodeMode = expression ]
{
..MultiMessageReportList.GetAt(pReportIndex).GetMessageParentFolders()
}

Method MergeADT(pMessagesOrigin As %String) As %Boolean [ CodeMode = expression ]
{
..Config.IsFlagSet("MERGEADTMESSAGES")
}

Method NewReport(pMessagesOrigin As %String, pMessageType As %String) As %Integer
{
	// if we should combine sources ..
	If '..Combine || ..MessageFolderChange(pMessagesOrigin) {

		// if the messages origin is a path ..
		If $Extract(pMessagesOrigin)="@" {
		
			// the directory part of the path
			Set tMessagesFolder=##class(%File).GetDirectory($Extract(pMessagesOrigin,2,*))

			// if it's a messages folder ..
			If tMessagesFolder'="",..FolderType.IsMessagesFolder(tMessagesFolder) {
			
				// load local schemas from messages folder, if appropriate (i.e. it's the first report or the path has changed)				
				Do ##class(FolderType).LoadFolderSchemas(tMessagesFolder,..RigSchemas,..Config,..Logger,..Quiet)

				// recreate index, possibly cache
				Do ..RefreshIndexPossiblyCache()
			}
		}
		
		// create a new report
		Do ..MultiMessageReportList.Insert(##class(MultiMessageReport).%New(pMessageType,..Logger, ##class(MessageHandler).%New(..FolderType)))
	}
	 
	Set tIndex=..MultiMessageReportList.Count()
	
	// add the origin
	Do ..MultiMessageReportList.GetAt(tIndex).AddMessagesOrigin(pMessagesOrigin)
	
	// return its index
	Quit tIndex
}

Method ProcessMessage(pReportIndex As %Integer, pMessageType As %String, pMessageSegmentTypes As %List, pMessageCount As %Integer, ByRef pFullMessageArray, pPathIfUnique As %String)
{
	If ..MessageTypeOnly,pMessageType="UNKNOWN" {
		$$$IFSESSION(ScanEvent("NoMessageType",$LB("MessageSegments",$ListToString(pMessageSegmentTypes)),$LB("MessageCount",pMessageCount),$LB("PathIfUnique",pPathIfUnique)))
	}
	Else {
		Do ..MultiMessageReportList.GetAt(pReportIndex).AddMessageReport(..IdentifyImplMatch("",pMessageType,pMessageSegmentTypes,pMessageCount,pPathIfUnique,..Quiet))
	}
}

Method GetVersion() As %String [ CodeMode = expression ]
{
..Version
}

Method GetReportCount() As %Integer [ CodeMode = expression ]
{
..MultiMessageReportList.Count()
}

Method Report(pReportIndex As %Integer, pMachineCollection As MachineCollection, pConfig As Config, pLogger As Logger, Output pStrategyManagers)
{
	$$$SHOULDBEUNDEF(pStrategyManagers)
	
	Do ..MultiMessageReportList.GetAt(pReportIndex).Report(pMachineCollection,pConfig,.pStrategyManagers)
}

Method IdentifyImplMatch(pOptionalPath As %String = "", pMessageType As %String, pMessageSegmentTypes As %List, pMessageCount As %Integer, pPathIfUnique As %String, pQuiet As %Boolean) As MessageReport
{
	Set findAllMatchingSchemas='$IsObject(..MatchCache)
	Set rigSchemaOrder=..RigSchemaOrder(pMessageType,findAllMatchingSchemas)	

	Set messagereport=##class(MessageReport).%New(pOptionalPath,pMessageSegmentTypes,pMessageCount,pPathIfUnique)
	Set matchingschemas=""
	
	Set ptrI=0 While $ListNext(rigSchemaOrder,ptrI,rigSchemaIndex) {
		
		Set schemadef=..RigSchemaIndex.GetAt(rigSchemaIndex)
		Set schemaname=schemadef.GetSchemaName()
		Set schemasource=schemadef.GetSchemaSpec()

		Kill failureoutcome
		Set $ListBuild(success,furthestreport)=..RunImplMatchRaw(rigSchemaIndex,pMessageSegmentTypes,pQuiet,.failureoutcome)
		If success {
			Set matchingschemas=matchingschemas_$ListBuild($ListBuild(schemaname,schemasource))
			If 'findAllMatchingSchemas {
				Do ..MatchCache.OnMatch(rigSchemaIndex)
				Quit // stop on success
			}
		}
		Else {
		
			$$$ACASSERT($IsObject(failureoutcome),"IdentifyImplMatch: after failure, 'failureoutcome' is not an object")
		
			// unless it's a control failure ..
			If failureoutcome.FailureOutcomeType()'=$$$FOCONT {
			
				Set tNewLength=$ListLength(furthestreport)
				
				Set tAll(tNewLength,schemaname)=schemasource
				Set tAll(tNewLength,schemaname,0)=failureoutcome
			}
		}
	}
	
	If matchingschemas="" {		
	
		Set tHighestLength=$Order(tAll(""),-1)
		If tHighestLength'="" {
			Set tSchemaName="" While 1 {
				Set tSchemaName=$Order(tAll(tHighestLength,tSchemaName),+1,tSchemaSource) If tSchemaName="" {Quit}
				Do messagereport.MismatchesBestSchema($ListBuild(tSchemaName,tSchemaSource),tAll(tHighestLength,tSchemaName,0))
				$$$IFSESSION(ScanEvent("Mismatch",$LB("MessageSegments",$ListToString(pMessageSegmentTypes)),$LB("SchemaName",tSchemaName)))
			}
		}
	}
	
	Else {
		Do messagereport.MatchesSchemas(matchingschemas)
		Set tOut=""
		Set tPtr=0 While $ListNext(matchingschemas,tPtr,tElem) {
			Set tOut=tOut_$ListBuild($List(tElem))
		}
		Set tSchemaNames=$ListToString(tOut)
		$$$IFSESSION(ScanEvent("Match",$LB("MessageSegments",$ListToString(pMessageSegmentTypes)),$LB("SchemaNames",tSchemaNames)))
	}
	
	Quit messagereport
}

Method RigSchemaOrder(pDelimitedMessageType As %String, pFindAllMatchingSchemas As %Boolean) As %List [ Private ]
{
	Set tMessageType=..UndelimitMessageType(pDelimitedMessageType)
	
	Set tSchemaName=..MessageTypeToSchema(tMessageType)
	If tSchemaName'="" {
		Set tSchemaIndex=..RigSchemaIndex.SchemaIndex(tSchemaName)
		If tSchemaIndex {
			Quit $ListBuild(tSchemaIndex)
		}
	}
	
	Quit $Select(
		pFindAllMatchingSchemas:##class(MatchCache).NormalOrder(..RigSchemaIndex),
		1:..MatchCache.SchemaOrder())
}

ClassMethod UndelimitMessageType(pPossiblyDelimitedMessageType As %String) As %String [ CodeMode = expression, Private ]
{
$Select(pPossiblyDelimitedMessageType["^":$Piece(pPossiblyDelimitedMessageType,"^")_"_"_$Piece(pPossiblyDelimitedMessageType,"^",2,*),1:pPossiblyDelimitedMessageType)
}

ClassMethod MakeMessageTypeMappings(pMessageTypeMappings As %String) As %List [ Private ]
{
	Set tOut=""
	Try {
		Set tPtr=0 While $ListNext($ListFromString(pMessageTypeMappings),tPtr,tMapping) {
			Set $ListBuild(tGivenMessageType,tGivenSchemaName)=$ListFromString(tMapping,"=")
			Set tMessageType=..UndelimitMessageType(tGivenMessageType)
			Set tSchemaName=$$$TRIM($Get(tGivenSchemaName))
			Set tOut=tOut_$ListBuild($ListBuild(tMessageType,tSchemaName))
		} 
	}
	Catch err {
		$$$THROW("Invalid message type mappings: "_pMessageTypeMappings)
	}
	
	Quit tOut
}

Method MessageTypeToSchema(pMessageType As %String) As %String [ Private ]
{
	// no message type given
	If pMessageType="" {
		Quit ""
	}
	
	// try user-provided message type mappings
	Set tPtr=0 While $ListNext(..MessageTypeMappings,tPtr,tMapping) {
	
		Set $ListBuild(tMessageType,tSchemaName)=tMapping
		
		// wildcard match
		If $Extract(tMessageType,*)="*" {
			If $Extract(pMessageType,1,$Length(tMessageType)-1)=$Extract(tMessageType,1,*-1) {
				Return tSchemaName
			}
		}
		
		// exact match
		Else {
			If pMessageType=tMessageType {
				Return tSchemaName
			}
		}
	}
	
	// try Ensemble HL7 message type mappings
	If $Data($$$vaSchemaGbl(##class(Common).SchemaVersion(..Version),"MT",pMessageType),tSchemaRef)#10 {
		Set tSchemaVersion=$Piece(tSchemaRef,":"),tSchemaName=$Piece(tSchemaRef,":",2)
		If tSchemaVersion'="",tSchemaVersion'=..Version {
			If '..Quiet {
				Write "Warning: message type '",pMessageType,"' in version ",..Version," refers to schema '",tSchemaRef,"'",!
			}  
		}
		Quit tSchemaName
	}
	
	// try all loaded schemas
	Quit ""
}

Method RunImplMatchRaw(RunSchemaIndex As %Integer, MessageTypes As %List, Quiet As %Boolean = 0, Output FailureOutcome) As %List [ CodeMode = expression, Private ]
{
##class(Common).RunImplMatch(MessageTypes,..RigSchemaIndex.GetAt(RunSchemaIndex),..Config,Quiet,.FailureOutcome)
}

/// / Return 1 if the messages origin is a folder and it's has changed since the last message
Method MessageFolderChange(pMessagesOrigin As %String) As %Boolean [ Private ]
{
	// if there are no existing reports ..
	If ..MultiMessageReportList.Count()=0 {
		Quit 1 // - start a new one
	}

	// if the new origin is not a path ..
	If $Extract(pMessagesOrigin)'="@" {
		Quit 0 // - carry on with the old one
	}
		
	// get the messages origin of the most recent report
	Set tOldMessagesOrigin=..MultiMessageReportList.GetAt(..MultiMessageReportList.Count()).GetMessagesOrigin()
	
	// set first origin if any present
	Set tSingleOldOrigin=$Select(tOldMessagesOrigin'="":$List(tOldMessagesOrigin),1:"")
			
	// if the old origin is not a path ..
	If $Extract(tSingleOldOrigin)'="@" {
		Quit 1 // - start a new one
	}

	// if the old folder matches the new one ..
	If ##class(%File).GetDirectory($Extract(tSingleOldOrigin,2,*),1)=##class(%File).GetDirectory($Extract(pMessagesOrigin,2,*)) {
		Quit 0 // - carry on with the old one
	}
		
	Quit 1 // - start a new one
}

Method RefreshIndexPossiblyCache() [ Private ]
{
	Set ..RigSchemaIndex=##class(RigSchemaIndex).%New(..RigSchemas)
	Set ..MatchCache=$Select(
		..Config.IsFlagSet("FINDALLMATCHINGSCHEMAS"):"",
		1:##class(MatchCache).%New(..RigSchemaIndex))
}

}
