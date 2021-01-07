Include (%cspBuild, HS.FHIRServer)

Class HS.FHIRServer.Service Extends (%RegisteredObject, HS.FHIRServer.API.Service, HS.FHIRServer.Util.Bundle, HS.HC.Util.Trace.Helper)
{

// The Configuration Data controlling this service 

Property ConfigData As HS.FHIRServer.API.ConfigData [ Calculated ];

/// The MetadataResource being enforced by this instance
Property MetadataResource As %DynamicObject [ Transient ];

/// The 'schema' node of the SchemaMetadata
Property Schema As HS.FHIRServer.Schema [ Calculated ];

/// The Rest object that has mode='server'
Property RestServerMeta As %DynamicObject [ Transient ];

Property strategy As HS.FHIRServer.API.InteractionsStrategy [ Calculated ];

Property interactions As HS.FHIRServer.API.Interactions [ Calculated ];

Property resourceValidator [ Transient ];

Property RestResourceMap As %DynamicObject [ Transient ];

Property ErrorToHttp [ MultiDimensional, Transient ];

Property RestUrlMap [ MultiDimensional, Transient ];

Parameter INVOCATION = "Queue";

Parameter QUERYIDPARAM = "queryId";

Parameter QUERYPAGEPARAM = "page";

/* ---------- Calculated Properties ------------- */
/// The 'schema' node of the SchemaMetadata
Property %Schema As HS.FHIRServer.Schema [ Private ];

Property %strategy As HS.FHIRServer.API.InteractionsStrategy [ Private ];

Property %interactions As HS.FHIRServer.API.Interactions [ Private ];

Property %ConfigData As HS.FHIRServer.API.ConfigData [ Private ];

Method SchemaGet() As HS.FHIRServer.Schema [ CodeMode = expression ]
{
..%Schema
}

Method strategyGet() As HS.FHIRServer.API.InteractionsStrategy [ CodeMode = expression ]
{
..%strategy
}

Method interactionsGet() As HS.FHIRServer.API.Interactions [ CodeMode = expression ]
{
..%interactions
}

Method ConfigDataGet() As HS.FHIRServer.API.ConfigData [ CodeMode = expression ]
{
..%ConfigData
}

/// @API
/// Called after the service is created to set the configuration.  
/// TODO: This could be a constructor parameter, if that works with Unit Testing and Mocking
Method Configure(serviceInstance As HS.FHIRServer.ServiceInstance)
{
	Set startTime = $ZTS
	

	
	// Force rebuild of the status mapping
	kill %FHIRServerStatusMap

	// Capture Option Values
	$$$FSLog("User = "_$Username_", Roles: "_$Roles)

	Set ..%strategy = serviceInstance.CreateStrategy()
	if '$IsObject(..%strategy) {
		$$$ThrowFHIR($$$GeneralError, "Unable to create Storage Strategy Class " _ storageStrategyClass)
	}
	Set ..%interactions = ..%strategy.NewInteractionsInstance()
	
	Set ..%ConfigData = ..%strategy.GetServiceConfigData()
	
	/// Load the Schema Metadata
	Set ..%Schema = ..%strategy.schema

	Set ..resourceValidator = $classmethod(..%interactions.#ResourceValidatorClass, "%New", ..%Schema)

	// In STU3+ the resource type is CapabilityStatement.
	Do ..LoadMetadata()
	
	// Populate our Rest URLMap for dispatch processing
	Do ..initRestUrlMap()

	Set endTime = $ZTS

	Set diff = $Piece(endTime,",",2) -  $Piece(startTime,",",2)
	if diff < 0  Set diff = diff + 86400.0
	$$$FSLog("Service Configured in "_diff_" secs")

	Quit $$$OK
}

/// Map
/// From (verb, pattern)
///    pattern key:  h:_history, s:_search, v:_validate, m:metadata, 
///                  *:*, +:<value>, -:<not used>, $:<operation name>
/// To: (operationName, targetFields, handlerMethod)
///     targetFields key:  c:Container, t:Type, i:Id, *:Type, -:<none>
Method initRestUrlMap()
{
	Set ..RestUrlMap("GET","h---") = $LB("history-system", "", "History", "r")
	Set ..RestUrlMap("GET","m---") = $LB("capabilities", "", "Metadata", "")
	Set ..RestUrlMap("GET","----") = $LB("search-system", "", "Search", "r")
	Set ..RestUrlMap("GET","+---") = $LB("search-type","t", "Search", "r")
	Set ..RestUrlMap("GET","+++-") = $LB("search-type","cit", "Search", "r")
	Set ..RestUrlMap("GET","++*-") = $LB("search-type","ci*", "Search", "r")
	Set ..RestUrlMap("GET","+h--") = $LB("history-type","t", "History", "r")
	Set ..RestUrlMap("GET","++h-") = $LB("history-instance","ti", "History", "r")
	Set ..RestUrlMap("GET","++h+") = $LB("vread","ti-v", "Read", "r")
	Set ..RestUrlMap("GET","++--") = $LB("read","ti", "Read", "r")
	Set ..RestUrlMap("GET","++$-") = $LB($$$ReqScopeInstance,"tio", "Operation", "r")
	Set ..RestUrlMap("GET","+$--") = $LB($$$ReqScopeType,"to", "Operation", "r")
	Set ..RestUrlMap("GET","$---") = $LB($$$ReqScopeSystem,"o", "Operation", "r")
	Set ..RestUrlMap("PATCH","++--") = $LB("patch","ti", "Patch", "w")
	Set ..RestUrlMap("PATCH","+---") = $LB("patch","t", "ConditionalPatch", "w")
	Set ..RestUrlMap("POST","s---") = $LB("search-system", "", "Search", "r")
	Set ..RestUrlMap("POST","----") = $LB("transaction", "", "Batch", "r")
	Set ..RestUrlMap("POST","+s--") = $LB("search-type","t", "Search", "r")
	Set ..RestUrlMap("POST","+---") = $LB("create","t", "Create", "w")
	Set ..RestUrlMap("POST","++$-") = $LB($$$ReqScopeInstance,"tio", "Operation", "r")
	Set ..RestUrlMap("POST","+$--") = $LB($$$ReqScopeType,"to", "Operation", "r")
	Set ..RestUrlMap("POST","$---") = $LB($$$ReqScopeSystem,"o", "Operation", "r")
	Set ..RestUrlMap("PUT","++--") = $LB("update","ti", "Update", "w")
	Set ..RestUrlMap("PUT","+---") = $LB("update","t", "ConditionalUpdate", "w")
	Set ..RestUrlMap("DELETE","++--") = $LB("delete","ti", "Delete", "w")
	Set ..RestUrlMap("DELETE","+---") = $LB("delete","t", "Delete", "w")
}

/// @API
/// StreamToJSON is a helper method intended for use by callers of the service
/// to convert an input stream to a JSON object.
Method StreamToJSON(pStream As %Stream.Object, pContentCode As %String) As %DynamicObject
{
	if 'pStream.Size {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrAPIContractViolation, "Blank FHIR stream specified") )
	}
	
	if ((pContentCode = $$$FHIRContentCodeJSON ) || (pContentCode = $$$FHIRContentCodeJPatch)) {
		Set json = ##class(HS.FHIRServer.Util.JsonHelper).FromJSON(pStream)
		Return json
	} elseif (pContentCode = $$$FHIRContentCodeXML ) {
		// Skip the <?xml ... ?> header of any
		// If the request body is XML, strip off the XML prolog, if present.
		// Any encoded characters have already been converted to internal format
		// (by virtue of having CONVERTINPUTSTREAM=1). Having the XML prolog, if it
		// contains "encoding='UTF-8'", will cause XML parsing to error, as it will
		// try to convert the already-converted characters.
		If (pStream.Read(5) = "<?xml") {
			// Has a prolog, read to the end of it.
			While ('pStream.AtEnd) && (pStream.Read(1) '= ">")  { }
			// Write a new stream from the remainder of the original stream.
			Set tempStream = ##class(%Stream.TmpCharacter).%New()
			While ('pStream.AtEnd)  {
				Do tempStream.Write(pStream.Read())
			}
		} Else {
			Set tempStream = pStream
		}
		Do tempStream.Rewind()
		Return ##class(HS.FHIRServer.Util.XMLToJSON).XMLToJSON(.tempStream, ..%Schema)
	} else {
		$$$ThrowFHIR($$$HSFHIRErrInvalidContentCode, pContentCode)
	}
}

/// LoadMetadata finds the Conformance resources currently in the resource repository
/// and loads them into the CapabilityStatements array, indexed by resource id, each as
/// an %XML.XPATH.Document object.
Method LoadMetadata() [ Internal ]
{
	Set metadataResource = ..%interactions.LoadMetadata()
	if metadataResource '= ..MetadataResource {
		$$$FSLog( "Reloading Metadata Resource, version = " _ metadataResource.meta.versionId)
		// cache the metadata resource
		Set ..MetadataResource = metadataResource
		// Find the 'rest' object that has 'mode'='server'
		Set restArray =..MetadataResource.rest
		Set raMax = $Select(restArray="":0, 1:restArray.%Size())-1
		for ord=0:1:raMax {
			if restArray.%Get(ord).mode="server" {
				set ..RestServerMeta = restArray.%Get(ord)
				Quit
			}
		}
		if ..RestServerMeta="" {
			$$$ThrowFHIR($$$GeneralError, "Metadata does not have a 'rest' object with mode='server'")
		}
		// Build a map of (ResourceType => Resource Capabilities Object)
		Set ..RestResourceMap = $$$NewJSONObject
		Set iter = ..RestServerMeta.resource.%GetIterator()
		while iter.%GetNext(.key , .value ) {
			//$$$FSLog(value.type_"=>"_value)
			Do ..RestResourceMap.%Set(value.type, value)
		}
	}
}

