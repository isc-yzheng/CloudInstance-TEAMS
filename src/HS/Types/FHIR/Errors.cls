/// HS.Types.FHIR.Errors provides a means for gathering multiple FHIR errors, warnings and/or
/// informational messages, and for creating a FHIR resource stream or FHIR resource object
/// from that collection.
Class HS.Types.FHIR.Errors Extends %RegisteredObject
{

Property Errors As list Of HS.Types.FHIR.Error;

Property HighestError As %String;

Method logError(pCode, pSeverity, pDetailsText, pLocation, pDetailsCode, pDetailsDescription, pDiagnostics, pExpression)
{
	Set tError = ##class(HS.Types.FHIR.Error).%New()
	Set tError.Code = pCode
	Set tError.Severity = pSeverity
	Set tError.DetailsText = pDetailsText
	If $Get(pLocation)'="" Set tError.Location = pLocation
	If $Get(pDetailsCode)'="" Set tError.DetailsCode = pDetailsCode
	If $Get(pDetailsDescription)'="" Set tError.DetailsDescription = pDetailsDescription
	If $Get(pDiagnostics)'="" Set tError.Diagnostics = pDiagnostics
	If $Get(pExpression)'="" Set tError.Expression = pExpression
	Do ..Errors.Insert(tError)
	If pSeverity="error" {
		Set ..HighestError="error"
	} else {
		Set:..HighestError="" ..HighestError=pSeverity
	}
	Quit
}

/// GenerateOperationOutcomeStream generates a FHIR OperationOutcome resource stream from the
/// information in the Errors collection of this class instance.<br>
/// Input:<br>
/// <li>pContentType      : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pFormatFHIROutput : 1 = include indent and line ending formatting, 0 = do not add formatting.
/// <br>Output:<br>
/// <li>pStream           : FHIR OperationOutcome resource stream.
Method GenerateOperationOutcomeStream(pContentType As %String, pFormatFHIROutput As %Boolean = 0, ByRef pStream) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pStream)) Set pStream = ##class(%Stream.TmpCharacter).%New()
		
		If ..Errors.Count()=0 Quit
		
		Set tIsJSON = ($ZConvert(pContentType,"L")["json")
		
		Set tSC = ##class(HS.FHIR.Utils).StartOutcomeStream(pContentType, .pStream, pFormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		For i = 1:1:..Errors.Count() {
			Set tError = ..Errors.GetAt(i)
			Set tSC = ##class(HS.FHIR.Utils).AddOutcomeIssueStream(pContentType, .pStream, tError.Severity, tError.Code, tError.DetailsText, tError.DetailsCode, tError.DetailsDescription, tError.Diagnostics, tError.Location, tError.Expression, ((tIsJSON)&&(i<..Errors.Count())) , pFormatFHIROutput)
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).EndOutcomeStream(pContentType, .pStream, pFormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// GenerateOperationOutcomeObj generates a FHIR OperationOutcome resource object from the
/// information in the Errors collection of this class instance.<br>
/// Input:<br>
/// <li>pResourceSchema   : (required) Class package to use as the root of FHIR resource schemas.
///                          Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br>Output:<br>
/// <li>pOperationOutcome : FHIR OperationOutcome resource object.
Method GenerateOperationOutcomeObj(pResourceSchema As %String, ByRef pOperationOutcome) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If ..Errors.Count()=0 Quit
		
		Set tSC = ..GenerateOperationOutcomeStream("json", , .tStream)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR("json", tStream, .pOperationOutcome, pResourceSchema)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
