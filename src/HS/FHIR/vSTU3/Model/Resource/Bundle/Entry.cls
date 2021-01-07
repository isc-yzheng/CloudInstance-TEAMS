/// A container for a collection of resources.
Class HS.FHIR.vSTU3.Model.Resource.Bundle.Entry Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle.Entry";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle.Entry";

Parameter JSONTYPEFIELD;

/// A series of links that provide context to this entry.
Property link As list Of HS.FHIR.vSTU3.Model.Resource.Bundle.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// The Absolute URL for the resource.  The fullUrl SHALL not disagree with the id in the resource. The fullUrl is a version independent reference to the resource. The fullUrl element SHALL have a value except that: * fullUrl can be empty on a POST (although it does not need to when specifying a temporary id for reference in the bundle)* Results from operations might involve resources that are not identified.
Property fullUrl As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "fullUrl", XMLPROJECTION = "ELEMENT");

/// The Resources for the entry.
Property resource As HS.FHIR.vSTU3.Model.Base.ResourceContainer(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// Information about the search process that lead to the creation of this entry.
Property search As HS.FHIR.vSTU3.Model.Resource.Bundle.Search(XMLNAME = "search", XMLPROJECTION = "ELEMENT");

/// Additional information about how this entry should be processed as part of a transaction.
Property request As HS.FHIR.vSTU3.Model.Resource.Bundle.Request(XMLNAME = "request", XMLPROJECTION = "ELEMENT");

/// Additional information about how this entry should be processed as part of a transaction.
Property response As HS.FHIR.vSTU3.Model.Resource.Bundle.Response(XMLNAME = "response", XMLPROJECTION = "ELEMENT");

/// Insert method for the "link" property.
Method SetLink(pRelation As %String = "", pURL As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle.Link).%New(pRelation, pURL, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Link object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..link.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "fullUrl" property.
Method SetFullUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..fullUrl = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "resource" property.
Method SetResource(pResource As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ResourceContainer).%New(pResource)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceContainer object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..resource = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get new object, populated with specified data.
Method %OnNew(pResource As %RegisteredObject, pLinkRelation As %String, pLinkUrl As %String, pFullUrl As %String, pExtension As %RegisteredObject, pModifierExtension As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pResource)=0)&&($Data(pLinkRelation)=0)&&($Data(pLinkUrl)=0)&&($Data(pFullUrl)=0)&&($Data(pExtension)=0)&&($Data(pModifierExtension)=0) Quit
		If $IsObject($Get(pResource)) Set tSC = ..SetResource(pResource) Quit:$$$ISERR(tSC)
		If ($Get(pLinkRelation)'="")&&($Get(pLinkUrl)'="") Set tSC = ..SetLink(pLinkRelation, pLinkUrl) Quit:$$$ISERR(tSC)
		If $Get(pFullUrl)'="" Set tSC = ..SetFullUrl(pFullUrl) Quit:$$$ISERR(tSC)
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
		#; pModifierExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pModifierExtension)) {
			If (pModifierExtension.%Extends("%Collection.ListOfObj")=0)&&(pModifierExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..modifierExtension.Insert(pModifierExtension) Quit:$$$ISERR(tSC)
			} Else {
				Set ..modifierExtension = pModifierExtension
			}
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
