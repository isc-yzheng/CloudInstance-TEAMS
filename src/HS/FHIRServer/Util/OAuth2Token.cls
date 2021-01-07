Include HS.FHIRServer

/// Class for OAuth 2.0 access token handling. An instance of this class is expected to be
/// instantiated and set as a property on an Interactions instance. There it will be used
/// for all interactions handled during the life of the Interactions instance.
Class HS.FHIRServer.Util.OAuth2Token Extends HS.FHIRServer.API.OAuth2Token
{

/// The access token string, as extracted from a FHIR REST API request.
Property %TokenString As %String(MAXLEN = 8192) [ Private ];

/// OAuth 2.0 Client name, as defined in System Administration > Security > OAuth 2.0 > Client.
Property %OAuthClient As %String(MAXLEN = 256) [ Private ];

/// FHIR request BaseURL.
Property %BaseURL As %String(MAXLEN = 1024) [ Private ];

/// FHIR request Basic Auth username.
Property %Username As %String(MAXLEN = 256) [ Private ];

/// Flag indicating whether access token sub must match FHIR request Basic Auth username.
Property %MatchUsername As %Boolean [ Private ];

/// The access token JWT object, as derived from validating via OAuth 2.0 API calls. 
Property %TokenObject As %Library.DynamicObject [ Private ];

/// $List of access token JWT scopes.
Property %ScopesList As %List [ Private ];

/// Array of clinical scopes present. Array format is:<br>
/// ..%ClinicalScopes(clinicalScopeName, N, "resourceType") = resourceType<br>
/// ..%ClinicalScopes(clinicalScopeName, N, "readWrite") = readWrite<br>
Property %ClinicalScopes As %String [ MultiDimensional, Private ];

/// Array of context values present (e.g., ..%ContextValues("patient") = 123)
Property %ContextValues As %String [ MultiDimensional, Private ];

/// The schema object that governs evaluation of resources and resource definitions.
Property %schema As HS.FHIRServer.Schema [ Private ];

Method TokenStringGet() As %String [ CodeMode = expression ]
{
..%TokenString
}

Method OAuthClientGet() As %String [ CodeMode = expression ]
{
..%OAuthClient
}

Method BaseURLGet() As %String [ CodeMode = expression ]
{
..%BaseURL
}

Method UsernameGet() As %String [ CodeMode = expression ]
{
..%Username
}

Method TokenObjectGet() As %String [ CodeMode = expression ]
{
..%TokenObject
}

Method ScopesListGet() As %String [ CodeMode = expression ]
{
..%ScopesList
}

Method %OnNew(pSchema As HS.FHIRServer.Schema) As %Status
{
	Set ..%schema = pSchema
	Return $$$OK
}

/// @API<br>
/// Set or reset the properties of the current token handler instance, based on the input parameters.<br>
/// @Input pTokenString The access token string.<br>
/// @Input pOAuthClient The OAuth 2.0 Client Name, as defined in the Management Portal at System Administration > Security > OAuth 2.0 > Client.
/// @Input pBaseURL The base URL, including scheme, host, port and path of the end point for the current FHIR interaction.
/// @Input pUserame The effective username for the current FHIR interaction.
Method SetInstance(pTokenString As %String = "", pOAuthClient As %String = "", pBaseURL As %String = "", pUsername As %String = "")
{
	// If this is a re-set to the same parameters as before (e.g., same token applied
	// to consecutive interactions on the same end point by the same user) then just
	// retain all properties as is and return.
	
	If (pTokenString = ..%TokenString) && (pOAuthClient = ..%OAuthClient) && (pBaseURL = ..%BaseURL) && (pUsername = ..%Username) {
		Return
	}
	
	Set ..%TokenString = pTokenString
	Set ..%OAuthClient = pOAuthClient
	Set ..%BaseURL = pBaseURL
	Set ..%Username = pUsername
	
	If (pTokenString '= "") {
		Do ..ValidateToken()
	}
	
	$$$ThrowOnError(..%ValidateObject())
	
	Return
}

/// Uses the instance properties populated by SetInstance() to validate the access
/// token and to derive and expose access token data that will be used for verifying
/// that a given FHIR request is allowed by the token. If ValidateToken() fails then
/// it will Throw. Otherwise, it will simply Return.
Method ValidateToken() [ Private ]
{
	// Must specify an OAuth 2.0 Client name if going to handle a token.
	If (..%TokenString '= "") && (..%OAuthClient = "") {
		$$$FSLog("OAuth access token received on end point that has no OAuth 2.0 Client defined")
		$$$ThrowFHIR($$$HttpOnlyResponse(403))
	}
	
	Set scope = ""
	
	Set tReturn = ##class(%SYS.OAuth2.Validation).ValidateJWT(..%OAuthClient, ..%TokenString, "", "", .JWTObj, .securityParams, .tSC)
	If tReturn = 1 {
		Set scope = JWTObj.scope
	}
	
	If scope="" {
		Set tSC = ##class(%SYS.OAuth2.AccessToken).GetIntrospection(..%OAuthClient, ..%TokenString, .JWTObj)
		If ($$$ISERR(tSC)) || ('JWTObj.active) {
			$$$FSLog("Invalid or inactive OAuth AccessToken")
			$$$ThrowFHIR($$$HttpOnlyResponse(401))
		}
	}
	
	Set ..%TokenObject = JWTObj
	
	// Validate the audience against our BaseURL.
	If '..ValidateAudience() {
		$$$FSLog("Wrong Audience: '" _ $Select($IsObject(JWTObj.aud):JWTObj.aud.%ToJSON(),1:JWTObj.aud) _ "' for " _ ..%BaseURL)
		$$$ThrowFHIR($$$HttpOnlyResponse(401))
	}
	
	// Verify that the token is for our current user.
	If '..ValidateSub() {
		$$$FSLog("Token sub '" _ JWTObj.sub _ "' failed validation - username: " _ ..%Username)
		$$$ThrowFHIR($$$HttpOnlyResponse(401))
	}
	
	Do ..SetScopes()
	
	Do ..SetContextValues()
	
	// Ensure that the scopes and context are reasonably sensical.
	// - Must have at least one scope.
	// - Must have at least one patient or user clinical scope.
	// - If patient context is present, then at least one patient clinical scope must also be present.
	// - If a patient clinical scope is present, then patient context must also be present.
	
	If ..%ScopesList = "" {
		$$$FSLog("No scopes found in access token")
		$$$ThrowFHIR($$$HttpOnlyResponse(403))
	} ElseIf '($Data(..%ClinicalScopes("patient")) || $Data(..%ClinicalScopes("user"))) {
		$$$FSLog("No patient or user clinical scopes found in access token")
		$$$ThrowFHIR($$$HttpOnlyResponse(403))
	} ElseIf ($Data(..%ClinicalScopes("patient"))) && ('$Data(..%ContextValues("patient"))) {
		$$$FSLog("No patient context provided for patient clinical scope in access token")
		$$$ThrowFHIR($$$HttpOnlyResponse(403))
	} ElseIf ('$Data(..%ClinicalScopes("patient"))) && ($Data(..%ContextValues("patient"))) {
		$$$FSLog("No patient clinical scope provided for patient context in access token")
		$$$ThrowFHIR($$$HttpOnlyResponse(403))
	}
	
	Return
}

