Include HS.FHIRServer

/// Helper Class that creates OperationOutcome resources as directed
/// This is take from the equivalent methods in HS.FHIR.Util, but it creates
/// a JSON resource rather than emitting to a stream.
Class HS.FHIRServer.Util.Outcome [ Abstract ]
{

/// CreateOperationOutcomeStream creates a FHIR OperationOutcome resource stream using the specified inputs.
ClassMethod Create(pSeverity As %String, pText As %String, pCode As %String = "", pExpression As %String = "") As %DynamicObject
{
	// Verify valid inputs
	If $Get(pSeverity)="" {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "OperationOutcome issue severity not specified"))
	} ElseIf $Get(pCode)="" {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "OperationOutcome issue code not specified"))
	}
	
	// From StartOutcomeStream()
	Set outcome = ##class(%DynamicObject).%New()
	Set outcome.resourceType = "OperationOutcome"
	Set issues = ##class(%DynamicArray).%New()
	Set outcome.issue = issues
	
	// From AddOutcomeIssueStream()
	Set issue = ##class(%DynamicObject).%New()
	Do issues.%Push(issue)
	
	Set issue.severity = pSeverity
	Set issue.code = pCode
	if pText '= "" {
		Set issue.diagnostics = pText
		
		// Put the text in the details.text slot as well
		Set details = $$$NewJSONObject
		Set issue.details = details
		Set details.text = pText
	}
	if pExpression'="" {
		Set issue.expression = $$$NewJSONArray
		Do issue.expression.%Push(pExpression)
	}
	Return outcome
}

/// CreateOperationOutcomeStream creates a FHIR OperationOutcome resource stream using the specified inputs.
ClassMethod CreateFromStatus(pStatus As %Status, Output httpStatus = "") As %DynamicObject
{
	Set tErrors = 0
	Do $system.Status.DecomposeStatus(pStatus, .tErrors)
	//zw tErrors
	
	// First check for a request to just return an HTTP status with no OperationOutcome
	// This is identified by a throw of a $$$HSFHIRErrHttpOnlyResponse
	if tErrors(1, "code") = $$$HSFHIRErrHttpOnlyResponse {
		Set httpStatus = +$Piece($Get(tErrors(1,"param",1),500),"|",2)
		Return ""
	}
	
	// From StartOutcomeStream()
	Set outcome = $$$NewJSONObject
	Set outcome.resourceType = "OperationOutcome"
	Set issues = $$$NewJSONArray
	Set outcome.issue = issues
	
	Set tIndexStart = 1
	if tErrors(1, "code") = $$$HSFHIRErrValidationFailure {
		Set tIndexStart = 2
		Set httpStatus = 400
	}
	// From AddOutcomeIssueStream()
	Set severity = "error"
	Set outcomeCode = "invalid"
	for tIndex = tIndexStart:1:tErrors {
		Set statusCode = tErrors(tIndex, "code")
		Set paramCount = $Get(tErrors(tIndex,"param"),0)
		Set outcomeInfo = ""
		for vbar=1:1:paramCount { 
			if $E($Get(tErrors(tIndex,"param",vbar))) = "|"  {
				Set outcomeInfo = $E(tErrors(tIndex,"param",vbar),2,*)
				Quit
			}
		}
		// Get the http-code, severity, code, text, and one expression
		Set errorText = $system.Status.GetOneStatusText(pStatus, tIndex)
		Do ..MapStatusCode(statusCode, .tempStatus , .outcomeCode)
		if tIndex=1 {
			Set httpStatus = tempStatus
		}
		// If overrides are present in the status, then use them
		Set expression = ""
		if outcomeInfo '= "" {	
			// We have Outcome parameters in the status
			if tIndex=1 {
				// Take the HTTP code from the first status
				Set tmp = $Piece(outcomeInfo,"|",1)
				if tmp'="" {
					Set httpStatus = +tmp
				}
			}
			Set tmp = $Piece(outcomeInfo,"|",2)
			if tmp'="" {
				Set severity = tmp
			}
			Set tmp = $Piece(outcomeInfo,"|",3)
			if tmp'="" {
				Set outcomeCode = tmp
			}

			Set tmp = $Piece(outcomeInfo,"|",4,*)
			if tmp'="" {
				Set expression = tmp
			}
		}

		Set issue = ##class(%DynamicObject).%New()
		Do issues.%Push(issue)
		
		Set issue.severity = severity
		Set issue.code = outcomeCode
		Do issue.%Set("diagnostics", tErrors(tIndex, "code"), "string")
		
		Set issue.details = $$$NewJSONObject
		Set issue.details.text = errorText
		
		If expression'="" {
			Set issue.expression = $$$NewJSONArray
			Do issue.expression.%Push(expression)
		}
		
		if (tIndex=1) && $Get(%FHIRDebugIncludeTracebacks) {
			Set stack = tErrors(tIndex,"stack")
			Set issue.location = $$$NewJSONArray
			set level = 2
			Set prefix = "at "
			for level=2:1 {
				set line = $ListGet(stack, level)
				quit:line=""
				quit:$Piece(line,"^",4)=0
				
				Set fn = $Piece(line,"^",2)
				Set cls = $Piece(line,"^",3)
				Do issue.location.%Push(prefix_fn_" in "_cls)
				Set prefix = "from "
			}
			
		}
	}
	
	Return outcome
}

