/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

/// VDoc Schema classmethods and queries
Class EnsLib.EDI.ASTM.Schema [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// Returns a list of available DocTypes for the corresponding document class. <br/>
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
Query DocStructures(Category As %String = "", IncludeBase As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "DocStructure:%String,Description:%String,IsStandard:%Boolean")
{
}

ClassMethod DocStructuresExecute(ByRef qHandle As %Binary, Category As %String = "", IncludeBase As %Boolean = 0) As %Status
{
	Set k="" For { Set k=$O($$$vaSchemaGbl(k)) Quit:""=k
		Set Std=+$G($$$vaSchemaDescGbl(k,"std"))
		If $Case(Category,"0":Std,"+":'Std,"":1,:$S("%"=$E(Category,$L(Category)):$ZCVT($E(Category,1,$L(Category)-1),"L")=$E($ZCVT(k,"L"),1,$L(Category)-1), 1:$ZCVT(Category,"L")=$ZCVT(k,"L"))) {
			Set iVer=$I(qHandle("ver")), qHandle("ver",$S(Std:iVer,1:"u"_iVer))=k ; sort standard ones first
		}
	}
	Set qHandle="", qHandle("ver")=$O(qHandle("ver","")), qHandle("IncludeBase")=IncludeBase  Set:""'=qHandle("ver") qHandle("base")=qHandle("ver",qHandle("ver"))
	Quit $$$OK
}

ClassMethod DocStructuresFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DocStructuresExecute ]
{
	Kill Row Set Row=""
	While ""'=$G(qHandle("ver")) {
		While ""'=$G(qHandle("base")) {
			While 1 {
				Set qHandle=$O($$$vaSchemaGbl(qHandle("base"),"DS",qHandle))
				Quit:""=qHandle||'$D(qHandle("seen",qHandle))
			}
			Quit:""'=qHandle
			Quit:'qHandle("IncludeBase")
			Set qHandle("base")=$G($$$vaSchemaGbl(qHandle("base"),"base"))
			Quit:""=qHandle("base")
		}
		Quit:""'=qHandle
		Set qHandle("ver")=$O(qHandle("ver",qHandle("ver")))  Set:""'=qHandle("ver") qHandle("base")=qHandle("ver",qHandle("ver"))  Kill qHandle("seen")
	}
	If ""=$G(qHandle("ver")) Set AtEnd=1  Quit $$$OK
	Set:qHandle("IncludeBase") qHandle("seen",qHandle)=""
	Set tCategory=qHandle("ver",qHandle("ver"))
	Set tDesc=..GetDescription("DS:"_tCategory_":"_qHandle)
	Set tStd=+$G($$$vaSchemaDescGbl(tCategory,"std"))
	Set Row=$LB(tCategory_":"_qHandle,tDesc,tStd)
	Quit $$$OK
}

ClassMethod DocStructuresClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DocStructuresFetch ]
{
	Kill qHandle
	Quit $$$OK
}

Query TypeCategories(Standard As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "Category:%String,Description:%String,IsStandard:%Boolean,Base:%String")
{
}

ClassMethod TypeCategoriesExecute(ByRef qHandle As %Binary, Standard As %String = "") As %Status
{
	Set k="" For { Set k=$O($$$vaSchemaGbl(k)) Quit:""=k
		Set Std=+$G($$$vaSchemaDescGbl(k,"std"))
		If $Case(Standard,"0":Std,"+":'Std,"":1,:$ZCVT(Standard,"L")=$E($ZCVT(k,"L"),1,$L(Standard))) {
			Set iVer=$I(qHandle("ver")), qHandle("ver",$S(Std:iVer,1:"u"_iVer))=k ; sort standard ones first
		}
	}
	Set qHandle="", qHandle("ver")=$O(qHandle("ver",""))
	Quit $$$OK
}

ClassMethod TypeCategoriesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TypeCategoriesExecute ]
{
	Kill Row Set Row=""
	If ""=$G(qHandle("ver")) Set AtEnd=1  Quit $$$OK
	Set tCategory=qHandle("ver",qHandle("ver"))
	Set qHandle("ver")=$O(qHandle("ver",qHandle("ver")))
	Set tDesc=$G($$$vaSchemaDescGbl(tCategory))
	Set tStd=+$G($$$vaSchemaDescGbl(tCategory,"std"))
	Set tBase=$G($$$vaSchemaGbl(tCategory,"base"))
	Set Row=$LB(tCategory,tDesc,tStd,tBase)
	Quit $$$OK
}

