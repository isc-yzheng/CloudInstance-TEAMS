/// Kind of specimen.
Class HS.FHIR.DTL.vR4.Model.Resource.SpecimenDefinition Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier of a kind of specimen.
Property identifier As HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Kind of material to collect.
/// <p>
/// any FHIR4 code may be used; 
/// v2-0487 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property typeCollected As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "typeCollected", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Patient preparation for collection.
/// <p>
/// any FHIR4 code may be used; 
/// prepare-patient-prior-specimen-collection shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property patientPreparation As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "patientPreparation", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Time aspect for collection.
Property timeAspect As %String(MAXLEN = 1000000, XMLNAME = "timeAspect", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Specimen collection procedure.
/// <p>
/// any FHIR4 code may be used; 
/// specimen-collection shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property collection As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "collection", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Specimen in container intended for testing by lab.
Property typeTested As list Of HS.FHIR.DTL.vR4.Model.Element.SpecimenDefinition.typeTested(XMLNAME = "typeTested", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SpecimenDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SpecimenDefinition";

}
