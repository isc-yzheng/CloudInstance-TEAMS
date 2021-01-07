/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Resource.ImagingObjectSelection.Frames when working with FHIR DSTU2.
Class HS.FHIR.Model.Resource.ImagingObjectSelection.Frames Extends HS.FHIR.Model.Base.BackboneElement [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ImagingObjectSelection.Frames";

///  
Parameter XMLSEQUENCE = 1;

///  
Parameter XMLTYPE = "ImagingObjectSelection.Frames";

///  
Property frameNumbers As list Of HS.FHIR.Model.Datatype.UnsignedInt(XMLNAME = "frameNumbers", XMLPROJECTION = "ELEMENT") [ Required ];

///  
Property url As HS.FHIR.Model.Datatype.Uri(XMLNAME = "url") [ Required ];

///  
Method SetFrameNumbers(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed") Quit
		Set tSC = ..frameNumbers.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
