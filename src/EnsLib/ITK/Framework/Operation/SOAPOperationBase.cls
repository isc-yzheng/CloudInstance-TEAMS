/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (%soap, EnsITK, EnsConstants)

/// This class is the base class for sending an ITK message. This class
/// does all the work in constructing and sending the message. Derived
/// classes must provide some of the details, which may be hard coded
/// values or other details it gets from somewhere.
Class EnsLib.ITK.Framework.Operation.SOAPOperationBase Extends (Ens.BusinessOperation, EnsLib.ITK.Framework.SOAPCommon) [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

/// The base URL of this Business Operation. <br>
/// E.g. http://server:port/  <br>
/// Absolute URLs of individual services will be<br>
/// constructed by concatinating this with relative<br>
/// paths drawn from the subsscriber capability registry
Property EndpointBaseURL As %String;

/// Vocabulary to use for creating fault messages from this Service.
Property FaultVocabulary As %String [ Required ];

/// This will be used as the UserNameToken in the outgoing SOAP Message if X509CertificateSign is not specified.
Property UserNameToken As %String;

Property EncryptionStandard As %String(VALUELIST = ",128-Bit,256-Bit,None") [ InitialExpression = "None", Required ];

/// Minimum time interval (in seconds) between two messages.
/// E.g. for 10 messages/minute, set this to 6.
/// This applies to both Asynch and Synch messages and that too only when Subscription Pull is False.
Property Throttle As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

/// Which SOAP sections to sign. 'None' will result in no signed sections. <br><br>
/// Codes for individual segments are as follows: <br>
/// None             0 <br>
/// SoapBody         1 <br>
/// Timestamp        2 <br>
/// Addressing     508 <br>
/// Action           4 <br>
/// FaultTo          8 <br>
/// From            16 <br>
/// MessageId       32 <br>
/// RelatesTo       64 <br>
/// ReplyTo        128 <br>
/// To             256 <br>
/// <br>
/// If mutiple sections are signed, specify sum of individual codes.<br>
/// E.g. if Timestamp, Action and From are signed, use 22 (2+4+16).
Property SignHeaders As %Integer(MINVAL = 0) [ InitialExpression = 0, Required ];

/// This will be used for Signing 
Property X509CertificateSign As %String;

/// This will be used for Body Encryption 
Property X509CertificateEncrypt As %String;

/// Optimise communication with application by using any available ITK SOAP extensions 
Property UseITKExtensions As %Boolean [ InitialExpression = 1 ];

Property BinarySOAP As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS = "EndpointBaseURL,FaultVocabulary,UserNameToken,EncryptionStandard,Throttle,SignHeaders,X509CertificateSign,X509CertificateEncrypt,UseITKExtensions,BinarySOAP";

Parameter INVOCATION = "Queue";

// Internal Use: Date/time when the last message was sent

Property LastMessageSentTime As %String;

// Internal Use: The request message id is kept for switchboard request/response callback

Property RequestMessageId As %String;

/// This is the base itk send operation that can be called if you have prepared
/// all the input. This is not directly exposed as a Business Operation method
/// because it does not handle errors (it is expected the caller will handle
/// errors)
/// 
/// Please note, the WebServiceClientClass and WebServiceURL and properties are
/// directly set on the adapter. It is the callers responsibility to reset these
/// as required. 
Method BaseITKSend(pAction As %String, pClientClass As %String, pUrl As %String, pClient As %SOAP.WebClient, pOneWay As %Boolean, pPayload As %CharacterStream, ByRef pResponse As %CharacterStream) As %Status
{
	// Setup the Adapter - need to call so setters fire appropriately!
	set ..Adapter.WebServiceURL = pUrl
	set ..Adapter.WebServiceClientClass=pClientClass
	set ..Adapter.%Client = pClient
	set ..Adapter.Credentials=..Adapter.Credentials
	set ..Adapter.SSLConfig=..Adapter.SSLConfig
	set ..Adapter.ProxyServer=..Adapter.ProxyServer
	set ..Adapter.ProxyPort=..Adapter.ProxyPort
	set ..Adapter.ProxyHTTPS=..Adapter.ProxyHTTPS
	set ..Adapter.ProxyPort=..Adapter.ProxyPort
	set ..Adapter.ResponseTimeout=..Adapter.ResponseTimeout
	
 	// Throttle as applicable
 	set sc=..PerformThrottle()
 	if 'sc quit sc
 	
 	// Invoke
	set sc = ..Adapter.InvokeWithSOAPBody(pAction, pOneWay, pPayload, .pResponse)
	
	// Call OnRequest for additional processing
	do ..OnRequest(sc, pAction, pOneWay, pResponse)
	
	quit sc
}

/// This method forms the SOAP request step by step given an ITKRequest from
/// the framework. This is not directly exposed on message map and it is up
/// to the derived class to do this if it wishes.
/// Note: The goto OnExit code mimics the old method to little changes!!!
Method SendWebRequest(pRequest As EnsLib.ITK.Framework.RequestBase, pResponse As EnsLib.ITK.Framework.ResponseBase) As %Status
{
	set sc = $$$OK
	set $ZERROR = ""
	set $ZTRAP="OnError"	
	
	// Setup our parameters
	set tResponse = ""						// Created so we always have a tResponse even if empty
	set tRelatedMessageId=""				// Created to we always have one
	set tBaseURL = ..Adapter.WebServiceURL 	// Taken so we can reset its value
	set tService=pRequest.ServiceName
	set sc=..DetermineServiceProperties(pRequest, .tAction, .tBehaviourType) if 'sc goto OnExit
	set sc=..DetermineInvocationPattern(pRequest, .tInvocationPattern) if 'sc goto OnExit
	set sc=..DetermineLogicalURL(pRequest, .tLogicalURL) if 'sc goto OnExit
	set sc=..DeterminePhysicalURL(pRequest, .tPhysicalURL) if 'sc goto OnExit
	set sc=..DetermineAddressing(pRequest, .tFrom, .tRelatesTo) if 'sc goto OnExit
	set sc=..DetermineApplication(pRequest, .tAppName) if 'sc goto OnExit
	set tOneWay = $S((tInvocationPattern = $$$ITKSyncInvocationPattern) && (tBehaviourType = $$$ITKBPRequestResponse):0, 1:1)
	
	// Determine Payload for the request
	set sc=..DeterminePayload(pRequest, .tPayload) if 'sc goto OnExit
	if ($IsObject(tPayload)) do tPayload.Rewind()
	
	// Setup the Client & Security Header
	set sc=..DetermineWebServiceClient(pRequest.ServiceName, .tWebClientClass) if 'sc goto OnExit
	set tClient = $CLASSMETHOD(tWebClientClass, "%New")
	set tClient.Location = tPhysicalURL
	set tClient.AddressingOut = ..CreateSOAPHeader(tLogicalURL, tFrom, tRelatesTo, tAction, tInvocationPattern, tBehaviourType)
	set tRelatedMessageId = tClient.AddressingOut.MessageId
	set sc=..CreateSecurityHeader(.tClient, .tSecurity) if 'sc goto OnExit
	set tClient.SecurityOut = tSecurity	
	
	set sc = ..BaseITKSend(tAction, tWebClientClass, tPhysicalURL, tClient, tOneWay, tPayload, .tResponse)
	if 'sc goto OnExit
	
	do ..OnITKRequest(sc, pRequest, tRelatedMessageId, tBehaviourType)
	
OnExit
	If ($$$GETERRORCODE(sc)=$$$ERRORCODE($$$SOAPFaultReceived)) {
		$$$LOGWARNING("SOAP Fault Received: "_ ..Adapter.%Client.SoapFault.AsString())
	}
	
	// Reset the web service url
	set ..Adapter.WebServiceURL = tBaseURL
	
	// Form the response
	set pResponse = ..GenerateResponse(pRequest, $G(tInvocationPattern,""),$G(tBehaviourType,""), $G(tAppName,""))
	set:pResponse="" pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
	set pResponse.MessageId = $G(tRelatedMessageId,"")
	set pResponse.ResponseBody = $G(tResponse,"")
	set pResponse.Status = sc
	quit sc
	
OnError
	set $ZTRAP = ""
	set sc = $$$ERROR($$$EnsErrGeneral, $ZERROR)
	$$$LOGERROR($ZERROR)
	
	goto OnExit
}

/// This is called after the request has been sent in the base class
Method OnRequest(pStatus As %Status, pAction As %String, pOneWay As %Boolean, ByRef pResponse As %CharacterStream) As %Status
{
	if ..UseITKExtensions && $$$ISOK(pStatus)
 	{
		set useBinarySOAP=0
		set h = ..Adapter.%Client.HeadersIn

		set cp=h.GetAt("ITKExtensions")
		if $IsObject(cp)
		{
	 		#dim cp As EnsLib.ITK.Framework.ITKExtensions
	 		do cp.XMLExportToString(.str)
			if cp.Extension.Find("UseBinarySOAP") Set useBinarySOAP=1
		}
	 		
		if (..BinarySOAP '= useBinarySOAP)
		{
	 		set ..BinarySOAP = useBinarySOAP
	 		$$$LOGINFO("Setting Binary SOAP to "_$S(useBinarySOAP:"ON",1:"OFF"))
		}
 	}
 	
 	quit $$$OK
}

/// This is called after the request message has been sent via an
/// EnsLib.ITK.Framework.RequestData operation. It is not called otherwise
Method OnITKRequest(pStatus As %Status, pRequest As EnsLib.ITK.Framework.RequestData, tMessageId As %String, tBehaviourType As %String) As %Status
{
	quit $$$OK
}

/// This method determines the payload. This is either as per the request
/// or if the request status is not OK then it forms a fault payload.
/// This must be implemented by the derived class
Method DeterminePayload(pRequest As EnsLib.ITK.Framework.RequestData, ByRef payload As %Stream.Object) As %Status [ Abstract ]
{
}

/// This method determines the action and behaviour type for the message
Method DetermineServiceProperties(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef action As %String, ByRef behaviourType As %String) As %Status
{
	set sc = $$$OK
	set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pRequest.ServiceName)

	if '$IsObject(sd) {
		set sc=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Service "_pRequest.ServiceName_" is not registered.")
	}
	else {
		set behaviourType = sd.BehaviourType
		set action = sd.SOAPAction
		set sc = pRequest.ModifyAction(.action, behaviourType)
	}	
	
	quit sc
}

