/// The shelf-life and storage information for a medicinal product item or container can be described using this class.
Class HS.FHIR.DTL.vR4.Model.Datatype.ProductShelfLife Extends HS.FHIR.DTL.vR4.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// Identifier
/// <p>
/// Unique identifier for the packaged Medicinal Product.
Property identifier As HS.FHIR.DTL.vR4.Model.Datatype.Identifier(XMLNAME = "identifier", XMLPROJECTION = "ELEMENT");

/// CodeableConcept
/// <p>
/// This describes the shelf life, 
/// taking into account various scenarios such as shelf life of the packaged Medicinal Product itself, 
/// shelf life after transformation where necessary and shelf life after the first opening of a bottle, 
/// etc. 
/// The shelf life type shall be specified using an appropriate controlled vocabulary The controlled term and the controlled term identifier shall be specified.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property type As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Quantity
/// <p>
/// The shelf life time period can be specified using a numerical value for the period of time and its unit of time measurement The unit of measurement shall be specified in accordance with ISO 11240 and the resulting terminology The symbol and the symbol identifier shall be used.
Property period As HS.FHIR.DTL.vR4.Model.Datatype.Quantity(XMLNAME = "period", XMLPROJECTION = "ELEMENT") [ Required ];

/// CodeableConcept
/// <p>
/// Special precautions for storage, 
/// if any, 
/// can be specified using an appropriate controlled vocabulary The controlled term and the controlled term identifier shall be specified.
/// <p>
/// any FHIR4 code from any ValueSet may be used.
Property specialPrecautionsForStorage As list Of HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept(XMLNAME = "specialPrecautionsForStorage", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "HS.FHIR.DTL.vR4.Model.Datatype.ProductShelfLife";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HS.FHIR.DTL.vR4.Model.Datatype.ProductShelfLife";

}
