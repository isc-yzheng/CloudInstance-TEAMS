/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsITK)

/// SOAP Service - Acts both as Business and Web Service.
Class EnsLib.ITK.Framework.Service.SOAPServiceBase Extends (EnsLib.SOAP.Service, EnsLib.ITK.Framework.SOAPCommon) [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.SOAP.InboundAdapter";

Parameter SETTINGS = "EndpointURL,MaxFileSizeMB,FaultVocabulary,PromoteITKExtensions,WSSecurityPassword,SignedHeaders,SOAPBodyEncrypted,TargetConfigName,SynchronousTimeout";

/// Send an Alert message whenever an error occurs here
/// Overridden to set default to True
Property AlertError As %Boolean [ InitialExpression = 1 ];

Property WebServiceClassName As %String;

Property WebServiceName As %String;

/*
** Properties for Business Service Settings 
*/
/// The complete URL of this Business Service. <br>
/// E.g. http://server:port/csp/itk/ITK.Framework.Service.SOAPRequestHandler.cls
Property EndpointURL As %String(MAXLEN = "");

/// Vocabulary to use for creating fault messages from this Service.
Property FaultVocabulary As %String [ Required ];

/// If True, the UserNameToken and Password will be verified against registered User Credentials.
/// Before making this Required, make sure that the expected Usernames are setup as users in advance.
Property WSSecurityPassword As %String(VALUELIST = ",Required,Ignore") [ InitialExpression = "Ignore", Required ];

/// The SOAP sections that MUST be signed in the incoming message. <br>
/// If any of these is not found to be signed, a SOAP fault will be returned. <br><br>
/// Codes for individual segments are as follows: <br>
/// None             0 <br>
/// SoapBody         1 <br>
/// Timestamp        2 <br>
/// Action           4 <br>
/// FaultTo          8 <br>
/// From            16 <br>
/// MessageId       32 <br>
/// RelatesTo       64 <br>
/// ReplyTo        128 <br>
/// To             256 <br>
/// <br>
/// If mutiple sections are signed, specify sum of individual codes.<br>
/// E.g. if Timestamp, Action and From are signed, use 22 (2+4+16).<br><br>
/// If 0, the check for Username to be same as Subject of X509 Certificate will also be skipped.
Property SignedHeaders As %Integer(MINVAL = 0) [ InitialExpression = 0, Required ];

/// If Required, request will be rejected if SOAP Body is not encrypted.
Property SOAPBodyEncrypted As %String(VALUELIST = ",Required,Ignore") [ InitialExpression = "Ignore", Required ];

/// Maximum SOAP Body size that should be processed. If size exceeds this, a SOAP fault will be returned.
Property MaxFileSizeMB As %Float [ InitialExpression = 5, Required ];

/// Configuration item to which to send messages
Property TargetConfigName As %String(MAXLEN = 1000);

/// Timeout for sysncronous requests
Property SynchronousTimeout As %Float [ InitialExpression = -1 ];

/// Inform connecting application about any extened ITK capabilities which may be offered from this ITK service
/// Entensions available comprise:
/// SwitchQueueMode - allows an application to determine the Subcription Pull status of its devices Business Operations
/// UseBinarySOAP - compresses data exchanged between ITK applications
Property PromoteITKExtensions As %String [ InitialExpression = "SwitchQueueMode" ];

/*
** Related to Web Service
*/
/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "NONE";

/// The SECURITYIN parameter controls the treatment of a WS-Security header
/// in the input SOAP message.
/// The possible value of SECURITYIN are ALLOW, IGNORE and REQUIRE.<br>
/// - The default value of IGNORE will ignore any WS-Security headers in the input except for the
/// UsernameToken which can always be used to login the user.<br>
/// - The value of ALLOW will cause the WS-Security header to be verified on input.<br>
/// - The value of REQUIRE will require the presence of the WS-Secufrity header and
/// verify the header on input.<br><br>
/// 
/// Note that if validation of the Security header is enabled (ALLOW or REQUIRE),
/// then a CA file, named iris.cer, containing the trusted root X509 certificates
/// should be put in the Mgr directory if signature verification or decryption
/// is to be performed.  An optional Certificate Revocagtion List (iris.crl) may
/// also be put in the Mgr directory.
Parameter SECURITYIN As %STRING [ Constraint = "ALLOW,IGNORE,REQUIRE", Flags = ENUM ] = "REQUIRE";

/// A list of supported SOAP headers is specified as a comma separated list of input header 
/// specifications.  Each specification is of the form "headerName:headerClass" where
/// headerName is the element name of the supported header and 
/// headerClass is the %SOAP.Header subclass that corresponds to that header.  
/// This list defines all headers supported in the SOAP request. 
Parameter SOAPHEADERS = "Header:%SOAP.Header,Security:%SOAP.Security.Header";

/// The integer code of the HTTP status (if blank/0, then is 200 OK)
Property HttpStatus As %Integer [ Transient ];

Method ProcessBody(pAction As %String, requestBody As %GlobalCharacterStream, ByRef responseBody As %GlobalCharacterStream) As %Boolean
{
	Set ..HttpStatus=0
	Set tSC=..ProcessInput(requestBody, .responseBody, pAction)
	Quit $$$ISOK(tSC)
}

Method Process(pAction As %String, ByRef request, needHeaders As %Boolean = 1) [ ServerOnly = 1 ]
{
	;Set:..SoapFault'="" ..Adapter.HTTPStatus=400

	Set handler = ..ImportHandler
	Set tree=handler.DocumentId
	if tree'="" {
		#; Find a FAULT - change the namespace before the SOAP framework gets to it
		Set root=$$$xmlGetDocumentElement(tree)
		If ($$$xmlGetNodeType(tree,root)'=$$$xmlELEMENTNODE) || ($$$xmlGetLocalName(tree,root)'="Envelope") GoTo super

		Set %soapenv=$$$xmlNamespaceToIndex(tree,$$$SOAPENVns)
		If (%soapenv="") || ($$$xmlGetNamespaceIndex(tree,root)'=%soapenv) {
			Set %soapenv=$$$xmlNamespaceToIndex(tree,$$$SOAP12ENVns)
		}
		$$$xmlFirstChildElement(tree,root,node)

		If $$$xmlGetLocalName(tree,node)="Header" {
			$$$xmlFirstChildElement(tree,root,node)
			$$$xmlNextChildElement(tree,root,node)
		}
		If (node="") || ($$$xmlGetLocalName(tree,node)'="Body") GoTo super

		#; Got body element
		$$$xmlFirstChildElement(tree,node,message)
		If (message="") || ($$$xmlGetNodeType(tree,message)'=$$$xmlELEMENTNODE) GoTo super

		#; Check for SOAP Fault
		If ($$$xmlGetLocalName(tree,message)="Fault") && ($$$xmlGetNamespaceIndex(tree,message)=%soapenv) {
			$$$xmlInsertNamespace(tree,$$$ITKTempURN)
			Set tempurn=$$$xmlNamespaceToIndex(tree,$$$ITKTempURN)
			$$$xmlSetNamespaceIndex(tree,message,tempurn)
		}
	}
super
	do ##super(.pAction,.request,.needHeaders)
}

Method OnProcessInput(requestBody As %GlobalCharacterStream, ByRef responseBody As %GlobalCharacterStream, pAction As %String) As %Status
{
	Set tSC=$$$OK
	
	set ..HttpStatus=0
	Set FaultCode=""
	Set FaultReason=""
	Set invocationPattern = ""
	Set (tMsgCat, tCreated, tExpires) = ""

	Set tIsAllowed = ..AuthorizeRequest(.invocationPattern)
	If 'tIsAllowed {
		Set tSC=$$$ERROR($$$EnsErrGeneral,$$$ITKUnauthorisedRequest_"Sender ("_##class(EnsLib.ITK.Util.UtilityMethods).CNfromDN(..Username)_") not registered to invoke Web Service ("_..WebServiceName_") on this target ("_..%ConfigName_")")
		Quit ..processBodyFault(tSC,FaultCode,FaultReason)
	}

	// Build list of namespaces defined in SOAP Envelope
	Set tSC = ..GetEnvelopeNamespaces(.nsList)  Quit:$$$ISERR(tSC) ..processBodyFault(tSC,FaultCode,FaultReason)

	Set trackingId=""
	If $IsObject(requestBody) {
		Do requestBody.Rewind()
		Do ..AddNamespacesToBody(requestBody,nsList,.out)
		Do out.Rewind()
		Set requestBody = out

		//s trackingId= ..ExtractTrackingId(requestBody)
		Do requestBody.Rewind()
	}

	Set sd = ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(..WebServiceName)
	If '$IsObject(sd) {
		Set tSC=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Service "_ ..WebServiceName _" is not registered.")
		Quit ..processBodyFault(tSC,FaultCode,FaultReason)
	}

	If (sd.BehaviourType = $$$ITKBPAsynchResponseHandler) || (sd.BehaviourType = $$$ITKBPFaultHandler) {
		Set invocationPattern = $$$ITKAsyncResponseInvocationPattern
	} ElseIf invocationPattern=$$$ITKDerivedInvocationPattern {
		If sd.BehaviourType= $$$ITKBPRequestResponse {
			If ..AddressingIn.ReplyEndpoint.Address '= "" {
				Set invocationPattern=$$$ITKAsyncInvocationPattern
			} Else {
				Set invocationPattern=$$$ITKSyncInvocationPattern
			}
		} ElseIf sd.BehaviourType= $$$ITKBPQueueCollection {
			Set invocationPattern=$$$ITKSyncInvocationPattern
		} Else {
			Set invocationPattern=$$$ITKAsyncInvocationPattern
		}
	}

	//Validate SOAP Address Header
	Set tSC = ..ValidateWSAddressHeader(pAction,sd.BehaviourType, invocationPattern)  Quit:$$$ISERR(tSC) ..processBodyFault(tSC,$$$FAULTClient,FaultReason)

	//Validate SOAP Security Header
	Set tSC = ..ValidateWSSecurityHeader(pAction, invocationPattern, .pCreated, .pExpires)  Quit:$$$ISERR(tSC) ..processBodyFault(tSC,$$$FAULTClient,FaultReason)

	//If message body size exceeds max message size property MaxFileSizeMB raise error
	If (requestBody.Size > ((..MaxFileSizeMB)*1048576)) {
		Set tSC = $$$ERROR($$$EnsErrGeneral, $$$ITKGeneralError_"Max Message Body Size Limit of "_..MaxFileSizeMB_" MB Exceeded")
		Quit ..processBodyFault(tSC,$$$FAULTClient,FaultReason)
	}
	//Prepare Request with the message and WS-Addressing attributes
	Set tRequest = ##class(EnsLib.ITK.Framework.RequestData).%New()
	Set tRequest.ServiceName = ..WebServiceName
	Set tRequest.Action = pAction
	Set tRequest.InvocationPattern = invocationPattern
	Set tRequest.SourceApplication = ##class(EnsLib.ITK.Util.UtilityMethods).CNfromDN(..Username)
	Set tRequest.Payload = requestBody

	// Get the distribution envelope if there is one, except when this is a response
	if invocationPattern'=$$$ITKAsyncResponseInvocationPattern {
		Set tSC =..ProcessDistributionEnvelope(requestBody, .tDistributionEnvelope, .tRealPayload)  Quit:$$$ISERR(tSC) ..processBodyFault(tSC,$$$FAULTClient,FaultReason)
	}

	// If we have a distribution envelope, validate it
	if $G(tDistributionEnvelope)'="" {
		set tRequest.Payload=tRealPayload
		set tRequest.DistributionEnvelope=##class(EnsLib.EDI.XML.Document).ImportFromString(tDistributionEnvelope)
		set tSC=..ValidateDistributionEnvelope(pAction, tRequest.DistributionEnvelope, sd)  Quit:$$$ISERR(tSC) ..processBodyFault(tSC,$$$FAULTClient,FaultReason)
	}
	Set tRequest.DistributionMode=..DetermineDistributionMode()

	Set tRequest.MessageId = ..AddressingIn.MessageId	
	Set tRequest.Created = tCreated
	Set tRequest.Expires = tExpires
	Set tRequest.Status = $$$OK
	Set tRequest.To = ..AddressingIn.Destination
	Set tRequest.RelatesTo = ..AddressingIn.Relationship.RelatesTo
	Set tRequest.ReplyTo = ..AddressingIn.ReplyEndpoint.Address
	Set tRequest.FaultTo = ..AddressingIn.FaultEndpoint.Address

	Set tSeqNo = $I(^EnsITK.SEQNO)
	Set tRequest.SequenceNumber = tSeqNo

	Do ..MakeResponseHeader()
	Set ..AddressingOut.Action=pAction_"Response" ; Add to meet ITK standards
	Do ..MakeFaultHeader()

	// If there will be a response and client is waiting for it ...
	Set responseExpected=(sd.BehaviourType=$$$ITKBPRequestResponse)||(sd.BehaviourType=$$$ITKBPQueueCollection)
	If (invocationPattern=$$$ITKSyncInvocationPattern)&&(responseExpected) {
		Set tDeferredResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()

		Set tSC = ..SendRequestAsync(..TargetConfigName, tRequest,0)  Quit:$$$ISERR(tSC) ..processBodyFault(tSC,FaultCode,FaultReason)
		Set tSC = ..SendRequestSync("DeferResponse", ##class(Ens.Request).%New(), .tDeferredResponse, ..SynchronousTimeout)  Quit:$$$ISERR(tSC) ..processBodyFault(tSC,FaultCode,FaultReason)

		If ('$IsObject(tDeferredResponse)) {
			Set tSC = $$$ERROR($$$EnsErrGeneral, $$$ITKGeneralError_$$$ITKFaultNoResponse)
			Quit ..processBodyFault(tSC,FaultCode,FaultReason)
		}
		Quit:$$$ISERR(tDeferredResponse.Status) ..processBodyFault(tDeferredResponse.Status,tDeferredResponse.FaultCode,FaultReason)

		Set responseBody = tDeferredResponse.ResponseBody
		If ($IsObject(responseBody)) {
			 //Do responseBody.Rewind()
			 //s str = responseBody.Read()
			 Do responseBody.Rewind()
		}
	} Else {
		Set tSC = ..SendRequestAsync(..TargetConfigName, tRequest,0)
		quit:$$$ISERR(tSC) ..processBodyFault(tSC,FaultCode,FaultReason)
	
		// Send back an acknowledgement, or a HTTP 202	
		if (sd.BehaviourType=$$$ITKBPPost)||(sd.BehaviourType=$$$ITKBPAcknowledged) { do ..MakeStandardResponse(.responseBody) }
		else { 
			set ..OneWay = 1 
			set ..HttpStatus = 202
		}
	}

	If ..PromoteITKExtensions'="" {
		Set ext=##class(EnsLib.ITK.Framework.ITKExtensions).%New()
		Set l = $LFS(..PromoteITKExtensions,",")
		Do:$LF(l,"SwitchQueueMode") ext.Extension.Insert("SwitchQueueMode")
		Do:$LF(l,"UseBinarySOAP") ext.Extension.Insert("UseBinarySOAP")

		Do ..HeadersOut.SetAt(ext,"ITKExtensions")
	}
	Quit $$$OK
}

