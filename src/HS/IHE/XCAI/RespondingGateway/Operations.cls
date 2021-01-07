Include (HS.IHE.XCAI, HS.IHE.ATNA)

Class HS.IHE.XCAI.RespondingGateway.Operations Extends (HS.Util.SOAPClient.FileStreamOperations, HS.IHE.Common.Actor.Base, HS.IHE.XCAI.Common) [ Inheritance = right, ProcedureBlock ]
{

Parameter SETTINGS = "-ServiceName";

Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.IHE.XDSI.RetrieveRequest"> 
		<Method>RetrieveRequest</Method>
	</MapItem>
</MapItems>
}

Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If (pRequest.Name = $$$XDSIRetrieveRequest) {
			Do pRequest.AdditionalInfo.SetAt($$$XDSIRetrieveAction(..#IHEVersion),"SOAPAction")
			Set pResponse.Name  = $$$XDSIRetrieveResponse
			Set tSC = ##super(pRequest, .pResponse)
			Do $$$ATNAEvent($$$ATNAActorImagingConsumer, pRequest, pResponse, tSC)
		}
		ElseIf (pRequest.Name = $$$XCAIRetrieveRequest) {
			Do pRequest.AdditionalInfo.SetAt($$$XCAIRetrieveAction(..#IHEVersion),"SOAPAction")
			Set pResponse.Name  = $$$XCAIRetrieveResponse
			Set tSC = ##super(pRequest, .pResponse)
			#; No ATNA - the passthrough RG will handle the audit
		}
		ElseIf (pRequest.Name = $$$XCAIRetrieveResponse) {
			Do pRequest.AdditionalInfo.SetAt($$$XCAIRetrieveResponseAction(..#IHEVersion),"SOAPAction")
			Do pRequest.AdditionalInfo.SetAt(1, "OneWay")
			Set tSC = ##super(pRequest, .pResponse)
			#; No ATNA - RG process already handled it
		}
		Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name))
		}
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// override to force MTOM on async response, and to purge temp files
Method InvokeWebService(pWebRequest As %SOAP.WebRequest = "", pWebServiceURL As %String(MAXLEN=256) = "", pSOAPAction As %String = "", pRequest As HS.Message.XMLMessage, pResponseBody As HS.Message.XMLMessage = "", pOneWay As %Boolean = 0) As %Status
{
	If pSOAPAction = $$$XCAIRetrieveResponseAction(..#IHEVersion) {
		If '$isObject(pWebRequest) Set pWebRequest = ##class(%SOAP.WebRequest).%New()
		Set pWebRequest.MTOMRequired = 1
	}
	Set tSC = ##super(.pWebRequest, pWebServiceURL, pSOAPAction, pRequest, .pResponseBody, pOneWay)

	Try {
		#dim tAttach As HS.IHE.Common.Messages.MIMEAttachment
		Set tIdx="" 
		For { 
			Set tAttach = pRequest.StreamCollection.GetNext(.tIdx) Quit:tIdx=""
			If tAttach.FilePath'="" {
				Set tSCDelete = ##class(%File).Delete(tAttach.FilePath)
			}
		}
	}
	Catch ex {}

	Quit tSC
}

Method RetrieveRequest(pRequest As HS.Message.IHE.XDSI.RetrieveRequest, Output pResponse As HS.Message.IHE.XDSI.RetrieveResponse) As %Status
{
	Set tSC = $$$OK
	Try {
		$$$ThrowOnError(..Initialize())		
		$$$ThrowOnError(..ConvertMessage(pRequest,.tRequest))
		$$$ThrowOnError(..OnMessage(tRequest,.tResponse))
		$$$HSTRACE("About to convert","tResponse",tResponse)
		$$$ThrowOnError(..ConvertMessage(tResponse,.pResponse))
		$$$ThrowOnError(pResponse.MoveInlineDocuments())
	}
	Catch ex {
		Set tSC = ex.AsStatus()
		$$$HSTRACE("error converting"_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

}
