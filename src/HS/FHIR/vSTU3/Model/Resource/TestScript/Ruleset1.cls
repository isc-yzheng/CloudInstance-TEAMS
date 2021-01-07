/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Ruleset1 Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Ruleset1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Ruleset1";

Parameter JSONTYPEFIELD;

/// The TestScript.ruleset id value this assert will evaluate.
Property rulesetId As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "rulesetId", XMLPROJECTION = "ELEMENT") [ Required ];

/// The referenced rule within the external ruleset template.
Property rule As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Rule3(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

/// Set method for the "rulesetId" property.
Method SetRulesetId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..rulesetId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