ClassMethod MapStatusCode(statusCode As %String, Output httpCode As %Integer, Output outcomeCode As %String)
{
	Do ..InitHttpToStatusData()
	Set httpCode = $Get(%FHIRServerStatusMap(statusCode), 500)
	Set outcomeCode = $Get(%FHIRServerStatusMap(httpCode), "exception")
	//$$$FSLog("status: "_statusCode_", http: "_httpCode_", outcome: "_outcomeCode)
}

ClassMethod InitHttpToStatusData() [ Private ]
{
	Quit:$Get(%FHIRServerStatusMap,0)=1
	Set %FHIRServerStatusMap=1
	// Map OutcomeCode from HttpStatus
	Do MapO(404, "not-found")
	Do MapO(400, "invalid")
	Do MapO(406, "not-supported")
	Do MapO(503, "operation")
	
	// Map HttpStatus from ErrorCodes
	Do MapH(400, $$$HSFHIRErrAPIContractViolation)
	Do MapH(400, $$$HSFHIRErrInteractionNotSupported)
	Do MapH(400, $$$HSFHIRErrInteractionsNotSupported)
	Do MapH(400, $$$HSFHIRErrInvalidQueryParameterValue)
	Do MapH(400, $$$HSFHIRErrConditionalUpdateNotSupported)
	Do MapH(400, $$$HSFHIRErrConditionalDeleteNotSupported)
	Do MapH(404, $$$HSFHIRErrResourceNotFound)
	Do MapH(404, $$$HSFHIRErrResourceNotSupported)
	Do MapH(404, $$$HSFHIRErrResourceNotInRepo)
	Do MapH(404, $$$HSFHIRErrResourceVersionNotFound)
	Do MapH(410, $$$HSFHIRErrResourceWasDeleted)
	Do MapH(412, $$$HSFHIRErrIfNoneExistsFoundMultiple)
	Do MapH(412, $$$HSFHIRErrConditionalUpdateFoundMultiple)
	Do MapH(412, $$$HSFHIRErrIfMatchDoesNotMatchResource)
	Do MapH(412, $$$HSFHIRErrConditionalDeleteOfMultipleNotSupported)
	Do MapH(412, $$$HSFHIRErrConditionalDeleteOverflow)
	Do MapH(503, $$$HSFHIRErrServiceDisabled)
	Quit
	
MapH(h,e)
	Set %FHIRServerStatusMap(e) = h
	Quit
	
MapO(h,o)
	Set %FHIRServerStatusMap(h) = o
	Quit
}

}
