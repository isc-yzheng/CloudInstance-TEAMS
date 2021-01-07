Class HS.FHIR.vDSTU2.Model.Resource.ClaimResponse.Adjudication1 Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.Adjudication1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.Adjudication1";

/// Code indicating: Co-Pay, deductible, eligible, benefit, tax, etc.
Property code As HS.FHIR.vDSTU2.Model.Base.Coding(XMLNAME = "code") [ Required ];

/// Monetary amount associated with the code.
Property amount As HS.FHIR.vDSTU2.Model.Base.Money(XMLNAME = "amount");

/// A non-monetary value for example a percentage. Mutually exclusive to the amount element above.
Property value As HS.FHIR.vDSTU2.Model.Datatype.Decimal(XMLNAME = "value");

/// Set method for the "code" property.
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "value" property.
Method SetValue(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Decimal).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Decimal object failed") Quit
		Set ..value = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
