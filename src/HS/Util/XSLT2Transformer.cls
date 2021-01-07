Class HS.Util.XSLT2Transformer Extends %RegisteredObject
{

/// Map of XSL locations to compiled stylesheets
Property StyleSheets As array Of %XML.XSLT2.CompiledStyleSheet;

/// XSLT gateway object used for XSLT2
Property XSLTGateway As %Net.Remote.Gateway;

/// Boolean for whether evaluate cache filter list is configured (1 = Configured 0 = Not Configured)
Property EvaluateCacheFilterListConfigured As %Boolean [ InitialExpression = 0, Private, Transient ];

Method CreateStyleSheetFromStream(pStream, ByRef pXSL As %XML.XSLT2.CompiledStyleSheet) As %Status
{
	return ##class(%XML.XSLT2.CompiledStyleSheet).CreateFromStream(pStream,.pXSL,,..XSLTGateway)
}

Method CreateStyleSheetFromFile(pFile, ByRef pXSL As %XML.XSLT2.CompiledStyleSheet) As %Status
{
	return ##class(%XML.XSLT2.CompiledStyleSheet).CreateFromFile(pFile,.pXSL,,..XSLTGateway)
}

/// Transform a string or stream
Method Transform(pInput = "", tXSL As %String = "", ByRef pOutput, ByRef tParams = "", pDisableCache As %Boolean = 0, pCallbackHandler, pErrorHandler) As %Status
{
	Set tSC = $$$OK
	
	Try {
	 	// Clear evaluate cache in gateway each time before transform as we do not want to cache "data".
	 	Set tSC = ##class(%XML.XSLT2.Transformer).ClearEvaluateCache(,..XSLTGateway) Quit:$$$ISERR(tSC)

		// Configure Java cache
		if ($g(pDisableCache)) {
			Set tSC = ##class(%XML.XSLT2.Transformer).ClearEvaluateCacheFilterList(, ..XSLTGateway) Quit:$$$ISERR(tSC)			
			Set tSC = ##class(%XML.XSLT2.Transformer).SetCacheEverythingBoolean(0, ,..XSLTGateway) Quit:$$$ISERR(tSC)		
			Set ..EvaluateCacheFilterListConfigured = 0
		} else {
			if ..EvaluateCacheFilterListConfigured = 0 {
				Set tWhitelist = $lb("getOIDForCode", "getCodeForOID", "piece", "getDescriptionForOID", "dateDiff")
				for i=1:1:$LISTLENGTH(tWhitelist) {
					Set tSC = ##class(%XML.XSLT2.Transformer).AddToEvaluateCacheFilterList($LIST(tWhitelist, i), ,..XSLTGateway) Quit:$$$ISERR(tSC)
				}			
				Set ..EvaluateCacheFilterListConfigured = 1
			}
		}
		
		// Do transform
		If $IsObject(pInput) {
			// Transform a stream
			Do pInput.Rewind()
			Set tSC = ##class(%XML.XSLT2.Transformer).TransformStreamWithCompiledXSL(pInput,tXSL,.pOutput,pErrorHandler,.tParams,pCallbackHandler, ,..XSLTGateway)
		} Else {
			// Transform a string
			Set tSC = ##class(%XML.XSLT2.Transformer).TransformStringWithCompiledXSL(pInput,tXSL,.pOutput,pErrorHandler,.tParams,pCallbackHandler, ,..XSLTGateway)
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Transform a file
Method TransformFile(pInput = "", tXSL As %String = "", pOutput As %String = "", ByRef tParams = "", pDisableCache As %Boolean, pCallbackHandler, pErrorHandler) As %Status
{
	Set tSC = $$$OK
	
	Try {
	 	// Clear evaluate cache in gateway each time before transform as we do not want to cache "data".
	 	Set tSC = ##class(%XML.XSLT2.Transformer).ClearEvaluateCache(,..XSLTGateway) Quit:$$$ISERR(tSC)

		// Configure Java cache
		if ($g(pDisableCache)) {
			Set tSC = ##class(%XML.XSLT2.Transformer).ClearEvaluateCacheFilterList(, ..XSLTGateway) Quit:$$$ISERR(tSC)			
			Set tSC = ##class(%XML.XSLT2.Transformer).SetCacheEverythingBoolean(0, ,..XSLTGateway) Quit:$$$ISERR(tSC)		
			Set ..EvaluateCacheFilterListConfigured = 0
		} else {
			if ..EvaluateCacheFilterListConfigured = 0 {
				Set tWhitelist = $lb("getOIDForCode", "getCodeForOID", "piece", "getDescriptionForOID", "dateDiff")
				for i=1:1:$LISTLENGTH(tWhitelist) {
					Set tSC = ##class(%XML.XSLT2.Transformer).AddToEvaluateCacheFilterList($LIST(tWhitelist, i), ,..XSLTGateway) Quit:$$$ISERR(tSC)
				}			
				Set ..EvaluateCacheFilterListConfigured = 1
			}
		}
		
		// Do transform
		Set tSC = ##class(%XML.XSLT2.Transformer).TransformFileWithCompiledXSL(pInput,tXSL,pOutput,pErrorHandler,.tParams,pCallbackHandler, ,..XSLTGateway)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
/// <p>It is passed the arguments provided in the %New call.
/// When customizing this method, override the arguments with whatever variables and types you expect to receive from %New().
/// For example, if you're going to call %New, passing 2 arguments, %OnNew's signature could be:
/// <p>Method %OnNew(dob as %Date = "", name as %Name = "") as %Status
/// If instead of returning a %Status code this returns an oref and this oref is a subclass of the current
/// class then this oref will be the one returned to the caller of %New method.
Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	Set tSC = $$$OK
	
	Try {
	 	// Start XSLT gatway
	 	Set tSC = ##class(%XML.XSLT2.Transformer).StartGateway(.tGateway) Quit:$$$ISERR(tSC)
	 	
	 	Set ..XSLTGateway = tGateway
	 	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}			

 	Quit tSC
}

Method %OnClose() As %Status [ Private ]
{
 	Set tSC = $$$OK
	
	Try {
		// Stop XSLT gateway
	 	Set tSC = ##class(%XML.XSLT2.Transformer).StopGateway(..XSLTGateway) Quit:$$$ISERR(tSC) 	

	} Catch eException {
		Set tSC = eException.AsStatus()
	}			

 	Quit tSC
}

}