/// Parses the token JWT object "scope" property and populates %ScopesList and %ClinicalScopes.
Method SetScopes() [ Private ]
{
	Set scopesList = ""
	
	Set scopesString = ..%TokenObject.scope
	
	For i = 1:1:$Length(scopesString," ") {
		Set nextScope = $Piece(scopesString," ",i)
		Continue:nextScope=""
		Set $List(scopesList, *+1) = nextScope
		If $Extract(nextScope, 1, 8) = "patient/" {
			Set clinicalScopeName = "patient"
		} ElseIf $Extract(nextScope, 1, 5) = "user/" {
			Set clinicalScopeName = "user"
		} Else {
			Set clinicalScopeName = ""
		}
		If clinicalScopeName '= "" {
			Set scopeTypeAndRW = $Piece(nextScope, "/", 2)
			Set scopeResourceType = $Piece(scopeTypeAndRW, ".", 1)
			Set scopeReadWrite = $Piece(scopeTypeAndRW, ".", 2)
			Set N = $Get(..%ClinicalScopes(clinicalScopeName)) + 1
			Set ..%ClinicalScopes(clinicalScopeName, N, "resourceType") = scopeResourceType
			Set ..%ClinicalScopes(clinicalScopeName, N, "readWrite") = scopeReadWrite
			Set ..%ClinicalScopes(clinicalScopeName) = N
		}
	}
	
	Set ..%ScopesList = scopesList
	
	Return
}

