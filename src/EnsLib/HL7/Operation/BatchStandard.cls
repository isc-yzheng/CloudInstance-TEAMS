/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Operation.BatchStandard Extends EnsLib.HL7.Operation.Standard [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// Name of file to output the document(s) to. May include timestamp specifiers. The %f specifier, if present, will be 
/// replaced with the name of the document's original source stream (stripped of characters that are illegal in filenames). <p/>
/// See method Ens.Util.File.CreateTimestamp() for documentation of timestamp options.
Property Filename As %String(MAXLEN = 1000, MINLEN = 1) [ InitialExpression = "%f_%Q", Required ];

/// When writing a message that has a batch parent, output the batch headers first, and follow up with
///  the batch trailers when triggered by the final batch parent header message or by a file name change. <br/>
/// All child messages of a batch parent message will be written out unless already written previously while AutoBatchParentSegs=true.
Property AutoBatchParentSegs As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS As %String = "Filename:Basic,AutoBatchParentSegs";

/* (override the InitialExpression inherited for this Setting from the base class) */
/// HL7 message outbound framing protocol.  The options are: <br/><ul>
/// <li>None: No framing - Each line that begins with 'MSH' is the start of a new message. </li>
/// <li>MLLP: Minimal Lower Level Protocol - Frame each HL7 message with ASCII code 11 prefix and ASCII code 28,13 suffix. </li>
/// <li>MLLPN/M: Minimal Lower Level Protocol - Frame each HL7 message with ASCII code N prefix, and ASCII code M suffix followed by an additional ASCII code 13. </li>
/// <li>AsciiLF: Frame messages with ASCII code 10 (Line Feed) separating each message from the subsequent one. </li>
/// <li>AsciiCRLF: Same as AsciiLF. </li>
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
Property Framing As %String(DISPLAYLIST = ",None,MLLP,MLLP11/28,AsciiLF,AsciiCR,AsciiCRLF,Ascii11,Ascii11/28,LLP,MsgEnvelope,MLLPMsgEnvelope") [ InitialExpression = "AsciiLF" ];

Method OnInit() As %Status
{
	#; Override default initialization
	Set ..%outFraming=##class(EnsLib.HL7.Parser).applyFraming(..Framing,"x"_$C(10))
	Quit ##super()
}

/// This method is for File and FTP Operations: per-message batch output with no reply. TCP and HTTP Operations
/// receive reply messages and only support entire batch output.
Method OnMessage(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
	#def1arg Files(%k) $$$EnsStaticAppData(..%ConfigName,"Files",%k)
	#def1arg Count(%k) $$$EnsStaticAppData(..%ConfigName,"Count",%k)
	#def1arg Parents(%k) $$$EnsStaticAppData(..%ConfigName,"Parents",%k)
	#define MapCtlChars(%s)	$TR(%s,$C(1,2,9,10,11,13,28),"12tlsre")

	Set pResponse=$$$NULLOREF
	Set tSC=..validateAndIndex(pRequest)  Quit:$$$ISERR(tSC) tSC

	Set tParentRef=pRequest.ParentId, tId=pRequest.%Id()
	Set tDoParent=tParentRef&&..AutoBatchParentSegs&&'..Adapter.Overwrite
	If 'tDoParent {
		Set tKey=tId, tOldFilename=$G($$$Files(tKey))
		If ""'=tOldFilename { ; we've already done output for this batch; finish it out now.
			Set tSC=..outputHeaders(tKey,$G($$$Parents(tKey)),"")
			Kill $$$Files(tKey),$$$Parents(tKey),$$$Count(tKey)
			Quit tSC
		}
		Set tFilename=..Adapter.CreateFilename(##class(%File).GetFilename($P(pRequest.Source,$C(13))),..Filename)
		Set tSeparators=$S(""'=..Separators:..Separators, 1:pRequest.Separators)
	} Else {
		#; Get the filename and output appropriate header and trailer segments
		Set tParentIds=pRequest.ParentIds, tNumParents=$LL(tParentIds)
		Set tKey=$P($LI(tParentIds,tNumParents),":")
		Set tTopParent=##class(EnsLib.HL7.Message).%OpenId(tKey)

		Set tFilename=..Adapter.CreateFilename(##class(%File).GetFilename($P(tTopParent.Source,$C(13))),..Filename)
		Set tOldFilename=$G($$$Files(tKey))

		If tOldFilename'=tFilename {
			#; New output; finish previous Batch if any
			If ""'=tOldFilename {
				$$$catTRACE("file","Finishing old file "_tOldFilename_" using key "_tKey_", parents '"_$G($$$Parents(tKey))_"'")
				Set tSC=..outputHeaders(tKey,$G($$$Parents(tKey)),"")
				If $$$ISERR(tSC) $$$LOGSTATUS(tSC)  Set tSC=$$$OK ; not fatal; start the new one anyway
				Kill $$$Files(tKey),$$$Parents(tKey),$$$Count(tKey)
			}
			#; Output starting Batch headers up to the current segment
			Quit:'pRequest.SegCount tSC
			$$$catTRACE("file","Starting "_tFilename_" using key "_tKey_", parents "_tParentIds)
			Set tSeparators=$S(""'=..Separators:..Separators, 1:tTopParent.Separators)
			Set $$$Files(tKey)=tFilename, $$$Files(tKey,"seps")=tSeparators
			Set tSC=..outputHeaders(tKey,"",tParentIds)  Quit:$$$ISERR(tSC) tSC
		} ElseIf tParentIds'=$G($$$Parents(tKey)) {
			#; Output intermediate Batch trailers/headers

			#; Ignore any batch parent whose children we already have done output for, or empty message
			Set tLastCountRefHavingMyId=$O($$$Count(tKey,tId+1_":"),-1)
			Set tChildrenDone=$S(+tId'=+tLastCountRefHavingMyId:0, 1:$G($$$Count(tKey,tLastCountRefHavingMyId)))

			$$$catTRACE("file","Continuing file "_tFilename_" using key "_tKey_", old parents '"_$G($$$Parents(tKey))_"', parents '"_tParentIds_"'")
			Set tSC=..outputHeaders(tKey,$G($$$Parents(tKey)),tParentIds)  Quit:$$$ISERR(tSC) tSC
			If ""=tParentIds {
				Kill $$$Files(tKey),$$$Parents(tKey),$$$Count(tKey)
				Quit tSC
			}
			If +tChildrenDone||'pRequest.SegCount {
				Set $$$Parents(tKey)=tParentIds
				Quit tSC
			}
		}
		Set tSeparators=$$$Files(tKey,"seps")
	}	
	#; Output the main Document
	Set tSC=..outputDocument(tFilename,pRequest,tSeparators,'tDoParent)  Quit:$$$ISERR(tSC) tSC
	If 'tDoParent {
		$$$sysTRACE("After writing message "_pRequest_"/"_tId_" to file "_tFilename_" using framing "_$$$MapCtlChars(..%outFraming))
	} Else {
		Set $$$Parents(tKey)=tParentIds
		Set tCount=$S($D($$$Count(tKey,tParentRef),tCount):tCount+1, 1:1), $$$Count(tKey,tParentRef)=tCount
		$$$sysTRACE("After writing message "_tCount_" at level "_tNumParents_" "_pRequest_"/"_tId_" to file "_tFilename_" using key "_tKey_" and framing "_$$$MapCtlChars(..%outFraming))
	}
	Quit tSC
}

