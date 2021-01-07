/// Contract.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Contract Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Contract identifier.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When this Contract was issued.
Property issued As %String(MAXLEN = 1000000, XMLNAME = "issued", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Effective time.
Property applies As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "applies", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Subject of this Contract.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property subject As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Authority under which this Contract has standing.
/// <p>
/// Organization
Property authority As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "authority", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Domain in which this Contract applies.
/// <p>
/// Location
Property domain As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "domain", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Tyoe.
/// <p>
/// any FHIR2 code may be used; 
/// contract-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Subtype.
/// <p>
/// any FHIR2 code may be used; 
/// contract-subtype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subType As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "subType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Action.
/// <p>
/// any FHIR2 code may be used; 
/// contract-action shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property action As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Contract Action Reason.
/// <p>
/// any FHIR2 code may be used; 
/// v3-PurposeOfUse shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property actionReason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "actionReason", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Actor.
Property actor As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.actor(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Valued Item.
Property valuedItem As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.valuedItem(XMLNAME = "valuedItem", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Signer.
Property signer As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.signer(XMLNAME = "signer", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Term List.
Property term As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.term(XMLNAME = "term", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Binding Contract.
Property bindingAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "bindingAttachment", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Binding Contract.
/// <p>
/// Composition | DocumentReference | QuestionnaireResponse
Property bindingReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "bindingReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Friendly Language.
Property friendly As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.friendly(XMLNAME = "friendly", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Legal Language.
Property legal As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.legal(XMLNAME = "legal", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Computable Contract Language.
Property rule As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Contract.rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract";

}
