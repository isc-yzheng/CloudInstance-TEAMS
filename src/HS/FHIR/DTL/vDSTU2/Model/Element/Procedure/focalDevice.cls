/// Device changed in procedure.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Procedure.focalDevice Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Kind of change to device.
/// <p>
/// device-action is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend device-action and you may NOT use codes from other ValueSets.
Property action As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Device that was changed.
/// <p>
/// Device
Property manipulated As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "manipulated", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Procedure.focalDevice";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Procedure.focalDevice";

}
