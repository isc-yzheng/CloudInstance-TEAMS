/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

/// Represents an Interchange or a TransactionSet. FunctionalGroups are represented as Segments within an Interchange.
Class EnsLib.EDI.ASTM.Document Extends (%Persistent, EnsLib.EDI.Document, EnsLib.EDI.Segmented, EnsLib.EDI.ASTM.MsgBodyMethods) [ ClassType = persistent, Inheritance = right, ProcedureBlock, System = 4 ]
{

/// Use our own domain for localization
Parameter DOMAIN = "Ensemble";

Parameter DOCCLASSNAME = "ASTM Document";

Parameter DOCCLASSFULLNAME = "ASC ASTM EDI Document";

Parameter DOCSHORTNAME = "ASTM";

/// Name of the default SearchTable indexing class used in UI choices and MessageBank submissions 
Parameter DEFSEARCHCLASS = "EnsLib.EDI.ASTM.SearchTable";

/// Name of the associated schema class and, after a colon, the schema class code that represents a DocType
Parameter SCHEMACLASS = "EnsLib.EDI.ASTM.Schema:DS";

Parameter EXTENTSIZE = 2000000;

Index Extent [ Extent, Type = bitmap ];

Index OriginalDocId On OriginalDocId;

/// 'Envelope' information for the ASTM document message. Used in propagating info about the return Service address for reply documents
Property Envelope As %String(MAXLEN = "");

/// All 4 Separators as a String,FLDSEP_REPSEP_COMSEP_ESCSEP
Property Separators As %String(MAXLEN = 4, MINLEN = 4) [ Transient ];

/// Data-field separator character
Property FieldSeparator As %String [ Calculated, Transient ];

/// Repetition separator character
Property RepetitionSeparator As %String [ Calculated, Transient ];

/// Sub-element component separator character
Property ComponentSeparator As %String [ Calculated, Transient ];

/// Escape separator character
Property EscapeSeparator As %String [ Calculated, Transient ];

/// Raw type name of document
Property Name As %String [ Calculated, ReadOnly, SqlComputeCode = { Set data=$G($$$vaSegmentGbl($G($$$vaExtentGbl({ID},"segs",2),0)))  Set {Name}=$$$vaDataTypeName(data) }, SqlComputed, Transient ];

/// Raw type version name of message found at H:13 in message content
Property TypeVersion As %String [ Calculated, ReadOnly, SqlComputeCode = { Set data=$G($$$vaSegmentGbl($G($$$vaExtentGbl({ID},"segs",1),0)))  Set {TypeVersion}=$$$vaDataTypeVersion(data) }, SqlComputed, Transient ];

/// Unique document identification string found in document content
Property Identifier As %String [ Calculated, ReadOnly, SqlComputeCode = { Set data=$G($$$vaSegmentGbl($G($$$vaExtentGbl({ID},"segs",1),0)))  Set {Identifier}=$$$vaDataDocIdentifier(data) }, SqlComputed, Transient ];

/// Count of segments composing this document
Property SegCount As %Integer [ Calculated, ReadOnly, SqlComputeCode = { Set {SegCount}=$G($$$vaExtentGbl({ID},"segs"),0) }, SqlComputed, Transient ];

/// The raw text content of the document. Note that this is a truncated version suitable for use in SQL results and visual inspection,
/// but not a complete or definitive representation of the document.
Property RawContent As %String(MAXLEN = 10000) [ Calculated, ReadOnly, SqlComputeCode = { Set {RawContent}=##class({%%CLASSNAME}).getSegsAsString({ID}) }, SqlComputed, Transient ];

/// the category portion of the DocType
Property DocTypeCategory As %String [ ReadOnly, Transient ];

/// Stored raw document type name ; the secondary type name portion of the DocType
Property DocTypeName As %String [ ReadOnly, Transient ];

/// Size in bytes of the message content (assuming 1-byte segment terminators, including segments >32k)
Property FullSize As %Integer [ Calculated, ReadOnly, Transient ];

/// A local array of orefs
/// "orefs" - a local map of integer ids to segment objects
/// And either a subscript into ^IRIS.Temp for this object's LVD maps (for notes on LVD implementation see EnsEDI.inc)
/// or local storage for these additional maps:
/// "runtimeIndex" - array for runtime index to segment; will always be defined unless mapRuntimePath is defined
/// "runtimePath" - array for runtime path to segment
/// "bidirectionalLink" - array for runtime path and index linkage
Property %maps [ MultiDimensional, Transient ];

/// Id of original object if we are a mutable clone (also used as a legal subscript that will result in $G(xxx(..%ClonedId))="" instead of a <SUBSCRIPT> error)
Property %ClonedId As %RawString [ InitialExpression = 0, Internal, ReadOnly, Transient ];

Method FieldSeparatorGet() As %String [ CodeMode = expression ]
{
$$$FLDSEP(..Separators)
}

Method RepetitionSeparatorGet() As %String [ CodeMode = expression ]
{
$$$REPSEP(..Separators)
}

Method ComponentSeparatorGet() As %String [ CodeMode = expression ]
{
$$$COMSEP(..Separators)
}

Method EscapeSeparatorGet() As %String [ CodeMode = expression ]
{
$$$ESCSEP(..Separators)
}

Method NameGet() As %String [ CodeMode = expression ]
{
..GetValueAt("2:0")_$S("M"=..GetValueAt("2:0"):"-"_..GetValueAt("2:2"),1:"")
}

Method TypeVersionGet() As %String [ CodeMode = expression ]
{
..GetValueAt("1:13","|\^&")
}

Method IdentifierGet() As %String [ CodeMode = expression ]
{
..GetValueAt("1:3")
}

Method SegCountGet() As %Integer
{
	If $D($$$vaM("runtimeIndex")) Quit $$$vaM("runtimeIndex")
	Set count=0,path="" For  Set path=$O($$$vaM("runtimePath",path)) Quit:path=""  Set count=count+1
	Quit count
}

Method RawContentGet() As %String
{
	Quit ..OutputToString()
}

Method FullSizeGet() As %Integer
{
	Do:'$D($$$vaM("runtimeIndex"))&&$D($$$vaM("runtimePath")) ..buildRuntimeIndexFromPath()
	Set tLen=0 For i=1:1:$G($$$vaM("runtimeIndex")) { Set tSeg=..getSegmentByIndex(i)
		If 'tSeg.IsChildHolder(.tRef) { Set tLen=tLen+tSeg.FullSize+1 }
		Do ..commitSegmentByIndex(i)
	}
	Quit tLen
}

ClassMethod GetFullSize(pMsgId) As %Integer
{
	Set tLen=0 For i=1:1:$$$vaExtentGbl(pMsgId,"segs") {
		#; Add segment size: - 4 separators + 2 terminator
		Set tLen = tLen + $L($$$vaSegmentGbl($$$vaExtentGbl(pMsgId,"segs",i))) - 2
		#; Get extra from any segs > 32k
		For j=1:1 { Quit:'$D($$$vaSegmentGbl($$$vaExtentGbl(pMsgId,"segs",i),j),extra)
			Set tLen = tLen + $L(extra)
		}
	}
	Quit tLen
}

/// Gets the next index in an array
Method GetNextIndex(pPath As %String, pIndex As %String, ByRef pStatus As %Status = {$$$OK}) As %String
{
	Set f=$F(pPath,"()")  If 'f Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't iterate on SegmentPath '"_pPath_"'") Quit ""
	Set tSegmentPath=$P(pPath,":",1)
	If f-1>$L(tSegmentPath) { ; '()' was found in PropertyPath not SegmentPath
		Set tPropertyPath=$P(pPath,":",2)
		Set tSegObj=..GetSegmentAt(tSegmentPath,.pStatus) Quit:$$$ISERR(pStatus) ""
		Quit tSegObj.GetNextIndex(tPropertyPath,pIndex,.pStatus)
	} Else {
		Set tHead=$E(pPath,1,f-2), tLen=$L(tHead)
		Quit:"("=tHead $S(+pIndex<..SegCount:pIndex+1,1:"") ; iterate by index if path is just "()"
		Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
		If '$D($$$vaM("loopIndex",tHead)) {
			#; Build LoopIndex node
			Set path=tHead For { Set path=$O($$$vaM("runtimePath",path))  Quit:path=""
				Quit:$E(path,1,tLen)'=tHead
				Set $$$vaM("loopIndex",tHead,$E(path,tLen+1,$F(path,")",tLen)-2))=""
			}
			If '$D($$$vaM("loopIndex",tHead)) Set $$$vaM("loopIndex",tHead)=0
		}
		Quit $O($$$vaM("loopIndex",tHead,pIndex))
	}
}

/// Gets the next path in a group
Method GetNextGroupPath(pGroup As %String, pPath As %String, ByRef pStatus As %Status = {$$$OK}) As %String
{
	Quit:$$$vaIsIndex(pGroup) ""
	If pGroup[":"||($L(pPath)<$L(pGroup)) Set pStatus=$$$ERROR($$$EnsErrGeneral,"Can't iterate in Group '"_pGroup_"' on Path '"_pPath_"'") Quit ""
	Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
	Set nextpath=$O($$$vaM("runtimePath",pPath))
	Quit:$E(nextpath,1,$L(pGroup))'=pGroup||$Case($E(nextpath,$L(pGroup)+1),"(":0,".":0,:1) ""
	Quit nextpath
}

Method SetValueAt(pValue As %String, pSegmentPropertyPath As %String, pAction As %String = "set", pKey As %String = "") As %Status
{
	If pSegmentPropertyPath["()" {
		Set tSC=$$$OK
		Set tFind=$F(pSegmentPropertyPath,"()")
		Set tHead=$E(pSegmentPropertyPath,1,tFind-3), tTail=$E(pSegmentPropertyPath,tFind,*)
		Set k=$P(pKey,","), pKey=$P(pKey,",",2,$L(pKey,","))
		If k { Set tSC=..SetValueAt(.pValue,tHead_"("_(k)_")"_tTail,pAction,pKey) Quit:$$$ISERR(tSC) }
		Else {
			Set i="" For { Set i=..GetNextIndex(tHead_"()",i) Quit:i=""
				Set tNewPath=tHead_"("_(i)_")"_tTail
				Set tSC=..SetValueAt(.pValue,tNewPath,pAction,pKey) Quit:$$$ISERR(tSC)
			}
		}
		Quit tSC
	}
	Set tGrpPath=$P(pSegmentPropertyPath,":"), tPropPath=$P(pSegmentPropertyPath,":",2)
	Set tSegPath=..GetNextGroupPath(tGrpPath,tGrpPath)
	If ""'=tSegPath { ; if there are group sub-elements
		For {
			Set tNewPath=tSegPath_$S(""=tPropPath:"",1:":"_tPropPath)
			Set tSC=..SetValueAt(.pValue,tNewPath,pAction,pKey) Quit:$$$ISERR(tSC)
			Set tSegPath=..GetNextGroupPath(tGrpPath,tSegPath,.tSC) Quit:$$$ISERR(tSC)
			Quit:""=tSegPath
		}
		Quit tSC
	} Else {
		Quit:(pAction="remove")&&(""=tPropPath) ..RemoveSegmentAt(tGrpPath)
		Set tSegObj=..GetMutableSegmentAt(tGrpPath,.tSC)  Quit:$$$ISERR(tSC) tSC  $$$ASSERT($IsObject(tSegObj))
		Quit tSegObj.SetValueAt(.pValue,tPropPath,pAction,pKey)
	}
}

Method GetValueAt(pSegmentPropertyPath As %String, pSeparators As %String, Output pStatus As %Status, pTreatEmptyAsNull As %Boolean = 0) As %String
{
	Set pStatus=$$$OK, tSeparators=$G(pSeparators,..Separators)
	Set tSegmentPath=$P(pSegmentPropertyPath,":"), tPropertyPath=$P(pSegmentPropertyPath,":",2)
	If ""=tPropertyPath&&(tSegmentPath["*") {
		Quit:$Case(tSegmentPath,"*":1,"(*)":1,:0) ..SegCount
		Set tLen=$L(tSegmentPath)
		If $E(tSegmentPath,tLen-2,tLen)="(*)" {
			Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
			Set count=0, (path,path0)=$E(tSegmentPath,1,tLen-2), tLen0=$L(path0), i=0
			For { Set path=$O($$$vaM("runtimePath",path))  Quit:path=""||(path0'=$E(path,1,tLen0))
				Set ti=+$E(path,tLen0+1,*)  Set:ti'=i&&ti count=count+1,i=ti
			}
			Quit count
		}
		If $E(tSegmentPath,tLen-1,tLen)=".*" {
			Set count=0,(path,path0)=$E(tSegmentPath,1,tLen-2),tLen0=$L(path0)
			Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
			For { Set path=$O($$$vaM("runtimePath",path))  Quit:path=""||(path0'=$E(path,1,tLen0))  Set count=count+1 }
			Quit count
		}
		Quit $$$ERROR($$$EnsErrGeneral,"Invalid segment count value path '"_tSegmentPath_"'")
	}
	Set tSegObj=..GetSegmentAt(tSegmentPath,.pStatus)  Quit:'$IsObject(tSegObj) ""  $$$ASSERT($$$ISOK(pStatus))
	Quit tSegObj.GetValueAt(tPropertyPath,tSeparators,.pStatus,pTreatEmptyAsNull)
}

/// Given a segment index, find the corresponding segment path
Method GetSegmentPath(pIndex As %Integer, Output pStatus As %Status) As %String
{
	If '$D($$$vaM("bidirectionalLink")) {
		If '$D($$$vaM("runtimePath")) { Set pStatus=$$$ERROR($$$EnsErrGeneral,"Document is in index-only mode")  Quit "" }
		Else { Set pStatus=$$$ERROR($$$EnsErrGeneral,"Document is in path-only mode")  Quit "" }
	}
	Set pStatus=$$$OK
	Set tVal=$G($$$vaM("bidirectionalLink",+pIndex))
	Set:""=tVal pStatus=$$$ERROR($$$EnsErrGeneral,"Index "_pIndex_" is out of bounds")
	Quit tVal
}

/// Given a segment path, find the corresponding segment index
Method GetSegmentIndex(pPath As %String, Output pStatus As %Status) As %Integer
{
	If '$D($$$vaM("bidirectionalLink")) {
		If '$D($$$vaM("runtimePath")) { Set pStatus=$$$ERROR($$$EnsErrGeneral,"Document is in index-only mode")  Quit "" }
		Else { Set pStatus=$$$ERROR($$$EnsErrGeneral,"Document is in path-only mode")  Quit "" }
	}
	Set pStatus=$$$OK
	Set tVal=$G($$$vaM("bidirectionalLink",pPath))
	Set:""=tVal||(tVal'=+tVal) pStatus=$$$ERROR($$$EnsErrGeneral,"Path "_pPath_" not found")
	Quit tVal
}

/// Gets the next segment after index <var>pIndex</var> with name <var>pSegName</var>.
/// Supports <var>pSegName</var> = '*' to match any segment.
Method FindSegment(pSegName As %String, ByRef pIndex As %String = "", Output pStatus As %Status) As EnsLib.EDI.ASTM.Segment
{
	Set pStatus=$$$OK, tId=..%Id()  Set:'tId tId=..%ClonedId
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Set seg=""  For index=+pIndex+1:1:$$$vaM("runtimeIndex") { Set seg=$$$vaSegLookthru(index,tId)  Continue:""=seg
		If $$$vaIsOref(seg) {
			Set tSegObj=..%maps("orefs",index)
			If (pSegName="*")||(tSegObj.Name=pSegName) Set pIndex=index  Quit
		} Else {
			Set segid=$P(seg,"|"), data=$G($$$vaSegmentGbl(segid))
			If (pSegName="*")||(pSegName=$$$vaDataSegName(data)) {
				#; Same code as in getSegmentByIndex
				Set pIndex=index
				Set tSegObj=##class(EnsLib.EDI.ASTM.Segment).%New($LB(segid,(..IsMutable&&(tId=..%ClonedId)),$P(seg,"|",2)))
				Set ..%maps("orefs",pIndex)=tSegObj
				Set $$$vaM("runtimeIndex",pIndex)="@"
				Set path=$G($$$vaM("bidirectionalLink",pIndex)) Set:""'=path $$$vaM("runtimePath",path)="@"_pIndex
				Quit
			}
		}
	}
	If +pIndex<index Set pIndex=""  Quit $$$NULLOREF
	Quit tSegObj
}

Method getSegmentByIndex(pIndex As %Integer, Output pStatus As %Status) As EnsLib.EDI.ASTM.Segment [ Internal ]
{
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Set pStatus=$$$OK, tId=..%Id()  Set:'tId tId=..%ClonedId
	Set seg=$$$vaSegLookthru(pIndex,tId)
	If seg="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Segment Index "_pIndex_" is out of bounds") Quit $$$NULLOREF
	Quit:$$$vaIsOref(seg) ..%maps("orefs",pIndex)
	Set tSegObj=##class(EnsLib.EDI.ASTM.Segment).%New($LB($P(seg,"|"),(..IsMutable&&..CacheSegsGotten&&(tId=..%ClonedId)),$P(seg,"|",2)))
	If ..CacheSegsGotten {
		Set ..%maps("orefs",pIndex)=tSegObj
		Set $$$vaM("runtimeIndex",pIndex)="@"
		Set path=$G($$$vaM("bidirectionalLink",pIndex)) Set:""'=path $$$vaM("runtimePath",path)="@"_pIndex
	}
	Quit tSegObj
}

Method getSegmentByPath(pPath As %String, Output pStatus As %Status) As EnsLib.EDI.ASTM.Segment [ Internal ]
{
	Set pStatus=$$$OK
	Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
	Set seg=$G($$$vaM("runtimePath",pPath))
	If seg="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"No segment found at path '"_pPath_"'") Quit $$$NULLOREF
	Quit:$$$vaIsOref(seg) ..%maps("orefs",$E(seg,2,*))
	Set tSegObj=##class(EnsLib.EDI.ASTM.Segment).%New($LB($P(seg,"|"),(..IsMutable&&..CacheSegsGotten&&'..%Id()&&..%ClonedId),$P(seg,"|",2)))
	If ..CacheSegsGotten {
		Set index=$G($$$vaM("bidirectionalLink",pPath))
		If index { Set seg="@"_index, $$$vaM("runtimeIndex",index)="@" }
		Else { Set index=$O(..%maps("orefs",""))-1, seg="@"_index}
		Set ..%maps("orefs",index)=tSegObj
		Set $$$vaM("runtimePath",pPath)=seg
	}
	Quit tSegObj
}

Method getSegmentIdByIndex(pIndex As %Integer, Output pStatus As %Status) As %String
{
	Set pStatus=$$$OK, tId=..%Id()  Set:'tId tId=..%ClonedId
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Set seg=$$$vaSegLookthru(pIndex,tId)
	If seg="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Index "_pIndex_" is out of bounds") Quit ""
	Quit:'$$$vaIsOref(seg) $P(seg,"|")
	Quit ..%maps("orefs",pIndex).ID
}

Method getSegmentIdByPath(pPath As %String, Output pStatus As %Status) As %String
{
	Set pStatus=$$$OK
	Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
	Set seg=$G($$$vaM("runtimePath",pPath))
	Quit:'$$$vaIsOref(seg) $P(seg,"|")
	Quit ..%maps("orefs",$E(seg,2,*)).ID
}

Method getMutableSegmentByIndex(pIndex As %Integer, Output pStatus As %Status) As EnsLib.EDI.ASTM.Segment [ Internal ]
{
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Set pStatus=$$$OK, i%BuildMapStatus="", tId=..%Id()  Set:'tId tId=..%ClonedId
	Set seg=$$$vaSegLookthru(pIndex,tId)
	If seg="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Index "_pIndex_" is out of bounds")  Quit $$$NULLOREF
	If $$$vaIsOref(seg) {
		Set tSegObj=..%maps("orefs",pIndex)
		If tSegObj.IsMutable Set tSegObj.Separators=..Separators  Quit tSegObj
		Kill ..%maps("orefs",pIndex)
		Set seg=tSegObj.ID_"|"_tSegObj.DocType
	}
	;Set tSegObj=..NewSegment(pPath)
	Set tSegObj=##class(EnsLib.EDI.ASTM.Segment).%New($LB($P(seg,"|"),1,$P(seg,"|",2)))
	If '$IsObject(tSegObj)  Set pStatus=%objlasterror  Quit $$$NULLOREF
	Set tSegObj.Separators=..Separators
	Set ..%maps("orefs",pIndex)=tSegObj
	Set $$$vaM("runtimeIndex",pIndex)="@"
	Set path=$G($$$vaM("bidirectionalLink",pIndex)) Set:""'=path $$$vaM("runtimePath",path)="@"_pIndex
	Quit tSegObj
}

Method getMutableSegmentByPath(pPath As %String, Output pStatus As %Status) As EnsLib.EDI.ASTM.Segment [ Internal ]
{
	If (..DocTypeCategory="")||(..DocTypeName="") Set pStatus=$$$ERROR($$$EnsErrGeneral,"Cannot recognize path before DocType is set")  Quit $$$NULLOREF
	Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
	Set pStatus=$$$OK, i%BuildMapStatus=""
	Set seg=$G($$$vaM("runtimePath",pPath))
	If $$$vaIsOref(seg) {
		Set index=$E(seg,2,*)
		Set tSegObj=..%maps("orefs",index)
		If tSegObj.IsMutable Set tSegObj.Separators=..Separators  Quit tSegObj
		Kill ..%maps("orefs",index)
		Set seg=$S(""=tSegObj.ID:"",1:tSegObj.ID_$S(""=tSegObj.DocType:"", 1:"|"_tSegObj.DocType))
	}
	If ""=seg {
		;Set tSegObj=..NewSegment(pPath)
		Set schema=$G($$$vaSchemaGbl(..DocTypeCategory,"DS",..DocTypeName,"map",..convertRuntimePathToSchemaPath(pPath)))
		If schema="" Set pStatus=$$$ERROR($$$EnsErrGeneral,"Path '"_pPath_"' is not mapped in schema for DocType '"_..DocType_"'")  Quit $$$NULLOREF
		Set tSegType=$P(schema,"|",2), tSegName=$P(tSegType,":",2)
		If $ZCVT(tSegName,"U")'=tSegName Set pStatus=$$$ERROR($$$EnsErrGeneral,"Cannot instantiate abstract segment type "_tSegType)  Quit $$$NULLOREF
		Set tSegObj=##class(EnsLib.EDI.ASTM.Segment).%New($LB("",1,tSegType,$E(..Separators,1,4)_tSegName))
		If '$IsObject(tSegObj) Set pStatus=%objlasterror  Quit $$$NULLOREF
		Kill $$$vaM("runtimeIndex"), $$$vaM("bidirectionalLink") ; we are operating only by PathMap now.
		Set index=$O(..%maps("orefs",""))-1, seg="@"_index
	} Else {
		Set tSegObj=##class(EnsLib.EDI.ASTM.Segment).%New($LB($P(seg,"|"),1,$P(seg,"|",2)))
		If '$IsObject(tSegObj) Set pStatus=%objlasterror  Quit $$$NULLOREF
		Set index=$G($$$vaM("bidirectionalLink",pPath))
		If index { Set seg="@"_index, $$$vaM("runtimeIndex",index)="@" }
		Else { Set index=$O(..%maps("orefs",""))-1, seg="@"_index }
	}
	Set tSegObj.Separators=..Separators
	Set ..%maps("orefs",index)=tSegObj
	Set $$$vaM("runtimePath",pPath)=seg
	If ..AutoBuildMap { Do ..BuildMap(0) }
	Else {
		Set i%BuildMapStatus=""
		#; Add relevant loopIndex node(s) if any
		Set pcs=$L(pPath,"(")-1, tHead=$P(pPath,"(",1,pcs)_"("
		For { Set tHead=$O($$$vaM("loopIndex",tHead_")"),-1), tLen=$L(tHead)  Quit:""=tHead
			If tHead=$E(pPath,1,tLen) { Set $$$vaM("loopIndex",tHead,$E(pPath,tLen+1,$F(pPath,")",tLen)-2))="", pcs=pcs-1, tHead=$P(pPath,"(",1,pcs)_"(" }
			Else {
				Set tPart="" For pcs=1:1 { Set tPrevPart=tPart, tPart=$P(pPath,"(",1,pcs)_"(", tLen=$L(tPart)
					If tPart'=$E(tHead,1,tLen) { Set tHead=tPrevPart  Quit }
				}
			}
			Quit:""=tHead||'pcs
		}
	}
	Quit tSegObj
}

Method setSegmentByIndex(pSegObj As EnsLib.EDI.ASTM.Segment, pIndex As %Integer, pInsert As %Boolean) As %Status [ Internal ]
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Object is immutable")
	Quit:'$$$IsdefObject(pSegObj) $$$ERROR($$$EnsErrGeneral,"Cannot set null segment object at index "_pIndex)
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Quit:(pIndex\1'=pIndex)||(pIndex<1)||(pIndex>($$$vaM("runtimeIndex")+1)) $$$ERROR($$$EnsErrGeneral,"Index "_pIndex_" is out of bounds")

	If pInsert {
		Set tId=..%Id()  Set:'tId tId=..%ClonedId  For i=$$$vaM("runtimeIndex"):-1:pIndex { ; slide up all segments to make room for inserted one
			Set $$$vaM("runtimeIndex",i+1)=$$$vaSegLookthru(i,tId)
			If $D(..%maps("orefs",i)) Set ..%maps("orefs",i+1)=..%maps("orefs",i)  Kill ..%maps("orefs",i)
		}
		Set path=""
	} Else {
		Set path=$G($$$vaM("bidirectionalLink",pIndex))  Set:""'=path $$$vaM("runtimePath",path)="@"_pIndex
	}
	If pInsert||(pIndex=($$$vaM("runtimeIndex")+1)) Set $$$vaM("runtimeIndex")=$$$vaM("runtimeIndex")+1

	Set $$$vaM("runtimeIndex",pIndex)="@"
	Set pSegObj.DocType="" ; setting by index, the SegType might not match its new position
	Set ..%maps("orefs",pIndex)=pSegObj

	Kill:""=path $$$vaM("runtimePath"), $$$vaM("bidirectionalLink"), $$$vaM("loopIndex") ; we are operating only by IndexMap now.
	If ..AutoBuildMap { Do ..BuildMap(0) } Else { Set i%BuildMapStatus="" }
	Quit $$$OK
}

Method setSegmentByPath(pSegObj As EnsLib.EDI.ASTM.Segment, pPath As %String) As %Status [ Internal ]
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Object is immutable")
	Quit:(..DocTypeCategory="")||(""=..DocTypeName) $$$ERROR($$$EnsErrGeneral,"Cannot recognize path before DocType is set")
	Quit:'$$$IsdefObject(pSegObj) $$$ERROR($$$EnsErrGeneral,"Cannot set null segment object at position "_pPath)
	Do:'$D($$$vaM("runtimePath")) ..BuildMap()

	Set schema=$G($$$vaSchemaGbl(..DocTypeCategory,"DS",..DocTypeName,"map",..convertRuntimePathToSchemaPath(pPath)))
	Quit:""=schema $$$ERROR($$$EnsErrGeneral,"Path '"_pPath_"' is not mapped in schema for DocType '"_..DocType_"'")
	Set tSegType=$P(schema,"|",2), tSegName=$P(tSegType,":",2)
	Quit:tSegName'=pSegObj.Name $$$ERROR($$$EnsErrGeneral,"Cannot set segment named '"_pSegObj.Name_"' at position "_pPath)
	Set pSegObj.DocType=tSegType ; setting by path, Set the SegType to match its new position

	Set index=$G($$$vaM("bidirectionalLink",pPath))
	If index { Set seg="@"_index, $$$vaM("runtimeIndex",index)="@" }
	Else {
		Set seg=$G($$$vaM("runtimePath",pPath))
		If $$$vaIsOref(seg) { Set index=$E(seg,2,*) }
		Else {
			Set index=$O(..%maps("orefs",""))-1, seg="@"_index
			Kill $$$vaM("runtimeIndex"), $$$vaM("bidirectionalLink") ; we are operating only by PathMap now.
		}
	}
	Set ..%maps("orefs",index)=pSegObj
	Set $$$vaM("runtimePath",pPath)=seg
	If ..AutoBuildMap { Do ..BuildMap(0) }
	Else {
		Set i%BuildMapStatus=""
		#; Add relevant loopIndex node(s) if any
		Set pcs=$L(pPath,"(")-1, tHead=$P(pPath,"(",1,pcs)_"("
		For { Set tHead=$O($$$vaM("loopIndex",tHead_")"),-1), tLen=$L(tHead)  Quit:""=tHead
			If tHead=$E(pPath,1,tLen) { Set $$$vaM("loopIndex",tHead,$E(pPath,tLen+1,$F(pPath,")",tLen)-2))="", pcs=pcs-1, tHead=$P(pPath,"(",1,pcs)_"(" }
			Else {
				Set tPart="" For pcs=1:1 { Set tPrevPart=tPart, tPart=$P(pPath,"(",1,pcs)_"(", tLen=$L(tPart)
					If tPart'=$E(tHead,1,tLen) { Set tHead=tPrevPart  Quit }
				}
			}
			Quit:""=tHead||'pcs
		}
	}
	Quit $$$OK
}

Method setSegmentIdByIndex(pSegId As %String, pIndex As %Integer, pInsert As %Boolean) As %Status [ Internal ]
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Object is immutable")
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Quit:(pIndex\1'=pIndex)||(pIndex<1)||(pIndex>($$$vaM("runtimeIndex")+1)) $$$ERROR($$$EnsErrGeneral,"Index "_pIndex_" is out of bounds")

	If pInsert {
		Set tId=..%Id()  Set:'tId tId=..%ClonedId  For i=$$$vaM("runtimeIndex"):-1:pIndex { ; slide up all segments to make room for inserted one
			Set $$$vaM("runtimeIndex",i+1)=$$$vaSegLookthru(i,tId)
			If $D(..%maps("orefs",i)) Set ..%maps("orefs",i+1)=..%maps("orefs",i)  Kill ..%maps("orefs",i)
		}
		Set path=""
	} Else {
		Set path=$G($$$vaM("bidirectionalLink",pIndex))  Set:""'=path $$$vaM("runtimePath",path)="@"_pIndex
	}
	If pInsert||(pIndex=($$$vaM("runtimeIndex")+1)) Set $$$vaM("runtimeIndex")=$$$vaM("runtimeIndex")+1

	Set $$$vaM("runtimeIndex",pIndex)=pSegId

	Kill:""=path $$$vaM("runtimePath"), $$$vaM("bidirectionalLink"), $$$vaM("loopIndex") ; we are operating only by IndexMap now.
	If ..AutoBuildMap { Do ..BuildMap(0) } Else { Set i%BuildMapStatus="" }
	Quit $$$OK
}

