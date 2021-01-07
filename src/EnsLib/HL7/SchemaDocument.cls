/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

/// Abstract Document used to load HL7 schema definition into Studio.
Class EnsLib.HL7.SchemaDocument Extends %Studio.AbstractDocument [ ClassType = "", ProcedureBlock, System = 4 ]
{

Projection RegisterExtension As %Projection.StudioDocument(DocumentExtension = "HL7", DocumentNew = 0, DocumentType = "xml", XMLNamespace = "http://www.intersystems.com/hl7sd");

Parameter EXTENSION = ".HL7";

/// Load the HL7 schema definition Name into the stream Code<br>
Method Load() As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		If ".HL7"'=$ZCVT($E(..Name,*-3,*),"U") Set tSC=$$$ERROR($$$GeneralError,"Invalid HL7 schema filename '"_..Name_"'")  Quit
		Set tSC=##class(EnsLib.HL7.SchemaXML).Export($E(..Name,1,*-4),..Code)
	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$SystemError
	Goto Exit
}

/// Save the HL7 schema definition document.
Method Save() As %Status
{
	Quit ..ImportStream(..Name,..Code)
}

/// Save the HL7 schema definition document from stream to global.
ClassMethod ImportStream(pName As %String, pStream As %GlobalCharacterStream) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		#; Find old Category name in pStream
		Do pStream.Rewind()
		Set (tLine,tOldCat)="" While tLine'["<Category " { Set tLine=pStream.ReadLine(,.tSC) Quit:pStream.AtEnd }
		Set f=$F(tLine,"name=") Set:f tOldCat=$P($E(tLine,f+1,*),$E(tLine,f))
		Do pStream.Rewind()
		Set tStream=##class(Ens.Util.XML.Reader).ChangeXMLStreamEncoding(pStream,"") Do tStream.Rewind()
		Set tCatName=$E(pName,1,*-4)  If ".HL7"'=$ZCVT($E(pName,*-3,*),"U") Set tSC=$$$ERROR($$$EnsErrGeneral,"Schema "_pName_" is not an HL7 schema")  Quit
		TStart
		Set tSC = ##class(EnsLib.HL7.SchemaXML).Import(tStream,,tCatName)
		If $$$ISOK(tSC) {
			#; Schema loaded ok, let's commit it - but first fix name if needed
			Do:tOldCat'=tCatName pStream.Clear(), ##class(EnsLib.HL7.SchemaXML).Export(tCatName,pStream)
			TCommit
		} Else {
			#; Rollback the schema update
			TRollback
		}
	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$SystemError
	Goto Exit
}

/// Delete the HL7 schema definition <var>name</var>.
ClassMethod Delete(name As %String) As %Status
{
	Quit:$ZCVT($E(name,*-3,*),"U")'=".HL7" $$$ERROR($$$GeneralError,"Invalid HL7 filename")
	Set category=$e(name,1,*-4)
	Set IsStd = +$G($$$vaSchemaDescGbl(category,"std"))
	If IsStd Quit $$$ERROR($$$GeneralError,"Cannot delete standard schema")
	Kill $$$vaSchemaGbl(category)
	Kill $$$vaSchemaDescGbl(category)
	Set tSC2 = $$$AuditModifySchema("HL7 "_category,"Deleted schema")
	Quit $$$OK
}

/// Return the timestamp of schema category 'name' in %TimeStamp format, i.e. $zdatetime($horolog,3).
/// This is used to determine if the category has been updated on the server and so needs reloading into Studio.
/// So the format should be $zdatetime($horolog,3), or "" if the category does not exist.
ClassMethod TimeStamp(name As %String) As %TimeStamp
{
	if $ZCVT($E(name,*-3,*),"U")'=".HL7" set tSC=$$$ERROR($$$GeneralError,"Invalid HL7 schema filename") quit ""
	set ts=$G($$$vaSchemaGbl($E(name,1,*-4),"time"))
	quit ##class(Ens.DataType.UTC).LogicalToOdbc($S(""=ts:ts,1:$ZDT(ts,3,,3)))
}

/// Return the compile time of routine 'name' in %TimeStamp format. The format should be $zdatetime($horolog,3),
/// or "" if the routine does not exist.
ClassMethod CompileTime(name As %String) As %TimeStamp [ CodeMode = expression ]
{
..TimeStamp(.name)
}

/// Return 1 if the given schema definition document exists and 0 if it does not.
ClassMethod Exists(name As %String) As %Boolean
{
	if $ZCVT($E(name,*-3,*),"U")'=".HL7" quit 0
	set category=$E(name,1,*-4)
	quit ''$data($$$vaSchemaGbl(category))
}

