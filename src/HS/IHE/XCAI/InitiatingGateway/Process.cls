Class HS.IHE.XCAI.InitiatingGateway.Process Extends (Ens.BusinessProcess, HS.IHE.XCAI.Common) [ ClassType = persistent, Inheritance = right ]
{

Parameter SETTINGS = "RetrieveTarget:Basic";

Property RetrieveTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCAI.InitiatingGateway.Operations" ];

Method OnRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		$$$ThrowOnError(..Initialize())

		Set pResponse=##class(HS.Message.XMLMessage).%New()

		If pRequest.%IsA("HS.Message.IHE.XDSI.RetrieveRequest") {
			$$$ThrowOnError(..RetrieveRequest(pRequest,.pResponse))
		} 
		ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			If $Case(pRequest.Name, $$$XDSIRetrieveRequest:1, $$$XCAIRetrieveRequest:1, :0) {
				$$$ThrowOnError(..XMLMessage(pRequest,.pResponse))
			}
			Else {
				$$$ThrowStatus($$$ERROR($$$GeneralError, "Request type not handled: " _ pRequest.Name))
			}			
		}
		Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Message class "_pRequest.%ClassName(1)_" not handled"))
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
		Do ..ErrorResponse($$$XDSIRetrieveResponse,tSC,.pResponse)
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
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>XDSbQueryServiceName</Value>
</Value>
<Value name="3">
<Value>XCPDInitiatingGatewayProcess</Value>
</Value>
<Value name="4">
<Value>XCAInitiatingGatewayServiceNames</Value>
</Value>
<Value name="5">
<Value>XCAInitiatingGatewayOperations</Value>
</Value>
<Value name="6">
<Value>Publisher</Value>
</Value>
<Value name="7">
<Value>XCARequestTransform</Value>
</Value>
<Value name="8">
<Value>XCAConsolidateQueryTransform</Value>
</Value>
<Value name="9">
<Value>XCAConsolidateRetrieveTransform</Value>
</Value>
<Value name="10">
<Value>XCAReplacePatientIdTransform</Value>
</Value>
<Value name="11">
<Value>MetadataTransform</Value>
</Value>
<Value name="12">
<Value>XCAIRetrieveTarget</Value>
</Value>
<Value name="13">
<Value>Errors</Value>
</Value>
<Value name="14">
<Value>HomeCommunity</Value>
</Value>
<Value name="15">
<Value>HomeCommunityOID</Value>
</Value>
<Value name="16">
<Value>Transformer</Value>
</Value>
<Value name="17">
<Value>RetrieveTarget</Value>
</Value>
<Value name="18">
<Value>XCAIRetrieveRequestImportTransform</Value>
</Value>
<Value name="19">
<Value>XCAIRetrieveRequestExportTransform</Value>
</Value>
<Value name="20">
<Value>XCAIRetrieveResponseImportTransform</Value>
</Value>
<Value name="21">
<Value>XCAIRetrieveResponseExportTransform</Value>
</Value>
<Value name="22">
<Value>XDSIRetrieveRequestImportTransform</Value>
</Value>
<Value name="23">
<Value>XDSIRetrieveRequestExportTransform</Value>
</Value>
<Value name="24">
<Value>XDSIRetrieveResponseImportTransform</Value>
</Value>
<Value name="25">
<Value>XDSIRetrieveResponseExportTransform</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
