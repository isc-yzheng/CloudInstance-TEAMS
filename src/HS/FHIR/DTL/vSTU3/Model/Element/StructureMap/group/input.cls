/// Named instance provided when invoking the map.
Class HS.FHIR.DTL.vSTU3.Model.Element.StructureMap.group.input Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Name for this instance of data.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Type for this instance of data.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// source | target
/// <p>
/// map-input-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend map-input-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Documentation for this instance of data.
Property documentation As %String(MAXLEN = 1000000, XMLNAME = "documentation", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureMap.group.input";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureMap.group.input";

}
