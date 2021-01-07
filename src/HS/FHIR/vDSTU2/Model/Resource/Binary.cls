Class HS.FHIR.vDSTU2.Model.Resource.Binary Extends HS.FHIR.vDSTU2.Model.Base.Resource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Binary";

Parameter XMLSEQUENCE = 1;

/// MimeType of the binary content represented as a standard MimeType (BCP 13).
Property contentType As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "contentType") [ Required ];

/// The actual content, base64 encoded.
Property content As HS.FHIR.vDSTU2.Model.Datatype.Base64Binary(XMLNAME = "content") [ Required ];

/// Set method for the "contentType" property.
Method SetContentType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..contentType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "content" property.
Method SetContent(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Base64Binary).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Base64Binary object failed") Quit
		Set ..content = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
