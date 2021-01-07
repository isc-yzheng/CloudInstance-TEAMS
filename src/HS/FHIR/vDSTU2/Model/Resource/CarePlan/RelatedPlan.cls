Class HS.FHIR.vDSTU2.Model.Resource.CarePlan.RelatedPlan Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan.RelatedPlan";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan.RelatedPlan";

/// Identifies the type of relationship this plan has to the target plan.
Property code As HS.FHIR.vDSTU2.Model.Base.CarePlanRelationship(XMLNAME = "code");

/// A reference to the plan to which a relationship is asserted.
Property plan As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "plan") [ Required ];

/// Set method for the "code" property.
Method SetCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CarePlanRelationship).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CarePlanRelationship object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "plan" property.
Method SetPlan(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..plan = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
