Include (HS.IHE.DSUB, HS.IHE.ATNA, HS.HC)

/// Take the request from the ConsumerService and fetch the document
Class HS.IHE.DSUB.NotificationConsumer.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper, HS.IHE.Common.Actor.Base) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "RetrieveOperation:Basic:selector?size=40&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},-RetrieveServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},-TransformNotificationToMessage";

/// *** Deprecated *** was never used
/// Service name where we will send the retrieve request (typically our initiating gateway)
Property RetrieveServiceName As %String [ InitialExpression = "XDSb.Retrieve" ];

Property TransformNotificationToMessage As %String(MAXLEN = 512) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

Property Transformer As HS.Util.XSLTTransformer;

/// Operation for XDSb Consumer.  This Operation needs to be pointed to an Initiating Gateway to handle a query request (when leaf class) and route the retrieve request
Property RetrieveOperation As Ens.DataType.ConfigName;

Property Errors As HS.Types.IHE.Errors;

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	try {
		Set tSC=$$$OK
		$$$GetTransformer(..Transformer)
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If pRequest.Name=$$$DSUBNotficationRequest {
			Set tSC = ..Notify(pRequest,.pResponse)
			/// ITI - 3.53.5.1
			Set tSCAudit = $$$ATNAEvent("DocumentMetadataNotificationRecipient",pRequest,pResponse,tSC) If $$$ISERR(tSCAudit) $$$LOGSTATUS(tSCAudit)
		} Else {
			$$$LOGERROR("Unknown Request")
			Set tSC=$$$ERROR($$$GeneralError,"Unknown request")
		} 
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationConsumer","Error",$system.Status.GetErrorText(tSC))
	}
	IF ..Errors.Errors.Count() $$$HSTRACE("Errors","Errors",..Errors)
	Quit tSC
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

/// Override to apply custom functionality - sample code to retrieve document
Method RetrieveDocuments(pRequest As HS.Message.IHE.XDSb.Metadata, Output pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC = $$$OK
		Quit:..RetrieveOperation=""
		Set tRequest = ##class(HS.Message.IHE.XDSb.RetrieveRequest).%New()
		If pRequest.AdditionalInfo.GetAt("Topic")="M" {
			#; just have object ref's need to get the document(s) - only care about documents right now
			Set tQueryRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
			Do tQueryRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
			Set tQueryRequest.ReturnType="LC"
			//Do tQueryRequest.AddPatientId(pRequest.AdditionalInfo.GetAt("PatientId"),"$patientId")
			Do tQueryRequest.AddPatientId(pRequest.AdditionalInfo.GetAt("PatientId"),"$XDSDocumentEntryPatientId")
			Set tQueryRequest.QueryType="GetDocuments"
			Set tItemD=##class(HS.Message.IHE.XDSb.QueryItem).%New() 
			For tIdx = 1:1:pRequest.ObjectRefs.Count() {
				Set tItemD.ItemName="$XDSDocumentEntryEntryUUID"
				Do tItemD.Values.Insert(pRequest.ObjectRefs.GetAt(tIdx).EntryUUID)
			}
			
			Do tQueryRequest.Parameters.Insert(tItemD)
			Set tSC = ..SendRequestSync(..RetrieveOperation,tQueryRequest,.pResponse)
			For tIdx = 1:1:pResponse.Documents.Count() {
				Do tRequest.Documents.Insert(pResponse.Documents.GetAt(tIdx))
			}
			
		} 
		For tIdx=1:1:pRequest.Documents.Count() {
			Set tDocument = pRequest.Documents.GetAt(tIdx)
			Set tRetrieveDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
			Set tRetrieveDocument.UniqueId = tDocument.DocumentUniqueIdentifier.Value
			Set tRetrieveDocument.HomeCommunityId = tDocument.HomeCommunityId
			Set tRetrieveDocument.RepositoryUniqueId = tDocument.RepositoryUniqueId
			Do tRequest.Documents.Insert(tRetrieveDocument)
		}
		If tRequest.Documents.Count() Set tSC = ..SendRequestSync(..RetrieveOperation,tRequest,.pResponse)
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationConsumer","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Override to apply custom functionality - sample code to retrieve document
/// The original inbound message is in pRequest.ContentStream, but the document elements have been extracted into the metadata object
Method OnNotify(pRequest As HS.Message.IHE.XDSb.Metadata, Output pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC=$$$OK
		Set pResponse=$$$NULLOREF
		Set tSC = ..RetrieveDocuments(pRequest,.pResponse)
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationConsumer","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method Notify(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC=$$$OK

		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/wsnt:Notify/wsnt:NotificationMessage/wsnt:SubscriptionReference/wsa:Address","text()",.tSubscriptionURL,.tNotifyDocument)
		If '$$$ISOK(tSC) || (tSubscriptionURL="") {
			$$$LOGWARNING("Unknown subscription ID, unable to obtain subscription or patient ID for audit")
		} Else {
			Set tSubscription = ##class(HS.IHE.DSUB.Subscriber.Subscription).SubscriptionForURL(tSubscriptionURL)
			If '$IsObject(tSubscription) {
				$$$HSTRACEMIN("No subscription for SubscriptionURL:"_tSubscriptionURL)
				Quit
			}
			
			Do pRequest.AdditionalInfo.SetAt(tSubscription.PatientID,"PatientId")
			Do pRequest.AdditionalInfo.SetAt(tSubscription.Topic,"Topic")
		}

		#dim tMetadata as HS.Message.IHE.XDSb.Metadata 
		Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream,..TransformNotificationToMessage /* "/IHE/XDSb/Version1/Message-to-MetadataObject.xsl" */,.tMetadata,.param,"HS.Message.IHE.XDSb.Metadata","Metadata")
		Quit:$$$ISERR(tSC)
		Do tMetadata.ContentStream.CopyFrom(pRequest.ContentStream)
		Do tMetadata.AdditionalInfo.SetAt(tSubscription.PatientID,"PatientId")
		Do tMetadata.AdditionalInfo.SetAt(tSubscription.Topic,"Topic")
		Set tSC=..OnNotify(tMetadata,.pResponse)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationConsumer","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>RegistryServiceName</Value>
