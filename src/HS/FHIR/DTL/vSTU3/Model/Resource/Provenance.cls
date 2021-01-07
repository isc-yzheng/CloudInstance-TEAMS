/// Provenance of a resource is a record that describes entities and processes involved in producing and delivering or otherwise influencing that resource. 
/// Provenance provides a critical foundation for assessing authenticity, 
/// enabling trust, 
/// and allowing reproducibility. 
/// Provenance assertions are a form of contextual metadata and can themselves become important records with their own provenance. 
/// Provenance statement indicates clinical significance in terms of confidence in authenticity, 
/// reliability, 
/// and trustworthiness, 
/// integrity, 
/// and stage in lifecycle (e.g. 
/// Document Completion - has the artifact been legally authenticated), 
/// all of which may impact security, 
/// privacy, 
/// and trust policies.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Provenance Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Target Reference (s) (usually version specific)
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference
Property target As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT") [ Required ];

/// Period
/// <p>
/// When the activity occurred.
Property period As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// When the activity was recorded / updated.
Property recorded As %String(MAXLEN = 1000000, XMLNAME = "recorded", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Policy or plan the activity was defined by.
Property policy As list Of %String(MAXLEN = 1000000, XMLNAME = "policy", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the activity occurred, 
/// if relevant.
/// <p>
/// Location
Property location As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Reason the activity is occurring.
/// <p>
/// v3-PurposeOfUse is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in v3-PurposeOfUse, 
/// you may formally EXTEND v3-PurposeOfUse to add codes to it.
Property reason As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Activity that occurred.
/// <p>
/// provenance-activity-type is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in provenance-activity-type, 
/// you may formally EXTEND provenance-activity-type to add codes to it.
Property activity As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "activity", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Actor involved.
Property agent As list Of HS.FHIR.DTL.vSTU3.Model.Element.Provenance.agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT") [ Required ];

/// BackboneElement
/// <p>
/// An entity used in this activity.
Property entity As list Of HS.FHIR.DTL.vSTU3.Model.Element.Provenance.entity(XMLNAME = "entity", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Signature on target.
Property signature As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Signature(XMLNAME = "signature", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Provenance";

}
