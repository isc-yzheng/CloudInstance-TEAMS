/// A text description of the DICOM SOP instances selected in the ImagingManifest; or the reason for, or significance of, the selection.
Class HS.FHIR.vSTU3.Model.Resource.ImagingManifest.Series Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingManifest.Series";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingManifest.Series";

Parameter JSONTYPEFIELD;

/// Series instance UID of the SOP instances in the selection.
Property uid As HS.FHIR.vSTU3.Model.Datatype.Oid(XMLNAME = "uid", XMLPROJECTION = "ELEMENT") [ Required ];

/// The network service providing access (e.g., query, view, or retrieval) for this series. See implementation notes for information about using DICOM endpoints. A series-level endpoint, if present, has precedence over a study-level endpoint with the same Endpoint.type.
Property endpoint As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "endpoint", XMLPROJECTION = "ELEMENT");

/// Identity and locating information of the selected DICOM SOP instances.
Property instance As list Of HS.FHIR.vSTU3.Model.Resource.ImagingManifest.Instance(XMLNAME = "instance", XMLPROJECTION = "ELEMENT");

/// Set method for the "uid" property.
Method SetUid(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..uid = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "endpoint" property.
Method SetEndpoint(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..endpoint.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
