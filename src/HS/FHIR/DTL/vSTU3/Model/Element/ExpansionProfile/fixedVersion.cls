/// Fix use of a code system to a particular version.
Class HS.FHIR.DTL.vSTU3.Model.Element.ExpansionProfile.fixedVersion Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// System to have its version fixed.
Property system As %String(MAXLEN = 1000000, XMLNAME = "system", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Specific version of the code system referred to.
Property version As %String(MAXLEN = 1000000, XMLNAME = "version", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// default | check | override
/// <p>
/// system-version-processing-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend system-version-processing-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.fixedVersion";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.fixedVersion";

}