ClassMethod TypeCategoriesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TypeCategoriesFetch ]
{
	Kill qHandle
	Quit $$$OK
}

/// Returns a list of schema categories and segment types and segment fields for the corresponding document class. <br/>
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
Query SegTypes(Category As %String = "", Level As %String = "", IncludeBase As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "SegType:%String,Field:%String,Description:%String,IsStandard:%Boolean")
{
}

ClassMethod SegTypesExecute(ByRef qHandle As %Binary, Category As %String = "", Level As %String = "", IncludeBase As %Boolean = 0) As %Status
{
	Set CatSeg=$P(Category,":",2,$L(Category,":")), Category=$P(Category,":",1)
	Set k="" For { Set k=$O($$$vaSchemaGbl(k)) Quit:""=k
		Set Std=+$G($$$vaSchemaDescGbl(k,"std"))
		If $Case(Category,"0":Std,"+":'Std,"":1,:$S("%"=$E(Category,$L(Category)):$ZCVT($E(Category,1,$L(Category)-1),"L")=$E($ZCVT(k,"L"),1,$L(Category)-1), 1:$ZCVT(Category,"L")=$ZCVT(k,"L"))) {
			Set iVer=$I(qHandle("ver")), qHandle("ver",$S(Std:iVer,1:"u"_iVer))=k ; sort standard ones first
		}
	}
	Set qHandle("ver")=0, qHandle("seg")="", qHandle("fldkey")="", qHandle("Level")=Level, qHandle("CatSeg")=CatSeg
	Quit $$$OK
}

ClassMethod SegTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SegTypesExecute, PublicList = qHandle ]
{
	Kill Row Set Row=""
	If ""=$G(qHandle("ver")) Set AtEnd=1  Quit $$$OK
	
	For {
		If ""=qHandle("seg") {
			Set qHandle("ver")=$O(qHandle("ver",qHandle("ver")))  Quit:""=qHandle("ver")
		}
		If $Case(qHandle("Level"), 0:1, :""=qHandle("fldkey")) {
			If ""'=qHandle("CatSeg") {
				Set qHandle("seg")=$S(qHandle("seg")="":qHandle("CatSeg"), 1:"")
			} Else {
				Set qHandle("seg")=$O($$$vaSchemaGbl(qHandle("ver",qHandle("ver")),"SS",qHandle("seg")))
			}
			Continue:""=qHandle("seg")
			Quit:""'=qHandle("seg")&&(0=qHandle("Level"))
			Set tSC=..getFieldsContentArray(.tSegFields,"source",qHandle("ver",qHandle("ver")),qHandle("seg"),qHandle("Level"))
			#; ignore tSC error - make do with what we got
			Merge qHandle("flds")=tSegFields
			Set qHandle("fldkey")="qHandle(""flds""", qHandle("fld")=""
		}
		Set tFld="" For {
			Set tCnt=$G(@(qHandle("fldkey")_")"),0)
			Set qHandle("fld")=qHandle("fld")+1
			If qHandle("fld") > tCnt { ; pop up a level
				If qHandle("fldkey")="qHandle(""flds""" Set qHandle("fldkey")=""  Quit
				Set tLen=$L(qHandle("fldkey"),",")
				Set qHandle("fld")=$P(qHandle("fldkey"),",",tLen)
				Set qHandle("fldkey")=$P(qHandle("fldkey"),",",1,tLen-1)
			} Else {
				Set qFldDown=qHandle("fldkey")_","_qHandle("fld")
				If $G(@(qFldDown_")"),0) { ; has subfields; push down a level
					Set qHandle("fldkey")=qFldDown, qHandle("fld")=""
				}
				Set tFld=$$fldName(qFldDown) Quit
			}
		}
		Quit:""'=tFld
		Kill qHandle("flds")
	}
	If ""=$G(qHandle("ver")) Set AtEnd=1  Quit $$$OK
	Set tCategory=qHandle("ver",qHandle("ver"))
	If qHandle("Level")=0 {
		Set tFld="", tDesc=..GetDescription("SS:"_tCategory_":"_qHandle("seg"))
	}
	Set tStd=+$G($$$vaSchemaDescGbl(tCategory,"std"))
	Set Row=$LB(tCategory_":"_qHandle("seg"),tFld,tDesc,tStd)
	Quit $$$OK
