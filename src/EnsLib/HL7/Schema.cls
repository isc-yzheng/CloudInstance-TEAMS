/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

/// VDoc Schema classmethods and queries
Class EnsLib.HL7.Schema [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/// Returns a list of available DocTypes for the corresponding document class. <br/>
/// Note that for HL7 DocType is not the same as Message Type; rather it corresponds to Message Structure. <br/>
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
Query MessageStructures(Category As %String = "", IncludeBase As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "MessageStructure:%String,Description:%String,IsStandard:%Boolean")
{
}

ClassMethod MessageStructuresExecute(ByRef qHandle As %Binary, Category As %String = "", IncludeBase As %Boolean = 0) As %Status
{
	Set k="" For { Set k=$O($$$vaSchemaGbl(k)) Quit:""=k
		Set Std=+$G($$$vaSchemaDescGbl(k,"std"))
		If $Case(Category, "0":Std, "+":'Std, "":1, :$S("%"=$E(Category,$L(Category)):$ZCVT($E(Category,1,$L(Category)-1),"L")=$E($ZCVT(k,"L"),1,$L(Category)-1), 1:$ZCVT(Category,"L")=$ZCVT(k,"L"))) {
			Set qHandle("ver",$S(Std:"s"_k,1:"u"_k))=k ; sort standard ones first
		}
	}
	Set qHandle="", qHandle("ver")=$O(qHandle("ver","")), qHandle("IncludeBase")=IncludeBase  Set:""'=qHandle("ver") qHandle("base")=qHandle("ver",qHandle("ver"))
	Quit $$$OK
}

ClassMethod MessageStructuresFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MessageStructuresExecute ]
{
	Kill Row Set Row=""
	While ""'=$G(qHandle("ver")) {
		While ""'=$G(qHandle("base")) {
			While 1 {
				Set qHandle=$O($$$vaSchemaGbl(qHandle("base"),"MS",qHandle))
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
	Set tDesc=..GetDescription("MS:"_tCategory_":"_qHandle)
	Set tStd=+$G($$$vaSchemaDescGbl(tCategory,"std"))
	Set Row=$LB(tCategory_":"_qHandle,tDesc,tStd)
	Quit $$$OK
}

ClassMethod MessageStructuresClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MessageStructuresFetch ]
{
	Kill qHandle
	Quit $$$OK
}

/// Returns a list of available MessageTypes for the corresponding document class. <br/>
/// Note that for HL7 DocType is not the same as Message Type; rather DocType corresponds to Message Structure. <br/>
/// The MessageTypes is returned as the first column in the result set. <br/>
/// The <var>Category</var> parameter can be used to restrict the list. <br/>
/// If <var>Category</var> is: <br/>
///  0 - return only MessageTypes in standard categories <br/>
///  + - return only MessageTypes in user-defined categories <br/>
///  empty - return MessageTypes from all categories <br/>
///  a category name - return only MessageTypes in the named category <br/>
///  a partial name suffixed with '%' - return only MessageTypes in categories matching the partial category name <br/>
///  other - return nothing <br/>
/// If <var>IncludeBase</var> is: <br/>
///  0 - return only MessageTypes defined in the current schema category itself <br/>
///  1 - return all MessageTypes in the current schema category's base category in addition to those defined in the current category itself <br/>
Query MessageTypes(Category As %String = "", IncludeBase As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "MessageStructure:%String,Description:%String,IsStandard:%Boolean")
{
}

ClassMethod MessageTypesExecute(ByRef qHandle As %Binary, Category As %String = "", IncludeBase As %Boolean = 0) As %Status
{
	Set k="" For { Set k=$O($$$vaSchemaGbl(k)) Quit:""=k
		Set Std=+$G($$$vaSchemaDescGbl(k,"std"))
		If $Case(Category, "0":Std, "+":'Std, "":1, :$S("%"=$E(Category,$L(Category)):$ZCVT($E(Category,1,$L(Category)-1),"L")=$E($ZCVT(k,"L"),1,$L(Category)-1), 1:$ZCVT(Category,"L")=$ZCVT(k,"L"))) {
			Set qHandle("ver",$S(Std:"s"_k,1:"u"_k))=k ; sort standard ones first
		}
	}
	Set qHandle="", qHandle("ver")=$O(qHandle("ver","")), qHandle("IncludeBase")=IncludeBase  Set:""'=qHandle("ver") qHandle("base")=qHandle("ver",qHandle("ver"))
	Quit $$$OK
}

