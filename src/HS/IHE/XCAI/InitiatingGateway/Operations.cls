Include (HS.IHE.XCAI, HS.IHE.ATNA)

Class HS.IHE.XCAI.InitiatingGateway.Operations Extends (HS.Util.SOAPClient.FileStreamOperations, HS.IHE.Common.Actor.Base, HS.IHE.XCAI.Common) [ Inheritance = right, ProcedureBlock ]
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
			Do pRequest.AdditionalInfo.SetAt($$$XDSIRetrieveAction(1),"SOAPAction")
			Set pResponse.Name  = $$$XDSIRetrieveResponse
			Set tSC = ##super(pRequest, .pResponse)
			Do $$$ATNAEvent($$$ATNAActorImagingConsumer, pRequest, pResponse, tSC)
		}
		ElseIf (pRequest.Name = $$$XCAIRetrieveRequest) {
			Do pRequest.AdditionalInfo.SetAt($$$XCAIRetrieveAction(1),"SOAPAction")
			Set pResponse.Name  = $$$XCAIRetrieveResponse
			Set tSC = ##super(pRequest, .pResponse)
			Do $$$ATNAEvent($$$ATNAActorImagingInitiatingGW, pRequest, pResponse, tSC)
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

Method RetrieveRequest(pRequest As HS.Message.IHE.XDSI.RetrieveRequest, Output pResponse As HS.Message.IHE.XDSI.RetrieveResponse) As %Status
{
	Set tSC = $$$OK
	Try {
		/// from Common get Transformer and initialize HomeCommunityOID
		$$$ThrowOnError(..Initialize())
		$$$ThrowOnError(..ConvertMessage(pRequest,.tRequest))
		$$$ThrowOnError(..OnMessage(tRequest,.tResponse))
		$$$ThrowOnError(..ConvertMessage(tResponse,.pResponse))
		$$$ThrowOnError(pResponse.MoveInlineDocuments())
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
