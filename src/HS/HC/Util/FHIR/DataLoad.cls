Include HS.HC

Class HS.HC.Util.FHIR.DataLoad
{

/// API
/// Submit FHIR content files from a specified operating system directory to a FHIR server. Each file
/// may contain an individual resource or a Bundle of resources. The files in the specified directory
/// can be a mix of files with an individual resource and files with a Bundle of resources. The files
/// in the specified directory may be all JSON files or all XML files, or a mix of JSON and XML files.<br>
/// <br>
/// Input:<br>
/// - pInputDirectory       : (required) Operating system directory location of the source input files.<br>
/// - pFHIRVersion          : (required) FHIR version (DSTU2, STU3) of the input FHIR data.<br>
/// - pServiceName          : Name of Service Registry HTTP service to which to send FHIR request messages.
///                           If not specified, then the FHIR request messages will be sent to the FHIR
///                           repository business operation in the local production.<br>
/// - pDisplayProgress      : 1 (default) = Display progress messages and errors. 0 = Do not display.<br>
/// - pLogGlobal            : Name of global to which to log statistics. If not specified, then no logging
///                           is done. The recorded elapsed time is that time spent while being processed
///                           in the relevant FHIR server infrastructure. It does not include time spent
///                           by this method in examining and re-formatting of resources or in the
///                           construction of request messages.<br>
/// - pFileLimit            : Limit processing to the first pFileLimit files in pInputDirectory. If pFileLimit is
///                           not specified, then all files are processed.<br>
/// <br>
/// Output - if pLogGlobal is specified:<br>
/// - @pLogGlobal@("FilesTotal") = Number of files processed.<br>
/// - @pLogGlobal@("ResourcesTotal") = Total number of resources within the processed files.<br>
/// - @pLogGlobal@("ElapsedTotal") = Total elapsed time between each processing request and response.<br>
/// - @pLogGlobal@("ElapsedAvgPerFile") = Average elapsed time per file.<br>
/// - @pLogGlobal@("ElapsedAvgPerResource") = Average elapsed time per resource.
ClassMethod SubmitResourceFiles(pInputDirectory As %String, pFHIRVersion As %String, pServiceName As %String = "", pDisplayProgress As %Boolean = 1, pLogGlobal As %String = "", pFileLimit As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If $Get(pInputDirectory)="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Input file directory not specified"))
		}
		If '##class(%Library.File).DirectoryExists(pInputDirectory) {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid input file directory specified"))
		}
		
		Set tSC = ..GetFiles(pInputDirectory, .tFiles)
		$$$ThrowOnError(tSC)
		
		If +$Get(tFiles)=0 {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "No files found in "_pInputDirectory))
		}
		
		Set tSC = ..ValidateInputForSubmit($Get(pFHIRVersion), pServiceName, "", pLogGlobal, pFileLimit)
		$$$ThrowOnError(tSC)
		
		If pServiceName="" {
			Do ..GetFHIRRepoBOName(pFHIRVersion, .tTargetHost)
			If tTargetHost="" {
				$$$ThrowStatus($$$ERROR($$$GeneralError, "FHIR server repository business host not found"))
			}
		} Else {
			Set tTargetHost = ""
		}
		
		If pLogGlobal'="" Kill @pLogGlobal
		
		If pDisplayProgress Do ..WriteOutput("")
		
		Set tTotalTime = 0
		Set tResourceCount = 0
		Set tFileCount = 0
		
		// Prevent malformed or non-JSON non-XML files from halting the entire bulk load.
		Set tBypassErrors = 0
		Set tBypassErrors($i(tBypassErrors)) = "Format not detected - input is all whitespace"
		Set tBypassErrors($i(tBypassErrors)) = "Neither JSON nor XML detected – first non-whitespace character is ASCII"
		Set tBypassErrors($i(tBypassErrors)) = "Premature end of data"
		Set tBypassErrors($i(tBypassErrors)) = "Parsing error"
		Set tBypassErrors($i(tBypassErrors)) = "SAX XML Parser Error"
		
		For tFileIndex = 1:1:tFiles {
			If (pFileLimit'="")&&(tFileIndex>pFileLimit) Quit
			
			Kill tFileStream
			
			Set tFileStream = ##class(%Stream.FileCharacter).%New()
			Set tSC = tFileStream.LinkToFile(tFiles(tFileIndex, "PathAndName"))
			$$$ThrowOnError(tSC)
			
			Set tSC = ..SubmitResourceStream(tFileStream, pFHIRVersion, pServiceName, tTargetHost, .tSentStreamSize, .tEntryCount, .tElapsed)
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
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If pDisplayProgress {
		Do ..WriteOutput("")
		If $$$ISERR(tSC) {
			Do ..WriteOutput($system.Status.GetOneErrorText(tSC))
		} Else {
			Do ..WriteOutput("Completed successfully.")
		}
	}
	
	Quit tSC
}

/// API
/// Submit an individual FHIR stream to a FHIR server.<br>
/// <br>
/// This method returns statistics regarding number of resources processed, plus elapsed time.
/// Please note that the elapsed time statistic is the accumulation of the timing starting from
/// the submission of each FHIR payload to the return of each FHIR payload.<br>
/// <br>
/// Input:<br>
/// - pResourceStream       : (required) Stream object containing FHIR content.
/// - pFHIRVersion          : (required) FHIR version (DSTU2, STU3) of the input FHIR data.<br>
/// - pServiceName          : Name of Service Registry HTTP service to which to send FHIR request messages.
///                           If not specified, then the FHIR request messages will be sent to the business
///                           host in the local Interoperability production indicated by the pTargetHost
///                           input parameter.<br>
/// - pTargetHost           : Name of business host in the local Interoperability production to which to
///                           send FHIR request messages.
/// <br>
/// Output:<br>
/// - pSentStreamSize       : Size, in bytes, of the FHIR stream that was actually sent.<br>
/// - pEntryCount           : Number of resources in pResourceStream.<br>
/// - pElapsed              : Elapsed processing time for the resources within pResourceStream.
///                           Elapsed time is that time spent while being processed in the relevant
///                           FHIR server infrastructure. It does not include time spent by this
///                           method in examining and re-formatting of resources or in the
///                           construction of request messages.
ClassMethod SubmitResourceStream(pResourceStream As %Stream.Object, pFHIRVersion As %String, pServiceName As %String = "", pTargetHost As %String = "", Output pSentStreamSize As %Integer, Output pEntryCount As %Integer, Output pElapsed As %Decimal) As %Status
{
	Set tSC = $$$OK
	
	Set pSentStreamSize = 0
	Set pEntryCount = 0
	Set pElapsed = 0
	
	Try {
		Set tSC = ..ValidateInputForSubmit($Get(pFHIRVersion), .pServiceName, pTargetHost, "", "")
		$$$ThrowOnError(tSC)
		
		If (pServiceName="")&&(pTargetHost="") {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Neither service name nor target host specified"))
		}
		
		// Get the format of the FHIR resource stream contents.
		Set tSC = ..GetFormatFromData(pResourceStream, .tStreamContentFormat)
		$$$ThrowOnError(tSC)
		
		Do pResourceStream.Rewind()
		
		// The HTTP Content-Type header is based on the FHIR version and the target FHIR format.
		If pFHIRVersion="DSTU2" {
			Set tContentTypeToSend = $Select(tStreamContentFormat["json":"application/json+fhir", 1:"application/xml+fhir")
		} Else {
			Set tContentTypeToSend = $Select(tStreamContentFormat["json":"application/fhir+json", 1:"application/fhir+xml")
		}
		
		// Get some metadata and an unformatted version of the resource stream.
		Do ..GatherInfoFromStream(pResourceStream, tStreamContentFormat, .tQuickStream, .tDynObj, .tXMLDocument, .tResourceType, .tResourceId, .pEntryCount)
		
		Set pSentStreamSize = tQuickStream.Size
		
		// Formulate the FHIR request message(s) and send.
		Do ..BuildFHIRRequestAndSubmit(tResourceType, tResourceId, tContentTypeToSend, pFHIRVersion, pServiceName, pTargetHost, tQuickStream, .pElapsed)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Common input validation logic.
ClassMethod ValidateInputForSubmit(pFHIRVersion As %String, ByRef pServiceName As %String, pTargetHost As %String, pLogGlobal As %String, pFileLimit As %String) As %Status [ Internal ]
{
	Set tErrText = ""
	
	Try {
		If pFHIRVersion="" Set tErrText = "FHIR version not specified" Quit
		
		If '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tErrText = "Invalid FHIR version '"_pFHIRVersion_"' specified - must be 'DSTU2' or 'STU3'"
			Quit
		}
		
		If (pTargetHost'="")&&(pServiceName'="") {
			Set tErrText = "Cannot specify both target host and service name"
			Quit
		} ElseIf pServiceName'="" {
			Set tObj = ##class(HS.Registry.Service.Abstract).EndPointForNameType(pServiceName, "HTTP")
			If '$IsObject(tObj) {
				Set tErrText = "Service '"_pServiceName_"' is not defined in this namespace"
				Quit
			} Else {
				Kill tObj
			}
		} ElseIf pTargetHost'="" {
			// Verify that the specified target host is included in the local
			// production and that its class is or extends the Repository
			// business host for the specified FHIR version.
			Set tRepoClassName = "HS.FHIR.v"_pFHIRVersion_".Repository.Operations"
			Set tClassName = $Get($$$ConfigClassName(pTargetHost))
			If tClassName="" {
				Set tErrText = "Target host not found in local production"
				Quit
			} ElseIf '$ClassMethod(tClassName, "%IsA", tRepoClassName) {
				Set tErrText = "Invalid target host specified - host class must be or extend "_tRepoClassName
				Quit
			}
		}
		
		If (pLogGlobal'="")&&($Extract(pLogGlobal)'="^") {
			Set tErrText = "Invalid log global specified - must start with ^"
			Quit
		}
		
		If (pFileLimit'="")&&((pFileLimit'?1N.N)||(+pFileLimit'>0)) {
			Set tErrText = "File limit must be a positive integer"
			Quit
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
		Set tErrText = $system.Status.GetErrorText(tSC)
	}
	
	If tErrText'="" Quit $$$ERROR($$$GeneralError, tErrText)
	
	Quit $$$OK
}

/// Derive and return the resource type and resource count from the specified resource
/// stream. Also remove the resource id from an individual-resource stream. Return the
/// QuickStream as an unformatted version of the input stream.
ClassMethod GatherInfoFromStream(pResourceStream As %Stream.Object, pStreamFHIRFormat As %String, ByRef pQuickStream As HS.SDA3.QuickStream, ByRef pDynObj As %Library.DynamicObject, ByRef pXMLDocument As %XML.Document, ByRef pResourceType As %String, ByRef pResourceId As %String, ByRef pEntryCount As %Integer) [ Internal ]
{
	Set pResourceType = ""
	Set pResourceId = ""
	Set pEntryCount = 0
	
	Set pQuickStream = ##class(HS.SDA3.QuickStream).%New()
	
	// Derive and return the resource type, entry count and stream to send.
	// Remove resource id, if one is found.
	
	If pStreamFHIRFormat="json" {
		Set pDynObj = ##class(%Library.DynamicObject).%FromJSON(pResourceStream)
		Do pResourceStream.Rewind()
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
		Set tSC = ##class(HS.FHIR.Utils).SerializeXMLDocument(pXMLDocument, pQuickStream)
		$$$ThrowOnError(tSC)
	}
	
	Do pQuickStream.Rewind()
	
	Quit
}

/// Given the basic metadata and the resource stream, build the FHIR request
/// message and submit it to the appropriate entity - API call, business host,
/// or to a FHIR service via the FHIR REST Operation.
ClassMethod BuildFHIRRequestAndSubmit(pResourceType As %String, pResourceId As %String, pContentType As %String, pFHIRVersion As %String, pServiceName As %String, pTargetHost As %String, pQuickStream As HS.SDA3.QuickStream, ByRef pElapsed As %Integer) [ Internal ]
{
	Set pElapsed = 0
	
	Set tRequest = ##class(HS.Message.FHIR.Request).%New()
	
	If pResourceType="Bundle" {
		// Interaction is always transaction here, regardless of Bundle type = transaction or batch.
		Set tRequest.Interaction = "transaction"
	} Else {
		Set tRequest.Interaction = $Select(pResourceId'="":"update",1:"create")
		Set tRequest.Type = pResourceType
		Set tRequest.Id = pResourceId
	}
	
	Set tRequest.ContentType = pContentType
	Set tRequest.FHIRVersion = pFHIRVersion
	If pServiceName'="" {
		Do tRequest.AdditionalInfo.SetAt("HS.FHIR.REST.Operation", "Host")
		Do tRequest.AdditionalInfo.SetAt(pServiceName, "ServiceName")
	} Else {
		Do ##class(%RoutineMgr).GetWebServerPort(.tPort)
		Set tInstanceHost = $$$HSNetworkHostName_":"_tPort
		Do tRequest.Headers.SetAt(tInstanceHost, "HOST")
		Set tSQL = "SELECT URL,FHIRVersion,UseOAuth FROM HS_Registry.FHIRCSPConfig"
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tSC = tStatement.%Prepare(.tSQL)
		#dim tSQLResultSet As %SQL.StatementResult
		Set tSQLResultSet = tStatement.%Execute()
		If (tSQLResultSet.%SQLCODE < 0) { 
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Error executing query for search interaction: SQL error, SQLCODE="_tSQLResultSet.%SQLCODE_", Msg="_tSQLResultSet.%Message))
		}
		// Get the non-OAuth URL for this FHIR version, use the OAuth one if we have to.
		Set tURL = ""
		While tSQLResultSet.%Next() {
			If tSQLResultSet.%Get("FHIRVersion")'=pFHIRVersion Continue
			Set tURL = tSQLResultSet.%Get("URL")
			If tSQLResultSet.%Get("UseOAuth")=0 Quit
		}
		If tURL="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Could not find URL in FHIR CSP Config table to use for Content-Location responses"))
		}
		Set tRequest.BaseURL = tURL
		Do tRequest.AdditionalInfo.SetAt(pTargetHost, "Host")
	}
	Set tRequest.QuickStreamId = pQuickStream.%Id()
	
	// Accumulate just the elapsed time between send and response.
	
	Do ..SendViaInteroperability(tRequest, .tResponse, .pElapsed)
	
	Do pQuickStream.Clear()
	
	If tResponse.QuickStreamId'="" {
		Set tResponseQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tResponse.QuickStreamId)
		Do tResponseQuickStream.Clear()
	}
	
	Quit
}