ClassMethod MessageTypesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MessageTypesExecute ]
{
	Kill Row Set Row=""
	While ""'=$G(qHandle("ver")) {
		While ""'=$G(qHandle("base")) {
			While 1 {
				Set qHandle=$O($$$vaSchemaGbl(qHandle("base"),"MT",qHandle))
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
	Set tDesc=..GetDescription("MT:"_tCategory_":"_qHandle)
	Set tStd=+$G($$$vaSchemaDescGbl(tCategory,"std"))
	Set Row=$LB(tCategory_":"_qHandle,tDesc,tStd)
	Quit $$$OK
}

ClassMethod MessageTypesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MessageTypesFetch ]
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
		If $Case(Standard, "0":Std, "+":'Std, "":1, :$ZCVT(Standard,"L")=$E($ZCVT(k,"L"),1,$L(Standard))) {
			Set qHandle("ver",$S(Std:"s"_k,1:"u"_k))=k ; sort standard ones first
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
		If $Case(Category, "0":Std, "+":'Std, "":1, :$S("%"=$E(Category,$L(Category)):$ZCVT($E(Category,1,$L(Category)-1),"L")=$E($ZCVT(k,"L"),1,$L(Category)-1), 1:$ZCVT(Category,"L")=$ZCVT(k,"L"))) {
			Set qHandle("ver",$S(Std:"s"_k,1:"u"_k))=k ; sort standard ones first
		}
	}
	Set qHandle("ver")=0, qHandle("seg")="", qHandle("IncludeBase")=IncludeBase, qHandle("fldkey")="", qHandle("Level")=Level, qHandle("CatSeg")=CatSeg
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

/// Returns a list of available Data Structures for the corresponding document class. <br/>
/// The Data Structure is returned as the first column in the result set. <br/>
/// The <var>Category</var> parameter can be used to restrict the list. <br/>
/// If <var>Category</var> is: <br/>
///  0 - return only Data Structures in standard categories <br/>
///  + - return only Data Structures in user-defined categories <br/>
///  empty - return Data Structures from all categories <br/>
///  a category name - return only Data Structures in the named category <br/>
///  a partial name suffixed with '%' - return only Data Structures in categories matching the partial category name <br/>
///  other - return nothing <br/>
/// If <var>IncludeBase</var> is: <br/>
///  0 - return only Data Structure defined in the current schema category itself <br/>
///  1 - return all Data Structure in the current schema category's base category in addition to those defined in the current category itself <br/>
Query DataStructures(Category As %String = "", IncludeBase As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "DataStruct:%String,Description:%String,IsStandard:%Boolean")
{
}

ClassMethod DataStructuresExecute(ByRef qHandle As %Binary, Category As %String = "", IncludeBase As %Boolean = 0) As %Status
{
	Set k="" For { Set k=$O($$$vaSchemaGbl(k)) Quit:""=k
		Set Std=+$G($$$vaSchemaDescGbl(k,"std"))
		If $Case(Category, "0":Std, "+":'Std, "":1, :$S("%"=$E(Category,$L(Category)):$ZCVT($E(Category,1,$L(Category)-1),"L")=$E($ZCVT(k,"L"),1,$L(Category)-1), 1:$ZCVT(Category,"L")=$ZCVT(k,"L"))) {
			Set qHandle("ver",$S(Std:"s"_k,1:"u"_k))=k ; sort standard ones first
		}
	}
	Set qHandle="", qHandle("ver")=$O(qHandle("ver","")), qHandle("IncludeBase")=IncludeBase  Set:""'=qHandle("ver") qHandle("base")=qHandle("ver",qHandle("ver"))
	Quit $$$OK
}

