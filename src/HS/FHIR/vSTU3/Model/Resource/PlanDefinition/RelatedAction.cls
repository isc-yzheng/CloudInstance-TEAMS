/// This resource allows for the definition of various types of plans as a sharable, consumable, and executable artifact. The resource is general enough to support the description of a broad range of clinical artifacts such as clinical decision support rules, order sets and protocols.
Class HS.FHIR.vSTU3.Model.Resource.PlanDefinition.RelatedAction Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.RelatedAction";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.RelatedAction";

Parameter JSONTYPEFIELD;

/// The element id of the related action.
Property actionId As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "actionId", XMLPROJECTION = "ELEMENT") [ Required ];

/// The relationship of this action to the related action.
Property relationship As HS.FHIR.vSTU3.Model.Base.ActionRelationshipType(XMLNAME = "relationship", XMLPROJECTION = "ELEMENT") [ Required ];

Property offsetDuration As HS.FHIR.vSTU3.Model.Base.Duration(XMLNAME = "offsetDuration", XMLPROJECTION = "ELEMENT");

Property offsetRange As HS.FHIR.vSTU3.Model.Base.Range(XMLNAME = "offsetRange", XMLPROJECTION = "ELEMENT");

/// Set method for the "actionId" property.
Method SetActionId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..actionId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "relationship" property.
Method SetRelationship(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ActionRelationshipType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ActionRelationshipType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..relationship = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
