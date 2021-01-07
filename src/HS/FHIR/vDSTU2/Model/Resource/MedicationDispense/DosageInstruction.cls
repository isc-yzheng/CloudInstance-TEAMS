Class HS.FHIR.vDSTU2.Model.Resource.MedicationDispense.DosageInstruction Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MedicationDispense.DosageInstruction";

Parameter XMLSEQUENCE = 0;

Parameter XMLTYPE = "MedicationDispense.DosageInstruction";

/// Free text dosage instructions can be used for cases where the instructions are too complex to code. When coded instructions are present, the free text instructions may still be present for display to humans taking or administering the medication.
Property text As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "text");

/// Additional instructions such as"Swallow with plenty of water" which may or may not be coded.
Property additionalInstructions As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "additionalInstructions");

/// The timing schedule for giving the medication to the patient.  The Schedule data type allows many different expressions.  For example,"Every  8 hours";"Three times a day";"1/2 an hour before breakfast for 10 days from 23-Dec 2011:";"15 Oct 2013, 17 Oct 2013 and 1 Nov 2013".
Property timing As HS.FHIR.vDSTU2.Model.Base.Timing(XMLNAME = "timing");

Property asNeededBoolean As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "asNeededBoolean");

Property asNeededCodeableConcept As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "asNeededCodeableConcept");

Property siteCodeableConcept As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "siteCodeableConcept");

Property siteReference As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "siteReference");

/// A code specifying the route or physiological path of administration of a therapeutic agent into or onto a subject.
Property route As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "route");

/// A coded value indicating the method by which the medication is intended to be or was introduced into or on the body.
Property method As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "method");

Property doseRange As HS.FHIR.vDSTU2.Model.Base.Range(XMLNAME = "doseRange");

Property doseQuantity As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "doseQuantity");

Property rateRatio As HS.FHIR.vDSTU2.Model.Base.Ratio(XMLNAME = "rateRatio");

Property rateRange As HS.FHIR.vDSTU2.Model.Base.Range(XMLNAME = "rateRange");

/// The maximum total quantity of a therapeutic substance that may be administered to a subject over the period of time,  e.g. 1000mg in 24 hours.
Property maxDosePerPeriod As HS.FHIR.vDSTU2.Model.Base.Ratio(XMLNAME = "maxDosePerPeriod");

/// Set method for the "text" property.
Method SetText(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "additionalInstructions" property.
Method SetAdditionalInstructions(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..additionalInstructions = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "asNeededBoolean" property.
Method SetAsNeededBoolean(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..asNeededBoolean = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "asNeededCodeableConcept" property.
Method SetAsNeededCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..asNeededCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "siteCodeableConcept" property.
Method SetSiteCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..siteCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "siteReference" property.
Method SetSiteReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..siteReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "route" property.
Method SetRoute(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..route = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "method" property.
Method SetMethod(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..method = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
