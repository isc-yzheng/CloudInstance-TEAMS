/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ConceptMap.Element when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ConceptMap.Element Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ConceptMap.Element";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ConceptMap.Element";

///  
Property codeSystem As HS.FHIR.Model.Datatype.Uri(XMLNAME = "codeSystem");

///  
Property code As HS.FHIR.Model.Datatype.Code(XMLNAME = "code");

///  
Property target As list Of HS.FHIR.Model.Resource.ConceptMap.Target(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

///  
Method SetCodeSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..codeSystem = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetCode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed") Quit
		Set ..code = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
