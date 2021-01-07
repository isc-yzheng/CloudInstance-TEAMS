/// Another Implementation guide this depends on.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.dependency Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// reference | inclusion
/// <p>
/// guide-dependency-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend guide-dependency-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Where to find dependency.
Property uri As %String(MAXLEN = 1000000, XMLNAME = "uri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.dependency";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.dependency";

}
