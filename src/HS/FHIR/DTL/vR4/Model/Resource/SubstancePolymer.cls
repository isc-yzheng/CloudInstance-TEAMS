/// Todo.
Class HS.FHIR.DTL.vR4.Model.Resource.SubstancePolymer Extends HS.FHIR.DTL.vR4.Model.Base.DomainResource [ Not ProcedureBlock ]
{

/// CodeableConcept
/// <p>
/// Todo.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property class As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "class", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Todo.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property geometry As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "geometry", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Todo.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property copolymerConnectivity As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "copolymerConnectivity", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Todo.
Property modification As list Of %String(MAXLEN = 1000000, XMLNAME = "modification", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Todo.
Property monomerSet As list Of HS.FHIR.DTL.vR4.Model.Element.SubstancePolymer.monomerSet(XMLNAME = "monomerSet", XMLPROJECTION = "ELEMENT");

/// BackboneElement
/// <p>
/// Todo.
Property repeat As list Of HS.FHIR.DTL.vR4.Model.Element.SubstancePolymer.repeat(XMLNAME = "repeat", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "SubstancePolymer";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "SubstancePolymer";

}
