Class HS.FHIRMeta.Load.Field Extends %RegisteredObject
{

Property name As %String;

Property path As %String;

/// Indicates whether the field is represented as an array or a scalar
/// Note: An array property can be constrained to maximum of one value, so we
/// cannot use the 'max' property as an indicator of how to represent this field
Property isArray As %Boolean;

Property min As %Integer;

Property max As %String;

/// An index assigned to each unique semantic property.
/// For 'value' type properties, all variants have the same index
Property index As %Integer;

/// An index assigned to each unique variant of a 'value' property
/// Set to zero for a non-variant property
Property vindex As %Integer;

/// The 'fhirType' object describing this field
Property fhirType As %String;

/// %List of Resource Types that a reference type can target
Property canReferTo As %List;

/// The FixedUri if this field is implemented as an extension
Property fixedUri As %String;

/// True if this profiled Extension field can NOT have unprofiled Extensions
Property noExtensions As %Boolean;

/// True if this property is represented in XML as an attribute
Property isVariant As %Boolean [ Calculated ];

/// 0 if not a variant, otherwise the number of variant types
Property variantTypeCount As %Integer;

/// True if this property is represented in XML as an attribute
Property isXmlAttr As %Boolean;

/// The Url for the ValueSet resource (if any) for this property
Property valueSetUrl As %String;

/// The "strength" code for the valueSet (required | extensible | preferred | example)
Property valueSetStrength As %String;

/// Initialize from a ElementDefinition
Method %OnNew(name, index, fhirType, min, max) As %Status
{
	//Set ..path = path
	Set ..name = name
	set ..index = index
	set ..fhirType = fhirType
	set ..min = min
	set ..max = max
	Set ..isXmlAttr = 0
	
	return $$$OK
}

Method isVariantGet() As %Boolean [ CodeMode = expression ]
{
..fhirType = "variant"
}

Method asString() As %String
{
	Set str = "[" _ $E(100+..index,2,3)_ "|"  _ ..name _ ": dt=" 
	if ..fhirType '= "" {
		set str = str _ ..fhirType
	}
	if ..isVariant {
		Set str = str _ " (" _ ..variantTypeCount _ " type"_ $Select(..variantTypeCount>1:"s",1:"") _ ")"
	}
	Set str = str _ ", min=" _ ..min _  ", max=" _  ..max
	if ..isArray {
		Set str = str _ ", array"	
	}
	if ..fixedUri'="" {
		Set str = str _ ", uri=" _  ..fixedUri	
	}
	if ..canReferTo '= "" {
		Set str = str _ ", refs=(" _  $LTS(..canReferTo) _ ")"	
	}
	if ..isXmlAttr = 1 {
		Set str = str _ ", XmlAttr"
	}
	if ..noExtensions = 1 {
		Set str = str _ ", NoExtns"
	}
	if ..valueSetUrl {
		Set str = str _ ", vs:" _ ..valueSetStrength _ ": " _ ..valueSetUrl 
		
	}
	Set str = str _ "]"
	return str
}

}