Method processBodyFault(pSC As %Status, pFaultCode As %String, pFaultReason As %String) As %Status [ Internal ]
{
	// Note: CFH suggest this should always be 500. Arguably better if inspect type of fault and set to 400/500 - extend fault registry?
	set ..HttpStatus = 500
	
	Set ecl=$LFS($system.Status.GetErrorCodes(pSC))

	// Enhance error resolution
	If $LF(ecl,$$$ERRORCODE($$$KeyNotUnique)) {
		Set pSC=$$$ADDSC($$$ERROR($$$EnsErrGeneral,$$$ITKInvalidAddressing_"Message Id is not globally unique"),pSC)
		Set pFaultCode=$$$FAULTClient
	}
	Set ..SoapFault = ..MakeStatusFault(pFaultCode,pFaultReason,pSC)	
	Quit pSC
}

/// Base (internal) method overridden to prevent an empty body to a HTTP 202
Method WriteSOAPMessage(body As %SOAP.Descriptor, tag As %String, isService As %Boolean, mimeAttachments As %Net.MIMEPart, bodyStream As %CharacterStream) As %Status [ Internal, ServerOnly = 1 ]
{
	// Allow empty 202 responses
	Quit:($D(bodyStream)=0)||('$IsObject(bodyStream))||(bodyStream.Size=0) $$$OK

	Quit ##super(.body,.tag,.isService,.mimeAttachments,.bodyStream)
}

ClassMethod captureNamespaces(tree, node, ByRef ns, ByRef nsExternal, iterate = 0)
{
	Merge:iterate nssave = ns

	Set att=$$$xmlFirstAttributeName(tree,node)
	While att'="" {
		If $$$xmlGetAttrNamespaceURI(tree,node,att) = $$$XMLNSns {
			Set nspace = $$$xmlGetAttribute(tree,node,att)
			Set i = $$$xmlNamespaceToIndex(tree,nspace)
			Set ns(att)=nspace
		}

		Set att = $$$xmlNextAttributeName(tree,node,att)
	}

	Set att=$$$xmlFirstAttributeName(tree,node)
	While att'="" {
		If $$$xmlGetAttrNamespaceURI(tree,node,att) '= $$$XMLNSns {
			Set attqname = $$$xmlGetAttrQName(tree,node,att)
			If $L(attqname,":")>1 {
				Set prefix = $P($$$xmlGetAttrQName(tree,node,att),":",1)	
				Set:($G(ns(prefix))="")&&($G(nsExternal(prefix))="") nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
				If ($G(ns(prefix))="") && ($G(nsExternal(prefix))="") {
					Set nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
				}
			}

			If $$$xmlGetAttrValueNsURI(tree,node,att)'="" {
				Set prefix = $P($$$xmlGetAttribute(tree,node,att),":",1)	
				If ($G(ns(prefix))="") && ($G(nsExternal(prefix))="") {
					Set nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
				}
			}
		}
		Set att = $$$xmlNextAttributeName(tree,node,att)
	}
	
	If $L($$$xmlGetQName(tree,node),":")>1 {
		Set prefix = $P($$$xmlGetQName(tree,node),":",1)
		If ($G(ns(prefix))="") && ($G(nsExternal(prefix))="") {
			Set nsExternal(prefix)=$$$xmlGetLocalName(tree,node)
		}
	}

	If (iterate) {
		$$$xmlFirstChildElement(tree,node,el)
		While el'="" {
			If $$$xmlGetNodeType(tree,el) = $$$xmlELEMENTNODE {
				Do ..captureNamespaces(tree,el,.ns,.nsExternal,iterate)
			}
			$$$xmlNextChildElement(tree,node,el)
		}
	}
	Merge:iterate ns = nssave
}

