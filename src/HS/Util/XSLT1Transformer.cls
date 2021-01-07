Class HS.Util.XSLT1Transformer Extends %RegisteredObject
{

/// Map of XSL locations to compiled stylesheets
Property StyleSheets As array Of %XML.XSLT.CompiledStyleSheet;

ClassMethod CreateStyleSheetFromStream(pStream, ByRef pXSL As %XML.XSLT.CompiledStyleSheet) As %Status
{
	return ##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(pStream,.pXSL)
}

ClassMethod CreateStyleSheetFromFile(pFile, ByRef pXSL As %XML.XSLT.CompiledStyleSheet) As %Status
{
	return ##class(%XML.XSLT.CompiledStyleSheet).CreateFromFile(pFile,.pXSL)
}

/// Transform a string or stream
Method Transform(pInput = "", tXSL, ByRef pOutput, ByRef tParams, CallbackHandler, ErrorHandler) As %Status
{
	If $IsObject(pInput) {
		Do pInput.Rewind()
		Set tSC=##class(%XML.XSLT.Transformer).TransformStreamWithCompiledXSL(pInput,tXSL,.pOutput, ErrorHandler,.tParams, CallbackHandler)
	} Else {
		Set tSC=##class(%XML.XSLT.Transformer).TransformStringWithCompiledXSL(pInput,tXSL,.pOutput, ErrorHandler,.tParams, CallbackHandler)
	}
		
	Quit tSC
}

/// Transform a file
Method TransformFile(pInput = "", tXSL, pOutput As %String = "", ByRef tParams, CallbackHandler, ErrorHandler) As %Status
{
	Set tSC=##class(%XML.XSLT.Transformer).TransformFileWithCompiledXSL(pInput,tXSL,pOutput, ErrorHandler,.tParams, CallbackHandler)
		
	Quit tSC
}

}
