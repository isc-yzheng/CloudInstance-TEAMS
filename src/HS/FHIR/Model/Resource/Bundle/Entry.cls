/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Bundle.Entry when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Bundle.Entry Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Bundle.Entry";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Bundle.Entry";

///  
Property link As list Of HS.FHIR.Model.Resource.Bundle.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

///  
Property fullUrl As HS.FHIR.Model.Datatype.Uri(XMLNAME = "fullUrl");

///  
Property resource As HS.FHIR.Model.Base.ResourceContainer(XMLNAME = "resource");

///  
Property search As HS.FHIR.Model.Resource.Bundle.Search(XMLNAME = "search");

///  
Property request As HS.FHIR.Model.Resource.Bundle.Request(XMLNAME = "request");

///  
Property response As HS.FHIR.Model.Resource.Bundle.Response(XMLNAME = "response");

///  
Method SetLink(pRelation As %String = "", pURL As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Resource.Bundle.Link).%New(pRelation, pURL, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Link object failed") Quit
		Set tSC = ..link.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetFullUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..fullUrl = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetResource(pResource As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.ResourceContainer).%New(pResource)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceContainer object failed") Quit
		Set ..resource = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
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
			} Else {
				Set ..extension = pExtension
			}
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
