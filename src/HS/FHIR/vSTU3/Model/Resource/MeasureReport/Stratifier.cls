/// The MeasureReport resource contains the results of evaluating a measure.
Class HS.FHIR.vSTU3.Model.Resource.MeasureReport.Stratifier Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MeasureReport.Stratifier";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MeasureReport.Stratifier";

Parameter JSONTYPEFIELD;

/// The identifier of this stratifier, as defined in the measure definition.
Property identifier As HS.FHIR.vSTU3.Model.Base.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// This element contains the results for a single stratum within the stratifier. For example, when stratifying on administrative gender, there will be four strata, one for each possible gender value.
Property stratum As list Of HS.FHIR.vSTU3.Model.Resource.MeasureReport.Stratum(XMLNAME = "stratum", XMLPROJECTION = "ELEMENT");

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

}
