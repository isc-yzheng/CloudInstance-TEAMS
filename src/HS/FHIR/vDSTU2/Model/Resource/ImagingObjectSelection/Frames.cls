Class HS.FHIR.vDSTU2.Model.Resource.ImagingObjectSelection.Frames Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection.Frames";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection.Frames";

/// The frame numbers in the frame set.
Property frameNumbers As list Of HS.FHIR.vDSTU2.Model.Datatype.UnsignedInt(XMLNAME = "frameNumbers", XMLPROJECTION = "ELEMENT") [ Required ];

/// WADO-RS URL to retrieve the DICOM frames.
Property url As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "url") [ Required ];

/// Insert method for the "frameNumbers" property.
Method SetFrameNumbers(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed") Quit
		Set tSC = ..frameNumbers.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "url" property.
Method SetUrl(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..url = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
