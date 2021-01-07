/// Device changed in procedure.
Class HS.FHIR.DTL.vSTU3.Model.Element.Procedure.focalDevice Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Kind of change to device.
/// <p>
/// device-action is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in device-action, 
/// you may use codes from any ValueSet.
Property action As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Device that was changed.
/// <p>
/// Device
Property manipulated As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "manipulated", XMLPROJECTION = "ELEMENT") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Procedure.focalDevice";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Procedure.focalDevice";

}
