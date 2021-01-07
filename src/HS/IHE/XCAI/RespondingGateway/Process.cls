Include HS.IHE.ATNA

Class HS.IHE.XCAI.RespondingGateway.Process Extends (Ens.BusinessProcess, HS.IHE.XCAI.Common) [ ClassType = persistent, Inheritance = right ]
{

Parameter SETTINGS = "RetrieveTarget:Basic";

Property RetrieveTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCAI.RespondingGateway.Operations" ];

Method OnRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		$$$ThrowOnError(..Initialize())
		
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		
		If $Case(pRequest.Name, $$$XDSIRetrieveRequest:1, $$$XCAIRetrieveRequest:1, :0) {
			Set tIsAsync = 0
			Set tReplyTo = pRequest.AdditionalInfo.GetAt("ReplyAddress")
			If tReplyTo]"" && (tReplyTo'["anonymous") {
				Set tIsAsync = 1
				Do ..Reply("")
			}
			
			Set tSC = ..XMLMessage(pRequest,.pResponse)
			Do $$$ATNAEvent($$$ATNAActorImagingRespondingGW, pRequest, pResponse, tSC)
			
			If tIsAsync {
				Set pResponse.SAMLData = pRequest.SAMLData.%ConstructClone()
				Set pResponse.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()
 				Do pResponse.AdditionalInfo.SetAt($$$XCAIRetrieveResponseAction(..#IHEVersion),  "SOAPAction")
 				Do pResponse.AdditionalInfo.RemoveAt("WSA:From")
 				Do pResponse.AdditionalInfo.RemoveAt("WSA:To")
				$$$ThrowOnError(..SendRequestAsync(..RetrieveTarget,pResponse))
			}
		}
		Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Request type not handled: " _ pRequest.Name))
		}			
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
		Do ..LogStatus(tSC)
	}
	Do ..LogEvents()
	Quit tSC
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

Method XMLMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage)
{
	Try {
		$$$ThrowOnError(..ConvertMessage(pRequest,.tRequest))
		$$$ThrowOnError(..RetrieveRequest(tRequest,.tResponse))
		$$$ThrowOnError(..ConvertMessage(tResponse,.pResponse))
	}
	Catch ex {
		Set tSC = ex.AsStatus()
		Do ..LogStatus(tSC)
		Do ..ErrorResponse($$$XCAIRetrieveResponse,tSC,.pResponse)
	}
	Quit $$$OK
}

Method RetrieveRequest(pRequest As HS.Message.IHE.XDSI.RetrieveRequest, Output pResponse As HS.Message.IHE.XDSI.RetrieveResponse) As %Status
{
	#; Fatal if unable to create a response object
	Set tSC = pRequest.NewResponse(.pResponse)
	Quit:$$$ISERR(tSC) tSC
	
	#; Otherwise response is always valid (though may just be failure with errors)
	Try {
		$$$ThrowOnError(..SplitRequests(pRequest, .tRequests, .tExpectedDocuments))
		$$$ThrowOnError(..BatchRequests(tRequests, ..RetrieveTarget, .tBatch))
		Quit:'$D(tBatch)
		$$$ThrowOnError(..SendRequestSyncMultiple(.tBatch, ..FailureTimeout))
		$$$ThrowOnError(..BatchResponses(.tBatch, .tResponses))
		$$$ThrowOnError(..CombineResponses(tResponses, .pResponse, .tExpectedDocuments))
	} 
	Catch ex {
		Set tSC = ex.AsStatus()
		Do ..LogStatus(tSC)
	}
	Do ..FinalizeResponse(pResponse)
	Quit $$$OK
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>RetrieveTarget</Value>
</Value>
<Value name="2">
<Value>HomeCommunity</Value>
</Value>
<Value name="3">
<Value>HomeCommunityOID</Value>
</Value>
<Value name="4">
<Value>Transformer</Value>
</Value>
<Value name="5">
<Value>Errors</Value>
</Value>
<Value name="6">
<Value>TraceOperations</Value>
</Value>
<Value name="7">
<Value>XCAIRetrieveRequestImportTransform</Value>
</Value>
<Value name="8">
<Value>XCAIRetrieveRequestExportTransform</Value>
</Value>
<Value name="9">
<Value>XCAIRetrieveResponseImportTransform</Value>
</Value>
<Value name="10">
<Value>XCAIRetrieveResponseExportTransform</Value>
</Value>
<Value name="11">
<Value>XDSIRetrieveRequestImportTransform</Value>
</Value>
<Value name="12">
<Value>XDSIRetrieveRequestExportTransform</Value>
</Value>
<Value name="13">
<Value>XDSIRetrieveResponseImportTransform</Value>
</Value>
<Value name="14">
<Value>XDSIRetrieveResponseExportTransform</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