/// @API
/// This is the main dispatcher for FHIR Requests.
Method DispatchRequest(pRequest As HS.FHIRServer.API.Data.Request, Output pResponse As HS.FHIRServer.API.Data.Response)
{
	if ##class(HS.FHIRServer.ServiceAdmin).IsInstanceDecommissioned(..InstanceKey) {
		$$$ThrowFHIR($$$HSFHIRErrServiceDecommissioned,$$$OutcomeIs(503, "error", "no-store"))
	}
	$$$FSLog("BaseURL: "_ pRequest.BaseURL)
	$$$FSLog("ReqPath: "_ pRequest.RequestPath)
	$$$FSLog("Query  : "_ pRequest.QueryString)
	if $$$FSLogIsActive($$$FSChannelGeneral) {
		If ..IsRequestAuthenticated() {
			Try {
				$$$FSLog("%Username: "_ pRequest.Username)
				$$$FSLog("%Roles   : "_ pRequest.Roles)
			} Catch fslogEx {
				$$$FSLog("%Username: (insufficent privilege to access %Username)")
				$$$FSLog("%Roles   : (insufficent privilege to access %Roles)")
			}
		} Else {
			$$$FSLog("%Username: (unauthenticated, cannot access %Username)")
			$$$FSLog("%Roles   : (unauthenticated, cannot access %Roles)")
		}
	}
	Set startTime = $ZH
	#dim tException
	Try {
		// Check if the metadata has changed
		Do ..LoadMetadata()
		
		Set pResponse = pRequest.NewResponse()
		
		// First check if we have been disabled
		if '##class(HS.FHIRServer.ServiceAdmin).IsInstanceEnabled(..InstanceKey) {
			$$$ThrowFHIR($$$HSFHIRErrServiceDisabled,$$$OutcomeIs(503, "error", "disabled"))
		}
		
		
		Set handlerMethod = ..ParseRequestInputs(pRequest)
		if handlerMethod=""  {
			Set pResponse.Status = 404
			return
		}
		
		// Process the '_pretty' query parameter
		Do pRequest.Parameters.GetParameters("_pretty", .params)
		Set pResponse.IsPrettyOut = 0
		if (params > 0 ) {
			// TODO: Do we care if there are more than one of these?  Yes, R4 requires true/false
			//       Could be stricter here.
			Set pResponse.IsPrettyOut = $Case(params(1).value, "1":1, "0":0, "true":1, "false":0, :0)
		}
		
		// Update OAuth token handler object with current OAuth Token info.
		Do ..%interactions.oauth2TokenHandler.SetInstance(pRequest.AdditionalInfo.GetAt("USER:OAuthToken"), pRequest.AdditionalInfo.GetAt("USER:OAuthClient"), pRequest.BaseURL, pRequest.Username)

		// Give the Interactions handler an opportunity to prepare for a top-level request
		if 'pRequest.IsRecursive {	
			Do ..%interactions.OnBeforeRequest($this, pRequest, ..%ConfigData.FHIRSessionTimeout)
		}
		
		// 
		$$$FSLog("Dispatch interaction "_pRequest.Interaction_" for "_ pRequest.RequestPath)
		Do $Method($this, handlerMethod, pRequest, pResponse)

	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
		$$$FSLog("Exception after "_pRequest.Interaction_".  status "_tStatus_", resp.Status"_pResponse.Status)
		//$$$FSLog($System.Status.DisplayError(tEx.AsStatus()))
		Do tEx.StackAsArray(.stack)
		for ord=$Get(stack,0):-1:1 { $$$FSLog("  ["_ord_"] -> "_$get(stack(ord))_" "_$get(stack(ord, "PLACE"))) }
		Do ..SetStatusResponse(pResponse, tStatus)
	}
	if 'pRequest.IsRecursive {	
		Do ..%interactions.OnAfterRequest($this, pRequest, pResponse)
	}
	
	Set endTime = $ZH
	$$$FSLog("Request Completed in "_(endTime-startTime)_" secs: "_pRequest.RequestPath)
}

ClassMethod IsRequestAuthenticated()
{
	return $USERNAME '= "UnknownUser"
}

Method ParseRequestInputs(pRequest As HS.FHIRServer.API.Data.Request) As %Boolean [ Internal ]
{
	#dim handlerMethod as %String = ""
	
	// Parse the Verb and Path according to the FHIR REST spec
	Set tUrl = pRequest.RequestPath
	Set tVerb = $SELECT(pRequest.RequestMethod ="HEAD":"GET", 1:pRequest.RequestMethod)

	If $Extract(tUrl)="/" Set tUrl = $Extract(tUrl, 2, *)
	If $Extract(tUrl, *)="/" Set tUrl = $Extract(tUrl, 1, *-1)
	Set partCount = $Length(tUrl, "/")
	if partCount > 4 {
		return handlerMethod
	}
	Set key = ""
	Set parts = ""
	for ord=1:1:4 {
		Set part = $Piece(tUrl, "/", ord)
		Set $List(parts,*+1) = part
		// Now encode the part as a single character for later pattern matching.
		Set key = key _ ..mapToKey(part, ord)
	}
	
	if $D(..RestUrlMap(tVerb, key), epMeta) = 0 {
		$$$FSLog("Cannot Dispatch Url: "_tVerb_" "_tUrl_"("_key_")")
		return handlerMethod
	}
	Set pRequest.Interaction = $ListGet(epMeta,1)
	Set fields = $ListGet(epMeta,2)
	Set handlerMethod = $ListGet(epMeta,3)
	Set privilege = $ListGet(epMeta,4)
	
	
	// Save the privilege level needed for the operation.  Used later for
	// OAuth authorization checks
	Do pRequest.AdditionalInfo.SetAt(privilege, "USER:PrivilegeNeeded")
	if (privilege '= "") {
		
		// If privilege is empty, then no authorization is required
		if ..%ConfigData.RequiredResource '= "" {
			// Validate authorization against the resource specified in the Configuration
			Set isNoAuthAllowed = (..%ConfigData.DebugMode \ $$$FHIRDebugAllowNoAuthCheck # 2)
			Set privilege = $Case(privilege, "r":"READ", "w":"WRITE")
			If 'isNoAuthAllowed && '$System.Security.Check(..%ConfigData.RequiredResource,privilege) {
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
			}
		}
	}
	
	for ord=1:1:$Length(fields) {
		Set c = $E(fields,ord)
		if (c="t") || (c = "c") {
			// This parameter must be a Resource Type, Validate it
			Set resourceType = $LG(parts,ord)
			// Return 404 Not Found as a response when invalid resource is specified.
			// "invalid" includes invalid resource type.
			if '..%Schema.IsValidResourceType(resourceType) {
				// Invalid resource type is a case where we don't want to return diagnostic info.
				$$$ThrowFHIR($$$HttpOnlyResponse(404))
			}
			
			// Return 404 Not Found as a response when the valid resource type is
			// not supported in the Capabilities statement
			If ..RestResourceMap.%Get(resourceType) = "" {
				$$$ThrowFHIR($$$HSFHIRErrResourceNotSupported, resourceType, $$$OutcomeNotSupported(404))
			}
			if c="t" {
				Set pRequest.Type = resourceType
			} else {
				Set pRequest.Compartment = resourceType
			}
		}
		elseif c="i" { 
			// This is a Resource Id, Validate it
			Set pRequest.Id = ..RequireValidId($LG(parts,ord))
		} elseif c="o" { 
			Set pRequest.OperationScope = pRequest.Interaction
			Set pRequest.Interaction = "operation"
			Set operationName = $Extract($LG(parts,ord), 2, *) 
			// Operation name must start with lower-case and contain lower, number or dash
			if ($Extract(operationName)'?1L) || ($Translate(operationName,"-0123456789abcdefghijklmnopqrstuvwxyz") '= "") {
				$$$ThrowFHIR($$$HSFHIRErrInvalidOperationName, operationName, $$$OutcomeIs(400, "error", "invalid"))
			}
			Set pRequest.OperationName = operationName
		}
		elseif c="v" { 
			Set pRequest.VId = ..RequireValidId($LG(parts,ord))
		} elseif c="*" { 
			Set pRequest.Type = c
		}
	}
	
	// Process the Query String into a QueryParameters Object and identify any
	// registered Search Parameters for the requested type
	// Use the base 'Resource' as the Type if no resource type was provided.  This will limit
	// valid parameters to the shared cross-resource parameters
	Set tResourceType = $Select(pRequest.Type="":"Resource", 1: pRequest.Type)
	Set pRequest.Parameters = ##class(HS.FHIRServer.API.Data.QueryParameters).CreateFromQueryString(pRequest.QueryString, ..%Schema, tResourceType)
	/// If Prefer:handling=strict, then throw
	If ..IsPreferStrictHandling(pRequest) {
		$$$ThrowOnError(pRequest.Parameters.status)
	}
	return handlerMethod
}

ClassMethod mapToKey(part As %String, num As %Integer) [ Private ]
{
	if num = 1 {
		if (part = "metadata") return "m"
		if (part = "*") return "*"
	}
	
	if part = "*" return "*"
	if ($Extract(part) = "$") return "$"
	return $Case(part,
		"": "-",
		"_history":"h",
		"_search":"s",
		"_validate":"v",
		:"+")
}

Method SetStatusResponse(pResponse As HS.FHIRServer.API.Data.Response, tStatus As %Status)
{
	Set pResponse.Json = ##class(HS.FHIRServer.Util.Outcome).CreateFromStatus(tStatus, .httpStatus)
	Set pResponse.Status = httpStatus
}

Method Metadata(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	set tBase = pRequest.BaseURL
	set tQueryURL = ..GetFullRequestURL(pRequest) 
	Set pResponse.Json = ..MetadataResource
	Set ..MetadataResource.url = tBase _ "/metadata"
	if ..MetadataResource.implementation '= "" {
		Set ..MetadataResource.implementation.url = tBase
	}
	$$$FSLog("Got Meta version: "_..MetadataResource.meta.versionId_", time: "_..MetadataResource.meta.lastUpdated)
	Set pResponse.Status = 200
}

/// Batch processes a FHIR batch or transaction interaction.  The payload
/// of a batch or transaction interaction is a FHIR Bundle (with type = "bundle" or "tranaction" respectively.
Method Batch(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{

	// Assert that this system level interaction is allowed as per the Conformance/CapabilityStatement.
	Do ..RequireAllowedSystemInteraction(pRequest.Interaction)

	// Ensure that there is a JSON Payload
	Do ..RequirePayload(pRequest)
	
	Do ..interactions.Batch($this, pRequest, pResponse)
}

Method Create(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	#dim resourceIn As %DynamicObject
	#dim resourceOut As %DynamicObject = ""
	Set resourceType = pRequest.Type
	Do {
		// Put code into a block so that we can use Quit for an orderly exit
		// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
		Do ..RequireAllowedResourceInteraction(resourceType, pRequest.Interaction)

		// Get the Resource
		Set resourceIn = pRequest.Json

		// Ensure that there is a JSON Payload
		Do ..RequirePayload(pRequest)
		
		// Do schema-based validation on the resource.  Throws on error.
		Do ..resourceValidator.ValidateResource(resourceIn)

		// Assert that the type of the given resource matches the named type in the request.
		If (resourceIn.resourceType '= resourceType) {
			$$$ThrowFHIR($$$HSFHIRErrPayloadTypeMismatch, resourceIn.resourceType, resourceType, $$$OutcomeInvalid(400))
		}

		// FHIR Spec: The resource does not need to have an id element (this is one of the few cases where a resource exists
		//  without an id element). If an id is provided, the server SHALL ignore it.
		If resourceIn.id'="" {
			Do resourceIn.%Remove("id")
		}

		// FHIR Spec: If the request body includes a meta, the server SHALL ignore the
		// existing versionId and lastUpdated values.
		If resourceIn.meta'="" {
			Do resourceIn.meta.%Remove("versionId")
			Do resourceIn.meta.%Remove("lastUpdated")
		}
		
		// If an OAuth 2.0 access token was provided with this request, verify
		// that the proposed resource to create is allowed per the token. This
		// will Throw if the create is not allowed.
		Do ..%interactions.oauth2TokenHandler.VerifyResourceContent(resourceIn, ..GetPrivFromRequest(pRequest), 1)
		
		// Get the If-None-Exist search string value for conditional create, and include
		// it in the parameters that get passed to the storage class.  As of 11/30/2017,
		// conditional create is not supported, but at least we have a place for it in
		// this code infrastructure.
		Set tIfNoneExist = pRequest.IfNoneExist
		if tIfNoneExist '= "" {
			// Returns a resource if the conditional clause identifies an exising resource, or
			// null ("") if no matches were found
			Set resourceOut = ..ConditionalCreate(resourceType, tIfNoneExist)	
		}

		// Spec for conditional-create matchin
		// No matches: The server processes the create as above
		// One Match: The server ignores the post and returns 200 OK
		// Multiple matches: The server returns a 412 Precondition Failed error indicating the client's
		// criteria were not selective enough
		if resourceOut '="" {
			// There was a single match so return the proper status code
			Set pResponse.Status = 200
		} else {
			// Create a new resource from the input
			Set newId = ..%interactions.Add(resourceIn)
			set resourceOut = resourceIn

			// Spec for successful Create: The server returns a 201 Created HTTP status code,
			// and SHALL also return a Location header which contains the
			// new Logical Id and Version Id of the created resource version:
			Set pResponse.Status = 201
		}

		Set tResourceVId = resourceOut.meta.versionId
		Set tLastModified = resourceOut.meta.lastUpdated
		// Convert Last Modified to a format appropriate for the "Last-Modified" header.
		// Example of the target format is: "Fri, 01 Dec 2017 23:01:20 GMT"
		Set tLastModified = $$$cspHtoD($ZDTH(tLastModified,3,5))

		Set tLocation = ..GetRequestURLNoQuery(pRequest)_"/"_resourceOut.id_"/_history/"_tResourceVId
		Set pResponse.Location = tLocation
		Set pResponse.ETag = ..ETagValue(tResourceVId)
		Set pResponse.LastModified = tLastModified
		Set pResponse.Id = resourceOut.id
		Set pResponse.VId = tResourceVId

		// If the request has a "Prefer" header with value "return=representation", return the
		// resource as it was saved in the response payload.
		// If tPreferReturn is "representation", then it means that the request has asked
		// the server to return a copy of the resource that was saved.
		Set tPreferReturn = ..GetPreferHeader(pRequest, "return")
		If tPreferReturn="representation" {
			Set pResponse.Json = resourceOut
		}
		// Return the created resource's id in the FHIR Response
		Set pResponse.Id = resourceOut.id
		
	} while 0  // End of Code block
}

