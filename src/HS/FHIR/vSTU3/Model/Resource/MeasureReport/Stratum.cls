/// The MeasureReport resource contains the results of evaluating a measure.
Class HS.FHIR.vSTU3.Model.Resource.MeasureReport.Stratum Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.Stratum";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.Stratum";

Parameter JSONTYPEFIELD;

/// The value for this stratum, expressed as a string. When defining stratifiers on complex values, the value must be rendered such that the value for each stratum within the stratifier is unique.
Property value As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "value", XMLPROJECTION = "ELEMENT") [ Required ];

/// The populations that make up the stratum, one for each type of population appropriate to the measure.
Property population As list Of HS.FHIR.vSTU3.Model.Resource.MeasureReport.Population1(XMLNAME = "population", XMLPROJECTION = "ELEMENT");

/// The measure score for this stratum, calculated as appropriate for the measure type and scoring method, and based on only the members of this stratum.
Property measureScore As HS.FHIR.vSTU3.Model.Datatype.Decimal(XMLNAME = "measureScore", XMLPROJECTION = "ELEMENT");

/// Set method for the "value" property.
Method SetValue(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..value = tObj
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
