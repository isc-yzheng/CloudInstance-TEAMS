Include HS.FHIRServer

/// Utility class to facilitate bulk loading of FHIR resources to a specified FHIR server.
Class HS.FHIRServer.Tools.DataLoader Extends %RegisteredObject
{

/// FHIRServer service object, buffered as a property to avoid instantiating upon every request.
Property FHIRService As HS.FHIRServer.Service [ Private ];

/// Service Registry entry object, buffered as a property to avoid instantiating upon every request.
Property HttpService As HS.Registry.Service.HTTP [ Private ];

/// HTTP request object, buffered as a property to avoid instantiating on every request.
/// Is Reset before each HTTP request.
Property HttpRequest As %Net.HttpRequest [ Private ];

/// API Method<br>
/// @API.Method<br>
/// Submit FHIR content files from a specified operating system directory to a FHIR server. Each file
/// may contain an individual resource or a Bundle of resources. The files in the specified directory
/// can be a mix of files with an individual resource and files with a Bundle of resources. The files
/// in the specified directory may be all JSON files or all XML files, or a mix of JSON and XML files.<br>
/// <br>
/// Input:<br>
/// - pInputDirectory  : (required) Operating system directory location of the source input files.<br>
/// - pServiceType     : (required) "FHIRServer" = FHIRServer Service endpoint, or "HTTP" = Service
///                      Registry HTTP service.<br>
/// - pServiceName     : (required) Name of FHIRServer Service or Service Registry HTTP service to
///                      which to send data.<br>
/// - pDisplayProgress : 1 (default) = Display progress messages and errors. 0 = Do not display.<br>
/// - pLogGlobal       : Name of global to which to log statistics. If not specified, then no logging
///                      is done. The recorded elapsed time is that time spent while being processed
///                      in the relevant FHIR server infrastructure. It does not include time spent
///                      by this method in examining and re-formatting of resources or in the
///                      construction of request messages.<br>
/// - pFileLimit       : Limit processing to the first pFileLimit files in pInputDirectory. If pFileLimit is
///                      not specified, then all files are processed.<br>
/// <br>
/// Output - if pLogGlobal is specified:<br>
/// - @pLogGlobal@("FilesTotal") = Number of files processed.<br>
/// - @pLogGlobal@("ResourcesTotal") = Total number of resources within the processed files.<br>
/// - @pLogGlobal@("ElapsedTotal") = Total elapsed time between each processing request and response.<br>
/// - @pLogGlobal@("ElapsedAvgPerFile") = Average elapsed time per file.<br>
/// - @pLogGlobal@("ElapsedAvgPerResource") = Average elapsed time per resource.
ClassMethod SubmitResourceFiles(pInputDirectory As %String, pServiceType As %String, pServiceName As %String, pDisplayProgress As %Boolean = 1, pLogGlobal As %String = "", pFileLimit As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		Kill %objlasterror
		
		Set tObj = ..%New($Get(pServiceType), $Get(pServiceName))
		
		If $IsObject($Get(tObj)) {
			Do tObj.SubmitResourceFilesHelper(pInputDirectory, pDisplayProgress, pLogGlobal, pFileLimit)
		} Else {
			If ($Get(%objlasterror)'="")&&($$$ISERR(%objlasterror)) {
				$$$ThrowOnError(%objlasterror)
			} Else {
				$$$ThrowStatus($$$HSFHIRErrDataLoaderObjectNotCreated)
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Input:<br>
/// - pServiceType : (required) "FHIRServer" = FHIRServer Service endpoint, or "HTTP" = Service
///                  Registry HTTP service.<br>
/// - pServiceName : (required) Name of FHIRServer Service or Service Registry HTTP service to
///                  which to send data.<br>
Method %OnNew(pServiceType As %String, pServiceName As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pServiceType)="" {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrServiceTypeNotSpecified))
		}
		
		If '(($ZConvert(pServiceType, "U")="FHIRSERVER")||($ZConvert(pServiceType, "U")="HTTP")) {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidServiceTypeSpecified, pServiceType))
		}
		
		If $Get(pServiceName)="" {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrServiceNameNotSpecified))
		}
		
		Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId($Namespace)
		If '$IsObject($Get(tConfigItem)) {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidNamespace, $Namespace))
		}
		
		If $ZConvert(pServiceType, "U")="FHIRSERVER" {
			Set ..FHIRService = ##class(HS.FHIRServer.Service).EnsureInstance(pServiceName)
			// EnsureInstance will Throw upon fail, but checking here anyway.
			If '$IsObject(..FHIRService) {
				$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidFHIRServiceSpecified, pServiceName))
			}
		} Else {
			Set ..HttpService = ##class(HS.Registry.Service.Abstract).EndPointForNameType(pServiceName, "HTTP")
			If '$IsObject(..HttpService) {
				$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidHTTPServiceSpecified, pServiceName))
			}
		}

		Set tSC = ..%ValidateObject()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method SubmitResourceFilesHelper(pInputDirectory As %String, pDisplayProgress As %Boolean = 1, pLogGlobal As %String = "", pFileLimit As %String = "")
{
	Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId($Namespace)
	If '$IsObject($Get(tConfigItem)) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidNamespace, $Namespace))
	}
	
	If (pLogGlobal'="")&&($Extract(pLogGlobal)'="^") {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidGlobalNameSpecified))
	}
	
	If pLogGlobal'="" Kill @pLogGlobal
	
	If $Get(pInputDirectory)="" {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrDirectoryNotSpecified))
	}
	If '##class(%Library.File).DirectoryExists(pInputDirectory) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrDirectoryNotFound))
	}
	
	If (pFileLimit'="")&&((pFileLimit'?1N.N)||(+pFileLimit'>0)) {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidFileLimitSpecified))
	}		
	
	Set tSC = ..GetFiles(pInputDirectory, .tFiles)
	$$$ThrowOnError(tSC)
	
	If +$Get(tFiles)=0 {
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrNoFilesFound))
	}
	
	If pDisplayProgress Do ..WriteOutput("")
	
	Set tTotalTime = 0
	Set tResourceCount = 0
	Set tFileCount = 0
	
	// Prevent malformed or non-JSON non-XML files from halting the entire bulk load.
	Set tBypassErrors = 0
	Set tBypassErrors($i(tBypassErrors)) = "Format not detected"
	Set tBypassErrors($i(tBypassErrors)) = "Premature end of data"
	Set tBypassErrors($i(tBypassErrors)) = "Parsing error"
	Set tBypassErrors($i(tBypassErrors)) = "SAX XML Parser Error"
	
	For tFileIndex = 1:1:tFiles {
		If (pFileLimit'="")&&(tFileIndex>pFileLimit) Quit
		
		Kill tFileStream
		
		Set tFileStream = ##class(%Stream.FileCharacter).%New()
		Set tSC = tFileStream.LinkToFile(tFiles(tFileIndex, "PathAndName"))
		$$$ThrowOnError(tSC)
		
		// Try to infer content format from file extension.
		Set tFileExt = $ZConvert($Piece(tFiles(tFileIndex, "PathAndName"),".",*), "U")
		If tFileExt=$$$FHIRContentCodeJSON {
			Set tFormat = $$$FHIRContentCodeJSON
		} ElseIf tFileExt=$$$FHIRContentCodeXML {
			Set tFormat = $$$FHIRContentCodeXML
		} Else {
			Set tFormat = ""
		}
		
		Set tSC = ..SubmitResourceStream(tFileStream, tFormat, .tSentStreamSize, .tEntryCount, .tElapsed)
		If $$$ISERR(tSC) {
			// Prevent malformed or non-JSON non-XML files from halting the entire bulk load.
			Set tByPass = 0
			Set tText = $system.Status.GetOneErrorText(tSC)
			For tBypassIndex = 1:1:tBypassErrors {
				If tText[tBypassErrors(tBypassIndex) {
					Set tByPass = 1
					Do ..WriteOutput(..GetFileErrorDisplayString(tFileIndex, tFiles(tFileIndex, "Name"), tText))
					Quit
				}
			}
			If tByPass Continue
		}
		$$$ThrowOnError(tSC)
		
		Set tTotalTime = tTotalTime + tElapsed
		
		If $i(tFileCount)
		
		Set tResourceCount = tResourceCount + tEntryCount
		
		If pDisplayProgress {
			Do ..WriteOutput(..GetStatsDisplayString(tFileIndex, tFiles(tFileIndex, "Name"), tSentStreamSize, tEntryCount, tElapsed))
		}
		
		If pLogGlobal'="" {
			Set @pLogGlobal@("ElapsedTotal") = tTotalTime
			Set @pLogGlobal@("FilesTotal") = tFileCount
			Set @pLogGlobal@("ResourcesTotal") = tResourceCount
			Set @pLogGlobal@("ElapsedAvgPerFile") = (tTotalTime/tFileCount)
			Set @pLogGlobal@("ElapsedAvgPerResource") = (tTotalTime/tResourceCount)
		}
	}
	
	If pDisplayProgress {
		Do ..WriteOutput("")
		If $$$ISERR(tSC) {
			Do ..WriteOutput($system.Status.GetOneErrorText(tSC))
		} Else {
			Do ..WriteOutput("Completed successfully.")
		}
	}
	
	Quit
}

