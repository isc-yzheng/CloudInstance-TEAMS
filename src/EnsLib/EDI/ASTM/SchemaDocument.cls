/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsEDIASTM

/// Abstract Document used to load ASTM schema definition into Studio.
Class EnsLib.EDI.ASTM.SchemaDocument Extends %Studio.AbstractDocument [ ClassType = "", ProcedureBlock, System = 4 ]
{

Projection RegisterExtension As %Projection.StudioDocument(DocumentExtension = "AST", DocumentNew = 0, DocumentType = "xml");

Parameter EXTENSION = ".AST";

/// Load the ASTM schema definition Name into the stream Code<br>
Method Load() As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		If ".AST"'=$ZCVT($E(..Name,*-3,*),"U") Set tSC=$$$ERROR($$$GeneralError,"Invalid ASTM schema filename '"_..Name_"'")  Quit
		Set tSC=##class(EnsLib.EDI.ASTM.SchemaXML).Export($E(..Name,1,*-4),..Code)
	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$SystemError
	Goto Exit
}

/// Save the ASTM schema definition document.
Method Save() As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		#; Find old Category name in ..Code
		Do ..Code.Rewind()
		Set (tLine,tOldCat)="" While tLine'["<Category " { Set tLine=..Code.ReadLine(,.tSC) Quit:..Code.AtEnd }
		Set f=$F(tLine,"name=") Set:f tOldCat=$P($E(tLine,f+1,*),$E(tLine,f))
		Do ..Code.Rewind()
		Set tStream=##class(Ens.Util.XML.Reader).ChangeXMLStreamEncoding(..Code,"") Do tStream.Rewind()
		Set tCatName=$E(..Name,1,*-4)  If ".AST"'=$ZCVT($E(..Name,*-3,*),"U") Set tSC=$$$ERROR($$$EnsErrGeneral,"Schema "_..Name_" is not an ASTM schema")  Quit
		tstart
		Set tSC = ##class(EnsLib.EDI.ASTM.SchemaXML).Import(tStream,,tCatName)
		If $$$ISOK(tSC) {
			#; Schema loaded ok, let's commit it - but first fix name if needed
			Do:tOldCat'=tCatName ..Code.Clear(), ##class(EnsLib.EDI.ASTM.SchemaXML).Export(tCatName,..Code)
			tcommit
		} Else {
			#; Rollback the schema update			
			trollback
		}
	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$SystemError
	Goto Exit
}

/// Delete the ASTM schema definition <var>name</var>.
ClassMethod Delete(name As %String) As %Status
{
	Quit:$ZCVT($E(name,*-3,*),"U")'=".AST" $$$ERROR($$$GeneralError,"Invalid ASTM filename")
	Set category=$e(name,1,*-4)
	Set IsStd = +$G($$$vaSchemaDescGbl(category,"std"))
	If IsStd Quit $$$ERROR($$$GeneralError,"Cannot delete standard schema")
	Kill $$$vaSchemaGbl(category)
	Kill $$$vaSchemaDescGbl(category)
	Set tSC2 = $$$AuditModifySchema("ASTM "_category,"Deleted schema")
	Quit $$$OK
}

/// Return the timestamp of schema category 'name' in %TimeStamp format, i.e. $zdatetime($horolog,3).
/// This is used to determine if the category has been updated on the server and so needs reloading into Studio.
/// So the format should be $zdatetime($horolog,3), or "" if the category does not exist.
ClassMethod TimeStamp(name As %String) As %TimeStamp
{
	if $ZCVT($E(name,*-3,*),"U")'=".AST" set tSC=$$$ERROR($$$GeneralError,"Invalid ASTM filename") quit ""
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
	if $ZCVT($E(name,*-3,*),"U")'=".AST" quit 0
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
	set Row=$LB(cat_".AST",$G(^IRIS.Temp(tempnode,cat,"time")),0,"")
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

}
