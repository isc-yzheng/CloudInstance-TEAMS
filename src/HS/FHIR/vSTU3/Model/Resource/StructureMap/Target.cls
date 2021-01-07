/// A Map of relationships between 2 structures that can be used to transform data.
Class HS.FHIR.vSTU3.Model.Resource.StructureMap.Target Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureMap.Target";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureMap.Target";

Parameter JSONTYPEFIELD;

/// Type or variable this rule applies to.
Property context As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "context", XMLPROJECTION = "ELEMENT");

/// How to interpret the context.
Property contextType As HS.FHIR.vSTU3.Model.Base.StructureMapContextType(XMLNAME = "contextType", XMLPROJECTION = "ELEMENT");

/// Field to create in the context.
Property element As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "element", XMLPROJECTION = "ELEMENT");

/// Named context for field, if desired, and a field is specified.
Property variable As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "variable", XMLPROJECTION = "ELEMENT");

/// If field is a list, how to manage the list.
Property listMode As list Of HS.FHIR.vSTU3.Model.Base.StructureMapTargetListMode(XMLNAME = "listMode", XMLPROJECTION = "ELEMENT");

/// Internal rule reference for shared list items.
Property listRuleId As HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "listRuleId", XMLPROJECTION = "ELEMENT");

/// How the data is copied / created.
Property transform As HS.FHIR.vSTU3.Model.Base.StructureMapTransform(XMLNAME = "transform", XMLPROJECTION = "ELEMENT");

/// Parameters to the transform.
Property parameter As list Of HS.FHIR.vSTU3.Model.Resource.StructureMap.Parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

/// Set method for the "context" property.
Method SetContext(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..context = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "contextType" property.
Method SetContextType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.StructureMapContextType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR StructureMapContextType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..contextType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "element" property.
Method SetElement(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..element = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "variable" property.
Method SetVariable(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..variable = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "listMode" property.
Method SetListMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.StructureMapTargetListMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR StructureMapTargetListMode object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..listMode.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "listRuleId" property.
Method SetListRuleId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..listRuleId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "transform" property.
Method SetTransform(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.StructureMapTransform).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR StructureMapTransform object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..transform = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
