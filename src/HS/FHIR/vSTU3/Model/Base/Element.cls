/// Base definition for all elements in a resource.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.Element Extends HS.FHIR.vSTU3.Model.Base.AbstractBase [ CompileAfter = HS.FHIR.vSTU3.Model.Datatype.StringPrimitive, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Element";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

/// May be used to represent additional information that is not part of the basic definition of the element. In order to make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
Property extension As list Of HS.FHIR.vSTU3.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

Property id As HS.FHIR.vSTU3.Model.Datatype.StringPrimitive(XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

}
