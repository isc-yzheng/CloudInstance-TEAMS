/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ImplementationGuide.Package when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ImplementationGuide.Package Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ImplementationGuide.Package";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ImplementationGuide.Package";

///  
Property name As HS.FHIR.Model.Datatype.String(XMLNAME = "name") [ Required ];

///  
Property description As HS.FHIR.Model.Datatype.String(XMLNAME = "description");

///  
Property resource As list Of HS.FHIR.Model.Resource.ImplementationGuide.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

///  
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
