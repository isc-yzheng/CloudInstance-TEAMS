/// Resource related to this observation.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Observation.related Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// has-member | derived-from | sequel-to | replaces | qualified-by | interfered-by
/// <p>
/// observation-relationshiptypes is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend observation-relationshiptypes and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Resource that is related to this one.
/// <p>
/// Observation | QuestionnaireResponse
Property target As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Observation.related";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Observation.related";

}
