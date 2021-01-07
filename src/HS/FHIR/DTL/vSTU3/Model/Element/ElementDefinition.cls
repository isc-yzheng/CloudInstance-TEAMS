/// The definition of an element in a resource or an extension. 
/// Among the constraints are: If the element definition has a contentReference, 
/// it cannot have type, 
/// defaultValue, 
/// fixed, 
/// pattern, 
/// example, 
/// minValue, 
/// maxValue, 
/// maxLength, 
/// or binding; 
/// Pattern may only be specified if there is one type; 
/// Fixed value may only be specified if there is one type; 
/// Binding can only be present for coded elements, 
/// string, 
/// and uri; 
/// Pattern and value are mutually exclusive; 
/// Default value and meaningWhenMissing are mutually exclusive.
Class HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition Extends HS.FHIR.DTL.vSTU3.Model.Base.Element [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Path of the element in the hierarchy of elements.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// xmlAttr | xmlText | typeAttr | cdaText | xhtml
/// <p>
/// property-representation is the REQUIRED FHIR3 ValueSet for codes; 
/// you may NOT extend property-representation and you may NOT use codes from other ValueSets.
Property representation As list Of %String(MAXLEN = 1000000, XMLNAME = "representation", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name for this particular element (in a set of slices)
Property sliceName As %String(MAXLEN = 1000000, XMLNAME = "sliceName", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for element to display with or prompt for element.
Property label As %String(MAXLEN = 1000000, XMLNAME = "label", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Corresponding codes in terminologies.
/// <p>
/// any FHIR3 code may be used; 
/// observation-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As list Of HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// This element is sliced - slices follow. 
/// If there are no discriminators.
Property slicing As HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.slicing(XMLNAME = "slicing", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Concise definition for space-constrained presentation.
Property short As %String(MAXLEN = 1000000, XMLNAME = "short", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Full formal definition as narrative text.
Property definition As %String(MAXLEN = 1000000, XMLNAME = "definition", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Comments about the use of this element.
Property comment As %String(MAXLEN = 1000000, XMLNAME = "comment", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Why this resource has been created.
Property requirements As %String(MAXLEN = 1000000, XMLNAME = "requirements", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Other names.
Property alias As list Of %String(MAXLEN = 1000000, XMLNAME = "alias", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Minimum Cardinality.
Property min As %Integer(XMLNAME = "min", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Maximum Cardinality (a number or *)
Property max As %String(MAXLEN = 1000000, XMLNAME = "max", XMLPROJECTION = "ATTRIBUTE");

/// Element
/// <p>
/// Base definition information for tools.
Property base As HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.base(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// uri
/// <p>
/// Reference to definition of content for the element.
Property contentReference As %String(MAXLEN = 1000000, XMLNAME = "contentReference", XMLPROJECTION = "ATTRIBUTE");

/// Element
/// <p>
/// Data type and Profile for this element.
Property type As list Of HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.type(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Address
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueAddress As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "defaultValueAddress", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "defaultValueAge", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueAnnotation As HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "defaultValueAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "defaultValueAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueBase64Binary As %Binary(XMLNAME = "defaultValueBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueBoolean As %Boolean(XMLNAME = "defaultValueBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Specified value if missing from instance. 
/// 
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property defaultValueCode As %String(MAXLEN = 1000000, XMLNAME = "defaultValueCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Specified value if missing from instance. 
/// 
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property defaultValueCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "defaultValueCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Specified value if missing from instance. 
/// 
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property defaultValueCoding As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "defaultValueCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueContactPoint As HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "defaultValueContactPoint", XMLPROJECTION = "ELEMENT");

/// Count
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueCount As HS.FHIR.DTL.vSTU3.Model.Datatype.Count(XMLNAME = "defaultValueCount", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueDate As %String(MAXLEN = 1000000, XMLNAME = "defaultValueDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueDateTime As %String(MAXLEN = 1000000, XMLNAME = "defaultValueDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueDecimal As %Decimal(XMLNAME = "defaultValueDecimal", XMLPROJECTION = "ATTRIBUTE");

/// Distance
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueDistance As HS.FHIR.DTL.vSTU3.Model.Datatype.Distance(XMLNAME = "defaultValueDistance", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "defaultValueDuration", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueHumanName As HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "defaultValueHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueId As %String(MAXLEN = 1000000, XMLNAME = "defaultValueId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "defaultValueIdentifier", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueInstant As %String(MAXLEN = 1000000, XMLNAME = "defaultValueInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueInteger As %Integer(XMLNAME = "defaultValueInteger", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueMarkdown As %String(MAXLEN = 1000000, XMLNAME = "defaultValueMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueMeta As HS.FHIR.DTL.vSTU3.Model.Base.Meta(XMLNAME = "defaultValueMeta", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueMoney As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "defaultValueMoney", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueOid As %String(MAXLEN = 1000000, XMLNAME = "defaultValueOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValuePeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "defaultValuePeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValuePositiveInt As %Integer(XMLNAME = "defaultValuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "defaultValueQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "defaultValueRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueRatio As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "defaultValueRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specified value if missing from instance. 
/// 
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property defaultValueReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "defaultValueReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueSampledData As HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData(XMLNAME = "defaultValueSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueSignature As HS.FHIR.DTL.vSTU3.Model.Datatype.Signature(XMLNAME = "defaultValueSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueString As %String(MAXLEN = 1000000, XMLNAME = "defaultValueString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueTime As %String(MAXLEN = 1000000, XMLNAME = "defaultValueTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "defaultValueTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueUnsignedInt As %Integer(XMLNAME = "defaultValueUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueUri As %String(MAXLEN = 1000000, XMLNAME = "defaultValueUri", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Implicit meaning when this element is missing.
Property meaningWhenMissing As %String(MAXLEN = 1000000, XMLNAME = "meaningWhenMissing", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// What the order of the elements means.
Property orderMeaning As %String(MAXLEN = 1000000, XMLNAME = "orderMeaning", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Value must be exactly this.
Property fixedAddress As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "fixedAddress", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// Value must be exactly this.
Property fixedAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "fixedAge", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Value must be exactly this.
Property fixedAnnotation As HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "fixedAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Value must be exactly this.
Property fixedAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "fixedAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// Value must be exactly this.
Property fixedBase64Binary As %Binary(XMLNAME = "fixedBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Value must be exactly this.
Property fixedBoolean As %Boolean(XMLNAME = "fixedBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Value must be exactly this.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property fixedCode As %String(MAXLEN = 1000000, XMLNAME = "fixedCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Value must be exactly this.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property fixedCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "fixedCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Value must be exactly this.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property fixedCoding As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "fixedCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Value must be exactly this.
Property fixedContactPoint As HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "fixedContactPoint", XMLPROJECTION = "ELEMENT");

/// Count
/// <p>
/// Value must be exactly this.
Property fixedCount As HS.FHIR.DTL.vSTU3.Model.Datatype.Count(XMLNAME = "fixedCount", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Value must be exactly this.
Property fixedDate As %String(MAXLEN = 1000000, XMLNAME = "fixedDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Value must be exactly this.
Property fixedDateTime As %String(MAXLEN = 1000000, XMLNAME = "fixedDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Value must be exactly this.
Property fixedDecimal As %Decimal(XMLNAME = "fixedDecimal", XMLPROJECTION = "ATTRIBUTE");

/// Distance
/// <p>
/// Value must be exactly this.
Property fixedDistance As HS.FHIR.DTL.vSTU3.Model.Datatype.Distance(XMLNAME = "fixedDistance", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Value must be exactly this.
Property fixedDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "fixedDuration", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// Value must be exactly this.
Property fixedHumanName As HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "fixedHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Value must be exactly this.
Property fixedId As %String(MAXLEN = 1000000, XMLNAME = "fixedId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Value must be exactly this.
Property fixedIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "fixedIdentifier", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// Value must be exactly this.
Property fixedInstant As %String(MAXLEN = 1000000, XMLNAME = "fixedInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Value must be exactly this.
Property fixedInteger As %Integer(XMLNAME = "fixedInteger", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Value must be exactly this.
Property fixedMarkdown As %String(MAXLEN = 1000000, XMLNAME = "fixedMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Value must be exactly this.
Property fixedMeta As HS.FHIR.DTL.vSTU3.Model.Base.Meta(XMLNAME = "fixedMeta", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Value must be exactly this.
Property fixedMoney As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "fixedMoney", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Value must be exactly this.
Property fixedOid As %String(MAXLEN = 1000000, XMLNAME = "fixedOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Value must be exactly this.
Property fixedPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "fixedPeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Value must be exactly this.
Property fixedPositiveInt As %Integer(XMLNAME = "fixedPositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Value must be exactly this.
Property fixedQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "fixedQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Value must be exactly this.
Property fixedRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "fixedRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Value must be exactly this.
Property fixedRatio As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "fixedRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Value must be exactly this.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property fixedReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "fixedReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Value must be exactly this.
Property fixedSampledData As HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData(XMLNAME = "fixedSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Value must be exactly this.
Property fixedSignature As HS.FHIR.DTL.vSTU3.Model.Datatype.Signature(XMLNAME = "fixedSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Value must be exactly this.
Property fixedString As %String(MAXLEN = 1000000, XMLNAME = "fixedString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Value must be exactly this.
Property fixedTime As %String(MAXLEN = 1000000, XMLNAME = "fixedTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// Value must be exactly this.
Property fixedTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "fixedTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Value must be exactly this.
Property fixedUnsignedInt As %Integer(XMLNAME = "fixedUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Value must be exactly this.
Property fixedUri As %String(MAXLEN = 1000000, XMLNAME = "fixedUri", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Value must have at least these property values.
Property patternAddress As HS.FHIR.DTL.vSTU3.Model.Datatype.Address(XMLNAME = "patternAddress", XMLPROJECTION = "ELEMENT");

/// Age
/// <p>
/// Value must have at least these property values.
Property patternAge As HS.FHIR.DTL.vSTU3.Model.Datatype.Age(XMLNAME = "patternAge", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Value must have at least these property values.
Property patternAnnotation As HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation(XMLNAME = "patternAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Value must have at least these property values.
Property patternAttachment As HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment(XMLNAME = "patternAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// Value must have at least these property values.
Property patternBase64Binary As %Binary(XMLNAME = "patternBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Value must have at least these property values.
Property patternBoolean As %Boolean(XMLNAME = "patternBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Value must have at least these property values.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property patternCode As %String(MAXLEN = 1000000, XMLNAME = "patternCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Value must have at least these property values.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property patternCodeableConcept As HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept(XMLNAME = "patternCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Value must have at least these property values.
/// <p>
/// any FHIR3 code from any ValueSet may be used.
Property patternCoding As HS.FHIR.DTL.vSTU3.Model.Datatype.Coding(XMLNAME = "patternCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Value must have at least these property values.
Property patternContactPoint As HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint(XMLNAME = "patternContactPoint", XMLPROJECTION = "ELEMENT");

/// Count
/// <p>
/// Value must have at least these property values.
Property patternCount As HS.FHIR.DTL.vSTU3.Model.Datatype.Count(XMLNAME = "patternCount", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Value must have at least these property values.
Property patternDate As %String(MAXLEN = 1000000, XMLNAME = "patternDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Value must have at least these property values.
Property patternDateTime As %String(MAXLEN = 1000000, XMLNAME = "patternDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Value must have at least these property values.
Property patternDecimal As %Decimal(XMLNAME = "patternDecimal", XMLPROJECTION = "ATTRIBUTE");

/// Distance
/// <p>
/// Value must have at least these property values.
Property patternDistance As HS.FHIR.DTL.vSTU3.Model.Datatype.Distance(XMLNAME = "patternDistance", XMLPROJECTION = "ELEMENT");

/// Duration
/// <p>
/// Value must have at least these property values.
Property patternDuration As HS.FHIR.DTL.vSTU3.Model.Datatype.Duration(XMLNAME = "patternDuration", XMLPROJECTION = "ELEMENT");

/// HumanName
/// <p>
/// Value must have at least these property values.
Property patternHumanName As HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName(XMLNAME = "patternHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Value must have at least these property values.
Property patternId As %String(MAXLEN = 1000000, XMLNAME = "patternId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Value must have at least these property values.
Property patternIdentifier As HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier(XMLNAME = "patternIdentifier", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// Value must have at least these property values.
Property patternInstant As %String(MAXLEN = 1000000, XMLNAME = "patternInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Value must have at least these property values.
Property patternInteger As %Integer(XMLNAME = "patternInteger", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Value must have at least these property values.
Property patternMarkdown As %String(MAXLEN = 1000000, XMLNAME = "patternMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Value must have at least these property values.
Property patternMeta As HS.FHIR.DTL.vSTU3.Model.Base.Meta(XMLNAME = "patternMeta", XMLPROJECTION = "ELEMENT");

/// Money
/// <p>
/// Value must have at least these property values.
Property patternMoney As HS.FHIR.DTL.vSTU3.Model.Datatype.Money(XMLNAME = "patternMoney", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Value must have at least these property values.
Property patternOid As %String(MAXLEN = 1000000, XMLNAME = "patternOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Value must have at least these property values.
Property patternPeriod As HS.FHIR.DTL.vSTU3.Model.Datatype.Period(XMLNAME = "patternPeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Value must have at least these property values.
Property patternPositiveInt As %Integer(XMLNAME = "patternPositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Value must have at least these property values.
Property patternQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "patternQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Value must have at least these property values.
Property patternRange As HS.FHIR.DTL.vSTU3.Model.Datatype.Range(XMLNAME = "patternRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Value must have at least these property values.
Property patternRatio As HS.FHIR.DTL.vSTU3.Model.Datatype.Ratio(XMLNAME = "patternRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Value must have at least these property values.
/// <p>
/// Any FHIR3 Resource may be indicated by this Reference.
Property patternReference As HS.FHIR.DTL.vSTU3.Model.Base.Reference(XMLNAME = "patternReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Value must have at least these property values.
Property patternSampledData As HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData(XMLNAME = "patternSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Value must have at least these property values.
Property patternSignature As HS.FHIR.DTL.vSTU3.Model.Datatype.Signature(XMLNAME = "patternSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Value must have at least these property values.
Property patternString As %String(MAXLEN = 1000000, XMLNAME = "patternString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Value must have at least these property values.
Property patternTime As %String(MAXLEN = 1000000, XMLNAME = "patternTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// Value must have at least these property values.
Property patternTiming As HS.FHIR.DTL.vSTU3.Model.Datatype.Timing(XMLNAME = "patternTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Value must have at least these property values.
Property patternUnsignedInt As %Integer(XMLNAME = "patternUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Value must have at least these property values.
Property patternUri As %String(MAXLEN = 1000000, XMLNAME = "patternUri", XMLPROJECTION = "ATTRIBUTE");

/// Element
/// <p>
/// Example value (as defined for type)
Property example As list Of HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.example(XMLNAME = "example", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueDate As %String(MAXLEN = 1000000, XMLNAME = "minValueDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueDateTime As %String(MAXLEN = 1000000, XMLNAME = "minValueDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueDecimal As %Decimal(XMLNAME = "minValueDecimal", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueInstant As %String(MAXLEN = 1000000, XMLNAME = "minValueInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueInteger As %Integer(XMLNAME = "minValueInteger", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Minimum Allowed Value (for some types).
Property minValuePositiveInt As %Integer(XMLNAME = "minValuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "minValueQuantity", XMLPROJECTION = "ELEMENT");

/// time
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueTime As %String(MAXLEN = 1000000, XMLNAME = "minValueTime", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueUnsignedInt As %Integer(XMLNAME = "minValueUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// date
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueDate As %String(MAXLEN = 1000000, XMLNAME = "maxValueDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueDateTime As %String(MAXLEN = 1000000, XMLNAME = "maxValueDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueDecimal As %Decimal(XMLNAME = "maxValueDecimal", XMLPROJECTION = "ATTRIBUTE");

/// instant
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueInstant As %String(MAXLEN = 1000000, XMLNAME = "maxValueInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueInteger As %Integer(XMLNAME = "maxValueInteger", XMLPROJECTION = "ATTRIBUTE");

/// positiveInt
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValuePositiveInt As %Integer(XMLNAME = "maxValuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueQuantity As HS.FHIR.DTL.vSTU3.Model.Datatype.Quantity(XMLNAME = "maxValueQuantity", XMLPROJECTION = "ELEMENT");

/// time
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueTime As %String(MAXLEN = 1000000, XMLNAME = "maxValueTime", XMLPROJECTION = "ATTRIBUTE");

/// unsignedInt
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueUnsignedInt As %Integer(XMLNAME = "maxValueUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Max length for strings.
Property maxLength As %Integer(XMLNAME = "maxLength", XMLPROJECTION = "ATTRIBUTE");

/// id
/// <p>
/// Reference to invariant about presence.
Property condition As list Of %String(MAXLEN = 1000000, XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// Condition that must evaluate to true.
Property constraint As list Of HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.constraint(XMLNAME = "constraint", XMLPROJECTION = "ELEMENT");

/// boolean
/// <p>
/// If the element must supported.
Property mustSupport As %Boolean(XMLNAME = "mustSupport", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// If this modifies the meaning of other elements.
Property isModifier As %Boolean(XMLNAME = "isModifier", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Include when _summary = true?
Property isSummary As %Boolean(XMLNAME = "isSummary", XMLPROJECTION = "ATTRIBUTE");

/// Element
/// <p>
/// ValueSet details if this is coded.
Property binding As HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.binding(XMLNAME = "binding", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// Map element to another set of definitions.
Property mapping As list Of HS.FHIR.DTL.vSTU3.Model.Element.ElementDefinition.mapping(XMLNAME = "mapping", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ElementDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ElementDefinition";

}
