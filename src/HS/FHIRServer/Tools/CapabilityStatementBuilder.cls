Include HS.FHIRServer

Class HS.FHIRServer.Tools.CapabilityStatementBuilder [ Abstract ]
{

/// Name in the HTTP Service Registry for obtaining the OAuth2 Issuer URL
/// The 'security' entry will not be built if this service is not registered.
Parameter OAuthIssuerServiceName As %String = "OAuth2.Issuer";

ClassMethod test(schema As HS.FHIRServer.Schema, pType As %String)
{
	set pXname = $classname() _ "||R3Default"
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId(pXname, .tSC)
	$$$ThrowOnError(tSC)
	Set pParams = ##class(%DynamicObject).%FromJSON(tXDataObj.Data)
	Set rsrc = ..buildRestEntry(schema, pParams)
	w $$$FormatJSON(rsrc),!
}

/// Update Only the search parameters for a CapabilityStatement
ClassMethod UpdateSearchParams(pAppKey As %String, ByRef pChanged)
{
	#dim strategy as HS.FHIRServer.API.InteractionsStrategy= ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(pAppKey)
	#dim interactions as HS.FHIRServer.API.Interactions = strategy.NewInteractionsInstance()
	set metadata = interactions.LoadMetadata()
	if '$isobject(metadata) || '$isobject(metadata.rest) || (metadata.rest.%Size() = 0) {
		quit
	}
	//Get the rest object that contains the server resource definitions
	set rest = ""
	set restIter = metadata.rest.%GetIterator()
	while restIter.%GetNext(, .tempRest) {
		if (tempRest.mode = "server") && (tempRest.resource.%Size '= 0) {
			set rest = tempRest
			quit
		}
	}
	if rest = "" {
		quit
	}
	
	set schema = strategy.schema
	set iter = rest.resource.%GetIterator()
	while iter.%GetNext(, .resource) {
		if $data(pChanged(resource.type)) {
			set paramKey = ""
			for {
				set paramKey = $order(pChanged(resource.type, paramKey))
				quit:paramKey=""
				set oldValue = pChanged(resource.type, paramKey)
				set newValue = schema.FindSearchParam(resource.type, paramKey)
				
				//Add
				if oldValue = "" {
					Set sentry = $$$NewJSONObject
					Set sentry.name = paramKey
					Set sentry.type = newValue.type
					Do resource.searchParam.%Push(sentry)
					
					if sentry.type = "reference" {
						Set qname = resource.type _ "." _ paramKey
						Do resource.searchInclude.%Push(qname)
					}
				}
				else {
					//Get the relevant existing search parameter
					set sp = ""
					set spIter = resource.searchParam.%GetIterator()
					while spIter.%GetNext(.spIndex, .tempSp) {
						if tempSp.name = paramKey {
							set sp = tempSp
							quit
						}
					}
					if sp = "" {
						quit
					}
					
					set si = ""
					set siIter = resource.searchInclude.%GetIterator()
					while siIter.%GetNext(.siIndex, .tempSi) {
						if tempSi = (resource.type _ "." _ paramKey) {
							set si = tempSi
							quit
						}
					}
					
					//Update
					if newValue '= "" {
						Set sp.name = paramKey
						Set sp.type = newValue.type
						if (sp.type = "reference") && (si = "") {
							Do resource.searchInclude.%Push(resource.type _ "." _ paramKey)
						}
						if (sp.type '= "reference") && (si '= "") {
							do resource.searchInclude.%Remove(siIndex)
						}
					}
					//Delete
					else {
						do resource.searchParam.%Remove(spIndex)
						if si '= "" {
							do resource.searchInclude.%Remove(siIndex)
						}
					}
				}
			}
		}
	}
	
	do interactions.SetMetadata(metadata)
}

/// @API
/// Creates a CapabilityStatment using a schema, config object, and a CapabilityStatement resource template.
/// Example XData blocks can be found in HS.FHIRServer.Tools.CapabilityTemplate, along with documentation
/// on how to modify them to change the capability definitions.
ClassMethod Build(schema As HS.FHIRServer.Schema, pRsrcObj As %DynamicObject, pConfigObj As %DynamicObject) As %DynamicObject
{
	Set pRsrcObj.fhirVersion = schema.FHIRVersion
	// In case the base is v3.0, remove a dropped properties
	if (+ $E(schema.FHIRVersion)) >= 4 {
		Do pRsrcObj.%Remove("acceptUnknown")	
	}
	Do pRsrcObj.rest.%Push(..buildRestEntry(schema, pConfigObj))
	return pRsrcObj
}

