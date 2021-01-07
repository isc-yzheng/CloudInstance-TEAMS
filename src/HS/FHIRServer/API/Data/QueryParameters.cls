Include HS.FHIRServer

Class HS.FHIRServer.API.Data.QueryParameters Extends %ListOfObjects
{

/// Map from property name to list of indices in the array
Property params As list Of HS.FHIRServer.API.SearchQueryParameter [ Private ];

/// Status from converting a query string indicating any invalid parameters.
/// This can be used to build an OperationOutcome depending on handling
Property status As %Status;

ClassMethod CreateFromCSPRequest(pRequest As %CSP.Request) As HS.FHIRServer.API.Data.QueryParameters
{
	#dim result as HS.FHIRServer.API.Data.QueryParameters = ##class(HS.FHIRServer.API.Data.QueryParameters).%New()
	set name=""
	for {
		Set name = $Order(pRequest.Data(name))
		Quit:name=""

		// RFC 6750
		// https://tools.ietf.org/html/rfc6750#section-2.2
		// https://tools.ietf.org/html/rfc6750#section-2.3
		// An OAuth access token may be sent in the form encoded body or in the request URI as a
		// name-value pair named "access_token". In these cases, silently prevent that parameter
		// from being added to the query parameters collection.
		If name = "access_token" {
			Continue
		}
		
		Set ix=""
		for {
			Set ix = $Order(pRequest.Data(name,ix),1,value)
			Quit:ix=""
			Do result.AddParameter( ##class(HS.FHIRServer.API.SearchQueryParameter).%New(name, value) )
		}
	}
	return result
}

/// @Param pKeepSearchOnly  If true, do not include non-search parameters
ClassMethod CreateFromQueryString(pParametersString As %String, pSchema As HS.FHIRServer.Schema = "", pResourceType As %String = "", pKeepSearchOnly As %Boolean = 0) As HS.FHIRServer.API.Data.QueryParameters
{
	Set tErrStatus = $$$OK
	#dim result as HS.FHIRServer.API.Data.QueryParameters = ##class(HS.FHIRServer.API.Data.QueryParameters).%New()
	Set tResourceType = $Select(pResourceType="":"Resource", 1: pResourceType)
	For i = 1:1:$Length(pParametersString,"&") {
		Set tP = $Piece(pParametersString,"&",i)
		If tP'="" {
			// Split Name from Value
			Set nameAndMod = $Piece(tP,"=",1)
			Set value = $ZConvert($Piece(tP,"=",2,*), "I","URL")
			if $Find(nameAndMod,".") {
				Set newParam = ..createChainedParam(nameAndMod, value, pSchema, tResourceType, .tErrStatus)
				if newParam '= "" {
					//Set newParam.value = value
					Do result.AddParameter(newParam)
				}
				Continue
			}
			Set name = $Piece(nameAndMod, ":", 1)
			Set modifier = $Piece(nameAndMod, ":", 2,*)
			if name = "_has" {
				Set newParam = ..createRevChainedParam(modifier, value, pSchema, tResourceType, .tErrStatus)
				Continue:(newParam="")
			} else {
				Set searchParam = ""
				if pSchema '= "" {
					if pSchema.IsNonSearchParam(name) {
						if pKeepSearchOnly {
							// We've been asked to skip non-search parameters. Do Nothing.
							Continue 
						}
					} else  {
						Set searchParam = pSchema.FindSearchParam(tResourceType, name)
						if searchParam = "" {
							// TODO:  Neither search or non-search ... must be invalid
							$$$FHIRAddError(tErrStatus, $$$ERROR($$$HSFHIRErrParameterNotSupported,name,value, $$$OutcomeInvalid(400)))
							Continue
						}
					}
				}
				Set newParam = ##class(HS.FHIRServer.API.SearchQueryParameter).%New(name, value, modifier, searchParam)
			}
			Do result.AddParameter(newParam)

		}
	}
	Set result.status = tErrStatus
	return result
}

