/// Related artifacts for a knowledge resource.
Class HS.FHIR.DTL.vR4.Model.Datatype.RelatedArtifact Extends HS.FHIR.DTL.vR4.Model.Base.Element [ Not ProcedureBlock ]
{

/// code
/// <p>
/// documentation | justification | citation | predecessor | successor | derived-from | depends-on | composed-of
/// <p>
/// related-artifact-type|4.0.1 is the REQUIRED FHIR4 ValueSet for codes; 
/// you may NOT extend related-artifact-type|4.0.1 and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Short label.
Property label As %String(MAXLEN = 1000000, XMLNAME = "label", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Brief description of the related artifact.
Property display As %String(MAXLEN = 1000000, XMLNAME = "display", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Bibliographic citation for the artifact.
Property citation As %String(MAXLEN = 1000000, XMLNAME = "citation", XMLPROJECTION = "ATTRIBUTE");

/// url
/// <p>
/// Where the artifact can be accessed.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE");

/// Attachment
/// <p>
/// What document is being referenced.
Property document As HS.FHIR.DTL.vR4.Model.Datatype.Attachment(XMLNAME = "document", XMLPROJECTION = "ELEMENT");

/// canonical
/// <p>
/// What resource is being referenced.
/// <p>
/// TO DO: Unrecognized value type for the FHIR4 model
Property resource As %String(MAXLEN = 1000000, XMLNAME = "resource", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RelatedArtifact";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RelatedArtifact";

}
