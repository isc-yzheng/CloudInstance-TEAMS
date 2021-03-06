/// A set of information summarized from a list of other resources.
Class HS.FHIR.DTL.vSTU3.Model.Resource.List Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Business identifier.
Property identifier As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// current | retired | entered-in-error
/// <p>
/// list-status is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend list-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// working | snapshot | changes
/// <p>
/// list-mode is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend list-mode and you may NOT use codes from other ValueSets.
Property mode As %String(MAXLEN = 1000000, XMLNAME = "mode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Descriptive name for the list.
Property title As %String(MAXLEN = 1000000, XMLNAME = "title", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// What the purpose of this list is.
/// <p>
/// any FHIR3 code may be used; 
/// list-example-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// If all resources have the same subject.
/// <p>
/// Patient | Group | Device | Location
Property subject As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Context in which list created.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When the list was prepared.
Property date As %String(MAXLEN = 1000000, XMLNAME = "date", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Who and/or what defined the list contents (aka Author)
/// <p>
/// Practitioner | Patient | Device
Property source As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// What order the list has.
/// <p>
/// list-order is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in list-order, 
/// you may use codes from any ValueSet.
Property orderedBy As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "orderedBy", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Comments about the list.
Property note As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Entries in the list.
Property entry As list Of HS.FHIR.DTL.vSTU3.Model.Element.List.entry(XMLNAME = "entry", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Why list is empty.
/// <p>
/// list-empty-reason is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in list-empty-reason, 
/// you may use codes from any ValueSet.
Property emptyReason As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "emptyReason", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "List";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "List";

}