ClassMethod DataStructuresFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DataStructuresExecute ]
{
	Kill Row Set Row=""
	Set inDS=($E(qHandle)="-") Set:inDS $E(qHandle,1)=""
	While ""'=$G(qHandle("ver")) {
		While ""'=$G(qHandle("base")) {
			While 1 && 'inDS {
				Set qHandle=$O($$$vaSchemaGbl(qHandle("base"),"DT",qHandle))
				If ""=qHandle Set inDS=1  Quit
				Quit:'$D(qHandle("seen",qHandle))
			}
			While inDS {
				Set qHandle=$O($$$vaSchemaGbl(qHandle("base"),"DS",qHandle))
				If ""=qHandle Set inDS=0  Quit
				Quit:'$D(qHandle("seen",qHandle))
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
	Set qHandle=$S(inDS&&$L(qHandle):"-",1:"")_qHandle
	Quit $$$OK
}

ClassMethod DataStructuresClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DataStructuresFetch ]
{
	Kill qHandle
	Quit $$$OK
}

/// Returns a list of available Code Tables for the corresponding document class. <br/>
/// The Code Table is returned as the first column in the result set. <br/>
/// The <var>Category</var> parameter can be used to restrict the list. <br/>
/// If <var>Category</var> is: <br/>
///  0 - return only Code Tables in standard categories <br/>
///  + - return only Code Tables in user-defined categories <br/>
///  empty - return Code Tables from all categories <br/>
///  a category name - return only Code Tables in the named category <br/>
///  a partial name suffixed with '%' - return only Code Tables in categories matching the partial category name <br/>
///  other - return nothing <br/>
/// If <var>IncludeBase</var> is: <br/>
///  0 - return only Code Table defined in the current schema category itself <br/>
///  1 - return all Code Table in the current schema category's base category in addition to those defined in the current category itself <br/>
Query CodeTables(Category As %String = "", IncludeBase As %Boolean = 0) As %Query(CONTAINID = 0, ROWSPEC = "CodeTable:%String,Description:%String,IsStandard:%Boolean")
{
}

ClassMethod CodeTablesExecute(ByRef qHandle As %Binary, Category As %String = "", IncludeBase As %Boolean = 0) As %Status
{
	Set k="" For { Set k=$O($$$vaSchemaGbl(k)) Quit:""=k
		Set Std=+$G($$$vaSchemaDescGbl(k,"std"))
		If $Case(Category, "0":Std, "+":'Std, "":1, :$S("%"=$E(Category,$L(Category)):$ZCVT($E(Category,1,$L(Category)-1),"L")=$E($ZCVT(k,"L"),1,$L(Category)-1), 1:$ZCVT(Category,"L")=$ZCVT(k,"L"))) {
			Set qHandle("ver",$S(Std:"s"_k,1:"u"_k))=k ; sort standard ones first
		}
	}
	Set qHandle="", qHandle("ver")=$O(qHandle("ver","")), qHandle("IncludeBase")=IncludeBase  Set:""'=qHandle("ver") qHandle("base")=qHandle("ver",qHandle("ver"))
	Quit $$$OK
}

ClassMethod CodeTablesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodeTablesExecute ]
{
	Kill Row Set Row=""
	While ""'=$G(qHandle("ver")) {
		While ""'=$G(qHandle("base")) {
			While 1 {
				Set qHandle=$O($$$vaSchemaGbl(qHandle("base"),"CT",qHandle))
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
	Set tDesc=..GetDescription("CT:"_tCategory_":"_qHandle)
	Set tStd=+$G($$$vaSchemaDescGbl(tCategory,"std"))
	Set Row=$LB(tCategory_":"_qHandle,tDesc,tStd)
	Quit $$$OK
}

ClassMethod CodeTablesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodeTablesFetch ]
{
	Kill qHandle
	Quit $$$OK
}

