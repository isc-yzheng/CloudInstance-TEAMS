/// Resource to define constraints on the Expansion of a FHIR ValueSet.
Class HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.Designation Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.Designation";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.Designation";

Parameter JSONTYPEFIELD;

/// Designations to be included.
Property include As HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.Include(XMLNAME = "include", XMLPROJECTION = "ELEMENT");

/// Designations to be excluded.
Property exclude As HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.Exclude(XMLNAME = "exclude", XMLPROJECTION = "ELEMENT");

}