ClassMethod createRevChainedParam(nameAndMod As %String, value As %String, pSchema As HS.FHIRServer.Schema, pResourceType As %String, ByRef pErrStatus) As HS.FHIRServer.API.SearchQueryParameter
{
	#dim searchParam as HS.FHIRServer.SearchParam
	#dim result as HS.FHIRServer.API.SearchQueryParameter = ""
	#dim queryParam as HS.FHIRServer.API.SearchQueryParameter = ""
	Set curHas = nameAndMod
	Set targetType = pResourceType
	for {
		Set sourceType = $Piece(curHas, ":", 1)
		Set refParamName = $Piece(curHas, ":", 2)

		// This is another step in the chain
		// Build a stage
		Set searchParam = pSchema.FindSearchParam(sourceType, refParamName)
		if searchParam = "" {
			// TODO:  Neither search or non-search ... must be invalid
			$$$FHIRAddError(pErrStatus, $$$ERROR($$$HSFHIRErrInvalidQueryParameter, sourceType, refParamName, $$$OutcomeInvalid(400)))
			return ""
		}
		if $ListFind(searchParam.target, targetType) = 0 {
			$$$FHIRAddError(pErrStatus, $$$ERROR($$$HSFHIRErrInvalidReferencedType, targetType, refParamName, sourceType, $$$OutcomeInvalid(400)))
			return ""
		}
		Set queryParam = ##class(HS.FHIRServer.API.SearchQueryParameter).%New(refParamName, targetType,, searchParam)
		Set queryParam.nextInRevChain = result
		Set result = queryParam


		Set nameAndMod = $Piece(curHas, ":", 3)
		if (nameAndMod '= "_has") {
			set curHas = $Piece(curHas, ":", 3, *)
			Quit
		}
		Set targetType = sourceType
		Set curHas = $Piece(curHas, ":", 4, *)
	}
	Set name = $Piece(curHas, ":", 1)
	Set modifier = $Piece(curHas, ":", 2)
	Set searchParam = pSchema.FindSearchParam(sourceType, name)
	if searchParam = "" {
		// TODO:  Neither search or non-search ... must be invalid
		$$$FHIRAddError(pErrStatus, $$$ERROR($$$HSFHIRErrInvalidQueryParameter, sourceType, name, $$$OutcomeInvalid(400)))
		return ""
	}
	Set queryParam = ##class(HS.FHIRServer.API.SearchQueryParameter).%New(name, value,modifier, searchParam)
	Set queryParam.nextInRevChain = result
	Set result = queryParam
	return result
}

ClassMethod createChainedParam(nameAndMod As %String, value As %String, pSchema As HS.FHIRServer.Schema, pResourceType As %String, ByRef pErrStatus) As HS.FHIRServer.API.SearchQueryParameter [ Private ]
{
	Set result = ""
	Set endOfChain = ""
	Set tResourceType = pResourceType
	Set linkCount = $length(nameAndMod, ".")
	for ord=1:1:linkCount {
		Set link = $Piece(nameAndMod, ".", ord)
		//w !,"link: ", link,!
		Set name = $Piece(link, ":", 1)
		Set modifier = $Piece(link, ":", 2)
		Set searchParam = pSchema.FindSearchParam(tResourceType, name)
		if searchParam = "" {
			// TODO:  Neither search or non-search ... must be invalid
			$$$FHIRAddError(pErrStatus, $$$ERROR($$$HSFHIRErrInvalidQueryParameter, tResourceType, name, $$$OutcomeInvalid(400)))
			Quit
		}
		
		if ( ord '= linkCount) {
			if (searchParam.type '= "reference") {
				// All Intermediate Links MUST be of type 'reference'
				$$$FHIRAddError(pErrStatus, $$$ERROR($$$HSFHIRErrInvalidChainLink, tResourceType, name, $$$OutcomeInvalid(400)))
				Quit
			}
			if modifier '= "" {
				// The parameter is declaring the target type, ensure that the reference can be to that type
				if '$ListFind(searchParam.target, modifier) {
					$$$FHIRAddError(pErrStatus, $$$ERROR($$$HSFHIRErrInvalidReferenceTarget, modifier, name, tResourceType, $LTS(searchParam.target), $$$OutcomeInvalid(400)))
					Quit
				}
			} else {
				if $LL(searchParam.target) '= 1 {
					$$$FHIRAddError(pErrStatus, $$$ERROR($$$HSFHIRErrAmbiguousReferenceTarget, name, tResourceType, $LTS(searchParam.target), $$$OutcomeInvalid(400)))
					Quit
				}
				set modifier = $ListGet(searchParam.target)
			}
		}
		Set newParam = ##class(HS.FHIRServer.API.SearchQueryParameter).%New(name, "", modifier, searchParam)
		if endOfChain = "" {
			Set endOfChain = newParam
			Set result = newParam
		} else {
			Set endOfChain.nextInChain = newParam
			Set endOfChain = newParam
		}
		Set tResourceType = modifier

	}
	Set:$$$ISOK(pErrStatus) endOfChain.value = value
	return result
}

