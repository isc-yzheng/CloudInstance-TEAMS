/// FHIR REST Handler
Class HS.FHIR.vDSTU2.REST.Handler Extends HS.FHIR.vCommon.RestHandlerBase
{

/// This parameter influences the CORS support. The default is an empty string meaning 'not specified'.
/// If set to true (1) then CORS processing is ON. If set to false (0) then CORS processing is OFF.
/// If left unset "" then the decision to process CORS is delegated to the setting on the URL map route.
Parameter HandleCorsRequest As %Integer = 1;

/// DefaultContentType specifies the content type to use when no
/// content type is specified in the incoming request.  The FHIR
/// spec at http://www.hl7.org/fhir/DSTU2/http.html#mime-type is
/// not clear about defaulting, and defers to the spec for HTTP
/// Content Negotiation and Server-driven Negotiation at
/// http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.
Parameter DefaultContentType As %String = "application/xml+fhir";

/// Per the FHIR spec, "FHIR uses UTF-8 for all request and response bodies."
/// (http://www.hl7.org/fhir/http.html#mime-type) Setting this parameter
/// to 1 (the default in %CSP.Page is 0) will cause CSP to convert the request
/// content to internal format before passing it to this handler (The equivalent
/// of doing $ZCVT(val, "I", "UTF8") on the request content).
Parameter CONVERTINPUTSTREAM = 1;

/// Per the FHIR spec, "requests and responses SHALL explicitly set the
/// character encoding to UTF-8 using the charset parameter of the MIME-type
/// in the Content-Type header" (http://www.hl7.org/fhir/http.html#mime-type).
/// However what we have observed working with various FHIR clients is that
/// clients sometimes include a Content-Type header in a request with no
/// charset parameter. Setting the value of this key to 1 in the Configuration
/// Registry in this namespace will cause a missing Content-Type charset to be
/// ignored rather than rejected. A non-null charset that is not "utf8" or
/// "utf-8" (case-insensitive) will still be rejected.
Parameter IGNOREMISSINGCHARSETKEY = "\FHIR\IgnoreMissingContentTypeCharset";

/// The UrlMap describes how incoming REST URL requests and their parameters get
/// dispatched to each of the handler-methods in this class.
XData UrlMap
{
<Routes>
<Route Url="/_history" 					Method="GET" 		Call="HistoryAll"/>
<Route Url="/metadata" 					Method="GET" 		Call="Conformance"/>
<Route Url="/Mailbox" 					Method="POST" 		Call="Mailbox"/>
<Route Url="/Document" 					Method="POST" 		Call="Document"/>
<Route Url="/_search" 					Method="POST" 		Call="SearchAllPost"/>
<Route Url="/" 							Method="POST" 		Call="Transaction"/>
<Route Url="/" 							Method="GET" 		Call="SearchAll"/>
<Route Url="/:type/_search" 			Method="POST" 		Call="SearchPost"/>
<Route Url="/:type/_history" 			Method="GET" 		Call="HistoryType"/>
<Route Url="/:type/_validate/:id" 		Method="POST" 		Call="Validate"/>
<Route Url="/:type/_validate" 			Method="POST" 		Call="Validate"/>
<Route Url="/:type/:id/_history/:vid"	Method="GET" 		Call="VRead"/>
<Route Url="/:type/:id/_history" 		Method="GET" 		Call="History"/>
<Route Url="/:type/:id" 				Method="GET" 		Call="Read"/>
<Route Url="/:type/:id" 				Method="PUT" 		Call="Update"/>
<Route Url="/:type" 					Method="PUT" 		Call="ConditionalUpdate"/>
<Route Url="/:type/:id" 				Method="DELETE" 	Call="Delete"/>
<Route Url="/:type" 					Method="DELETE" 	Call="ConditionalDelete"/>
<Route Url="/:type"			 			Method="GET" 		Call="Search"/>
<Route Url="/:type" 					Method="POST" 		Call="Create"/>
<Route Url="/:type/:operation" 			Method="POST" 		Call="OperationResourceType"/>
<Route Url="/:type/:id/:operation" 		Method="POST" 		Call="OperationResourceInstance"/>
<Route Url="/:compartment/:id/:type" 	Method="GET" 		Call="CompartmentSearch"/>
</Routes>
}

/// This interaction searches a set of resources based on some filter criteria, using
/// the request Content as the medium for the search parameters.
ClassMethod SearchAllPost() As %Status [ CodeMode = expression ]
{
..processRequest("search-all", , , , , , 1)
}

/// This interaction searches a set of resources based on some filter criteria
ClassMethod SearchAll() As %Status [ CodeMode = expression ]
{
..processRequest("search-all")
}

ClassMethod SearchPost(pType As %String) As %Status [ CodeMode = expression ]
{
..processRequest("search", pType, , , , , 1)
}

/// This interaction searches a set of resources based on some filter criteria.
/// The FHIR spec at http://hl7.org/fhir/operations.html says that FHIR
/// operations may use GET as an alternative to POST.  This means that the Url
/// and Method combination for a system-level operation can be the same as that
/// for a type-level search.  If the Type parameter starts with dollar sign ($)
/// then that means that this interaction is an operation rather than a search.
ClassMethod Search(pType As %String) As %Status
{
	If $Extract(pType)'="$" {
		Quit ..processRequest("search", pType)
	} Else {
		Quit ..OperationSystem(pType)
	}
}

/// Compartment-based search and resource instance-level operation that uses the
/// GET method both have variables as the first three items in the URL.
/// The FHIR spec at http://hl7.org/fhir/operations.html says that FHIR
/// operations may use GET as an alternative to POST.  This means that the Url
/// and Method combination for an resource instance-level operation can be the
/// same as that for a compartment-based search.  If the Type parameter starts
/// with dollar sign ($) then that means that this interaction is an operation
/// rather than a search.
ClassMethod CompartmentSearch(pCompartment As %String, pId As %String, pType As %String) As %Status
{
	If $Extract(pType)'="$" {
		Quit ..processRequest("search-compartment", pType, pId, , pCompartment)
	} Else {
		Quit ..OperationResourceInstance(pCompartment, pId, pType)
	}
}

/// The history interaction retrieves the history of all resources supported by the system
ClassMethod HistoryAll() As %Status [ CodeMode = expression ]
{
..processRequest("history-all")
}

/// The history interaction retrieves the history of all resources of a given type
ClassMethod HistoryType(pType As %String) As %Status [ CodeMode = expression ]
{
..processRequest("history-type", pType)
}

/// The history interaction retrieves the history of a particular resource
ClassMethod History(pType As %String, pId As %String) As %Status [ CodeMode = expression ]
{
..processRequest("history", pType, pId)
}

