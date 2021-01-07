/// For referring to data content defined in other formats.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.Attachment Extends HS.FHIR.vSTU3.Model.Base.Element [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Attachment";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

/// Identifies the type of the data in the attachment and allows a method to be chosen to interpret or render the data. Includes mime type parameters such as charset where appropriate.
Property contentType As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "contentType", XMLPROJECTION = "ELEMENT");

/// The human language of the content. The value can be any valid value according to BCP 47.
Property language As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "language", XMLPROJECTION = "ELEMENT");

/// The actual data of the attachment - a sequence of bytes. In XML, represented using base64.
Property data As HS.FHIR.vSTU3.Model.Datatype.Base64Binary(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

/// An alternative location where the data can be accessed.
Property url As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "url", XMLPROJECTION = "ELEMENT");

/// The number of bytes of data that make up this attachment (before base64 encoding, if that is done).
Property size As HS.FHIR.vSTU3.Model.Datatype.UnsignedInt(XMLNAME = "size", XMLPROJECTION = "ELEMENT");

/// The calculated hash of the data using SHA-1. Represented using base64.
Property hash As HS.FHIR.vSTU3.Model.Datatype.Base64Binary(XMLNAME = "hash", XMLPROJECTION = "ELEMENT");

/// A label or set of text to display in place of the data.
Property title As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "title", XMLPROJECTION = "ELEMENT");

/// The date that the attachment was first created.
Property creation As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "creation", XMLPROJECTION = "ELEMENT");

/// Set method for the "contentType" property.
Method SetContentType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..contentType = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "language" property.
Method SetLanguage(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..language = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "data" property.
Method SetData(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Base64Binary).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Base64Binary object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..data = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "url" property.
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "size" property.
Method SetSize(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..size = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "hash" property.
Method SetHash(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Base64Binary).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Base64Binary object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..hash = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "title" property.
Method SetTitle(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..title = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "creation" property.
Method SetCreation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..creation = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
Method %OnNew(pContentType As %String, pLanguage As %String, pData As %String, pUrl As %String, pSize As %String, pHash As %String, pTitle As %String, pCreation As %String, pId As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pContentType)=0)&&($Data(pLanguage)=0)&&($Data(pData)=0)&&($Data(pUrl)=0)&&($Data(pSize)=0)&&($Data(pHash)=0)&&($Data(pTitle)=0)&&($Data(pCreation)=0)&&($Data(pId)=0)&&($Data(pExtension)=0) Quit
		If $Get(pContentType)'="" Set tSC = ..SetContentType(pContentType) Quit:$$$ISERR(tSC)
		If $Get(pLanguage)'="" Set tSC = ..SetLanguage(pLanguage) Quit:$$$ISERR(tSC)
		If $Get(pData)'="" Set tSC = ..SetData(pData) Quit:$$$ISERR(tSC)
		If $Get(pUrl)'="" Set tSC = ..SetUrl(pUrl) Quit:$$$ISERR(tSC)
		If $Get(pSize)'="" Set tSC = ..SetSize(pSize) Quit:$$$ISERR(tSC)
		If $Get(pHash)'="" Set tSC = ..SetHash(pHash) Quit:$$$ISERR(tSC)
		If $Get(pTitle)'="" Set tSC = ..SetTitle(pTitle) Quit:$$$ISERR(tSC)
		If $Get(pCreation)'="" Set tSC = ..SetCreation(pCreation) Quit:$$$ISERR(tSC)
		If $Get(pId)'="" Set ..id = pId Quit:$$$ISERR(tSC)
		#; pExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pExtension)) {
			If (pExtension.%Extends("%Collection.ListOfObj")=0)&&(pExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..extension.Insert(pExtension) Quit:$$$ISERR(tSC)
			} ElseIf pExtension.Count()>0 {
				For i = 1:1:pExtension.Count() {
					Set tSC = ..extension.Insert(pExtension.GetAt(i)) Quit:$$$ISERR(tSC)
				}
			}
			Quit:$$$ISERR(tSC)
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
