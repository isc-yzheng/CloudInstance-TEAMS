Include HS.FHIRServer

Class HS.FHIRServer.Tools.ConfigEditor Extends HS.FHIRServer.Tools.ValueReader
{

Parameter spaces As %String = "                              ";

Method %OnNew(configData As %SerialObject) As %Status
{
	/*
	if $IsObject(configData) {
		Set ..configData = configData
	} else {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "configData must be an object"))
	}
	Set isNew = (configData.FHIRVersion = "")
	Set name = $classname(configData) _ "||metadata"
	if ('##class(%Dictionary.XDataDefinition).%ExistsId(name)) {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "TEST ERROR: Missing XData: "_name))
	}
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId(name)
	// Copy the JSON Stream to the output
	set ..configMeta =  ##class(%DynamicObject).%FromJSON(tXDataObj.Data)
	
	Set ..maxNameLength = 0
	Set ..configFields = $$$NewJSONObject
	Set iter = ..configMeta.%GetIterator()
	while iter.%GetNext(.subsc, .metaObj ) {
		Set name = metaObj.name
		if ..maxNameLength < $length(name) {
			Set ..maxNameLength = $length(name) 
		}
		Do ..configFields.%Set(name, metaObj)
		if isNew {
			Set $Property(..configData, name) = metaObj.default	
		}
	}
	*/
	return $$$OK
}

ClassMethod NewDefaultConfig() As HS.FHIRServer.API.ConfigData
{
	set configMeta = ..loadConfigMeta("ConfigData")
	Set configData = ##class(HS.FHIRServer.API.ConfigData).%New()
	Set iter = configMeta.%GetIterator()
	while iter.%GetNext(.subsc, .metaObj ) {
		Set name = metaObj.name
		Set $Property(configData, name) = metaObj.default	
	}
	return configData
}

ClassMethod loadConfigMeta(metaName As %String) As %DynamicArray
{
	Set name = $classname() _ "||" _ metaName
	if ('##class(%Dictionary.XDataDefinition).%ExistsId(name)) {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "TEST ERROR: Missing XData: "_name))
	}
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId(name)
	// Copy the JSON Stream to the output
	Return ##class(%DynamicArray).%FromJSON(tXDataObj.Data)
}

ClassMethod GetConfigFromKey(key As %String) As HS.Util.RESTCSPConfig
{
	#dim cspConfigObj as HS.Util.RESTCSPConfig = ""
	Set configClassname = "HS.FHIRServer.API.ConfigData"
	Set exists = ##class(HS.Util.RESTCSPConfig).URLIndexExists(key,.id)
	if exists {
		Set cspConfigObj = ##class(HS.Util.RESTCSPConfig).%OpenId(id)
	}
	return cspConfigObj
}

ClassMethod showCSPConfigs(pCspConfigObj As HS.Util.RESTCSPConfig, pServiceConfig As HS.FHIRServer.API.ConfigData)
{
	set configMeta =  ..loadConfigMeta("ConfigData")
	set cspConfigMeta =  ..loadConfigMeta("CSPConfigData")
	
	if $IsObject(pCspConfigObj) {
		w !,"-- CSP Application Configuration --",!
		Do ..showAll(pCspConfigObj, cspConfigMeta)
	}
	if pServiceConfig '= "" {
		w !,"-- FHIR Service Configuration --",!
		Do ..showAll(pServiceConfig, configMeta)
	}
}

ClassMethod editCSPConfigObj(pCspConfigObj As HS.Util.RESTCSPConfig) As %Boolean
{
	set cspConfigMeta =  ..loadConfigMeta("CSPConfigData")
	
	w !, "-- Edit CSP Application Configuration --",!
	return ..edit(pCspConfigObj, cspConfigMeta)
}

ClassMethod editServiceConfigObj(pServiceConfig As HS.FHIRServer.API.ConfigData) As %Boolean
{
	set configMeta =  ..loadConfigMeta("ConfigData")
	w !, "-- Edit FHIRService Configuration --",!
	return ..edit(pServiceConfig, configMeta)
}

ClassMethod edit(configData As %RegisteredObject, configMeta As %DynamicArray) As %Boolean
{
	Set changed = 0
	Set iter = configMeta.%GetIterator()
	while iter.%GetNext(.subsc, .metaObj ) {
		if metaObj.readOnly {
			Continue
		}
		set changed = (..editField(configData, metaObj) || changed)
	}
	Do:changed ..showAll(configData, configMeta)
	
	return changed
}

ClassMethod editField(configData As %RegisteredObject, metaObj As %DynamicObject) As %Boolean
{
	Set name = metaObj.name
	Set curValue = $property(configData, name)
	Set newValue = $Case( metaObj.type,
							"s":..readString(name, curValue),
							"i":..readNumber(name, curValue),
							"b":..readBoolean(name,curValue))
	Set $property(configData, name) = newValue
	Return (curValue '= newValue)
}

ClassMethod showAll(configData As %RegisteredObject, configMeta As %DynamicArray)
{
	Set maxNameLength = 0
	Set iter = configMeta.%GetIterator()
	while iter.%GetNext(.subsc, .metaObj ) {
		Set name = metaObj.name
		if maxNameLength < $length(name) {
			Set maxNameLength = $length(name) 
		}
	}

	Set iter = configMeta.%GetIterator()
	while iter.%GetNext(.subsc, .metaObj ) {
		Set name = metaObj.name
		Set value = $property(configData, name)
		if (value '= "") && $ListValid(value) set value = "$LB("_$LTS(value)_")"
		w $E(..#spaces, 1, maxNameLength- $length(name)), name, ": ",value,!
	}
}

XData CSPConfigData [ MimeType = application/json ]
{
[	
	{
		"name": "OAuthClientName",
		"default":"",
		"type": "s"
	},
	{
		"name": "ServiceConfigName",
		"default":"",
		"type": "s"
	}
]
}

XData ConfigData [ MimeType = application/json ]
{
[	
	{
		"name": "FHIRVersion",
		"type": "s",
		"readOnly": true
	},
	{
		"name": "InteractionsStrategyClass",
		"default":"HS.FHIRServer.Storage.Json.InteractionsStrategy",
		"type": "s",
		"readOnly": true
	},
	{
		"name": "RequiredResource",
		"default":"",
		"type": "s"
	},
	{
		"name": "FHIRSessionTimeout",
		"default":300,
		"type": "i"
	},
	{
		"name": "DefaultSearchPageSize",
		"default": 100,
		"type": "i"
	},
	{
		"name": "MaxSearchPageSize",
		"default": 100,
		"type": "i"
	},
	{
		"name": "MaxSearchResults",
		"default": 1000,
		"type": "i"
	},
	{
		"name": "MaxConditionalDeleteResults",
		"default": 3,
		"type": "i"
	},
	{
		"name": "DefaultPreferHandling",
		"default":"lenient",
		"type": "s"
	},
	{
		"name": "DebugMode",
		"default":0,
		"type": "i"
	}

]
}

}
