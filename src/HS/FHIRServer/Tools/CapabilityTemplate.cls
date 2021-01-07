Class HS.FHIRServer.Tools.CapabilityTemplate Extends HS.FHIRServer.Tools.CapabilityStatementBuilder
{

ClassMethod BuildFull(pAppKey As %String)
{
	set pXname = $classname() _ "||ConfigFull"
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId(pXname, .tSC)
	$$$ThrowOnError(tSC)
	Set configObj = ##class(%DynamicObject).%FromJSON(tXDataObj.Data)
	Return ..BuildFromConfig(pAppKey, configObj)
}

ClassMethod BuildReadOnly(pAppKey As %String)
{
	set pXname = $classname() _ "||ConfigReadOnly"
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId(pXname, .tSC)
	$$$ThrowOnError(tSC)
	Set configObj = ##class(%DynamicObject).%FromJSON(tXDataObj.Data)
	Return ..BuildFromConfig(pAppKey, configObj)
}

ClassMethod BuildFromConfig(serviceId As %String, pConfigObj As %DynamicObject)
{
	// NOTE: This code is protective of old code that used the CSP Rest App URL as the
	// serviceId (in version 1).  It was added in 2020.1 and it can be removed and the change documented
	// is a later release
	Set serviceInstanceId = serviceId
	if $E(serviceId,1) = "/" {
		// This is a csp path, convert it into a service instance Id
		Set serviceInstanceId = ##class(HS.FHIRServer.ServiceAdmin).GetInstanceIdForEndpoint(serviceId)
	}
	#dim instance as HS.FHIRServer.ServiceInstance = ##class(HS.FHIRServer.ServiceInstance).GetById(serviceInstanceId)
	set pXname = $classname() _ "||BaseResource"
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId(pXname, .tSC)
	$$$ThrowOnError(tSC)
	Set rsrcTemplate = ##class(%DynamicObject).%FromJSON(tXDataObj.Data)
	
	// Get Operation list from the OperationHandler
	// Load the Endpoint Config
	// For compatibility, accept both instanceId and restURL
	#dim strategy as HS.FHIRServer.API.InteractionsStrategy= instance.CreateStrategy()
	#dim interactions as HS.FHIRServer.API.Interactions = strategy.NewInteractionsInstance()
	
	Set operationProcessorClass = interactions.#OperationHandlerClass
	
	Set operationMap = $$$NewJSONObject
	Do $ClassMethod(operationProcessorClass, "AddSupportedOperations", operationMap)
	Set pConfigObj.operations = operationMap

	
	Return ..Build(strategy.schema, rsrcTemplate, pConfigObj)
}

/// Descriptive fields. None of these fields will modify functionality of an endpoint
XData BaseResource [ MimeType = application/json ]
{
{
  "resourceType": "CapabilityStatement",
  "id": "InterSystemsFHIRServer",
  "meta": {
    "versionId": "1",
    "lastUpdated": "2019-01-15T00:00:00Z"
  },
  "url": "<replaced-at-runtime>",
  "version": "1",
  "name": "InterSystems FHIR Server CapabilityStatement",
  "status": "active",
  "experimental": false,
  "date": "2020-01-15",
  "publisher": "InterSystems Corporation",
  "kind": "instance",
  "software": {
    "name": "InterSystems FHIR Server",
    "version": "2020.1"
  },
  "implementation": {
    "description": "InterSystems FHIR Server",
    "url": "<replaced-at-runtime>"
  },
  "fhirVersion": "<replaced-by-builder>",
  "acceptUnknown": "no",
  "format": [
    "xml",
    "json"
  ],
  "patchFormat": [
  	"application/json-patch+json"
  ],
  "rest": [
  ]
}
}

/// Config object for a read only endpoint. Fields suffixed with "-Documentation"
/// explain how that setting changes the capabilities
XData ConfigReadOnly [ MimeType = application/json ]
{
{
	"general-Documentation": [
		"This object controls the generation of a Metadata resource"
	],
	
	"paramExclude-Documentation": [
		"Each Entry represents a search parameter in the form of:"
		, "   <ResourceType>.<paramName> "
		, "that we do NOT want to support in the generated Metadata resource."
	],

	"paramExclude": [
		"Resource._content",
		"Resource._query"
	],
	
	"resourceDefaults-Documentation": [
		"These are the default values to apply to each resource added to the",
		"Metadata resource."
	
	],
	
	"resourceDefaults": {
		"interactions": [
			"read",
			"search-type"
		],
		"versioning": "versioned",
		"readHistory": false,
		"updateCreate": false,
		"conditionalCreate": false,
		"conditionalRead": "not-supported",
		"conditionalUpdate": false,
		"conditionalDelete": "not-supported"
	},
	
	"resourceOverrides-Documentation": [
		"Add an object with a resource name as a key.  Properties of the object",
		"will override the default value for all resources.  The first use is",
		"an override to the CapabilityStatement resource to indicate that only READ is allowed"
	],
	
	"resourceOverrides": {
		"CapabilityStatement": {
			"interactions": [
				"read"
			]
		},
		"Resource": {
			"interactions": [
			]
		}
	},
	
	"resourceList-Documentation": [
		"If present, this is the inclusive list of Resources to be supported by this",
		"Metadata object.  If not present, all resources in the schema are included"
	],
	"resourceListX": [
		"Patient", "Encounter"
	]
	
}
}

/// Config object for a read only endpoint. Fields suffixed with "-Documentation"
/// explain how that setting changes the capabilities
XData ConfigFull [ MimeType = application/json ]
{
{
	"general-Documentation": [
		"This object controls the generation of a Metadata resource"
	],
	
	"paramExclude-Documentation": [
		"Each Entry represents a search parameter in the form of:"
		, "   <ResourceType>.<paramName> "
		, "that we do NOT want to support in the generated Metadata resource."
	],

	"paramExclude": [
		"Resource._content",
		"Resource._query"
	],
	
	"resourceDefaults-Documentation": [
		"These are the default values to apply to each resource added to the",
		"Metadata resource."
	
	],
	
	"resourceDefaults": {
		"interactions": [
			"read",
			"vread",
			"create",
			"update",
			"patch",
			"delete",
			"history-instance",
			"search-type"
		],
		"versioning": "versioned",
		"readHistory": false,
		"updateCreate": true,
		"conditionalCreate": true,
		"conditionalRead": "not-supported",
		"conditionalUpdate": true,
		"conditionalDelete": "not-supported"
	},
	
	"resourceOverrides-Documentation": [
		"Add an object with a resource name as a key.  Properties of the object",
		"will override the default value for all resources.  The first use is",
		"an override to the CapabilityStatement resource to indicate that only READ is allowed"
	],
	
	"resourceOverrides": {
		"CapabilityStatement": {
			"interactions": [
				"read"
			]
		},
		"Binary": {
            "interactions": [
                "read",
                "vread",
                "create",
                "update",
                "delete",
                "history-instance",
                "search-type"
            ]
		},
		"Resource": {
			"interactions": [
				"transaction"
			]
		}
		
	},
	
	"resourceList-Documentation": [
		"If present, this is the inclusive list of Resources to be supported by this",
		"Metadata object.  If not present, all resources in the schema are included"
	],
	"resourceListX": [
		"Patient", "Encounter"
	]
	
}
}

}
