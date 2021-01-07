/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Output

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.RunMessageProcessor Extends MessageProcessor
{

Property RigSchemas As RigSchemaCollection [ Private ];

Property Logger As Logger [ Private ];

Property Version As %String [ Private ];

Property Quiet As %Boolean [ Private ];

Property SuccessCount As %Integer [ Private ];

Property FailureCount As %Integer [ Private ];

Method %OnNew(pRigSchemas As RigSchemaCollection, pConfig As Config, pVersion As %String, pLogger As Logger, pQuiet As %Boolean) As %Status
{
	Set ..RigSchemas=pRigSchemas
	Set ..Config=pConfig
	Set ..Version=pVersion
	Set ..Logger=pLogger
	Set ..FolderType=##class(FolderType).%New()
	Set ..Quiet=pQuiet
	Set ..SuccessCount=0
	Set ..FailureCount=0
	
	Quit $$$OK
}

Method GetMessageParentFolders(pReportIndex As %Integer) As %List [ CodeMode = expression ]
{
""
}

Method MergeADT(pMessagesOrigin As %String) As %Boolean [ CodeMode = expression ]
{
..Config.IsFlagSet("MERGEADTMESSAGES")
}

Method NewReport(pMessagesOrigin As %String, pMessageType As %String) As %Integer
{
	$$$LOGOUTPUT(..Logger,$ListBuild("","-----",pMessagesOrigin,"Message type: "_$Select(pMessageType="":"(not given)",1:pMessageType)))
	Quit 1
}

Method ProcessMessage(pReportIndex As %Integer, pMessageType As %String, pMessageSegmentTypes As %List, pMessageCount As %Integer, ByRef pFullMessageArray, pPathIfUnique As %String)
{
	Set tKey="" While 1 {
		Set tKey=..RigSchemas.NextByName(tKey) If tKey="" {Quit}
		If ..RunImplMatch(tKey,pMessageSegmentTypes,..Quiet,.failureoutcome) {
			Set ..SuccessCount=..SuccessCount+1
		}
		Else {
			Set ..FailureCount=..FailureCount+1
		}
		Do showFailure(.failureoutcome)
	}
	
	Quit
	
showFailure(f)
	If f'="" {
		$$$LOGOUTPUT1(..Logger,"- "_f.Show(1))
	}
	Quit
}

Method GetVersion() As %String [ CodeMode = expression ]
{
..Version
}

/// Return $LB(SUCCESSCOUNT,FAILURECOUNT)
Method Results() As %List [ CodeMode = expression ]
{
$ListBuild(..SuccessCount,..FailureCount)
}

Method RunImplMatch(RunSchemaName As %String, MessageTypes As %List, Quiet As %Boolean = 0, Output FailureOutcome) As %Boolean [ CodeMode = expression, Private ]
{
$List(..RunImplMatchRaw(RunSchemaName,MessageTypes,Quiet,.FailureOutcome))
}

Method RunImplMatchRaw(RunSchemaName As %String, MessageTypes As %List, Quiet As %Boolean = 0, Output FailureOutcome) As %List [ CodeMode = expression, Private ]
{
##class(Common).RunImplMatch(MessageTypes,..RigSchemas.GetByName(RunSchemaName),..Config,Quiet,.FailureOutcome)
}

}
