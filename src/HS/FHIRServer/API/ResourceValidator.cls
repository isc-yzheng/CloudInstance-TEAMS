Class HS.FHIRServer.API.ResourceValidator Extends %RegisteredObject [ Abstract ]
{

Method %OnNew(pSchema As HS.FHIRServer.Schema) As %Status [ Abstract ]
{
}

/// @API
/// ValidateResource validates a FHIR Resource.  If a validation error is found, a
/// compound %Status is thrown in a StatusException.  The compound %Status starts with a
/// $$$ValidationFailure code, followed by additional %Status objects for each detected
/// validation error.
/// Inputs:
/// <li>pJsonResource           : (required) %DynamicObject representation of the FHIR resource.
/// <li>Throws					: A StatusException containing a compound %Status representing all
///                             : validation errors.
Method ValidateResource(pResourceObject As %DynamicObject) [ Abstract ]
{
}

}
