/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

Class EnsLib.EDI.ASTM.Segment Extends (%RegisteredObject, EnsLib.EDI.Segment) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

/// Field separator character
Property FS As %String [ Calculated ];

/// Repetition separator character
Property RS As %String [ Calculated ];

/// Component separator character
Property CS As %String [ Calculated ];

/// Escape separator character
Property ESC As %String [ Calculated ];

/// All 4 Separators as a single String
Property Separators As %String(MAXLEN = 4, MINLEN = 4) [ InitialExpression = {$$$ASTMDefSeparators} ];

/// Local copy of segment data decomposed into multidimensional array
Property DataArray [ Internal, MultiDimensional ];

/// the Category portion of the DocType
Property DocTypeCategory As %String [ ReadOnly ];

/// the Name portion of the DocType ( name [ ! required fields] - ordinal )
Property DocTypeName As %String [ ReadOnly ];

/// Size in bytes of the segment content (even if >32k)
Property FullSize As %Integer [ Calculated, ReadOnly ];

/// Were we cloned from another Segment object? (If so, we won't be responsible for deleting the underlying segment ID data node if any)
Property %Cloned As %Boolean [ Internal, ReadOnly ];

Method PokeDocType(pDocType As %String) As %Status [ CodeMode = expression ]
{
..DocTypeSet(pDocType)
}

Method DocTypeSet(pDocType As %String) As %Status
{
	Set i%DocType=pDocType
	Set i%DocTypeCategory=$P(i%DocType,":",1)
	Set i%DocTypeName=$P(i%DocType,":",2)
	Quit $$$OK
}

Method FSGet() As %String [ CodeMode = expression ]
{
$$$FLDSEP(..Separators)
}

Method RSGet() As %String [ CodeMode = expression ]
{
$$$REPSEP(..Separators)
}

Method CSGet() As %String [ CodeMode = expression ]
{
$$$COMSEP(..Separators)
}

Method ESCGet() As %String [ CodeMode = expression ]
{
$$$ESCSEP(..Separators)
}

Method FSSet(newval) As %Status
{
	Set $$$FLDSEP(i%Separators)=$E(newval_$$$ASTMDefFS)
	Quit $$$OK
}

Method RSSet(newval) As %Status
{
	Set $$$REPSEP(i%Separators)=$E(newval_$$$ASTMDefRS)
	Quit $$$OK
}

Method CSSet(newval) As %Status
{
	Set $$$COMSEP(i%Separators)=$E(newval_$$$ASTMDefCS)
	Quit $$$OK
}

Method ESCSet(newval) As %Status
{
	Set $$$ESCSEP(i%Separators)=$E(newval_$$$ASTMDefESC)
	Quit $$$OK
}

Method SeparatorsSet(newvalue As %String) As %Status
{
	Set i%Separators=$E(newvalue,1,4)
	Set:$L(newvalue)<4 i%Separators=i%Separators_$E($$$ASTMDefSeparators,$L(newvalue)+1,4)
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
		Set $$$vaSegmentGbl(tIndex)=$E(tSeparators,1,4)_..getAtFromArray("",tSeparators)
		Set $$$vaOpenSegmentPPG(tIndex) = 1
		Set i%ID=tIndex, i%IsMutable=0, i%%Cloned=0
	} Else { $$$ASSERT(+..ID=..ID&&(..ID>0)) }
	Quit $$$OK
}

Method OutputToDevice(pSeparators As %String, ByRef pDoFraming As %Integer, pResponseTimeout As %Numeric = -1) As %Status
{
	Set tDeviceStream=##class(%IO.DeviceStream).AttachNew(,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ..OutputToIOStream(tDeviceStream, .pSeparators, .pDoFraming, .pResponseTimeout)
}