fldName(qFld)
	Set tName="", tLen=$L(qFld,",")
	For i=2:1:tLen {
		Set tName=tName_"."_@($P(qFld,",",1,i)_",""name"")")
	}
	Set tDesc=$S(tLen=2:..GetDescription("SS:"_qHandle("ver",qHandle("ver"))_":"_qHandle("seg"),$P(qFld,",",tLen))
			, 1:..GetDescription(@($P(qFld,",",1,tLen-1)_",""type"")"),$P(qFld,",",tLen)))
	Quit $E(tName,2,*)
}

ClassMethod SegTypesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SegTypesFetch ]
{
	Kill qHandle
	Quit $$$OK
}

/// Get all properties for a given document structure
ClassMethod GetContentArray(Output pContents, pMode As %String, pType As %String = "", pLevel As %Integer, pIncludeBase As %Boolean = 0) As %Status
{
	Quit:$G(pLevel)'=1||($G(pMode)'="source") ..buildContentArray(.pContents,.pMode,pType,.pLevel)
	Set tStructCategory=$P(pType,":"), tStructName=$P(pType,":",2)
	If (tStructCategory="")||(tStructName="") Quit $$$ERROR($$$EnsErrGeneral,"Document Structure '"_pType_"' must have form 'category:name'.")
	Set tBaseCat=tStructCategory, tSC=$$$OK
	For {
		If ""=$G($$$vaSchemaGbl(tBaseCat,"DS",tStructName)) Set tSC=$$$ERROR($$$EnsErrGeneral,"Document Structure '"_pType_"' not defined.")  Quit
		If '$D($$$vaSchemaGbl(tBaseCat,"DS",tStructName,"array")) Set tSC=$$$ERROR($$$EnsErrGeneral,"No content array is built for Document Structure '"_pType_"'.")  Quit
		Quit:$$$ISOK(tSC)||'pIncludeBase
		Set tBaseCat=$G($$$vaSchemaGbl(tBaseCat,"base"))
		Quit:""=tBaseCat
		Set tSC=$$$OK ; go around and try again on base schema
	} Quit:$$$ISERR(tSC) tSC
	Set tRef=$G(pContents)
	If $Case($E($G(pContents)),"%":1,"^":1,:0) { Kill @pContents  Merge @pContents=$$$vaSchemaGbl(tBaseCat,"DS",tStructName,"array") }
	Else { Kill pContents  Merge pContents=$$$vaSchemaGbl(tBaseCat,"DS",tStructName,"array") }
	Quit $$$OK
}

/// Get all properties for a given document structure
ClassMethod buildContentArray(Output pContents, pMode As %String = "source", pType As %String, pLevel As %Integer = 0) As %Status
{
	Set tStructCategory=$P(pType,":"), tStructName=$P(pType,":",2)
	If (tStructCategory="")||(tStructName="") Quit $$$ERROR($$$EnsErrGeneral,"Document Structure '"_pType_"' must have form 'category:name'.")
	Set tSchema=$G($$$vaSchemaGbl(tStructCategory,"DS",tStructName))
	Quit:""=tSchema $$$ERROR($$$EnsErrGeneral,"Document Structure '"_pType_"' not defined.")
	Set tSC=$$$OK
	Do ..getSegsContentArray(.pContents,$ZCVT(pMode,"L"),tStructCategory,tSchema,"",pLevel,.tSC)
	Quit tSC
}

