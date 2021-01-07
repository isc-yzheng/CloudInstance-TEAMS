/// Details and position information for a physical place where services are provided  and resources and participants may be stored, found, contained or accommodated.
Class HS.FHIR.vSTU3.Model.Resource.Location.Position Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Location.Position";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Location.Position";

Parameter JSONTYPEFIELD;

/// Longitude. The value domain and the interpretation are the same as for the text of the longitude element in KML (see notes below).
Property longitude As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "longitude", XMLPROJECTION = "ELEMENT") [ Required ];

/// Latitude. The value domain and the interpretation are the same as for the text of the latitude element in KML (see notes below).
Property latitude As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "latitude", XMLPROJECTION = "ELEMENT") [ Required ];

/// Altitude. The value domain and the interpretation are the same as for the text of the altitude element in KML (see notes below).
Property altitude As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "altitude", XMLPROJECTION = "ELEMENT");

/// Set method for the "longitude" property.
Method SetLongitude(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..longitude = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "latitude" property.
Method SetLatitude(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..latitude = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "altitude" property.
Method SetAltitude(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..altitude = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