/// Get all properties for a given document structure
ClassMethod GetContentArray(Output pContents, pMode As %String, pType As %String = "", pLevel As %Integer, pIncludeBase As %Boolean = 0) As %Status
{
	Quit:$G(pLevel)'=1||($G(pMode)'="source") ..buildContentArray(.pContents,.pMode,pType,.pLevel)
	Set tStructCategory=$P(pType,":"), tStructName=$P(pType,":",2)
	If (tStructCategory="")||(tStructName="") Quit $$$ERROR($$$EnsErrGeneral,"Message Structure '"_pType_"' must have form 'category:name'.")
	Set tBaseCat=tStructCategory, tSC=$$$OK
	For {
		If ""=$G($$$vaSchemaGbl(tBaseCat,"MS",tStructName)) Set tSC=$$$ERROR($$$EnsErrGeneral,"Message Structure '"_pType_"' not defined.")  Quit
		If '$D($$$vaSchemaGbl(tBaseCat,"MS",tStructName,"array")) Set tSC=$$$ERROR($$$EnsErrGeneral,"No content array is built for Message Structure '"_pType_"'.")  Quit
		Quit:$$$ISOK(tSC)||'pIncludeBase
		Set tBaseCat=$G($$$vaSchemaGbl(tBaseCat,"base"))
		Quit:""=tBaseCat
		Set tSC=$$$OK ; go around and try again on base schema
	} Quit:$$$ISERR(tSC) tSC
	Set tRef=$G(pContents)
	If $Case($E($G(pContents)),"%":1,"^":1,:0) { Kill @pContents  Merge @pContents=$$$vaSchemaGbl(tBaseCat,"MS",tStructName,"array") }
	Else { Kill pContents  Merge pContents=$$$vaSchemaGbl(tBaseCat,"MS",tStructName,"array") }
	Quit $$$OK
}

/// Get all properties for a given document structure
ClassMethod buildContentArray(Output pContents, pMode As %String = "source", pType As %String, pLevel As %Integer = 0) As %Status
{
	Set tStructCategory=$P(pType,":"), tStructName=$P(pType,":",2)
	If (tStructCategory="")||(tStructName="") Quit $$$ERROR($$$EnsErrGeneral,"Message Structure '"_pType_"' must have form 'category:name'.")
	Set tSchema=$G($$$vaSchemaGbl(tStructCategory,"MS",tStructName))
	Quit:""=tSchema $$$ERROR($$$EnsErrGeneral,"Message Structure '"_pType_"' not defined.")
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
		If tSeg[":" { Set tSegCategory=$P(tSeg,":"), tSeg=$P(tSeg,":",2) } Else { Set tSegCategory="" }
		Set tCat=$Case($E(tSeg),"[":1,"{":1,"(":1,"<":3,"]":-1,"}":-1,")":-1,"|":-3,">":-3,:0)
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
					Set iProp=iProp+1
					If tGrpContents=1&&($L(tSeg)=1) {
						Set tName=tGrpContents(1,"name")
						Set tType=tGrpContents(1,"type")
						Merge @tRef@(iProp)=tGrpContents(1)
					} Else { ; > 1 - repeating, optional or named loop
						Set tExt=$S(tCat>1:"union",1:"grp")
						If $L(tSeg)>1 {
							Set tName=tExt_$E(tSeg,2,*)
							Set tType=tExt_$E(tSeg,2,*)
						} Else {
							Set tName=$P(tGrpContents(1,"name"),"(")_tExt
							Set tType=$P($P(tGrpContents(1,"type"),":",3),"(")_tExt
						}
						If tGrpContents=1&&($L(tSeg)=1||(tGrpContents(1,"type")'[":")) {
							Merge @tRef@(iProp)=tGrpContents(1)
							Set:")"=$E(tGrpContents(1,"name"),*) tName=tName_"()", tType=tType_"()"
						} Else {
							Merge @tRef@(iProp)=tGrpContents
						}
					}
				}
				Kill tGrpContents
				Set tOptArr=(")"=$E(tName,*))  Set:tOptArr tName=$P(tName,"(",1,$L(tName,"(")-1) ; unwind returned optional array
				Set tSegNames(tName)=$G(tSegNames(tName))+1 ; count duplicate seg names at this level
				Set:+$G(tSegNames(tName))>1 tName=tName_"i"_tSegNames(tName) ; append i<n> if needed
				Set:"{"=$E(tSeg)||tOptArr tName=tName_"()"
				Set:"{"=$E(tSeg) tType=tType_"()"
				Set @tRef@(iProp,"name")=tName
				Set @tRef@(iProp,"type")=tType
				Set:"["=$E(tSeg) @tRef@(iProp,"opt")=1
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
		If ""'=tType {
			Set cList=$G($$$vaSchemaGbl(tTypeCategory,"DT",tType))
			Set:1=$LL(cList)&&$ListValid($LG(cList,1))&&(""=$LG($LG(cList,1))) tType="" ; test for DT elementary type
		}
		If ""=tType {
			Set:""'=tRepCount pContents(iFld,"type")=tRepCount
		} Else {
			Set pContents(iFld,"type")="DS:"_tTypeCategory_":"_tType_tRepCount
			If pLevel>=2||'pLevel {
				Set tSC1=..getComponentsContentArray(.tFldContents, pMode, tTypeCategory, tType, pLevel)  Set:tSC'=tSC1 tSC=$$$ADDSC(tSC,tSC1)
				Merge pContents(iFld)=tFldContents  Kill tFldContents
			}
		}
	}
	Set pContents=iFld
	Quit tSC
}