/// API Method<br>
/// @API.Method<br>
/// Submit an individual FHIR stream to a FHIRService or to an HTTP Service.<br>
/// <br>
/// This method returns statistics regarding number of resources processed, plus elapsed time.
/// Please note that the elapsed time statistic is the accumulation of the timing starting from
/// the submission of each FHIR payload to the return of each FHIR payload.<br>
/// <br>
/// Input:<br>
/// - pResourceStream : (required) Stream object containing FHIR content.
/// - pFormatCode     : FHIR data format - "JSON" or "XML". If not provided, then this method derives
///                     the format by examining the input stream.<br>
/// <br>
/// Output:<br>
/// - pSentStreamSize : Size, in bytes, of the FHIR stream that was actually sent.<br>
/// - pEntryCount     : Number of resources in pResourceStream.<br>
/// - pElapsed        : Elapsed processing time for the resources within pResourceStream.
///                     When sending directly to FHIRServer Service, elapsed time is that time spent
///                     while being processed in the relevant FHIRServer infrastructure. When sending
///                     via HTTP, elapsed time is the time between the invocation of the HTTP request
///                     and the return of the response over the wire.
Method SubmitResourceStream(pResourceStream As %Stream.Object, pFormatCode As %String = "", Output pSentStreamSize As %Integer, Output pEntryCount As %Integer, Output pElapsed As %Decimal) As %Status
{
	Set tSC = $$$OK
	
	Set pSentStreamSize = 0
	Set pEntryCount = 0
	Set pElapsed = 0
	
	Try {
		// Input content be a non-empty stream.
		If ('$IsObject($Get(pResourceStream))) || ('pResourceStream.%IsA("%Stream.Object")) {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrStreamRequired, "pResourceStream"))
		} ElseIf 'pResourceStream.Size {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrEmptyStreamSpecified))
		}
		
		// Get the format of the FHIR resource stream contents.
		Set tFormatU = $ZConvert(pFormatCode, "U")
		If (tFormatU=$$$FHIRContentCodeJSON)||(tFormatU=$$$FHIRContentCodeXML) {
			Set tStreamContentFormat = tFormatU
		} ElseIf pFormatCode'="" {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidContentCode, pFormatCode))
		} Else {
			Set tSC = ##class(HS.HC.Util).GetFormatFromData(pResourceStream, .tStreamContentFormat)
			$$$ThrowOnError(tSC)
			Set tStreamContentFormat = $ZConvert(tStreamContentFormat, "U")
		}
		
		Do pResourceStream.Rewind()
		
		// Get some metadata and an unformatted version of the resource stream.
		Do ..GatherInfoFromStream(pResourceStream, tStreamContentFormat, .tQuickStream, .tDynObj, .tXMLDocument, .tResourceType, .tResourceId, .pEntryCount, .tDynObjElapsed)
		
		Set pSentStreamSize = tQuickStream.Size
		
		// Formulate the FHIR request message(s) and send.
		If $IsObject(..FHIRService) {
			Do ..BuildAndSubmitToFHIRService(tResourceType, tResourceId, tStreamContentFormat, tQuickStream, $Get(tDynObj), $Get(tDynObjElapsed), .pElapsed)
		} Else {
			Do ..BuildAndSubmitToHTTPService(tResourceType, tResourceId, tStreamContentFormat, tQuickStream, .pElapsed)
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Derive and return the resource type and resource count from the specified resource
/// stream. Also remove the resource id from an individual-resource stream. Return the
/// QuickStream as an unformatted version of the input stream. For JSON streams, return
/// return the %DynamicObject to reduce the time spent by this utility (i.e., don't
/// incur another %FromJSON for the same stream), and return the time spent making the
/// %DynamicObject so that it gets included in the elapsed for testing JSON streams
/// going directly to FHIRService.
ClassMethod GatherInfoFromStream(pResourceStream As %Stream.Object, pStreamFHIRFormat As %String, ByRef pQuickStream As HS.SDA3.QuickStream, ByRef pDynObj As %Library.DynamicObject, ByRef pXMLDocument As %XML.Document, ByRef pResourceType As %String, ByRef pResourceId As %String, ByRef pEntryCount As %Integer, ByRef pDynObjElapsed As %Decimal) [ Internal ]
{
	Set pResourceType = ""
	Set pResourceId = ""
	Set pEntryCount = 0
	Set pDynObjElapsed = 0
	
	Set pQuickStream = ##class(HS.SDA3.QuickStream).%New()
	
	// Derive and return the resource type, entry count and stream to send.
	// Remove resource id, if one is found.
	
	If pStreamFHIRFormat=$$$FHIRContentCodeJSON {
		Set tStart = $ZH
		Set pDynObj = ##class(%Library.DynamicObject).%FromJSON(pResourceStream)
		Do pResourceStream.Rewind()
		Set tEnd = $ZH
		// Capture %FromJSON elapsed so that it gets counted in elapsed for direct FHIRService use.
		Set pDynObjElapsed = (tEnd-tStart)
		Set pResourceType = pDynObj.resourceType
		If pResourceType="Bundle" {
			If $IsObject(pDynObj.entry) Set pEntryCount = pDynObj.entry.%Size()
		} Else {
			Do pDynObj.%Remove("id")
			Set pResourceId = ""
			Set pEntryCount = 1
		}
		// This writes the stream with no indent or line end formatting.
		Do pDynObj.%ToJSON(pQuickStream)
		
	} Else {
		Set tSC = ##class(%XML.Document).GetDocumentFromStream(pResourceStream, .pXMLDocument)
		$$$ThrowOnError(tSC)
		#dim tNode As %XML.Node
		Set tNode = pXMLDocument.GetDocumentElement()
		Set pResourceType = tNode.LocalName
		If pResourceType'="Bundle" Set pEntryCount = 1
		If tNode.MoveToFirstChild(1) {
			For {
				Set tPropName = tNode.LocalName
				If pResourceType="Bundle" {
					If tPropName="entry" If $i(pEntryCount)
				} ElseIf tPropName="id" {
					// Remove removes the current node and makes its parent the current node.
					Do tNode.Remove()
					Set pResourceId = ""
					Quit
				}
				// Try to move to the next sibling on this level, quit if no more siblings.
				If 'tNode.MoveToNextSibling(1) Quit
			}
		}
		// This writes the stream with no indent or line end formatting.
		Set tSC = ##class(%XML.ImportHandler).SerializeNode(pXMLDocument.DocumentId,pXMLDocument.GetDocumentElement().NodeId,1,1,.pQuickStream,1,0)
		$$$ThrowOnError(tSC)
	}
	
	Do pQuickStream.Rewind()
	
	Quit
}

/// Build an HS.FHIRServer.API.Data.Request from the input data and submit it
/// directly to a FHIRServer Service in the local namespace.
Method BuildAndSubmitToFHIRService(pResourceType As %String, pResourceId As %String, pFormatCode As %String, pQuickStream As HS.SDA3.QuickStream, pDynObj As %Library.DynamicObject, pDynObjElapsed As %Decimal, ByRef pElapsed As %Decimal) [ Internal ]
{
	Set tRequest = ##class(HS.FHIRServer.API.Data.Request).%New()
	Set tResponse = ##class(HS.FHIRServer.API.Data.Response).%New()
	
	If pResourceType="Bundle" {
		// transaction
		Set tRequest.RequestPath = ""
		Set tRequest.RequestMethod = "POST"
	} ElseIf pResourceId="" {
		// create
		Set tRequest.RequestPath = "/"_pResourceType
		Set tRequest.RequestMethod = "POST"
	} Else {
		// update
		Set tRequest.RequestPath = "/"_pResourceType_"/"_pResourceId
		Set tRequest.RequestMethod = "PUT"
	}
	
	Set tRequest.RequestFormatCode = pFormatCode
	Set tRequest.ResponseFormatCode = tRequest.RequestFormatCode

	Set tStart = $ZH
	
	If $IsObject(pDynObj) {
		Set tRequest.Json = pDynObj
	} Else {
		Set tRequest.Json = ..FHIRService.StreamToJSON(pQuickStream, tRequest.RequestFormatCode)
	}
	
	Do ..PreFHIRService(tRequest)
	
	Do ..FHIRService.DispatchRequest(tRequest, .tResponse)
	
	Set tEnd = $ZH
	
	// Include time spent converting JSON stream to %DynamicObject, to more
	// closely match the FHIRService time spent when called over HTTP.
	Set pElapsed = ((tEnd-tStart) + pDynObjElapsed)
	
	If '((+tResponse.Status=200)||(+tResponse.Status=201)) {
		If $IsObject(tResponse.Json) {
			Set tText = tResponse.Json.%ToJSON()
			Set tText = " ("_tText_")"
		} Else {
			Set tText = ""
		}
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrFHIRRequestFailed, tResponse.Status, tText))
	}
	
	Do pQuickStream.Clear()
	
	Quit
}

