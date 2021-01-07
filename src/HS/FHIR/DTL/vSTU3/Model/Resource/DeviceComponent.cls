/// The characteristics, 
/// operational status and capabilities of a medical-related component of a medical device.
Class HS.FHIR.DTL.vSTU3.Model.Resource.DeviceComponent Extends HS.FHIR.DTL.vSTU3.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Instance id assigned by the software stack.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// What kind of component it is.
/// <p>
/// device-kind is the PREFERRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in device-kind, 
/// you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// instant
/// <p>
/// Recent system change timestamp.
Property lastSystemChange As %String(MAXLEN = 1000000, XMLNAME = "lastSystemChange", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Top-level device resource link.
/// <p>
/// Device
Property source As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "source", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Parent resource link.
/// <p>
/// DeviceComponent
Property parent As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "parent", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Current operational status of the component, 
/// for example On, 
/// Off or Standby.
/// <p>
/// operational-status is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in operational-status, 
/// you may formally EXTEND operational-status to add codes to it.
Property operationalStatus As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "operationalStatus", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Current supported parameter group.
/// <p>
/// parameter-group is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in parameter-group, 
/// you may formally EXTEND parameter-group to add codes to it.
Property parameterGroup As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "parameterGroup", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// other | chemical | electrical | impedance | nuclear | optical | thermal | biological | mechanical | acoustical | manual+
/// <p>
/// measurement-principle is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend measurement-principle and you may NOT use codes from other ValueSets.
Property measurementPrinciple As %String(MAXLEN = 1000000, XMLNAME = "measurementPrinciple", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Specification details such as Component Revisions, 
/// or Serial Numbers.
Property productionSpecification As list Of HS.FHIR.DTL.vSTU3.Model.Element.DeviceComponent.productionSpecification(XMLNAME = "productionSpecification", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Language code for the human-readable text strings produced by the device.
/// <p>
/// languages is the REQUIRED FHIR3 ValueSet for codes, 
/// but if you need to express meanings not found in languages, 
/// you may formally EXTEND languages to add codes to it.
Property languageCode As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "languageCode", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DeviceComponent";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DeviceComponent";

}
