/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Substance.Ingredient when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Substance.Ingredient Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Substance.Ingredient";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Substance.Ingredient";

///  
Property quantity As HS.FHIR.Model.Base.Ratio(XMLNAME = "quantity");

///  
Property substance As HS.FHIR.Model.Base.Reference(XMLNAME = "substance") [ Required ];

///  
Method SetSubstance(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..substance = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
