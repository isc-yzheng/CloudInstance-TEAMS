/// Content to create because of this mapping rule.
Class HS.FHIR.DTL.vSTU3.Model.Element.StructureMap.group.rule.target Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// id
/// <p>
/// Type or variable this rule applies to.
Property context As %String(MAXLEN = 1000000, XMLNAME = "context", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// type | variable
/// <p>
/// map-context-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend map-context-type and you may NOT use codes from other ValueSets.
Property contextType As %String(MAXLEN = 1000000, XMLNAME = "contextType", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Field to create in the context.
Property element As %String(MAXLEN = 1000000, XMLNAME = "element", XMLPROJECTION = "ATTRIBUTE");

/// id
/// <p>
/// Named context for field, 
/// if desired, 
/// and a field is specified.
Property variable As %String(MAXLEN = 1000000, XMLNAME = "variable", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// first | share | last | collate
/// <p>
/// map-target-list-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend map-target-list-mode and you may NOT use codes from other ValueSets.
Property listMode As list Of %String(MAXLEN = 1000000, XMLNAME = "listMode", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Internal rule reference for shared list items.
Property listRuleId As %String(MAXLEN = 1000000, XMLNAME = "listRuleId", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// create | copy +
/// <p>
/// map-transform is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend map-transform and you may NOT use codes from other ValueSets.
Property transform As %String(MAXLEN = 1000000, XMLNAME = "transform", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Parameters to the transform.
Property parameter As list Of HS.FHIR.DTL.vSTU3.Model.Element.StructureMap.group.rule.target.parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureMap.group.rule.target";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureMap.group.rule.target";

}
