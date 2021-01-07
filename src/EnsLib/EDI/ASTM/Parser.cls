/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

/// This is the ASTM Interchange parser
Class EnsLib.EDI.ASTM.Parser Extends %RegisteredObject [ ClassType = "", ProcedureBlock, System = 4 ]
{

// Public Properties

/// Number of seconds to wait for the start of a document to be available on the input stream
Property StartTimeout As %Numeric(MINVAL = -1) [ InitialExpression = 5 ];

/// Number of seconds to wait for each read of document data inside a started document to be available on the input stream
Property ReadTimeout As %Numeric(MINVAL = -1) [ InitialExpression = 5 ];

Property Done As %Boolean [ Calculated, ReadOnly ];

// Private State Properties

Property %Stream As %IO.I.CharacterStream;

/// Count of Segments tallied during parse of a TransactionSet
Property %SegmentCount As %Integer;

Property %LineCount As %Integer;

Property %CharCount As %Integer;

/// The config provider
Property %ServiceInterface As EnsLib.EDI.ServiceInterface;

/// The current Document
Property %CurrentDocument As EnsLib.EDI.Document;

Method DoneGet() As %Boolean [ CodeMode = expression ]
{
('$IsObject(..%Stream)||..%Stream.AtEnd)
}

Method ReadSegment(pIOStream As %IO.I.CharacterStream, pTimeout As %Numeric, ByRef pFrameNum As %Integer, Output pLine As %String, Output pEOT As %Boolean, ByRef pSTX As %Boolean = 0) As %Status
{
	Set pLine="", pEOT=0
	While 'pIOStream.AtEnd {
		#; Read 1 char
		Set tTimeout=pTimeout, tFresh=pIOStream.Read(1,.tTimeout,.tSC)  Quit:$$$ISERR(tSC)
		If (pTimeout&&(tTimeout=pTimeout)) { Set tSC=$$$ERROR($$$EnsErrTCPReadTimeoutExpired,pTimeout,"ASTM <STX>","binary")  Quit }
		If $$$EOT=tFresh {
			Set pLine=pLine_tFresh, pEOT=1
			If $$$EOT'=pLine { $$$LOGWARNING("Got extra line with EOT at "_pIOStream.Name_" @Line "_..%LineCount_" : '"_$$$MapCtlChars(pLine)_"'") }
			Else { $$$catTRACE("parse","Got EOT at "_pIOStream.Name_" @Line "_..%LineCount) }
			Quit
		} ElseIf $$$STX'=tFresh && pSTX {
			If ..%ServiceInterface.%GetParameter("EOTOPTIONAL") {
				If "01234567"[tFresh {
					Set tFresh=$$$STX_tFresh ; in case we already got it in place of ENQ
				} ElseIf $$$ENQ=tFresh {
					Write $$$ACK,*-3
					Set pFrameNum=1
					$$$LOGWARNING("Unexpected ASTM ENQ when expecting STX character at "_pIOStream.Name_" @Line "_..%LineCount_" : '"_$$$MapCtlChars(pLine)_"'; ACK'ing and continuing to wait for segment data")
					Continue
				} Else {
					Set tSC=$$$ERROR($$$EnsErrGeneral,"Unexpected ASTM character in place of STX: Ascii "_$$$MapCtlChar(tFresh))
					Quit
				}
			} Else {
				Set tSC=$$$ERROR($$$EnsErrGeneral,"Unexpected ASTM character in place of frame STX: Ascii "_$$$MapCtlChar(tFresh))
				Quit
			}
		}
		Continue:$C(13,10)[tFresh

		#; Read rest of line
		Kill tZB  Set tTimeout=pTimeout, tFresh=tFresh_pIOStream.ReadLine(32767,.tTimeout,.tSC,.tZB)  Quit:$$$ISERR(tSC)
		If (pTimeout&&(tTimeout=pTimeout)) { Set tSC=$$$ERROR($$$EnsErrTCPTerminatedReadTimeoutExpired,pTimeout,"ASTM <LF>",$$$MapCtlChars(pLine_tFresh))  Quit }
		Set:""'=tFresh||(""'=tZB) ..%LineCount=..%LineCount+1, ..%CharCount=..%CharCount+$L(tFresh)+$L(tZB)

		If $$$STX=$E(tFresh) {
			Set pSTX=1
			Set:tZB=$C(13,10) tFresh=tFresh_$C(13), tZB=$C(10)
			$$$catTRACE("parse","Got STX frame line #"_..%LineCount_" '"_$$$MapCtlChars(tFresh)_"'")
			If (""'=tZB) { Write $$$ACK,*-3 }
			Else { Set tSC=$$$ERROR($$$EnsErrGeneral,"Received incomplete ASTM segment '"_$$$MapCtlChars(tFresh)_"' at "_pIOStream.Name_" @Line "_..%LineCount)  Quit }
			If pFrameNum'=$E(tFresh,2) { Set tSC=$$$ERROR($$$EnsErrGeneral,"Received bad ASTM sequence number; expected "_pFrameNum_", got '"_$$$MapCtlChars($E(tFresh,2))_"' at "_pIOStream.Name_" @Line "_..%LineCount)  Quit }
			Set pFrameNum=(pFrameNum+1)#8
			Set tEOD=$L(tFresh)-3, tLine=$E(tFresh,3,tEOD-1)
			If $E(tFresh,tEOD+1,tEOD+2)'=$$$CHKSUM($E(tFresh,2,tEOD)) { Set tSC=$$$ERROR($$$EnsErrGeneral,"Received bad ASTM checksum "_$E(tFresh,tEOD+1,tEOD+2)_"; expected "_$$$CHKSUM($E(tFresh,2,tEOD))_", got '"_$$$MapCtlChars(tFresh)_"' at "_pIOStream.Name_" @Line "_..%LineCount)  Quit }
			Set pLine=pLine_tLine
			If $$$ETX=$E(tFresh,tEOD) Set:$C(13)=$E(pLine,*) $E(pLine,$L(pLine))=""  Quit
			If $$$ETB'=$E(tFresh,tEOD) { Set tSC=$$$ERROR($$$EnsErrGeneral,"Received bad ASTM frame character; expected ETX(3) or ETB(23), got "_$$$MapCtlChar($E(tFresh,tEOD))_" in '"_$$$MapCtlChars(tFresh)_"' at "_pDocPos)  Quit }
			If $Case($E(tFresh,tEOD+3,*),$C(13):0,"":0,:1) { Set tSC=$$$ERROR($$$EnsErrGeneral,"Found extra junk at end of ASTM frame in '"_$$$MapCtlChars(tFresh)_"' at "_pIOStream.Name_" @Line "_..%LineCount)  Quit }
		} Else {
			Set pLine=..stripWhitespace(tFresh)
			$$$catTRACE("parse","Got raw line #"_..%LineCount_" '"_pLine_"'")
			Quit
		}
	}
	Set:""=pLine&&pIOStream.AtEnd pEOT=1
	Quit tSC
}

/// Parse a complete ASTM document from the stream
Method ParseIOStream(pIOStream As %IO.I.CharacterStream, Output pDocument As EnsLib.EDI.ASTM.Document, ByRef pFrameNum As %Integer = 1) As %Status
{
	$$$ASSERT($IsObject(pIOStream))
	Set (tSC,tSC1)=$$$OK, (pDocument,tDoc)=$$$NULLOREF, ..%Stream=pIOStream, tLine="", tEOT = 0
	Set tStartTimeout=..StartTimeout
	Set tSubIndex=0, tSegDone=1, tSTX=..%ServiceInterface.%GetParameter("EOTOPTIONAL") ; force on expected TCP framing for this special kind of parse
	Set:'tSTX pFrameNum=1 ; reset Frame counter unless in EOTOPTIONAL mode
	Do { ; While 0
		#; Process any preceding stuff in the stream
		Set tSC=..%ServiceInterface.OnPreDocument(pIOStream,.tLine)  Quit:$$$ISERR(tSC)||(""=tLine&&pIOStream.AtEnd)

		#; Read any blank lines to end, just to make sure there is an actual document beginning there
		While ""=tLine && 'pIOStream.AtEnd {
			Set tSC=..ReadSegment(pIOStream,tStartTimeout,.pFrameNum,.tLine,.tEOT,.tSTX)  Quit:$$$ISERR(tSC)||tEOT
			Set tStartTimeout=..ReadTimeout ; already started so go to read mode
		}
		Quit:(""=tLine)||(tEOT&&(tLine=$$$EOT))
		$$$catTRACE("parse","Got first Segment line '"_$$$MapCtlChars(tLine)_"'")
		Set ..%SegmentCount=0
		Set tFS=$E($ZStrip($E(tLine,1,1+$$$MAXSEGNAME),"*AN")) ; separator is first non-alphanumeric char
		Set (tSegName,tFirstSeg)=$S(""=tFS:"", 1:$P(tLine,tFS))
		Set tSeparators=tFS_$P(tLine,tFS,2)
        Set:$L(tSeparators)<4 tSeparators=tSeparators_$E($$$ASTMDefSeparators,$L(tSeparators)+1,4)

		#; Store the data for the first segment
		Set tIndex=$I($$$vaSegmentGbl), $$$vaSegmentGbl(tIndex)=tSeparators_tLine, $$$vaOpenSegmentPPG(tIndex) = 1, tLine="", ..%SegmentCount=..%SegmentCount+1
		
		#; Instantiate a document to hold the segment and any to follow
		Set tDocPos=pIOStream.Name_$S(..%LineCount<=2:"", 1:$C(13,10)_", @Line "_..%LineCount)
		Set tDoc=##class(EnsLib.EDI.ASTM.Document).%New($LB($LB(tIndex),tSeparators,tDocPos))  If '$IsObject(tDoc) Set tSC=%objlasterror Quit
		Set ..%CurrentDocument=tDoc, tSegNum=2 ; tSegNum is current segment of current document

		Set tTypeName=tDoc.Name  Set:""=tTypeName tTypeName="?"
		
		#; Notify the Service of the new document beginning
		Set tSC1=..%ServiceInterface.OnDocumentStart(tDoc,tDocPos,tSC)  Quit:$$$ISERR(tSC1) // Fatal Error
	  
		#; Parse the rest of the segments in the current document
		#;$$$catTRACE("parse","tDoc="_tDoc)
		Set (tEOF,iRef,iRefSegId)=0
		While $$$ISOK(tSC)&&(""'=tLine||'(pIOStream.AtEnd||tEOF)) { ; loop over segs in the doc
			If ""=tLine {
				#; Read a segment line buffer
				Set tSC=..ReadSegment(pIOStream,..ReadTimeout,.pFrameNum,.tLine,.tEOT,.tSTX)  Quit:$$$ISERR(tSC)||tEOT
			}
			$$$catTRACE("parse","Got next Segment line '"_$$$MapCtlChars(tLine)_"'")
			Set tPrevSeg=tSegName, tSegName=$P($E(tLine,1,$$$MAXSEGNAME),tFS)
			Set tDocPos=pIOStream.Name_$C(13,10)_", segment "_tSegNum_", @Line "_..%LineCount
			If tSegName'?1U {
				$$$LOGWARNING("Badly formed segment name '"_tSegName_"' in message "_tDoc.%Id()_" at "_tDocPos_" ("_$$$MapCtlChars(tLine)_")")
				Quit
			}	
			#; save the segment and add it to the message
			Set tIndex=$I($$$vaSegmentGbl)
			Set $$$vaSegmentGbl(tIndex)=tSeparators_tLine, $$$vaOpenSegmentPPG(tIndex) = 1, tLine="", tSegNum=tSegNum+1, ..%SegmentCount=..%SegmentCount+1
			Set $$$vaMobj(tDoc,"runtimeIndex")=$$$vaMobj(tDoc,"runtimeIndex")+1, $$$vaMobja(tDoc,"runtimeIndex",$$$vaMobj(tDoc,"runtimeIndex"))=tIndex

			#; Quit if not interactive and at document end segment
			Quit:('tSTX||..%ServiceInterface.%GetParameter("EOTOPTIONAL"))&&(tSegName="L")&&(tFirstSeg="H")
		} ; done doc
		Quit:$$$ISERR(tSC)

		Set tDocPos=pIOStream.Name_$C(13,10)_", @Line "_..%LineCount
		Set tSC1=..%ServiceInterface.OnDocumentEnd(tDoc,tDocPos,tSC1)  Quit:$$$ISERR(tSC1) // Fatal Error
		
		#; Process any trailing stuff in the stream
		Set tSC1=..%ServiceInterface.OnPostDocument(pIOStream,"")
	} While 0
	Set:$$$ISERR(tSC1)&&(tSC'=tSC1) tSC=$$$ADDSC(tSC,tSC1)
	If $IsObject(tDoc) {
		Set ..%CurrentDocument=$$$NULLOREF
		Set pDocument=tDoc
	}
	Quit tSC
}

Method %OnNew(initvalue As %RawString) As %Status [ Private, ProcedureBlock = 1 ]
{
	Set ..%ServiceInterface=initvalue
	Do ..Reset()
	Quit $$$OK
}

/// Strip off leading whitespace from the line
Method stripWhitespace(pLine As %String) As %String
{
	For i=1:1 { Quit:i>$L(pLine)||($C(13,10,9,32)'[$E(pLine,i)) }
	Quit $E(pLine,i,*)
}

ClassMethod mapCtlChars(s As %String) As %String
{
	Set so=""
	For i=1:1 { Set c=$E(s,i)  Quit:""=c  Set so=so_$Case(c,$C(2):"<STX>",$C(3):"<ETX>",$C(4):"<EOT>",$C(5):"<ENQ>",$C(6):"<ACK>",$C(23):"<ETB>",$C(13):"<CR>",$C(10):"<LF>",:c) }
	Quit so
}

Method Reset()
{
	Do ..ResetPosition()
	Set ..%Stream =$$$NULLOREF
}

Method ResetPosition()
{
	Set (..%SegmentCount,..%LineCount,..%CharCount)=0
	Set ..%CurrentDocument=$$$NULLOREF
}

}
