/// Relationships to other compositions/documents.
Class HS.FHIR.DTL.vSTU3.Model.Element.Composition.relatesTo Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// replaces | transforms | signs | appends
/// <p>
/// document-relationship-type is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend document-relationship-type and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Target of the relationship.
Property targetIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "targetIdentifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Target of the relationship.
/// <p>
/// Composition.
Property targetReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "targetReference", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Composition.relatesTo";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Composition.relatesTo";

}