Method setSegmentIdByPath(pSegId As %String, pPath As %String) As %Status [ Internal ]
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Object is immutable")
	Quit:(..DocTypeCategory="")||(..DocTypeName="") $$$ERROR($$$EnsErrGeneral,"Cannot recognize path unless DocType is set")
	Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)

	Set schema=$G($$$vaSchemaGbl(..DocTypeCategory,"DS",..DocTypeName,"map",..convertRuntimePathToSchemaPath(pPath)))
	Quit:""=schema $$$ERROR($$$EnsErrGeneral,"Path '"_pPath_"' is not mapped in schema for DocType '"_..DocType_"'")
	Set newseg=pSegId_"|"_..DocTypeCategory_":"_..DocTypeName_":"_$P(schema,"|",2)

	Set index=$G($$$vaM("bidirectionalLink",pPath))
	If index { Kill ..%maps("orefs",index)  Set $$$vaM("runtimeIndex",index)=newseg }
	Else {
		Set seg=$G($$$vaM("runtimePath",pPath))
		If $$$vaIsOref(seg) { Kill ..%maps("orefs",$E(seg,2,*)) }
		Else {
			Kill $$$vaM("runtimeIndex"), $$$vaM("bidirectionalLink") ; we are operating only by PathMap now.
		}
	}
	Set $$$vaM("runtimePath",pPath)=newseg
	If ..AutoBuildMap { Do ..BuildMap(0) } Else { Set i%BuildMapStatus="" }
	Quit $$$OK
}

