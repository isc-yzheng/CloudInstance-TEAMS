/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// BusinessOperation class for writing HL7 messages to a file.  Supports individual or batched messages.
Class EnsLib.HL7.Operation.FileOperation Extends EnsLib.HL7.Operation.BatchStandard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

/* override default value */
/// Name of file to output the document(s) to. May include timestamp specifiers. The %f specifier if present will be 
/// replaced with the name of the document's original source stream (stripped of characters illegal in filenames).<p/>
/// See the method Ens.Util.File.CreateTimestamp() for documentation of timestamping options.
Property Filename As %String(MAXLEN = 1000, MINLEN = 1) [ InitialExpression = "%f_%Q%!+(_a)", Required ];

Method outputDocument(pFilename As %String, pDocument As EnsLib.HL7.Message, pSeparators As %String, pDoFraming As %Integer) As %Status
{
	Set tSC = ..Adapter.open(pFilename)  Quit:$$$ISERR(tSC) tSC
	Set $ZT="Trap"
	Use ..Adapter.Device  Set tSC=..OutputFramedToDevice(pDocument,pSeparators,"",0,..IOLogEntry,.pDoFraming)  Use ..Adapter.OldIO
	Set $ZT=""
Exit
	Set tSC1=..Adapter.close()
	Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method outputSegment(pFilename As %String, pSegObj As EnsLib.HL7.Segment, pSeparators As %String, pCount As %Integer) As %Status
{
	If $Case(pSegObj.Name,"FTS":1,"BTS":1,:0) Set pSegObj=pSegObj.%ConstructClone()  Do pSegObj.SetValueAt(pCount,1)
	Quit ..Adapter.PutStream(pFilename,pSegObj,pSeparators)
}

}
