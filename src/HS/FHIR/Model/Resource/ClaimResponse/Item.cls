/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ClaimResponse.Item when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ClaimResponse.Item Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ClaimResponse.Item";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ClaimResponse.Item";

///  
Property sequenceLinkId As HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "sequenceLinkId") [ Required ];

///  
Property noteNumber As list Of HS.FHIR.Model.Datatype.PositiveInt(XMLNAME = "noteNumber", XMLPROJECTION = "ELEMENT");

///  
Property adjudication As list Of HS.FHIR.Model.Resource.ClaimResponse.Adjudication(XMLNAME = "adjudication", XMLPROJECTION = "ELEMENT");

///  
Property detail As list Of HS.FHIR.Model.Resource.ClaimResponse.Detail(XMLNAME = "detail", XMLPROJECTION = "ELEMENT");

///  
Method SetSequenceLinkId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set ..sequenceLinkId = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetNoteNumber(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.PositiveInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR PositiveInt object failed") Quit
		Set tSC = ..noteNumber.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
