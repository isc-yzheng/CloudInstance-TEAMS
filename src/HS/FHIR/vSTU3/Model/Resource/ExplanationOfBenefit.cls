/// This resource provides: the claim details; adjudication details from the processing of a Claim; and optionally account balance information, for informing the subscriber of the benefits provided.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit Extends HS.FHIR.vSTU3.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExplanationOfBenefit";

Parameter XMLSEQUENCE = 1;

/// The EOB Business Identifier.
Property identifier As list Of HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// The status of the resource instance.
Property status As HS.FHIR.vSTU3.Model.Base.ExplanationOfBenefitStatus(XMLNAME = "status", XMLPROJECTION = "ELEMENT");

/// The category of claim, eg, oral, pharmacy, vision, insitutional, professional.
Property type As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// A finer grained suite of claim subtype codes which may convey Inpatient vs Outpatient and/or a specialty service. In the US the BillType.
Property subType As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "subType", XMLPROJECTION = "ELEMENT");

/// Patient Resource.
Property patient As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// The billable period for which charges are being submitted.
Property billablePeriod As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "billablePeriod", XMLPROJECTION = "ELEMENT");

/// The date when the EOB was created.
Property created As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "created", XMLPROJECTION = "ELEMENT");

/// The person who created the explanation of benefit.
Property enterer As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "enterer", XMLPROJECTION = "ELEMENT");

/// The insurer which is responsible for the explanation of benefit.
Property insurer As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "insurer", XMLPROJECTION = "ELEMENT");

/// The provider which is responsible for the claim.
Property provider As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "provider", XMLPROJECTION = "ELEMENT");

/// The provider which is responsible for the claim.
Property organization As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "organization", XMLPROJECTION = "ELEMENT");

/// The referral resource which lists the date, practitioner, reason and other supporting information.
Property referral As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "referral", XMLPROJECTION = "ELEMENT");

/// Facility where the services were provided.
Property facility As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "facility", XMLPROJECTION = "ELEMENT");

/// The business identifier for the instance: invoice number, claim number, pre-determination or pre-authorization number.
Property claim As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "claim", XMLPROJECTION = "ELEMENT");

/// The business identifier for the instance: invoice number, claim number, pre-determination or pre-authorization number.
Property claimResponse As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "claimResponse", XMLPROJECTION = "ELEMENT");

/// Processing outcome errror, partial or complete processing.
Property outcome As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// A description of the status of the adjudication.
Property disposition As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "disposition", XMLPROJECTION = "ELEMENT");

/// Other claims which are related to this claim such as prior claim versions or for related services.
Property related As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Related(XMLNAME = "related", XMLPROJECTION = "ELEMENT");

/// Prescription to support the dispensing of Pharmacy or Vision products.
Property prescription As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "prescription", XMLPROJECTION = "ELEMENT");

/// Original prescription which has been superceded by this prescription to support the dispensing of pharmacy services, medications or products. For example, a physician may prescribe a medication which the pharmacy determines is contraindicated, or for which the patient has an intolerance, and therefor issues a new precription for an alternate medication which has the same theraputic intent. The prescription from the pharmacy becomes the 'prescription' and that from the physician becomes the 'original prescription'.
Property originalPrescription As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "originalPrescription", XMLPROJECTION = "ELEMENT");

/// The party to be reimbursed for the services.
Property payee As HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Payee(XMLNAME = "payee", XMLPROJECTION = "ELEMENT");

/// Additional information codes regarding exceptions, special considerations, the condition, situation, prior or concurrent issues. Often there are mutiple jurisdiction specific valuesets which are required.
Property information As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Information(XMLNAME = "information", XMLPROJECTION = "ELEMENT");

/// The members of the team who provided the overall service as well as their role and whether responsible and qualifications.
Property careTeam As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.CareTeam(XMLNAME = "careTeam", XMLPROJECTION = "ELEMENT");

/// Ordered list of patient diagnosis for which care is sought.
Property diagnosis As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Diagnosis(XMLNAME = "diagnosis", XMLPROJECTION = "ELEMENT");

/// Ordered list of patient procedures performed to support the adjudication.
Property procedure As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Procedure(XMLNAME = "procedure", XMLPROJECTION = "ELEMENT");

/// Precedence (primary, secondary, etc.).
Property precedence As HS.FHIR.vSTU3.Model.Datatype.PositiveInt(XMLNAME = "precedence", XMLPROJECTION = "ELEMENT");

/// Financial instrument by which payment information for health care.
Property insurance As HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Insurance(XMLNAME = "insurance", XMLPROJECTION = "ELEMENT");

/// An accident which resulted in the need for healthcare services.
Property accident As HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Accident(XMLNAME = "accident", XMLPROJECTION = "ELEMENT");

/// The start and optional end dates of when the patient was precluded from working due to the treatable condition(s).
Property employmentImpacted As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "employmentImpacted", XMLPROJECTION = "ELEMENT");

/// The start and optional end dates of when the patient was confined to a treatment center.
Property hospitalization As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "hospitalization", XMLPROJECTION = "ELEMENT");

/// First tier of goods and services.
Property item As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// The first tier service adjudications for payor added services.
Property addItem As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.AddItem(XMLNAME = "addItem", XMLPROJECTION = "ELEMENT");

/// The total cost of the services reported.
Property totalCost As HS.FHIR.vSTU3.Model.Base.Money(XMLNAME = "totalCost", XMLPROJECTION = "ELEMENT");

/// The amount of deductable applied which was not allocated to any particular service line.
Property unallocDeductable As HS.FHIR.vSTU3.Model.Base.Money(XMLNAME = "unallocDeductable", XMLPROJECTION = "ELEMENT");

/// Total amount of benefit payable (Equal to sum of the Benefit amounts from all detail lines and additions less the Unallocated Deductable).
Property totalBenefit As HS.FHIR.vSTU3.Model.Base.Money(XMLNAME = "totalBenefit", XMLPROJECTION = "ELEMENT");

/// Payment details for the claim if the claim has been paid.
Property payment As HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.Payment(XMLNAME = "payment", XMLPROJECTION = "ELEMENT");

/// The form to be used for printing the content.
Property form As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "form", XMLPROJECTION = "ELEMENT");

/// Note text.
Property processNote As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.ProcessNote(XMLNAME = "processNote", XMLPROJECTION = "ELEMENT");

/// Balance by Benefit Category.
Property benefitBalance As list Of HS.FHIR.vSTU3.Model.Resource.ExplanationOfBenefit.BenefitBalance(XMLNAME = "benefitBalance", XMLPROJECTION = "ELEMENT");

/// Insert method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..identifier.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "status" property.
Method SetStatus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ExplanationOfBenefitStatus).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ExplanationOfBenefitStatus object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..status = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "subType" property.
Method SetSubType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..subType.Insert(tObj) Quit:$$$ISERR(tSC)
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..patient = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "billablePeriod" property.
Method SetBillablePeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..billablePeriod = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..created = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..enterer = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "insurer" property.
Method SetInsurer(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..insurer = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..organization = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..referral = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..facility = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "claim" property.
Method SetClaim(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..claim = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "claimResponse" property.
Method SetClaimResponse(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..claimResponse = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "outcome" property.
Method SetOutcome(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..outcome = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "disposition" property.
Method SetDisposition(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..disposition = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..originalPrescription = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "precedence" property.
Method SetPrecedence(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..precedence = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "employmentImpacted" property.
Method SetEmploymentImpacted(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..employmentImpacted = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "hospitalization" property.
Method SetHospitalization(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..hospitalization = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "form" property.
Method SetForm(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..form = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
