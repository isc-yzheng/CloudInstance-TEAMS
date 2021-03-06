/// Processing errors.
Class HS.FHIR.DTL.vSTU3.Model.Element.ClaimResponse.error Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
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

/// CodeableConcept
/// <p>
/// Error code detailing processing issues.
/// <p>
/// any FHIR3 code may be used; 
/// ex-revenue-center shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ClaimResponse.error";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ClaimResponse.error";

}