/// Get the components of a DataStructure / Type
ClassMethod getComponentsContentArray(Output pContents, pMode As %String, pCategory As %String, pDataStructType As %String, pLevel As %Integer = 0) As %Status
{
	Kill pContents  Set tSC=$$$OK
	Set elem="DT"
	If ""=pCategory { Set tSchema="" }
	Else {
		Set tSchema=$G($$$vaSchemaGbl(pCategory,elem,pDataStructType))
		Set:""=tSchema elem="DS", tSchema=$G($$$vaSchemaGbl(pCategory,elem,pDataStructType))
	}
	Quit:""=tSchema $$$ERROR($$$EnsErrGeneral,"Unknown data structure type '"_pCategory_":"_pDataStructType)

	For iComp=1:1:$LL(tSchema) { Continue:'$LD(tSchema,iComp)  Set tType=$LI(tSchema,iComp)
		Set:elem="DT" tType=$LI(tType)
		Set tTypeCategory=$P(tType,":"), tType=$P(tType,":",2)
		Set tName="" For  Set tName=$O($$$vaSchemaGbl(pCategory,elem,pDataStructType,"names",tName))  Quit:""=tName||(iComp=$$$vaSchemaGbl(pCategory,elem,pDataStructType,"names",tName))
		Set pContents(iComp,"name")=tName
		If ""'=tType {
			Set cList=$G($$$vaSchemaGbl(tTypeCategory,"DT",tType))
			Set:1=$LL(cList)&&$ListValid($LG(cList,1))&&(""=$LG($LG(cList,1))) tType="" ; test for DT elementary type
		}
		If ""'=tType {
			Set pContents(iComp,"type")="DS:"_tTypeCategory_":"_tType
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
	Quit:"DS"=tClass&&($D($$$vaSchemaGbl(tCat,"DT",tElem))#2'=0) 1
	Quit ($D($$$vaSchemaGbl(tCat,tClass,tElem))#2'=0)
}

/// Get the description of an item or an indexed piece of an item
ClassMethod GetDescription(pElementSpec As %String, pItem As %Integer = "") As %String
{
	Set tClass=$ZCVT($P(pElementSpec,":",1),"U")
	Set tCategory=$P(pElementSpec,":",2)  Set:""=tCategory tCategory="2.3.1"
	Set tElem=$P(pElementSpec,":",3)
	Quit:(""=tClass)||(""=tElem) "" ; Must specify ""Class:Category:Element""
	Set:"DS"=tClass&&$D($$$vaSchemaDescGbl(tCategory,"DT",tElem)) tClass="DT"
	Set tDesc=$S(""=pItem:$G($$$vaSchemaDescGbl(tCategory,tClass,tElem)), 1:$G($$$vaSchemaDescGbl(tCategory,tClass,tElem,pItem)))
	If ""=tDesc {
		Set tBaseCat=$G($$$vaSchemaGbl(tCategory,"base"))
		If ""=pItem {
			Quit:"MS"=tClass ..GetDescription("MT:"_$P(pElementSpec,":",2,$L(pElementSpec,":")))
			If "MT"=tClass {
				Set tType=$P(tElem,"_",1), tEvent=$P(tElem,"_",2,3)
				Set tTypeDesc=$S(""=tType:"", 1:$G($$$vaSchemaDescGbl(tCategory,"MG",tType)))
				Set tEventDesc=$S(""=tEvent:"", 1:$G($$$vaSchemaDescGbl(tCategory,"ME",tEvent)))
				If ""'=(tTypeDesc_tEventDesc)&&(""'=tBaseCat) { ; If one exists, get the other from base if possible
					Set:""=tTypeDesc tTypeDesc=..GetDescription("MG:"_tBaseCat_":"_tType)
					Set:""=tEventDesc tEventDesc=..GetDescription("ME:"_tBaseCat_":"_tEvent)
				}
				Set tEventDescX=$ZStrip($P(tEventDesc,"-",2,$L(tEventDesc,"-")),"<>W")
				Set:""=tEventDescX tEventDescX=tEventDesc
				Set tDesc=tTypeDesc_$S(""=tEventDescX:"",1:" - "_tEventDescX)
			}
		}
		If ""=tDesc&&(""'=tBaseCat) {
			Set pItem(tCategory)=""
			Set:'$D(pItem(tBaseCat)) tDesc=..GetDescription(tClass_":"_tBaseCat_":"_$P(pElementSpec,":",3,$L(pElementSpec,":")),.pItem)
		}
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

/// Given a Schema category and a Message TypeName string, return the corresponding HL7 DocType (message structure) declared in the schema
ClassMethod ResolveSchemaTypeToDocType(pSchemaCategory As %String, pTypeName As %String, Output pStatus As %Status, pDocTypeResolution As %String = "") As %String
{
	Set pStatus=$$$OK, tDTR=$ZCVT($E(pDocTypeResolution,1,3),"L")
	If ((pSchemaCategory="")||(pTypeName="")) Set pStatus=$$$ERROR($$$EnsErrGeneral,"Empty category '"_pSchemaCategory_"' or type name '"_pTypeName_"'") quit ""
	Set tCategory=pSchemaCategory
	Set tStripType=$Case(tDTR
						, "lit":pTypeName
						, "use":$$replace^EnsUtil($P(pTypeName,"_",3,99), "&","_", "\S\","_", "\T\","_")
						, "ign":$P(pTypeName,"_",1,2)
						, :pTypeName)
	For  {
		#; check for pieces that have what appears to be a msg structure in piece 3 and try discarding it
		If $Case(tDTR,"lit":1,"use":1,:0) {
			If ""'=tStripType && $D($$$vaSchemaGbl(tCategory,"MS",tStripType)) {
				Set tMessageStructure=tCategory_":"_tStripType
				Quit
			} Else { Set tMessageStructure="" }
		} Else {
			Set tMessageStructure=$G($$$vaSchemaGbl(tCategory,"MT",tStripType))
			Quit:""'=tMessageStructure
			Set tMsgType=##class(EnsLib.HL7.Message).GetMsgType(tStripType) ; do the standard thing
			If ""'=tMsgType {
				Set tMessageStructure=$G($$$vaSchemaGbl(tCategory,"MT",tMsgType))
				Quit:""'=tMessageStructure
			}
			#; check for _Qnn or _Znn style structure definitions
			If $P(tMsgType,"_",2)?1U2N {
				Set tMessageStructure=$G($$$vaSchemaGbl(tCategory,"MT",$E(tMsgType,1,*-2)_"nn"))
				Quit:""'=tMessageStructure
			}
		}
		Set tCategory=$G($$$vaSchemaGbl(tCategory,"base"))  Quit:""=tCategory
	}
	If ""=tMessageStructure {
		Quit:"ACK_"=$E(pTypeName,1,4) ..ResolveSchemaTypeToDocType(pSchemaCategory,"ACK",.pStatus)
		Set pStatus=$$$ERROR($$$EnsErrGeneral,"DocType not found for message type "_pSchemaCategory_":"_pTypeName)
	}
	Quit tMessageStructure
}

/// Given an HL7 Schema category and a Message TypeName string, return the corresponding commit ACK name and doctype
/// Note: CommitAck name and doctype are not specified from the message structure definition
ClassMethod ResolveReplyNameAndDocType(pMessageType As %String, Output pReplyMsgName As %String, Output pReplyDocType As %String, pForceAck As %Boolean = 1)
{
	Set pReplyDocType="", pReplyMsgName="ACK"
	set tCategory=$P(pMessageType,":"), tTypeName=$P(pMessageType,":",2)
	If pForceAck {
		#; check for pieces that have what appears to be a msg structure in piece 3 and try discarding it
		Set tPiece3=$P(tTypeName,"_",3,99)
		If ""'=tPiece3&&((tPiece3["_")||(tPiece3["&")||(tPiece3["\S\")||(tPiece3["\T\")) {
			Set:""'=tTypeName pReplyMsgName=pReplyMsgName_"_"_$P(tTypeName,"_",2)
		} Else {
			Set:""'=tTypeName pReplyMsgName=pReplyMsgName_"_"_$P(tTypeName,"_",2,99)
		}
		Set:""'=tCategory pReplyDocType=..ResolveSchemaTypeToDocType(tCategory,"ACK")
		Quit
	}
	Set tRetType=""  While ""'=tCategory {
		Set tRetType=$G($$$vaSchemaGbl(tCategory,"MT",tTypeName,"rettype"))
		Quit:""'=tRetType
		#; check for pieces that have what appears to be a msg structure in piece 3 and try discarding it
		Set tPiece3=$P(tTypeName,"_",3,99)
		If ""'=tPiece3&&((tPiece3["_")||(tPiece3["&")||(tPiece3["\S\")||(tPiece3["\T\")) {
			Set tRetType=$G($$$vaSchemaGbl(tCategory,"MT",$P(tTypeName,"_",1,2),"rettype"))
			Quit:""'=tRetType
		}
		Set tCategory=$G($$$vaSchemaGbl(tCategory,"base"))
	}
	If ""=tRetType Do ..ResolveReplyNameAndDocType(pMessageType,.pReplyMsgName,.pReplyDocType)  Quit

	set tCategory=$P(tRetType,":"), pReplyMsgName=$P(tRetType,":",2)
	Set pReplyDocType=..ResolveSchemaTypeToDocType(tCategory,pReplyMsgName)
	Quit
}

