/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

Class EnsLib.HL7.Segment Extends (%RegisteredObject, EnsLib.EDI.Segment) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

// Override Name Maxlen & Minlen

/// Segment Type name
Property Name As %String(MAXLEN = 6, MINLEN = 3) [ Calculated, ReadOnly ];

/// Field Separator character
Property FS As %String [ Calculated ];

/// Component Separator character
Property CS As %String [ Calculated ];

/// Repetition Separator character
Property RS As %String [ Calculated ];

/// Escape Character
Property ESC As %String [ Calculated ];

/// Subcomponent Separator character
Property SS As %String [ Calculated ];

/// Truncation Character
Property TC As %String;

/// All 5 Separators as a single String
Property Separators As %String(MAXLEN = 5, MINLEN = 5) [ InitialExpression = {$$$HL7DefSeparators} ];

/// Local copy of segment data decomposed into multidimensional array
Property DataArray [ Internal, MultiDimensional ];

/// Deprecated: use DocType
Property SegType As %String [ Calculated ];

/// Deprecated: use DocTypeCategory
Property SegTypeCategory As %String [ Calculated, ReadOnly ];

/// Deprecated: use DocTypeName
Property SegTypeName As %String [ Calculated, ReadOnly ];

/// Size in bytes of the full segment content including any continuation nodes.
Property FullSize As %Integer [ Calculated, ReadOnly ];

/// Were we cloned from another Segment object? (If so, we won't be responsible for deleting the underlying segment ID data node if any)
Property %Cloned As %Boolean [ Internal, ReadOnly ];

Method SegTypeGet() As %String [ CodeMode = expression, Internal ]
{
i%DocType
}

Method SegTypeSet(val As %String) As %Status [ Internal ]
{
	Set ..DocType = val
	Quit $$$OK
}

Method SegTypeCategoryGet() As %String [ CodeMode = expression, Internal ]
{
i%DocTypeCategory
}

Method SegTypeNameGet() As %String [ CodeMode = expression, Internal ]
{
i%DocTypeName
}

Method PokeDocType(pDocType As %String) As %Status [ CodeMode = expression ]
{
..DocTypeSet(pDocType)
}

Method DocTypeSet(pDocType As %String) As %Status [ Internal ]
{
	Set i%DocType=pDocType
	Set i%DocTypeCategory=$P(i%DocType,":",1)
	Set i%DocTypeName=$P(i%DocType,":",2)
	Quit $$$OK
}

Method FSGet() As %String [ CodeMode = expression, Internal ]
{
$$$FSSEP(..Separators)
}

Method CSGet() As %String [ CodeMode = expression, Internal ]
{
$$$CSSEP(..Separators)
}

Method RSGet() As %String [ CodeMode = expression, Internal ]
{
$$$RSSEP(..Separators)
}

Method ESCGet() As %String [ CodeMode = expression, Internal ]
{
$$$ESCSEP(..Separators)
}

Method SSGet() As %String [ CodeMode = expression, Internal ]
{
$$$SSSEP(..Separators)
}

Method FSSet(newval) As %Status [ Internal ]
{
	Set $$$FSSEP(i%Separators)=$E(newval_$$$HL7DefFS)
	Quit $$$OK
}

Method CSSet(newval) As %Status [ Internal ]
{
	Set $$$CSSEP(i%Separators)=$E(newval_$$$HL7DefCS)
	Quit $$$OK
}

Method RSSet(newval) As %Status [ Internal ]
{
	Set $$$RSSEP(i%Separators)=$E(newval_$$$HL7DefRS)
	Quit $$$OK
}

Method ESCSet(newval) As %Status [ Internal ]
{
	Set $$$ESCSEP(i%Separators)=$E(newval_$$$HL7DefESC)
	Quit $$$OK
}

Method SSSet(newval) As %Status [ Internal ]
{
	Set $$$SSSEP(i%Separators)=$E(newval_$$$HL7DefSS)
	Quit $$$OK
}

Method SeparatorsSet(newvalue As %String) As %Status [ Internal ]
{
	Set i%Separators=$S(""=newvalue:$$$HL7DefSeparators, $L(newvalue)<5:newvalue_$E($C(17,18,19,20),$L(newvalue),4), 1:$E(newvalue,1,5))
	Quit $$$OK
}

Method FullSizeGet() As %String [ Internal ]
{
	Set data=..GetValueAt("")
	If data=""||(..ID="")||$D(..DataArray)||'$D($$$vaSegmentExt(..ID,1)) {
		Set len=$L(data)
	} Else {
		Set len=$L(data)
		For i=1:1 { Quit:'$D($$$vaSegmentExt(..ID,i),data)
			Set len=len+$L(data)
		}
	}
	Quit len
}

Method init(pSegID As %String, pMutable As %Boolean, pDocType As %String, pSegData As %String) As %Status [ Internal ]
{
	Set ..DocType=pDocType
	If pSegID="" {
		If ""=pSegData {
			Set i%IsMutable=1
		} Else {
			#; If SegData supplied, use that
			Set i%IsMutable=+pMutable
			Set tSC=..decomposeData(pSegData)  Quit:$$$ISERR(tSC) tSC
			Set ..Separators=pSegData
		}
		Quit $$$OK
	}
	#; Verify that segment exists
	Set data=$G($$$vaSegment(pSegID))
	Quit:""=data $$$ERROR($$$EnsErrGeneral,"Segment "_pSegID_" does not exist")
	Set i%ID=pSegID, i%IsMutable=+pMutable, i%%Cloned=''pSegData
	Set ..Separators=data
	Quit $$$OK
}

Method %OnConstructClone(object As %RegisteredObject, deep As %Boolean = 0, ByRef cloned As %String) As %Status [ Internal, Private ]
{
	Set i%IsMutable=1, i%%Cloned=1
	If $D(..DataArray) {
		Set i%ID=""
	} ElseIf i%ID'="" {
		Do $I($$$vaOpenSegmentPPG(i%ID))
	}
	Quit $$$OK
}

/// Compose the segment and store it at a new ID
Method SaveData(pSeparators As %String = "") As %Status
{
	If $D(..DataArray) && (""=..ID || ..IsMutable) {
		Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:pSeparators)
		Set tJK=$$$JobKey
		Set:'$D(%topSegIndex) %topSegIndex=$G($$$vaSegmentGbl(tJK)), tNoTop=1

		#; Relocate all old-style segments of all msg objects that reference the current segment. (Opening one will do them all)
		If $G($$$EnsConfig("HL7Segs-Compat")) {
			Lock +$$$vaSegmentGbl(tJK):2
			If $Test {
				Set data=$G($$$vaSegmentGbl(tJK))
				Set:data'=+data msg=##class(EnsLib.HL7.Message).%OpenId($O($$$vaSegmentGbl(tJK,0,"")))  Kill msg
				Lock -$$$vaSegmentGbl(tJK)
			}
		}
		Set tIndex=tJK_","_$I(%topSegIndex)
		Set $$$vaSegment(tIndex)=$E(tSeparators,1,5)_..getAtFromArray("",tSeparators)
		Set $$$vaOpenSegmentPPG(tIndex) = 1
		Set i%ID=tIndex, i%IsMutable=0, i%%Cloned=0
		Set $$$vaSegmentGbl(tJK)=%topSegIndex  Kill:$G(tNoTop) %topSegIndex
	} Else { $$$ASSERT(+..ID=$P(..ID,",")&&(..ID>0)) }
	Quit $$$OK
}

Method OutputToDevice(pSeparators As %String, pSequenceNumber As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String) As %Status
{
	Set tDeviceStream=##class(%IO.DeviceStream).AttachNew(,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ..OutputToIOStream(tDeviceStream, .pSeparators, .pSequenceNumber, .pSegNum, .pSegPath, .pParentDoc, .pIOFormatClassname)
}

/// deprecated - use OutputToLibraryStream
Method OutputToOldStream(pOldStream As %Stream.Object, pSeparators As %String, pSequenceNumber As %String) As %Status [ CodeMode = expression ]
{
..OutputToLibraryStream(.pOldStream, .pSeparators, .pSequenceNumber)
}