/// Build a %Net.HttpRequest from the input data and submit it to a FHIR HTTP service.
Method BuildAndSubmitToHTTPService(pResourceType As %String, pResourceId As %String, pFormatCode As %String, pQuickStream As HS.SDA3.QuickStream, ByRef pElapsed As %Integer) [ Internal ]
{
	If '$IsObject(..HttpRequest) {
		Set ..HttpRequest = ##class(%Net.HttpRequest).%New()
	} Else {
		$$$ThrowOnError(..HttpRequest.Reset())
	}
	
	Do ..ServiceInfoToHttpRequest(..HttpService, ..HttpRequest)
	
	If pResourceType="Bundle" {
		// transaction
		Set tPath = "/"
		Set tMethod = "POST"
	} ElseIf pResourceId="" {
		// create
		Set tPath = "/"_pResourceType
		Set tMethod = "POST"
	} Else {
		// update
		Set tPath = "/"_pResourceType_"/"_pResourceId
		Set tMethod = "PUT"
	}
	
	If pFormatCode=$$$FHIRContentCodeJSON {
		Set ..HttpRequest.ContentType = "application/fhir+json"
		Do ..HttpRequest.SetHeader("Accept", "application/fhir+json")
	} Else {
		Set ..HttpRequest.ContentType = "application/fhir+xml"
		Do ..HttpRequest.SetHeader("Accept", "application/fhir+xml")
	}
	
	Set ..HttpRequest.ContentCharset = "UTF-8"
	Do ..HttpRequest.EntityBody.CopyFrom(pQuickStream)
	Do ..HttpRequest.EntityBody.Rewind()
	
	Set tMethodMixedCase = $Extract(tMethod)_$ZConvert($Extract(tMethod, 2, *), "L")
	
	Set tURL = ..HttpService.URL
	
	If $Extract(tURL, *)="/" {
		Set tURL = $Extract(tURL, 1, *-1)
	}
	
	Set tURLAndPath = tURL_tPath
	
	Do ..PreHttp(.tURLAndPath)
	
	Set tStart = $ZH
	
	If (tMethodMixedCase'="Delete")&&(tMethodMixedCase'="Patch") {
		Set tSC = $Method(..HttpRequest, tMethodMixedCase, tURLAndPath)
	} Else {
		Set tSC = $Method(..HttpRequest, "Send", tMethod, tURLAndPath)
	}
	$$$ThrowOnError(tSC)
	
	Set tEnd = $ZH
	
	Set pElapsed = (tEnd-tStart)
	
	If '((+..HttpRequest.HttpResponse.StatusCode=200)||(+..HttpRequest.HttpResponse.StatusCode=201)) {
		If $IsObject(..HttpRequest.HttpResponse.Data) {
			Set tText = ..HttpRequest.HttpResponse.Data.Read()
			Set tText = " ("_tText_")"
			Do ..HttpRequest.HttpResponse.Data.Rewind()
		} Else {
			Set tText = ""
		}
		$$$ThrowStatus($$$ERROR($$$HSFHIRErrFHIRRequestFailed, ..HttpRequest.HttpResponse.StatusCode, tText))
	}
	
	Do pQuickStream.Clear()
	
	Quit
}

