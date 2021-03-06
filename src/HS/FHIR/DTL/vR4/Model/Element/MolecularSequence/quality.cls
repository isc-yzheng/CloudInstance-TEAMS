/// An set of value as quality of sequence.
Class HS.FHIR.DTL.vR4.Model.Element.MolecularSequence.quality Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// indel | snp | unknown
/// <p>
/// quality-type|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend quality-type|4.0.1 and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Standard sequence for comparison.
/// <p>
/// any FHIR4 code may be used; 
/// sequence-quality-standardSequence shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property standardSequence As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "standardSequence", XMLPROJECTION = "ELEMENT");

/// integer
/// <p>
/// Start position of the sequence.
Property start As %Integer(XMLNAME = "start", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// End position of the sequence.
Property end As %Integer(XMLNAME = "end", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Quality score for the comparison.
Property score As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "score", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Method to get quality.
/// <p>
/// any FHIR4 code may be used; 
/// sequence-quality-method shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property method As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "method", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// True positives from the perspective of the truth data.
Property truthTP As %Decimal(XMLNAME = "truthTP", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// True positives from the perspective of the query data.
Property queryTP As %Decimal(XMLNAME = "queryTP", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// False negatives.
Property truthFN As %Decimal(XMLNAME = "truthFN", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// False positives.
Property queryFP As %Decimal(XMLNAME = "queryFP", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// False positives where the non-REF alleles in the Truth and Query Call Sets match.
Property gtFP As %Decimal(XMLNAME = "gtFP", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Precision of comparison.
Property precision As %Decimal(XMLNAME = "precision", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Recall of comparison.
Property recall As %Decimal(XMLNAME = "recall", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// F-score.
Property fScore As %Decimal(XMLNAME = "fScore", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Receiver Operator Characteristic (ROC) Curve.
Property roc As HS.FHIR.DTL.vR4.Model.Element.MolecularSequence.quality.roc(XMLNAME = "roc", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MolecularSequence.quality";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MolecularSequence.quality";

}
