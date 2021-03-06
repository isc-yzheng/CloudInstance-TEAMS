/// The actual configuration settings of a device as it actually operates, 
/// e.g., 
/// regulation status, 
/// time properties.
Class HS.FHIR.DTL.vR4.Model.Element.Device.property Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Code that specifies the property DeviceDefinitionPropetyCode (Extensible)
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property type As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Quantity
/// <p>
/// Property value as a quantity.
Property valueQuantity As list Of HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Property value as a code, 
/// e.g., 
/// NTP4 (synced to NTP)
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property valueCode As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "valueCode", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Device.property";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Device.property";

}
