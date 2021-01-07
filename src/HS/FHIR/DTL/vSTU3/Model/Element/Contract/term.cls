/// Contract Term List.
Class HS.FHIR.DTL.vSTU3.Model.Element.Contract.term Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Contract Term Number.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Contract Term Issue Date Time.
Property issued As %String(MAXLEN = 1000000, XMLNAME = "issued", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Contract Term Effective Time.
Property applies As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "applies", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Term Type or Form.
/// <p>
/// any FHIR3 code may be used; 
/// contract-term-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Term Type specific classification.
/// <p>
/// any FHIR3 code may be used; 
/// contract-term-subtype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "subType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Context of the Contract term.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property topic As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "topic", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Term Activity.
/// <p>
/// any FHIR3 code may be used; 
/// contract-action shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property action As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Purpose for the Contract Term Action.
/// <p>
/// any FHIR3 code may be used; 
/// v3-ActReason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property actionReason As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "actionReason", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Security Labels that define affected terms.
/// <p>
/// security-labels is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property securityLabel As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "securityLabel", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Term Agent List.
Property agent As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.term.agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human readable Contract term text.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contract Term Valued Item List.
Property valuedItem As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.term.valuedItem(XMLNAME = "valuedItem", XMLPROJECTION = "ELEMENT");

/// Contract:term
/// <p>
/// Nested Contract Term Group.
Property group As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.term(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.term";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.term";

}
