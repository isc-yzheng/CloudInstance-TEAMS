/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ValueSet.Compose when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ValueSet.Compose Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ValueSet.Compose";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ValueSet.Compose";

///  
Property import As list Of HS.FHIR.Model.Datatype.Uri(XMLNAME = "import", XMLPROJECTION = "ELEMENT");

///  
Property include As list Of HS.FHIR.Model.Resource.ValueSet.Include(XMLNAME = "include", XMLPROJECTION = "ELEMENT");

///  
Property exclude As list Of HS.FHIR.Model.Resource.ValueSet.Include(XMLNAME = "exclude", XMLPROJECTION = "ELEMENT");

///  
Method SetImport(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set tSC = ..import.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
