/// A sequence used as reference.
Class HS.FHIR.DTL.vSTU3.Model.Element.Sequence.referenceSeq Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Chromosome containing genetic finding.
/// <p>
/// any FHIR3 code may be used; 
/// chromosome-human shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property chromosome As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "chromosome", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// The Genome Build used for reference, 
/// following GRCh build versions e.g. 
/// 'GRCh 37'
Property genomeBuild As %String(MAXLEN = 1000000, XMLNAME = "genomeBuild", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Reference identifier.
/// <p>
/// any FHIR3 code may be used; 
/// sequence-referenceSeq shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property referenceSeqId As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "referenceSeqId", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// A Pointer to another Sequence entity as reference sequence.
/// <p>
/// Sequence
Property referenceSeqPointer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "referenceSeqPointer", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// A string to represent reference sequence.
Property referenceSeqString As %String(MAXLEN = 1000000, XMLNAME = "referenceSeqString", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Directionality of DNA ( +1/-1)
Property strand As %Integer(XMLNAME = "strand", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Start position of the window on the  reference sequence.
Property windowStart As %Integer(XMLNAME = "windowStart", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// integer
/// <p>
/// End position of the window on the reference sequence.
Property windowEnd As %Integer(XMLNAME = "windowEnd", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Sequence.referenceSeq";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Sequence.referenceSeq";

}