</Value>
<Value name="2">
<Value>RegistryOperation</Value>
</Value>
<Value name="3">
<Value>TransformSubscribeNotification</Value>
</Value>
<Value name="4">
<Value>TransformSubscribeResponse</Value>
</Value>
<Value name="5">
<Value>CallbackHandler</Value>
</Value>
<Value name="6">
<Value>ErrorHandler</Value>
</Value>
<Value name="7">
<Value>Initialized</Value>
</Value>
<Value name="8">
<Value>Errors</Value>
</Value>
<Value name="9">
<Value>DoHSTrace</Value>
</Value>
<Value name="10">
<Value>ClearCallbackVariables</Value>
</Value>
<Value name="11">
<Value>MaximumDuration</Value>
</Value>
<Value name="12">
<Value>NotificationOperation</Value>
</Value>
<Value name="13">
<Value>TraceOperations</Value>
</Value>
<Value name="14">
<Value>TransformDocumentNotification</Value>
</Value>
<Value name="15">
<Value>XSLTCacheMode</Value>
</Value>
<Value name="16">
<Value>XSLTCallbackHandlerClass</Value>
</Value>
<Value name="17">
<Value>XSLTDirectory</Value>
</Value>
<Value name="18">
<Value>XSLTErrorHandlerClass</Value>
</Value>
<Value name="19">
<Value>TransformNotificationToMessage</Value>
</Value>
<Value name="20">
<Value>TransformFullToSimpleNotification</Value>
</Value>
<Value name="21">
<Value>RetrieveServiceName</Value>
</Value>
<Value name="22">
<Value>RetrieveOperation</Value>
</Value>
<Value name="23">
<Value>Transformer</Value>
</Value>
</Data>
<Data name="StyleSheets">
<Attribute>StyleSheets</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.IHE.DSUB.NotificationConsumer.Process.StyleSheets"</Subscript>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
