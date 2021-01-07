/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Bundle.Response when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Bundle.Response Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Bundle.Response";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Bundle.Response";

///  
Property status As HS.FHIR.Model.Datatype.String(XMLNAME = "status") [ Required ];

///  
Property location As HS.FHIR.Model.Datatype.Uri(XMLNAME = "location");

///  
Property etag As HS.FHIR.Model.Datatype.String(XMLNAME = "etag");

///  
Property lastModified As HS.FHIR.Model.Datatype.Instant(XMLNAME = "lastModified");

///  
Method SetStatus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..status = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetLocation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..location = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetEtag(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..etag = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetLastModified(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed") Quit
		Set ..lastModified = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
