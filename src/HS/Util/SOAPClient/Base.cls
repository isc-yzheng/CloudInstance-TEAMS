Include (HS.HC, %soap)

Class HS.Util.SOAPClient.Base Extends (%RegisteredObject, HS.HC.Util.Trace.Helper) [ Inheritance = right, ProcedureBlock ]
{

Parameter MUSTUNDERSTANDACTION As %Boolean = 1;

Parameter MUSTUNDERSTANDREPLYTO As %Boolean = 1;

/// *** Deprecated *** use ServiceName
/// The configuration item name found in HS.Registry.Service.*
Property TargetName As %String;

/// The configuration item name found in HS.Registry.Service.*
Property ServiceName As %String(MAXLEN = 255);

/// Value of calculated end point either ServiceName or AdditionalInfo.GetAt("ServiceName")
Property ServiceNameValue As %String;

/// May be either 1.1 or 1.2 (1.2 is the default)
Property SOAPVersion As %String(VALUELIST = ",1.1,1.2") [ InitialExpression = "1.2" ];

/// *** Deprecated *** add the SSL configuration to the service registry end point
/// Set the following parameter to your TLS / SSL configuration name in Cache'
Property SSLConfiguration As %String;

/// *** Deprecated *** add credentials to the service registry end point
/// Names the credentials entry containing the WSSecurityLogin Username and Password values to be used if needed to access the SOAP service
Property SOAPCredentials As %String;

/// **** Deprecated **** SendSAMLAssertion should now be defined on the service registry end point
/// Controls whether SAML tokens should be sent in the Security headers for the SOAP call.
/// If using a XUAConfiguration and SendSAMLAssertion = 0 default it to 2 (create)
/// If the "Forward" option is selected, the SAMLCreator class will be used to forward a SAML
/// assertion if one is found in the Ensemble request message.
/// If the "Create" option is selected, the SAMLCreator class will be used to create a new SAML
/// assertion based on the data in the Ensemble request message.
/// The "Create then Forward" and "Forward then Create" option both indicate that an assertion should be
/// created in addition to forwarding an assertion if one is found, and the order they are added to the Security header
/// depends on the specific option chosen. If either approach fails to create an assertion, then an error will be thrown.
/// The "Forward or Create" option will attempt to forward an assertion, but if one can't be found in the request, an assertion will then
/// be created. If both operations fail, an error will be thrown.
Property SendSAMLAssertion As %Integer(DISPLAYLIST = ",No,Forward,Create,Create then Forward,Forward then Create,Forward or Create", VALUELIST = ",0,1,2,3,4,5") [ InitialExpression = 0 ];

/// **** Deprecated **** SAMLCreator should now be specified by adding a XUAConfig to the service registry end point
/// Classname of a class which extends HS.CHIxP.SAML.SAMLCreator,
/// which should be used for creating SAML assertions for requests. The process
/// of creating assertions is controlled by the SendSAMLAssertion property.
Property SAMLCreator As %String;

/// Timeout for getting a response from the remote SOAP server (the timeout for opening the connection to the server is always 5 seconds). Setting the timeout to -1 means wait forever.
Property ResponseTimeout As %Integer [ InitialExpression = 30 ];

Parameter WSADDRESSING = "AUTO";

/// Override the SSL server identity check 2014.1+, operation setting, overrides value in service registry
Property DisableSSLCheckServerIdentity As %Boolean [ InitialExpression = 0 ];

/// This method accepts a pWebRequest (%SOAP.WebRequest) as we may need to set some header information
/// This is also accepting a HS.Message.XMLMessage instead of just a stream 
Method InvokeWebService(pWebRequest As %SOAP.WebRequest = "", pWebServiceURL As %String(MAXLEN=256) = "", pSOAPAction As %String = "", pRequest As HS.Message.XMLMessage, pResponseBody As HS.Message.XMLMessage = "", pOneWay As %Boolean = 0) As %Status
{
	#dim eInvokeWebService As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If '$isObject(pWebRequest) Set pWebRequest = ##class(%SOAP.WebRequest).%New()
		Set tIsMTOM=pWebRequest.MTOMRequired
		If pWebServiceURL="" Set pWebServiceURL=pWebRequest.Location
		Set:pSOAPAction="" pSOAPAction=pWebRequest.AddressingOut.Action
		#dim tEndPoint as HS.Registry.Service.SOAP = ""
		/// For cases where the Host has Service name defined but specific transactions have a URL, define the ServiceName in the additional info with "" as a value (one example is DSUB consumer / subscribe to the broker but unsubscribe needs the address)
		Set tServiceName=$S(pRequest.AdditionalInfo.IsDefined("ServiceName"):pRequest.AdditionalInfo.GetAt("ServiceName"),pRequest.AdditionalInfo.GetAt("TargetName")]"":pRequest.AdditionalInfo.GetAt("TargetName"),..ServiceName]"":..ServiceName,1:..TargetName)
		$$$HSTRACE("EndPoint","tServiceName,tTargetName,pWebServiceURL,ServiceName,TargetName,pOneWay,ReplyAddress",pRequest.AdditionalInfo.GetAt("ServiceName"),pRequest.AdditionalInfo.GetAt("TargetName"),pWebServiceURL,..ServiceName,..TargetName,pOneWay,pRequest.AdditionalInfo.GetAt("ReplyAddress"))
		If tServiceName]"" {
			Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForNameType(tServiceName,"SOAP")
		}
		If '$isObject(tEndPoint) {
			If tServiceName]"" $$$LOGERROR("Service Name:"_tServiceName_" defined but not found in the service registry")
			If pWebServiceURL="" Set pWebServiceURL=pRequest.AdditionalInfo.GetAt("ReplyAddress")
			Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForURL(pWebServiceURL)
			If '$IsObject(tEndPoint) {
				Set tEndPoint=##class(HS.Registry.Service.SOAP).%New() Do tEndPoint.ParseURL(pWebServiceURL)
				Set tEndPoint.UsernameTokenProfileConfig=..SOAPCredentials
				Set:$e($zcvt(pWebServiceURL,"l"),1,5)="https" tEndPoint.SSLConfig=..SSLConfiguration
				Set tEndPoint.SendSAMLAssertion=..SendSAMLAssertion
			}
		}
		If tEndPoint.Host="" || (tEndPoint.URL="") {
			$$$LOGERROR("No end point defined") 
			Set tStatus=$$$ERROR($$$GeneralError,"No end point defined.")
			Quit
		}
		#; if the NoSSL is defined, we are using the test utility and we don't want SSL going to the trace
		Set:pRequest.AdditionalInfo.GetAt("NoSSL") tEndPoint.SSLConfig=""
		
		Set pWebRequest.Timeout		= $S(tEndPoint.Timeout:tEndPoint.Timeout,..ResponseTimeout=-1:2123456789,1:..ResponseTimeout)
		Set tEndPoint.Port=$Case(tEndPoint.Port,443:"",80:"",:tEndPoint.Port)
		Set tURLParams = pRequest.AdditionalInfo.GetAt("URLParameters") Set:tURLParams]"" tURLParams="?"_tURLParams
		Set pWebRequest.Location	= tEndPoint.EndPoint_tURLParams
		Set pWebRequest.MTOMRequired = $s(tIsMTOM:1,1:tEndPoint.MTOM)
		Set pWebRequest.SoapVersion	= $Case(tEndPoint.SOAPVersion = "", 0:tEndPoint.SOAPVersion, :"1.2")
		Set pWebRequest.SSLConfiguration = tEndPoint.SSLConfig
		#; on versions prior to 2014.1.x this setting did not exist
		Try { Set pWebRequest.SSLCheckServerIdentity=$S(..DisableSSLCheckServerIdentity:0,1:tEndPoint.SSLCheckServerIdentity) } Catch {}
			
		If (tEndPoint.UsernameTokenProfileConfig '= "") && ##class(Ens.Config.Credentials).%ExistsId(tEndPoint.UsernameTokenProfileConfig) {
			#dim tCredentials As Ens.Config.Credentials
			Set tCredentials = ##class(Ens.Config.Credentials).%OpenId(tEndPoint.UsernameTokenProfileConfig)
			Set tStatus = pWebRequest.WSSecurityLogin(tCredentials.Username, tCredentials.Password)
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}
		If $isObject(tEndPoint.XUAConfiguration) && (tEndPoint.XUAConfiguration.SAMLCreatorClass]"") {
			;# since we have a XUAConfiguration we want to send an assertion (default to create)
			Set tSendAssertion = tEndPoint.SendSAMLAssertion
			If tSendAssertion {
				Set tStatus = tEndPoint.XUAConfiguration.AddSAMLAssertions(pRequest,pWebRequest,tSendAssertion)
				Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
				$$$HSTRACE("Created XUA / SAML Assertion")
			}
		} ElseIf tEndPoint.SendSAMLAssertion || ..SendSAMLAssertion {
			#; old mechanism for adding SAML assertions
			Set tStatus = ..AddSAMLAssertions(pRequest, pWebRequest,$S(tEndPoint.SendSAMLAssertion:tEndPoint.SendSAMLAssertion,1:..SendSAMLAssertion))
			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
			$$$HSTRACE("Created XUA / SAML Assertion")
		}
		If tEndPoint.ProxyHost]"",tEndPoint.ProxyPort]"" {
			Set pWebRequest.HttpProxyPort=tEndPoint.ProxyPort
			Set pWebRequest.HttpProxyServer=tEndPoint.ProxyHost
			Set pWebRequest.HttpProxyHTTPS=tEndPoint.ProxyHTTPS
			Set pWebRequest.HttpProxySSLConnect=tEndPoint.ProxyHTTPSSLConnect
			Set pWebRequest.HttpProxyTunnel=tEndPoint.ProxyHTTPTunnel
			$$$HSTRACE("In Proxy ","tEndPoint,pWebRequest",tEndPoint,pWebRequest)
		}
		If tEndPoint.HTTPCredentialsConfig]"" {
			Set tCredentials = ##class(Ens.Config.Credentials).%OpenId(tEndPoint.HTTPCredentialsConfig)
			Set pWebRequest.HttpUsername=tCredentials.Username
			Set pWebRequest.HttpPassword=tCredentials.Password
		}

		Set:'$isObject(pWebRequest.AddressingOut) pWebRequest.AddressingOut	= ##class(%SOAP.Addressing.Properties).GetDefaultRequestProperties(pWebRequest.Location, pSOAPAction)
		Set:..#MUSTUNDERSTANDACTION&&'$D(pWebRequest.AddressingOut.mustUnderstand("Action")) pWebRequest.AddressingOut.mustUnderstand("Action")=..#MUSTUNDERSTANDACTION
		Set:..#MUSTUNDERSTANDREPLYTO&&'$D(pWebRequest.AddressingOut.mustUnderstand("ReplyTo")) pWebRequest.AddressingOut.mustUnderstand("ReplyTo")=..#MUSTUNDERSTANDREPLYTO
		Do pRequest.AdditionalInfo.SetAt(pWebRequest.Location,"WSA:To")
		Set tHttp = $Select(pWebRequest.SSLConfiguration'="":"https://",1:"http://")
		Set tPort = $Select(^%SYS("WebServer","Port")'="":":"_^%SYS("WebServer","Port"),1:"")
		Set tFrom = tHttp_$$$HSNetworkHostName_tPort_$system.CSP.GetDefaultApp($namespace)_"/"_..%ClassName(1)_".cls"
		Do pRequest.AdditionalInfo.SetAt(tFrom,"WSA:From")
		Set tSourceObj = ##class(%SOAP.Addressing.EndpointReference).%New(tFrom)
		Set tSourceObj.Address = tFrom
		Set pWebRequest.AddressingOut.SourceEndpoint = tSourceObj
		#; for async responses, update the relatesto value
		Set tRelatesToID = pRequest.AdditionalInfo.GetAt("RelatesTo")
		If tRelatesToID]"" {
			Set tRelatesTo=##class(%SOAP.Addressing.RelatesTo).%New()
	    	Set tRelatesTo.RelatesTo=tRelatesToID
			Set pWebRequest.AddressingOut.Relationship=tRelatesTo
		}
		
		
		#; only need to reload if we are testing with NoSSL option set
		Set:pRequest.AdditionalInfo.GetAt("NoSSL") tSC=tEndPoint.%Reload()
		If tEndPoint.SecurityClass="" {
			Set tStatus= ..AddSecurity(pWebRequest,tEndPoint,pRequest)
		} Else {
			Set tStatus = $classMethod(tEndPoint.SecurityClass,"AddSecurity",pWebRequest,tEndPoint,pRequest)
		}
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		#; Add attachments if not already done by caller
		If pWebRequest.MTOMRequired, pWebRequest.Attachments.Count() = 0 {
			$$$ThrowOnError(..MoveAttachments(pRequest,pWebRequest))
		}

		Set pResponseNode=##class(%XML.Node).%New()
		$$$HSTRACEMIN("ServiceRequest","ServiceName,ServiceValue,RequestContent",tEndPoint.Name,tEndPoint.EndPoint,pRequest)
		Do pRequest.ContentStream.Rewind()
		#; Send home community as part of enabling XCA Responding Gateway to read the XCPD patient id cache.
		If tEndPoint.DeviceFunction="XCA.Query" {
			Set tHomeCommunity = ##class(HS.IHE.Util).GetHomeCommunity()
			Set tHomeCommunityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tHomeCommunity, tHomeCommunity)
			If tHomeCommunityOID'="" {
				If pWebRequest.Location'["?" {
					Set pWebRequest.Location = pWebRequest.Location_"?"
				} Else {
					Set pWebRequest.Location = pWebRequest.Location_"&"
				}
				Set pWebRequest.Location = pWebRequest.Location_"sendingCommunityId="_tHomeCommunityOID
			}
		}		
		Set tStatus = pWebRequest.SendSOAPBody(pSOAPAction, pOneWay, pRequest.ContentStream, .pResponseNode)
		Set tAssertion = pWebRequest.SecurityOut.FindElement("Assertion")
		If '$IsObject(tAssertion) Set tAssertion = pWebRequest.SecurityOut.FindElement("SecurityElement")
		If $IsObject(tAssertion) $$$HSTRACEERROR("Assertion","Assertion",tAssertion)
		Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)

		If 'pOneWay {
			Set tWriter=##class(%XML.Writer).%New()
			Set tWriter.NoXMLDeclaration = 1
			If '$isObject(pResponseBody) {
				Set pResponseBody=##class(HS.Message.XMLMessage).%New()
				Do pResponseBody.AdditionalInfo.SetAt(pWebRequest.AddressingIn.Action,"ResponseSOAPAction")
			}
			Do tWriter.OutputToStream(pResponseBody.ContentStream)
			Set tStatus=tWriter.Canonicalize(pResponseNode,,1)

			If pWebRequest.ResponseAttachments.Count() {
				$$$ThrowOnError(..InsertAttachements(pResponseBody,pWebRequest,pSOAPAction))
			}
			Do pResponseBody.ContentStream.Rewind()
			$$$HSTRACEMIN("ServiceResponse","ResponseContent",pResponseBody)
			Do pResponseBody.ContentStream.Rewind()
			If tEndPoint.SecurityClass="" {
				Set tStatus=..ValidateResponse(pWebRequest,pSOAPAction)				
			} Else {
				Try {
					Set tStatus = $classMethod(tEndPoint.SecurityClass,"ValidateResponse",pWebRequest,pSOAPAction)
				} catch ex {
					If 'ex.AsStatus()["Method does" Throw ex
				}
			}
		}
	}
	Catch eInvokeWebService {
		Set tStatus = eInvokeWebService.AsStatus()
		$$$LOGSTATUS(tStatus)
	}
	Set tSC = pRequest.%Save()
	If $$$ISERR(tSC) {
		Set tStatus = $$$ADDSC(tStatus,tSC)
	}
	
	Set ..ServiceNameValue=""
	Quit tStatus
}

