/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.TestScript.Capability when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.TestScript.Capability Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "TestScript.Capability";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "TestScript.Capability";

///  
Property required As HS.FHIR.Model.Datatype.Boolean(XMLNAME = "required");

///  
Property validated As HS.FHIR.Model.Datatype.Boolean(XMLNAME = "validated");

///  
Property description As HS.FHIR.Model.Datatype.String(XMLNAME = "description");

///  
Property destination As HS.FHIR.Model.Datatype.Integer(XMLNAME = "destination");

///  
Property link As list Of HS.FHIR.Model.Datatype.Uri(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

///  
Property conformance As HS.FHIR.Model.Base.Reference(XMLNAME = "conformance") [ Required ];

///  
Method SetRequired(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..required = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetValidated(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..validated = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetDestination(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..destination = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetLink(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set tSC = ..link.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetConformance(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..conformance = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
