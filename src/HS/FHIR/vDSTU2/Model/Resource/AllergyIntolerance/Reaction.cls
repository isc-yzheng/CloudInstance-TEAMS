Class HS.FHIR.vDSTU2.Model.Resource.AllergyIntolerance.Reaction Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AllergyIntolerance.Reaction";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "AllergyIntolerance.Reaction";

/// Identification of the specific substance considered to be responsible for the Adverse Reaction event. Note: the substance for a specific reaction may be different to the substance identified as the cause of the risk, but must be consistent with it. For instance, it may be a more specific substance (e.g. a brand medication) or a composite substance that includes the identified substance. It must be clinically safe to only process the AllergyIntolerance.substance and ignore the AllergyIntolerance.event.substance.
Property substance As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "substance");

/// Statement about the degree of clinical certainty that the specific substance was the cause of the manifestation in this reaction event.
Property certainty As HS.FHIR.vDSTU2.Model.Base.AllergyIntoleranceCertainty(XMLNAME = "certainty");

/// Clinical symptoms and/or signs that are observed or associated with the adverse reaction event.
Property manifestation As list Of HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "manifestation", XMLPROJECTION = "ELEMENT") [ Required ];

/// Text description about the reaction as a whole, including details of the manifestation if required.
Property description As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "description");

/// Record of the date and/or time of the onset of the Reaction.
Property onset As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "onset");

/// Clinical assessment of the severity of the reaction event as a whole, potentially considering multiple different manifestations.
Property severity As HS.FHIR.vDSTU2.Model.Base.AllergyIntoleranceSeverity(XMLNAME = "severity");

/// Identification of the route by which the subject was exposed to the substance.
Property exposureRoute As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "exposureRoute");

/// Additional text about the adverse reaction event not captured in other fields.
Property note As HS.FHIR.vDSTU2.Model.Base.Annotation(XMLNAME = "note");

/// Set method for the "substance" property.
Method SetSubstance(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..substance = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "certainty" property.
Method SetCertainty(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.AllergyIntoleranceCertainty).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR AllergyIntoleranceCertainty object failed") Quit
		Set ..certainty = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "manifestation" property.
Method SetManifestation(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set tSC = ..manifestation.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "onset" property.
Method SetOnset(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..onset = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "severity" property.
Method SetSeverity(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.AllergyIntoleranceSeverity).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR AllergyIntoleranceSeverity object failed") Quit
		Set ..severity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "exposureRoute" property.
Method SetExposureRoute(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..exposureRoute = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