/// / Return the SOAPClient required to send async message
Method getAsyncWebRequest(pServiceName, pResponseServiceName, pAction) As %SOAP.WebRequest
{
	try {
		Set tWebRequest = ##class(%SOAP.WebRequest).%New()
		Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForNameType(pServiceName,"SOAP")
		Set tResponseEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForNameType(pResponseServiceName,"SOAP")
		Set tWebRequest.Location=tEndPoint.EndPoint
		#dim tAddressingOut as %SOAP.Addressing.Properties = ##class(%SOAP.Addressing.Properties).GetDefaultRequestProperties(tWebRequest.Location, pAction)
		Set tAddressingOut.ReplyEndpoint.Address=tResponseEndPoint.EndPoint
		Set tWebRequest.AddressingOut=tAddressingOut
	}Catch ex{
		throw ex
	}
	Quit tWebRequest
}

/// / Return the SOAPClient required to send async message
Method getAsyncSOAPClient(pServiceName, pResponseServiceName, pAction) As %SOAP.WebRequest
{
	try {
		Set tSOAPClient = ##class(%SOAP.WebRequest).%New()
		Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForNameType(pServiceName,"SOAP")
		Set tResponseEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForNameType(pResponseServiceName,"SOAP")
		Set tSOAPClient.Location=tEndPoint.EndPoint
		#dim tAddressingOut as %SOAP.Addressing.Properties = ##class(%SOAP.Addressing.Properties).GetDefaultRequestProperties(tSOAPClient.Location, pAction)
		Set tAddressingOut.ReplyEndpoint.Address=tResponseEndPoint.EndPoint
		Set tSOAPClient.AddressingOut=tAddressingOut
	}Catch ex{
		throw ex
	}
	Quit tSOAPClient
}