/// Derives context values (e.g., patient context) from the access token JWT object
/// information. Default functionality is to derive it from scopes that are
/// formatted as "launch/" _ contextName _ "/" _ contextValue, or from a specific
/// JWT property such as "patient".
Method SetContextValues() [ Private ]
{
	Set scopesString = ..%TokenObject.scope
	
	For i = 1:1:$Length(scopesString," ") {
		Set nextScope = $Piece(scopesString," ",i)
		Continue:nextScope=""
		If ($Extract(nextScope, 1, 7) = "launch/") && ($Length(nextScope, "/") = 3) {
			Set p2 = $Piece(nextScope, "/", 2)
			Set p3 = $Piece(nextScope, "/", 3)
			If p2?1A.A {
				If p3 '="" {
					Set ..%ContextValues(p2) = p3
				} ElseIf ..%TokenObject.%Get(p2) '= "" {
					Set ..%ContextValues(p2) = ..%TokenObject.%Get(p2)
				}
			}
		}
	}
	
	For context = "patient", "encounter" {
		If (..%TokenObject.%Get(context) '= "") && ($Get(..%ContextValues(context)) = "") {
			Set ..%ContextValues(context) = ..%TokenObject.%Get(context)
		}
	}
	
	Return
}

/// Compares the current audience against the token aud value(s), if any. The comparison
/// is trailing-slash-insensitive and case-insensitive. InterSystems FHIR requires an
/// access token have an audience that matches the current audience (i.e., the current
/// end point, defined as scheme + host + port + current %CSP.Request Application).
Method ValidateAudience() As %Boolean [ Private ]
{
	Set JWTAudience = ..%TokenObject.aud
	
	If JWTAudience'="" {
		Set matched = 0
		Set currentAud = $$formatAud(..%BaseURL)
		If '$IsObject(JWTAudience) {
			// Compare single audience from JWT.
			If $$formatAud(JWTAudience)=currentAud {
				Set matched = 1
			}
		} Else {
			// Compare multiple audience from JWT. In this case it is a %DynamicArray.
			For i = 0:1:JWTAudience.%Size()-1 {
				If $$formatAud(JWTAudience.%Get(i))=currentAud {
					Set matched = 1
					Quit
				}
			}
		}
		
	} Else {
		// If no aud in the token, then it does not match the current audience.
		Set matched = 0
	}
	
	Return matched
	
formatAud(aud)
	// Strip trailing slash, convert to lowercase.
	If $Extract(aud, *)="/" {
		Set aud = $Extract(aud, 1, *-1)
	}
	Set aud = $ZConvert(aud, "L")
	Return aud
}

/// Verify that the access token sub is okay.
Method ValidateSub() As %Boolean [ Private ]
{
	Set username = $ZConvert(..%Username, "U")
	
	If '((username = "UNKNOWNUSER") || (username = "")) {
		If $ZConvert(..%TokenObject.sub, "U") = username {
			Set ok = 1
		} Else {
			Set ok = 0
		}
	} Else {
		Set ok = 1
	}
	
	Return ok
}

/// Return a Boolean indicating whether the current specified clinical scope
/// allows the specified interaction per resource type plus read/write.
Method HasScope(pClinicalScopeName, pResourceType, pRequiredPrivilege) As %Boolean
{
	Set hasScope = 0
	
	Set n = ""
	For {
		Set n = $Order(..%ClinicalScopes(pClinicalScopeName, n))
		If n="" Quit
		If ((..%ClinicalScopes(pClinicalScopeName, n, "resourceType")="*") || (..%ClinicalScopes(pClinicalScopeName, n, "resourceType")=pResourceType)) 
			&& 
			((..%ClinicalScopes(pClinicalScopeName, n, "readWrite")="*") || (..%ClinicalScopes(pClinicalScopeName, n, "readWrite")=pRequiredPrivilege)) {
			Set hasScope = 1
			Quit
		}
	}
	
	Return hasScope
}

