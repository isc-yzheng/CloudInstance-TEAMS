/// Attests to accuracy of composition.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Composition.attester Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// personal | professional | legal | official
/// <p>
/// composition-attestation-mode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend composition-attestation-mode and you may NOT use codes from other ValueSets.
Property mode As list Of %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ELEMENT") [ Required ];

/// dateTime
/// <p>
/// When composition attested.
Property time As %String(MAXLEN = 1000000, XMLNAME = "time", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who attested the composition.
/// <p>
/// Patient | Practitioner | Organization
Property party As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "party", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Composition.attester";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Composition.attester";

}
