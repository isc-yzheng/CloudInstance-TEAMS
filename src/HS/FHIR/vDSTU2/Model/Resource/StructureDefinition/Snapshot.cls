Class HS.FHIR.vDSTU2.Model.Resource.StructureDefinition.Snapshot Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureDefinition.Snapshot";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureDefinition.Snapshot";

/// Captures constraints on each element within the resource.
Property element As list Of HS.FHIR.vDSTU2.Model.Base.ElementDefinition(XMLNAME = "element", XMLPROJECTION = "ELEMENT") [ Required ];

}
