/// Actor involved.
Class HS.FHIR.DTL.vSTU3.Model.Element.Provenance.agent Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// What the agents role was.
/// <p>
/// security-role-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in security-role-type, 
/// you may formally EXTEND security-role-type to add codes to it.
Property role As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "role", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who participated.
/// <p>
/// Practitioner | RelatedPerson | Patient | Device | Organization
Property whoReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "whoReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Who participated.
Property whoUri As %String(MAXLEN = 1000000, XMLNAME = "whoUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who the agent is representing.
/// <p>
/// Practitioner | RelatedPerson | Patient | Device | Organization
Property onBehalfOfReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "onBehalfOfReference", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Who the agent is representing.
Property onBehalfOfUri As %String(MAXLEN = 1000000, XMLNAME = "onBehalfOfUri", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Type of relationship between agents.
/// <p>
/// any FHIR3 code may be used; 
/// v3-RoleLinkType shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property relatedAgentType As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "relatedAgentType", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance.agent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance.agent";

}