Method GetEnvelopeNamespaces(Output nsList As %ArrayOfDataTypes) As %Status
{
	Set ih = ..ImportHandler
	Set tree=ih.DocumentId

	Set nsList = ##class(%ArrayOfDataTypes).%New()

	Set root=$$$xmlGetDocumentElement(tree)

	Set (nsOuter,nsInner,nsUndefined)=""
	If ($$$xmlGetNodeType(tree,root)'=$$$xmlELEMENTNODE) || ($$$xmlGetLocalName(tree,root)'="Envelope") GoTo Exit

	; "namespaces defined in envelope"
	Do ..captureNamespaces(tree,root,.nsOuter,.nsUndefined)

	$$$xmlFirstChildElement(tree,root,node)

	If $$$xmlGetLocalName(tree,node)="Header" {
		$$$xmlFirstChildElement(tree,root,node)
		$$$xmlNextChildElement(tree,root,node)
	}

	If (node="") || ($$$xmlGetLocalName(tree,node)'="Body") GoTo Exit

	; "add namespaces defined in body"
	Do ..captureNamespaces(tree,node,.nsOuter,.nsUndefined)

	$$$xmlFirstChildElement(tree,node,el)

	; "identify namespaces used in body content which not defined locally"
	Do:el'="" ..captureNamespaces(tree,el,.nsInner,.nsUndefined,1)

	Set nspace=""  For { Set nspace=$O(nsUndefined(nspace),1,undefNS)  Quit:""=nspace
		If $G(nsOuter(nspace))'="" {
			Do nsList.SetAt(nsOuter(nspace),nspace)
			; "promoting namespace"
		} Else {
			$$$LOGWARNING("Namespace prefix:"_undefNS_" referenced in body content not defined in outer scope")
		}
	}
Exit
	Quit $$$OK
}

