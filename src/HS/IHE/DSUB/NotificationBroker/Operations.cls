Include (HS.HC, HS.IHE.DSUB, HS.IHE.XDSb, HS.IHE.ATNA)

Class HS.IHE.DSUB.NotificationBroker.Operations Extends (HS.HC.Util.Trace.Helper, Ens.BusinessOperation, HS.Util.XSLTTransformer, HS.Util.SOAPClient.Operations) [ Inheritance = right ]
{

Parameter HSDEPLOY = 1;

/// Domain used for localization.
Parameter DOMAIN = "HS";

Parameter SETTINGS = "NotificationBrokerServiceName:Basic,DefaultSSLConfig:Basic,MaximumDuration:Basic,ValidatePatientID:Basic,ValidateAffinityDomain:Basic,PDQConsumer:Basic,TransformSubscribe,TransformPublishToMessage,-TransformSubscribeNotification,TransformSubscribeResponse,TransformDocumentToNotification,-NotificationOperation,-TransformToMetadata,TransformToMessage,-XSLTDirectory,-XSLTCallbackHandlerClass,-XSLTErrorHandlerClass,XSLTCacheMode:Basic,-ProducerReference:Basic,DisableSSLCheckServerIdentity:Dev";

/// Used to validate the PatientID provided in the Subscription
Property PDQConsumer As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PDQv3.Consumer.Operations" ];

/// Transform Subscription Request into HS.IHE.DSUB.NotificationBroker.Subscription
Property TransformSubscribe As %String(MAXLEN = 512) [ InitialExpression = "IHE/DSUB/Version1/BrokerSubscribeRequest.xsl" ];

/// Transform NotificationMessage - stripping notification header information
Property TransformPublishToMessage As %String(MAXLEN = 512) [ InitialExpression = "IHE/DSUB/Version1/BrokerNotificationToMetadataObject.xsl" ];

/// XSL to create a subscription response
Property TransformSubscribeResponse As %String(MAXLEN = 512) [ InitialExpression = "IHE/DSUB/Version1/BrokerSubscribeResponse.xsl" ];

/// Transform <Documents><Document (of type HS.Registry.Document)/></Documents> into a notification 
Property TransformDocumentToNotification As %String(MAXLEN = 512) [ InitialExpression = "IHE/DSUB/Version1/BrokerCreateNotification.xsl" ];

Property TransformToMetadata As %String [ InitialExpression = "IHE/XDSb/Version1/Message-to-XDSbRequest.xsl" ];

/// The transform that produces XDSb messages from metadata
Property TransformToMessage As %String [ InitialExpression = "IHE/XDSb/Version1/MetadataObject-to-Message.xsl" ];

/// Operations class to send message (common operation providing ServiceName / soap Action)
Property NotificationOperation As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.DSUB.Notification.Operations" ];

/// Service Registry entry for the HS.IHE.DSUB.NotificationBroker.Service.cls, to be used for producing cancellation address
Property NotificationBrokerServiceName As %String [ InitialExpression = "DSUB.NotificationBroker" ];

/// Temporary entry for the NotificationBroker Service registry entry (look it up once), if using a bus, this would be the service name of the BUS endpoint
Property NotificationBrokerService As HS.Registry.Service.SOAP;

/// If inbound url is https automatic SSL configuration assigned to subscription registry entry
Property DefaultSSLConfig As %String [ InitialExpression = "Client" ];

/// Allow turning off patient ID validation; to be used during testing
Property ValidatePatientID As %Boolean [ InitialExpression = 1 ];

Property ValidateAffinityDomain As %Boolean [ InitialExpression = 1 ];

/// **** Deprecated due to CP-ITI-888-04 - now use SubmissionSet sourceid ****
Property ProducerReference As %String(MAXLEN = 512) [ InitialExpression = {"https://"_$$$HSNetworkHostName_"/csp/connect/HS.IHE.XDSb.Registry.Services.cls"} ];

/// Not required, but if specified this is the maximum duration, subscriptions specifying longer durations will be limited to this value.
/// PnYnMnDTnHnMnS  P1Y2M3DT4H5M6S would be 1 year, 2 months, 3 days, 4 hours, 5 minutes, 6 seconds from now
Property MaximumDuration As %String;

Property Errors As HS.Types.IHE.Errors;

Property FilterItems As %String [ MultiDimensional ];

Property QueryParameters As %String [ MultiDimensional ];

Property HomeCommunityOID As %String;

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	try {
		Set tSC=$$$OK
		#; if ..ServiceName is defined we are forwarding on 
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If ..ServiceName]"" {
			If pRequest.Name=$$$DSUBUnsubscribeRequest {
				Do pRequest.AdditionalInfo.SetAt("SUB="_pRequest.AdditionalInfo.GetAt("SubscriptionID"),"URLParameters")
				Set tTargetURL = ..NotificationBrokerService.EndPoint_"?SUB="_pRequest.AdditionalInfo.GetAt("SubscriptionID")
				Do pRequest.ContentStream.Write("<wsnt:Unsubscribe xmlns:wsnt=""http://docs.oasis-open.org/wsn/b-2""/>")
				Set tRequest = ##class(%SOAP.WebRequest).%New()
				Set tSC = ..InvokeWebService(tRequest,,$$$DSUBUnsubscribeRequestAction(1),.pRequest,.pResponse)
				If tRequest.SoapFault]"" Set pResponse.SOAPFault=$LB($p(tRequest.SoapFault.Reason.GetAt(1).Text," ",1),tRequest.SoapFault.Detail),tSC=$$$OK
			} ElseIf pRequest.Name=$$$DSUBSubscribeRequest {
				Set tRequest = ##class(%SOAP.WebRequest).%New()
				Set tSC = ..InvokeWebService(,,$$$DSUBSubscribeRequestAction(1),.pRequest,.pResponse)
				If tRequest.SoapFault]"" Set pResponse.SOAPFault=$LB($p(tRequest.SoapFault.Reason.GetAt(1).Text," ",1),tRequest.SoapFault.Detail),tSC=$$$OK
			} Else {
				$$$LOGERROR("Unknown Request for forwarding")
				Set tSC=$$$ERROR($$$GeneralError,"Unknown request for forwarding")
			}
			Quit
		}
		If '$D(..FilterItems) Do ..BuildFilterItems()
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		If pRequest.%IsA("HS.Message.IHE.XDSb.Metadata") {
			#; inbound async request from Registry
			Set tSC = ..InternalPublish(pRequest,.pResponse)
		} ElseIf pRequest.Name=$$$DSUBSubscribeRequest {
			Set tSC = ..Subscribe(pRequest,.pResponse)
			Set tSCAudit=$$$ATNAEvent("DocumentMetadataNotificationBroker",pRequest,pResponse,tSC) If $$$ISERR(tSCAudit) $$$LOGSTATUS(tSCAudit)
		} ElseIf pRequest.Name=$$$DSUBUnsubscribeRequest {
			Set tSC = ..Unsubscribe(pRequest,.pResponse)
			Set tSCAudit=$$$ATNAEvent("DocumentMetadataNotificationBroker",pRequest,pResponse,tSC) If $$$ISERR(tSCAudit) $$$LOGSTATUS(tSCAudit)
		} ElseIf (pRequest.Name = $$$DSUBPublishRequest) {
			Set tSC = ..GetNotificationRequest(pRequest,.tRequest) 
			If $$$ISOK(tSC) Set tSC = ..InternalPublish(tRequest,.pResponse)
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
		Set tString = ""
		For tIdx=1:1:..Errors.Errors.Count() {
			Set tString = tString_", "_..Errors.Errors.GetAt(tIdx).Description
		}
		$$$LOGERROR("Error(s) have occurred "_$Extract(tString,3,*))
	}
	Quit tSC
}

