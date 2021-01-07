/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.MessageProcessor Extends %RegisteredObject [ Abstract ]
{

Property MessageStores As list Of MessageStore [ Private ];

Property FolderType As FolderType [ Private ];

/// Subclass constructor should set this up
Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

/// Scan the given source (@folder/@file/literal) for messages and process each one
Method ScanMessages(pSource As %String, pAllowNonHL7Messages As %Boolean, pOutlierThreshold As %Numeric = 0.0, pMakeLight As %Boolean = 0, Output pRejectedMessages As %Integer, pQuiet As %Boolean) [ Final ]
{
	$$$SHOULDBEUNDEF(pRejectedMessages)
	
	$$$IFSESSION0(StartScan)
	
	Do ..LoadMessages(pSource,pAllowNonHL7Messages,.pRejectedMessages)
	
	Set tSkipLimit=+..Config.GetOptionValue("MESSAGESKIPCOUNTPROC")
	
	Set tSkipCounter=0
	
	// tLoaded(0,NONFILEMESSAGESORIGIN)=$LB(TOTALMESSAGES,UNIQUEMESSAGES)	
	// tLoaded(1,MESSAGESORIGINFOLDER,MESSAGESORIGINFILE)=$LB(TOTALMESSAGES,UNIQUEMESSAGES)
	Kill tLoaded
	For tI=1:1:..MessageStores.Count() {
	
		Set tMessageStore=..MessageStores.GetAt(tI)

		Set tOrigin=tMessageStore.GetMessagesOrigin()
		
		// file origin ..
		If $Extract(tOrigin)="@" {
		
			// get folder and file parts
			Set tOriginPath=$Extract(tOrigin,2,*)
			Set tOriginFolder=##class(%File).GetDirectory(tOriginPath,0)
			Set tOriginFile=##class(%File).GetFilename(tOriginPath)
			
			// if they are no good ..
			If (tOriginFolder="") || (tOriginFile="") {
				Set tLoaded(0,tOrigin)=$ListBuild(tMessageStore.ComputeTotalMessageCount(),tMessageStore.Count())
			}
			
			// folder and file are good ..
			Else {
				Set tLoaded(1,tOriginFolder,tOriginFile)=$ListBuild(tMessageStore.ComputeTotalMessageCount(),tMessageStore.Count())
			}
		}
		
		// non-file origin ..
		Else {
			Set tLoaded(0,tOrigin)=$ListBuild(tMessageStore.ComputeTotalMessageCount(),tMessageStore.Count())
		}

		
		Do ..ScanOne(tMessageStore,pOutlierThreshold,pMakeLight,pQuiet,tSkipLimit,.tSkipCounter)
	}
	
	Do ..LoadingReport(.tLoaded)
}

Method ScanOne(pMessageStore As MessageStore, pOutlierThreshold As %Numeric, pMakeLight As %Boolean, pQuiet As %Boolean, pSkipLimit As %Integer, ByRef pSkipCounter As %Integer) [ Private ]
{
	If pMakeLight {
		Do ..MakeLight(pMessageStore)
	}
	
	Set tMessageTypes=pMessageStore.MessageTypes()
	
	Set tPtr=0 While $ListNext(tMessageTypes,tPtr,tMessType) {

		If 'pQuiet {
			Do ..Logger.OutputToLog("")
			Do ..Logger.OutputToLog("----- "_tMessType)
		}
		
		Set tReportIndex=..NewReport(pMessageStore.GetMessagesOrigin(),tMessType)
	
		Set tTypeStore=pMessageStore.TypeStore(tMessType)
		
		If 'pQuiet {
			Do ..Logger.OutputToLog("Loaded "_tTypeStore.ComputeTotalMessageCount()_" messages")
			Do ..Logger.OutputToLog(" - "_tTypeStore.Count()_" unique messages")
		}
		
		Do tTypeStore.RemoveAndReturnOutliers(pOutlierThreshold,.tOutliers)
		If 'pQuiet,$Get(tOutliers) {
		
			Do ..Logger.OutputToLog("Outliers:")
			For tI=1:1:tOutliers {
				Set $ListBuild(tKey,tCount)=tOutliers(tI)
				Do ..Logger.OutputToLog(" "_tKey_" - "_tCount)
			}
			
			Do ..Logger.OutputToLog("After removing outliers: "_tTypeStore.ComputeTotalMessageCount()_" messages")
			Do ..Logger.OutputToLog(" - "_tTypeStore.Count()_" unique messages")
		}	
		
		Set tPathIfUnique=pMessageStore.GetUniquePath()
		
		Set tMessage="" While 1 {
					
			Set tMessage=tTypeStore.Next(tMessage) If tMessage="" {Quit}
			
			Set tProcess=1
			If pSkipLimit {
				Set pSkipCounter=pSkipCounter+1
				If pSkipCounter < pSkipLimit {Set tProcess=0} Else {Set pSkipCounter=0}
			}
			
			If tProcess {
			
				Set tMessageCount=tTypeStore.GetMessageCount(tMessage)
				Kill tFullMessageArray
				Do tTypeStore.GetFullMessages(tMessage,.tFullMessageArray)
				Do ..ProcessMessage(tReportIndex,tMessType,$ListFromString(tMessage),tMessageCount,.tFullMessageArray,tPathIfUnique)
				
				For tS=1:1:tFullMessageArray {
					$$$IFSESSION(ScanEvent("ScanMessage",$LB("FullMessage",tFullMessageArray(tS)),$LB("MessageOrigin",pMessageStore.GetMessagesOrigin()),$LB("MessageType",tMessType)))
				}			
			}
		}
	}
}

