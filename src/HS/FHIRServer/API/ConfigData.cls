Class HS.FHIRServer.API.ConfigData Extends (%RegisteredObject, %JSON.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD As BOOLEAN = 1;

/// A Comma separated list of IDs of Metadata package in force for this instance.
Property FHIRMetadataSet As %String(%JSONFIELDNAME = "fhir_metadata_set", MAXLEN = "");

/// ((Deprecated - replaced by FHIRMetadataSet)
Property FHIRVersion As %String(%JSONFIELDNAME = "fhir_version");

/// The classname of the InteractionsStrategy class for this instance
Property InteractionsStrategyClass As %String(%JSONFIELDNAME = "interactions_strategy_class", MAXLEN = 256);

/// The name of a security resource that the user must hold in order to use the service.  If not specified, then
/// any authenticated user may use the service. 
Property RequiredResource As %String(%JSONFIELDNAME = "required_resource", MAXLEN = 256);

/// The search result page size to use when no _count parameter is specified on search.
Property DefaultSearchPageSize As %Integer(%JSONFIELDNAME = "default_search_page_size");

/// The maximum search result page size to prevent excessive user specified page size.
Property MaxSearchPageSize As %Integer(%JSONFIELDNAME = "max_search_page_size");

/// The maximum number of resources that can be selected by a search before
/// the server will simply respond to the query with an error. This number does
/// not include resources included via an _include parameter, only resources
/// selected by the actual search. This value does not affect the size of pages
/// returned by a search. The reason for not setting this value arbitrarily
/// high is because overly broad searches that select large numbers of
/// resources take a lot of system resources to fulfill, and are probably more
/// broad than the client actually needs. In this case, the client should
/// narrow their search.
Property MaxSearchResults As %Integer(%JSONFIELDNAME = "max_search_results");

/// The maximum allowable number of resources to delete via conditional delete. If the
/// conditional delete search finds more than this number of resources then the conditional
/// delete as a whole is rejected with an HTTP 412 Precondition Failed error.
Property MaxConditionalDeleteResults As %Integer(%JSONFIELDNAME = "max_conditional_delete_results");

/// This is the maximum number of seconds between requests on service
/// before any session data is considered stale.<br><br>
Property FHIRSessionTimeout As %Integer(%JSONFIELDNAME = "fhir_session_timeout");

/// This property specifies the default value for the Http Prefer Header in the form of
/// <br>Prefer:handling=<value>
/// <br>This value will be used if the header is not present.  If this property is not set,
/// the service defaults to "lenient" which ignores unknown query parameters.  Set this value to
/// "strict" if you want the presence of an unknown query parameter to be treated as an error.
Property DefaultPreferHandling As %String(%JSONFIELDNAME = "default_prefer_handling");

/// This property specifies several debugging options as bit-flags.  The bits are combined into
/// a numeric value.
/// <br> 1: Include a Traceback in any OperationOutcome response that is reporting an error
/// <br> 2: Create a new instance of the service on each REST request.  This is needed when editing custom
/// interactions or operations, otherwise the code will be reused and changes will not become active.  (This is the equivalent
/// of stopping and starting a Production after a code change).
/// <br> 4: Allow Unauthenticated access to the service.  DO NOT USE IN PRODUCTION.  This flag disables all authorization checks.
Property DebugMode As %Integer(%JSONFIELDNAME = "debug_mode");

Method AsJSONString() As %String
{
	$$$ThrowOnError( ..%JSONExportToString(.json) )
	return json
}

ClassMethod FromJSON(json As %DynamicObject) As ConfigData
{
	set configData =..%New()
	$$$ThrowOnError( configData.%JSONImport(json) )
	return configData
}

}
