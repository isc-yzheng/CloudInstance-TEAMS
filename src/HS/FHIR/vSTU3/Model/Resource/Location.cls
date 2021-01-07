/// Details and position information for a physical place where services are provided  and resources and participants may be stored, found, contained or accommodated.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.Location Extends HS.FHIR.vSTU3.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Location";

Parameter XMLSEQUENCE = 1;

/// Unique code or number identifying the location to its users.
Property identifier As list Of HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// The status property covers the general availability of the resource, not the current value which may be covered by the operationStatus, or by a schedule/slots if they are configured for the location.
Property status As HS.FHIR.vSTU3.Model.Base.LocationStatus(XMLNAME = "status", XMLPROJECTION = "ELEMENT");

/// The Operational status covers operation values most relevant to beds (but can also apply to rooms/units/chair/etc such as an isolation unit/dialisys chair). This typically covers concepts such as contamination, housekeeping and other activities like maintenance.
Property operationalStatus As HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "operationalStatus", XMLPROJECTION = "ELEMENT");

/// Name of the location as used by humans. Does not need to be unique.
Property name As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "name", XMLPROJECTION = "ELEMENT");

/// A list of alternate names that the location is known as, or was known as in the past.
Property alias As list Of HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "alias", XMLPROJECTION = "ELEMENT");

/// Description of the Location, which helps in finding or referencing the place.
Property description As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "description", XMLPROJECTION = "ELEMENT");

/// Indicates whether a resource instance represents a specific location or a class of locations.
Property mode As HS.FHIR.vSTU3.Model.Base.LocationMode(XMLNAME = "mode", XMLPROJECTION = "ELEMENT");

/// Indicates the type of function performed at the location.
Property type As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// The contact details of communication devices available at the location. This can include phone numbers, fax numbers, mobile numbers, email addresses and web sites.
Property telecom As list Of HS.FHIR.vSTU3.Model.Base.ContactPoint(XMLNAME = "telecom", XMLPROJECTION = "ELEMENT");

/// Physical location.
Property address As HS.FHIR.vSTU3.Model.Base.Address(XMLNAME = "address", XMLPROJECTION = "ELEMENT");

/// Physical form of the location, e.g. building, room, vehicle, road.
Property physicalType As HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "physicalType", XMLPROJECTION = "ELEMENT");

/// The absolute geographic location of the Location, expressed using the WGS84 datum (This is the same co-ordinate system used in KML).
Property position As HS.FHIR.vSTU3.Model.Resource.Location.Position(XMLNAME = "position", XMLPROJECTION = "ELEMENT");

/// The organization responsible for the provisioning and upkeep of the location.
Property managingOrganization As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "managingOrganization", XMLPROJECTION = "ELEMENT");

/// Another Location which this Location is physically part of.
Property partOf As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "partOf", XMLPROJECTION = "ELEMENT");

/// Technical endpoints providing access to services operated for the location.
Property endpoint As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// Insert method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pSystem As %String = "", pUse As %String = "", pTypeCode As %String = "", pTypeSystem As %String = "", pTypeDisplay As %String = "", pTypeText As %String = "", pId As %String = "", pStart As %String = "", pEnd As %String = "", pAssignerReference As %String = "", pAssignerDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Identifier).%New(pValue, pSystem, pUse, pTypeCode, pTypeSystem, pTypeDisplay, pTypeText, pId, pStart, pEnd, pAssignerReference, pAssignerDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Identifier object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..identifier.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "status" property.
Method SetStatus(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.LocationStatus).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR LocationStatus object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..status = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "operationalStatus" property.
Method SetOperationalStatus(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..operationalStatus = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "name" property.
Method SetName(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..name = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "alias" property.
Method SetAlias(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..alias.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.LocationMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR LocationMode object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..mode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "type" property.
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
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

/// Set method for the "physicalType" property.
Method SetPhysicalType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..physicalType = tObj
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..managingOrganization = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "partOf" property.
Method SetPartOf(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..partOf = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "endpoint" property.
Method SetEndpoint(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..endpoint.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
