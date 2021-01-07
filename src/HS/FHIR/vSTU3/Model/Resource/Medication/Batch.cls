/// This resource is primarily used for the identification and definition of a medication. It covers the ingredients and the packaging for a medication.
Class HS.FHIR.vSTU3.Model.Resource.Medication.Batch Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Batch";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Batch";

Parameter JSONTYPEFIELD;

/// The assigned lot number of a batch of the specified product.
Property lotNumber As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "lotNumber", XMLPROJECTION = "ELEMENT");

/// When this specific batch of product will expire.
Property expirationDate As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "expirationDate", XMLPROJECTION = "ELEMENT");

/// Set method for the "lotNumber" property.
Method SetLotNumber(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..lotNumber = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "expirationDate" property.
Method SetExpirationDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..expirationDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
