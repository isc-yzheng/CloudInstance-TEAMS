/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsLib.HL7.Util.IOFraming [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// HL7 message outbound framing protocol.  The options are: <br/><ul>
/// <li>None: No framing - Each line that begins with 'MSH' is the start of a new message. </li>
/// <li>MLLP: Minimal Lower Level Protocol - Frame each HL7 message with ASCII code 11 prefix and ASCII code 28,13 suffix. </li>
/// <li>MLLPN/M: Minimal Lower Level Protocol - Frame each HL7 message with ASCII code N prefix, and ASCII code M suffix followed by an additional ASCII code 13. </li>
/// <li>AsciiLF: Frame messages with ASCII code 10 (Line Feed) separating each message from the subsequent one. </li>
/// <li>AsciiCR: Frame messages with an extra ASCII code 13 (Carriage Return) separating each message from the subsequent one. </li>
/// <li>AsciiM: Frame messages with ASCII code M suffix character(s) separating each message from the subsequent one. </li>
/// <li>AsciiN/M: Frame messages with ASCII code N prefix character(s) before each message and ASCII code M suffix character(s), but no trailing ASCII code 13 as in MLLPN/M. </li>
/// <li>LLP: Lower Level Protocol - (Obsolete) Frame each HL7 message in a redundant checksum block. </li>
/// <li>MsgEnvelope: Use the message's Envelope property verbatim if it is present. The string &lt;!--HL72MSG--&gt; if present in the Envelope will be replaced with the 
/// message content. Otherwise the message will simply follow the Envelope text. </li>
/// <li>MLLPMsgEnvelope: Same as MsgEnvelope, but with MLLP prefix and suffix also around the message inside the Envelope. </li></ul><p/>
/// Notes: <br/>
/// - ASCII code N is a sequence of one or more characters represented by their ASCII code, separated by comma in case of more than one character. <br/>
/// - All ASCII codes should be given in decimal. <br/>
/// - ASCII code 120 (character 'x') is not allowed as a framing character. <br/>
/// - If an asterisk (*) is appended to the framing specification, 'Flexible' framing will be used in parsing received acknowledgement response messages. Otherwise the response messages 
/// will be expected with the same kind of framing as that specified here for outbound messages.
Property Framing As %String(DISPLAYLIST = ",None,MLLP,MLLP11/28,AsciiLF,AsciiCR,Ascii11,Ascii11/28,LLP,MsgEnvelope,MLLPMsgEnvelope") [ InitialExpression = "MLLP" ];

/// Default Character Encoding to use when reading or writing HL7 messages. <p/>
/// If MSH field 18 (Character Set) is empty, this encoding will be used. Choices you can use for this setting include: <br/><ul>
/// <li>Native: Use the default character encoding of the installed locale of the IRIS server. </li>
/// <li>latin1: The ISO Latin1 8-bit encoding. This is the default. </li>
/// <li>ISO-8859-1: The ISO Latin1 8-bit encoding. </li>
/// <li>UTF-8: The Unicode 8-bit encoding. </li>
/// <li>Unicode: The Unicode 16-bit encoding  (Little-Endian). </li>
/// <li>UnicodeBig:  The Unicode 16-bit encoding (Big-Endian). </li>
/// <li>Any other NLS definitions installed on this IRIS server. </li>
/// <li>@&lt;ttable&gt;: &lt;ttable&gt; means a raw InterSystems character translation table name. A prefix of '@' means to use the named table. </li></ul>
/// Putting ! before the encoding name will force the use of the named encoding and will ignore any value found in MSH:18. 
Property DefCharEncoding As %String(MAXLEN = 20) [ InitialExpression = "latin1" ];

Parameter SETTINGS As %String = "Framing:Connection:selector?context={Ens.ContextSearch/getDisplayList?host=@currHostId&prop=Framing}";

/// Framing to use on output if input framing is "Flexible"
Property %outFraming As %String [ InitialExpression = "uninitialized", Internal ];

Method OutputFramedToDevice(pMsg As EnsLib.HL7.Message, pSeparators As %String, pSequenceNumber As %String, pInbound As %Boolean = 0, ByRef pIOLogEntry As Ens.Util.IOLog = {$$$NULLOREF}, pDoFraming As %Integer) As %Status
{
	Set tDeviceStream=##class(%IO.DeviceStream).AttachNew(,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ..OutputFramedToIOStream(tDeviceStream, .pMsg, .pSeparators, .pSequenceNumber, .pInbound, .pIOLogEntry, .pDoFraming)
}

/// Write an HL7 Message to the given IO Stream. <p/>
/// Returned %Status codes are only logged if they are error exceptions. <p/>
/// Possible values for <variable>pDoFraming</variable> are: <br/><ul>
/// <li>0 = No framing. </li>
/// <li>1 = Full framing (default). </li>
/// <li>-1 = Prefix only. </li>
/// <li>2 = Suffix only. </li></ul>
Method OutputFramedToIOStream(pIOStream As %IO.I.CharacterStream, pMsg As EnsLib.HL7.Message, pSeparators As %String, pSequenceNumber As %String, pInbound As %Boolean = 1, ByRef pIOLogEntry As Ens.Util.IOLog = {$$$NULLOREF}, pDoFraming As %Integer = 1) As %Status
{
	#define MapCtlChars(%s)	$TR(%s,$C(1,2,9,10,11,13,28),"12tlsre")

	If "uninitialized"=..%outFraming {
		Set ..%outFraming=##class(EnsLib.HL7.Parser).applyFraming(..Framing,$C($$$HL7DefStartBlockAscii)_"x"_$C($$$HL7DefEndBlockAscii,$$$HL7DefEndDataCRAscii))
	}
	Set tPrefix=$P(..%outFraming,"xx"), tOutFraming=$E(..%outFraming,$L(tPrefix)+3,$L(..%outFraming)), tSuffix=$P(tPrefix,"x",2), tPrefix=$P(tPrefix,"x")
	If $IsObject(pMsg)&&pMsg.%Extends("%Persistent") {
		If $IsObject(pIOLogEntry)&&pIOLogEntry.%Extends("Ens.Util.IOLogObject") {
			Set pIOLogEntry.OutObject=pMsg  Do:""=pMsg.%Id() pMsg.%Save()
		}
		Set tMsgId=pMsg.%Id()
	} Else {
		Set tMsgId=""
	}
	Set tMSHEncoding=$S("!"=$E(..DefCharEncoding):$E(..DefCharEncoding,2,*), '$IsObject(pMsg):"", 1:$TR($ZStrip(pMsg.GetValueAt("1:18"),"<>CW"),$$$RSSEP($S(""=$G(pSeparators):pMsg.Separators,1:pSeparators))))  Set:""=tMSHEncoding tMSHEncoding=..DefCharEncoding
	If ""=tMSHEncoding || (""=##class(%IO.I.TranslationDevice).GetCharEncodingTable(tMSHEncoding)) {
		If ""'=tMSHEncoding $$$LOGWARNING("No translation table found for specified character encoding '"_tMSHEncoding_"'; Using 'ISO-8859-1' ('Latin1')")
		Set tMSHEncoding="ISO-8859-1"
	}
	Set tMsgInfo=$S('$IsObject(pMsg):"'"_pMsg_"'", 1:pMsg_" / "_tMsgId_" with separators='"_$S(""=$G(pSeparators):pMsg.Separators,1:pSeparators)_"' and sequence#='"_$G(pSequenceNumber)_"'")_" to "_pIOStream.Name_" using framing "_$$$MapCtlChars(..%outFraming)_$S(""=(tPrefix_tSuffix):"", 1:" (prefix '"_$$$MapCtlChars(tPrefix)_"' and suffix '"_$$$MapCtlChars(tSuffix)_"')"_" using encoding "_tMSHEncoding)
	$$$sysTRACE("Writing "_$Case(+pDoFraming,0:"bare message",1:"message",2:"suffix",:"prefix")_" "_tMsgInfo)
	Set pIOStream.CharEncoding=tMSHEncoding
	Do {
		Set tFlush=(pDoFraming<0), tSC=$$$OK
		If "<->"=tOutFraming&&$IsObject(pMsg)&&pDoFraming&&(pDoFraming'=2) {
			Do pIOStream.Write($P(pMsg.Envelope,"<!--HL72MSG-->"),tFlush&&'$L(tPrefix),.tSC)  Quit:$$$ISERR(tSC)
			Set tCloseFrame=$P(pMsg.Envelope,"<!--HL72MSG-->",2)
		} Else { Set tCloseFrame="" }
		If $L(tPrefix)&&pDoFraming&&(pDoFraming'=2) Do pIOStream.Write(tPrefix,tFlush,.tSC)  Quit:$$$ISERR(tSC)
		If "LLP"=tOutFraming && (pDoFraming>0) {
			$$$ASSERT($C(11)_"D21"_$C(13)=tPrefix && ($C(28,13)_"L"=tSuffix))
			Set tCRC=$ZCRC(tPrefix,1)
			If $IsObject(pMsg) { Set tLen=pMsg.GetLengthCRC($L(tPrefix),.tCRC,.pSeparators,.pSequenceNumber,tMSHEncoding) }
			Else { Set tOut=$ZCVT(pMsg,"O",##class(%IO.I.TranslationDevice).GetCharEncodingTable(tMSHEncoding)), tLen=$$$NUM($L(tOut),5), tCRC=$$$NUM($ZCRC(tOut,1,tCRC),3) }
			Set tSuffix=tLen_tCRC_$C(28,13)
		}
		If $Case(pDoFraming, 0:1, 1:1, :0) {
			Set tFlush='pDoFraming||((""=tSuffix)&&(""=tCloseFrame))
			If '$IsObject(pMsg) {
				Do pIOStream.Write(pMsg,tFlush,.tSC)  Quit:$$$ISERR(tSC)
			} ElseIf "ACK_1_"=$E(pMsg.Envelope,1,$L("ACK_1_")) {
				Do pIOStream.Write($P(pMsg.Envelope,":",2),tFlush,.tSC)  Quit:$$$ISERR(tSC)
			} Else {
				Set tSC=pMsg.OutputToIOStream(pIOStream,.pSeparators,.pSequenceNumber,tFlush)  Quit:$$$ISERR(tSC)
			}
		}
		If pDoFraming>0 {
			If ""'=tSuffix { Do pIOStream.Write(tSuffix,(""=tCloseFrame),.tSC)  Quit:$$$ISERR(tSC) }
			If ""'=tCloseFrame { Do pIOStream.Write(tCloseFrame,1,.tSC)  Quit:$$$ISERR(tSC) }
		}
	} While 0
	If $IsObject(pIOLogEntry) {
		Set pIOLogEntry.Annotation = $S(""=pIOLogEntry.Annotation:"",1:pIOLogEntry.Annotation_" | ")_"Wrote message "_tMsgInfo
	}
	Quit tSC
}

/// Call this method after initializing or resetting the parser to force a particular output framing style different from the input framing style that is either specified or detected.
Method SetOutFraming(pFraming As %String)
{
	Set ..%outFraming=##class(EnsLib.HL7.Parser).applyFraming(pFraming)
}

}
