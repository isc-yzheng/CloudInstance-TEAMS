/// Treatment and processing step details.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Specimen.treatment Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Textual description of procedure.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Indicates the treatment or processing step  applied to the specimen.
/// <p>
/// any FHIR2 code may be used; 
/// specimen-treatment-procedure shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property procedure As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "procedure", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Material used in the processing step.
/// <p>
/// Substance
Property additive As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "additive", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Specimen.treatment";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Specimen.treatment";

}
