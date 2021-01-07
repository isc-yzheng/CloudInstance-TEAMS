Class HS.FHIR.vDSTU2.MHD.Common [ Abstract ]
{

Parameter HSDEPLOY = 1;

/// Parse the Errors object and return an error response as per the
/// current MHD transaction type (i.e., Provide, Find, Retrieve).
Method FHIRMHDErrorResponse(pOriginalRequest As HS.Message.FHIR.Request, Output pErrorResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If ..Errors.Errors.Count()=0 Quit
		
		If '$IsObject($Get(pErrorResponse)) Set pErrorResponse = ##class(HS.Message.FHIR.Response).%New()
		Set pErrorResponse.ContentType = pOriginalRequest.ContentType
		
		#; For read (MHD Retrieve) the document itself might not be of
		#; mime type XML or JSON (e.g., application/pdf, text/plain).
		#; In those cases the Accept header needs to match the document
		#; mime type, or be */*.  Which would mean we cannot return the
		#; error message in a FHIR format.
		If pOriginalRequest.Interaction="read" {
			Set tIsFHIRFormat = 0
			Set tFoundStarStar = 0
			Do ##class(HS.FHIR.Utils).GetValidFormats("accept", .tValidTypes)
			If pOriginalRequest.ContentType'="" {
				For i = 1:1:$Length(pOriginalRequest.ContentType, ",") {
					Set tCP = $Piece($Piece(pOriginalRequest.ContentType, ",", i), ";", 1)
					If (tCP'="")&&('tIsFHIRFormat) Set tIsFHIRFormat = $Data(tValidTypes(tCP))
					If tCP="*/*" Set tFoundStarStar = 1
				}
			}
			If 'tIsFHIRFormat {
				If 'tFoundStarStar {
					Set pErrorResponse.ContentType = "text/plain"
					Do pErrorResponse.Payload.Write(..Errors.Errors.GetAt(1).Description)
					Set pErrorResponse.Status = $Case(..Errors.Errors.GetAt(1).Code, "not-supported":406, "not-found":404, :400)
					Quit
				} Else {
					Set pErrorResponse.ContentType = "text/xml"
				}
			}
		}
		
		Set tHasPayload = (pErrorResponse.Payload.Size>0)
		
		Set tErrorsCount = 0
		Set tWarningsCount = 0
		Set tException = 0
		
		For i = 1:1:..Errors.Errors.Count() {
			If (..Errors.Errors.GetAt(i).Severity="error") If $i(tErrorsCount)
			If (..Errors.Errors.GetAt(i).Severity="warning") If $i(tWarningsCount)
			If (..Errors.Errors.GetAt(i).Code="exception") Set tException = 1
		}
		
		#; The presence of errors (as opposed to warnings) supersedes continuing
		#; with returning any document manifest or document reference content.
		#; In that case, return only the OperationOutcome resource.
		If tErrorsCount>0 {
			Set tSC = ..OperationOutcomeOnly(pOriginalRequest, .pErrorResponse)
		} Else {
			#; Otherwise, if there is only warning(s) then return either
			#; an OperationOutcome resource, or add an OperationOutcome
			#; resource to an existing resource or Bundle.
			If tHasPayload=0 {
				Set tSC = ..OperationOutcomeOnly(pOriginalRequest, .pErrorResponse)
			} Else {
				Do pErrorResponse.Payload.Rewind()
				Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(pOriginalRequest.ContentType, pErrorResponse.Payload, .tHSFHIRObj, "HS.FHIR.vDSTU2.Model.Resource")
				If $$$ISERR(tSC) Quit
				If tHSFHIRObj.%ClassName(0)="Bundle" {
					Set tSC = ..AddOperationOutcomeToBundle(.tHSFHIRObj)
				} Else {
					Set tSC = ..AddOperationOutcomeToResource(.tHSFHIRObj)
				}
				If $$$ISERR(tSC) Quit
				Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pOriginalRequest.ContentType, tHSFHIRObj, .tNewFHIRStream, pOriginalRequest.FormatFHIROutput)
				If $$$ISERR(tSC) Quit
				Do tNewFHIRStream.Rewind()
				Set tSC = pErrorResponse.Payload.Clear()
				If $$$ISERR(tSC) Quit
				Set tSC = pErrorResponse.Payload.CopyFrom(tNewFHIRStream)
			}
		}
		
		If 'tException {
			If (..Errors.Errors.GetAt(1).Code="not-supported")&&(..Errors.Errors.GetAt(1).Description["Not Acceptable") {
				Set pErrorResponse.Status = 406
			} ElseIf ..Errors.Errors.GetAt(1).Code="not-found" {
				Set pErrorResponse.Status = 404
			} Else {
				Set pErrorResponse.Status = 400
			}
		} Else {
			Set pErrorResponse.Status = 500
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Do ..Errors.Errors.Clear()
	
	Quit tSC
}

