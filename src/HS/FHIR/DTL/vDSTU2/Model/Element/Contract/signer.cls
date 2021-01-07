/// Contract Signer.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Contract.signer Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Coding
/// <p>
/// Contract Signer Type.
/// <p>
/// contract-signer-type is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in contract-signer-type, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Contract Signatory Party.
/// <p>
/// Organization | Patient | Practitioner | RelatedPerson
Property party As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "party", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Contract Documentation Signature.
Property signature As %String(MAXLEN = 1000000, XMLNAME = "signature", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Contract.signer";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Contract.signer";

}
