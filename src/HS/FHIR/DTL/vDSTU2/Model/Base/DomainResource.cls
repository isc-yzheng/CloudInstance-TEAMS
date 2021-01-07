/// This resource extends the base resource. 
/// All Resources except Bundle, 
/// Parameters and Binary extend this resource.
Class HS.FHIR.DTL.vDSTU2.Model.Base.DomainResource Extends HS.FHIR.DTL.vDSTU2.Model.Base.Resource [ Not ProcedureBlock ]
{

/// Narrative
/// <p>
/// Text summary of the resource, 
/// for human interpretation.
Property text As HS.FHIR.DTL.vDSTU2.Model.Base.Narrative(XMLNAME = "text", XMLPROJECTION = "ELEMENT");

/// Resource
/// <p>
/// Contained, 
/// inline Resources.
Property contained As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Resource(XMLNAME = "contained", XMLPROJECTION = "ELEMENT");

/// Extension
/// <p>
/// Additional Content defined by implementations.
Property extension As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

/// Extension
/// <p>
/// Extensions that cannot be ignored.
Property modifierExtension As list Of HS.FHIR.DTL.vDSTU2.Model.Base.Extension(XMLNAME = "modifierExtension", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DomainResource";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "DomainResource";

}
