/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.MedicationOrder.DosageInstruction when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.MedicationOrder.DosageInstruction Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "MedicationOrder.DosageInstruction";

///  
Parameter XMLSEQUENCE = 0;

///  
Parameter XMLTYPE = "MedicationOrder.DosageInstruction";

///  
Property text As HS.FHIR.Model.Datatype.String(XMLNAME = "text");

///  
Property additionalInstructions As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "additionalInstructions");

///  
Property timing As HS.FHIR.Model.Base.Timing(XMLNAME = "timing");

///  
Property asNeededBoolean As HS.FHIR.Model.Datatype.Boolean(XMLNAME = "asNeededBoolean");

///  
Property asNeededCodeableConcept As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "asNeededCodeableConcept");

///  
Property siteCodeableConcept As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "siteCodeableConcept");

///  
Property siteReference As HS.FHIR.Model.Base.Reference(XMLNAME = "siteReference");

///  
Property route As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "route");

///  
Property method As HS.FHIR.Model.Base.CodeableConcept(XMLNAME = "method");

///  
Property doseRange As HS.FHIR.Model.Base.Range(XMLNAME = "doseRange");

///  
Property doseQuantity As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "doseQuantity");

///  
Property rateRatio As HS.FHIR.Model.Base.Ratio(XMLNAME = "rateRatio");

///  
Property rateRange As HS.FHIR.Model.Base.Range(XMLNAME = "rateRange");

///  
Property maxDosePerPeriod As HS.FHIR.Model.Base.Ratio(XMLNAME = "maxDosePerPeriod");

///  
Method SetText(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetAdditionalInstructions(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..additionalInstructions = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetAsNeededBoolean(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..asNeededBoolean = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetAsNeededCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..asNeededCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetSiteCodeableConcept(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..siteCodeableConcept = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetSiteReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..siteReference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetRoute(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..route = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetMethod(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..method = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
