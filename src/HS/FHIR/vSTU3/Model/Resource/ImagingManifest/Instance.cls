/// A text description of the DICOM SOP instances selected in the ImagingManifest; or the reason for, or significance of, the selection.
Class HS.FHIR.vSTU3.Model.Resource.ImagingManifest.Instance Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingManifest.Instance";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingManifest.Instance";

Parameter JSONTYPEFIELD;

/// SOP class UID of the selected instance.
Property sopClass As HS.FHIR.vSTU3.Model.Datatype.Oid(XMLNAME = "sopClass", XMLPROJECTION = "ELEMENT") [ Required ];

/// SOP Instance UID of the selected instance.
Property uid As HS.FHIR.vSTU3.Model.Datatype.Oid(XMLNAME = "uid", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "sopClass" property.
Method SetSopClass(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed"_$Select(err="":"",1:" - "_err)) Quit
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
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Oid).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Oid object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..uid = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
