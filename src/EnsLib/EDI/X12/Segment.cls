/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIX12

Class EnsLib.EDI.X12.Segment Extends (%RegisteredObject, EnsLib.EDI.Segment) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

/// Data-element separator character
Property ES As %String [ Calculated ];

/// Sub-element component separator character
Property CS As %String [ Calculated ];

/// Repetition separator character
Property RS As %String [ Calculated ];

/// All 3 Separators as a single String
Property Separators As %String(MAXLEN = 3, MINLEN = 3) [ InitialExpression = {$$$X12DefSeparators} ];

/// Segment serminator character(s) if we are an ISA and it came with any
Property ISASegmentTerminator As %String;

/// Local copy of segment data decomposed into multidimensional array
Property DataArray [ Internal, MultiDimensional ];

/// the Category portion of the DocType
Property DocTypeCategory As %String [ ReadOnly ];

/// the TransactionSet portion of the DocType
Property DocTypeValTS As %String [ Internal, ReadOnly ];

/// the Name portion of the DocType ( name [ ! required fields] )
Property DocTypeName As %String [ ReadOnly ];

/// Size in bytes of the segment content (even if >32k)
Property FullSize As %Integer [ Calculated, ReadOnly ];

/// Were we cloned from another Segment object? (If so, we won't be responsible for deleting the underlying segment ID data node if any)
Property %Cloned As %Boolean [ Internal, ReadOnly ];

Parameter ESCascii As %Integer = 27;

Property ESC As %String [ ReadOnly ];

Parameter ChildLinks = 10;

Method PokeDocType(pDocType As %String) As %Status [ CodeMode = expression ]
{
..DocTypeSet(pDocType)
}

Method DocTypeSet(pDocType As %String) As %Status
{
	Set i%DocType=pDocType
	Set i%DocTypeCategory=$P(i%DocType,":",1)
	Set i%DocTypeName=$P(i%DocType,":",2)
	Set tNameOld=$P(i%DocType,":",3)
	Set:""'=tNameOld i%DocTypeValTS=i%DocTypeName, i%DocTypeName=tNameOld
	Quit $$$OK
}

Method ESGet() As %String [ CodeMode = expression ]
{
$$$ELESEP(..Separators)
}

Method CSGet() As %String [ CodeMode = expression ]
{
$$$COMSEP(..Separators)
}

Method RSGet() As %String [ CodeMode = expression ]
{
$$$REPSEP(..Separators)
}

Method ESSet(newval) As %Status
{
	Set $$$ELESEP(i%Separators)=$E(newval_$$$X12DefElementSeparator)
	Quit $$$OK
}

Method CSSet(newval) As %Status
{
	Set $$$COMSEP(i%Separators)=$E(newval_$$$X12DefComponentSeparator)
	Quit $$$OK
}

Method RSSet(newval) As %Status
{
	Set $$$REPSEP(i%Separators)=$E(newval_$$$X12DefRepetitionSeparator)
	Quit $$$OK
}

Method SeparatorsSet(newvalue As %String) As %Status
{
	Set i%Separators=$S(""=newvalue:$$$X12DefSeparators, 1:$E(newvalue_$C(17,18),1,3))
	Quit $$$OK
}

Method FullSizeGet() As %String
{
	Set data=..GetValueAt("")
	If data=""||(..ID="")||$D(..DataArray)||'$D($$$vaSegmentGbl(..ID,1)) {
		Set len=$L(data)
	} Else {
		Set len=$L(data)
		For i=1:1 { Quit:'$D($$$vaSegmentGbl(..ID,i),data)
			Set len=len+$L(data)
		}
	}
	Quit len
}

Method init(pSegID As %String, pMutable As %Boolean, pDocType As %String, pSegData As %String) As %Status
{
	Set i%ESC=$C(..#ESCascii)
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
	Set data=$G($$$vaSegmentGbl(pSegID))
	Quit:""=data $$$ERROR($$$EnsErrGeneral,"Segment "_pSegID_" does not exist")
	Set i%ID=pSegID, i%IsMutable=+pMutable, i%%Cloned=''pSegData
	Set ..Separators=data
	Set ..ISASegmentTerminator=$G($$$vaSegmentGbl(pSegID,"term"))
	Quit $$$OK
}

Method %OnConstructClone(object As %RegisteredObject, deep As %Boolean = 0, ByRef cloned As %String) As %Status [ Private ]
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
		Set tIndex=$I($$$vaSegmentGbl)
		Set $$$vaSegmentGbl(tIndex)=$E(tSeparators,1,3)_..getAtFromArray("",tSeparators)
		Set $$$vaOpenSegmentPPG(tIndex) = 1
		Set tSegTerminator=$$$SEGTERM(tSeparators) Set:""=tSegTerminator tSegTerminator=..ISASegmentTerminator
		Set:""'=tSegTerminator $$$vaSegmentGbl(tIndex,"term")=tSegTerminator, ..ISASegmentTerminator = tSegTerminator
		Set i%ID=tIndex, i%IsMutable=0, i%%Cloned=0
	} Else { $$$ASSERT(+..ID=..ID&&(..ID>0)) }
	Quit $$$OK
}

