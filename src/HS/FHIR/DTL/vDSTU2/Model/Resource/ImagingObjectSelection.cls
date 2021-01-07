/// Key Object Selection.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.ImagingObjectSelection Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// oid
/// <p>
/// Instance UID.
Property uid As %String(MAXLEN = 1000000, XMLNAME = "uid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Patient of the selected objects.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Reason for selection.
/// <p>
/// kos-title is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend kos-title and you may NOT use codes from other ValueSets.
Property title As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "title", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Description text.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Author (human or machine)
/// <p>
/// Practitioner | Device | Organization | Patient | RelatedPerson
Property author As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Authoring time of the selection.
Property authoringTime As %String(MAXLEN = 1000000, XMLNAME = "authoringTime", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Study identity of the selected instances.
Property study As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ImagingObjectSelection.study(XMLNAME = "study", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImagingObjectSelection";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImagingObjectSelection";

}
