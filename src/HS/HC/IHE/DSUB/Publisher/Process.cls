Include (HS.HC, HS.IHE.DSUB, HS.IHE.XDSb, HS.IHE.ATNA)

/// Take a registration request from an XDSb.Registry and build Publish request
Class HS.HC.IHE.DSUB.Publisher.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper, HS.IHE.Common.Actor.Base) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "LocalBrokerOperation,Brokers,PublishOperation,ProducerReference,TransformMessageToNotification,MetadataTransform";

/// Used to transform Registration Request into a publish message
Property TransformMessageToNotification As %String(MAXLEN = 512) [ InitialExpression = "IHE/DSUB/Version1/PublisherMetadataToNotification.xsl" ];

Property MetadataTransform As %String(MAXLEN = 512) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

/// Comma separated list of Broker Service registry entries in which to publish this request.  Don't define the local broker here when defined in LocalBrokerOperation, otherwise the broker will receive duplicate messages.
Property Brokers As %String(MAXLEN = 512);

/// Local broker definition, use this to send transaction to local broker (without the overhead of sending a soap request).  In this case don't define the service name in "Brokers"<br>
/// The local broker would be defined as HS.IHE.DSUB.NotificationBroker.Operations
Property LocalBrokerOperation As Ens.DataType.ConfigName;

/// Generic operation HS.Util.IHE.SOAPClient.Operations to send notification to broker
Property PublishOperation As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.DSUB.Notification.Operations" ];

Property ProducerReference As %String(MAXLEN = 512) [ InitialExpression = {"https://"_$$$HSNetworkHostName_"/csp/connect/HS.IHE.XDSb.Registry.Services.cls"} ];

Property Errors As HS.Types.IHE.Errors;

Property Transformer As HS.Util.XSLTTransformer;

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	try {
		Set tSC=$$$OK
		$$$GetTransformer(..Transformer)
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set tRequest=pRequest
		If 'tRequest.%IsA("HS.Message.IHE.XDSb.Metadata") {
			// if not already metadata convert it to be metadata
			Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream, ..MetadataTransform /*"IHE/XDSb/Version1/Message-to-MetadataObject.xsl"*/,.tRequest,"","HS.Message.IHE.XDSb.Metadata","Metadata")
		}
		
		If tRequest.%IsA("HS.Message.IHE.XDSb.Metadata") {
			#; process DSUB brokers
			Do ..Publish(tRequest)
			$$$HSTRACE("request","pRequest",tRequest)

		} Else {
			$$$LOGERROR("Unknown Request")
			Set tSC=$$$ERROR($$$GeneralError,"Unknown request")
		} 
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	IF ..Errors.Errors.Count() {
		$$$HSTRACE("Errors","Errors",..Errors)
		Do ..Errors.XMLExportToString(.tErrors)
		$$$LOGERROR(tErrors)
	}
	Quit tSC
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

/// Internal publish - (from registry)
Method Publish(pRequest As HS.Message.IHE.XDSb.Metadata) As %Status
{
	try {
		Set tSC=$$$OK
		Set tPort = $Select(^%SYS("WebServer","Port")'="":":"_^%SYS("WebServer","Port"),1:"")
		Set tFrom = "http://"_$$$HSNetworkHostName_tPort_$system.CSP.GetDefaultApp($namespace)_"/"_..PublishOperation_".cls"

		Set tParam("homeCommunityOID")=$$$HomeCommunityOID
		Set tParam("producerReference")=..ProducerReference
		Set tSC = ..Transformer.TransformFromObject(pRequest,..TransformMessageToNotification /* "IHE/DSUB/Version1/PublisherMetadataToNotification.xsl" */,.tNotificationStream,.tParam)
		If $$$ISERR(tSC) Do ..Errors.logError("XDSNotificationBroker","Error",$system.Status.GetErrorText(tSC)) Quit
		$$$HSTRACE("notification","tNotificationStream",tNotificationStream)

		If ..LocalBrokerOperation]"" {
			Set tSC = ..SendRequestSync(..LocalBrokerOperation,pRequest,.tResponse)
			/// Need to audit message
			Set tPublishMessage = ##class(HS.Message.XMLMessage).%New()
			Set tPublishMessage.Name=$$$DSUBPublishRequest
			Set tPublishMessage.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
			Set tPublishMessage.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
			Do tPublishMessage.AdditionalInfo.SetAt($$$DSUBPublishRequestAction(1),"SOAPAction")
			Do tPublishMessage.ContentStream.CopyFrom(tNotificationStream)
			Do tPublishMessage.AdditionalInfo.SetAt(tFrom,"WSA:From")
			Set tAuditSC = $$$ATNAEvent("DocumentMetadataPublisher",tPublishMessage,"",tSC) If $$$ISERR(tAuditSC) $$$LOGSTATUS(tAuditSC)
		}
		Quit:..Brokers=""
		// Just because our broker only does documents, doesn't mean others don't want other notifications
		//If 'pRequest.Documents.Count() $$$HSTRACE("No Documents") Quit   // no documents... could be a folder update



		#; FOR EACH BROKER PUBLISH

		For tIdx = 1:1:$l(..Brokers,",") {
			Set tBroker = $p(..Brokers,",",tIdx)
			Continue:tBroker="" // Check for null broker for sites that are just using this to setup NQ Repositories
			Set tPublishMessage = ##class(HS.Message.XMLMessage).%New()
			Set tPublishMessage.Name=$$$DSUBPublishRequest
			Set tPublishMessage.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
			Set tPublishMessage.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
			Do tPublishMessage.AdditionalInfo.SetAt($$$DSUBPublishRequestAction(1),"SOAPAction")
			Do tPublishMessage.AdditionalInfo.SetAt(tBroker,"ServiceName")
			Do tPublishMessage.ContentStream.CopyFrom(tNotificationStream)
			Do tPublishMessage.AdditionalInfo.SetAt(1,"OneWay")
			Do tPublishMessage.AdditionalInfo.SetAt(tFrom,"WSA:From")
			Set tRegistryService = ##class(HS.Registry.Service.SOAP).EndPointForNameType(tBroker,"SOAP")
			Do tPublishMessage.AdditionalInfo.SetAt(tRegistryService.EndPoint,"WSA:To")
			Set tSC = ..SendRequestSync(..PublishOperation,tPublishMessage,.tResponse)
			Set tAuditSC = $$$ATNAEvent("DocumentMetadataPublisher",tPublishMessage,tResponse,tSC) If $$$ISERR(tAuditSC) $$$LOGSTATUS(tAuditSC)
		}

		
		
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>FacilityOIDPrefix</Value>
</Value>
<Value name="2">
<Value>TransformMessageToNotification</Value>
</Value>
<Value name="3">
<Value>MetadataTransform</Value>
</Value>
<Value name="4">
<Value>Brokers</Value>
</Value>
<Value name="5">
<Value>LocalBrokerOperation</Value>
</Value>
<Value name="6">
<Value>PublishOperation</Value>
</Value>
<Value name="7">
<Value>ProducerReference</Value>
</Value>
<Value name="8">
<Value>Errors</Value>
</Value>
<Value name="9">
<Value>Transformer</Value>
</Value>
<Value name="10">
<Value>TraceOperations</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
