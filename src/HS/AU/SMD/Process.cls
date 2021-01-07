Class HS.AU.SMD.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ ClassType = persistent ]
{

Parameter SETTINGS As %String = "MessageProcessor:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},TransportResponseDelivery:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// Custom defined handler for processing inbound messages
Property MessageProcessor As Ens.DataType.ConfigName;

/// Operation to handle outbound messages
Property TransportResponseDelivery As Ens.DataType.ConfigName [ InitialExpression = "HS.AU.SMD.Operations" ];

/// Take Deliver or ImmediateDeliver message
/// For Deliver - check for duplicates and respond duplicate / ok
/// build response message
Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	try {
		Set tSC=$$$OK
		If pRequest.%IsA("HS.AU.Message.SMD.TransportDeliveryRequest") {
			Set tSC = ..UpdateTransportStatus(pRequest,.pResponse)
			Quit
		}

		If 'pRequest.Synchronous {
			Do ..GetDeliverStatus(pRequest,.pResponse)
			Do ..Reply(pResponse)
		} Else {
			Set pResponse = ##class(HS.AU.Message.SMD.MessageType).%New()
		}
		If ..MessageProcessor]"" {
			Set tSC = ..SendRequestAsync(..MessageProcessor,pRequest,1,"MessageHandler")
		} Else {
			#; no message processor just send the acknowledgement
			If 'pRequest.Synchronous {
				Set tSC = ..SendTransportResponse(pRequest)
			}
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Locate any inbound messages with the same invocationId and reject as a duplicate when needed
Method GetDeliverStatus(pRequest As HS.AU.Message.SMD.InboundMessageRequest, Output pResponse As HS.AU.Message.SMD.DeliveryResponse) As %Status
{
	try {
		Set tSC=$$$OK
		Set pResponse=##class(HS.AU.Message.SMD.DeliveryResponse).%New()
		&sql(select * from HS_AU_Message_SMD.InboundMessageRequest where Metadata_InvocationId = :pRequest.Metadata.InvocationId )
		Set pResponse.Status=$S(SQLCODE:"duplicate",1:"ok")
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Update acknowledgement status for inbound messages (after sending TRD response)
Method UpdateInboundDeliveryStatus(pRequest As HS.AU.Message.SMD.InboundMessageRequest) As %Status
{
	try {
		Set tSC=$$$OK
		&sql(Update HS_AU_Message_SMD.InboundMessageRequest Set Status = 'Acknowledged' where Metadata_InvocationId = :pRequest.Metadata.InvocationId )
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Update acknowledgement status for outbound messages (after receiving TRD response)
Method UpdateTransportStatus(pRequest As HS.AU.Message.SMD.TransportDeliveryRequest, Output pResponse As HS.AU.Message.SMD.TransportDeliveryResponse) As %Status
{
	try {
		Set tSC=$$$OK,tAllNotOK=0,pResponse = ##class(HS.AU.Message.SMD.TransportDeliveryResponse).%New(),pResponse.Status=$$$OK
		For tIdx=1:1:pRequest.Response.Count() {
			Set tInvocationId = pRequest.Response.GetAt(tIdx).Metadata.InvocationId
			&sql(Update HS_AU_Message_SMD.deliveryrequest Set Status = 'Acknowledged' where InvocationId = :tInvocationId )
			IF SQLCODE Set tAllNotOK=$i(tAllNotOK)
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	If tAllNotOK Set pResponse.Status="Failed to Process "_tAllNotOK_" of "_pRequest.Response.Count()_" response(s)"
	Quit tSC
}

Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	try {
		Set tSC=$$$OK
		If pCompletionKey="MessageHandler" {
			If 'pRequest.Synchronous {
				Set tSC =..SendTransportResponse(pCallrequest)
			} Else {
				Set pResponse = pCallresponse
			}				
		} ElseIf pCompletionKey="TransportResponseDelivery" {
			If $IsObject(pCallresponse) && (pCallresponse.Status="ok") {
				#; successfully sent TransportResponseDelivery - Mark transaction as completed
				Set tSC = ..UpdateInboundDeliveryStatus(pRequest)
			}
		}
	} catch ex {
		Set tSC = ex.AsStatus()
		
	}
	Quit tSC
}

Method SendTransportResponse(pInboundMessage As HS.AU.Message.SMD.InboundMessageRequest, pResponseStatus As %Status = {$$$OK}, pResponseCode As %String = "", pResponseMessage As %String = "") As %Status
{
	Try {
		set tSC=$$$OK
		Set tRequest = ##class(HS.AU.Message.SMD.TransportDeliveryRequest).%New()
		Set tResponse = ##class(HS.AU.Types.SMD.TransportResponseType).%New()
		Do tRequest.Response.Insert(tResponse)
		
		Set tResponse.Final=1
		#dim tInboundMetadata as HS.AU.Types.SMD.TransportResponseMetadataType = pInboundMessage.Metadata
		#dim tOutboundMetadata as HS.AU.Types.SMD.TransportResponseMetadataType = tResponse.Metadata

		Set tRequest.TransportDeliveryEndpoint = ..GetTransportEndpoint(pInboundMessage)
		Set tRequest.Sender = tInboundMetadata.ReceiverOrganisation
		
		Set tOutboundMetadata.InvocationId = tInboundMetadata.InvocationId
		Set tOutboundMetadata.SenderOrganisation = tInboundMetadata.SenderOrganisation
		Set tOutboundMetadata.ReceiverOrganisation= tInboundMetadata.ReceiverOrganisation
		Set tOutboundMetadata.ServiceCategory = tInboundMetadata.ServiceCategory
		Set tOutboundMetadata.TransportResponseTime = $zdatetime($h,3,1)  //$zdatetime($ztimestamp,3)   
		Set tOutboundMetadata.ResponseId = $zcvt("urn:uuid:"_$system.Util.CreateGUID(),"l")
		Set tOutboundMetadata.SourceOrganisation = tInboundMetadata.ReceiverOrganisation
		Set tDeliveryResponse = tResponse.DeliveryResponse

		Set tSC = ..GetResponseCode(pResponseStatus,.tResponseString,.tResponseCode,.tResponseMessage) quit:$$$ISERR(tSC)

		Set tDeliveryResponse.ResponseClass=tResponseString
		if tResponseString="Success" {
			// Success
			Set tDeliveryResponse.DigestValue=pInboundMessage.DigestValue
			set tDeliveryResponse.ResponseCode=""
			set tDeliveryResponse.Message=""
		} else {
			// not Success
			set tDeliveryResponse.ResponseCode=tResponseCode
			set tDeliveryResponse.Message=tResponseMessage
		}

		Set tSC = ..SendRequestAsync(..TransportResponseDelivery,tRequest,1,"TransportResponseDelivery")
	} catch ex {
		set tSC=ex.AsStatus()
	}
	
 	Quit tSC
}

Method GetResponseCode(pResponseStatus, ByRef pResponseString, ByRef pResponseCode, ByRef pResponseMessage) As %Status
{
		Set (pResponseCode,pResponseMessage)=""
		Set pResponseString = $S(pResponseStatus=$$$OK:"Success",1:"Error")
		If $$$ISERR(pResponseStatus) Set pResponseCode=$system.Status.GetErrorCodes(pResponseStatus),pResponseMessage=$system.Status.GetErrorText(pResponseStatus)
		Quit $$$OK
}

Method GetTransportEndpoint(pInboundMessage As HS.AU.Message.SMD.InboundMessageRequest) As %String
{
	Set tString=""
	Set tRouteRecords = pInboundMessage.Metadata.RouteRecord
	For tIdx = tRouteRecords.Count():-1:1 {
		Set tRR=tRouteRecords.GetAt(tIdx)
		Continue:tRR.Interaction.ServiceInterface'="http://ns.electronichealth.net.au/smd/intf/TransportResponseDelivery/TLS/2010"
		Set tString = tRR.Interaction.ServiceEndpoint 
		Quit
	}
	Quit tString
}

/// This method is called when an error response is received
/// Returning the same error will cause the BusinessProcess to set its status to error and close down
/// Returning $$$OK from this method causes the BusinessProcess to recover from this error
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	Quit pErrorStatus
}

XData MessageMap
{
<MapItems>
<MapItem MessageType="HS.AU.Message.SMD.TransportDeliveryRequest">
<Method>TransportDelivery</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.SMD.ImmediateDeliveryRequest">
<Method>DeliverImmediate</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.SMD.DeliveryRequest">
<Method>Deliver</Method>
</MapItem>

</MapItems>
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>MessageProcessor</Value>
</Value>
<Value name="3">
<Value>TransportResponseDelivery</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