/// Deprecated - Define a HS.IHE.XUA.Config and assign to the Service Registry entry
/// Add SAML Assertions to the outgoing Security header based on the value of SendSAMLAssertions,
/// SAMLIssuer.
Method AddSAMLAssertions(pRequest As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest, pSendSAMLAssertion) As %Status
{
	Set tStatus = $$$OK
	Set tOptionCreate = 0
	
	Set (tCreatedAssertion, tForwardedAssertion) = $$$NULLOREF
	
	// Create first
	If $case(pSendSAMLAssertion, 2: 1, 3: 1, : 0) {
		Set tStatus = $classmethod(..SAMLCreator, "CreateSAML", pRequest, .tCreatedAssertion)
		If $$$ISERR(tStatus) Quit tStatus
	}
	// Forward
	If $case(pSendSAMLAssertion, 1: 1, 3: 1, 4:1, 5: 1, : 0) {
		Set tStatus = $classmethod(..SAMLCreator, "ForwardSAML", pRequest, .tForwardedAssertion)
		// Create the assertion if unable to forward and mode is "Forward or Create"
		If (pSendSAMLAssertion = 5)&&('$IsObject($G(tForwardedAssertion))) {
			Set tStatus = $$$OK
			Set tOptionCreate = 1
		}
		If $$$ISERR(tStatus) Quit tStatus
	}
	// Create second
	If $case(pSendSAMLAssertion, 4: 1, 5: tOptionCreate, : 0) {
		Set tStatus = $classmethod(..SAMLCreator, "CreateSAML", pRequest, .tCreatedAssertion)
		If $$$ISERR(tStatus) Quit tStatus
	}
	
	// Need to add assertions in reverse order, due to behaviour of security header output
	If $case(pSendSAMLAssertion, 2: 1, 4: 1, 5: tOptionCreate, : 0) {
		Do:$IsObject(tCreatedAssertion) pWebRequest.SecurityOut.AddToken(tCreatedAssertion)
		If pSendSAMLAssertion = 4 {
			Do:$IsObject(tForwardedAssertion) pWebRequest.SecurityOut.AddToken(tForwardedAssertion)
		}
	}
	If $case(pSendSAMLAssertion, 1: 1, 3: 1, 5: ('tOptionCreate), : 0) {
		Do:$IsObject(tForwardedAssertion) pWebRequest.SecurityOut.AddToken(tForwardedAssertion)
		If pSendSAMLAssertion = 3 {
			Do:$IsObject(tCreatedAssertion) pWebRequest.SecurityOut.AddToken(tCreatedAssertion)
		}
	}
	Quit tStatus
}

/// Ensure that SAMLCreator exists SendSAMLAssertion is not 0
Method OnInit() As %Status
{
	If ..SendSAMLAssertion {
		If (..SAMLCreator = "") {
			Quit $$$ERROR($$$EnsErrGeneral, "A SAMLCreator is required for sending SAML assertions, but none is specified")
		}
		Else {
			If '##class(%Dictionary.CompiledClass).%ExistsId(..SAMLCreator) {
				Quit $$$ERROR($$$ClassDoesNotExist, ..SAMLCreator)
			}
			If ('##class(%Dictionary.CompiledMethod).%ExistsId(..SAMLCreator_"||%Extends")) || ('$classmethod(..SAMLCreator, "%Extends", "HS.CHIxP.SAML.SAMLCreator")) {
				Quit $$$ERROR($$$EnsErrGeneral, "'"_..SAMLCreator_"' does not extend HS.CHIxP.SAML.SAMLCreator")
			}
		}
	}
	Quit $$$OK
}

