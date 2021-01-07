/// Structure Definition used by this map.
Class HS.FHIR.DTL.vSTU3.Model.Element.StructureMap.structure Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// Canonical URL for structure definition.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// source | queried | target | produced
/// <p>
/// map-model-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend map-model-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Name for type in this map.
Property alias As %String(MAXLEN = 1000000, XMLNAME = "alias", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Documentation on use of structure.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureMap.structure";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureMap.structure";

}
