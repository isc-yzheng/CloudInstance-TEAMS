/// Resource to define constraints on the Expansion of a FHIR ValueSet.
Class HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.Include Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.Include";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.Include";

Parameter JSONTYPEFIELD;

/// A data group for each designation to be included.
Property designation As list Of HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.Designation1(XMLNAME = "designation", XMLPROJECTION = "ELEMENT");

}
