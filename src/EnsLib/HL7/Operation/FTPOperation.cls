/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Operation.FTPOperation Extends EnsLib.HL7.Operation.BatchStandard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.FTP.OutboundAdapter";

Property %TempStream As %IO.FileStream;

Method OnInit() As %Status
{
	Set ..%TempStream=..%TempStreamNewObject()
 	Do ..%TempStream.Open("","RWN",,"",.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ##super()
}

Method outputDocument(pFilename As %String, pDocument As EnsLib.HL7.Message, pSeparators As %String, pDoFraming As %Integer) As %Status
{
#define MapCtlChars(%s)	$TR(%s,$C(1,2,9,10,11,13,28),"12tlsre")

	Do ..%TempStream.Clear()
	Set tSC=..OutputFramedToIOStream(..%TempStream,pDocument,pSeparators,"",0,..IOLogEntry,.pDoFraming)
	
	$$$sysTRACE("About to "_$S(..Adapter.Overwrite:"Store",1:"Append")_" HL7 message "_pDocument.%Id()_" / "_pDocument_" by FTP at "_..Adapter.fixSvrPath(..Adapter.%LastSetFilePath,1)_pFilename_" using framing "_$$$MapCtlChars(..%outFraming))
	Quit ..Adapter.PutStream(pFilename,..%TempStream)
}

Method outputSegment(pFilename As %String, pSegObj As EnsLib.HL7.Segment, pSeparators As %String, pCount As %Integer) As %Status
{
	If $Case(pSegObj.Name,"FTS":1,"BTS":1,:0) Set pSegObj=pSegObj.%ConstructClone()  Do pSegObj.SetValueAt(pCount,1)
	Do ..%TempStream.Clear()
	Set tSC=pSegObj.OutputToIOStream(..%TempStream,pSeparators,"")  Quit:$$$ISERR(tSC) tSC
	Quit ..Adapter.PutStream(pFilename,..%TempStream)
}

}