Method ConditionalCreate(pResourceType As %String, pIfNoneExistHeader As %String) As %Boolean [ Private ]
{
	#dim tIfNoneParameters as HS.FHIRServer.API.Data.QueryParameters = ""
	// For booleans, consider the item to be disallowed only when explictly so stated.
	// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#create says
	// "Servers that don't support the conditional create should return an HTTP 412
	// error and an operation outcome".
	Set tValue = ..IsCapabilitySupported(pResourceType, "conditionalCreate", 0)
	$$$FSLog("supported: "_tValue_", ver: "_ +$E(..%Schema.FHIRVersion))
	if tValue=0 {
		Set httpCode = $Select( ((+$E(..%Schema.FHIRVersion)) < 4):400, 1:412)
		$$$ThrowFHIR($$$HSFHIRErrConditionalCreateNotSupported, pResourceType, $$$OutcomeNotSupported(httpCode))
	}
	
	Set tIfNoneParameters = ##class(HS.FHIRServer.API.Data.QueryParameters).CreateFromQueryString(pIfNoneExistHeader, ..%Schema, pResourceType, 1)
	If (tIfNoneParameters.Count() = 0) {
		$$$ThrowFHIR($$$HSFHIRErrInvalidIfNoneExist, pIfNoneExistHeader)
	}
			
	#dim tResultSet as HS.FHIRServer.Util.SearchResult = ..%interactions.Search(pResourceType, "", "", tIfNoneParameters)
	
	if tResultSet.%Next() {
		// There is at least 1 result
		if tResultSet.%Next() {
			// There are at least 2 results ... fail
			$$$ThrowFHIR($$$HSFHIRErrIfNoneExistsFoundMultiple, pIfNoneExistHeader, $$$HttpIs(412))
		}
		// Return the resource that was uniquely found by the search parameters
		return ..%interactions.Read(tResultSet.ResourceType, tResultSet.ResourceId)
	}
	// No resources found, perform the normal create
	return ""
}

/// Note that both the "read" and "vread" interactions are handled by this method. The only difference
/// between the requests is that vread specifies a version, whereas read does not and is understood
/// to be requesting the current version.
Method Read(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
	Set interactionName = $Select(pRequest.VId="":"read", 1:"vread")
	Do ..RequireAllowedResourceInteraction(pRequest.Type, interactionName, pRequest.Interaction)

	// Load any _summary parameter info into the tSummary variable.
	Set tSummary = ""
	Set tKey = ""
	For {
		Set tParamItem = pRequest.Parameters.GetNext(.tKey)
		If tKey="" Quit
		If $Piece(tKey,":",1)="_summary" {
			Set tValue = $ListGet(tParamItem,1)
			If ((tValue="true")||(tValue="false")||(tValue="text")||(tValue="data")) {
				Set tSummary = tValue
			} Else {
				$$$ThrowFHIR($$$HSFHIRErrInvalidQueryParameterValue, "_summary", tValue)
			}
		}
	}

	/* ----
	NOTE: This is disabled but temporarily preserved as a marker until we prove that this "on-demand" feature can be
	handled by having a Strategy implemetation (e.g. ODS) subclass the Interactions object
	-------------------------------------------------------------
	// In the context of LoadPatientClass, we equate FHIR Patient resource id with HealthShare MPIID.
	If ..%ConfigData.LoadPatientClass'="" {
		If pRequest.Type="Patient" {
			Set tSC = $ClassMethod(..%ConfigData.LoadPatientClass, "LoadPatient", $this, pRequest.FHIRSessionKey, pRequest.Id)
			$$$ThrowOnError(tSC)
		}
	}
	*/

	Set privNeeded = ..GetPrivFromRequest(pRequest)
	
	// If an OAuth 2.0 access token was provided with this request, verify
	// that the request info does not indicate that the interaction is not
	// allowed per the token. This will Throw if the read is not allowed.
	Do ..%interactions.oauth2TokenHandler.VerifyResourceIdRequest(pRequest.Type, pRequest.Id, privNeeded)
	
	Set tResourceObject  = ..%interactions.Read( pRequest.Type, pRequest.Id, pRequest.VId)
	
	// If an OAuth 2.0 access token was provided with this request, verify
	// that the contents of the retrieved resource satisfy the scope(s)
	// and context of the token. This will Throw if the read was not allowed.
	Do ..%interactions.oauth2TokenHandler.VerifyResourceContent(tResourceObject, privNeeded, 1)
	
	Set tIsOK = ..%interactions.PostProcessRead(tResourceObject)
	If 'tIsOK {
		// If The post-processor says no, treat as not found.
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pRequest.Type, pRequest.Id, $$$OutcomeNotFound)
	}

	// If we get here we have a successful Read operation
	Set pResponse.Json = tResourceObject
	// Retrieve the resource meta object
	Set rsrcMeta = tResourceObject.meta
	If rsrcMeta '= "" {
		Set tLastModified = rsrcMeta.lastUpdated
		Set tResourceVId = rsrcMeta.versionId
		Set tLastModified = $$$cspHtoD($ZDTH(tLastModified,3,5))
	} Else {
		Set tResourceVId = ""
		Set tLastModified = ""
	}

	// According to the spec ETag should be 'W/"[versionId]"'
	Set pResponse.ETag = ..ETagValue(tResourceVId)
	Set pResponse.LastModified = tLastModified
	set tLocation = ..GetRequestURLNoQuery(pRequest)
	if pRequest.Interaction="read" set tLocation = tLocation_"/_history/"_tResourceVId
	Set pResponse.Location = tLocation

	Set pResponse.Status = 200
}

Method ConditionalUpdate(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Do ..Update(pRequest, pResponse, 1)
}

