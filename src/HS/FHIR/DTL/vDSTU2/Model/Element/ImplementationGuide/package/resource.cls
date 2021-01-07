/// Resource in the implementation guide.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ImplementationGuide.package.resource Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// code
/// <p>
/// example | terminology | profile | extension | dictionary | logical
/// <p>
/// guide-resource-purpose is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend guide-resource-purpose and you may NOT use codes from other ValueSets.
Property purpose As %String(MAXLEN = 1000000, XMLNAME = "purpose", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// string
/// <p>
/// Human Name for the resource.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Reason why included in guide.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Short code to identify the resource.
Property acronym As %String(MAXLEN = 1000000, XMLNAME = "acronym", XMLPROJECTION = "ATTRIBUTE");

/// Reference
/// <p>
/// Location of the resource.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property sourceReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "sourceReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// uri
/// <p>
/// Location of the resource.
Property sourceUri As %String(MAXLEN = 1000000, XMLNAME = "sourceUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Reference
/// <p>
/// Resource this is an example of (if applicable)
/// <p>
/// StructureDefinition
Property exampleFor As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "exampleFor", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.package.resource";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.package.resource";

}
