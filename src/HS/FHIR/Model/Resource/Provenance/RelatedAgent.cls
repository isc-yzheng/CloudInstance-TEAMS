/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Provenance.RelatedAgent when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Provenance.RelatedAgent Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Provenance.RelatedAgent";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Provenance.RelatedAgent";

///  
Property type As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "type") [ Required ];

///  
Property target As HS.FHIR.Model.Datatype.Uri(XMLNAME = "target") [ Required ];

///  
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetTarget(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..target = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}