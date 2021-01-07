Include HS.FHIRMeta

Class HS.FHIRMeta.API Extends %RegisteredObject
{

/// A FHIRPath API Instance
Property FHIRPathAPI As HS.FHIRPath.API [ Calculated ];

/// The MetadataSet Key for this metadata collection
Property FHIRMetadataSetKey As %String [ Calculated ];

/// The MetadataSet Key for this metadata collection
Property PackageList As %List [ Calculated ];

/// The FHIR Version supported by this metadata collection
Property FHIRVersion As %String [ Calculated ];

Parameter ImplementationClass As %String = "HS.FHIRMeta.Impl.Impl";

ClassMethod getInstance(mdSetKey As %String, globalRoot As %String = "")
{
	return $ClassMethod(..#ImplementationClass,"%New", ##class(HS.FHIRMeta.Storage.Package).MapPopularName(mdSetKey), globalRoot)
}

/// API
/// IsValidResourceType validates the specified resource type against this Schema, returning a %Boolean
/// <br>
/// Input:<br>
/// <li>pResourceType       : (required) FHIR resource type.
/// <br><br>
/// Output:<br>
/// Return: a %Boolean - 0 = Is not a valid resource type as per the specified schema, 1 = Is valid.
Method IsValidResourceType(pResourceType As %String) As %Boolean [ Abstract ]
{
}

/// API
/// IsSharedResourceType Indicates whether a resourceType is or can reference a Patient
/// <br>
/// Input:<br>
/// <li>pResourceType       : (required) FHIR resource type.
/// <br><br>
/// Return: a %Boolean - 1 if shared (no patient references), 0 if unshared
Method IsSharedResourceType(pResourceType As %String) [ Abstract ]
{
}

/// API
/// IsA Indicates whether a specified type is an instance of an ancestor class
/// <br>
/// Input:<br>
/// <li>pTypeName       : (required) FHIR type.
/// <li>pAncestorName   : (required) FHIR type.
/// <br><br>
/// Return: a %Boolean - 1 pTypeName is identical to or a subclass of pAncestorName
Method IsA(pTypeName As %String, pAncestorName As %String) [ Abstract ]
{
}

/// API
/// Returns a %List of Compartment names that a specific resource is a member of
Method GetCompartmentsForResource(pResourceObj As %DynamicObject) As %List [ Abstract ]
{
}

/// API
/// <br>Returns the instance of HS.FHIRMeta.SearchParam for the specified resourceType and parameter code.
/// Query parameters that do not refer to resource content (e.g. _count, etc) are not
/// considered Search Parameters and will not be found.
/// <br>@Input resourceType - The type of the Resource that the parameter applies to
/// <br>@Input pParamName - The name of the parameter as used in a FHIR query (the code property)
/// <br>@Return: If found, the corresponding HS.FHIRMeta.SearchParam, otherwise and empty string (null).
Method FindSearchParam(resourceType As %String, pParamName As %String) As HS.FHIRMeta.SearchParam [ Abstract ]
{
}

/// API
/// <br>Use this method to enumerate the set of resource types support search parameters.  
/// <br>@Input prevType - The resource type previously returned by this method, or "" to obtain the first resource type in the set
/// <br>@Return: The next resource type in the set, or "" if the entire set has been traversed.
Method NextSearchParamResourceType(prevType As %String) As %String [ Abstract ]
{
}

/// API
/// <br>Use this method to enumerate the set of search parameter names supported for the specified resource type..  
/// <br>@Input resourceType - The type of the Resource that the parameter applies to
/// <br>@Input prevName - The parameter name previously returned by this method, or "" to obtain the first name in the set
/// <br>@Return: The next parameter name in the set, or "" if the entire set has been traversed.
Method NextSearchParamName(resourceType As %String, prevName As %String) As %String [ Abstract ]
{
}

/// API
/// <br>Use this method to enumerate the set of search parameters supported for the specified resource type.  If only
/// names of parameters are needed, use the NextSearchParamName instead.
/// <br>@Input resourceType - The type of the Resource that the parameter applies to
/// <br>@Input prevParam - The parameter previously returned by this method, or "" to obtain the first parameter in the set
/// <br>@Return: The next parameter in the set, or "" if the entire set has been traversed.
Method NextSearchParamForResourceType(resourceType As %String, prevParam As HS.FHIRMeta.SearchParam) As HS.FHIRMeta.SearchParam [ Abstract ]
{
}

/// API
/// <br> Returns true (1) if the specified type is a valid FHIR type, otherwise false (0)
Method IsFHIRType(fhirType As %String) As %Boolean [ Abstract ]
{
}

/// <br> Returns the FHIR type of the superclass for the specified FHIR type.
Method GetSuperType(fhirType As %String) As %String [ Abstract ]
{
}

/// API
/// <br> Returns a %List of property names for the specified FHIR type.
Method GetPropertyNames(fhirType As %String) As %List [ Abstract ]
{
}

/// API
/// <br> Returns true if the specified fhirType has a property with the specified name
Method HasPropertyName(fhirType As %String, propName As %String) As %String [ Abstract ]
{
}

/// API
/// <br> Returns true if the specified property is required by the FHIR schema
Method IsPropertyRequired(fhirType As %String, propName As %String) As %Boolean [ Abstract ]
{
}

/// API
/// <br> Returns true if the specified property is represented as an Array in JSON.
Method IsPropertyArray(fhirType As %String, propName As %String) As %Boolean [ Abstract ]
{
}

/// API
/// <br> Returns a %List of the properties that are required by the FHIR schema for
/// the specified resource type.
Method GetRequiredProperties(fhirType As %String) As %List [ Abstract ]
{
}

/// API
/// <br> Returns the FHIR type of the specified property
Method GetPropertyFHIRType(fhirType As %String, propName As %String) As %String [ Abstract ]
{
}

/// API
/// <br> Returns an integer value that reflects the order of the property in the XML form
/// of the resource.  Note that the ordinals within a FHIR type may not be sequential.  For variant
/// properties, all variations will have the same ordinal.  For example in Patient, both 
/// multipleBirthBoolean and multipleBirthInteger have the same ordinal value (as does
/// multipleBirth).
Method GetPropertyOrdinal(fhirType As %String, propName As %String) As %Integer [ Abstract ]
{
}

/// API
/// <br> Returns the URL of the value set associated with the specified property.  Properties
/// with FHIR type of code, Coding, and CodeableConcept have associated value sets.
Method GetPropertyValueSetURL(fhirType As %String, propName As %String) As %String [ Abstract ]
{
}

/// API
/// <br> Returns the strength of the binding of the specified property to the value set ("required", 
/// "extensible", "preferred", or "example")
Method GetPropertyValueSetStrength(fhirType As %String, propName As %String) As %String [ Abstract ]
{
}

/// API
/// <br> Return a %List of allowed values for the value set associated with the specified
/// property.  NOTE: This will return an empty list unless the strength is "required".
Method GetPropertyValueList(fhirType As %String, propName As %String) As %List [ Abstract ]
{
}

/// API
/// <br> Returns an indicator of how to represent this property in Json.
/// <ul>
/// <li>"o" -> A child object
/// <li>"s" -> A string
/// <li>"n" -> A numeric value
/// <li>"b" -> A boolean value
/// <li>"c" -> A Variant root field name
/// <li>"x" -> XHTML formatted string
/// <li>"alias" -> An embedded resource
/// </ul>
/// <br> 
/// For variant fields, the base property name is labeled as "c", and the supported
/// specific typed properties are accessed using their type-inclusive names (names that actually
/// appear in a resource).  For example in the Patient resource, 'multipleBirth' will return "c", while
/// 'multipleBirthInteger' will return "n", and multipleBirthBoolean will return "b".
Method GetPropertyJSONType(fhirType As %String, propName As %String) As %String [ Abstract ]
{
}

/// API
/// <br> Returns a list of the allowable FHIR types for a variant property.  For example,
/// GetVariantTypes("Patient", "multipleBirth") will return $LB("boolean", "integer")
Method GetVariantTypes(fhirType As %String, propName As %String) As %List [ Abstract ]
{
}

/// API
/// <br>Returns a <code>RsrcIterator</code> object that will iterate through all
/// resources of the specified FHIR metadata resource type.  Supported metadata resource types
/// are StructureDefinition, CompartmentDefinition, SearchParameter, CodeSystem, and ValueSet
Method GetRsrcIterator(resourceType As %String) As HS.FHIRMeta.RsrcIterator [ Abstract ]
{
}

/// API
/// <br> This method retrieves a specific FHIR Metadata resource based on its URL.  If the URL 
/// includes a version specifier (ends with "|" followed by the version string), then the specific
/// resource version will be returned.  Otherwise, the version associated with this object's package
/// list will be returned.
Method GetMetadataResource(url As %String) As %DynamicObject [ Abstract ]
{
}

/// API
/// <br> This method returns a multi-dimensional array that contains the
/// code and associated display text for each code in the specified ValueSet
/// <br> @Input urlOrValueSet This may be the URL for a ValueSet resource, or the
/// ValueSet resource itself
/// <br> @Output codes A multidimensional array in the form
/// <br>codes(code-system, code) = display-text
Method ExpandValueSet(urlOrValueSet As %String, Output codes) [ Abstract ]
{
}

/// API
/// <br> This method returns a %List that contains the code and associated display text
/// for each code in the specified ValueSet  The list is ordered in the sequence that the
/// codes are defined in the ValueSet (which FHIR specifies may be meaningful).
/// <br> @Input urlOrValueSet This may be the URL for a ValueSet resource, or the
/// ValueSet resource itself
/// <br> @Return A %List containing a %List for each code-system containing a %List for each code.
/// The result is in the form of $LB(code-system, $LB(code, display-text))
Method ExpandValueSetAsList(urlOrValueSet As %String) As %List [ Abstract ]
{
}

/// API
/// <br> This method is intended for use in namespace configuration.  It "installs" the
/// packages that are shipped with a HealthShare release (from the disk to the database).
ClassMethod bootstrapMetadataSets(force As %Boolean = 0)
{
	do ##class(HS.FHIRMeta.Impl.Base).bootstrap(force)
}

}
