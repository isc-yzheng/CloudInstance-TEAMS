/// Representation of the content produced in a DICOM imaging study. A study comprises a set of series, each of which includes a set of Service-Object Pair Instances (SOP Instances - images or other data) acquired or produced in a common context.  A series is of only one modality (e.g. X-ray, CT, MR, ultrasound), but a study may have multiple series of different modalities.
Class HS.FHIR.vSTU3.Model.Resource.ImagingStudy.Instance Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingStudy.Instance";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingStudy.Instance";

Parameter JSONTYPEFIELD;

/// Formal identifier for this image or other content.
Property uid As HS.FHIR.vSTU3.Model.Datatype.Oid(XMLNAME = "uid", XMLPROJECTION = "ELEMENT") [ Required ];

/// The number of instance in the series.
Property number As HS.FHIR.vSTU3.Model.Datatype.UnsignedInt(XMLNAME = "number", XMLPROJECTION = "ELEMENT");

/// DICOM instance  type.
Property sopClass As HS.FHIR.vSTU3.Model.Datatype.Oid(XMLNAME = "sopClass", XMLPROJECTION = "ELEMENT") [ Required ];

/// The description of the instance.
Property title As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "title", XMLPROJECTION = "ELEMENT");

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

/// Set method for the "number" property.
Method SetNumber(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.UnsignedInt).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR UnsignedInt object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..number = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

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

/// Set method for the "title" property.
Method SetTitle(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..title = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
