/// Contract Signatory.
Class HS.FHIR.DTL.vSTU3.Model.Element.Contract.signer Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Contract Signatory Role.
/// <p>
/// contract-signer-type is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in contract-signer-type, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Contract Signatory Party.
/// <p>
/// Organization | Patient | Practitioner | RelatedPerson
Property party As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "party", XMLPROJECTION = "ELEMENT") [ Required ];

/// Signature
/// <p>
/// Contract Documentation Signature.
Property signature As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Signature(XMLNAME = "signature", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.signer";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.signer";

}