Method OutputToDevice(pSeparators As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String) As %Status
{
	Set tDeviceStream=##class(%IO.DeviceStream).AttachNew(,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ..OutputToIOStream(tDeviceStream, .pSeparators, .pSegNum, .pSegPath, .pParentDoc, .pIOFormatClassname)
}

Method OutputToLibraryStream(pLibStream As %Stream.Object, pSeparators As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String) As %Status
{
	Set tIOStream=$S(pLibStream.%Extends("%IO.I.CharacterStream"):pLibStream,1:##Class(%IO.MetaCharacterStream).%New(pLibStream))
	Quit ..OutputToIOStream(tIOStream, .pSeparators, .pSegNum, .pSegPath, .pParentDoc, .pIOFormatClassname)
}

Method OutputToString(pSeparators As %String, Output pStatus As %Status, pCharEncoding As %String = "", pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String) As %String
{
	Set tIOStream=##Class(%IO.StringStream).%New()
	Set:""'=pCharEncoding tIOStream.CharEncoding=pCharEncoding
	Set pStatus = ..OutputToIOStream(tIOStream, .pSeparators, .pSegNum, .pSegPath, .pParentDoc, .pIOFormatClassname)
	Do tIOStream.Rewind()
	Quit tIOStream.Read()
}

/// Convert segments back to Stream
Method OutputToIOStream(pIOStream As %IO.I.CharacterStream, pSeparators As %String, pSegNum As %String, pSegPath As %String, pParentDoc As EnsLib.EDI.Document, pIOFormatClassname As %String = "") As %Status
{
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:pSeparators)
	Quit:""'=pIOFormatClassname&&$classmethod(pIOFormatClassname,"OutputSegment",$this,.tSC,pIOStream,tSeparators,.pSegPath,.pParentDoc) tSC

	Set tSegTerminator=$S(""=$G(pSeparators):"", 1:$$$SEGTERM(pSeparators))
	Set:""=tSegTerminator tSegTerminator=..ISASegmentTerminator  Set:""=tSegTerminator tSegTerminator=$$$X12DefSegTerminator
	Set data=..GetValueAt("",.pSeparators)
	If data'="" {
		If (..ID="")||$D(..DataArray)||'$D($$$vaSegmentGbl(..ID,1)) {
			Do pIOStream.Write(data_tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
		} Else {
			Do pIOStream.Write(data,0,.tSC)  Quit:$$$ISERR(tSC) tSC
			For i=1:1 { Quit:'$D($$$vaSegmentGbl(..ID,i),data)
				Do pIOStream.Write(data,0,.tSC)  Quit:$$$ISERR(tSC)
			}
			Quit:$$$ISERR(tSC) tSC
			Do pIOStream.Write(tSegTerminator,0,.tSC)  Quit:$$$ISERR(tSC) tSC
		}
	}
	Quit $$$OK
}

Method outputHTMLSeg(pSeparators As %String, pSegNum As %String = "", pSegPath As %String = "", pDocument As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit ..OutputToDevice(.pSeparators,,pSegNum,pSegPath,pDocument,"EnsLib.EDI.X12.Util.FormatHTML")
}

Method outputHTMLSegZen(pSeparators As %String, pSegNum As %String = "", pSegPath As %String = "", pDocument As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit ..OutputToDevice(.pSeparators,,pSegNum,pSegPath,pDocument,"EnsLib.EDI.X12.Util.FormatHTMLZen")
}

ClassMethod ImportFromString(pString As %String, Output pStatus As %Status, pSeparators As %String, ByRef pConfigItem As %String = "", pIOFormatClassname As %String) As EnsLib.EDI.X12.Segment
{
	If ""'=$G(pIOFormatClassname) {
		Set tIOStream=##Class(%IO.StringStream).%New(pString)
		Set tSeg=..ImportFromIOStream(tIOStream,.pStatus,.pSeparators,.pIOFormatClassname)
		Quit:$$$IsdefObject(tSeg)||$$$ISERR(pStatus) $G(tSeg)
		// Else assume it abdicated and continue to decomposeData()
	}
	Set tSeg=..%New()
	Set tSeparators=$S(""=$G(pSeparators):tSeg.Separators, 1:pSeparators)
	Set pStatus=tSeg.decomposeData(tSeparators_pString)
	Quit:$$$ISERR(pStatus) $$$NULLOREF
	Quit tSeg
}

ClassMethod ImportFromIOStream(pIOStream As %IO.I.CharacterStream, Output pStatus As %Status = {$$$OK}, pSeparators As %String, pIOFormatClassname As %String = "") As EnsLib.EDI.X12.Document
{
	Quit:""'=pIOFormatClassname&&$classmethod(pIOFormatClassname,"ImportSegment",.tSeg,.pStatus,pIOStream,.pSeparators) tSeg
	Set tString=pIOStream.Read()
	Quit ..ImportFromString(tString,.pStatus,.pSeparators)
}