Method OperationOutcomeOnly(pOriginalRequest As HS.Message.FHIR.Request, Output pErrorResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tOperationOutcome = ##class(HS.FHIR.vDSTU2.Model.Resource.OperationOutcome).%New()
		
		For tIndex = 1:1:..Errors.Errors.Count() {
			Set tIssue = ##class(HS.FHIR.vDSTU2.Model.Resource.OperationOutcome.Issue).%New()
			Set tSC = tIssue.SetSeverity(..Errors.Errors.GetAt(tIndex).Severity) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetCode(..Errors.Errors.GetAt(tIndex).Code) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetDetails( , , , ..Errors.Errors.GetAt(tIndex).Description) Quit:$$$ISERR(tSC)
			Set tSC = tOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pErrorResponse.ContentType, tOperationOutcome, .tFHIRStream, pOriginalRequest.FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		Do tFHIRStream.Rewind()
		
		Set tSC = pErrorResponse.Payload.Clear()
		If $$$ISERR(tSC) Quit
		Set tSC = pErrorResponse.Payload.CopyFrom(tFHIRStream)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// AddOperationOutcomeToResource wraps the existing resource pHSFHIRObj
/// in a FHIR Bundle and then calls AddOperationOutcomeToBundle to add
/// the OperationOutcome.
Method AddOperationOutcomeToResource(ByRef pHSFHIRObj As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tBundle = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle).%New()
		
		Set tSC = tBundle.SetEntry(pHSFHIRObj) Quit:$$$ISERR(tSC)
		Do tBundle.SetTotal(1)
		
		Kill pHSFHIRObj
		
		Set pHSFHIRObj = tBundle.%ConstructClone(1)
		
		Kill tBundle
		
		Set tSC = ..AddOperationOutcomeToBundle(.pHSFHIRObj)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Add an OperationOutcome resource to an existing FHIR Bundle.
Method AddOperationOutcomeToBundle(ByRef pHSFHIRObj As HS.FHIR.vDSTU2.Model.Resource.Bundle) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tOperationOutcome = ##class(HS.FHIR.vDSTU2.Model.Resource.OperationOutcome).%New()
		
		For tIndex = 1:1:..Errors.Errors.Count() {
			Set tIssue = ##class(HS.FHIR.vDSTU2.Model.Resource.OperationOutcome.Issue).%New()
			Set tSC = tIssue.SetSeverity(..Errors.Errors.GetAt(tIndex).Severity) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetCode(..Errors.Errors.GetAt(tIndex).Code) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetDetails( , , , ..Errors.Errors.GetAt(tIndex).Description) Quit:$$$ISERR(tSC)
			Set tSC = tOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = pHSFHIRObj.SetEntry(tOperationOutcome)
		If $$$ISERR(tSC) Quit
		Set tSC = pHSFHIRObj.SetTotal((pHSFHIRObj.total+1))
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

}
