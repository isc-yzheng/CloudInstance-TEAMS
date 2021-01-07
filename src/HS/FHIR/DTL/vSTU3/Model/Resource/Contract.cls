/// A formal agreement between parties regarding the conduct of business, 
/// exchange of information or other matters.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Contract Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Contract number.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// amended | appended | cancelled | disputed | entered-in-error | executable | executed | negotiable | offered | policy | rejected | renewed | revoked | resolved | terminated
/// <p>
/// contract-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend contract-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When this Contract was issued.
Property issued As %String(MAXLEN = 1000000, XMLNAME = "issued", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Effective time.
Property applies As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "applies", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Contract Target Entity.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property subject As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Context of the Contract.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property topic As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "topic", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Authority under which this Contract has standing.
/// <p>
/// Organization
Property authority As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "authority", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Domain in which this Contract applies.
/// <p>
/// Location
Property domain As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "domain", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Type or form.
/// <p>
/// any FHIR3 code may be used; 
/// contract-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Subtype within the context of type.
/// <p>
/// any FHIR3 code may be used; 
/// contract-subtype shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property subType As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "subType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Action stipulated by this Contract.
/// <p>
/// any FHIR3 code may be used; 
/// contract-action shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property action As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Rationale for the stiplulated action.
/// <p>
/// any FHIR3 code may be used; 
/// v3-ActReason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property actionReason As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "actionReason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Decision by Grantor.
/// <p>
/// v3-ActCode is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v3-ActCode, 
/// you may formally EXTEND v3-ActCode to add codes to it.
Property decisionType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "decisionType", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Content derived from the basal information.
/// <p>
/// any FHIR3 code may be used; 
/// contract-content-derivative shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property contentDerivative As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "contentDerivative", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Security Labels that define affected resources.
/// <p>
/// security-labels is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-labels, 
/// you may formally EXTEND security-labels to add codes to it.
Property securityLabel As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "securityLabel", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Entity being ascribed responsibility.
Property agent As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Signatory.
Property signer As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.signer(XMLNAME = "signer", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Valued Item List.
Property valuedItem As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.valuedItem(XMLNAME = "valuedItem", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Term List.
Property term As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.term(XMLNAME = "term", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
///  Binding Contract.
Property bindingAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "bindingAttachment", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
///  Binding Contract.
/// <p>
/// Composition | DocumentReference | QuestionnaireResponse
Property bindingReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "bindingReference", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Friendly Language.
Property friendly As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.friendly(XMLNAME = "friendly", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Contract Legal Language.
Property legal As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.legal(XMLNAME = "legal", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Computable Contract Language.
Property rule As list Of HS.FHIR.DTL.vSTU3.Model.Element.Contract.rule(XMLNAME = "rule", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract";

}