/// Return a Boolean indicating that the specified resource content resides in the
/// specified compartment (compartment type plus resource id).
Method HasCompartment(pCompartmentType As %String, pCompartmentResourceId As %String, pResourceJson As %DynamicObject) As %Boolean
{
	Set hasCompartment = 0
	Set otherCompartmentVals = ""
	
	Set resourceType = pResourceJson.resourceType
	Set resourceId = pResourceJson.id
	Set compartmentResourceType = $ZConvert($Extract(pCompartmentType), "U") _ $Extract(pCompartmentType, 2, *)
	
	Set compartmentsList = ..GetCompartments(..%schema, pResourceJson)
	
	Set listIndex = 0
	While $ListNext(compartmentsList, listIndex, refVal) {
		Set refType = $Piece(refVal, "/", *-1)
		Set refId = $Piece(refVal, "/", *)
		If (refType = compartmentResourceType) && (refId = pCompartmentResourceId) {
			Set hasCompartment = 1
			Quit
		}
	}
	
	Return hasCompartment
}

ClassMethod GetCompartments(pSchema As HS.FHIRServer.Schema, pResourceJson As %DynamicObject) As %List [ Final, Internal ]
{
	// GetCompartments segregated here and conditionalized to be able
	// to run on pre- and post- IF-875 code base.
	
	Set compartmentsFound = ""
	
	Try {
		Set isNewParams = pSchema.isNewParams
	} Catch compartmentsEx {
		Set isNewParams = 0
	}
	
	If isNewParams {
		Set compartmentsFound = pSchema.GetCompartmentsForResource(pResourceJson)
	} Else {
		Set compartmentsFound = pSchema.BuildCompartmentList(pResourceJson)
	}
	
	Return compartmentsFound
}

/// Verify that the access token allows the current interaction request based on the resource type,
/// resource id and required privilege. If not allowed, this method will Throw. Otherwise, it will
/// simply Return. Note that despite returning from this call, the corresponding response to the
/// interaction could still fail verification.<br>
/// <br>
/// This method typically used for read, vread or history-instance requests.
Method VerifyResourceIdRequest(pResourceType As %String, pResourceId As %String, pRequiredPrivilege As %String)
{
	If ..%TokenString = "" Return
	
	// patient context and scopes supersedes user scopes.
	If $Data(..%ClinicalScopes("patient")) {
		
		// No specific check for Patient resource type + resource id here. Reading a
		// Patient resource that is NOT the patient context resource id but IS in
		// the Patient compartment for the patient context resource id is okay.
		// However, we won't know the latter until we actually look at the response.
		
		// No requiredPrivilege access to the requested resource type is definitely a fail.
		If '..HasScope("patient", pResourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg( , "patient", pRequiredPrivilege, pResourceType) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		Return
		
	} ElseIf $Data(..%ClinicalScopes("user")) {
		
		If '..HasScope("user", pResourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg( , "user", pRequiredPrivilege, pResourceType) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
	}
	
	Return
}

/// Verify that the access token allows the current interaction on the specified resource, based on
/// the content and required privilege. If not allowed, this method will Throw. Otherwise, it will
/// simply Return.<br>
/// <br>
/// This method typically used for read response, create request, update request, patch request.
Method VerifyResourceContent(pResourceJson As %DynamicObject, pRequiredPrivilege As %String, pAllowSharedResource As %Boolean = 0)
{
	If ..%TokenString = "" Return
	
	Set resourceType = pResourceJson.resourceType
	Set resourceId = pResourceJson.id
	
	// patient context and scopes supersedes user scopes.
	If $Data(..%ClinicalScopes("patient")) {
		
		// Lack of requiredPrivilege access to the requested resource type is not allowed.
		If '..HasScope("patient", resourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg( , "patient", pRequiredPrivilege, resourceType) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		// Update of Patient resource that is resource id matching the required context is okay.
		If (resourceType = "Patient") && (resourceId = ..%ContextValues("patient")) {
			Return
		}
		
		If ..%schema.IsSharedResourceType(resourceType) {
			If pAllowSharedResource {
				Return
			} Else {
				$$$FSLog("Request on shared resource when patient clinical context present is not allowed")
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
			}
		}
		
		If '..HasCompartment("patient", ..%ContextValues("patient"), pResourceJson) {
			$$$FSLog("Resource content for request is not in patient clinical scope compartment")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		Return
		
	} ElseIf $Data(..%ClinicalScopes("user")) {
		
		If '..HasScope("user", resourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg( , "user", pRequiredPrivilege, resourceType) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
	}
	
	Return
}

