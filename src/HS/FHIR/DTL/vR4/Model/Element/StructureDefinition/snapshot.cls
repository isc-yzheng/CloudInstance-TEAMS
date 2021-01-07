/// Snapshot view of the structure.
Class HS.FHIR.DTL.vR4.Model.Element.StructureDefinition.snapshot Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// ElementDefinition
/// <p>
/// Definition of elements in the resource (if no StructureDefinition)
Property element As list Of HS.FHIR.DTL.vR4.Model.Element.ElementDefinition(XMLNAME = "element", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureDefinition.snapshot";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureDefinition.snapshot";

}
