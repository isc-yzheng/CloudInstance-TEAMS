/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Service.FTPService Extends EnsLib.HL7.Service.Standard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.FTP.InboundAdapter";

/// ConfigID of the operation or process to which response (e.g. ACK) messages should be forwarded.
Property AckTargetConfigNames As %String;

Parameter SETTINGS = "AckTargetConfigNames::selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},Framing,OverrideSegmentTerminator";

/* (override default value for Setting inherited from base class) */
/// Control of ACK handling; options:
/// - Never : Do not send back any ACK
/// - Immediate : Send back (commit) ACK reply message immediately upon receipt of the inbound message
/// - Application : If message passes validation, wait for ACK from target config item and forward it back when it arrives
/// - MSH-determined : Send back ACK reply messages as requested in the MSH header of the incoming message
Property AckMode As %String(DISPLAYLIST = ",Never,Immediate,Application,MSH-determined", VALUELIST = ",Never,Immed,App,Msh") [ InitialExpression = "Never", Required ];

/// End-Segment marker character(s)
Property SegTerminator As %String [ InitialExpression = {$C(13)} ];

/// Comma separated list of control characters to use for the segment terminators
/// instead of the default standard Carriage Return (Ascii 13 character).<br>
/// Can be Decimal or Hex if have preceding 'x'<br>
/// For example 10 or x0A to specify the use of the Line Feed character as the segment terminator.<br>
Property OverrideSegmentTerminator As %String;

Parameter ReadTimeout As %Numeric = 1;

Method OnInit() As %Status
{
	Set tSC=##super()  Quit:$$$ISERR(tSC) tSC
	Set (..%Parser.StartTimeout,..%Parser.ReadTimeout)=..#ReadTimeout
	If $$$XOR(""=..AckTargetConfigNames,"Never"=..AckMode) {
		If ""=..AckTargetConfigNames { $$$LOGWARNING("No ACK Target Config Name configured for AckMode '"_..AckMode_"'") }
		Else { $$$LOGWARNING("ACK Target ConfigName(s) '"_..AckTargetConfigNames_"' configured for AckMode '"_..AckMode_"'") }
	}

	If ..OverrideSegmentTerminator '= "" {
		#dim tOverrideSegmentTerminator = ..AsciiOrHexAsChars(..OverrideSegmentTerminator)
		If tOverrideSegmentTerminator '= "" {
			Set ..SegTerminator = tOverrideSegmentTerminator
		}
	}

	Quit $$$OK
}

Method OnProcessInput(pFTPStream As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	$$$sysTRACE("Got FTP Stream "_pFTPStream_"("_pFTPStream.Size_") for file '"_pFTPStream.Attributes("Filename")_"'")
	Set tIOStream=##Class(%IO.MetaCharacterStream).%New(pFTPStream)  Quit:'$IsObject(tIOStream) %objlasterror
	Set tIOStream.Name=pFTPStream.Attributes("Filename")_$C(13,10)_"via FTP "_..Adapter.FTPServer_":"_..Adapter.FTPPort_" path '"_..Adapter.FilePath_"'"
	Set:$ZCVT(..Adapter.Charset,"l")="binary" pFTPStream.LineTerminator = $C(13) // Default delimiter for method ReadLine() of the stream class, when in binary mode
	
	Do ..%Parser.Reset()
	While 'tIOStream.AtEnd { ; Loop over docs in the file
		Set tSC1=..%Parser.ParseFramedIOStream(tIOStream,,1)
		Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
		Quit:$$$StatusEquals(tSC1,$$$EnsErrGeneral) // !!! quit on fatal errors only
	}
	Do ..%Parser.Reset() ; release the file
	Quit tSC
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	If ""=..AckTargetConfigNames {
		$$$sysTRACE("ACK "_pReplyDocument_$S($IsObject(pReplyDocument):"/"_pReplyDocument.%Id(),1:"")_" not sent because no ACK Target Config Name is configured")
		Quit $$$OK
	}
	Set pReplyDocument.IsMutable=0
	Set tSC=$$$OK  For iTarget=1:1:$L(..AckTargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..AckTargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
		Set tSC1=..SendRequestAsync(tOneTarget,pReplyDocument) Quit:$$$ISERR(tSC)
		Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
	}
	Quit tSC
}

/// Return the segment terminator string that the Parser and the OutputTo...() methods will use.
Method GetSegmentTerminator() As %String
{
	Quit ..SegTerminator
}

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("AckTargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}
