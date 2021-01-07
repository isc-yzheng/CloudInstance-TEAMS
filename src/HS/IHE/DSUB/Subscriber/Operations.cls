Include (HS.IHE.DSUB, HS.IHE.ATNA)

/// Used to Transform and send HS.Message.DSUB.SubscriptionRequest messages
Class HS.IHE.DSUB.Subscriber.Operations Extends (HS.Util.SOAPClient.Operations, HS.HC.Util.Trace.Helper, HS.Util.XSLTTransformer) [ ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "DisableSSLCheckServerIdentity:Dev,DefaultSSLConfig:Basic,-XSLTDirectory,-XSLTCallbackHandlerClass,-XSLTErrorHandlerClass,XSLTCacheMode:Basic,-SOAPVersion,-SSLConfiguration,SOAPCredentials,-ResponseTimeout,-SendSAMLAssertion,-SAMLCreator,TransformSubscriberRequest,TransformSubscriberResponse";

/// See %HSHOME%/csp/xslt/IHE/DSUB/Version1/SubscriptionRequestToSubscribeNotification.xsl for an example
Property TransformSubscriberRequest As %String(MAXLEN = 255) [ InitialExpression = "IHE/DSUB/Version1/SubscriberSubscribeRequest.xsl" ];

Property TransformSubscriberResponse As %String(MAXLEN = 255) [ InitialExpression = "IHE/DSUB/Version1/SubscriberSubscribeResponse.xsl" ];

/// If cancellationaddress https automatic SSL configuration assigned to subscription entry
Property DefaultSSLConfig As %String [ InitialExpression = "Client" ];

/// See %HSHOME%/csp/xslt/IHE/DSUB/Version1/SubscriptionRequestToSubscribeNotification.xsl for an example
XData MessageMap
{
<MapItems>
<MapItem MessageType="HS.Message.IHE.DSUB.SubscriptionRequest"> 
<Method>SubscriptionRequest</Method>
</MapItem>
<MapItem MessageType="HS.Message.IHE.DSUB.CancelSubscriptionRequest"> 
<Method>CancelSubscriptionRequest</Method>
</MapItem>
</MapItems>
}

/// If doing any security related signing the request comes and generated (with a security document 
/// as a placeholder), the caller then adds the security document and calls the source again, 
/// this time it will be audited and sent to the repository
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		#; when using custom soap headers we might need a different type of request
		Set tWebRequest = pRequest.AdditionalInfo.GetAt("WebRequest")
		Set:tWebRequest="" tWebRequest=##class(%SOAP.WebRequest).%New()
		Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction")
		$$$HSTRACEMIN("Request","Request",pRequest)
		Do ..ValidateMessage(pRequest,tAction,"Request")

		Set tSC = ..InvokeWebService(tWebRequest,, tAction, pRequest, .pResponse)
		If $$$ISERR(tSC) $$$HSTRACEERROR(tSC) Quit
		$$$HSTRACEMIN("Response","Response",pResponse)
		If pRequest.AdditionalInfo.GetAt("SOAPAction") = $$$DSUBSubscribeRequestAction(1) {
			Set tSCAudit=$$$ATNAEvent("DocumentMetadataSubscriber",pRequest,pResponse,tSC) If $$$ISERR(tSCAudit) $$$LOGSTATUS(tSCAudit)
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SubscriptionRequest(pRequest As HS.Message.IHE.DSUB.SubscriptionRequest, Output pResponse As HS.Message.IHE.DSUB.SubscriptionResponse = "", pWebRequest As %SOAP.WebRequest = {##class(%SOAP.WebRequest).%New()}) As %Status
{
	Set tSC=$$$OK
	Try {
		Set pResponse=##class(HS.Message.IHE.DSUB.SubscriptionResponse).%New()
		Set tSC = pRequest.ValidateFilterItems()
		If $$$ISERR(tSC) {
			Do pResponse.Errors.logError("Error","Error",$system.Status.GetErrorText(tSC))
			Set tSC = $$$OK 
			Quit
		}
		Set tSOAPAction = $$$DSUBSubscribeRequestAction(1)
		Set tOutboundRequest = ##class(HS.Message.XMLMessage).%New()

		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tOutboundRequest)  ///SAML/User Auth
		Set tOutboundRequest.Name=$$$DSUBSubscribeRequest
		Set tOutboundRequest.AdditionalInfo=pRequest.AdditionalInfo.%ConstructClone()
		Set tOutboundRequest.SAMLData=pRequest.SAMLData.%ConstructClone()
		Set tService = pRequest.AdditionalInfo.GetAt("ServiceName")
		Do:tService]"" tOutboundRequest.AdditionalInfo.SetAt(tService,"ServiceName")
		Do tOutboundRequest.AdditionalInfo.SetAt(tSOAPAction,"SOAPAction")

		Set tSC = ..TransformFromObject(pRequest,..TransformSubscriberRequest /*"IHE/DSUB/Version1/SubscriberSubscribeRequest.xsl"*/,tOutboundRequest.ContentStream)
		$$$HSTRACE("SubscriptionRequest","tOutboundRequest",tOutboundRequest)

		Do tOutboundRequest.AdditionalInfo.SetAt(pWebRequest,"WebRequest")
		Set tSC = ..OnMessage(tOutboundRequest,.tResponse)
		IF $$$ISERR(tSC) {
			Do pResponse.Errors.logError("Error","Error",$system.Status.GetErrorText(tSC))
			Set tSC = $$$OK 
			$$$HSTRACE("ResponseSOAPFault","pResponse",pResponse)
			Quit
		}
		Do tResponse.ContentStream.Rewind()
		Set tSC = ..TransformIntoObject(tResponse.ContentStream,..TransformSubscriberResponse /*"IHE/DSUB/Version1/SubscriberSubscribeResponse.xsl"*/,.pResponse,"SubscriptionResponse","HS.Message.IHE.DSUB.SubscriptionResponse")
		Set:pResponse="" pResponse=##class(HS.Message.IHE.DSUB.SubscriptionResponse).%New()
		Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
		Do pResponse.AdditionalInfo.SetAt("ResponseSOAPAction",tResponse.AdditionalInfo.GetAt("ResponseSOAPAction"))
		$$$HSTRACE("Response","pResponse",pResponse)

		#; file the subscription	
		Set tSubscription = ##class(HS.IHE.DSUB.Subscriber.Subscription).%New()
		Do tSubscription.CopyFrom(pRequest,tSubscription)
		Do tSubscription.CopyFrom(pResponse,tSubscription)
		For tIdx=1:1:pRequest.FilterItems.Count() {
			Do tSubscription.FilterItems.Insert(pRequest.FilterItems.GetAt(tIdx))
		}
		Set:tSubscription.TerminationTime]"" tSubscription.TerminationTime = ##class(HS.HC.Util.DateTime).ConvertToUTC(tSubscription.TerminationTime)
		Set tSC= tSubscription.%Save()
		Set pResponse.SubscriptionID=tSubscription.%Id()
		$$$HSTRACE("subscription","sub,rq,res,tSC",tSubscription,pRequest,pResponse,tSC)
	} Catch ex { 
		Set tSC=ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

Method CancelSubscriptionRequest(pRequest As HS.Message.IHE.DSUB.CancelSubscriptionRequest, pResponse As HS.Message.IHE.DSUB.CancelSubscriptionResponse) As %Status
{
	try {
		Set tSC=$$$OK
		Set pResponse=##class(HS.Message.IHE.DSUB.CancelSubscriptionResponse).%New()
		If pRequest.SubscriptionID]"" {
			Set tSubscription = ##class(HS.IHE.DSUB.Subscriber.Subscription).%OpenId(pRequest.SubscriptionID)
			Set tID=pRequest.SubscriptionID
		} Else {
			Set tSubscription = ##class(HS.IHE.DSUB.Subscriber.Subscription).CancellationAddressIndexOpen(pRequest.CancellationAddress)
			Set tID = pRequest.CancellationAddress
		}
		If '$IsObject(tSubscription) {
			Do pResponse.Errors.logError("Error","Error",$$$FormatText("Unable to locate subscription for %1",tID))
			Quit
		}
		Set ..SSLConfiguration=..DefaultSSLConfig
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRequest.Name=$$$DSUBUnsubscribeRequest
		Do tRequest.AdditionalInfo.SetAt("","ServiceName")
		Do tRequest.ContentStream.Write("<wsnt:Unsubscribe xmlns:wsnt=""http://docs.oasis-open.org/wsn/b-2""/>")
	
		Set tCancellationAddress = $p(tSubscription.CancellationAddress,"?")
		Do tRequest.AdditionalInfo.SetAt($p(tSubscription.CancellationAddress,"?",2,*),"URLParameters")
		Do tRequest.AdditionalInfo.SetAt(tSubscription.CancellationAddress,"Address")  //used for auditing
		Set tSC = ..InvokeWebService("",tCancellationAddress,$$$DSUBUnsubscribeRequestAction(1), tRequest, .tResponse) 
		IF $$$ISERR(tSC) {
			Do pResponse.Errors.logError("Error","Error",$system.Status.GetErrorText(tSC))
			Set tSC = $$$OK 
			$$$HSTRACE("ResponseSOAPFault","pResponse",pResponse)
			Quit
		} Else {
			Set tSC = tSubscription.%DeleteId(tSubscription.%Id())
		}
		Set tSCAudit=$$$ATNAEvent("DocumentMetadataSubscriber",tRequest,tResponse,tSC) If $$$ISERR(tSCAudit) $$$LOGSTATUS(tSCAudit)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