Method Update(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response, isConditional As %Boolean = 0)
{
	set pResponse.Id = pRequest.Id

	// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
	Do ..RequireAllowedResourceInteraction(pRequest.Type, pRequest.Interaction)

	// Ensure that there is a JSON Payload
	Set resourceIn =  ..RequirePayload(pRequest)
	Set resourceId = resourceIn.id
	Set resourceType = resourceIn.resourceType

	// Assert that the type of the given resource matches the named type in the request.
	If (resourceType '= pRequest.Type) {
		$$$ThrowFHIR($$$HSFHIRErrPayloadTypeMismatch, resourceType, pRequest.Type, $$$OutcomeInvalid(400))
	}
	
	// Do schema-based validation on the resource.  Throws on error.
	Do ..resourceValidator.ValidateResource(resourceIn)
	
	// If the request contains an If-Match header, assert that the value matches the current version ID of the resource
	// (Used for resource contention - see http://www.hl7.org/fhir/2015May/http.html#2.1.0.11)
	set tIfMatch = pRequest.IfMatch
	Set tIfMatchVersion = ""
	if (tIfMatch '= "") {
		// Assert that it is formatted correctly
		if (tIfMatch '? 1"W/""".E1"""") {
			$$$ThrowFHIR($$$HSFHIRErrInvalidIfMatch, tIfMatch, $$$OutcomeInvalid(405))
		}
		Set tIfMatchVersion = $Extract(tIfMatch,4,*-1)
	}

	// If tPreferReturn is "representation", then it means that the request has asked
	// the server to return a copy of the resource that was saved.
	Set tPreferReturn = ..GetPreferHeader(pRequest, "return")

	// updateCreate specifies whether the server allows update to create new identities
	// (i.e., resource for new resource id). Default to true (allowed) if not found in
	// the Conformance/CapabilityStatement.
	Set tUpdateCreate = ..IsCapabilitySupported(pRequest.Type, "updateCreate", 1)

	set tSearchParameters = pRequest.Parameters.ExtractSearchParameters()
	
	Set resourceIdToAssign = ""
	Set isUpdate = 1
	
	if 'isConditional {
		// Standard Update Request
		// If no id element is provided, or the id disagrees with the id in the URL, the server SHALL respond with an HTTP 400
		if (resourceId = "") || (pRequest.Id '= resourceId) {
			$$$ThrowFHIR($$$HSFHIRErrInvalidUpdateId, $$$OutcomeInvalid(400))
		}
		if tSearchParameters && tSearchParameters.Count() {
			$$$ThrowFHIR($$$HSFHIRErrInvalidUpdate, $$$OutcomeInvalid(400))
		}

		set rsrcMeta = ..%interactions.FindResourceMeta(resourceType, resourceId)
		if rsrcMeta = "" {
			if tUpdateCreate {
				// PUT to a unused url.  Request to force the resource Id.
				// Flag that this is a create (with caller-defined id)
				Set isUpdate = 0
				Set resourceIdToAssign = resourceId
			} else {
				$$$ThrowFHIR($$$HSFHIRErrNoCreateUpdate, resourceType, resourceId, $$$OutcomeIs(405, "error", "forbidden"))
			}
		} 
		if tIfMatchVersion '= "" {
			Set currentId = $$$RsrcMetaVersionId(rsrcMeta)
			if currentId '= tIfMatchVersion {
				Set httpCode = $Select( ((+$E(..%Schema.FHIRVersion)) < 4):409, 1:412)
				$$$ThrowFHIR($$$HSFHIRErrIfMatchViolation, tIfMatchVersion, currentId,$$$OutcomeIs(httpCode, "error", "concurrency"))
			}
		}

	} else {
		// Conditional Update Request
		// conditionalUpdate specifies whether the end point allows checking for the existence
		// of resources that match a given search criteria before updating.
		// For booleans, consider the item to be disallowed only when explictly so stated.
		// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#update says
		// "Servers that don't support the conditional update should return an HTTP 400
		// error and an operation outcome".
		Set tValue = ..IsCapabilitySupported(resourceType, "conditionalUpdate", 1)
		if tValue=0 {
			$$$ThrowFHIR($$$HSFHIRErrConditionalUpdateNotSupported, resourceType, $$$OutcomeNotSupported(400))
		}
		if tSearchParameters="" {
			$$$ThrowFHIR($$$HSFHIRErrInvalidConditionalUpdate, $$$OutcomeInvalid(400))
		}
		
		// Search for the resource to update
		#dim tResultSet as HS.FHIRServer.Util.SearchResult = ..%interactions.Search(resourceType, "" , resourceId, tSearchParameters)
		Set tMatches = 0
		
		While (tResultSet.NextUndeleted()) {
			Set tMatches = tMatches + 1
			If tMatches>1 Quit
			Set matchedResourceId = tResultSet.ResourceId
			$$$FSLog("Conditional Update found Id: "_resourceId)
		}
		
		If tMatches=0 {
			If tUpdateCreate {
				// Flag that this is a create (with server-assigned id)
				Set isUpdate = 0
			} Else {
				$$$ThrowFHIR($$$HSFHIRErrNoCreateUpdate, resourceType, resourceId, $$$OutcomeIs(405, "error", "forbidden"))
			}
		} ElseIf tMatches=1 {
			if (resourceId '= "") && (resourceId '= matchedResourceId) {
				$$$ThrowFHIR($$$HSFHIRErrPayloadDoesNotMatchResource, resourceId, matchedResourceId, $$$OutcomeInvalid(400))
			}
			// Incoming resource did not have an Id, use the id of the found resource
			Set resourceId = matchedResourceId
			Set resourceIn.id = resourceId
		} ElseIf tMatches>1 {
			$$$ThrowFHIR($$$HSFHIRErrConditionalUpdateFoundMultiple, $$$OutcomeIs(412, "error", "conflict"))
		}
		
		// If we're here, we've found a single resource to update or create
		set rsrcMeta = ..%interactions.GetResourceMeta(resourceType, resourceId)
		if tIfMatchVersion '= "" {
			Set currentId = $$$RsrcMetaVersionId(rsrcMeta)
			if currentId '= tIfMatchVersion {
				Set httpCode = $Select( ((+$E(..%Schema.FHIRVersion)) < 4):409, 1:412)
				$$$ThrowFHIR($$$HSFHIRErrIfMatchViolation, tIfMatchVersion, currentId,$$$OutcomeIs(httpCode, "error", "concurrency"))
			}
		}
	}
	
	//w "prefer: ",tPreferReturn,", create: ",tUpdateCreate,", sp: ",tSearchParameters,!

	// If an OAuth 2.0 access token was provided with this request, verify
	// that the proposed resource to update is allowed per the token. This
	// will Throw if the update is not allowed.
	Do ..%interactions.oauth2TokenHandler.VerifyResourceContent(resourceIn, ..GetPrivFromRequest(pRequest), 1)
	
	if isUpdate {
		Set newId = ..%interactions.Update(resourceIn)
		$$$FSLog("Updating "_$$$BuildRsrcKey(resourceType, resourceId))
		
	} else {
		Set newId = ..%interactions.Add(resourceIn, resourceIdToAssign, "PUT")
		$$$FSLog("Update Creating "_$$$BuildRsrcKey(resourceType, resourceId))
	}
	
	Set tResourceVId = resourceIn.meta.versionId
	Set tLastModified = resourceIn.meta.lastUpdated
	// Convert Last Modified to a format appropriate for the "Last-Modified" header.
	// Example of the target format is: "Fri, 01 Dec 2017 23:01:20 GMT"
	set tLastModified = $$$cspHtoD($ZDTH(tLastModified,3,5))

	set tLocation = ..GetRequestURLNoQuery(pRequest)_"/_history/"_tResourceVId
	Set pResponse.Location = tLocation
	Set pResponse.ETag = ..ETagValue(tResourceVId)
	Set pResponse.LastModified = tLastModified
	set pResponse.Id = resourceIn.id
	set pResponse.VId = tResourceVId

	if tResourceVId=1 {
		// Created
		Set pResponse.Status = 201
	} else {
		// Updated - HTTP OK
		Set pResponse.Status = 200
	}

	// If the request has a "Prefer" header with value "return=representation", return the
	// resource as it was saved in the response payload.
	If tPreferReturn="representation" {
		Set pResponse.Json = resourceIn
	}
}

Method ConditionalPatch(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Do ..Patch(pRequest, pResponse, 1)
}

Method Patch(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response, isConditional As %Boolean = 0)
{
	// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
	Do ..RequireAllowedResourceInteraction(pRequest.Type, pRequest.Interaction)
	
	// Ensure expected PATCH Payload.
	If pRequest.RequestFormatCode = $$$FHIRContentCodeJPatch {
		// JSON Patch payload is expected to be in the request .JSON at this point.
		Set patchPayload = ..RequirePayload(pRequest)
		
	} ElseIf pRequest.RequestFormatCode = $$$FHIRContentCodeXPatch {
		// XML not supported
		$$$ThrowFHIR($$$HSFHIRErrInteractionsNotSupported, pRequest.Type, pRequest.Interaction, "XML Patch", $$$OutcomeNotSupported(400))
		
	} ElseIf '((pRequest.RequestFormatCode=$$$FHIRContentCodeJSON)||(pRequest.RequestFormatCode=$$$FHIRContentCodeXML)) {
		// FHIRPath not supported
		$$$ThrowFHIR($$$HSFHIRErrInteractionsNotSupported, pRequest.Type, pRequest.Interaction, "FHIRPath Patch", $$$OutcomeNotSupported(400))
		
	} Else {
		// This can possibly happen only if not using the standard RestHandler,
		// or if calling FHIRServer Service directly.
		$$$ThrowFHIR($$$HSFHIRErrInteractionsNotSupported, pRequest.Type, pRequest.Interaction, "Unknown Patch", $$$OutcomeNotSupported(400))
	}
	
	// If the request contains an If-Match header, assert that the value matches the current version ID of the resource
	// (Used for resource contention - see http://www.hl7.org/fhir/2015May/http.html#2.1.0.11)
	Set ifMatch = pRequest.IfMatch
	Set ifMatchVersion = ""
	If (ifMatch '= "") {
		// Assert that it is formatted correctly
		If (ifMatch '? 1"W/""".E1"""") {
			$$$ThrowFHIR($$$HSFHIRErrInvalidIfMatch, ifMatch, $$$OutcomeInvalid(405))
		}
		Set ifMatchVersion = $Extract(ifMatch, 4, *-1)
	}
	
	// If tPreferReturn is "representation", then it means that the request has asked
	// the server to return a copy of the resource that was saved.
	Set preferReturn = ..GetPreferHeader(pRequest, "return")
	
	#dim searchParameters As HS.FHIRServer.API.Data.QueryParameters = pRequest.Parameters.ExtractSearchParameters()
	
	If 'isConditional {
		If (searchParameters) && (searchParameters.Count()) {
			$$$ThrowFHIR($$$HSFHIRErrInvalidUpdate, $$$OutcomeInvalid(400))
		}
		
		// Do an actual Read here, instead of FindResourceMeta, since we are going
		// to obtain and pass the resource object eventually anyway. Read will
		// Throw if the resource is not found.
		Set resourceIn  = ..%interactions.Read(pRequest.Type, pRequest.Id)
		Set resourceId = pRequest.Id
		Set resourceType = pRequest.Type
		
		// Since the meta is obtained from a retrieved resource, assume that it has content.
		If ifMatchVersion '= "" {
			Set currentVersionId = resourceIn.meta.versionId
			If currentVersionId '= ifMatchVersion {
				Set httpCode = $Select( ((+$Extract(..%Schema.FHIRVersion)) < 4):409, 1:412 )
				$$$ThrowFHIR($$$HSFHIRErrIfMatchViolation, ifMatchVersion, currentVersionId, $$$OutcomeIs(httpCode, "error", "concurrency"))
			}
		}
		
	} Else {
		// Conditional Patch Request
		// The FHIR REST API spec has a concept of conditional patch, but FHIR CapabilityStatement does not.
		// Use the CapabilityStatement conditionalUpdate value as the basis for checking if conditional
		// Patch is okay.
		
		// conditionalUpdate specifies whether the end point allows checking for the existence
		// of resources that match a given search criteria before updating.
		// For booleans, consider the item to be disallowed only when explictly so stated.
		// FHIR REST API for create at http://hl7.org/fhir/http.html#update says
		// "Servers that don't support the conditional update should return an HTTP 400
		// error and an operation outcome".
		If '..IsCapabilitySupported(pRequest.Type, "conditionalUpdate", 1) {
			$$$ThrowFHIR($$$HSFHIRErrConditionalUpdateNotSupported, resourceType, $$$OutcomeNotSupported(400))
		}
		If searchParameters = "" {
			$$$ThrowFHIR($$$HSFHIRErrInvalidConditionalUpdate, $$$OutcomeInvalid(400))
		}
		
		If '(($IsObject(searchParameters)) && (searchParameters.Count())) {
			$$$ThrowFHIR($$$HSFHIRErrInvalidUpdate, $$$OutcomeInvalid(400))
		}
		
		// Search for the resource to update
		#dim resultSet as HS.FHIRServer.Util.SearchResult = ..%interactions.Search(pRequest.Type, "" , pRequest.Id, searchParameters)
		
		Set matchCount = 0
		
		While (resultSet.NextUndeleted()) {
			If $i(matchCount)
			If matchCount>1 Quit
			Set matchedResourceId = resultSet.ResourceId
			Set matchedResourceType = resultSet.ResourceType
			$$$FSLog("Conditional Patch found Id: "_matchedResourceId)
		}
		
		If matchCount = 0 {
			$$$ThrowFHIR($$$HSFHIRErrConditionalPatchNoMatches, $$$OutcomeIs(404, "error", "not-found"))
			
		} ElseIf matchCount = 1 {
			Set resourceId = matchedResourceId
			Set resourceType = matchedResourceType
			// Do an actual Read here, instead of FindResourceMeta, since we are going
			// to obtain and pass the resource object eventually anyway. Read will
			// Throw if the resource is not found.
			Set resourceIn  = ..%interactions.Read(resourceType, resourceId)
			
		} ElseIf matchCount>1 {
			$$$ThrowFHIR($$$HSFHIRErrConditionalPatchFoundMultiple, $$$OutcomeIs(412, "error", "conflict"))
		}
		
		// If we're here, we've found a single resource to update or create
		// Since the meta is obtained from a retrieved resource, assume it has content.
		If ifMatchVersion '= "" {
			Set currentVersionId = resourceIn.meta.versionId
			If currentVersionId '= ifMatchVersion {
				Set httpCode = $Select( ((+$Extract(..%Schema.FHIRVersion)) < 4):409, 1:412 )
				$$$ThrowFHIR($$$HSFHIRErrIfMatchViolation, ifMatchVersion, currentVersionId, $$$OutcomeIs(httpCode, "error", "concurrency"))
			}
		}
	}
	
	// If an OAuth 2.0 access token was provided with this request, verify
	// that the proposed resource to patch is allowed per the token. This
	// will Throw if the patch is not allowed.
	Do ..%interactions.oauth2TokenHandler.VerifyResourceContent(resourceIn, ..GetPrivFromRequest(pRequest), 1)
	
	// Ensure expected PATCH Payload
	If pRequest.RequestFormatCode = $$$FHIRContentCodeJPatch {
		// JSON Patch payload is expected to be in the request .JSON at this point.
		Set updated = ..%interactions.JSONPatch(patchPayload, resourceIn)
		
	} ElseIf pRequest.RequestFormatCode = $$$FHIRContentCodeXPatch {
		// XML not supported - would already have Thrown earlier
		
	} ElseIf '((pRequest.RequestFormatCode=$$$FHIRContentCodeJSON)||(pRequest.RequestFormatCode=$$$FHIRContentCodeXML)) {
		// FHIRPath not supported - would already have Thrown earlier
	}
	
	If updated {
		// If the resource was actually updated - it would not be updated if the Patch had only
		// 'test' operations - then update it in the repo using the Interactions Update method.
		
		// Validate the Patched resource before saving. Throws upon error.
		Do ..resourceValidator.ValidateResource(resourceIn)
		
		Set newId = ..%interactions.Update(resourceIn)
	}
	
	// Regardless of whether the resource was updated or not, return all the meta info
	// and honor the Prefer return header value.
	
	Set resourceVId = resourceIn.meta.versionId
	Set lastModified = resourceIn.meta.lastUpdated
	
	// Convert Last Modified to a format appropriate for the "Last-Modified" header.
	// Example of the target format is: "Fri, 01 Dec 2017 23:01:20 GMT"
	Set lastModified = $$$cspHtoD($ZDTH(lastModified,3,5))
	
	Set pResponse.Location = ..GetRequestURLNoQuery(pRequest)_"/_history/"_resourceVId
	Set pResponse.ETag = ..ETagValue(resourceVId)
	Set pResponse.LastModified = lastModified
	Set pResponse.Id = resourceIn.id
	Set pResponse.VId = resourceVId
	
	Set pResponse.Status = 200
	
	If preferReturn = "representation" {
		Set pResponse.Json = resourceIn
	}
}

