/// A formally or informally recognized grouping of people or organizations formed for the purpose of achieving some form of collective action.  Includes companies, institutions, corporations, departments, community groups, healthcare practice groups, etc.
Class HS.FHIR.vSTU3.Model.Resource.Organization.Contact Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Organization.Contact";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Organization.Contact";

Parameter JSONTYPEFIELD;

/// Indicates a purpose for which the contact can be reached.
Property purpose As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "purpose", XMLPROJECTION = "ELEMENT");

/// A name associated with the contact.
Property name As HS.FHIR.vSTU3.Model.Base.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// A contact detail (e.g. a telephone number or an email address) by which the party may be contacted.
Property telecom As list Of HS.FHIR.vSTU3.Model.Base.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Visiting or postal addresses for the contact.
Property address As HS.FHIR.vSTU3.Model.Base.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// Set method for the "purpose" property.
Method SetPurpose(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..purpose = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "name" property.
Method SetName(pLastName As %String = "", pFirstName As %String = "", pMiddleName As %String = "", pPrefix As %String = "", pSuffix As %String = "", pUse As %String = "", pText As %String = "", pStart As %String = "", pEnd As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.HumanName).%New(pLastName, pFirstName, pMiddleName, pPrefix, pSuffix, pUse, pText, pStart, pEnd, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR HumanName object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "telecom" property.
Method SetTelecom(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pRank As %String = "", pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ContactPoint).%New(pValue, pSystem, pUse, pRank, pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ContactPoint object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..telecom.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
