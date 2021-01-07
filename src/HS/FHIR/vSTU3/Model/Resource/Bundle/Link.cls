/// A container for a collection of resources.
Class HS.FHIR.vSTU3.Model.Resource.Bundle.Link Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.Link";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.Link";

Parameter JSONTYPEFIELD;

/// A name which details the functional use for this link - see [http://www.iana.org/assignments/link-relations/link-relations.xhtml#link-relations-1](http://www.iana.org/assignments/link-relations/link-relations.xhtml#link-relations-1).
Property relation As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "relation", XMLPROJECTION = "ELEMENT") [ Required ];

/// The reference details for the link.
Property url As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "url", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "relation" property.
Method SetRelation(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..relation = tObj
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

/// Get new object, populated with specified data.
Method %OnNew(pRelation As %String, pUrl As %String, pExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pRelation)=0)&&($Data(pUrl)=0)&&($Data(pExtension)=0) Quit
		If $Get(pRelation)'="" Set tSC = ..SetRelation(pRelation) Quit:$$$ISERR(tSC)
		If $Get(pUrl)'="" Set tSC = ..SetUrl(pUrl) Quit:$$$ISERR(tSC)
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
