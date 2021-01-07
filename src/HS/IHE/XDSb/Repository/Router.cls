Include HS.IHE.XDSb

/// Splits document retrieve requests into separate requests based on repository OID, sends in batch, then combines the responses
Class HS.IHE.XDSb.Repository.Router Extends (Ens.BusinessProcess, HS.Util.XSLTTransformer)
{

Parameter SETTINGS = "RepositoryTarget,SplitTransform,CombineTransform,Timeout";

Property RepositoryTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Operations" ];

Property SplitTransform As %String [ InitialExpression = "IHE/XDSb/Version1/RetrieveRequestSplit.xsl" ];

Property CombineTransform As %String [ InitialExpression = "IHE/XDSb/Version1/RetrieveResponseCombine.xsl" ];

Property Timeout As %Integer [ InitialExpression = 60 ];

Method OnRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		#; Split into multiple requests based on OID
		Set tSC = ..TransformFromObject(pRequest, ..SplitTransform /*"IHE/XDSb/Version1/RetrieveRequestSplit.xsl"*/, .tRequests) $$$ThrowOnError(tSC)
		Set tReader = ##class(%XML.Reader).%New()
		Do tReader.Correlate("XMLMessage","HS.Message.XMLMessage")
		Set tSC = tReader.OpenStream(tRequests) $$$ThrowOnError(tSC)
		While tReader.Next(.tRequest, .tSC) { $$$ThrowOnError(tSC)
			Set tRq = ##class(Ens.CallStructure).%New()
			Set tRq.Request = tRequest
			Set tRequest.SAMLData=pRequest.SAMLData
			Set tRq.TargetDispatchName = ..RepositoryTarget
			Set tRequestList($i(tRequestList)) = tRq		
		}
		If '$D(tRequestList) {
			$$$LOGWARNING("No batch requests found for repository retrieve. Sending original request.")
			Set tSC = ..SendRequestSync(..RepositoryTarget, pRequest, .pResponse) $$$ThrowOnError(tSC)
			Quit
		}

		#; Ship out to the repositories in batch			
		#dim tResponse As HS.Message.XMLMessage
		Set tAttach = ##class(%ListOfObjects).%New()
		Set tErrors = ##class(HS.Types.IHE.Errors).%New()
		Set tResult = ##class(%Stream.GlobalCharacter).%New()
		Do tResult.WriteLine("<Result>")
		Set tStatus = ..SendRequestSyncMultiple(.tRequestList, ..Timeout)
		If $$$ISERR(tStatus) {
			Do tErrors.logError("XDSbRepository","Error","Internal repository error: "_$SYSTEM.Status.GetErrorText(tStatus))
		}
		Else {
			For i=1:1:tRequestList {
				Set tRq = tRequestList(i)
				Set tRequest = tRq.Request
				Set tResponse = tRq.Response
				Set tStatus = tRq.ResponseCode
				If $$$ISERR(tStatus) {
					Do tErrors.logError("XDSbRepository","Error",$SYSTEM.Status.GetErrorText(tStatus))
				} 
				ElseIf '$IsObject(tResponse) {
					Do tErrors.logError("XDSbRepository","Error","Response not returned")
				}
				Else {
					For j=1:1:tResponse.StreamCollection.Count() { Do tAttach.Insert(tResponse.StreamCollection.GetAt(j)) }
					Set tResponse.StreamCollection=""
					Set tStatus = tResponse.XMLExportToStream(tResult) 
					If $$$ISERR(tStatus) {
						Do tErrors.logError("XDSbRepository","Error",$SYSTEM.Status.GetErrorText(tStatus))
					}
				}
			}
		}
		Do tErrors.XMLExportToStream(tResult)
		Do tResult.WriteLine("</Result>")

		Set tSC = ..TransformIntoObject(tResult,..CombineTransform /*"IHE/XDSb/Version1/RetrieveResponseCombine.xsl"*/,.pResponse,.tParams,"HS.Message.XMLMessage","XMLMessage",1) $$$ThrowOnError(tSC)
		Set pResponse.StreamCollection = tAttach
		
	} Catch ex { 
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC) 
		Do ##class(HS.IHE.XDSb.Util).ErrorResponse(tSC, $$$XDSbRetrieveResponse, .pResponse, $this)
	}
	Quit $$$OK
}

Storage Default
{
<Data name="RouterDefaultData">
<Subscript>"Router"</Subscript>
<Value name="1">
<Value>RepositoryTarget</Value>
</Value>
<Value name="2">
<Value>SplitTransform</Value>
</Value>
<Value name="3">
<Value>CombineTransform</Value>
</Value>
<Value name="4">
<Value>Timeout</Value>
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
<Value>DoHSTrace</Value>
</Value>
<Value name="9">
<Value>ClearCallbackVariables</Value>
</Value>
<Value name="10">
<Value>TraceOperations</Value>
</Value>
<Value name="11">
<Value>XSLTCacheMode</Value>
</Value>
<Value name="12">
<Value>XSLTCallbackHandlerClass</Value>
</Value>
<Value name="13">
<Value>XSLTDirectory</Value>
</Value>
<Value name="14">
<Value>XSLTErrorHandlerClass</Value>
</Value>
<Value name="15">
<Value>XSLTSubDirectory</Value>
</Value>
<Value name="16">
<Value>UseXSLT2</Value>
</Value>
</Data>
<Data name="StyleSheets">
<Attribute>StyleSheets</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.IHE.XDSb.Repository.Router.StyleSheets"</Subscript>
</Data>
<DefaultData>RouterDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