/// Read a field from a >32k segment, or the whole segment, into a stream. Note that this will return the entire remainder of the segment, not stopping at the end of the field specified in pPropertyPath
Method ReadRawDataStream(ByRef pStream As %Stream.Object, pPropertyPath As %String = "") As %Status
{
	Set:'$$$IsdefObject(pStream) pStream=$zobjclassmethod($S(""'=$G(pStream):pStream, 1:"%Library.GlobalCharacterStream"),"%New")

	Set tMarker=..GetValueAt(pPropertyPath,,.tSC)  Quit:$$$ISERR(tSC) tSC
	If pStream.%Extends("%IO.I.Stream") {
		Do pStream.Write(tMarker,.tSC)  Quit:$$$ISERR(tSC) tSC
	} Else {
		Set tSC=pStream.Write(tMarker)  Quit:$$$ISERR(tSC) tSC
	}
	Set data0=$S(""=..ID:".", 1:$$$vaSegmentGbl(..ID))
	Quit:""=..ID||($F(data0,tMarker,6)-1<$L(data0)) tSC
	For i=1:1 { Quit:'$D($$$vaSegmentGbl(..ID,i),data)
		If pStream.%Extends("%IO.I.Stream") {
			Do pStream.Write(data,.tSC)  Quit:$$$ISERR(tSC)
		} Else {
			Set tSC=pStream.Write(data)  Quit:$$$ISERR(tSC)
		}
	}
	Quit tSC
}

