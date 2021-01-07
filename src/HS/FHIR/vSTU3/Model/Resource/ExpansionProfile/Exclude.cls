/// Resource to define constraints on the Expansion of a FHIR ValueSet.
Class HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.Exclude Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.Exclude";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.Exclude";

Parameter JSONTYPEFIELD;

/// A data group for each designation to be excluded.
Property designation As list Of HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.Designation2(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

}
