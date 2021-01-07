/// A list of Languages which may be used to communicate with the patient about his or her health.
Class HS.FHIR.DTL.vSTU3.Model.Element.Patient.communication Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The language which can be used to communicate with the patient about his or her health.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property language As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "language", XMLPROJECTION = "ELEMENT") [ Required ];

/// boolean
/// <p>
/// Language preference indicator.
Property preferred As %Boolean(XMLNAME = "preferred", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Patient.communication";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Patient.communication";

}