/// Write a >32k field or whole segment stream to a segment. Note that this renders the segment immutable after completing, and therefore works only once per segment.
Method StoreRawDataStream(pStream As %Stream.Object, pPropertyPath As %String = "") As %Status
{
	#define MAXSEGSTR	32767
	Set tSC=$$$OK, i=0, tMarker=..ESC_".stream"_..ESC
	If pStream.%Extends("%IO.I.Stream") {
		Set chunk=pStream.Read($$$MAXSEGSTR,,.tSC)  Quit:$$$ISERR(tSC) tSC
	} Else {
		Set chunk=pStream.Read($$$MAXSEGSTR,.tSC)  Quit:$$$ISERR(tSC) tSC
	}
	Set tSC=..SetValueAt(tMarker,pPropertyPath)  Quit:$$$ISERR(tSC) tSC
	Set tSC=..SaveData()  Quit:$$$ISERR(tSC) tSC
	Kill ..DataArray
	Set data=$$$vaSegmentGbl(..ID)
	Set pos=$F(data,tMarker,6) Quit:'pos $$$ERROR($$$EnsErrGeneral,"Unable find stream store location in segment")
	Set data2=$E(data,pos,*)

	Set chunkpos=pos-$L(tMarker), chunkmax=$$$MAXSEGSTR-(chunkpos-1)
	Set $E($$$vaSegmentGbl(..ID),chunkpos,$L(data))=$E(chunk,1,chunkmax)

	Set i=0,prevchunk="",tLast2=0 For {
		Set:""=chunk&&'tLast2 tLast2=1
		Set chunk=$S(chunkmax-$L(prevchunk)>$L(chunk):"", 1:$E(chunk,chunkmax-$L(prevchunk)+1,*))
		Set chunkpos=$L($S('i:$$$vaSegmentGbl(..ID),1:$$$vaSegmentGbl(..ID,i)))+1
		If chunkpos>$$$MAXSEGSTR { Set i=i+1, chunkpos=1, chunkmax=$$$MAXSEGSTR }
		Else { Set chunkmax=$$$MAXSEGSTR-(chunkpos-1) }
		
		If tLast2 {
			Set prevchunk=""
			Quit:data2_chunk=""
			Set:data2'="" chunk=data2, data2=""
		} Else {
			Set prevchunk=chunk
			If pStream.%Extends("%IO.I.Stream") {
				Set chunk=pStream.Read($$$MAXSEGSTR,,.tSC)  Quit:$$$ISERR(tSC)
			} Else {
				Set chunk=pStream.Read($$$MAXSEGSTR,.tSC)  Quit:$$$ISERR(tSC)
			}
		}
		If 'i {
			Set $$$vaSegmentGbl(..ID)=$$$vaSegmentGbl(..ID)_prevchunk_$E(chunk,1,chunkmax-$L(prevchunk))
		} Else {
			Set $$$vaSegmentGbl(..ID,i)=$G($$$vaSegmentGbl(..ID,i))_prevchunk_$E(chunk,1,chunkmax-$L(prevchunk))
		}
	}
	Quit tSC
}

/// pPropertyPath is of syntax: element [ ( array ) ] [ . component ]
/// Returns the value at the specified property path. pSeparators is used to specify the
/// separators to be used when a non-atomic value is returned.
/// All property path elements must be either name or index.<br>
/// When retrieving full segment data any trailing Data Element, Component Element or Repetition Separators will be removed unless the segment is ISA.
Method GetValueAt(pPropertyPath As %String, pSeparators As %String, Output pStatus As %Status, pTreatEmptyAsNull As %Boolean = 0) As %String
{
	#dim data
	If (..ID="")||$D(..DataArray) {
		Set data = ..getAtFromArray(.pPropertyPath,.pSeparators,.pStatus,pTreatEmptyAsNull)
	} Else {
		Set data = ..getAtFromGlobal(.pPropertyPath,.pSeparators,.pStatus,pTreatEmptyAsNull)
	}
	#; Whole segment - simplify checking for ISA (getAt methods already stripped leading separators)
	If (pPropertyPath="")&&(data'="")&&($E(data,1,3)'="ISA") {
		Return ..removeTrailingSeparators(data,.pSeparators)
	} Else {
		Return data
	}
}

/// Remove any trailing Separators from data
Method removeTrailingSeparators(pData As %String, pSeparators As %String) As %String [ Internal ]
{
	#dim tModifiedData = pData
	Try {
		#dim tSeparators=$S(""=$G(pSeparators):..Separators, 1:$E(pSeparators,1,3))
		While (tModifiedData'="") && (tSeparators[($Extract(tModifiedData,*))) {
			Set $Extract(tModifiedData,*) = ""
		}
	} Catch {
		Set tModifiedData = pData
	}
	Return tModifiedData
}

/// Gets the next index in an array
Method GetNextIndex(pPath As %String, pIndex As %String, ByRef pStatus As %Status = {$$$OK}) As %String
{
	If $E(pPath,*-1,*)'="()" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't iterate on PropertyPath '"_pPath_"'")  Quit ""
	Set field=$E(pPath,1,*-2)
	If +field'=field {
		If field="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't iterate on empty PropertyPath")  Quit ""
		Set field=$S((..DocTypeCategory="")||(..DocTypeName=""):"", ..DocTypeValTS="":$G($$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map",$ZCVT(field,"L"))), 1:$G($$$vaVSchemaGbl(..DocTypeCategory,..DocTypeValTS,..DocTypeName,"map",$ZCVT(field,"L"))))
		If $E(field,*-1,*)'="()" Set pStatus=$$$ERROR($$$EnsErrGeneral,"PropertyPath '"_field_"' is not an array property")  Quit ""
		Set field=$E(field,1,*-2)
		If +field'=field Set pStatus=$$$ERROR($$$EnsErrGeneral,"Unrecognized Property Index '"_field_"'")  Quit ""
	}
	If '$D(..DataArray) Set pStatus=..decompose() Quit:$$$ISERR(pStatus) ""
	Quit $O(..DataArray(field+1,pIndex))
}

/// Sets the value at the specified property path.
/// pPropertyPath is of syntax: element [ ( array ) ] [ . component ]
/// All property path elements must be either name or index. pKey is used to append an array index to the value at
/// the given property path. pAction corresponds to the actions in the DTL <assign> statement.
/// If a segment's total length is more than 32760 or will be after setting the value, then this method can't be used. Instead, use one of the methods StoreFieldStreamRaw(), StoreFieldStreamEscaped() or StoreFieldStreamBase64()
Method SetValueAt(pValue As %String, pPropertyPath As %String = "", pAction As %String = "set", pKey As %String = "") As %Status
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Segment is immutable")
	Set:$Case(pAction,"remove":1,"clear":1,:'($D(pValue)#2)) pValue=""
	If '$D(..DataArray) Set tSC=..decompose()  Quit:$$$ISERR(tSC) tSC
	Set i%ID="" ; clear the ID because we are no longer referring to it
	If pKey'="" Set pPropertyPath=pPropertyPath_"("_pKey_")"
	Set tSC=..parsePropertyPath(pPropertyPath,.field,.array,.component)  Quit:$$$ISERR(tSC) tSC

	#; TODO: support BDS segs, >32k BIN data, Stream Append, GetBinaryStreamAt(), >32k OutputToDevice
	#; Special test for BIN segment values
	if field>1||(""=field) {
		set tName=$G(..DataArray(1,1,1))
		If tName="BIN" {
			If field=3 {
				If $IsObject(pValue) && pValue.%Extends("%Stream.Object") {
					Set len=pValue.Size, ..DataArray(2,1,1)=len
					Do pValue.Rewind()
					Set ..DataArray(3,1,1)=pValue.Read(len), len=len-$L(..DataArray(3,1,1))
					While len>0 {
						Set i=$I(i), ..DataArray(3,1,1,i)=pValue.Read(len), len=len-$L(..DataArray(3,1,1,i))
					}
				} Else {
					If pAction="append" {
						Set ..DataArray(3,1,1)=..DataArray(3,1,1)_pValue
						Set ..DataArray(2,1,1)=..DataArray(2,1,1)+$L(pValue)
					} Else {
						Set ..DataArray(2,1,1)=$L(pValue)
						Set ..DataArray(3,1,1)=pValue
					}
				}
				Quit $$$OK
			}
		} Elseif tName="BDS" {
			If field=4 {
			}
			Quit $$$OK
		}
	}
	#; now the regular stuff
	Set data=pValue
	If field="" {
		Kill:pAction'="append" ..DataArray
		Set data1=data
		For i=1:1:$L(data1,..ES) { Set data2=$P(data1,..ES,i)
			For j=1:1:$L(data2,..RS) { Set data3=$P(data2,..RS,j)
				For k=1:1:$L(data3,..CS) { Set ..DataArray(i,j,k)=$S(pAction="append":$G(..DataArray(i,j,k)),1:"")_$P(data3,..CS,k) }
			}
		}
	} ElseIf array="" {
		Kill:pAction'="append" ..DataArray(field)
		Set data2=data
		For j=1:1:$L(data2,..RS) { Set data3=$P(data2,..RS,j)
			For k=1:1:$L(data3,..CS) { Set ..DataArray(field,j,k)=$S(pAction="append":$G(..DataArray(field,j,k)),1:"")_$P(data3,..CS,k) }
		}
	} ElseIf component="" {
		Kill:pAction'="append" ..DataArray(field,array)
		Set data3=data
		For k=1:1:$L(data3,..CS) { Set ..DataArray(field,array,k)=$S(pAction="append":$G(..DataArray(field,array,k)),1:"")_$P(data3,..CS,k) }
	} Else {
		Set ..DataArray(field,array,component)=$S(pAction="append":$G(..DataArray(field,array,component)),1:"")_data
	}
	Quit $$$OK
}

Method GetBinaryStreamAt(ByRef pStream As %Stream, pPath As %String) As %Status
{
	Set tValue=""
	#; Parse the path and determine postion
	Set tSC=..parsePropertyPath(pPath,.tField,.tArray,.tComponent) If $$$ISERR(tSC) Quit tSC

	#; Pick out the value
	Set tValue=$Get(..DataArray(tField,1,1))
	do pStream.Write(tValue)
	Quit $$$OK
}

Method CopyValues(pSource As EnsLib.EDI.X12.Segment, pSourcePath As %String, pTargetPath As %String, pAction As %String, pKey As %String, pEmptyFieldAsNull As %Boolean = 0, pIgnoreMissingSource As %Boolean = 0) As %Status
{
	Set tSC=$$$OK
	Set tSourceWild=$F(pSourcePath,"()"), tTargetWild=$F(pTargetPath,"()")
	If tSourceWild||tTargetWild {
		Set tSourceHead=$P(pSourcePath,"()"), tSourceTail=$P(pSourcePath,"()",2,*)
		Set tTargetHead=$P(pTargetPath,"()"), tTargetTail=$P(pTargetPath,"()",2,*)
		If tSourceWild {
			If pEmptyFieldAsNull&&TargetWild {
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
$S($D(..DataArray):$$$ERROR($$$EnsErrGeneral,"array data already exists"), ""=..ID:$$$OK, 1:..decomposeData($$$vaSegmentGbl(..ID)))
}

Method decomposeData(pData As %String) As %Status
{
	Set ES=$$$ELESEP(pData), RS=$$$REPSEP(pData), CS=$$$COMSEP(pData), data1=$E(pData,4,*)

	Set tName=$P(data1,ES,1)
	Quit:tName="BIN"||(tName="BDS") $$decomposeBinary()

	For i=1:1:$L(data1,ES) {
		Set data2=$P(data1,ES,i)
		If tName="ISA"&&((i=($$$ISAInterchangeControlStandardsI+1))||(i=($$$ISAComponentElementSeparator+1))) {
			Set ..DataArray(i,1,1)=data2 ; don't try to decompose repeat & component separators
			Continue
		}
		For j=1:1:$L(data2,RS) { Set data3=$P(data2,RS,j)
			For k=1:1:$L(data3,CS) { Set ..DataArray(i,j,k)=$P(data3,CS,k) }
		}
	}
	Quit $$$OK

decomposeBinary() ; Decompose a known Binary Segment
	If tName="BIN" {
		Set ..DataArray(1,1,1)=tName
		set s=$L(tName)+2, f=$F(data1,ES,s)
		Set ..DataArray(2,1,1)=$E(data1,s,f-2)
		Set ..DataArray(3,1,1)=$E(data1,f,$L(data1))
	} elseif tName="BDS" {
		Set ..DataArray(1,1,1)=tName
		set s=$L(tName)+2, f=$F(data1,ES,s)
		Set ..DataArray(2,1,1)=$E(data1,s,f-2)
		set s=f, f=$F(data1,ES,s)
		Set ..DataArray(3,1,1)=$E(data1,s,f-2)
		Set ..DataArray(4,1,1)=$E(data1,f,$L(data1))
	} else {
		$$$ASSERT("0:Unknown Binary seg")
	}
	Quit $$$OK
}

Method getAtFromGlobal(pPropertyPath As %String = "", pSeparators As %String, Output pStatus As %Status, pTreatEmptyAsNull As %Boolean = 0) As %String
{
	Set data=$$$vaSegmentGbl(..ID)
	If ""=$G(pSeparators) { Set tSeparators=$E(data,1,3), ES=$$$ELESEP(tSeparators), data=$E(data,4,*) }
	Else {
		Set tSeparators=$E(pSeparators,1,3)_$E($C(17,0),$L(pSeparators),2), ES=$$$ELESEP(tSeparators)
		If $E(data,1,3)'=tSeparators {
			Set data=..replaceSeparators(data,tSeparators), data=$E(data,4,*) 
			If ""=pPropertyPath&&("ISA"=$P(data,ES)) {
				Set RS=$$$REPSEP(tSeparators), tRs=$P(data,ES,12), $P(data,ES,12)=$S(tRs?1(1A,1N):tRs, 1:RS) ; show original data if not legal separator; otherwise separator
				Set CS=$$$COMSEP(tSeparators), $P(data,ES,17)=$S($C(17)=CS:"", 1:CS)
			}
		} Else { Set data=$E(data,4,*) }
	}
	If ""=pPropertyPath Set pStatus=$$$OK  Quit data
	Set pStatus=..parsePropertyPath(pPropertyPath,.field,.array,.component)  Quit:$$$ISERR(pStatus) ""
	Set CS=$$$COMSEP(tSeparators), RS=$$$REPSEP(tSeparators)
	If "ISA"=$P(data,ES) {
		Quit:field=1 "ISA"
		If field=12 Set tRs=$P(data,ES,12)  Quit $S(tRs?1(1A,1N):tRs, 1:RS) ; show original data if not legal separator; otherwise separator
		Quit:field=17 $S($C(17)=CS:"", 1:CS)
	}
	Set tLastFieldNull = (pTreatEmptyAsNull && ($P(data,ES,*)=""))
	Set tFieldCount = $L(data,ES) - 1 - tLastFieldNull
	If field'="" {
		Set data=$S(field="*":tFieldCount,1:$P(data,ES,field))
	}
	Set tRepsCount = $S((field-1) > tFieldCount : 0, pTreatEmptyAsNull&&(data="") : 0, 1:$L(data,RS))
	If array'="" {
		Set data=$S(array="*":tRepsCount,1:$P(data,RS,array))
	}
	If component'="" {
		If component="*" {
			Set data = $S(array > tRepsCount : 0, 1:$L(data,CS))
		} Else {
			Set data = $P(data,CS,component)
		}
	}
	Quit data
}

