/// 
/// Utility class for writing XML
/// 
Class HS.XML.WriterFHIR [ System = 3 ]
{

/// 
/// Write a value to a stream as FHIR XML.  This method simply wraps object.%ToFHIRXML() with I/O redirection in order to
/// capture the output to a stream.  The caller may specify the stream to avoid any additional copying, otherwise,
/// one will be created.
/// 
ClassMethod %CaptureWriteXMLToStream(pValue, ByRef pStream As %Stream.Object, pRewindStream As %Boolean = 0, pSuppressProlog As %Boolean = 0) As %Status [ ProcedureBlock = 0 ]
{
	New %ISCXMLStream, tSC, ex, tInitIO, tRedirected, tWasRedirected, tOldMnemonic
	#dim ex As %Exception.AbstractException
	#dim tSC As %Status = $$$OK
	#dim tRedirected, tWasRedirected As %Boolean = 0
	#dim tInitIO, tOldMnemonic
	Try {
		Set tWasRedirected = 0
		Set tOldMnemonic = ""

		Set:'$IsObject($G(pStream)) pStream=##class(%Stream.TmpBinary).%New()

		Set tInitIO = $IO
		Set tWasRedirected = ##class(%Library.Device).ReDirectIO()
		Set tOldMnemonic = ##class(%Library.Device).GetMnemonicRoutine()
		Set %ISCXMLStream = pStream
		Use tInitIO::("^"_$ZNAME)
		Set tRedirected = 1
		Do ##class(%Library.Device).ReDirectIO(1)

		// Use %ToFHIRXML to write the XML
		Set tSC = pValue.%ToFHIRXML(,,pSuppressProlog)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	If tRedirected && ##class(%Library.Device).ReDirectIO(0) {
		Use tInitIO
	}
	If ($get(tOldMnemonic) '= "") {
		Set tOldMnemonic = "^"_tOldMnemonic
		Use tInitIO::(tOldMnemonic)
	}
	If $get(tWasRedirected) {
		Do ##class(%Library.Device).ReDirectIO(1)
	}
	If pRewindStream && $$$ISOK(tSC) {
		Do pStream.Rewind()
	}
	
	Quit tSC

#; Public entry points for redirection - any changes made here should
#; also be reflected in redirects() in the jsonSQLProvider class
wstr(s)	Do %ISCXMLStream.Write(s) Quit
wchr(a) Do %ISCXMLStream.Write($char(a)) Quit
wnl 	Do %ISCXMLStream.WriteLine() Quit
wff 	Do %ISCXMLStream.WriteLine() Quit
wtab(n) Do %ISCXMLStream.Write($J("",$S(n>$X:n-$X,1:0))) Quit
rstr(len,time) Quit ""
rchr(time) Quit ""
}

}
