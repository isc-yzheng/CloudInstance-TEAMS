Class HS.FHIR.vDSTU2.Model.Resource.Order.When Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Order.When";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Order.When";

/// Code specifies when request should be done. The code may simply be a priority code.
Property code As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "code");

/// A formal schedule.
Property schedule As HS.FHIR.vDSTU2.Model.Base.Timing(XMLNAME = "schedule");

/// Set method for the "code" property.
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
