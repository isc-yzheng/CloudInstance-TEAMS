/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.CarePlan.Activity when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.CarePlan.Activity Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "CarePlan.Activity";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "CarePlan.Activity";

///  
Property actionResulting As list Of HS.FHIR.Model.Base.Reference(XMLNAME = "actionResulting", XMLPROJECTION = "ELEMENT");

///  
Property progress As list Of HS.FHIR.Model.Base.Annotation(XMLNAME = "progress", XMLPROJECTION = "ELEMENT");

///  
Property reference As HS.FHIR.Model.Base.Reference(XMLNAME = "reference");

///  
Property detail As HS.FHIR.Model.Resource.CarePlan.Detail(XMLNAME = "detail");

///  
Method SetActionResulting(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set tSC = ..actionResulting.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..reference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
