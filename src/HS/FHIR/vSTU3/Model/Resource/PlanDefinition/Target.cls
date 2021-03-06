/// This resource allows for the definition of various types of plans as a sharable, consumable, and executable artifact. The resource is general enough to support the description of a broad range of clinical artifacts such as clinical decision support rules, order sets and protocols.
Class HS.FHIR.vSTU3.Model.Resource.PlanDefinition.Target Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.Target";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.Target";

Parameter JSONTYPEFIELD;

/// The parameter whose value is to be tracked, e.g. body weigth, blood pressure, or hemoglobin A1c level.
Property measure As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "measure", XMLPROJECTION = "ELEMENT");

Property detailQuantity As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "detailQuantity", XMLPROJECTION = "ELEMENT");

Property detailRange As HS.FHIR.vSTU3.Model.Base.Range(XMLNAME = "detailRange", XMLPROJECTION = "ELEMENT");

Property detailCodeableConcept As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "detailCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Indicates the timeframe after the start of the goal in which the goal should be met.
Property due As HS.FHIR.vSTU3.Model.Base.Duration(XMLNAME = "due", XMLPROJECTION = "ELEMENT");

/// Set method for the "measure" property.
Method SetMeasure(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..measure = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "detailQuantity" property.
Method SetDetailQuantity(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..detailQuantity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "detailCodeableConcept" property.
Method SetDetailCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..detailCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
