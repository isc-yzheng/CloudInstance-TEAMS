/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

IncludeGenerator (Ensemble, %occInclude, EnsSearchTableErrors)

Class Ens.VDoc.SearchTable Extends Ens.SearchTableBase [ Abstract, ClassType = "", ProcedureBlock, System = 3 ]
{

/// Specification of virtual document properties for which to add SearchTable references
XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
}

/// Index of a virtual property definition row in class <class>Ens.Config.SearchTableProp</class>, in the context of the current SearchTable subclass's storage extent
Property PropId As %Integer;

/// Value found in the document using the ValueGetExpression from the property Item referred to by PropId
Property PropValue As %String(MAXLEN = 256, TRUNCATE = 1);

// Index must be re-declared in each non-Abstract, %Persistent subclass

Index indexValue On (PropId, PropValue, DocId) [ IdKey, Unique ];

// Index must be re-declared in each non-Abstract, %Persistent subclass

Index indexDocId On (DocId, PropId, PropValue) [ Unique ];

ClassMethod IndexDoc(pDocObj As %Persistent) As %Status [ CodeMode = objectgenerator ]
{
#define AnyMethods(%p)     $P(%p,",",1)
#define AnyTypeMethods(%p) $P(%p,",",2)
#define AnyNameMethods(%p) $P(%p,",",3)
#define AnyStoreMethod(%p) $P(%p,",",4)

	If $Case(%class.Name,"Ens.VDoc.SearchTable":1, "Ens.VDoc.XMLSearchTable":1,:0) {
		Do %code.WriteLine(" Quit $$$OK")
		Quit $$$OK
	}
	Set tDocClassname=$$$GetClassParameter(%class.Name,"DOCCLASS")
	Quit:""=tDocClassname $$$ERROR($$$EnsSearchTableDocClassRequired)
	Quit:'##class(%Dictionary.CompiledClass).%ExistsId(tDocClassname) $$$ERROR($$$EnsErrGeneral,"Document class '"_tDocClassname_"' does not exist")
	Do %code.WriteLine(" Set tSC=$$$OK")
	Do %code.WriteLine(" If '$$$IsdefObject(pDocObj) || 'pDocObj.%Extends("""_tDocClassname_""") Quit $$$ERROR($$$EnsErrGeneral,""SearchTable generated class must be initialized with a '"_tDocClassname_"' Document object; got ""_pDocObj)")

	Set tDocExtent = ##class(Ens.VDoc.SearchTableGenerator).GetExtentSuperclass(tDocClassname)
	Set tBaseExtent = ##class(Ens.VDoc.SearchTableGenerator).GetExtentSuperclass(%class.Name)
	Do %code.WriteLine(" Set tSC = ##class(Ens.DocClassMap).AddSearchTable($classname(pDocObj),"""_tBaseExtent_""")")
	Do %code.WriteLine(" Quit:$$$ISERR(tSC) tSC")
	If (tDocExtent '= "") {
		Do %code.WriteLine(" If """_tDocExtent_""" '= $classname(pDocObj) {")
		Do %code.WriteLine("  Set tSC = ##class(Ens.DocClassMap).AddSearchTable("""_tDocExtent_""","""_tBaseExtent_""")")
		Do %code.WriteLine("  Quit:$$$ISERR(tSC) tSC")
		Do %code.WriteLine(" }")
	}

	#; Call the right 'StoreXXX label based on DocType or doc Name
	Set tSC=##class(Ens.VDoc.SearchTableGenerator).getMethods(tDocClassname,.tProps,.tItems,.tTypeMethods) Quit:$$$ISERR(tSC) tSC
 	Do %code.WriteLine(" Set tDocId=pDocObj.%Id() If """"=tDocId Set tSC=pDocObj.%Save()  Quit:$$$ISERR(tSC) tSC  Set tDocId=pDocObj.%Id()")
	Do %code.WriteLine(" Set tSCFindProp = $$$OK")
	Do:$$$AnyTypeMethods(tTypeMethods) %code.WriteLine(" Goto:""""'=pDocObj.DocType DocTypeSwitch")
	Do:$$$AnyNameMethods(tTypeMethods) %code.WriteLine(" Goto:""""'=pDocObj.Name DocNameSwitch") ; use no-cat obj.Name if no DocType set")
	Do %code.WriteLine(" Goto "_$S($$$AnyStoreMethod(tTypeMethods):"Store", 1:"DoneStore"))

	Set tPropName=""
	For {
		Set tPropName = $O(tProps(tPropName))
		Quit:(tPropName = "")
		Set tProp = tProps(tPropName)
		Set tTable = $$$ClassSQLTable($P(tProp.ClassDerivation,"~"))
		If '$data(tInsertLabels(tTable)) {
			Set tInsertLabels(tTable)=$increment(tInsertLabels)
		}
	}
	Set tSC=##class(Ens.VDoc.SearchTableGenerator).genMethods(tDocClassname,.tProps,.tItems,.tTypeMethods,%class.Super,.tInsertLabels) Quit:$$$ISERR(tSC) tSC
	If $$$AnyTypeMethods(tTypeMethods) {
		Do %code.WriteLine("DocTypeSwitch")
		Do %code.WriteLine(" Goto $Case(pDocObj.DocType ; call the local label for the given DocType")
		Set tDocType="" For { Set tDocType=$O(tTypeMethods(tDocType),1,tMethodName)  Quit:""=tDocType
			Continue:""=$P(tDocType,":")
			Do %code.WriteLine("            ,"""_tDocType_""":"_tMethodName)
		}
		If $$$AnyNameMethods(tTypeMethods) {
			Do %code.WriteLine("            ,:DocNameSwitch)")
		} Else {
			Do %code.WriteLine("            ,:"_$S($$$AnyStoreMethod(tTypeMethods):"Store", 1:"DoneStore")_")")
		}
	}
	If $$$AnyNameMethods(tTypeMethods) {
		Do %code.WriteLine("DocNameSwitch")
		Set pClassDef=##class(%Dictionary.CompiledClass).%OpenId(tDocClassname,0,.tSC)  Quit:$$$ISERR(tSC) tSC
		Set tIndex = pClassDef.Methods.FindObjectId(pClassDef.Name_"||GetMsgType")
		If ""=tIndex {
			Do %code.WriteLine(" Goto $Case(pDocObj.Name ; call the local label for the given doc Name")
		} Else {
			Do %code.WriteLine(" Goto $Case(pDocObj.GetMsgType(pDocObj.Name) ; call the local label for the given doc Name")
		}
		Set tDocType="" For { Set tDocType=$O(tTypeMethods(tDocType),1,tMethodName)  Quit:""=tDocType
			Continue:""'=$P(tDocType,":")
			Do %code.WriteLine("            ,"""_$P(tDocType,":",2)_""":"_tMethodName)
		}
		Do %code.WriteLine("            ,:"_$S($$$AnyStoreMethod(tTypeMethods):"Store", 1:"DoneStore")_")")
	}
	Do %code.WriteLine("DoneStore Quit $$$ADDSC(tSC, tSCFindProp)")
	Do %code.WriteLine("PropStoreError Quit $$$ERROR($$$EnsErrGeneral,""Failed to save "_%class.Name_" instance for Property ""_tProp_"" (PropId ""_tPropId_"") for doc type '""_tType_""', SQLCODE=""_SQLCODE)")

	Set tTable = ""
	For {
		Set tTable = $O(tInsertLabels(tTable))
		Quit:(tTable = "")
		Do %code.WriteLine("SearchTableInsert"_tInsertLabels(tTable)_" ; INSERT for "_tTable)
		Do %code.WriteLine(" &sql(INSERT INTO "_tTable_" (PropId,PropValue,DocId) VALUES (:tPropId,:tNormVal,:tDocId))")
		Do %code.WriteLine(" Quit")
	}
	Quit $$$OK
}

/// Build output array of all documents and message headers that contain the given value for the given property
ClassMethod Search(Output pOutput, pPropId As %Integer, pPropValue As %String, pSearchNulls As %Boolean = 0, ByRef pRows = 250) As %Status [ CodeMode = objectgenerator ]
{
	If $Case(%class.Name,"Ens.VDoc.SearchTable":1, "Ens.VDoc.XMLSearchTable":1,:0) {
		Do %code.WriteLine(" Quit $$$OK")
		Quit $$$OK
	}
	//Set:tPropInsensitve pPropValue=$zcvt(pPropValue,"u")
	Do %code.WriteLine(" Set tMaxRows=pRows, pRows=0")
	Do %code.WriteLine(" If """"=pPropValue&&'pSearchNulls {")
	Do %code.WriteLine("  &sql(DECLARE sql1 CURSOR FOR")
	Do %code.WriteLine("   Select DocId into :tDocId from "_%compiledclass.SqlSchemaName_"."_%compiledclass.SqlTableName_" where PropId =:pPropId)")
	Do %code.WriteLine("  &sql(OPEN sql1)  For { &sql(FETCH sql1)  Quit:SQLCODE")
	 Do %code.WriteLine("   Continue:tDocId=""""")
	 Do %code.WriteLine("   Kill tOutput")
	 Do %code.WriteLine("   Do ..SearchHeader(.tOutput,tDocId)")
	 Do %code.WriteLine("   Merge pOutput=tOutput")
	Do %code.WriteLine("  } &sql(CLOSE sql1)")
	Do %code.WriteLine(" } Else {")
	Do %code.WriteLine("  &sql(DECLARE sql1a CURSOR FOR")
	Do %code.WriteLine("   Select DocId into :tDocId from "_%compiledclass.SqlSchemaName_"."_%compiledclass.SqlTableName_" where PropId =:pPropId and PropValue %startswith :pPropValue)")
	Do %code.WriteLine("  &sql(OPEN sql1a)  For { &sql(FETCH sql1a)  Quit:SQLCODE")
	 Do %code.WriteLine("   Continue:tDocId=""""")
	 Do %code.WriteLine("   Kill tOutput")
	 Do %code.WriteLine("   Do ..SearchHeader(.tOutput,tDocId)")
	 Do %code.WriteLine("   Merge pOutput=tOutput")
	Do %code.WriteLine("  } &sql(CLOSE sql1a)")
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Quit $$$OK")
	Quit $$$OK
}

/// Delete the objects that define SearchTable properties for this searchTable class and all other classes in the same inheritance tree.
ClassMethod DeleteProps() As %Status [ CodeMode = objectgenerator ]
{
	If $Case(%class.Name,"Ens.VDoc.SearchTable":1, "Ens.VDoc.XMLSearchTable":1,:0) {
		Do %code.WriteLine(" Quit $$$OK")
		Quit $$$OK
	}
	Set tExtentSuper=##class(Ens.VDoc.SearchTableGenerator).GetExtentSuperclass(%class.Name)
	Set tExtentSupertable=##class(Ens.VDoc.SearchTableGenerator).GetExtentSupertable(%class.Name)
	Do %code.WriteLine(" &sql(Select ID into :tId from "_tExtentSupertable_")")
	Do %code.WriteLine(" If '%ROWCOUNT {")
	Do %code.WriteLine("  Set tSC=##class(Ens.VDoc.SearchTableGenerator).DeleteProps("""_tExtentSuper_""")  Quit:$$$ISERR(tSC) tSC")
	Do %code.WriteLine("  Write ""SearchTableProp objects have been deleted. Force a recompile of '"_tExtentSuper_"' and all its derived classes in order to regenerate them""")
	Do %code.WriteLine("  Quit $$$OK")
	Do %code.WriteLine(" } Else {")
	Do %code.WriteLine("  Quit $$$ERROR($$$EnsErrGeneral,""Cannot delete SearchTableProp objects while SearchTable entries exist in table '"_tExtentSupertable_"' (SQLCODE=""_SQLCODE_"")"")")
	Do %code.WriteLine(" }")
	Quit $$$OK
}

/// Returns True if the given expression will return multiple values
ClassMethod IsListExpression(tGetExpression As %String) As %Boolean [ CodeMode = expression ]
{
((tGetExpression["{")&&(tGetExpression["()"))||(tGetExpression["[")
}

/// Generates an expression that 1) evaluates to a string value and 2) sets status code 'tSCGet'
ClassMethod genGetCode(tGetExpression As %String) As %String
{
 	#; cheezy pre-parser for curly-bracket syntax
	Set tLine="", tPrev = ""
	Set tInBrackets = 0 // keep track of whether we're in a set of brackets so that we don't stick "pDocObj." inside them
	For i=1:1:$L(tGetExpression,"_") {
		Set tExpr=$ZSTRIP($P(tGetExpression,"_",i),"<>W")
		Set tInBrackets = tInBrackets + ($L(tPrev,"{")-1) //add number of open brackets
		Set tInBrackets = tInBrackets - ($L(tPrev,"}")-1) //subtract number of closing brackets
		Set:'tInBrackets&&$Case($E(tExpr),"""":0,"{":0,"$":0,"#":0,"":0,:1) tExpr="pDocObj."_tExpr
		Set tLine=tLine_$S(i=1:"",1:"_")_tExpr
		Set tPrev = tExpr
	}
	Set tGetExpression=tLine
 	If (tGetExpression["{") {
		While tGetExpression["{" { Set tGetExpression=$ZSTRIP($P(tGetExpression,"{"),"<>W")_"pDocObj.GetValueAt("""_$ZSTRIP($P(tGetExpression,"{",2,$L(tGetExpression,"{")),"<>W") }
		While tGetExpression["}" { Set tGetExpression=$ZSTRIP($P(tGetExpression,"}"),"<>W")_""",,.tSCGet)"_$ZSTRIP($P(tGetExpression,"}",2,$L(tGetExpression,"}")),"<>W") }
	}
	Quit tGetExpression
}

/// Generates an expression that sets an array of values found in 'tList' and 2) sets status code 'tSCGet'
/// It may evaluate to a string but we intend to ignore that.
ClassMethod genGetCodeList(tGetExpression As %String, tPreExpression As %String, tPostExpression As %String) As %String
{
	#; cheezy pre-parser for curly-bracket list and square-bracket syntax
	Set (tPreExpression,tPostExpression) = ""
	#; extract piece of expression which appears before all virtual property syntax
	Set:$Case($E(tGetExpression),"{":0,"[":0,:1) tPreExpression=$P($P(tGetExpression,"{"),"[")
	#; extract piece of expression which appears after all virtual property syntax
	Set:$Case($E(tGetExpression,*),"}":0,"]":0,:1) tPostExpression=$P($P(tGetExpression,"}",*),"]",*)
	Set tGetExpression=$E(tGetExpression,$L(tPreExpression)+1,*-$L(tPostExpression))
	While tGetExpression["{" { Set tGetExpression=$ZSTRIP($P(tGetExpression,"{"),"<>W")_"pDocObj.GetValuesArray("""_$ZSTRIP($P(tGetExpression,"{",2,$L(tGetExpression,"{")),"<>W") }
	While tGetExpression["}" { Set tGetExpression=$ZSTRIP($P(tGetExpression,"}"),"<>W")_""",,.tList,.tSCGet)"_$ZSTRIP($P(tGetExpression,"}",2,$L(tGetExpression,"}")),"<>W") }
	Set tGetExpression=$Replace(tGetExpression,"[]","{}") // so that "[]" doesn't get converted
	While tGetExpression["[" { Set tGetExpression=$ZSTRIP($P(tGetExpression,"["),"<>W")_"pDocObj.FindSegmentValuesArray("""_$ZSTRIP($P(tGetExpression,"[",2,$L(tGetExpression,"[")),"<>W") }
	While tGetExpression["]" { Set tGetExpression=$ZSTRIP($P(tGetExpression,"]"),"<>W")_""",,.tList,.tSCGet)"_$ZSTRIP($P(tGetExpression,"]",2,$L(tGetExpression,"]")),"<>W") }
	Set tGetExpression=$Replace(tGetExpression,"{}","[]") // convert back to "[]"
	Quit tGetExpression
}

ClassMethod getPropId(pSearchTable As %String, pPropName As %String) As %Integer [ Internal, Private ]
{
	Set tPropId = $get($$$EnsJobLocal("SearchTableCache",pSearchTable,pPropName))
	If tPropId {
		Quit tPropId
	}
	&sql(SELECT PropID INTO :tPropId FROM Ens_Config.SearchTableProp WHERE ClassExtent = :pSearchTable AND Name = :pPropName)
	If SQLCODE = 0 {
		If $data($$$EnsJobLocal) { Set $$$EnsJobLocal("SearchTableCache",pSearchTable,pPropName) = tPropId }
		Quit tPropId
	}
	Quit 0
}

}
