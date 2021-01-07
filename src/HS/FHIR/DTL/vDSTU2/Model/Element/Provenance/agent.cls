/// Agents involved in creating resource.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Provenance.agent Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// What the agents involvement was.
/// <p>
/// provenance-agent-role is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in provenance-agent-role, 
/// you may formally EXTEND provenance-agent-role to add codes to it.
Property role As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "role", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Individual, 
/// device or organization playing role.
/// <p>
/// Practitioner | RelatedPerson | Patient | Device | Organization
Property actor As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "actor", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Authorization-system identifier for the agent.
Property userId As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "userId", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Track delegation between agents.
Property relatedAgent As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Provenance.agent.relatedAgent(XMLNAME = "relatedAgent", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance.agent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance.agent";

}
