Include HS.IHE.DSUB

/// Accept publish notification
Class HS.IHE.DSUB.NotificationConsumer.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.IHE.Common.Actor.Base) [ Inheritance = right ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:ihe:iti:2007";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "NotificationConsumer_Service";

Parameter SETTINGS = "NotificationTarget";

Property NotificationTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.DSUB.NotificationConsumer.Process" ];

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	Set tSC = $$$OK
	
	Try {
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		
		If (tAction = $$$DSUBNotficationRequestAction(1)) {
			Set pRequest.Name = $$$DSUBNotficationRequest
			Set tSC = ..Notification(pRequest, .pResponse)
			#; validate after call so that session has been assigned
			Do ..ValidateMessage(pRequest,tAction,"Request")
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
			Set pResponse=""
		}
		Else {
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

/// Notification ITI-53
Method Notification(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "http://docs.oasis-open.org/wsn/bw-2/NotificationConsumer/Notify", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$DSUBNotficationResponse
		Set ..OneWay=1
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
