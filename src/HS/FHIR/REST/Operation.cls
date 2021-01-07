Include HS.FHIR.Errors

/// 
/// FHIR REST client business operation
/// 
Class HS.FHIR.REST.Operation Extends Ens.BusinessOperation
{

Property Adapter As Ens.OutboundAdapter;

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=HTTP},-Validate,MetadataClass:Basic,FHIRVersion:Basic";

/// HTTP Service Registry entry for the target server.  This value may be overridden
/// on a per-message basis by specifying the ServiceName in the request message.
Property ServiceName As %String(MAXLEN = 255);

/// Attempt to validate the interaction, specifically the status codes & content type
Property Validate As %Boolean [ InitialExpression = 0, Required ];

/// Interaction Metadata class to use
Property MetadataClass As Ens.DataType.Class [ InitialExpression = "HS.FHIR.InteractionMetadata", Required ];

/// FHIR Version indicator (if specified)
Property FHIRVersion As %String(MAXLEN = 255);

/// HTTP request object for REST operations
Property HttpRequest As %Net.HttpRequest [ Internal ];

/// Cache of interaction metadata keyed by interaction name
Property MetadataCache As array Of HS.FHIR.InteractionMetadata [ Transient ];

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			Set tSC = ..FHIRRequest(pRequest, .pResponse)
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Message class "_pRequest.%ClassName(1)_" not handled")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Process a client-side FHIR request to the specified remote server
Method FHIRRequest(pRequest As HS.Message.FHIR.Request, pResponse As HS.Message.FHIR.Response) As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tUrl As %String
		#dim tKey As %String
		#dim tValue As %String
		#dim tMetadata As HS.FHIR.InteractionMetadata
		#dim tServiceObj As HS.Registry.Service.HTTP
		
		// Clear the HTTP request ready for this operation
		Set tStatus = ..HttpRequest.Reset()
		Quit:$$$ISERR(tStatus)
		
		// Special code path for HTTP GET on a full URL.
		If pRequest.AdditionalInfo.GetAt("GetURL")'="" {
			Set tStatus = ..GetByURL(pRequest, .pResponse)
			Quit
		}
		
		// Look up the metadata for this interaction.
		Set tStatus = ..GetInteractionMetadata(pRequest.Interaction, .tMetadata)
		Quit:$$$ISERR(tStatus)
		
		Set tServiceName = pRequest.AdditionalInfo.GetAt("ServiceName")
		If tServiceName="" Set tServiceName = ..ServiceName
		If tServiceName'="" {
			Set tServiceObj = ##class(HS.Registry.Service.HTTP).EndPointForNameType(tServiceName, "HTTP")
			If $IsObject(tServiceObj) {
				Set pRequest.BaseURL = tServiceObj.EndPoint
				Set ..HttpRequest.SSLConfiguration = tServiceObj.SSLConfig
				Set ..HttpRequest.Server = tServiceObj.Host
				Set ..HttpRequest.Port = tServiceObj.Port
				Set:..HttpRequest.Port="" ..HttpRequest.Port = 80
				Set ..HttpRequest.Https = (tServiceObj.SSLConfig'="")
				Set ..HttpRequest.Timeout=$Select(tServiceObj.Timeout="":30,tServiceObj.Timeout=-1:2123456789,1:tServiceObj.Timeout)
				If tServiceObj.HTTPCredentialsConfig'="" {
					Set tCredentialsObj = ##class(Ens.Config.Credentials).%OpenId(tServiceObj.HTTPCredentialsConfig)
					If '$IsObject($Get(tCredentialsObj)) {
						Set tStatus = $$$ERROR($$$GeneralError, "Invalid HTTP Credentials Config defined for Service Registry entry "_tServiceName)
						Quit
					}
					Set ..HttpRequest.Username = tCredentialsObj.Username
					Set ..HttpRequest.Password = tCredentialsObj.Password
				}
			} Else {
				Set tStatus = $$$ERROR($$$GeneralError, "Service Registry entry for "_tServiceName_" not found")
				Quit
			}
		} Else {
			Set tStatus = $$$ERROR($$$GeneralError, "Service Registry name not specified")
			Quit
		}
		
		// Construct the URL using the info in the request message
		Set tStatus = tMetadata.BuildUrlFromMessage(pRequest, pRequest.BaseURL, .tUrl)
		Quit:$$$ISERR(tStatus)
		
		// conditonal update, conditional delete, and conditional patch can end up with unnecessary trailing slash.
		If ($Extract(tUrl,*)="/")&&('((pRequest.Interaction="transaction")||(pRequest.Interaction="search-all"))) {
			Set tUrl = $Extract(tUrl, 1, *-1)
		}
		
		// And add the query string (if we have query parameters)
		Set tStatus = ##class(HS.FHIR.Utils).BuildQueryString(pRequest, .tUrl)
		Quit:$$$ISERR(tStatus)
		
		// Copy HTTP headers except for HOST
		Set tKey = ""
		For {
			Set tValue = pRequest.Headers.GetNext(.tKey)
			Quit:tKey=""
			If $ZConvert(tKey,"U")="HOST" Continue
			Set tStatus = ..HttpRequest.SetHeader(tKey, tValue)
			Quit:$$$ISERR(tStatus)
		}
		
		Quit:$$$ISERR(tStatus)
		
		Set tFHIRVersion = $Select(pRequest.FHIRVersion'="":pRequest.FHIRVersion, 1:"STU3")
		
		If tFHIRVersion'="DSTU2" {
			Set tFormalXMLMimeType = "application/fhir+xml"
			Set tFormalJSONMimeType = "application/fhir+json"
		} Else {
			Set tFormalXMLMimeType = "application/xml+fhir"
			Set tFormalJSONMimeType = "application/json+fhir"
		}
		
		Do ##class(HS.FHIR.Utils).GetAllValidFormats(.tValidFormats)
		
		// The user can override the Accept header with a valid _format URL parameter.
		Set tAcceptFromURL = ""
		Set tInteraction = pRequest.Interaction
		Set tFormat = pRequest.GetParameterValue("_format")
		If tFormat'="" {
			If $Data(tValidFormats("Parameter", tFormat)) {
				If (tFormat="application/fhir+xml")||(tFormat="application/xml+fhir") {
					Set tAcceptFromURL = tFormat
				} ElseIf (tFormat="application/fhir+json")||(tFormat="application/json+fhir") {
					Set tAcceptFromURL = tFormat
				} ElseIf (tFormat="xml") {
					Set tAcceptFromURL = tFormalXMLMimeType
				} ElseIf (tFormat="json") {
					Set tAcceptFromURL = tFormalJSONMimeType
				} ElseIf (tFormat="text/xml")||(tFormat="application/xml") {
					Set tAcceptFromURL = tFormat
				} ElseIf (tFormat="application/json") {
					Set tAcceptFromURL = tFormat
				}
			} Else {
				Set tStatus = $$$ERROR($$$GeneralError, "Invalid FHIR request _format value '"_tFormat_"' specified")
				Quit
			}
		}
		
		Set tRequestStream = pRequest.GetPayloadOref()
		
		If pRequest.ContentType'="" {
			If ($Data(tValidFormats("ContentType", pRequest.ContentType)))||($Data(tValidFormats("Patch", pRequest.ContentType))) {
				Set tContentType = pRequest.ContentType
			} Else {
				Set tStatus = $$$ERROR($$$GeneralError, "Invalid FHIR request ContentType specified")
				Quit
			}
		} ElseIf tRequestStream.Size>0 {
			Set tStatus = $$$ERROR($$$GeneralError, "FHIR request ContentType not specified for content")
			Quit
		}
		
		// Accept gets the first found of _format URL param, request Accept property, or
		// request ContentType property. The latter is kept for backward compatibility.
		If tAcceptFromURL'="" {
			Set tAccept = tAcceptFromURL
		} ElseIf pRequest.Accept'="" {
			If $Data(tValidFormats("Accept", pRequest.Accept)) {
				Set tAccept = pRequest.Accept
			} Else {
				Set tStatus = $$$ERROR($$$GeneralError, "Invalid FHIR request Accept specified")
				Quit
			}
		} Else {
			// Retain this for backward compatibility.
			Set tAccept = pRequest.ContentType
		}
		
		If tRequestStream.Size>0 {
			Set ..HttpRequest.ContentType = tContentType
			// Per the spec (http://www.hl7.org/fhir/http.html#mime-type), the request body must be
			// UTF-8 encoded, and this must be explicitly stated using the charset parameter of the
			// Content-Type header. Setting ContentCharset will do both.
			Set ..HttpRequest.ContentCharset = "UTF-8"
			// Write the payload
			Do ..HttpRequest.EntityBody.CopyFrom(tRequestStream)
			Do ..HttpRequest.EntityBody.Rewind()
		}
		
		// Inject the ContentType as an Accept header (unless it already exists)
		If (tAccept'="")&&(..HttpRequest.GetHeader(##class(HS.FHIR.Utils).#HTTPACCEPT)="") {
			Set tStatus = ..HttpRequest.SetHeader(##class(HS.FHIR.Utils).#HTTPACCEPT, tAccept)
			Quit:$$$ISERR(tStatus)
		}
		
		// Add the OAuth2 access token to the HTTP request headers, if applicable.
		Set tStatus = ..AddOAuth2Header(pRequest)
		Quit:$$$ISERR(tStatus)
		
		// Map the HTTP Method to the correct function in %Net.HttpRequest
		#dim tMethod As %String = $E(tMetadata.Method,1)_$ZCVT($E(tMetadata.Method,2,*),"L")
		
		// Compute the "path" (ignoring the scheme/host/port portion)
		#dim tPath As %String = "/"_$P(tUrl,"/",4,*)
		
		Do ..LogHTTPRequest("[HS.FHIR.REST.Operation:FHIRRequest]",0,..HttpRequest,tMethod,tUrl,.formData)
		
		// "Invoke" the HTTP method ...
		If (tMethod'="Delete")&&(tMethod'="Patch") {
			Set tStatus = $METHOD(..HttpRequest,tMethod,tPath)
		} Else {
			Set tStatus = $METHOD(..HttpRequest,"Send",$ZConvert(tMethod,"U"),tPath)
		}
		Quit:$$$ISERR(tStatus)

		#dim tHttpResponse As %Net.HttpResponse = ..HttpRequest.HttpResponse
		
		If '$IsObject(tHttpResponse) {
			Set tStatus = $$$ERROR($$$HSFHIRXErrConnectionFailed,tUrl,tMethod)
			Quit
		}
		
		Do ..LogHTTPResponse("[HS.FHIR.REST.Operation:FHIRRequest]",0,..HttpRequest)
		
		// Construct a response object ...
		Set tStatus = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tStatus)

		// Grab the HTTP status
		Set pResponse.Status = tHttpResponse.StatusCode _ " " _ tHttpResponse.ReasonPhrase		
		
		// Grab the content type
		Set pResponse.ContentType = tHttpResponse.ContentType
		
		// "Imprint" the FHIR version (if specified)
		If ..FHIRVersion '= "" {
			Set pResponse.FHIRVersion = ..FHIRVersion
		}

		// Deal with the response payload (if any).
		If ##class(HS.FHIR.Utils).HttpResponseContentLength(tHttpResponse)>0 {
			// This business operation will use a QuickStream to hold the client-side
			// response content (if any), if the request specifically specified to
			// do that. That would be indicated by the request AdditionalInfoItem
			// named "UseQuickStreamForResponseContent" being added and set to 1.
			Set tUseQuickStream = pRequest.AdditionalInfo.GetAt("UseQuickStreamForResponseContent")
			If $IsObject(tHttpResponse.Data) {
				// Copy the payload stream
				If tUseQuickStream {
					Set tQStream = ##class(HS.SDA3.QuickStream).%New()
					Set pResponse.QuickStreamId = tQStream.%Id()
					Set tStatus = tQStream.CopyFrom(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = tQStream.Rewind()
					Quit:$$$ISERR(tStatus)
				} Else {
					Set tStatus = pResponse.Payload.CopyFrom(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = pResponse.Payload.Rewind()
					Quit:$$$ISERR(tStatus)
				}
			} Else {
				If tUseQuickStream {
					Set tQStream = ##class(HS.SDA3.QuickStream).%New()
					Set pResponse.QuickStreamId = tQStream.%Id()
					Set tStatus = tQStream.Write(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = tQStream.Rewind()
					Quit:$$$ISERR(tStatus)
				} Else {
					// Manually "write" the [string] data
					Set tStatus = pResponse.Payload.Write(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = pResponse.Payload.Rewind()
					Quit:$$$ISERR(tStatus)
				}
			}
		}
		
		// Copy the returned HTTP headers
		Set tKey = ""
		For {
			Set tKey = tHttpResponse.GetNextHeader(tKey)
			Quit:tKey=""
			
			Set tValue = tHttpResponse.GetHeader(tKey)
			
			Do pResponse.Headers.SetAt(tValue, tKey)
		}
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	Quit tStatus
}

/// Handle an HTTP GET on a specified full URL, as opposed to a URL
/// whose pieces and parts reside throughout the HS FHIR request
/// message.  The URL does not necessarily need to be a FHIR request.
Method GetByURL(pRequest As HS.Message.FHIR.Request, pResponse As HS.Message.FHIR.Response)
{
	Set tStatus = $$$OK
	
	Try {
		#; Required inputs:
		#; - pRequest.AdditionalInfo.GetAt("GetURL")
		#;
		#; Optional inputs:
		#; - pRequest.ContentType
		#; - pRequest.AdditionalInfo.GetAt("ServiceName")
		
		Set tURL = pRequest.AdditionalInfo.GetAt("GetURL")
		
		If '(($Extract(tURL,1,7)="http://")||($Extract(tURL,1,8)="https://")) {
			Set tStatus = $$$ERROR($$$GeneralError, "Format of specified URL not supported")
			Quit
		}
		
		If (pRequest.Interaction'="")&&(pRequest.Interaction'="read")&&(pRequest.Interaction'="vread")&&(pRequest.Interaction'="search") {
			Set tStatus = $$$ERROR($$$GeneralError, "Invalid FHIR request interaction specified")
			Quit
		}
		
		Set ..HttpRequest.Server = $Piece($Piece(tURL, "/", 3), ":", 1)
		Set ..HttpRequest.Port = $Piece($Piece(tURL, "/", 3), ":", 2)
		Set tPath = "/"_$Piece($Piece(tURL, "/", 4, 99), "?", 1)
		
		#; If a ServiceName is specified then use the Timeout, SSL Config
		#; HTTP Credentials from the Service Registry entry.  Do not use
		#; the host, port or URL.
		Set tServiceName = pRequest.AdditionalInfo.GetAt("ServiceName")
		If tServiceName'="" {
			Set tServiceObj = ##class(HS.Registry.Service.HTTP).EndPointForNameType(tServiceName, "HTTP")
			If $IsObject(tServiceObj) {
				Set ..HttpRequest.SSLConfiguration = tServiceObj.SSLConfig
				Set ..HttpRequest.Https = (tServiceObj.SSLConfig'="")
				Set ..HttpRequest.Timeout=$Select(tServiceObj.Timeout="":30,tServiceObj.Timeout=-1:2123456789,1:tServiceObj.Timeout)
				If tServiceObj.HTTPCredentialsConfig'="" {
					Set tCredentialsObj = ##class(Ens.Config.Credentials).%OpenId(tServiceObj.HTTPCredentialsConfig)
					If '$IsObject($Get(tCredentialsObj)) {
						Set tStatus = $$$ERROR($$$GeneralError, "Invalid HTTP Credentials Config defined for Service Registry entry "_tServiceName)
						Quit
					}
					Set ..HttpRequest.Username = tCredentialsObj.Username
					Set ..HttpRequest.Password = tCredentialsObj.Password
				}
			} Else {
				Set tStatus = $$$ERROR($$$GeneralError, "Service Registry entry for "_tServiceName_" not found")
				Quit
			}
		}
		
		#; If the URL parameters include a valid _format parameter value
		#; then do not set the Accept header.
		Set tParameters = $ZConvert($Piece(tURL, "?", 2, 99), "I", "URL")
		Do ##class(HS.FHIR.Utils).GetValidFormats("parameter", .tValidFormats)
		Set tFormatParameter = ""
		Set tFormat = ""
		For {
			Set tFormat = $Order(tValidFormats(tFormat))
			If tFormat= "" Quit
			If tParameters[("_format="_tFormat) Set tFormatParameter = tFormat Quit
		}
		If tFormatParameter="" {
			If pRequest.ContentType'="" {
				Set tStatus = ..HttpRequest.SetHeader("Accept", pRequest.ContentType)
			} Else {
				Set tStatus = ..HttpRequest.SetHeader("Accept", "*/*;charset=UTF-8")
			}
		}
		If $$$ISERR(tStatus) Quit
		
		If tParameters'="" {
			For i = 1:1:$Length(tParameters,"&") {
				Set tName = $Piece($Piece(tParameters,"&",i),"=",1)
				Set tValue = $Piece($Piece(tParameters,"&",i),"=",2,99)
				If (tName'="")&&(tValue'="") Do ..HttpRequest.SetParam(tName,tValue,i)
			}
		}
		
		Set tStatus = $METHOD(..HttpRequest, "Get", tPath)
		If $$$ISERR(tStatus) Quit
		
		#dim tHttpResponse As %Net.HttpResponse
		Set tHttpResponse = ..HttpRequest.HttpResponse
		
		Set tStatus = pRequest.NewResponse(.pResponse)
		If $$$ISERR(tStatus) Quit
		
		// Grab the HTTP status
		Set pResponse.Status = tHttpResponse.StatusCode _ " " _ tHttpResponse.ReasonPhrase		
		
		// Grab the content type
		Set pResponse.ContentType = tHttpResponse.ContentType
		
		// Deal with the response payload (if any).
		If ##class(HS.FHIR.Utils).HttpResponseContentLength(tHttpResponse)>0 {
			// This business operation will use a QuickStream to hold the client-side
			// response content (if any), if the request specifically specified to
			// do that. That would be indicated by the request AdditionalInfoItem
			// named "UseQuickStreamForResponseContent" being added and set to 1.
			Set tUseQuickStream = pRequest.AdditionalInfo.GetAt("UseQuickStreamForResponseContent")
			If $IsObject(tHttpResponse.Data) {
				// Copy the payload stream
				If tUseQuickStream {
					Set tQStream = ##class(HS.SDA3.QuickStream).%New()
					Set pResponse.QuickStreamId = tQStream.%Id()
					Set tStatus = tQStream.CopyFrom(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = tQStream.Rewind()
					Quit:$$$ISERR(tStatus)
				} Else {
					Set tStatus = pResponse.Payload.CopyFrom(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = pResponse.Payload.Rewind()
					Quit:$$$ISERR(tStatus)
				}
			} Else {
				If tUseQuickStream {
					Set tQStream = ##class(HS.SDA3.QuickStream).%New()
					Set pResponse.QuickStreamId = tQStream.%Id()
					Set tStatus = tQStream.Write(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = tQStream.Rewind()
					Quit:$$$ISERR(tStatus)
				} Else {
					// Manually "write" the [string] data
					Set tStatus = pResponse.Payload.Write(tHttpResponse.Data)
					Quit:$$$ISERR(tStatus)
					Set tStatus = pResponse.Payload.Rewind()
					Quit:$$$ISERR(tStatus)
				}
			}
		}
		
		// Copy the returned HTTP headers
		Set tKey = ""
		For {
			Set tKey = tHttpResponse.GetNextHeader(tKey)
			Quit:tKey=""
			Set tValue = tHttpResponse.GetHeader(tKey)
			Do pResponse.Headers.SetAt(tValue, tKey)
		}
		
	} Catch ex {
		Set tStatus = ex.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Helper method for getting interaction metadata.  This first consults the local metadata cache before
/// calling out to the metadata class to get the metadata.
/// 
/// NOTE: Restarting this production element will flush the cache.
/// 
Method GetInteractionMetadata(pInteraction As %String, ByRef pMetadata As HS.FHIR.InteractionMetadata) As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		
		// Look to the interaction cache ...
		If ..MetadataCache.IsDefined(pInteraction) {
			Set pMetadata = ..MetadataCache.GetAt(pInteraction)
			Quit
		}
		
		Try {
			// Need to fetch the interaction definition from the metadata [sub]class
			Set tStatus = $CLASSMETHOD(..MetadataClass, "InteractionByName", pInteraction, .pMetadata)
			Quit:$$$ISERR(tStatus)
			
		} Catch (tUnexpected) {
			// Unexpected error, invalid metadata class!
			Set tStatus = $$$ERROR($$$HSFHIRXErrInvalidMetadataClass, ..MetadataClass)
			Set tStatus = $$$ADDSC(tStatus, tUnexpected.AsStatus())
		}
		
		If $$$ISERR(tStatus) {
			Quit
		}
		
		// Don't cache search because there are multiple search metadata possibilities.
		// ... and keep it in the cache for next time
		If pInteraction'="search" Set tStatus = ..MetadataCache.SetAt(pMetadata,pInteraction)
		Quit:$$$ISERR(tStatus)
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	Quit tStatus
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		
		// Construct an HTTP response
		Set ..HttpRequest = ##class(%Net.HttpRequest).%New()
		
		// Clear the cache
		Set tStatus = ..MetadataCache.Clear()
		Quit:$$$ISERR(tStatus)
		
		// Check the metadata class name
		If '##class(%Dictionary.CompiledClass).%ExistsId(..MetadataClass) {
			Set tStatus = $$$ERROR($$$HSFHIRXErrInvalidMetadataClass,..MetadataClass)
			Set tStatus = $$$ADDSC(tStatus, $$$ERROR($$$ClassDoesNotExist,..MetadataClass))
			Quit
		}
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	Quit tStatus
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		
		// ...
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	Quit tStatus
}

