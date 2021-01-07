Class HS.FHIR.vDSTU2.Model.Resource.ImagingObjectSelection.Instance Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection.Instance";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection.Instance";

/// SOP class UID of the selected instance.
Property sopClass As HS.FHIR.vDSTU2.Model.Datatype.Oid(XMLNAME = "sopClass") [ Required ];

/// SOP Instance UID of the selected instance.
Property uid As HS.FHIR.vDSTU2.Model.Datatype.Oid(XMLNAME = "uid") [ Required ];

/// WADO-RS URL to retrieve the DICOM SOP Instance.
Property url As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "url") [ Required ];

/// Identity and location information of the frames in the selected instance.
Property frames As list Of HS.FHIR.vDSTU2.Model.Resource.ImagingObjectSelection.Frames(XMLNAME = "frames", XMLPROJECTION = "ELEMENT");

/// Set method for the "sopClass" property.
Method SetSopClass(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed") Quit
		Set ..sopClass = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

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

}