Method AddParameter(entry As HS.FHIRServer.API.SearchQueryParameter)
{
	Do ..Insert(entry)
}

Method RemoveParameter(entry As HS.FHIRServer.API.SearchQueryParameter)
{
	Set entryIndex = ..FindEntryIndex(entry)
	if entryIndex '= 0 {
		Do ..RemoveAt(entryIndex)	
	}
}

Method GetParameters(name As %String, Output params)
{
	Set params = 0

	for ord=1:1:..Count() {
		Set e = ..GetAt(ord)
		if (e.name = name)  {
			Set params($I(params)) = e
		}
	}
}

/// GetParameterCount returns the number of instances of a given parameter.
/// Each instance may have a modifier or not
Method GetParameterCount(pParamName As %String) As %Integer
{
	Do ..GetParameters(pParamName, .params)
	Set count = params
	kill params
	return count
}

/// GetParameter returns the value of a specified parameter instance,
/// plus any parameter modifier.  Parameter modifier in FHIR is expressed
/// as a colon-delimited suffix on the parameter name (not value), for
/// example family:exact=jones.
/// An exception is thrown if more than one value is present.
Method GetOneParameterValue(pParamName As %String, ByRef pModifier As %String) As %String
{
	Set value = ""
	Do ..GetParameters(pParamName, .params)
	if params > 1 {	
		$$$ThrowFHIR($$$HSFHIRErrMultipleParameters, pParamName, $$$OutcomeInvalid(400))
	}
	if params = 1 {
		Set pModifier = params(1).modifier
		set value = params(1).value
	}
	return value
}

/// GetParameter returns the value of a specified parameter instance,
/// plus any parameter modifier.  Parameter modifier in FHIR is expressed
/// as a colon-delimited suffix on the parameter name (not value), for
/// example family:exact=jones.
Method GetParameterValue(pParamName As %String, pPosition As %Integer = 1, ByRef pModifier As %String) As %String
{
	Set pModifier = ""
	Set value = ""
	
	Do ..GetParameters(pParamName, .params)
	if (pPosition > 0) && (pPosition <= params) {
		Set value = params(pPosition).value
		Set pModifier = params(pPosition).modifier
	}
	kill params
	return value
}

Method FindEntryIndex(entry As HS.FHIRServer.API.SearchQueryParameter) As %Integer
{
	for ord=1:1:..Count() {
		Set e = ..GetAt(ord)
		if (e.name = entry.name) && (e.value = entry.value) && (e.modifier = entry.modifier) {
			return ord
		}
	}
	return 0
}

Method AsString()
{
	Set prefix = ""
	Set str = ""
	for ord=1:1:..Count() {
		Set e = ..GetAt(ord)
		Set str = str _ prefix _ e.AsString()
		Set prefix = "&"
	}
	return str
}

/// This method builds QueryParameters object that contains only known search parameters
/// If there are no FHIR SearchParams named, then it returns null ("")
Method ExtractSearchParameters() As HS.FHIRServer.API.Data.QueryParameters
{
	#dim result as HS.FHIRServer.API.Data.QueryParameters = ""
	#dim  tSearchParameters as HS.FHIRServer.API.Data.QueryParameters = ..%New()
	// Remove non-search keys from the list of parameters, just to make sure that
	// there are actual search criteria specified.
	Set tKey = ""
	for ord = 1:1:..Count() {
		#dim param as HS.FHIRServer.API.SearchQueryParameter = ..GetAt(ord)
		if param.searchParam '= "" {
			do tSearchParameters.AddParameter(param)
			Set result = tSearchParameters
		}
	}
	return result
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

Storage Default
{
<Data name="QueryParametersState">
<Value name="1">
<Value>params</Value>
</Value>
</Data>
<State>QueryParametersState</State>
<StreamLocation>^HS.FHIRSer26D2.QueryParame3E2ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