ClassMethod getSegsContentArray(Output pContents, pMode As %String, pCategory As %String, pSchema As %String, pPrevSeg As %String, pLevel As %Integer, Output pSC As %Status = {$$$OK}) As %Integer
{
	Set tRef=$G(pContents)
	If ("%"=$E(tRef)||("^"=$E(tRef))) { Kill @tRef }
	Else {
		Kill pContents  Set tRef="%local"  New %local
	}
	#; Walk through the segment structure of the document
	Set iProp=0
	For iSeg=1:1:$L(pSchema,"~") { Set tSeg=$P(pSchema,"~",iSeg)  Continue:""=tSeg
		If ""'=$ZStrip(tSeg,"*P") { Set tSegCategory=$P(tSeg,":"), tSeg=$P(tSeg,":",2) } Else { Set tSegCategory="" }
		Set tCat=$Case(tSeg,"[":1,"{":1,"<":3,"]":-1,"}":-1,"|":-3,">":-3,:0)
		If 0=tCat {
			Set tName=tSeg, tSegNames(tName)=$G(tSegNames(tName))+1 ; count duplicate seg names at this level
			Set:+$G(tSegNames(tName))>1 tName=tName_"i"_tSegNames(tName) ; append i<n> if needed
			Set iProp=iProp+1
			If pLevel>1||'pLevel {
				Set tSC1=..getFieldsContentArray(.tFldContents,pMode,tSegCategory,tSeg,pLevel)  Set:pSC'=tSC1 pSC=$$$ADDSC(pSC,tSC1)
				Merge @tRef@(iProp)=tFldContents  Kill tFldContents
			}
			Set @tRef@(iProp,"name")=tName
			Set @tRef@(iProp,"type")="SS:"_tSegCategory_":"_tSeg
		} Else { ; 0'=tCat
			// Tweak stuff for artificial Choice List schema #<~||~||~>>
			If ("#"=pPrevSeg) {
				If -3=tCat {
					Set tCat=$Case(tSeg,">":-2,"|":+3,:tCat)
				}
			} Else {
				If "<"=tSeg { Set tSeg="#", tCat=2, iSeg=iSeg-1 } ; Artificially descend an extra level "#" before "<"
				ElseIf -3=tCat {
					Set iSeg=iSeg-$Case(tSeg,">":1,"|":1,:0) ; Ascend from bottom level, double up each "|" or ">" - to extra-exit, or to enter a new branch
				}
			}
			If tCat>0 {
				Set iSeg=iSeg+..getSegsContentArray(.tGrpContents,pMode,pCategory,$P(pSchema,"~",iSeg+1,$L(pSchema,"~")),tSeg,pLevel,.pSC)
				If tGrpContents {
					Set tName=tGrpContents(1,"name")
					Set tType=tGrpContents(1,"type")
					Set iProp=iProp+1
					If tGrpContents=1 {
						Merge @tRef@(iProp)=tGrpContents(1)
					} Else { ; > 1
						Merge @tRef@(iProp)=tGrpContents
						Set tExt=$S("("=tSeg:"union",1:"grp")
						Set tName=$P(tName,"(")_tExt
						Set tType=$P(tType,"(")_tExt
					}
				}
				Kill tGrpContents
				Set tOptArr=(")"=$E(tName,*))  Set:tOptArr tName=$P(tName,"(",1,$L(tName,"(")-1) ; unwind returned optional array
				Set tSegNames(tName)=$G(tSegNames(tName))+1 ; count duplicate seg names at this level
				Set:+$G(tSegNames(tName))>1 tName=tName_"i"_tSegNames(tName) ; append i<n> if needed
				Set:"{"=tSeg||tOptArr tName=tName_"()"
				Set:"{"=tSeg tType=tType_"()"
				Set @tRef@(iProp,"name")=tName
				Set @tRef@(iProp,"type")=tType
				Set:"["=tSeg @tRef@(iProp,"opt")=1
			} Else { ; tCat < 0
				Quit
			}
		}
	}
	Set @tRef=iProp
	Merge:tRef="%local" pContents=%local
	Quit iSeg
}