Method Delete(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Set resourceType = pRequest.Type
	Set resourceId = pRequest.Id
	Set resourceVId = pRequest.VId
	
	set pResponse.Id = resourceId

	// Per http://www.hl7.org/fhir/STU3/http.html#delete, return status code 204 (No Content)
	// whether the identified resource exists or not and whether the resource is already
	// deleted or not.
	set pResponse.Status = 204

	// delete is similar to update in that it deprecates the old version of the resource and
	// creates a new one, the difference being that for delete, the new version has no content
	// and is marked as deleted

	// Assert that this interaction on this resource type is allowed as per the Conformance/CapabilityStatement.
	// If the server refuses to delete resources of that type as a blanket policy,
	// then it should return the 405 Method not allowed status code.
	Do ..RequireAllowedResourceInteraction(resourceType, pRequest.Interaction)
	
	#dim tSearchParameters as HS.FHIRServer.API.Data.QueryParameters = pRequest.Parameters.ExtractSearchParameters()

	// Must have either resource id or conditional delete search parameters, but not both.
	If (resourceId '= "")&&(tSearchParameters '= "") {
		$$$ThrowFHIR($$$HSFHIRErrInvalidDelete, $$$OutcomeInvalid(400))
	} ElseIf (resourceId = "")&&(tSearchParameters = "") {
		$$$ThrowFHIR($$$HSFHIRErrInvalidConditionalDelete, $$$OutcomeInvalid(400))
	}

	// Verify that conditional delete is allowed by the Conformance/CapabilityStatement.
	Set tConditionalDelete = "multiple"
	If tSearchParameters'="" {
		// conditionalDelete specifies whether the end point allows deleting resources
		// based on matching a given set of criteria (search parameters).  Conformance/
		// CapabilityStatement values for this are "not-supported", "single" and "multiple".
		// Support for conditional delete must be explicitly stated, via the "single" or
		// "multiple" values.
		Set tConditionalDelete = ..GetCapabilityStatus(resourceType, "conditionalDelete")
		If (tConditionalDelete="not-supported")||(tConditionalDelete="") {
			// FHIR REST API for create at http://hl7.org/fhir/STU3/http.html#delete says
			// "Servers that don't support the conditional delete should return an HTTP 400
			// error and an operation outcome".
			$$$ThrowFHIR($$$HSFHIRErrInteractionNotSupported, resourceType, "conditional-delete", $$$OutcomeNotSupported(400))
		}
	}

	Set deletedIdList = ##class(%Library.ListOfDataTypes).%New()
	
	Set privNeeded = ..GetPrivFromRequest(pRequest)
	
	If tSearchParameters="" {
		// No parameters, is not a conditional delete.
		// If the resource doesn't exist, do nothing (silently)
		If ..%interactions.oauth2TokenHandler.TokenString '= "" {
			Do ..%interactions.oauth2TokenHandler.VerifyResourceIdRequest(resourceType, resourceId, privNeeded)
			Try {
				Set resourceObj = ""
				Set resourceObj = ..%interactions.Read(resourceType, resourceId)
			} Catch read1Ex {
			}
			If $IsObject(resourceObj) {
				Do ..%interactions.oauth2TokenHandler.VerifyResourceContent(resourceObj, privNeeded, 0)
			}
		}
		Set resourceVId = ..%interactions.Delete(resourceType, resourceId)
		If resourceVId'="" Do deletedIdList.Insert(resourceId_","_resourceVId)
	} Else {
		// Request for a conditional delete
		If (pConditionalDelete="not-supported")||(pConditionalDelete="") {
		// Conditional delete must be explicitly supported.
			$$$ThrowFHIR($$$HSFHIRErrConditionalDeleteNotSupported, resourceType)
		}
		If resourceId '= "" {
			$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "Cannot include resource id and conditional delete search parameters on the same delete request")
		} 
		// All okay, proceed with the conditional delete search and deletes.
		#dim tResultSet as HS.FHIRServer.Util.SearchResult = ..%interactions.Search(resourceType, "", "", tSearchParameters)

		While (tResultSet.%Next()) {
			If (pConditionalDelete="single")&&(tResultSet.%ROWCOUNT>1) {
				$$$ThrowFHIR($$$HSFHIRErrConditionalDeleteOfMultipleNotSupported)
			}
			If (tResultSet.%ROWCOUNT > pMaxSearchMatches) {
				$$$ThrowFHIR($$$HSFHIRErrConditionalDeleteOverflow, pMaxSearchMatches)
			}
			Set tResourceId = tResultSet.ResourceId
			If ..%interactions.oauth2TokenHandler.TokenString '= "" {
				Do ..%interactions.oauth2TokenHandler.VerifyResourceIdRequest(resourceType, tResourceId, privNeeded)
				Try {
					Set resourceObj = ""
					Set resourceObj = ..%interactions.Read(resourceType, tResourceId)
				} Catch read2Ex {
				}
				If $IsObject(resourceObj) {
					Do ..%interactions.oauth2TokenHandler.VerifyResourceContent(resourceObj, privNeeded, 0)
				}
			}
			Set tResourceVId = ..%interactions.Delete(resourceType, tResourceId)
			If tResourceVId'="" Do deletedIdList.Insert(tResourceId_","_tResourceVId)
		}
	}
	
 //
	If tSearchParameters="" {
		Set pResponse.ETag = ..ETagValue($Piece(deletedIdList.GetAt(1),",",2))
	} Else {
		Set tString = "Deleted "
		Set idList = ""
		For i = 1:1:deletedIdList.Count() {
			If i>1 Set tString = tString_", "
			Set tString = tString_" resource id "_$Piece(deletedIdList.GetAt(i),",",1)
			Set tString = tString_" resource vid "_$Piece(deletedIdList.GetAt(i),",",2)
			Set $List(idList,*+1) = pRequest.Type _ "/" _ $Piece(deletedIdList.GetAt(i),",",1) _ "/" _ $Piece(deletedIdList.GetAt(i),",",2)
		}
  		Set pResponse.Json = ##class(HS.FHIRServer.Util.Outcome).Create("information", $LTS(idList,", "), "informational")
		Set pResponse.Status = 200
	}
}

Method Search(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	set tBase = pRequest.BaseURL
	set tType = pRequest.Type

	if tType'="" {

		// Assert that this interaction on this resource type is allowed as per the
		// Conformance/CapabilityStatement. While the FHIR REST API refers to the search by type
		// interaction as "search", the Conformance/CapabilityStatement resource uses value set
		// TypeRestfulInteraction http://hl7.org/fhir/ValueSet/type-restful-interaction for
		// interaction, which specifies a name of "search-type" for this interaction.
		Do ..RequireAllowedResourceInteraction(pRequest.Type, "search-type")
	} else {
		// Assert that this system level interaction on this resource type is allowed as per the
		// Conformance/CapabilityStatement. While the FHIR REST API refers to the system level
		// search interaction as "search", the Conformance/CapabilityStatement resource uses
		// value set TypeRestfulInteraction http://hl7.org/fhir/ValueSet/type-restful-interaction
		// for interaction, which specifies a name of "search-system" for this interaction.
		Do ..RequireAllowedSystemInteraction("search-system")
	}

	// These are HealthShare-specific parameters to use for paging.
	set tQueryId = pRequest.GetParameterValue(..#QUERYIDPARAM)
	set tPage = pRequest.GetParameterValue(..#QUERYPAGEPARAM)

	// If queryId is not present then this is a new search,
	// as opposed to a search that uses an established
	// cache of results from a previous search.
	#dim tResultSet As HS.FHIRServer.Util.SearchResult
	if (tQueryId="") {
		// Initial Query Request - Perform the query and process the result set.
		set tPage = 1
		Set tResultSet = ..SearchNew(pRequest)
		if '$IsObject($Get(tResultSet)) {
			$$$ThrowFHIR($$$GeneralError, "Unknown search error, resultset object not found")
		}
		If ..IsPreferStrictHandling(pRequest) {
			$$$ThrowOnError(pRequest.Parameters.status)
		}
		set tQueryURL = ..GetFullRequestURL(pRequest)
		Set pageCount = tResultSet.Paginate( ..GetQueryPageSize(pRequest) )
		if pageCount > 1 {
			Do tResultSet.Save()	
		}

		if tResultSet.TotalUndeleted > ..%ConfigData.MaxSearchResults {
			$$$ThrowFHIR($$$HSFHIRErrSearchTooCostly, ..%ConfigData.MaxSearchResults, $$$OutcomeIs(413, "error", "too-costly"))
		}
		// Handle the Summary Request Here
		if tResultSet.PageSize=0 {
			// From http://hl7.org/fhir/STU3/search.html#count
			// if _count has the value 0, this shall be treated the same as _summary=count:
			// the server resturns a bundle that reports the total number of resources that
			// match in Bundle.total, but with no entries, and no prev/next/last links. Note
			// that the Bundle.total only include the total number of matching resources. It
			// does not count extra resources such as OperationOutcome or included resources
			// that may also be returned.

			kill bundleUrls
			Set bundleUrls("self") = tQueryURL
			Set bundle = ..CreateBundle("", "searchset", tResultSet.MatchCount, .bundleUrls, ..Schema)

			Set pResponse.Json = bundle
			set pResponse.Status = 200
			Return
		}
	} else {
		// Response from a page request to a previous query
		set tQueryURL = ..GetFullRequestURL(pRequest)
		Set tResultSet = ##class(HS.FHIRServer.Util.SearchResult).Restore(tQueryId)
		if $IsObject(tResultSet)=0 {
			$$$ThrowFHIR($$$GeneralError, "Invalid queryId specified") 
		}
		
		if +tPage=0 set tPage = 1
	}
	Do tResultSet.SetIteratorToPage(tPage)


	// To maximize performance this method avoids the use of HS FHIR objects.
	// Instead it uses %DynamicObject and %XML.Document when an object is
	// needed, and constructs the Bundle using streams only.

	Do ..GetPageLinks(pRequest, tResultSet.QueryId, tResultSet.TotalUndeleted, tResultSet.PageSize, tPage, tBase, .bundleUrls)
	Set bundleUrls("self") = tQueryURL
	Set bundle = ..CreateBundle("", "searchset", tResultSet.MatchCount, .bundleUrls, ..Schema)
	
	if $$$ISERR(pRequest.Parameters.status) {
		Set outcome = ##class(HS.FHIRServer.Util.Outcome).CreateFromStatus(pRequest.Parameters.status, .httpStatus)
		do ..AddBundleEntry(bundle, "", outcome)
	}

	for ord=1:1:tResultSet.PageSize {
		if ' tResultSet.NextUndeleted() {
			Quit
		}
		//w "read: ",pRequest.Type, "/",tResultSet.ResourceId,"|",tResultSet.Mode,!
		if '$isObject(tResultSet.ResourceJson) {
			Set json = ..%interactions.Read(tResultSet.ResourceType, tResultSet.ResourceId)
		} else {
			Set json = tResultSet.ResourceJson
		}
		Set tFullUrl = tBase_"/"_json.resourceType_"/"_json.id
		Set bundleEntry = ..AddBundleEntry(bundle, tFullUrl, json, tResultSet.Mode)
	}
	Set pResponse.Json = ..FinalizeBundle(bundle)
	Set pResponse.Status = 200
}