Method OutputToLibraryStream(pLibStream As %Stream.Object, pSeparators As %String, pSequenceNumber As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String) As %Status
{
	Set tIOStream=$S(pLibStream.%Extends("%IO.I.CharacterStream"):pLibStream,1:##Class(%IO.MetaCharacterStream).%New(pLibStream))
	Quit ..OutputToIOStream(tIOStream, .pSeparators, .pSequenceNumber, .pSegNum, .pSegPath, .pParentDoc, .pIOFormatClassname)
}

Method OutputToString(pSeparators As %String, pSequenceNumber As %String, Output pStatus As %Status, pCharEncoding As %String = "", pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String) As %String
{
	Set tIOStream=##Class(%IO.StringStream).%New()
	Set:""'=pCharEncoding tIOStream.CharEncoding=pCharEncoding
	Set pStatus = ..OutputToIOStream(tIOStream, .pSeparators, .pSequenceNumber, .pSegNum, .pSegPath, .pParentDoc, .pIOFormatClassname)
	Do tIOStream.Rewind()
	Quit tIOStream.Read()
}

/// Convert segments back to Stream, using sequence number
Method OutputToIOStream(pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSequenceNumber As %String = "", pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String = "") As %Status
{
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:pSeparators)
	Quit:""'=pIOFormatClassname&&$classmethod(pIOFormatClassname,"OutputSegment",$this,.tSC,pIOStream,tSeparators,.pSegNum,.pSegPath,.pParentDoc,.pSequenceNumber) tSC

	Set tSegTerminator=$$$SEGTERM(tSeparators)  Set:""=tSegTerminator tSegTerminator=$C($$$HL7DefSegTerminatorAscii)
	If (..Name="MSH")&&(pSequenceNumber'="") {
		Set tSeparators=$E(tSeparators,1,5)
		If $E(tSeparators_$C(0,0,0,0),5)?1C {
			Set tSeparators=$E(tSeparators,1,5)_$E($C(17,18,19,20),$L(tSeparators),4)
			Set tShowSeparators=$ZStrip(tSeparators,">C")
		} Else { Set tShowSeparators=tSeparators }

		Set tFS=$$$FSSEP(tSeparators)
		Do pIOStream.Write(..Name_tShowSeparators_..TC,0,.tSC)  Quit:$$$ISERR(tSC) tSC
		For i=3:1:12 Do pIOStream.Write(tFS_..GetValueAt(i,tSeparators),0,.tSC)  Quit:$$$ISERR(tSC)
		Quit:$$$ISERR(tSC) tSC
		Do pIOStream.Write(tFS_pSequenceNumber,0,.tSC)  Quit:$$$ISERR(tSC) tSC
		For i=14:1:..Count Do pIOStream.Write(tFS_..GetValueAt(i,tSeparators),0,.tSC)  Quit:$$$ISERR(tSC)
		Do pIOStream.Write(tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
	} Else {
		Set data=..GetValueAt("",.pSeparators)
		If data'="" {
			If (..ID="")||$D(..DataArray)||'$D($$$vaSegmentExt(..ID,1)) {
				Do pIOStream.Write(data_tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
			} Else {
				Do pIOStream.Write(data,0,.tSC)  Quit:$$$ISERR(tSC) tSC
				For i=1:1 { Quit:'$D($$$vaSegmentExt(..ID,i),data)
					Do pIOStream.Write(data,0,.tSC)  Quit:$$$ISERR(tSC)
				}
				Quit:$$$ISERR(tSC) tSC
				Do pIOStream.Write(tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
			}
		}
	}
	Quit $$$OK
}

Method outputHTMLSeg(pSeparators As %String, pSegNum As %String = "", pSegPath As %String = "", pDocument As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit ..OutputToDevice(.pSeparators,,pSegNum,pSegPath,pDocument,"EnsLib.HL7.Util.FormatHTMLv2")
}

Method outputHTMLSegZen(pSeparators As %String, pSegNum As %String = "", pSegPath As %String = "", pDocument As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit ..OutputToDevice(.pSeparators,,pSegNum,pSegPath,pDocument,"EnsLib.HL7.Util.FormatHTMLv2Zen")
}

ClassMethod ImportFromString(pString As %String, Output pStatus As %Status, pSeparators As %String, ByRef pConfigItem As %String = "", pIOFormatClassname As %String) As EnsLib.HL7.Segment
{
	If ""'=$G(pIOFormatClassname) {
		Set tIOStream=##Class(%IO.StringStream).%New(pString)
		Set tSeg=..ImportFromIOStream(tIOStream,.pStatus,.pSeparators,.pIOFormatClassname)
		Quit:$$$IsdefObject(tSeg)||$$$ISERR(pStatus) $G(tSeg)
		// Else assume it abdicated and continue to decomposeData()
	}
	Set tSeg=..%New()
	Set tSeparators=$S(""=$G(pSeparators):tSeg.Separators, 1:pSeparators)
	Set tFS=$E($ZStrip($E(pString,1,1+$$$MAXSEGNAME),"*AN")) ; separator is first non-alphanumeric char
	If (""=$G(pSeparators))&&(tFS=$E(pString))&&(tFS=$E(pString,9))&&($E(pString,6,8)?1U1U1UN) {
		#; the input comes with separators prefix
		Set tSeparators=$E(pString,1,5), pString=$E(pString,6,*)
	}
	If $Case($P(pString,tFS),"MSH":1,"FHS":1,"BHS":1,:0) {
		Set tSeparators=tFS_$P(pString,tFS,2)
		Set:$L(tSeparators)'=5 tSeparators=$E(tSeparators,1,5)_$E($$$HL7DefFS_$C(17,18,19,20),$L(tSeparators)+1,5)
	} ElseIf tFS'=$E(tSeparators) {
		Set $E(tSeparators,1)=tFS  For i=2:1:5 { Set:tFS=$E(tSeparators,i) $E(tSeparators,i)=$E($C(0,17,18,19,20),i) }
	}
	Set pStatus=tSeg.decomposeData(tSeparators_pString)
	Quit:$$$ISERR(pStatus) $$$NULLOREF
	Quit tSeg
}

ClassMethod ImportFromIOStream(pIOStream As %IO.I.CharacterStream, Output pStatus As %Status = {$$$OK}, pSeparators As %String, pIOFormatClassname As %String = "") As EnsLib.HL7.Message
{
	Quit:""'=pIOFormatClassname&&$classmethod(pIOFormatClassname,"ImportSegment",.tSeg,.pStatus,pIOStream,.pSeparators) tSeg
	Set tString=pIOStream.Read()
	Quit ..ImportFromString(tString,.pStatus,.pSeparators)
}

/// Create a new output stream based on an input spec: used as classname if class exists, otherwise as filename for a writable %IO.FileStream 
Method newFieldStream(pStreamSpec As %String, Output pSC As %Status = {$$$OK}) As %Stream.Object [ Internal ]
{
	Kill %objlasterror
	If $G(pStreamSpec)=$$$NULLOREF {
		Set tStream=##class(%Stream.GlobalCharacter).%New(), tType="%Stream.GlobalCharacter"
	} ElseIf ##class(%Dictionary.CompiledClass).%ExistsId(pStreamSpec) && ($classmethod(pStreamSpec,"%Extends","%IO.I.Stream") || $classmethod(pStreamSpec,"%Extends","%Stream.Object")) {
		Set tType=pStreamSpec, tStream=$classmethod(pStreamSpec,"%New")
	} Else {
		Set tStream=##class(%IO.FileStream).%New(), tType="%IO.FileStream"
		Do:$IsObject(tStream) tStream.Open(pStreamSpec,"NEWR",,.pSC)
	}
	Set:'$IsObject(tStream) pSC=$$$ERROR($$$EnsErrGeneral,"Unable to create "_tType_" object:"_$$$StatusDisplayString($G(%objlasterror,$$$OK)))
	Quit tStream
}

