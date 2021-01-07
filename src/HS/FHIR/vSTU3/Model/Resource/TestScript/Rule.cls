/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Rule Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Rule";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Rule";

Parameter JSONTYPEFIELD;

/// Reference to the resource (containing the contents of the rule needed for assertions).
Property resource As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

/// Each rule template can take one or more parameters for rule evaluation.
Property param As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Param(XMLNAME = "param", XMLPROJECTION = "ELEMENT");

/// Set method for the "resource" property.
Method SetResource(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..resource = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
