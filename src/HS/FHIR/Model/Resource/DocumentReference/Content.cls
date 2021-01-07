/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.DocumentReference.Content when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.DocumentReference.Content Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "DocumentReference.Content";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "DocumentReference.Content";

///  
Property attachment As HS.FHIR.Model.Base.Attachment(XMLNAME = "attachment") [ Required ];

///  
Property format As list Of HS.FHIR.Model.Base.Coding(XMLNAME = "format", XMLPROJECTION = "ELEMENT");

///  
Method SetAttachment(pContentType As %String = "", pLanguage As %String = "", pData As %String = "", pUrl As %String = "", pSize As %String = "", pHash As %String = "", pTitle As %String = "", pCreation As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Attachment).%New(pContentType, pLanguage, pData, pUrl, pSize, pHash, pTitle, pCreation, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Attachment object failed") Quit
		Set ..attachment = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetFormat(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set tSC = ..format.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
