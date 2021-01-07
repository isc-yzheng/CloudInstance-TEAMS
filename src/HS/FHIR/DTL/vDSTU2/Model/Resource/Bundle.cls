/// Contains a collection of resources.
Class HS.FHIR.DTL.vDSTU2.Model.Resource.Bundle Extends HS.FHIR.DTL.vDSTU2.Model.Base.Resource [ Not ProcedureBlock ]
{

/// code
/// <p>
/// document | message | transaction | transaction-response | batch | batch-response | history | searchset | collection
/// <p>
/// bundle-type is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend bundle-type and you may NOT use codes from other ValueSets.
Property type As %String(MAXLEN = 1000000, XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// unsignedInt
/// <p>
/// If search, 
/// the total number of matches.
Property total As %Integer(XMLNAME = "total", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Links related to this Bundle.
Property link As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Bundle.link(XMLNAME = "link", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Entry in the bundle - will have a resource, 
/// or information.
Property entry As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Bundle.entry(XMLNAME = "entry", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Digital Signature.
Property signature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "signature", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Bundle";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Bundle";

}
