Class HS.FHIR.vDSTU2.Model.Resource.Medication.Batch Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.Batch";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.Batch";

/// The assigned lot number of a batch of the specified product.
Property lotNumber As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "lotNumber");

/// When this specific batch of product will expire.
Property expirationDate As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "expirationDate");

/// Set method for the "lotNumber" property.
Method SetLotNumber(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..expirationDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
