/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Conformance.Messaging when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Conformance.Messaging Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Conformance.Messaging";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Conformance.Messaging";

///  
Property endpoint As list Of HS.FHIR.Model.Resource.Conformance.Endpoint(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

///  
Property reliableCache As HS.FHIR.Model.Datatype.UnsignedInt(XMLNAME = "reliableCache");

///  
Property documentation As HS.FHIR.Model.Datatype.String(XMLNAME = "documentation");

///  
Property event As list Of HS.FHIR.Model.Resource.Conformance.Event(XMLNAME = "event", XMLPROJECTION = "ELEMENT") [ Required ];

///  
Method SetReliableCache(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed") Quit
		Set ..reliableCache = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetDocumentation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..documentation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