/// This method determines the invocation pattern for the request.
/// This must be implemented by the derived class
Method DetermineInvocationPattern(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef pattern As %String) As %Status [ Abstract ]
{
}

/// This method determines the logical url to send the request into
/// This must be implemented by the derived class
Method DetermineLogicalURL(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef url As %String) As %Status [ Abstract ]
{
}

/// The method determines the physical url to send the request into
/// This must be implemented by the derived class
Method DeterminePhysicalURL(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef url As %String) As %Status [ Abstract ]
{
}

/// This method determines the URL to send request into
/// This must be implemented by the derived class
Method DetermineAddressing(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef fromUrl As %String, ByRef relatesTo As %String) As %Status
{
}

/// This method determines the application the business operation represents
Method DetermineApplication(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef appName As %String) As %Status
{
	set appName=""
	quit $$$OK
}

/// This method builds a response message and populates it with specifics relevant to the context
/// This method must be implemented by the derived class
Method GenerateResponse(pRequest As EnsLib.ITK.Framework.RequestBase, pResponseInvocationPattern As %String, pBehaviourType As %String, sourceApplication As %String) As EnsLib.ITK.Framework.ResponseBase [ Abstract ]
{
}

/// This method determines the web service client class to create
/// The default is based on whether we are using a binary soap message
/// or not, but this can be overridden as required.
Method DetermineWebServiceClient(pService As %String, ByRef clientClass As %String) As %Status
{
	set sc=$$$OK
	
	if (..UseITKExtensions && ..BinarySOAP)	{
		set clientClass="EnsLib.ITK.WebClients.binarySOAP"
	}
	else {
		set clientClass="EnsLib.ITK.WebClients.genericService"
	}
	
	// If using the registry and this is turned on overwrite if set
	set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(pService)
	if sd.WebClientClass'="" { set clientClass=sd.WebClientClass }
	
	quit sc
}