ClassMethod buildRestEntry(schema As HS.FHIRServer.Schema, pConfigObj As %DynamicObject)
{
	// This array is built as we add resources to the Capability statement.  At the end
	// it will have the full set of cross-references for the included resource types
	kill %FHIRServerRevIncludes
		// Get list of excluded search parameters
	set includeAll = 1
	if (pConfigObj.resourceList '="") && (pConfigObj.resourceList.%Size() > 0) {
		set includeAll = 0
		Set iter = pConfigObj.resourceList.%GetIterator()
		while iter.%GetNext(.subsc, .name) {
			set included(name) = 1
		}
	}
	zw included
	Set rest = $$$NewJSONObject
	Set rest.mode = "server"
	// Build a Security property (if OAuth is enabled)
	Set security = ..buildSecurityEntry()
	if $IsObject(security) {
		Set rest.security = security
	}
	Set resources = $$$NewJSONArray
	Set rest.resource = resources
	Set commonRsrc = ..buildResourceEntry(schema, "Resource", pConfigObj)
	Set rest.interaction = commonRsrc.interaction
	Set rest.searchParam = commonRsrc.searchParam
	
	Set resourceType = ""
	for {
		Set resourceType = schema.NextSearchParamResourceType(resourceType)
		Quit:resourceType=""
		Continue:resourceType="Resource"
		if ('includeAll && (' $Get(included(resourceType),0))) {
			Continue
		}
		Do resources.%Push( ..buildResourceEntry(schema, resourceType, pConfigObj) )
	}
	
	// Now add the reverse includes
	Set iter = rest.resource.%GetIterator()
	while iter.%GetNext(.subsc, .restItem) {
		Set resourceType = restItem.type
		Set revIncludes = $$$NewJSONArray
		// Include references to this specific type
		Set paramName = ""
		for {
			Set paramName = $Order(%FHIRServerRevIncludes(resourceType, paramName))
			Quit:paramName=""
			
			Do revIncludes.%Push(paramName)
		}
		Set paramName = ""
		for {
			Set paramName = $Order(%FHIRServerRevIncludes("Resource", paramName))
			Quit:paramName=""
			
			Do revIncludes.%Push(paramName)
		}
		if revIncludes.%Size() '= 0 {
			Set restItem.searchRevInclude = revIncludes	
		}
	}
	
	// Now add the operations
	// Determine how to emit the URL
	Set preR4 = (+ $E(schema.FHIRVersion)) < 4 
	Set operations = $$$NewJSONArray
	Set iter = pConfigObj.operations.%GetIterator()
	while iter.%GetNext(.opname, .opurl) {
		Set opObj = $$$NewJSONObject
		Set opObj.name = opname
		if preR4 {
			Set ref = $$$NewJSONObject
			Set opObj.definition = ref
			Set ref.reference = opurl
		} else {
			// Starting with R4, this is no longer a "reference" type
			Set opObj.definition = opurl	
		}
		Do operations.%Push(opObj)
	}
	if operations.%Size() > 0 {
		Set rest.operation = operations
	}
	
	// We are done with this, don't leave droppings
	kill %FHIRServerRevIncludes
	return rest
}

ClassMethod buildSecurityEntry() As %DynamicObject
{
	Set authorizeURL = ""
	Set tokenURL = ""
	Set oauthServiceEntry = ##class(HS.Registry.Service.Abstract).EndPointForNameType(..#OAuthIssuerServiceName, "HTTP")
	If $IsObject(oauthServiceEntry) {
		// There is a Service Registry Entry for the OAuth issuer endpoint
		Set issuerURL = oauthServiceEntry.EndPoint
		kill tOAuthService
		// Lookup the OAuth Server Definition (in %SYS)
		Set tNS = $Namespace
		Set $Namespace = "%SYS"
		Set serverDef = ##class(OAuth2.ServerDefinition).OpenByIssuer(issuerURL, .tSC)
		if $IsObject(serverDef) {
			// The OAuth server told us about its endpoints.
			Set authorizeURL = serverDef.AuthorizationEndpoint
			Set tokenURL = serverDef.TokenEndpoint
		}
		Set $Namespace = tNS
	}
	if (authorizeURL = "") || (tokenURL = "" )
	{
		return ""
	}
	
	// We have the information necessary to build this entry.
	Set security = $$$NewJSONObject
	Do security.%Set("cors", 1, "boolean")
	
	Set uriExtn = ..AddExtension(security, "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris")
	Do ..AddExtension(uriExtn, "authorize", "valueUri", authorizeURL)
	Do ..AddExtension(uriExtn, "token", "valueUri", tokenURL)
	
	Set security.service = [{
		"coding": [{ 
			"system": "http://hl7.org/fhir/restful-security-service",
			"code": "SMART-on-FHIR",
			"display": "SMART-on-FHIR"
		}]
	}]
	
	return security
}