/// Verify that the access token allows the history-instance request based on the contents of
/// the interaction response and required privilege. If not allowed, this method will Throw.
/// Otherwise, it will simply Return.
Method VerifyHistoryInstanceResponse(pResourceType As %String, pResourceJson As %DynamicObject, pRequiredPrivilege As %String)
{
	If ..%TokenString = "" Return
	
	// patient context and scopes supersedes user scopes.
	If $Data(..%ClinicalScopes("patient")) {
		
		If ('$IsObject(pResourceJson)) || ('pResourceJson.%Size()) || (pResourceJson.entry = "") {
			// Nothing found, nothing to unauthorize or forbid.
			Return
		}
		
		// Only check the last (most recent) resource in the Bundle.
		For entryIndex = pResourceJson.entry.%Size()-1:-1:0 {
			Set resourceObj = pResourceJson.entry.%Get(entryIndex).resource
			// It is possible for a history entry to not have a resource.
			If '$IsObject(resourceObj) Continue
			// Could be an OperationOutcomes, skip if it is not the requested resource type.
			If resourceObj.resourceType '= pResourceType Continue
			If '..HasCompartment("patient", ..%ContextValues("patient"), resourceObj) {
				$$$FSLog("history response resource is not in patient clinical scope compartment")
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
			}
		}
		
		Return
		
	} ElseIf $Data(..%ClinicalScopes("user")) {
		
		If '..HasScope("user", pResourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg( , "user", pRequiredPrivilege, pResourceType) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
	}
	
	Return
}

