/// An entity used in this activity.
Class HS.FHIR.DTL.vSTU3.Model.Element.Provenance.entity Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// derivation | revision | quotation | source | removal
/// <p>
/// provenance-entity-role is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend provenance-entity-role and you may NOT use codes from other ValueSets.
Property role As %String(MAXLEN = 1000000, XMLNAME = "role", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Identity of entity.
Property whatIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "whatIdentifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Identity of entity.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property whatReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "whatReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Identity of entity.
Property whatUri As %String(MAXLEN = 1000000, XMLNAME = "whatUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Provenance:agent
/// <p>
/// Entity is attributed to this agent.
Property agent As list Of HS.FHIR.DTL.vSTU3.Model.Element.Provenance.agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance.entity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance.entity";

}