/// Get the query page size, based on the _count parameter from
/// the search request, constrained by default and maximum values.
Method GetQueryPageSize(pRequest As HS.FHIRServer.API.Data.Request) As %Integer [ Internal ]
{
	if pRequest.GetParameterValue("summary")="count" {
		set tPageSize = 0
	} else {
		set tPageSize = pRequest.GetParameterValue("_count")
		// From http://hl7.org/fhir/STU3/search.html#count
		// if _count has the value 0, this shall be treated the same as _summary=count:
		// the server resturns a bundle that reports the total number of resources that
		// match in Bundle.total, but with no entries, and no prev/next/last links. Note
		// that the Bundle.total only include the total number of matching resources. It
		// does not count extra resources such as OperationOutcome or included resources
		// that may also be returned.
		Set tDefault = ..ConfigData.DefaultSearchPageSize
		Set tMaximum = ..ConfigData.MaxSearchPageSize
		if (tPageSize="")&&(+tDefault>0) set tPageSize = tDefault
		if (+tMaximum>0)&&(tPageSize>tMaximum) set tPageSize = tMaximum
	}
	return tPageSize
}

/// Get the links for paging to first, previous, next and last, based
/// on the total search results, page size, and current page values.
ClassMethod GetPageLinks(pRequest As HS.FHIRServer.API.Data.Request, pQueryId As %String, pTotal As %Integer, pPageSize As %Integer, pPage As %Integer, pBase As %String, ByRef pUrls) [ Internal ]
{
	set (tFirst, tPrev, tNext, tLast) = ""
	kill pUrls

	if pTotal>pPageSize {

		set tFirst = 1

		If (pTotal#pPageSize)=0 {
			set tLast = pTotal\pPageSize
		} else {
			set tLast = (pTotal\pPageSize)+1
		}

		// Previous should not point to the current page.
		if pPage=2 {
			set tPrev = 1
		} elseif pPage>2 {
			set tPrev = pPage-1
		}

		// Next should not point to the current page.
		if pPage=(tLast-1) {
			set tNext = tLast
		} elseif pPage<(tLast-1) {
			set tNext = pPage+1
		}

		// Include the _format parameter in the page links only if it was provided in the search URL.
		Do pRequest.Parameters.GetParameters("_format", .formatParams)
		Set tFormat = $Select(formatParams=0:"", 1:formatParams(1).value)
		kill formatParams
		
		// Also include the _include parameter (may be multiple instances)
		Do pRequest.Parameters.GetParameters("_include", .includeParams)
		set tIncludeStr = ""
		for tI=1:1:includeParams { 
			set tIncludeStr = tIncludeStr _ "_include="_includeParams(tI).value _ "&"
		}
		
		if pRequest.Interaction '= "operation" {
			set tOperation = ""
		} else {
			set tOperation = "$" _ pRequest.OperationName
			if pRequest.Type '= "" {
				Set tOperation = "/"_tOperation
			}
		}
		
		set tUrl = pBase_"/"_pRequest.Type_tOperation_"?"_$Select(tFormat'="":"_format="_tFormat_"&",1:"")_tIncludeStr_"page=<PAGE>&queryId="_pQueryId
		set pUrls("first") = $Replace(tUrl, "<PAGE>", tFirst)
		if tPrev'="" set pUrls("previous") = $Replace(tUrl, "<PAGE>", tPrev)
		if tNext'="" set pUrls("next") = $Replace(tUrl, "<PAGE>", tNext)
		set pUrls("last") = $Replace(tUrl, "<PAGE>", tLast)
	}
}

/// Perform a "new" search, as opposed to a search that uses the query cache.
Method SearchNew(pRequest As HS.FHIRServer.API.Data.Request) As HS.FHIRServer.Util.SearchResult [ Internal ]
{

	/* --- 
	NOTE: This is disabled but temporarily preserved as a marker until we prove that this "on-demand" feature can be
	handled by having a Strategy implemetation (e.g. ODS) subclass the Interactions object
	-------------------------------------------------------------
	// If a LoadPatientClass class name is defined, try to derive an MPIID from the
	// request message, and call the class to perform custom logic.  In the context
	// of LoadPatientClass, we equate FHIR resource id with HealthShare MPIID.
	if ..%ConfigData.LoadPatientClass'="" {
		set tMPIID = ""
		if pRequest.Type'="Patient" {
			if (pRequest.Compartment="Patient")&&(pRequest.Id'="")&&(pRequest.Type'="") {
				set tMPIID = pRequest.Id
			} else {
				// If this is not a Patient compartment search, then the resource
				// type must have a search parameter that can point to a Patient
				// resource, and the search request must specify one of those
				// search parameters.
				set tKey = ""
				for {
					set tParamItem = pRequest.Parameters.GetNext(.tKey)
					if tKey="" Quit
					// Remove any modifier from the parameter name.
					set tKey1 = $Piece(tKey, ":", 1)
					if tKey1'="" {
						// Gather MPIID values from any reference type search
						// parameters that can point to a Patient resource.
						set tReturnVals = ..%Schema.GetRefTypeIdsFromSearchParam(pRequest.Type, tKey1, tParamItem, "Patient")
						if tReturnVals'="" {
							if tMPIID'="" set tMPIID = tMPIID_","
							set tMPIID = tMPIID_tReturnVals
						}
					}
				}
			}

		} else {
			set tAffinityDomainCode = ##class(HS.Registry.Config).GetKeyValue("\IHE\AffinityDomain")
			set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomainCode,"")
			if $Extract(tAffinityDomainOID, 1, 8)="urn:oid:" Set tAffinityDomainOID = $Extract(tAffinityDomainOID, 9, *)
			if pRequest.GetParameterCount("_id")=1 {
				set tMPIID = pRequest.GetParameterValue("_id", 1)
			} elseif pRequest.GetParameterCount("identifier")>0 {
				set tParamVal = pRequest.GetParameterValue("identifier", 1)
				set tSystem = $Piece(tParamVal, "|", 1)
				set tCode = $Piece(tParamVal, "|", 2)
				if (tSystem'="")&&(tCode'="") {
					if $Extract(tSystem,1,4)="http" set tSystem = ##class(HS.Data.OIDMap).GetOIDForURL(tSystem)
					if $Extract(tSystem, 1, 8)="urn:oid:" Set tSystem = $Extract(tSystem, 9, *)
					if tSystem=tAffinityDomainOID Set tMPIID = tCode
				}
			}
		}

		if tMPIID'="" {
			set tSC = $ClassMethod(..%ConfigData.LoadPatientClass, "LoadPatient", $this, tMPIID, pSessionApplication, pSessionId)
			$$$ThrowOnError(tSC)
		} elseif '..%Schema.IsSharedResourceType( pRequest.Type) {
			// When LoadPatientClass has a value, it implies that FHIR search requests on
			// "non-shared" resources must have a patient context. Which means reference
			// to Patient resource for a non-Patient non-shared resource type search, or
			// _id or identifier on a Patient search.
			$$$ThrowFHIR($$$HSFHIRErrMissingPatientId)
		}
	}
	*/
	
	Set resourceType = pRequest.Type
	Set compartment = pRequest.Compartment
	Set compartmentId = pRequest.Id
	Set parameters = pRequest.Parameters
	
	Set tResultSet = ""

	If $Get(resourceType)="" {
		$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "Resource type not specified")
	} 
	

	// Set this global to 1 to turn on logging for search. Useful for analyzing performance.
	set tLog = +$G(^HS.FHIR.Log.Search)

	set tOrderBy = ""
	
	#dim tSortKeys as HS.FHIRServer.API.Data.QueryParameters
	Do ..ValidateSortKeys(resourceType, pRequest.Parameters, .tSortKeys)
	
	// Pre-scan the parameters to verify at least one search key.
	Set tErrStatus = $$$OK
	Set preferStrict = ..IsPreferStrictHandling(pRequest)
	Set errSeverity = $Select(preferStrict="strict":"error",1:"warning")
	Set errHandling = $Select(preferStrict="strict":"",1:", ignoring")
	
	// Check the _include related parameter info, even if we are going to error
	// on unrecognized search params that we found earlier.
	Do parameters.GetParameters("_include", .params)
	do ..BuildIncludeList(.params, resourceType, .tErrStatus,.tValidIncludesArr)

	// Check the _revinclude related parameter info, even if we are going to error
	// on unrecognized search params that we found earlier.
	Do parameters.GetParameters("_revinclude", .params)
	do ..BuildRevIncludeList(.params, resourceType, .tErrStatus,.tValidRevIncludesArr)

	// Assume that pErrors was empty before starting to validate the search
	// parameters. Therefore if there are any errors now, they are due to
	// invalid search parameters. In that case, quit now.
	if preferStrict {
		$$$ThrowOnError(parameters.status)
	}
	
	Do ..%interactions.oauth2TokenHandler.VerifySearchRequest(resourceType, compartment, compartmentId, pRequest.Parameters, ..GetPrivFromRequest(pRequest))
	
	// ---- End of Parameter Validation, Start of Query Building ----
	
	Set tResultSet = ..%interactions.Search( resourceType, compartment, compartmentId, parameters, .tSortKeys )
	
	
	// -------- Run the PostProcessor -----------
	// Note: This is run BEFORE any _include or _revinclude processing
	
	// search-all (pRequest.Type=""), or search parameters _include, _revinclude or _contained,
	// could cause more than one resource type to be represented in the result set. The following loop
	// will set resourceType to empty if multiple types are included
	If (resourceType'="") && (tValidIncludesArr || tValidRevIncludesArr || (parameters.GetAt("_contained")'="")) {
		Set resourceType = ""
	}
		
	// Now add any includes (and reverse includes) to the result set	
	Do ..%interactions.SearchIncludes(tResultSet, .tValidIncludesArr, .tValidRevIncludesArr)

	// Reset to the start of the result set
	Do tResultSet.%SetIterator(0)

	// If there are no reverse includes, Call the post-processing method to apply consent or other filtering
	Do ..%interactions.PostProcessSearch(tResultSet, resourceType)
	
	// Search post processing is intended to be handled inside the storage class "Search" method.
	quit tResultSet
}

