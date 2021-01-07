/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.Medication.Content when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.Medication.Content Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Medication.Content";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "Medication.Content";

///  
Property item As HS.FHIR.Model.Base.Reference(XMLNAME = "item") [ Required ];

///  
Property amount As HS.FHIR.Model.Base.SimpleQuantity(XMLNAME = "amount");

///  
Method SetItem(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..item = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
