/// Collection details.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Specimen.collection Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Who collected the specimen.
/// <p>
/// Practitioner
Property collector As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "collector", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Collector comments.
Property comment As list Of %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Collection time.
Property collectedDateTime As %String(MAXLEN = 1000000, XMLNAME = "collectedDateTime", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Collection time.
Property collectedPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "collectedPeriod", XMLPROJECTION = "ELEMENT");

/// SimpleQuantity
/// <p>
/// The quantity of specimen collected.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Technique used to perform collection.
/// <p>
/// any FHIR2 code may be used; 
/// specimen-collection-method shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property method As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Anatomical collection site.
/// <p>
/// any FHIR2 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Specimen.collection";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Specimen.collection";

}