Method GetMessageParentFolders(pReportIndex As %Integer) As %List [ Abstract ]
{
}

Method MergeADT(pMessagesOrigin As %String) As %Boolean [ Abstract ]
{
}

Method NewReport(pMessagesOrigin As %String, pMessageType As %String) As %Integer [ Abstract ]
{
}

Method ProcessMessage(pReportIndex As %Integer, pMessageType As %String, pMessageTypes As %List, pMessageCount As %Integer, ByRef pFullMessageArray, pPathIfUnique As %String) [ Abstract ]
{
}

Method GetVersion() As %String [ Abstract ]
{
}

Method Report(pReportIndex As %Integer, pMachineCollection As MachineCollection, pConfig As Config, pLogger As Logger, Output pStrategyManagers) [ Abstract ]
{
}

Method Dump()
{
	For tI=1:1:..MessageStores.Count() {
		Write !,"Message Store #",tI,!
		Do ..MessageStores.GetAt(tI).Dump()
	}
}

/// Scan the given source (@folder/@file/literal) for messages and add each one to the message store
Method LoadMessages(pSource As %String, pAllowNonHL7Messages As %Boolean, Output pRejectedMessages As %Integer) [ Private ]
{
	$$$SHOULDBEUNDEF(pRejectedMessages)

	Set tVersion=..GetVersion()
	
	// if it's a file or folder ..
	If $Extract(pSource)="@" {
	
		// just "@" means use the MESSAGESDIR global setting
		Set path=$$$TRIM($Select(pSource="@":$$$GLOBALSETTING("MESSAGESDIR"),1:$Extract(pSource,2,*)))
		
		// if it's a folder ..
		If ##class(%File).DirectoryExists(path) {
		
			Do ..LoadMessagesInFolder(path,tVersion,pAllowNonHL7Messages,.pRejectedMessages)
		}
		
		// .. it's an existing file ..
		ElseIf ##class(%File).Exists(path) {
		
			Set tMessageStore=..NewMessageStore("@"_path)
			
			// for each message in the file ..
			Set tReader=##class(MessageFileReader).%New(path,..Config)
			While tReader.NextMessage(.messagetext,.messagenumber,.startlineno) {
			
				Set messagesegmentlist=##class(MessageUtils).MessageSegmentTypes(messagetext)
						
				// if it IS a message ..
				Set tSimpleMessage=##class(SimpleMessage).%New(messagetext)
				If pAllowNonHL7Messages || ..IsMessageTypeList(messagesegmentlist),$IsObject(tSimpleMessage) {
					Do ..AddMessageToStore(tMessageStore,tSimpleMessage,messagesegmentlist,tVersion)
				}
				Else {
					Set pRejectedMessages($I(pRejectedMessages))=messagetext
				}
			}
		}
		
		// .. neither a folder nor a file ..
		Else {
			$$$THROW("'"_path_"' is not a file or folder")
			Quit
		}
	}
	
	// .. a literal sequence of messages (assumed STRIPPED) separated by "+" ..
	Else {
		Set tMessageStore=..NewMessageStore(pSource)
		Set tMessageListList=$ListFromString(pSource,"+")
		Set tPtrI=0 While $ListNext(tMessageListList,tPtrI,tMessageList) {
			Set messagesegmentlist=$ListFromString(tMessageList)
			Set tSimpleMessage=##class(SimpleMessage).%New(tMessageList)
			If '$IsObject(tSimpleMessage) {			
				$$$ThrowStatus(%objlasterror)
			}
			Do ..AddMessageToStore(tMessageStore,tSimpleMessage,messagesegmentlist,tVersion)
		}
	}
}

