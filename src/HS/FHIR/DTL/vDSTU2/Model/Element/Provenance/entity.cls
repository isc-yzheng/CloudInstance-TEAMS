/// An entity used in this activity.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Provenance.entity Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// derivation | revision | quotation | source
/// <p>
/// provenance-entity-role is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend provenance-entity-role and you may NOT use codes from other ValueSets.
Property role As %String(MAXLEN = 1000000, XMLNAME = "role", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Coding
/// <p>
/// The type of resource in this entity.
/// <p>
/// resource-types is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in resource-types, 
/// you may formally EXTEND resource-types to add codes to it.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Identity of entity.
Property reference As %String(MAXLEN = 1000000, XMLNAME = "reference", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Human description of entity.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// Provenance:agent
/// <p>
/// Entity is attributed to this agent.
Property agent As HS.FHIR.DTL.vDSTU2.Model.Element.Provenance.agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance.entity";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance.entity";

}
