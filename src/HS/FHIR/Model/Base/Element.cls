/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.Element when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.Element Extends HS.FHIR.Model.Base.AbstractBase [ CompileAfter = HS.FHIR.Model.Datatype.IdPrimitive, Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "Element";

///  
Parameter XMLSEQUENCE = 1;

///  
Property extension As list Of HS.FHIR.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

///  
Property id As HS.FHIR.Model.Datatype.IdPrimitive(XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

}