/// Use applicable Service Registry entry information to populate some HTTP request properties.
ClassMethod ServiceInfoToHttpRequest(pServiceObj As HS.Registry.Service.HTTP, pHttpRequest As %Net.HttpRequest) [ Internal ]
{
	Set pHttpRequest.SSLConfiguration = pServiceObj.SSLConfig
	Set pHttpRequest.Server = pServiceObj.Host
	Set pHttpRequest.Port = pServiceObj.Port
	Set:pHttpRequest.Port="" pHttpRequest.Port = 80
	Set pHttpRequest.Https = (pServiceObj.SSLConfig'="")
	Set pHttpRequest.Timeout=$Select(pServiceObj.Timeout="":30,pServiceObj.Timeout=-1:2123456789,1:pServiceObj.Timeout)
	If pServiceObj.HTTPCredentialsConfig'="" {
		Set tCredentialsObj = ##class(Ens.Config.Credentials).%OpenId(pServiceObj.HTTPCredentialsConfig)
		If '$IsObject($Get(tCredentialsObj)) {
			$$$ThrowStatus($$$ERROR($$$HSFHIRErrInvalidServiceCredentials, pServiceObj.Name))
		}
		Set pHttpRequest.Username = tCredentialsObj.Username
		Set pHttpRequest.Password = tCredentialsObj.Password
	}
	
	Quit
}

