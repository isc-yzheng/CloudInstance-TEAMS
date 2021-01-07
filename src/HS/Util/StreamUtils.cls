Class HS.Util.StreamUtils [ Abstract ]
{

/// Base64 decode a string or a stream into a stream
/// 
/// <example>
/// Do ##class(HS.Util.StreamUtils).Base64Decode("SGVsbG8=",.tDecodedStream)
/// </example>
/// 
/// By default a %Stream.GlobalBinary is returned. Caller may override by
/// sending in a different stream. For example:
/// <example>
/// Set tInputFile=##class(%Stream.FileBinary).%New()
/// Set tInputFile.Filename="c:\data.b64"
/// Set tOutputFile=##class(%String.FileBinary).%New()
/// Set tOutputFile.Filename="c:\data.dat"
/// Do ##class(HS.Util.StreamUtils).Base64Encode(tInputFile,tOutputFile)
/// </example>
ClassMethod Base64Decode(pInput = "", ByRef pOutput As %Stream.GlobalBinary = "") As %Status
{
	Set tSC=$$$OK
	Try {
		If '$IsObject(pOutput) Set pOutput=##class(%Stream.GlobalBinary).%New()
		
		#; Remove newlines from input then decode the largest value
		#; possible that has a length which is a factor of 4
		If $IsObject(pInput) {
			Set tLeftOver=""
			While 'pInput.AtEnd { 
				Set tValue=pInput.Read($$$MaxLocalLength-4)  
				Set tValue=tLeftOver_$TR(tValue,$C(13,10))
				Set tPos=$L(tValue)-($L(tValue)#4)
				Set tLeftOver=$e(tValue,tPos+1,*)
				Set tValue=$e(tValue,1,tPos)
				Do pOutput.Write($SYSTEM.Encryption.Base64Decode(tValue))
			}
		} Else {
			Do pOutput.Write($SYSTEM.Encryption.Base64Decode(pInput))
		}	
		Do pOutput.Rewind()
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// Base64 encode a string or a stream into a stream
/// 
/// <example>
/// Do ##class(HS.Util.StreamUtils).Base64Encode("Hello",.tEncodedStream)
/// </example>
/// 
/// By default a %Stream.GlobalCharacter is returned. Caller may override by
/// sending in any stream type that has a LineTerminator property. For example:
/// <example>
/// Set tInputFile=##class(%Stream.FileBinary).%New()
/// Set tInputFile.Filename="c:\data.dat"
/// Set tOutputFile=##class(%String.FileBinary).%New()
/// Set tOutputFile.Filename="c:\data.b64"
/// Do ##class(HS.Util.StreamUtils).Base64Encode(tInputFile,tOutputFile)
/// </example>
ClassMethod Base64Encode(pInput = "", ByRef pOutput As %Stream.GlobalCharacter = "") As %Status
{
	Set tSC=$$$OK
	Try {
		If '$IsObject(pOutput) Set pOutput=##class(%Stream.GlobalCharacter).%New()
		
		#; Get the biggest buffer possible
		#; Assumes output is 78 characters (76 + 2 newlines) per base-64 line
		#; ($$$MaxLocalLength\78*57) should work, but it doesn't so just use 50% floored to nearst power of 57
		Set tMax=$$$MaxLocalLength*.5\1
		Set tMax=tMax-(tMax#57)
		
		If $IsObject(pInput) {
			Set tCurrLineLen=0
			While 'pInput.AtEnd { 
				Set tData=pInput.Read(tMax)
				Set tValue=$SYSTEM.Encryption.Base64Encode(tData)
				Do pOutput.Write(tValue) 
				If 'pInput.AtEnd Do pOutput.Write(pOutput.LineTerminator)
			}
		} Else {
			Set tPos=1
			While tPos<$l(pInput) {
				Set tEnd=tPos+tMax-1
				Set tValue=$e(pInput,tPos,tEnd)
				Set tValue=$SYSTEM.Encryption.Base64Encode(pInput)
				Do pOutput.Write(tValue)
				Set tPos=tEnd+1
				If tPos<$l(pInput) Do pOutput.Write(pOutput.LineTerminator)
			}
		}	
			Do pOutput.Rewind()
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// Copy either a string or stream into a stream
ClassMethod CopyFrom(pDest As %Stream.Object, pSource) As %Status
{
	Set tSC=$$$OK
	Try {
		If $IsObject(pSource) {
			Set tSC=pDest.CopyFrom(pSource) Quit:$$$ISERR(tSC)
		} Else {
			Set tSC=pDest.Write(pSource) Quit:$$$ISERR(tSC)
		}
		Do pDest.Rewind()
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// Convert the input (if necessary) to a %String.
/// Inputs:<br>
/// <li>pStringOrStream  : (required) A %String or a %Stream is accepted.  If a Stream, it is converted into
///                        a string.
/// <br>
/// Throws:  Any exception from StringIO will be thrown from this method
ClassMethod EnsureString(pStringOrStream) As %String
{
	If $IsObject(pStringOrStream) {
		#dim tResult As %String = ""
		#dim tStream = pStringOrStream
		
		Do tStream.Rewind()
		while 'tStream.AtEnd {
			Set len = 8192
			Set tStr = tStream.Read(.len, .sc)
			$$$ThrowOnError(sc)
			Set tResult = tResult_tStr
		}
		Quit tResult
	}
	Quit pStringOrStream
}

/// Convert the input (if necessary) to a %Stream
/// Inputs:<br>
/// <li>pStringOrStream  : (required) A %String or a %Stream is accepted.  If not a %Stream, it is converted into
///                        a %Stream
/// <br>
/// Throws:  Any exception from StringIO will be thrown from this method
ClassMethod EnsureStream(pStringOrStream) As %Stream
{
	If '$IsObject(pStringOrStream) {
		Set tStream = ##class(%Stream.TmpCharacter).%New()
		Set tString = pStringOrStream
		Set tSC = tStream.Write(pStringOrStream)
		$$$ThrowOnError(tSC)

		Do tStream.Rewind()
	} Else {
		Set tStream = pStringOrStream
	}
	Quit tStream
}

/// Get a temp directory, ensuring it exists
/// 
/// <dl>
/// <dt>pSubDir <dd>[optional] subdirectory under the system temp dir, defaults to 'HSTMP'
/// </dl>
/// 
/// <p>Returns:
/// <ul>
/// <li>the requested subdirectory if it exists or was created successfully
/// <li>otherwise the system configured temp directory
/// </ul>
/// 
ClassMethod GetTempDirectory(pSubDir = "HSTMP") As %String
{
	Set tTempFile = ##class(%File).TempFilename()
	Set tSysTemp  = ##class(%File).GetDirectory(tTempFile,1)
 	Set tTempDir = ##class(%File).NormalizeDirectory(tSysTemp_pSubDir_"/"_$namespace_"/")
 	If ##class(%File).CreateDirectoryChain(tTempDir) Quit tTempDir
 	Quit tSysTemp
}

/// Delete all files in the temp directory
/// 
/// <dl>
/// <dt>pSubDir <dd>[optional] subdirectory under the system temp dir, defaults to 'HSTMP'
/// </dl>
/// 
/// <p>Returns true if all files deleted
/// 
ClassMethod PurgeTempDirectory(pSubDir) As %Boolean
{
	Set tTempDir = ..GetTempDirectory(.pSubDir)
	Quit ##class(%File).ComplexDelete(tTempDir_"*")
}

/// Get a temp file path
/// 
/// <dl>
/// <dt>pSubDir <dd>[optional] subdirectory under the system temp dir, defaults to 'HSTMP'
/// </dl>
/// 
/// <p>Returns: the full temp file path
/// 
ClassMethod GetTempFilename(pSubDir) As %String
{
	Set tFileName = ##class(%FileBinaryStream).NewFileName()
	Quit ..GetTempDirectory(.pSubDir)_tFileName
}

/// Write stream to a file
/// 
/// <dl>
/// <dt>pFilePath <dd>[required] location to save the stream
/// <dt>pStream   <dd>[required] stream to write
/// <dt>pEncoding <dd>[optional] if given uses a character stream with this translate table
/// </dl>
/// 
/// <example>
/// Set tSC = ##class(HS.Util.StreamUtils).CopyToFile("/path/to/doc.pdf", tPDFStream)
/// Set tSC = ##class(HS.Util.StreamUtils).CopyToFile("/path/to/ccd.xml", tCCDStream, "UTF8")
/// </example>
/// 
ClassMethod CopyToFile(pFilePath As %String, pStream As %Stream.Object, pEncoding) As %Status
{
	If $D(pEncoding) {
		Set tFileStream = ##class(%Stream.FileCharacter).%New()
		If pEncoding'="" Set tFileStream.TranslateTable = pEncoding
	}
	Else {
		Set tFileStream = ##class(%Stream.FileBinary).%New()
	}
	$$$QuitOnError(pStream.Rewind())
	$$$QuitOnError(tFileStream.LinkToFile(pFilePath))
	$$$QuitOnError(tFileStream.CopyFrom(pStream))
	$$$QuitOnError(tFileStream.%Save())
	Quit $$$OK
}

/// Read stream from file, optionally copying it into a provided stream
/// 
/// <dl>
/// <dt>pFilePath <dd>[required] location to read the stream from
/// <dt>pStream   <dd>[output]   if given the stream to copy into, otherwise the file stream
/// <dt>pEncoding <dd>[optional] if given reads using a character stream with this translate table
/// </dl>
/// 
/// <example>
/// Set tSC = ##class(HS.Util.StreamUtils).ReadFromFile("/path/to/doc.pdf", .tPDFStream)          // a %Stream.FileBinary
/// Set tSC = ##class(HS.Util.StreamUtils).ReadFromFile("/path/to/ccd.xml", .tCCDStream, "UTF8")  // a %Stream.FileCharacter with TranslateTable="UTF8"
/// Set tSDAStream = ##class(HS.SDA3.QuickStream).%New()
/// Set tSC = ##class(HS.Util.StreamUtils).ReadFromFile("/path/to/sda.xml", .tSDAStream, "UTF8")  // reads file as UTF8 and copies into provided QuickStream 
/// </example>
/// 
ClassMethod ReadFromFile(pFilePath As %String, ByRef pStream As %Stream.Object, pEncoding) As %Status
{
	If $D(pEncoding) {
		Set tFileStream = ##class(%Stream.FileCharacter).%New()
		If pEncoding'="" Set tFileStream.TranslateTable = pEncoding
	}
	Else {
		Set tFileStream = ##class(%Stream.FileBinary).%New()
	}
	$$$QuitOnError(tFileStream.LinkToFile(pFilePath))	
	If (('$D(pStream))||('$IsObject(pStream))) {
		Set pStream = tFileStream
	}
	Else {
		$$$QuitOnError(pStream.CopyFrom(tFileStream))
		$$$QuitOnError(pStream.Rewind())
	}
	Quit $$$OK
}

}
