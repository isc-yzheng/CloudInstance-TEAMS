/// A request for a diagnostic service.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DiagnosticOrder Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Reference
/// <p>
/// Who and/or what test is about.
/// <p>
/// Patient | Group | Location | Device
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Who ordered the test.
/// <p>
/// Practitioner
Property orderer As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "orderer", XMLPROJECTION = "ELEMENT");

/// Identifier
/// <p>
/// Identifiers assigned to this order.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// The encounter that this diagnostic order is associated with.
/// <p>
/// Encounter
Property encounter As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Explanation/Justification for test.
/// <p>
/// any FHIR2 code may be used; 
/// condition-code shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property reason As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Additional clinical information.
/// <p>
/// Observation | Condition | DocumentReference
Property supportingInformation As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "supportingInformation", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// If the whole order relates to specific specimens.
/// <p>
/// Specimen
Property specimen As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "specimen", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | draft | planned | requested | received | accepted | in-progress | review | completed | cancelled | suspended | rejected | failed
/// <p>
/// diagnostic-order-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend diagnostic-order-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// routine | urgent | stat | asap
/// <p>
/// diagnostic-order-priority is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend diagnostic-order-priority and you may NOT use codes from other ValueSets.
Property priority As %String(MAXLEN = 1000000, XMLNAME = "priority", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// A list of events of interest in the lifecycle.
Property event As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DiagnosticOrder.event(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// The items the orderer requested.
Property item As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DiagnosticOrder.item(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Other notes and comments.
Property note As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "note", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticOrder";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticOrder";

}
