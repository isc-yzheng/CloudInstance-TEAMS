/// Raw data describing a biological sequence.
Class HS.FHIR.DTL.vSTU3.Model.Resource.Sequence Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique ID for this particular sequence. 
/// This is a FHIR-defined id.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// aa | dna | rna
/// <p>
/// any FHIR3 code may be used; 
/// sequence-type shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Base number of coordinate system (0 for 0-based numbering or coordinates, 
/// inclusive start, 
/// exclusive end, 
/// 1 for 1-based numbering, 
/// inclusive start, 
/// inclusive end)
Property coordinateSystem As %Integer(XMLNAME = "coordinateSystem", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Who and/or what this is about.
/// <p>
/// Patient
Property patient As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patient", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specimen used for sequencing.
/// <p>
/// Specimen
Property specimen As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "specimen", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The method for sequencing.
/// <p>
/// Device
Property device As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "device", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who should be responsible for test result.
/// <p>
/// Organization
Property performer As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "performer", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// The number of copies of the seqeunce of interest. 
/// (RNASeq)
Property quantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// A sequence used as reference.
Property referenceSeq As HS.FHIR.DTL.vSTU3.Model.Element.Sequence.referenceSeq(XMLNAME = "referenceSeq", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Variant in sequence.
Property variant As list Of HS.FHIR.DTL.vSTU3.Model.Element.Sequence.variant(XMLNAME = "variant", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Sequence that was observed.
Property observedSeq As %String(MAXLEN = 1000000, XMLNAME = "observedSeq", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// An set of value as quality of sequence.
Property quality As list Of HS.FHIR.DTL.vSTU3.Model.Element.Sequence.quality(XMLNAME = "quality", XMLPROJECTION = "ELEMENT");

/// integer
/// <p>
/// Average number of reads representing a given nucleotide in the reconstructed sequence.
Property readCoverage As %Integer(XMLNAME = "readCoverage", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// External repository which contains detailed report related with observedSeq in this resource.
Property repository As list Of HS.FHIR.DTL.vSTU3.Model.Element.Sequence.repository(XMLNAME = "repository", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Pointer to next atomic sequence.
/// <p>
/// Sequence
Property pointer As list Of HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "pointer", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Sequence";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Sequence";

}
