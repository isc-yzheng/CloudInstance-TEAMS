/// A list of Languages which may be used to communicate with the patient about his or her health.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Patient.communication Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// The language which can be used to communicate with the patient about his or her health.
/// <p>
/// Language RFC 5646 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property language As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "language", XMLPROJECTION = "ELEMENT") [ Required ];

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