/// API Method<br>
/// @API.Overrideable<br>
/// Override this method to carry out specific tasks before dispatching the
/// HS.FHIRServer.API.Data.Request to the FHIRServer Service.
Method PreFHIRService(pRequest As HS.FHIRServer.API.Data.Request)
{
	Quit
}

/// API Method<br>
/// @API.Overrideable<br>
/// Override this method to carry out specific tasks before invoking the HTTP request.
/// The HTTP service object and the HTTP request object are accessbile as instance 
/// properties ..HttpService and ..HttpRequest. pURLAndPath is passed in here because
/// it is not part of the request object.
Method PreHttp(ByRef pURLAndPath)
{
	Quit
}

ClassMethod GetStatsDisplayString(pIndex As %String, pFileName As %String, pStreamSize As %Integer, pEntryCount As %Integer, pElapsed As %Decimal) As %String [ Internal ]
{
	Set tDisplayString = ""
	
	// Spaces string, for display string padding.
	Set $Extract(tSpaces,60)=""
	
	If $Length(pFileName)>29 {
		Set tDispName = $Extract(pFileName, 1, 29)_"..."
	} Else {
		Set tDispName = pFileName
	}
	If pIndex'="" Set tDisplayString = pIndex_". "
	Set tDisplayString = tDisplayString_tDispName
	
	Set tDisplayStreamToSendSize = (pStreamSize\1024)_" KB"
	Set tDisplayStreamToSendSize = $Extract(tSpaces, 1, 9-$Length(tDisplayStreamToSendSize))_tDisplayStreamToSendSize
	Set tDisplayString = tDisplayString_$Extract(tSpaces,1,31-($Length(tDisplayString)))_" "_tDisplayStreamToSendSize
	
	Set tDisplayEntryCount = pEntryCount_" resource"_$Select(pEntryCount>1:"s",1:"")
	Set tDisplayEntryCount = $Extract(tSpaces, 1, 17-$Length(tDisplayEntryCount))_tDisplayEntryCount
	Set tDisplayString = tDisplayString_$Extract(tSpaces,1,45-($Length(tDisplayString)))_" "_tDisplayEntryCount
	
	Set tSpace = $Select(pElapsed<10:"  ",1:" ")
	Set tDisplayString = tDisplayString_$Extract(tSpaces,1,66-($Length(tDisplayString)))_tSpace_$Justify(pElapsed,0,3)_" secs"
	
	Quit tDisplayString
}