ClassMethod IsSOAPNS(ns As %String) As %Boolean
{
	Quit $Case(ns
		, $$$XMLNSns:1
		, $$$XSDns:1	
		, $$$XSIns:1
		, $$$WSDLns:1
		, $$$WSDLMIMEns:1
		, $$$SOAPns:1
		, $$$SOAP12ns:1 
		, $$$SOAPENVns:1
		, $$$SOAP12ENVns:1
		, $$$SOAPENCns:1
		, $$$SOAP12ENCns:1
		, $$$SOAP12RPC:1
		, $$$SOAPhttp:1
		, $$$ISCSOAPns:1
		, $$$ISCSOAPHeaderns:1
		, $$$SOAPWSSEns:1
		, $$$SOAPWSSE11ns:1
		, $$$SOAPWSUns:1
		, $$$SOAPWSAns:1	
		, :0)
}

ClassMethod AddNamespacesToBody(pRequestBody As %GlobalCharacterStream, pNSList As %ArrayOfDataTypes, ByRef pNSEnhancedBody As %GlobalCharacterStream) As %Status
{
	If (pNSList.Count()=0) {
		Set pNSEnhancedBody = pRequestBody
		Quit $$$OK
	}
	Set pNSEnhancedBody = ##class(%GlobalCharacterStream).%New()
	Set tString = pRequestBody.Read(32000, .tSC)  Quit:$$$ISERR(tSC)

	Set tIndex = $FIND(tString, ">")
	Set tRoot = $EXTRACT(tString, 1, tIndex-2)

	Set tSC = pNSEnhancedBody.Write(tRoot)  Quit:$$$ISERR(tSC) tSC

	Set tKey=""  For { Set tKey = pNSList.Next(tKey)  Quit:tKey=""
		Set tNS = pNSList.GetAt(tKey)
		If tNS'="" Set tSC = pNSEnhancedBody.Write(" xmlns:"_tKey_"="""_tNS_"""")  Quit:$$$ISERR(tSC)
	}
	Quit:$$$ISERR(tSC) tSC

	Set tSC = pNSEnhancedBody.Write(">")  Quit:$$$ISERR(tSC) tSC
	Set tSC =  pRequestBody.Rewind()  Quit:$$$ISERR(tSC) tSC
	Set tSC =  pRequestBody.MoveTo(tIndex)

	While '$$$ISERR(tSC) && 'pRequestBody.AtEnd {
		Set tSC = pNSEnhancedBody.Write(pRequestBody.Read())
	}
	Quit tSC
}

