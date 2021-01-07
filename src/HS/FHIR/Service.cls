/// FHIR REST Business Service
Class HS.FHIR.Service Extends (Ens.BusinessService, HS.HC.Util.Trace.Helper)
{

/// Configuration item to which to send inbound messages.<br><br>
/// This setting is superseded by the PatientHost setting when the FHIR
/// request is a Patient search request or Patient read request.
Property TargetConfigName As Ens.DataType.ConfigName;

/// FHIRVersion to be "imprinted" on messages flowing through this service.
Property FHIRVersion As %String(MAXLEN = 255);

/// Timeout for dispatch (so we don't hold up the HTTP service too long or hang up a production shutdown).
Property Timeout As %Integer [ InitialExpression = 25 ];

/// Value of true for this setting causes any returned FHIR payload
/// to include indentation and line feed characters to enhance
/// readability of the raw content.  This setting may be overridden
/// on a per-request basis by including the "_pretty" URL parameter
/// on the RESTful request.<br>
/// <br>
/// Adding formatting to returned payloads adds significant processing
/// overhead. Therefore it is recommended that this setting be enabled
/// only for testing and demonstration purposes.
Property FormatFHIROutput As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},PatientHost:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},Timeout:Basic,FHIRVersion:Basic,FormatFHIROutput:Basic,SessionMode:Basic,ParameterModeTimeout:Basic,SessionClass:Basic,SessionStartClass:Basic,SessionEndClass:Basic,-ConformanceOperation:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},";

/// <b>NoSession</b> mode means sessions are not being handled. FHIR
/// requests are intended to interact with the resource repository
/// as a regular FHIR resource server.<br><br>
/// <b>Parameter</b> mode requires that each request be accompanied by
/// a server-generated session id, passed in as a parameter on the
/// request URL.  This option is an alternative to requiring the client
/// to accept and return browser cookies.  The REST client must explicitly
/// "start a user session" by invoking the $parameter-session-start FHIR operation.
/// $parameter-session-start returns a session id that the REST client may
/// then use for the duration of the user session.  An explicit "end user
/// session" action is available via the $parameter-session-end FHIR operation.
/// The REST client should invoke $parameter-session-end upon ending the
/// application or browser session, if possible.<br><br>
/// <b>OAuth</b> mode is intended to use an OAuth 2.0 access token as
/// the basis for a session id.  This option requires that the FHIR
/// namespace has the required setup and handling of OAuth 2.0.
Property SessionMode As %String(VALUELIST = ",NoSession,Parameter,OAuth") [ InitialExpression = "NoSession" ];

/// Deprecated as of 2018.1, no longer used.
Property ConformanceOperation As Ens.DataType.ConfigName;

/// This setting is effective only when SessionMode is set to Parameter.
/// This is the maximum number of seconds between requests on this business
/// service before a Parameter-based session is considered timed out.<br><br>
/// Parameter mode has this specialized timeout setting because the other modes
/// each have an existing basis for their timeout:<br>
/// - OAuth session mode timeout is based on the life of the access token.
Property ParameterModeTimeout As %Integer [ InitialExpression = 300 ];

/// Class to use for the user session management object. Default is HS.FHIR.SessionData.FHIRSession.
/// If an alternate class is specified, it must extend class HS.FHIR.SessionData.FHIRSession, either
/// directly or indirectly.
Property SessionClass As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.SessionData.FHIRSession" ];

/// Class to use for supplementary processing upon user session start. This class must implement a
/// class method named "SessionStart", which takes as its input parameters a user session object
/// and a FHIR version (e.g., "DSTU2", "STU3"). It is called after this business service creates
/// the user session object.
Property SessionStartClass As %String(MAXLEN = 256);

/// Class to use for supplementary processing upon user session end. This class must implement a
/// class method named "SessionEnd", which takes as its only input parameter a user session object.
/// It is called before this business service deletes the user session object.
Property SessionEndClass As %String(MAXLEN = 256);

