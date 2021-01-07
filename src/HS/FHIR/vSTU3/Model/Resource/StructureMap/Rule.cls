/// A Map of relationships between 2 structures that can be used to transform data.
Class HS.FHIR.vSTU3.Model.Resource.StructureMap.Rule Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureMap.Rule";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureMap.Rule";

Parameter JSONTYPEFIELD;

/// Name of the rule for internal references.
Property name As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "name", XMLPROJECTION = "ELEMENT") [ Required ];

/// Source inputs to the mapping.
Property source As list Of HS.FHIR.vSTU3.Model.Resource.StructureMap.Source(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// Content to create because of this mapping rule.
Property target As list Of HS.FHIR.vSTU3.Model.Resource.StructureMap.Target(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// Rules contained in this rule.
Property rule As list Of HS.FHIR.vSTU3.Model.Resource.StructureMap.Rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

/// Which other rules to apply in the context of this rule.
Property dependent As list Of HS.FHIR.vSTU3.Model.Resource.StructureMap.Dependent(XMLNAME = "dependent", XMLPROJECTION = "ELEMENT");

/// Documentation for this instance of data.
Property documentation As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "documentation" property.
Method SetDocumentation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..documentation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