Method removeSegmentByIndex(pIndex As %Integer) As %Status [ Internal ]
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Object is immutable")
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Set tId=..%Id()  Set:'tId tId=..%ClonedId
	Set seg=$$$vaSegLookthru(pIndex,tId)
	Quit:""=seg $$$ERROR($$$EnsErrGeneral,"Index "_pIndex_" is out of bounds")

	For i=pIndex:1:$$$vaM("runtimeIndex")-1 { ; slide all segments down over removed one
		Set $$$vaM("runtimeIndex",i)=$$$vaSegLookthru(i+1,tId)
		If $D(..%maps("orefs",i+1)) Set ..%maps("orefs",i)=..%maps("orefs",i+1)  Kill ..%maps("orefs",i+1)
	}
	Kill $$$vaM("runtimeIndex",$$$vaM("runtimeIndex")), ..%maps("orefs",$$$vaM("runtimeIndex"))
	Set $$$vaM("runtimeIndex")=$$$vaM("runtimeIndex")-1

	Kill $$$vaM("runtimePath"), $$$vaM("bidirectionalLink"), $$$vaM("loopIndex") ; we are operating only by IndexMap now.
	If ..AutoBuildMap { Do ..BuildMap(0) } Else { Set i%BuildMapStatus="" }
	Quit $$$OK
}

