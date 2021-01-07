/// The marketing status describes the date when a medicinal product is actually put on the market or the date as of which it is no longer available.
Class HS.FHIR.DTL.vR4.Model.Datatype.ProdCharacteristic Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Quantity
/// <p>
/// Where applicable, 
/// the height can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used.
Property height As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "height", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Where applicable, 
/// the width can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used.
Property width As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "width", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Where applicable, 
/// the depth can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used.
Property depth As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "depth", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Where applicable, 
/// the weight can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used.
Property weight As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "weight", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Where applicable, 
/// the nominal volume can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used.
Property nominalVolume As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "nominalVolume", XMLPROJECTION = "ELEMENT");

/// Quantity
/// <p>
/// Where applicable, 
/// the external diameter can be specified using a numerical value and its unit of measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used.
Property externalDiameter As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "externalDiameter", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Where applicable, 
/// the shape can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used.
Property shape As %String(MAXLEN = 1000000, XMLNAME = "shape", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Where applicable, 
/// the color can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used.
Property color As list Of %String(MAXLEN = 1000000, XMLNAME = "color", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Where applicable, 
/// the imprint can be specified as text.
Property imprint As list Of %String(MAXLEN = 1000000, XMLNAME = "imprint", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Where applicable, 
/// the image can be provided The format of the image attachment shall be specified by regional implementations.
Property image As list Of HS.FHIR.DTL.vR4.Model.Datatype.Attachment(XMLNAME = "image", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// Where applicable, 
/// the scoring can be specified An appropriate controlled vocabulary shall be used The term and the term identifier shall be used.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property scoring As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "scoring", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HS.FHIR.DTL.vR4.Model.Datatype.ProdCharacteristic";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HS.FHIR.DTL.vR4.Model.Datatype.ProdCharacteristic";

}
