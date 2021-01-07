/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Immunization.Reaction when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Immunization.Reaction Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Immunization.Reaction";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Immunization.Reaction";

///  
Property date As HS.FHIR.Model.Datatype.DateTime(XMLNAME = "date") [ SqlFieldName = _date ];

///  
Property detail As HS.FHIR.Model.Base.Reference(XMLNAME = "detail");

///  
Property reported As HS.FHIR.Model.Datatype.Boolean(XMLNAME = "reported");

///  
Method SetDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..date = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetDetail(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..detail = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetReported(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed") Quit
		Set ..reported = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
