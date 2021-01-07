/// Processing errors.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ClaimResponse.error Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// positiveInt
/// <p>
/// Item sequence number.
Property sequenceLinkId As %Integer(XMLNAME = "sequenceLinkId", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Detail sequence number.
Property detailSequenceLinkId As %Integer(XMLNAME = "detailSequenceLinkId", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Subdetail sequence number.
Property subdetailSequenceLinkId As %Integer(XMLNAME = "subdetailSequenceLinkId", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Error code detailing processing issues.
/// <p>
/// adjudication-error is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend adjudication-error and you may NOT use codes from other ValueSets.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.error";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.error";

}
