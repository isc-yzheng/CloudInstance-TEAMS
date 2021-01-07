Class HS.FHIR.vDSTU2.Model.Resource.Provenance.Agent Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance.Agent";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance.Agent";

/// The function of the agent with respect to the activity.
Property role As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "role") [ Required, SqlFieldName = _role ];

/// The individual, device or organization that participated in the event.
Property actor As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "actor");

/// The identity of the agent as known by the authorization system.
Property userId As HS.FHIR.vDSTU2.Model.Base.Identifier(XMLNAME = "userId");

/// A relationship between two the agents referenced in this resource. This is defined to allow for explicit description of the delegation between agents.  For example, this human author used this device, or one person acted on another's behest.
Property relatedAgent As list Of HS.FHIR.vDSTU2.Model.Resource.Provenance.RelatedAgent(XMLNAME = "relatedAgent", XMLPROJECTION = "ELEMENT");

/// Set method for the "role" property.
Method SetRole(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..role = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "actor" property.
Method SetActor(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..actor = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "userId" property.
Method SetUserId(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed") Quit
		Set ..userId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