/// Verify that the access token allows the search request based on some or all of resource type,
/// resource id, compartment type, search parameters and required privilege. If not allowed, this
/// method will Throw. Otherwise, it will simply Return.
Method VerifySearchRequest(pResourceType As %String, pCompartmentResourceType As %String, pCompartmentResourceId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters, pRequiredPrivilege As %String)
{
	If ..%TokenString = "" Return
	
	Set compartmentType = $ZConvert($Extract(pCompartmentResourceType), "L") _ $Extract(pCompartmentResourceType, 2, *)
	
	// patient context and scopes supersedes user scopes.
	If $Data(..%ClinicalScopes("patient")) {
		
		// patient scopes verification:
		// - For Patient search, must be search by single _id parameter, and nothing else.
		// - For non-Patient search:
		// - - Must include single patient-reference search parameter.
		// - - _include and _revinclude allowed but only for resources in allowed scopes.
		// - - chain and revchain not allowed.
		
		If '..HasScope("patient", pResourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg("Search", "patient", pRequiredPrivilege, pResourceType) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		If (pCompartmentResourceType = "Patient") && (pCompartmentResourceId '= ..%ContextValues("patient")) {
			$$$FSLog("Search specified Patient compartment does not match access token patient context")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		Set PatientByIdParam = ""
		Set PatientSearchParam = ""
		Set paramCount = 0
		
		For paramIndex = pParameters.Count():-1:1 {
			Set searchQueryParameter = pParameters.GetAt(paramIndex)
			Set paramName = searchQueryParameter.name
			Set paramVal = searchQueryParameter.value
			
			// The only "non search params" evaluated here are _include and _revinclude.
			// Search params are expected to have been vetted by the stack by this point.
			// Therefore, if paramName is not valid for pResourceType, FindSearchParam
			// will Throw, which should be expected.
			If '..%schema.IsNonSearchParam(paramName) {
				Set searchParamObj = ..%schema.FindSearchParam(pResourceType, paramName)
				
			} ElseIf '((paramName = "_include") || (paramName = "_revinclude")) {
				Continue
			}
			
			If (pResourceType = "Patient") && (paramName = "_id") {
				// Multiple Patient _id parameter values not allowed.
				If ((PatientByIdParam '= "") || (paramVal [ ","))  {
					$$$FSLog("Search request specifies conflicting Patient _id search parameters - unable to verify compliance to specified access token patient context")
					$$$ThrowFHIR($$$HttpOnlyResponse(403))
				}
				Set PatientByIdParam = paramVal
				
			} ElseIf paramName = "_include" {
				Set clinicalScopeType = "patient"
				Do evaluateInclude
				
			} ElseIf paramName = "_revinclude" {
				If '..HasScope("patient", $Piece(paramVal, ":", 1), pRequiredPrivilege) {
					$$$FSLog( ..FSLogScopeMsg("Search", "patient", pRequiredPrivilege, $Piece(paramVal, ":", 1)) )
					$$$ThrowFHIR($$$HttpOnlyResponse(403))
				}
				
			} ElseIf (searchParamObj.target = $ListBuild("Patient")) ||
					(($ListFind(searchParamObj.target, "Patient")) && ($Extract(paramVal, 1, 8) = "Patient/")) {
				// Multiple Patient-related reference parameters not allowed.
				If PatientSearchParam '= "" {
					$$$FSLog("Search request specifies conflicting Patient reference search parameters - unable to verify compliance to specified access token patient context")
					$$$ThrowFHIR($$$HttpOnlyResponse(403))
				}
				Set PatientSearchParam = paramVal
				
			} ElseIf searchQueryParameter.nextInChain '= "" {
				// Chain not allowed.
				$$$FSLog("Search request chained parameter not allowed when access token patient context specified")
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
				
			} ElseIf searchQueryParameter.nextInRevChain '= "" {
				// Revese chain not allowed.
				$$$FSLog("Search request reverse chained parameter not allowed when access token patient context specified")
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
			}
			
			// _include and _revinclude are included in this count.
			Set paramCount = paramCount + 1
		}
		
		// If patient context specified then need to have some criteria that will
		// constrain the search results to the specified patient resource id.
		
		If (PatientByIdParam = "") && (PatientSearchParam = "") {
			$$$FSLog("Search request does not specify criteria to limit search to specified access token patient context")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		} ElseIf (PatientByIdParam '= "") && (PatientSearchParam '= "") {
			$$$FSLog("Search request specifies conflicting patient search parameters - unable to verify compliance to specified access token patient context")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		If PatientByIdParam '= "" {
			If paramCount > 1 {
				$$$FSLog("Search request search Patient by _id includes other search params - unable to verify compliance to specified access token patient context")
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
			} ElseIf PatientByIdParam '= ..%ContextValues("patient") {
				$$$FSLog("Search request search Patient by _id does not match specified access token patient context specified")
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
			}
			Return
		}
		
		If (PatientSearchParam '= "")  && ($Piece(PatientSearchParam, "/", *) '= ..%ContextValues("patient")) {
			$$$FSLog("Search request patient reference search parameter value does not match specified access token patient context specified")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		Return
		
	} ElseIf $Data(..%ClinicalScopes("user")) {
		
		// user scopes verification:
		// - search resource type must be allowed by user scope
		// - _include, _revinclude, chain, and revchain are allowed if resource type is allowed by user scope
		
		If '..HasScope("user", pResourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg("Search", "user", pRequiredPrivilege, pResourceType) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		For paramIndex = pParameters.Count():-1:1 {
			Set searchQueryParameter = pParameters.GetAt(paramIndex)
			Set paramName = searchQueryParameter.name
			Set paramVal = searchQueryParameter.value
			If paramName = "_include" {
				Set clinicalScopeType = "user"
				Do evaluateInclude
				
			} ElseIf paramName = "_revinclude" {
				If '..HasScope("user", $Piece(paramVal, ":", 1), pRequiredPrivilege) {
					$$$FSLog( ..FSLogScopeMsg("Search", "user", pRequiredPrivilege, $Piece(paramVal, ":", 1)) )
					$$$ThrowFHIR($$$HttpOnlyResponse(403))
				}
				
			} ElseIf searchQueryParameter.nextInChain '= "" {
				If '..HasScope("user", searchQueryParameter.modifier, pRequiredPrivilege) {
					$$$FSLog( ..FSLogScopeMsg("Search", "user", pRequiredPrivilege, searchQueryParameter.modifier) )
					$$$ThrowFHIR($$$HttpOnlyResponse(403))
				}
				
			} ElseIf searchQueryParameter.nextInRevChain '= "" {
				If '..HasScope("user", searchQueryParameter.searchParam.resourceType, pRequiredPrivilege) {
					$$$FSLog( ..FSLogScopeMsg("Search", "user", pRequiredPrivilege, searchQueryParameter.searchParam.resourceType) )
					$$$ThrowFHIR($$$HttpOnlyResponse(403))
				}
			}
		}
	}
	
	Return
	
