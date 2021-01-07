/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsDICOM)

/// This class represents a DICOM Association Context. It manages data which defines various parameters which are 
/// exchanged with the DICOM peer during the connection negotiation process. Items include the names of the calling and 
/// called Application Entity Titles (AETs), the maximum physical size of TCP data packets along with a list of one or more
/// presentation context objects which defines of which services are/should be available and their associated transfer syntaxes
Class EnsLib.DICOM.Util.AssociationContext Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, System = 4 ]
{

/// This holds the Name of the Association Context
Property Name As %String(MAXLEN = 64);

/// This holds the Description of the Association Context
Property Description As %String(MAXLEN = 256);

/// This holds the Application Entity Title of the calling DICOM Peer. Together with the CalledAET, this property
/// uniquely defines the object instance
Property CallingAET As %String(MAXLEN = 16) [ Required ];

/// This holds the Application Entity Title of the called DICOM Peer. Together with the CallingAET, this property
/// uniquely defines the object instance
Property CalledAET As %String(MAXLEN = 16) [ Required ];

/// This holds the list of presentation contexts
Property PresentationContexts As list Of EnsLib.DICOM.Util.PresentationContext;

/// Index AET, use this for retrieving instance of the object from the database
Index AET On (CallingAET, CalledAET) [ IdKey ];

Method %OnNew(pCallingAET As %RawString, pCalledAET As %RawString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..CallingAET=$Get(pCallingAET),..CalledAET=$Get(pCalledAET)
	Quit $$$OK
}

Query Enumerate() As %SQLQuery [ SqlProc ]
{
SELECT %Id, CallingAET,CalledAET, Name, Description FROM EnsLib_DICOM_Util.AssociationContext
}

/// Provides a simple way to test the Enumerate Query
ClassMethod TestEnumerate()
{
	#dim tRS As %IResultSet
	Set tRS=##class(%IResultSet).%Prepare("EnsLib.DICOM.Util.AssociationContext:Enumerate")
	while (tRS.Next()) {
		do tRS.%Print()
	}
}

/// This method exports an Association Context as XML into the specified file
ClassMethod ExportXML(pFileName As %String, pCallingAET As %String, pCalledAET As %String) As %Status
{
	#dim tSC As %Status=$$$OK
	#dim tContext As AssociationContext
	#dim tWriter As %XML.Writer
	
	try {
		#; Open the specified object
		Set tContext=##class(AssociationContext).%OpenId(pCallingAET_"||"_pCalledAET,,.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Get a %XML.Writer
		Kill %objlasterror Set tWriter=##class(%XML.Writer).%New()
		If '$IsObject(tWriter) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"%XML.Writer")) Quit
		
		#; We will output UTF-8 to the specified file
		Set tWriter.Charset="UTF-8"
		
		#; Output to the specified file
		Set tSC=tWriter.OutputToFile(pFileName) If $$$ISERR(tSC) Quit
		
		#; The root will be "associations"
		Set tSC=tWriter.RootElement("associations") If $$$ISERR(tSC) Quit
		
		#; Write out the object
		Set tSC=tWriter.Object(tContext,"association") If $$$ISERR(tSC) Quit
		
		#; Close the object
		Set tSC=tWriter.EndRootElement() If $$$ISERR(tSC) Quit
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// This method imports a file containing an AssociationContext
ClassMethod ImportXML(pFileName) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tContext As AssociationContext
	#dim tReader As %XML.Reader
	
	try {
		
		#; Get a %XML.Reader
		Kill %objlasterror Set tReader=##class(%XML.Reader).%New()
		If '$IsObject(tReader) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"%XML.Reader")) Quit
		
		#; Open the file
		Set tSC=tReader.OpenFile(pFileName) If $$$ISERR(tSC) Quit
		
		Do tReader.Correlate("association","EnsLib.DICOM.Util.AssociationContext")
		
		While('$$$ISERR(tSC)) {
			If (tReader.Next(.tContext,.tSC)=0)||($$$ISERR(tSC)) Quit
			Set tSC=tContext.%Save()
		}
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// This method is passed a filename containing a list of presentation contexts containing SOP/TransferSyntax pairs
/// An Association will be created between the pair of AETs containing the information from the file
ClassMethod ImportAssociation(pFileName As %String, pCallingAET As %String, pCalledAET As %String, pOverWriteExisting As %Boolean = 0)
{
	#dim tSC As %Status
	#dim tAC As EnsLib.DICOM.Util.AssociationContext
	#dim tPC As EnsLib.DICOM.Util.PresentationContext
	#dim tStream As %FileCharacterStream
	#dim tEndOfFile As %Boolean
	#dim tLine,tSOP,tTS As %String
	#dim tI As %Integer
	
	Set $ZT="Trap",tSC=$$$OK
	do {
	
		#; Check that file exists
		If '##class(%File).Exists(pFileName) Set tSC=$$$EnsError($$$FileDoesNotExist,pFileName) Quit
		
		#; Delete the pre-existing instance?
		If ##class(EnsLib.DICOM.Util.AssociationContext).AETExists(pCallingAET,pCalledAET) {
			If pOverWriteExisting=0 Set tSC=$$$EnsError($$$EnsDICOMAssociationAlreadyExists,pCallingAET,pCalledAET) Quit
			Set tSC=##class(EnsLib.DICOM.Util.AssociationContext).AETDelete(pCallingAET,pCalledAET) If $$$ISERR(tSC) Quit
		}
		
		Kill %objlasterror Set tAC=##class(EnsLib.DICOM.Util.AssociationContext).%New(pCallingAET,pCalledAET)
		If '$IsObject(tAC) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.AssociationContext")) Quit

		#; Create the file character stream
		Kill %objlasterror Set tStream=##class(%FileCharacterStream).%New()
		If '$IsObject(tStream) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"%FileCharacterStream")) Quit
		
		#; Set the file name
		Set tStream.Filename=pFileName
		
		#; Read a line
		Set tSC=..ReadLine(tStream,.tEndOfFile,.tLine) If $$$ISERR(tSC) Quit
		while ('tEndOfFile) {
			
			#; Get the SOP
			Set tSOP=$Piece(tLine,"\")
			
			#; Create a presentation context
			Kill %objlasterror Set tPC=##class(EnsLib.DICOM.Util.PresentationContext).%New(tSOP)
			If '$IsObject(tPC) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.PresentationContext")) Quit
			
			#; If no Transfer syntaxes defined then add the default syntax ( MUST be supported )
			If $Length(tLine,"\")=1 {
				Set tSC=tPC.TransferSyntaxes.Insert($$$IMPLICITVRLETRANSFERSYNTAX) If $$$ISERR(tSC) Quit
			} Else {
			
				#; For each transfer syntax
				For tI=2:1:$Length(tLine,"\") {
					Set tSC=tPC.TransferSyntaxes.Insert($Piece(tLine,"\",tI)) If $$$ISERR(tSC) Quit
				}
				If $$$ISERR(tSC) Quit
			}
			
			#; Insert the presentation context into the AC
			Set tSC=tAC.PresentationContexts.Insert(tPC) If $$$ISERR(tSC) Quit
			
			#; Read another line
			Set tSC=..ReadLine(tStream,.tEndOfFile,.tLine) If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC=tAC.%Save() If $$$ISERR(tSC) Quit
		
	} while (0)
	 
Exit Do:$$$ISERR(tSC) $System.Status.DisplayError(tSC) Quit
Trap Set $ZT="",tSC=$$$EnsError($$$ObjectScriptError,$ZE) Goto Exit
}

/// This Reads the next line from the file
/// [Previously private]
ClassMethod ReadLine(pStream As %FileCharacterStream, Output pAtEnd As %Boolean, Output pLine As %String) As %Status [ Internal ]
{
	#dim tLine As %String
	#dim tPos As %Integer
	#dim tSC As %Status
		
	Set pAtEnd=0,tSC=$$$OK
	do {
		#; No more lines ?
		If pStream.AtEnd Set pAtEnd=1,pLine="" Quit 
		
		#; Get the next line
		Set tLine=pStream.ReadLine()
		
		#; Convert tabs to spaces
		Set tLine=$Translate(tLine,$C(9),$C(32))
		
		#; Remove leading and trailing spaces
		While $Extract(tLine)=" " 
		{
			Set $Extract(tLine)=""
		}
		
		While $Extract(tLine,$Length(tLine))=" " {
			Set $Extract(tLine,$Length(tLine))=""
		}
		
		#; Remove repeating spaces
		For  Set tPos=$Find(tLine,"  ") Quit:'tPos  Set $Extract(tLine,tPos-1)=""
		
		Set pLine=tLine
		
	} while ($Extract(pLine)="#"||(pLine="")) // Discard comments and empty lines
	
	Quit tSC
}

/// This method creates an AssociationContext instance for the specified calling and called AET for 
/// AbstractSyntaxes which supports ALL known SOPs. The TCP Adapter will use the definitions defined here to validate associations
/// It should be noted that this association simply defines all SOP classes that are known in the data dictionary. There is a small
/// performance penalty for this and it may be preferable to define just the SOP classes needed either with the UI tool found at
/// EMP/Maintenance/DICOM SETTINGS or by using the ImportAssociation() method above. Note that the default transfer syntax here is
/// the DICOM mandated IMPLICIT VR little endian syntax.
ClassMethod CreateAssociation(pCallingAET As %String, pCalledAET As %String, pTransferSyntaxes As %List = {$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX)}) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tAC As EnsLib.DICOM.Util.AssociationContext
	#dim tPC As EnsLib.DICOM.Util.PresentationContext
	#dim tUID,tData As %String
	#dim tI As %Integer
	
	Do  {
		
		#; Delete the pre-existing instance
		If ##class(EnsLib.DICOM.Util.AssociationContext).AETExists(pCallingAET,pCalledAET) {
			Set tSC=##class(EnsLib.DICOM.Util.AssociationContext).AETDelete(pCallingAET,pCalledAET) If $$$ISERR(tSC) Quit
		}

	 	#; Create a new association context
		Kill %objlasterror Set tAC=##class(EnsLib.DICOM.Util.AssociationContext).%New(pCallingAET,pCalledAET)
	 	If '$IsObject(tAC) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.AssociationContext")) Quit

		#; For every SOP in the dictionary
		Set tUID="" For {
			
			Set tUID=$Order(^EnsDICOM.Dictionary("as","u",tUID),1,tData) If tUID="" Quit
			
			#; Only want those SOP classes for GET,FIND,STORAGE and MOVE
			If (tData["GET")||(tData["FIND")||(tData["Storage")||(tData["MOVE")||(tData["Verification") {
				
				Kill %objlasterror Set tPC=##class(EnsLib.DICOM.Util.PresentationContext).%New(tUID)
		 		If '$IsObject(tPC) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.PresentationContext")) Quit
	 		
		 		For tI=1:1:$ListLength(pTransferSyntaxes) {
		 			Set tSC=tPC.TransferSyntaxes.Insert($List(pTransferSyntaxes,tI)) If $$$ISERR(tSC) Quit
		 		}
	 		
			 	Set tSC=tAC.PresentationContexts.Insert(tPC) If $$$ISERR(tSC) Quit
			}
		}

		Set tSC=tAC.%Save() If $$$ISERR(tSC) Quit
 
	} while (0)
	
	Quit tSC
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	#dim tSC As %Status = $$$OK
	do {
		#; The calling AET is not allowed to consist of just spaces
		If $ZStrip(..CallingAET,"<>W")="" Set tSC=$$$EnsError($$$EnsDICOMBadCallingAET) Quit
		
		#; The called AET is not allowed to consist of just spaces
		If $ZStrip(..CalledAET,"<>W")="" Set tSC=$$$EnsError($$$EnsDICOMBadCalledAET) Quit
	} while (0)
	Quit tSC
}

/// This method is called by the TCP Adapter when the Association Request from the DICOM peer is decoded.
Method OnAcceptPresentationContext(pAbstractSyntax As %String, ByRef pTransferSyntaxes, Output pSelectedTransferSyntax, Output pAbstractSupported As %Boolean) As %Boolean
{
	#dim tPCIndex,tTSIndex As %Integer
	#dim tPresentedSyntaxes,tAbstractSyntax,tTSName,tConfiguredSyntax As %String
	#dim tPCAcceptable As %Boolean = 0
	#dim tConfiguredSyntaxes As List of %String;
	Set pAbstractSupported = 0
	
	do {
		
		#; Search our presentation contexts for a match on abstract syntax
		For tPCIndex=1:1:..PresentationContexts.Count() {

			Set tAbstractSyntax=..PresentationContexts.GetAt(tPCIndex).AbstractSyntax 
			
			#; Match on PresentedAbstractSyntax with Configured AbstractSyntax?
			If tAbstractSyntax=pAbstractSyntax {
				
				#; Take note of the fact that this abstract syntax did match so that we can send
				#; back the correct reason if the presentation context is not accepted 
				Set pAbstractSupported = 1
				
				#; Create a one dimensional array of transfer syntax names
				Set tTSIndex="" For {
					Set tTSIndex=$Order(pTransferSyntaxes(tTSIndex)) If tTSIndex="" Quit
					Set tTSName=pTransferSyntaxes(tTSIndex,"name"),tPresentedSyntaxes(tTSName)=""
				}
				
				#; Get the list of our configured transfer syntaxes
				Set tConfiguredSyntaxes=..PresentationContexts.GetAt(tPCIndex).TransferSyntaxes
				
				#; Our configured transfer syntax list is in order of preference, pick the first
				#; presented syntax that matches an item in our list
				For tTSIndex=1:1:tConfiguredSyntaxes.Count() {
				
					Set tConfiguredSyntax=tConfiguredSyntaxes.GetAt(tTSIndex)
				
					If $Data(tPresentedSyntaxes(tConfiguredSyntax)) {
					
						#; Matched
						Set pSelectedTransferSyntax=tConfiguredSyntax,tPCAcceptable=1 Quit
					}
				}
			}
			
			If tPCAcceptable Quit
		}
		
	} while (0)
		
	Quit tPCAcceptable
}

/// Shows all the active associations by exercising the Active and ActiveDetail queries
ClassMethod ShowActive() As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tActiveRS,tActiveDetailRS As %ResultSet
	#dim tGUID As %String
	#dim tI As %Integer
	
	Try {
		
		Set tActiveRS=##class(%ResultSet).%New("EnsLib.DICOM.Util.AssociationContext:Active")
		Set tSC=tActiveRS.Execute() If $$$ISERR(tSC) Quit
		while tActiveRS.Next(.tSC) {
			
			If $$$ISERR(tSC) Quit
			
			Write !
			
			For tI=1:1:tActiveRS.GetColumnCount() {
				Write tActiveRS.Data(tActiveRS.GetColumnName(tI))," "
			}
			
			Write !
			
			Set tGUID=tActiveRS.Data("GUID")
			
			Set tActiveDetailRS=##class(%ResultSet).%New("EnsLib.DICOM.Util.AssociationContext:ActiveDetail")
			Set tSC=tActiveDetailRS.Execute(tGUID) If $$$ISERR(tSC) Quit
			while tActiveDetailRS.Next(.tSC) {
			
				If $$$ISERR(tSC) Quit
				
				Write !
			
				For tI=1:1:tActiveDetailRS.GetColumnCount() {
					Write tActiveDetailRS.Data(tActiveDetailRS.GetColumnName(tI)),"|"
				}
			}
		}
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Lists the active assocations. Returns the calling AET,called AET and its unique ID
/// The tuple represents the composite primary key
Query Active() As %Query(ROWSPEC = "CallingAET:%String,CalledAET:%String,GUID:%String")
{
}

ClassMethod ActiveExecute(ByRef qHandle As %Binary) As %Status
{
 	Set qHandle=$name($$$EnsRuntimeAppData("EnsLib.DICOM.Adapter.TCP","i"))
 	Quit $$$OK
}

ClassMethod ActiveClose(ByRef qHandle As %Binary) As %Status
{
 	Kill qHandle
 	Quit $$$OK
}

ClassMethod ActiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 #dim tSC As %Status = $$$OK
 try {
	Set Row="",AtEnd=0
	Set qHandle=$Query(@qHandle) If qHandle="" Set AtEnd=1 Quit
	If $QSubscript(qHandle,2)="EnsLib.DICOM.Adapter.TCP" {
		Set Row=$ListBuild($QSubscript(qHandle,4),$QSubscript(qHandle,5),$QSubscript(qHandle,6))
	} else {
		If qHandle="" Set AtEnd=1 Quit
	}
 } catch {
	 Set tSC=$$$EnsSystemError
 }
 Quit tSC
}

/// List the details of an Active Association
/// PC is the presentation context ID will range from 1 - n odd numbers only
/// AS is the uid of the abstract syntax
/// ASName is the name of the abstract syntax
/// Accepted is a Boolean. If its set to 1 then the next two items will be non empty
/// TS is the uid of the accepted transfer syntax
/// TSName is the name of the accepted transfer syntax
Query ActiveDetail(pGUID As %String) As %Query(ROWSPEC = "PC:%Integer,AS:%String,ASName:%String,Accepted:%Boolean,TS:%String,TSName:%String")
{
}

ClassMethod ActiveDetailExecute(ByRef qHandle As %Binary, pGUID As %String) As %Status
{
 	Set qHandle=$ListBuild($name($$$EnsRuntimeAppData("EnsLib.DICOM.Adapter.TCP","d",pGUID)),"")
 	Quit $$$OK
}

ClassMethod ActiveDetailClose(ByRef qHandle As %Binary) As %Status
{
 	Kill qHandle
 	Quit $$$OK
}

ClassMethod ActiveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 #dim tSC As %Status = $$$OK
 #dim tGbl,tAS,tASName,tTS,tTSName As %String
 #dim tPC,tAccepted As %Integer
 try {
	 
	Set Row="",AtEnd=0
	Set tGbl=$List(qHandle,1),tPC=$List(qHandle,2)
	Set tPC=$Order(@tGbl@("RQ",32,tPC)) If tPC="" Set Row="",AtEnd=1 Quit
	
	Set tAS=@tGbl@("RQ",32,tPC,48,1,"name"),tASName=$Get(^EnsDICOM.Dictionary("as","u",tAS),"unknown")
	Set tAccepted='@tGbl@("AC",32,tPC,"result")
	If tAccepted {
		Set tTS=@tGbl@("AC",32,tPC,64,1,"name"),tTSName=$Get(^EnsDICOM.Dictionary("ts","u",tTS),"unknown")
	} else {
		Set (tTS,tTSName)=""
	}
	
	Set Row=$ListBuild(tPC,tAS,tASName,tAccepted,tTS,tTSName),qHandle=$ListBuild(tGbl,tPC)
	
 } catch {
	 Set tSC=$$$EnsSystemError
 }
 Quit tSC
}

Storage Default
{
<Data name="AssociationContextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>PresentationContexts</Value>
</Value>
</Data>
<DataLocation>^EnsLib.DICO5A3.AssociationC762D</DataLocation>
<DefaultData>AssociationContextDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.DICO5A3.AssociationC762D</IdLocation>
<IndexLocation>^EnsLib.DICO5A3.AssociationC762I</IndexLocation>
<StreamLocation>^EnsLib.DICO5A3.AssociationC762S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
