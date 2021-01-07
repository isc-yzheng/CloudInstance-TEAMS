/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Claim.MissingTeeth when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Claim.MissingTeeth Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Claim.MissingTeeth";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Claim.MissingTeeth";

///  
Property tooth As HS.FHIR.Model.Base.Coding(XMLNAME = "tooth") [ Required ];

///  
Property reason As HS.FHIR.Model.Base.Coding(XMLNAME = "reason");

///  
Property extractionDate As HS.FHIR.Model.Datatype.Date(XMLNAME = "extractionDate");

///  
Method SetTooth(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..tooth = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetReason(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed") Quit
		Set ..reason = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetExtractionDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed") Quit
		Set ..extractionDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
