/// What protocol was followed.
Class HS.FHIR.DTL.vSTU3.Model.Element.Immunization.vaccinationProtocol Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Dose number within series.
Property doseSequence As %Integer(XMLNAME = "doseSequence", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Details of vaccine protocol.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who is responsible for protocol.
/// <p>
/// Organization
Property authority As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "authority", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name of vaccine series.
Property series As %String(MAXLEN = 1000000, XMLNAME = "series", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Recommended number of doses for immunity.
Property seriesDoses As %Integer(XMLNAME = "seriesDoses", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Disease immunized against.
/// <p>
/// any FHIR3 code may be used; 
/// vaccination-protocol-dose-target shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property targetDisease As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "targetDisease", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Indicates if dose counts towards immunity.
/// <p>
/// any FHIR3 code may be used; 
/// vaccination-protocol-dose-status shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property doseStatus As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "doseStatus", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Why dose does (not) count.
/// <p>
/// any FHIR3 code may be used; 
/// vaccination-protocol-dose-status-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property doseStatusReason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "doseStatusReason", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Immunization.vaccinationProtocol";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Immunization.vaccinationProtocol";

}
