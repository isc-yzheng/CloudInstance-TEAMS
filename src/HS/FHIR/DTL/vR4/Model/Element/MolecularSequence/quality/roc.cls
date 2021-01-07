/// Receiver Operator Characteristic (ROC) Curve.
Class HS.FHIR.DTL.vR4.Model.Element.MolecularSequence.quality.roc Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// integer
/// <p>
/// Genotype quality score.
Property score As list Of %Integer(XMLNAME = "score", XMLPROJECTION = "ELEMENT");

/// integer
/// <p>
/// Roc score true positive numbers.
Property numTP As list Of %Integer(XMLNAME = "numTP", XMLPROJECTION = "ELEMENT");

/// integer
/// <p>
/// Roc score false positive numbers.
Property numFP As list Of %Integer(XMLNAME = "numFP", XMLPROJECTION = "ELEMENT");

/// integer
/// <p>
/// Roc score false negative numbers.
Property numFN As list Of %Integer(XMLNAME = "numFN", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Precision of the GQ score.
Property precision As list Of %Decimal(XMLNAME = "precision", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// Sensitivity of the GQ score.
Property sensitivity As list Of %Decimal(XMLNAME = "sensitivity", XMLPROJECTION = "ELEMENT");

/// decimal
/// <p>
/// FScore of the GQ score.
Property fMeasure As list Of %Decimal(XMLNAME = "fMeasure", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MolecularSequence.quality.roc";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MolecularSequence.quality.roc";

}
