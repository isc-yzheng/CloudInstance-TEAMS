Class HS.FHIR.vDSTU2.Model.Resource.StructureDefinition.Differential Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureDefinition.Differential";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureDefinition.Differential";

/// Captures constraints on each element within the resource.
Property element As list Of HS.FHIR.vDSTU2.Model.Base.ElementDefinition(XMLNAME = "element", XMLPROJECTION = "ELEMENT") [ Required ];

}
