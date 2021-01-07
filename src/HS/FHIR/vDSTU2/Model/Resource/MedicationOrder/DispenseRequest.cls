Class HS.FHIR.vDSTU2.Model.Resource.MedicationOrder.DispenseRequest Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationOrder.DispenseRequest";

Parameter XMLSEQUENCE = 0;

Parameter XMLTYPE = "MedicationOrder.DispenseRequest";

Property medicationCodeableConcept As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "medicationCodeableConcept");

Property medicationReference As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "medicationReference");

/// This indicates the validity period of a prescription (stale dating the Prescription).
Property validityPeriod As HS.FHIR.vDSTU2.Model.Base.Period(XMLNAME = "validityPeriod");

/// An integer indicating the number of additional times (aka refills or repeats) the patient can receive the prescribed medication.   Usage Notes: This integer does NOT include the original order dispense.   This means that if an order indicates dispense 30 tablets plus"3 repeats", then the order can be dispensed a total of 4 times and the patient can receive a total of 120 tablets.
Property numberOfRepeatsAllowed As HS.FHIR.vDSTU2.Model.Datatype.PositiveInt(XMLNAME = "numberOfRepeatsAllowed");

/// The amount that is to be dispensed for one fill.
Property quantity As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "quantity");

/// Identifies the period time over which the supplied product is expected to be used, or the length of time the dispense is expected to last.
Property expectedSupplyDuration As HS.FHIR.vDSTU2.Model.Base.Duration(XMLNAME = "expectedSupplyDuration");

/// Set method for the "medicationCodeableConcept" property.
Method SetMedicationCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..medicationCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "medicationReference" property.
Method SetMedicationReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..medicationReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "validityPeriod" property.
Method SetValidityPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed") Quit
		Set ..validityPeriod = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "numberOfRepeatsAllowed" property.
Method SetNumberOfRepeatsAllowed(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..numberOfRepeatsAllowed = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
