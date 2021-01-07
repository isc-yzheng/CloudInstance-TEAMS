/// Relationships to other documents.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DocumentReference.relatesTo Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// replaces | transforms | signs | appends
/// <p>
/// document-relationship-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend document-relationship-type and you may NOT use codes from other ValueSets.
Property code As %String(MAXLEN = 1000000, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Target of the relationship.
/// <p>
/// DocumentReference
Property target As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DocumentReference.relatesTo";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DocumentReference.relatesTo";

}
