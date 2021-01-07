Class HS.FHIR.vDSTU2.Model.Resource.Person Extends HS.FHIR.vDSTU2.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Person";

Parameter XMLSEQUENCE = 1;

/// Identifier for a person within a particular scope.
Property identifier As list Of HS.FHIR.vDSTU2.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// A name associated with the person.
Property name As list Of HS.FHIR.vDSTU2.Model.Base.HumanName(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// A contact detail for the person, e.g. a telephone number or an email address.
Property telecom As list Of HS.FHIR.vDSTU2.Model.Base.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Administrative Gender.
Property gender As HS.FHIR.vDSTU2.Model.Datatype.Code(XMLNAME = "gender");

/// The birth date for the person.
Property birthDate As HS.FHIR.vDSTU2.Model.Datatype.Date(XMLNAME = "birthDate");

/// One or more addresses for the person.
Property address As list Of HS.FHIR.vDSTU2.Model.Base.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// An image that can be displayed as a thumbnail of the person to enhance the identification of the individual.
Property photo As HS.FHIR.vDSTU2.Model.Base.Attachment(XMLNAME = "photo");

/// The organization that is the custodian of the person record.
Property managingOrganization As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "managingOrganization");

/// Whether this person's record is in active use.
Property active As HS.FHIR.vDSTU2.Model.Datatype.Boolean(XMLNAME = "active");

/// Link to a resource that concerns the same actual person.
Property link As list Of HS.FHIR.vDSTU2.Model.Resource.Person.Link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// Insert method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed") Quit
		Set tSC = ..identifier.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "name" property.
Method SetName(pLastName As %String = "", pFirstName As %String = "", pMiddleName As %String = "", pPrefix As %String = "", pSuffix As %String = "", pUse As %String = "", pText As %String = "", pStart As %String = "", pEnd As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.HumanName).%New(pLastName, pFirstName, pMiddleName, pPrefix, pSuffix, pUse, pText, pStart, pEnd, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR HumanName object failed") Quit
		Set tSC = ..name.Insert(tObj) Quit:$$$ISERR(tSC)
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.ContactPoint).%New(pValue, pSystem, pUse, pRank, pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ContactPoint object failed") Quit
		Set tSC = ..telecom.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "gender" property.
Method SetGender(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..gender = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "birthDate" property.
Method SetBirthDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed") Quit
		Set ..birthDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "photo" property.
Method SetPhoto(pContentType As %String = "", pLanguage As %String = "", pData As %String = "", pUrl As %String = "", pSize As %String = "", pHash As %String = "", pTitle As %String = "", pCreation As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Attachment).%New(pContentType, pLanguage, pData, pUrl, pSize, pHash, pTitle, pCreation, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Attachment object failed") Quit
		Set ..photo = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "managingOrganization" property.
Method SetManagingOrganization(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..managingOrganization = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "active" property.
Method SetActive(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..active = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