/// Configuration item to which to route FHIR search interactions on the Patient resource type. If
/// no value is specified for this setting, then at run-time the value from Target Config Name is
/// used for this setting.<br><br>
/// For the purposes of this setting, FHIR Patient search is defined as a search specifically on
/// the Patient resource type (e.g., GET [baseUrl]/Patient[?parameters]).<br><br>
/// It does not include Patient compartment-based search (e.g., GET [baseUrl]/Patient/123/Observation)
/// and does not include chained search on Patient (e.g., GET [baseUrl]/DiagnosticReport?subject:Patient.name=peter).
Property PatientHost As Ens.DataType.ConfigName;

/// 
/// Process an incoming message into the production; dispatch it to the configured target.
/// 
Method OnProcessInput(pInput As HS.Message.FHIR.Request, Output pOutput As HS.Message.FHIR.Response, ByRef pHint As %String) As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		If $$$HSTRACING {
			If pInput.QuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pInput.QuickStreamId)
				$$$HSTRACE("Input message", "pInput,tQuickStream", pInput.%ConstructClone(1), tQuickStream)
			} Else {
				$$$HSTRACE("Input message", "pInput", pInput.%ConstructClone(1))
			}
		}
		
		// If user sessions are being maintained, then SessionClass must extend HS.Util.SessionData.Session.
		If ..SessionMode'="NoSession" {
			If ..SessionClass'="" {
				If '$ClassMethod(..SessionClass, "%Extends", "HS.FHIR.SessionData.FHIRSession") {
					Set tStatus = $$$EnsError($$$GeneralError,"SessionClass "_..SessionClass_" does not extend HS.FHIR.SessionData.FHIRSession")
					Quit
				}
			} Else {
				Set tStatus = $$$EnsError($$$GeneralError,"SessionMode="_..SessionMode_" but SessionClass is not specified")
				Quit
			}
		}
		
		// Check for a target
		If ..TargetConfigName = "" {
			Set tStatus = $$$EnsError($$$EnsErrTargetNotSpecified,"TargetConfigName")
			Quit
		}
		
		// Make sure the input message is sensible
		If 'pInput.%IsA("HS.Message.FHIR.Request") {
			Set tStatus = $$$EnsError($$$EnsErrClassNotDerived,pInput.%ClassName(1), "HS.Message.FHIR.Request")
		}
		
		// The REST Handler should imprint the FHIR message with the FHIR Version.
		If (..FHIRVersion'="")&&(pInput.FHIRVersion'="")&&((","_..FHIRVersion_",")'[(","_pInput.FHIRVersion_",")) {
			Set tStatus = $$$ERROR($$$GeneralError, "FHIR Version on FHIR request does not match business service FHIR Version")
			Quit
		}

		// If this is a conformance or capabilities interaction, then bypass session-based
		// handling and pre and post processing, and send directly to TargetConfigName.
		If ((pInput.Interaction="conformance")||(pInput.Interaction="capabilities")) {
			Set tStatus = ..dispatchToProduction(..TargetConfigName, pInput, .pOutput, ..Timeout)
			Quit
		}
		
		// FHIR resource id specified in the request URL must follow the format rules.
		If '##class(HS.FHIR.Utils).IsValidResourceId(pInput.Id) {
			Set tStatus = ##class(HS.FHIR.Utils).BadRequest(pInput, .pOutput, "invalid", "Invalid resource id specified: "_pInput.Id)
			Quit
		}
		
		// Parameter session operations are intended only for end points using Parameter session mode.
		If ((pInput.Interaction="$parameter-session-start")||(pInput.Interaction="$parameter-session-end"))&&(..SessionMode'="Parameter") {
			Set tStatus = ##class(HS.FHIR.Utils).BadRequest(pInput, .pOutput, "invalid", "This end point is not configured for Parameter session mode")
			Quit
		}
		
		// Special handling for Parameter mode session start here, to avoid
		// conditionalizing session handling code downstream just for this
		// operation.
		If pInput.Interaction="$parameter-session-start" {
			Set tSessionId = ..MakeSessionId()
			Do ..GetSessionApplication(pInput, ..SessionMode, .tSessionApplication)
			Set ^CacheTemp.FHIRSession("ValidSessions", tSessionApplication, tSessionId)=""
			Set pOutput = ##class(HS.Message.FHIR.Response).%New()
			Set pOutput.Status = 200
			Set pOutput.ContentType = pInput.ContentType
			// Parameters and parameter the same between FHIR releases. Just build a string.
			If pInput.ContentType["json" {
				Set tPayload = ""
				Set tPayload = tPayload_"{"
    			Set tPayload = tPayload_"""resourceType"": ""Parameters"","
    			Set tPayload = tPayload_"""parameter"":["
        		Set tPayload = tPayload_"{"
            	Set tPayload = tPayload_"""name"":""iscSessionId"","
            	Set tPayload = tPayload_"""valueString"":"""_tSessionId_""""
        		Set tPayload = tPayload_"}"
    			Set tPayload = tPayload_"]"
				Set tPayload = tPayload_"}"
			} Else {
				Set tPayload = ""
				Set tPayload = tPayload_"<Parameters xmlns=""http://hl7.org/fhir"">"
    			Set tPayload = tPayload_"<parameter>"
        		Set tPayload = tPayload_"<name value=""iscSessionId""/>"
        		Set tPayload = tPayload_"<valueString value="""_tSessionId_"""/>"
    			Set tPayload = tPayload_"</parameter>"
				Set tPayload = tPayload_"</Parameters>"
			}
			If ..FormatFHIROutput {
				Set tSC = ##class(HS.FHIR.Utils).FormatFHIR(pInput.ContentType, tPayload, .tParametersStream, $Char(32,32), $Char(13,10), , 2)
				If $$$ISERR(tSC) Quit
				Do pOutput.Payload.CopyFrom(tParametersStream)
			} Else {
				Do pOutput.Payload.Write(tPayload)
				Do pOutput.Payload.Rewind()
			}
			Quit
		}
		
		// Validate or Create the session if sessions are enabled for this service.
		If ..SessionMode'="NoSession" {
			Set tStatus = ..ValidateSession(.pInput, ..SessionMode, ..SessionClass, ..SessionStartClass, ..SessionEndClass, .pOutput)
			If $$$ISERR(tStatus) Quit
			If $IsObject($Get(pOutput))&&(+pOutput.Status>399)&&(+pOutput.Status<599) Quit
		}
		
		// Special handling for Parameter mode session end here, to avoid
		// conditionalizing session handling code downstream just for this
		// operation.
		If pInput.Interaction="$parameter-session-end" {
			Set tStatus = ..EndParameterSession(..SessionClass, ..SessionEndClass, pInput.SessionApplication, pInput.SessionId, , pInput.Interaction)
			If $$$ISERR(tStatus) Quit
			Set pOutput = ##class(HS.Message.FHIR.Response).%New()
			Set pOutput.Status = 200
			Quit
		}
		
		If (pInput.Interaction="search")&&(pInput.Type="Patient")&&(pInput.Compartment="") {
			Set tHost = ..PatientHost
			If tHost="" Set tHost = ..TargetConfigName
		} Else {
			Set tHost = ..TargetConfigName
		}
		
		// Now dispatch with timeout
		Set tStatus = ..dispatchToProduction(tHost, pInput, .pOutput, ..Timeout)
		Quit:$$$ISERR(tStatus)
		
		If '$IsObject($Get(pOutput)) Quit
		
		If 'pOutput.%IsA("HS.Message.FHIR.Response") {
			Set tStatus = $$$EnsError($$$EnsErrClassNotDerived,pOutput.%ClassName(1), "HS.Message.FHIR.Response")
			Quit
		}
		
		If (+pOutput.Status>399)&&(+pOutput.Status<599) Quit
		
		Set tStatus = ..PostProcessResponse(pInput, ..SessionMode, .pOutput)
		
		// Done!
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	// We don't need the request QuickStream data any more, so clear it now.
	If ($IsObject($Get(pInput)))&&(pInput.QuickStreamId'="") {
		Set tQStream = ##class(HS.SDA3.QuickStream).%OpenId(pInput.QuickStreamId)
		If $IsObject(tQStream) Do tQStream.Clear() Set pInput.QuickStreamId = ""
	}
	
	// ProcessInteraction() also catches and handles error status in
	// this way, but it is unclear if OnProcessInput() will ever be
	// invoked by something other than ProcessInteraction.  Therefore
	// this code is included here too.
	If $$$ISERR(tStatus) {
		Set tStatus = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tStatus, pInput.ContentType, .pOutput, ..FormatFHIROutput)
		Set pOutput.Status = ##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
	}
	
	If $$$HSTRACING {
		If $IsObject($Get(pOutput)) {
			If pOutput.QuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pOutput.QuickStreamId)
				$$$HSTRACE("FHIR response message to be returned", "pOutput,tQuickStream", pOutput, tQuickStream)
			} Else {
				Set tQuickStream = ""
				$$$HSTRACE("FHIR response message to be returned", "pOutput", pOutput)
			}
		}
	}
	
	Quit tStatus
}

/// ValidateSession verifies that there is a valid session object
/// for the specified application name and session id, and
/// determines whether to create a session object for the session
/// if none exists.  Base behavior is to create the session object
/// if it does not exist.  Override this method to use alternate
/// logic for valid session.
Method ValidateSession(pFHIRRequest As HS.Message.FHIR.Request, pSessionMode As %String, pSessionClass As %String, pSessionStartClass As %String, pSessionEndClass As %String, ByRef pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pSessionMode="NoSession" Quit
		
		If (pFHIRRequest.Interaction="conformance")||(pFHIRRequest.Interaction="capabilities") Quit
		
		#; These resources are not session-specific.
		Set tNonSession("Conformance") = ""
		Set tNonSession("CapabilityStatement") = ""
		Set tNonSession("StructureDefinition") = ""
		Set tNonSession("ValueSet") = ""
		Set tNonSession("ConceptMap") = ""
		Set tNonSession("NamingSystem") = ""
		Set tNonSession("DataElement") = ""
		Set tNonSession("OperationDefinition") = ""
		Set tNonSession("SearchParameter") = ""
		Set tNonSession("ImplementationGuide") = ""
		Set tNonSession("TestScript") = ""
		If (pFHIRRequest.Type'="")&&($Data(tNonSession(pFHIRRequest.Type))) Quit
		
		Do ..GetSessionIdentifiers(pFHIRRequest, pSessionMode , .tApplication, .tSessionId)
		
		If tApplication="" {
			Set tSC = $$$ERROR($$$GeneralError,"Session application name not found when processing request")
			Quit
		} ElseIf tSessionId="" {
			Set tSC = $$$ERROR($$$GeneralError,"Session id not found when processing request")
			Quit
		}
		
		Set tExists = $ClassMethod(pSessionClass, "AppSessionExists", tApplication, tSessionId, .tSessionObjID)
		
		If pSessionMode="Parameter" {
			Set tSC = ..ValidateParameterSession(pFHIRRequest, pSessionClass, pSessionStartClass, pSessionEndClass, tApplication, tSessionId, tExists, tSessionObjID, .pFHIRResponse)
			If $$$ISERR(tSC) Quit
		} ElseIf pSessionMode="OAuth" {
			Set tSC = ..ValidateOAuthSession(pFHIRRequest, pSessionClass, pSessionStartClass, pSessionEndClass, tApplication, tSessionId, tExists, tSessionObjID, .pFHIRResponse)
		} Else {
			Set tSC = $$$ERROR($$$GeneralError,"Invalid session mode defined")
		}
		If $$$ISERR(tSC) Quit
		
		Set pFHIRRequest.SessionApplication = tApplication
		Set pFHIRRequest.SessionId = tSessionId
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method GetSessionIdentifiers(pFHIRRequest As HS.Message.FHIR.Request, pSessionMode As %String, ByRef pSessionApplication As %String, ByRef pSessionId As %String)
{
	Do ..GetSessionApplication(pFHIRRequest, pSessionMode, .pSessionApplication)
	Do ..GetSessionId(pFHIRRequest, pSessionMode, .pSessionId)
	Quit
}

Method GetSessionApplication(pFHIRRequest As HS.Message.FHIR.Request, pSessionMode As %String, ByRef pSessionApplication As %String)
{
	Set pSessionApplication = ""
	
	If pSessionMode="NoSession" {
		Set pSessionApplication = ""
	} ElseIf (pSessionMode="OAuth")||(pSessionMode="Parameter") {
		#; The CSP application that invokes this business service should
		#; not have an Event Class value defined when this business
		#; service is in OAuth or Parameter mode.
		Set pSessionApplication = pFHIRRequest.BaseURL
	}
	
	Quit pSessionApplication
}

Method GetSessionId(pFHIRRequest As HS.Message.FHIR.Request, pSessionMode As %String, ByRef pSessionId As %String)
{
	Set pSessionId = ""
	
	If pSessionMode="NoSession" {
		Set pSessionId = ""
	} ElseIf pSessionMode="Parameter" {
		Set pSessionId = pFHIRRequest.GetParameterValue("iscSessionId")
		If pSessionId'="" {
			Do pFHIRRequest.Parameters.RemoveAt("iscSessionId")
		}
	} ElseIf pSessionMode="OAuth" {
		Set pSessionId = pFHIRRequest.AdditionalInfo.GetAt("OAuthSessionId")
	}
		
	Quit pSessionId
}

ClassMethod MakeSessionId() As %String
{
	Set tRandom = $system.Encryption.GenCryptRand(32)
	Quit $translate($piece($system.Encryption.Base64Encode(tRandom,1),"=",1),"+/","-_")
}

Method ValidateParameterSession(pFHIRRequest As HS.Message.FHIR.Request, pSessionClass, pSessionStartClass As %String, pSessionEndClass As %String, pApplication As %String, pSessionId As %String, pSessionExists As %String, pSessionObjID As %String, ByRef pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tInterval = ..ParameterModeTimeout
			
		If 'pSessionExists {
			#; If this is a session end request and the session has already
			#; timed out and been cleaned up by another process, do not
			#; fail this request.
			If ($Data(^CacheTemp.FHIRSession("ExpiredSessions", pApplication, pSessionId)))&&(pFHIRRequest.Interaction="$parameter-session-end") {
				Quit
			}
			
			#; The specified session application and id cannot point
			#; to a session that once existed and is now expired and
			#; deleted.  It also must use a session id that was
			#; generated by the FHIR Gateway.
			If $Data(^CacheTemp.FHIRSession("ExpiredSessions", pApplication, pSessionId)) {
				Set tSC = ##class(HS.FHIR.Utils).BadRequest(pFHIRRequest, .pFHIRResponse, "expired", "Session expired")
				Quit
			}
			If '$Data(^CacheTemp.FHIRSession("ValidSessions", pApplication, pSessionId)) {
				Set tSC = ##class(HS.FHIR.Utils).BadRequest(pFHIRRequest, .pFHIRResponse, "invalid", "Invalid session id")
				Quit
			}
			Set tContext("Username") = pFHIRRequest.AdditionalInfo.GetAt("USER:UserID")
			Set tContext("UserRoles") = pFHIRRequest.AdditionalInfo.GetAt("USER:Roles")
			Set tSC = $ClassMethod(pSessionClass, "CreateSession", .tSessionObj, pApplication, pSessionId, , .tContext)
			If $$$ISERR(tSC) Quit
			Set tSessionObj.Expires=##class(HS.FHIR.Utils).TimeInSeconds($ZTimeStamp, tInterval)
			Set tSC = tSessionObj.%Save()
			If $$$ISERR(tSC) Quit
			If pSessionStartClass'="" {
				Set tSC = $ClassMethod(pSessionStartClass, "SessionStart", tSessionObj, pFHIRRequest.FHIRVersion)
				If $$$ISERR(tSC) Quit
			}
		} Else {
			#; The session object exists.  Verify that it is not expired.
			Set tSessionObj = $ClassMethod(pSessionClass, "%OpenId", pSessionObjID, , .tSC)
			If $$$ISERR(tSC) Quit
			#; If not expired, then refresh the timeout period.
			#; If expired, delete the cache for the session and return Bad Request.
			If tSessionObj.IsExpired()=0 {
				Set tNewExpire = ##class(HS.FHIR.Utils).TimeInSeconds($ZTimeStamp, tInterval)
				Set tSessionObj.Expires = tNewExpire
				Set tSC = tSessionObj.%Save()
				If $$$ISERR(tSC) Quit
			} Else {
				#; If this is a session end request but the session is already
				#; timed out then return success.  In this case, the session
				#; will get cleaned up in OnProcessInput().
				If pFHIRRequest.Interaction="$parameter-session-end" {
					Quit
				}
				
				Set tSC = ..EndParameterSession(pSessionClass, pSessionEndClass, pApplication, pSessionId, pSessionObjID, "Session expired")
				If $$$ISERR(tSC) Quit
				Set tSC = ##class(HS.FHIR.Utils).BadRequest(pFHIRRequest, .pFHIRResponse, "expired", "Session expired")
				Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ValidateOAuthSession(pFHIRRequest As HS.Message.FHIR.Request, pSessionClass As %String, pSessionStartClass As %String, pSessionEndClass As %String, pApplication As %String, pSessionId As %String, pSessionExists As %String, pSessionObjID As %String, ByRef pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If 'pSessionExists {
			#; Base the session timeout on the access token expiration time.
			Set tExpires = ""
			If pFHIRRequest.AdditionalInfo.GetAt("JSONWebToken")'="" {
				Set tJWTObj = ##class(%DynamicAbstractObject).%FromJSON(pFHIRRequest.AdditionalInfo.GetAt("JSONWebToken"))
				If $IsObject($Get(tJWTObj)) Set tExpires = tJWTObj.exp Kill tJWTObj
			}
			#; If no JWT and/or no exp, then default the timeout to 10 minutes.
			If tExpires="" Set tExpires = ##class(HS.FHIR.Utils).TimeInSeconds($ZTimeStamp, 600)
			Set tContext("Username") = pFHIRRequest.AdditionalInfo.GetAt("USER:UserID")
			Set tContext("UserRoles") = pFHIRRequest.AdditionalInfo.GetAt("USER:Roles")
			Set tSC = $ClassMethod(pSessionClass, "CreateSession", .tSessionObj, pApplication, pSessionId, , .tContext)
			If $$$ISERR(tSC) Quit
			Set tSessionObj.Expires = tExpires
			Set tSC = tSessionObj.%Save()
			If $$$ISERR(tSC) Quit
			#; Log the session start as a login event.
			Set tSC = ##class(%ZHSLIB.UsersAndRoles).AuditOAuth2Login(pFHIRRequest.AdditionalInfo.GetAt("USER:UserID"),pFHIRRequest.AdditionalInfo.GetAt("USER:Roles"),pFHIRRequest.BaseURL,"authorize")
			If $$$ISERR(tSC) Quit
			If pSessionStartClass'="" {
				Set tSC = $ClassMethod(pSessionStartClass, "SessionStart", tSessionObj, pFHIRRequest.FHIRVersion)
				If $$$ISERR(tSC) Quit
			}
		} Else {
			// The session object exists.  Verify that it is not expired.
			Set tSessionObj = $ClassMethod(pSessionClass, "%OpenId", pSessionObjID, , .tSC)
			If $$$ISERR(tSC) Quit
			// If expired, delete the cache for the session and return Bad Request.
			If tSessionObj.IsExpired() {
				Set ^CacheTemp.FHIRSession("ExpiredSessions", pApplication, pSessionId) = ""
				If $Data(^CacheTemp.FHIRSession("ValidSessions", pApplication, pSessionId)) {
					If pSessionEndClass'="" {
						Set tSC = $ClassMethod(pSessionEndClass, "SessionEnd", tSessionObj)
						If $$$ISERR(tSC) $$$LOGWARNING($system.Status.GetErrorText(tSC)) Set tSC = $$$OK
					}
					Set tSC = $ClassMethod(pSessionClass, "EndSession", pApplication, pSessionId, pReason)
					Kill ^CacheTemp.FHIRSession("ValidSessions", pApplication, pSessionId)
				}
			}
		}

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// End or Expire a Parameter mode session.  Even if the session
/// was explicitly ended via $parameter-session-end, add it to
/// the ExpiredSessions list so that the id does not get re-used
/// before the next instance restart.
Method EndParameterSession(pSessionClass As %String, pSessionEndClass As %String, pApplication As %String, pSessionId As %String, pSessionObjID As %String = "", pReason As %String = "(Reason not stated)") As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSessionObj = ""
		
		If pSessionObjID="" {
			Set tExists = $ClassMethod(pSessionClass, "AppSessionExists", pApplication, pSessionId, .pSessionObjID)
		}
		If pSessionObjID'="" {
			Set tSessionObj = $ClassMethod(pSessionClass, "%OpenId", pSessionObjID)
		}
		Set ^CacheTemp.FHIRSession("ExpiredSessions", pApplication, pSessionId) = ""
		If $Data(^CacheTemp.FHIRSession("ValidSessions", pApplication, pSessionId)) {
			If pSessionEndClass'="" {
				Set tSC = $ClassMethod(pSessionEndClass, "SessionEnd", tSessionObj)
				If $$$ISERR(tSC) $$$LOGWARNING($system.Status.GetErrorText(tSC)) Set tSC = $$$OK
			}
			Set tSC = $ClassMethod(pSessionClass, "EndSession", pApplication, pSessionId, pReason)
			Kill ^CacheTemp.FHIRSession("ValidSessions", pApplication, pSessionId)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method PostProcessResponse(pFHIRRequest As HS.Message.FHIR.Request, pSessionMode As %String, ByRef pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	// It is unclear if this method was ever used. Retaining a stub for backward compatibility.
	Quit $$$OK
}

/// 
/// Dispatch an incoming message into the production; dispatch it to the configured target.
/// 
Method dispatchToProduction(pTargetConfigName As %String, pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response, pTimeout As %Integer) As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		// "Imprint" the FHIR version if not already done.
		If (pRequest.FHIRVersion="")&&(..FHIRVersion'="")&&(..FHIRVersion[",") {
			Set pRequest.FHIRVersion = ..FHIRVersion
		}
		
		// Determine whether any returned FHIR should have formatting
		// chars included.  FormatFHIROutput may be overridden on a
		// per-request basis by the "_pretty" URL parameter.
		Set tPretty = $ZConvert(pRequest.GetParameterValue("_pretty"), "L")
		Do pRequest.Parameters.RemoveAt("_pretty")
		Set tPretty = $Case(tPretty, "1":1, "0":0, "true":1, "false":0, :"")
		If tPretty'="" {
			Set tFormatFHIROutput = tPretty
		} Else {
			Set tFormatFHIROutput = ..FormatFHIROutput
		}
		Set pRequest.FormatFHIROutput = tFormatFHIROutput
		
		// Now dispatch with timeout
		Set tStart = $ZH
		Set tStatus = ..SendRequestSync(pTargetConfigName,pRequest,.pResponse,pTimeout)
		Set tEnd=$ZH, tElapsed=tEnd-tStart
		Quit:$$$ISERR(tStatus)

		// At this point, the return status (tStatus) is distinct from the HTTP return
		// status (pResponse.Status, if it is set at all).
		// 
		// Regarding failure status, only one of two things should be true at this point:
		// 1. tStatus is an error status and there is no pResponse object.
		// 2. tStatus is 1 and pResponse is an HS.Message.FHIR.Response object with the
		//    Status property set to some failure status, and the Payload is optionally
		//    filled in with an OperationOutcome resource stream.
		//
		// If #1, then ignore any pResponse that was received, quit and let ProcessInput()
		// formulate the error response from tStatus.
		//
		// For internal server errors, FHIR business hosts can simply return the
		// %Status and can count on HS.FHIR.Service to formulate the HS.Message.FHIR.Response
		// with Status set to 500 and Payload set to an OperationOutcome resource stream.
		//
		// For application level fails (HTTP 4xx), FHIR business hosts must create the
		// HS.Message.FHIR.Response with the proper Status=4xx and the Payload set to an
		// OperationOutcome stream, and return %Status = 1.  HS.FHIR.Service will then
		// return that response message as is back to the REST handler.
		
		// Make sure we actually got a response
		If '$IsObject($GET(pResponse)) {
			// If somehow tStatus was OK but there is no response object,
			// that is not a valid condition.  Return a FHIR response
			// message with an OperationOutcome resource.
			
			Set pResponse = ##class(HS.Message.FHIR.Response).%New()
			
			// Often when the request times out, the elapsed time of SendRequestSync() as it is computed
			// above is very slightly less than the timeout, usually by less a millisecond. Compensate
			// for that here by adding .001 to the elapsed time before comparing to pTimeout.
			If (pTimeout'="")&&((tElapsed+.001)>pTimeout) { set tOOText = "FHIR request timed out" }
			else { set tOOText = "FHIR response object missing" }
			Set tStatus = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", tOOText, .tFHIRStream, pRequest.ContentType, "processing", ..FormatFHIROutput)
			
			Set tStatus = pResponse.Payload.CopyFrom(tFHIRStream)
			
			Set pResponse.ContentType = pRequest.ContentType
			Set pResponse.Status = ##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
			
			Quit
		}
	
		// Ensure we have some kind of HTTP status to return
		If (pResponse.Status = "") {
			// Default to 200 if no error and no status was given
			Set pResponse.Status = ##class(HS.FHIR.Utils).#HTTP200OK
		}

		// Done!
		
	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}

	Quit tStatus
}

/// 
/// Dispatch the FHIR request to a business service
/// 
ClassMethod ProcessInteraction(pRequest As HS.Message.FHIR.Request, ByRef pResponse As HS.Message.FHIR.Response, pConfigName As Ens.DataType.ConfigName = {..%ClassName(1)}) As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tService As Ens.BusinessService
		
		If $G($$$EnsRuntime("Name"))="" {
			#; Production not running.
			Set pResponse = ##class(HS.Message.FHIR.Response).%New()
			Set pResponse.Status = ##class(HS.FHIR.Utils).#HTTP503SERVICEUNAVAILABLE
			Set pResponse.ContentType = pRequest.ContentType
			Quit
		}
		
		// Construct the business service
		Set tStatus = ##class(Ens.Director).CreateBusinessService(pConfigName, .tService)
		If $$$ISERR(tStatus) {
			#; This is a ClassMethod, so we don't have access to ..FormatFHIROutput,
			#; and the FHIR request does not have it (was expecting to get it from
			#; ..FormatFHIROutput later).  Hard-code to 1.
			Set tFormatFHIROutput = 1
			Set tStatus = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tStatus, pRequest.ContentType, .pResponse, tFormatFHIROutput)
			If $IsObject($Get(pResponse)) Set pResponse.Status = ##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
			Quit
		}
	
		// Now, process it
		Set tStatus = tService.ProcessInput(pRequest, .pResponse)
		If $$$ISERR(tStatus) {
			#; This is a ClassMethod, so we don't have access to ..FormatFHIROutput,
			#; and the FHIR request does not have it (was expecting to get it from
			#; ..FormatFHIROutput later).  Hard-code to 1.
			Set tFormatFHIROutput = 1
			Set tStatus = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tStatus, pRequest.ContentType, .pResponse, tFormatFHIROutput)
			If $IsObject($Get(pResponse)) Set pResponse.Status = ##class(HS.FHIR.Utils).#HTTP500INTERNALSERVERERROR
			Quit
		}
		
		// All done
		
	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}
	
	// NOTE: Any errors returned here are considered fatal operational errors.

	Quit tStatus
}

/// 
/// Process message injecting Location and/or Content-Location headers as needed
/// 
Method ProcessLocationHeader(pMetadata As HS.FHIR.InteractionMetadata, pResponse As HS.Message.FHIR.Response, pDefaultUrl As %String) As %Status
{
	#dim tStatus As %Status = $$$OK
	// Disable ProcessLocationHeader for now.  Needs re-factor, probably due to DSTU1 -> DSTU2 changes.
	Quit tStatus
	Try {

		#dim tHeader As %String = ""
		

		// Is it a Location header or Content-Location?
		Set tHeader = $CASE(pMetadata.Location,"":##class(HS.FHIR.Utils).#HTTPCONTENTLOCATION,
											 "no":##class(HS.FHIR.Utils).#HTTPCONTENTLOCATION,
											     :##class(HS.FHIR.Utils).#HTTPLOCATION)

		
		// No location specified, we should inject one
		If 'pResponse.Headers.IsDefined(tHeader) {
			
			#dim tUrl As %String
			
			// Create a location header
			Set tStatus = pMetadata.BuildUrlFromMessage(pResponse,pDefaultUrl,.tUrl)
			Quit:$$$ISERR(tStatus)
			
			// Inject the header
			Set tStatus = pResponse.Headers.SetAt(tUrl,tHeader)
			Quit:$$$ISERR(tStatus)
		}
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	Quit tStatus
}

}