/// Read a field from a segment into a stream.
/// <var>pRemainder</var> is the remainder of the segment after the stream field, including the field's terminating separator
Method GetFieldStreamRaw(ByRef pStream As %Stream.Object, pPropertyPath As %String = "", Output pRemainder As %String = "", pProc As %String = "writeRaw", ByRef pHint) As %Status
{
	#; Construct pStream stream object if it is not an object passed in
	Set:'$$$IsdefObject(pStream) pStream=..newFieldStream(.pStream)

	#; We're done if the (partial) field is not the whole remainder of the segment chunk
	Set tData=..GetValueAt(pPropertyPath,,.tSC)  Quit:$$$ISERR(tSC) tSC
	If ""=..ID {
		Set pRemainder=..getRemainderFromArray(pPropertyPath,.tSC)
		Set tPrev=tData, next=6 ; use next as a flag for pRemainder already gotten
		Set pHint("%seps")=..Separators
	} Else {
		Set data0=$$$vaSegment(..ID), pHint("%seps")=$E(data0,1,5)
		Set next=$F(data0,tData,6)
		If 'next {
			Quit $$$ERROR($$$EnsErrGeneral,"Array/Global mismatch reading segment data at property path '"_pPropertyPath_"'")
		} ElseIf (next <= $L(data0)) {
			Set pRemainder=$E(data0,next,*)_$G($$$vaSegmentExt(..ID,1))
			Set tPrev=tData
		} Else {
			Set tMaxStr=$$$MaxLocalLength-50 ; 50 for the 10-char unescape extra plus 30 for 3 mod4 escape sequences plus 10 for good luck
			Set next=0, tPrev=""  For i=0:1 {
				#; Only process enough to leave 16k tail for separators checking
				#; process chunks rounded to nearest 4 for base64 processing
				#; leave at least 10 left over after last unescape for further unescaping
				Quit:i>0&&'$D($$$vaSegmentExt(..ID,i),tData) ; tPrev is the final chunk
				Set tPos=$L(tPrev)+$L(tData)-16000  Set tPos=$S(tPos<0:0, 1:tPos-(tPos#4))
				If tPos<$L(tPrev) { Set tCurr=$E(tPrev,1,tPos), tPrev=$E(tPrev,tPos+1,*)_tData, tData="" }
				Else {
					Set tCurr=tPrev, tPrev=$E(tData,tPos+1-$L(tCurr),*), tData=$E(tData,1,tPos-$L(tCurr))
					#; Rebalance to ensure enough elbow room in each string
					If $L(tCurr)+$L(tData)<tMaxStr { Set tCurr=tCurr_tData, tData="" }
					ElseIf $L(tData)<20 {
						Set tData=$E(tCurr,16000+1,*)_tData, $E(tCurr,16000+1,$L(tCurr))=""
					} ElseIf $L(tCurr)<20 {
						Set tMov=16000-$L(tCurr)
						Set tCurr=tCurr_$E(tData,1,tMov), $E(tData,1,tMov)=""
					}
				}
				#; Process (most of) tCurr and tData if any
				Set tSC=$method($this,pProc,pStream,tCurr,.pHint)  Quit:$$$ISERR(tSC)
				Set:""'=tData tSC=$method($this,pProc,pStream,tData,.pHint)  Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC) tSC
		}
	}
	If ""'=tPrev {
		If 'next {
			#; Find separators relevant to the given Property Path
			Set tSeps=""
			Set:pPropertyPath'="" tSeps=$$$FSSEP(data0)
			Set:pPropertyPath["(" tSeps=tSeps_$$$RSSEP(data0)
			Set pd=$F(pPropertyPath,".") Set:pd tSeps=tSeps_$$$CSSEP(data0)
			Set:pd&&$F(pPropertyPath,".",pd) tSeps=tSeps_$$$SSSEP(data0)

			#; Find first relevant separator in last chunk
			For i=1:1 { Quit:""=$E(tSeps,i)  Set rpos=$F(tPrev,$E(tSeps,i)) Set:rpos tHit(rpos-1)="" }
			Set tHit=$O(tHit(""))
			Set:tHit pRemainder=$E(tPrev,tHit,*), $E(tPrev,tHit,$L(tPrev))=""
		}
		Set pHint("%fin")=1
		Set tSC=$method($this,pProc,pStream,tPrev,.pHint)
	}
	Quit tSC
}

Method writeRaw(pStream As %Stream.Object, pData As %String, ByRef pHint) As %Status [ Internal ]
{
	If pStream.%Extends("%IO.I.Stream") {
		Do pStream.Write(pData,,.tSC)
		Quit tSC
	}
	Quit pStream.Write(pData)
}

/// Read a field from a segment into a stream, decoding from Base64 to plain binary.
/// <var>pRemainder</var> is the remainder of the segment after the stream field, including the field's terminating separator
Method GetFieldStreamBase64(ByRef pStream As %Stream.Object, pPropertyPath As %String = "", Output pRemainder As %String = "", pUnescapeFirst As %Boolean = 1) As %Status
{
	Set tHint("%unesc64")=pUnescapeFirst
	Quit ..GetFieldStreamRaw(.pStream,.pPropertyPath,.pRemainder,$S(pUnescapeFirst:"writeUnescaped",1:"writeBase64"),.tHint)
}

Method writeBase64(pStream As %Stream.Object, pData As %String, ByRef pHint) As %Status [ Internal ]
{
	try {
		Set tSC=..writeRaw(pStream,$System.Encryption.Base64Decode(pData))
	} catch {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"Error "_$$$StatusDisplayString($$$SystemError)_" writing decoded Base64 from data '"_$S($L(pData)<200:pData,1:$E(pData,1,100)_"..."_$E(pData,*+1-100,*))_"'")
	}
	Quit tSC
}

/// Read a field from a segment into a stream, unescaping any encoded separators or newlines, to plain text.
/// <var>pRemainder</var> is the remainder of the segment after the stream field, including the field's terminating separator
Method GetFieldStreamUnescaped(ByRef pStream As %Stream.Object, pPropertyPath As %String = "", Output pRemainder As %String = "") As %Status
{
	Quit ..GetFieldStreamRaw(.pStream,.pPropertyPath,.pRemainder,"writeUnescaped",.tHint)
}

