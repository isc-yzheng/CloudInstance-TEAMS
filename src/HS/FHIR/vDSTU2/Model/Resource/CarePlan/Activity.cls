Class HS.FHIR.vDSTU2.Model.Resource.CarePlan.Activity Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CarePlan.Activity";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CarePlan.Activity";

/// Resources that describe follow-on actions resulting from the plan, such as drug prescriptions, encounter records, appointments, etc.
Property actionResulting As list Of HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "actionResulting", XMLPROJECTION = "ELEMENT");

/// Notes about the adherence/status/progress of the activity.
Property progress As list Of HS.FHIR.vDSTU2.Model.Base.Annotation(XMLNAME = "progress", XMLPROJECTION = "ELEMENT");

/// The details of the proposed activity represented in a specific resource.
Property reference As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "reference");

/// A simple summary of a planned activity suitable for a general care plan system (e.g. form driven) that doesn't know about specific resources such as procedure etc.
Property detail As HS.FHIR.vDSTU2.Model.Resource.CarePlan.Detail(XMLNAME = "detail");

/// Insert method for the "actionResulting" property.
Method SetActionResulting(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set tSC = ..actionResulting.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "reference" property.
Method SetReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..reference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
