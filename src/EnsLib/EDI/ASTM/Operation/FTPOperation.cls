/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.EDI.ASTM.Operation.FTPOperation Extends EnsLib.EDI.ASTM.Operation.Standard [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// Name of file to output the document(s) to. May include timestamp specifiers. The %f specifier if present will be
/// replaced with the name of the document's original source stream. (stripped of characters illegal in filenames).<p>
/// See the method Ens.Util.File.CreateTimestamp() for documentation of timestamping options.
Property Filename As %String(MAXLEN = 1000, MINLEN = 1) [ InitialExpression = "%f_%Q", Required ];

Parameter SETTINGS As %String = "Filename:Basic";

Parameter ADAPTER = "EnsLib.FTP.OutboundAdapter";

Property %TempStream As %IO.FileStream;

Method OnInit() As %Status
{
	#dim tSC As %Status = $$$OK

	Set ..%TempStream=..%TempStreamNewObject()
 	Do ..%TempStream.Open("","RWN",,"",.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ##super()
}

/// This method is for File and FTP Operations: per-message output with no reply. TCP and HTTP Operations
/// can receive reply messages.
Method OnMessage(pRequest As EnsLib.EDI.ASTM.Document, Output pResponse As EnsLib.EDI.ASTM.Document) As %Status
{
	#dim tSeparators, tFilename As %String
	#dim tSC As %Status = $$$OK

	Set tSeparators=$S($L(..Separators)>=4:..Separators, 1:pRequest.Separators)
	Do ..%TempStream.Clear()
	Set tSC=pRequest.OutputToIOStream(..%TempStream,tSeparators)  Quit:$$$ISERR(tSC) tSC

	Set tFilename=..Adapter.CreateTimestamp(##class(%File).GetFilename($P(pRequest.Source,$C(13))),..Filename)
	$$$sysTRACE("About to "_$S(..Adapter.Overwrite:"Store",1:"Append")_" ASTM document "_pRequest.%Id()_" / "_pRequest_" by FTP at "_..Adapter.fixSvrPath(..Adapter.%LastSetFilePath,1)_tFilename)
	Set tSC=..Adapter.PutStream(tFilename,..%TempStream)

	$$$sysTRACE("After writing ASTM document "_pRequest_"/"_pRequest.%Id()_" by FTP")
	Quit tSC
}

}
