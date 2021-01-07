/// Document definition.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Conformance.document Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// producer | consumer
/// <p>
/// document-mode is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend document-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Description of document support.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Constraint on a resource used in the document.
/// <p>
/// StructureDefinition
Property profile As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Conformance.document";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Conformance.document";

}