Method MakeStandardResponse(ByRef pStream As %GlobalCharacterStream)
{
	Set tResponseObj = ##class(EnsLib.ITK.Standard.SimpleMessageResponse).%New()
	Set tResponseStr = ##class(EnsLib.ITK.Util.UtilityMethods).XMLExportToString(tResponseObj,1)
	Set pStream=##class(%GlobalCharacterStream).%New()
	Do pStream.Write(tResponseStr)
}

/// Validate SOAP Header
/// 1. MessageId must be present
/// 2. To must be present and same as EndpointURL
/// 3. Action must be present and same as SOAPAction
Method ValidateWSAddressHeader(pAction As %String, pBehaviorType As %String, pPattern As %String) As %Status
{
	Set tMsg = ""
	If (..AddressingIn.MessageId = "") {
		Set tMsg = $$$ITKWSAFaultNoMessageId
	} Elseif ('(##class(EnsLib.ITK.Util.UtilityMethods).ValidateWSMessageId(..AddressingIn.MessageId))) {
		Set tMsg = $$$ITKWSAFaultBadMessageId
	} Elseif (..AddressingIn.Destination = "") {
		Set tMsg = $$$ITKWSAFaultNoTo
	} Elseif (..AddressingIn.Destination '= ..EndpointURL) {
		Set tMsg = $$$ITKWSAFaultBadTo_" "_..AddressingIn.Destination
	} Elseif (..AddressingIn.Action = "") {
		Set tMsg = $$$ITKWSAFaultNoAction
	} Elseif (..AddressingIn.Action '= pAction) {
		Set tMsg = $$$ITKWSAFaultNoAction
	} Elseif ((pPattern = $$$ITKAsyncInvocationPattern) && (pBehaviorType=$$$ITKBPRequestResponse) && (..AddressingIn.ReplyEndpoint.Address = "")) {
		Set tMsg = $$$ITKWSAFaultNoReplyTo
	} Elseif ((pPattern = $$$ITKAsyncResponseInvocationPattern) && (..AddressingIn.Relationship = "")) {
		Set tMsg = $$$ITKWSAFaultNoRelatesTo
	} 
	Quit:tMsg'="" $$$ERROR($$$EnsErrGeneral, $$$ITKInvalidAddressing_tMsg)
	Quit $$$OK
}

/// Validate SOAP Security Header
/// If SECURITYIN = "IGNORE": Do nothing
/// If SECURITYIN = "REQUIRE": Raise Fault if Security Header missing
/// Validate fields if Security Header is present - Takes care of the scenario SECURITYIN = "ALLOW"
/// 1. Timestamp (Created) must be present
/// 2. Username must be present
/// 3. Validate Signature
/// 4. Validate Encryption
Method ValidateWSSecurityHeader(pAction As %String, pPattern As %String, Output pCreated As %String, Output pExpires As %String) As %Status
{
	Quit:..#SECURITYIN="IGNORE" $$$OK

	Set tErrType = $$$ITKInvalidSecurity
	Set tWSHeader = ..SecurityIn

	If '$IsObject(tWSHeader) {
		If (..#SECURITYIN = "REQUIRE") {
			Set tMsg = $$$ITKWSFaultNoSecurityDetails
			Quit $$$ERROR($$$EnsErrGeneral, tErrType_tMsg)		
		} Else {
			Quit $$$OK
		}
	}
	Set tCreatedDate = ""
	Set tExpireDate = ""
	For i=1:1:tWSHeader.SecurityElement.Count() {
		Set tElement = tWSHeader.SecurityElement.GetAt(i)

		If ( $CLASSNAME(tElement) = "%SOAP.Security.Timestamp") {
			Set tCreatedDate = tElement.Created
			Set tExpireDate = tElement.Expires
		}
	}

	If (tCreatedDate = "") {
		Quit $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultNoCreatedTimestamp)
	} ElseIf (tExpireDate = "") {
		Quit $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultNoExpiresTimestamp)
	} Elseif ( (..Username = "") || (..Username = $CHAR(0)) ) {
		Quit $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultNoUsername)
	} ElseIf (..WSSecurityPassword = "Required")&&('$SYSTEM.Security.Login(..Username, ..Password)) {
		Quit $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_"Username "_..Username_" is not a registered user.")
	} Else {
		Set tSC = ..ValidateSignature()  Quit:$$$ISERR(tSC) tSC
		Set tSC = ..ValidateEncryption()  Quit:$$$ISERR(tSC) tSC
		
		// Now ensure message has not expired
		//set tCreatedH=$ZDTH(tCreatedDate,3,7)
		set tExpiresH=$ZDTH(tExpireDate,3,7)
		set tCurrentH=$H
		if (tExpiresH<tCurrentH)||((tExpiresH=tCurrentH)&&($P(tExpiresH,",",2)<$P(tCurrentH,",",2))) {
			Quit $$$ERROR($$$EnsErrGeneral, $$$ITKInvalidRequest_$$$ITKWSFaultExpiredTimestamp)
		}
	}
		
	Set pCreated = tCreatedDate
	Set pExpires = tExpireDate
	Quit $$$OK
}