Method LoadMessagesInFolder(pPath As %String, pVersion As %String, pAllowNonHL7Messages As %Boolean, ByRef pRejectedMessages As %Integer) [ Private ]
{
	// if this is a container folder ..
	If ..FolderType.IsContainerFolder(pPath) {
	
		// scan the folder for subfolders
		Set tScanner=##class(FolderScanner).%New(pPath)
		While tScanner.Next(.tPath,.tIsDir) {
		
			// if it's a directory ..
			If tIsDir {
			
				// unless the directory name begins with "." ..
				Set tFileName=##class(%File).GetFilename(tPath)
				If $Extract(tFileName)'="." {
				
					// recurse (the structures that *we* create are only 2 or 3 levels deep)
					Do ..LoadMessagesInFolder(tPath,pVersion,pAllowNonHL7Messages,.pRejectedMessages)
				}
			}
		}
	}
	
	// .. not a container folder ..
	Else {
	
		// scan the folder for files
		Set tScanner=##class(FolderScanner).%New(pPath)
		While tScanner.Next(.tPath,.tIsDir) {
		
			// if it's a plain file ..
			If 'tIsDir {
			
				// if it's a message filename AND no "light" version exists ..
				If ##class(FolderType).IsMessageFileName(tPath),'##class(%File).Exists(tPath_"light") {
				
					Set tMessageStore=..NewMessageStore("@"_tPath)
						
					// for each message in the file ..
					Set tReader=##class(MessageFileReader).%New(tPath,..Config)
					While tReader.NextMessage(.messagetext,.messagenumber,.startlineno) {
					
						Set messagesegmentlist=##class(MessageUtils).MessageSegmentTypes(messagetext)
												
						// if it IS a message ..
						Set tSimpleMessage=##class(SimpleMessage).%New(messagetext)
						If pAllowNonHL7Messages || ..IsMessageTypeList(messagesegmentlist),$IsObject(tSimpleMessage) {
							Do ..AddMessageToStore(tMessageStore,tSimpleMessage,messagesegmentlist,pVersion)
						}
						Else {
							Set pRejectedMessages($I(pRejectedMessages))=messagetext
						}
					}
				}
			}
		}
	}
}

ClassMethod AddMessageToStore(pMessageStore As MessageStore, pSimpleMessage As SimpleMessage, pMessageList As %List, pVersion As %String) [ Private ]
{
	Set tMessageType=$$$SMMSHMESSAGETYPE(pSimpleMessage)
	Set tMessageControlID=$$$SMMSHMESSAGECONTROLID(pSimpleMessage)
	
	Do pMessageStore.Add(pSimpleMessage.GetMessage($Char(10)),tMessageType,tMessageControlID,$ListToString(pMessageList))
	
	$$$IFSESSION(ScanEvent("LoadMessage",$LB("MessageControlId",tMessageControlID),$LB("MessageOrigin",pMessageStore.GetMessagesOrigin()),$LB("MessageType",tMessageType)))
}

