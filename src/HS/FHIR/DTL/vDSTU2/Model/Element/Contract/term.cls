/// Contract Term List.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Contract.term Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Contract Term identifier.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// Contract Term Issue Date Time.
Property issued As %String(MAXLEN = 1000000, XMLNAME = "issued", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Contract Term Effective Time.
Property applies As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "applies", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Term Type.
/// <p>
/// any FHIR2 code may be used; 
/// contract-term-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Term Subtype.
/// <p>
/// any FHIR2 code may be used; 
/// contract-term-subtype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subType As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "subType", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Subject of this Contract Term.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Term Action.
/// <p>
/// any FHIR2 code may be used; 
/// contract-action shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property action As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Term Action Reason.
/// <p>
/// any FHIR2 code may be used; 
/// v3-PurposeOfUse shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property actionReason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "actionReason", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Term Actor List.
Property actor As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.term.actor(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Human readable Contract term text.
Property text As %String(MAXLEN = 1000000, XMLNAME = "text", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Contract Term Valued Item.
Property valuedItem As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.term.valuedItem(XMLNAME = "valuedItem", XMLPROJECTION = "ELEMENT");

/// Contract:term
/// <p>
/// Nested Contract Term Group.
Property group As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.term(XMLNAME = "group", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.term";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.term";

}