Method ValidateSignature() As %Status
{
	Set $ZT="Error"
	Quit:..SignedHeaders=0 $$$OK

	Set tSecHeader = ..SecurityIn
	Set tSignature = tSecHeader.FindElement("Signature")
	Set tSignRef = tSignature.SignedInfo.Reference
	Set tSignedHeaders = 0

	For i=1:1:tSignRef.Count() {
		Set tURI = $E((tSignRef.GetAt(i)).URI, 2, *)

		Set tNodeId = ..ImportHandler.GetNodeById(tURI)
		Set tNode = ..ImportHandler.GetNode(tNodeId)

		If ($IsObject(tNode))&&(tNode.NodeType=$$$xmlELEMENTNODE) {
			Set tNodeName=tNode.LocalName
			Set:tNodeName="Body" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeSoapBody)
			Set:tNodeName="Timestamp" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeTimestamp)
			Set:tNodeName="Action" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeAction)
			Set:tNodeName="FaultTo" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeFaultTo)
			Set:tNodeName="From" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeFrom)
			Set:tNodeName="MessageId" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeMessageId)
			Set:tNodeName="RelatesTo" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeRelatesTo)
			Set:tNodeName="ReplyTo" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeReplyTo)
			Set:tNodeName="To" tSignedHeaders = $$$OR(tSignedHeaders, $$$SOAPWSIncludeTo)
		}
	}
	If ..SignedHeaders '= $$$AND(..SignedHeaders, tSignedHeaders) {
		Quit $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultUnsignedHeaders)
	}
	If (+(..SignedHeaders)) {
		Set tToken = tSecHeader.FindElement("BinarySecurityToken")

		Quit:'$IsObject(tToken) $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultNoBinaryToken)

		Set SubjectDN = $System.Encryption.X509GetField(tToken.Token,"Subject")
		If '##class(EnsLib.ITK.Util.UtilityMethods).DistinguishedNamesAreEqual(..Username, SubjectDN) {
			// This relaxed check (allow CN) should probably be configurable
			Quit:$F(SubjectDN, ..Username)=0 $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultMismatchedUsername)
		}
	}
	Quit $$$OK

Error
	Set $ZT=""
	Set tSC1=$$$EnsSystemError ; log exception but don't report to client
	Quit $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultInternalSignature)
}

Method ValidateEncryption() As %Status
{
	Set tSC = $$$OK, $ZT="Error"
	
	If ..SOAPBodyEncrypted '= "Ignore" {
		Set (element, tURI) = ""
		Set tSecHeader = ..SecurityIn
		Set tKey = tSecHeader.FindElement("EncryptedKey")

		// There is no way, at this point, that we can accurately say which message section was encrypted.
		// This is because the pre-decryption message is not retained.
		// Therefore the best we can do is to check if an EncryptedKey is present in the Header.
		// It's existence, though, implies only that there was "something" that was encrypted
		If ('$IsObject(tKey)) {
			Set tSC = $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultNoEncryption)
		}
	}
Exit
	Quit tSC

Error
	Set $ZT=""
	Set tSC = $$$ERROR($$$EnsErrGeneral, $$$ITKUnauthorisedRequest_$$$ITKWSFaultInternalEncryption)
	$$$LOGERROR($ZERROR)
	GoTo Exit
}

/// Get class name for a message descriptor class for this web method based on the SOAPAction
/// (overridden from base class)
Method GetMsgClass(action As %String, message As %Integer, Output methodName As %String) As %String [ Internal, ServerOnly = 1 ]
{
	// Just key the Service Registry on the action
	Set tService = ##class(EnsLib.ITK.Setup.ServiceDefinition).FromAction(action)

	If ('$IsObject(tService)) {
		If $$$ITKIsSOAPResponse(action) {
			If $IsObject(##class(EnsLib.ITK.Setup.ServiceDefinition).FromAction($$$ITKResponseAction(action))) {
				// I'm a response - is there a response handler that I could use on this endpoint ?
				
				Set tService= ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId($$$ITKAsyncResponseHandler) 
				If $IsObject(tService) && (tService.BehaviourType '= $$$ITKBPAsynchResponseHandler) {
					Set tService=$$$NULLOREF
				}
			}
		}
	}
	If ($IsObject(tService)) {
		Set className = tService.WebServiceClass
		If className="" {
			Do ..DetermineGenericService(.className, .methodName)
		} Else {
			Set cl = ##class(%Dictionary.CompiledClass).%OpenId(className)

			Set k="" For i=1:1 Set md=cl.Methods.GetNext(.k) Quit:'$IsObject(md)  quit:md.WebMethod

			Set methodName = md.Name
		}
		Set ..WebServiceClassName = className
		Set ..WebServiceName = tService.ServiceName
		Quit className
	}
	Quit ""
}

/// Create a SOAP fault.  Usually returned by ReturnFault method.
/// (overridden from base class)
ClassMethod MakeFault(pFaultCode As %String, pFaultString As %String, pDetail As %String = "", pFaultActor As %String = "", pStatus As %Status = "") As %SOAP.Fault [ ServerOnly = 1 ]
{
	Set:$G(pFaultCode)="" pFaultCode=$$$FAULTServer
	Set:$G(pFaultString)="" pFaultString=$$$FormatMessage("","%ObjectErrors",$$$ERRORCODE($$$InternalError))	

	Set fault=##class(%SOAP.Fault).%New()
	Set fault.faultcode=pFaultCode
	Set fault.faultstring=pFaultString
	Set fault.detail=pDetail
	Set fault.faultactor=""
	Set tVocab = ""

	If $$$IsdefObject(%cspsoapservice) {
		Set fault.faultactor= %cspsoapservice.EndpointURL
		Set tVocab = %cspsoapservice.FaultVocabulary
		Do %cspsoapservice.MakeFaultHeader()

		// ITK Requirements
		// - If there is a WS-A error then we must set SOAPAction to addressing fault
		// - If any server error then the HTTP Response must be 500
		// - If any client error then the HTTP Response must be 400
		If $FIND(pDetail,$$$ITKInvalidAddressing)>0 Set %cspsoapservice.FaultAddressing.Action="http://www.w3.org/2005/08/addressing/fault"
		;Set %cspsoapservice.Adapter.HTTPStatus=500
		;If pFaultCode=$$$FAULTClient Set %cspsoapservice.Adapter.HTTPStatus=400
	}
	If (pFaultCode=$$$FAULTClient) || (pFaultCode=$$$FAULTServer) {
		Set:tVocab'="" fault.detail=..MakeFaultDetail(tVocab,pDetail,pStatus)
	} Else {
		$$$LOGWARNING("FAULT:"_pFaultCode_" "_fault.detail)
	}
	Quit fault
}