/// Perform any throttling. The base class performs a simply throttle
/// based on min time between requests and hangs the operation to ensure
/// that minimum is reached.
Method PerformThrottle() As %Status
{
	If ((..Throttle > 0) && (..LastMessageSentTime '= "")) {
		hang ( (..Throttle) - (##class(EnsLib.ITK.Util.UtilityMethods).GetTimeDiff(..LastMessageSentTime, $NOW())) )
	}
	Set ..LastMessageSentTime = $NOW()
	
	quit $$$OK
}

/// This internal method forms the SOAP header given
/// the logical endpoint url, the request, the SOAP action, the invocation pattern
/// and the behaviour type.
Method CreateSOAPHeader(pTo As %String, pFrom As %String, pRelatesTo As %String, pAction As %String, invocationPattern As %String, behaviourType As %String) As %SOAP.Addressing.Properties [ Private ]
{
	Set tAddressingOut = ##class(%SOAP.Addressing.Properties).%New()
	
	//Generate New MessageId
	Set tMessageId = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
	
	// If Async we need the reply to and fault to addresses
	// Note: We consider fault to an optional setting
	If ((invocationPattern = $$$ITKAsyncInvocationPattern) && (behaviourType = $$$ITKBPRequestResponse))
	{
		do ..DetermineAsyncReplyAddresses(.tReplyTo, .tFaultTo)
		
		Set tAddressingOut.ReplyEndpoint = ##class(%SOAP.Addressing.EndpointReference).%New()
		Set tAddressingOut.ReplyEndpoint.Address = tReplyTo
		if $G(tFaultTo,"")'="" {
			Set tAddressingOut.FaultEndpoint = ##class(%SOAP.Addressing.EndpointReference).%New()
			Set tAddressingOut.FaultEndpoint.Address = tFaultTo
		}
	}
	
	Set tAddressingOut.MessageId = tMessageId
	Set tAddressingOut.Action = pAction
	
	If (pRelatesTo '= "") {
		Set tAddressingOut.Relationship = ##class(%SOAP.Addressing.RelatesTo).%New()
		Set tAddressingOut.Relationship.RelatesTo = pRelatesTo
	}
	
	Set tAddressingOut.Destination = pTo
	
	Set tAddressingOut.SourceEndpoint = ##class(%SOAP.Addressing.EndpointReference).%New()
	Set tAddressingOut.SourceEndpoint.Address = pFrom

	Quit tAddressingOut
}

/// This is called when forming the SOAP header if we have an asynchronous request.
Method DetermineAsyncReplyAddresses(ByRef pReplyTo As %String, ByRef pFaultTo As %String) As %Status
{
	set pReplyTo=""
	set pFaultTo=""
	quit $$$OK
}

/// This internal method creates the security header for an request
Method CreateSecurityHeader(ByRef pClient As %SOAP.WebBase, ByRef pSecurity As %SOAP.Security.Header) As %Status [ Private ]
{
	Set sc = $$$OK

 Set $ZT="OnError"	
	Set tSecurity = ##class(%SOAP.Security.Header).%New()

	// Add UserNameToken from Certificate
	Set tPassword = ""
	
	// Initialize username as device name or application catogory
	Set tUserName = ..UserNameToken
	
	// If X509CertificateSign is present, use it to get the usename.
	// If X509CertificateSign is not present -
	// 1. The username can remain as already initialized. 
	// 2. If SignHeaders = 0 i.e. no signature required, go ahead and send the request.
	// 2. If SignHeaders > 0, i.e. signature is required, then raise an error and quit.
	Set tX509Credential = ""
	
	If (..X509CertificateSign '= "") {
		Set tX509Credential = ##class(%SYS.X509Credentials).GetByAlias(..X509CertificateSign)
	}
		
	If ('$IsObject(tX509Credential)) {
		If ((..SignHeaders > 0)) {
			set sc = $$$ERROR($$$EnsErrGeneral,"X509Certificate not found. UserNameToken could not be set.")
			Goto OnExit
		}
	} Else {
		set tUserName = tX509Credential.SubjectDN
	}

	Set tUsertoken=##class(%SOAP.Security.UsernameToken).Create(tUserName, tPassword)
	Do tSecurity.AddToken(tUsertoken)
	
	Set tTimestamp = ##class(%SOAP.Security.Timestamp).Create(900)

	Do tSecurity.AddToken(tTimestamp)

	// Sign SOAP elements as selected in Setting
	If ((..SignHeaders > 0)) {

		If ($IsObject(tX509Credential)) {
			set tSecurityToken = ##class(%SOAP.Security.BinarySecurityToken).CreateX509Token(tX509Credential)
			Do tSecurity.AddToken(tSecurityToken)

			Set tSignature = ##class(%XML.Security.Signature).CreateX509(tX509Credential, +(..SignHeaders))
			Set tSignature.SignatureOptions = +(..SignHeaders)
			Do tSecurity.AddElement(tSignature)
		}
	}

	// Encryption
	If (..EncryptionStandard '= "None") {
		
		Set tX509Encrypt = ""
		If (..X509CertificateEncrypt '= "") {
			Set tX509Encrypt = ##class(%SYS.X509Credentials).GetByAlias(..X509CertificateEncrypt)
		}		
		If ('$IsObject(tX509Encrypt)) {
			set sc = $$$ERROR($$$EnsErrGeneral,"X509CertificateEncrypt not found. Cannot encrypt SOAP Body.")
			Goto OnExit
		}
		
		Set tAlgorithm = $S(..EncryptionStandard="128-Bit":$$$SOAPWSaes128cbc, 1:$$$SOAPWSaes256cbc)
		Set tEncryptedKey = ##class(%XML.Security.EncryptedKey).CreateX509(tX509Encrypt)
		Set tEncryptedKey.Algorithm = tAlgorithm
		Do tSecurity.AddElement(tEncryptedKey)
	}

OnExit
	If ($IsObject(tSecurity)) Set pSecurity = tSecurity
	Quit sc
OnError
	Set $ZT=""
	$$$LOGERROR($ZERROR)	
	set sc = $$$ERROR($$$EnsErrGeneral,"Error in creating Security Header.")
	Goto OnExit
}

/// This helper method constructs a correctly formed ITK response message
Method MakeFaultPayload(pFaultCode As %String, pStatus As %Status, ByRef pStream As %GlobalCharacterStream) [ Private ]
{

	If $get(pFaultCode)="" Set pFaultCode=$$$FAULTServer
	Set tFaultString=$$$FormatMessage("","%ObjectErrors",$$$ERRORCODE($$$InternalError))	
	
	Set fault=##class(%SOAP.Fault).%New()
	Set fault.faultcode=pFaultCode
	Set fault.faultstring=tFaultString
	Set fault.detail = $system.Status.GetOneErrorText(pStatus,1)
	Set fault.faultactor=""
	
	If ((pFaultCode=$$$FAULTClient) || (pFaultCode=$$$FAULTServer)) {
		If (..FaultVocabulary '= "") {
			Set fault.detail=..MakeFaultDetail(..FaultVocabulary, fault.detail,pStatus)
		}
	}
	else
	{
		$$$LOGWARNING("FAULT:"_pFaultCode_" "_fault.detail)
	
	}

	//Set tResponseStr = ##class(EnsLib.ITK.Util.UtilityMethods).XMLExportToString(fault,1)
	set pStream=##class(%GlobalCharacterStream).%New()
	
	set writer=##class(%XML.Writer).%New()
	do writer.OutputToStream(pStream)
	
	do writer.RootObject(fault,"fault",$$$SOAPENVns)
}

}
