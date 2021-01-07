/// A parameter passed to or received from the operation. 
/// A parameter must have a value or resource, 
/// but not both.
Class HS.FHIR.DTL.vDSTU2.Model.Element.Parameters.parameter Extends HS.FHIR.DTL.vDSTU2.Model.Base.BackboneElement [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Name from the definition.
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Address
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueAddress As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "valueAddress", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueAnnotation As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "valueAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "valueAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueBase64Binary As %Binary(XMLNAME = "valueBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueBoolean As %Boolean(XMLNAME = "valueBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property valueCode As %String(MAXLEN = 1000000, XMLNAME = "valueCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property valueCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "valueCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property valueCoding As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "valueCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueContactPoint As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "valueContactPoint", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueDate As %String(MAXLEN = 1000000, XMLNAME = "valueDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueDateTime As %String(MAXLEN = 1000000, XMLNAME = "valueDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueDecimal As %Decimal(XMLNAME = "valueDecimal", XMLPROJECTION = "ATTRIBUTE");

/// HumanName
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueHumanName As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "valueHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueId As %String(MAXLEN = 1000000, XMLNAME = "valueId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "valueIdentifier", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueInstant As %String(MAXLEN = 1000000, XMLNAME = "valueInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueInteger As %Integer(XMLNAME = "valueInteger", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueMarkdown As %String(MAXLEN = 1000000, XMLNAME = "valueMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueMeta As HS.FHIR.DTL.vDSTU2.Model.Base.Meta(XMLNAME = "valueMeta", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueOid As %String(MAXLEN = 1000000, XMLNAME = "valueOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valuePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "valuePeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valuePositiveInt As %Integer(XMLNAME = "valuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "valueRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "valueRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property valueReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "valueReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "valueSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueSignature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "valueSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueString As %String(MAXLEN = 1000000, XMLNAME = "valueString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueTime As %String(MAXLEN = 1000000, XMLNAME = "valueTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "valueTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueUnsignedInt As %Integer(XMLNAME = "valueUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// If parameter is a data type. 
/// One of these (primitive or complex) data types.
Property valueUri As %String(MAXLEN = 1000000, XMLNAME = "valueUri", XMLPROJECTION = "ATTRIBUTE");

/// Resource
/// <p>
/// If parameter is a whole resource.
Property resource As HS.FHIR.DTL.vDSTU2.Model.Base.Resource(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// Parameters:parameter
/// <p>
/// Named part of a parameter (e.g. 
/// Tuple) A part must have a value or a resource, 
/// but not both.
Property part As list Of HS.FHIR.DTL.vDSTU2.Model.Element.Parameters.parameter(XMLNAME = "part", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Parameters.parameter";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Parameters.parameter";

}