/// The conformance interaction retrieves the server's conformance statement that defines how it supports resources
ClassMethod Conformance() As %Status [ CodeMode = expression ]
{
..processRequest("conformance")
}

/// The validate interaction checks whether the attached content would be acceptable as an update to an existing resource
ClassMethod Validate(pType As %String, pId As %String = "") As %Status [ CodeMode = expression ]
{
..processRequest("validate", pType, pId)
}

/// The conditional update interaction does not specify a resource id but rather will depend upon
/// its search parameters to determine of the resource exists or not. Based on that, it creates a
/// new current version for an existing resource or creates a new resource.
ClassMethod ConditionalUpdate(pType As %String) As %Status [ CodeMode = expression ]
{
..processRequest("update", pType)
}

/// The update interaction creates a new current version for an existing resource or creates a new resource if no resource already exists for the given id
ClassMethod Update(pType As %String, pId As %String) As %Status [ CodeMode = expression ]
{
..processRequest("update", pType, pId)
}

/// The create interaction creates a new resource in a server assigned location.
/// If the client wishes to have control over the id of a newly submitted resource,
/// it should use the update interaction instead.  The Url and Method combination
/// for a system-level operation is the same as that for create.  If the Type
/// parameter starts with dollar sign ($) then that means that this interaction is
/// an operation rather than a create.
ClassMethod Create(pType As %String) As %Status
{
	If $Extract(pType)'="$" {
		Quit ..processRequest("create", pType)
	} Else {
		Quit ..OperationSystem(pType)
	}
}

/// When operation is requested then the operation is the interaction.
ClassMethod OperationSystem(pOperation As %String) As %Status [ CodeMode = expression ]
{
..processRequest(pOperation)
}

/// When operation is requested then the operation is the interaction.
ClassMethod OperationResourceType(pType As %String, pOperation As %String) As %Status [ CodeMode = expression ]
{
..processRequest(pOperation, pType)
}

/// When operation is requested then the operation is the interaction.
ClassMethod OperationResourceInstance(pType As %String, pId As %String, pOperation As %String) As %Status [ CodeMode = expression ]
{
..processRequest(pOperation, pType, pId)
}

/// The conditional delete interaction does not specify a resource id but rather will depend upon
/// its search parameters to determine of the resource exists or not. Based on that, it deletes a
/// an existing resource or returns an error.
ClassMethod ConditionalDelete(pType As %String) As %Status [ CodeMode = expression ]
{
..processRequest("delete", pType)
}

/// The delete interaction removes an existing resource
ClassMethod Delete(pType As %String, pId As %String) As %Status [ CodeMode = expression ]
{
..processRequest("delete", pType, pId)
}

/// Read a specific resource instance.
/// The FHIR spec at http://hl7.org/fhir/operations.html says that FHIR
/// operations may use GET as an alternative to POST.  This means that the Url
/// and Method combination for an resource type-level operation can be the
/// same as that for a read.  If the Id parameter starts with dollar sign ($)
/// then that means that this interaction is an operation rather than a read
ClassMethod Read(pType As %String, pId As %String) As %Status
{
	If $Extract(pId)'="$" {
		Quit ..processRequest("read", pType, pId)
	} Else {
		Quit ..OperationResourceType(pType, pId)
	}
}

/// The vread interaction preforms a version specific read of the resource
ClassMethod VRead(pType As %String, pId As %String, pVId As %String) As %Status [ CodeMode = expression ]
{
..processRequest("vread", pType, pId, pVId)
}

/// The transaction interaction submits a Bundle of resources to be updated,
/// created or deleted on the server.  This class sets the Interaction to
/// "transaction".  Processing downstream, presumably by a business process,
/// will examine the Bundle type property to determine proper handling.
/// Possible input Bundle types are: document, message, transaction, batch,
/// and collection.
ClassMethod Transaction() As %Status [ CodeMode = expression ]
{
..processRequest("transaction")
}

ClassMethod Mailbox() As %Status [ CodeMode = expression ]
{
..processRequest("mailbox")
}

ClassMethod Document() As %Status [ CodeMode = expression ]
{
..processRequest("document")
}

