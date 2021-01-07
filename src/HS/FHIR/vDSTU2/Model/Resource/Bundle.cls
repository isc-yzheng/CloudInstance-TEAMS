Class HS.FHIR.vDSTU2.Model.Resource.Bundle Extends HS.FHIR.vDSTU2.Model.Base.Resource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle";

Parameter XMLSEQUENCE = 1;

/// Indicates the purpose of this bundle- how it was intended to be used.
Property type As HS.FHIR.vDSTU2.Model.Base.BundleType(XMLNAME = "type") [ Required ];

/// If a set of search matches, this is the total number of matches for the search (as opposed to the number of results in this bundle).
Property total As HS.FHIR.vDSTU2.Model.Datatype.UnsignedInt(XMLNAME = "total");

/// A series of links that provide context to this bundle.
Property link As list Of HS.FHIR.vDSTU2.Model.Resource.Bundle.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// An entry in a bundle resource - will either contain a resource, or information about a resource (transactions and history only).
Property entry As list Of HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry(XMLNAME = "entry", XMLPROJECTION = "ELEMENT");

/// Digital Signature - base64 encoded. XML DigSIg or a JWT.
Property signature As HS.FHIR.vDSTU2.Model.Base.Signature(XMLNAME = "signature");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.BundleType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR BundleType object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Link).%New(pRelation, pURL, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Link object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New(pResource, pLinkRelation, pLinkUrl, pFullUrl, pExtension, pModifierExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Entry object failed") Quit
		Set tSC = ..entry.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
