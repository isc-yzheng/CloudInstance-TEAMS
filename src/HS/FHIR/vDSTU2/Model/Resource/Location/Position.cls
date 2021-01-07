Class HS.FHIR.vDSTU2.Model.Resource.Location.Position Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Location.Position";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Location.Position";

/// Longitude. The value domain and the interpretation are the same as for the text of the longitude element in KML (see notes below).
Property longitude As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "longitude") [ Required ];

/// Latitude. The value domain and the interpretation are the same as for the text of the latitude element in KML (see notes below).
Property latitude As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "latitude") [ Required ];

/// Altitude. The value domain and the interpretation are the same as for the text of the altitude element in KML (see notes below).
Property altitude As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "altitude");

/// Set method for the "longitude" property.
Method SetLongitude(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..altitude = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
