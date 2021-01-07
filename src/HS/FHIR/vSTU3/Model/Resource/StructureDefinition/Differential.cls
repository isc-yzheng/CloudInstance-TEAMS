/// A definition of a FHIR structure. This resource is used to describe the underlying resources, data types defined in FHIR, and also for describing extensions and constraints on resources and data types.
Class HS.FHIR.vSTU3.Model.Resource.StructureDefinition.Differential Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "StructureDefinition.Differential";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "StructureDefinition.Differential";

Parameter JSONTYPEFIELD;

/// Captures constraints on each element within the resource.
Property element As list Of HS.FHIR.vSTU3.Model.Base.ElementDefinition(XMLNAME = "element", XMLPROJECTION = "ELEMENT");

}
