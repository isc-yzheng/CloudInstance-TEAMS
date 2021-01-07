/// Example value (as defined for type)
Class HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.example Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Describes the purpose of this example.
Property label As %String(MAXLEN = 1000000, XMLNAME = "label", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Address
/// <p>
/// Value of Example (one of allowed types).
Property valueAddress As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "valueAddress", XMLPROJECTION = "ELEMENT") [ Required ];

/// Age
/// <p>
/// Value of Example (one of allowed types).
Property valueAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "valueAge", XMLPROJECTION = "ELEMENT") [ Required ];

/// Annotation
/// <p>
/// Value of Example (one of allowed types).
Property valueAnnotation As HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "valueAnnotation", XMLPROJECTION = "ELEMENT") [ Required ];

/// Attachment
/// <p>
/// Value of Example (one of allowed types).
Property valueAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "valueAttachment", XMLPROJECTION = "ELEMENT") [ Required ];

/// base64Binary
/// <p>
/// Value of Example (one of allowed types).
Property valueBase64Binary As %Binary(XMLNAME = "valueBase64Binary", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// boolean
/// <p>
/// Value of Example (one of allowed types).
Property valueBoolean As %Boolean(XMLNAME = "valueBoolean", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// Value of Example (one of allowed types).
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCode As %String(MAXLEN = 1000000, XMLNAME = "valueCode", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// CodeableConcept
/// <p>
/// Value of Example (one of allowed types).
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "valueCodeableConcept", XMLPROJECTION = "ELEMENT") [ Required ];

/// Coding
/// <p>
/// Value of Example (one of allowed types).
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property valueCoding As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "valueCoding", XMLPROJECTION = "ELEMENT") [ Required ];

/// ContactPoint
/// <p>
/// Value of Example (one of allowed types).
Property valueContactPoint As HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "valueContactPoint", XMLPROJECTION = "ELEMENT") [ Required ];

/// Count
/// <p>
/// Value of Example (one of allowed types).
Property valueCount As HS.FHIR.DTL.vSTU3.Model.Datatype.Count(XMLNAME = "valueCount", XMLPROJECTION = "ELEMENT") [ Required ];

/// date
/// <p>
/// Value of Example (one of allowed types).
Property valueDate As %String(MAXLEN = 1000000, XMLNAME = "valueDate", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// dateTime
/// <p>
/// Value of Example (one of allowed types).
Property valueDateTime As %String(MAXLEN = 1000000, XMLNAME = "valueDateTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// decimal
/// <p>
/// Value of Example (one of allowed types).
Property valueDecimal As %Decimal(XMLNAME = "valueDecimal", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Distance
/// <p>
/// Value of Example (one of allowed types).
Property valueDistance As HS.FHIR.DTL.vSTU3.Model.Datatype.Distance(XMLNAME = "valueDistance", XMLPROJECTION = "ELEMENT") [ Required ];

/// Duration
/// <p>
/// Value of Example (one of allowed types).
Property valueDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "valueDuration", XMLPROJECTION = "ELEMENT") [ Required ];

/// HumanName
/// <p>
/// Value of Example (one of allowed types).
Property valueHumanName As HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "valueHumanName", XMLPROJECTION = "ELEMENT") [ Required ];

/// id
/// <p>
/// Value of Example (one of allowed types).
Property valueId As %String(MAXLEN = 1000000, XMLNAME = "valueId", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Identifier
/// <p>
/// Value of Example (one of allowed types).
Property valueIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "valueIdentifier", XMLPROJECTION = "ELEMENT") [ Required ];

/// instant
/// <p>
/// Value of Example (one of allowed types).
Property valueInstant As %String(MAXLEN = 1000000, XMLNAME = "valueInstant", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// integer
/// <p>
/// Value of Example (one of allowed types).
Property valueInteger As %Integer(XMLNAME = "valueInteger", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// markdown
/// <p>
/// Value of Example (one of allowed types).
Property valueMarkdown As %String(MAXLEN = 1000000, XMLNAME = "valueMarkdown", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Meta
/// <p>
/// Value of Example (one of allowed types).
Property valueMeta As HS.FHIR.DTL.vSTU3.Model.Base.Meta(XMLNAME = "valueMeta", XMLPROJECTION = "ELEMENT") [ Required ];

/// Money
/// <p>
/// Value of Example (one of allowed types).
Property valueMoney As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "valueMoney", XMLPROJECTION = "ELEMENT") [ Required ];

/// oid
/// <p>
/// Value of Example (one of allowed types).
Property valueOid As %String(MAXLEN = 1000000, XMLNAME = "valueOid", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Period
/// <p>
/// Value of Example (one of allowed types).
Property valuePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "valuePeriod", XMLPROJECTION = "ELEMENT") [ Required ];

/// positiveInt
/// <p>
/// Value of Example (one of allowed types).
Property valuePositiveInt As %Integer(XMLNAME = "valuePositiveInt", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Quantity
/// <p>
/// Value of Example (one of allowed types).
Property valueQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "valueQuantity", XMLPROJECTION = "ELEMENT") [ Required ];

/// Range
/// <p>
/// Value of Example (one of allowed types).
Property valueRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "valueRange", XMLPROJECTION = "ELEMENT") [ Required ];

/// Ratio
/// <p>
/// Value of Example (one of allowed types).
Property valueRatio As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "valueRatio", XMLPROJECTION = "ELEMENT") [ Required ];

/// Reference
/// <p>
/// Value of Example (one of allowed types).
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property valueReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "valueReference", XMLPROJECTION = "ELEMENT") [ Required ];

/// SampledData
/// <p>
/// Value of Example (one of allowed types).
Property valueSampledData As HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData(XMLNAME = "valueSampledData", XMLPROJECTION = "ELEMENT") [ Required ];

/// Signature
/// <p>
/// Value of Example (one of allowed types).
Property valueSignature As HS.FHIR.DTL.vSTU3.Model.Datatype.Signature(XMLNAME = "valueSignature", XMLPROJECTION = "ELEMENT") [ Required ];

/// string
/// <p>
/// Value of Example (one of allowed types).
Property valueString As %String(MAXLEN = 1000000, XMLNAME = "valueString", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// time
/// <p>
/// Value of Example (one of allowed types).
Property valueTime As %String(MAXLEN = 1000000, XMLNAME = "valueTime", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// Timing
/// <p>
/// Value of Example (one of allowed types).
Property valueTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "valueTiming", XMLPROJECTION = "ELEMENT") [ Required ];

/// unsignedInt
/// <p>
/// Value of Example (one of allowed types).
Property valueUnsignedInt As %Integer(XMLNAME = "valueUnsignedInt", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// uri
/// <p>
/// Value of Example (one of allowed types).
Property valueUri As %String(MAXLEN = 1000000, XMLNAME = "valueUri", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "example";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "example";

}