Method writeUnescaped(pStream As %Stream.Object, pData As %String, ByRef pHint) As %Status [ Internal ]
{
	Set:""'=$G(pHint) pData=pHint_pData, pHint=""
	If $G(pHint("%fin")) {
		Set pData=..UnescapeEx(pData,pHint("%seps")), tExtra=""
	} ElseIf '$G(pHint("%unesc64")) {
		Set pData=..UnescapeEx(pData,pHint("%seps"),,.tAfterPos), tExtra=""
		If tAfterPos<=$L(pData) {
			Set:$L(pData)+2-10>tAfterPos tAfterPos=$L(pData)+2-10
			Set tExtra=$E(pData,tAfterPos,*)_tExtra, $E(pData,tAfterPos,$L(pData))=""
		}
	} Else {
		#; Find the site of the last replacement
		#; Make it mod 4 in case we need to base64 decode
		#; save some extra extra in case there is a replacement right at the end
		Set tExtra=$E(pData,*+1-30,*), pData=$E(pData,1,*-30)
		Set pData=..UnescapeEx(pData,pHint("%seps"),,.tAfterPos)
		Set tMod4Tail=$L(pData)+2-10-($L(pData)+1-10#4)
		If tMod4Tail>=tAfterPos {
			Set tAfterPos=tMod4Tail
			Set tExtra=$E(pData,tAfterPos,*)_tExtra, $E(pData,tAfterPos,$L(pData))=""
		} Else {
			#; Increment escaped pData until we get to Mod4
			Set tExtra=$E(pData,tAfterPos,*)_tExtra, $E(pData,tAfterPos,$L(pData))=""
			Set tNeeded=4-($L(pData)#4)
			For i=3:1:30 { Quit:tNeeded=4
				Set tAfterPos=0, tTail=..UnescapeEx($E(tExtra,1,i),pHint("%seps"),,.tAfterPos)
				If tAfterPos { ; we hit an escape sequence - is it far enough along?
					If tAfterPos-1<tNeeded {
						Set pData=pData_$E(tTail,1,tAfterPos-1), $E(tExtra,1,i)="", i=0
						Set tNeeded=4-($L(pData)#4)
					} Else {
						Set pData=pData_$E(tTail,1,tNeeded)
						If tAfterPos-1=tNeeded {
							Set $E(tExtra,1,i)=""
						} Else {
							Set $E(tExtra,1,tNeeded)=""
						}
						Set tNeeded=4 ; done
					}
				} ElseIf i-10>0 { ; 10 is enough to be sure of no escape seqence
					Set pData=pData_$E(tExtra), $E(tExtra)="", i=i-1
					Set tNeeded=4-($L(pData)#4)
				}
			}
		}
	}
	Set pHint=tExtra
	If $G(pHint("%unesc64")) {
		Quit ..writeBase64(pStream,pData,.pHint)
	}
	Quit ..writeRaw(pStream,pData,.pHint)
}

/// deprecated: use GetFieldStreamRaw(), GetFieldStreamUnescaped(), or GetFieldStreamBase64()
Method ReadRawDataStream(ByRef pStream As %Stream.Object, pPropertyPath As %String = "") As %Status [ Internal ]
{
	Set:'$$$IsdefObject(pStream) pStream=$classmethod($S(""'=$G(pStream):pStream, 1:"%Library.GlobalCharacterStream"),"%New")

	Set tMarker=..GetValueAt(pPropertyPath,,.tSC)  Quit:$$$ISERR(tSC) tSC
	If pStream.%Extends("%IO.I.Stream") {
		Do pStream.Write(tMarker,.tSC)  Quit:$$$ISERR(tSC) tSC
	} Else {
		Set tSC=pStream.Write(tMarker)  Quit:$$$ISERR(tSC) tSC
	}
	Set data0=$S(""=..ID:".", 1:$$$vaSegment(..ID))
	Quit:""=..ID||($F(data0,tMarker,6)-1<$L(data0)) tSC
	For i=1:1 { Quit:'$D($$$vaSegmentExt(..ID,i),data)
		If pStream.%Extends("%IO.I.Stream") {
			Do pStream.Write(data,.tSC)  Quit:$$$ISERR(tSC)
		} Else {
			Set tSC=pStream.Write(data)  Quit:$$$ISERR(tSC)
		}
	}
	Quit tSC
}

/// Store a stream into a segment field. Note that this renders the segment immutable after completing, and therefore works only once per segment.
/// <var>pRemainder</var> contains trailing segment text to be appended raw after the stream value.
Method StoreFieldStreamRaw(pStream As %Stream.Object, pPropertyPath As %String = "", pRemainder As %String = "", pProc As %String = "readRaw", ByRef pHint) As %Status
{
	Set tMaxStr=$$$MaxLocalLength
	Set tSC=$$$OK, i=0, tMarker=..ESC_".stream"_..ESC

	#; Place a marker at the target site
	Set tSC=..SetValueAt(tMarker,pPropertyPath)  Quit:$$$ISERR(tSC) tSC
	Set tSC=..SaveData()  Quit:$$$ISERR(tSC) tSC
	Kill ..DataArray
	Set data=$$$vaSegment(..ID), pHint("%seps")=$E(data,1,5)
	Set pos=$F(data,tMarker,6) Quit:'pos $$$ERROR($$$EnsErrGeneral,"Unable find stream store location in segment")
	Set data2=$S(""'=pRemainder:pRemainder,1:$E(data,pos,*))
	Set maxSegLen=$$$HL7MaxSegLen, chunkpos=pos-$L(tMarker), chunkmax=maxSegLen-(chunkpos-1)

	Set chunk=$method($this,pProc,pStream,tMaxStr,.tSC,.pHint)  Quit:$$$ISERR(tSC) tSC
	Set $E($$$vaSegment(..ID),chunkpos,$L(data))=$E(chunk,1,chunkmax)

	Set i=0,prevchunk="",tLast2=0 For {
		Set:""=chunk&&'tLast2 tLast2=1
		Set chunk=$S(chunkmax-$L(prevchunk)>$L(chunk):"", 1:$E(chunk,chunkmax-$L(prevchunk)+1,*))
		Set chunkpos=1+$L($S('i:$$$vaSegment(..ID),1:$$$vaSegmentExt(..ID,i)))
		If chunkpos>maxSegLen { Set i=i+1, chunkpos=1, chunkmax=maxSegLen }
		Else { Set chunkmax=maxSegLen-(chunkpos-1) }
		
		If tLast2 {
			Set prevchunk=""
			Quit:data2_chunk=""
			Set:data2'="" chunk=data2, data2=""
		} Else {
			Set prevchunk=chunk
			Set chunk=$method($this,pProc,pStream,tMaxStr,.tSC,.pHint)  Quit:$$$ISERR(tSC)
		}
		If 'i {
			Set $$$vaSegment(..ID)=$$$vaSegment(..ID)_prevchunk_$E(chunk,1,chunkmax-$L(prevchunk))
		} Else {
			Set $$$vaSegmentExt(..ID,i)=$G($$$vaSegmentExt(..ID,i))_prevchunk_$E(chunk,1,chunkmax-$L(prevchunk))
		}
	}
	Quit tSC
}

Method readRaw(pStream As %Stream.Object, pMaxRead As %Integer, pSC As %Status, ByRef pHint) As %String [ Internal ]
{
	If pStream.%Extends("%IO.I.Stream") {
		Quit pStream.Read(pMaxRead,,.pSC)
	}
	Quit pStream.Read(pMaxRead,.pSC)
}

/// Store a stream into a segment field, encoding as Base64. Note that this renders the segment immutable after completing, and therefore works only once per segment.
Method StoreFieldStreamBase64(pStream As %Stream.Object, pPropertyPath As %String = "", pRemainder As %String = "", pEscapeAfter As %Boolean = 1) As %Status
{
	Set tHint("%esc64")=pEscapeAfter
	Quit ..StoreFieldStreamRaw(.pStream,.pPropertyPath,.pRemainder,"readBase64",.tHint)
}

Method readBase64(pStream As %Stream.Object, pMaxRead As %Integer, pSC As %Status, ByRef pHint) As %String [ Internal ]
{
	Set pMaxRead=pMaxRead\4*3-(pMaxRead\52*2) ; make room for Base64 expansion
	Set:$G(pHint("%esc64")) pMaxRead=pMaxRead\10 ; make room for escape codes
	#; round down to multiple of 3 for Base64 chunk
	Set pMaxRead=pMaxRead-(pMaxRead#3)
	Set tData=..readRaw(pStream,pMaxRead,.pSC,.pHint)  Quit:$$$ISERR(pSC) ""
	Set tData=$System.Encryption.Base64Encode(tData)
	Set:$G(pHint("%esc64")) tData=..EscapeEx(tData,pHint("%seps"))
	Quit tData
}

/// Store a stream into a segment field, applying HL7 escaping. Note that this renders the segment immutable after completing, and therefore works only once per segment.
Method StoreFieldStreamEscaped(pStream As %Stream.Object, pPropertyPath As %String = "", pRemainder As %String = "") As %Status
{
	Quit ..StoreFieldStreamRaw(.pStream,.pPropertyPath,.pRemainder,"readEscaped",.tHint)
}

Method readEscaped(pStream As %Stream.Object, pMaxRead As %Integer, pSC As %Status, ByRef pHint) As %String [ Internal ]
{
	Set tData=..readRaw(pStream,pMaxRead\10,.pSC,.pHint)  Quit:$$$ISERR(pSC) "" ; make room for escape codes
	Quit ..EscapeEx(tData,pHint("%seps"))
}

/// deprecated: use StoreFieldStreamRaw(), StoreFieldStreamEscaped() or StoreFieldStreamBase64()
Method StoreRawDataStream(pStream As %Stream.Object, pPropertyPath As %String = "") As %Status
{
	Set tSC=$$$OK, i=0, tMarker=..ESC_".stream"_..ESC, tMaxSegLen = $$$HL7MaxSegLen
	If pStream.%Extends("%IO.I.Stream") {
		Set chunk=pStream.Read(tMaxSegLen,,.tSC)  Quit:$$$ISERR(tSC) tSC
	} Else {
		Set chunk=pStream.Read(tMaxSegLen,.tSC)  Quit:$$$ISERR(tSC) tSC
	}
	Set tSC=..SetValueAt(tMarker,pPropertyPath)  Quit:$$$ISERR(tSC) tSC
	Set tSC=..SaveData()  Quit:$$$ISERR(tSC) tSC
	Kill ..DataArray
	Set data=$$$vaSegment(..ID)
	Set pos=$F(data,tMarker,6) Quit:'pos $$$ERROR($$$EnsErrGeneral,"Unable find stream store location in segment")
	Set data2=$E(data,pos,*)

	Set chunkpos=pos-$L(tMarker), chunkmax=tMaxSegLen-(chunkpos-1)
	Set $E($$$vaSegment(..ID),chunkpos,$L(data))=$E(chunk,1,chunkmax)

	Set i=0,prevchunk="",tLast2=0 For {
		Set:""=chunk&&'tLast2 tLast2=1
		Set chunk=$S(chunkmax-$L(prevchunk)>$L(chunk):"", 1:$E(chunk,chunkmax-$L(prevchunk)+1,*))
		Set chunkpos=$L($S('i:$$$vaSegment(..ID),1:$$$vaSegmentExt(..ID,i)))+1
		If chunkpos>tMaxSegLen { Set i=i+1, chunkpos=1, chunkmax=tMaxSegLen }
		Else { Set chunkmax=tMaxSegLen-(chunkpos-1) }
		
		If tLast2 {
			Set prevchunk=""
			Quit:data2_chunk=""
			Set:data2'="" chunk=data2, data2=""
		} Else {
			Set prevchunk=chunk
			If pStream.%Extends("%IO.I.Stream") {
				Set chunk=pStream.Read(tMaxSegLen,,.tSC)  Quit:$$$ISERR(tSC)
			} Else {
				Set chunk=pStream.Read(tMaxSegLen,.tSC)  Quit:$$$ISERR(tSC)
			}
		}
		If 'i {
			Set $$$vaSegment(..ID)=$$$vaSegment(..ID)_prevchunk_$E(chunk,1,chunkmax-$L(prevchunk))
		} Else {
			Set $$$vaSegmentExt(..ID,i)=$G($$$vaSegmentExt(..ID,i))_prevchunk_$E(chunk,1,chunkmax-$L(prevchunk))
		}
	}
	Quit tSC
}

/// <var>pPropertyPath</var> is of syntax: <code>field [ ( array ) ] [ . component [ . subcomponent ] ]</code>
/// Returns the value at the specified property path. 
/// <var>pSeparators</var> is used to specify the separators to be used when a non-atomic value is returned.
/// All property path elements must be either name or index.
/// If a segment's total length is greater than the maximum string length on the system, then fields beyond the 
/// maximum string length can't be retrieved using this method. (Note that on older Ensemble systems, this 
/// limit was 32K, but with long strings enabled the limit is approximately 3.6MB.)
/// If you are dealing with strings longer than the string limit, use one of the following methods:
/// <ul><li><method>GetFieldStreamRaw</method>(),
/// <li><method>GetFieldStreamUnescaped</method>(), or</li>
/// <li><method>GetFieldStreamBase64</method>()</li></ul>
Method GetValueAt(pPropertyPath As %String, pSeparators As %String, Output pStatus As %Status, pTreatEmptyAsNull As %Boolean = 0) As %String
{
	If (..ID="")||$D(..DataArray) {
		Quit ..getAtFromArray(.pPropertyPath,.pSeparators,.pStatus,pTreatEmptyAsNull)
	} Else {
		Quit ..getAtFromGlobal(.pPropertyPath,.pSeparators,.pStatus,pTreatEmptyAsNull)
	}
}

/// Gets the next index in an array
Method GetNextIndex(pPath As %String, pIndex As %String, ByRef pStatus As %Status = {$$$OK}) As %String
{
	If $E(pPath,*-1,*)'="()" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't iterate on PropertyPath '"_pPath_"'")  Quit ""
	Set field=$E(pPath,1,*-2)
	If +field'=field {
		If field="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't iterate on empty PropertyPath")  Quit ""
		Set field=$S((..DocTypeCategory="")||(..DocTypeName=""):"", 1:$G($$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map",$ZCVT(field,"L"))))
		If $E(field,*-1,*)'="()" Set pStatus=$$$ERROR($$$EnsErrGeneral,"PropertyPath '"_field_"' is not an array property")  Quit ""
		Set field=$E(field,1,*-2)
		If +field'=field Set pStatus=$$$ERROR($$$EnsErrGeneral,"Unrecognized Property Index '"_field_"'")  Quit ""
	}
	If $Case(..Name,"MSH":0,"FHS":0,"BHS":0,:1) Set field=field+1
	If '$D(..DataArray) Set pStatus=..decompose() Quit:$$$ISERR(pStatus) ""
	Quit $O(..DataArray(field,pIndex))
}

/// Sets the value at the specified property path.
/// pPropertyPath is of syntax: field [ ( array ) ] [ . component [ . subcomponent ] ]
/// All property path elements must be either name or index. pKey is used to append an array index to the value at
/// the given property path. pAction corresponds to the actions in the DTL <assign> statement.
/// If a segment's total length is more than the current string length limit, or will be after setting the value, then this method can't be used. Instead, use one of the methods StoreFieldStreamRaw(), StoreFieldStreamEscaped() or StoreFieldStreamBase64()
Method SetValueAt(pValue As %String, pPropertyPath As %String = "", pAction As %String = "set", pKey As %String = "") As %Status
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Segment is immutable")
	Set:$Case(pAction,"remove":1,"clear":1,:'($D(pValue)#2)) pValue=""
	If '$D(..DataArray) Set tSC=..decompose()  Quit:$$$ISERR(tSC) tSC
	Set i%ID="" ; clear the ID because we are no longer referring to it
	If pKey'="" Set pPropertyPath=pPropertyPath_"("_pKey_")"
	Set tSC=..parsePropertyPath(pPropertyPath,.field,.array,.component,.subcomponent)  Quit:$$$ISERR(tSC) tSC
	If $Case(..Name,"MSH":1,"FHS":1,"BHS":1,:0) {
		If field=2 Set ..FS=pValue Quit $$$OK
		If field=3 Set ..Separators=..FS_pValue, ..TC=$E(pValue,5) Quit $$$OK
		If field'="",field>1 Set field=field-1
	}
	Set data=pValue
	If field="" {
		Kill:pAction'="append" ..DataArray
		Set data1=data
		For i=1:1:$L(data1,..FS) { Set data2=$P(data1,..FS,i)
			For j=1:1:$L(data2,..RS) { Set data3=$P(data2,..RS,j)
				For k=1:1:$L(data3,..CS) { Set data4=$P(data3,..CS,k)
					For l=1:1:$L(data4,..SS) { Set ..DataArray(i,j,k,l)=$S(pAction="append":$G(..DataArray(i,j,k,l)),1:"")_$P(data4,..SS,l) }
				}
			}
		}
	} ElseIf array="" {
		Kill:pAction'="append" ..DataArray(field)
		Set data2=data
		For j=1:1:$L(data2,..RS) { Set data3=$P(data2,..RS,j)
			For k=1:1:$L(data3,..CS) { Set data4=$P(data3,..CS,k)
				For l=1:1:$L(data4,..SS) { Set ..DataArray(field,j,k,l)=$S(pAction="append":$G(..DataArray(field,j,k,l)),1:"")_$P(data4,..SS,l) }
			}
		}
	} ElseIf component="" {
		Kill:pAction'="append" ..DataArray(field,array)
		Set data3=data
		For k=1:1:$L(data3,..CS) { Set data4=$P(data3,..CS,k)
			For l=1:1:$L(data4,..SS) { Set ..DataArray(field,array,k,l)=$S(pAction="append":$G(..DataArray(field,array,k,l)),1:"")_$P(data4,..SS,l) }
		}
	} ElseIf subcomponent="" {
		Kill:pAction'="append" ..DataArray(field,array,component)
		Set data4=data
		For l=1:1:$L(data4,..SS) { Set ..DataArray(field,array,component,l)=$S(pAction="append":$G(..DataArray(field,array,component,l)),1:"")_$P(data4,..SS,l) }
	} Else {
		Set ..DataArray(field,array,component,subcomponent)=$S(pAction="append":$G(..DataArray(field,array,component,subcomponent)),1:"")_data
	}
	Quit $$$OK
}

Method CopyValues(pSource As EnsLib.HL7.Segment, pSourcePath As %String, pTargetPath As %String, pAction As %String, pKey As %String, pEmptyFieldAsNull As %Boolean = 0, pIgnoreMissingSource As %Boolean = 0) As %Status
{
	Set tSC=$$$OK
	Set tSourceWild=$F(pSourcePath,"()"), tTargetWild=$F(pTargetPath,"()")
	If tSourceWild||tTargetWild {
		Set tSourceHead=$P(pSourcePath,"()"), tSourceTail=$P(pSourcePath,"()",2,*)
		Set tTargetHead=$P(pTargetPath,"()"), tTargetTail=$P(pTargetPath,"()",2,*)
		If tSourceWild {
			If pEmptyFieldAsNull&&tTargetWild {
				Quit:(pSource.GetValueAt(tSourceHead)="") $$$OK
			}
			Set i=""
			For {
				Set i=pSource.GetNextIndex(tSourceHead_"()",i,.tSC) Quit:i=""
				Set tSourceNewPath=tSourceHead_"("_(i)_")"_tSourceTail
				Set tTargetNewPath=$S(tTargetWild:tTargetHead_"("_(i)_")"_tTargetTail,1:pTargetPath)
				Set tSC2=..CopyValues(pSource,tSourceNewPath,tTargetNewPath,pAction,pKey,pEmptyFieldAsNull,pIgnoreMissingSource)
				If $$$ISERR(tSC2)&&('pIgnoreMissingSource||(($$$StatusText(tSC2)'["No segment found")&&($$$StatusText(tSC2)'["is not an element, instead this node"))) {
					Set tSC=tSC2
					Quit
				}
			}
		} Else {
			Set i=""
			For {
				Set i=..GetNextIndex(tTargetHead_"()",i,.tSC) Quit:i=""
				Set tTargetNewPath=tTargetHead_"("_(i)_")"_tTargetTail
				Set tSC=..CopyValues(pSource,pSourcePath,tTargetNewPath,pAction,pKey,pEmptyFieldAsNull,pIgnoreMissingSource) Quit:$$$ISERR(tSC)
			}
		}
	} Else {
		Set tSC=..SetValueAt(pSource.GetValueAt(pSourcePath,,.tSC2,pEmptyFieldAsNull),pTargetPath,pAction,pKey)
		Set:$$$ISERR(tSC2) tSC=$$$ADDSC(tSC,tSC2)
	}
	Quit tSC
}

/// Decompose the segment from a single string into a multidimensional array
Method decompose() As %Status [ CodeMode = expression ]
{
$S($D(..DataArray):$$$ERROR($$$EnsErrGeneral,"array data already exists"), ""=..ID:$$$OK, 1:..decomposeData($$$vaSegment(..ID)))
}

Method decomposeData(pData As %String) As %Status
{
	Set FS=$E(pData,1), CS=$E(pData,2), RS=$E(pData,3), ESC=$E(pData,4), SS=$E(pData,5), data1=$E(pData,6,*)
	For i=1:1:$L(data1,FS) { Set data2=$P(data1,FS,i)
		For j=1:1:$L(data2,RS) { Set data3=$P(data2,RS,j)
			For k=1:1:$L(data3,CS) { Set data4=$P(data3,CS,k)
				For l=1:1:$L(data4,SS) { Set ..DataArray(i,j,k,l)=$P(data4,SS,l) }
			}
		}
	}
	Set:$Case($P(data1,FS),"MSH":1,"BHS":1,"FHS":1,:0) ..TC=$G(..DataArray(2,2,1,2))
	Quit $$$OK
}

Method getAtFromGlobal(pPropertyPath As %String = "", pSeparators As %String, Output pStatus As %Status, pTreatEmptyAsNull As %Boolean = 0) As %String
{
	Set data=$$$vaSegment(..ID)
	If ""=$G(pSeparators) { Set (tShowSeparators,tSeparators)=$E(data,1,5), FS=$$$FSSEP(tSeparators), data=$E(data,6,*) }
	Else {
		Set tSeparators=$E(pSeparators,1,5), FS=$$$FSSEP(tSeparators)
		If $E(tSeparators_$C(0,0,0,0),5)?1C {
			Set tSeparators=tSeparators_$E($C(17,18,19,20),$L(tSeparators),4)
			Set tShowSeparators=$ZStrip(tSeparators,">C") ; allow short separators list
		} Else { Set tShowSeparators=tSeparators }
		If $E(data,1,5)'=tSeparators {
			Set data=..replaceSeparators(data,tSeparators), data=$E(data,6,*) 
			Set:""=pPropertyPath&&$Case($P(data,FS),"MSH":1,"FHS":1,"BHS":1,:0) $P(data,FS,2)=$E(tShowSeparators,2,5)_$E($P(data,FS,2),5)
		} Else {
			Set data=$E(data,6,*)
			Set:""=pPropertyPath&&$Case($P(data,FS),"MSH":1,"FHS":1,"BHS":1,:0)&&(tShowSeparators'=tSeparators) $P(data,FS,2)=$E(tShowSeparators,2,5)_$E($P(data,FS,2),5)
		}
	}
	Set tName=$P(data,FS)
	Set tIsHeader = $Case(tName,"MSH":1,"FHS":1,"BHS":1,:0)
	Set:tIsHeader ..TC = $E($P(data,FS,2),5)
	If ""=pPropertyPath Set pStatus=$$$OK  Quit data
	Set pStatus=..parsePropertyPath(pPropertyPath,.field,.array,.component,.subcomponent)  Quit:$$$ISERR(pStatus) ""
	If tIsHeader {
		Quit:field=1 tName
		Quit:field=2 FS
		Quit:field=3 $E(tShowSeparators,2,5)_..TC
		If field="*" {
			Set tLastFieldNull= (pTreatEmptyAsNull && ($P(data,FS,*)=""))
			Quit $L(data,FS) - tLastFieldNull
		}
		Set:field'="" field=field-1
	}
	Set tLastFieldNull = (pTreatEmptyAsNull && ($P(data,FS,*)=""))
	Set tFieldCount = $L(data,FS)-'tIsHeader - tLastFieldNull
	If field'="" {
		Set data = $S(field="*":tFieldCount,1:$P(data,FS,field))
	}
	Set RS=$$$RSSEP(tSeparators)
	Set tRepsCount = $S((field-'tIsHeader) > tFieldCount : 0,pTreatEmptyAsNull&&(data="") : 0, 1:$L(data,RS))
	If array'="" {
		Set data=$S(array="*":tRepsCount,1:$P(data,RS,array))
	}
	Set CS=$$$CSSEP(tSeparators)
	Set tCompCount = $S(array > tRepsCount : 0, 1:$L(data,CS))
	If component'="" {
		Set data=$S(component="*":tCompCount,1:$P(data,CS,component))
	}
	If subcomponent'="" {
		Set SS=$$$SSSEP(tSeparators)
		If subcomponent="*" {
			Set data = $S(component > tCompCount : 0, 1:$L(data,SS))
		} Else {
			Set data=$P(data,SS,subcomponent)
		}
	}
	Quit data
}

Method getAtFromArray(pPropertyPath As %String = "", pSeparators As %String, Output pStatus As %Status, pEmptyFieldAsNull As %Boolean = 0) As %String
{
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:$E(pSeparators,1,5))
	If $E(tSeparators_$C(0,0,0,0),5)?1C {
		Set tSeparators=tSeparators_$E($C(17,18,19,20),$L(tSeparators),4)
		Set tShowSeparators=$ZStrip(tSeparators,">C") ; allow short separators list
	} Else { Set tShowSeparators=tSeparators }
	Set FS=$$$FSSEP(tSeparators), CS=$$$CSSEP(tSeparators), RS=$$$RSSEP(tSeparators), SS=$$$SSSEP(tSeparators)
	Set pStatus=..parsePropertyPath(pPropertyPath,.I,.J,.K,.L) Quit:$$$ISERR(pStatus) ""
	Set tName=$G(..DataArray(1,1,1,1))
	If $Case(tName,"MSH":1,"FHS":1,"BHS":1,:0) {
		Quit:I=1 tName
		Quit:I=2 FS
		Quit:I=3 $E(tShowSeparators,2,5)_..TC
		If I="*" {
			Set data = $O(..DataArray(""),-1)
			If pEmptyFieldAsNull && (..GetValueAt(data)="") {
				Set data = data - 1
			}
			Quit data
		}		
		If I="" {
			Set data=tName_tShowSeparators_..TC, tCount=$O(..DataArray(""),-1)
			For i=3:1:tCount Set data=data_FS_..getAtFromArray(i,tSeparators)
			Quit data
		}
		Set I=I-1
	}
	Set lasti=$O(..DataArray(""),-1)
	If I="*" {
		Set data=lasti-1
		If pEmptyFieldAsNull && (..GetValueAt(data)="") {
			Set data = data - 1
		}
	} Else {
		Set data=""
		If I'="" {Set tStartI=I, tEndI=I} Else {Set tStartI=1, tEndI=lasti}
		For i=tStartI:1:tEndI {
			If I="",i>1 Set data=data_FS
			Set lastj=$S(i>lasti:0,1:$O(..DataArray(i,""),-1))
			If J="*" {
				Set data=lastj
				Quit:(lastj>1)||'pEmptyFieldAsNull
				Set data = $S(..GetValueAt(i-1)="":0,1:1)
				Quit
			}
			If J'="" {Set tStartJ=J, tEndJ=J} Else {Set tStartJ=1, tEndJ=lastj}
			For j=tStartJ:1:tEndJ {
				If J="",j>1 Set data=data_RS
				Set lastk=$S(j>lastj:0,1:$O(..DataArray(i,j,""),-1))
				If K="*" Set data=lastk Quit
				If K'="" {Set tStartK=K, tEndK=K} Else {Set tStartK=1, tEndK=lastk}
				For k=tStartK:1:tEndK {
					If K="",k>1 Set data=data_CS
					Set lastl=$S(k>lastk:0,1:$O(..DataArray(i,j,k,""),-1))
					If L="*" Set data=lastl Quit
					If L'="" {Set tStartL=L, tEndL=L} Else {Set tStartL=1, tEndL=lastl}
					For l=tStartL:1:tEndL {
						If L="",l>1 Set data=data_SS
						Set value=$G(..DataArray(i,j,k,l))
						Set:tSeparators'=..Separators value=$E(..replaceSeparators(..Separators_value,tSeparators),6,*)
						Set data=data_value
					}
				}
			}
		}
	}
	Quit data
}

Method getRemainderFromArray(pPropertyPath As %String = "", Output pStatus As %Status = {$$$OK})
{
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:$E(pSeparators,1,5))
	If $E(tSeparators_$C(0,0,0,0),5)?1C {
		Set tSeparators=tSeparators_$E($C(17,18,19,20),$L(tSeparators),4)
		Set tShowSeparators=$ZStrip(tSeparators,">C") ; allow short separators list
	} Else { Set tShowSeparators=tSeparators }
	Set FS=$$$FSSEP(tSeparators), CS=$$$CSSEP(tSeparators), RS=$$$RSSEP(tSeparators), SS=$$$SSSEP(tSeparators)
	Set pStatus=..parsePropertyPath(pPropertyPath,.I,.J,.K,.L) Quit:$$$ISERR(pStatus) ""
	Quit:I="" ""
	If (I="*")||(J="*")||(K="*")||(L="*") {
		Quit ""
	}
	Set depth = $Select(L'="":4,K'="":3,J'="":2,1:1)
	Set data=""

	Set tName=$G(..DataArray(1,1,1,1))
	If $Case(tName,"MSH":1,"FHS":1,"BHS":1,:0) {
		If $Case(I,1:1,2:1,:0) {
			Set:I=1 data=tShowSeparators_..TC
			Set:I=2 data=$E(tShowSeparators,2,5)_..TC
			Set tCount=$O(..DataArray(""),-1)
			Set I=2
		}
		Else {
			Set I=I-1
		}
	}
	
	Set lasti=$O(..DataArray(""),-1)
	For i=I:1:lasti {
		Continue:(depth=1)&&(i<=I)
		Set:(i>1)&&'((i=I)&&(depth>1)) data=data_FS
		Set lastj=$O(..DataArray(i,""),-1)
		For j=1:1:lastj {
			Continue:(i=I)&&((j<J)||((depth=2)&&(j=J)))
			Set:(j>1)&&'((i=I)&&(j=J)&&(depth'=2)) data=data_RS
			Set lastk=$O(..DataArray(i,j,""),-1)
			For k=1:1:lastk {
				Continue:(i=I)&&(j=J)&&((k<K)||((depth=3)&&(k=K)))
				Set:(k>1)&&'((i=I)&&(j=J)&&(k=K)&&(depth'=3)) data=data_CS
				Set lastl=$O(..DataArray(i,j,k,""),-1)
				For l=1:1:lastl {
					Continue:(i=I)&&(j=J)&&(k=K)&&((l<L)||((depth=4)&&(l=L)))
					Set:l>1 data=data_SS
					Set value=$G(..DataArray(i,j,k,l))
					Set:tSeparators'=..Separators value=$E(..replaceSeparators(..Separators_value,tSeparators),6,*)
					Set data=data_value
				}
			}
		}
	}
	Quit data
}

