Class HS.FHIR.vDSTU2.Model.Resource.ImagingObjectSelection.Study Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection.Study";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection.Study";

/// Study instance UID of the SOP instances in the selection.
Property uid As HS.FHIR.vDSTU2.Model.Datatype.Oid(XMLNAME = "uid") [ Required ];

/// WADO-RS URL to retrieve the study. Note that this URL retrieves all SOP instances of the study, not only those in the selection.
Property url As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "url");

/// Reference to the Imaging Study in FHIR form.
Property imagingStudy As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "imagingStudy");

/// Series identity and locating information of the DICOM SOP instances in the selection.
Property series As list Of HS.FHIR.vDSTU2.Model.Resource.ImagingObjectSelection.Series(XMLNAME = "series", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "uid" property.
Method SetUid(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed") Quit
		Set ..uid = tObj
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

/// Set method for the "imagingStudy" property.
Method SetImagingStudy(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..imagingStudy = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
