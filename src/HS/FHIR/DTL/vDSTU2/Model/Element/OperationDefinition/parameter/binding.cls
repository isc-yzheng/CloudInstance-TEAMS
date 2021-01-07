/// ValueSet details if this is coded.
Class HS.FHIR.DTL.vDSTU2.Model.Element.OperationDefinition.parameter.binding Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// required | extensible | preferred | example
/// <p>
/// binding-strength is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend binding-strength and you may NOT use codes from other ValueSets.
Property strength As %String(MAXLEN = 1000000, XMLNAME = "strength", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Source of value set.
/// <p>
/// ValueSet.
Property valueSetReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "valueSetReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Source of value set.
Property valueSetUri As %String(MAXLEN = 1000000, XMLNAME = "valueSetUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "OperationDefinition.parameter.binding";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "OperationDefinition.parameter.binding";

}