Method Escape(pData) As %String
{
	Quit ..EscapeEx(pData,..Separators)
}

Method Unescape(pData) As %String
{
	Quit ..UnescapeEx(pData,..Separators)
}

ClassMethod EscapeEx(pData, pSeparators, pEscapeChar) As %String
{
	Set tEscape=$g(pEscapeChar,$$$ESCSEP(pSeparators))
	Set replace($C(10))=tEscape_"X0A"_tEscape
	Set replace($C(13))=tEscape_"X0D"_tEscape
	Set replace($$$FSSEP(pSeparators))=tEscape_"F"_tEscape
	Set replace($$$RSSEP(pSeparators))=tEscape_"R"_tEscape
	Set replace($$$CSSEP(pSeparators))=tEscape_"S"_tEscape
	Set replace($$$SSSEP(pSeparators))=tEscape_"T"_tEscape
	Set replace($$$ESCSEP(pSeparators))=tEscape_"E"_tEscape
	Quit $$replaceArray^EnsUtil(pData,.replace)
}

ClassMethod UnescapeEx(pData, pSeparators, pEscapeChar, ByRef pLastPos) As %String
{
	Set tEscape=$g(pEscapeChar,$$$ESCSEP(pSeparators))
	Set replace(tEscape_"X0A"_tEscape)=$c(10)
	Set replace(tEscape_"X0D"_tEscape)=$c(13)
	Set replace(tEscape_".br"_tEscape)=$C(13)
	Set replace(tEscape_"F"_tEscape)=$$$FSSEP(pSeparators)
	Set replace(tEscape_"R"_tEscape)=$$$RSSEP(pSeparators)
	Set replace(tEscape_"S"_tEscape)=$$$CSSEP(pSeparators)
	Set replace(tEscape_"T"_tEscape)=$$$SSSEP(pSeparators)
	Set replace(tEscape_"E"_tEscape)=$$$ESCSEP(pSeparators)
	Quit $$replaceArrayLeftToRight^EnsUtil(pData,.replace,5,.pLastPos)
}

