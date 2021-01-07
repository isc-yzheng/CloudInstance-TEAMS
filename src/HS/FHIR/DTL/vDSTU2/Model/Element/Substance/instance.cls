/// If this describes a specific package/container of the substance.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Substance.instance Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Identifier of the package/container.
Property identifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// dateTime
/// <p>
/// When no longer valid to use.
Property expiry As %String(MAXLEN = 1000000, XMLNAME = "expiry", XMLPROJECTION = "ATTRIBUTE");

/// SimpleQuantity
/// <p>
/// Amount of substance in the package.
Property quantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity(XMLNAME = "quantity", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Substance.instance";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Substance.instance";

}
