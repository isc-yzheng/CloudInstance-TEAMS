/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Conformance.Rest when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Conformance.Rest Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Conformance.Rest";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Conformance.Rest";

///  
Property mode As HS.FHIR.Model.Base.RestfulConformanceMode(XMLNAME = "mode") [ Required ];

///  
Property documentation As HS.FHIR.Model.Datatype.String(XMLNAME = "documentation");

///  
Property security As HS.FHIR.Model.Resource.Conformance.Security(XMLNAME = "security");

///  
Property resource As list Of HS.FHIR.Model.Resource.Conformance.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT") [ Required ];

///  
Property interaction As list Of HS.FHIR.Model.Resource.Conformance.Interaction1(XMLNAME = "interaction", XMLPROJECTION = "ELEMENT");

///  
Property transactionMode As HS.FHIR.Model.Base.TransactionMode(XMLNAME = "transactionMode");

///  
Property searchParam As list Of HS.FHIR.Model.Resource.Conformance.SearchParam(XMLNAME = "searchParam", XMLPROJECTION = "ELEMENT");

///  
Property operation As list Of HS.FHIR.Model.Resource.Conformance.Operation(XMLNAME = "operation", XMLPROJECTION = "ELEMENT");

///  
Property compartment As list Of HS.FHIR.Model.Datatype.Uri(XMLNAME = "compartment", XMLPROJECTION = "ELEMENT");

///  
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.RestfulConformanceMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR RestfulConformanceMode object failed") Quit
		Set ..mode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetDocumentation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..documentation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetTransactionMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.TransactionMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR TransactionMode object failed") Quit
		Set ..transactionMode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetCompartment(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set tSC = ..compartment.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