Method Subscribe(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set pResponse.Name = $$$DSUBSubscribeResponse
		#dim tSubscription as HS.IHE.DSUB.NotificationBroker.Subscription
		
		Set tSC = ..TransformIntoObject(pRequest.ContentStream,..TransformSubscribe /* "IHE/DSUB/Version1/BrokerSubscribeRequest.xsl" */,.tSubscription,,"HS.IHE.DSUB.NotificationBroker.Subscription","Subscription")
		If $$$ISERR(tSC) {
			If (","_$system.Status.GetErrorCodes(tSC)_",")[(",6232,") && ($system.Status.GetErrorText(tSC) [ "Topic") {
				Set tParsedDocument=""
				Set tSC = ##class(HS.IHE.Util).GetXPathDocument(.tParsedDocument,pRequest.ContentStream)
				Set tParsedDocument.PrefixMappings=tParsedDocument.PrefixMappings_" wsnt http://docs.oasis-open.org/wsn/b-2"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue("","/wsnt:Subscribe/wsnt:Filter/wsnt:TopicExpression","text()",.tValue,.tParsedDocument)
				Set pResponse.SOAPFault=$LB("TopicExpressionDialectUnknownFault","<wsntw:TopicExpressionDialectUnknownFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">An unknown topic "_tValue_" expression was provided</wsntw:TopicExpressionDialectUnknownFault>")
				Quit
			}
		}
		If $$$ISERR(tSC) Do ..Errors.logError("XDSNotificationBroker","Error",$system.Status.GetErrorText(tSC)) Quit
		Set tSC = ..SubscribeObject(tSubscription,.pResponse,pRequest)
	} Catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Internal method - do not override - use OnBeforeSubscription or OnAfterSubscription
Method SubscribeObject(pSubscription As HS.IHE.DSUB.NotificationBroker.Subscription, Output pResponse As HS.Message.XMLMessage, pRequest As HS.Message.XMLMessage = "") As %Status
{
	try {
		Set tSC=$$$OK
		Set pResponse.Name = $$$DSUBSubscribeResponse
		$$$HSTRACEMIN("SubscriptionRequest","pSubscription",pSubscription)
		#; validate type - currently only support Document and Submission
		If pSubscription.Type'="Document" && (pSubscription.Type'="Submission") {
			Do ..Errors.logError("XDSNotificationBroker","Error","Only document or submission set type subscriptions are accepted")
			Set pResponse.SOAPFault=$lb("TopicNotSupportedFault","<wsntw:TopicNotSupportedFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">"_pSubscription.TypeLogicalToDisplay(pSubscription.Type)_" is not supported</wsntw:TopicNotSupportedFault>")
			Quit
		}
		Set tHavePatient=0
		Set tSC = ..CleanupFilterItems(pSubscription)
		Quit:$$$ISERR(tSC)
		For tIdx = pSubscription.FilterItems.Count():-1:1 {
			Set tItem = pSubscription.FilterItems.GetAt(tIdx)
			Set tItemName = tItem.Item
			If 'tHavePatient && ($extract(tItemName,*-8,*) = "PatientId") {
				If tItem.Values.Count()=1 {  
					Set pSubscription.PatientID = tItem.Values.GetAt(1)
					Do pSubscription.FilterItems.RemoveAt(tIdx)
					Set tHavePatient=1
				}
			}
		}
		If pSubscription.PatientID="" {
			Set pResponse.SOAPFault=$lb("SubscribeCreationFailedFault","<wsntw:SubscribeCreationFailedFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">Unknown Patient</wsntw:SubscribeCreationFailedFault>")
			Set tSC = $$$OK
			Quit
		}			
		#; validate the patient exists
		If ..ValidatePatientID {
			Set tSC=..QueryPatientIDPDQ(pSubscription.PatientID)
			If $$$ISERR(tSC) {
				Set pResponse.SOAPFault=$lb("SubscribeCreationFailedFault","<wsntw:SubscribeCreationFailedFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">Unknown Patient</wsntw:SubscribeCreationFailedFault>")
				Set tSC = $$$OK
				Quit
			}
		}
		Set tOriginalTerminationTime = pSubscription.TerminationTime
		Set tSC = pSubscription.GetTerminationTime(tOriginalTerminationTime,..MaximumDuration,.tAdjustedTerminationTime)
		If $$$ISERR(tSC) {
			Do ..Errors.logError("XDSNotificationBroker","Error","Error calculating termination time") 
			Set pResponse.SOAPFault=$lb("SubscribeCreationFailedFault","<wsntw:SubscribeCreationFailedFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">Error calculating termination time with:"_tOriginalTerminationTime_"</wsntw:SubscribeCreationFailedFault>")
			Quit
		}
		Set pSubscription.TerminationTime=tAdjustedTerminationTime
		$$$HSTRACE("TerminationTime","In,Max,Adj,innill",tOriginalTerminationTime,..MaximumDuration,tAdjustedTerminationTime,(tOriginalTerminationTime=""))
		If pSubscription.Topic'="M" && (pSubscription.Topic'="F") && (pSubscription.Topic'="S") {
			Do ..Errors.logError("XDSNotificationBroker","Error","Unknown topic") Quit
		}
		If pSubscription.RecipientAddress="" {
			Do ..Errors.logError("XDSNotificationBroker","Error","Unknown recipient") Quit
		}

		#; for each FilterItems().Item make sure we know what it is
		Set tSC = ..ValidateFilterItems(pSubscription,.pResponse)
		If $$$ISERR(tSC) {
			Set tSC = $$$OK
			Quit
		}

		Set pSubscription.SubscriptionID=$system.Util.CreateGUID()
		Set tSC = ..OnBeforeSubscription(pSubscription,.pResponse,pRequest) Quit:$$$ISERR(tSC)
		Set tSC = pSubscription.%Save()
		Do pSubscription.XMLExportToString(.tXML)
		$$$HSTRACE("Subscription","pSubscription,tSC,tURL",tXML,tSC,pSubscription.RecipientAddress)
		If $$$ISERR(tSC) {
			Set pResponse.SOAPFault=$LB("SubscribeCreationFailedFault","<wsntw:SubscribeCreationFailedFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">"_$zcvt($system.Status.GetErrorText(tSC),"O","XML")_" is not supported</wsntw:SubscribeCreationFailedFault>")
			Do ..Errors.logError("XDSNotificationBroker","Error",$system.Status.GetErrorText(tSC)) 
			Quit
		}

		#; if everything is okay....
		Set tParam("cancellationAddress")=..NotificationBrokerService.EndPoint_"?SUB="_pSubscription.SubscriptionID
		Set tParam("terminationTime")=tAdjustedTerminationTime
		
		Set tSC = ..Transform("<foo/>",..TransformSubscribeResponse /* "IHE/DSUB/Version1/BrokerSubscribeResponse.xsl" */,.tResponse,.tParam)
		$$$HSTRACE("Transform,","tSC,tResponseStream",tSC,tResponse)
		If $$$ISERR(tSC) Do ..Errors.logError("XSDNotificationBroker","Error","Unable to transform response") Quit
		Do pResponse.ContentStream.Write(tResponse)
		Set tSC = ..OnAfterSubscription(pSubscription,.pResponse,pRequest) Quit:$$$ISERR(tSC)

	} Catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Strip leading/trailing () and '' from values, move multiple values from single line to mulitple lines
ClassMethod CleanupFilterItems(pSubscription As HS.IHE.DSUB.NotificationBroker.Subscription) As %Status
{
	try {
		Set tSC = $$$OK
		For tIdx=1:1:pSubscription.FilterItems.Count() {
			Kill tValues
			Set tItem = pSubscription.FilterItems.GetAt(tIdx)
			For tIdx1 = tItem.Values.Count():-1:1 {
				Set tValue = $zstrip(tItem.Values.GetAt(tIdx1),"<>","()")
				For tIdx2 = 1:1:$l(tValue,",") {
					Set tValueItem = $zstrip($p(tValue,",",tIdx2),"<>","'")
					Continue:tValueItem=""
					Set tValues($i(tValues))=tValueItem
				}
			}
			Do tItem.Values.Clear()
			for tIdx1 = 1:1:tValues { 
				Do tItem.Values.Insert(tValues(tIdx1))
			}
		}

	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method ValidateFilterItems(pSubscription As HS.IHE.DSUB.NotificationBroker.Subscription, pResponse As HS.Message.XMLMessage) As %Status
{
	For tIdx=1:1:pSubscription.FilterItems.Count() {
		Set tItem = pSubscription.FilterItems.GetAt(tIdx)
		If tItem.Item=""||'$d(..FilterItems(pSubscription.Type,tItem.Item)) {
			Set pResponse.SOAPFault=$lb("InvalidFilterFault","<wsntw:InvalidFilterFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">"_tItem.Item_" is not supported</wsntw:InvalidFilterFault>")
		}
	}
	#; when supporting different types and the type does not match pSubscriptionType throw fault InvalidTopicExpressionFault since we only support document don't need to worry about this
	Quit $S(pResponse.SOAPFault="":$$$OK,1:$$$ERROR($$$GeneralError,$$$Text("Invalid filter requested")))
}

/// User code capable of checking / changing subscription prior to filing
/// pSubscription is parsed subscription ready to be filed
/// pResponse is available to provide soap faults
/// pRequest is the original message
Method OnBeforeSubscription(pSubscription As HS.IHE.DSUB.NotificationBroker.Subscription, pResponse As HS.Message.XMLMessage, pRequest As HS.Message.XMLMessage) As %Status [ CodeMode = expression ]
{
$$$OK
}

/// User code fired after the subscription has been filed
/// pSubscription is subscription object which has been filed
/// pResponse is available to provide soap faults
/// pRequest is the original message
Method OnAfterSubscription(pSubscription As HS.IHE.DSUB.NotificationBroker.Subscription, pResponse As HS.Message.XMLMessage, pRequest As HS.Message.XMLMessage) As %Status [ CodeMode = expression ]
{
$$$OK
}

Method Unsubscribe(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC = $$$OK
		Set pResponse.Name = $$$DSUBUnsubscribeResponse
		Set tSubscriptionID = pRequest.AdditionalInfo.GetAt("SubscriptionID")
		Do pResponse.ContentStream.Write("<wsnt:UnsubscribeResponse xmlns:wsnt='http://docs.oasis-open.org/wsn/b-2'/>")
		Set tSubscription = ##class(HS.IHE.DSUB.NotificationBroker.Subscription).SubscriptionIDIndexOpen(tSubscriptionID)
		If $isObject(tSubscription) {
			Do pRequest.AdditionalInfo.SetAt(tSubscription.PatientID,"PatientId")
			Do pResponse.AdditionalInfo.SetAt(tSubscription.PatientID,"PatientId")
			Set tSC = tSubscription.%Delete(tSubscription.%Oid())		
			If $$$ISERR(tSC) Set pResponse.SOAPFault=$lb("UnableToDestroySubscriptionFault","<wsntw:UnableToDestroySubscriptionFault xmlns:wsntw=""http://docs.oasis-open.org/wsn/bw-2"">Unable to delete subscription</wsntw:UnableToDestroySubscriptionFault>")
			
		}
		If '$isObject(tSubscription) {
			Set pResponse.SOAPFault=$lb("ResourceUnknownFault "_tSubscriptionID,"<wsrf-rw:ResourceUnknownFault xmlns:wsrf-rw=""http://docs.oasis-open.org/wsrf/rw-2"">Unable to delete subscription</wsrf-rw:ResourceUnknownFault>")
			Do ..Errors.logError("XDSNotificationBroker","Error","Unknown subscription")
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Internal publish - (from registry)
Method InternalPublish(pRequest As HS.Message.IHE.XDSb.Metadata, Output pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC=$$$OK
		#dim tRequest as HS.Message.IHE.XDSb.Metadata = pRequest.%ConstructClone(1)
		Set tRequest.Name = $$$DSUBPublishRequest
		Set tSCAudit = $$$ATNAEvent("DocumentMetadataNotificationBroker",tRequest,"",tSC) If $$$ISERR(tSCAudit) $$$LOGSTATUS(tSCAudit)

		$$$HSTRACE("Internal Request","pRequest",tRequest)
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$DSUBNotficationResponse
		
		#; multipatient query could screw with this, but we shouldn't be getting notifications about those
		If tRequest.Documents.Count() && (tRequest.Documents.GetAt(1).PatientIdentifier.Value]"") {
			Set tPatientID = tRequest.Documents.GetAt(1).PatientIdentifier.Value
		} Else {
			//If there are no documents just quit - could be a metadata update which currently doesn't have any useful information
			Quit
		}
		Do tRequest.AdditionalInfo.SetAt(tPatientID,"PatientId")
		$$$HSTRACE("Metadata before filter","tRequest",tRequest)
		
		#; *** ANY SUBSCRIPTIONS FOR THIS PATIENT ***
		Set tRS = ##class(%ResultSet).%New("HS.IHE.DSUB.NotificationBroker.Subscription:SubscriptionsForPatient")
		Do tRS.Execute(tPatientID,$zdt($H,3,7))
		If 'tRS.%Next() $$$HSTRACE("No subscriptions for patient "_tPatientID) Quit  /// no subscriptions


		#; FOR EACH SUBSCRIPTION VALIDATE THE SUBSCRIPTION TO THE SUBMITTED DOCUMENTS
		Do {
			Kill tQueryParams
			Set tSubscription = ##class(HS.IHE.DSUB.NotificationBroker.Subscription).%OpenId(tRS.%Get("ID"),,.tSC)
			#dim tItem as HS.Types.IHE.DSUB.SubscriptionItems
			IF $$$ISERR(tSC) {
				$$$LOGERROR($$$FormatText($$$Text("Unable to open subscription with error: %1"),$System.Status.GetErrorText(tSC)))
			}
			If '$IsObject(tSubscription) Continue
			Kill ..QueryParameters
			For tIdx = 1:1:tSubscription.FilterItems.Count() {
				Set tItem = tSubscription.FilterItems.GetAt(tIdx)
				Set tFilterItem = tItem.Item
				For tValueCount = 1:1:tItem.Values.Count() {
					/// tIdx for "OR" conditions
					Set ..QueryParameters(tItem.Item,tIdx,tItem.Values.GetAt(tValueCount))=""
				}
				
			}
			Set tMetaData=##class(HS.Message.IHE.XDSb.Metadata).%New()
			/// tRequest = HS.Message.IHE.XDSb.Metadata
			If tSubscription.Type = "Document" {
				For tIdx=1:1:tRequest.Documents.Count() {
					Set tDoc = tRequest.Documents.GetAt(tIdx)
					Set:tDoc.HomeCommunityId="" tDoc.HomeCommunityId="urn:oid:"_..HomeCommunityOID
					#; if document is not filtered it will be inserted into tMetaData
					Set tSC = ..CheckFilteredDocument(tMetaData,tDoc) Quit:$$$ISERR(tSC)
				}
			} ElseIF tSubscription.Type="Submission" {
				Set tSC = ..CheckSubmissionSet(tMetaData,tRequest.Submissions.GetAt(1)) Quit:$$$ISERR(tSC)
			}
			If 'tMetaData.Documents.Count() &&('tMetaData.Submissions.Count()) Continue
			Set tParam("messageName")=$$$XDSbRegisterRequest

			#;Ensure the token sent in notification is the same as the one sent is subscription response
			Set tParam("subscriptionAddress")=..NotificationBrokerService.EndPoint_"?SUB="_tSubscription.SubscriptionID
			Set tParam("topic")=tSubscription.Topic
			Set tParam("homeCommunityOID")=..HomeCommunityOID

			/// Get inbound producer reference
			If $IsObject(tRequest.ContentStream) && (tRequest.ContentStream.Size) {
				Do ##class(HS.IHE.Util).GetXPathValue(tRequest.ContentStream,"//wsnt:Notify/wsnt:NotificationMessage/wsnt:ProducerReference/wsa:Address","text()",.tValue)
			} Else {
				Set tValue=""
			}
			Set tParam("producerReference")=$g(tValue)
			If $IsObject(tRequest.Submissions) && (tRequest.Submissions.Count()) {
				Set tParam("producerReference")="urn:oid:"_tRequest.Submissions.GetAt(1).SourceIdentifier.Value
			}
			Set tSC = ..TransformFromObject(tMetaData,..TransformDocumentToNotification /* "IHE/DSUB/Version1/BrokerCreateNotification.xsl" */,.tNotificationStream,.tParam)
			If $$$ISERR(tSC) Do ..Errors.logError("XDSNotificationBroker","Error",$system.Status.GetErrorText(tSC)) Quit
			$$$HSTRACE("notification","tNotificationStream",tNotificationStream)
			Set tNotificationMessage = ##class(HS.Message.XMLMessage).%New()
			Set tNotificationMessage.Name=$$$DSUBNotficationRequest
			Set tNotificationMessage.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
			//Set tNotificationMessage.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
			Do tNotificationMessage.AdditionalInfo.SetAt($$$DSUBNotficationRequestAction(1),"SOAPAction")
			Do tNotificationMessage.AdditionalInfo.SetAt(tSubscription.RecipientAddress,"ReplyAddress")
			Do tNotificationMessage.ContentStream.CopyFrom(tNotificationStream)
			Do tNotificationMessage.AdditionalInfo.SetAt(1,"OneWay")
			Do tNotificationMessage.AdditionalInfo.SetAt(tSubscription.PatientID,"PatientId")
			Do tNotificationMessage.AdditionalInfo.SetAt(tSubscription.Topic,"Topic")
			Set tSC = ..SendRequestSync(..NotificationOperation,tNotificationMessage,.tResponse)
			do tNotificationMessage.%Reload()  /// issue reload to handle tNotificationMessage being updated with WSA:From WSA:To
			Set tSCAudit = $$$ATNAEvent("DocumentMetadataNotificationBroker",tNotificationMessage,tResponse,tSC) If $$$ISERR(tSCAudit) $$$LOGSTATUS(tSCAudit)

			If ..Errors.HighestError="Error" $$$HSTRACE("Errors Generated") Quit
			#;
			
		} While tRS.%Next()
		
		
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method CheckSubmissionSet(pMetaData, pSubmissionSet) As %Status
{
	Set tSC = $$$OK
	try {
		Set tFilterItem="",tFilter=0
		For  {

			Set tFilterItem=$o(..QueryParameters(tFilterItem)) Quit:tFilterItem=""
			#; ..FilterItems("Submission","$XDSSubmissionSetSourceId")= ... etc
			Set tCodedField = $G(..FilterItems("Submission",tFilterItem)) Continue:tCodedField=""
			Set tType=$p(tCodedField,"^",2),tField=$p(tCodedField,"^")
			If tType="SourceID" {
				#; identifier value
				Set tFieldObject=$method(pSubmissionSet,tField_"Get")
				If '$IsObject(tFieldObject) Set tFilter=1 Quit
				Set tValueCount="",tFilterThisItem=1
				#; match one of the values or filter
				For  {
					Set tValueCount=$O(..QueryParameters(tFilterItem,tValueCount)) Quit:tValueCount=""
					Set tValueItem="" 
					For {
						Set tValueItem = $O(..QueryParameters(tFilterItem,tValueCount,tValueItem)) 
						Quit:tValueItem=""
						$$$HSTRACE("Validating "_tFieldObject.Value_"="_tValueItem_"="_(tFieldObject.Value=tValueItem))
						If tFieldObject.Value=tValueItem Set tFilterThisItem=0 Quit
					}
				}
				If tFilterThisItem Set tFilter=1 Quit
			} ElseIf tType="IR" {
				Set tFilter = ..FilterIntendedRecipients(pSubmissionSet,tFilterItem)
				If tFilter {
					$$$HSTRACE("Filter",pSubmissionSet,tFilterItem)
				}
			} ElseIf tType="A" {
				Set tFilter = ..FilterAuthor(pSubmissionSet,tFilterItem)
			}
			Quit:tFilter
		}
		If ..Errors.HighestError="Error" Quit
		If tFilter $$$HSTRACE("SubmissionSet filtered")
		If 'tFilter Do pMetaData.Submissions.Insert(pSubmissionSet)


	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// FilterAuthor for SubmissionSets and Documents
Method FilterAuthor(pObject, pFilterItem) As %Boolean
{
	Set tFilter=0,tFilterThisItem=1,tValueCount=""
	For tAuthorList=1:1:pObject.Author.Count() {
		Set tAuthorItem = pObject.Author.GetAt(tAuthorList)
		If $E(pFilterItem,*-16,*)="AuthorInstitution" {
			For tInstitutionItem = 1:1:tAuthorItem.AuthorInstitution.Count() {
				Set tInstitution = tAuthorItem.AuthorInstitution.GetAt(tInstitutionItem)
				For {
					Set tValueCount=$O(..QueryParameters(pFilterItem,tValueCount)) Quit:tValueCount=""
					Set tValueItem=""
					For  {
						Set tValueItem = $O(..QueryParameters(pFilterItem,tValueCount,tValueItem))
						Quit:tValueItem=""
						If tInstitution.Value=tValueItem Set tFilterThisItem=0 Quit
					}
				}
			}
		} Else {
			//match one of the values or filter
			For  {
				Set tValueCount=$O(..QueryParameters(pFilterItem,tValueCount)) Quit:tValueCount=""
				Set tValueItem=""
				For  {
					Set tValueItem = $O(..QueryParameters(pFilterItem,tValueCount,tValueItem))
					Quit:tValueItem=""
					If ..CompareValues(tAuthorItem.AuthorPerson,tValueItem) Set tFilterThisItem=0 Quit
				}
			}
		}
	}
	If tFilterThisItem Set tFilter=1 Quit
	Quit tFilter
}

Method FilterReferenceIdList(pDocument, pFilterItem) As %Boolean
{
	Set tFilter=0
	#; move IntendedRecipients to array
	For tIdx1=1:1:pDocument.Slots.Count() {
		Set tSlot = pDocument.Slots.GetAt(tIdx1)
		Continue:tSlot.Name'="urn:ihe:iti:xds:2013:referenceIdList"
		For tIdx2 = 1:1:tSlot.ValueList.Count() {
			Set tValues($i(tValues))=tSlot.ValueList.GetAt(tIdx2).Value
		}
	}
	If '$G(tValues) {
		#; no referenceId's quit
		Set tFilter=1
		Quit tFilter
	}
	
	#; ReferenceIdList is in slots, go through each query item and ensure a slot matches
	Set tValueCount=""
	For  {
		Set tValueCount=$O(..QueryParameters(pFilterItem,tValueCount)) Quit:tValueCount=""
		Set tQueryItemMatched=0
		Set tQueryItem=""
		For  {
			Set tQueryItem = $O(..QueryParameters(pFilterItem,tValueCount,tQueryItem))
			Quit:tQueryItem=""
			For tIdx1 = 1:1:tValues {
				Set tValue = tValues(tIdx1)
				$$$HSTRACE("Comparing referenceidlist",tValue,tQueryItem)
				Set tQueryItemMatched=..CompareValues(tValue,tQueryItem)
				Quit:tQueryItemMatched
			}	
			Quit:tQueryItemMatched
		}
		If 'tQueryItemMatched {
			Set tFilter=1
			Quit
		}
	}
	Quit tFilter
}

/// Given the pSubmissionSet determine whether the Record Should be filtered based on IntendedRecipients
Method FilterIntendedRecipients(pSubmissionSet As HS.Types.IHE.XDSb.Submission, pFilterItem) As %Boolean
{
	Set tFilter=0
	#; move IntendedRecipients to array
	For tIdx1=1:1:pSubmissionSet.IntendedRecipient.Count() {
		Set tRecipients($i(tRecipients)) = pSubmissionSet.IntendedRecipient.GetAt(tIdx1).Value
	}
	$$$HSTRACE("Recipients"_$G(tRecipients))
	If '$G(tRecipients) {
		#; no recipients quit
		Set tFilter=1
		Quit tFilter
	}
	
	#; IntendedRecipient in slots, list of values XON|XCN|XTN where XON identifies the organization, XCN identifies a person and XTN identifies the telecommunications
	#; go through each query item and ensure a slot matches
	Set tValueCount=""
	For  {
		Set tQueryItemMatched=0
		Set tValueCount=$O(..QueryParameters(pFilterItem,tValueCount)) Quit:tValueCount=""
		Set tQueryItem=""
		For  {
			Set tQueryItem = $O(..QueryParameters(pFilterItem,tValueCount,tQueryItem)) Quit:tQueryItem=""
			For tIdx1 = 1:1:tRecipients {
				Set tValue = tRecipients(tIdx1)
				Set tQueryItemMatched=..CompareValues(tValue,tQueryItem)
				$$$HSTRACE("compare","tValue,tQueryItem,tQueryItemMatched",tValue,tQueryItem,tQueryItemMatched)
				Quit:tQueryItemMatched
			}	
			Quit:tQueryItemMatched
		}
		If 'tQueryItemMatched {
			Set tFilter=1
			Quit
		}
	}
	Quit tFilter
}

/// Compare a pQueryValue to pValue considering % as like or _, otherwise only equal
ClassMethod CompareValues(pValue, pQueryValue) As %Boolean
{
	Set tResult = ##class(%SQL.Statement).%ExecDirect(,"select 1 where ? like ?",pValue,pQueryValue)
	If tResult.SQLCODE Quit 0
	Quit tResult.%Next()
}

Method CheckFilteredDocument(pMetaData, pDocument) As %Status
{
	Set tSC = $$$OK
	try {
		Set tFilterItem="",tFilter=0
		For  {
			Set tFilterItem=$o(..QueryParameters(tFilterItem)) Quit:tFilterItem=""
			#; ..FilterItems("Document","$XDSDocumentEntryEventCodeList")="EventCodeList^L" ... etc
			Set tCodedField = $G(..FilterItems("Document",tFilterItem)) Continue:tCodedField=""
			Set tType=$p(tCodedField,"^",2),tField=$p(tCodedField,"^")
			$$$HSTRACE(" filter type "_tType)
			If tType="I" {
				#; individual value
				Set tFieldObject=$method(pDocument,tField_"Get")
				If '$IsObject(tFieldObject) Set tFilter=1 Quit
				Set tValueCount="",tFilterThisItem=1
				#; match one of the values or filter
				For  {
					Set tValueCount=$O(..QueryParameters(tFilterItem,tValueCount)) Quit:tValueCount=""
					Set tValueItem = $O(..QueryParameters(tFilterItem,tValueCount,""))
					If tFieldObject.Code=$p(tValueItem,"^") && (tFieldObject.CodingScheme=$p(tValueItem,"^",3)) Set tFilterThisItem=0 Quit
				}
				If tFilterThisItem Set tFilter=1 Quit
			} ElseIf tType="L" {
				#; list of values
				Set tFieldList=$method(pDocument,tField_"Get")
				If '$IsObject(tFieldList) || (tFieldList.Count()=0) Set tFilter=1 Quit
				Set tFilterThisItem=1
				For tIdx1 =1:1:tFieldList.Count() {
					Set tFieldObject=tFieldList.GetAt(tIdx1)
					If '$IsObject(tFieldObject) Continue
					Set tValueCount=""
					#; match one of the values or filter
					For  {
						Set tValueCount=$O(..QueryParameters(tFilterItem,tValueCount)) Quit:tValueCount=""
						Set tValueItem = $O(..QueryParameters(tFilterItem,tValueCount,""))
						If tFieldObject.Code=$p(tValueItem,"^") && (tFieldObject.CodingScheme=$p(tValueItem,"^",3)) Set tFilterThisItem=0 Quit
					}
					Quit:'tFilterThisItem
				}
				If tFilterThisItem Set tFilter=1 Quit			
			} ElseIf tType="A" {
				Set tFilter = ..FilterAuthor(pDocument,tFilterItem)
			} ElseIf tType="ReferenceIdList" {
				Set tFilter = ..FilterReferenceIdList(pDocument,tFilterItem)
				$$$HSTRACE("in referece id list"_tFilter)
			} Else {
				Do ..Errors.logError("NotificationBroker","Error","Unknown filter type "_tType)
			}
		}
		If ..Errors.HighestError="Error" Quit
		If tFilter $$$HSTRACE("Document filtered","pDocument",pDocument)
		If 'tFilter Do pMetaData.Documents.Insert(pDocument)


	} catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// Get the Metadata from the notification
Method GetNotificationRequest(pRequest As HS.Message.XMLMessage, Output pNewRequest As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC = ..TransformIntoObject(pRequest.ContentStream,..TransformPublishToMessage /*"IHE/DSUB/Version1/BrokerNotificationToMetadataObject.xsl"*/,.pNewRequest,,"HS.Message.IHE.XDSb.Metadata","Metadata")
		If $$$ISERR(tSC) Do ..Errors.logError("XDSNotificationBroker","Error",$system.Status.GetErrorText(tSC)) Quit
		Set pNewRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
		Set pNewRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
		Do pNewRequest.ContentStream.CopyFrom(pRequest.ContentStream)
		Set pNewRequest.Name = $$$DSUBNotficationRequest
		$$$HSTRACE("New Message","pNewRequest",pNewRequest)
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("NotificationBroker","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method QueryPatientIDPDQ(pPatientID) As %Status
{
	#;SAML Note: This is only called when validating patient ID during register, so consent
	#;	by user is not applicable. If this ever needs to use the SAML user, much of this 
	#;	code will need refactoring to send the AdditionalInfo array from the initiating 
	#;  request all the way down here.
	
	Set tSC=$$$OK
	try {
		Set tID=$p(pPatientID,"^^^",1)
		If $zstrip(tID,"*WC")'=tID Set tSC = $$$ERROR($$$GeneralError,"Patient ID contains invalid characters") Quit
		#; connectathon only check
		//If tID=911 Quit
		Set tAAoid=$p($p(pPatientID,"^^^",2),"&",2)
		Set tAA=##class(HS.Data.OIDMap).GetCodeForOID(tAAoid)
		If ..ValidateAffinityDomain && (tAA '= ##class(HS.IHE.Util).GetAffinityDomain()) Set tSC = $$$ERROR($$$GeneralError,"Unknown affinity domain:"_tAA) Quit
		Set tSearchRequest=##class(HS.Message.PatientSearchRequest).%New()
		Set tSearchRequest.MPIID=tID
		Set tSearchRequest.AssigningAuthority=tAA
		Set tSearchRequest.SearchMode="PIXPDQ"
		Set tSC = ..SendRequestSync(..PDQConsumer, tSearchRequest, .tSearchResponse)
		$$$HSTRACE("response from pdq lookup ","tSearchRequest,tSearchResponse,tSC",tSearchRequest,tSearchResponse,tSC)
		If '$isObject(tSearchResponse) || (tSearchResponse.Results.Count()=0) {
			Set tSC=$$$ERROR($$$GeneralError,"No Patient match") 
		} Else {
			Set tSC=$$$OK
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

Method BuildFilterItems()
{
	Set ..FilterItems("Document","$XDSDocumentEntryTypeCode")="TypeCode^I"
	Set ..FilterItems("Document","$XDSDocumentEntryEventCodeList")="EventCodeList^L"
	Set ..FilterItems("Document","$XDSDocumentEntryClassCode")="ClassCode^I"
	Set ..FilterItems("Document","$XDSDocumentEntryPracticeSettingCode")="PracticeSettingCode^I"
	Set ..FilterItems("Document","$XDSDocumentEntryHealthcareFacilityTypeCode")="HealthCareFacilityTypeCode^I"
	Set ..FilterItems("Document","$XDSDocumentEntryConfidentialityCode")="ConfidentialityCode^L"
	Set ..FilterItems("Document","$XDSDocumentEntryFormatCode")="FormatCode^I"
	Set ..FilterItems("Document","$XDSDocumentEntryAuthorPerson")="Author^A"
	Set ..FilterItems("Document","$XDSDocumentEntryAuthorInstitution")="AuthorInstitution^A"
	Set ..FilterItems("Document","$XDSDocumentEntryReferenceIdList")="Slot^ReferenceIdList"
	Set ..FilterItems("Submission","$XDSSubmissionSetSourceId")="SourceIdentifier^SourceID"
	Set ..FilterItems("Submission","$XDSSubmissionSetAuthorPerson")="Author^A"
	Set ..FilterItems("Submission","$XDSSubmissionSetAuthor")="Author^A"  // this is old - from before CP-ITI-1146-03
	Set ..FilterItems("Submission","$XDSSubmissionSetAuthorInstitution")="AuthorInstitution^A"
	Set ..FilterItems("Submission","$XDSSubmissionSetIntendedRecipient")="IntendedRecipient^IR"
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	Set tSC = $$$OK
	If ..NotificationBrokerService="" {
		Set ..NotificationBrokerService=##class(HS.Registry.Service.SOAP).EndPointForNameType(..NotificationBrokerServiceName,"SOAP")
		If ..NotificationBrokerService="" {
			If ..NotificationBrokerServiceName="" {
				Set tString = $$$Text("The NotificationBrokerServiceName is not set, but is required")
			} Else {
				Set tString=$$$Text("The NotificationBrokerServiceName is not set, but is not a valid name")
			}
			Set tSC = $$$ERROR($$$GeneralError,tString)
		}
	}
	Set:..HomeCommunityOID="" ..HomeCommunityOID=$$$HomeCommunityOID
	Quit tSC
}

Storage Default
{
<Data name="OperationsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%RequestHeader</Value>
</Value>
<Value name="3">
<Value>AlertOnError</Value>
</Value>
<Value name="4">
<Value>IOLogEntry</Value>
</Value>
<Value name="5">
<Value>%QuitTask</Value>
</Value>
<Value name="6">
<Value>%SessionId</Value>
</Value>
<Value name="7">
<Value>CallbackHandler</Value>
</Value>
<Value name="8">
<Value>ErrorHandler</Value>
</Value>
<Value name="9">
<Value>DefaultSSLConfig</Value>
</Value>
<Value name="10">
<Value>ResponseTimeout</Value>
</Value>
<Value name="11">
<Value>MaximumDuration</Value>
</Value>
<Value name="12">
<Value>DeferResponse</Value>
</Value>
<Value name="13">
<Value>%AlertStartTime</Value>
</Value>
<Value name="14">
<Value>ClearCallbackVariables</Value>
</Value>
<Value name="15">
<Value>Adapter</Value>
</Value>
<Value name="16">
<Value>%ConfigQueueName</Value>
</Value>
<Value name="17">
<Value>%ConfigName</Value>
</Value>
<Value name="18">
<Value>AlertRetryGracePeriod</Value>
</Value>
<Value name="19">
<Value>ArchiveIO</Value>
</Value>
<Value name="20">
<Value>DoHSTrace</Value>
</Value>
<Value name="21">
<Value>Errors</Value>
</Value>
<Value name="22">
<Value>FailureTimeout</Value>
</Value>
<Value name="23">
<Value>Initialized</Value>
</Value>
<Value name="24">
<Value>NoFailWhileDisconnected</Value>
</Value>
<Value name="25">
<Value>NotificationOperation</Value>
</Value>
<Value name="26">
<Value>PDQConsumer</Value>
</Value>
<Value name="27">
<Value>ReplyCodeActions</Value>
</Value>
<Value name="28">
<Value>Retry</Value>
</Value>
<Value name="29">
<Value>RetryCount</Value>
</Value>
<Value name="30">
<Value>RetryInterval</Value>
</Value>
<Value name="31">
<Value>SAMLCreator</Value>
</Value>
<Value name="32">
<Value>SOAPCredentials</Value>
</Value>
<Value name="33">
<Value>SOAPVersion</Value>
</Value>
<Value name="34">
<Value>SSLConfiguration</Value>
</Value>
<Value name="35">
<Value>SendSAMLAssertion</Value>
</Value>
<Value name="36">
<Value>ServiceName</Value>
</Value>
<Value name="37">
<Value>ServiceNameValue</Value>
</Value>
<Value name="38">
<Value>SuspendMessage</Value>
</Value>
<Value name="39">
<Value>TargetName</Value>
</Value>
<Value name="40">
<Value>TraceOperations</Value>
</Value>
<Value name="41">
<Value>TransformDocumentNotification</Value>
</Value>
<Value name="42">
<Value>TransformPublishToMessage</Value>
</Value>
<Value name="43">
<Value>TransformSubscribeNotification</Value>
</Value>
<Value name="44">
<Value>TransformSubscribeResponse</Value>
</Value>
<Value name="45">
<Value>ValidatePatientID</Value>
</Value>
<Value name="46">
<Value>XSLTCacheMode</Value>
</Value>
<Value name="47">
<Value>XSLTCallbackHandlerClass</Value>
</Value>
<Value name="48">
<Value>XSLTDirectory</Value>
</Value>
<Value name="49">
<Value>XSLTErrorHandlerClass</Value>
</Value>
</Data>
<Data name="StyleSheets">
<Attribute>StyleSheets</Attribute>
<Structure>subnode</Structure>
<Subscript>"StyleSheets"</Subscript>
</Data>
<DataLocation>^HS.IHE.DSUB.NotE69C.OperationsD</DataLocation>
<DefaultData>OperationsDefaultData</DefaultData>
<IdLocation>^HS.IHE.DSUB.NotE69C.OperationsD</IdLocation>
<IndexLocation>^HS.IHE.DSUB.NotE69C.OperationsI</IndexLocation>
<StreamLocation>^HS.IHE.DSUB.NotE69C.OperationsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
