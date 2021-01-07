/// A Capability Statement documents a set of capabilities (behaviors) of a FHIR Server that may be used as a statement of actual server functionality or a statement of required or desired server implementation.
Class HS.FHIR.vSTU3.Model.Resource.CapabilityStatement.Certificate Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "CapabilityStatement.Certificate";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "CapabilityStatement.Certificate";

Parameter JSONTYPEFIELD;

/// Mime type for a certificate.
Property type As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Actual certificate.
Property blob As HS.FHIR.vSTU3.Model.Datatype.Base64Binary(XMLNAME = "blob", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "blob" property.
Method SetBlob(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Base64Binary).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Base64Binary object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..blob = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
