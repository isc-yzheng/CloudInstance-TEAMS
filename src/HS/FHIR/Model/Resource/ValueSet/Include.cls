/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ValueSet.Include when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ValueSet.Include Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ValueSet.Include";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ValueSet.Include";

///  
Property system As HS.FHIR.Model.Datatype.Uri(XMLNAME = "system") [ Required ];

///  
Property version As HS.FHIR.Model.Datatype.String(XMLNAME = "version");

///  
Property concept As list Of HS.FHIR.Model.Resource.ValueSet.Concept1(XMLNAME = "concept", XMLPROJECTION = "ELEMENT");

///  
Property filter As list Of HS.FHIR.Model.Resource.ValueSet.Filter(XMLNAME = "filter", XMLPROJECTION = "ELEMENT");

///  
Method SetSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..system = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..version = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
