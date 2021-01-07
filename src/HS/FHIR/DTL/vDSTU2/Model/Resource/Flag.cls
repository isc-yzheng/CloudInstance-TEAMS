/// Key information to flag to healthcare providers.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Flag Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Clinical, 
/// administrative, 
/// etc.
/// <p>
/// any FHIR2 code may be used; 
/// flag-category shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property category As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "category", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// active | inactive | entered-in-error
/// <p>
/// flag-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend flag-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Time period when flag is active.
Property period As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Who/What is flag about?
/// <p>
/// Patient | Location | Group | Organization | Practitioner
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Alert relevant during encounter.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Flag creator.
/// <p>
/// Device | Organization | Patient | Practitioner
Property author As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "author", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Partially deaf, 
/// Requires easy open caps, 
/// No permanent address, 
/// etc.
/// <p>
/// any FHIR2 code may be used; 
/// flag-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Flag";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Flag";

}
