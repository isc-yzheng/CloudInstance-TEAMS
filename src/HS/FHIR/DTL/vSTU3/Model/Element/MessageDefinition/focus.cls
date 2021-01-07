/// Resource(s) that are the subject of the event.
Class HS.FHIR.DTL.vSTU3.Model.Element.MessageDefinition.focus Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// Type of resource.
/// <p>
/// resource-types is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend resource-types and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Profile that must be adhered to by focus.
/// <p>
/// StructureDefinition
Property profile As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Minimum number of focuses of this type.
Property min As %Integer(XMLNAME = "min", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Maximum number of focuses of this type.
Property max As %String(MAXLEN = 1000000, XMLNAME = "max", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "MessageDefinition.focus";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "MessageDefinition.focus";

}