Method removeSegmentByPath(pPath As %String) As %Status [ Internal ]
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Object is immutable")
	Quit:(..DocTypeCategory="")||(..DocTypeName="") $$$ERROR($$$EnsErrGeneral,"Cannot recognize path before DocType is set")
	Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)

	Set seg=$G($$$vaM("runtimePath",pPath))  If seg="" Quit $$$ERROR($$$EnsErrGeneral,"No segment found at path '"_pPath_"'")
	If $$$vaIsOref(seg) { Kill ..%maps("orefs",$E(seg,2,*)) }
	Kill $$$vaM("runtimePath",pPath)

	Kill $$$vaM("runtimeIndex"), $$$vaM("bidirectionalLink") ; we are operating only by PathMap now.
	If ..AutoBuildMap { Do ..BuildMap(0) }
	Else {
		Set i%BuildMapStatus=""
		If pPath["(" {
			#; Invalidate relevant loopIndex sub-arrays if any
			Set tPathHead=$P(pPath,"(",$L(pPath,"(")-1)
			Set tHead=tPathHead For { Set tHead=$O($$$vaM("loopIndex",tHead))  Quit:tPathHead_"("'=$E(tHead,1,$L(tPathHead)+1)
				Kill $$$vaM("loopIndex",tHead)
			}
		}
	}
	Quit $$$OK
}

/// collapse segment object into just ID; Save if necessary
Method commitSegmentByIndex(pIndex As %Integer) As %Status
{
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath()
	Quit:(pIndex<1)||(pIndex>$$$vaM("runtimeIndex")) $$$ERROR($$$EnsErrGeneral,"Index "_pIndex_" is out of bounds")
	Set seg=$G($$$vaM("runtimeIndex",pIndex))
	Quit:'$$$vaIsOref(seg) $$$OK
	Set tSegObj=..%maps("orefs",pIndex)
	If tSegObj.IsMutable Set tSC=tSegObj.SaveData(..Separators) Quit:$$$ISERR(tSC) tSC
	Set newseg=tSegObj.ID_$S(""=tSegObj.DocType:"", 1:"|"_tSegObj.DocType)
	Set $$$vaM("runtimeIndex",pIndex)=newseg
	Set path=$G($$$vaM("bidirectionalLink",pIndex)) Set:""'=path $$$vaM("runtimePath",path)=newseg
	Kill ..%maps("orefs",pIndex)
	Quit $$$OK
}

/// collapse segment object into just Id; Save if necessary
Method commitSegmentByPath(pPath As %String) As %Status
{
	Do:'$D($$$vaM("runtimePath")) ..BuildMap(0)
	Set seg=$G($$$vaM("runtimePath",pPath))
	If seg="" Quit $$$ERROR($$$EnsErrGeneral,"No segment found at path '"_pPath_"'")
	If '$$$vaIsOref(seg) Quit $$$OK
	Set index=$E(seg,2,*)
	Set tSegObj=..%maps("orefs",index)
	If tSegObj.IsMutable Set tSC=tSegObj.SaveData(..Separators) Quit:$$$ISERR(tSC) tSC
	Set newseg=tSegObj.ID_$S(""=tSegObj.DocType:"", 1:"|"_tSegObj.DocType)
	Set $$$vaM("runtimePath",pPath)=newseg
	Kill ..%maps("orefs",index)
	Set index=$G($$$vaM("bidirectionalLink",pPath)) Set:""'=index $$$vaM("runtimeIndex",index)=newseg
	Quit $$$OK
}

