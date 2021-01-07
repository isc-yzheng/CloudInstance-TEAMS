/// Population criteria group.
Class HS.FHIR.DTL.vSTU3.Model.Element.Measure.group Extends HS.FHIR.DTL.vSTU3.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier.
Property identifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Short name.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Summary description.
Property description As %String(MAXLEN = 1000000, XMLNAME = "description", XMLPROJECTION = "ATTRIBUTE");

/// BackboneElement
/// <p>
/// Population criteria.
Property population As list Of HS.FHIR.DTL.vSTU3.Model.Element.Measure.group.population(XMLNAME = "population", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Stratifier criteria for the measure.
Property stratifier As list Of HS.FHIR.DTL.vSTU3.Model.Element.Measure.group.stratifier(XMLNAME = "stratifier", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Measure.group";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Measure.group";

}
