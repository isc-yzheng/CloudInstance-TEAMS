/// Profiles that apply globally.
Class HS.FHIR.DTL.vSTU3.Model.Element.ImplementationGuide.global Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Type this profiles applies to.
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Profile that all resources must conform to.
/// <p>
/// StructureDefinition
Property profile As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.global";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.global";

}