/// Given a property path, determine the Field, Array, Component and Subcomponent positions
Method parsePropertyPath(pPropertyPath As %String, Output pField As %Integer, Output pArray As %Integer, Output pComponent As %Integer, Output pSubcomponent As %Integer) As %Status
{
	Set pField=$P($P(pPropertyPath,".",1),"(",1)
	Set pArray=$P($P($P(pPropertyPath,".",1),"(",2),")",1)
	Set pComponent=$P(pPropertyPath,".",2)
	Set pSubcomponent=$P(pPropertyPath,".",3)

	If pField'="",pField'="*",pField'=0,+pField'=pField {
		Set index=$ZCVT(pField_$S(pComponent="":"",1:"."_pComponent)_$S(pSubcomponent="":"",1:"."_pSubcomponent),"L")
		Set newspec=$S((..DocTypeCategory="")||(..DocTypeName=""):"", 1:$G($$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map",index)))
		If newspec="" Quit $$$ERROR($$$EnsErrGeneral,"PropertyPath '"_pPropertyPath_"' is invalid.")
		Set pField=$P($P(newspec,".",1),"(",1)
		Set pComponent=$P(newspec,".",2)
		Set pSubcomponent=$P(newspec,".",3)
	}
	If +pField=pField Set pField=pField+1
	If pArray="",pComponent'="" Set pArray=1
	Quit $$$OK
}

ClassMethod replaceSeparators(pInputData, oSeparators) As %String
{
	Set iSeparators=$e(pInputData,1,5)
	Set mSeparators=$c(1,2,3,4,5)
	set tData=$e(pInputData,6,*)
	Set tData=$tr(tData,iSeparators,mSeparators)
	Set tData=..UnescapeEx(tData,iSeparators,$$$ESCSEP(mSeparators))
	Set tData=..EscapeEx(tData,oSeparators,$$$ESCSEP(mSeparators))
	Quit oSeparators_$tr(tData,mSeparators,oSeparators)
}

/// Display Segment as HTML, using DocType info if available
Method OutputHTML() As %Status
{
	Set tSC=$$$OK
	&html<
	<table border="0" cellspacing="0" cellpadding="0" cols="2" width="100%"><tr><td align="left"><div class="Text" style="margin: 3px;">>
	If ""'=..DocType {
		Set tDesc=##class(EnsLib.HL7.Schema).GetDescription("SS:"_..DocType)
		&html<HL7 <b>#($ZCVT(..Name,"O","HTML"))#</b> Segment, DocType = '<a#($S(""=tDesc:"",1:" title='"_$ZCVT(tDesc,"O","HTML")_"'")_##class(EnsLib.HL7.Util.FormatHTMLv2).getSegLink(..DocType))#><b>#($ZCVT(..DocType,"O","HTML"))#</b></a>'
			<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#($S(""=tDesc:"", 1:"'<b><i>"_$ZCVT(tDesc,"O","HTML")_"</i></b>', "))#>
	} Else {
		&html<HL7 <b>#($ZCVT(..Name,"O","HTML"))#</b> Segment, DocType = <b>''</b>>
	}
	&html<</div></td></tr></table>>
	&html<<table class="EDIDocumentTable" BORDER="0" CELLSPACING="0" CELLPADDING="0">>
	&html<<TR CLASS="EDIDocumentTableRow"><TD CLASS="EDIDocumentTableExpandor">&nbsp;</TD>>
	Set tSC=..outputHTMLSeg()  Quit:$$$ISERR(tSC)
	&html<</TR>>
	&html<</table>>
	Write:$$$ISERR(tSC) $ZCVT($$$StatusDisplayString(tSC),"O","HTML")
	Quit tSC
}

/// Display Segment as HTML, using DocType info if available
Method OutputHTMLZen() As %Status
{
	Set tSC=$$$OK
	Set tSeg = $$$Text("Segment","EDIDocumentView")
	Set tTyp = $$$Text("DocType","EDIDocumentView")
	&html<
	<table border="0" cellspacing="0" cellpadding="0" cols="2" width="100%"><tr><td align="left"><div class="Text" style="margin: 3px;">>
	If ""'=..DocType {
		Set tDesc=##class(EnsLib.HL7.Schema).GetDescription("SS:"_..DocType)
		&html<HL7 <b>#($ZCVT(..Name,"O","HTML"))#</b> #(tSeg)#, #(tTyp)# = '<a#($S(""=tDesc:"",1:" title='"_$ZCVT(tDesc,"O","HTML")_"'")_##class(EnsLib.HL7.Util.FormatHTMLv2Zen).getSegLink(..DocType))#><b>#($ZCVT(..DocType,"O","HTML"))#</b></a>'
			<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#($S(""=tDesc:"", 1:"'<b><i>"_$ZCVT(tDesc,"O","HTML")_"</i></b>', "))#>
	} Else {
		&html<HL7 <b>#($ZCVT(..Name,"O","HTML"))#</b> #(tSeg)#, #(tTyp)# = <b>''</b>>
	}
	&html<</div></td></tr></table>>
	&html<<table class="EDIDocumentTable" BORDER="0" CELLSPACING="0" CELLPADDING="0">>
	&html<<TR CLASS="EDIDocumentTableRow"><TD CLASS="EDIDocumentTableExpandor">&nbsp;</TD>>
	Set tSC=..outputHTMLSegZen()  Quit:$$$ISERR(tSC)
	&html<</TR>>
	&html<</table>>
	Write:$$$ISERR(tSC) $ZCVT($$$StatusDisplayString(tSC),"O","HTML")
	Quit tSC
}