Method OutputToLibraryStream(pLibStream As %Stream.Object, pSeparators As %String, ByRef pDoFraming As %Integer, pResponseTimeout As %Numeric = -1) As %Status
{
	Set tIOStream=$S(pLibStream.%Extends("%IO.I.CharacterStream"):pLibStream,1:##Class(%IO.MetaCharacterStream).%New(pLibStream))
	Quit ..OutputToIOStream(tIOStream, .pSeparators, .pDoFraming, .pResponseTimeout)
}

Method OutputToString(pSeparators As %String, ByRef pDoFraming As %Integer, pResponseTimeout As %Numeric = -1, Output pStatus As %Status) As %String
{
	Set tIOStream=##Class(%IO.StringStream).%New()
	Set pStatus = ..OutputToIOStream(tIOStream, .pSeparators, .pDoFraming, .pResponseTimeout)
	Do tIOStream.Rewind()
	Quit tIOStream.Read()
}

/// Convert segments back to Stream
Method OutputToIOStream(pIOStream As %IO.I.CharacterStream, pSeparators As %String, ByRef pDoFraming As %Integer = 0, pResponseTimeout As %Numeric = -1) As %Status
{
#define ABS(%n)	$S(%n>=0:%n,1:-%n)
	Set tSC=$$$OK, $ZT="Trap"
	Set data=..GetValueAt("",.pSeparators)
	Set i=0 While data'="" {
		Set tDone=(..ID=""||$D(..DataArray)||'$D($$$vaSegmentGbl(..ID,i+1)))

		If 'pDoFraming { Do pIOStream.Write(data,,.tSC)  Set data="" }
		Else {
			Set tFrameNum=$$$ABS(pDoFraming)-1
			Set tChunk=$E(data,1,240), data=$E(data,241,*)
			Set tChunk=tFrameNum_tChunk_$S(""=data&&tDone:$S($C(13)=$E(tChunk,*):"",1:$C(13))_$$$ETX,1:$$$ETB)
			Do pIOStream.Write($$$STX_tChunk_$$$CHKSUM(tChunk)_$C(13,10),(pDoFraming<0),.tSC)
			If pDoFraming<0 {
				While 1 {
					If pResponseTimeout=-1 {
						Read tACK#1
					} Else {
						Read tACK#1:pResponseTimeout  Set tTimedOut='$Test
						If tTimedOut Set tSC=$$$ERROR($$$EnsErrTCPReadTimeoutExpired,pResponseTimeout,"ASTM Frame ACK","binary")  Quit
					}
					Quit:$$$ACK=tACK
					Continue:$C(13,10)[tACK
					Set tSC=$$$ERROR($$$EnsErrGeneral,"Received unexpected ASTM Frame ACK character: Ascii "_$A(tACK))
					Quit
				}
				Set pDoFraming=-1-(tFrameNum+1#8)
			} Else {
				Set pDoFraming=1+(tFrameNum+1#8)
			}
		}
		Quit:$$$ISERR(tSC)
		Set:""=data&&'tDone i=i+1, data=$G($$$vaSegmentGbl(..ID,i))
	}
	Do:$$$ISOK(tSC)&&'pDoFraming pIOStream.Write($C(10),,.tSC)
Exit
	Quit tSC
Trap
	Set $ZT="", tZE=$ZE, tSC=$$$SystemError
	Goto Exit
}

Method outputHTMLSeg(pSeparators As %String, pSegNum As %String = "", pSegPath As %String = "", pDocument As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit ..OutputToDevice(.pSeparators,,pSegNum,pSegPath,pDocument,"EnsLib.EDI.ASTM.Util.FormatHTML")
}

Method outputHTMLSegZen(pSeparators As %String, pSegNum As %String = "", pSegPath As %String = "", pDocument As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit ..OutputToDevice(.pSeparators,,pSegNum,pSegPath,pDocument,"EnsLib.EDI.ASTM.Util.FormatHTMLZen")
}

ClassMethod ImportFromString(pString As %String, Output pStatus As %Status, pSeparators As %String, ByRef pConfigItem As %String = "", pIOFormatClassname As %String) As EnsLib.EDI.ASTM.Segment
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

ClassMethod ImportFromIOStream(pIOStream As %IO.I.CharacterStream, Output pStatus As %Status = {$$$OK}, pSeparators As %String, pIOFormatClassname As %String = "") As EnsLib.EDI.ASTM.Document
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
	Quit:""=..ID||($F(data0,tMarker,5)-1<$L(data0)) tSC
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
	Set pos=$F(data,tMarker,5) Quit:'pos $$$ERROR($$$EnsErrGeneral,"Unable find stream store location in segment")
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

/// pPropertyPath is of syntax: field [ ( array ) ] [ . component ]
/// Returns the value at the specified property path. pSeparators is used to specify the
/// separators to be used when a non-atomic value is returned.
/// All property path elements must be either name or index.
Method GetValueAt(pPropertyPath As %String, pSeparators As %String, Output pStatus As %Status, pTreatEmptyAsNull As %Boolean = 0) As %String
{
	If (..ID="")||$D(..DataArray) {
		Quit ..getAtFromArray(.pPropertyPath,.pSeparators,.pStatus, pTreatEmptyAsNull)
	} Else {
		Quit ..getAtFromGlobal(.pPropertyPath,.pSeparators,.pStatus, pTreatEmptyAsNull)
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
	If $Case(..Name,"H":0,:1) Set field=field+1
	If '$D(..DataArray) Set pStatus=..decompose() Quit:$$$ISERR(pStatus) ""
	Quit $O(..DataArray(field,pIndex))
}

/// Sets the value at the specified property path.
/// pPropertyPath is of syntax: field [ ( array ) ] [ . component ]
/// All property path elements must be either name or index. pKey is used to append an array index to the value at
/// the given property path. pAction corresponds to the actions in the DTL <assign> statement.
Method SetValueAt(pValue As %String, pPropertyPath As %String = "", pAction As %String = "set", pKey As %String = "") As %Status
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Segment is immutable")
	Set:$Case(pAction,"remove":1,"clear":1,:'($D(pValue)#2)) pValue=""
	If '$D(..DataArray) Set tSC=..decompose()  Quit:$$$ISERR(tSC) tSC
	Set i%ID="" ; clear the ID because we are no longer referring to it
	If pKey'="" Set pPropertyPath=pPropertyPath_"("_pKey_")"
	Set tSC=..parsePropertyPath(pPropertyPath,.field,.array,.component)  Quit:$$$ISERR(tSC) tSC
	
	If $Case(..Name,"H":1,:0) {
		If field=2 Set ..FS=pValue Quit $$$OK
		If field=3 Set ..Separators=..FS_pValue Quit $$$OK
		If field'="",field>1 Set field=field-1
	}
	Set data=pValue
	If field="" {
		Kill:pAction'="append" ..DataArray
		Set data1=data
		For i=1:1:$L(data1,..FS) { Set data2=$P(data1,..FS,i)
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

Method CopyValues(pSource As EnsLib.EDI.ASTM.Segment, pSourcePath As %String, pTargetPath As %String, pAction As %String, pKey As %String, pEmptyFieldAsNull As %Boolean = 0, pIgnoreMissingSource As %Boolean = 0) As %Status
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
$S($D(..DataArray):$$$ERROR($$$EnsErrGeneral,"array data already exists")
	,""=..ID:$$$OK
	, 1:..decomposeData($$$vaSegmentGbl(..ID)))
}

Method decomposeData(pData As %String) As %Status
{
	Set FS=$$$FLDSEP(pData), CS=$$$COMSEP(pData), RS=$$$REPSEP(pData), ESC=$$$ESCSEP(pData), data1=$E(pData,5,*)
	Set tName=$P(data1,FS)
	For i=1:1:$L(data1,FS) { Set data2=$P(data1,FS,i)
		If tName="H"&&(i=2) { ; separators
			Set ..DataArray(i,1,1)=FS_$P(data1,FS,i) ; don't try to decompose repeat & component separators
			Continue
		}
		For j=1:1:$L(data2,RS) { Set data3=$P(data2,RS,j)
			For k=1:1:$L(data3,CS) { Set ..DataArray(i,j,k)=$P(data3,CS,k) }
		}
	}
	Quit $$$OK
}

Method getAtFromGlobal(pPropertyPath As %String = "", pSeparators As %String, Output pStatus As %Status, pTreatEmptyAsNull As %Boolean = 0) As %String
{
	Set data=$$$vaSegmentGbl(..ID)
	If ""=$G(pSeparators) { Set tSeparators=$E(data,1,4) }
	Else {
		Set tSeparators=$E(pSeparators,1,4)
		Set:$E(data,1,4)'=tSeparators data=..replaceSeparators(data,tSeparators)
	}
	Set FS=$$$FLDSEP(data), CS=$$$COMSEP(data), RS=$$$REPSEP(data), ESC=$$$ESCSEP(data), data=$E(data,5,*)
	If ""=pPropertyPath Set pStatus=$$$OK  Quit data
	Set pStatus=..parsePropertyPath(pPropertyPath,.field,.array,.component)  Quit:$$$ISERR(pStatus) ""
	Set tName=$P(data,FS)
	Set tIsHeader = (tName="H")
	If tIsHeader {
		Quit:field=1 tName
		Quit:field=2 FS
		Quit:field=3 $E(tSeparators,2,4)
		If field="*" {
			Set tLastFieldNull = (pTreatEmptyAsNull && ($P(data,FS,*)=""))
			Quit $L(data,FS) - tLastFieldNull
		}
		Set:field'="" field=field-1
	}
	Set tLastFieldNull = (pTreatEmptyAsNull && ($P(data,FS,*)=""))
	Set tFieldCount = $L(data,FS)-'tIsHeader - tLastFieldNull
	If field'="" {
		Set data=$S(field="*":tFieldCount,1:$P(data,FS,field))
	}
	Set tRepsCount = $S((field-'tIsHeader) > tFieldCount : 0, pTreatEmptyAsNull&&(data="") : 0, 1 : $L(data,RS))
	If array'="" {
		Set data=$S(array="*":tRepsCount,1:$P(data,RS,array))
	}
	If component'="" {
		If component="*" {
			Set data = $S(component>tRepsCount : 0, 1:$L(data,CS))
		} Else {
			Set data=$P(data,CS,component)
		}
	}
	Quit data
}

Method getAtFromArray(pPropertyPath As %String = "", pSeparators As %String, Output pStatus As %Status, pEmptyFieldAsNull As %Boolean = 0) As %String
{
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:$E(pSeparators,1,4))
	Set FS=$$$FLDSEP(tSeparators), RS=$$$REPSEP(tSeparators), CS=$$$COMSEP(tSeparators)
	Set pStatus=..parsePropertyPath(pPropertyPath,.I,.J,.K)  Quit:$$$ISERR(pStatus) ""
	Set tName=$G(..DataArray(1,1,1))
	If $Case(tName,"H":1,:0) {
		Quit:I=1 tName
		Quit:I=2 FS
		Quit:I=3 $E(tSeparators,2,4)
		If I="*" {
			Set data = $O(..DataArray(""),-1)
			If pEmptyFieldAsNull && (..GetValueAt(data)="") {
				Set data = data -1
			}
			Quit data
		}
		If I="" {
			Set data=tName_tSeparators, tCount=$O(..DataArray(""),-1)
			For i=3:1:tCount Set data=data_FS_..GetValueAt(i,tSeparators)
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
		For i=1:1:lasti {
			If I'="",i'=I Continue
			If I="",i>1 Set data=data_FS
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
					Set:tSeparators'=..Separators value=$E(..replaceSeparators(..Separators_value,tSeparators),5,*)
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
	Set replace($$$FLDSEP(pSeparators))=tEscape_"F"_tEscape
	Set replace($$$REPSEP(pSeparators))=tEscape_"R"_tEscape
	Set replace($$$COMSEP(pSeparators))=tEscape_"S"_tEscape
	Set replace($$$ESCSEP(pSeparators))=tEscape_"E"_tEscape
	Quit $$replaceArray^EnsUtil(pData,.replace)
}

ClassMethod UnescapeEx(pData, pSeparators, pEscapeChar) As %String
{
	Set tEscape=$g(pEscapeChar,$$$ESCSEP(pSeparators))
	Set replace(tEscape_"X0A"_tEscape)=$c(10)
	Set replace(tEscape_"X0D"_tEscape)=$c(13)
	Set replace(tEscape_".br"_tEscape)=$C(13)
	Set replace(tEscape_"F"_tEscape)=$$$FLDSEP(pSeparators)
	Set replace(tEscape_"R"_tEscape)=$$$REPSEP(pSeparators)
	Set replace(tEscape_"S"_tEscape)=$$$COMSEP(pSeparators)
	Set replace(tEscape_"E"_tEscape)=$$$ESCSEP(pSeparators)
	Quit $$replaceArrayLeftToRight^EnsUtil(pData,.replace,5)
}

/// Given a property path, determine the Field, Array, and Component positions
Method parsePropertyPath(pPropertyPath As %String, Output pField As %Integer, Output pArray As %Integer, Output pComponent As %Integer) As %Status
{
	Set pField=$P($P(pPropertyPath,".",1),"(",1)
	Set pArray=$P($P($P(pPropertyPath,".",1),"(",2),")",1)
	Set pComponent=$P(pPropertyPath,".",2)

	If pField'="",pField'="*",pField'=0,+pField'=pField {
		Set index=$ZCVT(pField_$S(pComponent="":"",1:"."_pComponent),"L")
		Set newspec=$S((..DocTypeCategory="")||(..DocTypeName=""):"", 1:$G($$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map",index)))
		If newspec="" Quit $$$ERROR($$$EnsErrGeneral,"PropertyPath '"_pPropertyPath_"' is invalid.")
		Set pField=$P($P(newspec,".",1),"(",1)
		Set pComponent=$P(newspec,".",2)
	}
	If +pField=pField Set pField=pField+1
	If pArray="",pComponent'="" Set pArray=1
	Quit $$$OK
}

ClassMethod replaceSeparators(pInputData, oSeparators) As %String
{
	Set iSeparators=$e(pInputData,1,4)
	Set mSeparators=$c(1,2,3,4)
	set tData=$e(pInputData,5,*)
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
	<table border="0" cellspacing="0" cellpadding="0" cols="2" width="100%"><tr><td align="center"><div class="Text" style="margin: 3px;">>
	If ""'=..DocType {
		Set tDesc=##class(EnsLib.EDI.ASTM.Schema).GetDescription("SS:"_..DocType)
		&html<ASTM <b>#($ZCVT(..Name,"O","HTML"))#</b> Segment, DocType = '<a#($S(""=tDesc:"",1:" title='"_$ZCVT(tDesc,"O","HTML")_"'")_##class(EnsLib.EDI.ASTM.Util.FormatHTML).getSegLink(..DocType))#><b>#($ZCVT(..DocType,"O","HTML"))#</b></a>'
			<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#($S(""=tDesc:"", 1:"'<b><i>"_$ZCVT(tDesc,"O","HTML")_"</i></b>', "))#>
	} Else {
		&html<ASTM <b>#($ZCVT(..Name,"O","HTML"))#</b> Segment, DocType = <b>''</b>>
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
	Set tVDocTxt = $$$Text("ASTM")
	Set tSegTxt = $$$Text("Segment")
	Set tDocTypeTxt = $$$Text("DocType")
	&html<
	<table border="0" cellspacing="0" cellpadding="0" cols="2" width="100%"><tr><td align="left"><div class="Text" style="margin: 3px;">>
	If ""'=..DocType {
		Set tDesc=##class(EnsLib.EDI.ASTM.Schema).GetDescription("SS:"_..DocType)
		&html<#(tVDocTxt)# <b>#($ZCVT(..Name,"O","HTML"))#</b> #(tSegTxt)#, #(tDocTypeTxt)# = 
			'<a#($S(""=tDesc:"",1:" title='"_$ZCVT(tDesc,"O","HTML")_"'")_##class(EnsLib.EDI.ASTM.Util.FormatHTMLZen).getSegLink(..DocType))#><b>#($ZCVT(..DocType,"O","HTML"))#</b></a>'
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
	If ..DocTypeCategory'="",..DocTypeName'=""	Merge MapArray=$$$vaSchemaGbl(..DocTypeCategory,"SS",..DocTypeName,"map") w ! zw MapArray
	Merge DataArray=..DataArray w ! zw DataArray
	Quit $$$OK
}

ClassMethod GetContentArray(Output pContents, pMode As %String, pDocType As %String, pLevel As %Integer, pIncludeBase As %Boolean = 0) As %Status
{
	Set tRef=$G(pContents)
	If ("%"=$E(tRef)||("^"=$E(tRef))) {
		Set tSC=##class(EnsLib.EDI.ASTM.Schema).getFieldsContentArray(.local,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
		Merge @tRef=local
		Quit tSC
	} Else {
		Quit ##class(EnsLib.EDI.ASTM.Schema).getFieldsContentArray(.pContents,.pMode,$P(pDocType,":",1),$P(pDocType,":",2),$S('pLevel:0,1:pLevel+2))
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
##class(EnsLib.EDI.ASTM.Schema).SegTypesExecute(.qHandle,.Category,0,.IncludeBase)
}

ClassMethod EnumerateDocTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EnumerateDocTypesExecute ]
{
	Set tSC=##class(EnsLib.EDI.ASTM.Schema).SegTypesFetch(.qHandle,.Row,.AtEnd)
	Set:""'=$G(Row) Row=$LB($LG(Row))
	Quit tSC
}

ClassMethod EnumerateDocTypesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateDocTypesExecute ]
{
##class(EnsLib.EDI.ASTM.Schema).SegTypesClose(.qHandle)
}

/// Returns a list of document type schema categories for the document class.<br>
/// The Standard parameter can be used to restrict the list.<br>
/// If Standard is:
///  0 - return only standard categories
///  + - return only user-defined categories
///  empty - return all categories
///  a category name - return only the named category
///  a partial name suffixed with '%' - return only categories matching the partial category name
///  other - return nothing
Query EnumerateTypeCategories(Standard As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "Category:%String,Description:%String,IsStandard:%Boolean,Base:%String")
{
}

ClassMethod EnumerateTypeCategoriesExecute(ByRef qHandle As %Binary, Standard As %String = "") As %Status [ CodeMode = expression ]
{
##class(EnsLib.EDI.ASTM.Schema).TypeCategoriesExecute(.qHandle, Standard)
}

ClassMethod EnumerateTypeCategoriesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EnumerateTypeCategoriesExecute ]
{
	Set tSC=##class(EnsLib.EDI.ASTM.Schema).TypeCategoriesFetch(.qHandle,.Row,.AtEnd)
	Quit tSC
}

ClassMethod EnumerateTypeCategoriesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateTypeCategoriesExecute ]
{
##class(EnsLib.EDI.ASTM.Schema).TypeCategoriesClose(.qHandle)
}

}