ClassMethod IsMessageTypeList(MessageList As %List) As %Boolean [ Private ]
{
	If $ListLength(MessageList)<1 {
		Quit 0
	}
	
	Set tFirst=$List(MessageList)
	If $Select(tFirst[":":$Piece(tFirst,":",2),1:tFirst)'="MSH" {
		Quit 0
	}
	
	Set tOut=""
	Set tPtr=0 While $ListNext(MessageList,tPtr,tSegment) { 
		Set tType=$Select(tSegment[":":$Piece(tSegment,":",2),1:tSegment)
		If 'tType?1U2UN {
			Return 0
		}
	}
	
	Quit 1
}

Method NewMessageStore(pMessagesOrigin As %String) As MessageStore [ Private ]
{
	Set tMessageStore=##class(MessageStore).%New(pMessagesOrigin,..MergeADT(pMessagesOrigin))
	Do ..MessageStores.Insert(tMessageStore)
	Quit tMessageStore
}

Method MakeLight(pMessageStore As MessageStore) [ Private ]
{
	Set tOrigin=pMessageStore.GetMessagesOrigin()
	
	If $Extract(tOrigin)="@",$Extract(tOrigin,*-4,*)'="light" {
	
		Set tLightPath=$Extract(tOrigin,2,*)_"light"
		If '##class(%File).Exists(tLightPath) {
		
			Set tFile=##class(%File).%New(tLightPath)
			$$$THROWONERROR(tSC,tFile.Open("WN"))
			
			Set tMessageTypes=pMessageStore.MessageTypes()
	
			Set tPtr=0 While $ListNext(tMessageTypes,tPtr,tElem) {

				Set tTypeStore=..TypeStore(tElem)

				Set tKey="" While 1 {
					Set tKey=tTypeStore.Next(tKey) If tKey="" {Quit}
					$$$THROWONERROR(tSC,tFile.WriteLine(tKey))
				}
			}
								
			Do tFile.Close()
		}
	}
}

Method LoadingReport(ByRef pLoaded) [ Private ]
{
	// list non-file messages
	If $Data(pLoaded(0)) {
		Set tOriginFileList=""
		Set tMessageCount=0
		Set tOriginFile="" While 1 {
			Set tOriginFile=$Order(pLoaded(0,tOriginFile),+1,tData) If tOriginFile="" {Quit}
			Set tOriginFileList=tOriginFileList_$ListBuild(tOriginFile)
			Set tMessageCount=tMessageCount+$List(tData,2)
		}
		
		Do ..Logger.OutputToLog("Loaded "_tMessageCount_" messages: "_$ListToString(tOriginFileList," .. "))		
	}
	
	// list file messages
	Set tOriginFolder="" While 1 {
		Set tOriginFolder=$Order(pLoaded(1,tOriginFolder)) If tOriginFolder="" {Quit}
		Set tFirstOriginFile=$Order(pLoaded(1,tOriginFolder,""))
		
		// if there's more than one file for this folder ..
		If $Order(pLoaded(1,tOriginFolder,tFirstOriginFile))'="" {
			Set tMessageCount=0
			Set tOriginFile="" While 1 {
				Set tOriginFile=$Order(pLoaded(1,tOriginFolder,tOriginFile),+1,tData) If tOriginFile="" {Quit}
				Set tMessageCount=tMessageCount+$List(tData,2)
			}
			Do ..Logger.OutputToLog("Loaded "_tMessageCount_" messages from "_tOriginFolder)
		}
		Else {
			Set tMessageCount=$List(pLoaded(1,tOriginFolder,tFirstOriginFile),2)
			Set tOrigin=##class(%File).NormalizeFilename(tFirstOriginFile,tOriginFolder)
			Do ..Logger.OutputToLog("Loaded "_tMessageCount_" messages from "_tOrigin)
		}
	}
}

}