Method DumpMaps() As %Status
{
	Set DocType=..DocType w ! zw DocType
	Set ID=..ID w ! zw ID
	If ..DocTypeCategory'="",..DocTypeName'=""	Merge MapArray=$$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map") w ! zw MapArray
	Merge DataArray=..DataArray w ! zw DataArray
	Quit $$$OK
}

/// Deprecated - to be removed - only used by deprecated toEasyXML
ClassMethod buildSchema(pType As %String, pTag As %String, ByRef schema) As %Status
{
	Set pCategory = $P(pTag,":")
	Set pName = $P(pTag,":",2)

	Set schema(pType,pTag) = $G($$$vaSchemaGbl(pCategory,pType,pName))
	Quit:schema(pType,pTag)="" $$$ERROR($$$EnsErrGeneral,"No schema for segment '"_pName_"' in "_pType)

	// Build a reverse index, keyed by field number
	Set name=""  For { Set name=$O($$$vaSchemaGbl(pCategory,pType,pName,"names",name),1,i)  Quit:""=name
		Set schema(pType,pTag,i)=name
	}
	Quit $$$OK
}

/// Deprecated - to be removed
Method toEasyXML(ByRef xml As %String, id As %Integer, baseDocType As %String, ByRef schema = "", pToDevice As %Boolean = 0) As %Status [ Internal ]
{
#define APPEND(%x,%s) If +$G(pToDevice) { Write %s,! } Else { Do %x.WriteLine(%s) }
#define BLDSCHEMA(%t,%x,%s) Do:'$D(%s(%t,%x)) ..buildSchema(%t,%x,.%s)
#define SETTYPE(%l,%r,%b) Set %l=$S(%r[":":%r,1:%b_":"_%r)

	Set:..DocType="" ..DocType=baseDocType_":"_..Name
	$$$SETTYPE(sstype,..DocType,baseDocType)
	Set sstag   = $ZCVT($P(sstype,":",2),"O","XML")
	Set type    = $ZCVT($P(sstype,":"),"O","XML")

	$$$BLDSCHEMA("SS",sstype,schema)

	$$$APPEND(xml,"<"_sstag_" docType="""_type_""">")

	Set pData = $$$vaSegment(..ID)	
	Set FS=$E(pData,1), CS=$E(pData,2), RS=$E(pData,3), ESC=$E(pData,4), SS=$E(pData,5), data1=$E(pData,6,*)
	Set offset = $S(..Name="MSH":0,1:1)
	For i=1+offset:1:$L(data1,FS) {

		Set idx = i - offset

		// Process each field in turn
		Set data2=$P(data1,FS,i)
		If data2'="" {
			// Generate a wrapping tag for this field
			If $D(schema("SS",sstype,idx)) {
				Set fstag  = $ZCVT(schema("SS",sstype,idx),"O","XML")
				Set fsinfo = $LI(schema("SS",sstype),idx)
			} Else {
				Set fstag = sstag_"."_idx
				Set fsinfo = ""
			}

			If $LG(fsinfo,1)'="" {
				// Dig up the information for the component
				$$$SETTYPE(cstype,$LI(fsinfo,1),baseDocType)
				$$$BLDSCHEMA("DT",cstype,schema)
				Set csinfo = schema("DT",cstype)
			} Else {
				Set (cstype,csinfo)=""
			}

			// Now, look for repetitions
			For j=1:1:$L(data2,RS) {
				// Process each repetition
				Set data3=$P(data2,RS,j)
				If data3="" Continue

				If $G(cstype)'="" {
					$$$APPEND(xml,"<"_fstag_">")

					// Process each component
					For k=1:1:$L(data3,CS) {
						Set data4=$P(data3,CS,k)
						If data4="" Continue

						If $LG(csinfo,k)'="" {
							$$$SETTYPE(sctype,$LI(csinfo,k),baseDocType)
							$$$BLDSCHEMA("DS",sctype,schema)
						} Else {
							Set sctype=""
						}

						Set cstag = $ZCVT($G(schema("DT",$G(cstype,-1),k),"CS"_k),"O","XML")
						If $G(sctype)'="",data4[SS {
							$$$APPEND(xml,"<"_cstag_">")
							For l=1:1:$L(data4,SS) {
								Set data5=$P(data4,SS,l)
								If data5="" Continue

								Set sctag = $ZCVT($G(schema("DT",$G(sctype,-1),l),"SS"_l),"O","XML")
								$$$APPEND(xml,"<"_sctag_">"_$ZCVT(data5,"O","XML")_"</"_sctag_">")
							}
							$$$APPEND(xml,"</"_cstag_">")
						} Else {
							$$$APPEND(xml,"<"_cstag_">"_$ZCVT(data4,"O","XML")_"</"_cstag_">")
						}
					}
					$$$APPEND(xml,"</"_fstag_">")
				} Else {
					$$$APPEND(xml,"<"_fstag_">"_$ZCVT(data3,"O","XML")_"</"_fstag_">")
				}
			}
		}
	}
	$$$APPEND(xml,"</"_sstag_">")
}

ClassMethod GetContentArray(Output pContents, pMode As %String, pDocType As %String, pLevel As %Integer, pIncludeBase As %Boolean = 0) As %Status
{
	Set tRef=$G(pContents)
	If ("%"=$E(tRef)||("^"=$E(tRef))) {
		Set tSC=##class(EnsLib.HL7.Schema).getFieldsContentArray(.local,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
		Merge @tRef=local
		Quit tSC
	} Else {
		Quit ##class(EnsLib.HL7.Schema).getFieldsContentArray(.pContents,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
	}
}

/// Returns a list of available DocTypes for this document class. <br/>
/// The DocType is returned as the first column in the result set. <br/>
/// The <var>Category</var> parameter can be used to restrict the list. <br/>
/// If <var>Category</var> is: <br/>
///  0 - return only DocTypes in standard categories <br/>
///  + - return only DocTypes in user-defined categories <br/>
///  empty - return DocTypes from all categories <br/>
///  a category name - return only DocTypes in the named category <br/>
///  a partial name suffixed with '%' - return only DocTypes in categories matching the partial category name <br/>
///  other - return nothing <br/>
/// If <var>IncludeBase</var> is: <br/>
///  0 - return only DocTypes defined in the current schema category itself <br/>
///  1 - return all DocTypes in the current schema category's base category in addition to those defined in the current category itself <br/>
Query EnumerateDocTypes(Category As %String = "", IncludeBase As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "Type:%String")
{
}

ClassMethod EnumerateDocTypesExecute(ByRef qHandle As %Binary, Category As %String, IncludeBase As %Boolean) As %Status [ CodeMode = expression ]
{
##class(EnsLib.HL7.Schema).SegTypesExecute(.qHandle,.Category,0,.IncludeBase)
}

ClassMethod EnumerateDocTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EnumerateDocTypesExecute ]
{
	Set tSC=##class(EnsLib.HL7.Schema).SegTypesFetch(.qHandle,.Row,.AtEnd)
	Set:""'=$G(Row) Row=$LB($LG(Row))
	Quit tSC
}

ClassMethod EnumerateDocTypesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateDocTypesExecute ]
{
##class(EnsLib.HL7.Schema).SegTypesClose(.qHandle)
}

/// Returns a list of document type schema categories for the document class.<br>
/// The Standard parameter can be used to restrict the list.<br>
/// If Standard is:
///  0 - return only standard categories
///  + - return only user-defined categories
///  empty - return all categories
///  a partial category name - return only categories starting with the given category name part<br/>
///  other - return nothing
Query EnumerateTypeCategories(Standard As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "Category:%String,Description:%String,IsStandard:%Boolean,Base:%String")
{
}

ClassMethod EnumerateTypeCategoriesExecute(ByRef qHandle As %Binary, Standard As %String = "") As %Status [ CodeMode = expression ]
{
##class(EnsLib.HL7.Schema).TypeCategoriesExecute(.qHandle, Standard)
}

ClassMethod EnumerateTypeCategoriesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EnumerateTypeCategoriesExecute ]
{
	Set tSC=##class(EnsLib.HL7.Schema).TypeCategoriesFetch(.qHandle,.Row,.AtEnd)
	Quit tSC
}

ClassMethod EnumerateTypeCategoriesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateTypeCategoriesExecute ]
{
##class(EnsLib.HL7.Schema).TypeCategoriesClose(.qHandle)
}

}