/// ValidateSortKeys validates the sort keys that were passed in as URL parameters, as per
/// the FHIR STU3 specification. If validation is successful, it returns information about
/// the sort keys, if any are found, in an array via the pSortKeys parameter. Otherwise a
/// failure status is returned.<br>
/// <br>
/// Input:<br>
/// <li>pResourceType : (required) FHIR resource type.
/// <li>pParameters   : (required) Request URL parameters, passed in as %Library.ArrayOfDataTypes.
/// <br><br>
/// Output:<br>
/// <li>pSortKeys     : Array of sort keys:<br>
/// - pSortKeys(n)   = True if ascending order, False if descending<br>
/// - pSortKeys(n,"SearchParam") = The nth SearchParam object to be sorted on.<br>
Method ValidateSortKeys(pResourceType As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters, ByRef pSortKeys As %String) [ Internal ]
{
	Kill pSortKeys
	Set pSortKeys = 0
	
	If pResourceType="" {
		$$$ThrowFHIR($$$HSFHIRErrCrossResourceSort, $$$OutcomeNotSupported(400))
	}
	
	// Ensure that _sort is present no more than once in the URL
	Set tSortKeysStr = ""
	Set tKey = "_sort"
	Set tSortKeyCount = pParameters.GetParameterCount(tKey)
	if tSortKeyCount > 0 {
		if tSortKeyCount > 1 {
			$$$ThrowFHIR($$$HSFHIRErrMultipleParameters, tKey, $$$OutcomeInvalid(400))
		}
		Set tSortKeysStr = pParameters.GetParameterValue(tKey, 1, .modifier)
		if modifier '= "" {
			$$$ThrowFHIR($$$HSFHIRErrInvalidParameterModifier, modifier, tKey, $$$OutcomeInvalid(400))
		}
		
		For i = 1:1:$Length(tSortKeysStr,",") {
			Set tSortKeyStr = $Piece(tSortKeysStr,",",i)
			If tSortKeyStr'="" {
				Set isAscending = 1
				If $Extract(tSortKeyStr)="-" {
					Set isAscending = 0
					Set tSortKeyStr = $Extract(tSortKeyStr,2,*)
				}
				If $Data(tKeys(tSortKeyStr)) {
					$$$ThrowFHIR($$$HSFHIRErrDuplicateSortKey,tSortKeysStr,$$$OutcomeInvalid(400))
				}
				If tSortKeyStr="0" {
					$$$ThrowFHIR($$$HSFHIRErrDuplicateSortKey,tSortKeysStr,$$$OutcomeInvalid(400))
				}
				#dim searchParam as HS.FHIRServer.SearchParam = ..%Schema.GetSearchParam(pResourceType,tSortKeyStr)
				Set tSortKeyType = searchParam.type
				If tSortKeyType="quantity" {
					$$$ThrowFHIR($$$HSFHIRErrUnsupportedSortKey,tSortKeysStr,$$$OutcomeNotSupported(400))
				}
				Set tKeys(tSortKeyStr)=""
				If $i(tSortKeyCount) {}
				Set pSortKeys($I(pSortKeys),"SearchParam") = searchParam
				Set pSortKeys(pSortKeys) = isAscending
			} Else {
				$$$ThrowFHIR($$$HSFHIRErrInvalidSortKey,tSortKeysStr,$$$OutcomeInvalid(400))
			}
		}
	}
}

/// Validates the incoming $LIST of values provided to the _include parameter and builds
/// a $LIST of valid include requests ( <resourceType>:<searchParam>[:<targetResourceType>] )
/// Forms:
///  resourceType:* - Include resources referenced by any searchParams of resourceType reference
///  resourceType:searchParam - Include all types that the searchParam references
///  resourceType:searchParam:targetType - Include resources of targetType that the searchParam references
Method BuildIncludeList(ByRef includeValues, pResourceType As %String, ByRef pErrorList As %Status, ByRef pResArr) [ Internal ]
{
	// If the query has an _include param or params, make sure it's valid, otherwise return an operation outcome.
	// This just validates _include, the actual processing is below.

	// Take a pass looking for '*' and expand to the set of valid search parameters
	// Build a set of values (to ensure uniqueness)
	kill pResArr
	set pResArr = 0
	set tValidIncludes = ""
	
	for tJ=1:1:includeValues {
		Set tOneInclude = includeValues(tJ).value		
		set tIncludeBaseType = $P(tOneInclude, ":", 1)
		
		// Assert that the base type of the include matches the search type.
		if (tIncludeBaseType '= pResourceType) {
			$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidIncludeBaseType,tOneInclude))
			Continue
		}
		
		set tIncludeParam = $P(tOneInclude, ":", 2)
		set tTargetType = $P(tOneInclude, ":", 3)
		if tIncludeParam '= "*" {
			
			set searchParam = ..%Schema.FindSearchParam(tIncludeBaseType, tIncludeParam)
			if searchParam="" {
				$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidQueryParameter, tIncludeBaseType, tIncludeParam))
				Continue
			}
			
			// Assert that the named param is of type "reference"
			if (searchParam.type '= "reference") {
				$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidIncludeReference, tOneInclude))
				Continue
			}
			if '$data(includeSet(tOneInclude)) {
				set pResArr($i(pResArr))=searchParam
				set pResArr(pResArr,"targetType")=tTargetType
				
				If $$$FSLogIsActive($$$FSChannelInclude) {
					set $List(tValidIncludes, *+1) = tOneInclude
				}
				
			}
			Set includeSet(tOneInclude) = ""
 		
		} else {

			// Expand the '*' to add all search parameters
			set searchParam = ""
			for {
				Set searchParam = ..%Schema.NextSearchParamForResourceType(tIncludeBaseType,searchParam)
				Quit:searchParam=""
				
				// Is this a reference to the search type?
				if (searchParam.type = "reference") {
					if (tTargetType="") || $ListFind(searchParam.target, tTargetType) {
						// Include this search param
						Set value = tIncludeBaseType _ ":" _ searchParam.name
						if tTargetType '= "" {
							Set value = value _ ":" _ tTargetType
						}
						if '$data(includeSet(value)) {
							set pResArr($i(pResArr))=searchParam
							set pResArr(pResArr,"targetType")=tTargetType
							
							If $$$FSLogIsActive($$$FSChannelInclude) {
								set $List(tValidIncludes, *+1) = value
							}
							
						}
						Set includeSet(value) = ""
					}
				}
			}
		}
	}
	$$$FSLogInclude("include: "_$LTS(tValidIncludes))
}

/// Validates the incoming $LIST of values provided to the _include parameter and builds
/// a $LIST of valid include requests ( <resourceType>:<searchParam>[:<targetResourceType>] )
/// Forms:
///  resourceType:* - Include resources of resourceType if any searchParam references the search target
///  resourceType:searchParam - Include resources of resourceType if specified searchParam references the search target
///  resourceType:searchParam:targetType - targetType must match search Resource Type if present
Method BuildRevIncludeList(ByRef includeValues, pResourceType As %String, ByRef pErrorList As %Status, ByRef pRes As %CacheString) [ Internal ]
{
	// If the query has an _include param or params, make sure it's valid, otherwise return an operation outcome.
	// This just validates _include, the actual processing is below.
	kill pRes
	set pRes = 0
	set tValidIncludes = ""

	for tJ=1:1:includeValues {
		Set tOneInclude = includeValues(tJ).value		
		set tIncludeBaseType = $P(tOneInclude, ":", 1)
		set tIncludeParam = $P(tOneInclude, ":", 2)
		set tTargetType = $P(tOneInclude, ":", 3)
		
		// Assert that the base type of the include matches the search type.
		if (tIncludeBaseType = pResourceType) {
			$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidRevIncludeBaseType,tOneInclude))
			Continue
		} 
		if ((tTargetType '= "") && (tTargetType '= pResourceType)) {
			$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidRevIncludeTargetType,tOneInclude))
			Continue
		}
		#dim searchParam as HS.FHIRServer.SearchParam
		if tIncludeParam = "*" {
			// First see if the search target has compartments
			// If it does, then we search the targetType for all resources in the compartment
			set searchParam = ""
			for {
				Set searchParam = ..%Schema.NextSearchParamForResourceType(tIncludeBaseType,searchParam)
				Quit:searchParam=""
				Set paramName = searchParam.code
				// Is this a reference to the search type?
				if (searchParam.type = "reference") && $ListFind(searchParam.target, pResourceType) {
					set pRes($i(pRes))=searchParam
					set pRes(pRes,"targetType")=tTargetType
					If $$$FSLogIsActive($$$FSChannelInclude) {
						set $List(tValidIncludes, *+1) =   tIncludeBaseType _ ":" _ paramName
					}
				}
			}
		} else {
			set searchParam = ..%Schema.FindSearchParam(tIncludeBaseType, tIncludeParam)
			if searchParam="" {
				$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidQueryParameter, tIncludeBaseType, tOneInclude))
				Continue
			}
			// Assert that the named param is of type "reference"
			if (searchParam.type '= "reference") {
				$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidIncludeReference,tOneInclude))
				Continue
			} elseif ( $ListFind( searchParam.target, pResourceType) = 0 ) {
				// The reference from the desired included type can reference the search type
				$$$FHIRAddError(pErrorList, $$$ERROR($$$HSFHIRErrInvalidRevIncludeReference,tOneInclude, pResourceType))
				Continue
			}
			// Put it in the list of valid includes if it passes validation
			set pRes($i(pRes))=searchParam
			set pRes(pRes,"targetType")=tTargetType
			If $$$FSLogIsActive($$$FSChannelInclude) {
					set $List(tValidIncludes, *+1) =  tOneInclude
			}
		}		
	}
	$$$FSLogInclude("revInclude: "_$LTS(tValidIncludes))
}

