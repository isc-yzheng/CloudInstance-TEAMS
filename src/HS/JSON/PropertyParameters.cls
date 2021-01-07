/// Property superclass used to hold information about property parameters for HS.JSON.Adaptor.
Class HS.JSON.PropertyParameters [ System = 2 ]
{

/// This is the JSON property element name to be used for this property.
Parameter JSONNAME As STRING;

/// The type of JSON projection for this property. "NONE" or "PROPERTY".
Parameter JSONPROJECTION As STRING [ Constraint = ",NONE,PROPERTY", Flags = ENUM ];

/// For an object property, this specifies that instead of writing out the referenced object,
/// we will instead write out the value of one (summary) property within the object.<br/>
/// This is ignored for non-object properties.
Parameter JSONSUMMARY As STRING;

}