/// Given a segment type, extract the content array for the fields (items)
ClassMethod getFieldsContentArray(Output pContents, pMode As %String, pCategory As %String, pSeg As %String, pLevel As %Integer) As %Status
{
	Kill pContents  Set tSC=$$$OK
	Set tSegType=$P(pSeg,"i")
	If $D($$$vaSchemaGbl(pCategory,"SS",tSegType))#2=0 {
		If "DocsRef"=$E(tSegType,$L(tSegType)-$L("DocsRef")+1,$L(tSegType)) Set pContents=0  Quit $$$OK
		Quit $$$ERROR($$$EnsErrGeneral,"Unknown segment type '"_pCategory_":"_tSegType_"'")
	}
	Set tSchema=$$$vaSchemaGbl(pCategory,"SS",tSegType)

	For iFld=1:1:$LL(tSchema) { Set tFld=$LG(tSchema,iFld)  Continue:""=tFld
		Set tType=$LI(tFld,1)
		Set tTypeCategory=$P(tType,":"), tType=$P(tType,":",2)
		Set tRep=$Case($LI(tFld,2),"+":1,"*":1,"&":1,:0)
		Set tRepCount=$LI(tFld,3)
		Set tRepCount=$S('tRep:"", 1:"("_tRepCount_")")
		Set tName="" For  Set tName=$O($$$vaSchemaGbl(pCategory,"SS",tSegType,"names",tName))  Quit:""=tName||(iFld=$$$vaSchemaGbl(pCategory,"SS",tSegType,"names",tName))
		Set pContents(iFld,"name")=":"_tName_$S('tRep:"", 1:"()")
		If ""=tType {
			Set:""'=tRepCount pContents(iFld,"type")=tRepCount
		} Else {
			Set pContents(iFld,"type")="CS:"_tTypeCategory_":"_tType_tRepCount
			If pLevel>=2||'pLevel {
				Set tSC1=..getComponentsContentArray(.tFldContents, pMode, tTypeCategory, tType, pLevel)  Set:tSC'=tSC1 tSC=$$$ADDSC(tSC,tSC1)
				Merge pContents(iFld)=tFldContents  Kill tFldContents
			}
		}
	}
	Set pContents=iFld
	Quit tSC
}

/// Get the components of a ComponentStructure / Type
ClassMethod getComponentsContentArray(Output pContents, pMode As %String, pCategory As %String, pComponentStructType As %String, pLevel As %Integer = 0) As %Status
{
	Kill pContents  Set tSC=$$$OK
	Set tSchema=$S(""=pCategory:"",1:$G($$$vaSchemaGbl(pCategory,"CS",pComponentStructType)))
	Quit:""=tSchema $$$ERROR($$$EnsErrGeneral,"Unknown component structure type '"_pCategory_":"_pComponentStructType)

	For iComp=1:1:$LL(tSchema) { Continue:'$LD(tSchema,iComp)  Set tType=$LI(tSchema,iComp)
		Set tTypeCategory=$P(tType,":"), tType=$P(tType,":",2)
		Set tName="" For  Set tName=$O($$$vaSchemaGbl(pCategory,"CS",pComponentStructType,"names",tName))  Quit:""=tName||(iComp=$$$vaSchemaGbl(pCategory,"CS",pComponentStructType,"names",tName))
		Set pContents(iComp,"name")=tName
		If ""'=tType {
			Set pContents(iComp,"type")="CS:"_tTypeCategory_":"_tType
			If pLevel>=3||'pLevel {
				Set tSC1=..getComponentsContentArray(.tCompContents, pMode, tTypeCategory, tType)  Set:tSC'=tSC1 tSC=$$$ADDSC(tSC,tSC1)
				Merge pContents(iComp)=tCompContents   Kill tCompContents
			}
		}
	}
	Set pContents=iComp
	Quit tSC
}