Method History(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	#; http://hl7.org/fhir/http.html#history

	set pResponse.Id = pRequest.Id

	// Assert that this interaction on this resource type is allowed as per the
	// Conformance/CapabilityStatement. While the FHIR REST API refers to the search by type
	// interaction as "history", the Conformance/CapabilityStatement resource uses value set
	// TypeRestfulInteraction http://hl7.org/fhir/ValueSet/type-restful-interaction for
	// interaction, which specifies a name of "history-instance" for this interaction.
	Do ..RequireAllowedResourceInteraction(pRequest.Type, "history", pRequest.Interaction)

	// Load any _count and _since parameter info into the tCount and tSince variables.
	// If bad values are found, ignore them and include a warning in the returned payload.
	Set tErrorStatus = $$$OK
	set tCount = ""
	set tSince = ""
	set tKey = ""

	Set tValue = pRequest.Parameters.GetOneParameterValue("_count", .pModifier)
	if tCount '= "" {
		if (tCount?1N.N)&&(tCount>0) {
			Set tCount = tValue
		} else {
			$$$FHIRAddError(tErrorStatus, $$$ERROR($$$HSFHIRErrInvalidParameterValue, "_count", tValue, $$$OutcomeIs(400, "warning", "value")))
		}
	}
	Set tValue = pRequest.Parameters.GetOneParameterValue("_since", .pModifier)
	if tValue '= "" {
		if (tValue ? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N1(1"Z",1"-"2N1":"2N,1"+"2N1":"2N)) {
			set tSince = ##class(HS.FHIRServer.Utils).ConvertToUTC(tValue)
		} else {
			// value as passed in failed validation, so ignore it
			$$$FHIRAddError(tErrorStatus, $$$ERROR($$$HSFHIRErrInvalidParameterValue, "_since", tValue, $$$OutcomeIs(400, "warning", "value")))
		}
	}
	Set tValue = pRequest.Parameters.GetOneParameterValue("_at", .pModifier)
	if tValue '= "" {
		$$$FHIRAddError(tErrorStatus, $$$ERROR($$$HSFHIRErrUnsupportedParameter, "_at", $$$OutcomeIs(400, "warning", "value")))
	}
	
	// Strict parameter handling for History
	$$$ThrowOnError(tErrorStatus)

	// TODO: Add support for _at.
	set tAt = ""
	
	Set privNeeded = ..GetPrivFromRequest(pRequest)
	
	// If an OAuth 2.0 access token was provided with this request, verify
	// that the request info does not indicate that the interaction is not
	// allowed per the token. This will Throw if the history is not allowed.
	If pRequest.Type '= "" {
		Do ..%interactions.oauth2TokenHandler.VerifyResourceIdRequest(pRequest.Type, pRequest.Id, privNeeded)
	} Else {
		Do ..%interactions.oauth2TokenHandler.VerifySystemLevelRequest()
	}

	#dim tHistoryResultSet As HS.FHIRServer.Util.SearchResult
	set tHistoryResultSet = ..%interactions.History( pRequest.Type, pRequest.Id, tSince, tAt)
	
	kill bundleUrls
	Set bundleUrls("self") = ..GetFullRequestURL( pRequest )

	Set bundle = ..CreateBundle("", "history", tHistoryResultSet.%ROWCOUNT, .bundleUrls, ..Schema)

	if tCount="" set tCount = tHistoryResultSet.%ROWCOUNT
	
	while tHistoryResultSet.%Next(.tSC) {
		$$$ThrowOnError(tSC)
		Set bundleEntry = ..AddBundleEntry(bundle)
		Set bundleEntry.request = $$$NewJSONObject
		Set tVerb = tHistoryResultSet.Verb
		Set bundleEntry.request.method = tVerb
		Set bundleEntry.request.url = pRequest.Type_$S(tVerb'="POST":"/"_pRequest.Id, 1:"")
		set tDeleted = tHistoryResultSet.IsDeleted
		if 'tDeleted {
			Set bundleEntry.resource = ..%interactions.Read(tHistoryResultSet.ResourceType, tHistoryResultSet.ResourceId, tHistoryResultSet.VersionId)
		}
		
	}
	set pResponse.Json = ..FinalizeBundle(bundle)
	
	// If an OAuth 2.0 access token was provided with this request, verify
	// that the contents of the retrieved resource Bundle satisfies the scope(s)
	// and context of the token. This will Throw if the history is not allowed.
	Do ..%interactions.oauth2TokenHandler.VerifyHistoryInstanceResponse(pRequest.Type, bundle, privNeeded)
	
	set pResponse.Status = 200
}

Method Operation(pRequest As HS.FHIRServer.API.Data.Request, pResponse As HS.FHIRServer.API.Data.Response)
{
	Do ..interactions.Operation($this, pRequest, pResponse)
}

/// RequireAllowedResourceInteraction validates that the specified interaction is permitted by the Conformance/CapabilityStatement
/// server definition.<br>From FHIR Spec:  
/// In general, if an instance fails the constraints documented in the CapabilityStatement then the response should be a 400
/// <br>
/// Input:<br>
/// <li>pInteraction         : (required) FHIR RESTful interaction.
/// <li>pInteraction2         : (required) A more specific interaction (e.g. history, history-instance).
/// Return: void, but throws if interaction is not allowed
Method RequireAllowedResourceInteraction(pResourceType As %String, pInteraction As %String, pInteractionLevel2 As %String = "")
{
	set entry = ""
	Set interactionLevel2 = $select(pInteractionLevel2="": pInteraction, 1: pInteractionLevel2)
	Set rsrcMeta = ..RestResourceMap.%Get(pResourceType)
	if rsrcMeta '= "" {
		Set entry = ..findItemByProperty( rsrcMeta.interaction, "code", pInteraction )
		if (entry = "") && (interactionLevel2 '= pInteraction) {
			Set entry = ..findItemByProperty( rsrcMeta.interaction, "code", pInteractionLevel2 )
		}
	}
	If entry="" {
		if (interactionLevel2 = pInteraction) {
			$$$ThrowFHIR($$$HSFHIRErrInteractionNotSupported, pResourceType, pInteraction, $$$OutcomeNotSupported(400))
		}
		$$$ThrowFHIR($$$HSFHIRErrInteractionsNotSupported, pResourceType, pInteraction, interactionLevel2, $$$OutcomeNotSupported(400))
	}
}

/// RequireAllowedSystemInteraction validates that the specified interaction is permitted by the Conformance/CapabilityStatement
/// server definition.<br>From FHIR Spec:  
/// In general, if an instance fails the constraints documented in the CapabilityStatement then the response should be a 400<br>
/// <br>
/// Input:<br>
/// <li>pInteraction         : (required) FHIR RESTful interaction.
/// Return: void, but throws if interaction is not allowed
Method RequireAllowedSystemInteraction(pInteraction As %String) As %Boolean
{
	Set entry = ..findItemByProperty( ..RestServerMeta.interaction, "code", pInteraction )
	if (entry = "") {
		$$$ThrowFHIR($$$HSFHIRErrSystemInteractionNotSupported, pInteraction, $$$OutcomeNotSupported(400))
	}
}

ClassMethod GetPreferHeader(pRequest As HS.FHIRServer.API.Data.Request, pPreferenceType As %String) As %String
{
	Set tHeader = pRequest.Prefer
	Set tPreference = ""
	For i = 1:1:$Length(tHeader,";") {
		If $Piece($Piece(tHeader,";",i),"=",1)=pPreferenceType {
			Set tPreference = $Piece($Piece(tHeader,";",i),"=",2)
			$$$FSLog("Preference: "_tPreference)
			Quit
		}
	}
	Return tPreference
}

Method IsPreferStrictHandling(pRequest As HS.FHIRServer.API.Data.Request) As %Boolean
{
	// If Prefer:handling=strict, then it means that the request has asked
	// the server to consider unrecognized and/or unsupported search parameters
	// to be an error, rather than just being a condition to be ignored with a
	// warning.
	Set tPreferHandling = ..GetPreferHeader(pRequest, "handling")
	if tPreferHandling = "" {
		Set tPreferHandling = $Select(..%ConfigData.DefaultPreferHandling="":"lenient", 1:..%ConfigData.DefaultPreferHandling)
	}
	return (tPreferHandling = "strict")
}

ClassMethod GetFullRequestURL(pRequest As HS.FHIRServer.API.Data.Request)
{
	// When we build the full URL, we do not echo bad search parameters (they are still
	// available in pRequest.QueryString if needed)
	Set url = ..GetRequestURLNoQuery(pRequest)
	Set queryString = pRequest.Parameters.AsString()
	if queryString '= "" {
		set url = url _ "?" _ queryString	
	}
	Return url
}

ClassMethod GetRequestURLNoQuery(pRequest As HS.FHIRServer.API.Data.Request)
{
	Quit pRequest.BaseURL_$Select($Extract(pRequest.BaseURL,*)="/":"",1:"/")_pRequest.RequestPath
}

/// API
/// GetResourceCapabilityItem examines the specified Conformance/CapabilityStatement for the
/// the specified resource type and returns the value for the specified "capability item".<br>
/// <br>
/// Input:<br>
/// <li>pResourceType        : (required) FHIR resource type.
/// <li>pCapabilityItem      : (required) Resource type capability item (examples: "conditionalCreate", "readHistory").
/// <li>pDefault             : (required) Value to return if the specification is not present
Method IsCapabilitySupported(pResourceType As %String, pCapabilityItem As %String, pDefault As %Boolean) As %Boolean
{
	Set result = pDefault
	Set rsrcMeta = ..RestResourceMap.%Get(pResourceType)
	if rsrcMeta'="" {
		Set value = rsrcMeta.%Get(pCapabilityItem)
		if value '= "" {
			Set result = value
		}
	}
	Quit result
}

Method GetCapabilityStatus(pResourceType As %String, pCapabilityItem As %String) As %String
{
	Set result = ""
	Set rsrcMeta = ..RestResourceMap.%Get(pResourceType)
	if rsrcMeta'="" {
		Set result = rsrcMeta.%Get(pCapabilityItem)
	}
	Quit result
}

// Find the first object in an array that has a specific property value

ClassMethod findItemByProperty(array As %DynamicArray, propName As %String, propValue)
{
	Set iter = array.%GetIterator()
	while iter.%GetNext(.key , .value ) {
		if value.%Get(propName) = propValue {
			Return value
		}
	}
	Quit ""
}

/// Checks if the specified resource is a member of the Patient compartment.  If so, then it
/// inspects the enumerated reference properties to see if there is a reference to the specified
/// Patient resource id.
/// TODO:  This does (may) not handle compound property names properly...
///        it seems they indicate that the first property is an array of objects that have a "reference" property of
///        type reference.  So its like "AuditEvent.entity[n].reference.reference" but indicated by "entity.patient"
/// 
Method IsResourceForPatient(pResourceObj As %DynamicObject, pPatientResourceId As %String) As %Boolean [ Internal ]
{
	// Get the list of compartments that this resource is a part of
	Set compartmentList = ..Schema.BuildCompartmentList(pResourceObj)
	// return whether it includes a compartment for the specified Patient
	return $ListFind(compartmentList, "Patient/" _ pPatientResourceId)
}

ClassMethod RequireValidId(pId) As %String
{
	If ((pId '= "") && ($Length(pId)>64) || ($Translate(pId,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.")'=""))
	{
		$$$ThrowFHIR($$$HSFHIRErrInvalidId, pId, $$$OutcomeInvalid(400))
	}
	return pId
}

Method RequirePayload(pRequest As HS.FHIRServer.API.Data.Request) As %DynamicObject
{
	Set payload = pRequest.Json
	if payload = "" {
		$$$ThrowFHIR($$$HSFHIRErrPayloadMissing, pRequest.Interaction,$$$OutcomeIs(400, "invalid", "missing payload"))
	}
	Return payload
}

ClassMethod ETagValue(pVersionId As %String) As %String [ CodeMode = expression ]
{
"W/"""_pVersionId_""""
}

ClassMethod GetPrivFromRequest(pRequest As HS.FHIRServer.API.Data.Request) As %String [ CodeMode = expression ]
{
$Case(pRequest.AdditionalInfo.GetAt("USER:PrivilegeNeeded"), "r":"read", "w":"write", "*":"*", :pRequest.AdditionalInfo.GetAt("USER:PrivilegeNeeded"))
}

}
