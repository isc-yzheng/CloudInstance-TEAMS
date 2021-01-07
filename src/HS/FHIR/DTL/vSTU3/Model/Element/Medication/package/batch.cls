/// Identifies a single production run.
Class HS.FHIR.DTL.vSTU3.Model.Element.Medication.package.batch Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Identifier assigned to batch.
Property lotNumber As %String(MAXLEN = 1000000, XMLNAME = "lotNumber", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// When batch will expire.
Property expirationDate As %String(MAXLEN = 1000000, XMLNAME = "expirationDate", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Medication.package.batch";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Medication.package.batch";

}