/// 
/// Process an inbound request.  This hands off the incoming request to the business service.
/// 
ClassMethod processRequest(pInteraction As %String, pType As %String = "", pId As %String = "", pVersion As %String = "", pCompartment As %String = "", pParamCount As %Integer = -1, pIsPOST As %Boolean = 0) As %Status
{
	#dim %request As %CSP.Request
	#dim tStatus As %Status = $$$OK
	Try {

		// tRequest will end up being passed to a FHIR business service.
		Set tRequest = ##class(HS.Message.FHIR.Request).%New()
		
		// tResponse will only be used by this REST handler.
		Set tResponse = ##class(HS.Message.FHIR.Response).%New()
		Set tResponseStream = tResponse.Payload
		
		Do ..LogCSPRequest("[HS.FHIR.REST.Handler:processRequest]", 1)
		
		If pParamCount < 0 {
			#dim tParam As %String
			
			Set pParamCount = 0
			For tParam = pType, pId, pVersion, pCompartment {
				Set:tParam'="" pParamCount = pParamCount+1
			}
		}
		
		Set tStatus = ..contentTypeForRequest(.tContentType, pInteraction, pIsPOST)
		If $$$ISERR(tStatus) {
			Set tErrorText = $system.Status.GetErrorText(tStatus)
			Set tErrorTextU = $ZConvert(tErrorText,"U")
			If (tErrorTextU["INVALID _FORMAT PARAMETER VALUE")||(tErrorTextU["NO VALID ACCEPT DATA FOUND")||(tErrorTextU["INVALID CONTENT-TYPE")||(tErrorTextU["INVALID ACCEPT HEADER CHARSET") {
				Set tResponse.Status = ##class(HS.FHIR.Utils).#HTTP406NOTACCEPTABLE
				Set tStatus = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tErrorText, .tResponseStream, tContentType, "not-supported", 0)
				If $$$ISOK(tStatus) Set tResponse.ContentType="text/xml"
			} ElseIf (tErrorTextU["CONTENT TYPE APPLICATION/X-WWW-FORM-URLENCODED ONLY ALLOWED") {
				Set tStatus = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(tContentType, .tResponseStream, "error", "invalid", tErrorText, , , tErrorText, , , 1)
				Set tResponse.Status = ##class(HS.FHIR.Utils).#HTTP400BADREQUEST
			} Else {
				Set tStatus = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tStatus, tContentType, .tResponse, 1)
				Set tResponse.Status = ##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
			}
			Set tStatus = ..marshallResponse(tResponse)
			Quit
		}
		
		// Construct a raw FHIR request
		Set tStatus = ..marshallRequest(tContentType, pInteraction, pType, pId, pVersion, pCompartment, pParamCount, .tRequest)
		If $$$ISOK(tStatus) {
			// Delegate the FHIR request into the FHIR service
			Set tServiceName = %fhircspconfig.ServiceConfigName
			Set tServiceClass = %fhircspconfig.ServiceClassName
			If tServiceClass="" Set tServiceClass = tServiceName
			
			Set tStatus = ..delegateRequest(tServiceName, tServiceClass, tRequest, .tResponse)
			Quit:$$$ISERR(tStatus)
		} Else {
			Set tErrorText = $system.Status.GetErrorText(tStatus)
			Set tErrorTextU = $ZConvert(tErrorText,"U")
			Set tResponse = ##class(HS.Message.FHIR.Response).%New()
			If (tErrorTextU["INVALID ACCESS TOKEN")||(tErrorTextU["INVALID AUDIENCE FOR ACCESS TOKEN")||(tErrorTextU["ERROR GETTING ACCESS TOKEN")||(tErrorTextU["ACCESS TOKEN NOT FOUND") {
				// Should have already been caught by OnPreDispatch, but providing for it here anyway.
				Set tResponse.Status = "401 Unauthorized"
			} Else {
				Set tStatus = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tStatus, tRequest.ContentType, .tResponse, 1)
				Set tResponse.Status = ##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
			}
		}
		
		// Process the FHIR response back to the calling REST client
		Set tStatus = ..marshallResponse(tResponse)
		Quit:$$$ISERR(tStatus)
		
		Do ..LogCSPResponse("[HS.FHIR.REST.Handler:processRequest]", 1)
		
		// Done!

	} Catch (tUnexpected) {
		// Unexpected error ...
		Set tStatus = tUnexpected.AsStatus()
	}
	
	// NOTE: Any error %Status will be converted into a 500 Internal Server Error.  This is error handling of the last
	//       resort.  Normally, errors will have been converted into an OperationOutcome structure and returned.  Since
	//       this is a catch-all, we make no attempt to convert this error into anything; by default, %CSP.REST will
	//		 convert the %Status to JSON if the caller accepts it, otherwise it's reported as plain text.

	Kill %fhircspconfig
	
	Quit tStatus
}

/// 
/// Marshall the incoming FHIR REST request into a message ready for dispatch to the FHIR business service
/// 
ClassMethod marshallRequest(pContentType As %String, pInteraction As %String, pType As %String, pId As %String, pVersion As %String, pCompartment As %String, pParamCount As %Integer, ByRef pRequest As HS.Message.FHIR.Request) As %Status [ Internal ]
{
	#dim tStatus As %Status = $$$OK
	Try {
		
		#dim tKey As %String
		#dim tSubKey As %String
		#dim tItem As %String
		#dim tHeader As %String
		#dim tContentType As %String
		#dim %request As %CSP.Request
		
		// Construct a new FHIR request object and populate it with the contents of the HTTP request
		Set pRequest = ##class(HS.Message.FHIR.Request).%New()
		
		Set tBaseURL = %request.Application
		If $Extract(tBaseURL, *)="/" Set tBaseURL = $Extract(tBaseURL, 1, *-1)
		Set pRequest.BaseURL = tBaseURL
		
		Set pRequest.Interaction = pInteraction
		Set pRequest.ContentType = pContentType
		Set pRequest.Type = pType
		Set pRequest.Id = pId
		Set pRequest.VId = pVersion
		Set pRequest.Compartment = pCompartment
		Set pRequest.FHIRVersion = %fhircspconfig.FHIRVersion
		
		// Copy in any HTTP query values
		Set tKey = ""
		For {
			Set tKey = $ORDER(%request.Data(tKey))
			Quit:tKey=""
			
			// Look for subkeys in case of duplicate query parameters
			Set (tSubKey, tItem) = ""
			For {
				Set tSubKey = $ORDER(%request.Data(tKey,tSubKey))
				Quit:tSubKey=""
				
				Set tVal = %request.Data(tKey,tSubKey)
				
				// Force the URL query parameter Order value into the request data for sort keys.
				If $Extract(tKey,1,5)="_sort" {
					Set tVal = tVal_":"_%request.Data(tKey,tSubKey,"O")
				}
				
				// NOTE: We store this as a $LIST of possible values in order of appearance
				Set tItem = tItem_$LB(tVal)
			}
			
			// Copy the URL query parameters
			Do pRequest.Parameters.SetAt(tItem, tKey)
		}
		
		// Copy in any HTTP header values
		Set tKey = ""
		For {
			Set tKey = $ORDER(%request.CgiEnvs(tKey))
			Quit:tKey=""
			
			If tKey?1"HTTP_"1.E {
				// Determine the proper header name (will be all caps unfortunately)
				Set tHeader = $PIECE(tKey,"HTTP_",2,*)
				
				// Copy the HTTP headers
				Do pRequest.Headers.SetAt(%request.CgiEnvs(tKey), tHeader)
			} ElseIf tKey="REMOTE_ADDR" {
				// AdditionalInfo ClientAddr is added to provide an
				// indication in the message trace of the client IP
				// address.
				Do pRequest.AdditionalInfo.SetAt(%request.CgiEnvs(tKey), "ClientAddr")
			}
		}
		
		Do pRequest.AdditionalInfo.SetAt(%request.Secure, "Secure")
		Do pRequest.AdditionalInfo.SetAt(%session.SessionId, "CSPSessionId")
		
		Set tConformance = %fhircspconfig.ConformanceId
		Set tOAuth = %fhircspconfig.UseOAuth
		Set tResourceServerClient = %fhircspconfig.ResourceServerOAuthClient
		
		If tConformance'="" Do pRequest.AdditionalInfo.SetAt(tConformance, "ConformanceId")
		
		// The OAuth token processing here is a little redundant to that done in OnPreDispatch.
		// Measures are taken here to minimize the overhead. OnPreDispatch is meant to catch
		// an invalid access token before the UrlMap is even reached. marshallRequest needs
		// the access token information to formulate a session id in case it is needed, and
		// to populate a field in the FHIR message request so that the JWT is carried
		// forward into the rest of the FHIR processing.
		// Regarding access token validation:
		// 1. Absence of access token in Conformance request is okay.
		// 2. Absence of access token in request that is NOT Conformance is an error.
		// 3. Invalid access token (has value but is invalid), even when in a Conformance request, is an error.
		// 4. Current audience must match one of the token audiences, if the token has any.
		If tOAuth {
			Set tStatus = ..ValidateOAuthToken(pRequest.Interaction, .tOAuthSessionId, .tJWTString, .tJWTObj)
			If $$$ISERR(tStatus) Quit
			Do pRequest.AdditionalInfo.SetAt(tOAuthSessionId, "OAuthSessionId")
			Do pRequest.AdditionalInfo.SetAt(tJWTString, "JSONWebToken")
		}
		
		// UserIDAndRoles may be based on access token or on CSP basic authentication.
		Do ..GetUserIDAndRoles($Get(tJWTObj), .tUserID, .tUserRoles)
		If tUserID'="" Do pRequest.AdditionalInfo.SetAt(tUserID, "USER:UserID")
		If tUserRoles'="" Do pRequest.AdditionalInfo.SetAt(tUserRoles, "USER:Roles")
		
		// Copy the HTTP body (if any)
		If $IsObject(%request.Content) {
			Set tRequestStream = ##class(HS.SDA3.QuickStream).%New()
			Set pRequest.QuickStreamId = tRequestStream.%Id()
			// If the request body is XML, strip off the XML prolog, if present.
			// Any encoded characters have already been converted to internal format
			// (by virtue of having CONVERTINPUTSTREAM=1). Having the XML prolog, if it
			// contains "encoding='UTF-8'", will cause XML parsing to error, as it will
			// try to convert the already-converted characters.
			If ($ZCVT(pRequest.ContentType,"U") [ "XML") && (%request.Content.Read(5) = "<?xml") {
				While (%request.Content.Read(1) '= ">") { }
				While ('%request.Content.AtEnd) { Do tRequestStream.Write(%request.Content.Read()) }
			}
			Else {
				// Copy the incoming payload
				Set tStatus = tRequestStream.CopyFrom(%request.Content)
				Quit:$$$ISERR(tStatus)
			}
		}

	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}
	
	Kill %accesstokenjwtobj
	Kill %accesstokenstring
	
	Quit tStatus
}

ClassMethod ValidateOAuthToken(pInteraction As %String, ByRef pOAuthSessionId As %String, ByRef pJWTString As %String, ByRef pJWTObj As %Library.DynamicObject) As %Status
{
	Set tSC = $$$OK
	
	Set pOAuthSessionId = ""
	Set pJWTString = ""
	Set pJWTObj = ""
	
	Try {
		// The OAuth token processing here is a little redundant to that done in OnPreDispatch.
		// Measures are taken here to minimize the overhead. OnPreDispatch is meant to catch
		// an invalid access token before the UrlMap is even reached. The processing here uses
		// the access token information to formulate a session id in case it is needed, and
		// to populate a field in the FHIR message request so that the JWT is carried forward
		// into the rest of the FHIR processing.
		// Regarding access token validation:
		// 1. Absence of access token in Conformance request is okay.
		// 2. Absence of access token in request that is NOT Conformance is an error.
		// 3. Invalid access token (has value but is invalid), even when in a Conformance request, is an error.
		// 4. Current audience must match one of the token audiences, if the token has any.
		
		// %accesstokenstring and %accesstokenjwtobj are created by OnPreDispatch upon
		// successful validation of the access token. Use those values if present.
		
		If $Get(%accesstokenstring)'="" {
			Set tAccessToken = %accesstokenstring
		} Else {
			// For GetAccessTokenFromRequest, a present but blank Authorization header value will
			// return an error. Aside from that, the absence of an access token will not give an
			// error, it will just come back with tAccessToken="".
			Set tAccessToken = ##class(%SYS.OAuth2.AccessToken).GetAccessTokenFromRequest(.tSC)
			If $$$ISERR(tSC) {
				Set tSC = $$$ERROR($$$GeneralError, "Error getting access token from request - "_$system.Status.GetErrorText(tSC))
				Quit
			}
		}
		
		// Blank or missing access token is okay with a Conformance interaction, and is
		// not okay if not a Conformance interaction.
		If (tAccessToken="") {
			If pInteraction'="conformance" {
				Set tSC = $$$ERROR($$$GeneralError, "Access token not found")
			}
			Quit
		}
		
		// Formulate a user session id using the access token as a basis.
		Set tHash = $system.Encryption.SHA1Hash(tAccessToken)
		Set tString = ""
		For i = 1:1:$Length(tHash) {
			Set tC = $Extract(tHash, i)
			Set tA = $ASCII(tC)
			#; Convert from extended ascii if needed.
			If (tA<32)||(tA>122) Set tC = $Char(32+(tA#91))
			Set tString = tString_tC
		}
		Set pOAuthSessionId = tString
		
		If $IsObject($Get(%accesstokenjwtobj)) {
			Set pJWTObj = %accesstokenjwtobj
		} Else {
			// Do not pass the current audience into ValidateJWT, we will do
			// our own compare of curent audience to token audience(s).
			Set tReturn = ##class(%SYS.OAuth2.Validation).ValidateJWT(tResourceServerClient, tAccessToken, "", "", .pJWTObj, .tSecurityParams, .tSC)
			If tReturn=0 {
				If ($$$ISERR(tSC))&&((","_$system.Status.GetErrorCodes(tSC)_",")[",8873,") {
					// tSC of 8873 is OAuth2JWTNotValid, which is returned when it is a JWT
					// (passes structural integrity and encryption, etc) AND it fails on aud,
					// or exp, or iss, or scope.
					// Is a JWT, but not valid.
					Set tSC = $$$ERROR($$$GeneralError, "Invalid access token")
					Quit
				} Else {
					// Does not appear to be a valid JWT, try GetIntrospection.
					Set tSC = ##class(%SYS.OAuth2.AccessToken).GetIntrospection(tResourceServerClient, tAccessToken, .pJWTObj)
					If $$$ISERR(tSC) Quit
				}
			}
		}
		
		// Unclear if pJWTObj can be not an object by this point.
		If '$IsObject($Get(pJWTObj)) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid access token")
			Quit
		}
		
		// If the JWT is invalid then GetIntrospection will return a JSON object with
		// a single property 'active' set to false (0).
		If (pJWTObj.active'="")&&(pJWTObj.active=0) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid access token")
			Quit
		}
		
		// Compare the current audience against the aud value(s), if any, in the access
		// token. This compare is trailing-slash-insensitive and case-insensitive.
		If '##class(HS.FHIR.Utils).ValidateAudience(pJWTObj) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid audience for access token")
			Quit
		}
		
		#; Create a JSON string of selected properties from the JWT object.
		#;
		#; Some pJWTObj properties available are:
		#; active (true/false - will be false if the access token was found to be invalid)
		#; scope (space delimited string of scopes)
		#; sub (username)
		#; iss (token issuer, e.g., https://argonaut.intersystems.com/oauth2)
		#; aud (audience, e.g., https://argonaut.intersystems.com/fhiroauth2)
		#; client_id (client id string)
		#; username (username)
		#; token_type (e.g., bearer)
		#; exp (expire time, expressed as number of seconds since start of the Unix epoch)
		#; iat (authoriztion time, expressed as number of seconds since start of the Unix epoch)
		#; nbf (authorization time, expressed as number of seconds since start of the Unix epoch)
		#;
		#; As part of creating the JSON string, this method creates a new
		#; object and adds properties to it.  We cannot remove properties
		#; from the existing object, because it is a DynamicAbstractObject,
		#; and does not have access to the %Remove() method.
		
		Set tJWTProps = "active,scope,client_id,username,token_type,exp,iat,nbf,sub,aud,iss,jti,healthshare_roles,healthshare_username,name"
		
		Set tNewJWTObj = ##class(%DynamicAbstractObject).%FromJSON("{}")
		For i = 1:1:$Length(tJWTProps,",") {
			Set tJWTProp = $Piece(tJWTProps,",",i)
			If tJWTProp="" Continue
			Set tValue = pJWTObj.%Get(tJWTProp)
			If tValue'="" Set tNewJWTObj = tNewJWTObj.%Set(tJWTProp, tValue)
		}
		Set pJWTString = tNewJWTObj.%ToJSON()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod GetUserIDAndRoles(pJWTObj = "", Output pUserID As %String, Output pUserRoles As %String)
{
	Set pUserID = ""
	Set pUserRoles = ""
	
	#; Check to see if the user info is found in an access token.
	If $IsObject(pJWTObj) {
		If pJWTObj.%Get("healthshare_username")'="" {
			Set pUserID = pJWTObj.%Get("healthshare_username")
		} ElseIf pJWTObj.%Get("username")'="" {
			Set pUserID = pJWTObj.%Get("username")
		} ElseIf pJWTObj.%Get("sub")'="" {
			Set pUserID = pJWTObj.%Get("sub")
		}
		If pUserID'="" {
			Set pUserRoles = pJWTObj.%Get("healthshare_roles")
			Quit
		}
	}
	
	#; If relying on the username from an Authenticated CSP application request,
	#; the user account's roles will be accessible only if the CSP application
	#; includes the %DB_IRISSYS role.
	If $Piece(%request.GetCgiEnv("HTTP_AUTHORIZATION"),"Basic ",2)'="" {
		Set tUsername = $Piece($system.Encryption.Base64Decode($Piece(%request.GetCgiEnv("HTTP_AUTHORIZATION"),"Basic ",2)),":",1)
		If tUsername'="" {
			Set pUserID = tUsername
			If (","_$roles_",")[",%DB_IRISSYS," {
				Set tSC = $system.Security.GetUserRecursedRoleSet(pUserID, .tRoles)
				If ($$$ISOK(tSC))&&($Get(tRoles)'="") {
					Set pUserRoles = tRoles
				} Else {
					Set pUserRoles = "%DB_%DEFAULT"
				}
			} Else {
				Set pUserRoles = "%DB_%DEFAULT"
			}
			Quit
		}
	}
	
	#; Otherwise, just use the current process username and roles.
	Set pUserID = $username
	Set pUserRoles = $roles
	
	Quit
}

/// 
/// Delegate a FHIR request to FHIR business service
/// 
ClassMethod delegateRequest(pServiceName As %String, pServiceClass As %String, pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response) As %Status [ Internal ]
{
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tStatus2 As %Status
		
		// Dispatch to the FHIR business service
		Set tStatus2 = $CLASSMETHOD(pServiceClass, "ProcessInteraction", pRequest, .pResponse, pServiceName)
		
		// We don't need the request QuickStream data any more, so clear it now.
		If ($IsObject($Get(pRequest)))&&(pRequest.QuickStreamId'="") {
			Set tQStream = ##class(HS.SDA3.QuickStream).%OpenId(pRequest.QuickStreamId)
			If $IsObject(tQStream) Do tQStream.Clear() Set pRequest.QuickStreamId = ""
		}
		
		// NOTE: The business service will map normal runtime errors into an OperationOutcome structure
		//       Any %Status errors here are fatal operational errors (such as production not running,
		//       class does not exist etc).
		//
		//       However, there are some validation and processing errors in the business service that we
		//       can attempt to map to a HTTP status (e.g. Bad Requests).

		#dim tHttpStatus As %String = ""
		
		Set tStatus = ##class(HS.FHIR.Utils).StatusToHttp(tStatus2,.tHttpStatus)
		Quit:$$$ISERR(tStatus)
		
		// We were able to map the %Status to something ... let's go with that.
		If tHttpStatus'="" {
			Set tStatus = pRequest.NewResponse(.pResponse)
			Quit:$$$ISERR(tStatus)
			
			Set pResponse.Status = tHttpStatus
			
			// Set the content type to text/plain
			Set pResponse.ContentType = ##class(HS.FHIR.Utils).#CONTENTTYPETEXTPLAIN
			
			If pResponse.QuickStreamId'="" {
				Set tResponseStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
				Do tResponseStream.Clear(0)
			} Else {
				Set tResponseStream = pResponse.Payload
				Do tResponseStream.Clear()
			}

			// Write the error to the payload
			Do tResponseStream.WriteLine($system.Status.GetErrorText(tStatus2))
			Do tResponseStream.Rewind()			
		} Else {
			// No appropriate HTTP status code, so we'll return the error which will end up as a 500 Internal Server Error
			Set tStatus = tStatus2
		}

	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Marshall a raw HS.Message.FHIR.Response message out onto the wire
/// 
ClassMethod marshallResponse(pResponse As HS.Message.FHIR.Response, pDefaultStatus As %String = {##class(HS.FHIR.Utils).#HTTP200OK}) As %Status [ Internal ]
{
	#dim tStatus As %Status = $$$OK
	Try {
		
		#dim %response As %CSP.Response
		#dim tKey As %String
		#dim tValue As %String
		#dim tHTTPCode As %String
		#dim tHTTPStatus As %String

		// Set up HTTP response code
		Set tHTTPCode = $SELECT(pResponse.Status'="":pResponse.Status,1:pDefaultStatus)

		// Make sure we're returning proper HTTP status codes & messages
		Set tStatus = ##class(HS.FHIR.Helper).LookupHTTPStatusText(tHTTPCode,.tHTTPStatus)
		Quit:$$$ISERR(tStatus)

		Set %response.Status = +tHTTPCode _" "_ tHTTPStatus
		
		// Inject any HTTP headers
		Set tKey = ""
		For {
			Set tValue = pResponse.Headers.GetNext(.tKey)
			Quit:tKey=""
			
			Do %response.SetHeader(tKey, tValue)
			
			// NOTE: This may include any Location or Content-Location headers as necessary
			//       for the interaction.  This is handled by the business service.
		}
				
		// Set the content type
		Set %response.ContentType = pResponse.ContentType
		Set %response.CharSet = "UTF-8"
		
		// Inject the payload
		Set tResponseStream = pResponse.GetPayloadOref()
		If $IsObject(tResponseStream) {
			Do tResponseStream.Rewind()
			For {
				Set tStatus = tResponseStream.OutputToDevice($$$MaxLocalLength)
				If $$$ISERR(tStatus) Quit
				If tResponseStream.AtEnd Quit
			}
			// If a QuickStream, delete it, now that we are done with it.
			If tResponseStream.%IsA("HS.SDA3.QuickStream") Do tResponseStream.Clear()
		}
		
	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}
	
    Quit tStatus
}

/// 
/// Return the requested content type. Returns the string specified specified by class parameter 
/// "DefaultContentType" if no content type and no Accept data was specified in the request.<br>
/// Given that the FHIR request message class provides only one property "ContentType" to deal
/// with the concepts of Accept and ContentType, this method and the rest of the FHIR infrastructure
/// assumes that the _format and/or Accept header of a given request corresponds to the Content-Type
/// header of that request.<br>
/// Basic overview of logic:<br>
/// <li>Check for the presence of a request URL parameter named "_format". If _format has a valid
/// value, then a valid FHIR MIME type is derived from it and that is used as the Accept and
/// ContentType value. Otherwise if _format has a value and it is not valid then that is an error.
/// <li>If _format is not present then that is okay. The Accept header is then checked for the
/// presence of a valid FHIR MIME type. If one is present and has a valid charset value then it is
/// used as the Accept and ContentType value. Otherwise if the Accept header is present but does
/// not include a valid FHIR MIME type with a valid charset value then that is an error.
/// <li>If neither _format nor the Accept header was present, then the Content-Type header is checked
/// for the presence of a valid FHIR MIME type. If one is present and has a valid charset value then
/// it is used as the Accept value and ContentType value. Otherwise if Content-Type is not valid or
/// is not present then the value of class parameter DefaultContentType is used as the Accept and
/// ContentType value.
ClassMethod contentTypeForRequest(ByRef pContentType As %String, pInteraction As %String, pIsPOST As %Boolean) As %Status [ Internal ]
{
	#dim tStatus As %Status = $$$OK
	Try {

		#dim %request As %CSP.Request
		#dim tAccept As %String
		#dim tIndex As %Integer
		
		Set pContentType = ..#DefaultContentType
		
		Set tFormat = ""
		Set tAccept = ""
		Set tAcceptCharset = ""
		Set tRequestFormat = %request.Get("_format")
		Set tRequestContentType = %request.ContentType
		
		Do ##class(HS.FHIR.Utils).GetAllValidFormats(.tValidFormats)
		
		// A valid _format parameter value overrides the HTTP_ACCEPT header value, so check _format
		// first. The _format parameter will be either from the request URL or from the search URL
		// found in the Content when Content-Type is application/x-www-form-urlencoded.
		If tRequestFormat'="" {
			If $Data(tValidFormats("Parameter", tRequestFormat))#10 {
				If (tRequestFormat="application/fhir+xml")||(tRequestFormat="application/fhir+json") {
					// This will cause a 406 Not Acceptable to be returned in the HTTP response.
					Set tStatus = $$$ERROR($$$GeneralError, "Invalid _format parameter value: "_tRequestFormat)
					Quit 
				} Else {
					If tRequestFormat="xml" {
						Set tAccept = "application/xml+fhir"
					} ElseIf tRequestFormat="json" {
						Set tAccept = "application/json+fhir"
					} Else {
						Set tAccept = tRequestFormat
					}
				}
			} Else {
				// This will cause a 406 Not Acceptable to be returned in the HTTP response.
				Set tStatus = $$$ERROR($$$GeneralError, "Invalid _format parameter value: "_tRequestFormat)
				Quit 
			}
		}
		
		// If the _format parameter was not specified, then consult the HTTP Accept header
		// (which is a list of acceptable types) to see if there is a valid FHIR mime type.
		If tAccept="" {
			Set tAcceptHeader = $GET(%request.CgiEnvs("HTTP_ACCEPT"))
			If tAcceptHeader="*/*" Set tAcceptHeader = ""
			For tIndex = 1:1:$L(tAcceptHeader,",") {
				Set tOneAcceptHeader = $P(tAcceptHeader,",",tIndex)
				Set tAcceptMime = $ZSTRIP($PIECE(tOneAcceptHeader,";"),"<>W")
				Set tParams = $ZSTRIP($PIECE(tOneAcceptHeader,";",2,*),"*W")
				// Get the value of the charset param (if present), then if we end up using the current content type,
				// but the charset is non-null and *not* utf-8, return an error.
				Set tAcceptCharset = ""
				For tJ=1:1:$L(tParams,";") {
					Set tOneParam = $P(tParams, ";", tJ)
					Set tOneParamL = $ZCVT(tOneParam, "L")
					If ($P(tOneParamL,"=") = "charset") {
						Set tAcceptCharset = $P(tOneParam, "=", 2)
						Quit
					}
				}
				// If we encounter a valid FHIR mime type, it must either have a valid charset
				// value or no charset value.
				If (tAcceptMime'="")&&($Data(tValidFormats("Accept", tAcceptMime))#10)&&('((tAcceptMime="application/fhir+xml")||(tAcceptMime="application/fhir+json"))) {
					If (tAcceptCharset="")||($ZConvert(tAcceptCharset,"L")="utf-8")||($ZConvert(tAcceptCharset,"L")="utf8") {
						Set tAccept = tAcceptMime
					} Else {
						// This will cause a 406 Not Acceptable to be returned in the HTTP response.
						Set tStatus = $$$ERROR($$$GeneralError, "Invalid Accept header charset: "_tAcceptCharset_". Must be UTF-8.")
					}
					Quit
				}
			}
		}
		If $$$ISERR(tStatus) Quit
		
		// If there was a _format parameter and/or an Accept header provided in the request, but
		// neither was found to be valid for FHIR, then that is an error.
		If (tAccept="")&&((tFormat'="")||(tAcceptHeader'="")) {
			// This will cause a 406 Not Acceptable to be returned in the HTTP response.
			Set tStatus = $$$ERROR($$$GeneralError, "No valid Accept data found (Accept header or _format parameter)")
			Quit
		}
		
		// If there was a valid Accept mime type found, then validate the Accept-Charset header,
		// if there is one AND if the Accept header itself did not already specify the charset.
		If (tAccept'="") {
			If (tAcceptCharset="")&&($Get(%request.CgiEnvs("HTTP_ACCEPT_CHARSET"))'="") {
				Set tAcceptCharset = %request.CgiEnvs("HTTP_ACCEPT_CHARSET")
				Set tFound = 0
				For tJ=1:1:$L(tAcceptCharset,",") {
					Set tOneAcceptCharset = $P(tAcceptCharset,",",tJ)
					// Could have a q param, separated by ";"
					Set tOneAcceptCharset = $P(tOneAcceptCharset,";")
					Set tOneAcceptCharset = $ZSTRIP(tOneAcceptCharset, "<>W")
					Set tOneAcceptCharset = $ZCVT(tOneAcceptCharset,"L")
					If (tOneAcceptCharset="utf8")||(tOneAcceptCharset="utf-8") { Set tFound=1 Quit }
				}
				If ('tFound) {
					// This will cause a 406 Not Acceptable to be returned in the HTTP response.
					Set tStatus = $$$ERROR($$$GeneralError, "No valid Accept data found. Invalid Accept-Charset header: "_tAcceptCharset_". Must include UTF-8.")
					Quit 
				}
			}
			// If the request simply does not specify an accept charset, this is fine, it is assumed to be UTF-8.
		}
		
		// application/x-www-form-urlencoded is allowed only for search interactions.
		// No need for further processing if Content-Type is application/x-www-form-urlencoded.
		If tRequestContentType="application/x-www-form-urlencoded" {
			If tAccept'="" Set pContentType = tAccept
			// Must be a search interaction initiated using the HTTP POST verb.
			If ('pIsPOST)||('((pInteraction="search")||(pInteraction="search-all"))) {
				Set tStatus = $$$ERROR($$$GeneralError, "Content type application/x-www-form-urlencoded only allowed for FHIR POST search interaction")
			}
			Quit
		}
		
		// If the request has a Content-Type header, then also validate its charset parameter.
		// CSP parses it out of the Content-Type header and into %request.CharSet, if present.
		If (tRequestContentType '= "") {
			Set tContentTypeCharset = $ZCVT(%request.CharSet,"L")
			// Error if the content type charset is missing, UNLESS the system is configured to ignore a missing charset.
			// The default behavior is that a missing charset will NOT be ignored (ie, the request rejected with an error).
			If (tContentTypeCharset="") {
				If ('##class(HS.Registry.Config).GetKeyValue(..#IGNOREMISSINGCHARSETKEY,0)) {
					// This will cause a 406 Not Acceptable to be returned in the HTTP response.
					Set tStatus = $$$ERROR($$$GeneralError, "Invalid Content-Type header - missing charset. Must be UTF-8.")
				}
			}
			ElseIf (tContentTypeCharset'="utf8")&&(tContentTypeCharset'="utf-8") {
				// This will cause a 406 Not Acceptable to be returned in the HTTP response.
				Set tStatus = $$$ERROR($$$GeneralError, "Invalid Content-Type header charset: "_tContentTypeCharset_". Must be UTF-8.")
				Quit
			}
			If (tRequestContentType="application/fhir+xml")||(tRequestContentType="application/fhir+json") {
				// This will cause a 406 Not Acceptable to be returned in the HTTP response.
				Set tStatus = $$$ERROR($$$GeneralError, "Invalid Content-Type header value: "_tRequestContentType)
				Quit
			}
			If '$Data(tValidFormats("ContentType", tRequestContentType))#10 {
				// This will cause a 406 Not Acceptable to be returned in the HTTP response.
				Set tStatus = $$$ERROR($$$GeneralError, "Invalid Content-Type header value: "_tRequestContentType)
				Quit
			}
		}
		
		// At this point, use the first non-blank found of Accept, ContentType or DefaultContentType.
		Set pContentType = tAccept
		If pContentType="" Set pContentType = tRequestContentType
		If pContentType="" Set pContentType = ..#DefaultContentType
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
    Quit tStatus
}

/// Map $$$ERROR codes into the appropriate HTTP codes.
ClassMethod statusToHTTP(pStatus As %Status, ByRef pErrorMap, ByRef pHTTPStatus As %String) As %Status [ Internal ]
{
	#dim tStatus As %Status = pStatus
	Try {
		
		#dim tCodes As %String = $system.Status.GetErrorCodes(pStatus)
		#dim tIndex
		
		For tIndex = 1:1:$LENGTH(tCodes,",") {
			#dim tCode As %String
			#dim tHTTPStatus As %String
			#dim tHTTPCode As %String
			
			Set tCode = $PIECE(tCodes,",",tIndex)
			Set tHTTPCode = $GET(pErrorMap(tCode))
		
			// Do we have a map entry for this error?   ... then stop.
			Quit:tHTTPCode'=""
		}
		
		// Use 500 if no other, suitable error
		If tHTTPCode = "" {
			Set tHTTPCode = +##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
		}

		// Send back this HTTP status
		Set tStatus = ##class(HS.FHIR.Helper).LookupHTTPStatusText(tHTTPCode,.tHTTPStatus)
		Quit:$$$ISERR(tStatus)

		Set pHTTPStatus = tHTTPCode _" "_ tHTTPStatus		
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	

	Quit tStatus
}

/// Log details of HTTP request received by CSP
ClassMethod LogCSPRequest(methodName As %String, server As %Boolean) [ Internal ]
{
	#define SysLogLevel                            $get(^%ISCLOG,1)
	#define SysLog(%level,%cat,%message,%data)     Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data)
	
	Set tReadLen = $Select($system.SYS.MaxLocalLength()=3641144:3640000,1:32000)
	
	If $$$SysLogLevel<3 Quit
	
	Set data="Content-Type: "_%request.ContentType
	Set data=data_", Secure: "_%request.Secure
	Set authorization=%request.GetCgiEnv("HTTP_AUTHORIZATION")
	If authorization'="" {
		Set data=data_", Authorization: "_authorization
	}
	Set name=""
	For {
		Set name=$order(%request.Data(name))
		If name="" Quit
		Set index=""
		For {
			Set index=$order(%request.Data(name,index),1,value)
			If index="" Quit
			Set data(name,index)=value
		}
	}
	If %request.Content'="" {
		If $isobject(%request.Content) {
			Set data=data_", Content: "_%request.Content.Read(tReadLen) Do %request.Content.Rewind()
		} Else {
			Set data=data_", Content: "_%request.Content
		}
	}
	If $$$SysLogLevel>=5 {
		Set name=""
		For {
			Set name=%request.NextCookie(name)
			If name="" Quit
			Set data("Cookie",name)=%request.GetCookie(name)
		}
		Set name="HTTP_"
		For {
			Set name=$order(%request.CgiEnvs(name),1,value)
			If $extract(name,1,5)'="HTTP_" Quit
			Set data("Header",name)=value
		}
	}
	$$$SysLog(3,"HSFHIR"_$select(server:"Server",1:""),methodName_"CSP Request",.data)
}

/// Log details of HTTP response about to be returned via CSP
ClassMethod LogCSPResponse(methodName As %String, server As %Boolean) [ Internal ]
{
	#define SysLogLevel                            $get(^%ISCLOG,1)
	#define SysLog(%level,%cat,%message,%data)     Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data)
	
	If $$$SysLogLevel<3 Quit
	Set data="Content-Type: "_%response.ContentType
	Set data=data_", HTTPVersion: "_%response.HTTPVersion
	Set data=data_", Status: "_%response.Status
	Set data=data_", Redirect: "_%response.Redirect
	Set data=data_", ServerSideRedirect: "_%response.ServerSideRedirect
	Set data=data_", ContentLength: "_%response.ContentLength
	If $$$SysLogLevel>=5 {
		Set name=""
		For {
			Set name=$Order(%response.Headers(name))
			If name="" Quit
			Set data("Header",name)=%response.Headers(name)
		}
		Set name=""
		For {
			Set name=$Order(%response.Cookies(name))
			If name="" Quit
			Set sub=""
			For {
				Set sub=$Order(%response.Cookies(name,sub))
				If sub="" Quit
				Set data("Cookie",name,sub)=%response.Cookies(name,sub)
			}
		}
	}
	$$$SysLog(3,"HSFHIR"_$select(server:"Server",1:""),methodName_"CSP Response",.data)
}

/// OnPreDispatch overrides the same method from %CSP.Request.  If pContinue is set to 0,
/// the request will NOT be dispatched according to the UrlMap. If this case it's the
/// responsibility of the user to return a response.
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	#dim %request As %CSP.Request
	
	Set pContinue = 1
	Try {
		// Hold the FHIR CSP Config data in a % variable or else this class does URLIndexOpen
		// four times for each CSP request.  Subsequent usage of this variable is guaranteed to have a
		// valid object in '%fhircspconfig'
		// If the Config data cannot be found, return a Http 500 indicating that the App has been mis-configured. 
		Set tApplication = %request.Application
		If $Extract(tApplication, *)="/" Set tApplication = $Extract(tApplication, 1, *-1)
		Set %fhircspconfig = ##class(HS.Registry.FHIRCSPConfig).URLIndexOpen(tApplication)
		If '$IsObject($Get(%fhircspconfig))  {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"FHIR App Configuration Data is Missing for "_tApplication))
		}
		
		If %fhircspconfig.UseOAuth=0 Quit
		If %fhircspconfig.ResourceServerOAuthClient="" Set %fhircspconfig.ResourceServerOAuthClient="HSRESOURCESERVER"
		
		#; metadata and OPTIONS are two ways of requesting the Conformance statement.
		#; Conformance holds the authorization end point and token end point.
		Set tIsConformance = 0
		If (%request.PageName="metadata")&&(%request.CgiEnvs("REQUEST_METHOD")="GET") Set tIsConformance = 1
		If %request.CgiEnvs("REQUEST_METHOD")="OPTIONS" Set tIsConformance = 1
		
		// Present but blank Authorization header value will return an error. Aside from that,
		// the absence of an access token will not give an error, and will just come back with
		// tAccessToken="".
		Set tAccessToken = ##class(%SYS.OAuth2.AccessToken).GetAccessTokenFromRequest(.tStatus)
		If $$$ISERR(tStatus) {
			Set pContinue = 0
			If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED)
			Quit
		}
		// Blank or missing access token is okay with a Conformance interaction, and is
		// not okay if not a Conformance interaction. In either case for blank access
		// token, no need for further processing.
		If tAccessToken="" {
			If 'tIsConformance {
				Set pContinue = 0
				If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED)
			}
			Quit
		}
		
		Set tSC = $$$OK
		Set tStatus = $$$OK
		Set tReturn = ##class(%SYS.OAuth2.Validation).ValidateJWT(%fhircspconfig.ResourceServerOAuthClient, tAccessToken, "", "", .tJWTObj, .tSecurityParams, .tSC)
		If tReturn=0 {
			// tSC of 8873 is OAuth2JWTNotValid, which is returned when it is a JWT
			// (passes structural integrity and encryption, etc) AND it fails on aud,
			// or exp, or iss, or scope.
			If ($$$ISERR(tSC))&&((","_$system.Status.GetErrorCodes(tSC)_",")'[",8873,") {
				// Does not appear to be a valid JWT, try GetIntrospection.
				// An example of a tSC that gets us to this point is:
				// ERROR #8896: No private key found for alg: RSA-OAEP.
				Set tStatus = ##class(%SYS.OAuth2.AccessToken).GetIntrospection(%fhircspconfig.ResourceServerOAuthClient, tAccessToken, .tJWTObj)
			} Else {
				#; Is a JWT, but not valid.
				Set tStatus = tSC
				Quit
			}
		}
		
		// If GetIntrospection failed due to an error then return 401 Unauthorized.
		If $$$ISERR(tStatus) {
			Set pContinue = 0
			If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED)
			Quit
		}
		
		// If GetIntrospection returned a JWT then check the JWT "active" property.
		// If GetIntrospection detects invalid access token then it returns active=false.
		If $IsObject($Get(tJWTObj)) {
			If (tJWTObj.active'="")&&(tJWTObj.active=0) {
				Set pContinue = 0
				If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED)
				Quit
			} Else {
				Set tMatched = ##class(HS.FHIR.Utils).ValidateAudience(tJWTObj)
				If 'tMatched {
					Set pContinue = 0
					If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED)
					Quit
				}
				If tJWTObj.exp'="" {
					If tJWTObj.exp < ##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0) {
						Set pContinue = 0
						If ..ReportHttpStatusCode(..#HTTP401UNAUTHORIZED)
						Quit
					}
				}
				
				Set %accesstokenstring = tAccessToken
				Set %accesstokenjwtobj = tJWTObj
			}
		}
		
	} Catch ex {
		Set pContinue = 0
		Do ..Http500(ex)
	}
	
	Quit $$$OK
}

/// OnHandleCorsRequest overrides the same method from %CSP.REST.  FHIR CSP
/// config setting DisableCORS provides a way for an implementation to override
/// the HandleCorRequest class parameter.
ClassMethod OnHandleCorsRequest(pUrl As %String) As %Status
{
	If %fhircspconfig.DisableCORS=1 Quit $$$OK
    Quit ..HandleDefaultCorsRequest(pUrl)
}

}