ClassMethod AddExtension(obj As %DynamicObject, url As %String, valueKey As %String = "", value = "", valuejt As %String = "string") As %DynamicObject
{
	Set array = obj.extension
	if '$IsObject(array) {
		Set array = $$$NewJSONArray
		Set obj.extension = array
	}
	Set extn = $$$NewJSONObject
	Do array.%Push(extn)
	Set extn.url = url
	if (valueKey '= "") && (value '= "") {
		Do extn.%Set(valueKey, value, valuejt)	
	}
	return extn
}

ClassMethod buildResourceEntry(schema As HS.FHIRServer.Schema, pType As %String, pConfigObj As %DynamicObject) As %DynamicObject
{
	Set rsrc = $$$NewJSONObject
	Set rsrc.type = pType
	// Specify the options
	Do ..setOption( rsrc, "versioning", pConfigObj)
	Do ..setOption( rsrc, "readHistory", pConfigObj, "boolean")
	Do ..setOption( rsrc, "updateCreate", pConfigObj, "boolean")
	Do ..setOption( rsrc, "conditionalCreate", pConfigObj, "boolean")
	Do ..setOption( rsrc, "conditionalRead", pConfigObj)
	Do ..setOption( rsrc, "conditionalUpdate", pConfigObj, "boolean")
	Do ..setOption( rsrc, "conditionalDelete", pConfigObj)
	
	// Build the Interactions array
	Set interactionSpec = ..getValue(rsrc.type, "interactions", pConfigObj)
	Set rsrc.interaction = $$$NewJSONArray
	Set iter = interactionSpec.%GetIterator()
	while iter.%GetNext(.subsc, .value) {
		Set ientry = $$$NewJSONObject
		Set ientry.code = value
		Do rsrc.interaction.%Push(ientry)	
	}

	// Build the search parameters
	Set searchParams = $$$NewJSONArray
	Set searchInclude = $$$NewJSONArray
	Set rsrc.searchParam = searchParams
	Set rsrc.searchInclude = searchInclude
	// Get list of excluded search parameters
	if pConfigObj.paramExclude '="" {
		Set iter = pConfigObj.paramExclude.%GetIterator()
		while iter.%GetNext(.subsc, .name) {
			set excluded(name) = 1
		}
	}
	
	// Walk the Schema
	Set searchParam = ""
	for {
		#dim searchParam as HS.FHIRServer.SearchParam
		Set searchParam = schema.NextSearchParamForResourceType(pType, searchParam)
		Quit:searchParam=""
		
		set paramName = searchParam.code
		
		Set qname = pType _ "." _ paramName
		if ($get(excluded(qname),0)) {
			// Skip excluded search parameters
			Continue
		}
		Set sentry = $$$NewJSONObject
		Set sentry.name = paramName
		Set sentry.type = searchParam.type
		Do searchParams.%Push(sentry)
		
		if searchParam.type = "reference" {
			Do searchInclude.%Push(qname)
			// Now calculate reverse includes
			for tord=1:1:$LL(searchParam.target) {
				Set %FHIRServerRevIncludes($LG(searchParam.target, tord), qname) = ""
			}
		}
	}
	return rsrc
}

ClassMethod setOption(pRsrc As %DynamicObject, name As %String, pConfigObj As %DynamicObject, pValType As %String = "string")
{
	Set value = ..getValue(pRsrc.type, name, pConfigObj)
	Do pRsrc.%Set(name, value, pValType)
}

ClassMethod getValue(pType As %String, name As %String, pConfigObj As %DynamicObject)
{
	Set value = pConfigObj.resourceDefaults.%Get(name)
	Set override = pConfigObj.resourceOverrides.%Get(pType)
	if override'="" {
		Set ov = override.%Get(name)
		if ov'="" {
			Set value = ov
		}
	}
	return value
}

}