/// Ensure we send an appropriate HTTP response if there is an error
/// This is an ITK requirement that a SOAP Fault is returned as a HTTP Error
Method OnAdapterHTTPResponse(ByRef pStatus As %Status, ByRef pHTTPResponseStatus As %String, ByRef pBodyLen As %Integer, ByRef pResponseBodyStream As %Stream.Object, Output pMainResponseHeader As %String = "", ByRef pHeaderExtra As %String)
{
	Set pHTTPResponseStatus=$S(..HttpStatus=500:"500 Internal Server Error", ..HttpStatus=400:"400 Bad Request", ..HttpStatus=202:"202 Accepted", 1:pHTTPResponseStatus)

	if ..HttpStatus=202 {
		set pStatus=1
		set pHTTPResponseStatus="202 Accepted"
		set pBodyLen=0
		set pResponseBodyStream=""
		set pMainResponseHeader="HTTP/1.1 202 Accepted"_$c(13,10)_"Content-Length: 0"_$c(13,10)
	}
	
	Quit
}

/// Create a SOAP fault based on a %Status value.
/// (overridden from base class)
ClassMethod MakeStatusFault(pFaultCode As %String, pFaultString As %String, pStatus As %Status = "", pFaultActor As %String = "") As %SOAP.Fault [ ServerOnly = 1 ]
{
	Set:$G(pFaultCode)="" pFaultCode=$$$FAULTServer
	Set:$G(pFaultString)="" pFaultString=$$$FormatMessage("","%ObjectErrors",$$$ERRORCODE($$$InternalError))
	//Do DecomposeStatus^%apiOBJ(pStatus,.tErr)
	//Set detail= tErr(1)
	Set detail = $$$StatusDisplayString(pStatus)
	Set fault=..MakeFault(pFaultCode,pFaultString,detail,pFaultActor,pStatus)
	Do ..OnInternalFault(fault,pStatus)
	Quit fault
}

Method MakeResponseHeader()
{
	// Set WS-Addressing
	Set ..AddressingOut = ..CreateSOAPHeader()

	// Create WS-Security Header
	Do ..CreateSecurityHeader()
}

Method MakeFaultHeader()
{
	// Set WS-Addressing
	Set ..FaultAddressing = ..CreateSOAPHeader()

	// ITK Req, if there is a fault set SOAPAction to fault
	Set ..FaultAddressing.Action="http://www.w3.org/2005/08/addressing/soap/fault"

	// Create WS-Security Header
	Do ..CreateSecurityHeader()
}

Method CreateSecurityHeader() As %Status
{
	Set tSecurity = ##class(%SOAP.Security.Header).%New()

	// Create Timestamp - Interval of 15 minutes
	Set tTimestamp = ##class(%SOAP.Security.Timestamp).Create(900)
    Do tSecurity.AddToken(tTimestamp)

	Set:$IsObject(tSecurity) ..SecurityOut = tSecurity
}

Method CreateSOAPHeader() As %SOAP.Addressing.Properties
{
	Set tRelatesToId = ..AddressingIn.MessageId
	Set tAddressingOut = ##class(%SOAP.Addressing.Properties).%New()
	Set tAddressingOut.MessageId = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()

	If $G(tRelatesToId) '= "" {
		Set tAddressingOut.Relationship = ##class(%SOAP.Addressing.RelatesTo).%New()
		Set tAddressingOut.Relationship.RelatesTo = tRelatesToId
	}
	Quit tAddressingOut
}

