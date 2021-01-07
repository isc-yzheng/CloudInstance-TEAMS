Include HS.FHIRServer

/// Helper Class that creates Bundle resources as directed
Class HS.FHIRServer.Util.Bundle [ Abstract ]
{

/// API
/// StartBundleStream writes to a stream object the first standard elements of a FHIR Bundle resource: type, total, link.<br>
/// This method is intended to be used in conjunction with the methods AddBundleEntryToStream and EndBundleStream.
/// <br>
/// Input:<br>
/// <li>pIdentifier   : A CodeableConcept JSON Object representing a unique identifier (Not Used Yet)
/// <li>pType         : (required) Bundle type.
/// <li>pTotal        : If search, the total number of matches.
/// <li>pUrls         : A Multidimensional Array mapping link relationship to URL
///                     pUrls(relationship) = url.  Possible relationship values are:
///                     "first", "previous", "self", "next", and "last"
/// <li>Returns: A Bundle JSON Object
ClassMethod CreateBundle(pIdentifier As %DynamicObject, pType As %String, pTotal As %String, ByRef pUrls, pSchema As HS.FHIRServer.Schema) As %DynamicObject
{
	#dim bundle as %DynamicObject = $$$NewJSONObject
	Set bundle.resourceType = "Bundle"
	Set bundle.id = $ZConvert($SYSTEM.Util.CreateGUID(),"L")
	Set bundle.type = pType
	if +$Extract(pSchema.FHIRVersion) > 3 {
		Set bundle.timestamp = $ZDateTime($Horolog, 3, 7)
	}
	
	if (pIdentifier '= "") {
		Set bundle.identifier = pIdentifier
	}
	if (pTotal '= "" ) {
		Do bundle.%Set("total", pTotal, "number")	
	}
	if $D(pUrls) > 9 {
		Set links = $$$NewJSONArray
		for relation = "first", "previous", "self", "next", "last" {
			if ($D(pUrls(relation), urlValue) = 1) {
				Set link = $$$NewJSONObject
				Do links.%Push(link)
				Set link.relation = relation
				Set link.url = urlValue
			}
		}
		if (links.%Size() > 0) {
			Set bundle.link = links
		}
	}
	Set bundle.entry = $$$NewJSONArray
	Quit bundle
}

/// AddBundleEntry adds a Bundle entry to an existing Bundle JSON Object<br>
/// <br>
/// Input:<br>
/// <li>pFullUrl         : [optional] Bundle entry fullUrl value.
/// <li>pResource        : [optional] The resource for this entry (if any) as a JSON Object
/// <li>Returns: A Bundle.Entry JSON Object
ClassMethod AddBundleEntry(pBundle As %DynamicObject, pFullUrl As %String = "", pResource As %DynamicObject = "", pMode As %String = "") As %DynamicObject
{
	#dim entry As %DynamicObject = $$$NewJSONObject
	Do pBundle.entry.%Push(entry)
	
	if (pFullUrl '= "") {
		Set entry.fullUrl = pFullUrl
	}
	if (pResource '= "") {
		Set entry.resource = pResource	
	}
	if (pMode '= "") {
		Set entry.search = $$$NewJSONObject
		Set entry.search.mode = pMode
	}
	return entry
}

/// @API Finalize the bundle by ensuring that the object does not contain
/// an empty 'entry' array.
ClassMethod FinalizeBundle(pBundle As %DynamicObject) As %DynamicObject
{
	if pBundle.entry && 'pBundle.entry.%Size() {
		Do pBundle.%Remove("entry")
	}
	return pBundle
}

}
