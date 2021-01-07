/// The definition of an element in a resource or an extension. 
/// Among the constraints are: Types must be unique by the combination of code and profile; 
/// Binding can only be present for coded elements, 
/// string, 
/// and uri; 
/// Pattern and value are mutually exclusive; 
/// Default value and meaningWhenMissing are mutually exclusive; 
/// Pattern may only be specified if there is one type; 
/// Fixed value may only be specified if there is one type; 
/// Either a nameReference or a fixed value (but not both) is permitted.
Class HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition Extends HS.FHIR.DTL.vDSTU2.Model.Base.Element [ Not ProcedureBlock ]
{

/// string
/// <p>
/// Path of the element in the hierarchy of elements.
Property path As %String(MAXLEN = 1000000, XMLNAME = "path", XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// code
/// <p>
/// xmlAttr | xmlText | typeAttr | cdaText | xhtml
/// <p>
/// property-representation is the REQUIRED FHIR2 ValueSet for codes; 
/// you may NOT extend property-representation and you may NOT use codes from other ValueSets.
Property representation As list Of %String(MAXLEN = 1000000, XMLNAME = "representation", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Name for this particular element definition (reference target)
Property name As %String(MAXLEN = 1000000, XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

/// string
/// <p>
/// Name for element to display with or prompt for element.
Property label As %String(MAXLEN = 1000000, XMLNAME = "label", XMLPROJECTION = "ATTRIBUTE");

/// Coding
/// <p>
/// Corresponding codes in terminologies.
/// <p>
/// any FHIR2 code may be used; 
/// observation-codes shows EXAMPLE codes, 
/// but you may use codes from any ValueSet.
Property code As list Of HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// This element is sliced - slices follow. 
/// If there are no discriminators.
Property slicing As HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.slicing(XMLNAME = "slicing", XMLPROJECTION = "ELEMENT");

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
Property comments As %String(MAXLEN = 1000000, XMLNAME = "comments", XMLPROJECTION = "ATTRIBUTE");

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
Property base As HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.base(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// Data type and Profile for this element.
Property type As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.type(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// To another element constraint (by element.name)
Property nameReference As %String(MAXLEN = 1000000, XMLNAME = "nameReference", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueAddress As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "defaultValueAddress", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueAnnotation As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "defaultValueAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "defaultValueAttachment", XMLPROJECTION = "ELEMENT");

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
/// any FHIR2 code from any ValueSet may be used.
Property defaultValueCode As %String(MAXLEN = 1000000, XMLNAME = "defaultValueCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Specified value if missing from instance. 
/// 
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property defaultValueCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "defaultValueCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Specified value if missing from instance. 
/// 
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property defaultValueCoding As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "defaultValueCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueContactPoint As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "defaultValueContactPoint", XMLPROJECTION = "ELEMENT");

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

/// HumanName
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueHumanName As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "defaultValueHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueId As %String(MAXLEN = 1000000, XMLNAME = "defaultValueId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "defaultValueIdentifier", XMLPROJECTION = "ELEMENT");

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
Property defaultValueMeta As HS.FHIR.DTL.vDSTU2.Model.Base.Meta(XMLNAME = "defaultValueMeta", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueOid As %String(MAXLEN = 1000000, XMLNAME = "defaultValueOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValuePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "defaultValuePeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValuePositiveInt As %Integer(XMLNAME = "defaultValuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "defaultValueQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "defaultValueRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "defaultValueRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Specified value if missing from instance. 
/// 
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property defaultValueReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "defaultValueReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "defaultValueSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Specified value if missing from instance. 
/// 
Property defaultValueSignature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "defaultValueSignature", XMLPROJECTION = "ELEMENT");

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
Property defaultValueTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "defaultValueTiming", XMLPROJECTION = "ELEMENT");

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

/// Address
/// <p>
/// Value must be exactly this.
Property fixedAddress As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "fixedAddress", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Value must be exactly this.
Property fixedAnnotation As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "fixedAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Value must be exactly this.
Property fixedAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "fixedAttachment", XMLPROJECTION = "ELEMENT");

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
/// any FHIR2 code from any ValueSet may be used.
Property fixedCode As %String(MAXLEN = 1000000, XMLNAME = "fixedCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Value must be exactly this.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property fixedCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "fixedCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Value must be exactly this.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property fixedCoding As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "fixedCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Value must be exactly this.
Property fixedContactPoint As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "fixedContactPoint", XMLPROJECTION = "ELEMENT");

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

/// HumanName
/// <p>
/// Value must be exactly this.
Property fixedHumanName As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "fixedHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Value must be exactly this.
Property fixedId As %String(MAXLEN = 1000000, XMLNAME = "fixedId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Value must be exactly this.
Property fixedIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "fixedIdentifier", XMLPROJECTION = "ELEMENT");

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
Property fixedMeta As HS.FHIR.DTL.vDSTU2.Model.Base.Meta(XMLNAME = "fixedMeta", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Value must be exactly this.
Property fixedOid As %String(MAXLEN = 1000000, XMLNAME = "fixedOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Value must be exactly this.
Property fixedPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "fixedPeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Value must be exactly this.
Property fixedPositiveInt As %Integer(XMLNAME = "fixedPositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Value must be exactly this.
Property fixedQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "fixedQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Value must be exactly this.
Property fixedRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "fixedRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Value must be exactly this.
Property fixedRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "fixedRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Value must be exactly this.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property fixedReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "fixedReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Value must be exactly this.
Property fixedSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "fixedSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Value must be exactly this.
Property fixedSignature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "fixedSignature", XMLPROJECTION = "ELEMENT");

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
Property fixedTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "fixedTiming", XMLPROJECTION = "ELEMENT");

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
Property patternAddress As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "patternAddress", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Value must have at least these property values.
Property patternAnnotation As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "patternAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Value must have at least these property values.
Property patternAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "patternAttachment", XMLPROJECTION = "ELEMENT");

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
/// any FHIR2 code from any ValueSet may be used.
Property patternCode As %String(MAXLEN = 1000000, XMLNAME = "patternCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Value must have at least these property values.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property patternCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "patternCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Value must have at least these property values.
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property patternCoding As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "patternCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Value must have at least these property values.
Property patternContactPoint As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "patternContactPoint", XMLPROJECTION = "ELEMENT");

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

/// HumanName
/// <p>
/// Value must have at least these property values.
Property patternHumanName As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "patternHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Value must have at least these property values.
Property patternId As %String(MAXLEN = 1000000, XMLNAME = "patternId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Value must have at least these property values.
Property patternIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "patternIdentifier", XMLPROJECTION = "ELEMENT");

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
Property patternMeta As HS.FHIR.DTL.vDSTU2.Model.Base.Meta(XMLNAME = "patternMeta", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Value must have at least these property values.
Property patternOid As %String(MAXLEN = 1000000, XMLNAME = "patternOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Value must have at least these property values.
Property patternPeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "patternPeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Value must have at least these property values.
Property patternPositiveInt As %Integer(XMLNAME = "patternPositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Value must have at least these property values.
Property patternQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "patternQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Value must have at least these property values.
Property patternRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "patternRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Value must have at least these property values.
Property patternRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "patternRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Value must have at least these property values.
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property patternReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "patternReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Value must have at least these property values.
Property patternSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "patternSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Value must have at least these property values.
Property patternSignature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "patternSignature", XMLPROJECTION = "ELEMENT");

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
Property patternTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "patternTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Value must have at least these property values.
Property patternUnsignedInt As %Integer(XMLNAME = "patternUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Value must have at least these property values.
Property patternUri As %String(MAXLEN = 1000000, XMLNAME = "patternUri", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Example value (as defined for type)
Property exampleAddress As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "exampleAddress", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Example value (as defined for type)
Property exampleAnnotation As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "exampleAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Example value (as defined for type)
Property exampleAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "exampleAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// Example value (as defined for type)
Property exampleBase64Binary As %Binary(XMLNAME = "exampleBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Example value (as defined for type)
Property exampleBoolean As %Boolean(XMLNAME = "exampleBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Example value (as defined for type)
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property exampleCode As %String(MAXLEN = 1000000, XMLNAME = "exampleCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Example value (as defined for type)
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property exampleCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "exampleCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Example value (as defined for type)
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property exampleCoding As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "exampleCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Example value (as defined for type)
Property exampleContactPoint As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "exampleContactPoint", XMLPROJECTION = "ELEMENT");

/// date
/// <p>
/// Example value (as defined for type)
Property exampleDate As %String(MAXLEN = 1000000, XMLNAME = "exampleDate", XMLPROJECTION = "ATTRIBUTE");

/// dateTime
/// <p>
/// Example value (as defined for type)
Property exampleDateTime As %String(MAXLEN = 1000000, XMLNAME = "exampleDateTime", XMLPROJECTION = "ATTRIBUTE");

/// decimal
/// <p>
/// Example value (as defined for type)
Property exampleDecimal As %Decimal(XMLNAME = "exampleDecimal", XMLPROJECTION = "ATTRIBUTE");

/// HumanName
/// <p>
/// Example value (as defined for type)
Property exampleHumanName As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "exampleHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Example value (as defined for type)
Property exampleId As %String(MAXLEN = 1000000, XMLNAME = "exampleId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Example value (as defined for type)
Property exampleIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "exampleIdentifier", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// Example value (as defined for type)
Property exampleInstant As %String(MAXLEN = 1000000, XMLNAME = "exampleInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Example value (as defined for type)
Property exampleInteger As %Integer(XMLNAME = "exampleInteger", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Example value (as defined for type)
Property exampleMarkdown As %String(MAXLEN = 1000000, XMLNAME = "exampleMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Example value (as defined for type)
Property exampleMeta As HS.FHIR.DTL.vDSTU2.Model.Base.Meta(XMLNAME = "exampleMeta", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Example value (as defined for type)
Property exampleOid As %String(MAXLEN = 1000000, XMLNAME = "exampleOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Example value (as defined for type)
Property examplePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "examplePeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Example value (as defined for type)
Property examplePositiveInt As %Integer(XMLNAME = "examplePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Example value (as defined for type)
Property exampleQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "exampleQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Example value (as defined for type)
Property exampleRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "exampleRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Example value (as defined for type)
Property exampleRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "exampleRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Example value (as defined for type)
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property exampleReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "exampleReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Example value (as defined for type)
Property exampleSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "exampleSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Example value (as defined for type)
Property exampleSignature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "exampleSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Example value (as defined for type)
Property exampleString As %String(MAXLEN = 1000000, XMLNAME = "exampleString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Example value (as defined for type)
Property exampleTime As %String(MAXLEN = 1000000, XMLNAME = "exampleTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// Example value (as defined for type)
Property exampleTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "exampleTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Example value (as defined for type)
Property exampleUnsignedInt As %Integer(XMLNAME = "exampleUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Example value (as defined for type)
Property exampleUri As %String(MAXLEN = 1000000, XMLNAME = "exampleUri", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueAddress As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "minValueAddress", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueAnnotation As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "minValueAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "minValueAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueBase64Binary As %Binary(XMLNAME = "minValueBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueBoolean As %Boolean(XMLNAME = "minValueBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Minimum Allowed Value (for some types).
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property minValueCode As %String(MAXLEN = 1000000, XMLNAME = "minValueCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Minimum Allowed Value (for some types).
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property minValueCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "minValueCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Minimum Allowed Value (for some types).
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property minValueCoding As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "minValueCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueContactPoint As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "minValueContactPoint", XMLPROJECTION = "ELEMENT");

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

/// HumanName
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueHumanName As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "minValueHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueId As %String(MAXLEN = 1000000, XMLNAME = "minValueId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "minValueIdentifier", XMLPROJECTION = "ELEMENT");

/// instant
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueInstant As %String(MAXLEN = 1000000, XMLNAME = "minValueInstant", XMLPROJECTION = "ATTRIBUTE");

/// integer
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueInteger As %Integer(XMLNAME = "minValueInteger", XMLPROJECTION = "ATTRIBUTE");

/// markdown
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueMarkdown As %String(MAXLEN = 1000000, XMLNAME = "minValueMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueMeta As HS.FHIR.DTL.vDSTU2.Model.Base.Meta(XMLNAME = "minValueMeta", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueOid As %String(MAXLEN = 1000000, XMLNAME = "minValueOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Minimum Allowed Value (for some types).
Property minValuePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "minValuePeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Minimum Allowed Value (for some types).
Property minValuePositiveInt As %Integer(XMLNAME = "minValuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "minValueQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "minValueRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "minValueRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Minimum Allowed Value (for some types).
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property minValueReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "minValueReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "minValueSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueSignature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "minValueSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueString As %String(MAXLEN = 1000000, XMLNAME = "minValueString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueTime As %String(MAXLEN = 1000000, XMLNAME = "minValueTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "minValueTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueUnsignedInt As %Integer(XMLNAME = "minValueUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Minimum Allowed Value (for some types).
Property minValueUri As %String(MAXLEN = 1000000, XMLNAME = "minValueUri", XMLPROJECTION = "ATTRIBUTE");

/// Address
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueAddress As HS.FHIR.DTL.vDSTU2.Model.Datatype.Address(XMLNAME = "maxValueAddress", XMLPROJECTION = "ELEMENT");

/// Annotation
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueAnnotation As HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation(XMLNAME = "maxValueAnnotation", XMLPROJECTION = "ELEMENT");

/// Attachment
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueAttachment As HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment(XMLNAME = "maxValueAttachment", XMLPROJECTION = "ELEMENT");

/// base64Binary
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueBase64Binary As %Binary(XMLNAME = "maxValueBase64Binary", XMLPROJECTION = "ATTRIBUTE");

/// boolean
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueBoolean As %Boolean(XMLNAME = "maxValueBoolean", XMLPROJECTION = "ATTRIBUTE");

/// code
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property maxValueCode As %String(MAXLEN = 1000000, XMLNAME = "maxValueCode", XMLPROJECTION = "ATTRIBUTE");

/// CodeableConcept
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property maxValueCodeableConcept As HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept(XMLNAME = "maxValueCodeableConcept", XMLPROJECTION = "ELEMENT");

/// Coding
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
/// <p>
/// any FHIR2 code from any ValueSet may be used.
Property maxValueCoding As HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding(XMLNAME = "maxValueCoding", XMLPROJECTION = "ELEMENT");

/// ContactPoint
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueContactPoint As HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint(XMLNAME = "maxValueContactPoint", XMLPROJECTION = "ELEMENT");

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

/// HumanName
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueHumanName As HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName(XMLNAME = "maxValueHumanName", XMLPROJECTION = "ELEMENT");

/// id
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueId As %String(MAXLEN = 1000000, XMLNAME = "maxValueId", XMLPROJECTION = "ATTRIBUTE");

/// Identifier
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueIdentifier As HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier(XMLNAME = "maxValueIdentifier", XMLPROJECTION = "ELEMENT");

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

/// markdown
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueMarkdown As %String(MAXLEN = 1000000, XMLNAME = "maxValueMarkdown", XMLPROJECTION = "ATTRIBUTE");

/// Meta
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueMeta As HS.FHIR.DTL.vDSTU2.Model.Base.Meta(XMLNAME = "maxValueMeta", XMLPROJECTION = "ELEMENT");

/// oid
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueOid As %String(MAXLEN = 1000000, XMLNAME = "maxValueOid", XMLPROJECTION = "ATTRIBUTE");

/// Period
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValuePeriod As HS.FHIR.DTL.vDSTU2.Model.Datatype.Period(XMLNAME = "maxValuePeriod", XMLPROJECTION = "ELEMENT");

/// positiveInt
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValuePositiveInt As %Integer(XMLNAME = "maxValuePositiveInt", XMLPROJECTION = "ATTRIBUTE");

/// Quantity
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueQuantity As HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity(XMLNAME = "maxValueQuantity", XMLPROJECTION = "ELEMENT");

/// Range
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueRange As HS.FHIR.DTL.vDSTU2.Model.Datatype.Range(XMLNAME = "maxValueRange", XMLPROJECTION = "ELEMENT");

/// Ratio
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueRatio As HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio(XMLNAME = "maxValueRatio", XMLPROJECTION = "ELEMENT");

/// Reference
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
/// <p>
/// Any FHIR2 Resource may be indicated by this Reference.
Property maxValueReference As HS.FHIR.DTL.vDSTU2.Model.Base.Reference(XMLNAME = "maxValueReference", XMLPROJECTION = "ELEMENT");

/// SampledData
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueSampledData As HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData(XMLNAME = "maxValueSampledData", XMLPROJECTION = "ELEMENT");

/// Signature
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueSignature As HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature(XMLNAME = "maxValueSignature", XMLPROJECTION = "ELEMENT");

/// string
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueString As %String(MAXLEN = 1000000, XMLNAME = "maxValueString", XMLPROJECTION = "ATTRIBUTE");

/// time
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueTime As %String(MAXLEN = 1000000, XMLNAME = "maxValueTime", XMLPROJECTION = "ATTRIBUTE");

/// Timing
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueTiming As HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing(XMLNAME = "maxValueTiming", XMLPROJECTION = "ELEMENT");

/// unsignedInt
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueUnsignedInt As %Integer(XMLNAME = "maxValueUnsignedInt", XMLPROJECTION = "ATTRIBUTE");

/// uri
/// <p>
/// Maximum Allowed Value (for some types). 
/// 
Property maxValueUri As %String(MAXLEN = 1000000, XMLNAME = "maxValueUri", XMLPROJECTION = "ATTRIBUTE");

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
Property constraint As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.constraint(XMLNAME = "constraint", XMLPROJECTION = "ELEMENT");

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
Property binding As HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.binding(XMLNAME = "binding", XMLPROJECTION = "ELEMENT");

/// Element
/// <p>
/// Map element to another set of definitions.
Property mapping As list Of HS.FHIR.DTL.vDSTU2.Model.Element.ElementDefinition.mapping(XMLNAME = "mapping", XMLPROJECTION = "ELEMENT");

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ElementDefinition";

Parameter XMLPROJECTION = "ELEMENT";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ElementDefinition";

}
