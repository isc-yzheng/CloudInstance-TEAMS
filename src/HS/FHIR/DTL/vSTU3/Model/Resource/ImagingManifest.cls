/// A text description of the DICOM SOP instances selected in the ImagingManifest; 
/// or the reason for, 
/// or significance of, 
/// the selection.
Class HS.FHIR.DTL.vSTU3.Model.Resource.ImagingManifest Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// SOP Instance UID.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Patient of the selected objects.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// Time when the selection of instances was made.
Property authoringTime As %String(MAXLEN = 1000000, XMLNAME = "authoringTime", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Author (human or machine)
/// <p>
/// Practitioner | Device | Organization | Patient | RelatedPerson
Property author As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Description text.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Study identity of the selected instances.
Property study As list Of HS.FHIR.DTL.vSTU3.Model.Element.ImagingManifest.study(XMLNAME = "study", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingManifest";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingManifest";

}