Method getAtFromArray(pPropertyPath As %String = "", pSeparators As %String, Output pStatus As %Status, pEmptyFieldAsNull As %Boolean = 0) As %String
{
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:$E(pSeparators,1,3))
	Set ES=$$$ELESEP(tSeparators), CS=$$$COMSEP(tSeparators), RS=$$$REPSEP(tSeparators)
	Set pStatus=..parsePropertyPath(pPropertyPath,.I,.J,.K) Quit:$$$ISERR(pStatus) ""
	If "ISA"=$G(..DataArray(1,1,1)) {
		Quit:I=1 "ISA"
		If I=12 Set tRs=$G(..DataArray(12,1,1))  Quit $S(tRs?1(1A,1N):tRs, 1:RS) ; show original data if not legal separator; otherwise separator
		Quit:I=17 $S($C(17)=CS:"", 1:CS)
		If I="" {
			Set data="ISA", tCount=$O(..DataArray(""),-1)-1
			For i=1:1:tCount Set data=data_ES_..getAtFromArray(i,tSeparators)
			Quit data
		}
	}
	Set lasti=$O(..DataArray(""),-1)
	If I="*" {
		Set data=lasti-1
		If pEmptyFieldAsNull && (..GetValueAt(data)="") {
			Set data = data - 1
		}
	} Else {
		Set data=""
		For i=1:1:lasti {
			If I'="",i'=I Continue
			If I="",i>1 Set data=data_ES
			Set lastj=$O(..DataArray(i,""),-1)
			If J="*" {
				Set data=lastj
				Quit:(lastj>1)||'pEmptyFieldAsNull
				Set data = $S(..GetValueAt(i-1)="":0,1:1)
				Quit
			}
			For j=1:1:lastj {
				If J'="",j'=J Continue
				If J="",j>1 Set data=data_RS
				Set lastk=$O(..DataArray(i,j,""),-1)
				If K="*" Set data=lastk Quit
				For k=1:1:lastk {
					If K'="",k'=K Continue
					If K="",k>1 Set data=data_CS
					Set value=$G(..DataArray(i,j,k))
					Set:tSeparators'=..Separators value=$E(..replaceSeparators(..Separators_value,tSeparators),4,*)
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

ClassMethod EscapeEx(pData, pSeparators) As %String
{
	Set tEscape=$C(..#ESCascii)
	Set replace($C(10))=tEscape_"X0A"_tEscape
	Set replace($C(13))=tEscape_"X0D"_tEscape
	Set replace($$$ELESEP(pSeparators))=tEscape_"F"_tEscape
	Set replace($$$REPSEP(pSeparators))=tEscape_"R"_tEscape
	Set replace($$$COMSEP(pSeparators))=tEscape_"C"_tEscape
	Set replace(tEscape)=tEscape_"E"_tEscape
	Quit $$replaceArray^EnsUtil(pData,.replace)
}

ClassMethod UnescapeEx(pData, pSeparators) As %String
{
	Set tEscape=$C(..#ESCascii)
	Set replace(tEscape_"X0A"_tEscape)=$c(10)
	Set replace(tEscape_"X0D"_tEscape)=$c(13)
	Set replace(tEscape_".br"_tEscape)=$C(13)
	Set replace(tEscape_"F"_tEscape)=$$$ELESEP(pSeparators)
	Set replace(tEscape_"R"_tEscape)=$$$REPSEP(pSeparators)
	Set replace(tEscape_"C"_tEscape)=$$$COMSEP(pSeparators)
	Set replace(tEscape_"E"_tEscape)=tEscape
	Quit $$replaceArrayLeftToRight^EnsUtil(pData,.replace,5)
}

/// Given a property path, determine the Element, Repeat and Component positions
Method parsePropertyPath(pPropertyPath As %String, Output pElem As %Integer, Output pArray As %Integer, Output pComponent As %Integer) As %Status
{
	Set pElem=$P($P(pPropertyPath,".",1),"(",1)
	Set pArray=$P($P($P(pPropertyPath,".",1),"(",2),")",1)
	Set pComponent=$P(pPropertyPath,".",2)

	If pElem'="",pElem'="*",pElem'=0,+pElem'=pElem {
		Set index=$ZCVT(pElem_$S(pComponent="":"",1:"."_pComponent),"L")
		If (..DocTypeCategory="")||(..DocTypeName="") {
			#; Not enough information
			Set newspec = ""
		} ElseIf ..DocTypeValTS="" {
			#; New-style schema path
			Set newspec = $G($$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map",index))
		} Else {
			#; Validation-style schema path
			If '$D($$$vaVSchemaGbl(..DocTypeCategory,..DocTypeValTS,..Name,"map",index),newspec) {
				If ..DocTypeName["!" {
					Set newspec = $G($$$vaVSchemaGbl(..DocTypeCategory,..DocTypeValTS,$P(..DocTypeName,"!")_"-"_$P(..DocTypeName,"-",2),"map",index))
				} Else {
					Set newspec = $G($$$vaVSchemaGbl(..DocTypeCategory,..DocTypeValTS,..DocTypeName,"map",index))
				}
			}
		}
		If newspec="" Quit $$$ERROR($$$EnsErrGeneral,"PropertyPath '"_pPropertyPath_"' is invalid.")
		Set pElem=$P($P(newspec,".",1),"(",1)
		Set pComponent=$P(newspec,".",2)
	}
	If +pElem=pElem Set pElem=pElem+1
	If pArray="",pComponent'="" Set pArray=1
	Quit $$$OK
}

ClassMethod replaceSeparators(pInputData, oSeparators) As %String
{
	Set iSeparators=$e(pInputData,1,3)
	Set mSeparators=$c(1,2,3)
	set tData=$e(pInputData,4,*)
	Set tData=$tr(tData,iSeparators,mSeparators)
	Set tData=..UnescapeEx(tData,iSeparators)
	Set tData=..EscapeEx(tData,oSeparators)
	Quit oSeparators_$tr(tData,mSeparators,oSeparators)
}

/// Display Segment as HTML, using DocType info if available
Method OutputHTML() As %Status
{
	Set tSC=$$$OK
	&html<
	<table border="0" cellspacing="0" cellpadding="0" cols="2" width="100%"><tr><td align="center"><div class="Text" style="margin: 3px;">>
	If ""'=..DocType {
		If ..DocTypeValTS="" {
			Set tDesc=##class(EnsLib.EDI.X12.Schema).GetDescription("SS:"_..DocType)
		} Else {
			Set tDesc=##class(EnsLib.EDI.SEF.Schema).GetDescription("SS:"_..DocType)
		}
		&html<X12 <b>#($ZCVT(..Name,"O","HTML"))#</b> Segment, DocType = '<a#($S(""=tDesc:"",1:" title='"_$ZCVT(tDesc,"O","HTML")_"'")_##class(EnsLib.EDI.X12.Util.FormatHTML).getSegLink(..DocType))#><b>#($ZCVT(..DocType,"O","HTML"))#</b></a>'
			<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#($S(""=tDesc:"", 1:"'<b><i>"_$ZCVT(tDesc,"O","HTML")_"</i></b>', "))#>
	} Else {
		&html<X12 <b>#($ZCVT(..Name,"O","HTML"))#</b> Segment, DocType = <b>''</b>>
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
	Set tVDocTxt = $$$Text("X12")
	Set tSegTxt = $$$Text("Segment")
	Set tDocTypeTxt = $$$Text("DocType")
	&html<
	<table border="0" cellspacing="0" cellpadding="0" cols="2" width="100%"><tr><td align="center"><div class="Text" style="margin: 3px;">>
	If ""'=..DocType {
		If ..DocTypeValTS="" {
			Set tDesc=##class(EnsLib.EDI.X12.Schema).GetDescription("SS:"_..DocType)
		} Else {
			Set tDesc=##class(EnsLib.EDI.SEF.Schema).GetDescription("SS:"_..DocType)
		}
		&html<#(tVDocTxt)# <b>#($ZCVT(..Name,"O","HTML"))#</b> #(tSegTxt)#, #(tDocTypeTxt)# = '<a#($S(""=tDesc:"",1:" title='"_
			$ZCVT(tDesc,"O","HTML")_"'")_##class(EnsLib.EDI.X12.Util.FormatHTML).getSegLink(..DocType))#><b>#($ZCVT(..DocType,"O","HTML"))#</b></a>'
			<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#($S(""=tDesc:"", 1:"'<b><i>"_$ZCVT(tDesc,"O","HTML")_"</i></b>', "))#>
	} Else {
		&html<#(tVDocTxt)# <b>#($ZCVT(..Name,"O","HTML"))#</b> #(tSegTxt)#, #(tDocTypeTxt)# = <b>''</b>>
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
	If ..DocTypeValTS="" {
		If ..DocTypeCategory'="",..DocTypeName'="" Merge MapArray=$$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map") w ! zw MapArray
} Else {
		If ..DocTypeCategory'="",..DocTypeName'="" Merge MapArray=$$$vaVSchemaGbl(..DocTypeCategory,..DocTypeValTS,..DocTypeName,"map") w ! zw MapArray
}
	Merge DataArray=..DataArray w ! zw DataArray
	Quit $$$OK
}

ClassMethod GetContentArray(Output pContents, pMode As %String, pDocType As %String, pLevel As %Integer = 0, pIncludeBase As %Boolean = 0) As %Status
{
	Set tRef=$G(pContents)
	If ("%"=$E(tRef)||("^"=$E(tRef))) {
		If $P(pDocType,":",3)="" {
			Set tSC=##class(EnsLib.EDI.X12.Schema).getFieldsContentArray(.local,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
		} Else {
			Set tSC=##class(EnsLib.EDI.SEF.Schema).getFieldsContentArray(.local,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$P(pDocType,":",3),$S('pLevel:0,1:pLevel+2))
		}
		Merge @tRef=local
		Quit tSC
	} Else {
		If $P(pDocType,":",3)="" {
			Quit ##class(EnsLib.EDI.X12.Schema).getFieldsContentArray(.pContents,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
		} Else {
			Quit ##class(EnsLib.EDI.SEF.Schema).getFieldsContentArray(.pContents,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$P(pDocType,":",3),$S('pLevel:0,1:pLevel+2))
		}
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
/// If <var>ExpandedDocType</var> is: <br/>
///  0 - return all SegTypes as Category:SegName <br/>
///  1 - return old-style SegTypes as Category:DocStruct:Segment-Ordinal <br/>
Query EnumerateDocTypes(Category As %String = "", IncludeBase As %Boolean = 0, ExpandedDocType As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "Type:%String")
{
}

ClassMethod EnumerateDocTypesExecute(ByRef qHandle As %Binary, Category As %String, IncludeBase As %Boolean, ExpandedDocType As %Boolean = 0) As %Status [ CodeMode = expression ]
{
##class(EnsLib.EDI.X12.Schema).SegTypesExecute(.qHandle,.Category,0,.IncludeBase,ExpandedDocType)
}

ClassMethod EnumerateDocTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EnumerateDocTypesExecute ]
{
	Set tSC=##class(EnsLib.EDI.X12.Schema).SegTypesFetch(.qHandle,.Row,.AtEnd)
	Set:""'=$G(Row) Row=$LB($LG(Row))
	Quit tSC
}

ClassMethod EnumerateDocTypesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateDocTypesFetch ]
{
##class(EnsLib.EDI.X12.Schema).SegTypesClose(.qHandle)
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
##class(EnsLib.EDI.X12.Schema).TypeCategoriesExecute(.qHandle, Standard)
}

ClassMethod EnumerateTypeCategoriesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = expression, PlaceAfter = EnumerateTypeCategoriesExecute ]
{
##class(EnsLib.EDI.X12.Schema).TypeCategoriesFetch(.qHandle,.Row,.AtEnd)
}

ClassMethod EnumerateTypeCategoriesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateTypeCategoriesFetch ]
{
##class(EnsLib.EDI.X12.Schema).TypeCategoriesClose(.qHandle)
}

}
