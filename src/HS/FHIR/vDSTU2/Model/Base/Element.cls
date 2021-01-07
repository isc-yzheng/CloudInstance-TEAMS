Class HS.FHIR.vDSTU2.Model.Base.Element Extends HS.FHIR.vDSTU2.Model.Base.AbstractBase [ CompileAfter = HS.FHIR.vDSTU2.Model.Datatype.IdPrimitive, ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Element";

Parameter XMLSEQUENCE = 1;

/// May be used to represent additional information that is not part of the basic definition of the element. In order to make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
Property extension As list Of HS.FHIR.vDSTU2.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

Property id As HS.FHIR.vDSTU2.Model.Datatype.IdPrimitive(XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

}