ClassMethod GetFileErrorDisplayString(pIndex As %String, pFileName As %String, pErrorText As %String) As %String [ Internal ]
{
	Set tDisplayString = ""
	
	// Spaces string, for display string padding.
	Set $Extract(tSpaces,60)=""
	
	If $Length(pFileName)>35 {
		Set tDispName = $Extract(pFileName, 1, 35)_"..."
	} Else {
		Set tDispName = pFileName
	}
	If pIndex'="" Set tDisplayString = pIndex_". "
	Set tDisplayString = tDisplayString_tDispName
	
	Set tDisplayString = tDisplayString_"  "_pErrorText
	
	Quit tDisplayString
}

/// API Method<br>
/// @API.Overrideable<br>
/// Override this method to implement an alternate means of display output.
Method WriteOutput(pString)
{
	Write pString,!
	Quit
}

/// GetFiles returns an array of the files that are found in the
/// operating system directory pSourceDir.  File ".DS_Store" is
/// filtered out.
ClassMethod GetFiles(pSourceDir As %String, ByRef pFileArray As %String, pType As %String = "F", pWildCard As %String = "", pRecursive As %Boolean = 0) As %Status [ Internal ]
{
	Set tSC=$$$OK

	Try {
		If $Data(pFileArray)=0 Set pFileArray = 0
		If $Data(pFileArray)>9,$Data(pFileArray)#10=0 Set tSC = $$$ERROR($$$GeneralError, "Invalid file array input") Quit
		
		If ##class(%Library.File).Exists(pSourceDir)=1,##class(%Library.File).DirectoryExists(pSourceDir)=0 {
			If $i(pFileArray)
			Set pFileArray(pFileArray,"PathAndName")=pSourceDir
			Set pFileArray(pFileArray,"Name")=##class(%Library.File).GetFilename(pSourceDir)
			Quit
		}
		
		Set tSortBy = ""
		Set tSC = ##class(%File).FileSetExecute(.tHandle, pSourceDir, pWildCard, tSortBy, 0, ",")

		If $$$ISOK(tSC) {
			Set tAtEnd = 0
			For {
				Set tSC = ##class(%File).FileSetFetch(.tHandle, .tRow, .tAtEnd)
				If '$$$ISOK(tSC)!($ListLength(tRow)<6) Quit
				Set tFile = $List(tRow, 6)
				Set tType = $List(tRow, 2)
				If tFile'=".DS_Store",tType'="",pType[tType,$Extract(tFile,*-3,*)'=".bak" {
					If $i(pFileArray)
					Set pFileArray(pFileArray, "Name") = tFile
					Set pFileArray(pFileArray, "PathAndName") = $List(tRow, 1)
				} ElseIf tType="D",pRecursive=1 {
					Set tSC = ..GetFiles($List(tRow, 1), .pFileArray, pType, pWildCard, pRecursive)
				}
				If tAtEnd Quit
			}	
			Set tSC = ##class(%File).FileSetClose(.tHandle)
		}

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