Method outputHeaders(pKey As %String, pOldParents As %String, pParents As %String) As %Status
{
	#def1arg Files(%k) $$$EnsStaticAppData(..%ConfigName,"Files",%k)
	#def1arg Count(%k) $$$EnsStaticAppData(..%ConfigName,"Count",%k)

	#; Output group header(s) - walk up the parents ladder
	Set tNumOld=$LL(pOldParents), tNum=$LL(pParents)
	
	#; Find first non-matching parent level
	If tNum {
		For i=1:1:tNum { Set tOldParentRef=$LG(pOldParents,tNumOld+1-i), tParentRef=$LI(pParents,tNum+1-i)  Quit:tOldParentRef'=tParentRef }
	} Else {
		Quit:'tNumOld $$$OK
		Set i=1, tParentRef="", tOldParentRef=$LG(pOldParents,tNumOld)
	}
	Set tOldId=$P(tOldParentRef,":"), tNewId=$P(tParentRef,":"), tNewSeg=$P(tParentRef,":",2)

	#; Output trailer(s) for previous group
	Set tSC=$$$OK, tParentRef=""
	For j=1:1:tNumOld+1-i { Set tChild=tParentRef, tParentRef=$LG(pOldParents,j)
		Set tId=$P(tParentRef,":"), tSeg=$P(tParentRef,":",2), tCount=$G($$$Count(pKey,tParentRef))
		Set:""'=tId tParent=##class(EnsLib.HL7.Message).%OpenId(tId)
		Set tEndSeg=$S(""=tId||((tId=tNewId)&&+tNewSeg):tNewSeg-1, 1:tParent.SegCount) ; same level, different DocsRef segments
		For s=tSeg+1:1:tEndSeg {
			Set tSC=..outputSegment($$$Files(pKey),tParent.GetSegmentAt(s),$$$Files(pKey,"seps"),tCount)  Quit:$$$ISERR(tSC)
		}
		Kill:""'=tChild $$$Count(pKey,tChild) ; kill count now that we've written the terminal segment(s)
	}
	#; If needed, output framing prefix or suffix
	Set:'tNumOld||'tNum tTopParent=##class(EnsLib.HL7.Message).%OpenId(pKey)
	If 'tNumOld { Set tSC=..outputDocument($$$Files(pKey),tTopParent,$$$Files(pKey,"seps"),-2)  Quit:$$$ISERR(tSC) tSC }
	If 'tNum { Set tSC=..outputDocument($$$Files(pKey),tTopParent,$$$Files(pKey,"seps"),2)  Quit:$$$ISERR(tSC) tSC }

	#; Output header(s) for new group
	Set tParentRef=$S(i<2:"",1:$LG(pParents,tNum+2-i))
	For j=tNum+1-i:-1:1 { Set tGrampa=tParentRef, tParentRef=$LI(pParents,j)
		#; record the count of intermediate parents too
		Set:""'=tGrampa $$$Count(pKey,tGrampa)=$G($$$Count(pKey,tGrampa))+1 ; increment count for this parent level at grandparent node
		Set tId=$P(tParentRef,":"), tSeg=$P(tParentRef,":",2)
		Continue:tId=tOldId ; we already did these in the trailers loop
		Set tParent=##class(EnsLib.HL7.Message).%OpenId(tId)
		Set:'tSeg tSeg=tParent.SegCount
		For s=1:1:tSeg-1 {
			Set tSC=..outputSegment($$$Files(pKey),tParent.GetSegmentAt(s),$$$Files(pKey,"seps"),"")  Quit:$$$ISERR(tSC)
		}
	}
	Quit tSC
}

}
