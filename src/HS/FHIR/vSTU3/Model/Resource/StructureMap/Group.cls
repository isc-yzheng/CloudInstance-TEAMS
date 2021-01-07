/// A Map of relationships between 2 structures that can be used to transform data.
Class HS.FHIR.vSTU3.Model.Resource.StructureMap.Group Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureMap.Group";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureMap.Group";

Parameter JSONTYPEFIELD;

/// A unique name for the group for the convenience of human readers.
Property name As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "name", XMLPROJECTION = "ELEMENT") [ Required ];

/// Another group that this group adds rules to.
Property extends As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "extends", XMLPROJECTION = "ELEMENT");

/// If this is the default rule set to apply for thie source type, or this combination of types.
Property typeMode As HS.FHIR.vSTU3.Model.Base.StructureMapGroupTypeMode(XMLNAME = "typeMode", XMLPROJECTION = "ELEMENT") [ Required ];

/// Additional supporting documentation that explains the purpose of the group and the types of mappings within it.
Property documentation As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// A name assigned to an instance of data. The instance must be provided when the mapping is invoked.
Property input As list Of HS.FHIR.vSTU3.Model.Resource.StructureMap.Input(XMLNAME = "input", XMLPROJECTION = "ELEMENT");

/// Transform Rule from source to target.
Property rule As list Of HS.FHIR.vSTU3.Model.Resource.StructureMap.Rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "extends" property.
Method SetExtends(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..extends = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "typeMode" property.
Method SetTypeMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.StructureMapGroupTypeMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR StructureMapGroupTypeMode object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..typeMode = tObj
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
