Include HS.IHE.DSUB

Class HS.IHE.DSUB.NotificationBroker.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "NotificationBroker_Service";

Parameter SETTINGS = "NotificationTarget,SubscribeTarget,UnsubscribeTarget,XMLValidator";

Property SubscribeTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.DSUB.NotificationBroker.Operations" ];

Property UnsubscribeTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.DSUB.NotificationBroker.Operations" ];

Property NotificationTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.DSUB.NotificationBroker.Operations" ];

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACEMIN("Inbound SOAP Request","pRequest",pRequest)
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If ..isAsync { Set pResponse = ##class(HS.Message.XMLMessage).%New() }
		If (tAction = $$$DSUBSubscribeRequestAction(1)) {
			Set pRequest.Name = $$$DSUBSubscribeRequest
			Set tSC = ..Subscribe(pRequest, .pResponse)
			#; validate after call so that session has been assigned
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$DSUBSubscribeResponseAction(1),"Response")
		} ElseIf (tAction = $$$DSUBUnsubscribeRequestAction(1)) {
			Set pRequest.Name = $$$DSUBUnsubscribeRequest
			Set tSC = ..Unsubscribe(pRequest, .pResponse)
			#; validate after call so that session has been assigned
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Do ..ValidateMessage(pResponse,$$$DSUBUnsubscribeResponseAction(1),"Response")
		} ElseIf (tAction = $$$DSUBPublishRequestAction(1)) {
			Set pRequest.Name = $$$DSUBPublishRequest
			Set tSC = ..Notification(pRequest, .pResponse)
			#; validate after call so that session has been assigned
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Set pResponse=""
		} Else {
			Set tSC = $$$EnsError("Unknown SOAP action:  " _ tAction)
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}

	}
	Catch eException {
		$$$LOGERROR(eException.DisplayString())
		Set tSC = eException.AsStatus()
	}

	Quit tSC
}

/// ITI-52
Method Subscribe(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "http://docs.oasis-open.org/wsn/bw-2/NotificationProducer/SubscribeRequest", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Try {
		Do ..SetAddressingOut($$$DSUBSubscribeResponseAction(1))
		Set tSC = ..SendRequestSync(..SubscribeTarget,pRequest,.pResponse)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// ITI-52
Method Unsubscribe(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "http://docs.oasis-open.org/wsn/bw-2/SubscriptionManager/UnsubscribeRequest", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Try {
		Set tSC = $$$OK
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRequest.Name = pRequest.Name
		Do tRequest.AdditionalInfo.SetAt(%request.Get("SUB"),"SubscriptionID")
		/// log inbound address for Auditing purposes
		Do:$isObject(..AddressingIn) tRequest.AdditionalInfo.SetAt(..AddressingIn.Destination,"Address")
		Do tRequest.AdditionalInfo.SetAt(%request.CgiEnvs("REMOTE_ADDR"), "WSA:From")
		If ..AddressingIn.SourceEndpoint.Address'="" Do tRequest.AdditionalInfo.SetAt(..AddressingIn.SourceEndpoint.Address, "WSA:From")
		If ..AddressingIn.Destination'="" Do tRequest.AdditionalInfo.SetAt(..AddressingIn.Destination, "WSA:To")
		Do ..SetAddressingOut($$$DSUBUnsubscribeResponseAction(1))
		Set tSC = ..SendRequestSync(..UnsubscribeTarget,tRequest,.pResponse)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// ITI-54
Method Notification(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %SOAP.OneWay [ ProcedureBlock = 1, SoapAction = "http://docs.oasis-open.org/wsn/bw-2/NotificationConsumer/Notify", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		If ..NotificationTarget]"" {
			Set tSC = ..SendRequestAsync(..NotificationTarget,pRequest)
		} Else {
			$$$LOGWARNING("No notification target set")
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
