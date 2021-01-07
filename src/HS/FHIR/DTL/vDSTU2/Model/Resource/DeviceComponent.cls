/// An instance of a medical-related component of a medical device.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.DeviceComponent Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// What kind of component it is.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Identifier
/// <p>
/// Instance id assigned by the software stack.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// instant
/// <p>
/// Recent system change timestamp.
Property lastSystemChange As %String(MAXLEN = 1000000, XMLNAME = "lastSystemChange", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// A source device of this component.
/// <p>
/// Device
Property source As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Parent resource link.
/// <p>
/// DeviceComponent
Property parent As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "parent", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Component operational status.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property operationalStatus As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "operationalStatus", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Current supported parameter group.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property parameterGroup As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "parameterGroup", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// other | chemical | electrical | impedance | nuclear | optical | thermal | biological | mechanical | acoustical | manual+
/// <p>
/// measurement-principle is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend measurement-principle and you may NOT use codes from other ValueSets.
Property measurementPrinciple As %String(MAXLEN = 1000000, XMLNAME = "measurementPrinciple", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Production specification of the component.
Property productionSpecification As list Of HS.FHIR.DTL.vDSTU2.Model.Element.DeviceComponent.productionSpecification(XMLNAME = "productionSpecification", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Language code for the human-readable text strings produced by the device.
/// <p>
/// Language RFC 5646 is the REQUIRED IETF specification for the FHIR2 code values that may be used.
Property languageCode As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "languageCode", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceComponent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceComponent";

}
