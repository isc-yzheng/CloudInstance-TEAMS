/// Base definition for all elements that are defined inside a resource - but not those in a data type.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.BackboneElement Extends HS.FHIR.vSTU3.Model.Base.Element [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "BackboneElement";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

/// May be used to represent additional information that is not part of the basic definition of the element, and that modifies the understanding of the element that contains it. Usually modifier elements provide negation or qualification. In order to make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
Property modifierExtension As list Of HS.FHIR.vSTU3.Model.Base.Extension(XMLNAME = "modifierExtension", XMLPROJECTION = "ELEMENT");

}