/// Add the OAuth2 access token to the HTTP request headers, if applicable.
Method AddOAuth2Header(pRequest As HS.Message.FHIR.Request) As %Status
{
	Set tStatus = $$$OK
	
	Try {
		If pRequest.AdditionalInfo.GetAt("OAuth2ClientName")'="" {
			If pRequest.AdditionalInfo.GetAt("ClientSessionId")'="" {
				#; If adding the access token to the HTTP headers then use
				#; the SSL Config that is defined on the OAuth2 client.
				Set tSSLConfiguration = ""
				#; tSendType is the mode of sending access token to resource server.
				Set tSendType = "header"
				Set tStatus = ##class(%SYS.OAuth2.AccessToken).AddAccessToken(..HttpRequest, tSendType, , pRequest.AdditionalInfo.GetAt("OAuth2ClientName"), pRequest.AdditionalInfo.GetAt("ClientSessionId"))
			} Else {
				Set tStatus = $$$ERROR($$$GeneralError, "Session Id for OAuth2 Client not specified")
			}
		}
		
	} Catch ex {
		Set tStatus = ex.AsStatus()
	}
	
	Quit tStatus
}

/// Log details of HTTP request to be made
ClassMethod LogHTTPRequest(methodName As %String, server As %Boolean, httpRequest As %Net.HttpRequest, method As %String, url As %String, ByRef formData) [ Internal ]
{
	#define SysLogLevel                            $get(^%ISCLOG,1)
	#define SysLog(%level,%cat,%message,%data)     Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data)
	
	If $$$SysLogLevel<3 Quit

	Set data=method_": "_url
	Set data=data_", Content-Type: "_httpRequest.ContentType
	Set data("SSLConfiguration")=httpRequest.SSLConfiguration
	Set data("Username")=httpRequest.Username
	Set authorization=httpRequest.GetHeader("AUTHORIZATION")
	If authorization'="" {
		Set data=data_", Authorization: "_authorization
	}
	Set accept=httpRequest.GetHeader("ACCEPT")
	If accept'="" {
		Set data=data_", Accept: "_accept
	}
	Set stream=##class(%Stream.GlobalCharacter).%New()
	Do httpRequest.OutputFormData(stream)
	Do stream.Rewind()
	Set data("-body-")=stream.Read()
	Set name=""
	For {
		Set name=$order(formData(name),1,value)
		If name="" Quit
		Set data(name)=value
	}
	$$$SysLog(3,"HSFHIR"_$select(server:"Server",1:""),methodName_"HTTP Request",.data)
}

/// Log details of HTTP response
ClassMethod LogHTTPResponse(methodName As %String, server As %Boolean, httpRequest As %Net.HttpRequest) [ Internal ]
{
	#define SysLogLevel                            $get(^%ISCLOG,1)
	#define SysLog(%level,%cat,%message,%data)     Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data)
	
	Set tReadLen = $Select($system.SYS.MaxLocalLength()=3641144:3640000,1:32000)
	
	If $$$SysLogLevel<3 Quit
	
	Set httpResponse=httpRequest.HttpResponse
	Set data="StatusCode="_httpResponse.StatusCode
	Set data=data_", ContentType="_httpResponse.ContentType
	Set data=data_",body="
	If $isobject(httpResponse.Data) {
		Set data=data_httpResponse.Data.Read(tReadLen)
	} Else {
		Set data=data_httpResponse.Data
	}
	If $$$SysLogLevel>=5 {
		Merge data=httpResponse.Headers
	}
	$$$SysLog(3,"HSFHIR"_$select(server:"Server",1:""),methodName_"HTTP Response",.data)
}

}
