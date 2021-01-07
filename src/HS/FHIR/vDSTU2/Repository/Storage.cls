Include (%cspBuild, %occReference)

Class HS.FHIR.vDSTU2.Repository.Storage Extends %RegisteredObject [ DependsOn = HS.FHIR.vDSTU2.Repository.Resource.Abstract ]
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

Parameter SchematronXSLTDir = "FHIR/vDSTU2/Schematron";

/// A key useable for disambiguating version-specific cached data
Parameter VERSIONKEY As %String = "DSTU2";

/// Individual DSTU2 resource type storage classes that hold the resource-specific search parameter
/// definitions and resource-specific indexing logic are located by default under the product
/// class package HS.FHIR.vDSTU2.Repository.Resource. A custom storage package may be specified,
/// to be used instead of the default package. To do this, extend this class to a custom class
/// and override the CUSTOMSTORAGEPKG class parameter.
Parameter CUSTOMSTORAGEPKG As %String;

Parameter TEMPSORTGLOBAL = "^||FHIRSearchSort";

/// By default the ResultSet that is returned by Search leaves the ResourceId column value blank.
/// To have the ResourceId column unconditionally populated by Search, extend this class and set
/// this class parameter value to 1. Please note that doing so will incur a performance hit for
/// all search interactions.
Parameter RESOURCEIDINSEARCHRESULTSET = 0;

