/// This resource provides eligibility and plan details from the processing of an Eligibility resource.
Class HS.FHIR.vSTU3.Model.Resource.EligibilityResponse.Insurance Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "EligibilityResponse.Insurance";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "EligibilityResponse.Insurance";

Parameter JSONTYPEFIELD;

/// A suite of updated or additional Coverages from the Insurer.
Property coverage As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "coverage", XMLPROJECTION = "ELEMENT");

/// The contract resource which may provide more detailed information.
Property contract As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "contract", XMLPROJECTION = "ELEMENT");

/// Benefits and optionally current balances by Category.
Property benefitBalance As list Of HS.FHIR.vSTU3.Model.Resource.EligibilityResponse.BenefitBalance(XMLNAME = "benefitBalance", XMLPROJECTION = "ELEMENT");

/// Set method for the "coverage" property.
Method SetCoverage(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..coverage = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "contract" property.
Method SetContract(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..contract = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
