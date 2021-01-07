Include (%cspBuild, %occReference)

Class HS.FHIR.vSTU3.Repository.Storage Extends %RegisteredObject [ DependsOn = HS.FHIR.vSTU3.Repository.Resource.Abstract ]
{

/// Class that provides the FHIR resource validation logic for this storage class.
/// The ResourceValidatorClass must implement the class method ValidateResource.
/// The class is intended to handle structural validation of a resource and intra-
/// resource constraints.
Parameter ResourceValidatorClass = "HS.FHIR.Validation.ResourceValidator";

/// Class that provides various utility methods needed for repository processing.
/// The utility class methods that are used by this class are:<br>
/// <li>ValidateResourceTypeFHIR
/// <li>ValidateResourceTypeCapability
/// <li>GetResourceBasicInfo
/// <li>UpdateResourceId
/// <li>UpdateResourceMeta
/// <li>ValidateInteraction
Parameter RepositoryUtilityClass = "HS.FHIR.Utils";

Parameter SchematronXSLTDir = "FHIR/vSTU3/Schematron";

/// A key useable for disambiguating version-specific cached data
Parameter VERSIONKEY As %String = "STU3";

/// Individual STU3 resource type storage classes that hold the resource-specific search parameter
/// definitions and resource-specific indexing logic are located by default under the product
/// class package HS.FHIR.vSTU3.Repository.Resource. A custom storage package may be specified,
/// to be used instead of the default package. To do this, extend this class to a custom class
/// and override the CUSTOMSTORAGEPKG class parameter.
Parameter CUSTOMSTORAGEPKG As %String;

Parameter TEMPSORTGLOBAL = "^||FHIRSearchSort";

/// When SEARCHPREFERALWAYSSTRICT is 1, the "PreferHandling" input to Search is always interpreted
/// as though the HTTP Prefer header on the search request includes a "handling=strict" parameter.
/// Therefore when this class parameter is 1, the presence of any invalid or unsupported search
/// parameter on the request will return an error status, plus errors in the pErrors collection.
/// When this class parameter is overridden and set to 0, "handling=lenient" is the default
/// behavior, unless overridden explicitly by the HTTP Prefer header "handling=strict".
Parameter SEARCHPREFERALWAYSSTRICT = 1;

/// By default the ResultSet that is returned by Search leaves the ResourceId column value blank.
/// To have the ResourceId column unconditionally populated by Search, extend this class and set
/// this class parameter value to 1. Please note that doing so will incur a performance hit for
/// all search interactions.
Parameter RESOURCEIDINSEARCHRESULTSET = 0;

/// API
/// Create carries out the FHIR storage-specific logic for the create interaction.
/// Reference: http://hl7.org/fhir/STU3/http.html#create<br>
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pIfNoneExist       : FHIR search parameters for conditional create.
/// <li>pValBySchematron   : 1 = Perform schematron-based validation of the FHIR resource,
///                          0 = Do not perform schematron-based validation.
/// <li>pTransformer       : (recommended if pValBySchematron=1) Transformer object to use for performing
///                          XSLT 2.0 evaluation during schematron validation. If this object is not
///                          passed in when it is needed, then this method will create an instance of the
///                          transformer and use that. However doing that on each call of this method
///                          incurs a performance impact.
/// <li>pSessionIdentifier : Session identifier for session-based use of the FHIR storage.
/// <li>pResourceStream    : FHIR resource stream object. This stream will be updated during the course of
///                          the create interaction, and will be returned to the caller.
/// <li>pResourceObject    : FHIR %XML.Document object or %DynamicObject representation of the FHIR resource.
///                          This object will be updated during the course of the create interaction, and
///                          will be returned to the caller.
/// <br>Output:<br>
/// <li>pStorageId         : Physical storage object id (%Id(), not Oref) for the stored resource.
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod Create(pContentType As %String, pResourceSchema As %String, pIfNoneExist As %String = "", pValBySchematron As %Boolean = 0, pTransformer, pSessionIdentifier As %String = "", ByRef pResourceStream, ByRef pResourceObject, Output pStorageId As %String, Output pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Set pStorageId = ""
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// Simplify Content Type for later checks.
		If $ZConvert(pContentType,"L")["json" {
			Set tContentType = "JSON"
		} ElseIf $ZConvert(pContentType,"L")["xml" {
			Set tContentType = "XML"
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid content type '"_pContentType_"' specified")
			Quit
		}
		
		If $Get(pResourceSchema)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource schema not specified")
			Quit
		}
		
		If $Get(pIfNoneExist)'="" {
			If $IsObject(pIfNoneExist) {
				If pIfNoneExist.%IsA("%Library.ArrayOfDataTypes") {
					Set tIfNoneExist = pIfNoneExist
				} Else {
					Set tSC = $$$ERROR($$$GeneralError, "Conditional create search parameter input must be string or %ArrayOfDataTypes")
					Quit
				}
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).URLParamStringToArray(pIfNoneExist, .tIfNoneExist)
				If $$$ISERR(tSC) Quit
			}
			// Remove non-search keys from the list of parameters, just to make sure that
			// there are actual search criteria specified.
			Set tSearchParameters = ""
			If tIfNoneExist.Count()>0 {
				Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
				Set tSearchParameters = ##class(%Library.ArrayOfDataTypes).%New()
				Set tKey = ""
				For {
					Set tValue = tIfNoneExist.GetNext(.tKey)
					If tKey="" Quit
					If tNotSearchKeys'[(","_tKey_",") {
						Do tSearchParameters.SetAt(tValue, .tKey)
					}
				}
				If tSearchParameters.Count()=0 Set tSearchParameters = ""
			}	
		} Else {
			Set tSearchParameters = ""
		}
		
		If (('$IsObject($Get(pResourceStream)))||(pResourceStream.Size=0))&&('$IsObject($Get(pResourceObject))) {
			Set tSC = $$$ERROR($$$GeneralError, "Neither resource stream nor resource object specified")
			Quit
		}
		
		// If validation by schematron is requested then it will require a transformer
		// object that can execute XSLT 2.0.
		If (pValBySchematron=1)&&('$IsObject($Get(pTransformer))) {
			Set pTransformer = ##class(HS.Util.XSLTTransformer).%New()
			Set pTransformer.UseXSLT2 = 1
		}
		
		// If resource object was provided, then we don't need the resource stream yet.
		If '$IsObject($Get(pResourceObject)) {
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(pContentType, pResourceStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		}
		
		// But we at least want the resource stream object to exist.
		If '$IsObject($Get(pResourceStream)) {
			Set pResourceStream = ##class(%Stream.TmpCharacter).%New()
		}
		
		// Do schema-based validation on the resource.
		Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateResource( , , pResourceSchema, pResourceObject, .pErrors)
		If $$$ISERR(tSC) Quit
		
		// Extract the Resource Type from the resource object.
		Kill tProperties
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "resourceType")
		Set tSC = ##class(HS.FHIR.Utils).GetResourceInfo( , , pResourceObject, pResourceSchema, .tProperties)
		If $$$ISERR(tSC) Quit
		
		Set tResourceType = tProperties.GetAt("resourceType")
		
		// Do schematron-based validation on the resource, if requested.
		If pValBySchematron {
			If (tContentType="JSON")||((tContentType="XML")&&(pResourceStream.Size=0)) {
				Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateBySchematron( , , pResourceObject, pResourceSchema, tResourceType, .pTransformer, ..#SchematronXSLTDir, .pErrors)
			} Else {
				Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateBySchematron(pContentType, pResourceStream, , pResourceSchema, tResourceType, .pTransformer, ..#SchematronXSLTDir, .pErrors)
			}
			If $$$ISERR(tSC) Quit
		}
		
		If tSearchParameters'="" {
			Set tSC = ..Search(tResourceType, , , tSearchParameters, pSessionIdentifier, .tResultSet, .tErrors)
			If $$$ISERR(tSC) Quit
			
			Set tMatches = 0
			
			While (tResultSet.%Next()) {
				Set tMatches = tResultSet.%ROWCOUNT
				If tMatches>1 Quit
				Set pStorageId = tResultSet.%Get("ID")
			}
			
			If tMatches=1 {
				Set tSC = ..GetStorageObjectByStorageId(pStorageId, .tStorageObject, .tStorageClass)
				If $$$ISERR(tSC) Quit
				Set tResourceId = tStorageObject.ResourceId
				Set tTempStream = ##class(%Stream.TmpCharacter).%New()
				Do tStorageObject.GetResourceAsStream(.tTempStream)
				Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(pContentType, tTempStream, .pResourceObject)
				If $$$ISERR(tSC) Quit
				Kill tStorageObject
				Kill tTempStream
				Set tText = "If-None-Exist found one match, POST ignored. Resource id="_tResourceId
				Do pErrors.logError("informational", "information", tText, , , , tText)
				Quit
			} ElseIf tMatches>1 {
				Set tSC = $$$ERROR($$$GeneralError, "If-None-Exist found more than one match, POST rejected")
				Quit
			}
			// Otherwise, no matches were found, create can proceed as normal.
		}
		
		#dim tRepoResource As HS.FHIR.vSTU3.Repository.Resource.Abstract
		set tStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClass(tResourceType, .tSC, ..#CUSTOMSTORAGEPKG) quit:$$$ISERR(tSC)
		set tRepoResource = $CLASSMETHOD(tStorageClass, "%New")
		set tRepoResource.ResourceObject = pResourceObject
		set tRepoResource.ResourceType = tResourceType
		set tRepoResource.ResourceSchema = pResourceSchema
		set tRepoResource.Format = tContentType
		set tRepoResource.Verb = "POST"
		set tRepoResource.Session = pSessionIdentifier
		set tSC = tRepoResource.SetResourceId() quit:$$$ISERR(tSC)
		set tSC = tRepoResource.OnBeforeMatch() quit:$$$ISERR(tSC)
		set tSC = tRepoResource.SaveResource() quit:$$$ISERR(tSC)
		set pStorageId = tRepoResource.%Id()
		
		// Copy the resource string / stream to the resource stream that we will be returning.
		
		If pResourceStream.%IsA("HS.SDA3.QuickStream") {
			Do pResourceStream.Clear(0)
		} Else {
			Do pResourceStream.Clear()
		}
		
		Do tRepoResource.GetResourceAsStream(.pResourceStream)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// Read carries out the FHIR storage-specific logic for the read and vread interactions.
/// Reference: http://hl7.org/fhir/STU3/http.html#read<br>
/// Reference: http://hl7.org/fhir/STU3/http.html#vread<br>
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pResourceType      : (required) FHIR resource type.
/// <li>pResourceId        : (required) FHIR resource Id.
/// <li>pResourceVId       : FHIR resource version Id.
/// <li>pSummary           : (not yet supported) FHIR summary.
/// <li>pSessionIdentifier : Session identifier for session-based use of the FHIR storage.
/// 
/// <br>Output:<br>
/// <li>pResourceStream    : FHIR resource stream object.
/// <li>pResourceObject    : FHIR %XML.Document object or %DynamicObject representation of the FHIR resource.
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.
/// <li>pStorageId         : Physical storage object id (%Id(), not Oref) for the stored resource.
ClassMethod Read(pContentType As %String, pResourceSchema As %String, pResourceType As %String, pResourceId As %String, pResourceVId As %String = "", pSummary As %String = "", pSessionIdentifier As %String = "", Output pResourceStream, Output pResourceObject, Output pErrors As HS.Types.FHIR.Errors, Output pStorageId As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pStorageId = ""
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// If the resource doesn't exist (not even deleted), return not-found.
		if ('##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
			Set tText = "Resource not found: "_pResourceType_" ID="_pResourceId
			Do pErrors.logError("not-found", "error", tText, , , , tText)
			Set tSC = $$$ERROR($$$GeneralError, tText)
			Quit
		}
		// If this is a vread and the specified version does not exist, return not-found.
		if (pResourceVId'="")&&('##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).VersionExists(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tText = "Version not found: "_pResourceType_" ID="_pResourceId_" Version="_pResourceVId
			Do pErrors.logError("not-found", "error", tText, , , , tText)
			Set tSC = $$$ERROR($$$GeneralError, tText)
			Quit
		}
		
		// If the resource does exist but is deleted, return status 410 Gone.
		// For a regular read, Version should be null, so the method will return the deleted status of the current version.
		if (##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceIsDeleted(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource previously deleted")
			Quit
		}
		
		// For a regular read (i.e., not a vread), Version should be null, so the method will return
		// the logical ID (aka Storage Id) of the current version.
		Set pStorageId = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceToLogicalId(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)
		
		If pStorageId="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource repository item for resource type "_pResourceType_" resource id "_pResourceId_$Select(pResourceVId'="":" resource version id "_pResourceVId,1:"")_$Select(pSessionIdentifier'="":" session identifier "_pSessionIdentifier,1:"")_" not found")
			Quit
		}
		
		Set tSC = ..ReadByStorageId(pContentType, pResourceSchema, pStorageId, pSummary, , .pResourceStream, .pResourceObject, .pErrors)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// ReadByStorageId retrieves the FHIR resource stored at the repository object indicated by
/// pStorageId. This method assumes that the storage id has been obtained by previous means
/// such as FHIR search or history on this repository or by FHIR read cross reference of the
/// input resource type + resource id + session identifier (if any) to storage id.
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pStorageId         : (required) Resource repository storage object id.
/// <li>pSummary           : (not yet supported) FHIR _summary parameter value.
/// <li>pElements          : (not yet supported) FHIR _elements parameter value.
/// <li>pDoNotReturnObject : 0 = Create a %XML.Document object or %DynamicObject from the resource stream and return
///                          it, 1 = Do not create an object. This parameter helps avoid unnecessary performance
///                          overhead when the calling application has no use for an output object.
/// 
/// <br>Output:<br>
/// <li>pResourceStream    : FHIR resource stream object.
/// <li>pResourceObject    : FHIR %XML.Document object or %DynamicObject representation of the FHIR resource.
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod ReadByStorageId(pContentType As %String, pResourceSchema As %String, pStorageId, pSummary As %String = "", pElements As %String = "", Output pResourceStream, Output pResourceObject, Output pErrors As HS.Types.FHIR.Errors, pDoNotReturnObject As %Boolean = 0) As %Status
{
	set tSC = $$$OK
	
	try {
		if (pSummary'="")&&(pElements'="") {
			set tSC = $$$ERROR($$$GeneralError, "Cannot specify both _summary and _elements in the same request")
			quit
		}
		
		set tSC = ..GetStorageObjectByStorageId(pStorageId, .tStreamlet, .tStorageClass)
		if $$$ISERR(tSC) quit
		
		if '$IsObject($Get(pResourceStream)) Set pResourceStream = ##class(%Stream.GlobalCharacter).%New()
		
		if (pSummary'="")&&(pSummary'="false") {
			// TODO: Add support for _summary here.
			// pSummary input is "true", "text", "data", "false" or blank.
			// Create resource object.
			// Remove items that are NOT in the _summary.
			// Evaluation and application of _summary will need to be a new utility.
			// Output will need to be stream.
			// Turn stream back to string? Or make all subsequent refs to the resource to be stream?
			Set tSC = $$$ERROR($$$GeneralError, "_summary not supported")
			Quit
		}
		
		if pElements'="" {
			// TODO: Add support for _elements here.
			// pElements input is a comma-delimited list of top-level elements.
			// Create resource object.
			// Remove items that are NOT in the _elements.
			// Evaluation and application of _elements will need to be a new utility.
			// Output will need to be stream.
			// Turn stream back to string? Or make all subsequent refs to the resource to be stream?
			set tSC = $$$ERROR($$$GeneralError, "_elements not supported")
			quit
		}
		
		If ('$IsObject(tStreamlet.ResourceStream))||(tStreamlet.ResourceStream.Size=0) {
			Set tStreamOrString = tStreamlet.ResourceString
		} Else {
			Set tStreamOrString = tStreamlet.ResourceStream
		}
		
		If ((pContentType["xml")&&(tStreamlet.Format'="XML"))||((pContentType["json")&&(tStreamlet.Format'="JSON")) {
			// Difference between stored and requested format.
			Set tTempStream = ##class(%Stream.TmpCharacter).%New()
			If pContentType["json" {
				Set tSC = ##class(HS.FHIR.Utils).XMLToJSON(tStreamOrString, .tTempStream, pResourceSchema)
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).JSONToXML(tStreamOrString, .tTempStream, pResourceSchema)
			}
			If $$$ISERR(tSC) Quit
			Set tSC = pResourceStream.CopyFrom(tTempStream)
			If $$$ISERR(tSC) Quit
			Kill tTempStream
		} Else {
			Do tStreamlet.GetResourceAsStream(.pResourceStream)
		}
		
		If 'pDoNotReturnObject {
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(pContentType, pResourceStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod GetStorageObjectByStorageId(pStorageId As %String, ByRef pStorageObject, ByRef pStorageClass) As %Status
{
	Set tSC = $$$OK
	
	Set pStorageObject = ""
	
	Set pStorageClass = ""
	
	Try {
		Set pStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClassFromLogicalId(pStorageId)
		
		Set pStorageObject = $ClassMethod(pStorageClass, "%OpenId", pStorageId)
		
		If '$IsObject(pStorageObject) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource repository item for storage id "_pStorageId_" not found")
			Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// GetStorageDataByStorageId provides a "lite" read functionality that abstracts away the structure
/// of the physical storage object (indicated by pStorageId) used by this storage class, and retrieves
/// storage object metadata and, if requested, a stream representation of the resource itself. For
/// implementations that store the resource as a FHIR string or stream, as opposed to as an object,
/// the stream is returned "as is", in the format in which it is stored. For implementations that
/// store the FHIR resource as an object, the pFormat parameter can be used as input to specify the
/// format of the returned stream.
ClassMethod GetStorageDataByStorageId(pStorageId As %String, ByRef pResourceType As %String, ByRef pResourceId As %String, ByRef pResourceVId As %String, ByRef pVerb, ByRef pFormat As %String, ByRef pDeleted As %Boolean, ByRef pLastModified As %String, ByRef pResourceStream As %Stream.Object, ByRef pResourceSchema As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pResourceType = ""
	Set pResourceId = ""
	Set pVerb = ""
	Set pFormat = ""
	Set pDeleted = ""
	Set pLastModified = ""
	Set pResourceSchema = ""
	
	Try {
		Set tStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClassFromLogicalId(pStorageId)
		
		If tStorageClass="" {
			Set tSC = $$$ERROR($$$GeneralError, "Storage class for storage id "_pStorageId_" not found")
			Quit
		}
		
		Set tStorageObject = $ClassMethod(tStorageClass, "%OpenId", pStorageId)
		
		If '$IsObject(tStorageObject) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource repository item for storage id "_pStorageId_" not found")
			Quit
		}
		
		Set pResourceType = tStorageObject.ResourceType
		Set pResourceId = tStorageObject.ResourceId
		Set pResourceVId = tStorageObject.VersionId
		Set pVerb = tStorageObject.Verb
		Set pFormat = tStorageObject.Format
		Set pDeleted = tStorageObject.Deleted
		Set pLastModified = tStorageObject.LastModified
		Set pResourceSchema = tStorageObject.ResourceSchema
		
		// Return the resource content only if requested. The content is requested by
		// passing in a value for pResourceStream, as opposed to omitting it from the
		// input parameters or by passing in an undefined variable by reference.
		If $Data(pResourceStream) {
			If ('$IsObject(pResourceStream))||('pResourceStream.%IsA("%Stream.Object")) {
				Set pResourceStream = ##class(%Stream.TmpCharacter).%New()
			}
			Do tStorageObject.GetResourceAsStream(.pResourceStream)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod GetStorageIdByTypeAndId(pResourceType As %String, pResourceId As %String, pResourceVId As %String = "", pSessionIdentifier As %String = "", Output pStorageId As %String)
{
	Set tSC = $$$OK
	
	Set pStorageId = ""
	
	Try {
		// If the resource doesn't exist (not even deleted), return not-found.
		if ('##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource not found: "_pResourceType_" ID="_pResourceId)
			Quit
		}
		
		// If this is a vread and the specified version does not exist, return not-found.
		if (pResourceVId'="")&&('##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).VersionExists(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource not found: "_pResourceType_" ID="_pResourceId)
			Quit
		}
		
		// If the resource does exist but is deleted, return status 410 Gone.
		// For a regular read, Version should be null, so the method will return the deleted status of the current version.
		if (##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceIsDeleted(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource previously deleted")
			Quit
		}
		
		// For a regular read (i.e., not a vread), Version should be null, so the method will return
		// the storage id of the current version.
		Set pStorageId = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceToLogicalId(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)
		
		If pStorageId="" {
			Set tSC = $$$ERROR($$$GeneralError, "Stored resource repository item for resource type "_pResourceType_" resource id "_pResourceId_$Select(pResourceVId'="":" resource version id "_pResourceVId,1:"")_$Select(pSessionIdentifier'="":" session identifier "_pSessionIdentifier,1:"")_" not found")
			Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// Update carries out the FHIR storage-specific logic for the update interaction.
/// Reference: http://hl7.org/fhir/STU3/http.html#update<br>
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pParameters        : Search parameters for conditional update resource search. May be a Search
///                          parameters string, exactly as would be seen in the URL of a FHIR search
///                          request, or may be an %ArrayOfDataTypes of parameter $List values.
/// <li>pIfMatchVersion    : Resource version id to match when updating. If pIfMatchVersion has a value,
///                          then the current (pre-update) latest version of the resource must match
///                          pIfMatchVersion.
/// <li>pUpdateCreate      : 1 = Allow update to create a new resource identity (i.e., resource for
///                              previously unused resource Id),
///                          0 = Do not allow update to create a new resource identity.
/// <li>pValBySchematron   : 1 = Perform schematron-based validation of the FHIR resource,
///                          0 = Do not perform schematron-based validation.
/// <li>pTransformer       : (recommended if pValBySchematron=1) Transformer object to use for performing
///                          XSLT 2.0 evaluation during schematron validation. If this object is not
///                          passed in when it is needed, then this method will create an instance of the
///                          transformer and use that. However doing that on each call of this method
///                          incurs a performance impact.
/// <li>pSessionIdentifier : Session identifier for session-based use of the FHIR storage.
/// <li>pResourceStream    : FHIR resource stream object. This stream will be updated during the course of
///                          the update interaction, and will be returned to the caller.
/// <li>pResourceObject    : FHIR %XML.Document object or %DynamicObject representation of the FHIR resource.
///                          This object will be updated during the course of the update interaction, and
///                          will be returned to the caller.
/// <br>Output:<br>
/// <li>pStorageId         : Physical storage object id (%Id(), not Oref) for the stored resource.
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod Update(pContentType As %String, pResourceSchema As %String, pParameters, pIfMatchVersion As %String = "", pUpdateCreate As %Boolean = 1, pValBySchematron As %Boolean = 0, pTransformer, pSessionIdentifier As %String = "", ByRef pResourceStream, ByRef pResourceObject, Output pStorageId As %String, Output pErrors) As %Status
{
	Set tSC = $$$OK
	
	Set pStorageId = ""
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// The initial transaction level might not be 0, if this is part of a TRANSACTION interaction
		Set tInitLevel = $TLEVEL
		
		// Simplify Content Type for later checks.
		If $ZConvert(pContentType,"L")["json" {
			Set tContentType = "JSON"
		} ElseIf $ZConvert(pContentType,"L")["xml" {
			Set tContentType = "XML"
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid content type '"_pContentType_"' specified")
			Quit
		}
		
		If $Get(pResourceSchema)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource schema not specified")
			Quit
		}
		
		If $Get(pParameters)'="" {
			If $IsObject(pParameters) {
				If pParameters.%IsA("%Library.ArrayOfDataTypes") {
					Set tParameters = pParameters
				} Else {
					Set tSC = $$$ERROR($$$GeneralError, "Conditional update search parameter input must be string or %ArrayOfDataTypes")
					Quit
				}
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).URLParamStringToArray(pParameters, .tParameters)
				If $$$ISERR(tSC) Quit
			}
			// Remove non-search keys from the list of parameters, just to make sure that
			// there are actual search criteria specified.
			Set tSearchParameters = ""
			If tParameters.Count()>0 {
				Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
				Set tSearchParameters = ##class(%Library.ArrayOfDataTypes).%New()
				Set tKey = ""
				For {
					Set tValue = tParameters.GetNext(.tKey)
					If tKey="" Quit
					If tNotSearchKeys'[(","_tKey_",") {
						Do tSearchParameters.SetAt(tValue, .tKey)
					}
				}
				If tSearchParameters.Count()=0 Set tSearchParameters = ""
			}	
		} Else {
			Set tSearchParameters = ""
		}
		
		If (('$IsObject($Get(pResourceStream)))||(pResourceStream.Size=0))&&('$IsObject($Get(pResourceObject))) {
			Set tSC = $$$ERROR($$$GeneralError, "Neither resource stream nor resource object specified")
			Quit
		}
		
		// If validation by schematron is requested then it will require a transformer
		// object that can execute XSLT 2.0.
		If (pValBySchematron=1)&&('$IsObject($Get(pTransformer))) {
			Set pTransformer = ##class(HS.Util.XSLTTransformer).%New()
			Set pTransformer.UseXSLT2 = 1
		}
		
		// If resource object was provided, then we don't need the resource stream yet.
		If '$IsObject($Get(pResourceObject)) {
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(pContentType, pResourceStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		}
		
		// But we at least want the resource stream object to exist.
		If '$IsObject($Get(pResourceStream)) {
			Set pResourceStream = ##class(%Stream.TmpCharacter).%New()
		}
		
		// Do schema-based validation on the resource.
		Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateResource( , , pResourceSchema, pResourceObject, .pErrors)
		If $$$ISERR(tSC) Quit
		
		// Extract the Resource Type from the resource object.
		Kill tProperties
		Set tProperties = ##class(%Library.ArrayOfDataTypes).%New()
		Do tProperties.SetAt("", "resourceType")
		Do tProperties.SetAt("", "id")
		Set tSC = ##class(HS.FHIR.Utils).GetResourceInfo( , , pResourceObject, pResourceSchema, .tProperties)
		If $$$ISERR(tSC) Quit
		
		Set tResourceType = tProperties.GetAt("resourceType")
		Set tResourceId = tProperties.GetAt("id")
		
		If (tSearchParameters'="")&&(tResourceId'="") {
			Set tSC = $$$ERROR($$$GeneralError, "Cannot include resource id and conditional update search parameters on the same update request")
			Quit
		} ElseIf (tSearchParameters="")&&(tResourceId="") {
			Set tSC = $$$ERROR($$$GeneralError, "Neither resource id nor conditional update search parameters specified")
			Quit
		}
		
		// Do schematron-based validation on the resource, if requested.
		If pValBySchematron {
			If (tContentType="JSON")||((tContentType="XML")&&(pResourceStream.Size=0)) {
				Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateBySchematron( , , pResourceObject, pResourceSchema, tResourceType, .pTransformer, ..#SchematronXSLTDir, .pErrors)
			} Else {
				Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateBySchematron(pContentType, pResourceStream, , pResourceSchema, tResourceType, .pTransformer, ..#SchematronXSLTDir, .pErrors)
			}
			If $$$ISERR(tSC) Quit
		}
		
		// If no resource id then we know we're doing conditional update.
		If tResourceId="" {
			Set tSC = ..Search(tResourceType, , , tSearchParameters, pSessionIdentifier, .tResultSet, .tErrors)
			If $$$ISERR(tSC) Quit
			
			Set tMatches = 0
			
			While (tResultSet.%Next()) {
				Set tMatches = tResultSet.%ROWCOUNT
				If tMatches>1 Quit
				Set pStorageId = tResultSet.%Get("ID")
			}
			
			If tMatches=0 {
				If pUpdateCreate {
					Set tSC = ..Create(pContentType, pResourceSchema, , , , pSessionIdentifier, .pResourceStream, .pResourceObject, .pStorageId, .pErrors)
				} Else {
					Set tSC = $$$ERROR($$$GeneralError, "conditional update not allowed when no matches found, PUT rejected")
				}
				Quit
			} ElseIf tMatches=1 {
				Set tSC = ..GetStorageObjectByStorageId(pStorageId, .tStreamlet, .tStorageClass)
				If $$$ISERR(tSC) Quit
				Set tResourceId = tStreamlet.ResourceId
				Kill tStreamlet
			} ElseIf tMatches>1 {
				Set tSC = $$$ERROR($$$GeneralError, "conditional update search found more than one match, PUT rejected")
				Quit
			}
		}
		
		Set tCurrentVersionId = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).CurrentVersion(pSessionIdentifier, tResourceType, tResourceId)
		
		// If the request contains an If-Match header, assert that the value matches the current version ID of the resource.
		// (Used for resource contention - see http://hl7.org/fhir/STU3/http.html#update#2.21.0.11)
		// Allow pIfMatchVersion to be just the specified version, or a whole HTTP If-Match value.
		If pIfMatchVersion?1"W/""".E1"""" {
			Set tIfMatchVersion = $Extract(pIfMatchVersion, 4, *-1)
		} Else {
			Set tIfMatchVersion = pIfMatchVersion
		}
		If (tIfMatchVersion'="")&&(tIfMatchVersion'=tCurrentVersionId) {
			Set tSC = $$$ERROR($$$GeneralError, "'If-Match' header ("_pIfMatchVersion_") does not match current version ID ("_tCurrentVersionId_"), PUT rejected")
			Quit
		}
		
		If (tCurrentVersionId="")&&('pUpdateCreate) {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR update interaction on non-existent resource id not allowed")
			Quit
		}
		
		#dim tRepoResource As HS.FHIR.vSTU3.Repository.Resource.Abstract
		set tStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClass(tResourceType, .tSC, ..#CUSTOMSTORAGEPKG) quit:$$$ISERR(tSC)
		set tRepoResource = $CLASSMETHOD(tStorageClass, "%New")
		set tRepoResource.ResourceObject = pResourceObject
		set tRepoResource.ResourceSchema = pResourceSchema
		set tRepoResource.ResourceType = tResourceType
		set tRepoResource.Format = tContentType
		set tRepoResource.Verb = "PUT"
		set tRepoResource.Session = pSessionIdentifier
		set tRepoResource.ResourceId = tResourceId
		set tSC = tRepoResource.OnBeforeMatch() quit:$$$ISERR(tSC)
		
		// Check if the resource already exists, and if so, deprecate the current version.
		// The deprecation of the existing resource and the save of the new one need to
		//  happen inside a transaction so that an error while saving the new one does not
		//  leave the original resource as deprecated.
		if (##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceExists(tRepoResource.Session,tResourceType,tResourceId)) {
			if tInitLevel=0 TSTART
			set tSC = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).DeprecateResource(tRepoResource.Session,tResourceType,tResourceId) quit:$$$ISERR(tSC)
			set tSC = tRepoResource.SaveResource() quit:$$$ISERR(tSC)
			if tInitLevel=0 TCOMMIT
		}
		else {
			set tSC = tRepoResource.SaveResource() quit:$$$ISERR(tSC)
		}
		
		set pStorageId = tRepoResource.%Id()
		
		// Copy the resource string / stream to the resource stream that we will be returning.
		
		If pResourceStream.%IsA("HS.SDA3.QuickStream") {
			Do pResourceStream.Clear(0)
		} Else {
			Do pResourceStream.Clear()
		}
		
		Do tRepoResource.GetResourceAsStream(.pResourceStream)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	// If the transaction was left uncommitted (ie, error), roll it back.
	// The "1" because it's possible we are in a nested transaction (the TRANSACTION interaction)
	if ($D(tInitLevel) && ($TLEVEL > tInitLevel)) { TROLLBACK 1 }
	Quit tSC
}

/// API
/// Delete carries out the FHIR storage-specific logic for the delete interaction.
/// Reference: http://hl7.org/fhir/STU3/http.html#delete<br>
/// Input:<br>
/// <li>pResourceType      : (required) FHIR resource type.
/// <li>pResourceId        : (required if not using conditional delete) FHIR resource Id.
/// <li>pConditionalDelete : Conditional delete support value. Valid values are "not-supported", "single",
///                          "multiple" and blank. Blank value is considered same as "not-supported".
/// <li>pParameters        : Search parameters for conditional delete resource search. May be a Search
///                          parameters string, exactly as would be seen in the URL of a FHIR search
///                          request, or may be an %ArrayOfDataTypes of parameter $List values.
/// <li>pMaxSearchMatches  : Maximum number of resources that may be found by the conditional delete
///                          search parameters. If more than this number are found by the search then
///                          the conditional delete is rejected as an error.
/// <li>pSessionIdentifier : Session identifier for session-based use of the FHIR storage.
/// <br>Output:<br>
/// <li>pResourceIds       : %ListOfDataTypes object with each element being the resource id and resource
///                          version id of a resource that got deleted, separated by comma.
ClassMethod Delete(pResourceType As %String, pResourceId As %String = "", pConditionalDelete As %String = "", pParameters As %String = "", pMaxSearchMatches As %Integer = 10, pSessionIdentifier As %String = "", ByRef pResourceIds As %Library.ListOfDataTypes) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pResourceIds)) Set pResourceIds = ##class(%Library.ListOfDataTypes).%New()
		
		If pParameters'="" {
			If $IsObject(pParameters) {
				If pParameters.%IsA("%Library.ArrayOfDataTypes") {
					Set tParameters = pParameters
				} Else {
					Set tSC = $$$ERROR($$$GeneralError, "Conditional delete search parameter input must be string or %ArrayOfDataTypes")
					Quit
				}
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).URLParamStringToArray(pParameters, .tParameters)
				If $$$ISERR(tSC) Quit
			}
			// Remove non-search keys from the list of parameters, just to make sure that
			// there are actual search criteria specified.
			Set tSearchParameters = ""
			If tParameters.Count()>0 {
				Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
				Set tSearchParameters = ##class(%Library.ArrayOfDataTypes).%New()
				Set tKey = ""
				For {
					Set tValue = tParameters.GetNext(.tKey)
					If tKey="" Quit
					If tNotSearchKeys'[(","_tKey_",") {
						Do tSearchParameters.SetAt(tValue, .tKey)
					}
				}
				If tSearchParameters.Count()=0 Set tSearchParameters = ""
			}
		} Else {
			Set tSearchParameters = ""
		}
		
		If $Get(pResourceType)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource type not specified")
		} ElseIf tSearchParameters="" {
			// No parameters, is not a conditional delete.
			Set tSC = ..DeleteOne(pResourceType, pResourceId, pSessionIdentifier, .tResourceVId)
			If tResourceVId'="" Do pResourceIds.Insert(pResourceId_","_tResourceVId)
		} ElseIf (pConditionalDelete="not-supported")||(pConditionalDelete="") {
			// Conditional delete must be explicitly supported.
			Set tSC = $$$ERROR($$$GeneralError, "Conditional delete not supported")
		} ElseIf pResourceId'="" {
			Set tSC = $$$ERROR($$$GeneralError, "Cannot include resource id and conditional delete search parameters on the same delete request")
		} Else {
			// All okay, proceed with the conditional delete search and deletes.
			Set tSC = ..Search(pResourceType, , , tSearchParameters, pSessionIdentifier, .tResultSet, .tErrors)
			If $$$ISERR(tSC) Quit
			
			While (tResultSet.%Next()) {
				If (pConditionalDelete="single")&&(tResultSet.%ROWCOUNT>1) {
					Set tSC = $$$ERROR($$$GeneralError, "Conditional delete of multiple resources not supported")
					Quit
				}
				If (tResultSet.%ROWCOUNT > pMaxSearchMatches) {
					Set tSC = $$$ERROR($$$GeneralError, "Conditional delete search found more than maximum allowed number of "_pMaxSearchMatches_" results, DELETE rejected")
					Quit
				}
				Set tStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClassFromLogicalId(tResultSet.%Get("ID"))
				Set tStreamlet = $ClassMethod(tStorageClass, "%OpenId", tResultSet.%Get("ID"))
				Set tResourceId = tStreamlet.ResourceId
				Kill tStreamlet
				Set tSC = ..DeleteOne(pResourceType, tResourceId, pSessionIdentifier, .tResourceVId)
				If $$$ISERR(tSC) Quit
				If tResourceVId'="" Do pResourceIds.Insert(tResourceId_","_tResourceVId)
			}
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod DeleteOne(pResourceType As %String, pResourceId As %String, pSessionIdentifier As %String = "", ByRef pResourceVId As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Set pResourceVId = ""
	
	Try {
		Set tInitLevel = $TLevel
		
		If $Get(pResourceType)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource type not specified")
			Quit
		}
		
		If $Get(pResourceId)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource Id not specified")
			Quit
		}
		
		// If the resource doesn't exist, do nothing.
		If ('##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
			Quit
		}
		
		// If the resource is already marked as deleted, do nothing.
		If (##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceIsDeleted(pSessionIdentifier, pResourceType, pResourceId)) {
			Quit
		}
		
		// Resource exists, so create new "deleted" version with no content
		#dim tStreamlet As HS.FHIR.vSTU3.Repository.Resource.Abstract
		Set tStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClass(pResourceType, .tSC, ..#CUSTOMSTORAGEPKG) quit:$$$ISERR(tSC)
		Set tStreamlet = $CLASSMETHOD(tStorageClass, "%New")
		Set tStreamlet.ResourceType = pResourceType
		Set tStreamlet.ResourceString = ""
		Do tStreamlet.ResourceStream.Clear()
		Set tStreamlet.ResourceId = pResourceId
		Set tStreamlet.Deleted = 1
		Set tStreamlet.Verb = "DELETE"
		Set tStreamlet.Session = pSessionIdentifier
		Set tSC = tStreamlet.OnBeforeMatch() quit:$$$ISERR(tSC)
		
		// Deprecate the last version of the resource and save the new, "deleted" version.
		// Do this in a transaction so an error in either step does not leave the database in some
		// unpredictable state.
		TSTART
		Set tSC = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).DeprecateResource(pSessionIdentifier, pResourceType, pResourceId) quit:$$$ISERR(tSC)
		Set tSC = tStreamlet.SaveResource() Quit:$$$ISERR(tSC)
		TCOMMIT
		
		Set pResourceVId = tStreamlet.VersionId
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	// If the transaction was left uncommitted (ie, error), roll it back.
	// The "1" because it's possible we are in a nested transaction (the TRANSACTION interaction)
	If ($Data(tInitLevel))&&($TLevel > tInitLevel) {
		TROLLBACK 1
	}
	
	Quit tSC
}

ClassMethod HardDelete(resourceType As %String, resourceId As %String) As %Status
{
	set tSC = $$$OK
	try {
		set tSC = ..Delete(resourceType, resourceId)
		quit:$$$ISERR(tSC)
		
		&SQL(DELETE FROM HS_FHIR_vSTU3_Repository_Resource.Abstract
		            WHERE ResourceId = :resourceId AND ResourceType = :resourceType)
		if (SQLCODE < 0) { set tSC = $$$ERROR($$$GeneralError, "SQL Error "_SQLCODE_", "_$system.SQL.SQLCODE(SQLCODE)) quit }
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// API
/// Lastn executes a search on the resource repository, within the constraints and special
/// processing defined for the $lastn operation interaction, and returns a result set of
/// identifiers of the FHIR resources that qualify for the search.<br>
/// Input:<br>
/// <li>pParameters        : May be a Search parameters string, exactly as would be seen in the URL of a
///                          FHIR search request, or may be an %ArrayOfDataTypes of parameter $List values.
/// <li>pMax               : Maximum number of resources to return in each Observation.code grouping.
/// <li>pSessionIdentifier : Session identifier, used for session-based resource storage.
/// <li>pPreferHandling    : Value of "lenient" or null value means ignore unrecognized search parameters
///                          and return warnings about such search parameters in an OperationOutcome
///                          resource in the returned FHIR Bundle. Value of "strict" means return errors
///                          and a 400 Bad Request status when unrecognized search parameters are found
///                          in the request.
/// <li>pSearchPostProcessorClass : When specified, the "PostProcessSearch" method of this class is executed
///                                 on the initial ResultSet of the search.
/// <li>pSessionApplication, pSessionId : Optional inputs, can be used as inputs to the "PostProcessSearch" call.
/// <br>Output:<br>
/// <li>pResultSet         : <class>HS.Util.TransientTable</class> object for holding the results of
///                          the search.  Columns in pResultSet are:<br>
///                          ID           = The physical storage object id.
///                          Deleted      = Initialized as blank for all rows. Provides a means to mark rows for
///                                         exclusion from the returned Bundle of resources. The search and $everything
///                                         logic subsequent to the return from PostProcessSearch will ignore result
///                                         set rows that have the Deleted column set to 1.<br>
///                          ResourceType = Resource type.<br>
///                          ResourceId   = Resource id, populated only if ..#RESOURCEIDINSEARCHRESULTSET=1.<br>
///                          Mode         = "match" means the resource matched by the search criteria. "include" means
///                                         the resource is present only because a "match" resource has a reference to
///                                         it.<br>
///                          RefersTo     = Comma-delimited list of storage ids to which the resource has references.<br>
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod Lastn(pParameters = "", pMax As %Integer = 1, pSessionIdentifier As %String = "", Output pResultSet As HS.Util.TransientTable, Output pErrors As HS.Types.FHIR.Errors, pPreferHandling As %String = "", pSearchPostProcessorClass As %String = "", pSessionApplication As %String = "", pSessionId As %String = "") As %Status
{
	Set tSC = $$$OK
	
	// $lastn-specific: Hard-code resource type to Observation.
	Set pResourceType = "Observation"
	
	Set pResultSet = ""
	
	Try {
		If '$IsObject($Get(pErrors)) set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		If $Get(pParameters)'="" {
			// If it is not an object, then we will assume that it is a URL parameter string,
			// and will convert it to a %Library.ArrayOfDataTypes. If it IS an object, then
			// then we will assume that it is a %Library.ArrayOfDataTypes like that found in
			// the FHIR request message class.
			If '$IsObject(pParameters) {
				Set tString = pParameters
				Kill pParameters
				Set tSC = $ClassMethod(..#RepositoryUtilityClass, "URLParamStringToArray", tString, .pParameters)
				$$$ThrowOnError(tSC)
			}
		} Else {
			// $lastn-specific: Must have patient or subject search param.
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Neither patient nor subject search parameter specified"))
		}
		
		// $lastn-specific: Must have patient or subject search param.
		If (pParameters.GetAt("patient")="")&&(pParameters.GetAt("subject")="") {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Neither patient nor subject search parameter specified"))
		} ElseIf (pParameters.GetAt("patient")'="")&&(pParameters.GetAt("subject")'="") {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Cannot specify both patient and subject search parameter"))
		} ElseIf pParameters.GetAt("_sort")="" {
			// $lastn-specific: Default in code,-date if no sort specified.
			Do pParameters.SetAt($ListBuild("code,-date"), "_sort")
		} Else {
			// $lastn-specific: If _sort is specified, must start with code,-date.
			If $listvalid(pParameters.GetAt("_sort")) {
				Set tSortParam = $ListGet(pParameters.GetAt("_sort"))
			} Else {
				Set tSortParam = pParameters.GetAt("_sort")
			}
			If $extract(tSortParam,1,10)'="code,-date" {
				$$$ThrowStatus($$$ERROR($$$GeneralError, "First two _sort keys must be code,-date"))
			}
		}
		
		Set tResourceAbstractClass = "HS.FHIR.v"_..#VERSIONKEY_".Repository.Resource.Abstract"
		Set tSearchTablePackage = $Parameter(tResourceAbstractClass, "SEARCHTABLEPACKAGE")
		
		// Assert that the search table for this type exists
		If ('$$$defClassDefined(tSearchTablePackage_"."_pResourceType)) {
			Set tSC = $$$ERROR($$$GeneralError, "Search table definition for resource type "_pResourceType_" not found")
			$$$ThrowOnError(tSC)
		}
		
		// Set this global to 1 to turn on logging for search. Useful for analyzing performance.
		Set tLog = +$G(^HS.FHIR.Log.Search)

		Set tSC = ..ValidateSortKeys(.pResourceType, .pParameters, .tSortKeys)
		$$$ThrowOnError(tSC)
		
		// - tSortKeys(n,"KeyName")   = Sort key name as specified in the request URL.<br>
		// - tSortKeys(n,"KeyNameNormalized") = Sort key name, normalized to match the corresponding search table property name.<br>
		// - tSortKeys(n,"Direction") = "asc" or "desc".<br>
		// - tSortKeys(n,"KeyType")   = Search/sort key field type, for example "token" or "date".<br>
		// - tSortKeys(n,"XPathType") = Search/sort key field type data type from data model.<br>
		
		// Create an SQL ORDER BY string, based on tSortKeys.
		// Adding the sort keys as ? parameters does not crash
		// the SQL but also does not seem to sort. Therefore
		// the sort fields are added explicitly to the string.
		Set tSQLORDERBY = ""
		Set tSQLORDERBYParams = 0
		Set tSortKeySub = ""
		For {
			Set tSortKeySub = $Order(tSortKeys(tSortKeySub))
			If tSortKeySub="" Quit
			Set tKeyName = tSortKeys(tSortKeySub, "KeyNameNormalized")
			If tKeyName="date" {
				Set tKeyName = "dateStart"
			}
			If tSortKeySub>1 {
				Set tSQLORDERBY = tSQLORDERBY_","
			}
			If tSortKeys(tSortKeySub, "KeyType")="date" {
				Set tKeyName = "%INTERNAL("_tKeyName_")"
			}
			Set tSQLORDERBY = tSQLORDERBY_tKeyName
			Set tSQLORDERBY = tSQLORDERBY_" "_tSortKeys(tSortKeySub, "Direction")
		}
		
		// Out of the box behavior is to return error upon invalid or unsupported search param.
		If ..#SEARCHPREFERALWAYSSTRICT Set pPreferHandling = "strict"
		
		// Validate the search parameters. Pass all input params here byref for speed.
		Do ..ValidateSearchParams(.pResourceType, .pParameters, .pPreferHandling, .tHasParams, .tHasChain, .tHasRevChain, .tHasNonChain, .tChains, .tRevChains, .tValidIncludes, .tValidRevIncludes, .pErrors)
		
		// Assume that pErrors was empty before starting to validate the search
		// parameters. Therefore if there are any errors now, they are due to
		// invalid search parameters. In that case, quit now.
		If pErrors.HighestError="error" {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid search parameters found"))
		}
		
		// $lastn-specific: Add column 'Code' to help with determining
		// the last max number of Observations in each group.
		Do ..InitializeSearchResultSet(.pResultSet, "Code", .tColNums)
		
		Set tSQL = "SELECT ResourceLogicalId As ID,_id As ResourceId,code FROM "
		Set tSQL = tSQL_$TR(tSearchTablePackage,".","_")_"."_$S($system.SQL.IsReservedWord(pResourceType):$C(34)_pResourceType_$C(34), 1:pResourceType)
		Set tSQLParams = 0
		
		// Get the SQL string and parameter value array for the WHERE clause of initial
		// (non-reverse chain) search query. Pass all input params here ByRef for speed.
		Set tSQLWHERE = ""
		Set tSQLWHEREParams = 0
		Do ..GetSearchSQLWHERE(.pResourceType, , , .pParameters, .tChains, .pSessionIdentifier, .tSQLWHERE, .tSQLWHEREParams)
		If tSQLWHERE'="" {
			Set tSQL = tSQL_" WHERE "_tSQLWHERE
			Set tN = ""
			For {
				Set tN = $order(tSQLWHEREParams(tN))
				If tN="" Quit
				Set tSQLParams($i(tSQLParams)) = tSQLWHEREParams(tN)
			}
		}
		If tSQLORDERBY'="" {
			Set tSQL = tSQL_" ORDER BY "_tSQLORDERBY
		}
		
		// If the search has regular and/or chain search parameters, or has no parameters
		// at all, then do a search using the regular/chain/no parameters. If a reverse
		// chain was specified, then it will be done separately after this search.
		If ( (tHasNonChain)||(tHasChain) ) || ( '((tHasNonChain)||(tHasChain)||(tHasRevChain)) ) {
			
			Do ..ExecuteSQLSearch(.pResourceType, .pParameters, .tSQL, .tSQLParams, .tLog, .tSQLResultSet)
			
			Set tSQLIDColNum = 1
			Set tSQLResourceIdColNum = 2
			// $lastn-specific: Additional Code column.
			Set tSQLCodeColNum = 3
			
			// Populate the TransientTable result set from initial SQL result set.
			While tSQLResultSet.%Next() {
				Set tStorageId = tSQLResultSet.%GetData(tSQLIDColNum)
				Do pResultSet.%NewRow()
				Do pResultSet.%SetData(tColNums("Deleted"), "")
				Do pResultSet.%SetData(tColNums("ID"), tStorageId)
				Do pResultSet.%SetData(tColNums("ResourceType"), pResourceType)
				Do pResultSet.%SetData(tColNums("ResourceId"), $ListGet(tSQLResultSet.%GetData(tSQLResourceIdColNum),1))
				Do pResultSet.%SetData(tColNums("Mode"), "match")
				// $lastn-specific: Additional Code column.
				Do pResultSet.%SetData(tColNums("Code"), $ListGet(tSQLResultSet.%GetData(tSQLCodeColNum),1))
				Set tSC = pResultSet.%SaveRow()
				If $$$ISERR(tSC) Quit
			}
			If $$$ISERR(tSC) Quit
			
			If pResultSet.%ROWCOUNT=0 Quit
			
			Do pResultSet.%SetIterator(0)
		}
		
		// If there are reverse chains specified
		// AND
		// There were no other search criteria, OR There were other criteria AND there were results found
		If ($data(tRevChains)) && ( '((tHasNonChain)||(tHasChain)) || ( ((tHasNonChain)||(tHasChain)) && (pResultSet.%ROWCOUNT>0) ) ) {
			Do ..ApplyReverseChainedSearch(pResourceType, pSessionIdentifier, ((tHasNonChain)||(tHasChain)), .tRevChains, .pResultSet, .tColNums, tLog)
			If pResultSet.%ROWCOUNT=0 quit
		}
		
		// If there is a search post processor class specified, then apply it only to the result set
		// that is the outcome of the initial (non-reverse chain) and the reverse chain search.
		If pSearchPostProcessorClass'="" {
			// search-all (pRequest.Type=""), or search parameters _include, _revinclude or _contained,
			// could cause more than one resource type to be represented in the result set.
			If (pResourceType'="")&&(($ListLength(tValidIncludes))||(pParameters.GetAt("_revinclude")'="")||(pParameters.GetAt("_contained")'="")) {
				While pResultSet.%Next() {
					If pResultSet.%GetData(tColNums("ResourceType"))'=pResourceType {
						Set pResourceType = ""
						Quit
					}
				}
				Do pResultSet.%SetIterator(0)
			}
			Set tSC = $ClassMethod(pSearchPostProcessorClass, "PostProcessSearch", .pResultSet, pSessionApplication, pSessionId, pResourceType)
			If $$$ISERR(tSC) Quit
			// Here we count the remaining non-deleted rows, not the total rows.
			Do pResultSet.%SetIterator(0)
			Set tHasNonDeletedRows = 0
			While (pResultSet.%Next()) {
				If 'pResultSet.%GetData(tColNums("Deleted")) {
					Set tHasNonDeletedRows = 1
					Quit
				}
			}
			Do pResultSet.%SetIterator(0)
			If 'tHasNonDeletedRows {
				// If all rows have Deleted set to 1, then just re-init the resultset.
				Do ..InitializeSearchResultSet(.pResultSet, , .tColNums)
				Quit
			}
		}
		
		// If there are still non-deleted rows remaining in the result set after post
		// processing has been applied, then next parse the result set and remove any
		// rows that exceed the pMax number of rows for a given Observation code.
		// Because pMax must be at least 1, we can assume that this loop will not
		// delete all remaining non-deleted rows.
		Do pResultSet.%SetIterator(0)
		Set tPrevCode = ""
		Set tCurrentCodeCount = 0
		While (pResultSet.%Next()) {
			If 'pResultSet.%GetData(tColNums("Deleted")) {
				Set tCode = pResultSet.%GetData(tColNums("Code"))
				If tCode'=tPrevCode {
					Set tCurrentCodeCount = 1
				} Else {
					If $i(tCurrentCodeCount)
					If tCurrentCodeCount>pMax {
						Do pResultSet.%SetData(tColNums("Deleted"), "1")
						Set tSC = pResultSet.%SaveRow()
						$$$ThrowOnError(tSC)
					}
				}
				Set tPrevCode = tCode
			}
		}
		Do pResultSet.%SetIterator(0)
		
		// If there are still non-deleted rows remaining in the result set after post
		// processing has been applied, then assume that any resources to be pulled
		// in by those non-deleted resources via _include and references are okay to
		// add.
		
		Do ..SearchIncludes(.pResourceType, .tValidIncludes, .pSessionIdentifier, .pResultSet, .tColNums)
		
		If pResultSet.%ROWCOUNT>0 Do pResultSet.%SetIterator(0)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// Search executes a specified search on the resource repository and returns a result set of
/// identifiers of the FHIR resources that qualify for the search.<br>
/// Input:<br>
/// <li>pResourceType      : (required) FHIR resource type.
/// <li>pCompartment       : Needed only for compartment-based search.
/// <li>pResourceId        : Resource Id for compartment-based search.
/// <li>pParameters        : May be a Search parameters string, exactly as would be seen in the URL of a
///                          FHIR search request, or may be an %ArrayOfDataTypes of parameter $List values.
/// <li>pSessionIdentifier : Session identifier, used for session-based resource storage.
/// <li>pPreferHandling    : Value of "lenient" or null value means ignore unrecognized search parameters
///                          and return warnings about such search parameters in an OperationOutcome
///                          resource in the returned FHIR Bundle. Value of "strict" means return errors
///                          and a 400 Bad Request status when unrecognized search parameters are found
///                          in the request.
/// <li>pSearchPostProcessorClass : When specified, the "PostProcessSearch" method of this class is executed
///                                 on the initial ResultSet of the search.
/// <li>pSessionApplication, pSessionId : Optional inputs, can be used as inputs to the "PostProcessSearch" call.
/// <br>Output:<br>
/// <li>pResultSet         : <class>HS.Util.TransientTable</class> object for holding the results of
///                          the search.  Columns in pResultSet are:<br>
///                          ID           = The physical storage object id.
///                          Deleted      = Initialized as blank for all rows. Provides a means to mark rows for
///                                         exclusion from the returned Bundle of resources. The search and $everything
///                                         logic subsequent to the return from PostProcessSearch will ignore result
///                                         set rows that have the Deleted column set to 1.<br>
///                          ResourceType = Resource type.<br>
///                          ResourceId   = Resource id, populated only if ..#RESOURCEIDINSEARCHRESULTSET=1.<br>
///                          Mode         = "match" means the resource matched by the search criteria. "include" means
///                                         the resource is present only because a "match" resource has a reference to
///                                         it.<br>
///                          RefersTo     = Comma-delimited list of storage ids to which the resource has references.<br>
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod Search(pResourceType As %String, pCompartment As %String = "", pResourceId As %String = "", pParameters = "", pSessionIdentifier As %String = "", Output pResultSet As HS.Util.TransientTable, Output pErrors As HS.Types.FHIR.Errors, pPreferHandling As %String = "", pSearchPostProcessorClass As %String = "", pSessionApplication As %String = "", pSessionId As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Set pResultSet = ""
	
	Try {
		if '$IsObject($Get(pErrors)) set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		if $Get(pResourceType)="" {
			set tSC = $$$ERROR($$$GeneralError, "Resource type not specified")
			quit
		}
		
		if $Get(pParameters)'="" {
			// If it is not an object, then we will assume that it is a URL parameter string,
			// and will convert it to a %Library.ArrayOfDataTypes. If it IS an object, then
			// then we will assume that it is a %Library.ArrayOfDataTypes like that found in
			// the FHIR request message class.
			if '$IsObject(pParameters) {
				set tString = pParameters
				kill pParameters
				set tSC = $classmethod(..#RepositoryUtilityClass, "URLParamStringToArray", tString, .pParameters)
				if $$$ISERR(tSC) quit
			}
		} else {
			set pParameters = ##class(%Library.ArrayOfDataTypes).%New()
		}
		
		set tResourceAbstractClass = "HS.FHIR.v"_..#VERSIONKEY_".Repository.Resource.Abstract"
		set tSearchTablePackage = $Parameter(tResourceAbstractClass, "SEARCHTABLEPACKAGE")
		
		// Assert that the search table for this type exists
		if ('$$$defClassDefined(tSearchTablePackage_"."_pResourceType)) {
			set tSC = $$$ERROR($$$GeneralError, "Search table definition for resource type "_pResourceType_" not found")
			quit
		}
		
		// Set this global to 1 to turn on logging for search. Useful for analyzing performance.
		set tLog = +$G(^HS.FHIR.Log.Search)

		set tSC = ..ValidateSortKeys(.pResourceType, .pParameters, .tSortKeys)
		if $$$ISERR(tSC) quit
		
		// Out of the box behavior is to return error upon invalid or unsupported search param.
		if ..#SEARCHPREFERALWAYSSTRICT set pPreferHandling = "strict"
		
		// Validate the search parameters. Pass all input params here byref for speed.
		do ..ValidateSearchParams(.pResourceType, .pParameters, .pPreferHandling, .tHasParams, .tHasChain, .tHasRevChain, .tHasNonChain, .tChains, .tRevChains, .tValidIncludes, .tValidRevIncludes, .pErrors)
		
		// Assume that pErrors was empty before starting to validate the search
		// parameters. Therefore if there are any errors now, they are due to
		// invalid search parameters. In that case, quit now.
		if pErrors.HighestError="error" {
			set tSC = $$$ERROR($$$GeneralError, "Invalid search parameters found")
			quit
		}
		
		do ..InitializeSearchResultSet(.pResultSet, , .tColNums)
		
		// Build the SELECT and FROM parts of the SQL for the initial (non-reverse chain)search.
		// If the name of the table is an SQL reserved word (ex: Procedure, Group), it must be quoted.
		// tType should have been validated above via HS.FHIR.Utils:IsValidResourceType().
		if ('..#RESOURCEIDINSEARCHRESULTSET)&&('tHasRevChain) {
			set tSQL = "SELECT ResourceLogicalId As ID FROM "
		} else {
			// Reverse chain will need the ResourceId. Specific implementation also
			// may want the ResourceId added, enabled by the class parameter value.
			set tSQL = "SELECT ResourceLogicalId As ID,_id As ResourceId FROM "
		}
		set tSQL = tSQL_$TR(tSearchTablePackage,".","_")_"."_$S($system.SQL.IsReservedWord(pResourceType):$C(34)_pResourceType_$C(34), 1:pResourceType)
		set tSQLParams = 0
		
		// Get the SQL string and parameter value array for the WHERE clause of initial
		// (non-reverse chain) search query. Pass all input params here ByRef for speed.
		set tSQLWHERE = ""
		set tSQLWHEREParams = 0
		do ..GetSearchSQLWHERE(.pResourceType, .pCompartment, .pResourceId, .pParameters, .tChains, .pSessionIdentifier, .tSQLWHERE, .tSQLWHEREParams)
		if tSQLWHERE'="" {
			set tSQL = tSQL_" WHERE "_tSQLWHERE
			set tN = ""
			for {
				set tN = $order(tSQLWHEREParams(tN))
				if tN="" Quit
				set tSQLParams($i(tSQLParams)) = tSQLWHEREParams(tN)
			}
		}
		
		// If the search has regular and/or chain search parameters, or has no parameters
		// at all, then do a search using the regular/chain/no parameters. If a reverse
		// chain was specified, then it will be done separately after this search.
		if ( (tHasNonChain)||(tHasChain) ) || ( '((tHasNonChain)||(tHasChain)||(tHasRevChain)) ) {
			
			do ..ExecuteSQLSearch(.pResourceType, .pParameters, .tSQL, .tSQLParams, .tLog, .tSQLResultSet)
			
			Set tSQLIDColNum = 1
			Set tSQLResourceIdColNum = 2
			
			// Populate the TransientTable result set from initial SQL result set.
			While tSQLResultSet.%Next() {
				Set tStorageId = tSQLResultSet.%GetData(tSQLIDColNum)
				Do pResultSet.%NewRow()
				Do pResultSet.%SetData(tColNums("Deleted"), "")
				Do pResultSet.%SetData(tColNums("ID"), tStorageId)
				Do pResultSet.%SetData(tColNums("ResourceType"), pResourceType)
				If ('..#RESOURCEIDINSEARCHRESULTSET)&&('tHasRevChain) {
					Do pResultSet.%SetData(tColNums("ResourceId"), "")
				} Else {
					Do pResultSet.%SetData(tColNums("ResourceId"), $ListGet(tSQLResultSet.%GetData(tSQLResourceIdColNum),1))
				}
				Do pResultSet.%SetData(tColNums("Mode"), "match")
				Set tSC = pResultSet.%SaveRow()
				If $$$ISERR(tSC) Quit
			}
			If $$$ISERR(tSC) Quit
			
			If pResultSet.%ROWCOUNT=0 Quit
			
			Do pResultSet.%SetIterator(0)
		}
		
		// If there are reverse chains specified
		// AND
		// There were no other search criteria, OR There were other criteria AND there were results found
		if ($data(tRevChains)) && ( '((tHasNonChain)||(tHasChain)) || ( ((tHasNonChain)||(tHasChain)) && (pResultSet.%ROWCOUNT>0) ) ) {
			do ..ApplyReverseChainedSearch(pResourceType, pSessionIdentifier, ((tHasNonChain)||(tHasChain)), .tRevChains, .pResultSet, .tColNums, tLog)
			if pResultSet.%ROWCOUNT=0 quit
		}
		
		// If there is a search post processor class specified, then apply it only to the result set
		// that is the outcome of the initial (non-reverse chain) and the reverse chain search.
		If pSearchPostProcessorClass'="" {
			// search-all (pRequest.Type=""), or search parameters _include, _revinclude or _contained,
			// could cause more than one resource type to be represented in the result set.
			If (pResourceType'="")&&(($ListLength(tValidIncludes))||(pParameters.GetAt("_revinclude")'="")||(pParameters.GetAt("_contained")'="")) {
				While pResultSet.%Next() {
					If pResultSet.%GetData(tColNums("ResourceType"))'=pResourceType {
						Set pResourceType = ""
						Quit
					}
				}
				Do pResultSet.%SetIterator(0)
			}
			Set tSC = $ClassMethod(pSearchPostProcessorClass, "PostProcessSearch", .pResultSet, pSessionApplication, pSessionId, pResourceType)
			If $$$ISERR(tSC) Quit
			// Here we count the remaining non-deleted rows, not the total rows.
			Do pResultSet.%SetIterator(0)
			Set tHasNonDeletedRows = 0
			While (pResultSet.%Next()) {
				If 'pResultSet.%GetData(tColNums("Deleted")) {
					Set tHasNonDeletedRows = 1
					Quit
				}
			}
			Do pResultSet.%SetIterator(0)
			If 'tHasNonDeletedRows {
				// If all rows have Deleted set to 1, then just re-init the resultset.
				Do ..InitializeSearchResultSet(.pResultSet, , .tColNums)
				Quit
			}
		}
		
		// Apply any specified sorting to the post-processed result set. If sorting is
		// applied, rows that were marked as Deleted by the post processing will be
		// dropped from the result set.
		If $Data(tSortKeys) {
			Kill @..#TEMPSORTGLOBAL
			Set tSC = ..AddResultsToTempSort(pResultSet, .tSortKeys, tColNums("Deleted"), tColNums("ID"), tColNums("ResourceType"), tColNums("ResourceId"), tColNums("Mode"), tSearchTablePackage, ..#TEMPSORTGLOBAL)
			If $$$ISERR(tSC) Kill @..#TEMPSORTGLOBAL Quit
			// At this point, the old result set is of no use to us any more. Delete it,
			// re-initialize it, and pass it into CreateSortedResultSet for re-population.
			Do ..InitializeSearchResultSet(.pResultSet, , .tColNums)
			Set tSC = ..CreateSortedResultSet(..#TEMPSORTGLOBAL, .tSortKeys, tColNums("Deleted"), tColNums("ID"), tColNums("ResourceType"), tColNums("ResourceId"), tColNums("Mode"), .pResultSet)
			Kill @..#TEMPSORTGLOBAL
			If $$$ISERR(tSC) Quit
			Do pResultSet.%SetIterator(0)
		}
		
		// If there are still non-deleted rows remaining in the result set after post
		// processing has been applied, then assume that any resources to be pulled
		// in by those non-deleted resources via _include and references are okay to
		// add.
		
		do ..SearchIncludes(.pResourceType, .tValidIncludes, .pSessionIdentifier, .pResultSet, .tColNums)
		
		If pResultSet.%ROWCOUNT>0 Do pResultSet.%SetIterator(0)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Validate the specified parameters for FHIR search, and return any applicable data
/// regarding chained parameters, reverse chained parameters, _includes and _revincludes.
ClassMethod ValidateSearchParams(pResourceType As %String, pParameters As %Library.ArrayOfDataTypes, pPreferHandling As %String, ByRef pHasParams As %Boolean, ByRef pHasChain As %Boolean, ByRef pHasRevChain As %Boolean, ByRef pHasNonChain As %Boolean, ByRef pChains As %String, ByRef pRevChains As %String, ByRef pValidIncludes As %List, ByRef pValidRevIncludes As %String, ByRef pErrors As HS.Types.FHIR.Errors)
{
	// Pre-scan the parameters to verify at least one search key.
	// Also gather info on chained parameters, reverse chained
	// parameters, _includes and _revincludes.
	set pHasParams = 0
	set pHasChain = 0
	set pHasRevChain = 0
	set pHasNonChain = 0
	set pValidIncludes = ""
	set pValidRevIncludes = ""
	
	// Maintain a list of the parameters that are not search keys.
	set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
		
	for {
		set tParamVals = pParameters.GetNext(.tWholeParam) quit:tWholeParam=""
		set tParam=$P(tWholeParam,":")
		if tParam="" continue
		
		// Chained and reverse chained parameters will be logged to local
		// arrays and will be added to the search SQL last.
		if tParam="_has" {
			do ..ValidateAndLogRevChainParam(pParameters, tWholeParam, tParamVals, pPreferHandling, pResourceType, .tParamType, .pErrors, .pRevChains, .tAdded)
			if tAdded set (pHasRevChain, pHasParams) = 1
			continue
		} elseif tParam="_include" {
			do ..ValidateSearchInclude(.pResourceType, .pParameters, .pPreferHandling, .pValidIncludes, .pErrors)
			continue
		} elseif (tParam[".")||($P(tWholeParam,":",2)[".") {
			do ..ValidateAndLogChainParam(pParameters, tWholeParam, tParamVals, pPreferHandling, pResourceType, .tParamType, .pErrors, .pChains, .tAdded)
			if tAdded set (pHasChain, pHasParams) = 1
			continue
		}
		
		set tParam=$P(tParam,".")
		
		// Skip the parameters that are not search keys
		if (tNotSearchKeys [ (","_tParam_",")) { continue }
		// Skip unrecognized params
		set tParamType = ..GetSearchParamType(pResourceType, tParam)
		if (tParamType="") {
			// This will prevent GetURLWithQuery() from including this parameter in the "self" URL in the response
			do pParameters.RemoveAt(tWholeParam)
			set tText = "Unrecognized search param"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_tParam
			set tSeverity = $Select(pPreferHandling="strict":"error",1:"warning")
			do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			continue
		}
		// Validate the param type
		If (",token,date,string,reference,quantity,number,uri," '[ (","_tParamType_",")) {
			// This will prevent GetURLWithQuery() from including this parameter in the "self" URL in the response
			do pParameters.RemoveAt(tWholeParam)
			set tText = "Unsupported search param type ("_tParamType_")"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_tParam
			set tSeverity = $Select(pPreferHandling="strict":"error",1:"warning")
			do pErrors.logError("not-supported", tSeverity, tText, , , , tText)
			continue
		}
		set pHasParams = 1
		set pHasNonChain = 1
	}
	kill tWholeParam
	
	quit
}

/// Validate the _include search parameter value(s).
ClassMethod ValidateSearchInclude(pResourceType As %String, pParameters As %Library.ArrayOfDataTypes, pPreferHandling As %Boolean, ByRef pValidIncludes As %List, ByRef pErrors As HS.Types.FHIR.Errors)
{
	// If the query has an _include param or params, make sure it's valid, otherwise return an operation outcome.
	// This just validates _include, the actual processing is below.
	set pValidIncludes = ""
	set tInclude = pParameters.GetAt("_include")
	for tJ=1:1:$LL(tInclude) {
		set tIsValidInclude = 1
		set tOneInclude = $LG(tInclude, tJ)
		set tIncludeBaseType = $P(tOneInclude, ":", 1)
		set tIncludeParam = $P(tOneInclude, ":", 2)
		set tParamType = ..GetSearchParamType(pResourceType,tIncludeParam)
		// Assert that the base type of the include matches the search type.
		if (tIncludeBaseType '= pResourceType) {
			set tText = "Base type of _include must be the same as search type: "_tOneInclude
			do pErrors.logError("value", $Select(pPreferHandling="strict":"error",1:"warning"), tText, , , , tText)
			set tIsValidInclude = 0
		}
		// Assert that the named param is valid for this resource type.
		elseif (tParamType="") {
			set tText = "_include references a non-existent or unsupported search param: "_tOneInclude
			do pErrors.logError("value", $Select(pPreferHandling="strict":"error",1:"warning"), tText, , , , tText)
			set tIsValidInclude = 0
		}
		// Assert that the named param is of type "reference"
		elseif (tParamType '= "reference") {
			set tText = "_include must name a search param of type reference: "_tOneInclude
			do pErrors.logError("value", $Select(pPreferHandling="strict":"error",1:"warning"), tText, , , , tText)
			set tIsValidInclude = 0
		}
		
		// Put it in the list of valid includes if it passes validation
		if tIsValidInclude set pValidIncludes = pValidIncludes_$LB(tOneInclude)
	}
	
	quit
}

/// Construct and return the SQL string and SQL parameter values for the WHERE clause
/// of the current search.
ClassMethod GetSearchSQLWHERE(pResourceType As %String, pCompartment As %String = "", pResourceId As %String, pParameters As %Library.ArrayOfDataTypes, ByRef pChains As %String, pSessionIdentifier As %String, ByRef pSQL As %String, ByRef pSQLParams As %String)
{
	// Maintain a list of the parameters that are not search keys.
	set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
	
	set tResourceAbstractClass = "HS.FHIR.v"_..#VERSIONKEY_".Repository.Resource.Abstract"
	
	set pSQL = ""
	set pSQLParams = 0
	
	if (pCompartment '= "") {
		set tSC = $classmethod(tResourceAbstractClass, "SearchCompartment", pResourceType, pCompartment, pResourceId, .pSQL, .pSQLParams)
		$$$ThrowOnError(tSC)
	}
	
	for {
		// NOTE: tParamVals is a LIST!
		set tParamVals = pParameters.GetNext(.tWholeParam) quit:tWholeParam=""
		set tParam=$P(tWholeParam,":"), tModifier=$P(tWholeParam,":",2)
		if tNotSearchKeys[(","_tParam_",") continue
		
		// If chained or reverse chained, these are already logged, add them last.
		if ((tParam[".")||(tModifier[".")||(tParam="_has")) {
			continue
		}
		
		set tParamType = ..GetSearchParamType(pResourceType, tParam, .tPropType)
		
		if pSQL'="" set pSQL = pSQL_" AND "
		
		set pSQL = pSQL_"("
		do ..AddSearchParamToSQL(tParamType, pResourceType, tWholeParam, tParamVals, tPropType, .pSQL, .pSQLParams)
		set pSQL = pSQL_")"
	}
	
	// Derive, formulate and add chained parameters, if any.
	if $data(pChains) {
		do ..GetChainedSQL(.pChains, .tChainSQL, .pSQLParams)
		if pSQL'="" set pSQL = pSQL_" AND "
		set pSQL = pSQL_" "_tChainSQL
	}
	
	if (pSessionIdentifier'="") {
		if pSQL'="" set pSQL = pSQL_" AND "
		set pSQL = pSQL_" ResourceLogicalId->Session=?"
		set pSQLParams($I(pSQLParams)) = pSessionIdentifier
	}
	
	quit
}

/// Common method for initializing the search resultset object.
ClassMethod InitializeSearchResultSet(ByRef pResultSet As HS.Util.TransientTable, pAdditionalColumns As %String = "", ByRef pColNums As %String)
{
	Kill pResultSet
	Kill pColNums
	
	Set pResultSet = ##class(HS.Util.TransientTable).%New()
	
	Set tDelim = ","
	
	Set tCoreColumns = "Deleted"_tDelim_"ID"_tDelim_"ResourceType"_tDelim_"ResourceId"_tDelim_"Mode"_tDelim_"RefersTo"
	
	If (pAdditionalColumns'="")&&($Extract(pAdditionalColumns)'=tDelim) {
		Set pAdditionalColumns = tDelim_pAdditionalColumns
	}
	Set tAllColumns = tCoreColumns_pAdditionalColumns
	
	For i = 1:1:$Length(tAllColumns, tDelim) {
		Set tColumnName = $Piece(tAllColumns, tDelim, i)
		If tColumnName'="" {
			Set pColNums(tColumnName) = pResultSet.%AddColumn(tColumnName, "%String")
		}
	}
	Quit
}

/// Execute the search and return the %SQL.StatementResult resultset.
/// Log performance statistics if logging is requested.
ClassMethod ExecuteSQLSearch(pResourceType As %String, pParameters As %Library.ArrayOfDataTypes, pSQL As %String, ByRef pSQLParams As %String, pLog As %Boolean, ByRef pSQLResultSet As %SQL.StatementResult)
{
	set tStatement = ##class(%SQL.Statement).%New()

	// Prepare
	if pLog set tSQLPrepareStart = $ZHOROLOG
	set tSC = tStatement.%Prepare(.pSQL)
	if $$$ISERR(tSC) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Error preparing query for search interaction: "_$system.Status.GetErrorText(tSC)))
	}
	if pLog set tSQLPrepareEnd = $ZHOROLOG
	if pLog set tSQLPrepare = (tSQLPrepareEnd-tSQLPrepareStart)
	
	// Execute
	if pLog set tSQLExecuteStart = $ZHOROLOG
	set pSQLResultSet = tStatement.%Execute(pSQLParams...)
	if (pSQLResultSet.%SQLCODE < 0) { 
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Error executing query for search interaction: SQL error, SQLCODE="_pSQLResultSet.%SQLCODE_", Msg="_pSQLResultSet.%Message))
	}
	if pLog set tSQLExecute1 = ($ZHorolog-tSQLExecuteStart)
	
	// Log performance stats on the SQL query itself.
	If pLog {
		set tSQLExecute2 = ($ZHorolog-tSQLExecuteStart)
	
		set tSQLTime = (tSQLPrepare+tSQLExecute1+tSQLExecute2)
		
		// Get the local time, turn the parameters array back into a string (some
		// items may have been removed during parameter parsing) and log:
		// - Local time (YYYY-DD-MM HH:MM:SS)
		// - Re-assembled URL query string
		// - Full SQL statement
		// - Elapsed time for query Prepare
		// - Elapsed time for query Execute
		set tTimestamp = $ZDT($Horolog,3)
		set tOrigQuery = "/"_pResourceType
		set tParamString = $ClassMethod(..#RepositoryUtilityClass, "URLParameterArrayToString", pParameters)
		if tParamString'="" Set tOrigQuery = tOrigQuery_"?"_tParamString
		set tSQLWithParams = pSQL
		set pSQLParams = +$Get(pSQLParams)
		for tI=1:1:pSQLParams { set tSQLWithParams = $REPLACE(tSQLWithParams, "?", "'"_pSQLParams(tI)_"'", , 1) }
		set ^HS.FHIR.Log.Search($i(^HS.FHIR.Log.Search(0))) = $LB(tTimestamp, tOrigQuery, tSQLWithParams, tSQLPrepare, tSQLExecute1, tSQLExecute2)
	}
	
	quit
}

/// Based on the current resultset, add rows to the resultset for resources that
/// need to get pulled in due to _include search parameter(s).
ClassMethod SearchIncludes(pResourceType As %String, pValidIncludes As %List, pSessionIdentifier As %String, ByRef pResultSet As HS.Util.TransientTable, ByRef pColNums As %String)
{
	If '$ListLength(pValidIncludes) Quit
	
	Set tGlobalName = "^||IncludeStreamletIds"
	
	Kill @tGlobalName
	
	Set tResourceAbstractClass = "HS.FHIR.v"_..#VERSIONKEY_".Repository.Resource.Abstract"
	Set tSearchTablePackage = $Parameter(tResourceAbstractClass, "SEARCHTABLEPACKAGE")

	While (pResultSet.%Next()) {
		If pResultSet.%GetData(pColNums("Deleted")) Continue
		Set tStorageId = pResultSet.%GetData(pColNums("ID"))
		// Only populate the "RefersTo" column when _include is specified on the search.
		Set tSearchTableObj = $ClassMethod(tSearchTablePackage_"."_pResourceType, "%OpenId", tStorageId)
		If '$Data(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType)) {
			// This should never be true since we added the LoadAllSearchParams()
			// call at repository business operation startup.
			Do ..CacheSearchParams(pResourceType)
		}
		Set tRefersTo = ""
		Set tSearchParam = 0
		Kill tAlreadyLogged
		For {
			Set tSearchParam = $Order(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType, tSearchParam))
			If tSearchParam="" Quit
			If $Piece(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType, tSearchParam),"^",1)="reference" {
				Set tSearchParamNormalized = $ClassMethod(tResourceAbstractClass, "NormalizeParamName", tSearchParam)
				For j = 1:1:$Property(tSearchTableObj, tSearchParamNormalized).Count() {
					Set tRef = $Property(tSearchTableObj, tSearchParamNormalized).GetAt(j)
					If $Length(tRef,"/")'=2 Continue
					If $Data(tAlreadyLogged(tRef)) Continue
					If $Data(tReferenceToStorageId(tRef)) {
						Set tRefStorageId = tReferenceToStorageId(tRef)
					} Else {
						Set tSC = ..GetStorageIdByTypeAndId($Piece(tRef,"/",1), $Piece(tRef,"/",2), , pSessionIdentifier, .tRefStorageId)
						$$$ThrowOnError(tSC)
					}
					If tRefersTo'="" Set tRefersTo = tRefersTo_","
					Set tRefersTo = tRefersTo_tRefStorageId
					Set tReferenceToStorageId(tRef) = tRefStorageId
					Set tAlreadyLogged(tRef) = ""
				}
			}
		}
		If tRefersTo'="" Do pResultSet.%SetData(pColNums("RefersTo"), tRefersTo)
		
		Set tSC = pResultSet.%SaveRow()
		$$$ThrowOnError(tSC)
		
		// Gather resources pointed to by any valid _include search parameters.
		Set tSC = ..SearchInclude(pResourceType, tStorageId, pSessionIdentifier, pValidIncludes, .tIncluded, .tOneStreamletIds)
		$$$ThrowOnError(tSC)
		
		// SearchInclude already makes sure the same resource is not _include-ed
		// more than once, so no need to check for duplicates here.
		For tJ = 1:1:$ListLength(tOneStreamletIds) {
			Set tStreamletId = $ListGet(tOneStreamletIds, tJ)
			Set @tGlobalName@($i(@tGlobalName)) = tStreamletId
		}
	}
	
	Set tJ = ""
	For {
		Set tJ = $Order(@tGlobalName@(tJ))
		If tJ="" Quit
		Set tTargetLogicalId = @tGlobalName@(tJ)
		Set tSC = ..GetStorageDataByStorageId(tTargetLogicalId, .tResourceType, .tResourceId)
		$$$ThrowOnError(tSC)
		Do pResultSet.%NewRow()
		Do pResultSet.%SetData(pColNums("Deleted"), "")
		Do pResultSet.%SetData(pColNums("ID"), tTargetLogicalId)
		Do pResultSet.%SetData(pColNums("ResourceType"), tResourceType)
		Do pResultSet.%SetData(pColNums("ResourceId"), tResourceId)
		Do pResultSet.%SetData(pColNums("Mode"), "include")
		Set tSC = pResultSet.%SaveRow()
		$$$ThrowOnError(tSC)
	}
	
	Kill @tGlobalName
	
	Quit
}

/// Given the search parameter type and other search parameter information, construct and
/// add the proper SQL and SQL parameter values to the search SQL statement.
ClassMethod AddSearchParamToSQL(pParamType As %String, pResourceType As %String, pWholeParam As %String, pParamVals, pPropType As %String, ByRef pSQL As %String, ByRef pSQLParams As %String)
{
	set tResourceAbstractClass = "HS.FHIR.v"_..#VERSIONKEY_".Repository.Resource.Abstract"
	
	if (pParamType = "token") {
		set tSC = $classmethod(tResourceAbstractClass, "SearchToken", pWholeParam, pParamVals, .pSQL, .pSQLParams, pPropType)
		$$$ThrowOnError(tSC)
	}
	elseif (pParamType = "date") {
		set tSC = $classmethod(tResourceAbstractClass, "SearchDate", pResourceType, pWholeParam, pParamVals, .pSQL, .pSQLParams, pPropType)
		$$$ThrowOnError(tSC)
	}
	elseif (pParamType = "string") {
		set tSC = $classmethod(tResourceAbstractClass, "SearchString", pWholeParam, pParamVals, .pSQL, .pSQLParams)
		$$$ThrowOnError(tSC)
	}
	elseif (pParamType = "reference") {
		set tSC = $classmethod(tResourceAbstractClass, "SearchReference", pWholeParam, pParamVals, .pSQL, .pSQLParams)
		$$$ThrowOnError(tSC)
	}
	elseif (pParamType = "quantity") {
		set tSC = $classmethod(tResourceAbstractClass, "SearchQuantity", pResourceType, pWholeParam, pParamVals, .pSQL, .pSQLParams)
		$$$ThrowOnError(tSC)
	}
	elseif (pParamType = "number") { 
		set tSC = $classmethod(tResourceAbstractClass, "SearchNumber", pWholeParam, pParamVals, .pSQL, .pSQLParams)
		$$$ThrowOnError(tSC)
	}
	elseif (pParamType = "uri") { 
		set tSC = $classmethod(tResourceAbstractClass, "SearchURI", pWholeParam, pParamVals, .pSQL, .pSQLParams)
		$$$ThrowOnError(tSC)
	}
	quit
}

/// If the specified member of pParameters is a chained search parameter, validate
/// it and log it to the pChains array. Chained paramters will be added to the SQL
/// statement last.
ClassMethod ValidateAndLogChainParam(pParameters, pWholeParam As %String, pParamVals, pPreferHandling As %String, pResourceType As %String, ByRef pParamType As %String, ByRef pErrors As HS.Types.FHIR.Errors, ByRef pChains As %String, ByRef pAdded As %Boolean)
{
	Set pAdded = 0
	
	Set tParam=$Piece(pWholeParam, ":")
	Set tModifier=$Piece(pWholeParam, ":", 2, *)
	
	Set tSubDelim = "||"
	
	If tParam["." {
		
		// Examples:
		//
		// GET [base]/DiagnosticReport?patient.given=aaron,robert
		// tParam             = patient
		// tChainResourceType = Patient (derived from definition of tParam search param)
		// tChainParam        = given
		// pParamVals         = $ListBuild("aaron,robert") (NOT $ListBuild("aaron","robert"))
		//
		// GET [base]/DiagnosticReport?result.code=2093-3&result.code=8302-2
		// tParam             = result
		// tChainResourceType = Observation (derived from definition of tParam search param)
		// tChainParam        = code
		// pParamVals         = $ListBuild("2093-3","8302-2") (NOT $ListBuild("2093-3,8302-2"))
		
		Set tChain = tParam
		Set tParam=$Piece(tParam, ".", 1)
		Set tChainParam = $Piece(tChain, ".", 2, *)
		
		If ((tParam="")||(tChainParam=""))||((tChain[".")&&(tModifier[".")) {
			Set tText = "Invalid malformed chained search param '"_pWholeParam_"'"
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		Set pParamType = ..GetSearchParamType(pResourceType, tParam)
		
		If pParamType="" {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Unrecognized chained search param"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_tParam
			Set tSeverity = $Select(pPreferHandling="strict":"error",1:"warning")
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		If pParamType'="reference" {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Invalid chained search param - must be reference type"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_tParam
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		// %HSFHIRSearchParams stores target resource types, if any, with leading and trailing tilde on the list.
		If tParam="patient" {
			Set tTargetResourceTypes = "Patient"
		} ElseIf tParam="encounter" {
			Set tTargetResourceTypes = "Encounter"
		} Else {
			Set tTargetResourceTypes = $Piece(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType, tParam), "^", 3)
			If $Extract(tTargetResourceTypes)="~" Set tTargetResourceTypes = $Extract(tTargetResourceTypes, 2, *)
			If $Extract(tTargetResourceTypes, *)="~" Set tTargetResourceTypes = $Extract(tTargetResourceTypes, 1, *-1)
		}
		
		If ($Length(tTargetResourceTypes,"~")>1)||(tTargetResourceTypes="*") {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Invalid ambiguous chained search param"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		Set tChainResourceType = tTargetResourceTypes
		
		// This type of chain must be from a search parameter that references only a single resource type.
		If '$Data(%HSFHIRSearchParams(..#VERSIONKEY, tChainResourceType, tChainParam)) {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Invalid chained search param - unrecognized search param on resource type "_tChainResourceType_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_tChainParam
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		Set pChains(tParam_tSubDelim_tChainResourceType, tChainParam) = pParamVals
		Set pAdded = 1
		
	} ElseIf tModifier["." {
		
		// Examples:
		//
		// GET [base]/DiagnosticReport?subject:Patient.given=aaron,robert
		// tParam             = subject
		// tChainResourceType = Patient
		// tChainParam        = given
		// pParamVals         = $ListBuild("aaron,robert") (NOT $ListBuild("aaron","robert"))
		//
		// GET [base]/DiagnosticReport?result:Observation.code=2093-3&result:Observation.code=8302-2
		// tParam             = result
		// tChainResourceType = Observation
		// tChainParam        = code
		// pParamVals         = $ListBuild("2093-3","8302-2") (NOT $ListBuild("2093-3,8302-2"))
		
		Set tChain = tModifier
		Set tModifier=""
		Set tChainParam = $Piece(tChain, ".", 2, *)
		Set tChainResourceType = $Piece(tChain, ".", 1)
		
		If (tParam="")||(tChainParam="")||(tChainResourceType="") {
			Set tText = "Invalid malformed chained search param '"_pWholeParam_"'"
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		Set pParamType = ..GetSearchParamType(pResourceType, tParam)
		
		If pParamType="" {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Unrecognized chained search param"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
			Set tSeverity = $Select(pPreferHandling="strict":"error",1:"warning")
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		If pParamType'="reference" {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Invalid chained search param - must be reference type"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		// %HSFHIRSearchParams stores target resource types, if any, with leading and trailing tilde on the list.
		If tChainParam="patient" {
			Set tTargetResourceTypes = "~Patient~"
		} ElseIf tChainParam="encounter" {
			Set tTargetResourceTypes = "~Encounter~"
		} Else {
			Set tTargetResourceTypes = $Piece(%HSFHIRSearchParams(..#VERSIONKEY, pResourceType, tParam), "^", 3)
		}
		
		If tTargetResourceTypes'[("~"_tChainResourceType_"~") {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Invalid chained search param - resource type is invalid"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		If '$Data(%HSFHIRSearchParams(..#VERSIONKEY, tChainResourceType, tChainParam)) {
			Do pParameters.RemoveAt(pWholeParam)
			Set tText = "Invalid chained search param - unrecognized search param on resource type"_tChainResourceType_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
			Set tSeverity = "error"
			Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
			Quit
		}
		
		Set pChains(tParam_tSubDelim_tChainResourceType, tChainParam) = pParamVals
		Set pAdded = 1
	}
	
	Quit
}

/// If the specified member of pParameters is a chained search parameter, validate
/// it and log it to the pChains array. Chained paramters will be added to the SQL
/// statement last.
ClassMethod ValidateAndLogRevChainParam(pParameters, pWholeParam As %String, pParamVals, pPreferHandling As %String, pResourceType As %String, ByRef pParamType As %String, ByRef pErrors As HS.Types.FHIR.Errors, ByRef pRevChains As %String, ByRef pAdded As %Boolean)
{
	Set pAdded = 0
	Set pParamType = ""
	
	// Example:
	//
	// GET [base]/Patient?_has:Observation:patient:code=2093-3&_has:Observation:patient:code=8302-2
	// tRevChainTargetSearchParam  = patient
	// tRevChainSourceResourceType = Observation
	// tRevChainSourceSearchParam  = code
	// pParamVals                  = $ListBuild("2093-3","8302-2") (NOT $ListBuild("2093-3,8302-2"))
	//
	// In the above example:
	// - 'code' must be a valid search parameter for Observation.
	// - 'patient' must be a valid search parameter for Observation.
	
	Set tParamName = $Piece(pWholeParam, ":")
	Set tModifier = $Piece(pWholeParam, ":", 2, *)
	Set tRevChainSourceResourceType = $Piece(tModifier, ":", 1)
	Set tRevChainTargetSearchParam = $Piece(tModifier, ":", 2)
	Set tRevChainSourceSearchParam = $Piece(tModifier, ":", 3)
	
	If tParamName'="_has" Quit
	
	Set tSubDelim = "||"
	
	If (tRevChainSourceResourceType="")||(tRevChainTargetSearchParam="")||(tRevChainSourceSearchParam="") {
		Set tText = "Invalid malformed reverse chained search param '"_pWholeParam_"'"
		Set tSeverity = "error"
		Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
		Quit
	}
	
	// First check the reverse chain resource type and search parameter.
	// For example the "Observation" and "code" parts of:
	// GET [base]/Patient?_has:Observation:patient:code=1234-5
	
	If '$Data(%HSFHIRSearchParams(..#VERSIONKEY, tRevChainSourceResourceType)) {
		Set tText = "Invalid source resource type on reverse chained search param"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
		Set tSeverity = "error"
		Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
		Quit
	}
	
	If tRevChainSourceSearchParam="_has" {
		Set tText = "Nested reverse chained search param is not supported"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
		Set tSeverity = "error"
		Do pErrors.logError("not-supported", tSeverity, tText, , , , tText)
		Quit
	}
	
	If '$Data(%HSFHIRSearchParams(..#VERSIONKEY, tRevChainSourceResourceType, tRevChainSourceSearchParam)) {
		Set tText = "Unrecognized source search param on reverse chained search param"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
		Set tSeverity = "error"
		Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
		Quit
	}
	
	Set tRevChainSourceSearchParamType = ..GetSearchParamType(tRevChainSourceResourceType, tRevChainSourceSearchParam)
	
	
	// Next check the target search parameter to ensure is valid, is reference type,
	// and can point to the search resource type pResourceType.
	// For example the "patient" part of:
	// GET [base]/Patient?_has:Observation:patient:code=1234-5
	
	If '$Data(%HSFHIRSearchParams(..#VERSIONKEY, tRevChainSourceResourceType, tRevChainTargetSearchParam)) {
		Set tText = "Unrecognized target search param on reverse chained search param"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
		Set tSeverity = "error"
		Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
		Quit
	}
	
	Set tRevChainTargetSearchParamType = ..GetSearchParamType(tRevChainSourceResourceType, tRevChainTargetSearchParam)
	
	If tRevChainTargetSearchParamType'="reference" {
		Do pParameters.RemoveAt(pWholeParam)
		Set tText = "Invalid reverse chained search param - must be reference type"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
		Set tSeverity = "error"
		Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
		Quit
	}
	
	// %HSFHIRSearchParams stores target resource types, if any, with leading and trailing tilde on the list.
	If tRevChainTargetSearchParam="patient" {
		Set tTargetResourceTypes = "~Patient~"
	} ElseIf tRevChainTargetSearchParam="encounter" {
		Set tTargetResourceTypes = "~Encounter~"
	} Else {
		Set tTargetResourceTypes = $Piece(%HSFHIRSearchParams(..#VERSIONKEY, tRevChainSourceResourceType, tRevChainTargetSearchParam), "^", 3)
		Set tTargetResourceTypes = "~"_tTargetResourceTypes_"~"
	}
	
	If tTargetResourceTypes'[("~"_pResourceType_"~") {
		Do pParameters.RemoveAt(pWholeParam)
		Set tText = "Invalid reverse chained search param - resource type is not target resource type"_$Select(pPreferHandling="strict":"",1:", ignoring")_": "_pWholeParam
		Set tSeverity = "error"
		Do pErrors.logError("invalid", tSeverity, tText, , , , tText)
		Quit
	}
	
	Set pRevChains(tRevChainTargetSearchParam_tSubDelim_tRevChainSourceResourceType_tSubDelim_tRevChainSourceSearchParam) = pParamVals
	Set pAdded = 1
	
	Quit
}

/// Given the pChains log of chained search parameters, construct the SQL and
/// SQL parameter values for the chained portion of the current search.
ClassMethod GetChainedSQL(ByRef pChains As %String, ByRef pChainSQL As %String, ByRef pSQLParams As %String)
{
	Set pChainSQL = ""
	
	If '$Data(pChains) Quit
	
	Set tResourceAbstractClass = "HS.FHIR.v"_..#VERSIONKEY_".Repository.Resource.Abstract"
	Set tSearchTablePackage = $Parameter(tResourceAbstractClass, "SEARCHTABLEPACKAGE")
	
	Set tSubDelim = "||"
	
	Set pChainSQL = pChainSQL_"("
	
	// Example:
	//
	// GET [base]/DiagnosticReport?patient.given=aaron,robert
	// tParam             = patient
	// tChainResourceType = Patient (derived from definition of tParam search param)
	// tChainParam        = given
	// pParamVals         = $ListBuild("aaron,robert") (NOT $ListBuild("aaron","robert"))
	
	Set tParamAndType = ""
	For tParamAndTypeIndex = 1:1 {
		Set tParamAndType = $Order(pChains(tParamAndType))
		If tParamAndType="" Quit
		Set tParam = $Piece(tParamAndType, tSubDelim, 1)
		Set tChainResourceType = $Piece(tParamAndType, tSubDelim, 2)
		Set tParamNormalized = $ClassMethod(tResourceAbstractClass, "NormalizeParamName", tParam)
		If tParamAndTypeIndex>1 Set pChainSQL = pChainSQL_") AND ("
		Set pChainSQL = pChainSQL_"(FOR SOME %ELEMENT("_tParamNormalized_") "
		Set pChainSQL = pChainSQL_"(%VALUE %INLIST "
		Set pChainSQL = pChainSQL_"(SELECT %DLIST('"_tChainResourceType_"/'||$ListGet(_id)) As TargetReferences FROM "_$TR(tSearchTablePackage,".","_")_"."_$S($system.SQL.IsReservedWord(tChainResourceType):$C(34)_tChainResourceType_$C(34), 1:tChainResourceType)
		Set pChainSQL = pChainSQL_" WHERE ("
		Set pChainSQL = pChainSQL_"("
		Set tChainParam = ""
		For tChainParamIndex = 1:1 {
			Set tChainParam = $Order(pChains(tParamAndType, tChainParam))
			If tChainParam="" Quit
			// tChainParam will get normalized in the methods called by ..AddSearchParamToSQL().
			If tChainParamIndex>1 Set pChainSQL = pChainSQL_") AND ("
			Set tParamType = ..GetSearchParamType(tChainResourceType, tChainParam, .tPropType)
			Set tParamVals = pChains(tParamAndType, tChainParam)
			Set tListLength = $ListLength(tParamVals)
			For tListIndex = 1:1:tListLength {
				Set tOneParamVal = $ListBuild($ListGet(tParamVals, tListIndex))
				Do ..AddSearchParamToSQL(tParamType, tChainResourceType, tChainParam, tOneParamVal, tPropType, .pChainSQL, .pSQLParams)
			}
		}
		// Right paren for "("
		Set pChainSQL = pChainSQL_")"
		// Right paren for " WHERE ("
		Set pChainSQL = pChainSQL_")"
		// Right paren for "(SELECT %DLIST("
		Set pChainSQL = pChainSQL_")"
		// Right paren for "(%VALUE %INLIST "
		Set pChainSQL = pChainSQL_")"
		// Right paren for "(FOR SOME %ELEMENT"
		Set pChainSQL = pChainSQL_")"
	}
	
	Set pChainSQL = pChainSQL_")"
	
	Quit
}

/// Given the pRevChains array of reverse chained search parameters, construct the SQL
/// string and SQL parameter values for the reverse chained portion of the current search.
/// This method assumes that pRevChains was generated by ValidateAndLogRevChainParam()
/// and that all reverse chain "_has" parameters are valid for the current search.<br>
/// Reference: http://hl7.org/fhir/STU3/search.html#has<br>
/// Search support here does not include chaining of the _has parameter itself.<br>
/// 
ClassMethod GetRevChainedSQL(ByRef pRevChains As %String, ByRef pRevChainSQL As %String, ByRef pRevChainSQLParams As %String)
{
	Set pRevChainSQL = ""
	Set pRevChainSQLParams = 0
	
	If '$Data(pRevChains) Quit
	
	Set tResourceAbstractClass = "HS.FHIR.v"_..#VERSIONKEY_".Repository.Resource.Abstract"
	Set tSearchTablePackage = $Parameter(tResourceAbstractClass, "SEARCHTABLEPACKAGE")
	
	Set tSubDelim = "||"
	Set tRefColName = "TargetReferences"
	
	// Determine beforehand whether we have _has for multiple source resource types and/or
	// for multiple target search params on the same source resource types. The latter is
	// unlikely but it could happen, for example the search specifies two different _has
	// for the same source resource type, but one specifies target search param "patient"
	// and the other specifies "subject". While these both point to the Patient resource,
	// they technically are two different indicies and should be treated distinctly.
	Set tMultiParams = 0
	Set tPrevious = ""
	Set tSub = ""
	For {
		Set tSub = $Order(pRevChains(tSub))
		If tSub="" Quit
		Set tSourceTypeAndTargetParam = $Piece(tSub, tSubDelim, 1, 2)
		If (tPrevious'="")&&(tSourceTypeAndTargetParam'=tPrevious) {
			Set tMultiParams = 1
			Quit
		}
		Set tPrevious = tSourceTypeAndTargetParam
	}
	
	// Examples:
	//
	// #1: Single parameter, single value
	//
	// GET [base]/Patient?_has:Observation:patient:code=2093-3
	// tRevChainTargetSearchParam  = patient
	// tRevChainSourceResourceType = Observation
	// tRevChainSourceSearchParam  = code
	// pParamVals                  = $ListBuild("2093-3")
	// SQL string = SELECT DISTINCT patient As TargetReferences FROM NSLocal_FHIR_Search_vSTU3.Observation WHERE  FOR SOME %ELEMENT(code) (%VALUE=?)
	//
	//
	// #2: Single parameter, multiple values for OR
	//
	// GET [base]/Patient?_has:Observation:patient:code=2093-3,8302-2
	// tRevChainTargetSearchParam  = patient
	// tRevChainSourceResourceType = Observation
	// tRevChainSourceSearchParam  = code
	// pParamVals                  = $ListBuild("2093-3,8302-2") (NOT $ListBuild("2093-3","8302-2"))
	// SQL string = SELECT DISTINCT patient As TargetReferences FROM NSLocal_FHIR_Search_vSTU3.Observation WHERE  FOR SOME %ELEMENT(code) (%VALUE IN (?,?))
	//
	//
	// #3: Multiple parameters, single source resource type
	//
	// GET [base]/Patient?_has:Observation:patient:code=2093-3,8302-2&_has:Observation:patient:code=718-7
	// SQL string                  = SELECT DISTINCT patient As TargetReferences FROM NSLocal_FHIR_Search_vSTU3.Observation WHERE  (FOR SOME %ELEMENT(code) (%VALUE IN (?,?))) AND (FOR SOME %ELEMENT(code) (%VALUE=?)))
	//
	//
	// #4: Multiple parameters, multiple source resource types
	//
	// GET [base]_has:Observation:patient:code=2093-3,8302-2&_has:Observation:patient:code=718-7&_has:DiagnosticReport:patient:code=58410-2
	// SQL string = 
	//    SELECT RCTable001.TargetReferences FROM
	//
	//     (SELECT DISTINCT patient As TargetReferences FROM NSLocal_FHIR_Search_vSTU3.DiagnosticReport WHERE  FOR SOME %ELEMENT(code) (%VALUE='58410-2') ) RCTable001
	//
	//     INNER JOIN
	//
	//     (SELECT DISTINCT patient As TargetReferences FROM NSLocal_FHIR_Search_vSTU3.Observation WHERE  FOR SOME %ELEMENT(code) (%VALUE IN ('2093-3','8302-2'))) RCTable002
	//
	//     ON RCTable001.TargetReferences = RCTable002.TargetReferences
	//
	//     INNER JOIN
	//
	//     (SELECT DISTINCT patient As TargetReferences FROM NSLocal_FHIR_Search_vSTU3.Observation WHERE  FOR SOME %ELEMENT(code) (%VALUE='718-7') ) RCTable003
	//
	//     ON RCTable001.TargetReferences = RCTable003.TargetReferences
	
	Set tMainTableName = ""
	Set tDistinctSearchesCount = 0
	Set tSub = ""
	For {
		Set tSub = $Order(pRevChains(tSub))
		If tSub="" Quit
		Set tRevChainTargetSearchParam = $Piece(tSub, tSubDelim, 1)
		Set tRevChainTargetSearchParamNormalized = $ClassMethod(tResourceAbstractClass, "NormalizeParamName", tRevChainTargetSearchParam)
		Set tRevChainSourceResourceType = $Piece(tSub, tSubDelim, 2)
		Set tRevChainSourceSearchParam = $Piece(tSub, tSubDelim, 3)
		Set tCurrentSourceTypeAndTargetParam = tRevChainSourceResourceType_tSubDelim_tRevChainTargetSearchParam
		If $i(tSourceAndParamCount(tCurrentSourceTypeAndTargetParam))
		If tSourceAndParamCount(tCurrentSourceTypeAndTargetParam)=1 {
			If $i(tDistinctSearchesCount)
		}
		If tMultiParams {
			Set tTableIndex = $Select(tDistinctSearchesCount<10:"0"_tDistinctSearchesCount,1:tDistinctSearchesCount)
			Set tRCTableName = "RCTable"_tTableIndex
			If tMainTableName="" Set tMainTableName = tRCTableName
			If tDistinctSearchesCount=1 {
				Set pRevChainSQL = pRevChainSQL_"SELECT "_tMainTableName_"."_tRefColName_" FROM ("
			} Else {
				Set pRevChainSQL = pRevChainSQL_" INNER JOIN ("
			}
		}
		Set tParamVals = pRevChains(tSub)
		If tSourceAndParamCount(tCurrentSourceTypeAndTargetParam)=1 {
			Set pRevChainSQL = pRevChainSQL_"SELECT DISTINCT "_tRevChainTargetSearchParamNormalized_" As "_tRefColName
			Set pRevChainSQL = pRevChainSQL_" FROM "_$TR(tSearchTablePackage,".","_")_"."_$S($system.SQL.IsReservedWord(tRevChainSourceResourceType):$C(34)_tRevChainSourceResourceType_$C(34), 1:tRevChainSourceResourceType)
			Set pRevChainSQL = pRevChainSQL_" WHERE "
		} Else {
			Set pRevChainSQL = pRevChainSQL_" AND "
		}
		// tRevChainSourceSearchParam will get normalized in the methods called by ..AddSearchParamToSQL().
		Set tParamType = ..GetSearchParamType(tRevChainSourceResourceType, tRevChainSourceSearchParam, .tPropType)
		Set pRevChainSQL = pRevChainSQL_"("
		Do ..AddSearchParamToSQL(tParamType, tRevChainSourceResourceType, tRevChainSourceSearchParam, tParamVals, tPropType, .pRevChainSQL, .pRevChainSQLParams)
		Set pRevChainSQL = pRevChainSQL_")"
		If tMultiParams {
			Set pRevChainSQL = pRevChainSQL_") "_tRCTableName
			If tDistinctSearchesCount>1 {
				Set pRevChainSQL = pRevChainSQL_" ON "_tMainTableName_"."_tRefColName_" = "_tRCTableName_"."_tRefColName
			}
		}
	}
	
	Quit
}

/// Apply the reverse chaining "_has" parameters to an existing search resultset that contains results.
ClassMethod ApplyReverseChainedSearch(pResourceType As %String, pSessionIdentifier As %String, pHasPrevSearch As %Boolean, ByRef pRevChains As %String, ByRef pResultSet As HS.Util.TransientTable, ByRef pColNums As %String, pLog As %Boolean = 0)
{
	If pResultSet.%ROWCOUNT=0 Quit
	
	Do pResultSet.%SetIterator(0)
	
	// SELECT DISTINCT will return the TargetReferences column data in all uppercase.
	Set tSearchResourceTypeU = $ZConvert(pResourceType, "U")
	Set tSearchResourceTypeUS = tSearchResourceTypeU_"/"
	Set tSearchResourceTypeUSLen = $Length(tSearchResourceTypeUS)
	Set tSearchResourceTypeUSLenP1 = tSearchResourceTypeUSLen+1
	
	Set tTempGlobal = "^||ReverseChain"
	
	Do ..GetRevChainedSQL(.pRevChains, .tSQL, .tSQLParams)
	
	If tSQL="" Quit
	
	Set tStatement = ##class(%SQL.Statement).%New()
	
	// Prepare reverse chain query
	If pLog Set tSQLPrepareStart = $ZHOROLOG
	Set tSC = tStatement.%Prepare(.tSQL)
	If $$$ISERR(tSC) {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "Error preparing query for reverse chain search interaction: "_$system.Status.GetErrorText(tSC)))
	}
	If pLog Set tSQLPrepareEnd = $ZHOROLOG
	If pLog Set tSQLPrepare = (tSQLPrepareEnd-tSQLPrepareStart)
	
	#dim tSQLResultSet As %SQL.StatementResult
	
	// Execute reverse chain query
	If pLog Set tSQLExecuteStart = $ZHOROLOG
	Set tSQLResultSet = tStatement.%Execute(tSQLParams...)
	If (tSQLResultSet.%SQLCODE < 0) { 
		$$$ThrowOnError($$$ERROR($$$GeneralError, "Error executing query for reverse chain search interaction: SQL error, SQLCODE="_tSQLResultSet.%SQLCODE_", Msg="_tSQLResultSet.%Message))
	}
	If pLog Set tSQLExecute1 = ($ZHorolog-tSQLExecuteStart)
	
	// Log performance stats on the reverse chain SQL query itself.
	If pLog {
		set tSQLExecute2 = ($ZHorolog-tSQLExecuteStart)
	
		set tSQLTime = (tSQLPrepare+tSQLExecute1+tSQLExecute2)
		
		// Get the local time, turn the parameters array back into a string (some
		// items may have been removed during parameter parsing) and log:
		// - Local time (YYYY-DD-MM HH:MM:SS)
		// - Re-assembled URL query string
		// - Full SQL statement
		// - Elapsed time for query Prepare
		// - Elapsed time for query Execute
		set tTimestamp = $ZDT($Horolog,3)
		set tOrigQuery = "/"_pResourceType
		set tParamString = "reversechain"
		if tParamString'="" Set tOrigQuery = tOrigQuery_"?"_tParamString
		set tSQLWithParams = tSQL
		set tSQLParams = +$Get(tSQLParams)
		for tI=1:1:tSQLParams { set tSQLWithParams = $REPLACE(tSQLWithParams, "?", "'"_tSQLParams(tI)_"'", , 1) }
		set ^HS.FHIR.Log.Search($i(^HS.FHIR.Log.Search(0))) = $LB(tTimestamp, tOrigQuery, tSQLWithParams, tSQLPrepare, tSQLExecute1, tSQLExecute2)
	}
	
	Set tSQLTargetRefsColNum = 1
	
	If pHasPrevSearch {
		// If there was a regular or chain query that yielded matches:
		// - Parse the reverse chain results into a temp global.
		// - Parse the initial search resultset, and for any that
		//   have a resource id that is not found in the reverse
		//   chain results, set Deleted=1.
		// - If there are no remaining non-Deleted rows in the
		//   resultset then quit the Search method.
		
		While tSQLResultSet.%Next() {
			Set tTargetRefs = tSQLResultSet.%GetData(tSQLTargetRefsColNum)
			For tLLIndex = 1:1:$ListLength(tTargetRefs) {
				Set tTargetRef = $ListGet(tTargetRefs, tLLIndex)
				Set tTargetRefU = $ZConvert(tTargetRef, "U")
				If $Data(@tTempGlobal@(tTargetRef)) Continue
				If $Extract(tTargetRefU, 1, tSearchResourceTypeUSLen)'=tSearchResourceTypeUS Continue
				Set @tTempGlobal@(tTargetRef) = ""
				// SourceIDS are the ResourceLogicalIds (e.g., storage ids) of the
				// reverse chained resources that point to the target resource.
			}
		}
		
		// Keep track of whether there is at least one remaining non-deleted row.
		Set tNonDeletedRows = 0
		
		While (pResultSet.%Next()) {
			If pResultSet.%GetData(pColNums("Deleted")) Continue
			// target ref = search resource type _ "/" _resource id
			Set tTargetRefU = tSearchResourceTypeUS_$ZConvert(pResultSet.%GetData(pColNums("ResourceId")), "U")
			If $Data(@tTempGlobal@(tTargetRefU)) {
				Set tNonDeletedRows = 1
			} Else {
				Do pResultSet.%SetData(pColNums("Deleted"), 1)
				Do pResultSet.%SaveRow()
			}
		}
		
		If tNonDeletedRows {
			Do pResultSet.%SetIterator(0)
		} Else {
			// If all rows have Deleted set to 1, then just re-init the resultset.
			Do ..InitializeSearchResultSet(.pResultSet, , .pColNums)
			Quit
		}
		
		Kill @tTempGlobal
		
	} Else {
		// If reverse chaining is the only criteria, then build the search
		// resultset based only on the reverse chain resultset.
		
		While tSQLResultSet.%Next() {
			Set tTargetRefs = tSQLResultSet.%GetData(tSQLTargetRefsColNum)
			For tLLIndex = 1:1:$ListLength(tTargetRefs) {
				Set tTargetRef = $ListGet(tTargetRefs, tLLIndex)
				Set tTargetRefU = $ZConvert(tTargetRef, "U")
				If $Extract(tTargetRefU, 1, tSearchResourceTypeUSLen)'=tSearchResourceTypeUS Continue
				If '$Data(@tTempGlobal@(tTargetRefU)) {
					Set tResourceId = $Extract(tTargetRef, tSearchResourceTypeUSLenP1, *)
					Set tSC = ..GetStorageIdByTypeAndId(pResourceType, tResourceId, , pSessionIdentifier, .tStorageId)
					$$$ThrowOnError(tSC)
					Do pResultSet.%NewRow()
					Do pResultSet.%SetData(pColNums("Deleted"), "")
					Do pResultSet.%SetData(pColNums("ID"), tStorageId)
					Do pResultSet.%SetData(pColNums("ResourceType"), pResourceType)
					Do pResultSet.%SetData(pColNums("ResourceId"), tResourceId)
					Do pResultSet.%SetData(pColNums("Mode"), "match")
					Set tSC = pResultSet.%SaveRow()
					$$$ThrowOnError(tSC)
					Set @tTempGlobal@(tTargetRefU) = ""
				}
			}
		}
		If $$$ISERR(tSC) Quit
		
		Kill @tTempGlobal
		
		If pResultSet.%ROWCOUNT=0 Quit
		
		Do pResultSet.%SetIterator(0)
	}
	
	Quit
}

/// ValidateSortKeys validates the sort keys that were passed in as URL parameters, as per
/// the FHIR STU3 specification. If validation is successful, it returns information about
/// the sort keys, if any are found, in an array via the pSortKeys parameter. Otherwise a
/// failure status is returned.<br>
/// <br>
/// Input:<br>
/// <li>pResourceType : (required) FHIR resource type.
/// <li>pParameters   : (required) Request URL parameters, passed in as %Library.ArrayOfDataTypes.
/// <br><br>
/// Output:<br>
/// <li>pSortKeys     : Array of sort keys:<br>
/// - pSortKeys(n,"KeyName")   = Sort key name as specified in the request URL.<br>
/// - pSortKeys(n,"KeyNameNormalized") = Sort key name, normalized to match the corresponding search table property name.<br>
/// - pSortKeys(n,"Direction") = "asc" or "desc".<br>
/// - pSortKeys(n,"KeyType")   = Search/sort key field type, for example "token" or "date".<br>
/// - pSortKeys(n,"XPathType") = Search/sort key field type data type from data model.<br>
ClassMethod ValidateSortKeys(pResourceType As %String, pParameters As %Library.ArrayOfDataTypes, ByRef pSortKeys As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Kill pSortKeys
	
	Try {
		If pResourceType="" {
			Set tSC = $$$ERROR($$$GeneralError, "Sorting across resource types is not supported")
			Quit
		}
		
		Set tErrorText = ""
		
		Set tSortKeyCount = 0
		Set tSortKeyList = ""
		Set tKey = ""
		For {
			Set tVal = pParameters.GetNext(.tKey)
			If tKey="" Quit
			If $Extract(tKey,1,5)="_sort" {
				If $Extract(tKey,6,*)'="" Set tErrorText = "Invalid modifier '"_tKey_"' on _sort parameter" Quit
				If $i(tSortKeyCount)
				If tSortKeyCount>1 Set tErrorText = "Invalid multiple sort parameters specified" Quit
				If $ListLength(tVal)>1 Set tErrorText = "Invalid multiple sort parameters specified" Quit
				Set tSortKeyList = tVal
			}
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
		If tSortKeyList="" Quit
		
		Set tSortKeysStr = $ListGet(tSortKeyList,1)
		If tSortKeysStr'=",," {
			If $Extract(tSortKeysStr)="," Set tSortKeysStr = $Extract(tSortKeysStr,2,*)
			If $Extract(tSortKeysStr,*)="," Set tSortKeysStr = $Extract(tSortKeysStr,1,*-1)
		}
		
		If $Length(tSortKeysStr,",")>5 {
			Set tSC = $$$ERROR($$$GeneralError, "Sorting by more than 5 sort keys is not supported")
			Quit
		}
		
		Set tSortKeyCount = 0
		For i = 1:1:$Length(tSortKeysStr,",") {
			Set tSortKeyStr = $Piece(tSortKeysStr,",",i)
			If tSortKeyStr'="" {
				Set tDirection = "asc"
				If $Extract(tSortKeyStr)="-" {
					Set tDirection = "desc"
					Set tSortKeyStr = $Extract(tSortKeyStr,2,*)
				}
				If $Data(tKeys(tSortKeyStr)) Set tErrorText = "Duplicate sort keys '"_tSortKeyStr_"' specified" Quit
				If tSortKeyStr="0" Set tErrorText = "Invalid sort key '"_tSortKeyStr_"' specified" Quit
				If '$Data(%HSFHIRSearchParams("STU3",pResourceType)) Do ..CacheSearchParams(pResourceType)
				Set tSearchParamInfo = $Get(%HSFHIRSearchParams("STU3",pResourceType,tSortKeyStr))
				If $Get(tSearchParamInfo)="" Set tErrorText = "Invalid sort key '"_tSortKeyStr_"' specified" Quit
				Set tSortKeyType = $Piece(tSearchParamInfo,"^",1)
				If tSortKeyType="quantity" Set tErrorText = "Sort key '"_tSortKeyStr_"' is not supported" Quit
				Set tKeys(tSortKeyStr)=""
				If $i(tSortKeyCount)
				Set pSortKeys(tSortKeyCount,"KeyName") = tSortKeyStr
				Set pSortKeys(tSortKeyCount,"KeyNameNormalized") = ##class(HS.FHIR.vCommon.ResourceBase).NormalizeParamName(tSortKeyStr)
				Set pSortKeys(tSortKeyCount,"Direction") = tDirection
				Set pSortKeys(tSortKeyCount,"KeyType") = tSortKeyType
				Set pSortKeys(tSortKeyCount,"XPathType") = $Piece(%HSFHIRSearchParams("STU3",pResourceType,tSortKeyStr),"^",5)
			} Else {
				If tSortKeyStr="" Set tErrorText = "Blank sort key specified" Quit
			}
			If tErrorText'="" Quit
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// AddResultsToTempSort places the ResultSet rows into a temporary global to facilitate sorting.
ClassMethod AddResultsToTempSort(pResultSet As HS.Util.TransientTable, ByRef pSortKeys As %String, pDeletedColNum As %Integer, pStreamletIdColNum As %Integer, pResourceTypeColNum As %Integer, pResourceIdColNum As %Integer, pModeColNum, pSearchTablePackage As %String, pSortGlobal As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		While pResultSet.%Next() {
			If pResultSet.%GetData(pDeletedColNum) Continue
			Set tSC = ..AddResultToTempSort(pResultSet.%GetData(pStreamletIdColNum), pResultSet.%GetData(pResourceTypeColNum), pResultSet.%GetData(pResourceIdColNum), pResultSet.%GetData(pModeColNum), .pSortKeys, pSearchTablePackage, pSortGlobal)
			If $$$ISERR(tSC) quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod AddResultToTempSort(pStreamletId As %String, pResourceType As %String, pResourceId As %String, pMode As %String, pSortKeys As %String, pSearchTablePackage As %String, pSortGlobal As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSortVals = 0
		
		Set tSearchTableObj = $ClassMethod(pSearchTablePackage_"."_pResourceType, "%OpenId", pStreamletId)
		
		#dim tSearchTableVals As %Library.ListOfDataTypes
		
		For i = 1:1:5 {
			If $Data(pSortKeys(i))=0 Quit
			Set tSortVal = ""
			Set tSearchTableVals = ""
			If pSortKeys(i,"KeyType")="date" {
				// date type parameters are indexed in the search tables either by the
				// parameter name, or by parameter name plus "Start" and parameter name
				// plus "End", depending on whether they are variant that includes Period.
				If pSortKeys(i,"XPathType")[".Period" {
					If $Property(tSearchTableObj, pSortKeys(i,"KeyNameNormalized")_"Start")'="" {
						Set tSearchTableVals = $Property(tSearchTableObj, pSortKeys(i,"KeyNameNormalized")_"Start")
					} Else {
						// The list for End, whether it has any values or not, will suffice at this point.
						Set tSearchTableVals = $Property(tSearchTableObj, pSortKeys(i,"KeyNameNormalized")_"End")
					}
				} Else {
					Set tSearchTableVals = $Property(tSearchTableObj, pSortKeys(i,"KeyNameNormalized"))
				}
			} ElseIf pSortKeys(i,"KeyType")="quantity" {
				// Should not be true if sort key validation was done.
				// Sort on quantity type keys is not supported at this time.
			} Else {
				Set tSearchTableVals = $Property(tSearchTableObj, pSortKeys(i,"KeyNameNormalized"))
			}
			
			If tSearchTableVals'="" {
				For j = 1:1:tSearchTableVals.Count() {
					Set tSearchTableVal = tSearchTableVals.GetAt(j)
					If pSortKeys(i,"KeyType")="date" {
						If tSearchTableVal?4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N.E1"Z" {
							// Resource repository indexing of date type fields as
							// UTC when the value includes time. Remove the trailing
							// "Z" and pad out the time fraction to 5 places.
							Set tSearchTableVal = $Extract(tSearchTableVal,1,*-1)
							If $Length(tSearchTableVal)>19 {
								Set tSearchTableVal1 = $Extract(tSearchTableVal,1,19)
								Set tFraction = $Extract(tSearchTableVal, 20, *)
								Set tFraction = tFraction_$Extract("00000",1,5-$Length(tFraction))
								Set tSearchTableVal = tSearchTableVal1_"."_tFraction
							}
						}
					}
					If pSortKeys(i,"KeyType")="token" {
						If tSearchTableVal'["|" Set tSortVal = tSortVal_" "_$ClassMethod("HS.FHIR.vCommon.ResourceBase", "Collate", tSearchTableVal)
					} Else {
						Set tSortVal = tSortVal_" "_$ClassMethod("HS.FHIR.vCommon.ResourceBase", "Collate", tSearchTableVal)
					}
				}
			}
			
			// Tilde makes blank value sort last.  Space would make it sort first.
			Set tSortVals(i) = tSortVal
			If tSortVals(i)="" Set tSortVals(i)="  ~"
			Set tSortVals = i
		}
		
		Set tSortIndexData = pStreamletId_"||"_pResourceType_"||"_pResourceId_"||"_pMode
		
		If tSortVals=1 {
			Set tIndex = $Order(@pSortGlobal@(tSortVals(1), ""), -1) + 1
			Set @pSortGlobal@(tSortVals(1), tIndex) = tSortIndexData
		} ElseIf tSortVals=2 {
			Set tIndex = $Order(@pSortGlobal@(tSortVals(1), tSortVals(2), ""), -1) + 1
			Set @pSortGlobal@(tSortVals(1), tSortVals(2), tIndex) = tSortIndexData
		} ElseIf tSortVals=3 {
			Set tIndex = $Order(@pSortGlobal@(tSortVals(1), tSortVals(2), tSortVals(3), ""), -1) + 1
			Set @pSortGlobal@(tSortVals(1), tSortVals(2), tSortVals(3), tIndex) = tSortIndexData
		} ElseIf tSortVals=4 {
			Set tIndex = $Order(@pSortGlobal@(tSortVals(1), tSortVals(2), tSortVals(3), tSortVals(4), ""), -1) + 1
			Set @pSortGlobal@(tSortVals(1), tSortVals(2), tSortVals(3), tSortVals(4), tIndex) = tSortIndexData
		} ElseIf tSortVals=5 {
			Set tIndex = $Order(@pSortGlobal@(tSortVals(1), tSortVals(2), tSortVals(3), tSortVals(4), tSortVals(5), ""), -1) + 1
			Set @pSortGlobal@(tSortVals(1), tSortVals(2), tSortVals(3), tSortVals(4), tSortVals(5), tIndex) = tSortIndexData
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// CreateSortedResultSet parses the temporary sort global to create a new ResultSet
/// that is in the desired sort order.
ClassMethod CreateSortedResultSet(pSortGlobal As %String, ByRef pSortKeys As %String, pDeletedColNum As %Integer, pStreamletIdColNum As %Integer, pResourceTypeColNum As %Integer, pResourceIdColNum As %Integer, pModeColNum As %Integer, ByRef pResultSet As HS.Util.TransientTable) As %Status [ Internal ]
{
	try {
		Set tSC = $$$OK
		
		// These should not happen, but checking anyway.
		If $Data(pSortKeys)=0 set tSC = $$$ERROR($$$GeneralError, "Sort keys not specified to CreateSortedResultSet") quit
		If $Data(pSortKeys(1))=0 set tSC = $$$ERROR($$$GeneralError, "First sort key not specified to CreateSortedResultSet") quit
		
		// For all loops, direction=desc means -1 for $Order direction,
		// all other direction values mean 1 for $Order direction.
		Set tSub1 = ""
		For {
			Set tSub1 = $Order(@pSortGlobal@(tSub1), $Select(pSortKeys(1,"Direction")="desc":-1,1:1))
			If tSub1="" Quit
			If $Data(pSortKeys(2))=0 {
				Set tN = ""
				For {
					Set tN = $Order(@pSortGlobal@(tSub1, tN), 1, tData)
					If tN="" Quit
					Do pResultSet.%NewRow()
					Do pResultSet.%SetData(pDeletedColNum, "")
					Do pResultSet.%SetData(pStreamletIdColNum, $Piece(tData,"||",1))
					Do pResultSet.%SetData(pResourceTypeColNum, $Piece(tData,"||",2))
					Do pResultSet.%SetData(pResourceIdColNum, $Piece(tData,"||",3))
					Do pResultSet.%SetData(pModeColNum, $Piece(tData,"||",4))
					Set tSC = pResultSet.%SaveRow()
					If $$$ISERR(tSC) Quit
				}
				Continue
			}
			Set tSub2 = ""
			For {
				Set tSub2 = $Order(@pSortGlobal@(tSub1, tSub2), $Select(pSortKeys(2,"Direction")="desc":-1,1:1))
				If tSub2="" Quit
				If $Data(pSortKeys(3))=0 {
					Set tN = ""
					For {
						Set tN = $Order(@pSortGlobal@(tSub1, tSub2, tN), 1, tData)
						If tN="" Quit
						Do pResultSet.%NewRow()
						Do pResultSet.%SetData(pDeletedColNum, "")
						Do pResultSet.%SetData(pStreamletIdColNum, $Piece(tData,"||",1))
						Do pResultSet.%SetData(pResourceTypeColNum, $Piece(tData,"||",2))
						Do pResultSet.%SetData(pResourceIdColNum, $Piece(tData,"||",3))
						Do pResultSet.%SetData(pModeColNum, $Piece(tData,"||",4))
						Set tSC = pResultSet.%SaveRow()
						If $$$ISERR(tSC) Quit
					}
					Continue
				}
				Set tSub3 = ""
				For {
					Set tSub3 = $Order(@pSortGlobal@(tSub1, tSub2, tSub3), $Select(pSortKeys(3,"Direction")="desc":-1,1:1))
					If tSub3="" Quit
					If $Data(pSortKeys(4))=0 {
						Set tN = ""
						For {
							Set tN = $Order(@pSortGlobal@(tSub1, tSub2, tSub3, tN), 1, tData)
							If tN="" Quit
							Do pResultSet.%NewRow()
							Do pResultSet.%SetData(pDeletedColNum, "")
							Do pResultSet.%SetData(pStreamletIdColNum, $Piece(tData,"||",1))
							Do pResultSet.%SetData(pResourceTypeColNum, $Piece(tData,"||",2))
							Do pResultSet.%SetData(pResourceIdColNum, $Piece(tData,"||",3))
							Do pResultSet.%SetData(pModeColNum, $Piece(tData,"||",4))
							Set tSC = pResultSet.%SaveRow()
							If $$$ISERR(tSC) Quit
						}
						Continue
					}
					Set tSub4 = ""
					For {
						Set tSub4 = $Order(@pSortGlobal@(tSub1, tSub2, tSub3, tSub4), $Select(pSortKeys(4,"Direction")="desc":-1,1:1))
						If tSub4="" Quit
						If $Data(pSortKeys(5))=0 {
							Set tN = ""
							For {
								Set tN = $Order(@pSortGlobal@(tSub1, tSub2, tSub3, tSub4, tN), 1, tData)
								If tN="" Quit
								Do pResultSet.%NewRow()
								Do pResultSet.%SetData(pDeletedColNum, "")
								Do pResultSet.%SetData(pStreamletIdColNum, $Piece(tData,"||",1))
								Do pResultSet.%SetData(pResourceTypeColNum, $Piece(tData,"||",2))
								Do pResultSet.%SetData(pResourceIdColNum, $Piece(tData,"||",3))
								Do pResultSet.%SetData(pModeColNum, $Piece(tData,"||",4))
								Set tSC = pResultSet.%SaveRow()
								If $$$ISERR(tSC) Quit
							}
							Continue
						}
						Set tSub5 = ""
						For {
							Set tSub5 = $Order(@pSortGlobal@(tSub1, tSub2, tSub3, tSub4, tSub5), $Select(pSortKeys(5,"Direction")="desc":-1,1:1))
							If tSub5="" Quit
							Set tN = ""
							For {
								Set tN = $Order(@pSortGlobal@(tSub1, tSub2, tSub3, tSub4, tSub5, tN), 1, tData)
								If tN="" Quit
								Do pResultSet.%NewRow()
								Do pResultSet.%SetData(pDeletedColNum, "")
								Do pResultSet.%SetData(pStreamletIdColNum, $Piece(tData,"||",1))
								Do pResultSet.%SetData(pResourceTypeColNum, $Piece(tData,"||",2))
								Do pResultSet.%SetData(pResourceIdColNum, $Piece(tData,"||",3))
								Do pResultSet.%SetData(pModeColNum, $Piece(tData,"||",4))
								Set tSC = pResultSet.%SaveRow()
								If $$$ISERR(tSC) Quit
							}
						}
					}
				}
			}
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod SearchRelated(pCompartment As %String = "", pResourceId As %String = "", pSessionIdentifier As %String = "", ByRef pResultSet As HS.Util.TransientTable) As %Status
{
	set tSC = $$$OK
	
	set pResultSet = ""
	
	try {
		// Query for related resources
		set tStatement = ##class(%SQL.Statement).%New()
		set tSQL = "SELECT ID FROM HS_FHIR_vSTU3_Repository_Resource.Abstract WHERE FOR SOME %ELEMENT(Compartments) (%VALUE=?)"
		if (pSessionIdentifier'="") { set tSQL = tSQL_" AND Session=?" }
		set tSC = tStatement.%Prepare(tSQL)
		if $$$ISERR(tSC) {
			set tSC = $$$ERROR($$$GeneralError, "Error preparing SearchRelated query for $everything operation, status = "_$system.Status.GetErrorText(tSC))
			quit
		}
		set tPatientRef = pCompartment_"/"_pResourceId
		if (pSessionIdentifier="") { set tResult = tStatement.%Execute(tPatientRef) }
		else { set tResult = tStatement.%Execute(tPatientRef, pSessionIdentifier) }
		if (tResult.%SQLCODE < 0) { 
			set tSC = $$$ERROR($$$GeneralError, "SQL error executing SearchRelated query for $everything operation, SQLCODE="_tResult.%SQLCODE_", Msg="_tResult.%Message)
			quit 
		}
		set pResultSet = ##class(HS.Util.TransientTable).%New(tResult)
		
	} catch eException {
		set tSC = eException.AsStatus()
	}
	
	quit tSC
}

ClassMethod SearchInclude(pResourceType As %String, pStorageId As %String, pSessionIdentifier As %String, pValidIncludes As %List, ByRef pAlreadyIncluded As %String, pStorageIds As %List) As %Status
{
	Set tSC = $$$OK
	
	Set pStorageIds = ""
	
	Try {
		// See http://hl7.org/fhir/STU3/search.html#include for a full description of the _include parameter.
		// The _include parameter allows a client to request that, in addition to the resources selected by
		// by the criteria of a query, the server also include in the response bundle certain resources
		// referenced by the selected resources. The parts of an _include parameter are:
		// 1. The name of the source resource from which the join comes (for a regular _include,
		//    which is all we support right now, this should always be the same as the resource type
		//    being searched on)
		// 2. The name of the search parameter which must be of type reference
		// 3. (Optional) A specific of type of target resource (for when the search parameter refers to 
		//    multiple possible target types)
		set tSearchTableObj = $CLASSMETHOD(##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).#SEARCHTABLEPACKAGE_"."_pResourceType, "%OpenId", pStorageId)
		
		// The only way I can think of that this might happen is if this is a paged search, and this result is not on the first page,
		//  and between the time the search was executed and this page was accessed, the resource was deleted. The standard
		//  discusses this briefly: http://www.hl7.org/fhir/search.html#currency
		if ('$IsObject(tSearchTableObj)) Quit
		
		for tJ=1:1:$LL(pValidIncludes) {
			set tOneInclude = $LG(pValidIncludes, tJ)
			set tIncludeBaseType = $P(tOneInclude, ":", 1)
			set tIncludeParam = $P(tOneInclude, ":", 2)
			set tIncludeTargetType = $P(tOneInclude, ":", 3)
			
			set tValueList = $PROPERTY(tSearchTableObj, ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).NormalizeParamName(tIncludeParam))
			for tK=1:1:tValueList.Count() {
				set tOneValue = tValueList.GetAt(tK)
				// Skip resources that have already been included in this bundle
				if ($D(pAlreadyIncluded(tOneValue))) { continue }
				// Only want references formatted as [type]/[id]
				if ($L(tOneValue,"/")'=2) { continue }
				// If the include has a target type (optional), only include resources of that type
				//  (since some references can refer to more than one type of resource)
				set tTargetType = $P(tOneValue, "/", 1)
				if (tIncludeTargetType'="") && (tTargetType'=tIncludeTargetType) { continue }
				set tTargetResourceId = $P(tOneValue, "/", 2)
				set tSC = ..GetStorageIdByTypeAndId(tTargetType, tTargetResourceId, , pSessionIdentifier, .tTargetLogicalId)
				if (tTargetLogicalId="") { continue }
				set pStorageIds = pStorageIds_$ListBuild(tTargetLogicalId)
				
				// Set this to keep track of which resources have already been included, so nothing gets included more than once.
				set pAlreadyIncluded(tOneValue) = ""
				
			}	// Loop over references for current resource
			quit:$$$ISERR(tSC)
		}
			
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// History carries out the FHIR storage-specific logic for the history interaction.<br>
/// Reference: http://hl7.org/fhir/STU3/http.html#history<br>
/// This method retrieves all the stored versions of a specified FHIR resource and returns
/// a result set object that includes minimal but vital information about each item.<br>
/// Input:<br>
/// <li>pResourceType      : (required) FHIR resource type.
/// <li>pResourceId        : (required) FHIR resource id.
/// <li>pSince             : FHIR instant-type value for the history _since parameter. This is for
///                          requesting only the history items that occurred after a specified time.
/// <li>pAt                : (not supported) FHIR dateTime-type value for the history _at parameter.
/// <li>pSessionIdentifier : Session identifier, used for session-based resource storage.
/// <br>Output:<br>
/// <li>pResultSet         : <class>HS.Util.TransientTable</class> object for holding the results of
///                          the history search.  Columns in pResultSet are:<br>
///                          StorageId = The physical storage object id.<br>
///                          Verb = The HTTP method that produced the history item (e.g., PUT, POST).<br>
///                          Deleted = 1 means the item is the result of a DELETE, 0 means not deleted.
ClassMethod History(pResourceType, pResourceId, pSince = "", pAt = "", pSessionIdentifier As %String = "", Output pResultSet As HS.Util.TransientTable, Output pErrors As HS.Types.FHIR.Errors) As %Status
{
	#dim tStreamlet As HS.FHIR.vSTU3.Repository.Resource.Abstract
	
	Set tSC = $$$OK
	
	Try {
		Set pResultSet = ##class(HS.Util.TransientTable).%New()
		For tColumnName = "StorageId", "Verb", "Deleted" {
			Set tSC = pResultSet.%AddColumn(tColumnName, "%String", , 1)
			If 'tSC {
				Set tSC = $$$ERROR($$$GeneralError, "Unable to set column "_tColumnName_" into TransientTable")
				Quit
			}
		}
		If $$$ISERR(tSC) Quit
		
		// if the resource doesn't exist (not even deleted), return status 404 Not Found
		If ('##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource does not exist")
			Quit
		}
		
		// Convert _since value to UTC
		If (pSince'="") {
			// The type of the _since parameter is "instant": "known at least to the second and always includes a time zone".
			// Validate that here.
			// YYYY-MM-DDThh:mm:ss[Z,-hh:mm,+hh:mm]
			If (pSince ? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N1(1"Z",1"-"2N1":"2N,1"+"2N1":"2N)) {
				Set tSince = ##class(HS.FHIR.Utils).ConvertToUTC(pSince)
			}
			Else {
				Set tSince = ""
				// value as passed in failed validation, so ignore it
				Set tText = "_since parameter invalid, ignoring: "_pSince
				Do pErrors.logError("value", "warning", tText, , , , tText)
			}
		} Else {
			Set tSince = ""
		}
		
		Set tCurrentVersion = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).CurrentVersion(pSessionIdentifier, pResourceType, pResourceId)
		
		For tI=tCurrentVersion:-1:1 {
			Set tSC = ..GetStorageIdByTypeAndId(pResourceType, pResourceId, tI, pSessionIdentifier, .tLogicalId)
			If $$$ISERR(tSC) Quit
			Set tSC = ..GetStorageObjectByStorageId(tLogicalId, .tStreamlet)
			If $$$ISERR(tSC) Quit
			
			// Handle "_since" parameter
			// We are processing the versions in reverse chronological order, so once we find one with
			//  LastModified earlier than "_since", quit.
			// Note this correctly handles the case where tSince="".
			If (tSince]tStreamlet.LastModified) { Quit }
			
			Set tSC = pResultSet.%NewRow()
			Set tSC = pResultSet.%Set("StorageId", tLogicalId)
			Set tSC = pResultSet.%Set("Verb", tStreamlet.Verb)
			Set tSC = pResultSet.%Set("Deleted", tStreamlet.Deleted)
			Set tSC = pResultSet.%SaveRow()
		}
		
		If pResultSet.%ROWCOUNT>0 {
			// Setting iterator to -1 and then doing a %Next seems to be the only way
			// to set the set the current row to 0 after you build the result set row
			// by row, as opposed to building it via %New (like Search does).
			Set tSC = pResultSet.%SetIterator(-1)
			If $$$ISERR(tSC) {
				Set tSC = $$$ERROR($$$GeneralError, "Unable to set result set iterator to -1")
				Quit
			}
			Set tSCI = pResultSet.%Next(.tSC)
			If $$$ISERR(tSC) {
				Quit
			} ElseIf $$$ISERR(tSCI) {
				Set tSC = $$$ERROR($$$GeneralError, "Unable to do initial %Next of result set")
				Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// IsSharedResourceType returns a Boolean value indicating whether the specified FHIR
/// resource type includes a reference property that may point to a Patient resource.
/// "Shared" in the context of this function means the resource type may NOT point to
/// a Patient resource.<br>
/// Input:<br>
/// <li>pResourceType : (required) FHIR resource type.
ClassMethod IsSharedResourceType(pResourceType As %String) As %Boolean
{
	If $Data(%FHIRNonSharedResourceTypes(..#VERSIONKEY))=0 {
		// This list of resource type / element combinations was generated by parsing the
		// STU3 dataelements.xml using this context and expression:
		// context    = "/f:Bundle/f:entry[f:resource/f:DataElement]/f:resource/f:DataElement[f:element/f:type/f:code/@value='Reference' and (f:element/f:type/f:targetProfile/@value='http://hl7.org/fhir/StructureDefinition/Patient')]"
		// expression = "f:id/@value"
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Account","guarantor.party")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Account","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AdverseEvent","recorder")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AdverseEvent","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AllergyIntolerance","asserter")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AllergyIntolerance","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AllergyIntolerance","recorder")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Appointment","participant.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AppointmentResponse","actor")=""
		// An AuditEvent can be linked to multiple resources, so AuditEvent should be considered shared.
		//Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AuditEvent","agent.reference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Basic","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"BodySite","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CarePlan","activity.detail.performer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CarePlan","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CarePlan","subject")=""
		// Despite CareTeam possibly involving more than one person, it should be considered non-shared.
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CareTeam","participant.member")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CareTeam","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ChargeItem","enterer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ChargeItem","participant.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ChargeItem","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Claim","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Claim","payee.party")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ClaimResponse","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ClinicalImpression","subject")=""
		// Despite Communication and CommunicationRequest both having recipient and
		// sender and subject properties, they are considered non-shared.
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Communication","recipient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Communication","sender")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Communication","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","recipient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","requester.agent")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","sender")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Composition","attester.party")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Composition","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Condition","asserter")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Condition","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Consent","actor.reference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Consent","consentingParty")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Consent","except.actor.reference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Consent","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Contract","agent.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Contract","signer.party")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Contract","term.agent.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Coverage","beneficiary")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Coverage","payor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Coverage","policyHolder")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Coverage","subscriber")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DetectedIssue","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Device","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DeviceRequest","performer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DeviceRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DeviceUseStatement","source")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DeviceUseStatement","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DiagnosticReport","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentManifest","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentManifest","recipient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentManifest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentReference","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentReference","context.sourcePatientInfo")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentReference","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"EligibilityRequest","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Encounter","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"EnrollmentRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"EpisodeOfCare","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ExplanationOfBenefit","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ExplanationOfBenefit","payee.party")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"FamilyMemberHistory","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Flag","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Flag","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Goal","expressedBy")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Goal","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Group","member.entity")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"GuidanceResponse","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImagingManifest","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImagingManifest","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImagingStudy","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Immunization","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImmunizationRecommendation","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"List","source")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"List","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MeasureReport","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Media","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationAdministration","performer.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationAdministration","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationDispense","performer.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationDispense","receiver")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationDispense","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationRequest","requester.agent")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationStatement","informationSource")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationStatement","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"NutritionOrder","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Observation","performer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Observation","subject")=""
		// link.other is not really what makes this non-shared, it is just the fact that this type is Patient.
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Patient","link.other")=""
		// A Person can be linked to multiple Patients, so Person should be considered shared.
		//Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Person","link.target")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Procedure","performer.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Procedure","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ProcedureRequest","performer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ProcedureRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Provenance","agent.onBehalfOfReference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Provenance","agent.whoReference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"QuestionnaireResponse","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"QuestionnaireResponse","source")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ReferralRequest","requester.agent")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ReferralRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"RelatedPerson","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"RequestGroup","action.participant")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"RequestGroup","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ResearchSubject","individual")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"RiskAssessment","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Schedule","actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Sequence","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Signature","onBehalfOfReference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Signature","whoReference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Specimen","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"SupplyDelivery","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"SupplyRequest","deliverTo")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"SupplyRequest","requester.agent")=""
		// Despite Task having requester and owner, it will be considered to be non-shared.
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Task","owner")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Task","requester.agent")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Task","restriction.recipient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"VisionPrescription","patient")=""
	}
	
	Quit ($Data(%FHIRNonSharedResourceTypes(..#VERSIONKEY,pResourceType))=0)
}

/// Given a resource type and the name of a search parameter, return the type
/// of that parameter (token, string, reference, date, uri, quantity, number, etc.).
/// This will return null if pResourceType is valid but pParamName is not recognized.
ClassMethod GetSearchParamType(pResourceType As %String, pParamName As %String, ByRef pPropType As %String) As %String
{
	Quit ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetSearchParamType(pResourceType, pParamName, .pPropType)
}

ClassMethod FindMatchingResourceIds(pResourceType As %String, pResourceStreamId As %String, pSession As %String = "") As %String
{
	// Not implemented.
	Quit ""
}

ClassMethod GenerateResourceId(pResourceType As %String, pSession As %String = "") As %String
{
	Quit ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GenerateResourceId(pResourceType, pSession)
}

ClassMethod CacheSearchParams(pResourceType As %String) As %Status
{
	Quit ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).CacheSearchParams(pResourceType, ..#CUSTOMSTORAGEPKG)
}

/// OnInit carries out any tasks desired to be done upon first use of this storage class.
/// For example upon startup of a business host that is using this class as its FHIR
/// storage class.
ClassMethod OnInit() As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..LoadAllSearchParams()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Load the search parameter definitions for all resource types into %HSFHIRSearchParams().
/// For each resource type, if a custom storage class exists in the class package indicated
/// by CUSTOMSTORAGEPKG, then use that class instead of the one in the standard location.
ClassMethod LoadAllSearchParams() As %Status
{
	Set tSC = $$$OK
	
	For tStoragePkg = ..#CUSTOMSTORAGEPKG, ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).#STORAGEPKG {
		If tStoragePkg'="" {
			If $Extract(tStoragePkg,*)="." Set tStoragePkg = $Extract(tStoragePkg,1,*-1)
			
			Kill tStorageClasses
			
			Do $system.OBJ.GetPackageList(.tStorageClasses, tStoragePkg)
			
			Set tStorageClass = ""
			For {
				Set tStorageClass = $Order(tStorageClasses(tStorageClass))
				If tStorageClass="" Quit
				If $Extract(tStorageClass,*-8,*)=".Abstract" Continue
				If $Extract(tStorageClass,*-7,*)=".Generic" Continue
				Set tResourceType = $Piece(tStorageClass, ".", *)
				If $Data(tResourceTypesDone(tResourceType)) Continue
				Set tSC = ..CacheSearchParams(tResourceType)
				If $$$ISERR(tSC) Quit
				Set tResourceTypesDone(tResourceType) = ""
			}
		}
		If $$$ISERR(tSC) Quit
	}
	
	Quit tSC
}

/// For the specified search parameter name and value(s), if the search parameter is
/// a reference type parameter, gather search parameter id values that unambiguously
/// apply to the specified resource type. Return an error if the search parameter is
/// invalid. Return an error if the search parameter value specifies a resource type
/// that does not apply to the search parameter.
ClassMethod GetRefTypeIdsFromSearchParam(pParamName As %String, pParamVals, pSearchResourceType As %String, pReferenceResourceType As %String, ByRef pReturnVals As %String) As %Status
{
	Quit ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetRefTypeIdsFromSearchParam(pParamName, pParamVals, pSearchResourceType, pReferenceResourceType, .pReturnVals)
}

/// API
/// In this context, "orphaned" means the resource references a non-existent
/// session.<br>
/// There *should* never be orphaned resources. The deletion of the referenced
/// session should trigger the delete of the resource. Still, this utility
/// is provided in case something goes wrong and orphaned resources are left
/// in the repository.
ClassMethod DeleteOrphanedResources() As %Status
{
	Quit ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).DeleteOrphanedResources()
}

ClassMethod DeleteSessionResources(pSession As %String) As %Status
{
	Quit ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).DeleteSessionResources(pSession)
}

ClassMethod Patch(pPatchContentType As %String, pPatchStream As %Stream.Object, pResourceType As %String, pResourceId As %String, pResourceSchema As %String, pParameters, pIfMatchVersion As %String = "", pSessionIdentifier As %String = "", pResourceContentType As %String, ByRef pResourceStream As %Stream.Object, Output pResourceObject, Output pStorageId As %String, Output pErrors) As %Status
{
	Set tSC = $$$OK
	
	Set pResourceObject = ""
	Set pStorageId = ""
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// The initial transaction level might not be 0, if this is part of a TRANSACTION interaction
		Set tInitLevel = $TLEVEL
		
		// Simplify Content Types for later checks.
		If $ZConvert(pPatchContentType,"L")["json" {
			Set tPatchContentType = "JSON"
		} ElseIf $ZConvert(pPatchContentType,"L")["xml" {
			Set tPatchContentType = "XML"
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid patch content type '"_pPatchContentType_"' specified")
			Quit
		}
		If $ZConvert(pResourceContentType,"L")["json" {
			Set tResourceContentType = "JSON"
		} ElseIf $ZConvert(pResourceContentType,"L")["xml" {
			Set tResourceContentType = "XML"
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid resource content type '"_pResourceContentType_"' specified")
			Quit
		}
		
		If $Get(pResourceSchema)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource schema not specified")
			Quit
		}
		
		If $Get(pParameters)'="" {
			If $IsObject(pParameters) {
				If pParameters.%IsA("%Library.ArrayOfDataTypes") {
					Set tParameters = pParameters
				} Else {
					Set tSC = $$$ERROR($$$GeneralError, "Conditional patch search parameter input must be string or %ArrayOfDataTypes")
					Quit
				}
			} Else {
				Set tSC = ##class(HS.FHIR.Utils).URLParamStringToArray(pParameters, .tParameters)
				If $$$ISERR(tSC) Quit
			}
			// Remove non-search keys from the list of parameters, just to make sure that
			// there are actual search criteria specified.
			Set tSearchParameters = ""
			If tParameters.Count()>0 {
				Set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
				Set tSearchParameters = ##class(%Library.ArrayOfDataTypes).%New()
				Set tKey = ""
				For {
					Set tValue = tParameters.GetNext(.tKey)
					If tKey="" Quit
					If tNotSearchKeys'[(","_tKey_",") {
						Do tSearchParameters.SetAt(tValue, .tKey)
					}
				}
				If tSearchParameters.Count()=0 Set tSearchParameters = ""
			}	
		} Else {
			Set tSearchParameters = ""
		}
		
		If (tSearchParameters'="")&&(pResourceId'="") {
			Set tSC = $$$ERROR($$$GeneralError, "Cannot include resource id and conditional patch search parameters on the same patch request")
			Quit
		} ElseIf (tSearchParameters="")&&(pResourceId="") {
			Set tSC = $$$ERROR($$$GeneralError, "Neither resource id nor conditional patch search parameters specified")
			Quit
		}
		
		// If no resource id then we know we're doing conditional patch, same rules as conditional update.
		If pResourceId="" {
			Set tSC = ..Search(pResourceType, , , tSearchParameters, pSessionIdentifier, .tResultSet, .tErrors)
			If $$$ISERR(tSC) Quit
			
			Set tMatches = 0
			
			While (tResultSet.%Next()) {
				Set tMatches = tResultSet.%ROWCOUNT
				If tMatches>1 Quit
				Set pStorageId = tResultSet.%Get("ID")
			}
			
			If tMatches=0 {
				Set tSC = $$$ERROR($$$GeneralError, "conditional patch search found no matches, PATCH rejected")
				Quit
			} ElseIf tMatches=1 {
				Set tStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClassFromLogicalId(pStorageId)
				Set tStreamlet = $ClassMethod(tStorageClass, "%OpenId", pStorageId)
				Set pResourceId = tStreamlet.ResourceId
				Kill tStreamlet
			} ElseIf tMatches>1 {
				Set tSC = $$$ERROR($$$GeneralError, "conditional patch search found more than one match, PATCH rejected")
				Quit
			}
		} Else {
			Set tSC = ..GetStorageIdByTypeAndId(pResourceType, pResourceId, , pSessionIdentifier, .pStorageId)
			If $$$ISERR(tSC) {
				Set tText = $system.Status.GetErrorText(tSC)
				If tText["Resource not found:" { // when returned via HTTP, will have status 404 Not Found
					Set tSC = $$$ERROR($$$GeneralError, "Resource does not exist")
				} ElseIf tText["Resource previously deleted" { // when returned via HTTP, will have status 410 Gone
					Set tSC = $$$ERROR($$$GeneralError, "Resource is deleted")
				}
				Quit
			}
		}
		If $$$ISERR(tSC) Quit
		
		If '$IsObject($Get(pPatchStream))||('pPatchStream.%IsA("%Stream.Object")) {
			Set tSC = $$$ERROR($$$GeneralError, "Patch input must be a %Stream.Object")
			Quit
		} ElseIf 'pPatchStream.Size {
			Set tSC = $$$ERROR($$$GeneralError, "Blank Patch input")
			Quit
		}
		
		Set tSC = ..GetStorageDataByStorageId(pStorageId, , , .tCurrentVersionId, , .tResourceStoredFormat)
		If $$$ISERR(tSC) Quit
		
		// If the request contains an If-Match header, assert that the value matches the current version ID of the resource.
		// (Used for resource contention - see http://hl7.org/fhir/STU3/http.html#update#2.21.0.11)
		// Allow pIfMatchVersion to be just the specified version, or a whole HTTP If-Match value.
		If pIfMatchVersion?1"W/""".E1"""" {
			Set tIfMatchVersion = $Extract(pIfMatchVersion, 4, *-1)
		} Else {
			Set tIfMatchVersion = pIfMatchVersion
		}
		If (tIfMatchVersion'="")&&(tIfMatchVersion'=tCurrentVersionId) {
			Set tSC = $$$ERROR($$$GeneralError, "'If-Match' header ("_pIfMatchVersion_") does not match current version ID ("_tCurrentVersionId_"), PATCH rejected")
			Quit
		}
		
		If '$IsObject($Get(pResourceStream)) Set pResourceStream = ##class(%Stream.TmpCharacter).%New()
		
		Set tPatchResourceStream = ##class(%Stream.TmpCharacter).%New()
		
		// Read the resource in the mime type of the Patch content.
		Set tSC = ..ReadByStorageId(pPatchContentType, pResourceSchema, pStorageId, , , .tPatchResourceStream, .tPatchResourceObj, .pErrors)
		If $$$ISERR(tSC) Quit
		
		Set tUpdated = 0
		
		// Carry out the patch, and leave this If Else block with a %DynamicObject or %XML.Document in hand.
		If tPatchContentType="JSON" {
			Set tSC = ..PatchJSONDynObj(tPatchResourceObj, pPatchStream, .tUpdated)
			If ($$$ISERR(tSC))&&($system.Status.GetErrorCodes(tSC)=5035) {
				Set tSC = $$$ERROR($$$GeneralError, $system.Status.GetErrorText(tSC)_" - Patch JSON input is not well-formed")	
			}
			// Update the resource stream only if the resource object was updated.
			If ($$$ISOK(tSC))&&(tUpdated) {
				Kill tPatchResourceStream
				Set tPatchResourceStream = ##class(%Stream.TmpCharacter).%New()
				// if both store and accept are the same, use that, otherwise use patch object natively
				Do tPatchResourceObj.%ToJSON(.tPatchResourceStream)
			}
		} Else {
			Set tSC = ..PatchXMLWithXSLT(.tPatchResourceStream, tPatchResourceObj, pPatchStream, .tUpdated, .tAdded)
			// Due to the nature of the XML Patch add operation, elements could have been
			// added to the resource stream out of FHIR XML sequence order. If add was
			// was done as part of this patch, then de-serialize the patched resource
			// stream into an HS FHIR object and then serialize it back into stream.
			// For all cases, re-create the %XML.Document for the resource.
			If ($$$ISOK(tSC))&&(tUpdated) {
				If tAdded {
					Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR("xml", tPatchResourceStream, .tPatchResourceHSObj, "HS.FHIR.vSTU3.Model.Resource")
					If $$$ISERR(tSC) Quit
					Kill tPatchResourceStream
					Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR("xml", tPatchResourceHSObj, .tPatchResourceStream)
					If $$$ISERR(tSC) Quit
					Kill tPatchResourceHSObj
				}
				Kill tPatchResourceObj
				Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject("xml", tPatchResourceStream, .tPatchResourceObj)
			}
		}
		If $$$ISERR(tSC) Quit
		
		// If the resource was updated, do schema-based validation, and save it in its repo stored format.
		If tUpdated {
			// Validate using the resource object output by the Patch.
			Set tSC = ##class(HS.FHIR.Validation.ResourceValidator).ValidateResource( , , pResourceSchema, tPatchResourceObj, .pErrors)
			If $$$ISERR(tSC) Quit
			
			If tPatchContentType=tResourceStoredFormat {
				Set tResourceStoreObj = tPatchResourceObj
				Set tResourceStoreStream = tPatchResourceStream
			} ElseIf (tPatchContentType="JSON")&&(tResourceStoredFormat="XML") {
				Set tSC = ##class(HS.FHIR.Utils).JSONDynamicObjectToXML(tPatchResourceObj, .tResourceStoreStream, pResourceSchema)
				If $$$ISERR(tSC) Quit
				Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject("xml", tResourceStoreStream, .tResourceStoreObj)
				If $$$ISERR(tSC) Quit
			} ElseIf (tPatchContentType="XML")&&(tResourceStoredFormat="JSON") {
				// TODO: use the new XMLDocumentToDynObj instead, and if necessary for return, dynobj.%toJSON
				Set tSC = ##class(HS.FHIR.Utils).XMLToJSON(tPatchResourceStream, .tResourceStoreStream, pResourceSchema)
				If $$$ISERR(tSC) Quit
				Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject("json", tResourceStoreStream, .tResourceStoreObj)
				If $$$ISERR(tSC) Quit
			}
			
			#dim tRepoResource As HS.FHIR.vSTU3.Repository.Resource.Abstract
			set tStorageClass = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).GetStorageClass(pResourceType, .tSC, ..#CUSTOMSTORAGEPKG) quit:$$$ISERR(tSC)
			set tRepoResource = $CLASSMETHOD(tStorageClass, "%New")
			set tRepoResource.ResourceObject = tResourceStoreObj
			set tRepoResource.ResourceSchema = pResourceSchema
			set tRepoResource.ResourceType = pResourceType
			set tRepoResource.Format = tResourceStoredFormat
			set tRepoResource.Verb = "PUT"
			set tRepoResource.Session = pSessionIdentifier
			set tRepoResource.ResourceId = pResourceId
			set tSC = tRepoResource.OnBeforeMatch() quit:$$$ISERR(tSC)
			
			// Patch can only be done on an existing stored resource. Deprecate the current version.
			// The deprecation of the existing resource and the save of the new one need to
			// happen inside a transaction so that an error while saving the new one does not
			// leave the original resource as deprecated.
			if tInitLevel=0 TSTART
			set tSC = ##class(HS.FHIR.vSTU3.Repository.Resource.Abstract).DeprecateResource(tRepoResource.Session,pResourceType,pResourceId) quit:$$$ISERR(tSC)
			set tSC = tRepoResource.SaveResource() quit:$$$ISERR(tSC)
			if tInitLevel=0 TCOMMIT
			
			set pStorageId = tRepoResource.%Id()
		}
		
		// Copy the resource string / stream to the resource stream that we will be returning.
		
		If pResourceStream.%IsA("HS.SDA3.QuickStream") {
			Do pResourceStream.Clear(0)
		} Else {
			Do pResourceStream.Clear()
		}
		
		If tResourceContentType=tPatchContentType {
			Set pResourceStream = tPatchResourceStream
			Set pResourceObject = tPatchResourceObj
		} ElseIf tResourceContentType=tResourceStoredFormat {
			// Stored object and stream may not have gotten created if Patch did no updates.
			If '$IsObject($Get(tResourceStoreObj)) {
				Set tSC = ..ReadByStorageId($ZConvert(tResourceContentType,"L"), pResourceSchema, pStorageId, , , .tResourceStoreStream, .tResourceStoreObj, .pErrors)
				If $$$ISERR(tSC) Quit				
			} ElseIf ('$IsObject($Get(tResourceStoreStream)))||('tResourceStoreStream.Size) {
				Set tResourceStoreStream = ##class(%Stream.TmpCharacter).%New()
				Set tSC = ##class(HS.FHIR.Utils).SerializeResourceObject(tResourceStoreObj, , , , , .tResourceStoreStream)
				If $$$ISERR(tSC) Quit
			}
			Set pResourceStream = tResourceStoreStream
			Set pResourceObject = tResourceStoreObj
		} ElseIf (tPatchContentType="JSON")&&(tResourceContentType="XML") {
			Set tSC = ##class(HS.FHIR.Utils).JSONDynamicObjectToXML(tPatchResourceObj, .pResourceStream, pResourceSchema)
			If $$$ISERR(tSC) Quit
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject("xml", pResourceStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		} ElseIf (tPatchContentType="XML")&&(tResourceContentType="JSON") {
			Set tSC = ##class(HS.FHIR.Utils).XMLDocumentToJSON(tPatchResourceObj, .pResourceStream, pResourceSchema)
			If $$$ISERR(tSC) Quit
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject("json", pResourceStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	// If the transaction was left uncommitted (ie, error), roll it back.
	// The "1" because it's possible we are in a nested transaction (the TRANSACTION interaction)
	If ($Data(tInitLevel) && ($TLEVEL > tInitLevel)) { TROLLBACK 1 }
	
	Quit tSC
}

ClassMethod PatchJSONDynObj(pResourceObj As %Library.DynamicObject, pPatchStream As %Stream.Object, Output pUpdated As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Set pUpdated = 0
	
	Try {
		Set tPatchArr = ##class(%Library.DynamicArray).%FromJSON(pPatchStream)
		If '$IsObject(tPatchArr) {
			Set tSC = $$$ERROR($$$GeneralError, "Unable to create %DynamicArray from Patch input stream")
			Quit
		}
		
		If pResourceObj.text.div'="" {
			Set tSC = $$$ERROR($$$GeneralError, "Patch on resource that already includes narrative text is not allowed")
			Quit
		}
		
		Set tPatchArrIter = tPatchArr.%GetIterator()
		While tPatchArrIter.%GetNext(.tArrKey, .tArrValue) {
			Set tOp = tArrValue.op
			Set tPath = tArrValue.path
			Set tFrom = tArrValue.from
			Set tValue = tArrValue.value
			If tValue'="" {
				Set tValueTypeOf = tArrValue.%GetTypeOf("value")
			} Else {
				Set tValueTypeOf = ""
			}
			
			Set tErrPrefix = "Patch '"_tOp_"' operation "
			
			If tOp="" {
				Set tErr = "Patch operation op not specified"
				
			} ElseIf (",add,remove,replace,copy,move,test," '[ (","_tOp_",")) {
				Set tErr = "Patch operation invalid op '"_tOp_"' specified"
				
			} ElseIf tPath="" {
				Set tErr = tErrPrefix_"has no path specified"
				
			} ElseIf (tPath="/")||(tPath'["/")||(($Extract(tPath,*-1,*)="/-")&&('((tOp="add")||(tOp="move")||(tOp="copy")))) {
				Set tErr = tErrPrefix_"has invalid path '"_tPath_"' specified"
				
			} ElseIf (tValue="")&&('((tOp="remove")||(tOp="move")||(tOp="copy"))) {
				Set tErr = tErrPrefix_"has no value specified"
				
			} ElseIf ((tOp="copy")||(tOp="move"))&&(tFrom="") {
				Set tErr = tErrPrefix_"has no from specified"
				
			} ElseIf (tFrom'="")&&((tFrom="/")||(tFrom'["/")) {
				Set tErr = tErrPrefix_"has invalid from '"_tFrom_"' specified"
				
			} ElseIf (tOp="move")&&($Piece(tPath,"/",1,$Length(tFrom,"/"))=tFrom) {
				Set tErr = tErrPrefix_"invalid move from '"_tFrom_"' to the same or child path"
				
			} ElseIf tPath="/id" {
				Set tErr = tErrPrefix_"on resource id is not allowed"
				
			} Else {
				Set tErr = ""
			}
			If tErr'="" {
				Set tSC = $$$ERROR($$$GeneralError, tErr)
				Quit
			}
			
			// Attempts to patch versionId and/or lastUpdated are ignored.
			If (tPath="/meta/versionId")||(tPath="/meta/lastUpdated") Continue
			
			Set tPathLen = $Length(tPath,"/")
			
			For i = 2:1:tPathLen {
				Set tPathPiece(i)=$Piece(tPath,"/",i)
				// Only the last piece of the path can be "-".
				If (tPathPiece(i)="-")&&(i<tPathLen) {
					Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"has invalid path '"_tPath_"' specified")
					Quit
				}
			}
			If $$$ISERR(tSC) Quit
			
			Set tFromLen = $Length(tFrom,"/")
			
			For i = 2:1:tFromLen {
				Set tFromPiece(i)=$Piece(tFrom,"/",i)
				// From cannot have array pointer of "-".
				If tFromPiece(i)="-" {
					Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"has invalid from '"_tFrom_"' specified")
					Quit
				}
			}
			If $$$ISERR(tSC) Quit
			
			Set tTargetIsArray = ((tPathPiece(tPathLen)?1N.N)||(tPathPiece(tPathLen)="-"))
			
			If tOp="add" {
				Set tPrevPathData=""
				Set tPathData = pResourceObj
				// Turn tPathData into the target property. The target property
				// does not have to already exist, but its parents need to exist.
				For j = 2:1:(tPathLen-1) {
					Set tPrevPathData = tPathData
					Set tPathData = tPathData.%Get(tPathPiece(j))
					If tPathData="" {
						If (j=(tPathLen-1))&&(tTargetIsArray) {
							// If the target is an array but there is no array
							// object there, go ahead and initialize one now.
							Set tArrObj = ##class(%Library.DynamicArray).%New()
							Do tPrevPathData.%Set(tPathPiece(j), tArrObj)
							Set tPathData = tPrevPathData.%Get(tPathPiece(j))
						} Else {
							Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"path '"_tPath_"' not found in resource")
							Quit
						}
					}
				}
				If $$$ISERR(tSC) Quit
				
				If tPathPiece(tPathLen)?1N.N {
					// If the target array element is within the current array
					// bound then shuffle out the array elements that are after
					// the target array index.
					Do ShuffleOut(.tPathPiece, .tPathLen, .tPathData, .tErrPrefix, .tPath, .tStatus)
					If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
					Do tPathData.%Set(tPathPiece(tPathLen), tValue)
				} ElseIf tPathPiece(tPathLen)="-" {
					// Insert at the end of the array.
					Do tPathData.%Push(tValue)
				} Else {
					// Path is not for an array element, just set the primitive or object.
					Do tPathData.%Set(tPathPiece(tPathLen), tValue)
				}
				Set pUpdated = 1
				
				
			} ElseIf tOp="remove" {
				Set tPathData = pResourceObj
				// Turn tPathData into the data at the target location. The target location must already exist.
				Do GetLocationData(.tPathPiece, .tPathLen, .tPathData, .tPathDataTypeOf, .tPrevPathData, .tErrPrefix, .tPath, .tStatus)
				If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
				
				Set tPathData = tPrevPathData
				Do tPathData.%Remove(tPathPiece(tPathLen))
				Set pUpdated = 1
				
				
			} ElseIf tOp="replace" {
				Set tPathData = pResourceObj
				// Turn tPathData into the data at the target location. The target location must already exist.
				Do GetLocationData(.tPathPiece, .tPathLen, .tPathData, .tPathDataTypeOf, .tPrevPathData, .tErrPrefix, .tPath, .tStatus)
				If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
				
				Set tPathData = tPrevPathData
				Do tPathData.%Set(tPathPiece(tPathLen), tValue)
				Set pUpdated = 1
				
				
			} ElseIf tOp="copy" {
				Set tFromData = pResourceObj
				// Turn tFromData into the data at the from location. The from location must already exist.
				Do GetLocationData(.tFromPiece, .tFromLen, .tFromData, .tFromDataTypeOf, .tPrevFromData, .tErrPrefix, .tPath, .tStatus)
				If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
				
				Set tPathData = pResourceObj
				// Turn tPathData into the data at the parent of the target location data.
				// The parent of the target location must already exist.
				Do GetLocationData(.tPathPiece, tPathLen-1, .tPathData, .tPathDataTypeOf, .tPrevPathData, .tErrPrefix, .tPath, .tStatus)
				If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
				
				If tPathPiece(tPathLen)?1N.N {
					// If the target array element is within the current array
					// bound then shuffle out the array elements that are after
					// the target array index.
					Do ShuffleOut(.tPathPiece, .tPathLen, .tPathData, .tErrPrefix, .tPath, .tStatus)
					If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
					If (tFromDataTypeOf="object")||(tFromDataTypeOf="array") {
						Set tStr = tFromData.%ToJSON()
						Set tNewObj = ##class(%Library.DynamicObject).%FromJSON(tStr)
						Do tPathData.%Set(tPathPiece(tPathLen), tNewObj)
					} Else {
						Do tPathData.%Set(tPathPiece(tPathLen), tFromData, tFromDataTypeOf)
					}
				} ElseIf tPathPiece(tPathLen)="-" {
					// Insert at the end of the array.
					Do tPathData.%Push(tFromData)
				} Else {
					If (tFromDataTypeOf="object")||(tFromDataTypeOf="array") {
						Set tStr = tFromData.%ToJSON()
						Set tNewObj = ##class(%Library.DynamicObject).%FromJSON(tStr)
						Do tPathData.%Set(tPathPiece(tPathLen), tNewObj)
					} Else {
						Do tPathData.%Set(tPathPiece(tPathLen), tFromData, tFromDataTypeOf)
					}
				}
				Set pUpdated = 1
				
				
			} ElseIf tOp="move" {
				Set tFromData = pResourceObj
				// Turn tFromData into the data at the from location. The from location must already exist.
				Do GetLocationData(.tFromPiece, .tFromLen, .tFromData, .tFromDataTypeOf, .tPrevFromData, .tErrPrefix, .tPath, .tStatus)
				If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
								
				Set tPathData = pResourceObj
				// Turn tPathData into the data at the parent of the target location data.
				// The parent of the target location must already exist.
				Do GetLocationData(.tPathPiece, tPathLen-1, .tPathData, .tPathDataTypeOf, .tPrevPathData, .tErrPrefix, .tPath, .tStatus)
				If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
				
				// Save and remove the from data.
				Set tSaveFromData = tFromData
				Do tPrevFromData.%Remove(tFromPiece(tFromLen))
				
				If tPathPiece(tPathLen)?1N.N {
					// If the target array element is within the current array
					// bound then shuffle out the array elements that are after
					// the target array index.
					Do ShuffleOut(.tPathPiece, .tPathLen, .tPathData, .tErrPrefix, .tPath, .tStatus)
					If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
					Do tPathData.%Set(tPathPiece(tPathLen), tSaveFromData)
				} ElseIf tPathPiece(tPathLen)="-" {
					// Insert at the end of the array.
					Do tPathData.%Push(tSaveFromData)
				} Else {
					Do tPathData.%Set(tPathPiece(tPathLen), tSaveFromData)
				}
				Set pUpdated = 1
				
				
			} ElseIf tOp="test" {
				Set tPathData = pResourceObj
				// Turn tPathData into the data at the target location. The target location must already exist.
				Do GetLocationData(.tPathPiece, .tPathLen, .tPathData, .tPathDataTypeOf, .tPrevPathData, .tErrPrefix, .tPath, .tStatus)
				If 'tStatus Set tSC = $$$ERROR($$$GeneralError, tStatus) Quit
				
				// %GetTypeOf is part of comparing primitives (e.g., "true" does not match true).
				Set tPathTypeOf = tPrevPathData.%GetTypeOf(tPathPiece(tPathLen))
				
				If '$IsObject(tPathData) {
					Set tPathDataJSONStr = tPathData
				} Else {
					Set tPathDataJSONStr = tPathData.%ToJSON()
				}
				If '$IsObject(tValue) {
					Set tValueJSONStr = tValue
				} Else {
					Set tValueJSONStr = tValue.%ToJSON()
				}
				
				If (tPathDataJSONStr'=tValueJSONStr)||(tPathTypeOf'=tValueTypeOf) {
					Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"of path '"_tPath_"' for value '"_tValueJSONStr_"' failed")
				}
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
	
GetLocationData(pieces, len, data, typeof, prevData, errPrefix, path, status)
	Set prevData = ""
	Set status = 1
	For j = 2:1:len {
		Set prevData = data
		Set typeof = data.%GetTypeOf(pieces(j))
		Set data = data.%Get(pieces(j))
		If data="" {
			Set status = errPrefix_"path '"_path_"' not found in resource"
			Quit
		}
	}
	Quit
	
ShuffleOut(pieces, len, data, errPrefix, path, status)
	Set status = 1
	Set size = data.%Size()
	write !,"pieces(len)="_pieces(len)_"  size="_size,!
	If pieces(len)'>(size-1) {
		For j = (size-1):-1:pieces(len) {
			Do data.%Set(j+1,data.%Get(j))
		}
	} ElseIf pieces(len)>size {
		// Path cannot be beyond the end of the existing array.
		Set status = errPrefix_"path '"_path_"' is past end of existing array"
		Quit
	}
	Quit
}

/// PatchXMLDocument applies XML Patch to the specified FHIR resource stream and
/// its accompanying %XML.Document representation. 
ClassMethod PatchXMLWithXSLT(pResourceStream As %Stream.Object, pResourceXMLDocument As %XML.Document, pPatchStream As %Stream.Object, ByRef pUpdated As %Boolean, ByRef pAdded As %Boolean) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pUpdated = 0
		Set pAdded = 0
		
		If ..PatchXMLResourceHasText(pResourceXMLDocument) {
			Set tSC = $$$ERROR($$$GeneralError, "Patch on resource that already includes narrative text is not allowed")
			Quit
		}
		
		#dim tPatchXMLDocument As %XML.Document
		Set tSC = ##class(%XML.Document).GetDocumentFromStream(pPatchStream, .tPatchXMLDocument)
		If $$$ISERR(tSC) Quit
		Do pPatchStream.Rewind()
		
		#dim tPatchNode As %XML.Node
		Set tPatchNode = tPatchXMLDocument.GetDocumentElement()
		If 'tPatchNode.MoveToFirstChild(1) {
			Set tSC = $$$ERROR($$$GeneralError, "Empty XML Patch document specified")
			Quit
		}
		
		For {
			Set tSC = ..PatchXMLValidatePatchOp(tPatchXMLDocument, tPatchNode, .tOp, .tSel, .tType, .tPos, .tText, .tAddReplaceNodeSetStream)
			If $$$ISERR(tSC) Quit
			
			// Silently ignore any patches on meta versionId and lastUpdated.
			If ($Length(tSel,"/")=3)&&($Piece($Piece($Piece(tSel,"/",2),":",*),"[",1)="meta")&&(($Piece($Piece($Piece(tSel,"/",3),":",*),"[",1)="versionId")||($Piece($Piece($Piece(tSel,"/",3),":",*),"[",1)="lastUpdated")) Continue
			
			Set tSelWithLeadingSlash = "/"_tSel
			
			If $Extract($Piece(tSel,"/",*))="@" {
				Set tSelWithoutAttr = $Piece(tSelWithLeadingSlash, "/", 1, *-1)
				Set tSelIsAttribute = 1
				Set tSelAttributeName = $Extract($Piece(tSelWithLeadingSlash,"/",*),2,*)
			} Else {
				Set tSelWithoutAttr = tSelWithLeadingSlash
				Set tSelIsAttribute = 0
				Set tSelAttributeName = ""
			}
			Set tCountSel = tSelWithoutAttr
			
			Set tPathCount = 1
			
			If tOp="add" {
				If tType="" { // add element
					
					// If an element is being added to the top property level of the
					// resource, then simply add the node set string on to the end
					// of the stream, just before the resource closing tag.
					If $Length(tSel,"/")=1 {
						Set tResourceType = $Piece($Piece(tSel,"/",1),":",*)
						Set tEndTag = "</"_tResourceType_">"
						Set tOutput = ##class(%Stream.TmpBinary).%New()
						For {
							Set tStr = pResourceStream.Read()
							If 'pResourceStream.AtEnd {
								Do tOutput.Write(tStr)
							} Else {
								Set tBuf = ""
								For i = $Length(tStr):-1:1 {
									Set tC = $Extract(tStr,i)
									If (tC=$Char(32))||(tC=$Char(9))||(tC=$Char(10))||(tC=$Char(13))||(tC=$Char(11)) Continue
									Set tBuf = tC_tBuf
									If tBuf=tEndTag Quit
								}
								Do tOutput.Write($Extract(tStr,1,i-1))
								For {
									Do tOutput.Write(tAddReplaceNodeSetStream.Read())
									If tAddReplaceNodeSetStream.AtEnd Quit
								}
								Do tOutput.Write(tEndTag)
								Quit
							}
						}
						
					} Else {
						// If adding something within a top-level property, then use XSLT
						// to carry out the add.
						Set tXSLTPath = "xdata://"_..%ClassName(1)_":PatchXMLAddElementXSLT"
						Set tSC = ##class(Ens.Util.URLStream).GetURLStream(tXSLTPath, .tXSLTStream)
						Do tXSLTStream.Rewind()
						Set tStr = tXSLTStream.Read()
						Set tStr = $Replace(tStr, "{{selectPath}}", tSelWithoutAttr)
						Set tStr = $Replace(tStr, "{{countPath}}", tCountSel)
						Do tXSLTStream.Clear()
						Set tStr1 = $Piece(tStr, "{{newNodeSet}}", 1)
						Set tStr2 = $Piece(tStr, "{{newNodeSet}}", 2)
						Do tXSLTStream.Write(tStr1)
						For {
							Do tXSLTStream.Write(tAddReplaceNodeSetStream.Read())
							If tAddReplaceNodeSetStream.AtEnd Quit
						}
						Do tXSLTStream.Write(tStr2)
						Do tXSLTStream.Rewind()
						Set tSC = ##class(%XML.XSLT.Transformer).TransformStream(pResourceStream, tXSLTStream, .tOutput)
						If $$$ISERR(tSC) Quit
						Do getPathCount(.tOutput, .tPathCount)
					}
					
				} Else { // add attribute
					Set tXSLTPath = "xdata://"_..%ClassName(1)_":PatchXMLAddAttributeXSLT"
					Set tSC = ##class(Ens.Util.URLStream).GetURLStream(tXSLTPath, .tXSLTStream)
					Do tXSLTStream.Rewind()
					Set tStr = tXSLTStream.Read()
					Set tStr = $Replace(tStr, "{{selectPath}}", tSel)
					Set tStr = $Replace(tStr, "{{countPath}}", tCountSel)
					Set tStr = $Replace(tStr, "{{attributeName}}", $Extract(tType,2,*))
					Do tXSLTStream.Clear()
					Set tStr1 = $Piece(tStr, "{{attributeNewValue}}", 1)
					Set tStr2 = $Piece(tStr, "{{attributeNewValue}}", 2)
					Do tXSLTStream.Write(tStr1)
					Do tXSLTStream.Write(tText)
					Do tXSLTStream.Write(tStr2)
					Do tXSLTStream.Rewind()
					Set tSC = ##class(%XML.XSLT.Transformer).TransformStream(pResourceStream, tXSLTStream, .tOutput)
					If $$$ISERR(tSC) Quit
					Do getPathCount(.tOutput, .tPathCount)
				}
				
				Set pAdded = 1
				
			} ElseIf tOp="replace" {
				If 'tSelIsAttribute { // replace element
					Set tXSLTPath = "xdata://"_..%ClassName(1)_":PatchXMLReplaceElementXSLT"
					Set tSC = ##class(Ens.Util.URLStream).GetURLStream(tXSLTPath, .tXSLTStream)
					Do tXSLTStream.Rewind()
					Set tStr = tXSLTStream.Read()
					Set tStr = $Replace(tStr, "{{selectPath}}", tSelWithoutAttr)
					Set tStr = $Replace(tStr, "{{countPath}}", tCountSel)
					Do tXSLTStream.Clear()
					Set tStr1 = $Piece(tStr, "{{newNodeSet}}", 1)
					Set tStr2 = $Piece(tStr, "{{newNodeSet}}", 2)
					Do tXSLTStream.Write(tStr1)
					For {
						Do tXSLTStream.Write(tAddReplaceNodeSetStream.Read())
						If tAddReplaceNodeSetStream.AtEnd Quit
					}
					Do tXSLTStream.Write(tStr2)
					Do tXSLTStream.Rewind()
					Set tSC = ##class(%XML.XSLT.Transformer).TransformStream(pResourceStream, tXSLTStream, .tOutput)
					If $$$ISERR(tSC) Quit
					Do getPathCount(.tOutput, .tPathCount)
					
				} Else { // replace attribute
					Set tXSLTPath = "xdata://"_..%ClassName(1)_":PatchXMLReplaceAttributeXSLT"
					Set tSC = ##class(Ens.Util.URLStream).GetURLStream(tXSLTPath, .tXSLTStream)
					Do tXSLTStream.Rewind()
					Set tStr = tXSLTStream.Read()
					Set tStr = $Replace(tStr, "{{selectPath}}", tSel)
					Set tStr = $Replace(tStr, "{{countPath}}", tCountSel)
					Set tStr = $Replace(tStr, "{{attributeName}}", tSelAttributeName)
					Do tXSLTStream.Clear()
					Set tStr1 = $Piece(tStr, "{{attributeNewValue}}", 1)
					Set tStr2 = $Piece(tStr, "{{attributeNewValue}}", 2)
					Do tXSLTStream.Write(tStr1)
					Do tXSLTStream.Write(tText)
					Do tXSLTStream.Write(tStr2)
					Do tXSLTStream.Rewind()
					Set tSC = ##class(%XML.XSLT.Transformer).TransformStream(pResourceStream, tXSLTStream, .tOutput)
					If $$$ISERR(tSC) Quit
					Do getPathCount(.tOutput, .tPathCount)
				}
				
			} Else { // remove
				Set tXSLTPath = "xdata://"_..%ClassName(1)_":PatchXMLRemoveXSLT"
				Set tSC = ##class(Ens.Util.URLStream).GetURLStream(tXSLTPath, .tXSLTStream)
				Do tXSLTStream.Rewind()
				Set tStr = tXSLTStream.Read()
				Set tStr = $Replace(tStr, "{{selectPath}}", tSel)
				Set tStr = $Replace(tStr, "{{countPath}}", tCountSel)
				Do tXSLTStream.Clear()
				Do tXSLTStream.Write(tStr)
				Do tXSLTStream.Rewind()
				Set tSC = ##class(%XML.XSLT.Transformer).TransformStream(pResourceStream, tXSLTStream, .tOutput)
				If $$$ISERR(tSC) Quit
				Do getPathCount(.tOutput, .tPathCount)
			}
			
			Set tErrPrefix = "Patch '"_tOp_"' operation "
			
			If tPathCount=0 {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"sel "_tSel_" found no node in existing resource")
				Quit
			} ElseIf tPathCount>1 {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"sel "_tSel_" found multiple nodes in existing resource")
				Quit
			}
			
			Kill pResourceStream
			
			Set pResourceStream = tOutput
			
			Do pResourceStream.Rewind()
			
			Kill tOutput
			
			Set pUpdated = 1
			
			If 'tPatchNode.MoveToNextSibling(1) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
	
getPathCount(output, pathCount)
	Set pathCount = 1
	Do output.Rewind()
	Set str = output.Read(200)
	Do output.Rewind()
	If str["</pathCount>" Set pathCount = $Piece($Piece(str,"</pathCount>",1),">",*)
	Quit
}

XData PatchXMLAddElementXSLT
{
<xsl:stylesheet xmlns="http://hl7.org/fhir" xmlns:f="http://hl7.org/fhir" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="f h exsl" version="1.0">
<xsl:output method="xml" indent="no" encoding="UTF-8"/>
<xsl:strip-space elements="*" />
<xsl:preserve-space elements="h:head h:title h:meta h:body h:div h:p h:span h:em h:strong h:h1 h:h2 h:h3 h:h4 h:h5 h:h6 h:address h:dfn h:code h:samp h:kbd h:var h:cite h:abbr h:acronym h:blockquote h:q h:br h:pre h:ul h:ol h:li h:dl h:dt h:dd h:dir h:menu h:table h:caption h:thead h:tfoot h:tbody h:colgroup h:col h:tr h:th h:td" />
<xsl:variable name="pathCount" select="count({{countPath}})"/>

<xsl:template match="//@* | //node()">
<xsl:choose>
<xsl:when test="$pathCount=1">
<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="node()"/>
</xsl:copy>
</xsl:when>
<xsl:otherwise><pathCount><xsl:value-of select="$pathCount"/></pathCount></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="{{selectPath}}">
<xsl:element name="{local-name()}"><xsl:apply-templates select="@*|node()" mode="copy"/>{{newNodeSet}}</xsl:element>
</xsl:template>

<xsl:template match="@*|node()" mode="copy">
<xsl:copy><xsl:apply-templates select="@*|node()" mode="copy" /></xsl:copy>
</xsl:template>

</xsl:stylesheet>
}

XData PatchXMLAddAttributeXSLT
{
<xsl:stylesheet xmlns="http://hl7.org/fhir" xmlns:f="http://hl7.org/fhir" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="f h exsl" version="1.0">
<xsl:output method="xml" indent="no" encoding="UTF-8"/>
<xsl:strip-space elements="*" />
<xsl:preserve-space elements="h:head h:title h:meta h:body h:div h:p h:span h:em h:strong h:h1 h:h2 h:h3 h:h4 h:h5 h:h6 h:address h:dfn h:code h:samp h:kbd h:var h:cite h:abbr h:acronym h:blockquote h:q h:br h:pre h:ul h:ol h:li h:dl h:dt h:dd h:dir h:menu h:table h:caption h:thead h:tfoot h:tbody h:colgroup h:col h:tr h:th h:td" />
<xsl:variable name="pathCount" select="count({{countPath}})"/>

<xsl:template match="//@* | //node()">
<xsl:choose>
<xsl:when test="$pathCount=1">
<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="node()"/>
</xsl:copy>
</xsl:when>
<xsl:otherwise><pathCount><xsl:value-of select="$pathCount"/></pathCount></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="{{selectPath}}">
<xsl:element name="{local-name()}"><xsl:attribute name="{{attributeName}}">{{attributeNewValue}}</xsl:attribute><xsl:apply-templates select="@*|node()" mode="copy"/></xsl:element>
</xsl:template>

<xsl:template match="@*|node()" mode="copy">
<xsl:copy><xsl:apply-templates select="@*|node()" mode="copy" /></xsl:copy>
</xsl:template>

</xsl:stylesheet>
}

XData PatchXMLReplaceElementXSLT
{
<xsl:stylesheet xmlns="http://hl7.org/fhir" xmlns:f="http://hl7.org/fhir" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="f h exsl" version="1.0">
<xsl:output method="xml" indent="no" encoding="UTF-8"/>
<xsl:strip-space elements="*" />
<xsl:preserve-space elements="h:head h:title h:meta h:body h:div h:p h:span h:em h:strong h:h1 h:h2 h:h3 h:h4 h:h5 h:h6 h:address h:dfn h:code h:samp h:kbd h:var h:cite h:abbr h:acronym h:blockquote h:q h:br h:pre h:ul h:ol h:li h:dl h:dt h:dd h:dir h:menu h:table h:caption h:thead h:tfoot h:tbody h:colgroup h:col h:tr h:th h:td" />
<xsl:variable name="pathCount" select="count({{countPath}})"/>

<xsl:template match="//@* | //node()">
<xsl:choose>
<xsl:when test="$pathCount=1">
<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="node()"/>
</xsl:copy>
</xsl:when>
<xsl:otherwise><pathCount><xsl:value-of select="$pathCount"/></pathCount></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="{{selectPath}}">{{newNodeSet}}</xsl:template>

</xsl:stylesheet>
}

XData PatchXMLReplaceAttributeXSLT
{
<xsl:stylesheet xmlns="http://hl7.org/fhir" xmlns:f="http://hl7.org/fhir" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="f h exsl" version="1.0">
<xsl:output method="xml" indent="no" encoding="UTF-8"/>
<xsl:strip-space elements="*" />
<xsl:preserve-space elements="h:head h:title h:meta h:body h:div h:p h:span h:em h:strong h:h1 h:h2 h:h3 h:h4 h:h5 h:h6 h:address h:dfn h:code h:samp h:kbd h:var h:cite h:abbr h:acronym h:blockquote h:q h:br h:pre h:ul h:ol h:li h:dl h:dt h:dd h:dir h:menu h:table h:caption h:thead h:tfoot h:tbody h:colgroup h:col h:tr h:th h:td" />
<xsl:variable name="pathCount" select="count({{countPath}})"/>

<xsl:template match="node()|@*" name="identity">
<xsl:choose>
<xsl:when test="$pathCount=1">
<xsl:copy>
<xsl:apply-templates select="node()|@*"/>
</xsl:copy>
</xsl:when>
<xsl:otherwise><pathCount><xsl:value-of select="$pathCount"/></pathCount></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="{{selectPath}}"><xsl:attribute name="{{attributeName}}">{{attributeNewValue}}</xsl:attribute></xsl:template>

</xsl:stylesheet>
}

XData PatchXMLRemoveXSLT
{
<xsl:stylesheet xmlns="http://hl7.org/fhir" xmlns:f="http://hl7.org/fhir" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="f h exsl" version="1.0">
<xsl:output method="xml" indent="no" encoding="UTF-8"/>
<xsl:strip-space elements="*" />
<xsl:preserve-space elements="h:head h:title h:meta h:body h:div h:p h:span h:em h:strong h:h1 h:h2 h:h3 h:h4 h:h5 h:h6 h:address h:dfn h:code h:samp h:kbd h:var h:cite h:abbr h:acronym h:blockquote h:q h:br h:pre h:ul h:ol h:li h:dl h:dt h:dd h:dir h:menu h:table h:caption h:thead h:tfoot h:tbody h:colgroup h:col h:tr h:th h:td" />
<xsl:variable name="pathCount" select="count({{countPath}})"/>

<xsl:template match="//@* | //node()">
<xsl:choose>
<xsl:when test="$pathCount=1">
<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:apply-templates select="node()"/>
</xsl:copy>
</xsl:when>
<xsl:otherwise><pathCount><xsl:value-of select="$pathCount"/></pathCount></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="{{selectPath}}"/>

</xsl:stylesheet>
}

/// Return true or false indication of whether the resource XML Document includes narrative text.
ClassMethod PatchXMLResourceHasText(pResourceXMLDocument As %XML.Document) As %Boolean [ Internal ]
{
	#dim tNode As %XML.Node
	
	Set tHasNarrativeText = 0
	
	Set tNode = pResourceXMLDocument.GetDocumentElement()
	
	If 'tNode.MoveToFirstChild(1) Quit
	
	For {
		If 'tNode.MoveToNextSibling(1) Quit
		If tNode.LocalName="text" Set tHasNarrativeText = 1 Quit
	}
	
	Quit tHasNarrativeText
}

/// Validate an XML Patch operation that is represented as %XML.Node.
/// Validation rules are influenced by FHIR-specific context and by
/// some ISC-specific limitations (e.g., not doing anything with
/// namespaces or comments or div).
ClassMethod PatchXMLValidatePatchOp(pPatchDocument As %XML.Document, pPatchNode As %XML.Node, ByRef pOp As %String, ByRef pSel As %String, ByRef pType As %String, ByRef pPos As %String, ByRef pText As %String, ByRef pAddReplaceNodeSetStream As %Stream.Object) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Do {
		Set tSaveNodeId = pPatchNode.NodeId
		
		Set pOp = ""
		Set pSel = ""
		Set pType = ""
		Set pPos = ""
		Set pText = ""
		Set tTextWithoutWhitespace = ""
		Set pAddReplaceNodeSetStream = $$$NULLOREF
		
		Set tValidAttributes = ",value,url,id,"
			
		Set pOp = pPatchNode.LocalName
		If '((pOp="add")||(pOp="replace")||(pOp="remove")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid XML Patch operation '"_pOp_"' specified")
			Quit
		}
		
		Set tErrPrefix = "Patch '"_pOp_"' operation "
		
		Set tBoolean = pPatchNode.GetText(.pText)
		
		Set pSel = pPatchNode.GetAttributeValue("sel")
		If pSel="" {
			Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"missing sel value")
			Quit
		}
		If pSel["text()" {
			Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"sel with text() is not supported")
			Quit
		}
		If pSel["comment(" {
			Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"sel with comment() is not supported")
			Quit
		}
		If pSel["processing-instruction(" {
			Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"sel with processing-instruction() is not supported")
			Quit
		}
		If $Piece($Piece(pSel,"/",2),":",*)="id" {
			Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"on resource id is not allowed")
			Quit
		}
		// Silently ignore any patches on meta versionId and lastUpdated.
		If ($Length(pSel,"/")=3)&&($Piece($Piece($Piece(pSel,"/",2),":",*),"[",1)="meta")&&(($Piece($Piece($Piece(pSel,"/",3),":",*),"[",1)="versionId")||($Piece($Piece($Piece(pSel,"/",3),":",*),"[",1)="lastUpdated")) Continue
		// Only remove and replace can specify an attribute at the end of sel.
		Set tAttribute = $Piece(pSel, "/", *)
		If $Extract(tAttribute)="@" {
			If pOp="add" {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"sel "_pSel_" cannot include attribute")
				Quit
			} Else { // replace or remove
				Set tTextWithoutWhitespace = $Translate(pText,$Char(9,10,11,13))
				If (tValidAttributes'[(","_$Extract(tAttribute,2,*)_",")) {
					Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"sel attribute '"_tAttribute_"' is not supported")
					Quit
				} ElseIf pText="" {
					Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"blank text value for sel attribute '"_tAttribute_"' is invalid")
					Quit
				} ElseIf ((tAttribute="@id")||(tAttribute="@url")) {
					Set tTextWithoutWhitespace = $Translate(pText,$Char(9,10,11,13))
					If (tTextWithoutWhitespace'=pText) {
						Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"white space in sel attribute '"_tAttribute_"' is invalid")
						Quit
					} ElseIf $Translate(tTextWithoutWhitespace,$Char(32))="" {
						Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"white space in sel attribute '"_tAttribute_"' is invalid")
						Quit
					}
				} Else {
					Set tSelIsAttribute = 1
				}
			}
		} Else {
			Set tSelIsAttribute = 0
		}
		
		// type is only allowed on add operation.
		Set pType = pPatchNode.GetAttributeValue("type")
		If pType'="" {
			If pOp'="add" {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"with type value is invalid")
				Quit
			} ElseIf pType["namespace::" {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"on namespace is not supported")
				Quit
			}
			Set tAttribute = $Piece(pType,"/",*)
			If ($Extract(tAttribute)="@") {
				If (tValidAttributes'[(","_$Extract(tAttribute,2,*)_",")) {
					Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"type attribute '"_pType_"' is not supported")
					Quit
				} ElseIf pText="" {
					Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"blank text value for type attribute '"_pType_"' is invalid")
					Quit
				} ElseIf ((tAttribute="@id")||(tAttribute="@url")) {
					Set tTextWithoutWhitespace = $Translate(pText,$Char(9,10,11,13))
					If (tTextWithoutWhitespace'=pText) {
						Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"white space in type attribute '"_pType_"' is invalid")
						Quit
					} ElseIf $Translate(tTextWithoutWhitespace,$Char(32))="" {
						Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"white space in type attribute '"_pType_"' is invalid")
						Quit
					}
				} Else {
					Set tTypeIsAttribute = 1
				}
			} Else {
				Set tTypeIsAttribute = 0
			}
		} Else {
			Set tTypeIsAttribute = 0
		}
		
		// pos is only allowed on add operation.
		Set pPos = pPatchNode.GetAttributeValue("pos")
		If pPos'="" {
			If pOp'="add" {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"with pos value is invalid")
				Quit
			} ElseIf '((pPos="before")||(pPos="after")) {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"with invalid pos value '"_pPos_"'")
				Quit
			}
		}
		
		// We do not support ws.
		Set tWs = pPatchNode.GetAttributeValue("ws")
		If tWs'="" {
			Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"ws attribute is not supported")
			Quit
		}
		
		
		// add and replace must have something to add.
		If ((pOp="add")||(pOp="replace"))&&(pText="") {
			Set tHasChildren = pPatchNode.MoveToFirstChild(1)
			If (pOp="add")&&('tTypeIsAttribute)&&('tHasChildren) {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"missing text or node values")
				Quit
			}
			If (pOp="replace")&&('tSelIsAttribute)&&('tHasChildren) {
				Set tSC = $$$ERROR($$$GeneralError, tErrPrefix_"missing text or node values")
				Quit
			}
			Set tSC = ##class(HS.FHIR.Utils).SerializeXMLNode(pPatchDocument, pPatchNode, .pAddReplaceNodeSetStream)
			If $$$ISERR(tSC) Quit
		}
		
		
	} While (0)
	
	Set pPatchNode.NodeId = tSaveNodeId
	
	Quit tSC
}

}