ClassMethod BuildCategoryMaps(pCategory As %String) As %Status
{
	Set tSC=$$$OK, tMsgStructName="" For { Set tMsgStructName=$O($$$vaSchemaGbl(pCategory,"MS",tMsgStructName))  Quit:""=tMsgStructName
		Set tSC=..buildDocStructureMap(pCategory,tMsgStructName)  Quit:$$$ISERR(tSC)
	}
	Set tSegment="" For { Set tSegment=$O($$$vaSchemaGbl(pCategory,"SS",tSegment))  Quit:tSegment=""
		Set tSC=..buildSegmentStructureMap(pCategory,tSegment)  Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod buildDocStructureMap(pCategory As %String, pDocStructName As %String) As %Status
{
	Set tContentArrayName=$Name($$$vaSchemaGbl(pCategory,"MS",pDocStructName,"array"))
	Set tSC=..buildContentArray(tContentArrayName,,pCategory_":"_pDocStructName,1)
	Do ..buildDocStructureMapLoop(tContentArrayName,.tSchemaPathMap,"","=")
	Set index=$O(@tContentArrayName@(""),-1)
	Set tSchemaPathMap("leftoversegs()")="="_(+index+1)_",*|:Any"
	Kill $$$vaSchemaGbl(pCategory,"MS",pDocStructName,"map")
	Merge $$$vaSchemaGbl(pCategory,"MS",pDocStructName,"map")=tSchemaPathMap
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
			Set csCat=$P(cs,":",1), csTyp=$P(cs,":",2)
			If $Case(csTyp,"DT":1,"DTM":1,"FT":1,"GTS":1,"ID":1,"IS":1,"NM":1,"SI":1,"SNM":1,"ST":1,"TM":1,"TN":1,"TX":1,"TS":1,:0) {
				Set cList=$G($$$vaSchemaGbl(csCat,"DT",csTyp))
				Continue:(1=$LL(cList)&&$ListValid($LG(cList,1))&&(""=$LG($LG(cList,1)))) ; don't map standard elementary data types
			}
			Kill subarray
			Set tSC=..buildComponentStructMap(csCat,csTyp,.subarray) Quit:$$$ISERR(tSC)
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
	Set elem="DT"
	Set struct=$G($$$vaSchemaGbl(pDocTypeCategory,elem,pTypeName))
	Set:""=struct elem="DS", struct=$G($$$vaSchemaGbl(pDocTypeCategory,elem,pTypeName))
	Quit:""=struct $$$OK
	Kill names Set name="" For { Set name=$O($$$vaSchemaGbl(pDocTypeCategory,elem,pTypeName,"names",name))  Quit:""=name
		Set names($$$vaSchemaGbl(pDocTypeCategory,elem,pTypeName,"names",name))=name
	}
	Set tSC=$$$OK
	For i=1:1:$LL(struct) {
		Continue:'$D(names(i))
		Set pCSMap(names(i))=i
		Set cs=$LI(struct,i)
		Set:elem="DT" cs=$LI(cs)
		If cs'="" {
			Set csCat=$P(cs,":",1), csTyp=$P(cs,":",2)
			If $Case(csTyp,"DT":1,"DTM":1,"FT":1,"GTS":1,"ID":1,"IS":1,"NM":1,"SI":1,"SNM":1,"ST":1,"TM":1,"TN":1,"TX":1,"TS":1,:0) {
				Set cList=$G($$$vaSchemaGbl(csCat,"DT",csTyp))
				Continue:(1=$LL(cList)&&$ListValid($LG(cList,1))&&(""=$LG($LG(cList,1)))) ; don't map standard elementary data types
			}
			Kill subarray
			Set tSC=..buildComponentStructMap(csCat,csTyp,.subarray)  Quit:$$$ISERR(tSC)
			Set name="" For { Set name=$O(subarray(name))  Quit:name=""
				Set pCSMap(names(i)_"."_name)=pCSMap(names(i))_"."_subarray(name)
			}
		}
	}
	Quit tSC
}

ClassMethod GetFieldNumberFromName(SchemaCategory As %String, SegmentName As %String, FieldName As %String) As %String
{
	quit $get($$$vaSchemaGbl(SchemaCategory,"SS",SegmentName,"map",$zcvt(FieldName,"L")))
}

ClassMethod GetFieldNameFromNumber(SchemaCategory As %String, SegmentName As %String, FieldNumber As %String) As %String
{
	set sub = ""
	set fieldname = ""
	for {
		set sub = $order($$$vaSchemaGbl(SchemaCategory,"SS",SegmentName,"map",sub)) 
		quit:sub=""
		if ($get($$$vaSchemaGbl(SchemaCategory,"SS",SegmentName,"map",sub)) = FieldNumber) {
			set fieldname = sub
			quit ; have fieldname, no need to keep going through the loop
		}
	}
	quit fieldname
}

}
