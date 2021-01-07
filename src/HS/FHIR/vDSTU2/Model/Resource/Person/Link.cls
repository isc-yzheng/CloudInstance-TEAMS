Class HS.FHIR.vDSTU2.Model.Resource.Person.Link Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Person.Link";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Person.Link";

/// The resource to which this actual person is associated.
Property target As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "target") [ Required ];

/// Level of assurance that this link is actually associated with the target resource.
Property assurance As HS.FHIR.vDSTU2.Model.Base.IdentityAssuranceLevel(XMLNAME = "assurance");

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

/// Set method for the "assurance" property.
Method SetAssurance(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.IdentityAssuranceLevel).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR IdentityAssuranceLevel object failed") Quit
		Set ..assurance = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
