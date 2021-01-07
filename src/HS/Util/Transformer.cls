Include %callout

/// Deprecated - please use HS.Util.XSLTTransformer instead
/// We won't remove this, because it is in extensive use
/// It's OK to use for files, but not for style sheets in XDATA blocks.
/// Utility class for XSLT transformations
Class HS.Util.Transformer Extends EnsLib.XSLT.Common
{

/// subdirectory under xslt treed structure allowed using sub/sub/sub
Property XSLTSubDir As %String [ Private ];

/// file specification to be used such as *.xsl
Property XSLTSpec As %String [ Private ];

/// use XSLTClass makes it possible to use classes with XData blocks
Property XSLTClass As %String [ Private ];

Method OnInit() As %Status
{
	#dim tDir As %String
	#dim tSubDir As %String
	#dim tRS as %ResultSet
	#dim tSC as %Status

	Set:..CallbackHandlerClass="" ..CallbackHandlerClass = "HS.Util.XSLTHelper"
	Set tSC=$$$OK
	/// Now using classes for compiled stylesheets
	If ..XSLTClass]"" {
		Set ..RuntimeMode="P"  // for now, there is no checking of the compiled timestamp
		Set tRS=##class(%ResultSet).%New("%Dictionary.CompiledXData:Summary")
		Set tSC=tRS.Execute(..XSLTClass)
		While tRS.Next() {
			Set tSheet=tRS.GetData(1)
			Set tXDATA=##class(%Dictionary.CompiledXData).%OpenId(..XSLTClass_"||"_tSheet)
			If '$isObject(tXDATA) Continue
			Set tSC = ##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(tXDATA.Data,.tCSS)
			Quit:$$$ISERR(tSC)
			Set tSheet=$zcvt(tSheet,"U")
			Do ..CompiledStyleSheets.SetAt(tCSS,tSheet)
			Do ..CompiledStyleSheetsInfo.SetAt("",tSheet)
		}		
		Quit:$$$ISERR(tSC)
		#; these would be processed in the ensemble class
		
		// Grab any parameters
		Do ..getParameters(..Parameters,.tParams)
		Merge ..Params = tParams

		// Finally, instantiate the callback handler (if supplied)
		If ..CallbackHandlerClass'="" {
			Set ..CallbackHandler = $ZOBJCLASSMETHOD(..CallbackHandlerClass,"%New")
		}
		Quit $$$OK
	}	
	If $$$ISERR(tSC) Quit tSC
	// Configure the XSLT transformer
	Set tDir = ##class(HS.Util.XSLTTransformer).GetXSLTDirectory()

	For tIdx = 1:1:$l(..XSLTSubDir,"/") {
		Set tSubDir=$p(..XSLTSubDir,"/",tIdx)
		If tSubDir]"" Set tDir = ##class(%File).SubDirectoryName(tDir, tSubDir)
	}

	Set ..StylesheetDir = tDir
	Set ..StylesheetDirFileSpec = ..XSLTSpec
				
	// Let the base class initialize
	Set tSC= ##super()
	If $$$ISERR(tSC) Quit tSC
	Set tUserDirectory = ##class(%File).SubDirectoryName(tDir, "Custom")
	Set tSC=..LoadDirectory(tUserDirectory,..XSLTSpec)
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
Method %OnNew(pSubDir As %String = "", pSpec As %String = "", pClass As %String = "") As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..XSLTSubDir = pSubDir
	Set ..XSLTSpec = pSpec
	Set ..XSLTClass = pClass
	Quit $$$OK
}

/// Additional directories to be loaded after the OnInit
Method LoadDirectory(pDirectory As %String = "", pFilespec As %String = "") As %Status
{
	Set tSC=$$$OK	
	If pDirectory '= "" && ##class(%File).DirectoryExists(pDirectory) {
		Set tRS = ##class(%ResultSet).%New("%File:FileSet")
		Do tRS.Execute(pDirectory,pFilespec,"",0)
		While (tRS.Next()) {
			// Loop over the files in the directory and load them
			Set tFN = tRS.GetData(1)
			Set tSC = ..loadStylesheet(tFN)
	
			If $$$ISERR(tSC) {
				$$$LOGWARNING("Unable to load "_tFN_": "_$system.Status.GetErrorText(tSC))
			}
		}
	}
	Quit tSC
}

ClassMethod LoadAndTransform(pStreamInput As %Stream.TmpCharacter, Output pOutputStream As %Stream.TmpCharacter, Output pTransformer As HS.Util.Transformer, pDirectory As %String, pSpec As %String, pFile As %String = "", ByRef pParameters) As %Status
{
	If pFile="" Set pFile=$p(pSpec,".")
	Set pTransformer = ##class(HS.Util.Transformer).%New(pDirectory,pSpec)
	Do pTransformer.OnInit()
	Set tSC = pTransformer.Transform(pStreamInput,pFile,.pParameters, .pOutputStream)
	Quit tSC
}

/// when using a URL could be file:///usr/bin/somefile.xsl
/// or even http://...
/// In OnInit... Do ##class(HS.Util.Transformer).LoadURL(pURL,.tTransformer)
/// when you want to transform Do tTransformer.Transform(pInput,pURL,.pParameters,.tOutput)
/// XDATA is not supported.
ClassMethod LoadURL(pURL As %String, ByRef pTransformer As HS.Util.Transformer) As %Status
{
	try {
		Set tSC=$$$OK
		Set pTransformer=..%New()
		Set pTransformer.CallbackHandler = ##class(HS.Util.XSLTHelper).%New()
		Set tSC=pTransformer.LoadURLInstance(pURL)
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

/// Called by the LoadURL method, the instance method allows calling some inherited private methods
Method LoadURLInstance(pURL As %String) As %Status
{
	try {
		Set tSC=$$$OK
		Do ##Class(%Net.URLParser).Parse(pURL,.components)
		Set tScheme=$ZConvert($Get(components("scheme")),"L")
		Set pName=$zcvt(pURL,"U")
		if tScheme="file" {
			Set tFname=$E(pURL,9,$L(pURL)) // skip "file:///"
			#; Check for file existence
			If '##Class(%File).Exists(tFname) {
				Set tSC=$$$ERROR($$$FileDoesNotExist,tFname) Quit
			}
			Set tSC = ..loadStylesheet(tFname,pName)
		} Else {
			Set tSC = ##class(Ens.Util.URLStream).GetURLStream(pURL, .tXSL) Quit:$$$ISERR(tSC)
			Set tSC = ##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(tXSL, .tSheet) Quit:$$$ISERR(tSC)
			Do ..CompiledStyleSheets.SetAt(pName,tSheet)
			Do ..CompiledStyleSheetsInfo.SetAt("",tSheet)
		}
		
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

}
