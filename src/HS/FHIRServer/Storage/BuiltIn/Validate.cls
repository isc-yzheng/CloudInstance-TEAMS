Include HS.FHIRServer

Class HS.FHIRServer.Storage.BuiltIn.Validate Extends (%RegisteredObject, HS.FHIRServer.Util.Bundle, HS.FHIRServer.Util.FHIRQueryUtils)
{

/// @API Enumerate the name and url of each Operation supported by this class
ClassMethod AddSupportedOperations(pMap As %DynamicObject)
{
	Do pMap.%Set("validate", "http://hl7.org/fhir/OperationDefinition/Resource-validate")
}

ClassMethod FHIRTypeOpValidate(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, ByRef pResponse As HS.FHIRServer.API.Data.Response)
{
	Do ..FHIRInstanceOpValidate(pService, pRequest, pResponse)
}

ClassMethod FHIRInstanceOpValidate(pService As HS.FHIRServer.API.Service, pRequest As HS.FHIRServer.API.Data.Request, ByRef pResponse As HS.FHIRServer.API.Data.Response)
{
	Set resourceType = pRequest.Type
	Set resourceId = pRequest.Id
	
	#dim payload as %DynamicObject = ..EnsureParameterPayload(pRequest)
	
	Do ..GetParameters(payload, .params)
	if $D(params("profile")) {
		$$$ThrowFHIR($$$HSFHIRErrProfileValidationNotSupported,$$$OutcomeInvalid(400))
	}

	Set mode = $Get(params("mode", 1))
	if mode '= "" {
		Set mode = mode.valueCode
	}
	if (resourceId = "") {
		if ((mode = "delete") || (mode = "update")) {
			$$$ThrowFHIR($$$HSFHIRErrBadValidateMode, mode, "Type", $$$OutcomeInvalid(400))
		} 
	} else {
		if (mode = "create") || (mode="") {
			$$$ThrowFHIR($$$HSFHIRErrBadValidateMode, mode, "Instance", $$$OutcomeInvalid(400))
		} 
	}
	

	Set resourceCount = $Get(params("resource"), 0)
	Set resource = ""	
	if (mode '= "delete") {
		if ( resourceCount '= 1) {
			$$$ThrowFHIR($$$HSFHIRErrSingleResourceRequired, pRequest.OperationName, $$$OutcomeInvalid(400))
		} else {
			Set resource = params("resource", 1).resource
		}
	} else {
		if ( resourceCount '= 0 ) {
			$$$ThrowFHIR($$$HSFHIRErrSingleResourceRequired, pRequest.OperationName, $$$OutcomeInvalid(400))
		}
	}
	Set status = $$$OK
	try {
		Do pService.resourceValidator.ValidateResource(resource)
		if mode = "create" {
			If (resource.resourceType '= resourceType) {
				$$$FHIRAddError(status, $$$ERROR($$$HSFHIRErrPayloadTypeMismatch, resource.resourceType, resourceType, $$$OutcomeInvalid(400)))
			}
		} elseif mode = "update" {
			If (resource.resourceType '= resourceType) {
				$$$FHIRAddError(status, $$$ERROR($$$HSFHIRErrPayloadTypeMismatch, resource.resourceType, resourceType, $$$OutcomeInvalid(400)))
			}
			if (resource.Id = "") || (resource.Id '= resourceId) {
				$$$ThrowFHIR($$$HSFHIRErrInvalidUpdateId, $$$OutcomeInvalid(400))
			}
			
		} elseif mode = "delete" {
		} elseif mode '= "" {
			$$$FHIRAddError(status, $$$ERROR($$$HSFHIRErrInvalidParameterValue, "mode", mode, $$$OutcomeInvalid(400)))
		}	
	} catch ex {
		$$$FHIRAddError(status, ex.AsStatus())
	}
	if $$$ISOK(status) {
		Set pResponse.Json = ##class(HS.FHIRServer.Util.Outcome).Create("information", "All OK", "informational")
	} else {
		Set pResponse.Json = ##class(HS.FHIRServer.Util.Outcome).CreateFromStatus(status, .httpStatus)
	}
	set pResponse.Status = 200
}

ClassMethod EnsureParameterPayload(pRequest As HS.FHIRServer.API.Data.Request) As %DynamicObject
{
	// If the body is a Parameters resource, then we parse it into our request.
	#dim payload As %DynamicObject = pRequest.Json 
	if (payload = "") {
		$$$ThrowFHIR($$$HSFHIRErrOperationPayloadMissing, pRequest.OperationName, $$$OutcomeInvalid(400))
	}
	if payload.resourceType '= "Parameters" {
		// Create a Parameter Entry for the resource
		#dim entry As %DynamicObject = $$$NewJSONObject
		Set entry.name = "resource"
		set entry.resource = payload
		
		// Create a new Parameters object and add the entry
		Set payload = $$$NewJSONObject
		Set payload.resourceType = "Parameters"
		Set payload.parameter = $$$NewJSONArray
		Do payload.parameter.%Push(entry)
	}
	return payload
}

ClassMethod GetParameters(pParameters As %DynamicObject, Output data)
{
	Set iter = pParameters.parameter.%GetIterator()
	while iter.%GetNext(.subsc, .entry) {
		Set data(entry.name, $I(data(entry.name))) = entry
	}
}

}
