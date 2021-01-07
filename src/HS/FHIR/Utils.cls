Include (HS.HC, HS.FHIR.Errors, %occSAX)

/// Helpful utilities
Class HS.FHIR.Utils
{

Parameter CONTENTTYPEANY As %String = "*/*";

Parameter CONTENTTYPEXML As %String = "application/xml+fhir";

Parameter CONTENTTYPEJSON As %String = "application/json+fhir";

Parameter CONTENTTYPETEXTPLAIN As %String = "text/plain";

Parameter HTTPLOCATION As %String = "Location";

Parameter HTTPACCEPT As %String = "Accept";

Parameter HTTPCONTENTLOCATION As %String = "Content-Location";

Parameter HTTP200OK As %String = "200 OK";

Parameter HTTP400BADREQUEST As %String = "400 Bad Request";

Parameter HTTP404NOTFOUND As %String = "404 Not Found";

Parameter HTTP406NOTACCEPTABLE As %String = "406 Not Acceptable";

Parameter HTTP500INTERNALSERVERERROR As %String = "500 Internal Server Error";

Parameter HTTP502BADGATEWAY As %String = "502 Bad Gateway";

Parameter HTTP503SERVICEUNAVAILABLE As %String = "503 Service Unavailable";

Parameter INTERACTIONMETDATACLASS = "HS.FHIR.InteractionMetadata";

/// API
/// Construct a FHIR OperationOutcome structure from a %Status value.  Note that depending on the desired content type
/// this structure could be JSON or XML.
/// <br>
/// NOTE: The OperationOutcome structure isn't rich enough to capture the "embedded" status values in a %Status.<br>
/// Input:<br>
/// <li>pStatus           : (required) %Library.Status object.
/// <li>pContentType      : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResponse         : FHIR response object. If it is not passed in then it is created by this method.
/// <li>pFormatFHIROutput : 0 = Do not add indent and line terminator formatting to the response Payload stream.
///                         1 = Add indent and line terminator formatting to the response Payload stream.
ClassMethod OperationOutcomeFromStatus(pStatus As %Status, pContentType As %String, ByRef pResponse As HS.Message.FHIR.Response, pFormatFHIROutput As %Boolean = 0) As %Status
{
    #dim tStatus As %Status = $$$OK
    Try {
	    Do ..GetAllValidFormats(.tValidFormats)
	    
	    Set tContentType = ""
	    For i = 1:1:$Length(pContentType,";") {
		    Set tX = $Piece(pContentType,";",i)
		    Set tX = $ZStrip(tX,"<>W")
		    If (tX'="")&&($Data(tValidFormats("ContentType",tX))#10) {
			    Set tContentType = tValidFormats("ContentType",tX)
			    Quit
		    }
		    Quit
	    }
	    
	    // Force content type to XML if none could be discerned by this point.
	    If tContentType'="" {
		    Set pContentType = tContentType
	    } Else {
		    Set pContentType = "text/xml"
	    }
		
		If '$IsObject($Get(pResponse)) Set pResponse = ##class(HS.Message.FHIR.Response).%New()
		
		Set pResponse.ContentType = pContentType
		
		// Clear any existing content in the response message payload stream.
		// That content will be replaced with the OperationOutcome data.
		Set tResponseStream = pResponse.GetPayloadOref()
		If tResponseStream.%IsA("HS.SDA3.QuickStream") {
			Set tStatus = tResponseStream.Clear(0)
		} Else {
			Set tStatus = tResponseStream.Clear()
		}
		If $$$ISERR(tStatus) Quit
		
		Do $system.Status.DecomposeStatus(pStatus, .tErrors)
		
		Set tSC = ..StartOutcomeStream(pContentType, .tResponseStream, pFormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		For tIndex = 1:1:tErrors {
			Set tSC = ..AddOutcomeIssueStream(pContentType, .tResponseStream, "error", "exception", tErrors(tIndex), , , tErrors(tIndex))
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tStatus) Quit
		
		Set tSC = ..EndOutcomeStream(pContentType, .tResponseStream, pFormatFHIROutput)
		If $$$ISERR(tStatus) Quit
		
		Do tResponseStream.Rewind()
		
    } Catch (tEx) {
	    Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// 
/// Convert a %Status error code back into it's "mnemonic" code.  For example, in the
/// case of error 5809, we use $$$LoadObjectNotFound in the $$$ERROR macro to construct a
/// %Status.  In the case of 5809, the mnemonic would be "LoadObjectNotFound".
/// 
/// We have to rummage around in the ^IRIS.MsgNames (local) and ^%qMsgNames (system)
/// globals to match the code up to the mnemonic.
/// 
ClassMethod mnemonicForStatusCode(pCode As %String) As %String [ Internal ]
{
	#dim tMnemonic As %String = ""
	#dim tGbl As %String
	#dim tDomain As %String
	
	// Hackery .. there's no API for this.
	For tGbl = "^IRIS.MsgNames","^%qMsgNames" {
		Set tDomain = ""
		For {
			Set tDomain = $ORDER(@tGbl@(tDomain))
			Quit:tDomain=""
		
			If $DATA(@tGbl@(tDomain,pCode)) {
				Set tMnemonic = ^(pCode)
				Quit
			}
		}
	}
	
	Quit $CASE(tMnemonic,"":pCode,:tMnemonic)
}

/// 
/// Helper method for parsing XML XDATA blocks containing metadata.  Designed to be called from a method generator, so
/// this class has a System=4 to ensure it gets compiled *before* anything that uses this method in a generator.
/// 
ClassMethod GetMetadataFromXDATA(pClassName As %String, pXDATA As %String, ByRef pMap) As %Status [ Internal ]
{
    #dim tStatus As %Status = $$$OK
    Try {
        
	    #dim tStream As %Stream.TmpCharacter
	    #dim tHandler As %XML.ImportHandler
		#dim tCompiledClass As %Dictionary.CompiledClass
	    
	    #dim tIndex,tI,tCounter As %Integer
	    #dim tChild,tType,tError As %String
	    
       
        // Grab the class & XDATA
        If ##class(%Dictionary.CompiledXData).%ExistsId(pClassName_"||"_pXDATA) {
            
            Set tCompiledClass=##class(%Dictionary.CompiledClass).%OpenId(pClassName,,.tStatus)
            If '$IsObject(tCompiledClass)||$$$ISERR(tStatus) {
	            Quit
            }
            
            Set tIndex = tCompiledClass.XDatas.FindObjectId(pClassName_"||"_pXDATA)
            If tIndex="" {
	            Set tStatus = $$$ERROR($$$XDataBlockMissing,pClassName,pXDATA)
	            Quit
            }
        
            // Get XDATA as stream
            Set tStream = tCompiledClass.XDatas.GetAt(tIndex).Data
            Do tStream.Rewind()
            
            // Create an XML import handler ( use the internal handler )
            Set tHandler = ##class(%XML.ImportHandler).%New("CacheTemp",$$$IntHandler) 
        
            // Create the Entity Resolver
            Set tResolver = ##class(%XML.SAX.XDataEntityResolver).%New(pClassName)
        
            // Parse the XML data in the specfied stream
            Set tStatus = ##Class(%XML.SAX.Parser).ParseStream(tStream,tHandler,tResolver,,,pXDATA_"Schema")
            Quit:$$$ISERR(tStatus)
        
            // Copy tree because handler will delete it's copy when it goes out of scope
            Merge pMap = ^CacheTemp(tHandler.Tree)
    
    		// Make sure the XData block was valid
            If $Data(pMap("error"))||$Data(pMap("warning")) {
                Set tStatus = $$$ERROR($$$HSFHIRXErrInvalidMetadata, pXDATA)
                For tType = "error","warning" {       
                    Set tIndex = "" For {
                        Set tIndex = $Order(pMap(tType,tIndex),1,tError) If tIndex="" Quit
                        Set tStatus = $$$ADDSC(tStatus,$$$ERROR($$$GeneralError,tError))
                    }
                }
                Quit
            }
        } Else {
            
            // The specified class must have the named XDATA Block
            Set tStatus=$$$ERROR($$$XDataBlockMissing,pClassName,pXDATA)
            Quit
        }

        
    } Catch (tEx) {
	    Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// 
/// Parse a URL spec (i.e. something like /fhir/:Type/:Id) into a regular expression pattern and a list of arg names (e.g. Type, Id)
/// in a $LIST in group order (so the values can be extracted by name from the regular expression matcher).  Optionally, the args can
/// be "wrapped" in quotes etc. if needed (e.g. for code generation).
/// 
ClassMethod ParseUrlSpec(pUrlSpec As %String, ByRef pPattern As %String, ByRef pArgs As %List, pArgWrapper As %String = "") As %Status
{
    #dim tStatus As %Status = $$$OK
    Try {
	    #dim tPattern As %List
	    
	    Set tPattern = ""
	    Set pArgs = ""

		#dim tIndex As %Integer
		#dim tPiece As %String
		
	    For tIndex = 1:1:$LENGTH(pUrlSpec,"/") {
	        Set tPiece=$PIECE(pUrlSpec,"/",tIndex)
	        If $EXTRACT(tPiece) = ":" {
		        If $LENGTH(tPiece)>1 {
	            	Set tPattern = tPattern_$LB("([^/]+)")
	            	Set pArgs = pArgs_$LB(pArgWrapper_$EXTRACT(tPiece,2,*)_pArgWrapper)
		        } Else {
			        Set tPattern = tPattern_$LB("[^/]+")
		        }
	        } ElseIf $EXTRACT(tPiece) = "*" {
		        If $LENGTH(tPiece)>1 {
	            	Set tPattern = tPattern_$LB("(.*)")
	            	Set pArgs = pArgs_$LB(pArgWrapper_$EXTRACT(tPiece,2,*)_pArgWrapper)
		        } Else {
			        Set tPattern = tPattern_$LB(".*")
		        }
	        } Else {
	            Set tPattern = tPattern _ $LB(tPiece)
	        }
	    }
	    
	    Set pPattern = $LISTTOSTRING(tPattern,"/")
	    
    } Catch (tEx) {
	    Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// 
/// Convert common %Status values into HTTP status codes.  Note: this is not exhaustive
/// 
ClassMethod StatusToHttp(pStatus As %Status, ByRef pHttpStatus As %String = "") As %Status
{
    #dim tStatus As %Status = $$$OK
    Try {

		// Map common errors
		#dim tCodes As %String = $system.Status.GetErrorCodes(pStatus)
		#dim tIndex
		
		For tIndex = 1:1:$LENGTH(tCodes,",") {
			#dim tCode As %String
			#dim tMatch As %String
			
			Set tCode = $PIECE(tCodes,",",tIndex)
			
			// Try to match the %Status code
			Set tMatch = $CASE(tCode,
					$$$LoadObjectNotFound:						..#HTTP404NOTFOUND,
					$$$HSFHIRXErrEntityNotFound:					..#HTTP404NOTFOUND,
					$$$HSFHIRXErrUrlNotMatchedToInteraction:		..#HTTP404NOTFOUND,
					$$$HSFHIRXErrPayloadMissing:					..#HTTP400BADREQUEST,
					$$$HSFHIRXErrPayloadUnexpected:				..#HTTP400BADREQUEST,
					$$$HSFHIRXErrContentTypeNotSupported:		..#HTTP406NOTACCEPTABLE,
					$$$EnsErrProductionNotRunning:				..#HTTP503SERVICEUNAVAILABLE,
					$$$EnsErrBusinessDispatchNameNotRegistered:	..#HTTP502BADGATEWAY,
					:"")
								
			If tMatch'="" {
				Set pHttpStatus = tMatch
				Quit
			}
		}

    } Catch (tEx) {
	    Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// API
/// Helper to determine the amount of content in a %Net.HttpResponse instance
/// 
ClassMethod HttpResponseContentLength(pHttpResponse As %Net.HttpResponse) As %Integer [ CodeMode = expression ]
{
$SELECT(pHttpResponse.ContentLength'="":pHttpResponse.ContentLength,$IsObject(pHttpResponse.Data):pHttpResponse.Data.Size,1:$LENGTH(pHttpResponse.Data))
}

/// API
/// Construct the URL query string from the array of parameters in the request.
/// 
ClassMethod BuildQueryString(pRequest As HS.Message.FHIR.Request, ByRef pUrl As %String) As %Status
{
	#dim tStatus As %Status = $$$OK
	Try {
		// Inject any URL query parameters
		If (pRequest.Parameters.Count() > 0) {
			#dim tQuery As %String
			#dim tKey As %String
			#dim tValue As %String
		
			Set (tKey, tQuery) = ""
			For {
				Set tValue = pRequest.Parameters.GetNext(.tKey)
				Quit:tKey=""
				
				// NOTE: The parameters are actually a $LIST of parameter values as there can be multiple
				//       URL query values with the same name.  The $LIST keeps them in sequence
				
				#dim tIndex As %Integer
				For tIndex = 1:1:$LL(tValue) {
					#dim tSubItem = $LG(tValue,tIndex)
					
					Set:tQuery'="" tQuery = tQuery _ "&"
					Set tQuery = tQuery _ $ZCVT(tKey,"O","URL")_"="_$ZCVT(tSubItem,"O","URL")
				}
			}
		
			Quit:$$$ISERR(tStatus)
			
			// Append the query string
			Set pUrl = pUrl _ $SELECT(pUrl'["?":"?",1:"&") _ tQuery
		}
		
	} Catch (tEx) {
		Set tStatus = tEx.AsStatus()
	}
	
	Quit tStatus
}

/// API
/// HSFHIRToFHIR creates a FHIR XML or JSON stream from an HS FHIR data model object.
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pHSFHIRObj         : (required) HS FHIR data model object instance. NOT a %DynamicObject or %XML.Document object.
/// <li>pFormatFHIROutput  : 0 = Do not add indent and line terminator formatting to the output stream.
///                          1 = Add indent and line terminator formatting to the output stream.
/// <br>Output::<br>
/// <li>pFHIRStream        : FHIR stream object. If not passed in, is initialized as %Stream.GlobalCharacter.
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod HSFHIRToFHIR(pContentType As %String, pHSFHIRObj As %RegisteredObject, ByRef pFHIRStream As %Stream.GlobalCharacter, pFormatFHIROutput As %Boolean = 0, pDummy) As %Status
{
	Set tSC = $$$OK
	Set pSuppressXMLProlog = 1
	
	If '$IsObject($Get(pFHIRStream)) Set pFHIRStream = ##class(%Stream.GlobalCharacter).%New()
	
	If pFormatFHIROutput=1 {
		Set %formattabchar=$Char(32,32)
		Set %formatcrchar=$Char(13,10)
	} Else {
		Set %formattabchar=""
		Set %formatcrchar=""
	}
	
	If '$IsObject($Get(pHSFHIRObj)) {
		Set tSC = $$$ERROR($$$GeneralError,"Specified FHIR input is not an object")
	} ElseIf $ZConvert(pContentType,"L")["json" {
		Set tSC = ##class(HS.JSON.Writer).%CaptureWriteJSONToStream(pHSFHIRObj, .pFHIRStream, 1)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,"FHIR stream write failed - "_$system.Status.GetErrorText(tSC))
	} ElseIf $ZConvert(pContentType,"L")["xml" {
		Set tSC = ##class(HS.XML.WriterFHIR).%CaptureWriteXMLToStream(pHSFHIRObj, .pFHIRStream, 1, pSuppressXMLProlog)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,"FHIR stream write failed - "_$system.Status.GetErrorText(tSC))
	} Else {
		Set tSC = $$$ERROR($$$GeneralError, "Invalid content type "_$Select(pContentType'="":pContentType,1:"(blank)")_" specified")
	}
	
	If ($$$ISOK(tSC)) {
		If $IsObject($Get(pFHIRStream))=0 {
			Set tSC = $$$ERROR($$$GeneralError,"FHIR stream not created")
		} ElseIf pFHIRStream.Size=0 {
			Set tSC = $$$ERROR($$$GeneralError,"FHIR stream not created")
		}
	}
	
	#; Add a prefix to any error status that may have been generated.
	If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,$classname()_" HSFHIRToFHIR() error converting FHIR data object to FHIR stream - "_$system.Status.GetErrorText(tSC))
	
	Kill %formattabchar
	Kill %formatcrchar
	
	Quit tSC
}

/// API
/// FHIRToHSFHIR creates an HS FHIR data model object from a FHIR XML or JSON stream or string.
/// Input:<br>
/// <li>pContentType        : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pFHIRStreamOrString : (required) FHIR stream object or string.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br>Output::<br>
/// <li>pHSFHIRObj         : HS FHIR data model object instance. NOT a %DynamicObject or %XML.Document object.
ClassMethod FHIRToHSFHIR(pContentType As %String, pFHIRStreamOrString, ByRef pHSFHIRObj As %RegisteredObject, pResourceSchemaRoot As %String = "HS.FHIR.Model.Resource", pNoLongerUsed As %String) As %Status
{
	Set tSC = $$$OK
	
	Kill pHSFHIRObj
	
	If pResourceSchemaRoot = "HS.FHIR.Model" Set pResourceSchemaRoot = "HS.FHIR.Model.Resource"
	
	If $ZConvert(pContentType,"L")["json" {
		Set tSC = ##class(HS.JSON.AdaptorFHIR).%FromFHIRJSON(pFHIRStreamOrString, .pHSFHIRObj, pResourceSchemaRoot)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,"%FromFHIRJSON failed - "_$system.Status.GetErrorText(tSC))
	} ElseIf $ZConvert(pContentType,"L")["xml" {
		Set tSC = ##class(HS.XML.AdaptorFHIR).%FromFHIRXML(pFHIRStreamOrString, .pHSFHIRObj, pResourceSchemaRoot)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,"%FromFHIRXML failed - "_$system.Status.GetErrorText(tSC))
	} Else {
		Set tSC = $$$ERROR($$$GeneralError, "Invalid content type "_$Select(pContentType'="":pContentType,1:"(blank)")_" specified")
	}
	
	If ($$$ISOK(tSC))&&($IsObject($Get(pHSFHIRObj))=0) {
		Set tSC = $$$ERROR($$$GeneralError,"HS FHIR object not created")
	}
	
	#; Add a prefix to any error status that may have been generated.
	If $$$ISERR(tSC) {
		Set tSC = $$$ERROR($$$GeneralError,$classname()_" FHIRToHSFHIR() error converting FHIR stream to FHIR data object - "_$system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

/// Derive the http[s]://host:port string from the CSP request information.
/// The relevant CSP information was stored in the HS FHIR request message
/// by HS.FHIR.REST.Handler.  If the HTTP client accessed the server by
/// specifying an IP address rather than a hostname, then this method will
/// yield a string that includes the IP address as the host.  If the
/// request was via https then the port number might be omitted.
ClassMethod GetHttpHostPort(pRequest As HS.Message.FHIR.Request) As %String
{
	set tHttp = $Select(pRequest.AdditionalInfo.GetAt("Secure"):"https:",1:"http:")
	set tHost = $Piece(pRequest.Headers.GetAt("HOST"),":",1)
	set tPort = $Piece(pRequest.Headers.GetAt("HOST"),":",2)
	set tHttpHostAndPort = tHttp_"//"_tHost_$Select(tPort'="":":"_tPort,1:"")
	Quit tHttpHostAndPort
}

/// Derive the http[s]://host:port/baseurl string from the CSP request
/// information.  The relevant CSP information was stored in the HS FHIR
/// request message by HS.FHIR.REST.Handler.
ClassMethod GetURLBase(pRequest As HS.Message.FHIR.Request, ByRef pSC As %Status) As %String
{
	set pSC = $$$OK
	try {
		set tURL = ..GetHttpHostPort(pRequest)_pRequest.BaseURL
	}
	catch ex { set pSC = ex.AsStatus() }
	quit tURL
}

/// Derive the http[s]://host:port/baseurl string from the CSP request
/// information, plus any resource type and/or resource id and/or operation
/// parameters from the HS FHIR request message.  The relevant CSP information
/// was stored in the HS FHIR request message by HS.FHIR.REST.Handler.
ClassMethod GetURLWithParams(pRequest As HS.Message.FHIR.Request, ByRef pSC As %Status) As %String
{
	set pSC = $$$OK
	set tURL = ""
	try {
		set pSC = $ClassMethod(..#INTERACTIONMETDATACLASS, "InteractionByName", pRequest.Interaction, .tMetadata)
		if $$$ISERR(pSC) quit
		set pSC = tMetadata.BuildUrlFromMessage(pRequest, pRequest.BaseURL, .tURL)
		if $$$ISERR(pSC) quit
		set tURL = ..GetHttpHostPort(pRequest)_tURL
	}
	catch ex { set pSC = ex.AsStatus() }
	quit tURL
}

/// Return the full request URI including the http protocol and host
/// and port.  This string is derived from the CSP request information
/// that was stored into the HS FHIR request message by HS.FHIR.REST.Handler
/// and from the current contents of the Parameters collection in the HS
/// FHIR request message.  Please note that this implies that some scenarios
/// may remove some items from the Parameters collection before calling this
/// method, due to those parameters being unsupported or invalid.
ClassMethod GetURLWithQuery(pRequest As HS.Message.FHIR.Request, ByRef pSC As %Status) As %String
{
	set pSC = $$$OK
	try {
		set tURL = ..GetURLWithParams(pRequest, .pSC)
		if $$$ISERR(pSC) quit
		set pSC = ..BuildQueryString(pRequest, .tURL)
	}
	catch ex { set pSC = ex.AsStatus() }
	quit tURL
}

/// API
/// Get the resource type for the resource contained in a ResourceContainer object.<br>
/// <br>
/// Input:<br>
/// <li>pResourceContainer : (required) HS FHIR ResourceContainer object. Only one of its
///                          resource properties should be populated.
/// <br><br>
/// Output:<br>
/// <li>pResourceType      : Resource type of the resource held in pResourceContainer.
ClassMethod GetResourceTypeFromContainer(pResourceContainer, Output pResourceType As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pResourceType = ""
	
	If '$IsObject($Get(pResourceContainer)) {
		Set tSC = $$$ERROR($$$GeneralError, "ResourceContainer object not specified for GetResourceTypeFromContainer")
	} Else {
		Set pResourceType = pResourceContainer.GetResourceType()
		If pResourceType="" Set tSC = $$$ERROR($$$GeneralError, "GetResourceTypeFromContainer did not find resource object type")
	}
	
	Quit tSC
}

/// API
/// Get the resource that is contained in a ResourceContainer object.<br>
/// <br>
/// Input:<br>
/// <li>pResourceContainer : (required) HS FHIR ResourceContainer object. Only one of its
///                          resource properties should be populated.
/// <br><br>
/// Output:<br>
/// <li>pResource          : FHIR resource object held in the container object.
ClassMethod GetResourceFromContainer(pResourceContainer, Output pResource) As %Status
{
	Set tSC = $$$OK
	
	Kill pResource Set pResource = ""
	
	If '$IsObject($Get(pResourceContainer)) {
		Set tSC = $$$ERROR($$$GeneralError, "ResourceContainer object not specified for GetResourceFromContainer")
	} Else {
		Set pResource = pResourceContainer.GetResource()
		If '$IsObject(pResource) Set tSC = $$$ERROR($$$GeneralError, "GetResourceFromContainer did not find resource object")
	}
	
	Quit tSC
}

/// API
/// Get the resource that is contained in the specified resource, given the
/// id, and, optionally, the resource type.<br>
/// <br>
/// Input:<br>
/// <li>pHSFHIRObj      : (required) HS FHIR resource object.
/// <li>pId             : (required) Resource id of the contained resource to find.
/// <li>pType           : Resource type of the contained resource to find.
/// <br><br>
/// Output:<br>
/// <li>pResource       : FHIR resource object contained in pHSFHIRObj.
ClassMethod GetContainedResource(pHSFHIRObj, pId As %String = "", pType As %String = "", Output pResource) As %Status
{
	Set tSC = $$$OK
	
	Kill pResource Set pResource = ""
	
	Try {
		If '$IsObject($Get(pHSFHIRObj)) Set tSC = $$$ERROR($$$GeneralError, "Containing FHIR resource object not specified") Quit
		
		If pHSFHIRObj.contained.Count()=0 Set tSC = $$$ERROR($$$GeneralError, "Specified containing FHIR resource object has no contained resources") Quit
		
		If (pId="")||(pId="#") Set tSC = $$$ERROR($$$GeneralError, "Contained resource id not specified") Quit
		
		If $Extract(pId)="#" Set pId = $Extract(pId,2,*)
		
		For i = 1:1:pHSFHIRObj.contained.Count() {
			Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(pHSFHIRObj.contained.GetAt(i), .pResource)
			If ((pType="")||((pType'="")&&(pResource.%ClassName(0)=pType)))&&(pResource.id.value=pId) Quit
			Kill pResource Set pResource = ""
		}
		
		If '$IsObject(pResource) Set tSC = $$$ERROR($$$GeneralError, "Could not find contained "_$Select(pType'="":pType_" ",1:"")_"resource id "_pId) Quit
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Deprecated. Please use HS.HC.Util IsOID().
ClassMethod IsOID(pString As %String) As %Boolean
{
	If $Extract(pString,1,8)="urn:oid:" Quit 1
	If pString?1"2.25."30N.N Quit 1
	If (($Extract(pString,1,2)="1.")||($Extract(pString,1,2)="2."))&&($Length(pString)>10&&($Length($Translate(pString,$Translate(pString,"."),"")>3))&&($Length($Translate(pString,"0123456789."))=0)) Quit 1
	Quit 0
}

/// Deprecated. Please use HS.HC.Util IsUUID().
ClassMethod IsUUID(pString As %String) As %Boolean
{
	If $Extract(pString,1,9)="urn:uuid:" Quit 1
	If $Length(pString)'=36 Quit 0
	If $Length(pString,"-")'=5 Quit 0
	If $Length($Translate(pString,"-0123456789abcdef"))>0 Quit 0
	Quit 1
}

/// IndexBundle creates some indexes for the specified Bundle.
/// The indexes are held in a local array.
ClassMethod IndexBundle(pBundle, ByRef pBundleIndex As %String)
{
	#; pBundleIndex("TypeIndexByEntry", resourceType, entryNumber) = ""
	
	#; pBundleIndex("EntryIndexById", resourceType_"/"_resourceId) = entryNumber
	
	#; pBundleIndex("EntryIndexByFullUrl", fullUrl) = entryNumber
	
	#; pBundleIndex("TypeCount", resourceType) = count
	
	#; pBundleIndex("EncounterIndexById", resourceId) = first identifier found in Encounter
	#; EncounterIndexById used by HS.FHIR.Server.DTL.ToSDA
	
	For i = 1:1:pBundle.entry.Count() {
		Set tSC = ##class(HS.FHIR.Utils).GetResourceFromContainer(pBundle.entry.GetAt(i).resource, .tResource)
		If $$$ISERR(tSC) Quit
		Set tResourceType = tResource.%ClassName(0)
		Set tResourceId = tResource.id.value
		Set pBundleIndex("TypeIndexByEntry", tResourceType, i) = ""
		Set pBundleIndex("EntryIndexById", tResourceType_"/"_tResourceId) = i
		If pBundle.entry.GetAt(i).fullUrl.value'="" Set pBundleIndex("EntryIndexByFullUrl", pBundle.entry.GetAt(i).fullUrl.value) = i
		If $i(pBundleIndex("TypeCount", tResourceType))
		If (tResourceType="Encounter")&&(tResource.id.value'="") {
			If (tResource.identifier.Count()>0)&&(tResource.identifier.GetAt(1).value.value'="") {
				Set pBundleIndex("EncounterIndexById", tResource.id.value) = tResource.identifier.GetAt(1).value.value
			}
		}
	}
	
	Quit
}

/// COPIED FROM %OAuth2.Utils.
/// Convert $h value to seconds since start of the Unix epoch,<br>
/// time is $h value.<br>
/// interval is interval to be added in seconds.
ClassMethod TimeInSeconds(time As %String, interval As %Integer = 0) As %Integer [ Internal ]
{
	Quit (($piece(time,",")-47117)*86400+$piece(time,",",2)+interval)\1
}

/// API
/// BadRequest constructs a FHIR response message with Status = 400 and an OperationOutcome
/// for the specified code and text.<br>
/// If pFHIRResponse is not passed in, then it will be created here, and the OperationOutcome
/// stream will be placed in a QuickStream, and the response object QuickStreamId property
/// will be updated.
/// If pFHIRResponse is passed in, then this method will figure out where the response Payload
/// is to be held - in the Payload property or in a QuickStream - and place the OperationOutcome
/// stream accordingly.
ClassMethod BadRequest(pFHIRRequest As HS.Message.FHIR.Request, ByRef pFHIRResponse As HS.Message.FHIR.Response, pCode As %String, pText As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// If the response object does not yet exist, then the response
		// stream will be placed in a QuickStream. Otherwise if the
		// response message already exists, the just find out where the
		// response stream is being maintained (Payload property or
		// QuickStream).
		If '$IsObject($Get(pFHIRResponse)) {
			Set tSC = pFHIRRequest.NewResponse(.pFHIRResponse)
			If $$$ISERR(tSC) Quit
			Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
			Set pFHIRResponse.QuickStreamId = tResponseStream.%Id()
		} Else {
			Set tResponseStream = pFHIRResponse.GetPayloadOref()
		}
		
		Set pFHIRResponse.Status = 400
		Set pFHIRResponse.Type = "OperationOutcome"
		Set pFHIRResponse.ContentType = pFHIRRequest.ContentType
		
		Set tSC = ..CreateOperationOutcomeStream("error", pText, .tResponseStream, pFHIRRequest.ContentType, pCode, pFHIRRequest.FormatFHIROutput)
  		If $$$ISERR(tSC) Quit
  		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// CreateOperationOutcomeStream creates a FHIR OperationOutcome resource stream using the specified inputs.
ClassMethod CreateOperationOutcomeStream(pSeverity As %String, pText As %String, ByRef pOutputStream As %Stream.Object, pContentType As %String, pCode As %String = "", pFormatFHIROutput As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pOutputStream)) Set pOutputStream = ##class(%Stream.TmpCharacter).%New()
		
		Set tSC = ..CreateOutcomeSingleIssueStream(pContentType, .pOutputStream, pSeverity, pCode, pText, , , pText, , , pFormatFHIROutput)
		
		Do pOutputStream.Rewind()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "Error creating OperationOutcome stream for "_$get(pSeverity,"blank severity")_" '"_$get(pText,"blank text")_"' - "_$system.Status.GetErrorText(tSC))
	
	Quit tSC
}

/// API
/// CreateOutcomeSingleIssueStream uses methods StartOutcomeStream(), AddOutcomeIssueStream() and
/// EndOutcomeStream() to create an OperationOutcome resource stream that has only one issue object
/// included.<br>
/// <br>Input:<br>
/// <li>pContentType        : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pSeverity           : (required) Error severity code, should be an IssueSeverity code (http://hl7.org/fhir/issue-severity).
/// <li>pCode               : (required) Error type code, should be an IssueType code (http://hl7.org/fhir/issue-type).
/// <li>pDetailsText        : Brief text description of the error.
/// <li>pDetailsCode        : Code for more detailed categorization of the error.  Examples are the
///                           operation outcome codes from HL7 (http://hl7.org/fhir/operation-outcome).
/// <li>pDetailsDescription : Text description associated with the DetailsCode.
/// <li>pDiagnostics        : Additional diagnostic information about the issue.
/// <li>pLocation           : Error location, as an XPath expression.
/// <li>pExpression         : Error location, as a FHIRPath expression.
/// <li>pFormatFHIROutput   : 0 = No indent or line end formatting on the output stream.
///                           1 = Add indent or line end formatting on the output stream.
/// <br>Output:<br>
/// <li>pStream             : OperationOutcome resource stream object. This object may be passed
///                           in as a new stream object. Otherwise it will be initialized as a
///                           %Stream.TmpCharacter object.
ClassMethod CreateOutcomeSingleIssueStream(pContentType As %String, ByRef pStream As %Stream.Object, pSeverity As %String, pCode As %String, pDetailsText As %String = "", pDetailsCode As %String = "", pDetailsDescription As %String = "", pDiagnostics As %String = "", pLocation As %String = "", pExpression As %String = "", pFormatFHIROutput As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pSeverity)="" {
			Set tSC = $$$ERROR($$$GeneralError, "OperationOutcome issue severity not specified")
		} ElseIf $Get(pCode)="" {
			Set tSC = $$$ERROR($$$GeneralError, "OperationOutcome issue code not specified")
		}
		If $$$ISERR(tSC) Quit
		
		If '$IsObject($Get(pStream)) Set pStream = ##class(%Stream.TmpCharacter).%New()
		
		Set tSC = ..StartOutcomeStream(pContentType, .pStream, pFormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..AddOutcomeIssueStream(pContentType, .pStream, pSeverity, pCode, pDetailsText, pDetailsCode, pDetailsDescription, pDiagnostics, pLocation, pExpression, , pFormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..EndOutcomeStream(pContentType, .pStream, pFormatFHIROutput)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// StartOutcomeStream starts a FHIR OperationOutcome resource stream. This method is intended
/// to be used in conjunction with AddOutcomeIssueStream and EndOutcomeStream.
/// <br>Input:<br>
/// <li>pContentType        : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pFormatFHIROutput   : 0 = No indent or line end formatting on the output stream.
///                           1 = Add indent or line end formatting on the output stream.
/// <br>Output:<br>
/// <li>pStream             : OperationOutcome resource stream object. This object may be passed
///                           in as a new stream object. Otherwise it will be initialized as a
///                           %Stream.TmpCharacter object.
ClassMethod StartOutcomeStream(pContentType As %String, ByRef pStream As %Stream.Object, pFormatFHIROutput As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pStream)) Set pStream = ##class(%Stream.TmpCharacter).%New()
		
		If pFormatFHIROutput {
			Set tIndent = $Char(32,32)
			Set tLineTerm = $Char(13,10)
		} Else {
			Set tIndent = ""
			Set tLineTerm = ""
		}
		
		If $ZConvert(pContentType,"L")["json" {
			Do pStream.Write("{"_tLineTerm)
			Do pStream.Write(tIndent_"""resourceType"":""OperationOutcome"","_tLineTerm)
			Do pStream.Write(tIndent_"""issue"":["_tLineTerm)
		} Else {
			Do pStream.Write("<OperationOutcome xmlns=""http://hl7.org/fhir"">"_tLineTerm)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// EndOutcomeStream adds the closing tags on an existing FHIR OperationOutcome resource stream.
/// This method is intended to be used in conjunction with StartOutcomeStream and AddOutcomeIssueStream.
/// <br>Input:<br>
/// <li>pContentType        : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pStream             : (required) OperationOutcome resource stream object, which is under construction.
/// <li>pFormatFHIROutput   : 0 = No indent or line end formatting on the output stream.
///                           1 = Add indent or line end formatting on the output stream.
ClassMethod EndOutcomeStream(pContentType As %String, ByRef pStream As %Stream.Object, pFormatFHIROutput As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pFormatFHIROutput {
			Set tIndent = $Char(32,32)
			Set tLineTerm = $Char(13,10)
		} Else {
			Set tIndent = ""
			Set tLineTerm = ""
		}
		
		If $ZConvert(pContentType,"L")["json" {
			Do pStream.Write(tIndent_"]"_tLineTerm)
			Do pStream.Write("}")
		} Else {
			Do pStream.Write("</OperationOutcome>")
		}
		
		Do pStream.Rewind()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// AddOutcomeIssueStream adds a FHIR OperationOutcome issue to an existing OperationOutcome
/// resource stream, using the specified inputs. This method is intended to be used in
/// conjunction with StartOutcomeStream and EndOutcomeStream.
/// <br>Input:<br>
/// <li>pContentType        : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pStream             : (required) OperationOutcome resource stream object, which is under construction.
/// <li>pSeverity           : (required) Error severity code, should be an IssueSeverity code (http://hl7.org/fhir/issue-severity).
/// <li>pCode               : (required) Error type code, should be an IssueType code (http://hl7.org/fhir/issue-type).
/// <li>pDetailsText        : Brief text description of the error.
/// <li>pDetailsCode        : Code for more detailed categorization of the error.  Examples are the
///                           operation outcome codes from HL7 (http://hl7.org/fhir/operation-outcome).
/// <li>pDetailsDescription : Text description associated with the DetailsCode.
/// <li>pDiagnostics        : Additional diagnostic information about the issue.
/// <li>pLocation           : Error location, as an XPath expression.
/// <li>pExpression         : Error location, as a FHIRPath expression.
/// <li>pFormatFHIROutput   : 0 = No indent or line end formatting on the output stream.
///                           1 = Add indent or line end formatting on the output stream.
ClassMethod AddOutcomeIssueStream(pContentType As %String, ByRef pStream As %Stream.Object, pSeverity As %String, pCode As %String, pDetailsText As %String = "", pDetailsCode As %String = "", pDetailsDescription As %String = "", pDiagnostics As %String = "", pLocation As %String = "", pExpression As %String = "", pWriteComma As %Boolean = 0, pFormatFHIROutput As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pSeverity)="" {
			Set tSC = $$$ERROR($$$GeneralError, "OperationOutcome issue severity not specified")
		} ElseIf $Get(pCode)="" {
			Set tSC = $$$ERROR($$$GeneralError, "OperationOutcome issue code not specified")
		}
		If $$$ISERR(tSC) Quit
		
		If pFormatFHIROutput {
			Set tIndent = $Char(32,32)
			Set tLineTerm = $Char(13,10)
		} Else {
			Set tIndent = ""
			Set tLineTerm = ""
		}
		
		For i = 1:1:9 Set $Piece(tIndent(i),tIndent,i+1) = ""
		
		If $ZConvert(pContentType,"L")["json" {
			Set pDetailsText = $ZConvert(pDetailsText,"O","JSON")
			Set pDiagnostics = $ZConvert(pDiagnostics,"O","JSON")
			Set pLocation = $ZConvert(pLocation,"O","JSON")
			Do pStream.Write(tIndent(2)_"{"_tLineTerm)
			Do pStream.Write(tIndent(3)_"""severity"":"""_pSeverity_""","_tLineTerm)
			Do pStream.Write(tIndent(3)_"""code"":"""_pCode_""","_tLineTerm)
			If (pDetailsCode'="")||(pDetailsDescription'="")||(pDetailsText'="") {
				Do pStream.Write(tIndent(3)_"""details"":"_tLineTerm)
				Do pStream.Write(tIndent(4)_"{"_tLineTerm)
				If (pDetailsCode'="")||(pDetailsDescription'="") {
					Do pStream.Write(tIndent(5)_"""coding"":["_tLineTerm)
					Do pStream.Write(tIndent(6)_"{"_tLineTerm)
					If pDetailsCode'="" {
						Do pStream.Write(tIndent(7)_"""code"":"""_pDetailsCode_"""")
						If pDetailsDescription'="" Do pStream.Write(",")
						Do pStream.Write(tLineTerm)
					}
					If pDetailsDescription'="" Do pStream.Write(tIndent(7)_"""display"":"""_pDetailsDescription_""""_tLineTerm)
					Do pStream.Write(tIndent(6)_"}"_tLineTerm)
					Do pStream.Write(tIndent(5)_"]")
					If pDetailsText'="" Do pStream.Write(",")
					Do pStream.Write(tLineTerm)
				}
				Do pStream.Write(tIndent(5)_"""text"":"""_pDetailsText_""""_tLineTerm)
				Do pStream.Write(tIndent(4)_"}")
				If (pDiagnostics'="")||(pLocation'="")||(pExpression'="") Do pStream.Write(",")
				Do pStream.Write(tLineTerm)
			}
			If pDiagnostics'="" {
				Do pStream.Write(tIndent(3)_"""diagnostics"":"""_pDiagnostics_"""")
				If (pLocation'="")||(pExpression'="") Do pStream.Write(",")
				Do pStream.Write(tLineTerm)
			}
			If pLocation'="" {
				Do pStream.Write(tIndent(3)_"""location"":["_tLineTerm)
				Do pStream.Write(tIndent(4)_""""_pLocation_""""_tLineTerm)
				Do pStream.Write(tIndent(3)_"]")
				If pExpression'="" Do pStream.Write(",")
				Do pStream.Write(tLineTerm)
			}
			If pExpression'="" {
				Do pStream.Write(tIndent(3)_"""expression"":["_tLineTerm)
				Do pStream.Write(tIndent(4)_""""_pExpression_""""_tLineTerm)
				Do pStream.Write(tIndent(3)_"]"_tLineTerm)
			}
			Do pStream.Write(tIndent(2)_"}")
			If pWriteComma Do pStream.Write(",")
			Do pStream.Write(tLineTerm)
		} Else {
			Set pDetailsText = $ZConvert(pDetailsText,"O","XML")
			Set pDiagnostics = $ZConvert(pDiagnostics,"O","XML")
			Set pLocation = $ZConvert(pLocation,"O","XML")
			Do pStream.Write(tIndent(1)_"<issue>"_tLineTerm)
			Do pStream.Write(tIndent(2)_"<severity value="""_pSeverity_"""/>"_tLineTerm)
			Do pStream.Write(tIndent(2)_"<code value="""_pCode_"""/>"_tLineTerm)
			If (pDetailsCode'="")||(pDetailsDescription'="")||(pDetailsText'="") {
				Do pStream.Write(tIndent(2)_"<details>"_tLineTerm)
				If (pDetailsCode'="")||(pDetailsDescription'="") {
					Do pStream.Write(tIndent(3)_"<coding>"_tLineTerm)
					If pDetailsCode'="" Do pStream.Write(tIndent(4)_"<code value="""_pDetailsCode_"""/>"_tLineTerm)
					If pDetailsDescription'="" Do pStream.Write(tIndent(4)_"<display value="""_pDetailsDescription_"""/>"_tLineTerm)
					Do pStream.Write(tIndent(3)_"</coding>"_tLineTerm)
				}
				If pDetailsText'="" Do pStream.Write(tIndent(3)_"<text value="""_pDetailsText_"""/>"_tLineTerm)
				Do pStream.Write(tIndent(2)_"</details>"_tLineTerm)
			}
			If pDiagnostics'="" Do pStream.Write(tIndent(2)_"<diagnostics value="""_pDiagnostics_"""/>"_tLineTerm)
			If pLocation'="" Do pStream.Write(tIndent(2)_"<location value="""_pLocation_"""/>"_tLineTerm)
			If pExpression'="" Do pStream.Write(tIndent(2)_"<expression value="""_pExpression_"""/>"_tLineTerm)
			Do pStream.Write(tIndent(1)_"</issue>"_tLineTerm)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Deprecated.
ClassMethod CreateOperationOutcomeObject(pSeverity As %String, pCode As %String, pText As %String, Output pOperationOutcome) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pOperationOutcome = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome).%New()
  		Set tIssue = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome.Issue).%New()
  		Set tSC = tIssue.SetSeverity(pSeverity) Quit:$$$ISERR(tSC)
  		Set tSC = tIssue.SetDetails(,,,pText) Quit:$$$ISERR(tSC)
  		Set tSC = tIssue.SetDiagnostics(pText) Quit:$$$ISERR(tSC)
  		Set tSC = tIssue.SetCode(pCode) Quit:$$$ISERR(tSC)
  		Set tSC = pOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
  		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "Error creating OperationOutcome object for "_$get(pSeverity,"blank severity")_" '"_$get(pText,"blank text")_"' - "_$system.Status.GetErrorText(tSC))
	
	Quit tSC
}

/// Deprecated. Use ValidateResourceTypeFHIR() instead.
ClassMethod GetValidResourceTypes() As %String
{
	Quit ",Account,AllergyIntolerance,Appointment,AppointmentResponse,AuditEvent,Basic,Binary,BodySite,Bundle,CarePlan,Claim,ClaimResponse,ClinicalImpression,Communication,CommunicationRequest,Composition,ConceptMap,Condition,Conformance,Contract,Coverage,DataElement,DetectedIssue,Device,DeviceComponent,DeviceMetric,DeviceUseRequest,DeviceUseStatement,DiagnosticOrder,DiagnosticReport,DocumentManifest,DocumentReference,EligibilityRequest,EligibilityResponse,Encounter,EnrollmentRequest,EnrollmentResponse,EpisodeOfCare,ExplanationOfBenefit,FamilyMemberHistory,Flag,Goal,Group,HealthcareService,ImagingObjectSelection,ImagingStudy,Immunization,ImmunizationRecommendation,ImplementationGuide,List,Location,Media,Medication,MedicationAdministration,MedicationDispense,MedicationOrder,MedicationStatement,MessageHeader,NamingSystem,NutritionOrder,Observation,OperationDefinition,OperationOutcome,Order,OrderResponse,Organization,Parameters,Patient,PaymentNotice,PaymentReconciliation,Person,Practitioner,Procedure,ProcedureRequest,ProcessRequest,ProcessResponse,Provenance,Questionnaire,QuestionnaireResponse,ReferralRequest,RelatedPerson,RiskAssessment,Schedule,SearchParameter,Slot,Specimen,StructureDefinition,Subscription,Substance,SupplyDelivery,SupplyRequest,TestScript,ValueSet,VisionPrescription,"
}

/// Deprecated. Use ValidateResourceTypeFHIR() instead.
ClassMethod IsValidResourceType(pType As %String) As %Boolean
{
	Quit (..GetValidResourceTypes()[(","_pType_","))
}

/// API
/// Validate resource id as per http://hl7.org/fhir/datatypes.html#id
ClassMethod IsValidResourceId(pResourceId As %String) As %Boolean
{
	If pResourceId="" Quit 1
	If $Translate(pResourceId,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.")'="" Quit 0
	If $Length(pResourceId)>64 Quit 0
	Quit 1
}

ClassMethod GetValidFormats(pMode As %String, ByRef pFormats As %String)
{
	Set tMode = $ZConvert($Translate(pMode,"-"), "L")
	
	#; contenttype = Input is a value for an HTTP Content-Type header.
	#; accept      = Input is a value for an HTTP Accept header.
	#; parameter   = Input is a value for a URL _format parameter.
	
	If '((tMode="contenttype")||(tMode="accept")||(tMode="parameter")) Quit
	
	Set tFormalXMLMIMEType = "application/fhir+xml"
	Set tFormalJSONMIMEType = "application/fhir+json"
	
	Set pFormats("application/xml+fhir") = tFormalXMLMIMEType
	Set pFormats("application/fhir+xml") = tFormalXMLMIMEType
	Set pFormats("application/json+fhir") = tFormalJSONMIMEType
	Set pFormats("application/fhir+json") = tFormalJSONMIMEType
	If tMode="contenttype" Set pFormats("application/x-www-form-urlencoded") = "application/x-www-form-urlencoded"
	If tMode="parameter" Set pFormats("xml") = tFormalXMLMIMEType
	If tMode="parameter" Set pFormats("json") = tFormalJSONMIMEType
	If tMode="parameter" Set pFormats("text/xml") = tFormalXMLMIMEType
	If tMode="parameter" Set pFormats("application/xml") = tFormalXMLMIMEType
	If tMode="parameter" Set pFormats("application/json") = tFormalJSONMIMEType
	
	Quit
}

/// This method returns an array of valid formats/mime types. Array format is:<br>
/// pFormats(context, value) = formal mime type<br>
/// Where context is "Accept" for accept header, "ContentType" for Content-Type header,
/// and "Parameter" for request URL parameter.
ClassMethod GetAllValidFormats(ByRef pFormats As %String)
{
	// ContentType = Input is a value for an HTTP Content-Type header.
	// Accept      = Input is a value for an HTTP Accept header.
	// Parameter   = Input is a value for a URL _format parameter.
	
	Set tFormalXMLMimeType = "application/fhir+xml"
	Set tFormalJSONMimeType = "application/fhir+json"
	
	For i = "Accept", "ContentType", "Parameter" {
		Set pFormats(i, "application/xml+fhir") = tFormalXMLMimeType
		Set pFormats(i, "application/fhir+xml") = tFormalXMLMimeType
		Set pFormats(i, "application/json+fhir") = tFormalJSONMimeType
		Set pFormats(i, "application/fhir+json") = tFormalJSONMimeType
		Set pFormats(i, "application/xml") = tFormalXMLMimeType
		Set pFormats(i, "application/json") = tFormalJSONMimeType
	}
	
	Set pFormats("Accept", "text/json") = tFormalJSONMimeType

	Set pFormats("ContentType", "application/x-www-form-urlencoded") = "application/x-www-form-urlencoded"
	
	Set pFormats("Parameter", "xml") = tFormalXMLMimeType
	Set pFormats("Parameter", "json") = tFormalJSONMimeType
	Set pFormats("Parameter", "text/xml") = tFormalXMLMimeType
	
	Set pFormats("Patch", "application/json-patch+json") = "application/json-patch+json"
	Set pFormats("Patch", "application/xml-patch+xml") = "application/xml-patch+xml"
	Set pFormats("Patch", "application/fhir+xml") = tFormalXMLMimeType
	Set pFormats("Patch", "application/fhir+json") = tFormalJSONMimeType
	
	Quit
}

ClassMethod GetSDATypeList(Output pSDATypeList As %ListOfDataTypes, pVerbose = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pSDATypeList = ##class(%ListOfDataTypes).%New()
		
		Set tCount = 0
		
		Do $system.OBJ.GetPackageList(.tClasses, "HS.SDA3")

		Write:pVerbose !,"Loading SDA Types"
		
		Set tClass = ""
		For {
			Set tClass = $Order(tClasses(tClass))
			If tClass="" Quit
			Set tObj = ##class(%Dictionary.ClassDefinition).%OpenId(tClass)
			If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError, "Could not find class definition for "_tClass) Quit
			If tObj.Super["HS.SDA3.SuperClass" Do pSDATypeList.Insert(tClass) Set tCount = tCount + 1
		}
		
		Write:pVerbose !,"Loaded "_pSDATypeList.Count()_" SDA Types"
			
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// API
/// V2ToFHIRDateTime converts HL7 V2 TS (aka DTM) format YYYYDDMMHHMMSS to FHIR DateTime format.
/// <br>Input Parameters:
/// <br>- pTS         : HL7v2 time stamp.
/// <br>- pIsUTC      : 0 = pTS is local time, 1 = pTS is UTC time.
/// <br>- pCvtToLocal : 0 = Do not convert output to local time zone, 1 = Convert output to local time zone.
ClassMethod V2ToFHIRDateTime(pTS As %String, pIsUTC As %Boolean = 0, pCvtToLocal As %Boolean = 0) As %String
{
	i (pTS="")||(pTS="""""") q ""
	i pTS'?1n.n q pTS
	s tLen = $l(pTS)
	i tLen<14 {
		i (tLen<4)||(tLen=5)||(tLen=7)||(tLen=9)||(tLen=11)||(tLen=13) q pTS
		i pTS?4n q pTS
		s tMM = +$e(pTS,5,6)
		s tDD = +$e(pTS,7,8)
		i (tMM<1)||(tMM>12) q pTS
		i pTS?6n q $e(pTS,1,4)_"-"_$e(pTS,5,6)
		i (tDD<1)||(tDD>31) q pTS
		i pTS?8n q $e(pTS,1,4)_"-"_$e(pTS,5,6)_"-"_$e(pTS,7,8)
		i pTS?10n s pTS = pTS_"0000"
		i pTS?12n s pTS = pTS_"00"
	}
	s tTimeStamp = $e(pTS,1,4)_"-"_$e(pTS,5,6)_"-"_$e(pTS,7,8)_"T"_$e(pTS,9,10)_":"_$e(pTS,11,12)_":"_$e(pTS,13,14)
	s tPrecision = 0
	i tLen>14 s tTimeStamp = tTimeStamp_"."_$e(pTS,15,*) s tPrecision = $l($e(pTS,15,*))
	s tDH = $ZDateTimeH(tTimeStamp,3,1,,,,,,,"error")
	i tDH="error" q pTS
	s tLocal = $ZDateTime(tDH,3,5,tPrecision)
	s pIsUTC=+pIsUTC,pCvtToLocal=+pCvtToLocal
	// If input is not UTC then return output in local time zone.
	i pIsUTC=0 q tLocal
	// If input is UTC and want to leave it in UTC then just append Zulu time zone.
	i pCvtToLocal=0 q tTimeStamp_"Z"
	// Otherwise, convert UTC time to local time zone time.
	i $e(tLocal,*-4,*)="00:00" q tLocal
	s tHH = $e(tLocal,*-4,*-3),tMM = $e(tLocal,*-1,*)
	s tPM = $e(tLocal,*-5)
	s tSecsOffset = ((+tHH)*3600)+((+tMM)*60)
	s tDHDay = $p(tDH,",",1) s tDHSecs = $p(tDH,",",2)
	i tPM="-" {
		i tSecsOffset>tDHSecs {
			s tDHDay = tDHDay - 1
			s tDHSecs = 86400-(tSecsOffset-tDHSecs)
		} else {
			s tDHSecs = tDHSecs - tSecsOffset
		}
	} else {
		i (tDHSecs+tSecsOffset)>86399 {
			s tDHDay = tDHDay + 1
			s tDHSecs = (tDHSecs+tSecsOffset)-86400
		} else {
			s tDHSecs = tDHSecs + tSecsOffset
		}
	}
	s tNewDH = tDHDay_","_tDHSecs
	q $ZDateTime(tNewDH,3,5,tPrecision)
}

/// API
/// V2ToFHIRInstant converts HL7 V2 TS (aka DTM) format YYYYDDMMHHMMSS to FHIR Instant format.
ClassMethod V2ToFHIRInstant(pTS As %String, pIsUTC As %Boolean = 0, pCvtToLocal As %Boolean = 0) As %String
{
	i (pTS'?1n.n)||($l(pTS)<8) q pTS
	i pTS?8n s pTS = pTS_"000000"
	i pTS?10n s pTS = pTS_"0000"
	i pTS?12n s pTS = pTS_"00"
	q ..V2ToFHIRDateTime(pTS, pIsUTC, pCvtToLocal)
}

/// API
/// ConvertToUTC takes a date time value and converts it to UTC time.
/// Expected input format is YYYY-MM-DDTHH:MM:SS[.ssss][(+/-)HH:MM]/[Z].
/// A date-only input value is returned unchanged.
/// A date time input value with the "Z" time zone appended is returned unchanged.
ClassMethod ConvertToUTC(pDateTime As %String) As %String
{
	// 24*60*60 = 86400
	#dim tSecondsPerDay = 86400
	
	set tDate = $P(pDateTime,"T")
	set tTimeWithOffset = $P(pDateTime,"T",2)
	// If no time part, no need to convert, just quit the original value
	if (tTimeWithOffset="") { quit pDateTime }
	// If already in UTC time, no need to convert, just quit the original value
	if ($E(tTimeWithOffset,*) = "Z") { quit pDateTime }
	
	
	if (tTimeWithOffset [ "-") { set tOffsetSign = "-" }
	elseif (tTimeWithOffset [ "+") { set tOffsetSign = "+" }
	else { set tOffsetSign = "" }
	
	
	if (tOffsetSign'="") {
		// compute offset in seconds
		set tOffset = $P(tTimeWithOffset,tOffsetSign,2)
		set tOffsetHrs = $P(tOffset,":")
		set tOffsetMins = $P(tOffset,":",2)
		set tOffsetInSeconds = (3600*tOffsetHrs) + (60*tOffsetMins)
		// get date/time in $H format
		set tTime = $P(tTimeWithOffset,tOffsetSign)
		set tDateTimeH = $ZDTH(tDate_"T"_tTime,3,1)
		set tDateH = $P(tDateTimeH,",")
		set tTimeH = $P(tDateTimeH,",",2)
		// UTC time = timestamp value (+/-) offset
		// might have to increment or decrement the date
		set tUTCDateH = tDateH
		if (tOffsetSign = "-") {
			set tUTCTimeH = tTimeH + tOffsetInSeconds
			if (tUTCTimeH >= tSecondsPerDay) {
				set tUTCDateH = tUTCDateH+1
				set tUTCTimeH = tUTCTimeH-tSecondsPerDay
			}
		}
		else { 
			set tUTCTimeH = tTimeH - tOffsetInSeconds
			if (tUTCTimeH < 0) {
				set tUTCDateH = tUTCDateH-1
				set tUTCTimeH = tUTCTimeH+tSecondsPerDay
			}
		}

		quit $TR($ZDT(tUTCDateH_","_tUTCTimeH,3,1)," ","T")_"Z"	
	}
	// no offset - assume local time
	else {
		// convert to $H format
		set tDateTimeH = $ZDTH(pDateTime,3,1)
		// convert to UTC time, $H format
		set tUTCDateTimeH = $ZDT(tDateTimeH,-3)
		quit $TR($ZDT(tUTCDateTimeH,3,1)," ","T")_"Z"
	}
	
	
	
	quit ""
}

/// Compares the current audience against the aud value(s), if any, in the access
/// token. This comparison is trailing-slash-insensitive and case-insensitive.
ClassMethod ValidateAudience(pJWTObject As %Library.DynamicAbstractObject) As %Boolean
{
	Set tMatched = 1
	
	// Validate audience
	// Compare the current audience against the aud value(s), if any, in the access
	// token. This compare is trailing-slash-insensitive and case-insensitive.
	Set tJWTAud = pJWTObject.aud
	If tJWTAud'="" {
		Set tCurrentAud = ""
		Set tCurrentAud = tCurrentAud_$Select(%request.Secure:"https://",1:"http://")
		Set tCurrentAud = tCurrentAud_%request.CgiEnvs("HTTP_HOST")
		Set tCurrentAud = tCurrentAud_%request.Application
		If $Extract(tCurrentAud, *)="/" Set tCurrentAud = $Extract(tCurrentAud, 1, *-1)
		Set tCurrentAud = $ZConvert(tCurrentAud, "L")
		Set tMatched = 0
		Set JWTAuds = 0
		If '$IsObject(tJWTAud) {
			// Compare single audience from JWT
			If $Extract(tJWTAud, *)="/" Set tJWTAud = $Extract(tJWTAud, 1, *-1)
			Set tJWTAud = $ZConvert(tJWTAud, "L")
			If tJWTAud=tCurrentAud Set tMatched = 1
			Set tJWTAuds($i(tJWTAuds)) = tJWTAud
		} Else {
			// Compare multiple audience from JWT
			Set tIterator = tJWTAud.%GetIterator()
			While tIterator.%GetNext(.tKey, .tJWTAudN) {
				If $Extract(tJWTAudN, *)="/" Set tJWTAudN = $Extract(tJWTAudN, 1, *-1)
				Set tJWTAudN = $ZConvert(tJWTAudN, "L")
				If tJWTAudN=tCurrentAud Set tMatched = 1
				Set tJWTAuds($i(tJWTAuds)) = tJWTAudN
			}
		}
	}
	Quit tMatched
}

/// API
/// XMLToJSON takes a FHIR XML stream object or string as input, and returns a FHIR JSON stream.
/// This method requires a class package to be designated as the root of the data model classes
/// to use during this transform. Indent character(s) and line terminator character(s) for the
/// JSON output are optional.<br>
/// <br>
/// Input:<br>
/// <li>pXMLStreamOrString  : (required) FHIR XML stream object or string.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pIndentChars        : (optional) Indent character(s) to use for each line in the XML output.
/// <li>pLineTerminator     : (optional) Line terminator character(s) to use for the XML output.
/// <br><br>
/// Output:<br>
/// <li>pJSONStream         : FHIR JSON stream. If this object is not passed in as input then this
///                           method initializes it as %Stream.TmpCharacter.
ClassMethod XMLToJSON(pXMLStreamOrString, Output pJSONStream As %Stream.Object, pResourceSchemaRoot As %String, pIndentChars As %String = "", pLineTerminator As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If ($Get(pXMLStreamOrString)="")||(($IsObject(pXMLStreamOrString))&&('pXMLStreamOrString.%IsA("%Stream.Object"))) {
			Set tSC = $$$ERROR($$$GeneralError,"XML input not specified - must be a string or a %Stream.Object")
			Quit
		}
		
		If '$IsObject(pXMLStreamOrString) {
			Set tXMLStream = ##class(%Stream.TmpCharacter).%New()
			Do tXMLStream.Write(pXMLStreamOrString)
			Do tXMLStream.Rewind()
		} Else {
			Set tXMLStream = pXMLStreamOrString
		}
		
		Set tSC = ..CreateXMLDocument(tXMLStream, .tXMLDocument)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..XMLDocumentToJSON(.tXMLDocument, .pJSONStream, pResourceSchemaRoot, pIndentChars, pLineTerminator)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// XMLDocumentToJSON takes an %XML.Document object representation of a FHIR XML payload as
/// input, and returns a FHIR JSON stream.  This method needs a class package to be
/// designated as the root of the data model classes to use during this transform. Indent
/// character(s) and line terminator character(s) for the XML output are optional.<br>
/// <br>
/// Input:<br>
/// <li>pXMLDocument        : (required) %XML.Document object representation of the FHIR XML.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pIndentChars        : (optional) Indent character(s) to use for each line in the XML output.
/// <li>pLineTerminator     : (optional) Line terminator character(s) to use for the XML output.<br>
/// <br><br>
/// Output:<br>
/// <li>pJSONStream         : FHIR JSON Stream. If this object is not passed in as input then this method
///                           initializes it as a %Stream.GlobalCharacter.
ClassMethod XMLDocumentToJSON(pXMLDocument As %XML.Document, ByRef pJSONStream As %Stream.Object, pResourceSchemaRoot As %String, pIndentChars As %String = "", pLineTerminator As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pResourceSchemaRoot="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR resource schema not specified")
			Quit
		}
		
		For i = 0:1:25 Set $Piece(%indent(i),pIndentChars,i+1)=""
		
		Set %lineterm = pLineTerminator
		
		Set %buffer = ""
		
		Set %maxbuffer = $$$MaxLocalLength
		
		#dim tNode As %XML.Node
		
		If ($Get(pXMLDocument)="")||('$IsObject(pXMLDocument))||('pXMLDocument.%IsA("%XML.Document")) {
			Set tSC = $$$ERROR($$$GeneralError,"XML input must be an %XML.Document object")
			Quit
		}
		
		If '$IsObject($Get(pJSONStream)) Set pJSONStream = ##class(%Stream.GlobalCharacter).%New()
		
		Set tNode = pXMLDocument.GetDocumentElement()
		
		Set tTopResourceName = ""
		
		If tNode.NodeType=$$$xmlELEMENTNODE {
			If tNode.Namespace'="http://hl7.org/fhir" {
				Set tSC = $$$ERROR($$$GeneralError,"FHIR namespace not found")
				Quit
			}
			Set tTopResourceName = tNode.LocalName
			Set tTopResourceSchemaName = pResourceSchemaRoot_"."_tTopResourceName
		}
		If tTopResourceName="" {
			Set tSC = $$$ERROR($$$GeneralError,"Top level FHIR resource name not found")
			Quit
		}
		
		Set tLevel = 1
		Set tString = ""
		Set tString = tString_"{"_%lineterm_%indent(tLevel)
		Set tString = tString_"""resourceType"":"""_tTopResourceName_""","_%lineterm_%indent(tLevel)
		Do Write
		
		Set tSC = ..XMLDocumentToJSON2(tNode, .pJSONStream, tTopResourceSchemaName, tLevel)
		
		Set tString = %lineterm_"}" Do Write
		
		If %buffer'="" Do pJSONStream.Write(%buffer)
		
		Do pJSONStream.Rewind()
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Kill %indent
	Kill %lineterm
	Kill %buffer
	Kill %maxbuffer
	
	Quit tSC
Write
	If ($Length(%buffer)+$Length(tString))>%maxbuffer Do pJSONStream.Write(%buffer) Set %buffer = ""
	Set %buffer = %buffer_tString
	Set tString = ""
	Quit
}

ClassMethod XMLDocumentToJSON2(pNode As %XML.Node, ByRef pJSONStream, pHSFHIRClassName As %String, pLevel As %Integer) [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(pHSFHIRClassName))=0 Do ..GetPropInfo(pHSFHIRClassName)
		
		Set tString = ""
		
		Set tPrevPropName = ""
		Set tPrevPropType = ""
		Set tPrevPropColl = ""
		
		// url attribute on this object means this is an extension object.
		If pNode.AttributeDefined("url") {
			Set tString = tString_"""url"":"""_pNode.GetAttributeValue("url")_""""
			Set tString = tString_","_%lineterm_%indent(pLevel+1)
			Do Write
		}
		
		// Save the current node id so that we may re-set back to it before returning.
		Set tSaveNodeId = pNode.NodeId
		// Try to move to the first child node, quit if no child nodes.
		If 'pNode.MoveToFirstChild(1) Quit
				
		For {
			Set tPropName = pNode.LocalName
			If '$Data(%propsByName(pHSFHIRClassName,tPropName)) {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid property '"_tPropName_"' for class "_pHSFHIRClassName)
				Quit
			}
			Set tPropType = %propsByName(pHSFHIRClassName,tPropName,"Type")
			Set tPropColl = %propsByName(pHSFHIRClassName,tPropName,"Collection")
			If $Data(%propsByName(tPropType))=0 Do ..GetPropInfo(tPropType)
			Set tHasChild = pNode.HasChildNodes(1)
			Set tNumAtt = pNode.GetNumberAttributes()
			If (tPropName="div")&&($Extract(pHSFHIRClassName,*-8,*)="Narrative") {
				If (pNode.Namespace="")||(pNode.Namespace="http://hl7.org/fhir") {
					Set pNode.Namespace = "http://www.w3.org/1999/xhtml"
				}
				If pNode.Namespace="http://www.w3.org/1999/xhtml" {
					// Gather div as an xhtml string with all whitespace preserved.
					Set tString = tString_","_%lineterm_%indent(pLevel)_"""div"":" Do Write
					Set tSC = ..XMLDocumentDivString(pNode, 1, .tString)
					If $$$ISERR(tSC) Quit
					Set tString = $ZStrip(tString,"<>W")
					Set tString = """"_$ZConvert(tString,"O","JSON")_""""
					Do Write
					// Try to move to the next sibling on this level, quit if no more siblings.
					If 'pNode.MoveToNextSibling(1) Quit
					Continue
				} Else {
					Set tSC = $$$ERROR($$$GeneralError,"Invalid namespace on Narrative div property")
					Quit
				}
			}
			If tPropName'=tPrevPropName {
				// Starting a new property on this level.
				If tPrevPropName'="" {
					// Finish up the previous property (if any) on this level.
					// Write out closing curly brace and square bracket, and
					// write id and/or extensions if any.
					If ('%propsByName(tPrevPropType,"Datatype"))&&($Extract(tPrevPropType,*-16,*)'="ResourceContainer") {
						Set pLevel = pLevel - 1
						Set tString = tString_%lineterm_%indent(pLevel)_"}"
					}
					If tPrevPropColl {
						Set pLevel = pLevel - 1
						Set tString = tString_%lineterm_%indent(pLevel)_"]"
					}
					Set tString = tString_","_%lineterm_%indent(pLevel)
					Do Write
					// If the previous property on this level had ids and/or
					// extensions, then write them now.
					If ($Data(tExtNodes))||($Data(tIds)) {
						Set tPrevPropType = %propsByName(pHSFHIRClassName, tPrevPropName, "Type")
						If $Data(%propsByName(tPrevPropType))=0 Do ..GetPropInfo(tPrevPropType)
						Set tExtensionSchema = %propsByName(tPrevPropType, "extension", "Type")
						Set tSC = ..XMLDocumentToJSONExt(pNode, .pJSONStream, tExtensionSchema, tPrevPropName, tPrevPropColl, tPrevCollCount, pLevel, .tIds, .tExtNodes)
						If $$$ISERR(tSC) Quit
						Kill tIds,tExtNodes
						Set tString = tString_","_%lineterm_%indent(pLevel)
						Do Write
					}
				}
				Set tCollCount = 1
				If $Extract(pHSFHIRClassName,*-16,*)'="ResourceContainer" {
					Set tString = tString_""""_tPropName_""":"
				}
				If tPropColl {
					Set pLevel = pLevel + 1
					Set tString = tString_"["_%lineterm_%indent(pLevel)
				}
				If ('%propsByName(tPropType,"Datatype"))&&($Extract(tPropType,*-16,*)'="ResourceContainer") {
					Set pLevel = pLevel + 1
					Set tString = tString_"{"_%lineterm_%indent(pLevel)
				}
				If $Extract(pHSFHIRClassName,*-16,*)="ResourceContainer" {
					Set tString = tString_"""resourceType"":"""_tPropName_""","_%lineterm_%indent(pLevel)
				}
				Do Write
			} Else {
				// The current property name is the same as the previous property name
				// on this level. This implies that this is the 2nd through Nth member
				// in a collection.
				If 'tPropColl {
					Set tSC = $$$ERROR($$$GeneralError, "Invalid multiple values for non-collection property '"_tPropName_"' on class "_pHSFHIRClassName)
					Quit
				}
				Set tCollCount = tCollCount + 1
				If ('%propsByName(tPropType,"Datatype"))&&($Extract(tPropType,*-16,*)'="ResourceContainer") {
					Set tString = tString_%lineterm_%indent(pLevel-1)_"}"
					Set tString = tString_","_%lineterm_%indent(pLevel-1)
					Set tString = tString_"{"_%lineterm_%indent(pLevel)
				} Else {
					Set tString = tString_","_%lineterm_%indent(pLevel)
				}
				Do Write
			}
			
			If ('%propsByName(tPropType,"Datatype"))&&(pNode.HasChildNodes())&&(tPropType'="%String") {
				// If the property is a complex object then parse it now.
				Set tSC = ..XMLDocumentToJSON2(pNode, .pJSONStream, tPropType, pLevel)
				If $$$ISERR(tSC) Quit
			} ElseIf (%propsByName(tPropType,"Datatype"))&&(pNode.HasChildNodes()) {
				// If this property is a datatype, the only children it can have is extension.
				If ('pNode.AttributeDefined("value")) {
					Set tString = tString_"null"
					Do Write
				}
				// Gather the extension element node ids. They will be used later when XMLDocumentToJSONExt is called.
				Set tSaveDatatypeNodeId = pNode.NodeId
				Set tExtBoolean = pNode.MoveToFirstChild(1)
				Set tExtNodes(tCollCount,$i(tExtNodes(tCollCount))) = pNode.NodeId
				For {
					If 'pNode.MoveToNextSibling(1) Quit
					Set tExtNodes(tCollCount,$i(tExtNodes(tCollCount))) = pNode.NodeId
				}
				Set pNode.NodeId = tSaveDatatypeNodeId
			}
			If tNumAtt>0 {
				Set tAttName = ""
				For {
					Set tAttName = pNode.NextAttributeName(tAttName)
					If tAttName="" Quit
					Set tValue = pNode.GetAttributeValue(tAttName)
					Set tValue = $ZConvert(tValue,"O","JSON")
					If tAttName="value" {
						If '$Get(%propsByName(tPropType,"value","NotJSONString")) {
							Set tValue = """"_tValue_""""
						} ElseIf $Extract(tValue)="." {
							Set tValue = """"_tValue_""""
						}
						Set tString = tString_tValue Do Write
					} ElseIf tAttName="id" {
						// Gather the ids. They will be used later when XMLDocumentToJSONExt is called.
						Set tIds(tCollCount) = tValue
					}
				}
			}
			Set tPrevPropName = tPropName
			Set tPrevPropType = tPropType
			Set tPrevPropColl = tPropColl
			Set tPrevCollCount = tCollCount
			
			// Try to move to the next sibling on this level, quit if no more siblings.
			If 'pNode.MoveToNextSibling(1) Quit
		}
		If ('%propsByName(tPropType,"Datatype"))&&($Extract(tPropType,*-16,*)'="ResourceContainer")&&(tPropType'="%String") {
			Set pLevel = pLevel - 1
			Set tString = tString_%lineterm_%indent(pLevel)_"}"
		}
		If tPropColl {
			Set pLevel = pLevel - 1
			Set tString = tString_%lineterm_%indent(pLevel)_"]"
		}
		Do Write
		
		If ($Data(tExtNodes))||($Data(tIds)) {
			Set tString = tString_","_%lineterm_%indent(pLevel) Do Write
			Set tPrevPropType = %propsByName(pHSFHIRClassName, tPrevPropName, "Type")
			If $Data(%propsByName(tPrevPropType))=0 Do ..GetPropInfo(tPrevPropType)
			Set tExtensionSchema = %propsByName(tPrevPropType, "extension", "Type")
			Set tSC = ..XMLDocumentToJSONExt(pNode, .pJSONStream, tExtensionSchema, tPrevPropName, tPrevPropColl, tPrevCollCount, pLevel, .tIds, .tExtNodes)
			If $$$ISERR(tSC) Quit
			Kill tIds,tExtNodes
		}
		
		Set pNode.NodeId = tSaveNodeId
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC

Write
	If ($Length(%buffer)+$Length(tString))>%maxbuffer Do pJSONStream.Write(%buffer) Set %buffer = ""
	Set %buffer = %buffer_tString
	Set tString = ""
	Quit
}

/// XMLDocumentDivString parses the div of a FHIR XML resource and builds and returns
/// a string that represents the div xhtml with whitespace preserved.
ClassMethod XMLDocumentDivString(pNode As %XML.Node, pDivLevel As %Integer, ByRef pDivString As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		For {
			Set tNodeType = pNode.NodeType
			
			If tNodeType=$$$xmlELEMENTNODE {
				Set tPropName = pNode.LocalName
				Set pDivString = pDivString_"<"_tPropName
				Set tNumAtt = pNode.GetNumberAttributes()
				Set tHasChild = pNode.HasChildNodes()
				If tNumAtt>0 {
					Set tAttName = ""
					For {
						Set tAttName = pNode.NextAttributeName(tAttName)
						If tAttName="" Quit
						Set tAttValue = pNode.GetAttributeValue(tAttName)
						Set pDivString = pDivString_" "_tAttName_"="""_$ZConvert(tAttValue,"O","HTML")_""""
					}
				}
				If (pDivLevel=1)&&(pDivString'[" xmlns="""_pNode.Namespace_"""") Set pDivString = pDivString_" xmlns="""_pNode.Namespace_""""
				If tHasChild {
					Set pDivString = pDivString_">"
					Set tSaveNodeId = pNode.NodeId
					Set tBoolean = pNode.MoveToFirstChild()
					Set tSC = ..XMLDocumentDivString(pNode, pDivLevel+1, .pDivString)
					If $$$ISERR(tSC) Quit
					Set pNode.NodeId = tSaveNodeId
					Set pDivString = pDivString_"</"_tPropName_">"
					Set tBoolean = pNode.MoveToNextSibling()
				} Else {
					Set pDivString = pDivString_">"
					Set tBoolean = pNode.MoveToNextSibling()
				}
				If tBoolean=0 Quit
			} Else {
				// is $$$xmlTEXTNODE or $$$xmlWHITESPACENODE
				Set pDivString = pDivString_pNode.NodeData
				If 'pNode.MoveToNextSibling() Quit
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// XMLDocumentToJSONExt writes to the JSON output the ids and/or extensions that have
/// been gathered for a given property.
ClassMethod XMLDocumentToJSONExt(pNode As %XML.Node, pJSONStream, pExtSchema, pPropName, pPropColl, pCollCount, pLevel, ByRef pIds, ByRef pExtNodes) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tSaveNodeId = pNode.NodeId
		
		Set tString = ""
		
		If $Data(%propsByName(pExtSchema))=0 Do ..GetPropInfo(pExtSchema)
		
		Set tString = tString_"""_"_pPropName_""":" Do Write
		
		If 'pPropColl {
			Set tCollPos = 1
			Do OneExt
			If $$$ISERR(tSC) Quit
		} Else {
			Set tString = tString_"["_%lineterm_%indent(pLevel+1) Do Write
			For tCollPos = 1:1:pCollCount {
				If tCollPos>1 Set tString = tString_","_%lineterm_%indent(pLevel+1) Do Write
				Set pLevel = pLevel + 1
				Do OneExt
				If $$$ISERR(tSC) Quit
				Set pLevel = pLevel - 1
			}
			Set tString = tString_%lineterm_%indent(pLevel)_"]" Do Write
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Set pNode.NodeId = tSaveNodeId
	
	Quit tSC
	
OneExt
	If ('$Data(pIds(tCollPos)))&&('$Data(pExtNodes(tCollPos))) {
		Set tString = tString_"null" Do Write
	} Else {
		Set tString = tString_"{"_%lineterm_%indent(pLevel+1)
		If $Data(pIds(tCollPos)) Set tString = tString_"""id"":"""_pIds(tCollPos)_""""
		If $Data(pExtNodes(tCollPos)) {
			If $Data(pIds(tCollPos)) Set tString = tString_","_%lineterm_%indent(pLevel+1)
			Set tString = tString_"""extension"":["_%lineterm_%indent(pLevel+2)
			For i = 1:1:pExtNodes(tCollPos) {
				Set pNode.NodeId = pExtNodes(tCollPos,i)
				If i>1 Set tString = tString_","_%lineterm_%indent(pLevel+3)
				Set tString = tString_"{"_%lineterm_%indent(pLevel+3)
				Do Write
				Set tSC = ..XMLDocumentToJSON2(pNode, .pJSONStream, pExtSchema, pLevel+2)
				If $$$ISERR(tSC) Quit
				Set tString = tString_%lineterm_%indent(pLevel+2)_"}"
				Do Write
			}
			Set tString = tString_%lineterm_%indent(pLevel+1)_"]"
		}
		Set tString = tString_%lineterm_%indent(pLevel)_"}"
		Do Write
	}
	Quit
	
Write
	If ($Length(%buffer)+$Length(tString))>%maxbuffer Do pJSONStream.Write(%buffer) Set %buffer = ""
	Set %buffer = %buffer_tString
	Set tString = ""
	Quit
}

/// Get the definition information for a given property. This is currently based on class definitions.
ClassMethod GetPropInfo(pHSFHIRClass As %String) [ Internal ]
{
	// Build %propsByName for the specified class name.
	//
	// %propsByName(classname, propertyname, "Type"): property type
	// %propsByName(classname, propertyname, "NotJSONString"): 0 = property value requires quotes when emitted as JSON, 1 = do not include quotes
	// %propsByName(classname, propertyname, "Collection"): 0 = property is not a collection, 1 = is a collection
	// %propsByName(classname, propertyname, "Required"): 0 = property is not required, 1 = is required
	// %propsByName(classname, "Datatype"): 0 = class is not a datatype, 1 = is a datatype
	// where "Datatype" means this class has only value, id, and extension properties.
		
	Set tPropName = "@"
	For {
		Set tPropName = $$$comMemberNext(pHSFHIRClass, $$$cCLASSproperty, tPropName)
		If tPropName="" Quit
		Set tPropOrigin = $$$comMemberKeyGet(pHSFHIRClass, $$$cCLASSproperty, tPropName, $$$cPROPorigin)
		Set %propsByName(pHSFHIRClass, tPropName, "Type") = $$$defMemberKeyGet(tPropOrigin, $$$cCLASSproperty, tPropName, $$$cPROPtype)
		Set tTempType = $Piece(%propsByName(pHSFHIRClass, tPropName, "Type"),".",*)
		If (tTempType="BooleanPrimitive")||(tTempType="DecimalPrimitive")||(tTempType="IntegerPrimitive")||(tTempType="PositiveIntPrimitive")||(tTempType="UnsignedIntPrimitive") {
			Set %propsByName(pHSFHIRClass, tPropName, "NotJSONString") = 1
		} Else {
			Set %propsByName(pHSFHIRClass, tPropName, "NotJSONString") = 0
		}
		Set %propsByName(pHSFHIRClass, tPropName, "Collection") = ($$$defMemberKeyGet(tPropOrigin, $$$cCLASSproperty, tPropName, $$$cPROPcollection)'="")
		Set %propsByName(pHSFHIRClass, tPropName, "Required") = $$$defMemberKeyGet(tPropOrigin, $$$cCLASSproperty, tPropName, $$$cPROPrequired)
	}
	Set tPropName = ""
	Set tPropCount = 0
	Set tLastProp = ""
	For {
		Set tPropName = $$$defMemberNext(pHSFHIRClass, $$$cCLASSproperty, tPropName)
		If tPropName="" Quit
		If $i(tPropCount)>1 Quit
		Set tLastProp = tPropName
	}
	Set %propsByName(pHSFHIRClass, "Datatype") = ((tPropCount=1)&&(tLastProp="value"))
	
	Quit
}

/// API
/// XMLDocumentToDynamicObject takes an %XML.Document object representation of a FHIR XML
/// payload as input, and returns a %DynamicObject.  This method needs a class package to
/// be designated as the root of the data model classes to use during this transform.<br>
/// <br>
/// Input:<br>
/// <li>pXMLDocument        : (required) %XML.Document object representation of the FHIR XML.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br><br>
/// Output:<br>
/// <li>pDynObj             : %DynamicObject representation of the FHIR payload.
ClassMethod XMLDocumentToDynamicObject(pXMLDocument As %XML.Document, pResourceSchemaRoot As %String, Output pDynObj As %Library.DynamicObject) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pResourceSchemaRoot="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR resource schema not specified")
			Quit
		}
		
		#dim tNode As %XML.Node
		
		If ($Get(pXMLDocument)="")||('$IsObject(pXMLDocument))||('pXMLDocument.%IsA("%XML.Document")) {
			Set tSC = $$$ERROR($$$GeneralError,"XML input must be an %XML.Document object")
			Quit
		}
		
		Set pDynObj = ##class(%Library.DynamicObject).%New()
		
		Set tNode = pXMLDocument.GetDocumentElement()
		
		Set tTopResourceName = ""
		
		If tNode.NodeType=$$$xmlELEMENTNODE {
			If tNode.Namespace'="http://hl7.org/fhir" {
				Set tSC = $$$ERROR($$$GeneralError,"FHIR namespace not found")
				Quit
			}
			Set tTopResourceName = tNode.LocalName
			Set tTopResourceSchemaName = pResourceSchemaRoot_"."_tTopResourceName
		}
		If tTopResourceName="" {
			Set tSC = $$$ERROR($$$GeneralError,"Top level FHIR resource name not found")
			Quit
		}
		
		Set pDynObj.resourceType = tTopResourceName
		
		Set tSC = ..XMLDocumentToDynamicObject2(tNode, tTopResourceSchemaName, .pDynObj, .pResourceSchemaRoot)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod XMLDocumentToDynamicObject2(pNode As %XML.Node, pHSFHIRClassName As %String, ByRef pDynObj As %Library.DynamicObject, ByRef pResourceSchemaRoot As %String) [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(pHSFHIRClassName))=0 Do ..GetPropInfo(pHSFHIRClassName)
		
		Set tPrevPropName = ""
		Set tPrevPropType = ""
		Set tPrevPropColl = ""
		
		// url attribute on this object means this is an extension object.
		If pNode.AttributeDefined("url") {
			Set pDynObj.url = pNode.GetAttributeValue("url")
		}
		
		// Save the current node id so that we may re-set back to it before returning.
		Set tSaveNodeId = pNode.NodeId
		// Try to move to the first child node, quit if no child nodes.
		If 'pNode.MoveToFirstChild(1) Quit
		
		For {
			Set tPropName = pNode.LocalName
			If '$Data(%propsByName(pHSFHIRClassName,tPropName)) {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid property '"_tPropName_"' for class "_pHSFHIRClassName)
				Quit
			}
			Set tPropType = %propsByName(pHSFHIRClassName,tPropName,"Type")
			Set tPropColl = %propsByName(pHSFHIRClassName,tPropName,"Collection")
			If $Data(%propsByName(tPropType))=0 Do ..GetPropInfo(tPropType)
			Set tHasChild = pNode.HasChildNodes(1)
			Set tNumAtt = pNode.GetNumberAttributes()
			
			// div is a special case, is a string, guaranteed to be part of
			// a Narrative element, which consists of just singleton status
			// property and singleton div property.
			If tPropName="div" {
				If (pNode.Namespace="")||(pNode.Namespace="http://hl7.org/fhir") {
					Set pNode.Namespace = "http://www.w3.org/1999/xhtml"
				}
				If pNode.Namespace="http://www.w3.org/1999/xhtml" {
					// Gather div as an xhtml string with all whitespace preserved.
					Set tString = ""
					Set tSC = ..XMLDocumentDivString(pNode, 1, .tString)
					If $$$ISERR(tSC) Quit
					Set tString = $ZStrip(tString,"<>W")
					// No need XML decode, it's already done.
					// No need to JSON encode, because we are populating an object, not writing a stream.
					Set pDynObj.div = tString
					// Try to move to the next sibling on this level, quit if no more siblings.
					If 'pNode.MoveToNextSibling(1) Quit
					Continue
				} Else {
					Set tSC = $$$ERROR($$$GeneralError,"Invalid namespace on Narrative div property")
					Quit
				}
			}
			
			If tPropName'=tPrevPropName {
				// Starting a new property on this level.
				If tPrevPropName'="" {
					// Finish up the previous property (if any) on this level.
					// If the previous property on this level had ids and/or
					// extensions, then write them now.
					If ($Data(tExtNodes))||($Data(tIds)) {
						Set tPrevPropType = %propsByName(pHSFHIRClassName, tPrevPropName, "Type")
						If $Data(%propsByName(tPrevPropType))=0 Do ..GetPropInfo(tPrevPropType)
						Set tExtensionSchema = %propsByName(tPrevPropType, "extension", "Type")
						Set tSC = ..XMLDocumentToDynamicObjectExt(pNode, tExtensionSchema, tPrevPropName, tPrevPropColl, tPrevCollCount, .tIds, .tExtNodes, .pDynObj)
						If $$$ISERR(tSC) Quit
						Kill tIds,tExtNodes
					}
				}
				
				// Now set up for new next property.
				
				Set tCollCount = 1
				
				If %propsByName(pHSFHIRClassName,tPropName,"Collection") {
					Set tDynArr = ##class(%Library.DynamicArray).%New()
					Do pDynObj.%Set(tPropName, tDynArr)
				}
				
				Set tPrevPropName = tPropName
				Set tPrevPropType = tPropType
				Set tPrevPropColl = tPropColl
				Set tPrevCollCount = tCollCount
				
			} Else {
				// The current property name is the same as the previous property name
				// on this level. This implies that this is the 2nd through Nth member
				// in a collection.
				If 'tPropColl {
					Set tSC = $$$ERROR($$$GeneralError, "Invalid multiple values for non-collection property '"_tPropName_"' on class "_pHSFHIRClassName)
					Quit
				}
				Set tCollCount = tCollCount + 1
			}
			
			// New property is now started or current one is being continued.
			
			If %propsByName(tPropType,"Datatype") {
				// It's a primitive.
				// Can have value.
				// Can have value with id and/or extension.
				// Can have id and/or extension without value.
				Set tValueValue = 0
				If tNumAtt>0 {
					Set tAttName = ""
					For {
						Set tAttName = pNode.NextAttributeName(tAttName)
						If tAttName="" Quit
						Set tValue = pNode.GetAttributeValue(tAttName)
						// No need XML decode, it's already done.
						// No need to JSON encode, because we are populating an object, not writing a stream.
						If tAttName="value" {
							If $Extract(tPropType,*-6,*)="Boolean" {
								Set tValue = $Case(tValue, "true":1, "false":0, 1:1, 0:0, :0)
								If %propsByName(pHSFHIRClassName,tPropName,"Collection") {
									Do tDynArr.%Push(tValue, "boolean")
								} Else {
									Do pDynObj.%Set(tPropName, tValue, "boolean")
								}
							} ElseIf ($Extract(tPropType,*-6,*)="Numeric")||($Extract(tPropType,*-6,*)="Integer")||($Extract(tPropType,*-6,*)="Decimal") {
								If %propsByName(pHSFHIRClassName,tPropName,"Collection") {
									Do tDynArr.%Push(tValue, "number")
								} Else {
									Do pDynObj.%Set(tPropName, tValue, "number")
								}
							} Else {
								If %propsByName(pHSFHIRClassName,tPropName,"Collection") {
									Do tDynArr.%Push(tValue, "string")
								} Else {
									Do pDynObj.%Set(tPropName, tValue, "string")
								}
							}
							Set tValueValue = 1
						} ElseIf tAttName="id" {
							// Gather the ids. They will be used later when XMLDocumentToJSONExt is called.
							Set tIds(tCollCount) = tValue
						}
					}
				}
				// If it's a primitive, then extension is the only reason for child.
				If tHasChild {
					If 'tValueValue {
						If %propsByName(pHSFHIRClassName,tPropName,"Collection") {
							Do tDynArr.%Push("", "null")
						}
					}
					// Gather the extension element node ids. They will be used later when XMLDocumentToJSONExt is called.
					Set tSaveDatatypeNodeId = pNode.NodeId
					Set tExtBoolean = pNode.MoveToFirstChild(1)
					Set tExtNodes(tCollCount,$i(tExtNodes(tCollCount))) = pNode.NodeId
					For {
						If 'pNode.MoveToNextSibling(1) Quit
						Set tExtNodes(tCollCount,$i(tExtNodes(tCollCount))) = pNode.NodeId
					}
					Set pNode.NodeId = tSaveDatatypeNodeId
				}
			} Else { // Not a Datatype, is an object.
				// Start an object and place the reference into the array.
				Set tDynObj = ##class(%Library.DynamicObject).%New()
				If %propsByName(pHSFHIRClassName,tPropName,"Collection") {
					Do tDynArr.%Push(tDynObj)
				} Else {
					Do pDynObj.%Set(tPropName, tDynObj)
				}
				If (tPropName="resource")||(tPropName="contained") {
					// Properties named resource or contained should always have
					// a child node that is the top of a FHIR resource.
					Set tSaveResourceNodeId = pNode.NodeId
					If 'pNode.MoveToFirstChild(1) {
						Set tSC = $$$ERROR($$$GeneralError, "Property '"_tPropName_"' has no child nodes")
						Quit
					}
					Set tPropName = pNode.LocalName
					Set tDynObj.resourceType = tPropName
					Set tPropType = pResourceSchemaRoot_"."_tPropName
					Set tSC = ..XMLDocumentToDynamicObject2(pNode, tPropType, .tDynObj, .pResourceSchemaRoot)
					If $$$ISERR(tSC) Quit
					Set pNode.NodeId = tSaveResourceNodeId
				} Else {
					Set tSC = ..XMLDocumentToDynamicObject2(pNode, tPropType, .tDynObj, .pResourceSchemaRoot)
					If $$$ISERR(tSC) Quit
				}
			}
			
			// Try to move to the next sibling on this level, quit if no more siblings.
			If 'pNode.MoveToNextSibling(1) {
				// If this property had ids and/or extensions, then put then in the %DynamicObject now.
				If ($Data(tExtNodes))||($Data(tIds)) {
					Set tExtensionSchema = %propsByName(tPropType, "extension", "Type")
					Set tSC = ..XMLDocumentToDynamicObjectExt(pNode, tExtensionSchema, tPropName, tPropColl, tCollCount, .tIds, .tExtNodes, .pDynObj)
					If $$$ISERR(tSC) Quit
					Kill tIds,tExtNodes
				}
				Quit
			}
		}
		
		Set pNode.NodeId = tSaveNodeId
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// XMLDocumentToDynamicObjectExt sets ids and/or extensions for a given property into the %DynamicObject.
ClassMethod XMLDocumentToDynamicObjectExt(pNode As %XML.Node, pExtSchema, pPropName, pPropColl, pCollCount, ByRef pIds, ByRef pExtNodes, ByRef pDynObj) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tSaveNodeId = pNode.NodeId
		
		If $Data(%propsByName(pExtSchema))=0 Do ..GetPropInfo(pExtSchema)
		
		If 'pPropColl {
			Set tCollPos = 1
			// Start an object.
			Set tExtDynObj = ##class(%Library.DynamicObject).%New()
			Do OneExt
			If $$$ISERR(tSC) Quit
			Do pDynObj.%Set("_"_pPropName, tExtDynObj)
		} Else {
			// Start a collection.
			Set tExtDynArr = ##class(%Library.DynamicArray).%New()
			For tCollPos = 1:1:pCollCount {
				Set tExtDynObj = ##class(%Library.DynamicObject).%New()
				Do OneExt
				If $$$ISERR(tSC) Quit
			}
			Do pDynObj.%Set("_"_pPropName, tExtDynArr)
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Set pNode.NodeId = tSaveNodeId
	
	Quit tSC
	
OneExt
	If ('$Data(pIds(tCollPos)))&&('$Data(pExtNodes(tCollPos))) {
		// This can happen only when the property is a collection.
		Do tExtDynArr.%Push("","null")
	} Else {
		If $Data(pIds(tCollPos)) Set tExtDynObj.id = pIds(tCollPos)
		If $Data(pExtNodes(tCollPos)) {
			Set tExtDynExtArr = ##class(%Library.DynamicArray).%New()
			For i = 1:1:pExtNodes(tCollPos) {
				Set pNode.NodeId = pExtNodes(tCollPos,i)
				Set tExtDynExtObj = ##class(%Library.DynamicObject).%New()
				// Extension value cannot be a resource, so don't worry about passing in pResourceSchemaRoot here.
				Set tSC = ..XMLDocumentToDynamicObject2(pNode, pExtSchema, .tExtDynExtObj)
				If $$$ISERR(tSC) Quit
				Do tExtDynExtArr.%Push(tExtDynExtObj)
			}
			Set tExtDynObj.extension = tExtDynExtArr
		}
		If pPropColl {
			Do tExtDynArr.%Push(tExtDynObj)
		}
	}
	Quit
}

/// API
/// JSONToXML takes a FHIR JSON stream object or string as input, and returns a FHIR XML stream.
/// This method needs a class package to be designated as the root of the data model classes to
/// use during this transform. Indent character(s) and line terminator character(s) for the XML
/// output are optional.<br>
/// <br>
/// Input:<br>
/// <li>pJSONStreamOrString : (required) FHIR JSON stream object or string.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema.  Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pIndentChars        : (optional) Indent character(s) to use for each line in the XML output.
/// <li>pLineTerminator     : (optional) Line terminator character(s) to use for the XML output.<br>
/// <br><br>
/// Output:<br>
/// <li>pXMLStream          : FHIR XML stream. If this object is not passed in then this method
///                           initializes it as a %Stream.TmpCharacter.
ClassMethod JSONToXML(pJSONStreamOrString, ByRef pXMLStream, pResourceSchemaRoot As %String = "", pIndentChars As %String = "", pLineTerminator As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pJSONStreamOrString)="" {
			Set tSC = $$$ERROR($$$GeneralError,"JSON input not specified")
			Quit
		}
		
		Set tJSONObject = ##class(%DynamicObject).%FromJSON(pJSONStreamOrString)
		If '$IsObject($Get(tJSONObject)) {
			Set tSC = $$$ERROR($$$GeneralError, "Could not create object from FHIR JSON string")
			Quit
		}
		
		Set tSC = ..JSONDynamicObjectToXML(.tJSONObject, .pXMLStream, pResourceSchemaRoot, pIndentChars, pLineTerminator)

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// API
/// JSONDynamicObjectToXML takes a FHIR JSON %DynamicObject as input, and returns a FHIR XML
/// stream. This method needs a class package to be designated as the root of the data model
/// classes to use during this transform. Indent character(s) and line terminator character(s)
/// for the XML output are optional.<br>
/// <br>
/// Input:<br>
/// <li>pJSONObject         : (required) FHIR JSON %DynamicObject.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema.  Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pIndentChars        : (optional) Indent character(s) to use for each line in the XML output.
/// <li>pLineTerminator     : (optional) Line terminator character(s) to use for the XML output.<br>
/// <br><br>
/// Output:<br>
/// <li>pXMLStream          : FHIR XML stream. If this object is not passed in then this method
///                           initializes it as a %Stream.TmpCharacter.
ClassMethod JSONDynamicObjectToXML(ByRef pJSONObject As %Library.DynamicObject, ByRef pXMLStream, pResourceSchemaRoot As %String = "", pIndentChars As %String = "", pLineTerminator As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pResourceSchemaRoot="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR resource schema not specified")
			Quit
		}
		
		For i = 0:1:25 Set $Piece(%indent(i),pIndentChars,i+1)=""
		
		Set %lineterm = pLineTerminator
		
		Set %buffer = ""
		Set %maxbuffer = 3640000
		
		If ($Get(pJSONObject)="")||('$IsObject(pJSONObject))||('pJSONObject.%IsA("%Library.DynamicAbstractObject")) {
			Set tSC = $$$ERROR($$$GeneralError,"JSON input must be a %DynamicObject")
		}
		
		If '$IsObject($Get(pXMLStream)) Set pXMLStream = ##class(%Stream.TmpCharacter).%New()
		
		Set tTopResourceName = pJSONObject.resourceType
		If tTopResourceName="" {
			Set tSC = $$$ERROR($$$GeneralError, "resourceType not found at top level of JSON object")
			Quit
		}
		
		Set tTopResourceClassName = pResourceSchemaRoot_"."_tTopResourceName
		
		Set tLevel = 0
		Set tString = "<"_tTopResourceName_" xmlns=""http://hl7.org/fhir"">" Do Write
		
		Set tSC = ..JSONDynamicObjectToXML2(pJSONObject, tLevel+1, .pXMLStream, tTopResourceClassName)
		If $$$ISERR(tSC) Quit
		
		Set tString = "</"_tTopResourceName_">" Do Write
		
		If %buffer'="" Do pXMLStream.Write(%buffer)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Kill %indent
	Kill %lineterm
	Kill %buffer
	Kill %maxbuffer
	
	Quit tSC
	
Write
	Set tString = %indent(tLevel)_tString_%lineterm
	If ($Length(%buffer)+$Length(tString))>%maxbuffer Do pXMLStream.Write(%buffer) Set %buffer = ""
	Set %buffer = %buffer_tString
	Quit
}

ClassMethod JSONDynamicObjectToXML2(pJSONObject As %Library.DynamicObject, pLevel As %Integer, ByRef pXMLStream, pHSFHIRClassName As %String) [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(pHSFHIRClassName))=0 Do ..GetPropInfo(pHSFHIRClassName)
		
		// Properties in FHIR XML must follow the schema order.
		Set tSequence = 0
		For {
			Set tSequence = $$$comMemberKeyNext(pHSFHIRClassName,$$$cCLASSxmldata,$$$cPROPmethod,tSequence)
			If tSequence="" Quit
			
			Set tPropName = $$$comMemberKeyGet(pHSFHIRClassName,$$$cCLASSxmldata,$$$cPROPmethod,tSequence)
			Set tPropName = $ListGet(tPropName,1)
			
			Set tData = pJSONObject.%Get(tPropName)
			If tData="" Continue
						
			// tPropName is the current property name.
			// tData can be one of these:
			// - String value
			// - %Library.DynamicArray object reference
			// - %Library.DynamicObject object reference
			
			// resourceType is only used by the code calling this method, to determine the type of
			// FHIR resource (if any) that this object is.
			// fhir_comments is for the FHIR JSON equivalent of XML comments, which we want to ignore.
			If (tPropName="resourceType")||(tPropName="fhir_comments") Continue
			
			// Extensions will already have been processed earlier along with their associated
			// standard property.
			If $Extract(tPropName)="_" Continue
			
			If $Data(%propsByName(pHSFHIRClassName, tPropName))=0 {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid property '"_tPropName_"' found in "_pHSFHIRClassName_" object")
				Quit
			}
			
			// Properties url and id are processed as part of extension processing.
			If ((tPropName="url")||(tPropName="id"))&&($Extract(pHSFHIRClassName,*-9,*)=".Extension") Continue
			
			Set tPropType = %propsByName(pHSFHIRClassName, tPropName, "Type")
			
			// Make a note of the object reference for the extension data, if any, for the
			// current property.
			Set tExtData = pJSONObject.%Get("_"_tPropName)
			
			// Property "div" is just a %String.  Just set the data into the XML directly.
			If tPropName="div" {
				Set tString = tData
				If $Extract(tString,1,5)="<div>" Set tString = "<div xmlns=""http://www.w3.org/1999/xhtml"">"_$Extract(tString,6,*)
				Do Write
				Continue
			}
			
			If '$IsObject(tData) {
				// This is a primitive FHIR object type such as String, Code, etc.
				// Check for extension and/or id on this item first, and build
				// collection of extensions if necessary.
				If $Extract(tPropType,*-6,*)'="Boolean" {
					Set tData = $ZConvert(tData,"O","XML")
				} Else {
					Set tData = $Case(tData, "0":"false", "1":"true", "true":"true", "false":"false", :"false")
				}
				If tExtData="" {
					// Assume that tData has a value if there is no id or extension data.
					Set tString = "<"_tPropName_" value="""_tData_""""_"/>"
					Do Write
				} Else {
					Set tPropTag = "<"_tPropName
					If tExtData.id'="" Set tPropTag = tPropTag_" id="""_tExtData.id_""""
					If tData'="" Set tPropTag = tPropTag_" value="""_tData_""""
					If tExtData.extension="" {
						Set tPropTag = tPropTag_"/>"
						Set tString = tPropTag Do Write
					} Else {
						Set tPropTag = tPropTag_">"
						Set tString = tPropTag Do Write
						// Find the class definition for extension, then use it.
						If $Data(%propsByName(tPropType))=0 Do ..GetPropInfo(tPropType)
						Set tExtensionSchema = %propsByName(tPropType, "extension", "Type")
						// Because this is not an array, the extension will be an object, not an array.
						Do ..JSONDynamicObjectToXMLExt(tExtData, pLevel+1, .pXMLStream, tExtensionSchema)
						Set tString = "</"_tPropName_">" Do Write
					}
				}
				If $$$ISERR(tSC) Quit
			} ElseIf tData.%IsA("%Library.DynamicObject") {
				// This is a %DynamicObject. Instantiate a new object and make the recursive call.
				If $Extract(tPropType,*-16,*)'="ResourceContainer" {
					If tPropName'="extension" {
						Set tString = "<"_tPropName_">" Do Write
					} Else {
						Set tPropTag = "<extension url="""_tData.url_""""
						If tData.id'="" Set tPropTag = tPropTag_" id="""_tData.id_""""
						Set tPropTag = tPropTag_">"
						Set tString = tPropTag Do Write
					}
					Set tSC = ..JSONDynamicObjectToXML2(tData, pLevel+1, .pXMLStream, tPropType)
					If $$$ISERR(tSC) Quit
					Set tString = "</"_tPropName_">" Do Write
				} Else {
					// Special case: tPropType ends with "ResourceContainer" means this is
					// a ResourceContainer.  In this case, the class should be the resource
					// type indicated in the JSON array. Instantiate that, instead of
					// ResourceContainer. We will wrap the the resource object in the
					// ResourceContainer after returning from the ..JSONDynamicObjectToXML2 call.
					Set tResourceType = tData.resourceType
					If $Data(%propsByName(tPropType))=0 Do ..GetPropInfo(tPropType)
					Set tResourcePropType = %propsByName(tPropType, tResourceType, "Type")
					// tPropName is most likely either "resource" or "contained".
					Set tString = "<"_tPropName_">" Do Write
					Set pLevel = pLevel + 1
					// tResourceType is the resource type.
					Set tString = "<"_tResourceType_">" Do Write
					Set tSC = ..JSONDynamicObjectToXML2(tData, pLevel+1, .pXMLStream, tResourcePropType)
					If $$$ISERR(tSC) Quit
					Set tString = "</"_tResourceType_">" Do Write
					Set pLevel = pLevel - 1
					Set tString = "</"_tPropName_">" Do Write
				}
			} Else {
				// This is a %DynamicArray of objects or primitive object types.
				// First, loop through any counterpart extension objects for this array.
				// For each extension object found in the JSON, generate the extension
				// object and put it in a local array.  This array of extension object
				// references will then be used when looping through the array of
				// standard objects/values.
				If tExtData'="" {
					Set tIterator2 = tExtData.%GetIterator()
					Set tPropName2 = ""
					For {
						If 'tIterator2.%GetNext(.tPropName2, .tData2) Quit
						If tPropName2="" Quit
						// Empty tData2 here means there is "null" in the JSON array element.
						If tData2="" Continue
						If tData2.id'="" Set tPropIdArray(tPropName2) = tData2.id
						If tData2.extension'="" Set tExtDataArray(tPropName2) = tData2
					}
					Kill tIterator2
				}
				// Loop through the array elements.
				Set tIterator2 = tData.%GetIterator()
				Set tPropName2 = ""
				For {
					If 'tIterator2.%GetNext(.tPropName2, .tData2) Quit
					If tPropName2="" Quit
					// This condition should never ever happen, but noting it anyway.
					If (tData2="")&&('$Data(tExtDataArray(tPropName2))) Continue
					// If tData2 is blank after this point, it means that the property has 
					// no standard property value but has some extension data. 
					If ($IsObject(tData2))&&(tData2.%IsA("%Library.DynamicObject")) {
						If $Extract(tPropType,*-16,*)'="ResourceContainer" {
							If tPropName'="extension" {
								Set tString = "<"_tPropName_">" Do Write
							} Else {
								Set tPropTag = "<extension url="""_tData2.url_""""
								If tData2.id'="" Set tPropTag = tPropTag_" id="""_tData2.id_""""
								Set tPropTag = tPropTag_">"
								Set tString = tPropTag Do Write
							}
							Set tSC = ..JSONDynamicObjectToXML2(tData2, pLevel+1, .pXMLStream, tPropType)
							If $$$ISERR(tSC) Quit
							Set tString = "</"_tPropName_">" Do Write
						} Else {
							// Special case: tPropType ends with "ResourceContainer" means this is
							// a ResourceContainer.  In this case, the class should be the resource
							// type indicated in the JSON array. Instantiate that, instead of
							// ResourceContainer. We will wrap the the resource object in the
							// ResourceContainer after returning from the ..JSONDynamicObjectToXML2 call.
							Set tResourceType = tData2.resourceType
							If $Data(%propsByName(tPropType))=0 Do ..GetPropInfo(tPropType)
							Set tResourcePropType = %propsByName(tPropType, tResourceType, "Type")
							// tPropName is most likely either "resource" or "contained".
							Set tString = "<"_tPropName_">" Do Write
							Set pLevel = pLevel + 1
							// tResourceType is the resource type.
							Set tString = "<"_tResourceType_">" Do Write
							Set tSC = ..JSONDynamicObjectToXML2(tData2, pLevel+1, .pXMLStream, tResourcePropType)
							If $$$ISERR(tSC) Quit
							Set tString = "</"_tResourceType_">" Do Write
							Set pLevel = pLevel - 1
							Set tString = "</"_tPropName_">" Do Write
						}
					} ElseIf '$IsObject(tData2) {
						// This is a primitive FHIR object type such as String, Code, etc.
						// Check for extension and/or id that may have been noted on this item
						// earlier, and include them when setting the property.
						If $Extract(tPropType,*-6,*)'="Boolean" {
							Set tData2 = $ZConvert(tData2,"O","XML")
						} Else {
							Set tData2 = $Case(tData2, "0":"false", "1":"true", "true":"true", "false":"false", :"false")
						}
						Set tPropId2 = $Get(tPropIdArray(tPropName2))
						If $Get(tExtDataArray(tPropName2))="" {
							// Assume that tData/tValue has a value if there is no extension data.
							Set tPropTag = "<"_tPropName
							If tPropId2'="" Set tPropTag = tPropTag_" id="""_tPropId2_""""
							Set tPropTag = tPropTag_" value="""_tData2_""""
							Set tPropTag = tPropTag_"/>"
							Set tString = tPropTag Do Write
						} Else {
							Set tPropTag = "<"_tPropName
							If tPropId2'="" Set tPropTag = tPropTag_" id="""_tPropId2_""""
							If tData2'="" Set tPropTag = tPropTag_" value="""_tData2_""""
							Set tPropTag = tPropTag_">"
							Set tString = tPropTag Do Write
							// Find the class definition for extension, then use it.
							If $Data(%propsByName(tPropType))=0 Do ..GetPropInfo(tPropType)
							Set tExtensionSchema = %propsByName(tPropType, "extension", "Type")
							// Because this is not an array, the extension will be an object, not an array.
							Do ..JSONDynamicObjectToXMLExt(tExtDataArray(tPropName2), pLevel+1, .pXMLStream, tExtensionSchema)
							Set tString = "</"_tPropName_">" Do Write
						}
						If $$$ISERR(tSC) Quit						
						Continue
					} Else {
						// This is an array.  Unlikely that this situation exists at all.
					}
				}
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
	
Write
	Set tString = %indent(pLevel)_tString_%lineterm
	If ($Length(%buffer)+$Length(tString))>%maxbuffer Do pXMLStream.Write(%buffer) Set %buffer = ""
	Set %buffer = %buffer_tString
	Quit
}

ClassMethod JSONDynamicObjectToXMLExt(pJSONObject As %Library.DynamicObject, pLevel As %Integer, ByRef pXMLStream As %Stream.GlobalCharacter, pExtensionClass As %String) [ Internal ]
{
	Set tIterator = pJSONObject.extension.%GetIterator()
	Set tPropName = ""
	For {
		If 'tIterator.%GetNext(.tPropName, .tData) Quit
		If tPropName="" Quit
		If tData="" Continue
		Set tPropTag = "<extension url="""_tData.url_""""
		If tData.id'="" Set tPropTag = tPropTag_" id="""_tData.id_""""
		Set tPropTag = tPropTag_">"
		Set tString = tPropTag Do Write
		Set tSC = ..JSONDynamicObjectToXML2(tData, pLevel+1, .pXMLStream, pExtensionClass)
		If $$$ISERR(tSC) Quit
		Set tString = "</extension>" Do Write
	}
	Quit
	
Write
	Set tString = %indent(pLevel)_tString_%lineterm
	If ($Length(%buffer)+$Length(tString))>%maxbuffer Do pXMLStream.Write(%buffer) Set %buffer = ""
	Set %buffer = %buffer_tString
	Quit
}

/// API
/// FormatFHIR takes a FHIR stream object or string as input, calls either FormatJSON or FormatXML,
/// depending on pContentType input parameter, and returns the result as a FHIR stream object.<br>
/// <br>
/// Input:<br>
/// <li>pContentType        : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pFHIRStreamOrString : (required) FHIR stream object or string.
/// <li>pJSONIndentChars    : Indent character(s) for JSON formatting. May be specified as blank.
/// <li>pJSONLineTerminator : Line terminator character(s) for JSON formatting. May be specified as blank.
/// <li>pTransformer        : HS.Util.XSLTTransformer object to use for the XSLT transformation. If
///                           this object is not passed in, then a local transformer object will be
///                           created for this call. <b>Please note</b> that the transformer object
///                           create incurs a performance impact. Therefore if this method is being
///                           called frequently by a given host or application, then it is prudent
///                           for that host or application to instantiate, maintain and pass in its
///                           own transformer object.
/// <li>pXMLFormatOption    : 0 = No formatting (i.e., strip existing indent and line end formatting).
///                           1 = Add tab indent and line-feed-only line end formatting.
///                           2 = Add tab indent and carriage return line feed line end formatting.
/// <br><br>
/// Output:<br>
/// <li>pFHIRStreamOut      : Stream object to use for the formatted FHIR output. This object may be 
///                           passed in as a new stream object. Otherwise it will be initialized as
///                           a %Stream.TmpCharacter object.
ClassMethod FormatFHIR(pContentType As %String, pFHIRStreamOrString = "", ByRef pFHIRStreamOut As %Stream.Object, pJSONIndentChars As %String = "", pJSONLineTerminator As %String = "", ByRef pXMLTransformer = "", pXMLFormatOption As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tContentType = $ZConvert($Get(pContentType), "L")
		
		If tContentType["json" {
			Set tSC = ..FormatJSON(pFHIRStreamOrString, .pFHIRStreamOut, pJSONIndentChars, pJSONLineTerminator)
		} ElseIf tContentType["xml" {
			Set tSC = ..FormatXML(pFHIRStreamOrString, .pFHIRStreamOut, .pXMLTransformer, pXMLFormatOption)
		} ElseIf tContentType'="" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid content type specified")
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Content type not specified")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// FormatJSON takes a FHIR JSON stream or string as input, applies indent and line end formatting
/// as per the pIndentChars and pLineTerminator input parameters, and returns the result as a FHIR
/// JSON stream. This method can be used for stripping the indent, line terminator, and other
/// unnecessary white space, by passing in pIdentChars and pLineTerminator both as blank, or by
/// simply omitting them from the parameter inputs.<br>
/// <br>
/// Input:<br>
/// <li>pJSONStreamOrString : (required) FHIR JSON stream object or string.
/// <li>pIndentChars        : Indent character(s).
/// <li>pLineTerminator     : Line terminator character(s).
/// <br><br>
/// Output:<br>
/// <li>pJSONStreamOut      : Stream object to use for the formatted FHIR JSON output. This object
///                           may be passed in as a new stream object. Otherwise this method will
///                           initialize it as a %Stream.TmpCharacter.
ClassMethod FormatJSON(pJSONStreamOrString, ByRef pJSONStreamOut As %Stream.Object, pIndentChars As %String = "", pLineTerminator As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pJSONStreamOrString)="" {
			Set tSC = $$$ERROR($$$GeneralError,"JSON input not specified")
			Quit
		}
		
		Set tIsString = ('$IsObject(pJSONStreamOrString))
		
		Set tMaxBuf = $$$MaxLocalLength
		Set tReadLen = 32656

		Set tInPropName = 0
		Set tInPropVal = 0
		Set tIndentLevel = 0
		Set tBuffer = ""
		Set tTab = $Char(9)
		Set tLF = $Char(10)
		Set tCR = $Char(13)
		Set tChar = ""
		Set tPrevChar = ""
		Set tPrevPrevChar = ""
		Set tPrevNonWSChar = ""
		Set tInCollection = 0
		
		// tJSONChars have special meaning when outside of
		// a property/object name and property value.
		Set tJSONChars(tTab)=""
		Set tJSONChars(tLF)=""
		Set tJSONChars(tCR)=""
		Set tJSONChars(" ")=""
		Set tJSONChars("[")=""
		Set tJSONChars("]")=""
		Set tJSONChars("{")=""
		Set tJSONChars("}")=""
		Set tJSONChars(",")=""
		Set tJSONChars("""")=""
		
		Set tWhitespace(" ") = ""
		Set tWhitespace(tTab) = ""
		Set tWhitespace(tLF) = ""
		Set tWhitespace(tCR) = ""
		
		For i = 0:1:25 Set $Piece(tIndent(i),pIndentChars,i+1) = ""
		
		If '$IsObject($Get(pJSONStreamOut)) Set pJSONStreamOut = ##class(%Stream.TmpCharacter).%New()
		
		// Set the string by either copying it from the input, or by initial read on the stream.
		If tIsString {
			Set tString = pJSONStreamOrString
		} Else {
			Set tString = pJSONStreamOrString.Read(tReadLen, .tSC)
			If $$$ISERR(tSC) Quit
		}
		
		// Make sure the first non-whitespace character is left curly brace.
		For tReadPos = 1:1 {
			Set tChar = $Extract(tString, tReadPos)
			If $Data(tWhitespace(tChar)) Continue
			If tChar'="{" Set tSC = $$$ERROR($$$GeneralError,"First character is not {")
			Quit
		}
		If $$$ISERR(tSC) Quit
		
		For {
			For tPosition = 1:1:$Length(tString) {
				Set tPrevPrevChar = tPrevChar
				Set tPrevChar = tChar
				If '$Data(tWhitespace(tPrevChar)) Set tPrevNonWSChar = tPrevChar
				Set tChar = $Extract(tString,tPosition)
				
				// This is not a character that needs any special processing.
				// Simply write it out.
				If $Data(tJSONChars(tChar))=0 {
					Set tAddChars = tChar Do Write
					Continue
				}
				
				// Handle the escape character (backslash).
				If (tInPropVal)&&((tChar'="""")||((tPrevChar="\")&&(tPrevPrevChar'="\"))) {
					Set tAddChars = tChar Do Write
					Continue
				}
				
				// Write out space or tab only when inside a property value.
				If (tChar=" ")||(tChar=tTab) {
					If tInPropVal {
						Set tAddChars = tChar Do Write
					}
					Continue
				}
				
				// A quote here can signal either start or end of a property name
				// or the start or end of a property value.
				If tChar="""" {
					If ('tInPropVal)&&(tPrevNonWSChar=":") {
						Set tInPropVal=1
					} ElseIf tInPropName {
						Set tInPropName=0
					} ElseIf tInPropVal {
						Set tInPropVal=0
					} ElseIf ((tPrevNonWSChar=",")&&(tInCollection))||(tPrevNonWSChar="[") {
						Set tInPropVal = 1
					} Else {
						Set tInPropName=1
					}
					Set tAddChars = tChar Do Write
					Continue
				}
				
				// A comma inside a property value is just text, otherwise it
				// is a delimiter before the next property or property value.
				If tChar="," {
					If tInPropVal {
						Set tAddChars = tChar Do Write
						Continue
					}
					Set tAddChars = tChar_pLineTerminator_tIndent(tIndentLevel) Do Write
					Continue
				}
				
				If tChar="{" {
					Set tInCollection = 0
					If $i(tIndentLevel)
					Set tAddChars = tChar_pLineTerminator_tIndent(tIndentLevel) Do Write
					Continue
				}
				
				If tChar="[" {
					Set tInCollection = 1
					If $i(tIndentLevel)
					Set tAddChars = tChar_pLineTerminator_tIndent(tIndentLevel) Do Write
					Continue
				}
				
				If ('tInPropVal)&&((tChar=tLF)||(tChar=tCR)) Continue
				
				If tChar="]"!(tChar="}") {
					If tChar="]" Set tInCollection = 0
					Set tIndentLevel = tIndentLevel - 1
					Set tAddChars = pLineTerminator_tIndent(tIndentLevel)_tChar Do Write
					Continue
				}
			}
			
			If (tIsString)||(pJSONStreamOrString.AtEnd) {
				Do:$Length(tBuffer)>0 pJSONStreamOut.Write(tBuffer)
				Quit
			} Else {
				Set tString = pJSONStreamOrString.Read(tReadLen, .tSC)
				If $$$ISERR(tSC) Quit
			}
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
	
Write
	If ($Length(tBuffer)+$Length(tAddChars))>tMaxBuf Do pJSONStreamOut.Write(tBuffer) Set tBuffer = ""
	Set tBuffer = tBuffer_tAddChars
	Quit
}

/// API
/// FormatXML uses XSLT to add or remove indent and line end formatting in a FHIR XML stream object
/// or string, and to return the result in a FHIR XML stream.<br>
/// <br>
/// Input:<br>
/// <li>pXMLStreamOrString : (required) FHIR XML resource stream object or string.
/// <li>pTransformer       : HS.Util.XSLTTransformer object to use for the XSLT transformation. If
///                          this object is not passed in, then a local transformer object will be
///                          created for this call. <b>Please note</b> that the transformer object
///                          create incurs a performance impact. Therefore if this method is being
///                          called frequently by a given host or application, then it is prudent
///                          for that host or application to instantiate, maintain and pass in its
///                          own transformer object.
/// <li>pFormatOption      : 0 = No formatting (i.e., strip existing indent and line end formatting).
///                          1 = Add tab indent and line-feed-only line end formatting.
///                          2 = Add tab indent and carriage return line feed line end formatting.
/// <br><br>
/// Output:<br>
/// <li>pXMLStreamOut      : Stream object to use for holding the formatted FHIR XML. This object may
///                          be passed in as an new stream object. Otherwise this method will initialize
///                          it as a %Stream.TmpCharacter object.<br>
ClassMethod FormatXML(pXMLStreamOrString, ByRef pXMLStreamOut As %Stream.Object = "", pTransformer = "", pFormatOption As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pXMLStreamOrString)="" {
			Set tSC = $$$ERROR($$$GeneralError,"XML input not specified")
			Quit
		}
		
		If $Get(pFormatOption)="" {
			Set tSC = $$$ERROR($$$GeneralError, "XML format option not specified")
			Quit
		}
		
		If '((pFormatOption=0)||(pFormatOption=1)||(pFormatOption=2)) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid XML format option specified")
			Quit
		}
		
		If '$IsObject($Get(pTransformer)) {
			Set pTransformer = ##class(HS.Util.XSLTTransformer).%New()
		}
		
		If '$IsObject($Get(pXMLStreamOut)) Set pXMLStreamOut = ##class(%Stream.TmpCharacter).%New()
		
		If '$IsObject(pXMLStreamOrString) {
			Set tXMLStream = ##class(%Stream.TmpCharacter).%New()
			Set tSC = tXMLStream.Write(pXMLStreamOrString)
			If $$$ISERR(tSC) Quit
			Do tXMLStream.Rewind()
		} Else {
			Set tXMLStream = pXMLStreamOrString
		}
		
		If pFormatOption=0 {
			If pTransformer.UseXSLT2'=1 {
				Set tXSLTName = "FormatXMLNoIndent10"
			} Else {
				Set tXSLTName = "FormatXMLNoIndent20"
			}
		} Else {
			If pTransformer.UseXSLT2'=1 {
				Set tXSLTName = "FormatXMLWithIndent10"
			} Else {
				Set tXSLTName = "FormatXMLWithIndent20"
			}
		}
		
		Set tXSLPath = "FHIR/"_tXSLTName_".xsl"
		Set tSC = pTransformer.Transform(tXMLStream, tXSLPath, .pXMLStreamOut)
		If $$$ISERR(tSC) Quit
		
		Do pXMLStreamOut.Rewind()
		
		If pFormatOption=2 Set tSC = ..AddXMLCrLf(.pXMLStreamOut)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddXMLCrLf converts XML line-feed-only line endings in the specified stream to
/// carriage return line feed line endings.
ClassMethod AddXMLCrLf(ByRef pXMLStream) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Do pXMLStream.Rewind()
		
		Set tXMLStreamTemp = ##class(%Stream.TmpCharacter).%New()
		For {
			Set tString = pXMLStream.Read(32767, .tSC)
			If $$$ISERR(tSC) Quit
			Do tXMLStreamTemp.Write(tString)
			If pXMLStream.AtEnd Quit
		}
		If $$$ISERR(tSC) Quit
		
		Do tXMLStreamTemp.Rewind()
		
		If pXMLStream.%IsA("HS.SDA3.QuickStream") {
			Do pXMLStream.Clear(0)
		} Else {
			Do pXMLStream.Clear()
		}
		
		Set tBuffer = ""
		Set tDivBuffer = ""
		Set tInDiv = 0
		Set tChar = ""
		Set tPrevChar = ""
		For {
			Set tString = tXMLStreamTemp.Read(32767, .tSC)
			If $$$ISERR(tSC) Quit
			For i = 1:1:$Length(tString) {
				Set tPrevChar = tChar
				Set tChar = $Extract(tString,i)
				Set tDivBuffer = tDivBuffer_tChar
				Set tDivBuffer = $Extract(tDivBuffer,*-41,*)
				If tDivBuffer="<div xmlns=""http://www.w3.org/1999/xhtml"">" Set tInDiv = 1
				If tInDiv {
					If $Extract(tDivBuffer,*-4,*)="<div>" Set tInDiv = tInDiv + 1
					If $Extract(tDivBuffer,*-5,*)="</div>" Set tInDiv = tInDiv - 1
				}
				If 'tInDiv If (tChar=$Char(10))&&(tPrevChar'=$Char(13)) Set tChar = $Char(13,10)
				Set tBuffer = tBuffer_tChar
				If $Length(tBuffer)>3640000 Do pXMLStream.Write(tBuffer) Set tBuffer = ""
			}
			If tXMLStreamTemp.AtEnd Do pXMLStream.Write(tBuffer) Set tBuffer = "" Quit
		}
		If $$$ISERR(tSC) Quit
		
		Do pXMLStream.Rewind()
		
		Kill tXMLStreamTemp
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetFHIRXPathDocument returns an %XML.XPATH.Document object for the specified FHIR resource
/// string, stream object, %XML.Document object, or %DynamicObject.  If both a string/stream
/// and an object are passed in, this method chooses the most efficent option for obtaining
/// the XPATH document.<br>
/// <br>
/// Input:<br>
/// <li>pContentType    : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema : (required if pContentType indicates json) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pResourceStream : (required if no pResourceObject) FHIR resource string, or stream object.
/// <li>pResourceObject : (required if no pResourceStream) %XML.Document or %DynamicObject representation of the FHIR resource.
/// <br><br>
/// Output:<br>
/// <li>pXPATHDocument  : %XML.XPATH.Document object representation of the FHIR resource.
ClassMethod GetFHIRXPathDocument(pContentType As %String, pResourceSchema As %String, pResourceStream, pResourceObject, ByRef pXPATHDocument As %XML.XPATH.Document) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pContentType)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Content type not specified")
		} ElseIf '(($ZConvert(pContentType,"L")["json")||($ZConvert(pContentType,"L")["xml")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid content type '"_pContentType_"' specified")
		}
		If $$$ISERR(tSC) Quit
		
		If ($Get(pResourceSchema)="")&&($ZConvert(pContentType,"L")) {
			Set tSC = $$$ERROR($$$GeneralError,"Resource schema not specified")
			Quit
		}
		
		If '(($Get(pResourceStream)'="")||($IsObject($Get(pResourceStream)))||($IsObject($Get(pResourceObject)))) {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR input not specified")
			Quit
		}
		
		If ($IsObject($Get(pResourceStream)))&&('pResourceStream.%IsA("%Stream.Object")) {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR stream object must extend %Stream.Object")
			Quit
		}
		
		// Convert string to stream only if the content type is xml, or if the content
		// type is json and only the string was passed in.
		If ($Get(pResourceStream)'="")&&(($ZConvert(pContentType,"L")["xml"))||(($ZConvert(pContentType,"L")["json")&&('$IsObject($Get(pResourceObject)))) {
			If '$IsObject(pResourceStream) {
				Set tTempStream = ##class(%Stream.TmpCharacter).%New()
				
				Set tSC = tTempStream.Write(pResourceStream)
				If $$$ISERR(tSC) Quit
				
				Do tTempStream.Rewind()
			} Else {
				Set tTempStream = pResourceStream
			}
		}
		
		If $ZConvert(pContentType,"L")["xml" {
			If $IsObject($Get(tTempStream)) {
				Set tXMLStream = tTempStream
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).SerializeXMLDocument(pResourceObject, .tXMLStream)
			}
		} Else {
			If $IsObject($Get(pResourceObject)) {
				Set tSC = ##class(HS.FHIR.Utils).JSONDynamicObjectToXML(pResourceObject, .tXMLStream, pResourceSchema)
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).JSONToXML(tTempStream, .tXMLStream, pResourceSchema)
			}
		}
		If $$$ISERR(tSC) Quit
		
		Do tXMLStream.Rewind()
		
		Set tSC = ..GetFHIRXPathDocFromXMLStream(tXMLStream, .pXPATHDocument)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetFHIRXPathDocFromXMLStream returns an %XML.XPATH.Document object for the specified FHIR
/// stream. This method sets the XPATH document PrefixMappings property specifically for use
/// with a FHIR resource.<br>
/// <br>
/// Input:
/// <li>pXMLStream     : FHIR XML stream object.
/// <br><br>
/// Output:<br>
/// <li>pXPATHDocument : %XML.XPATH.Document object representation of the FHIR XML.
ClassMethod GetFHIRXPathDocFromXMLStream(pXMLStream, ByRef pXPATHDocument As %XML.XPATH.Document) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Do pXMLStream.Rewind()
		
		Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(pXMLStream, .pXPATHDocument)
		If $$$ISERR(tSC) Quit
		
		Set pXPATHDocument.PrefixMappings = "f http://hl7.org/fhir,h http://www.w3.org/1999/xhtml"
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// EvaluateXPathExpression evaluates the specified XPath expression against the specified
/// %XML.XPATH.Document object. The results are always returned as a %ListOfDataTypes. However,
/// the nature of the results that are returned depends on the nature of the expression. If
/// the expression indicates a specific attribute at the end (e.g., "f:Patient/f:gender/@value")
/// then the results will each be strings.  If the expression does not indicate an attribute at
/// the end, then the results will each be an object. In either case, the FHIR property type of
/// the rightmost element in the XPath expression is returned as a separate data item.<br>
/// <br>
/// Input:<br>
/// <li>pXPATHDocument  : (required) %XML.XPATH.Document object representation of a FHIR resource.
/// <li>pExpression     : (required) The XPath expression to evaluate.
/// <li>pResourceSchema : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br><br>
/// Output:<br>
/// <li>pType           : FHIR property data type of the rightmost element in <var>pExpression</var>.
/// <li>pResults        : %ListOfDataTypes collection of the results. If <var>pExpression</var> specifies
///                       an attribute at its end, then each item in the pResults collection is a string.
///                       Otherwise, each item in the pResults collection is an object.
ClassMethod EvaluateXPathExpression(pXPATHDocument As %XML.XPATH.Document, pExpression As %String, pResourceSchema As %String, Output pType, Output pResults As %Library.ListOfDataTypes) As %Status
{
	Set tSC = $$$OK
	
	Set pType = ""
	
	Set pResults = ##class(%Library.ListOfDataTypes).%New()
	
	Try {
		If $Extract(pExpression)="/" Set pExpression = $Extract(pExpression,2,*)
		
		Set tSC = ..GetTypeForXPath(pExpression, pResourceSchema, .pType)
		If $$$ISERR(tSC) Quit
		
		Set tSC = pXPATHDocument.EvaluateExpression("/", pExpression, .tResults)
		If $$$ISERR(tSC) Quit
		
		If tResults.Count()=0 Quit
		
		// If the XPath expression specified an attribute at the end (e.g., @value, @url, @id)
		// then the results will be returned as a collection of what are basically strings.
		// In that case just return the collection as is.
		If tResults.GetAt(1).%IsA("%XML.XPATH.ValueResult") {
			For i = 1:1:tResults.Count() {
				Set tSC = pResults.Insert(tResults.GetAt(i).Value)
				If $$$ISERR(tSC) Quit
			}
			Quit
		}
		
		// Otherwise, the XPath expression implied a request for the entire FHIR object at
		// the specified XPath level.
		For i = 1:1:tResults.Count() {
			Set tSC = ..DOMResultToFHIRObj(tResults.GetAt(i), pType, .pResults)
			If $$$ISERR(tSC) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod DOMResultToFHIRObj(pDOMResult As %XML.XPATH.DOMResult, pSchema As %String, ByRef pResults As %Library.ListOfDataTypes) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		If pDOMResult.ReadState'="initial" {
			Set tSC = $$$ERROR($$$GeneralError, "Result input not passed in intial read state")
			Quit
		}
		
		Set tBoolean = pDOMResult.Read()
		If 'tBoolean {
			Set tSC = $$$ERROR($$$GeneralError, "No data found in result input")
			Quit
		}
		
		If pDOMResult.NodeType'="element" {
			Set tSC = $$$ERROR($$$GeneralError, "Result input does not start with an element")
			Quit
		}		
		
		For {
			Set tHSFHIRObj = $ClassMethod(pSchema, "%New")
			Set tSC = ..DOMResultToFHIRObj2(pDOMResult, pDOMResult.Path, .tHSFHIRObj)
			If $$$ISERR(tSC) Quit
			Set tSC = pResults.Insert(tHSFHIRObj)
			If $$$ISERR(tSC) Quit
			If pDOMResult.ReadState="eof" Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

ClassMethod DOMResultToFHIRObj2(pDOMResult As %XML.XPATH.DOMResult, pTopPath As %String, ByRef pHSFHIRObj As %RegisteredObject) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tHSFHIRClassName = pHSFHIRObj.%ClassName(1)
		
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(tHSFHIRClassName))=0 Do ..GetPropInfo(tHSFHIRClassName)
		
		// First check any attributes on this element that are
		// properties that we want to set.
		If (pDOMResult.HasAttributes) {
			For i = 1:1:pDOMResult.AttributeCount {
				If 'pDOMResult.MoveToAttributeIndex(i) Quit
				Set tDOMResultName = pDOMResult.Name
				Set tDOMResultValue = pDOMResult.Value
				If tDOMResultName="value" {
					If $Extract(tHSFHIRClassName,*-7,*)'=".Boolean" {
						Set pHSFHIRObj.value = tDOMResultValue
					} Else {
						Set pHSFHIRObj.value = $Case(tDOMResultValue, "true":1, "false":0, 1:1, 0:0, :0)
					}
				} ElseIf tDOMResultName="url" {
					Set pHSFHIRObj.url = tDOMResultValue
				} ElseIf tDOMResultName="id" {
					Set pHSFHIRObj.id = tDOMResultValue
				}
			}
			// Just invoke MoveToElement, don't need to check return value.
			If pDOMResult.MoveToElement()
		}
		
		For {
			For {
				Set tBoolean = pDOMResult.Read()
				If 'tBoolean Quit
				Set tDOMResultName = pDOMResult.LocalName
				Set tDOMResultPath = pDOMResult.Path
				If (tDOMResultName'="")&&(pDOMResult.NodeType'="chars") Quit
			}
			If 'tBoolean Quit
			// We're at the start of the next object in a collection of the main object.
			If tDOMResultPath=pTopPath Quit
			// We're at the start of something that is past all instances of the main object.
			If $Length(tDOMResultPath)<$Length(pTopPath) Quit
			// We're at the start of something that is past all instances of the main object.
			If $Extract(tDOMResultPath,1,$Length(pTopPath))'=pTopPath Quit
			If (tDOMResultName'="div") {
				For {
					If $Data(%propsByName(tHSFHIRClassName, tDOMResultName))=0 {
						Set tSC = $$$ERROR($$$GeneralError, "Invalid property "_tDOMResultName_" on "_tHSFHIRClassName_" object")
						Quit
					}
					Set tHSFHIRPropertyClassName = $Get(%propsByName(tHSFHIRClassName, tDOMResultName, "Type"))
					Set tPropertyObj = $ClassMethod(tHSFHIRPropertyClassName, "%New")
					Set tSC = ..DOMResultToFHIRObj2(pDOMResult, tDOMResultPath, .tPropertyObj)
					If $$$ISERR(tSC) Quit
					If '%propsByName(tHSFHIRClassName, tDOMResultName, "Collection") {
						Set $Property(pHSFHIRObj, tDOMResultName) = tPropertyObj
					} Else {
						Set tSC = $Property(pHSFHIRObj, tDOMResultName).Insert(tPropertyObj)
						If $$$ISERR(tSC) Quit
					}
					If pDOMResult.EOF Quit
					Set tNewDOMResultPath = pDOMResult.Path
					Set tNewDOMResultName = pDOMResult.Name
					// We're at the start of the next object in a collection within the main object.
					If tNewDOMResultPath=tDOMResultPath Continue
					// We're at the start of the next object in a collection of the main object.
					If tNewDOMResultPath=pTopPath Quit
					// We're at the start of something that is past all instances of the main object.
					If $Length(tNewDOMResultPath)<$Length(pTopPath) Quit
					// We're at the start of something that is past all instances of the main object.
					If $Extract(tNewDOMResultPath,1,$Length(pTopPath))'=pTopPath Quit
					// It's the start of the div.
					If $Extract(tNewDOMResultPath,*-3,*)="div\" {
						Set tDivString = "<div xmlns=""http://www.w3.org/1999/xhtml"">"
						Set tSC = ..DOMResultToFHIRObjDiv(pDOMResult, tNewDOMResultPath, .tDivString)
						If $$$ISERR(tSC) Quit
						Set tDivString = tDivString_"</div>"
						Set pHSFHIRObj.div = tDivString
						If pDOMResult.EOF Quit
						Set tNewDOMResultPath = pDOMResult.Path
						If tNewDOMResultPath=pTopPath Quit
						If $Length(tNewDOMResultPath)<$Length(pTopPath) Quit
						If $Extract(tNewDOMResultPath,1,$Length(pTopPath))'=pTopPath Quit
						Continue
					}
					// Otherwise, we're at the start of different property in the current object.
					Set tDOMResultPath = tNewDOMResultPath
					Set tDOMResultName = tNewDOMResultName
				}
				If $$$ISERR(tSC) Quit
				If pDOMResult.EOF Quit
				If tNewDOMResultPath=pTopPath Quit
				If $Length(tNewDOMResultPath)<$Length(pTopPath) Quit
				If $Extract(tNewDOMResultPath,1,$Length(pTopPath))'=pTopPath Quit
			} Else {
				#; Special handling of "div" property. Just gather
				#; everything between div and /div into a string.
				Set tDivString = ""
				Set tSC = ..DOMResultToFHIRObjDiv(pDOMResult, tDOMResultPath, .tDivString)
				If $$$ISERR(tSC) Quit
				Set pHSFHIRObj.div = tDivString
				If pDOMResult.EOF Quit
				If pDOMResult.Path=pTopPath Quit
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Added to allow processing of nested DIVs
ClassMethod DOMResultToFHIRObjDiv(ByRef pDOMResult As %XML.XPATH.DOMResult, pTopPath As %String, Output pDivString As %String) As %Status [ Internal ]
{
	Set tLevel = 1
	While (pDOMResult.Read()) {
		Set tDOMResultNodeType = pDOMResult.NodeType
		Set tDOMResultLocalName = pDOMResult.LocalName
		Set tDOMResultName = pDOMResult.Name
		Set tDOMResultPath = pDOMResult.Path
		If tDOMResultNodeType="element" {
			If tDOMResultPath=pTopPath Quit
			If $Length(tDOMResultPath)<$Length(pTopPath) Quit
			If $Extract(tDOMResultPath,1,$Length(pTopPath))'=pTopPath Quit
			If pDOMResult.HasAttributes=0 {
				If tDOMResultName="div" Set tLevel = tLevel + 1
				Set pDivString = pDivString_"<"_tDOMResultName_">"
			} Else {
				Set tAttString = ""
				For i = 1:1:pDOMResult.AttributeCount {
					Set tBoolean = pDOMResult.MoveToAttributeIndex(i)
					If 'tBoolean Quit
					Set tAttString = tAttString_" "_tDOMResultName_"="""_$ZConvert(pDOMResult.Value,"O","HTML")_""""
				}
				Set tBoolean = pDOMResult.MoveToElement()
				If tDOMResultLocalName="div" Set tLevel = tLevel + 1
				Set pDivString = pDivString_"<"_tDOMResultName_tAttString_">"
			}
		} ElseIf tDOMResultNodeType="chars" {
			Set pDivString = pDOMResult.Value
		}
	}
	Set pDivString = pDivString_"</"_tDOMResultName_">"
	Quit $$$OK
}

ClassMethod DOMResultToNameAndAtts(pReader As %XML.XPATH.DOMResult, Output pName As %String, Output pValue As %String, Output pUrl As %String, Output pId As %String)
{
	Set tSC = $$$OK
	
	Set pName = ""
	Set pValue = ""
	Set pUrl = ""
	Set pId = ""
	
	Try {
		If pReader.ReadState'="initial" {
			Set tSC = $$$ERROR($$$GeneralError, "Result input not passed in intial read state")
			Quit
		}
		
		Set tBoolean = pReader.Read()
		If 'tBoolean {
			Set tSC = $$$ERROR($$$GeneralError, "No data found in result input")
			Quit
		}
		
		If pReader.NodeType'="element" {
			Set tSC = $$$ERROR($$$GeneralError, "Result input does not start with an element")
			Quit
		}
		
		Set pName = pReader.LocalName
		
		If pReader.MoveToAttributeName("value") Set pValue = pReader.Value
		
		If pReader.MoveToAttributeName("url") Set pUrl = pReader.Value
		
		If pReader.MoveToAttributeName("id") Set pId = pReader.Value
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

/// API
/// SerializeResourceObject takes a FHIR %XML.Document object or %DynamicObject as input and
/// serializes it as XML or JSON (depending on the object type) to the specified stream object.<br>
/// <br>
/// Input:<br>
/// <li>pResourceObject : (required) FHIR %XML.Document object or %DynamicObject.
/// <li>pFormatOption   : (optional) Applies only to XML.
///                       0 = No formatting (i.e., strip existing indent and line end formatting).
///                       1 = Add tab indent and line-feed-only line end formatting.
///                       2 = Add tab indent and carriage return line feed line end formatting.
/// <li>pTransformer    : (optional) Applies only to XML, and only when pFormatOption is not 0.
///                       Transformer object to use for applying XML tab indent and line end formatting.
/// <li>pIndentChars    : (optional) Indent character(s) to use for each line in the XML output.
/// <li>pLineTerminator : (optional) Line terminator character(s) to use for the XML output.<br>
/// <br><br>
/// Output:<br>
/// <li>pResourceStream : FHIR Stream object to use for FHIR output. This object may be passed
///                       in as an new stream object. Otherwise this method will initialize it
///                       as a %Stream.TmpCharacter.<br>
ClassMethod SerializeResourceObject(pResourceObject, pFormatOption As %Integer = 0, pTransformer, pIndentChars As %String = "", pLineTerminator As %String = "", ByRef pResourceStream) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pResourceStream)) Set pResourceStream = ##class(%Stream.TmpCharacter).%New()
		
		If pResourceObject.%IsA("%Library.DynamicObject") {
			Do pResourceObject.%ToJSON(.pResourceStream)
			Do pResourceStream.Rewind()
			If pResourceStream.Size>0 {
				If (pIndentChars'="")&&(pLineTerminator'="") {
					Set tTempStream = ##class(%Stream.TmpCharacter).%New()
					Set tSC = ..FormatJSON(pResourceStream, .tTempStream, pIndentChars, pLineTerminator)
					If $$$ISERR(tSC) Quit
					Set tSC = pResourceStream.Clear()
					If $$$ISERR(tSC) Quit
					Set tSC = pResourceStream.CopyFrom(tTempStream)
					If $$$ISERR(tSC) Quit
				}
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Unable to make JSON stream for resource object")
				Quit
			}
		} ElseIf pResourceObject.%IsA("%XML.Document") {
			Set tSC = ..SerializeXMLDocument(pResourceObject, .pResourceStream, pFormatOption, $Get(pTransformer))
		} Else {
			
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// SerializeXMLDocument takes an %XML.Document object as input and exports the serialized
/// XML to the specified stream object.
/// <br>
/// Input:<br>
/// <li>pXMLDocument  : (required) %XML.Document object containing the FHIR resource.<br>
/// <li>pFormatOption : (required)
///                      0 = No formatting (i.e., strip existing indent and line end formatting).
///                      1 = Add tab indent and line-feed-only line end formatting.
///                      2 = Add tab indent and carriage return line feed line end formatting.
/// <li>pTransformer  : Required only if pFormatOption is not 0.  Transformer object to use
///                     for XSLT transformation to apply indent and line end formatting.
/// <br><br>
/// Output:<br>
/// <li>pXMLStream    : Stream object to use for FHIR XML output. This object may be passed
///                     in as an new stream object. Otherwise this method will initialize it
///                     as a %Stream.TmpCharacter.<br>
ClassMethod SerializeXMLDocument(pXMLDocument As %XML.Document, ByRef pXMLStream, pFormatOption As %Integer = 0, pTransformer) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pXMLStream)) Set pXMLStream = ##class(%Stream.TmpCharacter).%New()
		
		// Input to SerializeNode:
		// - tree         = pXMLDocument.DocumentId
		// - node         = pXMLDocument.GetDocumentElement().NodeId
		// - outputstream = 1 (yes, output to stream)
		// - mixed        = 1 (use XML translate table)
		// - includetop   = 1
		// - linemode     = 0
		//
		// The "line mode" output of SerializeNode does not work as desired. Therefore
		// if indent and line end formatting is desired then the FormatXML
		// method will be used to apply formatting.
		Set tSC = ##class(%XML.ImportHandler).SerializeNode(pXMLDocument.DocumentId,pXMLDocument.GetDocumentElement().NodeId,1,1,.pXMLStream,1,0)
		If $$$ISERR(tSC) Quit
		
		If (pFormatOption=1)||(pFormatOption=2) {
			If '$IsObject($Get(pTransformer)) {
				Set pTransformer = ##class(HS.Util.XSLTTransformer).%New()
			}
			Set tSC = ##class(HS.FHIR.Utils).FormatXML(pXMLStream, .tTempXMLStream, pTransformer, pFormatOption)
			If $$$ISERR(tSC) Quit
			Kill pXMLStream
			Set pXMLStream = tTempXMLStream
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// API
/// SerializeXMLNode takes an %XML.Document object and a %XML.Node iterator object from that
/// %XML.Document as input. Basically, serialize just a specific tree within the XML document.
/// It exports the serialized XML to the specified stream object.
/// <br>
/// Input:<br>
/// <li>pXMLDocument  : (required) %XML.Document object containing the FHIR resource.<br>
/// <li>pFormatOption : (required)
///                      0 = No formatting (i.e., strip existing indent and line end formatting).
///                      1 = Add tab indent and line-feed-only line end formatting.
///                      2 = Add tab indent and carriage return line feed line end formatting.
/// <li>pTransformer  : Required only if pFormatOption is not 0.  Transformer object to use
///                     for XSLT transformation to apply indent and line end formatting.
/// <br><br>
/// Output:<br>
/// <li>pXMLStream    : Stream object to use for FHIR XML output. This object may be passed
///                     in as an new stream object. Otherwise this method will initialize it
///                     as a %Stream.TmpCharacter.<br>
ClassMethod SerializeXMLNode(pXMLDocument As %XML.Document, pXMLNode As %XML.Node, ByRef pXMLStream, pFormatOption As %Integer = 0, pTransformer) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pXMLStream)) Set pXMLStream = ##class(%Stream.TmpCharacter).%New()
		
		// Input to SerializeNode:
		// - tree         = pXMLDocument.DocumentId
		// - node         = pXMLDocument.GetDocumentElement().NodeId
		// - outputstream = 1 (yes, output to stream)
		// - mixed        = 1 (use XML translate table)
		// - includetop   = 1
		// - linemode     = 0
		//
		// The "line mode" output of SerializeNode does not work as desired. Therefore
		// if indent and line end formatting is desired then the FormatXML
		// method will be used to apply formatting.
		Set tSC = ##class(%XML.ImportHandler).SerializeNode(pXMLDocument.DocumentId,pXMLNode.NodeId,1,1,.pXMLStream,1,0)
		If $$$ISERR(tSC) Quit
		
		If (pFormatOption=1)||(pFormatOption=2) {
			If '$IsObject($Get(pTransformer)) {
				Set pTransformer = ##class(HS.Util.XSLTTransformer).%New()
			}
			Set tSC = ##class(HS.FHIR.Utils).FormatXML(pXMLStream, .tTempXMLStream, pTransformer, pFormatOption)
			If $$$ISERR(tSC) Quit
			Kill pXMLStream
			Set pXMLStream = tTempXMLStream
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// FHIRXMLDivString parses the div of a FHIR XML resource and builds and returns
/// a string that represents the div xhtml with whitespace preserved.
ClassMethod FHIRXMLDivString(pNode As %XML.Node, ByRef pDivString As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		For {
			Set tNodeType = pNode.NodeType
			
			If tNodeType=$$$xmlELEMENTNODE {
				Set tPropName = pNode.LocalName
				Set pDivString = pDivString_"<"_tPropName
				Set tNumAtt = pNode.GetNumberAttributes()
				Set tHasChild = pNode.HasChildNodes()
				If tNumAtt>0 {
					Set tAttName = ""
					For {
						Set tAttName = pNode.NextAttributeName(tAttName)
						If tAttName="" Quit
						Set tAttValue = pNode.GetAttributeValue(tAttName)
						Set pDivString = pDivString_" "_tAttName_"="""_$ZConvert(tAttValue,"O","HTML")_""""
					}
				}
				If tHasChild {
					Set pDivString = pDivString_">"
					Set tSaveNodeId = pNode.NodeId
					Set tBoolean = pNode.MoveToFirstChild()
					Set tSC = ..FHIRXMLDivString(pNode, .pDivString)
					If $$$ISERR(tSC) Quit
					Set pNode.NodeId = tSaveNodeId
					Set pDivString = pDivString_"</"_tPropName_">"
					Set tBoolean = pNode.MoveToNextSibling()
				} Else {
					Set pDivString = pDivString_">"
					Set tBoolean = pNode.MoveToNextSibling()
				}
				If tBoolean=0 Quit
			} Else {
				// is $$$xmlTEXTNODE or $$$xmlWHITESPACENODE
				Set pDivString = pDivString_pNode.NodeData
				If 'pNode.MoveToNextSibling() Quit
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// API
/// ValidateResourceTypeFHIR validates the specified resource type against the specified HS FHIR data model class package.
/// <br>
/// Input:<br>
/// <li>pResourceType       : (required) FHIR resource type.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br><br>
/// Output:<br>
/// <li>pIsValid            : 0 = Is not a valid resource type as per the specified schema, 1 = Is valid.
ClassMethod ValidateResourceTypeFHIR(pResourceType As %String, pResourceSchemaRoot As %String, ByRef pIsValid As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Set pIsValid = 0
	
	Try {
		If $$$defClassDefined(pResourceSchemaRoot_"."_pResourceType) Set pIsValid = 1
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// ValidateResourceTypeCapability validates the specified resource type against the specified
/// Conformance/CapabilityStatement.
/// <br>
/// Input:<br>
/// <li>pResourceType        : (required) FHIR resource type.
/// <li>pCapabilityStatement : (required) %XML.XPATH.Document representation of a FHIR Conformance/CapabilityStatement resource.
/// <br><br>
/// Output:<br>
/// <li>pIsValid             : 0 = Is not a valid resource type as per the specified Conformance/CapabilityStatement,
///                            1 = Is valid.
ClassMethod ValidateResourceTypeCapability(pResourceType As %String, pCapabilityStatement, ByRef pIsValid As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Set pIsValid = 0
	
	Try {
		If pCapabilityStatement="" Set pIsValid = 1 Quit
		
		If ('$IsObject(pCapabilityStatement))||('pCapabilityStatement.%IsA("%XML.XPATH.Document")) {
			Set tSC = $$$ERROR($$$GeneralError, "Input statement resource must be an %XML.XPATH.Document object")
			Quit
		}
		
		// Get the resource type by getting the name of the root element.
		Set tSC = pCapabilityStatement.EvaluateExpression("/*", "name()", .tResults)
		If $$$ISERR(tSC) Quit
		If ('$IsObject(tResults))||(tResults.Count()=0)||(tResults.GetAt(1).Value="") {
			Set tSC = $$$ERROR($$$GeneralError,"Could not get statement resource type")
			Quit
		}
		Set tCapabilityResourceType = tResults.GetAt(1).Value
		
		Set tSC = pCapabilityStatement.EvaluateExpression("/f:"_tCapabilityResourceType_"/f:rest[f:mode/@value='server']/f:resource[f:type/@value='"_pResourceType_"']", "f:type/@value", .tResults)
		If ($$$ISOK(tSC))&&($IsObject($Get(tResults)))&&(tResults.Count()>0)&&(tResults.GetAt(1).Value=pResourceType) {
			Set pIsValid = 1
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetBundleTypeFromResource takes %DynamicObject or %XML.Document object representation of a
/// FHIR Bundle as input, finds the 'type' property of the Bundle, and returns it.
ClassMethod GetBundleTypeFromResource(pResourceObject, Output pBundleType As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pBundleType = ""
	
	Try {
		If pResourceObject.%IsA("%Library.DynamicAbstractObject") {
			Set pBundleType = pResourceObject.type
		} ElseIf pResourceObject.%IsA("%XML.Document") {
			#dim tNode As %XML.Node
			Set tNode = pResourceObject.GetDocumentElement()
			// Try to move to the first child node, quit if no child nodes.
			If 'tNode.MoveToFirstChild(1) Quit
			For {
				Set tPropName = tNode.LocalName
				If tPropName="type" {
					Set pBundleType = tNode.GetAttributeValue("value")
					Quit
				}
				// Try to move to the next sibling on this level, quit if no more siblings.
				If 'tNode.MoveToNextSibling(1) Quit
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR resource object type "_pResourceObject.%ClassName(1))
		}
				
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetResourceMetaFromResource retrieves the resource meta property object of a given FHIR resource.
/// The resource may be supplied to this method as a stream object, a string, a %DynamicObject or an
/// %XML.Document object.<br>
/// <br>
/// Input:<br>
/// <li>pContentType    : (required if not providing pResourceObject) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceStream : (required if not providing pResourceObject) FHIR resource stream object or string.
/// <li>pResourceObject : (required if not providing pResourceStream) %DynamicObject or %XML.Document object
///                       representation of the FHIR resource.
/// <li>pResourceSchema : (required) Class package to use as the resource schema.
///                       Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br><br>
/// Output:<br>
/// <li>pResourceMeta   : FHIR meta object from the resource.
ClassMethod GetResourceMetaFromResource(pContentType As %String = "", pResourceStream, pResourceObject, pResourceSchema, Output pResourceMeta) As %Status
{
	Set tSC = $$$OK
	
	Set pResourceMeta = ""
	
	Try {
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "meta")
		
		Set tSC = ..GetResourceInfo(pContentType, $Get(pResourceStream), $Get(pResourceObject), $Get(pResourceSchema), .tProperties)
		If $$$ISERR(tSC) Quit
		
		Set pResourceMeta = tProperties.GetAt("meta")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetResourceIdFromResource retrieves the resource id of a given FHIR resource. The resource may be 
/// supplied to this method as a stream object, a string, a %DynamicObject or an %XML.Document object.<br>
/// <br>
/// Input:<br>
/// <li>pContentType    : (required if not providing pResourceObject) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceStream : (required if not providing pResourceObject) FHIR resource stream object or string.
/// <li>pResourceObject : (required if not providing pResourceStream) %DynamicObject or %XML.Document object
///                       representation of the FHIR resource.
/// <br><br>
/// Output:<br>
/// <li>pResourceId     : FHIR resource id.
ClassMethod GetResourceIdFromResource(pContentType As %String = "", pResourceStream, pResourceObject, Output pResourceId As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pResourceId = ""
	
	Try {
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("","id")
		
		Set tSC = ..GetResourceInfo(pContentType, $Get(pResourceStream), $Get(pResourceObject), , .tProperties)
		If $$$ISERR(tSC) Quit
		
		Set pResourceId = tProperties.GetAt("id")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetResourceInfo retrieves specified base information on a given FHIR resource. The resource may be
/// supplied to this method as a stream object, a string, a %DynamicObject or an %XML.Document object.
/// The properties available for retrieval via this method are:<br>
/// <li>resourceType (string)
/// <li>id (string)
/// <li>meta (object)
/// <li>implicitRules (string)
/// <li>language (string)
/// <li>text (object)
/// <br>
/// <br>
/// The caller specifies the desired properties by creating entries for them in the <var>pProperties</var>
/// input %ArrayOfDataTypes. GetResourceInfo returns the values in the respective <var>pProperties</var>
/// array entries.
/// <br><br>
/// Usage example - assume a resource stream available in this example:<br>
/// <br>
/// <code>
/// Set pContentType = "xml"<br>
/// Set pResourceSchema = "HS.FHIR.vSTU3.Model.Resource"
/// Set pProperties = ##class(%Library.ArrayOfDataTypes).%New()<br>
/// Do pProperties.SetAt("","resourceType")<br>
/// Do pProperties.SetAt("","id")<br>
/// Do pProperties.SetAt("","meta")<br>
/// Do pProperties.SetAt("","text")<br>
/// Set Status = ##class(HS.FHIR.Utils).GetResourceInfo(pContentType, pResourceStream, , pResourceSchema, pProperties)<br>
/// Write !,pProperties.GetAt("id")<br>
/// Write !,pProperties.GetAt("meta").versionId.value<br>
/// </code>
/// <br>
/// Input:<br>
/// <li>pContentType    : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceStream : (required if not providing pResourceObject) FHIR resource stream object or string.
/// <li>pResourceObject : (required if not providing pResourceStream) %DynamicObject or %XML.Document object
///                       representation of the FHIR resource.
/// <li>pResourceSchema : (required if requesting "meta" or "text" properties) Class package
///                       to use as the resource schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pProperties     : (required) %ArrayOfDataTypes of properties to retrieve.
/// <br><br>
/// Output:<br>
/// <li>pProperties     : This array is returned with the entries populated with the data found.
ClassMethod GetResourceInfo(pContentType, pResourceStream, pResourceObject, pResourceSchema As %String, ByRef pProperties As %Library.ArrayOfDataTypes) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If ($Get(pResourceStream)="")&&('$Get(pResourceObject)) {
			Set tSC = $$$ERROR($$$GeneralError, "Neither resource stream nor resource object specified")
			Quit
		}
		
		If ($Get(pContentType)="")&&('$IsObject($Get(pResourceObject))) {
			Set tSC = $$$ERROR($$$GeneralError, "Content type not specified")
			Quit
		}
		
		If '$IsObject($Get(pProperties))||('pProperties.%IsA("%Library.ArrayOfDataTypes")) {
			Set tSC = $$$ERROR($$$GeneralError, "Properties input must be %ArrayOfDataTypes")
			Quit
		}
		
		Set tKey = ""
		For {
			Set tValue = pProperties.GetNext(.tKey)
			If tKey="" Quit
			Set tPropArray(tKey) = ""
		}
		
		Merge tRemainingProperties = tPropArray
		
		// If stream provided but pResourceObject not provided, then make the object.
		If ($Get(pResourceStream)'="")&&('$IsObject($Get(pResourceObject))) {
			If '$IsObject(pResourceStream) {
				Set tTempStream = ##class(%Stream.TmpCharacter).%New()
				
				Set tSC = tTempStream.Write(pResourceStream)
				If $$$ISERR(tSC) Quit
				
				Do tTempStream.Rewind()
			} Else {
				Set tTempStream = pResourceStream
			}
			Kill pResourceObject
			Set tSC = ..CreateResourceObject(pContentType, tTempStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		}
		
		If pResourceObject.%IsA("%Library.DynamicAbstractObject") {
			// These are the string properties. This assumes no extensions on any of these.
			For tPropName = "resourceType", "id", "implicitRules", "language" {
				If $Data(tPropArray(tPropName)) {
					Set tPropArray(tPropName) = pResourceObject.%Get(tPropName)
					Kill tRemainingProperties(tPropName)
					If $Data(tRemainingProperties)=0 Quit
				}
			}
			If $Data(tRemainingProperties) {
				// If the %DynamicObject meta object is requested and is present, then make
				// an HS FHIR object from it and return the oref in the array.
				If ($Data(tPropArray("meta")))&&(pResourceObject.meta'="") {
					Set tSC = ..GetSchemaForResourceProperty(pResourceSchema, , "meta", .tSchema)
					If $$$ISERR(tSC) Quit
					Set tMeta = $ClassMethod(tSchema, "%New")
					Set tSC = ##class(HS.JSON.AdaptorFHIR).%FromFHIRJSON2(pResourceObject.meta, .tMeta)
					If $$$ISERR(tSC) Quit
					Set tPropArray("meta") = tMeta
					Kill tRemainingProperties("meta")
				}
				If $Data(tRemainingProperties) {
					// If the %DynamicObject text object is requested and is present, then make
					// an HS FHIR object from it and return the oref in the array.
					If ($Data(tPropArray("text")))&&(pResourceObject.text'="") {
						Set tSC = ..GetSchemaForResourceProperty(pResourceSchema, , "text", .tSchema)
						If $$$ISERR(tSC) Quit
						Set tText = $ClassMethod(tSchema, "%New")
						Set tSC = ##class(HS.JSON.AdaptorFHIR).%FromFHIRJSON2(pResourceObject.text, .tText)
						If $$$ISERR(tSC) Quit
						Set tPropArray("text") = tText
						Kill tRemainingProperties("text")
					}
				}
			}
			
		} ElseIf pResourceObject.%IsA("%XML.Document") {
			#dim tNode As %XML.Node
			Set tDomainResourceProps = ",id,meta,implicitRules,language,text,contained,extension,modifierExtension,"
			Set tNode = pResourceObject.GetDocumentElement()
			If $Data(tPropArray("resourceType")) {
				Set tPropArray("resourceType") = tNode.LocalName
				Kill tRemainingProperties("resourceType")
			}
			If $Data(tRemainingProperties) {
				// Try to move to the first child node, quit if no child nodes.
				If 'tNode.MoveToFirstChild(1) Quit
				For {
					// A well-formed FHIR XML will have all the DomainResource properties first.
					// If the property name is not one of the DomainResource property names
					// then we will assume that we are past all of them. This helps prevent
					// looping through a very large resource (e.g., Bundle with thousands of
					// of entries) just because one of the requested properties was not present.
					Set tPropName = tNode.LocalName
					If tDomainResourceProps'[(","_tPropName_",") Quit
					If ((tPropName="id")||(tPropName="implicitRules")||(tPropName="language"))&&($Data(tPropArray(tPropName))) {
						Set tPropArray(tPropName) = tNode.GetAttributeValue("value")
						Kill tRemainingProperties(tPropName)
						If $Data(tRemainingProperties)=0 Quit
					} ElseIf (tPropName="meta")&&($Data(tPropArray(tPropName))) {
						Set tSC = ..GetSchemaForResourceProperty(pResourceSchema, , "meta", .tSchema)
						If $$$ISERR(tSC) Quit
						Set tMeta = $ClassMethod(tSchema, "%New")
						Set tSC = ##class(HS.XML.AdaptorFHIR).%FromFHIRXML2(tNode, .tMeta)
						If $$$ISERR(tSC) Quit
						Set tPropArray(tPropName) = tMeta
						Kill tRemainingProperties(tPropName)
						If $Data(tRemainingProperties)=0 Quit
					} ElseIf (tPropName="text")&&($Data(tPropArray(tPropName))) {
						Set tSC = ..GetSchemaForResourceProperty(pResourceSchema, , "text", .tSchema)
						If $$$ISERR(tSC) Quit
						Set tText = $ClassMethod(tSchema, "%New")
						Set tSC = ##class(HS.XML.AdaptorFHIR).%FromFHIRXML2(tNode, .tText)
						If $$$ISERR(tSC) Quit
						Set tPropArray(tPropName) = tText
						Kill tRemainingProperties(tPropName)
						If $Data(tRemainingProperties)=0 Quit
					}
					// Try to move to the next sibling on this level, quit if no more siblings.
					If 'tNode.MoveToNextSibling(1) Quit
				}
			}
			
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR resource object type "_pResourceObject.%ClassName(1))
		}
		
		Set tKey = ""
		For {
			Set tKey = $Order(tPropArray(tKey))
			If tKey="" Quit
			Do pProperties.SetAt(tPropArray(tKey), tKey)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// UpdateResourceId updates the FHIR resource id in a previously-established %DynamicObject
/// or %XML.Document representation of the resource.<br>
/// <br>
/// Input:<br>
/// <li>pResourceObject : (required) %DynamicObject or %XML.Document representation of the resource.
/// <li>pResourceId     : (required) The resource id to set into the resource.
/// <br><br>
/// Output:<br>
/// <li>pResourceObject : The updated resource object.
ClassMethod UpdateResourceId(ByRef pResourceObject, pResourceId As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pResourceObject.%IsA("%Library.DynamicAbstractObject") {
			Do pResourceObject.%Set("id", pResourceId, "string")
		} ElseIf pResourceObject.%IsA("%XML.Document") {
			#dim tResourceNode As %XML.Node
			#dim tNode As %XML.Node
			Set tResourceNode = pResourceObject.GetDocumentElement()
			Set tNode = pResourceObject.GetDocumentElement()
			// Try to move to the first child node, quit if no child nodes.
			If 'tNode.MoveToFirstChild(1) Quit
			// FHIR says that in XML the id, if present, must be the first element.
			If tNode.LocalName="id" {
				Do tNode.SetAttribute("value", , pResourceId)
			} Else {
				Set tString = tResourceNode.InsertElement("id", , tNode.NodeId)
				Set tBoolean = tResourceNode.MoveToFirstChild(1)
				Do tResourceNode.SetAttribute("value", , pResourceId)
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// UpdateResourceMeta updates the FHIR resource meta object property in a previously-established
/// %DynamicObject or %XML.Document representation of the resource.<br>
/// <br>
/// Input:<br>
/// <li>pResourceObject : (required) %DynamicObject or %XML.Document representation of the resource.
/// <li>pResourceMeta   : The resource meta object to set into the resource.
/// <br><br>
/// Output:<br>
/// <li>pResourceObject : The updated resource object.
ClassMethod UpdateResourceMeta(ByRef pResourceObject, pResourceMeta) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tBaseSchema = $Piece(pResourceMeta.%ClassName(1),".",1,$Length(pResourceMeta.%ClassName(1),".")-1)
		
		// Wrap the meta object up in a resource so that we can use HSFHIRToFHIR as is,
		// to turn the meta object into a FHIR XML or JSON stream.
		Set tResource = $ClassMethod(tBaseSchema_".Resource", "%New")
		Set tResource.meta = pResourceMeta
		
		If pResourceObject.%IsA("%Library.DynamicObject") {
			Set tContentType = "json"
		} Else {
			Set tContentType = "xml"
		}
		
		Set tResourceMetaStream = ##class(%Stream.TmpCharacter).%New()
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(tContentType, tResource, .tResourceMetaStream, 0)
		If $$$ISERR(tSC) Quit
		
		If pResourceObject.%IsA("%Library.DynamicAbstractObject") {
			// Make a %DynamicObject from the FHIR JSON stream, and put the meta object
			// from that object into pResourceObject.
			Set tJSONObject = ##class(%Library.DynamicObject).%FromJSON(tResourceMetaStream)
			If '$IsObject($Get(tJSONObject)) {
				Set tSC = $$$ERROR($$$GeneralError, "Could not create JSON object from meta stream")
			} ElseIf '$IsObject(tJSONObject.meta) {
				Set tSC = $$$ERROR($$$GeneralError, "meta object not found in JSON object")
			} ElseIf 'tJSONObject.meta.%IsA("%Library.DynamicObject") {
				Set tSC = $$$ERROR($$$GeneralError, "meta object is not a dynamic object")
			}
			If $$$ISERR(tSC) Quit
			Set pResourceObject.meta = tJSONObject.meta
		} ElseIf pResourceObject.%IsA("%XML.Document") {
			// Make a %XML.Node object from the FHIR XML stream, and put the meta tree
			// from that object into pResourceObject.
			#dim tMetaDocument As %XML.Document
			#dim tMetaNode As %XML.Node
			#dim tNode As %XML.Node
			Set tSC = ..CreateXMLDocument(tResourceMetaStream, .tMetaDocument)
			If $$$ISERR(tSC) Quit
			Set tMetaNode = tMetaDocument.GetDocumentElement()
			// Try to move to the first child node, quit if no child nodes.
			If 'tMetaNode.MoveToFirstChild(1) Quit
			Set tResourceNode = pResourceObject.GetDocumentElement()
			Set tNode = pResourceObject.GetDocumentElement()
			// Try to move to the first child of the resource element, quit if no child nodes.
			If 'tNode.MoveToFirstChild(1) Quit
			// In a well-formed FHIR XML, id and meta - if they are present - are the first
			// two elements in the resource. If we find id, skip it. If we find meta, replace
			// it. Otherwise if the current property is neither, then insert meta and quit.
			For {
				If tNode.LocalName="id" {
					// Try to move to the next sibling on this level, quit if no more siblings.
					If 'tNode.MoveToNextSibling(1) Quit
					Continue
				} ElseIf tNode.LocalName="meta" {
					Set tSC = tNode.ReplaceTree(tMetaNode)
				} Else {
					Do tResourceNode.InsertTree(tMetaNode, tNode.NodeId, .tSC)
				}
				Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// ValidateResourceInteraction validates the specified interaction on the specified FHIR resource type
/// against the specified Conformance/CapabilityStatement.<br>
/// <br>
/// Input:<br>
/// <li>pResourceType        : (required) FHIR resource type.
/// <li>pInteraction         : (required) FHIR RESTful interaction.
/// <li>pCapabilityStatement : (required) %XML.XPATH.Document representation of a FHIR Conformance/CapabilityStatement resource.
/// <br><br>
/// Output:<br>
/// <li>pIsValid             : 0 = Is not a valid or supported interaction on the resource type as per
///                            the specified Conformance/CapabilityStatement, 1 = Is valid.
ClassMethod ValidateResourceInteraction(pResourceType As %String, pInteraction As %String, pCapabilityStatement, ByRef pIsValid As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Set pIsValid = 0
	
	Try {
		// Default implementation of this method expects pCapabilityStatement to be
		// either blank or an %XML.XPATH.Document object.
		
		If pCapabilityStatement="" Set pIsValid = 1 Quit
		
		If ('$IsObject(pCapabilityStatement))||('pCapabilityStatement.%IsA("%XML.XPATH.Document")) {
			Set tSC = $$$ERROR($$$GeneralError, "Input statement resource must be an %XML.XPATH.Document object")
			Quit
		}
		
		// Get the resource type by getting the name of the root element.
		Set tSC = pCapabilityStatement.EvaluateExpression("/*", "name()", .tResults)
		If $$$ISERR(tSC) Quit
		If ('$IsObject(tResults))||(tResults.Count()=0)||(tResults.GetAt(1).Value="") {
			Set tSC = $$$ERROR($$$GeneralError,"Could not get statement resource type")
			Quit
		}
		Set tCapabilityResourceType = tResults.GetAt(1).Value
		
		Set tSC = pCapabilityStatement.EvaluateExpression("/f:"_tCapabilityResourceType_"/f:rest[f:mode/@value='server']/f:resource[f:type/@value='"_pResourceType_"']/f:interaction[f:code/@value='"_pInteraction_"']", "f:code/@value", .tResults)
		If ($$$ISOK(tSC))&&($IsObject($Get(tResults)))&&(tResults.Count()>0)&&(tResults.GetAt(1).Value=pInteraction) {
			Set pIsValid = 1
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// ValidateSystemInteraction validates the specified interaction on the Conformance/CapabilityStatement
/// server definition.<br>
/// <br>
/// Input:<br>
/// <li>pInteraction         : (required) FHIR RESTful interaction.
/// <li>pCapabilityStatement : (required) %XML.XPATH.Document representation of a FHIR Conformance/CapabilityStatement resource.
/// <br><br>
/// Output:<br>
/// <li>pIsValid             : 0 = Is not a valid or supported interaction on the system type as per
///                            the specified Conformance/CapabilityStatement, 1 = Is valid.
ClassMethod ValidateSystemInteraction(pInteraction As %String, pCapabilityStatement, ByRef pIsValid As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Set pIsValid = 0
	
	Try {
		// Default implementation of this method expects pCapabilityStatement to be
		// either blank or an %XML.XPATH.Document object.
		
		If pCapabilityStatement="" Set pIsValid = 1 Quit
		
		If ('$IsObject(pCapabilityStatement))||('pCapabilityStatement.%IsA("%XML.XPATH.Document")) {
			Set tSC = $$$ERROR($$$GeneralError, "Input statement resource must be an %XML.XPATH.Document object")
			Quit
		}
		
		// Get the resource type by getting the name of the root element.
		Set tSC = pCapabilityStatement.EvaluateExpression("/*", "name()", .tResults)
		If $$$ISERR(tSC) Quit
		If ('$IsObject(tResults))||(tResults.Count()=0)||(tResults.GetAt(1).Value="") {
			Set tSC = $$$ERROR($$$GeneralError,"Could not get statement resource type")
			Quit
		}
		Set tCapabilityResourceType = tResults.GetAt(1).Value
		
		Set tSC = pCapabilityStatement.EvaluateExpression("/f:"_tCapabilityResourceType_"/f:rest[f:mode/@value='server']/f:interaction[f:code/@value='"_pInteraction_"']", "f:code/@value", .tResults)
		If ($$$ISOK(tSC))&&($IsObject($Get(tResults)))&&(tResults.Count()>0)&&(tResults.GetAt(1).Value=pInteraction) {
			Set pIsValid = 1
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetResourceCapabilityItem examines the specified Conformance/CapabilityStatement for the
/// the specified resource type and returns the value for the specified "capability item".<br>
/// <br>
/// Input:<br>
/// <li>pResourceType        : (required) FHIR resource type.
/// <li>pCapabilityItem      : (required) Resource type capability item (examples: "conditionalCreate", "readHistory").
/// <li>pCapabilityStatement : (required) %XML.XPATH.Document representation of a FHIR Conformance/CapabilityStatement resource.
/// <br><br>
/// Output:<br>
/// <li>pValue               : Value for the specified capability item. If the item was not found then
///                            this will be returned as blank.
ClassMethod GetResourceCapabilityItem(pResourceType As %String, pCapabilityItem As %String, pCapabilityStatement, ByRef pValue As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pValue = 0
	
	Try {
		// Default implementation of this method expects pCapabilityStatement to be
		// provided as an %XML.XPATH.Document object.
		
		If pCapabilityStatement="" {
			Set tSC = $$$ERROR($$$GeneralError, "Statement resource not specified")
			Quit
		}
		
		If ('$IsObject(pCapabilityStatement))||('pCapabilityStatement.%IsA("%XML.XPATH.Document")) {
			Set tSC = $$$ERROR($$$GeneralError, "Input statement resource must be an %XML.XPATH.Document object")
			Quit
		}
		
		// Get the resource type by getting the name of the root element.
		Set tSC = pCapabilityStatement.EvaluateExpression("/*", "name()", .tResults)
		If $$$ISERR(tSC) Quit
		If ('$IsObject(tResults))||(tResults.Count()=0)||(tResults.GetAt(1).Value="") {
			Set tSC = $$$ERROR($$$GeneralError,"Could not get statement resource type")
			Quit
		}
		Set tCapabilityResourceType = tResults.GetAt(1).Value
		
		Kill tResults
		
		Set tSC = pCapabilityStatement.EvaluateExpression("/f:"_tCapabilityResourceType,"f:rest[f:mode/@value='server']/f:resource[f:type/@value='"_pResourceType_"']/f:"_pCapabilityItem_"/@value", .tResults)
		If ($$$ISOK(tSC))&&($IsObject($Get(tResults)))&&(tResults.Count()>0) {
			Set pValue = tResults.GetAt(1).Value
			Set pValue = $CASE(pValue, "true":1, "false":0, :pValue)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// CreateResourceObject uses the specified FHIR resource stream and content type to create
/// either a %DynamicObject or %XML.Document object representation of the resource.<br>
/// <br>
/// Input:<br>
/// <li>pContentType    : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceStream : (required) FHIR resource JSON or XML stream object.
/// <br><br>
/// Output:<br>
/// <li>pResourceObject : The FHIR resource object that is created by this method call.  If pContentType
///                       indicates FHIR JSON then this will be a %DynamicObject, or if pContentType
///                       indicates FHIR XML then this will be an %XML.Document object.
ClassMethod CreateResourceObject(pContentType As %String, pResourceStream, ByRef pResourceObject) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tContentType = $ZConvert(pContentType,"L")
		If (tContentType'["xml")&&(tContentType'["json") {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid ContentType specified")
			Quit
		}
		If tContentType["json" {
			Set pResourceObject = ##class(%DynamicObject).%FromJSON(pResourceStream)
			If '$IsObject($Get(pResourceObject)) {
				Set tSC = $$$ERROR($$$GeneralError, "Could not create object from FHIR JSON stream")
				Quit
			}
		} Else {
			Set tSC = ..CreateXMLDocument(pResourceStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		}
		
		Do pResourceStream.Rewind()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// This method creates an %XML.Document object from the specified FHIR XML resource stream.
ClassMethod CreateXMLDocument(pResourceStream, ByRef pXMLDocument As %XML.Document) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		// This methodology is used instead of the %XML.Document GetDocumentFromStream()
		// class method because this enables us to get a %XML.Document object with the
		// KeepWhitespace property set to 0.
		Set tReader = ##class(%XML.Reader).%New()
		Set tReader.SAXFlags = $$$SAXFULLDEFAULT-$$$SAXVALIDATIONSCHEMA
		Set tReader.KeepWhitespace = 0
		Set tSC = tReader.OpenStream(pResourceStream)
		If $$$ISERR(tSC) Quit
		Set pXMLDocument = tReader.Document
		If '$IsObject($Get(pXMLDocument)) {
			Set tSC = $$$ERROR($$$GeneralError, "Could not create object from FHIR XML stream")
			Quit
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetTypeForXPath evaluates a given FHIR resource XPath spec against a specified FHIR
/// resource schema and returns the FHIR data model class type for the XPath element.<br>
/// <br>
/// Input:<br>
/// <li>pXPath              : (required) XPath expression relating to a given FHIR resource type.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br><br>
/// Output:<br>
/// <li>pType               : FHIR data model class name.
ClassMethod GetTypeForXPath(pXPath As %String, pResourceSchemaRoot As %String, Output pType As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pType = ""
	
	Try {
		If $Extract(pXPath)="/" Set pXPath = $Extract(pXPath,2,*)
		
		If $Extract(pXPath,*-6,*)="/@value" {
			Set pXPath = $Extract(pXPath,1,*-7)
		} ElseIf $Extract(pXPath,*-4,*)="/@url" {
			Set pXPath = $Extract(pXPath,1,*-5)
		} ElseIf $Extract(pXPath,*-3,*)="/@id" {
			Set pXPath = $Extract(pXPath,1,*-4)
		}
		
		Set tSC = ..GetTypeForXPath2(.pXPath, .tNext)
		If $$$ISERR(tSC) Quit
		
		Set tHSFHIRClassName = pResourceSchemaRoot_"."_tNext
		
		If pXPath="" Set pType = tHSFHIRClassName Quit
		
		If $Data(%propsByName(tHSFHIRClassName))=0 Do ..GetPropInfo(tHSFHIRClassName)
		
		For {
			Set tSC = ..GetTypeForXPath2(.pXPath, .tNext)
			If $$$ISERR(tSC) Quit
			
			Set tHSFHIRClassName = %propsByName(tHSFHIRClassName, tNext, "Type")
			
			If pXPath="" Set pType = tHSFHIRClassName Quit
			
			If $Data(%propsByName(tHSFHIRClassName))=0 Do ..GetPropInfo(tHSFHIRClassName)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Get the next element in the specified XPath expression.
ClassMethod GetTypeForXPath2(ByRef pXPath, ByRef pNext) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Set pNext = ""
		
	Try {
		Set tInPredicate = 0
		Set tLeftBracketCount = 0
		Set tRightBracketCount = 0
		For tPos = 1:1:$Length(pXPath) {
			Set tChar = $Extract(pXPath,tPos)
			If ('tInPredicate)&&(tChar="[") {
				Set tInPredicate = 1
				Set tLeftBracketCount = 1
			} ElseIf ('tInPredicate)&&(tChar=":") {
				Set pNext = ""
			} ElseIf tInPredicate {
				If tChar="]" {
					Set tRightBracketCount = tRightBracketCount + 1
				} ElseIf tChar="[" {
					Set tLeftBracketCount = tLeftBracketCount + 1
				}
				If tRightBracketCount=tLeftBracketCount {
					Set tInPredicate = 0
				}
			} ElseIf tChar="/" {
				Quit
			} Else {
				Set pNext = pNext_tChar
			}
		}
		Set pXPath = $Extract(pXPath, tPos+1, *)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetSchemaForResourceProperty finds the schema (currently defined as the class definition)
/// for a given resource property, starting with a given resource schema.<br>
/// <br>
/// Input:<br>
/// <li>pResourceSchema : (required) Class package to use as the resource schema. Example is "HS.FHIR.vDSTU2.Model.Resource".
/// <li>pResourceType   : (optional) FHIR resource type (e.g., "Patient", "Observation", etc).
/// <li>pResourceProp   : (required) FHIR resource property name.
/// <br><br>
/// Output:<br>
/// <li>pPropSchema     : Class name that defines the property type.
ClassMethod GetSchemaForResourceProperty(pResourceSchema As %String, pResourceType As %String = "", pResourceProp As %String, ByRef pPropSchema As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pPropSchema = ""
	
	Try {
		If $Get(pResourceSchema)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource schema not specified")
			Quit
		}
		
		If $Get(pResourceProp)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource property not specified")
			Quit
		}
		
		// If resource type doesn't matter (i.e., getting data for resource or domainresource
		// property) then just set it to "Basic".
		If pResourceType="" Set pResourceType = "Basic"
		
		Set tResource = pResourceSchema_"."_pResourceType
		
		Set tPropOrigin = $$$comMemberKeyGet(tResource, $$$cCLASSproperty, pResourceProp, $$$cPROPorigin)
		Set pPropSchema = $$$defMemberKeyGet(tPropOrigin, $$$cCLASSproperty, pResourceProp, $$$cPROPtype)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// URLParamStringToArray takes a URL parameters string and converts it to an array of $List.<br>
/// <br>
/// Input:<br>
/// <li>pParametersString : Parameters string exactly as one would see in a request URL.
/// <br><br>
/// Output:<br>
/// <li>pParametersArray  : %Library.ArrayOfDataTypes that is an array of $List, indexed by parameter
///                         name. Use the GetParameterCount() and GetParameterValue() methods of this
///                         class to extract information from this array.
ClassMethod URLParamStringToArray(pParametersString As %String, Output pParametersArray As %Library.ArrayOfDataTypes)
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pParametersArray)) Set pParametersArray = ##class(%Library.ArrayOfDataTypes).%New()
		
		For i = 1:1:$Length(pParametersString,"&") {
			Set tP = $Piece(pParametersString,"&",i)
			If tP'="" {
				Set tParamName = $Piece(tP,"=",1)
				If tParamName[":" {
					Set tModifier = $Piece(tParamName,":",2)
					Set tParamName = $Piece(tParamName,":",1)
				} Else {
					Set tModifier = ""
				}
				Set tParamValue = $Piece(tP,"=",2,99)
				Set tSC = ##class(HS.FHIR.Utils).SetParameter(tParamName, tParamValue, tModifier, .pParametersArray)
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// SetParameter adds the specified parameter, modifier, and value to the pParametersArray collection.
ClassMethod SetParameter(pParamName As %String = "", pParamValue As %String = "", pModifier As %String = "", pParametersArray As %Library.ArrayOfDataTypes) As %Status
{
	Set tSC = $$$OK
	
	If (pParamName'="")&&(pParamValue'="") {
		If $Extract(pModifier)=":" Set pModifier = $Extract(pModifier,2,*)
		If pModifier'="" Set pParamName = pParamName_":"_pModifier
		Set tParamList = pParametersArray.GetAt(pParamName)
		Set tParamList = tParamList_$ListBuild(pParamValue)
		Set tSC = pParametersArray.SetAt(tParamList, pParamName)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "Error setting parameter "_pParamName_" - "_$system.Status.GetErrorText(tSC))
	} ElseIf pParamName="" {
		Set tSC = $$$ERROR($$$GeneralError, "Error setting parameter - parameter name not specified")
	} ElseIf pParamValue="" {
		Set tSC = $$$ERROR($$$GeneralError, "Error setting parameter "_pParamName_" - parameter value not specified")
	}
	
	Quit tSC
}

/// API
/// GetParameterCount returns the number of instances of a given parameter within the specified
/// array of parameters.<br>
/// <br>
/// Input:<br>
/// <li>pParametersArray  : %Library.ArrayOfDataTypes array of $List, indexed by parameter name.
/// <li>pParameterName    : Parameter name. If a modifier is included, the modifier is ignored.
/// <br><br>
/// Output:<br>
/// <li>(return value)    : Number of instances of the parameter.  For example, if the original parameter
///                         string was "given=joe&family=smith&family=jones&name:exact=sample" then
///                         this method would return 1 for "given", would return 2 for "family" and would
///                         would return 1 for "name".
ClassMethod GetParameterCount(pParametersArray As %Library.ArrayOfDataTypes, pParameterName As %String) As %Integer
{
	Set tCount = 0
	
	Set tKey = ""
	For {
		Set tParamItem = pParametersArray.GetNext(.tKey)
		If tKey="" Quit
		If $Piece(tKey,":",1)=$Piece(pParameterName,":",1) Set tCount = $ListLength(tParamItem) Quit
	}
	
	Quit tCount
}

/// API
/// GetParameterValue returns the value of a specified parameter instance within the specified
/// array of parameters, plus any parameter modifier. This method assumes that all instances
/// instances of a given parameter include a modifier OR all instances do NOT include a modifier.
/// Parameter modifier in FHIR is expressed as a colon-delimited suffix on the parameter name
/// (not value), for example family:exact=jones.
/// GetParameterCount returns the number of instances of a given parameter within the specified
/// array of parameters.<br>
/// <br>
/// Input:<br>
/// <li>pParametersArray  : %Library.ArrayOfDataTypes array of $List, indexed by parameter name.
/// <li>pParameterName    : Parameter name. If a modifier is included, the modifier is ignored.
/// <li>pPosition         : Instance of a given parameter. For example if a parameter appears in
///                         a URL string twice then specifying pPosition as 2 would get the value
///                         of the second instance of that parameter.
/// <br><br>
/// Output:<br>
/// <li>pModifier         : If any instances of this parameter include a modifier, this is the modifier.
/// <li>(return value)    : Value of the specified parameter instance.
ClassMethod GetParameterValue(pParametersArray As %Library.ArrayOfDataTypes, pParameterName As %String, pPosition As %Integer = 1, ByRef pModifier As %String) As %String
{
	Set tParamValue = ""
	Set pModifier = ""
	
	Set tKey = ""
	For {
		Set tParamItem = pParametersArray.GetNext(.tKey)
		If tKey="" Quit
		If $Piece(tKey,":",1)=$Piece(pParameterName,":",1) {
			If $ListGet(pParametersArray.GetAt(tKey),pPosition)'="" {
				Set tParamValue = $ListGet(pParametersArray.GetAt(tKey),pPosition)
				Set pModifier = $Piece(tKey,":",2)
			}
			Quit
		}
	}
	
	Quit tParamValue
}

ClassMethod URLParameterArrayToString(pParametersArray As %Library.ArrayOfDataTypes) As %String
{
	Set tString = ""
	
	Set tParamName = ""
	For {
		Set tParamVals = pParametersArray.GetNext(.tParamName)
		If tParamName="" Quit
		For i = 1:1:$ListLength(tParamVals) {
			If tString'="" Set tString = tString_"&"
			Set tString = tString_tParamName_"="_$ListGet(tParamVals, i)
		}
	}
	
	Quit tString
}

/// API
/// StartBundleStream writes to a stream object the first standard elements of a FHIR Bundle resource: type, total, link.<br>
/// This method is intended to be used in conjunction with the methods AddBundleEntryToStream and EndBundleStream.
/// <br>
/// Input:<br>
/// <li>pContentType  : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pBundleStream : Bundle stream object, to be updated by this method.  If this object is not
///                     passed in, then this method instantiates it as %Stream.TmpCharacter.
/// <li>pIdentifier   : Not yet implemented.
/// <li>pType         : (required) Bundle type.
/// <li>pTotal        : If search, the total number of matches.
/// <li>pFirstUrl     : For link, the url for the "first" link (for paging).
/// <li>pPrevUrl      : For link, the url for the "previous" link (for paging).
/// <li>pSelfUrl      : For link, the url for for "self" link for the url that caused this Bundle.
/// <li>pNextUrl      : For link, the url for the "next" link (for paging).
/// <li>pLastUrl      : For link, the url for the "last" link (for paging).
ClassMethod StartBundleStream(pContentType As %String, pBundleStream As %Stream.Object, pIdentifier = "", pType As %String, pTotal As %String = "", pFirstUrl As %String = "", pPrevUrl As %String = "", pSelfUrl As %String = "", pNextUrl As %String = "", pLastUrl As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pBundleStream)) Set pBundleStream = ##class(%Stream.TmpCharacter).%New()
		
		If $ZConvert(pContentType,"L")["json" {
			Do pBundleStream.Write("{""resourceType"":""Bundle""")
			Do pBundleStream.Write(",""id"":"""_$ZConvert($SYSTEM.Util.CreateGUID(),"L")_"""")
			Do pBundleStream.Write(",""type"":"""_pType_"""")
			If pTotal'="" Do pBundleStream.Write(",""total"":"_pTotal)
			If ((pSelfUrl'="")||(pFirstUrl'="")||(pLastUrl'="")||(pNextUrl'="")||(pPrevUrl'="")) {
				Do pBundleStream.Write(",""link"":[")
				If pFirstUrl'="" Do pBundleStream.Write("{""relation"":""first"",""url"":"""_$ZConvert(pFirstUrl,"O","JSON")_"""},")
				If pPrevUrl'="" Do pBundleStream.Write("{""relation"":""previous"",""url"":"""_$ZConvert(pPrevUrl,"O","JSON")_"""},")
				If pSelfUrl'="" Do pBundleStream.Write("{""relation"":""self"",""url"":"""_$ZConvert(pSelfUrl,"O","JSON")_"""}")
				If (pNextUrl'="")||(pLastUrl'="") Do pBundleStream.Write(",")
				If pNextUrl'="" Do pBundleStream.Write("{""relation"":""next"",""url"":"""_$ZConvert(pNextUrl,"O","JSON")_"""},")
				If pLastUrl'="" Do pBundleStream.Write("{""relation"":""last"",""url"":"""_$ZConvert(pLastUrl,"O","JSON")_"""}")
				Do pBundleStream.Write("]")
			}
		} Else {
			Do pBundleStream.Write("<Bundle xmlns=""http://hl7.org/fhir"">")
			Do pBundleStream.Write("<id value="""_$ZConvert($SYSTEM.Util.CreateGUID(),"L")_"""/>")
			Do pBundleStream.Write("<type value="""_pType_"""/>")
			If pTotal'="" Do pBundleStream.Write("<total value="""_pTotal_"""/>")
			If pFirstUrl'="" Do pBundleStream.Write("<link><relation value=""first""/><url value="""_$ZConvert(pFirstUrl,"O","XML")_"""/></link>")
			If pPrevUrl'="" Do pBundleStream.Write("<link><relation value=""previous""/><url value="""_$ZConvert(pPrevUrl,"O","XML")_"""/></link>")
			If pSelfUrl'="" Do pBundleStream.Write("<link><relation value=""self""/><url value="""_$ZConvert(pSelfUrl,"O","XML")_"""/></link>")
			If pNextUrl'="" Do pBundleStream.Write("<link><relation value=""next""/><url value="""_$ZConvert(pNextUrl,"O","XML")_"""/></link>")
			If pLastUrl'="" Do pBundleStream.Write("<link><relation value=""last""/><url value="""_$ZConvert(pLastUrl,"O","XML")_"""/></link>")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// AddBundleEntryToStream adds a Bundle entry to an existing JSON or XML Bundle stream.<br>
/// This method is intended to be used in conjunction with the methods StartBundleStream and EndBundleStream.
/// <br>
/// Input:<br>
/// <li>pContentType     : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pBundleStream    : (required) Existing Bundle stream object.
/// <li>pFullUrl         : Bundle entry fullUrl value.
/// <li>pResourceStream  : Stream object for FHIR resource to include in the entry.
/// <li>pSearch()        : Array of Bundle entry search object properties.
///                        pSearch(property_name) = value, where property name can be "mode" or "score".
/// <li>pRequest()       : Array of Bundle entry request object properties.
///                        pRequest(property_name) = value, where property name can be "method", "url",
///                        "ifNoneMatch", "ifModifiedSince", "ifMatch", or "ifNoneExist".
/// <li>pResponse()      : Array of Bundle entry response object properties.
///                        pSearch(property_name) = value, where property name can be "status", "location",
///                        "etag", or "lastModified".
/// <li>pOutcomeStream   : Stream object for OperationOutcome resource for entry response outcome property.
/// <li>pIsFirstEntry    : If true, then for JSON the entry collection start ("entry":[) is written.
/// <li>pWriteComma      : If true, then for JSON write a comma after writing out the entry object.
/// <li>pIsLastEntry     : If true, then for JSON the entry collection end (]) is written.
ClassMethod AddBundleEntryToStream(pContentType As %String, ByRef pBundleStream As %Stream.Object, pFullUrl As %String = "", pResourceStream As %Stream.Object = {$$$NULLOREF}, ByRef pSearch As %String, ByRef pRequest As %String, ByRef pResponse As %String, pOutcomeStream As %Stream.Object = {$$$NULLOREF}, pIsFirstEntry As %Boolean = 0, pWriteComma As %Boolean = 0, pIsLastEntry As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $ZConvert(pContentType,"L")["json" {
			Set tSC = ..AddBundleEntryToJSONStream(.pBundleStream, pFullUrl, pResourceStream, .pSearch, .pRequest, .pResponse, pOutcomeStream, pIsFirstEntry, pWriteComma, pIsLastEntry)
		} Else {
			Set tSC = ..AddBundleEntryToXMLStream(.pBundleStream, pFullUrl, pResourceStream, .pSearch, .pRequest, .pResponse, pOutcomeStream)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddBundleEntryToJSONStream adds a Bundle entry to an existing Bundle stream as JSON.<br>
/// <br>
/// Input:<br>
/// <li>pBundleStream    : (required) Existing Bundle stream object.
/// <li>pFullUrl         : Bundle entry fullUrl value.
/// <li>pResourceStream  : Stream object for FHIR resource to include in the entry.
/// <li>pSearch()        : Array of Bundle entry search object properties.
///                        pSearch(property_name) = value, where property name can be "mode" or "score".
/// <li>pRequest()       : Array of Bundle entry request object properties.
///                        pRequest(property_name) = value, where property name can be "method", "url",
///                        "ifNoneMatch", "ifModifiedSince", "ifMatch", or "ifNoneExist".
/// <li>pResponse()      : Array of Bundle entry response object properties.
///                        pSearch(property_name) = value, where property name can be "status", "location",
///                        "etag", or "lastModified".
/// <li>pOutcomeStream   : Stream object for OperationOutcome resource for entry response outcome property.
/// <li>pIsFirstEntry    : If true, then for JSON the entry collection start ("entry":[) is written.
/// <li>pWriteComma      : If true, then for JSON write a comma after writing out the entry object.
/// <li>pIsLastEntry     : If true, then for JSON the entry collection end (]) is written.
ClassMethod AddBundleEntryToJSONStream(ByRef pBundleStream As %Stream.Object, pFullUrl As %String = "", pResourceStream, ByRef pSearch As %String, ByRef pRequest As %String, ByRef pResponse As %String, pOutcomeStream As %Stream.Object, pIsFirstEntry As %Boolean = 0, pWriteComma As %Boolean = 0, pIsLastEntry As %Boolean = 0) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		// This assumes that at least type has already been written to the Bundle, so the comma is okay.
		If pIsFirstEntry Do pBundleStream.Write(",""entry"":[")
		Set tWroteProp1 = 0
		Do pBundleStream.Write("{")
		If pFullUrl'="" {
			Do pBundleStream.Write("""fullUrl"":"""_pFullUrl_"""")
			Set tWroteProp1 = 1
		}
		If ($IsObject($Get(pResourceStream)))&&(pResourceStream.Size>0) {
			If tWroteProp1 Do pBundleStream.Write(",")
			Do pBundleStream.Write("""resource"":")
			Do pBundleStream.CopyFrom(pResourceStream)
			Set tWroteProp1 = 1
		}
		If $Data(pSearch)>9 {
			If tWroteProp1 Do pBundleStream.Write(",")
			Do pBundleStream.Write("""search"":{")
			If $Get(pSearch("mode"))'="" Do pBundleStream.Write("""mode"":"""_pSearch("mode")_"""")
			If $Get(pSearch("score"))'="" {
				If $Get(pSearch("mode"))'="" Do pBundleStream.Write(",")
				Do pBundleStream.Write("""score"":"_pSearch("score")_"")
			}
			Do pBundleStream.Write("}")
			Set tWroteProp1 = 1
		}
		If $Data(pRequest)>9 {
			If tWroteProp1 Do pBundleStream.Write(",")
			Do pBundleStream.Write("""request"":{")
			Set tWroteProp2 = 0
			For i = "method", "url", "ifNoneMatch", "ifModifiedSince", "ifMatch", "ifNoneExist" {
				If $Get(pRequest(i))'="" {
					If tWroteProp2 Do pBundleStream.Write(",")
					Do pBundleStream.Write(""""_i_""":"""_$ZConvert(pRequest(i),"O","JSON")_"""")
					Set tWroteProp2 = 1
				}
			}
			Do pBundleStream.Write("}")
			Set tWroteProp1 = 1
		}
		If $Data(pResponse)>9 {
			If tWroteProp1 Do pBundleStream.Write(",")
			Do pBundleStream.Write("""response"":{")
			Set tWroteProp2 = 0
			For i = "status", "location", "etag", "lastModified" {
				If $Get(pResponse(i))'="" {
					If tWroteProp2 Do pBundleStream.Write(",")
					Do pBundleStream.Write(""""_i_""":"""_$ZConvert(pResponse(i),"O","JSON")_"""")
					Set tWroteProp2 = 1
				}
			}
			If ($IsObject($Get(pOutcomeStream)))&&(pOutcomeStream.Size>0) {
				If tWroteProp2 Do pBundleStream.Write(",")
				Do pBundleStream.CopyFrom(pOutcomeStream)
			}
			Do pBundleStream.Write("}")
			Set tWroteProp1 = 1
		}
		Do pBundleStream.Write("}")
		If pWriteComma Do pBundleStream.Write(",")
		If pIsLastEntry Do pBundleStream.Write("]")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddBundleEntryToXMLStream adds a Bundle entry to an existing Bundle stream as XML.<br>
/// <br>
/// Input:<br>
/// <li>pBundleStream    : (required) Existing Bundle stream object.
/// <li>pFullUrl         : Bundle entry fullUrl value.
/// <li>pResourceStream  : Stream object for FHIR resource to include in the entry.
/// <li>pSearch()        : Array of Bundle entry search object properties.
///                        pSearch(property_name) = value, where property name can be "mode" or "score".
/// <li>pRequest()       : Array of Bundle entry request object properties.
///                        pRequest(property_name) = value, where property name can be "method", "url",
///                        "ifNoneMatch", "ifModifiedSince", "ifMatch", or "ifNoneExist".
/// <li>pResponse()      : Array of Bundle entry response object properties.
///                        pSearch(property_name) = value, where property name can be "status", "location",
///                        "etag", or "lastModified".
/// <li>pOutcomeStream   : Stream object for OperationOutcome resource for entry response outcome property.
ClassMethod AddBundleEntryToXMLStream(ByRef pBundleStream As %Stream.Object, pFullUrl As %String = "", pResourceStream, ByRef pSearch As %String, ByRef pRequest As %String, ByRef pResponse As %String, pOutcomeStream As %Stream.Object) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Do pBundleStream.Write("<entry>")
		If pFullUrl'="" Do pBundleStream.Write("<fullUrl value="""_$ZConvert(pFullUrl,"O","XML")_"""/>")
		If ($IsObject($Get(pResourceStream)))&&(pResourceStream.Size>0) {
			Do pBundleStream.Write("<resource>")
			Do pBundleStream.CopyFrom(pResourceStream)
			Do pBundleStream.Write("</resource>")
		}
		If $Data(pSearch)>9 {
			Do pBundleStream.Write("<search>")
			For i = "mode", "score" {
				If $Get(pSearch(i))'="" Do pBundleStream.Write("<"_i_" value="""_pSearch(i)_"""/>")
			}
			Do pBundleStream.Write("</search>")
		}
		If $Data(pRequest)>9 {
			Do pBundleStream.Write("<request>")
			For i = "method", "url", "ifNoneMatch", "ifModifiedSince", "ifMatch", "ifNoneExist" {
				If $Get(pRequest(i))'="" Do pBundleStream.Write("<"_i_" value="""_$ZConvert(pRequest(i),"O","XML")_"""/>")
			}
			Do pBundleStream.Write("</request>")
		}
		If $Data(pResponse)>9 {
			Do pBundleStream.Write("<response>")
			For i = "status", "location", "etag", "lastModified" {
				If $Get(pResponse(i))'="" Do pBundleStream.Write("<"_i_" value="""_$ZConvert(pResponse(i),"O","XML")_"""/>")
			}
			If ($IsObject($Get(pOutcomeStream)))&&(pOutcomeStream.Size>0) {
				Do pBundleStream.Write("<outcome>")
				Do pBundleStream.CopyFrom(pOutcomeStream)
				Do pBundleStream.Write("</outcome>")
			}
			Do pBundleStream.Write("</response>")
		}
		Do pBundleStream.Write("</entry>")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// EndBundleStream adds the ending to an existing under-construction FHIR Bundle stream.<br>
/// This method is intended to be used in conjunction with the methods StartBundleStream and AddBundleEntryToStream.
/// <br>
/// Input:<br>
/// <li>pContentType     : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pBundleStream    : (required) Existing Bundle stream object.
/// <li>pSignatureStream : Stream object for Signature property.
ClassMethod EndBundleStream(pContentType As %String, ByRef pBundleStream As %Stream.Object, pSignatureStream As %Stream.Object = {$$$NULLOREF}) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $ZConvert(pContentType,"L")["json" {
			If ($IsObject(pSignatureStream))&&(pSignatureStream.Size>0) {
				Do pBundleStream.Write(",")
				Do pBundleStream.CopyFrom(pSignatureStream)
			}
			Do pBundleStream.Write("}")
		} Else {
			If ($IsObject(pSignatureStream))&&(pSignatureStream.Size>0) {
				Do pBundleStream.CopyFrom(pSignatureStream)
			}
			Do pBundleStream.Write("</Bundle>")
		}
		
		Do pBundleStream.Rewind()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetCapabilityStatementFromXData retrieves a FHIR Conformance/CapabilityStatement that is located
/// in a class XData block, as opposed to located in the FHIR resource repository.  The data in the
/// XData may be completely static, or may contain some placeholder text that allows for dynamic
/// population of fields based on the current host, web server port, end point base url, end point
/// OAuth definition, and end point CORS handling.<br>
/// <br>
/// This is a list of the fields that may be dynamically populated, with the placeholder text to use.<br>
/// <li>resource id value           : "<placeholder>resource_id</placeholder>"
/// <li>url value                   : "<placeholder>url</placeholder>"
/// <li>implementation/url value    : "<placeholder>implementation_url</placeholder>"
/// <li>rest/security/extension for oauth-uris : "<placeholder>security_oauth_uris_extension</placeholder>"
/// <li>rest/security/cors value    : "<placeholder>security_cors</placeholder>"
/// <li>rest/security/service value : "<placeholder>security_service</placeholder>"
/// <br><br>
/// Input:<br>
/// <li>pContentType        : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pXDataName          : (required) Name of the XData block to use.
/// <li>pClassName          : (required) Full name of the class that holds the XData block.
/// <li>pResourceSchemaRoot : (required only when pContentType indicates json) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pResourceId         : (required) Resource id to apply to the Conformance/CapabilityStatement.
/// <li>pBaseURL            : (required) Base URL (e.g., CSP application name) for the end point.
/// <li>pOAuthClient        : OAuth 2.0 client name for this end point.
/// <li>pCORSEnabled        : 1 = CORS is enabled for this end point, 0 = CORS is not enabled.
/// <li>pFormatFHIROutput   : 1 = Add indent and line end formatting to the FHIR resource output,
///                           0 = Do not add formatting.
/// <br><br>
/// Output:<br>
/// <li>pResourceStream     : FHIR resource stream object.
ClassMethod GetCapabilityStatementFromXData(pContentType As %String, pXDataName As %String, pClassName As %String, pResourceSchemaRoot As %String = "", pResourceId As %String, pBaseURL As %String, pOAuthClient As %String = "", pCORSEnabled As %Boolean = 1, pFormatFHIROutput As %Boolean = 0, ByRef pResourceStream As %Stream.Object) As %Status
{
	Set tSC = $$$OK

	#dim tXDataStream As %Stream.Object
	#dim tNewXDataStream As %Stream.Object
	
	Try {
		Set tErrorText = ""
		If $Get(pContentType)="" {
			Set tErrorText = "Content type not specified"
		} ElseIf '(($ZConvert(pContentType,"L")["json")||($ZConvert(pContentType,"L")["xml")) {
			Set tErrorText = "Invalid content type "_$Select(pContentType'="":pContentType,1:"(blank)")_" specified"
		} ElseIf $Get(pXDataName)="" {
			Set tErrorText = "XData name not specified"
		} ElseIf $Get(pClassName)="" {
			Set tErrorText = "Class name not specified"
		} ElseIf (pContentType["json")&&(pResourceSchemaRoot="") {
			Set tErrorText = "ResourceSchemaRoot is required when json content type is requested"
		} ElseIf $Get(pResourceId)="" {
			Set tErrorText = "Resource id not specified"
		}
		If tErrorText'="" {
			Set tSC = $$$ERROR($$$GeneralError, tErrorText)
			Quit
		}
		
		// Using GetURLStream will find the XData in a sub-class if the XData is only in the base class.
		Set tXDataURL = "xdata://"_pClassName_":"_pXDataName
		Set tSC = ##class(Ens.Util.URLStream).GetURLStream(tXDataURL, .tXDataStream)
		If $$$ISERR(tSC) Quit
		
		Do tXDataStream.Rewind()
		
		// Gather host, port, namespace and OAuth 2.0 information and use it to dynamically
		// populate some of the fields in the "header" part of the Conformance/CapabilityStatement.
		Set tSC = ##class(%RoutineMgr).GetWebServerPort(.tPort)
		If $$$ISERR(tSC) {
			Set tSC = $$$ERROR($$$GeneralError, "Could not get web server port")
			Quit
		}
		Set tHost = $ZConvert($$$HSNetworkHostName, "L")
		
		Set tCapability = "<CapabilityStatement xmlns=""http://hl7.org/fhir"">"
		Set tCapabilityL = $Length(tCapability)
		Set tConformance = "<Conformance xmlns=""http://hl7.org/fhir"">"
		Set tConformanceL = $Length(tConformance)
		
		Set tResourceType = ""
		Set tBuffer = ""
		For {
			Set tChar = tXDataStream.Read(1)
			Set tBuffer = tBuffer_tChar
			If $Length(tBuffer)>200 Set tBuffer = $Extract(tBuffer,2,*)
			If $Extract(tBuffer,*-(tCapabilityL-1),*)=tCapability {
				Set tResourceType = "CapabilityStatement"
				Quit
			} ElseIf $Extract(tBuffer,*-(tConformanceL-1),*)=tConformance {
				Set tResourceType = "Conformance"
				Quit
			}
			If tXDataStream.AtEnd Quit
		}
		If tResourceType="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource type for Conformance/CapabilityStatement resource not found")
			Quit
		}
		If '((tResourceType="Conformance")||(tResourceType="CapabilityStatement")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid resource type '"_tResourceType_"' found")
			Quit
		}
		Do tXDataStream.Rewind()
		Kill tBuffer
		
		Set tHttpHostPort = "http://"_tHost_$Select(tPort'="":":"_tPort,1:"")
		
		Set tUrl = tHttpHostPort_pBaseURL_"/"_tResourceType_"/"_pResourceId
		Set tImplementationUrl = tHttpHostPort_pBaseURL
		If pOAuthClient'="" {
			Set tSC = ..GetOAuthClientInfo(pOAuthClient, .tClientInfo)
			If $$$ISERR(tSC) Quit
		}
		Set tCORSEnabled = $Case(pCORSEnabled, 0:"false", 1:"true", "false":"false", "true":"true", :"false")
		
		Set tValues("resource_id") = "<id value="""_pResourceId_""" />"
		Set tValues("url") = "<url value="""_tUrl_""" />"
		
		Set tProductNum = ##class(%SYSTEM.Version).GetISCProduct()
		Set tComponents = ##class(%SYSTEM.Version).GetISCComponents(tProductNum)
		If tProductNum=4 {
			Set tSoftware = "InterSystems IRIS"
			If tComponents'="" {
				For i = 1:1:$ListLength(tComponents) {
					If $ListGet(tComponents, i)="Health" {
						Set tSoftware = tSoftware_" for Health"
						Quit
					}
				}
			}
		} ElseIf tProductNum=3 {
			Set tSoftware = "HealthShare"
			If tComponents'="" {
				For i = 1:1:$ListLength(tComponents) {
					If $ListGet(tComponents, i)="HealthConnect" {
						Set tSoftware = tSoftware_" Health Connect"
					}
				}
			}
		} Else {
			Set tSoftware = ""
		}
		Set tSoftwareVersion = ##class(%SYSTEM.Version).GetNumber()
		Set tValues("software") = "<software><name value="""_tSoftware_"""/><version value="""_tSoftwareVersion_"""/></software>"
		
		Set tValues("implementation_url") = "<url value="""_tImplementationUrl_""" />"
		
		// Assume that the OAuth end points are defined in conjunction with SMART on FHIR.
		If $Get(tClientInfo("authorization_endpoint"))'="" {
			Set tString = ""
			Set tString = tString_"<extension url=""http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"">"
			Set tString = tString_"<extension url=""authorize"">"
			Set tString = tString_"<valueUri value="""_tClientInfo("authorization_endpoint")_""" />"
			Set tString = tString_"</extension>"
			Set tString = tString_"<extension url=""token"">"
			Set tString = tString_"<valueUri value="""_tClientInfo("token_endpoint")_""" />"
			Set tString = tString_"</extension>"
			Set tString = tString_"</extension>"
			Set tValues("security_oauth_uris_extension") = tString
			Set tString = ""
			Set tString = tString_"<service>"
			Set tString = tString_"<coding>"
			Set tString = tString_"<system value=""http://hl7.org/fhir/restful-security-service"" />"
			Set tString = tString_"<code value=""SMART-on-FHIR"" />"
			Set tString = tString_"<display value=""SMART-on-FHIR"" />"
			Set tString = tString_"</coding>"
			Set tString = tString_"<text value=""SMART-on-FHIR"" />"
			Set tString = tString_"</service>"
			Set tValues("security_service") = tString
		}
		
		Set tValues("security_cors") = "<cors value="""_tCORSEnabled_""" />"
		
		Set tTempStream = ##class(%Stream.TmpCharacter).%New()
		Set tSC = ..ApplyValuesToStreamOrString(tXDataStream, .tTempStream, .tValues, "<placeholder>", "</placeholder>")
		If $$$ISERR(tSC) Quit
		
		If '$IsObject($Get(pResourceStream)) Set pResourceStream = ##class(%Stream.TmpCharacter).%New()
		
		If 'pFormatFHIROutput {
			Set tIndentChars = ""
			Set tLineTerminator = ""
			Set tXMLFormatOption = 0
		} Else {
			Set tIndentChars = $Char(32,32)
			Set tLineTerminator = $Char(13,10)
			Set tXMLFormatOption = 2
		}
		
		If pContentType["xml" {
			Set tSC = ##class(HS.FHIR.Utils).FormatFHIR(pContentType, tTempStream, .pResourceStream, , , , tXMLFormatOption)
		} Else {
			Set tSC = ##class(HS.FHIR.Utils).XMLToJSON(tTempStream, .pResourceStream, pResourceSchemaRoot, tIndentChars, tLineTerminator)
		}
		If $$$ISERR(tSC) Quit
		
		Do pResourceStream.Rewind()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod GetOAuthClientInfo(pClientName As %String, ByRef pClientInfo As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		Set $Namespace = "%SYS"
		
		Set tClient = ##class(OAuth2.Client).%OpenId(pClientName)
		If '$IsObject(tClient) {
			Set tSC = $$$ERROR($$$GeneralError, "OAuth 2.0 client '"_pClientName_"' not found")
			Quit
		}
		
		Set pClientInfo("issuer") = tClient.ServerDefinition.Metadata."issuer"
		Set pClientInfo("authorization_endpoint") = tClient.ServerDefinition.Metadata."authorization_endpoint"
		Set pClientInfo("token_endpoint") = tClient.ServerDefinition.Metadata."token_endpoint"
		Set pClientInfo("introspection_endpoint") = tClient.ServerDefinition.Metadata."introspection_endpoint"
		Set pClientInfo("registration_endpoint") = tClient.ServerDefinition.Metadata."registration_endpoint"
		Set pClientInfo("revocation_endpoint") = tClient.ServerDefinition.Metadata."revocation_endpoint"
		Set pClientInfo("userinfo_endpoint") = tClient.ServerDefinition.Metadata."userinfo_endpoint"
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ApplyValuesToStreamOrString(pStreamOrString, pStreamOut As %Stream.Object, ByRef pValues As %String, pLeftDelim As %String = "{%", pRightDelim As %String = "%}") As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pStreamOrString)="" {
			Set tSC = $$$ERROR($$$GeneralError,"Stream or string input not specified")
			Quit
		}
		
		Set tIsString = ('$IsObject(pStreamOrString))
		
		Set tWriteBuffer = ""
		Set tWindow = ""
		Set tMaxBuf = 3640000
		Set tReadLen = 32767
		Set tLeftDelimL = ($Length(pLeftDelim)-1)
		Set tRightDelimL = ($Length(pRightDelim)-1)
		
		Set tInPlaceholder = 0
		
		If '$IsObject($Get(pStreamOut)) Set pStreamOut = ##class(%Stream.TmpCharacter).%New()
		
		For {
			If 'tIsString {
				Set tString = pStreamOrString.Read(tReadLen, .tSC)
				If $$$ISERR(tSC) Quit
			} Else {
				Set tString = pStreamOrString
			}
			For tPosition = 1:1:$Length(tString) {
				Set tChar = $Extract(tString, tPosition)
				Set tWindow = tWindow_tChar
				// Not expecting a place holder (name plus delimiters) anywhere near 100 chars.
				If $Length(tWindow)>100 {
					Set tAddChars = $Extract(tWindow) Do Write
					Set tWindow = $Extract(tWindow, 2, *)
				}
				If 'tInPlaceholder {
					If $Extract(tWindow, *-tLeftDelimL, *)=pLeftDelim {
						Set tInPlaceholder = 1
						Set tCurrentPlaceholder = ""
					}
				} Else {
					Set tCurrentPlaceholder = tCurrentPlaceholder_tChar
					If $Extract(tWindow, *-tRightDelimL, *)=pRightDelim {
						// We have hit the end of a place holder. Check pValues to see if
						// this place holder has a value string specified for it.
						Set tCurrentPlaceholder = $Extract(tCurrentPlaceholder, 1, *-($Length(pRightDelim)))
						Set tWindow = $Extract(tWindow, 1, *-($Length(pLeftDelim_tCurrentPlaceholder_pRightDelim)))_$Get(pValues(tCurrentPlaceholder))
						Kill pValues(tCurrentPlaceholder)
						Set tAddChars = tWindow Do Write Set tWindow = ""
						Set tInPlaceholder = 0
						Set tCurrentPlaceholder = ""
					}
				}
			}
			
			If (tIsString)||(pStreamOrString.AtEnd) {
				Set tAddChars = tWindow Do Write
				Do:$Length(tWriteBuffer)>0 pStreamOut.Write(tWriteBuffer)
				Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($IsObject($Get(pStreamOut)))&&(pStreamOut.%IsA("%Stream.Object")) Do pStreamOut.Rewind()
	
	Quit tSC
	
Write
	If ($Length(tWriteBuffer)+$Length(tAddChars))>tMaxBuf {
		Do pStreamOut.Write(tWriteBuffer)
		Set tWriteBuffer = ""
	}
	Set tWriteBuffer = tWriteBuffer_tAddChars
	Quit
}

/// EnsureContentType corrects an incoming erroneous ContentType so that the
/// correct Content-Type header value will be included on the HTTP response.
ClassMethod EnsureContentType(pContentType As %String, pFHIRVersion As %String) As %String [ Internal ]
{
	Set tReturnType = pContentType
	
	If pFHIRVersion'="DSTU2" {
		For i = 1:1:$Length(pContentType, ";") {
			Set tP = $ZStrip($Piece(pContentType, ";", i),"<>W")
			If tP="application/xml+fhir" {
				Set $Piece(tReturnType, ";", i) = "application/fhir+xml"
				Quit
			} ElseIf tP="application/json+fhir" {
				Set $Piece(tReturnType, ";", i) = "application/fhir+json"
				Quit
			}
		}
		
	} Else {
		For i = 1:1:$Length(pContentType, ";") {
			Set tP = $ZStrip($Piece(pContentType, ";", i),"<>W")
			If tP="application/fhir+xml" {
				Set $Piece(tReturnType, ";", i) = "application/xml+fhir"
				Quit
			} ElseIf tP="application/fhir+json" {
				Set $Piece(tReturnType, ";", i) = "application/json+fhir"
				Quit
			}
		}
	}
	
	Quit tReturnType
}

/// GetURI wraps the logic for obtaining a Code, based on a specified URI.
ClassMethod ParseISCURI(pURI As %String, pMode As %String = "strict", Output pType As %String, Output pCode As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pType = ""
	Set pCode = ""
	
	Try {
		// Look in the OID Registry for a Code that maps to the specified URI.
		set pCode = ##class(HS.Data.OIDMap).GetCodeForURI(pURI, "")
		if pCode'="" quit
		
		if pMode="strict" quit
		
		// If none found, then try to derive a Code from a "ISC-formatted URL".
		if ($length(pURI,"/")<5)||(($extract(pURI,1,7)'="http://")&&($extract(pURI,1,8)'="https://")) {
			set tSC = $$$ERROR($$$GeneralError,"Invalid URI: "_pURI)
			quit
		}
		set pType = $piece(pURI,"/",$length(pURI,"/")-1)
		set pCode = $piece(pURI,"/",$length(pURI,"/"))
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GetURI wraps the logic for obtaining a URI, based on a specified code and code type.
ClassMethod GetURI(pType As %String, pCode As %String, pMode As %String = "strict", pDefault As %String = "") As %String
{
	set tRet = ""
	
	if pMode = "strict" quit ##class(HS.Data.OIDMap).GetURIForCode(pCode, pDefault)
	
	set tRet = ##class(HS.Data.OIDMap).GetURLForCode(pCode, "")
	if tRet '= "" quit tRet
	
	set tHost = "http://"_$$$HSNetworkHostName
	set tRet = tHost_"/"_pType_"/"_pCode
	quit tRet
}

/// API
/// VerifyWithAccessToken verifies the authorization of a request based on the provided
/// access token and the specified request and/or resource data.<br>
/// Input:<br>
/// <li>pJSONWebToken   : (required) JSON string representation of the access token.
/// <li>pFHIRVersion    : (required) FHIR version (DSTU2, STU3, etc.).
/// <li>pResourceType   : (required) Resource type.
/// <li>pResourceId     : Resource id.
/// <li>pInteraction    : (required) Interaction (e.g., create, update, search, etc.).
/// <li>pResourceObj    : Resource %DynamicObject or %XML.Document object.
/// <li>pResourceStream : Resource stream object.
/// <br>Output:<br>
/// <li>pApproved       : Boolean indicator of whether the item is approved as per the access token.
ClassMethod VerifyWithAccessToken(pJSONWebToken As %String, pFHIRVersion As %String, pResourceType As %String, pResourceId As %String = "", pInteraction As %String, pResourceObj = "", pResourceStream As %Stream.Object = "", Output pApproved As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Set pApproved = 0
	
	Try {
		Set tErrorText = ""
		
		If $Get(pJSONWebToken)="" {
			Set tErrorText = "Access token not specified"
		} ElseIf $Get(pFHIRVersion)="" {
			Set tErrorText = "FHIR version not specified"
		} ElseIf $Get(pResourceType)="" {
			Set tErrorText = "Resource type not specified"
		} ElseIf $Get(pInteraction)="" {
			Set tErrorText = "Interaction not specified"
		} ElseIf ($Get(pResourceObj)'="")&&(('$IsObject(pResourceObj))||(('pResourceObj.%IsA("%Library.DynamicObject"))&&('pResourceObj.%IsA("%XML.Document")))) {
			Set tErrorText = "Specified resource object must be %DynamicObject or %XML.Document object"
		} ElseIf ($Get(pResourceStream)'="")&&(('$IsObject(pResourceStream))||('pResourceStream.%IsA("%Stream.Object"))) {
			Set tErrorText = "Specified resource stream must extend %Stream.Object"
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
		Set tJSONWebTokenObj = ##class(%Library.DynamicObject).%FromJSON(pJSONWebToken)
		
		// If JSONWebToken had content but could not make an object from it then
		// the token is corrupt and invalid, and therefore access not approved.
		If '$IsObject($Get(tJSONWebTokenObj)) Quit
		
		// Determine whether the interaction is read or write.
		Set tInteractionRW = $Case(pInteraction, "create":"write", "update":"write", "search":"read", "read":"read", "$everything":"read", "vread":"read", "history":"read", "delete":"write", :"read")
		
		Set tScopes = tJSONWebTokenObj.scope
		Set tPatient = tJSONWebTokenObj.patient
		
		// Examples: patient/*.read, user/*.write
		// If patient scope is present:
		// - There must be a patient value.
		// - patient scope must pass in order for authorization to be approved.
		// If user scope is present:
		// - Must be authorized to read and/or write the specified resource type or all types.
		
		For i = 1:1:$Length(tScopes," ") {
			Set tScope = $Piece(tScopes," ",i)
			If tScope'="" {
				// Clinical scope is either "user" or "patient".
				Set tClinicalScope = $Piece(tScope,"/",1)
				If (tClinicalScope="patient") {
					// If a patient scope is specified but patient value is not, that is invalid.
					// Failure to comply with patient scope means fail of authorization check.
					// If patient scope fails but user scope passes it is still a fail.
					If tPatient="" Set pApproved = 0 Quit
					If (pInteraction="update")||(pInteraction="search")||(pInteraction="read")||(pInteraction="$everything")||(pInteraction="vread")||(pInteraction="history")||(pInteraction="delete") {
						If pResourceType="Patient" {
							If pResourceId'=tPatient Set pApproved = 0 Quit
						} ElseIf (pInteraction="search")&&(pResourceId'=tPatient) {
							Set pApproved = 0 Quit
						} Else { // is a resource type other than Patient and is not search
							// If resource object or resource stream were passed in, examine
							// the references in the resource to see if any refer to the
							// patient resource id from the access token.
							If $IsObject($Get(pResourceObj)) {
								// Examine the references in this resource to see if any
								// refer to the patient resource id from the access token.
								Set tIsForPatient = ..IsResourceForPatient(pResourceObj, pFHIRVersion, pResourceType, tPatient)
								If 'tIsForPatient Set pApproved = 0 Quit
							} ElseIf ($IsObject($Get(pResourceStream)))&&(pResourceStream.%IsA("%Stream.Object"))&&(pResourceStream.Size>0) {
								Set tContentType = ""
								For {
									Set tChar = pResourceStream.Read(1)
									If tChar="{" {
										Set tContentType = "json"
										Quit
									} ElseIf tChar="<" {
										Set tContentType = "xml"
										Quit
									}
									If pResourceStream.AtEnd Quit
								}
								Do pResourceStream.Rewind()
								Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(tContentType, .pResourceStream, .tResourceObject)
								If $$$ISERR(tSC) Quit
								Set tIsForPatient = ..IsResourceForPatient(tResourceObj, pFHIRVersion, pResourceType, tPatient)
								If 'tIsForPatient Set pApproved = 0 Quit
							}
							// If no resource object and no resource stream, then it means
							// it is the pre-query access token check for things like search,
							// history and $everything. Can't verify the patient scope in
							// that scenario and should not fail the check.
						}
					} ElseIf (pInteraction="create") {
						// If the clinical scope is Patient, it implies the knowledge of a
						// Patient resource id that this token is authorized for. If this
						// is a create of a Patient resource, there is no resource id for
						// this Patient resource yet, so this cannot be approved.
						If pResourceType="Patient" Continue
						// Examine the references in this resource to see if any point to
						// the patient resource id from the access token.
						Set tIsForPatient = ..IsResourceForPatient(pResourceObj, pFHIRVersion, pResourceType, tPatient)
						If 'tIsForPatient Continue
					}
				}
				// Resource type is a FHIR resource type, or "*" for all resource types.
				Set tScopeResourceType = $Piece($Piece(tScope,"/",2),".",1)
				// Read/Write is "read", "write", or "*" for both.
				Set tReadWrite = $Piece($Piece(tScope,"/",2),".",2)
				If ((tScopeResourceType="*")||(tScopeResourceType=pResourceType))&&((tReadWrite="*")||(tReadWrite=tInteractionRW)) {
					Set pApproved = 1
					// Don't quit, we might still run into an invalid patient scope.
				}
			}
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod IsResourceForPatient(pResourceObj, pFHIRVersion As %String, pResourceType As %String, pPatientResourceId As %String) As %Boolean [ Internal ]
{
	Set tIsForPatient = 0
	
	// %patComp is a specialized copy of the Patient Compartment info.
	
	If pFHIRVersion="DSTU2" {
		If '$Data(%patComp("DSTU2")) {
			Set %patComp("DSTU2","Account","subject") = ""
			Set %patComp("DSTU2","AllergyIntolerance","patient") = ""
			Set %patComp("DSTU2","AllergyIntolerance","recorder") = ""
			Set %patComp("DSTU2","AllergyIntolerance","reporter") = ""
			Set %patComp("DSTU2","Appointment","actor") = ""
			Set %patComp("DSTU2","AppointmentResponse","actor") = ""
			Set %patComp("DSTU2","AuditEvent","patient") = ""
			Set %patComp("DSTU2","Basic","author") = ""
			Set %patComp("DSTU2","Basic","patient") = ""
			Set %patComp("DSTU2","BodySite","patient") = ""
			Set %patComp("DSTU2","CarePlan","participant") = ""
			Set %patComp("DSTU2","CarePlan","patient") = ""
			Set %patComp("DSTU2","CarePlan","performer") = ""
			Set %patComp("DSTU2","Claim","patient") = ""
			Set %patComp("DSTU2","ClinicalImpression","patient") = ""
			Set %patComp("DSTU2","Communication","recipient") = ""
			Set %patComp("DSTU2","Communication","sender") = ""
			Set %patComp("DSTU2","Communication","subject") = ""
			Set %patComp("DSTU2","CommunicationRequest","recipient") = ""
			Set %patComp("DSTU2","CommunicationRequest","requester") = ""
			Set %patComp("DSTU2","CommunicationRequest","sender") = ""
			Set %patComp("DSTU2","CommunicationRequest","subject") = ""
			Set %patComp("DSTU2","Composition","attester") = ""
			Set %patComp("DSTU2","Composition","author") = ""
			Set %patComp("DSTU2","Composition","subject") = ""
			Set %patComp("DSTU2","Condition","patient") = ""
			Set %patComp("DSTU2","DetectedIssue","patient") = ""
			Set %patComp("DSTU2","DeviceUseRequest","subject") = ""
			Set %patComp("DSTU2","DeviceUseStatement","subject") = ""
			Set %patComp("DSTU2","DiagnosticOrder","subject") = ""
			Set %patComp("DSTU2","DiagnosticReport","subject") = ""
			Set %patComp("DSTU2","DocumentManifest","author") = ""
			Set %patComp("DSTU2","DocumentManifest","recipient") = ""
			Set %patComp("DSTU2","DocumentManifest","subject") = ""
			Set %patComp("DSTU2","DocumentReference","author") = ""
			Set %patComp("DSTU2","DocumentReference","subject") = ""
			Set %patComp("DSTU2","Encounter","patient") = ""
			Set %patComp("DSTU2","EnrollmentRequest","subject") = ""
			Set %patComp("DSTU2","EpisodeOfCare","patient") = ""
			Set %patComp("DSTU2","FamilyMemberHistory","patient") = ""
			Set %patComp("DSTU2","Flag","patient") = ""
			Set %patComp("DSTU2","Goal","patient") = ""
			Set %patComp("DSTU2","Group","member") = ""
			Set %patComp("DSTU2","ImagingObjectSelection","author") = ""
			Set %patComp("DSTU2","ImagingObjectSelection","patient") = ""
			Set %patComp("DSTU2","ImagingStudy","patient") = ""
			Set %patComp("DSTU2","Immunization","patient") = ""
			Set %patComp("DSTU2","ImmunizationRecommendation","patient") = ""
			Set %patComp("DSTU2","List","source") = ""
			Set %patComp("DSTU2","List","subject") = ""
			Set %patComp("DSTU2","Media","subject") = ""
			Set %patComp("DSTU2","MedicationAdministration","patient") = ""
			Set %patComp("DSTU2","MedicationDispense","patient") = ""
			Set %patComp("DSTU2","MedicationOrder","patient") = ""
			Set %patComp("DSTU2","MedicationStatement","patient") = ""
			Set %patComp("DSTU2","MedicationStatement","source") = ""
			Set %patComp("DSTU2","NutritionOrder","patient") = ""
			Set %patComp("DSTU2","Observation","performer") = ""
			Set %patComp("DSTU2","Observation","subject") = ""
			Set %patComp("DSTU2","Order","subject") = ""
			Set %patComp("DSTU2","Patient","link") = ""
			Set %patComp("DSTU2","Person","patient") = ""
			Set %patComp("DSTU2","Procedure","patient") = ""
			Set %patComp("DSTU2","Procedure","performer") = ""
			Set %patComp("DSTU2","ProcedureRequest","orderer") = ""
			Set %patComp("DSTU2","ProcedureRequest","performer") = ""
			Set %patComp("DSTU2","ProcedureRequest","subject") = ""
			Set %patComp("DSTU2","Provenance","patient") = ""
			Set %patComp("DSTU2","QuestionnaireResponse","author") = ""
			Set %patComp("DSTU2","QuestionnaireResponse","subject") = ""
			Set %patComp("DSTU2","ReferralRequest","patient") = ""
			Set %patComp("DSTU2","ReferralRequest","requester") = ""
			Set %patComp("DSTU2","RelatedPerson","patient") = ""
			Set %patComp("DSTU2","RiskAssessment","subject") = ""
			Set %patComp("DSTU2","Schedule","actor") = ""
			Set %patComp("DSTU2","Specimen","subject") = ""
			Set %patComp("DSTU2","SupplyDelivery","patient") = ""
			Set %patComp("DSTU2","SupplyRequest","patient") = ""
			Set %patComp("DSTU2","VisionPrescription","patient") = ""
		}
	} ElseIf pFHIRVersion="STU3" {
		If '$Data(%patComp("STU3")) {
			Set %patComp("STU3","Account","subject") = ""
			Set %patComp("STU3","AdverseEvent","subject") = ""
			Set %patComp("STU3","AllergyIntolerance","patient") = ""
			Set %patComp("STU3","AllergyIntolerance","recorder") = ""
			Set %patComp("STU3","AllergyIntolerance","asserter") = ""
			Set %patComp("STU3","Appointment","actor") = ""
			Set %patComp("STU3","AppointmentResponse","actor") = ""
			//Set %patComp("STU3","AuditEvent","agent.patient") = ""
			//Set %patComp("STU3","AuditEvent","entity.patient") = ""
			Set %patComp("STU3","Basic","subject") = ""
			Set %patComp("STU3","Basic","author") = ""
			Set %patComp("STU3","BodySite","patient") = ""
			Set %patComp("STU3","CarePlan","subject") = ""
			Set %patComp("STU3","CarePlan","performer") = ""
			Set %patComp("STU3","CareTeam","subject") = ""
			Set %patComp("STU3","CareTeam","participant") = ""
			Set %patComp("STU3","ChargeItem","subject") = ""
			Set %patComp("STU3","Claim","patient") = ""
			Set %patComp("STU3","Claim","payee") = ""
			Set %patComp("STU3","ClaimResponse","patient") = ""
			Set %patComp("STU3","ClinicalImpression","subject") = ""
			Set %patComp("STU3","Communication","subject") = ""
			Set %patComp("STU3","Communication","sender") = ""
			Set %patComp("STU3","Communication","recipient") = ""
			Set %patComp("STU3","CommunicationRequest","subject") = ""
			Set %patComp("STU3","CommunicationRequest","sender") = ""
			Set %patComp("STU3","CommunicationRequest","recipient") = ""
			//Set %patComp("STU3","CommunicationRequest","requester.agent") = ""
			Set %patComp("STU3","Composition","subject") = ""
			Set %patComp("STU3","Composition","author") = ""
			Set %patComp("STU3","Composition","attester") = ""
			Set %patComp("STU3","Condition","subject") = ""
			Set %patComp("STU3","Condition","asserter") = ""
			Set %patComp("STU3","Consent","patient") = ""
			Set %patComp("STU3","Coverage","policy-holder") = ""
			Set %patComp("STU3","Coverage","subscriber") = ""
			Set %patComp("STU3","Coverage","beneficiary") = ""
			Set %patComp("STU3","Coverage","payor") = ""
			Set %patComp("STU3","DetectedIssue","patient") = ""
			Set %patComp("STU3","DeviceRequest","subject") = ""
			Set %patComp("STU3","DeviceRequest","performer") = ""
			Set %patComp("STU3","DeviceUseStatement","subject") = ""
			Set %patComp("STU3","DiagnosticReport","subject") = ""
			Set %patComp("STU3","DocumentManifest","subject") = ""
			Set %patComp("STU3","DocumentManifest","author") = ""
			Set %patComp("STU3","DocumentManifest","recipient") = ""
			Set %patComp("STU3","DocumentReference","subject") = ""
			Set %patComp("STU3","DocumentReference","author") = ""
			Set %patComp("STU3","EligibilityRequest","patient") = ""
			Set %patComp("STU3","Encounter","subject") = ""
			Set %patComp("STU3","EnrollmentRequest","subject") = ""
			Set %patComp("STU3","EpisodeOfCare","patient") = ""
			Set %patComp("STU3","ExplanationOfBenefit","patient") = ""
			Set %patComp("STU3","ExplanationOfBenefit","payee") = ""
			Set %patComp("STU3","FamilyMemberHistory","patient") = ""
			Set %patComp("STU3","Flag","subject") = ""
			Set %patComp("STU3","Goal","subject") = ""
			Set %patComp("STU3","Group","member") = ""
			Set %patComp("STU3","ImagingManifest","patient") = ""
			Set %patComp("STU3","ImagingManifest","author") = ""
			Set %patComp("STU3","ImagingStudy","patient") = ""
			Set %patComp("STU3","Immunization","patient") = ""
			Set %patComp("STU3","ImmunizationRecommendation","patient") = ""
			Set %patComp("STU3","List","subject") = ""
			Set %patComp("STU3","List","source") = ""
			Set %patComp("STU3","MeasureReport","patient") = ""
			Set %patComp("STU3","Media","subject") = ""
			Set %patComp("STU3","MedicationAdministration","subject") = ""
			Set %patComp("STU3","MedicationAdministration","performer") = ""
			Set %patComp("STU3","MedicationAdministration","subject") = ""
			Set %patComp("STU3","MedicationDispense","subject") = ""
			Set %patComp("STU3","MedicationDispense","subject") = ""
			Set %patComp("STU3","MedicationDispense","receiver") = ""
			Set %patComp("STU3","MedicationRequest","subject") = ""
			Set %patComp("STU3","MedicationStatement","subject") = ""
			Set %patComp("STU3","NutritionOrder","patient") = ""
			Set %patComp("STU3","Observation","subject") = ""
			Set %patComp("STU3","Observation","performer") = ""
			Set %patComp("STU3","Patient","link") = ""
			Set %patComp("STU3","Person","patient") = ""
			Set %patComp("STU3","Procedure","subject") = ""
			Set %patComp("STU3","Procedure","performer") = ""
			Set %patComp("STU3","ProcedureRequest","subject") = ""
			Set %patComp("STU3","ProcedureRequest","performer") = ""
			//Set %patComp("STU3","Provenance","target.subject") = ""
			//Set %patComp("STU3","Provenance","target.patient") = ""
			Set %patComp("STU3","QuestionnaireResponse","subject") = ""
			Set %patComp("STU3","QuestionnaireResponse","author") = ""
			Set %patComp("STU3","ReferralRequest","patient") = ""
			//Set %patComp("STU3","ReferralRequest","requester.agent") = ""
			Set %patComp("STU3","RelatedPerson","patient") = ""
			Set %patComp("STU3","RequestGroup","subject") = ""
			Set %patComp("STU3","RequestGroup","participant") = ""
			Set %patComp("STU3","ResearchSubject","individual") = ""
			Set %patComp("STU3","RiskAssessment","subject") = ""
			Set %patComp("STU3","Schedule","actor") = ""
			Set %patComp("STU3","Specimen","subject") = ""
			Set %patComp("STU3","SupplyDelivery","patient") = ""
			//Set %patComp("STU3","SupplyRequest","requester.agent") = ""
			Set %patComp("STU3","VisionPrescription","patient") = ""
		}
	}
	
	// If no property for Patient reference, it cannot possibly be for the specified patient.
	If '$Data(%patComp(pFHIRVersion,pResourceType)) Quit tIsForPatient
	
	Merge tReferenceProps = %patComp(pFHIRVersion,pResourceType)
	
	If pResourceObj.%IsA("%Library.DynamicObject") {
		Set tIsForPatient = ..FindRefForPatientJSON(pResourceObj, pPatientResourceId, .tReferenceProps)
	} Else {
		Set tIsForPatient = ..FindRefForPatientXML(pResourceObj, pPatientResourceId, .tReferenceProps)
	}
	
	Quit tIsForPatient
}

/// FindRefForPatientXML uses the resource %XML.Document object to check for reference
/// properties that point to the specified patient resource id.
ClassMethod FindRefForPatientXML(pResourceObj As %XML.Document, pResourceId, ByRef pReferenceProps) As %Boolean [ Internal ]
{
	#dim tNode As %XML.Node
	
	Set tFound = 0
	
	Set tNode = pResourceObj.GetDocumentElement()
	
	If 'tNode.MoveToFirstChild(1) Quit
	
	Set tPropName = tNode.LocalName
	If $Data(pReferenceProps(tPropName)) {
		Set tFound = ..CheckRefXML(tNode, pResourceId, tPropName)
		If tFound Quit
		Kill pReferenceProps(tPropName)
		If '$Data(pReferenceProps) Quit
	}

	While tNode.MoveToNextSibling(1) {
		Set tPropName = tNode.LocalName
		If $Data(pReferenceProps(tPropName)) {
			Set tFound = ..CheckRefXML(tNode, pResourceId, tPropName)
			If tFound Quit
			Kill pReferenceProps(tPropName)
			If '$Data(pReferenceProps) Quit
		}
	}
	
	Quit tFound
}

/// Called by FindRefForPatientXML.
ClassMethod CheckRefXML(pNode As %XML.Node, pResourceId, pPropName) As %Boolean [ Internal ]
{
	Set tFound = 0
	
	Set tSaveNodeId = pNode.NodeId
	
	If 'pNode.MoveToFirstChild(1) Quit
	
	Do {
		If pNode.LocalName="reference" {
			Set tRefVal = pNode.GetAttributeValue("value")
			If pPropName="patient" {
				If (tRefVal=pResourceId)||(tRefVal=("Patient/"_pResourceId)) {
					Set tFound = 1
					Quit
				}
			} Else {
				If tRefVal=("Patient/"_pResourceId) {
					Set tFound = 1
					Quit
				}
			}
		}
		If tFound Quit
		
	} While pNode.MoveToNextSibling(1) 
	
	Set pNode.NodeId = tSaveNodeId
	
	Quit tFound
}

/// FindRefForPatientJSON uses the resource %DynamicObject to check for reference
/// properties that point to the specified patient resource id.
ClassMethod FindRefForPatientJSON(pResourceObj As %Library.DynamicObject, pResourceId, ByRef pReferenceProps) As %Boolean [ Internal ]
{
	Set tFound = 0
	
	Set tPropName = ""
	
	For {
		Set tPropName = $Order(pReferenceProps(tPropName))
		If tPropName="" Quit
		Set tPropObj = pResourceObj.%Get(tPropName)
		If '$IsObject(tPropObj) Continue
		Set tRefVal = tPropObj.%Get("reference")
		If tPropName="patient" {
			If (tRefVal=pResourceId)||(tRefVal=("Patient/"_pResourceId)) {
				Set tFound = 1
				Quit
			}
		} Else {
			If tRefVal=("Patient/"_pResourceId) {
				Set tFound = 1
				Quit
			}
		}
		If tFound Quit
	}
	
	Quit tFound
}

}
