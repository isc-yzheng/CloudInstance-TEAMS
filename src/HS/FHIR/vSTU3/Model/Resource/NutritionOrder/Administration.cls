/// A request to supply a diet, formula feeding (enteral) or oral nutritional supplement to a patient/resident.
Class HS.FHIR.vSTU3.Model.Resource.NutritionOrder.Administration Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "NutritionOrder.Administration";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "NutritionOrder.Administration";

Parameter JSONTYPEFIELD;

/// The time period and frequency at which the enteral formula should be delivered to the patient.
Property schedule As HS.FHIR.vSTU3.Model.Base.Timing(XMLNAME = "schedule", XMLPROJECTION = "ELEMENT");

/// The volume of formula to provide to the patient per the specified administration schedule.
Property quantity As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

Property rateQuantity As HS.FHIR.vSTU3.Model.Base.Quantity(XMLNAME = "rateQuantity", XMLPROJECTION = "ELEMENT");

Property rateRatio As HS.FHIR.vSTU3.Model.Base.Ratio(XMLNAME = "rateRatio", XMLPROJECTION = "ELEMENT");

/// Set method for the "quantity" property.
Method SetQuantity(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..quantity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "rateQuantity" property.
Method SetRateQuantity(pValue As %String = "", pComparator As %String = "", pUnit As %String = "", pSystem As %String = "", pCode As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Quantity).%New(pValue, pComparator, pUnit, pSystem, pCode, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Quantity object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..rateQuantity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
