/// A structured set of tests against a FHIR server implementation to determine compliance against the FHIR specification.
Class HS.FHIR.vSTU3.Model.Resource.TestScript.Rule1 Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Rule1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Rule1";

Parameter JSONTYPEFIELD;

/// Id of the referenced rule within the external ruleset template.
Property ruleId As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "ruleId", XMLPROJECTION = "ELEMENT") [ Required ];

/// Each rule template can take one or more parameters for rule evaluation.
Property param As list Of HS.FHIR.vSTU3.Model.Resource.TestScript.Param1(XMLNAME = "param", XMLPROJECTION = "ELEMENT");

/// Set method for the "ruleId" property.
Method SetRuleId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..ruleId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
