/// Sample for analysis.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Specimen Extends HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// External Identifier.
Property identifier As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// code
/// <p>
/// available | unavailable | unsatisfactory | entered-in-error
/// <p>
/// specimen-status is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend specimen-status and you may NOT use codes from other ValueSets.
Property status As %String(MAXLEN = 1000000, XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Kind of material that forms the specimen.
/// <p>
/// any FHIR2 code may be used; 
/// v2-0487 shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property type As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specimen from which this specimen originated.
/// <p>
/// Specimen
Property parent As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "parent", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Where the specimen came from. 
/// This may be from the patient(s) or from the environment or a device.
/// <p>
/// Patient | Group | Device | Substance
Property subject As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [ Required ];

/// Identifier
/// <p>
/// Identifier assigned by the lab.
Property accessionIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "accessionIdentifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// The time when specimen was received for processing.
Property receivedTime As %String(MAXLEN = 1000000, XMLNAME = "receivedTime", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Collection details.
Property collection As HS.FHIR.DTL.vDSTU2.Model.Element.Specimen.collection(XMLNAME = "collection", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Treatment and processing step details.
Property treatment As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Specimen.treatment(XMLNAME = "treatment", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Direct container of specimen (tube/slide, 
/// etc.)
Property container As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Specimen.container(XMLNAME = "container", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Specimen";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Specimen";

}