/// For signatures and encryption it is possible to override this code since there are different options - this is the standard Healthshare mechanism
/// To define specific Security for a web service Create a class which extends HS.Util.SOAPClient.Base and Override the AddSecurity Class Method
/// Add your class name to the Service Registry entry which you would like to run different security
ClassMethod AddSecurity(pWebRequest As %SOAP.WebRequest = "", pEndPoint As HS.Registry.Service.SOAP, pRequest As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	try {
		#; Add Signature
		If pEndPoint.SignX509TokenProfile '= "" {
			Set tX509 = ##class(%SYS.X509Credentials).GetByAlias(pEndPoint.SignX509TokenProfile)
			Set tSecToken = ##class(%SOAP.Security.BinarySecurityToken).CreateX509Token(tX509)
			Do pWebRequest.SecurityOut.AddToken(tSecToken)
			Set tSignature = ##class(%XML.Security.Signature).CreateX509(tSecToken)
			Do pWebRequest.SecurityOut.AddElement(tSignature)
			Set tAssertion = pWebRequest.SecurityOut.FindElement("Assertion",.tSAMLPos)
			While $IsObject(tAssertion) {
				If '$IsObject(tAssertion.Signature) {
					Set tSecReference = ##class(%SOAP.Security.SecurityTokenReference).GetSAMLDirectReference("#"_tAssertion.SAMLID)
					Do pWebRequest.SecurityOut.AddToken(tSecReference)
					Set tReference = ##class(%XML.Security.Reference).CreateSTR(tSecReference.GetId())
					Do tSignature.AddReference(tReference)
				}
				Set tAssertion = pWebRequest.SecurityOut.FindElement("Assertion",.tSAMLPos)
			}
		}


		#; Add Encryption
		If pEndPoint.EncryptX509TokenProfile '= "" {
			Set tX509 = ##class(%SYS.X509Credentials).GetByAlias(pEndPoint.EncryptX509TokenProfile)
			Set tSecToken = ##class(%SOAP.Security.BinarySecurityToken).CreateX509Token(tX509)
			Do pWebRequest.SecurityOut.AddToken(tSecToken)
			Set tEncKey=##class(%XML.Security.EncryptedKey).CreateX509(tSecToken)
			Do pWebRequest.SecurityOut.AddElement(tEncKey)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod ValidateResponse(pWebRequest As %SOAP.WebClient, pSOAPAction As %String) As %Status
{
	Quit $$$OK
}

