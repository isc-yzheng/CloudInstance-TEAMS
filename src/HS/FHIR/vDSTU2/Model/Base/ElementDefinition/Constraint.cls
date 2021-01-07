Class HS.FHIR.vDSTU2.Model.Base.ElementDefinition.Constraint Extends HS.FHIR.vDSTU2.Model.Base.Element [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ElementDefinition.Constraint";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ElementDefinition.Constraint";

/// Allows identification of which elements have their cardinalities impacted by the constraint.  Will not be referenced for constraints that do not affect cardinality.
Property key As HS.FHIR.vDSTU2.Model.Datatype.Id(XMLNAME = "key") [ Required ];

/// Description of why this constraint is necessary or appropriate.
Property requirements As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "requirements");

/// Identifies the impact constraint violation has on the conformance of the instance.
Property severity As HS.FHIR.vDSTU2.Model.Base.ConstraintSeverity(XMLNAME = "severity") [ Required ];

/// Text that can be used to describe the constraint in messages identifying that the constraint has been violated.
Property human As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "human") [ Required ];

/// An XPath expression of constraint that can be executed to see if this constraint is met.
Property xpath As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "xpath") [ Required ];

/// Set method for the "key" property.
Method SetKey(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed") Quit
		Set ..key = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "requirements" property.
Method SetRequirements(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..requirements = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "severity" property.
Method SetSeverity(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ConstraintSeverity).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ConstraintSeverity object failed") Quit
		Set ..severity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "human" property.
Method SetHuman(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..human = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "xpath" property.
Method SetXpath(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..xpath = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
