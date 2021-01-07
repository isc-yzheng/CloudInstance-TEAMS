Class HS.FHIR.vDSTU2.Model.Resource.Claim Extends HS.FHIR.vDSTU2.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim";

Parameter XMLSEQUENCE = 1;

/// The category of claim this is.
Property type As HS.FHIR.vDSTU2.Model.Base.ClaimType(XMLNAME = "type") [ Required ];

/// The business identifier for the instance: invoice number, claim number, pre-determination or pre-authorization number.
Property identifier As list Of HS.FHIR.vDSTU2.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// The version of the specification on which this instance relies.
Property ruleset As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "ruleset");

/// The version of the specification from which the original instance was created.
Property originalRuleset As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "originalRuleset");

/// The date when the enclosed suite of services were performed or completed.
Property created As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "created");

/// Insurer Identifier, typical BIN number (6 digit).
Property target As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "target");

/// The provider which is responsible for the bill, claim pre-determination, pre-authorization.
Property provider As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "provider");

/// The organization which is responsible for the bill, claim pre-determination, pre-authorization.
Property organization As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "organization");

/// Complete (Bill or Claim), Proposed (Pre-Authorization), Exploratory (Pre-determination).
Property use As HS.FHIR.vDSTU2.Model.Base.Use(XMLNAME = "use");

/// Immediate (STAT), best effort (NORMAL), deferred (DEFER).
Property priority As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "priority");

/// In the case of a Pre-Determination/Pre-Authorization the provider may request that funds in the amount of the expected Benefit be reserved ('Patient' or 'Provider') to pay for the Benefits determined on the subsequent claim(s). 'None' explicitly indicates no funds reserving is requested.
Property fundsReserve As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "fundsReserve");

/// Person who created the invoice/claim/pre-determination or pre-authorization.
Property enterer As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "enterer");

/// Facility where the services were provided.
Property facility As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "facility");

/// Prescription to support the dispensing of Pharmacy or Vision products.
Property prescription As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "prescription");

/// Original prescription to support the dispensing of pharmacy services, medications or products.
Property originalPrescription As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "originalPrescription");

/// The party to be reimbursed for the services.
Property payee As HS.FHIR.vDSTU2.Model.Resource.Claim.Payee(XMLNAME = "payee");

/// The referral resource which lists the date, practitioner, reason and other supporting information.
Property referral As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "referral");

/// Ordered list of patient diagnosis for which care is sought.
Property diagnosis As list Of HS.FHIR.vDSTU2.Model.Resource.Claim.Diagnosis(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT");

/// List of patient conditions for which care is sought.
Property condition As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// Patient Resource.
Property patient As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "patient") [ Required ];

/// Financial instrument by which payment information for health care.
Property coverage As list Of HS.FHIR.vDSTU2.Model.Resource.Claim.Coverage(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

/// Factors which may influence the applicability of coverage.
Property exception As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "exception", XMLPROJECTION = "ELEMENT") [ SqlFieldName = _exception ];

/// Name of school for over-aged dependents.
Property school As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "school");

/// Date of an accident which these services are addressing.
Property accident As HS.FHIR.vDSTU2.Model.Datatype.Date(XMLNAME = "accident");

/// Type of accident: work, auto, etc.
Property accidentType As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "accidentType");

/// A list of intervention and exception codes which may influence the adjudication of the claim.
Property interventionException As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "interventionException", XMLPROJECTION = "ELEMENT");

/// First tier of goods and services.
Property item As list Of HS.FHIR.vDSTU2.Model.Resource.Claim.Item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// Code to indicate that Xrays, images, emails, documents, models or attachments are being sent in support of this submission.
Property additionalMaterials As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "additionalMaterials", XMLPROJECTION = "ELEMENT");

/// A list of teeth which would be expected but are not found due to having been previously  extracted or for other reasons.
Property missingTeeth As list Of HS.FHIR.vDSTU2.Model.Resource.Claim.MissingTeeth(XMLNAME = "missingTeeth", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ClaimType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ClaimType object failed") Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed") Quit
		Set tSC = ..identifier.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "ruleset" property.
Method SetRuleset(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..ruleset = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "originalRuleset" property.
Method SetOriginalRuleset(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..originalRuleset = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "created" property.
Method SetCreated(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..created = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "target" property.
Method SetTarget(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..target = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "provider" property.
Method SetProvider(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..provider = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "organization" property.
Method SetOrganization(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..organization = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "use" property.
Method SetUse(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Use).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Use object failed") Quit
		Set ..use = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "priority" property.
Method SetPriority(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..priority = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "fundsReserve" property.
Method SetFundsReserve(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..fundsReserve = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "enterer" property.
Method SetEnterer(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..enterer = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "facility" property.
Method SetFacility(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..facility = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "prescription" property.
Method SetPrescription(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..prescription = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "originalPrescription" property.
Method SetOriginalPrescription(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..originalPrescription = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "referral" property.
Method SetReferral(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..referral = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "condition" property.
Method SetCondition(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..condition.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "patient" property.
Method SetPatient(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..patient = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "exception" property.
Method SetException(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..exception.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "school" property.
Method SetSchool(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..school = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "accident" property.
Method SetAccident(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed") Quit
		Set ..accident = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "accidentType" property.
Method SetAccidentType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..accidentType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "interventionException" property.
Method SetInterventionException(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..interventionException.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "additionalMaterials" property.
Method SetAdditionalMaterials(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..additionalMaterials.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
