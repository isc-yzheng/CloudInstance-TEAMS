/// Optional Extensions Element. 
/// Must have either extensions or value*, 
/// not both.
Class HS.FHIR.DTL.vSTU3.Model.Base.Extension Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// uri
/// <p>
/// identifies the meaning of the extension.
Property url As %String(MAXLEN = 1000000, XMLNAME = "url", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Address
/// <p>
/// Value of extension.
Property valueAddress As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "valueAddress", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// Value of extension.
Property valueAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "valueAge", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Value of extension.
Property valueAnnotation As HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "valueAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Value of extension.
Property valueAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "valueAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// Value of extension.
Property valueBase64Binary As %Binary(XMLNAME = "valueBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Value of extension.
Property valueBoolean As %Boolean(XMLNAME = "valueBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Value of extension.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCode As %String(MAXLEN = 1000000, XMLNAME = "valueCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Value of extension.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "valueCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Value of extension.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCoding As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "valueCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Value of extension.
Property valueContactPoint As HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "valueContactPoint", XMLPROJECTION = "ELEMENT");

/// Count
/// <p>
/// Value of extension.
Property valueCount As HS.FHIR.DTL.vSTU3.Model.Datatype.Count(XMLNAME = "valueCount", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Value of extension.
Property valueDate As %String(MAXLEN = 1000000, XMLNAME = "valueDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Value of extension.
Property valueDateTime As %String(MAXLEN = 1000000, XMLNAME = "valueDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Value of extension.
Property valueDecimal As %Decimal(XMLNAME = "valueDecimal", XMLPROJECTION = "ATTRIBUTE");

/// Distance
/// <p>
/// Value of extension.
Property valueDistance As HS.FHIR.DTL.vSTU3.Model.Datatype.Distance(XMLNAME = "valueDistance", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Value of extension.
Property valueDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "valueDuration", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// Value of extension.
Property valueHumanName As HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "valueHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Value of extension.
Property valueId As %String(MAXLEN = 1000000, XMLNAME = "valueId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Value of extension.
Property valueIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "valueIdentifier", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// Value of extension.
Property valueInstant As %String(MAXLEN = 1000000, XMLNAME = "valueInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Value of extension.
Property valueInteger As %Integer(XMLNAME = "valueInteger", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Value of extension.
Property valueMarkdown As %String(MAXLEN = 1000000, XMLNAME = "valueMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Value of extension.
Property valueMeta As HS.FHIR.DTL.vSTU3.Model.Base.Meta(XMLNAME = "valueMeta", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Value of extension.
Property valueMoney As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "valueMoney", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Value of extension.
Property valueOid As %String(MAXLEN = 1000000, XMLNAME = "valueOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Value of extension.
Property valuePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "valuePeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Value of extension.
Property valuePositiveInt As %Integer(XMLNAME = "valuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Value of extension.
Property valueQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Value of extension.
Property valueRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "valueRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Value of extension.
Property valueRatio As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "valueRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Value of extension.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property valueReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "valueReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Value of extension.
Property valueSampledData As HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData(XMLNAME = "valueSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Value of extension.
Property valueSignature As HS.FHIR.DTL.vSTU3.Model.Datatype.Signature(XMLNAME = "valueSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Value of extension.
Property valueString As %String(MAXLEN = 1000000, XMLNAME = "valueString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Value of extension.
Property valueTime As %String(MAXLEN = 1000000, XMLNAME = "valueTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// Value of extension.
Property valueTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "valueTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Value of extension.
Property valueUnsignedInt As %Integer(XMLNAME = "valueUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Value of extension.
Property valueUri As %String(MAXLEN = 1000000, XMLNAME = "valueUri", XMLPROJECTION = "ATTRIBUTE");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Extension";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Extension";

}
