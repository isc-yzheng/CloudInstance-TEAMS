/// The items the orderer requested.
Class HS.FHIR.DTL.vDSTU2.Model.Element.DiagnosticOrder.item Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Code to indicate the item (test or panel) being ordered.
/// <p>
/// diagnostic-requests is the PREFERRED FHIR2 ValueSet for codes, 
/// but if you need to express meanings not found in diagnostic-requests, 
/// you may use codes from any ValueSet.
Property code As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// If this item relates to specific specimens.
/// <p>
/// Specimen
Property specimen As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "specimen", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Location of requested test (if applicable)
/// <p>
/// any FHIR2 code may be used; 
/// body-site shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property bodySite As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "bodySite", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// proposed | draft | planned | requested | received | accepted | in-progress | review | completed | cancelled | suspended | rejected | failed
/// <p>
/// diagnostic-order-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend diagnostic-order-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// DiagnosticOrder:event
/// <p>
/// Events specific to this item.
Property event As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DiagnosticOrder.event(XMLNAME = "event", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DiagnosticOrder.item";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DiagnosticOrder.item";

}
