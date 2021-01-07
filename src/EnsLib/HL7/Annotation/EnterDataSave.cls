/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Annotation.EnterDataSave Extends %CSP.Page [ System = 4 ]
{

Parameter SECURITYRESOURCE = "%Ens_EDISchemaAnnotations:WRITE";

ClassMethod OnPage() As %Status
{
	Set version=$G(%request.Data("version",1),"2.5")
	Set type=$G(%request.Data("type",1),"MG")
	Set item=$G(%request.Data("item",1))
	Set doSave=$D(%request.Data("Save",1))
	#dim annot As EnsLib.HL7.Annotation.Data
	S annot=##Class(EnsLib.HL7.Annotation.Data).%New(version)
	//this page does nothing but save the data, and then go back
	//to the page that submitted it
	&html<<html>
<head>
<script language="javascript" type="text/javascript">
function atload() {history.go(-1)}
window.onload=atload;
</script>
</head>
<body>>
	IF type="MG" {
		DO annot.LoadMG(.mgs)
		IF doSave { DO update(.mgs),annot.SaveMG(.mgs)}
	}
	ElseIF type="MT" {
		Write "<br><br>"
		DO annot.LoadMT(item,.mts) Set mt=""
		IF doSave { DO update(.mts),annot.SaveMT(.mts)}
	}
	ElseIF type="MS" {
		Do annot.LoadMS(item,.segs)
		IF doSave { DO update(.segs),annot.SaveMS(item,.segs)}
	}
	ElseIF type="SS" {
		Do annot.LoadSS(item,.flds)
		IF doSave {
			DO update(.flds),annot.SaveSS(item,.flds)}
	}
	ElseIF type="DS" {
	Set ds=""
		Do annot.LoadDS(item,.flds)
		IF doSave { DO update(.flds),annot.SaveDS(item,.flds)}
	}
	&html<</body>
</html>>
	Quit $$$OK
	
update(array)
	s n1="note"
	F  { 
		s n1=$O(%request.Data(n1)) Q:$E(n1,1,5)'="note@"
		S array($P(n1,"@",2),"Note")=%request.Data(n1,1)
	}
	S n1="usage"
	F  {
		s n1=$O(%request.Data(n1)) Q:$E(n1,1,6)'="usage@"
		S array($P(n1,"@",2),"U")=%request.Data(n1,1)
	}
	S n1="HSPRI"
	F  {
		s n1=$O(%request.Data(n1)) Q:$E(n1,1,6)'="HSPRI@"
		S array($P(n1,"@",2),"HSPRI")=%request.Data(n1,1)
	}
}

}
