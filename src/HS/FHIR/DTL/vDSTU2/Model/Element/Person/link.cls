/// Link to a resource that concerns the same actual person.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Person.link Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// The resource to which this actual person is associated.
/// <p>
/// Patient | Practitioner | RelatedPerson | Person
Property target As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT") [ Required ];

/// code
/// <p>
/// level1 | level2 | level3 | level4
/// <p>
/// identity-assuranceLevel is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend identity-assuranceLevel and you may NOT use codes from other ValueSets.
Property assurance As %String(MAXLEN = 1000000, XMLNAME = "assurance", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Person.link";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Person.link";

}