ClassMethod SendViaInteroperability(pRequest, ByRef pResponse, ByRef pElapsed As %Integer) [ Internal ]
{
	Set pElapsed = 0
	Set tStart = $ZH
	Set tSC = ##class(HS.Test.Service).SendSync(pRequest, .pResponse)
	Set tEnd = $ZH
	$$$ThrowOnError(tSC)
	If '$IsObject($Get(pResponse)) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "FHIR response object not returned from SendSync to "_pRequest.AdditionalInfo.GetAt("Host")))
	} ElseIf 'pResponse.%IsA("HS.Message.FHIR.Response") {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Response object from "_pRequest.AdditionalInfo.GetAt("Host")_" is not FHIR response"))
	} ElseIf '##class(HS.FHIR.Helper).HttpSuccess(pResponse.Status) {
		Set tText = pResponse.GetPayloadOref().Read()
		$$$ThrowStatus($$$ERROR($$$GeneralError, "FHIR response Status = "_pResponse.Status_$Select(tText'="":"("_tText_")",1:"")))
	}
	Set pElapsed = (tEnd-tStart)
	Quit
}

ClassMethod GetStatsDisplayString(pIndex As %String, pFileName As %String, pStreamSize As %Integer, pEntryCount As %Integer, pElapsed As %Decimal) As %String [ Internal ]
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
	
	Set tDisplayStreamToSendSize = (pStreamSize\1024)_" KB"
	Set tDisplayStreamToSendSize = $Extract(tSpaces, 1, 8-$Length(tDisplayStreamToSendSize))_tDisplayStreamToSendSize
	Set tDisplayString = tDisplayString_$Extract(tSpaces,1,42-($Length(tDisplayString)))_" "_tDisplayStreamToSendSize
	
	Set tDisplayEntryCount = pEntryCount_" resource"_$Select(pEntryCount>1:"s",1:"")
	Set tDisplayEntryCount = $Extract(tSpaces, 1, 15-$Length(tDisplayEntryCount))_tDisplayEntryCount
	Set tDisplayString = tDisplayString_$Extract(tSpaces,1,54-($Length(tDisplayString)))_" "_tDisplayEntryCount
	
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

/// Override this method if an alternate means of display output is desired.
ClassMethod WriteOutput(pString)
{
	Write pString,!
	Quit
}

/// GetFormatFromData derives a JSON-or-XML format designation for the specified
/// string or stream data, and returns it in the pFormat parameter. If the first
/// non-whitespace character found is left curly brace ("{"), then pFormat is
/// returned as "json". If the first non-whitespace character found is left
/// angle bracket ("<") then pFormat is returned as "xml". Otherwise pFormat is
/// returned as blank string, and an error status is returned.<br>
/// <br>
/// Note that this method does NOT verify that the specified data is well-formed
/// JSON or XML.
ClassMethod GetFormatFromData(pStreamOrString = "", ByRef pFormat As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Set pFormat = ""
	
	Try {
		Set tReturn = ""
		
		If pStreamOrString="" {
			Set tSC = $$$ERROR($$$GeneralError, "Input not specified")
		} ElseIf '$IsObject(pStreamOrString) {
			// It's a string.
			Do FindStart(.pStreamOrString, .tReturn)
		} ElseIf pStreamOrString.%IsA("%Stream.Object") {
			// It's a stream object.
			Do pStreamOrString.Rewind()
			For {
				// Use a shorter-than-default read length to avoid taking up too much memory.
				Set tString = pStreamOrString.Read(2000, .tSC)
				If $$$ISERR(tSC) Quit
				Do FindStart(.tString, .tReturn)
				If tReturn'="" Quit
				If pStreamOrString.AtEnd Quit
			}
			If $$$ISOK(tSC) Do pStreamOrString.Rewind()
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Input must be a String or a %Stream.Object")
		}
		If $$$ISERR(tSC) Quit
		
		If (tReturn="json")||(tReturn="xml") {
			Set pFormat = tReturn
		} ElseIf tReturn="" {
			Set tSC = $$$ERROR($$$GeneralError, "Format not detected - input is all whitespace")
		} Else {
			Set tSC = tReturn
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
	
FindStart(string, return)
	For j = 1:1:$Length(string) {
		Set char = $Extract(string, j)
		// Once we hit a non-whitespace char, it's either left curly brace,
		// left angle bracket, or we return an error.
		If '((char=$Char(9))||(char=$Char(32))||(char=$Char(10))||(char=$Char(11))||(char=$Char(13))) {
			If char="{" {
				Set return = "json"
			} ElseIf char="<" {
				Set return = "xml"
			} Else {
				Set return = $$$ERROR($$$GeneralError, "Neither JSON nor XML detected – first non-whitespace character is ASCII "_$A(char))
			}
			Quit
		}
	}
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

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Find the FHIR repository business host for the specified FHIR version in the local production.
ClassMethod GetFHIRRepoBOName(pFHIRVersion As %String, ByRef pConfigItemName As %String) [ Internal ]
{
	Set pConfigItemName = ""
	
	#dim tProdRef As Ens.Config.Production
	#dim tItem As Ens.Config.Item
	
	Set tSC = ##class(HS.Util.Installer.Kit.Base).GetProduction(.tProdRef)
	$$$ThrowOnError(tSC)
	
	Set tRepoClassName = "HS.FHIR.v"_pFHIRVersion_".Repository.Operations"
	
	For i = 1:1:tProdRef.Items.Count() {
		Set tItem = tProdRef.Items.GetAt(i)
		If 'tItem.Enabled Continue
		If $ClassMethod(tItem.ClassName, "%IsA", tRepoClassName) {
			Set pConfigItemName = tItem.Name
			Quit
		}
	}
	
	Quit pConfigItemName
}

}
