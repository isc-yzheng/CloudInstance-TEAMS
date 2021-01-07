/// Only if type = oral.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Claim.missingTeeth Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Tooth Code.
/// <p>
/// any FHIR2 code may be used; 
/// teeth shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property tooth As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "tooth", XMLPROJECTION = "ELEMENT") [ Required ];

/// Coding
/// <p>
/// Reason for missing.
/// <p>
/// any FHIR2 code may be used; 
/// missing-tooth-reason shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Date of Extraction.
Property extractionDate As %String(MAXLEN = 1000000, XMLNAME = "extractionDate", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Claim.missingTeeth";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Claim.missingTeeth";

}