ClassMethod ElementExists(pElementSpec As %String = "") As %Boolean
{
	Set tClass=$ZCVT($P(pElementSpec,":",1),"U"), tCat=$P(pElementSpec,":",2), tElem=$P(pElementSpec,":",3)
	Quit:((""=tClass)||(""=tCat)||(""=tElem)) 0
	Quit ($D($$$vaSchemaGbl(tCat,tClass,tElem))#2'=0)
}

/// Get the description of an item or an indexed piece of an item
ClassMethod GetDescription(pElementSpec As %String, pItem As %Integer = "") As %String
{
	Set tClass=$ZCVT($P(pElementSpec,":",1),"U")
	Set tCategory=$P(pElementSpec,":",2)  Set:""=tCategory tCategory="E1394"
	Set tElem=$P(pElementSpec,":",3)
	Quit:(""=tClass)||(""=tElem) "" ; Must specify ""Class:Category:Element""
	Set tDesc=$S(""=pItem:$G($$$vaSchemaDescGbl(tCategory,tClass,tElem)), 1:$G($$$vaSchemaDescGbl(tCategory,tClass,tElem,pItem)))
	If ""=tDesc {
		Set tBaseCat=$G($$$vaSchemaGbl(tCategory,"base"))
		Set pItem(tCategory)=""
		Set:""'=tBaseCat&&'$D(pItem(tBaseCat)) tDesc=..GetDescription(tClass_":"_tBaseCat_":"_$P(pElementSpec,":",3,$L(pElementSpec,":")),.pItem)
	}
	Quit tDesc
}

/// This method computes the Alias string for a property name, given the property's node in the Content Array.
ClassMethod GetAlias(pContentArrayName As %String, pArrayPos As %String) As %String
{
	Set tSeg=1,tAlias=""  For i=1:1:$L(pArrayPos,",") {
		Set tPiece=@(pContentArrayName_"("_$P(pArrayPos,",",1,i)_",""name"")")
		If tSeg && ($G(@(pContentArrayName_"("_$P(pArrayPos,",",1,i)_",""type"")"))["SS:") {
			Set tAlias=tAlias_"."_tPiece
		} else {
			Set tAlias=tAlias_$S(tSeg:":",1:".")_$P(pArrayPos,",",i)_$S(")"=$E(tPiece,$L(tPiece)):"("_$P(tPiece,"(",2),1:"")
			Set:tSeg tSeg=0
		}
	}
	Quit $E(tAlias,2,$L(tAlias))
}

/// Given a Schema Category and a Segment name, return the corresponding segment structure declared in the schema
ClassMethod ResolveSegNameToStructure(pSchemaCategory As %String, pDummy As %String = "", pSegName As %String, Output pStatus As %Status) As %String
{
	Set pStatus=$$$OK
	Set tSegmentStructure=""
	If ((pSchemaCategory="")||(pSegName="")) Set pStatus=$$$ERROR($$$EnsErrGeneral,"Empty category '"_pSchemaCategory_"' or segment name '"_pSegName_"'") quit ""
	Set tCategory=pSchemaCategory
	For  {
		If $D($$$vaSchemaGbl(tCategory,"SS",pSegName)) {
			Set tSegmentStructure=tCategory_":"_pSegName
			Quit
		}
		Set tCategory=$G($$$vaSchemaGbl(tCategory,"base"))  Quit:""=tCategory
	}
	If ""=tSegmentStructure {
		Set pStatus=$$$ERROR($$$EnsErrGeneral,"Segment Structure not found for segment named "_pSegName_" in category '"_pSchemaCategory_"'")
	}
	Quit tSegmentStructure
}

/// Given a Schema category and a Document TypeName string, return the corresponding DocType (document structure)
ClassMethod ResolveSchemaTypeToDocType(pSchemaCategory As %String, pTypeName As %String, Output pStatus As %Status) As %String
{
	Set pStatus=$$$OK
	If ((pSchemaCategory="")||(pTypeName="")) Set pStatus=$$$ERROR($$$EnsErrGeneral,"Empty category '"_pSchemaCategory_"' or type name '"_pTypeName_"'")  Quit ""
	Quit pSchemaCategory_":"_pTypeName
}

ClassMethod BuildCategoryMaps(pCategory As %String) As %Status
{
	Set tSC=$$$OK, tDocStructName="" For { Set tDocStructName=$O($$$vaSchemaGbl(pCategory,"DS",tDocStructName))  Quit:""=tDocStructName
		Set tSC=..buildDocStructureMap(pCategory,tDocStructName)  Quit:$$$ISERR(tSC)
	}
	Set tSegment="" For { Set tSegment=$O($$$vaSchemaGbl(pCategory,"SS",tSegment))  Quit:tSegment=""
		Set tSC=..buildSegmentStructureMap(pCategory,tSegment)  Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod buildDocStructureMap(pCategory As %String, pDocStructName As %String) As %Status
{
	Set tContentArrayName=$Name($$$vaSchemaGbl(pCategory,"DS",pDocStructName,"array"))
	Set tSC=..buildContentArray(tContentArrayName,,pCategory_":"_pDocStructName,1)
	Do ..buildDocStructureMapLoop(tContentArrayName,.tSchemaPathMap,"","=")
	Set index=$O(@tContentArrayName@(""),-1)
	Set tSchemaPathMap("leftoversegs()")="="_(+index+1)_",*|:Any"
	Kill $$$vaSchemaGbl(pCategory,"DS",pDocStructName,"map")
	Merge $$$vaSchemaGbl(pCategory,"DS",pDocStructName,"map")=tSchemaPathMap
	Quit tSC
}

ClassMethod buildDocStructureMapLoop(pContentArrayName As %String, pSchemaPathMap As %String, pNamePrefix As %String, pValuePrefix As %String)
{
	Set padding=$L($O(@pContentArrayName@("name"),-1))
	Set index="" For { Set index=$O(@pContentArrayName@(index))  Quit:""=index  Continue:index'=+index
		Set value=$TR($J(index,padding)," ","0")
		If @pContentArrayName@(index,"name")["()" set value=value_",*"
		If '$G(@pContentArrayName@(index)) {
			Set segtype=$TR($P(@pContentArrayName@(index,"type"),":",2,99),"()")
			Set pSchemaPathMap(pNamePrefix_@pContentArrayName@(index,"name"))=pValuePrefix_value_"|"_segtype
		} Else {
			Set nestedref=$S(pContentArrayName[")":$E(pContentArrayName,1,$L(pContentArrayName)-1)_","_index_")",1:pContentArrayName_"("_index_")")
			Set nameprefix=pNamePrefix_@pContentArrayName@(index,"name")
			Do ..buildDocStructureMapLoop(nestedref,.pSchemaPathMap,nameprefix_".",pValuePrefix_value_",")
		}
	}
}

ClassMethod buildSegmentStructureMap(pCategory As %String, pSegmentType As %String) As %Status
{
	Kill $$$vaSchemaGbl(pCategory,"SS",pSegmentType,"map")
	Set struct=$G($$$vaSchemaGbl(pCategory,"SS",pSegmentType))
	Quit:""=struct $$$OK
	Kill names Set name="" For { Set name=$O($$$vaSchemaGbl(pCategory,"SS",pSegmentType,"names",name))  quit:name=""
		Set names($$$vaSchemaGbl(pCategory,"SS",pSegmentType,"names",name))=name
	}
	Set tSC=$$$OK
	For i=1:1:$LL(struct) {
		Continue:'$D(names(i))
		Set ifrepeating=$LI($LI(struct,i),6)
		Set tSSMap($ZCVT(names(i),"L"))=i_$s(ifrepeating:"()",1:"")
		Set cs=$LG($LI(struct,i),1)
		If cs'="" {
			Kill subarray
			Set tSC=..buildComponentStructMap($p(cs,":",1),$p(cs,":",2),.subarray) Quit:$$$ISERR(tSC)
			Set name="" For { Set name=$O(subarray(name))  Quit:name=""
				Set tSSMap($ZCVT(names(i)_"."_name,"L"))=tSSMap($ZCVT(names(i),"L"))_"."_subarray(name)
			}
		}
	}
	Merge:$$$ISOK(tSC) $$$vaSchemaGbl(pCategory,"SS",pSegmentType,"map")=tSSMap
	Quit tSC
}

ClassMethod buildComponentStructMap(pDocTypeCategory, pTypeName, pCSMap) As %Status
{
	Set struct=$G($$$vaSchemaGbl(pDocTypeCategory,"CS",pTypeName))
	Quit:""=struct $$$OK
	Kill names Set name="" For { Set name=$O($$$vaSchemaGbl(pDocTypeCategory,"CS",pTypeName,"names",name))  Quit:""=name
		Set names($$$vaSchemaGbl(pDocTypeCategory,"CS",pTypeName,"names",name))=name
	}
	Set tSC=$$$OK
	For i=1:1:$LL(struct) {
		Continue:'$D(names(i))
		Set pCSMap(names(i))=i
		Set cs=$LI(struct,i)
		If cs'="" {
			Kill subarray
			Set tSC=..buildComponentStructMap($P(cs,":",1),$p(cs,":",2),.subarray)  Quit:$$$ISERR(tSC)
			Set name="" For { Set name=$O(subarray(name))  Quit:name=""
				Set pCSMap(names(i)_"."_name)=pCSMap(names(i))_"."_subarray(name)
			}
		}
	}
	Quit tSC
}

}
