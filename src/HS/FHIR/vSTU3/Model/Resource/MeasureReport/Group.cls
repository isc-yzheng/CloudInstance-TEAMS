/// The MeasureReport resource contains the results of evaluating a measure.
Class HS.FHIR.vSTU3.Model.Resource.MeasureReport.Group Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.Group";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.Group";

Parameter JSONTYPEFIELD;

/// The identifier of the population group as defined in the measure definition.
Property identifier As HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// The populations that make up the population group, one for each type of population appropriate for the measure.
Property population As list Of HS.FHIR.vSTU3.Model.Resource.MeasureReport.Population(XMLNAME = "population", XMLPROJECTION = "ELEMENT");

/// The measure score for this population group, calculated as appropriate for the measure type and scoring method, and based on the contents of the populations defined in the group.
Property measureScore As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "measureScore", XMLPROJECTION = "ELEMENT");

/// When a measure includes multiple stratifiers, there will be a stratifier group for each stratifier defined by the measure.
Property stratifier As list Of HS.FHIR.vSTU3.Model.Resource.MeasureReport.Stratifier(XMLNAME = "stratifier", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "measureScore" property.
Method SetMeasureScore(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..measureScore = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