Query List(Directory As %String, Flat As %Boolean, System As %Boolean) As %Query(ROWSPEC = "name:%String,modified:%TimeStamp,size:%Integer,directory:%String")
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Directory As %String, Flat As %Boolean, System As %Boolean) As %Status
{
	if $g(Directory)'="" set qHandle="" quit $$$OK
	set index=$I(^IRIS.Temp)
	set cat="" for  set cat=$O($$$vaSchemaGbl(cat)) quit:cat=""  set ^IRIS.Temp(index,cat)=""
	set qHandle=$LB(index,"")
	quit $$$OK
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListExecute ]
{
	set Row="",AtEnd=0
	set tempnode=$LG(qHandle,1),cat=$LG(qHandle,2)
	if (tempnode="") set Row="",AtEnd=1 quit $$$OK
	set cat=$O(^IRIS.Temp(tempnode,cat))
	set $LI(qHandle,2)=cat
	If cat="" Set AtEnd=1 Quit $$$OK
	set Row=$LB(cat_".HL7",$G(^IRIS.Temp(tempnode,cat,"time")),0,"")
	if $O(^IRIS.Temp(tempnode,cat))="" set AtEnd=1
	Quit $$$OK
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListExecute ]
{
	set tempnode=$LG(qHandle,1)
	if tempnode'="" kill ^IRIS.Temp(tempnode)
	set qHandle=""
	Quit $$$OK
}

/// Export this document to the current device in XML format
Method ExportToXML(flags As %String) As %Status
{
	Set ..Code.LineTerminator=$c(10)
	Do ..Code.Rewind()
	Do ..Code.ReadLine()  // omit xml header
	While '(..Code.AtEnd) {
		Write ..Code.Read(16000)
	}
	Quit $$$OK
}

/// Import from the stream in XML format
Method ImportFromXML(stream As %RegisteredObject, flags As %String) As %Status
{
	Do ..Code.Clear()
	Do ..Code.CopyFrom(stream)
	Quit $$$OK
}

/// Reload and save/"compile" all custom schemas and report a status code listing any schemas whose structure changes as a result. If pFlags contains "v" then also print a message for each schema that changes.
ClassMethod ReloadCustomSchemas(pFlags As %String = "") As %String
{
	Set (tSC,tSC1)=$$$OK, tStream=$$$NULLOREF
	New %oldSchema, %oldSchemaDesc
	Set tRS = ##class(%ResultSet).%New("EnsLib.HL7.Message:EnumerateTypeCategories")
	Do tRS.Execute("+")
	While (tRS.Next()) {
		Set tCat = $G(tRS.Data("Category"))
		Set tBase = $G($$$vaSchemaGbl(tCat,"base"))
		
		//If ""'=tBase {
		If pFlags["v" Write !,"Reloading HL7 schema '"_tCat_"'"
		Kill %oldSchema Merge %oldSchema=$$$vaSchemaGbl(tCat)
		Kill %oldSchemaDesc Merge %oldSchemaDesc=$$$vaSchemaDescGbl(tCat)
		Set:'$IsObject(tStream) tStream=##class("%Library.GlobalCharacterStream").%New()
		Set tSC1=##class(EnsLib.HL7.SchemaXML).Export(tCat,tStream)
		Set:$$$ISOK(tSC1) tSC1=..ImportStream(tCat_".HL7",tStream)
		If $$$ISERR(tSC1) Set tSC=$$$ADDSC(tSC,tSC1)  Do:pFlags["v" $System.Status.DisplayError(tSC1)  Continue
		Set %oldSchema("time")=$$$vaSchemaGbl(tCat,"time")
		Set tChange=$$compareArrays^EnsUtil("%oldSchema",$Name($$$vaSchemaGbl(tCat)))
		Set:""=tChange tChange=$$compareArrays^EnsUtil("%oldSchemaDesc",$Name($$$vaSchemaDescGbl(tCat)))
		If ""'=tChange {
			Set tText="Reloading changed HL7 schema '"_tCat_"' at position '"_tChange_"'"
			If pFlags["v" Write !,"** "_tText
			Set tSC1=$$$ERROR($$$EnsErrGeneral,tText)
			Set tSC=$$$ADDSC(tSC,tSC1)
		}
	}
	Do tRS.Close()
	Set tRS = $$$NULLOREF
	Quit tSC
}

}
