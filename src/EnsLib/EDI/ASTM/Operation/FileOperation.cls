/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.EDI.ASTM.Operation.FileOperation Extends EnsLib.EDI.ASTM.Operation.Standard [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// Name of file to output the document(s) to. May include timestamp specifiers. The %f specifier if present will be 
/// replaced with the name of the document's original source stream. (stripped of characters illegal in filenames).<p>
/// See the method Ens.Util.File.CreateTimestamp() for documentation of timestamping options.
Property Filename As %String(MAXLEN = 1000, MINLEN = 1) [ InitialExpression = "%f_%Q%!+(_a)", Required ];

Parameter SETTINGS As %String = "Filename:Basic";

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

/// This method is for File and FTP Operations: per-message output with no reply. TCP and HTTP Operations
/// can receive reply messages.
Method OnMessage(pRequest As EnsLib.EDI.ASTM.Document, Output pResponse As EnsLib.EDI.ASTM.Document) As %Status
{
	#; Output the main Document
	Set tSeparators=$S($L(..Separators)>=4:..Separators, 1:pRequest.Separators)
	Set tFilename=..Adapter.CreateFilename(##class(%File).GetFilename($P(pRequest.Source,$C(13))),..Filename)
	Set tSC=..Adapter.PutStream(tFilename,pRequest,tSeparators)  Quit:$$$ISERR(tSC) tSC
	$$$sysTRACE("After "_$S(..Adapter.Overwrite:"storing",1:"appending")_" ASTM document "_pRequest_"/"_pRequest.%Id()_" to file "_tFilename)
	Quit tSC
}

}
