/// Demographics and administrative information about a person independent of a specific health-related context.
Class HS.FHIR.vSTU3.Model.Resource.Person.Link Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Person.Link";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Person.Link";

Parameter JSONTYPEFIELD;

/// The resource to which this actual person is associated.
Property target As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT") [ Required ];

/// Level of assurance that this link is actually associated with the target resource.
Property assurance As HS.FHIR.vSTU3.Model.Base.IdentityAssuranceLevel(XMLNAME = "assurance", XMLPROJECTION = "ELEMENT");

/// Set method for the "target" property.
Method SetTarget(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..target = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "assurance" property.
Method SetAssurance(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.IdentityAssuranceLevel).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR IdentityAssuranceLevel object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..assurance = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