/// API
/// Create carries out the FHIR storage-specific logic for the create interaction.
/// Reference: http://hl7.org/fhir/DSTU2/http.html#create<br>
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vDSTU2.Model.Resource".
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
		
		#dim tRepoResource As HS.FHIR.vDSTU2.Repository.Resource.Abstract
		set tStorageClass = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetStorageClass(tResourceType, .tSC, ..#CUSTOMSTORAGEPKG) quit:$$$ISERR(tSC)
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
/// Reference: http://hl7.org/fhir/DSTU2/http.html#read<br>
/// Reference: http://hl7.org/fhir/DSTU2/http.html#vread<br>
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vDSTU2.Model.Resource".
/// <li>pResourceType      : (required) FHIR resource type.
/// <li>pResourceId        : (required) FHIR resource Id.
/// <li>pResourceVId       : FHIR resource version Id.
/// <li>pSummary           : (not yet supported) FHIR summary.
/// <li>pSessionIdentifier : Session identifier for session-based use of the FHIR respository.
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
		if ('##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
			Set tText = "Resource not found: "_pResourceType_" ID="_pResourceId
			Do pErrors.logError("not-found", "error", tText, , , , tText)
			Set tSC = $$$ERROR($$$GeneralError, tText)
			Quit
		}
		// If this is a vread and the specified version does not exist, return not-found.
		if (pResourceVId'="")&&('##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).VersionExists(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tText = "Version not found: "_pResourceType_" ID="_pResourceId_" Version="_pResourceVId
			Do pErrors.logError("not-found", "error", tText, , , , tText)
			Set tSC = $$$ERROR($$$GeneralError, tText)
			Quit
		}
		
		// If the resource does exist but is deleted, return status 410 Gone.
		// For a regular read, Version should be null, so the method will return the deleted status of the current version.
		if (##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceIsDeleted(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource previously deleted")
			Quit
		}
		
		// For a regular read (i.e., not a vread), Version should be null, so the method will return
		// the logical ID (aka Storage Id) of the current version.
		Set pStorageId = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceToLogicalId(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)
		
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
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vDSTU2.Model.Resource".
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
		Set pStorageClass = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetStorageClassFromLogicalId(pStorageId)
		
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
		Set tStorageClass = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetStorageClassFromLogicalId(pStorageId)
		
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
		if ('##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource not found: "_pResourceType_" ID="_pResourceId)
			Quit
		}
		
		// If this is a vread and the specified version does not exist, return not-found.
		if (pResourceVId'="")&&('##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).VersionExists(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource not found: "_pResourceType_" ID="_pResourceId)
			Quit
		}
		
		// If the resource does exist but is deleted, return status 410 Gone.
		// For a regular read, Version should be null, so the method will return the deleted status of the current version.
		if (##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceIsDeleted(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)) {
			Set tSC = $$$ERROR($$$GeneralError, "Resource previously deleted")
			Quit
		}
		
		// For a regular read (i.e., not a vread), Version should be null, so the method will return
		// the storage id of the current version.
		Set pStorageId = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceToLogicalId(pSessionIdentifier, pResourceType, pResourceId, pResourceVId)
		
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
/// Reference: http://hl7.org/fhir/DSTU2/http.html#update<br>
/// Input:<br>
/// <li>pContentType       : (required) May be the ContentType from a FHIR request, or even just "json" or "xml".
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vDSTU2.Model.Resource".
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
		
		Set tCurrentVersionId = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).CurrentVersion(pSessionIdentifier, tResourceType, tResourceId)
		
		// If the request contains an If-Match header, assert that the value matches the current version ID of the resource.
		// (Used for resource contention - see http://hl7.org/fhir/DSTU2/http.html#update#2.1.0.11)
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
		
		#dim tRepoResource As HS.FHIR.vDSTU2.Repository.Resource.Abstract
		set tStorageClass = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetStorageClass(tResourceType, .tSC, ..#CUSTOMSTORAGEPKG) quit:$$$ISERR(tSC)
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
		if (##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceExists(tRepoResource.Session,tResourceType,tResourceId)) {
			if tInitLevel=0 TSTART
			set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).DeprecateResource(tRepoResource.Session,tResourceType,tResourceId) quit:$$$ISERR(tSC)
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
/// Reference: http://hl7.org/fhir/DSTU2/http.html#delete<br>
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
				Set tStorageClass = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetStorageClassFromLogicalId(tResultSet.%Get("ID"))
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
		If ('##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
			Quit
		}
		
		// If the resource is already marked as deleted, do nothing.
		If (##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceIsDeleted(pSessionIdentifier, pResourceType, pResourceId)) {
			Quit
		}
		
		// Resource exists, so create new "deleted" version with no content
		#dim tStreamlet As HS.FHIR.vDSTU2.Repository.Resource.Abstract
		Set tStorageClass = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetStorageClass(pResourceType, .tSC, ..#CUSTOMSTORAGEPKG) quit:$$$ISERR(tSC)
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
		Set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).DeprecateResource(pSessionIdentifier, pResourceType, pResourceId) quit:$$$ISERR(tSC)
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
		
		&SQL(DELETE FROM HS_FHIR_vDSTU2_Repository_Resource.Abstract
		            WHERE ResourceId = :resourceId AND ResourceType = :resourceType)
		if (SQLCODE < 0) { set tSC = $$$ERROR($$$GeneralError, "SQL Error "_SQLCODE_", "_$system.SQL.SQLCODE(SQLCODE)) quit }
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
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
ClassMethod Search(pResourceType As %String, pCompartment As %String = "", pResourceId As %String = "", pParameters = "", pSessionIdentifier As %String = "", Output pResultSet As HS.Util.TransientTable, Output pErrors As HS.Types.FHIR.Errors, pUnused, pSearchPostProcessorClass As %String = "", pSessionApplication As %String = "", pSessionId As %String = "") As %Status
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
				set tSC = ##class(HS.FHIR.Utils).URLParamStringToArray(tString, .pParameters)
				if $$$ISERR(tSC) quit
			}
		} else {
			set pParameters = ##class(%Library.ArrayOfDataTypes).%New()
		}
		
		// Assert that the search table for this type exists
		if ('$$$defClassDefined(##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).#SEARCHTABLEPACKAGE_"."_pResourceType)) {
			set tSC = $$$ERROR($$$GeneralError, "Search table definition for resource type "_pResourceType_" not found")
			quit
		}
		
		// Set this global to 1 to turn on logging for search. Useful for analyzing performance.
		set tLog = +$G(^HS.FHIR.Log.Search)

		// Maintain a list of the parameters that are not search keys.
		set tNotSearchKeys = ",_sort,_count,_include,_revinclude,_summary,_elements,_contained,_containedType,_format,debug,"
		
		set tOrderBy = ""
		
		set tSC = ..ValidateSortKeys(pResourceType, pParameters, .tSortKeys)
		if $$$ISERR(tSC) quit
		
		// Pre-scan the parameters to verify at least one search key.
		set tHasParams = 0
		for {
			set tParamVals = pParameters.GetNext(.tWholeParam) quit:tWholeParam=""
			set tParam=$P(tWholeParam,":")
			if tParam="" continue
			
			// Skip the parameters that are not search keys
			if (tNotSearchKeys [ (","_tParam_",")) { continue }
			// Skip unrecognized params
			set tParamType = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetSearchParamType(pResourceType,tParam)
			if (tParamType="") {
				// This will prevent GetURLWithQuery() from including this parameter in the "self" URL in the response
				do pParameters.RemoveAt(tWholeParam)
				set tText = "Unrecognized search param: "_tParam
				do pErrors.logError("invalid", "error", tText, , , , tText)
				continue
			}
			// Validate the param type
			// TO DO: Parameterize this list somehow rather than hardcoding it here.
			If (",token,date,string,reference,quantity,number,uri," '[ (","_tParamType_",")) {
				// This will prevent GetURLWithQuery() from including this parameter in the "self" URL in the response
				do pParameters.RemoveAt(tWholeParam)
				set tText = "Unsupported search param type ("_tParamType_") for param: "_tParam
				do pErrors.logError("not-supported", "error", tText, , , , tText)
				continue
			}
			set tHasParams = 1
		}
		kill tWholeParam
		
		// If the query has an _include param or params, make sure it's valid, otherwise return an operation outcome.
		// This just validates _include, the actual processing is below.
		set tInclude = pParameters.GetAt("_include")
		set tValidIncludes = ""
		for tJ=1:1:$LL(tInclude) {
			set tIsValidInclude = 1
			set tOneInclude = $LG(tInclude, tJ)
			set tIncludeBaseType = $P(tOneInclude, ":", 1)
			set tIncludeParam = $P(tOneInclude, ":", 2)
			set tParamType = ..GetSearchParamType(pResourceType,tIncludeParam)
			// Assert that the base type of the include matches the search type.
			if (tIncludeBaseType '= pResourceType) {
				set tText = "Base type of _include must be the same as search type. Ignoring: "_tOneInclude
				do pErrors.logError("value", "error", tText, , , , tText)
				set tIsValidInclude = 0
			}
			// Assert that the named param is valid for this resource type.
			elseif (tParamType="") {
				set tText = "_include references a non-existent or unsupported search param. Ignoring: "_tOneInclude
				do pErrors.logError("value", "error", tText, , , , tText)
				set tIsValidInclude = 0
			}
			// Assert that the named param is of type "reference"
			elseif (tParamType '= "reference") {
				set tText = "_include must name a search param of type reference. Ignoring: "_tOneInclude
				do pErrors.logError("value", "error", tText, , , , tText)
				set tIsValidInclude = 0
			}
			
			// Put it in the list of valid includes if it passes validation
			if tIsValidInclude set tValidIncludes = tValidIncludes_$LB(tOneInclude)
		}
		quit:$$$ISERR(tSC)
		
		// Assume that pErrors was empty before starting to validate the search
		// parameters. Therefore if there are any errors now, they are due to
		// invalid search parameters. In that case, quit now.
		if pErrors.HighestError="error" {
			set tSC = $$$ERROR($$$GeneralError, "Invalid search parameters found")
			quit
		}
		
		// If the name of the table is an SQL reserved word (ex: Procedure, Group), it must be quoted.
		// tType should have been validated above via HS.FHIR.Utils:IsValidResourceType().
		if '..#RESOURCEIDINSEARCHRESULTSET {
			set tSQL = "SELECT ResourceLogicalId As ID FROM "
		} else {
			set tSQL = "SELECT ResourceLogicalId As ID,_id As ResourceId FROM "
		}
		set tSQL = tSQL_$TR(##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).#SEARCHTABLEPACKAGE,".","_")_"."_$S($system.SQL.IsReservedWord(pResourceType):$C(34)_pResourceType_$C(34), 1:pResourceType)
		
		set tSQLParams = 0
		set tFirstParam = 1
		if (pCompartment '= "") {
			set tFirstParam = 0
			set tSQL = tSQL_" WHERE "
			set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchCompartment(pResourceType, pCompartment, pResourceId, .tSQL, .tSQLParams) quit:$$$ISERR(tSC)
		}
		for {
			// NOTE: tParamVals is a LIST!
			set tParamVals = pParameters.GetNext(.tWholeParam) quit:tWholeParam=""
			set tParam=$P(tWholeParam,":"), tModifier=$P(tWholeParam,":",2)
			if tNotSearchKeys[(","_tParam_",") continue
			set tParamType = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetSearchParamType(pResourceType,tParam,.tPropType)
			// If this is the first parameter (and it's valid) no need to do anything to the query,
			//  but set tFirstParam to 0 so the next time we know we need to add "AND"
			if (tFirstParam)&&(tParamType'="") {
				set tFirstParam = 0
				set tSQL = tSQL_" WHERE "
			}
			else { set tSQL = tSQL_" AND " }
			set tSQL = tSQL_"("
			if (tParamType = "token") {
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchToken(tWholeParam, tParamVals, .tSQL, .tSQLParams, tPropType) quit:$$$ISERR(tSC)
			}
			elseif (tParamType = "date") {
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchDate(pResourceType, tWholeParam, tParamVals, .tSQL, .tSQLParams, tPropType) quit:$$$ISERR(tSC)
			}
			elseif (tParamType = "string") {
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchString(tWholeParam, tParamVals, .tSQL, .tSQLParams) quit:$$$ISERR(tSC)
			}
			elseif (tParamType = "reference") {
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchReference(tWholeParam, tParamVals, .tSQL, .tSQLParams) quit:$$$ISERR(tSC)
			}
			elseif (tParamType = "quantity") {
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchQuantity(pResourceType, tWholeParam, tParamVals, .tSQL, .tSQLParams) quit:$$$ISERR(tSC)
			}
			elseif (tParamType = "number") { 
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchNumber(tWholeParam, tParamVals, .tSQL, .tSQLParams) quit:$$$ISERR(tSC)
			}
			elseif (tParamType = "uri") { 
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).SearchURI(tWholeParam, tParamVals, .tSQL, .tSQLParams) quit:$$$ISERR(tSC)
			}
			set tSQL = tSQL_")"
		}
		if (pSessionIdentifier'="") {
			set tSQL = tSQL_$S(tFirstParam:" WHERE",1:" AND")_" ResourceLogicalId->Session=?"
			set tSQLParams($I(tSQLParams)) = pSessionIdentifier
		}
		quit:$$$ISERR(tSC)
		
		set tStatement = ##class(%SQL.Statement).%New()

		// Prepare
		if tLog set tSQLPrepareStart = $ZHOROLOG
		set tSC = tStatement.%Prepare(.tSQL)
		if $$$ISERR(tSC) {
			set tSC = $$$ERROR($$$GeneralError, "Error preparing query for search interaction: "_$system.Status.GetErrorText(tSC))
			quit
		}
		if tLog set tSQLPrepareEnd = $ZHOROLOG
		if tLog set tSQLPrepare = (tSQLPrepareEnd-tSQLPrepareStart)
		
		#dim tSQLResultSet As %SQL.StatementResult
		
		// Execute
		if tLog set tSQLExecuteStart = $ZHOROLOG
		set tSQLResultSet = tStatement.%Execute(tSQLParams...)
		if (tSQLResultSet.%SQLCODE < 0) { 
			set tSC = $$$ERROR($$$GeneralError, "Error executing query for search interaction: SQL error, SQLCODE="_tSQLResultSet.%SQLCODE_", Msg="_tSQLResultSet.%Message)
			quit 
		}
		if tLog set tSQLExecute1 = ($ZHorolog-tSQLExecuteStart)
		
		Set pResultSet = ##class(HS.Util.TransientTable).%New()
		Set tDeletedColNum = pResultSet.%AddColumn("Deleted", "%String")
		Set tIDColNum = pResultSet.%AddColumn("ID", "%String")
		Set tResourceTypeColNum = pResultSet.%AddColumn("ResourceType", "%String")
		Set tResourceIdColNum = pResultSet.%AddColumn("ResourceId", "%String")
		Set tModeColNum = pResultSet.%AddColumn("Mode", "%String")
		Set tRefersToColNum = pResultSet.%AddColumn("RefersTo", "%String")
		
		Set tSQLIDColNum = 1
		Set tSQLResourceIdColNum = 2
		
		Kill tReferenceToStorageId
		
		// Create TransientTable result set from initial SQL result set.
		While tSQLResultSet.%Next() {
			Set tStorageId = tSQLResultSet.%GetData(tSQLIDColNum)
			Do pResultSet.%NewRow()
			Do pResultSet.%SetData(tDeletedColNum, "")
			Do pResultSet.%SetData(tIDColNum, tStorageId)
			Do pResultSet.%SetData(tResourceTypeColNum, pResourceType)
			If '..#RESOURCEIDINSEARCHRESULTSET {
				Do pResultSet.%SetData(tResourceIdColNum, "")
			} Else {
				Do pResultSet.%SetData(tResourceIdColNum, $ListGet(tSQLResultSet.%GetData(tSQLResourceIdColNum),1))
			}
			Do pResultSet.%SetData(tModeColNum, "match")
			Set tSC = pResultSet.%SaveRow()
			If $$$ISERR(tSC) Quit
		}
		If pResultSet.%ROWCOUNT=0 Quit
		
		Do pResultSet.%SetIterator(0)
		
		// If there is a search post processor class specified, then apply it only to the initial result set.
		If pSearchPostProcessorClass'="" {
			// search-all (pRequest.Type=""), or search parameters _include, _revinclude or _contained,
			// could cause more than one resource type to be represented in the result set.
			If (pResourceType'="")&&(($ListLength(tValidIncludes))||(pParameters.GetAt("_revinclude")'="")||(pParameters.GetAt("_contained")'="")) {
				While pResultSet.%Next() {
					If pResultSet.%GetData(tResourceTypeColNum)'=pResourceType {
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
			Set tNonDeletedRowCount = 0
			While (pResultSet.%Next()) {
				If 'pResultSet.%GetData(tDeletedColNum) If $i(tNonDeletedRowCount)
			}
			Do pResultSet.%SetIterator(0)
			If tNonDeletedRowCount=0 Quit
		} Else {
			Set tNonDeletedRowCount = pResultSet.%ROWCOUNT
		}
		
		// Apply any specified sorting to the post-processed result set. If sorting is
		// applied, rows that were marked as Deleted by the post processing will be
		// dropped from the result set.
		If $Data(tSortKeys) {
			Kill @..#TEMPSORTGLOBAL
			Set tSC = ..AddResultsToTempSort(pResultSet, .tSortKeys, tDeletedColNum, tIDColNum, tResourceTypeColNum, tResourceIdColNum, tModeColNum, ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).#SEARCHTABLEPACKAGE, ..#TEMPSORTGLOBAL)
			If $$$ISERR(tSC) Kill @..#TEMPSORTGLOBAL Quit
			// At this point, the old result set is of no use to us any more. Delete it,
			// re-initialize it, and pass it into CreateSortedResultSet for re-population.
			Kill pResultSet
			Set pResultSet = ##class(HS.Util.TransientTable).%New()
			Set tDeletedColNum = pResultSet.%AddColumn("Deleted", "%String")
			Set tIDColNum = pResultSet.%AddColumn("ID", "%String")
			Set tResourceTypeColNum = pResultSet.%AddColumn("ResourceType", "%String")
			Set tResourceIdColNum = pResultSet.%AddColumn("ResourceId", "%String")
			Set tModeColNum = pResultSet.%AddColumn("Mode", "%String")
			Set tRefersToColNum = pResultSet.%AddColumn("RefersTo", "%String")
			Set tSC = ..CreateSortedResultSet(..#TEMPSORTGLOBAL, .tSortKeys, tDeletedColNum, tIDColNum, tResourceTypeColNum, tResourceIdColNum, tModeColNum, .pResultSet)
			Kill @..#TEMPSORTGLOBAL
			If $$$ISERR(tSC) Quit
			Do pResultSet.%SetIterator(0)
		}
		
		// If there are still non-deleted rows remaining in the result set after post
		// processing has been applied, then assume that any resources to be pulled
		// in by those non-deleted resources via _include and references are okay to
		// add.
		
		Set tIncludeStreamletIds = ""
		
		If $ListLength(tValidIncludes) {
			While (pResultSet.%Next()) {
				If pResultSet.%GetData(tDeletedColNum) Continue
				Set tStorageId = pResultSet.%GetData(tIDColNum)
				// Only populate the "RefersTo" column when _include is specified on the search.
				Set tSearchTableObj = $CLASSMETHOD(##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).#SEARCHTABLEPACKAGE_"."_pResourceType, "%OpenId", tStorageId)
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
						Set tSearchParamNormalized = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).NormalizeParamName(tSearchParam)
						For j = 1:1:$Property(tSearchTableObj, tSearchParamNormalized).Count() {
							Set tRef = $Property(tSearchTableObj, tSearchParamNormalized).GetAt(j)
							If $Length(tRef,"/")'=2 Continue
							If $Data(tAlreadyLogged(tRef)) Continue
							If $Data(tReferenceToStorageId(tRef)) {
								Set tRefStorageId = tReferenceToStorageId(tRef)
							} Else {
								Set tSC = ..GetStorageIdByTypeAndId($Piece(tRef,"/",1), $Piece(tRef,"/",2), , pSessionIdentifier, .tRefStorageId)
								If $$$ISERR(tSC) Quit
							}
							If tRefersTo'="" Set tRefersTo = tRefersTo_","
							Set tRefersTo = tRefersTo_tRefStorageId
							Set tReferenceToStorageId(tRef) = tRefStorageId
							Set tAlreadyLogged(tRef) = ""
						}
						If $$$ISERR(tSC) Quit
					}
					If $$$ISERR(tSC) Quit
				}
				If $$$ISERR(tSC) Quit
				If tRefersTo'="" Do pResultSet.%SetData(tRefersToColNum, tRefersTo)
				
				Set tSC = pResultSet.%SaveRow()
				If $$$ISERR(tSC) Quit
				
				// Gather resources pointed to by any valid _include search parameters.
				Set tSC = ..SearchInclude(pResourceType, tStorageId, pSessionIdentifier, tValidIncludes, .tIncluded, .tOneStreamletIds)
				If $$$ISERR(tSC) Quit
				
				// SearchInclude already makes sure the same resource is not _include-ed
				// more than once, so no need to check for duplicates here.
				For tJ = 1:1:$ListLength(tOneStreamletIds) {
					Set tStreamletId = $ListGet(tOneStreamletIds, tJ)
					Set $List(tIncludeStreamletIds, *+1) = tStreamletId
				}
			}
		}
		
		For tJ = 1:1:$ListLength(tIncludeStreamletIds) {
			Set tTargetLogicalId = $ListGet(tIncludeStreamletIds, tJ)
			Set tSC = ..GetStorageDataByStorageId(tTargetLogicalId, .tResourceType, .tResourceId)
			If $$$ISERR(tSC) Quit
			Do pResultSet.%NewRow()
			Do pResultSet.%SetData(tDeletedColNum, "")
			Do pResultSet.%SetData(tIDColNum, tTargetLogicalId)
			Do pResultSet.%SetData(tResourceTypeColNum, tResourceType)
			Do pResultSet.%SetData(tResourceIdColNum, tResourceId)
			Do pResultSet.%SetData(tModeColNum, "include")
			Set tSC = pResultSet.%SaveRow()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit
		
		If pResultSet.%ROWCOUNT>0 Do pResultSet.%SetIterator(0)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $Get(tLog)&&($Get(tSQLPrepare)'="")&&($Get(tSQLExecuteStart)'="")&&($Get(tSQLExecute1)'="")&&($Get(tSQL)'="") {
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
		set tParamString = ##class(HS.FHIR.Utils).URLParameterArrayToString(pParameters)
		if tParamString'="" Set tOrigQuery = tOrigQuery_"?"_tParamString
		set tSQLWithParams = tSQL
		set tSQLParams = +$Get(tSQLParams)
		for tI=1:1:tSQLParams { set tSQLWithParams = $REPLACE(tSQLWithParams, "?", "'"_tSQLParams(tI)_"'", , 1) }
		set ^HS.FHIR.Log.Search($i(^HS.FHIR.Log.Search(0))) = $LB(tTimestamp, tOrigQuery, tSQLWithParams, tSQLPrepare, tSQLExecute1, tSQLExecute2)
	}
	
	Quit tSC
}