/// collapse segment objects within the collectionPath into just Id; Save if necessary
Method commitCollectionOpenSegments(pCollectionPath As %String) As %Status
{
	If $Get(pCollectionPath)="" Return $$$OK
	#dim tCollectionPath = pCollectionPath_"."
	#dim seg
	#dim lengthCollectionPath = $Length(tCollectionPath)
	#dim tPath = $Order($$$vaM("runtimePath",tCollectionPath),1,seg)
	While ((tPath'="")&&($E(tPath,1,lengthCollectionPath)=tCollectionPath)) {
		#;Path will exist so no need to get return
		If $$$vaIsOref(seg) Do ..commitSegmentByPath(tPath)
		Set tPath = $Order($$$vaM("runtimePath",tPath),1,seg)
	}
	#; Return status so that can be called from DTL set
	Return $$$OK
}

Method convertRuntimePathToSchemaPath(pPath As %String) As %String
{
	Set tOutput=pPath
	Set f=0 For {
		Set f=$F(tOutput,"(",f) Quit:f=0
		Set g=$F(tOutput,")",f) If g=0 Set tOutput="" quit
		Set tOutput=$E(tOutput,1,f-1)_$E(tOutput,g-1,*)
		Set f=g
	}
	Quit tOutput
}

/// Given a runtime path, this method generates the key used for collation
Method getOrderKeyFromRuntimePath(pRuntimePath As %String) As %String [ Internal ]
{
	Set tSchemaPath=pRuntimePath, tRuntimeIndex=0
	Set f=0 For {
		Set f=$F(tSchemaPath,"(",f) Quit:f=0
		Set g=$F(tSchemaPath,")",f) If g=0 Set tSchemaPath="" Quit
		Set tRuntimeIndex($I(tRuntimeIndex))=$E(tSchemaPath,f,g-2)
		Set tSchemaPath=$E(tSchemaPath,1,f-1)_$E(tSchemaPath,g-1,*)
		Set f=g
	}
	Quit:""=tSchemaPath ""
	Set tMapValue=$G($$$vaSchemaGbl(..DocTypeCategory,"DS",..DocTypeName,"map",tSchemaPath))  Quit:""=tMapValue ""
	Set tKey=$P(tMapValue,"|")
	Set f=1 For i=1:1:tRuntimeIndex {
		Set f=$F(tKey,"*",f)  Quit:'f
		Set $E(tKey,f-1)=$$$NUM(tRuntimeIndex(i),8)
	}
	#; If couldn't find a replacement position or there are remaining unfilled replacement positions then key is invalid
	Quit:tKey["*"||'f ""
	Quit tKey
}

Method buildRuntimeIndexFromPath(pClearSegTypes As %Boolean = 0) As %Status [ Internal ]
{
	$$$ASSERT('$D($$$vaM("runtimeIndex"))&&'$D($$$vaM("bidirectionalLink")))
	Set tPath="" For { Set tPath=$O($$$vaM("runtimePath",tPath))  Quit:""=tPath
		Set tOrderKey=..getOrderKeyFromRuntimePath(tPath)  Continue:""=tOrderKey
		Set $$$vaM("OrderKeyToRuntimePath",tOrderKey)=tPath
	}
	#; Re-Order mapOrefs according to new index sequence.
	Set key="",index=0 For { Set key=$O($$$vaM("OrderKeyToRuntimePath",key),1,tPath)  Quit:key=""
		Set seg=$$$vaM("runtimePath",tPath)
		Set index=index+1
		If $$$vaIsOref(seg) {
			Set oldindex=$E(seg,2,*)
			Set tSegObj=..%maps("orefs",oldindex)
			Set:pClearSegTypes tSegObj.DocType=""
			If oldindex'=index {
				Set $$$vaM("runtimePath",tPath)="@"_index  Kill ..%maps("orefs",oldindex)
				#; Migrate ..mapOrefs if needed rather than doing it in place, because re-ordering in Path mode may have occurred after runtimeIndex map was killed
				If $D(..%maps("orefs",index)) { Set tMapOrefs(index)=tSegObj } Else { Set ..%maps("orefs",index)=tSegObj }
			}
			Set $$$vaM("runtimeIndex",index)="@"
		} Else {
			Set:pClearSegTypes seg=$P(seg,"|")
			Set $$$vaM("runtimeIndex",index)=seg
		}
		Set $$$vaM("bidirectionalLink",index)=tPath, $$$vaM("bidirectionalLink",tPath)=index
	}
	Kill $$$vaM("OrderKeyToRuntimePath")
	Merge ..%maps("orefs")=tMapOrefs
	Set $$$vaM("runtimeIndex")=index, $$$vaM("runtimeIndex",0)="" ; set a marker for negative path indices
	Quit $$$OK
}

Method %OnConstructClone(object As %RegisteredObject, deep As %Boolean = 0, ByRef cloned As %String) As %Status [ Private, ProcedureBlock = 1 ]
{
	$$$vaMgetIndex

#ifndef LOCALMAPS
	#; copy runtime maps from old instance
	Merge $$$vaM("runtimePath")=$$$vaMobj(object,"runtimePath")
	Merge $$$vaM("bidirectionalLink")=$$$vaMobj(object,"bidirectionalLink")
	Set tId=object.%Id()  Merge:tId $$$vaM("runtimeIndex")=$$$vaExtentGbl(tId,"segs") ; no lookthru to other guy's Id
	Merge $$$vaM("runtimeIndex")=$$$vaMobj(object,"runtimeIndex")
#endif	
	#; Clone segment objects so the clone can continue to use them without changing the original's data or properties
	Set index="" For { Set index=$O(object.%maps("orefs",index),1,tSegObj)  Quit:""=index
		Set ..%maps("orefs",index)=tSegObj.%ConstructClone()
	}
	Set i%IsMutable=1 ; mark it mutable
	Set i%%ClonedId=object.%ClonedId  Set:'..%ClonedId i%%ClonedId=object.%Id()  Set:'..%ClonedId i%%ClonedId=0
	Quit $$$OK
}

/// create an object based on id=initvalue but editable
Method %OnNew(initvalue As %RawString = "") As %Status [ Private ]
{
	Set tSegmentIds=$LG(initvalue,1), ..Separators=$LG(initvalue,2), i%Source=$LG(initvalue,3)
	Set:""=..Separators ..Separators=$$$ASTMDefSeparators
	$$$vaMgetIndex
	Set $$$vaM("runtimeIndex")=$LL(tSegmentIds), $$$vaM("runtimeIndex",0)="" ; set a marker for negative path indices
	For i=1:1:$$$vaM("runtimeIndex") { Set $$$vaM("runtimeIndex",i)=$LI(tSegmentIds,i) }
	Quit $$$OK
}

Method %OnOpen() As %Status [ Private ]
{
	Set tId=..%Id()
	$$$vaMgetIndex
	Set cnt=$G($$$vaExtentGbl(tId,"segs")), $$$vaM("runtimeIndex")=cnt, $$$vaM("runtimeIndex",0)="" ; set a marker for negative path indices
	If 'cnt { Set ..Separators=$$$ASTMDefSeparators }
	Else { Set seg1id=$$$vaExtentGbl(tId,"segs",1), ..Separators=$E($$$vaSegmentGbl(seg1id),1,4) }
	Set i%DocTypeCategory=$P(..DocType,":",1)
	Set i%DocTypeName=$P(..DocType,":",2)
	#; No automatic BuildMap here - allow cheap instantiation for portal etc; do BuildMap() only when called for
	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	Set tSC=$$$OK, tId=..%Id()
	Do:'$D($$$vaM("runtimeIndex"))&&$D($$$vaM("runtimePath")) ..buildRuntimeIndexFromPath()
	Set count=+$G($$$vaM("runtimeIndex"))  For index=1:1:count { Set seg=$$$vaSegLookthru(index,..%ClonedId)
		If $$$vaIsOref(seg) {
			Set tSegObj=..%maps("orefs",index)
			Set tSC=tSegObj.SaveData(..Separators)  Quit:$$$ISERR(tSC)
			Set segid=tSegObj.ID
		} Else {
			Set segid=$P(seg,"|")
		}
		If segid {
			Set $$$vaExtentGbl(tId,"segs",index)=segid
			Set $$$vaSegmentGbl(segid,0,tId)=""
			Kill $$$vaOpenSegmentPPG(segid)
		}
	}
	For index=count+1:1:+$G($$$vaExtentGbl(tId,"segs")) { Kill $$$vaExtentGbl(tId,"segs",index) } ; Kill leftovers if we shrank
	Set $$$vaExtentGbl(tId,"segs")=count
	Set i%%ClonedId=0
	Quit tSC
}

Method PokeDocType(pDocType As %String) As %Status [ CodeMode = expression ]
{
..DocTypeSet(pDocType,0)
}

Method DocTypeSet(pDocType As %String, pBuildMap As %Boolean = 1) As %Status
{
	Quit:pDocType=..DocType&&$D($$$vaM("runtimePath")) $$$OK ; nothing is changed

	#; convert runtimePath to runtimeIndex and then Kill runtimePath
	Do:'$D($$$vaM("runtimeIndex"))&&$D($$$vaM("runtimePath")) ..buildRuntimeIndexFromPath(1) ; 1 = clear types
	Kill $$$vaM("runtimePath"), $$$vaM("bidirectionalLink"), $$$vaM("loopIndex")
	Set i%DocType=pDocType
	Set i%DocTypeCategory=$P(pDocType,":",1)
	Set i%DocTypeName=$P(pDocType,":",2)
	Do:pBuildMap ..BuildMap()
	Quit $$$OK
}

/// pKeepParsingAfterError means keep trying to parse after errors are encountered; returned Status will contain all errors encountered
Method BuildMap(pKeepParsingAfterError As %Boolean = 1) As %Status
{
	If ((""=..DocTypeCategory)||(""=..DocTypeName)) {
		Set i%BuildMapStatus=$S(""=..DocType:"", 1:$$$ERROR($$$EnsEDIErrMapDocType,"ASTM",..DocType))
	} Else {
		Quit:$D($$$vaM("runtimePath"))&&(""'=..BuildMapStatus) ..BuildMapStatus ; already done
		Set i%BuildMapStatus=""
	}
	Do:'$D($$$vaM("runtimeIndex")) ..buildRuntimeIndexFromPath(1) ; 1 = clear types
	Kill $$$vaM("runtimePath"), $$$vaM("bidirectionalLink"), $$$vaM("loopIndex")

	Quit:""=..DocType $$$OK
	Quit:""'=..BuildMapStatus ..BuildMapStatus

	Set tSchema=$G($$$vaSchemaGbl(..DocTypeCategory,"DS",..DocTypeName))
	If tSchema="" {
		Set i%BuildMapStatus=$$$ERROR($$$EnsEDIErrMapDocType,"ASTM",..DocType)
		Quit ..BuildMapStatus
	}
	Set tId=..%Id()  Set:'tId tId=..%ClonedId
	Set tCurrSeg=1, %seglastmatch=0, %pathlastmatch=""
	Set tSC=..buildRuntimePathFromIndex(tId,"",$Name($$$vaSchemaGbl)_"("""_..DocTypeCategory_""",""DS"","""_..DocTypeName_""",""array"")","top",.tCurrSeg,0,$$$OK,pKeepParsingAfterError)
	$$$ASSERT(%seglastmatch=(tCurrSeg-1))
	#; Map leftover segments
	Set tSegments=$$$vaM("runtimeIndex")
	If tCurrSeg<=tSegments {
		For i=tCurrSeg:1:tSegments {
			Set seg=$$$vaSegLookthru(i,tId)
			If $$$vaIsOref(seg) {
				Set $$$vaM("runtimePath","leftoversegs("_(i+1-tCurrSeg)_")")="@"_i
			} Else {
				Set segid=$P(seg,"|")
				Set $$$vaM("runtimePath","leftoversegs("_(i+1-tCurrSeg)_")")=segid
			}	
		}
		If pKeepParsingAfterError||$$$ISOK(tSC) {
			#; Find current Segment's Type Name
			Set seg=$$$vaSegLookthru(tCurrSeg,tId)
			If $$$vaIsOref(seg) {
				Set tSegObj=..%maps("orefs",tCurrSeg)
				Set currsegname=tSegObj.Name
			} Else {
				Set data=$G($$$vaSegmentGbl($P(seg,"|")))
				Set currsegname=$$$vaDataSegName(data)
			}
			If tCurrSeg=1 { Set lastname="" }
			Else {
				#; Find previous Segment's Type Name
				Set seg=$$$vaSegLookthru(tCurrSeg-1,tId)
				If $$$vaIsOref(seg) {
					Set tSegObj=..%maps("orefs",tCurrSeg-1)
					Set lastname=tSegObj.Name
				} Else {
					Set data=$G($$$vaSegmentGbl($P(seg,"|")))
					Set lastname=$$$vaDataSegName(data)
				}
			}
			Set lastmatch=$S(""'=lastname&&%seglastmatch:%seglastmatch_" ("_%pathlastmatch_")", 1:"0")
			Set tSC=$$$ADDSC(tSC,$$$ERROR($$$EnsEDIErrMapSegUnrecog,currsegname,lastmatch))
		}
	}
	Kill %seglastmatch, %pathlastmatch
	Set i%BuildMapStatus=tSC
	Quit tSC
}

/// Build a segment map for the current segment index array based on the document schema<br>
/// If <var>pKeepParsingAfterError</var> is false then stop parsing when first error is encountered<br>
Method buildRuntimePathFromIndex(pId As %String, pPath As %String, pContentArray As %String, pType As %String, ByRef pCurrSeg As %Integer, pParentGrpOpt As %Boolean, pSC As %Status, pKeepParsingAfterError As %Boolean) As %Status
{
	Set tSegments=$$$vaM("runtimeIndex"), currsegname=""
	Set type=$P(pType,"(",1,$L(pType,"(")), len=$L(type), tIsUnion="union"=$E(type,len+1-$L("union"),len)
	Set tGrpOpt=(pParentGrpOpt||$G(@pContentArray@("opt"),0)), tFirstReq="", tGrpSeg=pCurrSeg
	For i=1:1:$G(@pContentArray) { ; loop over sub-elements of the root element at this level
		Set pIContents=$Name(@pContentArray@(i))
		Set opt=$G(@pIContents@("opt"),0), tFirstReq=$S(""=tFirstReq&&'opt:1, ""=tFirstReq:"", 1:0)
		Set type=@pIContents@("type")
		Set segtype=$P(type,":",3)
		Set isrep=$P(segtype,"(",2), tMaxReps=$Case(isrep, ")":0, "":1, :+isrep), isrep=(""'=isrep), tRequiredReps='opt
		Set segtype=$P(segtype,"(") ; strip off parens
		Set keyfields=$P(segtype,"-",2), segtype=$P(segtype,"-") ; split off key fields indicator
		Set segname=$P(@pIContents@("name"),"(")
		Set subs=$G(@pIContents,0)
		Set tISeg=pCurrSeg
		For rep=1:1 { Quit:rep>tMaxReps&&tMaxReps ; loop for repetitions of the current sub-element
			Set tBaseSeg=pCurrSeg
			Set tIPath=$S(""=pPath:"",1:pPath_".")_segname_$S(isrep:"("_rep_")",1:"")
			#;If isrep&&(rep=1)&&(i=1)&&opt Set pSC=$$$ADDSC(pSC,$$$ERROR($$$EnsEDIErrMapGeneral,"Schema error at "_tIPath_" - the first element in a repeating group must not be optional"))  Quit

			If subs {
				Set pSC=..buildRuntimePathFromIndex(pId,tIPath,pIContents,type,.pCurrSeg,tGrpOpt||(rep>tRequiredReps),pSC,pKeepParsingAfterError)
			} Else {
				#; Find current Segment's Type Name
				If pCurrSeg>tSegments {
					Set currsegname=""
				} Else {
					Set seg=$$$vaSegLookthru(pCurrSeg,pId)
					If $$$vaIsOref(seg) {
						Set tSegObj=..%maps("orefs",pCurrSeg)
						Set data=$E(tSegObj.Separators,1,4)_tSegObj.GetValueAt()
					} Else {
						Set data=$G($$$vaSegmentGbl($P(seg,"|")))
					}
					Set currsegname=$$$vaDataSegName(data)
				}
				#; Check for segment type match
				If segtype=currsegname &&(""=keyfields
				 || $$keyfieldsMatch(keyfields,data)) {	
					#; Set seg address/schema at path into runtimePath
					Set schema=$P($P(type,":",2,3),"(")
					Set seg=$$$vaSegLookthru(pCurrSeg,pId)
					If $$$vaIsOref(seg) {
						Set $$$vaM("runtimePath",tIPath)="@"_pCurrSeg
						Set ..%maps("orefs",pCurrSeg).DocType=schema
					} Else {
						Set seg=$P(seg,"|")_"|"_schema
						Set $$$vaM("runtimeIndex",pCurrSeg)=seg
						Set $$$vaM("runtimePath",tIPath)=seg
					}
					Set $$$vaM("bidirectionalLink",pCurrSeg)=tIPath, $$$vaM("bidirectionalLink",tIPath)=pCurrSeg

					Set %seglastmatch=pCurrSeg, %pathlastmatch=tIPath
					Set:pCurrSeg<=tSegments pCurrSeg=pCurrSeg+1, currsegname=""
				}
			}
			If tBaseSeg=pCurrSeg { ; found no match in repeat loop
				Set:rep<tRequiredReps&&'tIsUnion&&'tGrpOpt pSC=$$$ADDSC(pSC,$$$ERROR($$$EnsEDIErrMapSegCount,tRequiredReps,tIPath,pCurrSeg_$S(""=$G(currsegname):"",1:" ("_currsegname_")")))
				Quit
			} Else {
				Set tGrpOpt=0
				Quit:pCurrSeg>tSegments
			}
		}
		Quit:$$$ISERR(pSC)&&'pKeepParsingAfterError
		If tISeg=pCurrSeg { ; found no match at element i
			If 'opt&&'tIsUnion {
				Quit:i=1
				Set:'tGrpOpt pSC=$$$ADDSC(pSC,$$$ERROR($$$EnsEDIErrMapRequired,tIPath,pCurrSeg_$S(""=$G(currsegname):"",1:" ("_currsegname_")")))
				Quit:tFirstReq||'pKeepParsingAfterError
			}
		} Else {
			Set tGrpOpt=0
			Quit:tIsUnion
		}
	}
	If tIsUnion {
		If tGrpSeg=pCurrSeg { ; found no match in any union element
			Set:'tGrpOpt pSC=$$$ADDSC(pSC,$$$ERROR($$$EnsEDIErrMapRequiredUnion,pPath,pCurrSeg_$S(""=$G(currsegname):"",1:" ("_currsegname_")")))
		}
	}
	Quit pSC
keyfieldsMatch(pKeyFields,pData) ; local routine that returns true if all keyfields match the data
	Set tMatch=1, nFlds=$L(pKeyFields,"&") For iFld=1:1:nFlds { Set tKey=$P(pKeyFields,"&",iFld)  Continue:""=tKey
		If (tKey'=$$$SEGELEM(pData,2)) Set tMatch=0  Quit
	}
	Quit tMatch
}

Method DumpMaps() As %Status
{
	Set DocType=..DocType w ! zw DocType
	w !,"DocTypeCategory,DocTypeName="_..DocTypeCategory_","_..DocTypeName
	Set BuildMapStatus=..BuildMapStatus w ! zw BuildMapStatus
	If ""'=..DocTypeCategory&&(""'=..DocTypeName) {
		Merge mapSchemaPath=$$$vaSchemaGbl(..DocTypeCategory,"DS",..DocTypeName,"map") w ! zw mapSchemaPath
		Merge mapContentArray=$$$vaSchemaGbl(..DocTypeCategory,"DS",..DocTypeName,"array") w ! zw mapContentArray
	}
	Merge mapRuntimeIndex=$$$vaM("runtimeIndex") w ! zw mapRuntimeIndex
	Merge mapRuntimePath=$$$vaM("runtimePath") w ! zw mapRuntimePath
	Merge mapBidirectionalLink=$$$vaM("bidirectionalLink") w ! zw mapBidirectionalLink
	Merge mapLoopIndex=$$$vaM("loopIndex") w ! zw mapLoopIndex
 	Merge mapOrefs=..%maps("orefs") w ! zw mapOrefs
	Quit $$$OK
}

ClassMethod GetContentArray(Output pContents, pMode As %String, pDocType As %String, pLevel As %Integer, pIncludeBase As %Boolean) As %Status [ CodeMode = expression ]
{
##class(EnsLib.EDI.ASTM.Schema).GetContentArray(.pContents,.pMode,.pDocType,.pLevel,.pIncludeBase)
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
Query EnumerateDocTypes(Category As %String = "", IncludeBase As %Boolean = 1) As %Query(CONTAINID = 0, ROWSPEC = "Type:%String")
{
}

ClassMethod EnumerateDocTypesExecute(ByRef qHandle As %Binary, Category As %String = "", IncludeBase As %Boolean) As %Status [ CodeMode = expression ]
{
##class(EnsLib.EDI.ASTM.Schema).DocStructuresExecute(.qHandle,.Category,.IncludeBase)
}

ClassMethod EnumerateDocTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer) As %Status [ PlaceAfter = EnumerateDocTypesExecute ]
{
	Set tSC=##class(EnsLib.EDI.ASTM.Schema).DocStructuresFetch(.qHandle,.Row,.AtEnd)
	Set:""'=$G(Row) Row=$LB($LG(Row))
	Quit tSC
}

ClassMethod EnumerateDocTypesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateDocTypesExecute ]
{
##class(EnsLib.EDI.ASTM.Schema).DocStructuresClose(.qHandle)
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
##class(EnsLib.EDI.ASTM.Schema).TypeCategoriesExecute(.qHandle, Standard)
}

ClassMethod EnumerateTypeCategoriesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer) As %Status [ PlaceAfter = EnumerateTypeCategoriesExecute ]
{
	Set tSC=##class(EnsLib.EDI.ASTM.Schema).TypeCategoriesFetch(.qHandle,.Row,.AtEnd)
	Quit tSC
}

ClassMethod EnumerateTypeCategoriesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateTypeCategoriesExecute ]
{
##class(EnsLib.EDI.ASTM.Schema).TypeCategoriesClose(.qHandle)
}

/// Returns a list of schema categories and segment types and segment fields for this document class. <br/>
/// The <var>Category</var> and <var>Level</var> parameters can be used to restrict the list. <br/>
/// If <var>Category</var> is: <br/>
///  0 - return only standard categories <br/>
///  + - return only user-defined categories <br/>
///  empty - return all categories <br/>
///  a category name - return only SegTypes in the named category <br/>
///  a category name:segment type name - return only information about the named SegType <br/>
///  a partial name suffixed with '%' - return only SegTypes in categories matching the partial category name <br/>
///  other - return nothing <br/>
/// If <var>Level</var> is: <br/>
///  0 - return all segment names <br/>
///  n - return the given number of levels of nested field names within each segment <br/>
///  empty - return all levels of nested field names within each segment <br/>
/// If <var>IncludeBase</var> is: <br/>
///  0 - return only segment names defined in the current schema category itself <br/>
///  1 - return all segment names in the current schema category's base category in addition to those defined in the current category itself <br/>
Query EnumerateSegTypes(Category As %String = "", Level As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "SegType:%String,Field:%String,Description:%String,IsStandard:%Boolean")
{
}

ClassMethod EnumerateSegTypesExecute(ByRef qHandle As %Binary, Category As %String, Level As %String, IncludeBase As %Boolean) As %Status [ CodeMode = expression ]
{
##class(EnsLib.EDI.ASTM.Schema).SegTypesExecute(.qHandle,.Category,.Level,.IncludeBase)
}

ClassMethod EnumerateSegTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer) As %Status [ PlaceAfter = EnumerateSegTypesExecute ]
{
	Set tSC=##class(EnsLib.EDI.ASTM.Schema).SegTypesFetch(.qHandle,.Row,.AtEnd)
	Quit tSC
}

ClassMethod EnumerateSegTypesClose(ByRef qHandle As %Binary) As %Status [ CodeMode = expression, PlaceAfter = EnumerateSegTypesExecute ]
{
##class(EnsLib.EDI.ASTM.Schema).SegTypesClose(.qHandle)
}

/// This method computes the Alias string for a property name, given the property's node in the Content Array.
ClassMethod GetAlias(pContentArrayName As %String, pArrayPos As %String) As %String [ CodeMode = expression ]
{
##class(EnsLib.EDI.ASTM.Schema).GetAlias(pContentArrayName,pArrayPos)
}

ClassMethod checkDocType(ByRef pDocType As %String) As %Status
{
	Set tSC=$$$OK
	Set category=$P(pDocType,":",1)
	Set secondary=$P(pDocType,":",2)
	If (""=category)||(""=secondary)||(""=$G($$$vaSchemaGbl(category,"DS",secondary))) {
		Set tSC=$$$ERROR($$$EnsEDIErrMapDocType,"ASTM",pDocType)
	}
	Quit tSC
}

/// This method is for use from the RawContent property's SQL Compute invocation
ClassMethod getSegsAsString(pId As %String, pMaxLen As %Integer = 10000, pStartOffset As %Integer = 1) As %String
{
	#; Use delimiters from first segment, translate all subsequent delims to those; SegTerminator=$C(13,10)
	Set str=""  For index=1:1:+$G($$$vaExtentGbl(pId,"segs")) { Set data=$$$vaSegmentGbl($$$vaExtentGbl(pId,"segs",index))
		Set:index=1 tSeparators=$E(data,1,4)
		Set:tSeparators'=$E(data,1,4) data=##class(EnsLib.EDI.ASTM.Segment).replaceSeparators(data, tSeparators)
		If pStartOffset>1 {
			If pStartOffset>($L(data)-4+2) { Set pStartOffset=pStartOffset-($L(data)-4+2) }
			Else { Set pStartOffset=1, data=$E(data,pStartOffset,*) }
		}
		If pMaxLen-$L(str)>=($L(data)-4+2) { Set str=str_$E(data,5,*)_$C(13,10) }
		Else { Set str=str_$E(data_$C(13,10),5,4+pMaxLen-$L(str)) }
		Quit:$L(str)>=pMaxLen
	}
	Quit str
}

Method OutputToFile(pFilename As %String, pOverwrite As %Boolean, pSeparators As %String, pDoFraming As %Integer, pResponseTimeout As %Numeric = -1, pIOFormatClassname As %String) As %Status
{
	Set tIOStream=##Class(%IO.FileStream).%New()
	Do tIOStream.Open(pFilename,$S($G(pOverwrite):"NEW",1:"AEW"),5,,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ..OutputToIOStream(tIOStream, .pSeparators, .pDoFraming, .pResponseTimeout, .pIOFormatClassname)
}

Method OutputToDevice(pSeparators As %String, pDoFraming As %Integer, pResponseTimeout As %Numeric = -1, pIOFormatClassname As %String) As %Status
{
	Set tDeviceStream=##class(%IO.DeviceStream).AttachNew(,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ..OutputToIOStream(tDeviceStream, .pSeparators, .pDoFraming, .pResponseTimeout, .pIOFormatClassname)
}

Method OutputToLibraryStream(pLibStream As %Stream.Object, pSeparators As %String, pDoFraming As %Integer, pResponseTimeout As %Numeric = -1, pIOFormatClassname As %String) As %Status
{
	Set tIOStream=$S(pLibStream.%Extends("%IO.I.CharacterStream"):pLibStream, 1:##Class(%IO.MetaCharacterStream).%New(pLibStream))
	Quit ..OutputToIOStream(tIOStream, .pSeparators, .pDoFraming, .pResponseTimeout, .pIOFormatClassname)
}

Method OutputToString(pSeparators As %String, pDoFraming As %Integer, pResponseTimeout As %Numeric = -1, Output pStatus As %Status, pIOFormatClassname As %String) As %String
{
	Set tIOStream=##Class(%IO.StringStream).%New()
	Set pStatus = ..OutputToIOStream(tIOStream, .pSeparators, .pDoFraming, .pResponseTimeout, .pIOFormatClassname)
	Do tIOStream.Rewind()
	Quit tIOStream.Read()
}

Method OutputToIOStream(pIOStream As %IO.I.CharacterStream, pSeparators As %String, ByRef pDoFraming As %Integer = 0, pResponseTimeout As %Numeric = -1, pIOFormatClassname As %String = "") As %Status
{
	Set tSC=$$$OK  Set pDoFraming=$S(pDoFraming>7:2, pDoFraming<-7:-2, 1:pDoFraming)
	Set tSeparators=$S(""=$G(pSeparators):..Separators, 1:pSeparators)  Set:""=tSeparators tSeparators=$$$ASTMDefSeparators
	If ""=pIOFormatClassname || '$classmethod(pIOFormatClassname,"OutputDocument",$this,.tSC,pIOStream,tSeparators) {
		Do:'$D($$$vaM("runtimeIndex"))&&$D($$$vaM("runtimePath")) ..buildRuntimeIndexFromPath()
		For i=1:1:$G($$$vaM("runtimeIndex")) { Set tSeg=..getSegmentByIndex(i)
			Set tSC=tSeg.OutputToIOStream(pIOStream, tSeparators, .pDoFraming, .pResponseTimeout)
			Do ..commitSegmentByIndex(i)
		}
		Do:""'=pIOFormatClassname $classmethod(pIOFormatClassname,"OutputDocumentEnd",$this,.tSC,pIOStream,tSeparators)
		If $$$ISOK(tSC) {
			If pDoFraming { Do pIOStream.Write($$$EOT,1,.tSC) }
			Else { Do pIOStream.Flush(.tSC) }
		}
	}
	Quit tSC
}

/// Display Segments as HTML, using DocType info if available
Method OutputHTML() As %Status
{
	Set tSC=$$$OK
	Set tSeparators=..Separators  Set:""=tSeparators tSeparators=$$$ASTMDefSeparators
	Quit ..OutputToDevice(tSeparators,,,"EnsLib.EDI.ASTM.Util.FormatHTML")
}

/// Display Segments as HTML, using DocType info if available
Method OutputHTMLZen() As %Status
{
	Set tSC=$$$OK
	Set tSeparators=..Separators  Set:""=tSeparators tSeparators=$$$ASTMDefSeparators
	Quit ..OutputToDevice(tSeparators,,,"EnsLib.EDI.ASTM.Util.FormatHTMLZen")
}

ClassMethod ImportFromFile(pFilename As %String, pDocNum As %Integer = 1, Output pStatus As %Status, ByRef pConfigItem As %String, pIOFormatClassname As %String) As EnsLib.EDI.ASTM.Document
{
	Set tIOStream=##Class(%IO.FileStream).%New()
	Set tIOStream.LineTerminator=$C(13,10) ; override OS dependent default
	Do tIOStream.Open(pFilename,,5,,.pStatus)  Quit:$$$ISERR(pStatus) $$$NULLOREF
	$$$sysTRACE("Opened file '"_pFilename_"'")
	Set tDoc=$$$NULLOREF  For i=1:1:pDocNum {
		If tIOStream.AtEnd Set pStatus=$$$ERROR($$$EnsErrGeneral,"Fewer than "_pDocNum_" documents in file "_pFilename)  Quit
		Set tDoc=..ImportFromIOStream(tIOStream,.pStatus,.pConfigItem,.pIOFormatClassname)  Quit:$$$ISERR(pStatus)
	}
	Quit:$$$ISERR(pStatus) $$$NULLOREF
	Quit tDoc
}

ClassMethod ImportFromDevice(Output pStatus As %Status, ByRef pConfigItem As %String, pIOFormatClassname As %String) As EnsLib.EDI.ASTM.Document
{
	Set tDeviceStream=##class(%IO.DeviceStream).AttachNew(,.tSC)  Quit:$$$ISERR(tSC) tSC
	Quit ..ImportFromIOStream(tDeviceStream,.pStatus,.pConfigItem,.pIOFormatClassname)
}

ClassMethod ImportFromLibraryStream(pLibStream As %Stream.Object, Output pStatus As %Status, ByRef pConfigItem As %String, pIOFormatClassname As %String) As EnsLib.EDI.ASTM.Document
{
	Set tIOStream=$S(pLibStream.%Extends("%IO.I.CharacterStream"):pLibStream,1:##Class(%IO.MetaCharacterStream).%New(pLibStream))
	Quit ..ImportFromIOStream(tIOStream,.pStatus,.pConfigItem,.pIOFormatClassname)
}

ClassMethod ImportFromString(pString As %String, Output pStatus As %Status, ByRef pConfigItem As %String, pIOFormatClassname As %String) As EnsLib.EDI.ASTM.Document
{
	Set tIOStream=##Class(%IO.StringStream).%New(pString)
	Quit ..ImportFromIOStream(tIOStream,.pStatus,.pConfigItem,.pIOFormatClassname)
}

ClassMethod ImportFromIOStream(pIOStream As %IO.I.CharacterStream, Output pStatus As %Status = {$$$OK}, ByRef pConfigItem As %String = "", pIOFormatClassname As %String = "") As EnsLib.EDI.ASTM.Document
{
	Quit:""'=pIOFormatClassname&&$classmethod(pIOFormatClassname,"ImportDocument",.tDoc,.pStatus,pIOStream,pConfigItem) tDoc

	If ""'=pConfigItem {
		If $IsObject(pConfigItem) {
			Set tInst=pConfigItem
		} Else {
			Set tInst=##class(Ens.Host).GetShadowInstance(pConfigItem,.pStatus)  Quit:$$$ISERR(pStatus) $$$NULLOREF
		}
		If 'tInst.%Extends("EnsLib.EDI.ASTM.Service.Standard") Set pStatus=$$$ERROR($$$EnsErrGeneral,"Config Item class "_$classname(tInst)_" found For "_pConfigItem_" is not not an EDI document Service")  Quit $$$NULLOREF
	} Else {
		Set tInst=##class(Ens.Host).GetShadowInstance("class ||EnsLib.EDI.ASTM.Service.FileService",.pStatus)  Quit:$$$ISERR(pStatus) $$$NULLOREF
	}
	#; Get a new parser based on a Service; OnInit not called for shadow service instances
	If '$IsObject(tInst.%Parser) Set tInst.%Parser=##class(EnsLib.EDI.ASTM.Parser).%New(tInst)  $$$ASSERT($IsObject(tInst.%Parser))

	If tInst'=pConfigItem { ; override some default properties if we created the shadow instance
		Set tInst.SearchTableClass=""
	}
	#; call the parser
	Set tInst.%PreserveSession=2 ; don't let Service process the document
	Set pStatus=tInst.%Parser.ParseIOStream(pIOStream,.tDoc)
	Set pConfigItem=tInst ; allow repeated calls on the same parser
	Quit tDoc
}

Method CopyValues(pSource As EnsLib.EDI.ASTM.Document, pSourcePath As %String, pTargetPath As %String, pAction As %String, pKey As %String, pEmptyFieldAsNull As %Boolean = 0, pIgnoreMissingSource As %Boolean = 0) As %Status
{
	Set tSC=$$$OK
	Set tSourceWild=$F(pSourcePath,"()"), tTargetWild=$F(pTargetPath,"()")
	If tSourceWild||tTargetWild {
		Set tSourceHead=$E(pSourcePath,1,tSourceWild-3), tSourceTail=$E(pSourcePath,tSourceWild,*)
		Set tTargetHead=$E(pTargetPath,1,tTargetWild-3), tTargetTail=$E(pTargetPath,tTargetWild,*)
		If tSourceWild {
			If pEmptyFieldAsNull {
				If (tTargetWild)&&(tSourceHead [ ":")&&(tTargetHead [ ":") {
					Quit:(pSource.GetValueAt(tSourceHead)="") $$$OK
				}
			}
			Set i="" For { Set i=pSource.GetNextIndex(tSourceHead_"()",i,.tSC) Quit:i=""
				Set tSourceNewPath=tSourceHead_"("_(i)_")"_tSourceTail
				Set tTargetNewPath=$S(tTargetWild:tTargetHead_"("_(i)_")"_tTargetTail,1:pTargetPath)
				Set tSC2=..CopyValues(pSource,tSourceNewPath,tTargetNewPath,pAction,pKey,pEmptyFieldAsNull,pIgnoreMissingSource)
				If $$$ISERR(tSC2)&&('pIgnoreMissingSource||(($$$StatusText(tSC2)'["No segment found")&&($$$StatusText(tSC2)'["is not an element, instead this node"))) {
					Set tSC=tSC2
					Quit
				}
			
			}
		} Else {
			Set i="" For { Set i=..GetNextIndex(tTargetHead_"()",i,.tSC) Quit:i=""
				Set tTargetNewPath=tTargetHead_"("_(i)_")"_tTargetTail
				Set tSC=..CopyValues(pSource,pSourcePath,tTargetNewPath,pAction,pKey,pEmptyFieldAsNull,pIgnoreMissingSource) Quit:$$$ISERR(tSC)
			}
		}
	} Else {
		Set tSourceGrpPath=$P(pSourcePath,":"), tSourcePropPath=$P(pSourcePath,":",2)
		Set tTargetGrpPath=$P(pTargetPath,":"), tTargetPropPath=$P(pTargetPath,":",2)
		Set tSrcSegPath=pSource.GetNextGroupPath(tSourceGrpPath,tSourceGrpPath)
		Set tTrgSegPath=..GetNextGroupPath(tTargetGrpPath,tTargetGrpPath)
		If (""'=tSrcSegPath)||(""'=tTrgSegPath) { ; if there are group sub-elements
			If (""'=tSrcSegPath) {
				For {
					Set tSourceNewPath=tSrcSegPath_$S(""=tSourcePropPath:"",1:":"_tSourcePropPath)
					Set tTargetNewPath=tTargetGrpPath_$E(tSrcSegPath,1+$L(tSourceGrpPath),$L(tSrcSegPath))_$S(""=tSourcePropPath:"",1:":"_tSourcePropPath)
					Set tSC=..CopyValues(pSource,tSourceNewPath,tTargetNewPath,pAction,pKey,pEmptyFieldAsNull,pIgnoreMissingSource) Quit:$$$ISERR(tSC)
					Set tSrcSegPath=pSource.GetNextGroupPath(tSourceGrpPath,tSrcSegPath,.tSC) Quit:$$$ISERR(tSC)
					Quit:""=tSrcSegPath
				}
			} Else {
				For {
					Set tTargetNewPath=tTrgSegPath_$S(""=tTargetPropPath:"",1:":"_tTargetPropPath)
					Set tSC=..CopyValues(pSource,pSourcePath,tTargetNewPath,pAction,pKey,pEmptyFieldAsNull,pIgnoreMissingSource) Quit:$$$ISERR(tSC)
					Set tTrgSegPath=..GetNextGroupPath(tTargetGrpPath,tTrgSegPath,.tSC) Quit:$$$ISERR(tSC)
					Quit:""=tTrgSegPath
				}
			}
		} Else {
			If ""'=tSourcePropPath||("*"=pSourcePath)||($E(pSourcePath,*-2,*)="(*)") {
				Set tSC=..SetValueAt(pSource.GetValueAt(pSourcePath,,.tSC2,pEmptyFieldAsNull),pTargetPath,pAction,pKey)
				Set:$$$ISERR(tSC2) tSC=$$$ADDSC(tSC,tSC2)
			} Else { ; create clone segment object for id or oref
				Set tId=pSource.GetSegmentIdAt(pSourcePath,.tSC)  Quit:$$$ISERR(tSC) tSC
				If tId'="" {
					Set tSegObj=##class(EnsLib.EDI.ASTM.Segment).%New($LB(tId,1,"",1))
					Set:$IsObject(tSegObj) tSC=..SetSegmentAt(tSegObj,pTargetPath)
				} Else {
					Set tSegObj=pSource.GetSegmentAt(pSourcePath,.tSC)  Quit:$$$ISERR(tSC) tSC
					Set:$IsObject(tSegObj) tSC=..SetSegmentAt(tSegObj.%ConstructClone(),pTargetPath)
				}
			}
		}
	}
	Quit tSC
}

ClassMethod Purge(Output pDeletedCount As %Integer, pDaysToKeep As %Integer = 7, pDummy As %Boolean = 0) As %Status
{
	If 0=pDaysToKeep Do ..KillGlobals(.pDeletedCount,1,0)  Quit $$$OK

	New %tDoNotDeleteDate,%tID,%tTime  Set %tDoNotDeleteDate = ##class(Ens.Purge).GetDoNotDeleteDate(pDaysToKeep)
	Set SQLCODE=0, pDeletedCount=0
	&sql(Declare C1 Cursor for
		Select ID,TimeCreated Into :%tID,:%tTime From EnsLib_EDI_ASTM.Document Order By ID)
	&sql(OPEN C1) For { &sql(FETCH C1)  Quit:SQLCODE
		If $$$timeCmp(%tTime,%tDoNotDeleteDate)<0 {
			&sql(Delete From EnsLib_EDI_ASTM.Document Where ID=:%tID)
			Set pDeletedCount=pDeletedCount+%ROWCOUNT
		}
	} Set tCode=SQLCODE &sql(CLOSE C1) Set:'SQLCODE SQLCODE=tCode
	Quit:SQLCODE&&(SQLCODE'=100) $$$ERROR($$$EnsErrGeneral,"Purge error at ID "_%tID_"; SQLCODE = "_SQLCODE)
	Quit $$$OK
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private ]
{
	New %tID  Set %tID=$$$oidPrimary(oid)
	Do ##class(Ens.SearchTableBase).RemoveSearchTableEntries($classname(),%tID,1)
	For index=1:1:+$G($$$vaExtentGbl(%tID,"segs")) {
		Set segid=$$$vaExtentGbl(%tID,"segs",index)
		Kill $$$vaSegmentGbl(segid,0,%tID)
		If '$D($$$vaSegmentGbl(segid,0))&&($G($$$vaOpenSegmentPPG(segid),0)<=0) {
			Kill $$$vaSegmentGbl(segid)
			Kill $$$vaOpenSegmentPPG(segid)
		}
	}
	Quit $$$OK
}

Trigger OnDelete [ Event = DELETE ]
{
	New %tID,index,segid  Set %tID={%%ID}
	Do ##class(Ens.SearchTableBase).RemoveSearchTableEntries($classname(),%tID,1)
	For index=1:1:+$G($$$vaExtentGbl(%tID,"segs")) {
		Set segid=$$$vaExtentGbl(%tID,"segs",index)
		Kill $$$vaSegmentGbl(segid,0,%tID)
		If '$D($$$vaSegmentGbl(segid,0))&&($G($$$vaOpenSegmentPPG(segid),0)<=0) {
			Kill $$$vaSegmentGbl(segid)
			Kill $$$vaOpenSegmentPPG(segid)
		}
	}
	Quit
}

ClassMethod KillGlobals(Output pDeletedCount, pKeepExtentCount = 0, pDisplayLog = 1)
{
	Set pDeletedCount=..TotalCount()
	Set tExtentCount=$G($$$vaExtentGbl)
	Write:pDisplayLog !,"Killing ",$classname()," extent ("_pDeletedCount_"/"_tExtentCount_")"
	Do ..%KillExtent()
	Set:pKeepExtentCount $$$vaExtentGbl=tExtentCount

	Do ##class(EnsLib.EDI.ASTM.SearchTable).%KillExtent()

	Set globals($Name($$$vaSegmentGbl))=""

	Set global="" For { Set global=$O(globals(global))  Quit:""=global
		Kill tExtentCount  Set:pKeepExtentCount tExtentCount=$S($D(@global)#2:@global,1:$$topNodesSum(global))
		Write:pDisplayLog !,"Killing ",global,"("_$G(tExtentCount)_")"
		Kill @global
		If $D(tExtentCount) Set @global=tExtentCount
	}
	Quit
topNodesSum(global)
	Set tSum=0,cnt=0,sub="" For { Set sub=$O(@global@(sub),1,cnt) Quit:""=sub  Set tSum=tSum+cnt }
	Quit tSum
}

ClassMethod TotalCount() As %Integer
{
	&sql(SELECT COUNT(*) INTO :tCount From EnsLib_EDI_ASTM.Document)
	Quit tCount
}

Method %OnClose() As %Status [ Private, ProcedureBlock = 1 ]
{
	#; Kill Segment storage if not %Save'd and segment not used by other Documents
	Set tId=..%Id()
	If ""=tId {
		If $D($$$vaM("runtimeIndex")) {
			For index=1:1:$$$vaM("runtimeIndex") { Set seg=$G($$$vaM("runtimeIndex",index))
				If '$$$vaIsOref(seg) { Set segid=$P(seg,"|") }
				Else {
					Set tSegObj=..%maps("orefs",index)
					Set segid=tSegObj.ID
				}
				If ""'=segid {
					Set $$$vaOpenSegmentPPG(segid) = ($G($$$vaOpenSegmentPPG(segid),0)-1)
					If '$D($$$vaSegmentGbl(segid,0))&&($$$vaOpenSegmentPPG(segid)<=0) {
						Kill $$$vaSegmentGbl(segid)
						Kill $$$vaOpenSegmentPPG(segid)
					}
				}
			}
		} Else {
			Set path="" For { Set path=$O($$$vaM("runtimePath",path),1,seg) Quit:""=path
				If '$$$vaIsOref(seg) { Set segid=$P(seg,"|") }
				Else {
					Set tSegObj=..%maps("orefs",$E(seg,2,*))
					Set segid=tSegObj.ID
				}
				If ""'=segid {
					Set $$$vaOpenSegmentPPG(segid) = ($G($$$vaOpenSegmentPPG(segid),0)-1)
					If '$D($$$vaSegmentGbl(segid,0))&&($$$vaOpenSegmentPPG(segid)<=0) {
						Kill $$$vaSegmentGbl(segid)
						Kill $$$vaOpenSegmentPPG(segid)
					}
				}
			}
		}
	}
	If 'tId||$D($$$vaExtentGbl(tId)) $$$vaMkill  ; ..%maps can be undefined when aborting %OpenId() of nonexistent Id
	Quit $$$OK
}

Method NewReplyDocument(pDocType As %String = "", pLocalApplicationID As %String, Output pSC As %Status) As EnsLib.EDI.ASTM.Document
{
	Kill %objlasterror
	Set pSC=$$$OK, tReplyDoc=..%New($LB("",..Separators))
	If '$IsObject(tReplyDoc) Set pSC=$$$ERROR($$$EnsErrGeneral,"Failed to instantiate reply document for doc "_..%Id()_"; status = "_$G(%objlasterror,$$$OK))  Quit $$$NULLOREF
	Set:""=pDocType pDocType=..DocType
	Do tReplyDoc.PokeDocType(pDocType)
	Quit tReplyDoc
}

/// Delete All Content and reset all properties
Method Clear() As %Status
{
	Quit:'..IsMutable $$$ERROR($$$EnsErrGeneral,"Object is immutable")
	Set tSC=..%OnClose()  Quit:$$$ISERR(tSC) tSC
	Kill $$$vaM("runtimeIndex"), $$$vaM("runtimePath"), $$$vaM("bidirectionalLink"), $$$vaM("loopIndex")
	Set $$$vaM("runtimeIndex")=0
	Set i%BuildMapStatus=""
	Set ..Source=""
	Quit $$$OK
}

/// The same as %Id(), but allocates the Id even if the object hasn't been saved already
Method getId() As %String [ CodeMode = generator ]
{
	$$$GENERATE(" If ..%Id()="""" Do ..%IdSet($increment("_$$$EXTidlocation($$$pEXT,%class)_"))")
	$$$GENERATE(" Quit ..%Id()")
	Quit $$$OK
}

/// Returns an array of links to manager pages for this type of VDoc; item 0 is the family description
ClassMethod GetManagerLinks(Output pColumns) As %Boolean
{
	Set iCol=0
	Set pColumns(iCol,"page")="http://www.ASTM.org"
	Set pColumns(iCol,"name")=$$$Text("ASTM")
	Set pColumns(iCol,"desc")=$$$Text("ASTM E1394-97 / LIS02-A2 protocol")

	Set iCol=iCol+1
	Set pColumns(iCol,"page")=##class(%CSP.Page).Link("ASTM/ASTMSchemaMain.csp")
	Set pColumns(iCol,"name")=$$$Text("Schema Structures")
	Set pColumns(iCol,"desc")=$$$Text("View schema definitions for various types of ASTM message documents")

	Set iCol=iCol+1
	Set pColumns(iCol,"page")=##class(%CSP.Page).Link("EDIDocumentView.csp?NAME="_$ZCVT("ASTM Document","O","URL")_"&CLASS=EnsLib.EDI.ASTM.Document")
	Set pColumns(iCol,"name")=$$$Text("Document Viewer")
	Set pColumns(iCol,"desc")=$$$Text("View ASTM Documents from a variety of sources and test them with various DocType schema definitions and Data Transformations")

	Quit 1
}

Storage Default
{
<Data name="Attachments">
<Attribute>Attachments</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attachments"</Subscript>
</Data>
<Data name="DocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentId</Value>
</Value>
<Value name="3">
<Value>DocType</Value>
</Value>
<Value name="4">
<Value>IsMutable</Value>
</Value>
<Value name="5">
<Value>TimeCreated</Value>
</Value>
<Value name="6">
<Value>Source</Value>
</Value>
<Value name="7">
<Value>OriginalDocId</Value>
</Value>
<Value name="8">
<Value>Envelope</Value>
</Value>
</Data>
<Data name="UserValues">
<Attribute>UserValues</Attribute>
<Structure>subnode</Structure>
<Subscript>"UserValues"</Subscript>
</Data>
<DataLocation>^EnsLib.EDI.ASTM.DocumentD</DataLocation>
<DefaultData>DocumentDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^EnsLib.EDI.ASTM.DocumentD</IdLocation>
<IndexLocation>^EnsLib.EDI.ASTM.DocumentI</IndexLocation>
<StreamLocation>^EnsLib.EDI.ASTM.DocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