/// Ensures the DE passes the basic rules set
/// Note: DistributionEnvelope is detected by the work DistributionEnvelope. To make 100% this
/// should look for the namespace declaration
ClassMethod ProcessDistributionEnvelope(pRequestBody As %Stream, Output pDE As %String, Output pPayload As %Stream) As %Status
{
	Set tSC=$$$OK, pDE="", pPayload=$$$NULLOREF

	#; Find start of payload
	do pRequestBody.Rewind()
	Set tEnv = pRequestBody.Read(10000)
	Set (tHasDE,tHasCData,tPayPos,num)=0, tLen=$L(tEnv)
	Set pos1=1  While pos1<tLen { Set pos=pos1, pos1=$F(tEnv,">",pos)  Set:'pos1 pos1=1+tLen  Set tElem=$E(tEnv,pos,pos1-2), num=num+1

		#; quit if no DE in first 2 elements
		If 'num<3 {
			Set:'tHasDE tHasDE=tElem?.E1"<".1(.AN1":")1"DistributionEnvelope"1(1" ".E)
		} Else {
			Quit:'tHasDE
		}
		If tElem?.E1"<".1(.AN1":")1"payload"1(1" ".E) {
			Set tPayPos=pos1 While " "_$C(9,10,13)[$E(tEnv,tPayPos)&&(tPayPos<tLen) { Set tPayPos = tPayPos+1 } ; skip whitespace 
			If "<![CDATA[" = $E(tEnv,tPayPos,tPayPos-1+$L("<![CDATA[")) {
				Set tPayPos = tPayPos+$L("<![CDATA["), tHasCData = 1
			}
			Set:'tHasCData tPayPos = pos1
			Quit
		}
	}
	If 'tHasDE {
		Do pRequestBody.Rewind()
		Set pPayload = pRequestBody
		Quit tSC
	}
	Quit:'tPayPos $$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"No payload element found in Distribution Envelope '"_tEnv_"'")
	#; Copy payload to stream while looking for payload end marker
	Set pDE=$E(tEnv,1,tPayPos-1)
	Set tBuf=$E(tEnv,tPayPos,*)
	Set pPayload = ##class(%Stream.GlobalCharacter).%New()
	Set tTarg=$S(tHasCData:"]]>",1:"payload>")
	Do {
		Set tPrevBuf=tBuf, tBuf=pRequestBody.Read(10000,.tSC)  Quit:$$$ISERR(tSC)
		If $L(tBuf)<200 {
			Set tBuf=tPrevBuf_tBuf, tPrevBuf=""
		} Else {
			Set tSC=pPayload.Write(tPrevBuf), tPrevBuf=""  Quit:$$$ISERR(tSC)
		}
	} While 'pRequestBody.AtEnd
	Quit:$$$ISERR(tSC) tSC

	#; Search backwards from end for payload close target string
	Set tPrevBuf=$E(tBuf,1,*-200), tBuf=$E(tBuf,*+1-200,*)
	Set:""'=tPrevBuf tSC=pPayload.Write(tPrevBuf)  Quit:$$$ISERR(tSC) tSC
	Set tPayEnd=$F($Reverse(tBuf),$Reverse(tTarg))
	Set:'tHasCData tPayEnd=$F($Reverse(tBuf),"<",tPayEnd)
	Quit:'tPayEnd $$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"No payload closing element found in Distribution Envelope tail '"_tBuf_"'")

	#; Finish writing envelope and payload body
	Set tSC=pPayload.Write($E(tBuf,1,*+1-tPayEnd))  Quit:$$$ISERR(tSC) tSC
	Set pDE=pDE_"@@PAYLOAD@@"_$E(tBuf,*+2-tPayEnd,*)

	Quit tSC
}

/// This method is call if there is a distribution envelope to validate it
/// Note: Technically this is not full distribution envelope validation, but
/// we will have this with Schema based XML validation
ClassMethod ValidateDistributionEnvelope(pAction As %String, pDE As EnsLib.EDI.XML.Document, pServiceDefinition As EnsLib.ITK.Setup.ServiceDefinition)
{
	// Ensure service matches action
	If $ZSTRIP(pDE.GetValueAt("*:/1/header/@service"), "<>P")'=pAction quit $$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Bad Distribution Envelope, Service Not Matching SOAP Action")

	// Ensure there are some items
	If pDE.GetValueAt("*:/1/header/manifest/@count")=0 quit $$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Bad Distribution Envelope, No Manifest Count")
	set count=pDE.GetValueAt("*:/1/header/manifest/@count")

	// Ensure count and actual items match
	If count'=pDE.GetValueAt("*:/1/header/manifest/*") quit $$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Bad Distribution Envelope, Invalid Manifest Count")

	// Ensure count and payload count match
	If count'=pDE.GetValueAt("*:/1/payloads/@count") quit $$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Bad Distribution Envelope, Mismatch Count")

	// Ensure the Sender is present if required
	if (pServiceDefinition.BehaviourType=$$$ITKBPAcknowledged)&&(pDE.GetValueAt("*:/1/header/senderAddress/@uri")="") quit $$$ERROR($$$EnsErrGeneral, $$$ITKInvalidRequest_"Bad Distribution Envelope, No Sender for Acknowledged Service")

	// Get all manifest item ids
	For i=1:1:count { 
		set key=pDE.GetValueAt("*:/1/header/manifest/manifestitem["_i_"]/@id")
		Set:key'="" manifestIds(key)=1
	}

	// Now check payload IDs match
	set tSC=$$$OK
	For i=1:1:count {
		set payloadId=pDE.GetValueAt("*:/1/payloads/payload["_i_"]/@id")
		If payloadId="" { Set tSC=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Bad Distribution Envelope, No Payload Id") }
		ElseIf $G(manifestIds(payloadId),0)'=1 { Set tSC=$$$ERROR($$$EnsErrGeneral,$$$ITKInvalidRequest_"Bad Distribution Envelope, Invalid Payload Id") }
		Quit:tSC'=$$$OK
	}
	Quit:tSC'=$$$OK tSC

	Quit $$$OK
}

Method ExtractTrackingId(doc As %GlobalCharacterStream) As %String
{
	Set tSC = ##class(%XML.TextReader).ParseStream(doc,.rdr)  Quit:$$$ISERR(tSC) ""

	While (rdr.Read()) {
		If (rdr.LocalName = "DistributionEnvelope") && (rdr.NodeType = "element") {
			Do rdr.Read()
			Set ac = rdr.AttributeCount
			For i=1:1:ac {
				Do rdr.MoveToAttributeIndex(i)
				Quit:rdr.LocalName="trackingid"
			}
			Quit
		}
	}
	Quit rdr.Value
}

/// Implemented by derived classes
Method DetermineGenericService(Output pClass As %String, Output pMethod As %String) [ Abstract ]
{
	$$$ASSERT(0_"Subclass Responsibility")
}

/// Implemented by derived classes
Method AuthorizeRequest(Output invocationPattern) As %Boolean [ Abstract ]
{
	$$$ASSERT(0_"Subclass Responsibility")
}

Method DetermineDistributionMode() As %String
{
	Quit "Relay"
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigName",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}