/// ValidateSortKeys validates the sort keys that were passed in as URL parameters, as per
/// the FHIR DSTU2 specification. If validation is successful, it returns information about
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
		// The logic in the DSTU2 version of this method is very different than that for
		// STU3 and later. This is because of the difference in the FHIR spec with regard
		// to sort key specification.
		
		If pResourceType="" {
			Set tSC = $$$ERROR($$$GeneralError, "Sorting across resource types is not supported")
			Quit
		}
		
		Set tErrorText = ""
		
		Set tSortKeyIdx = 0
		Set tSortKeyCount = 0
		
		Set tKey = ""
		For {
			Set tVal = pParameters.GetNext(.tKey)
			If tKey="" Quit
			If $Extract(tKey,1,5)="_sort" {
				Set tKey2 = $Extract(tKey,6,*)
				If '((tKey2="")||(tKey2=":asc")||(tKey2=":desc")) {
					Set tErrorText = "Invalid modifier '"_tKey2_"' on _sort parameter"
					Quit
				} Else {
					For i = 1:1:$ListLength(tVal) {
						Set tValLG = $ListGet(tVal,i)
						// Sort key names might have an integer value appended, delimited
						// from the sort key name by colon (:). That number is the position
						// in which the sort key param and value appeared in the original
						// request URL. Either all of the sort key names will have that
						// order value attached, or none will.
						If tValLG[":" {
							Set tSortKeyIdx = $Piece(tValLG,":",2)
							Set tValLG = $Piece(tValLG,":",1)
						} Else {
							If $i(tSortKeyIdx)
						}
						Set tSortArray(tSortKeyIdx,"KeyName") = tValLG
						Set tSortArray(tSortKeyIdx,"KeyDirection") = $Select(tKey2=":desc":"desc",1:"asc")
						Set tSortKeyCount = tSortKeyCount + 1
					}
				}
			}
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
		If tSortKeyCount>5 {
			Set tSC = $$$ERROR($$$GeneralError, "Sorting by more than 5 sort keys is not supported")
			Quit
		}
		// The absence of sort keys is not considered a fail.
		If tSortKeyCount=0 Quit
		
		Set tSortKeyCount = 0
		
		Set i = ""
		For {
			Set i = $Order(tSortArray(i))
			If i="" Quit
			Set tSortKeyStr = tSortArray(i,"KeyName")
			If tSortKeyStr="" Set tErrorText = "Blank sort key specified" Quit
			If $Data(tKeys(tSortKeyStr)) Set tErrorText = "Duplicate sort keys '"_tSortKeyStr_"' specified" Quit
			If tSortKeyStr="0" Set tErrorText = "Invalid sort key '"_tSortKeyStr_"' specified" Quit
			If '$Data(%HSFHIRSearchParams("DSTU2",pResourceType)) Do ..CacheSearchParams(pResourceType)
			Set tSearchParamInfo = $Get(%HSFHIRSearchParams("DSTU2",pResourceType,tSortKeyStr))
			If tSearchParamInfo="" Set tErrorText = "Invalid sort key '"_tSortKeyStr_"' specified" Quit
			Set tSortKeyType = $Piece(tSearchParamInfo,"^",1)
			If tSortKeyType="quantity" Set tErrorText = "Sort key '"_tSortKeyStr_"' is not supported" Quit
			Set tKeys(tSortKeyStr)=""
			If $i(tSortKeyCount)
			Set pSortKeys(tSortKeyCount,"KeyName") = tSortKeyStr
			Set pSortKeys(tSortKeyCount,"KeyNameNormalized") = ##class(HS.FHIR.vCommon.ResourceBase).NormalizeParamName(tSortKeyStr)
			Set pSortKeys(tSortKeyCount,"Direction") = tSortArray(i,"KeyDirection")
			Set pSortKeys(tSortKeyCount,"KeyType") = tSortKeyType
			Set pSortKeys(tSortKeyCount,"XPathType") = $Piece(%HSFHIRSearchParams("DSTU2",pResourceType,tSortKeyStr),"^",5)
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
				// Sort on quantity fields is not supported at this time.
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
		set tSQL = "SELECT ID FROM HS_FHIR_vDSTU2_Repository_Resource.Abstract WHERE FOR SOME %ELEMENT(Compartments) (%VALUE=?)"
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
		// See http://hl7.org/fhir/DSTU2/search.html#include for a full description of the _include parameter.
		// The _include parameter allows a client to request that, in addition to the resources selected by
		// by the criteria of a query, the server also include in the response bundle certain resources
		// referenced by the selected resources. The parts of an _include parameter are:
		// 1. The name of the source resource from which the join comes (for a regular _include,
		//    which is all we support right now, this should always be the same as the resource type
		//    being searched on)
		// 2. The name of the search parameter which must be of type reference
		// 3. (Optional) A specific of type of target resource (for when the search parameter refers to 
		//    multiple possible target types)
		set tSearchTableObj = $CLASSMETHOD(##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).#SEARCHTABLEPACKAGE_"."_pResourceType, "%OpenId", pStorageId)
		
		// The only way I can think of that this might happen is if this is a paged search, and this result is not on the first page,
		//  and between the time the search was executed and this page was accessed, the resource was deleted. The standard
		//  discusses this briefly: http://www.hl7.org/fhir/search.html#currency
		if ('$IsObject(tSearchTableObj)) Quit
		
		for tJ=1:1:$LL(pValidIncludes) {
			set tOneInclude = $LG(pValidIncludes, tJ)
			set tIncludeBaseType = $P(tOneInclude, ":", 1)
			set tIncludeParam = $P(tOneInclude, ":", 2)
			set tIncludeTargetType = $P(tOneInclude, ":", 3)
			
			set tValueList = $PROPERTY(tSearchTableObj, ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).NormalizeParamName(tIncludeParam))
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
				set tSC = ##class(HS.FHIR.vDSTU2.Repository.Storage).GetStorageIdByTypeAndId(tTargetType, tTargetResourceId, , pSessionIdentifier, .tTargetLogicalId)
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
/// Reference: http://hl7.org/fhir/DSTU2/http.html#history<br>
/// This method retrieves all the stored versions of a specified FHIR resource and returns
/// a result set object that includes minimal but vital information about each item.<br>
/// Input:<br>
/// <li>pResourceType      : (required) FHIR resource type.
/// <li>pResourceId        : (required) FHIR resource id.
/// <li>pSince             : FHIR instant-type value for the history _since parameter. This is for
///                          requesting only the history items that occurred after a specified time.
/// <li>pAt                : (not applicable) STU3-specific history parameter, not applicable to DSTU2.
/// <li>pSessionIdentifier : Session identifier, used for session-based resource storage.
/// <br>Output:<br>
/// <li>pResultSet         : <class>HS.Util.TransientTable</class> object for holding the results of
///                          the history search.  Columns in pResultSet are:<br>
///                          StorageId = The physical storage object id.<br>
///                          Verb = The HTTP method that produced the history item (e.g., PUT, POST).<br>
///                          Deleted = 1 means the item is the result of a DELETE, 0 means not deleted.
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod History(pResourceType, pResourceId, pSince = "", pAt = "", pSessionIdentifier As %String = "", Output pResultSet As HS.Util.TransientTable, Output pErrors As HS.Types.FHIR.Errors) As %Status
{
	#dim tStreamlet As HS.FHIR.vDSTU2.Repository.Resource.Abstract
	
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
		If ('##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).ResourceExists(pSessionIdentifier, pResourceType, pResourceId)) {
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
		
		Set tCurrentVersion = ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).CurrentVersion(pSessionIdentifier, pResourceType, pResourceId)
		
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
		// DSTU2 dataelements.xml using this context and expression:
		// context    = "/f:Bundle/f:entry[f:resource/f:DataElement]/f:resource/f:DataElement[f:element/f:type/f:code/@value='Reference' and (f:element/f:type/f:profile/@value='http://hl7.org/fhir/StructureDefinition/Patient')]"
		// expression = "f:id/@value"
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Account","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AllergyIntolerance","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AllergyIntolerance","recorder")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AllergyIntolerance","reporter")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Appointment","participant.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AppointmentResponse","actor")=""
		// An AuditEvent can be linked to multiple resources, so AuditEvent should be considered shared.
		//Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"AuditEvent","participant.reference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Basic","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"BodySite","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CarePlan","activity.detail.performer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CarePlan","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CarePlan","participant.member")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CarePlan","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Claim","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Claim","payee.person")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ClinicalImpression","patient")=""
		// Despite Communication and CommunicationRequest both having recipient and
		// sender and subject properties, they are considered non-shared.
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Communication","recipient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Communication","sender")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Communication","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","recipient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","requester")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","sender")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"CommunicationRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Composition","attester.party")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Composition","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Condition","asserter")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Condition","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Contract","actor.entity")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Contract","signer.party")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Contract","term.actor.entity")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Coverage","subscriber")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DetectedIssue","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Device","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DeviceUseRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DeviceUseStatement","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DiagnosticOrder","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DiagnosticReport","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentManifest","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentManifest","recipient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentManifest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentReference","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentReference","context.sourcePatientInfo")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"DocumentReference","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Encounter","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"EnrollmentRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"EpisodeOfCare","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"FamilyMemberHistory","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Flag","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Flag","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Goal","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Goal","subject")=""
		// Despite Group possibly pointing to multiple resources/entities, it should be considered non-shared.
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Group","member.entity")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImagingObjectSelection","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImagingObjectSelection","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImagingStudy","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Immunization","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ImmunizationRecommendation","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"List","source")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"List","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Media","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationAdministration","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationAdministration","practitioner")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationDispense","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationDispense","receiver")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationOrder","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationStatement","informationSource")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"MedicationStatement","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"NutritionOrder","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Observation","performer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Observation","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Order","subject")=""
		// link.other is not really what makes this non-shared, the fact that this type is Patient does.
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Patient","link.other")=""
		// A Person can be linked to multiple Patients, so Person should be considered shared.
		//Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Person","link.target")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Procedure","performer.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Procedure","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ProcedureRequest","orderer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ProcedureRequest","performer")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ProcedureRequest","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Provenance","agent.actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"QuestionnaireResponse","author")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"QuestionnaireResponse","source")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ReferralRequest","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"ReferralRequest","requester")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"RelatedPerson","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"RiskAssessment","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Schedule","actor")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Signature","whoReference")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"Specimen","subject")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"SupplyDelivery","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"SupplyRequest","patient")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"SupplyRequest","source")=""
		Set %FHIRNonSharedResourceTypes(..#VERSIONKEY,"VisionPrescription","patient")=""
	}
	
	Quit ($Data(%FHIRNonSharedResourceTypes(..#VERSIONKEY,pResourceType))=0)
}

/// Given a resource type and the name of a search parameter, return the type
/// of that parameter (token, string, reference, date, uri, quantity, number, etc.).
/// This will return null if pResourceType is valid but pParamName is not recognized.
ClassMethod GetSearchParamType(pResourceType As %String, pParamName As %String) As %String
{
	Quit ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetSearchParamType(pResourceType, pParamName)
}

ClassMethod FindMatchingResourceIds(pResourceType As %String, pResourceStreamId As %String, pSession As %String = "") As %String
{
	// Not implemented.
	Quit ""
}

ClassMethod GenerateResourceId(pResourceType As %String, pSession As %String = "") As %String
{
	Quit ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GenerateResourceId(pResourceType, pSession)
}

ClassMethod CacheSearchParams(pResourceType As %String) As %Status
{
	Quit ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).CacheSearchParams(pResourceType, ..#CUSTOMSTORAGEPKG)
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
	
	For tStoragePkg = ..#CUSTOMSTORAGEPKG, ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).#STORAGEPKG {
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
	Quit ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).GetRefTypeIdsFromSearchParam(pParamName, pParamVals, pSearchResourceType, pReferenceResourceType, .pReturnVals)
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
	Quit ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).DeleteOrphanedResources()
}

ClassMethod DeleteSessionResources(pSession As %String) As %Status
{
	Quit ##class(HS.FHIR.vDSTU2.Repository.Resource.Abstract).DeleteSessionResources(pSession)
}

}
