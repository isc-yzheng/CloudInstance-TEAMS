Class HS.FHIR.vDSTU2.Model.Resource.TestScript.Test Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "TestScript.Test";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "TestScript.Test";

/// The name of this test used for tracking/logging purposes by test engines.
Property name As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "name");

/// A short description of the test used by test engines for tracking and reporting purposes.
Property description As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "description");

/// Capabilities that must exist and are assumed to function correctly on the FHIR server being tested.
Property metadata As HS.FHIR.vDSTU2.Model.Resource.TestScript.Metadata(XMLNAME = "metadata");

/// Action would contain either an operation or an assertion.
Property action As list Of HS.FHIR.vDSTU2.Model.Resource.TestScript.Action1(XMLNAME = "action", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
