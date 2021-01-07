/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ImagingObjectSelection.Series when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ImagingObjectSelection.Series Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ImagingObjectSelection.Series";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ImagingObjectSelection.Series";

///  
Property uid As HS.FHIR.Model.Datatype.Oid(XMLNAME = "uid");

///  
Property url As HS.FHIR.Model.Datatype.Uri(XMLNAME = "url");

///  
Property instance As list Of HS.FHIR.Model.Resource.ImagingObjectSelection.Instance(XMLNAME = "instance", XMLPROJECTION = "ELEMENT") [ Required ];

///  
Method SetUid(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed") Quit
		Set ..uid = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
