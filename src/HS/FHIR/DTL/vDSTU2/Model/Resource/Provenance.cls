/// Who, 
/// What, 
/// When for a set of resources.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Provenance Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Target Reference(s) (usually version specific)
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference
Property target As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// When the activity occurred.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// When the activity was recorded / updated.
Property recorded As %String(MAXLEN = 1000000, XMLNAME = "recorded", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Reason the activity is occurring.
/// <p>
/// v3-PurposeOfUse is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in v3-PurposeOfUse, 
/// you may formally EXTEND v3-PurposeOfUse to add codes to it.
Property reason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Activity that occurred.
/// <p>
/// v3-ProvenanceEventCurrentState is the REQUIRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in v3-ProvenanceEventCurrentState, 
/// you may formally EXTEND v3-ProvenanceEventCurrentState to add codes to it.
Property activity As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "activity", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the activity occurred, 
/// if relevant.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Policy or plan the activity was defined by.
Property policy As list Of %String(MAXLEN = 1000000, XMLNAME = "policy", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Agents involved in creating resource.
Property agent As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Provenance.agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// An entity used in this activity.
Property entity As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Provenance.entity(XMLNAME = "entity", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Signature on target.
Property signature As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "signature", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance";

}