evaluateInclude
	// Piece 2 is the search param name from the current search resource type.
	// target is the target resource type(s) for that search param.
	// Piece 3 is a specific target resource type, for when the search param has multiple targets.
	Set searchParamTarget = ..%schema.FindSearchParam(pResourceType, $Piece(paramVal, ":", 2)).target
	Set specificTargetResourceType = $Piece(paramVal, ":", 3)
	Set listLen = $ListLength(searchParamTarget)
	If (listLen=1) || ((listLen>1) && (specificTargetResourceType '= "")) {
		Set targetResourceType = $Select(listLen=1:searchParamTarget, 1:specificTargetResourceType)
		If '..HasScope(clinicalScopeType, targetResourceType, pRequiredPrivilege) {
			$$$FSLog( ..FSLogScopeMsg("Search", clinicalScopeType, pRequiredPrivilege, paramName) )
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
	} Else {
		Set listIndex = 0
		While $ListNext(searchParamTarget, listIndex, targetResourceType) {
			If '..HasScope(clinicalScopeType, targetResourceType, pRequiredPrivilege) {
				$$$FSLog( ..FSLogScopeMsg("Search", clinicalScopeType, pRequiredPrivilege, paramName) )
				$$$ThrowFHIR($$$HttpOnlyResponse(403))
			}
		}
	}
	Quit
}

/// Verify that the access token allows the system-level request. This is for system-history and
/// system-search. Default functionality is to ignore patient context, and require user/*.read
/// and/or user/*.*<br>
/// If not allowed, this method will Throw. Otherwise, it will simply Return.
Method VerifySystemLevelRequest()
{
	If ..%TokenString = "" Return
	
	Set hasScope = 0
	
	// Must have user/*.read or user/*.*
	
	// patient scopes are not applicable.
	
	Set index = 0
	While $ListNext(..%ScopesList, index, value) {
		If (value = ("user/*.read")) || (value = "user/*.*") {
			Set hasScope = 1
			Quit
		}
	}
	
	If 'hasScope {
		$$$FSLog("System-level request access token does not have user/*.read or user/*.* scope")
		$$$ThrowFHIR($$$HttpOnlyResponse(403))
	}
	
	Return
}

Method VerifyEverythingRequest(pResourceType As %String, pResourceId As %String, pResourceJson As %DynamicObject)
{
	If ..%TokenString = "" Return
	
	Set requiredPrivilege = "read"
	
	// patient context and scopes supersedes user scopes.
	If $Data(..%ClinicalScopes("patient")) {
		
		// Any $everything needs to have read access to all resource types.
		Set ok = 0
		Set N = ""
		For {
			Set N = $Order(..%ClinicalScopes("patient", N))
			If N="" Quit
			If (..%ClinicalScopes("patient", N, "resourceType") = "*") {
				If (..%ClinicalScopes("patient", N, "readWrite") = "*") || (..%ClinicalScopes("patient", N, "readWrite") = requiredPrivilege) {
					Set ok = 1
				}
			}
		}
		If 'ok {
			$$$FSLog("Patient $everything request access token does not have required patient read scope for all resource types")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		If (pResourceType = "Patient") && (pResourceId '= ..%ContextValues("patient")) {
			$$$FSLog(pResourceType _ " $everything request resource id does not match access token patient context value")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		If (pResourceType = "Encounter") && ('..HasCompartment("patient", ..%ContextValues("patient"), pResourceJson)) {
			$$$FSLog("Resource content for Encounter $everything request is not in patient clinical scope compartment")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
		
		Return
		
	} ElseIf $Data(..%ClinicalScopes("user")) {
		
		// Any $everything needs to have read access to all resource types.
		Set ok = 0
		Set N = ""
		For {
			Set N = $Order(..%ClinicalScopes("user", N))
			If N="" Quit
			If (..%ClinicalScopes("user", N, "resourceType") = "*") {
				If (..%ClinicalScopes("user", N, "readWrite") = "*") || (..%ClinicalScopes("user", N, "readWrite") = requiredPrivilege) {
					Set ok = 1
				}
			}
		}
		If 'ok {
			$$$FSLog(pResourceType _ " $everything request access token does not have required user read scope for all resource types")
			$$$ThrowFHIR($$$HttpOnlyResponse(403))
		}
	}
	
	Return
}

ClassMethod FSLogScopeMsg(pInteraction As %String = "", pClinicalScopeType As %String, pRequiredPrivilege As %String, pResourceType As %String = "") As %String
{
	Set msg = ""
	
	If pInteraction '= "" {
		Set msg = msg _ pInteraction _ " request"
	} Else {
		Set msg = msg _ "Request"
	}
	
	Set msg = msg _ " access token does not have required " _ pClinicalScopeType _ " clinical scope " _ pRequiredPrivilege _ " access to"
	
	If pResourceType '= "" {
		Set msg = msg _ " " _ pResourceType
	}
	
	Set msg = msg _ " resource type"
	
	Return msg
}

}