/// Copy SOAP attachments into response StreamCollection
Method InsertAttachements(pResponse As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest, pAction As %String) As %Status
{
	#dim tMIME As %Net.MIMEPart
	#dim tAtt  As HS.IHE.Common.Messages.MIMEAttachment
	Set tSC = $$$OK
	Try {
		Set i="" For { Set tMIME = pWebRequest.ResponseAttachments.GetNext(.i) Quit:i=""
			Set tAtt = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
			Set tAtt.ContentId = tMIME.ContentId
			Set tAtt.ContentTransferEncoding = tMIME.ContentTransferEncoding
			Set tAtt.ContentType = tMIME.ContentType
			$$$ThrowOnError(..OnSetAttachmentBody(pAction,tMIME,tAtt))
			$$$ThrowOnError(pResponse.StreamCollection.Insert(tAtt))
		}	
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Callback to copy MIME body into StreamCollection item body
Method OnSetAttachmentBody(pAction As %String, pFrom As %Net.MIMEPart, pTo As HS.IHE.Common.Messages.MIMEAttachment) As %Status
{
	#; Must copy here since %Net.MIMEPart clears the body when object closes
	Quit pTo.Body.CopyFrom(pFrom.Body)
}

/// Copy request StreamCollection into SOAP attachments 
Method MoveAttachments(pRequest As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest) As %Status
{
	#dim tMIME As %Net.MIMEPart
	#dim tAtt  As HS.IHE.Common.Messages.MIMEAttachment
	Set tSC = $$$OK
	Try {
		Quit:'$IsObject(pRequest.StreamCollection)
		Quit:pRequest.StreamCollection.Count()<1
		Set i="" For { Set tAtt = pRequest.StreamCollection.GetNext(.i) Quit:i=""
			Set tMIME = ##class(%Net.MIMEPart).%New()
			Set tMIME.Body = tAtt.GetBody()
			Set tMIME.ContentId = tAtt.ContentId
			Do tMIME.SetHeader("content-transfer-encoding", $S(tAtt.ContentTransferEncoding="":"binary",1:tAtt.ContentTransferEncoding))
			Do tMIME.SetHeader("content-type", $s(tAtt.ContentType="":"application/octet-stream",1:tAtt.ContentType))
			$$$ThrowOnError(pWebRequest.Attachments.Insert(tMIME))
		}
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
