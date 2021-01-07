Class HS.FHIR.vDSTU2.Model.Resource.DocumentReference.Content Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentReference.Content";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentReference.Content";

/// The document or url of the document along with critical metadata to prove content has integrity.
Property attachment As HS.FHIR.vDSTU2.Model.Base.Attachment(XMLNAME = "attachment") [ Required ];

/// An identifier of the document encoding, structure, and template that the document conforms to beyond the base format indicated in the mimeType.
Property format As list Of HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "format", XMLPROJECTION = "ELEMENT");

/// Set method for the "attachment" property.
Method SetAttachment(pContentType As %String = "", pLanguage As %String = "", pData As %String = "", pUrl As %String = "", pSize As %String = "", pHash As %String = "", pTitle As %String = "", pCreation As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Attachment).%New(pContentType, pLanguage, pData, pUrl, pSize, pHash, pTitle, pCreation, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Attachment object failed") Quit
		Set ..attachment = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "format" property.
Method SetFormat(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..format.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
