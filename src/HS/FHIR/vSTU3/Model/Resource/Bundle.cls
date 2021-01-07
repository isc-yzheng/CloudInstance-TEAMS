/// A container for a collection of resources.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.Bundle Extends HS.FHIR.vSTU3.Model.Base.Resource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle";

Parameter XMLSEQUENCE = 1;

/// A persistent identifier for the batch that won't change as a batch is copied from server to server.
Property identifier As HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Indicates the purpose of this bundle - how it was intended to be used.
Property type As HS.FHIR.vSTU3.Model.Base.BundleType(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// If a set of search matches, this is the total number of matches for the search (as opposed to the number of results in this bundle).
Property total As HS.FHIR.vSTU3.Model.Datatype.UnsignedInt(XMLNAME = "total", XMLPROJECTION = "ELEMENT");

/// A series of links that provide context to this bundle.
Property link As list Of HS.FHIR.vSTU3.Model.Resource.Bundle.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// An entry in a bundle resource - will either contain a resource, or information about a resource (transactions and history only).
Property entry As list Of HS.FHIR.vSTU3.Model.Resource.Bundle.Entry(XMLNAME = "entry", XMLPROJECTION = "ELEMENT");

/// Digital Signature - base64 encoded. XML-DSIg or a JWT.
Property signature As HS.FHIR.vSTU3.Model.Base.Signature(XMLNAME = "signature", XMLPROJECTION = "ELEMENT");

/// Set method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..identifier = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.BundleType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR BundleType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "total" property.
Method SetTotal(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..total = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

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

/// Insert method for the "entry" property.
Method SetEntry(pResource As %RegisteredObject = "", pLinkRelation As %String = "", pLinkUrl As %String = "", pFullUrl As %String = "", pExtension As %RegisteredObject = "", pModifierExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle.Entry).%New(pResource, pLinkRelation, pLinkUrl, pFullUrl, pExtension, pModifierExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Entry object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..entry.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
