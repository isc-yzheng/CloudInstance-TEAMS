///  Retry is not working... E=R in Additional:ReplyCodeAction - it creates a new message, and therefore a new invocation id
///  need to make it one invocation id with timestamps.
Class HS.AU.SMD.Operations Extends (Ens.BusinessOperation, HS.AU.SMD.Common, HS.HC.Util.Trace.Helper) [ ProcedureBlock ]
{

Parameter SETTINGS = "-ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems}";

Parameter ADAPTER = "HS.Util.SOAPClient.Adapter.Outbound";

/// ELSOperations:Basic:selector?multiSelect=0&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}
/// Property ELSOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.AU.ELS.Operations" ];
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

/// Handle sending a TransportDeliveryRequest (notification that we have processed the message)
Method TransportDelivery(pRequest As HS.AU.Message.SMD.TransportDeliveryRequest, Output pResponse As HS.AU.Message.SMD.DeliveryResponse) As %Library.Status
{
	Set tSC=$$$OK
	Try {
		// Set Web proxy client class to use
		Set ..Adapter.WebServiceClientClass ="HS.AU.SMD.SoapClient.TransportResponseDelivery"
 
 		// Location URL 	
		Set ..Adapter.WebServiceURL=pRequest.TransportDeliveryEndpoint
		
		set tConfig=##class(HS.AU.SMD.Configuration).HPIOIndexOpen(pRequest.Sender)
		If '$isObject(tConfig) Set tSC = $$$ERROR($$$GeneralError,"Unable to locate sender configuration for "_pRequest.Sender) Quit
		// If SSL/TLS configuration to use is not specified in the production, retrieve it from the HPI-O configuration settings
		Set:..Adapter.SSLConfig="" ..Adapter.SSLConfig=tConfig.SSLConfig

		Set tSC = ..SetHeader("http://ns.electronichealth.net.au/smd/svc/TransportResponseDelivery/2010/TransportResponseDelivery/deliverRequest")

		$$$THROWONERROR(tSC,..Adapter.InvokeMethod("deliver",.status,pRequest.Response))
		Set pResponse = ##class(HS.AU.Message.SMD.DeliveryResponse).%New()
		Set pResponse.Status=status
	
	} catch ex {
		set tSC=ex.AsStatus()
        if $ZERROR["<ZSOAP>" {
            Set tSC=%objlasterror
        }
	}
	
 	Quit tSC
}

Method DeliverImmediate(pRequest As HS.AU.Message.SMD.ImmediateDeliveryRequest, Output pResponse As HS.AU.Message.SMD.ImmediateDeliveryResponse) As %Library.Status
{
	set tServiceInterface = "http://ns.electronichealth.net.au/smd/intf/SealedImmediateMessageDelivery/TLS/2010"

	set tSC=$$$OK
	Try {
		// Set Web proxy client class to use
		set ..Adapter.WebServiceClientClass="HS.AU.SMD.SoapClient.ImmediateDelivery"

		Set tSC =..SetHeader("http://ns.electronichealth.net.au/smd/svc/SealedImmediateMessageDelivery/2010/SealedImmediateMessageDelivery/deliverRequest")
		Quit:$$$ISERR(tSC)
		Set tSC = ..DeliverCommon(pRequest,tServiceInterface,.tBody)
		Quit:$$$ISERR(tSC)
		
		// ; Note: Unlike Sealed Message Delivery, routeRecord is empty for Sealed Immediate Message Delivery	
		
	 	// Invoke web service
		$$$HSTRACEMIN("WebService","Request",tBody)
		Set tSC = ..Adapter.InvokeMethod("deliver",.tResponse,tBody)
		If $$$ISERR(tSC) $$$HSTRACEERROR("WebService","ResponseErrorStatus",$zcvt($system.Status.GetErrorText(tSC),"O","HTML")) Quit
		$$$HSTRACEMIN("WebService","Response",tResponse)
		Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC)
		Set pResponse.Metadata=tResponse.Response.Metadata.%ConstructClone(1)
	
		// Validate (decrypt and validate signatures)
		set tSC=..ValidateResponse(tResponse,..Adapter.%Client.ImportHandler,.tObjData) 
		IF $$$ISERR(tSC) {
			$$$HSTRACEERROR("Validation problem","tResponse",tResponse)
			$$$LOGSTATUS(tSC)
			Quit
		}
		set pResponse.PayloadObject=tObjData
		$$$HSTRACE("Response","pResponse",pResponse)
	} catch errVar {
		set tSC=errVar.AsStatus()
	}
 	Quit tSC
}

Method Deliver(pRequest As HS.AU.Message.SMD.DeliveryRequest, Output pResponse As HS.AU.Message.SMD.DeliveryResponse) As %Library.Status
{
	set tServiceInterface = "http://ns.electronichealth.net.au/smd/intf/SealedMessageDelivery/TLS/2010"

	set tSC=$$$OK
	Try {
		// Set Web proxy client class to use
		set ..Adapter.WebServiceClientClass="HS.AU.SMD.SoapClient.Delivery"

		Set tSC =..SetHeader("http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010/SealedMessageDelivery/deliverRequest")
		Quit:$$$ISERR(tSC)
		Set tSC = ..DeliverCommon(pRequest,tServiceInterface,.tBody)
		Quit:$$$ISERR(tSC)

		#; Route record is required to tell responder how to provide the processed response
		Set tSC = ..SetRouteRecord(pRequest,tBody)

	 	// Invoke web service
		$$$HSTRACEMIN("WebService","Request",tBody)
		Set tSC = ..Adapter.InvokeMethod("deliver",.tResponse,tBody)
		If $$$ISERR(tSC) $$$HSTRACEERROR("WebService","ResponseErrorStatus",$zcvt($system.Status.GetErrorText(tSC),"O","HTML")) Quit
		$$$HSTRACEMIN("WebService","Response",tResponse)
		Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC)
		Set pResponse.Status=tResponse.Status
	
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
 	Quit tSC
}

Method DeliverCommon(pRequest As HS.AU.Message.SMD.DeliveryRequestBase, pServiceInterFace As %String, Output pBody, Output pObjSI, Output pSignWith, Output pEncryptWith)
{
	set tSC=$$$OK
	Try {

		set tConfig=##class(HS.AU.SMD.Configuration).HPIOIndexOpen(pRequest.Sender)
		If '$isObject(tConfig) Set tSC = $$$ERROR($$$GeneralError,"Unable to locate sender configuration for "_pRequest.Sender) Quit
	
		// locate the interaction record in the Interactions cache to use.
		Set tSC = ..GetInteraction(pRequest.Target,pRequest.ServiceCategory,pServiceInterFace,.tObjSI) Quit:$$$ISERR(tSC)
		
		// using the service interaction, prepare a metadata object to include in the SOAP request.
		#dim objMeta as HS.AU.Types.SMD.MessageMetadataType
		$$$THROWONERROR(tSC,..MakeMetadata(.tObjMeta,tObjSI,pRequest))

		// Location URL 	
		Set ..Adapter.WebServiceURL=tObjSI.ServiceEndpoint

		// Get an X509 Credentials object built from the 'Payload' useQualifier on the selected interaction
		$$$THROWONERROR(tSC,tObjSI.GetX509("P",.tEncryptWith))

		// Get an X509 Credentials object built from a supplied X509 Alias or default against this gateway's settings
		$$$THROWONERROR(tSC,tConfig.GetSigningX509(.tSignWith))
		
		// If SSL/TLS configuration to use is not specified in the production, retrieve it from the HPI-O configuration settings
		Set:..Adapter.SSLConfig="" ..Adapter.SSLConfig=tConfig.SSLConfig

		// encrypt contents passed (data) and place it into <body.message.encryptedPayload>
		// prepare message for Web service.
		set pBody=##class(HS.AU.Types.SMD.Deliver).%New()
		set pBody.Message=##class(HS.AU.Types.SMD.SealedMessageType).%New()
		set pBody.Message.Metadata=tObjMeta
		
		set tSC=..SignAndEncrypt(pRequest.PayloadObject,tSignWith,tEncryptWith,.encryptedPayload)  Quit:$$$ISERR(tSC)
		set pBody.Message.EncryptedPayload=encryptedPayload
		
	} catch ex {
		set tSC=ex.AsStatus()
	}
 	Quit tSC
}

/// Get interaction information from the InteractionCache (eventually this will query out to ELS Operation)
Method GetInteraction(pTarget As %String, pServiceCategory As %String, pServiceInterface As %String, ByRef pObjSI As HS.AU.ELS.InteractionCache) As %Status
{
	try {
		Set pObjSI=""
		Set tSC = ##class(HS.AU.ELS.InteractionCache).GetInteractions(.sis,pTarget,pServiceCategory,pServiceInterface) 
		Quit:$$$ISERR(tSC)
		
		if sis.Count()=0 {
			; no interactions found for this target/category combination
			set tSC=$$$ERROR($$$GeneralError,"No Service Interaction found for Target: "_$piece(pTarget,"/",$l(pTarget,"/"))_" and Category: "_pServiceCategory)
			$$$ThrowStatus(tSC)
		} else {
			set pObjSI=sis.GetAt(1)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	} 
	Quit tSC
}

/// This method must return an interaction record for a TRD service which will be added to the deliver operation's metadata <routeRecord>.
/// The nominated endpoint in the service interaction specified here, will receive transport responses from the recipient 
Method SetRouteRecord(pRequest As HS.AU.Message.SMD.DeliveryRequest, pBody As HS.AU.Types.SMD.Deliver) As %Status
{
	set tSC=$$$OK
	Try {
		Set tServiceInterface="http://ns.electronichealth.net.au/smd/intf/TransportResponseDelivery/TLS/2010"
		//  Need to specify endpoint to receive responses. 
		Set tSC = ..GetInteraction(pRequest.Sender,pRequest.ServiceCategory,tServiceInterface,.tObjSI)

		set tInteraction=##class(HS.AU.Types.ELS.InteractionType).%New()
		set tInteraction.Target=pRequest.Sender
		set tInteraction.ServiceInterface=tServiceInterface
		set tInteraction.ServiceCategory=pRequest.ServiceCategory
		set tInteraction.ServiceEndpoint=tObjSI.ServiceEndpoint
		set tInteraction.ServiceProvider=pRequest.Sender

		set tRouteRecord=##class(HS.AU.Types.SMD.RouteRecordEntryType).%New()
		set tRouteRecord.SendIntermediateResponses=0
		set tRouteRecord.Interaction=tInteraction
		Do pBody.Message.Metadata.RouteRecord.Insert(tRouteRecord)
	} Catch ex {
		set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Using interaction information make Metadata object
ClassMethod MakeMetadata(ByRef metadata As HS.AU.Types.SMD.MessageMetadataType, objSI As HS.AU.ELS.InteractionCache, pRequest As HS.AU.Message.SMD.DeliveryRequestBase) As %Status
{
	set tSC=$$$OK
	Try {
		set metadata=##class(HS.AU.Types.SMD.MessageMetadataType).%New()
		set metadata.ReceiverIndividual=	pRequest.ReceiverIndividual 
		set metadata.ReceiverOrganisation=	objSI.Target
		set metadata.SenderIndividual=		pRequest.SenderIndividual
		set metadata.SenderOrganisation=	objSI.ServiceProvider
		set metadata.ServiceCategory= 		objSI.ServiceCategory
		set metadata.ServiceInterface= 		objSI.ServiceInterface
		
		set metadata.CreationTime=pRequest.CreationTime
		set metadata.ExpiryTime=pRequest.ExpiryTime
		set metadata.InvocationId=pRequest.InvocationId
		
	} catch ex {
		set tSC=ex.AsStatus()
	}
	
	quit tSC
}

ClassMethod ValidateResponse(pResponse As HS.AU.Message.SMD.ImmediateDeliveryResponse, document As %XML.Document, ByRef objData As HS.AU.SMD.BaseDataType) As %Status
{
	set tSC=$$$OK 
	set ePayload=pResponse.Response.EncryptedPayload

	if ePayload.Validate(.document) {
		// At this point the SOAP message (document) is now decrypted.  Signatures can be unpacked and checked.
		set reader=##class(%XML.Reader).%New()
		set reader.Document=document

		Set tInput = ##class(%Stream.GlobalCharacter).%New()
		Set tWriter = ##class(%XML.Writer).%New()
		Set tSC = tWriter.OutputToStream(tInput)
		Do tWriter.Document(document)
		Do tInput.Rewind()
		do reader.Correlate("signedPayload","HS.AU.SMD.SignedPayloadType")
		if 'reader.Next(.signedPayload,.sc) {
			if $$$ISOK(sc) {
				set tSC=$$$ERROR($$$GeneralError,"no signed payload")
			} else {
				set tSC=$$$ERROR($$$GeneralError,"decrypt Error: "_$system.Status.GetErrorText(sc))
			}
		}
	} else {
		set tSC=$$$ERROR($$$GeneralError,"unable to decrypt")
	} 
	
	quit:$$$ISERR(tSC) tSC

	set tSC=signedPayload.Validate(document)
	if $$$ISERR(tSC) {
		set tSC=$$$ERROR($$$GeneralError,"signature Error: "_$system.Status.GetErrorText(sc))
		quit tSC
	}
	set objData=signedPayload.SignedPayloadData.Content
	quit $$$OK
}

Method SetHeader(pAction)
{
	Set tSC = $$$OK
	try {
		// Add Addressing headers (define destination endpoint)
		set tWSA=##class(%SOAP.Addressing.Properties).%New()
		set tWSA.Action=pAction
		set tWSA.MessageId=$System.Util.CreateGUID()
		set tWSA.Destination="http://www.w3.org/2005/08/addressing/anonymous"

		set tEP=##class(%SOAP.Addressing.EndpointReference).%New()
		set tEP.Address="http://www.w3.org/2005/08/addressing/anonymous"
		set tWSA.SourceEndpoint=tEP
		set ..Adapter.%Client.AddressingOut=tWSA
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	quit tSC
}

}
