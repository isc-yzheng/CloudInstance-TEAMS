/// Track delegation between agents.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Provenance.agent.relatedAgent Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Type of relationship between agents.
/// <p>
/// any FHIR2 code may be used; 
/// v3-RoleLinkType shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Reference to other agent in this resource by identifier.
Property target As %String(MAXLEN = 1000000, XMLNAME = "target", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance.agent.relatedAgent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance.agent.relatedAgent";

}
