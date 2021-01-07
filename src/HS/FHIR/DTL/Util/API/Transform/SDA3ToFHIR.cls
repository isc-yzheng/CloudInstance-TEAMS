Class HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR Extends %RegisteredObject
{

/// Contains the FHIR Bundle generated during the transformation. If transforming
/// individual SDA classes, it contain the FHIR representation of those classes and
/// can be continuously appended to. If transforming a Container, 
/// will be the entire contents of the Container, represented as FHIR.
Property bundle As %DynamicObject [ Calculated ];

Property schema As HS.FHIRServer.Schema [ Calculated ];

Property fhirVersion As %String [ Calculated ];

Property %bundle As %DynamicObject [ Private ];

Property %schema As HS.FHIRServer.Schema [ Private ];

Property %fhirVersion As %String [ Private ];

Property %resourceValidator As HS.FHIRServer.Util.ResourceValidator [ Private ];

Property %patientId As %String [ Private ];

/// Tracks the id mapping from an SDA identifier and resource type to a
/// resource id
Property %resourceIds As %String [ MultiDimensional, Private ];

/// Maps the resource type and id to the actual resource for O(1) lookup when
/// resolving certain references
Property %resourceIndex [ MultiDimensional, Private ];

/// Transforms an SDA stream (Container or SDA class) to the specified FHIR version. Returns an instance of this class
/// which contains a "bundle" property. That property will contain a FHIR Bundle with all the resources
/// generated during the transformation, and with all references resolved. If <var>patientId</var> or
/// <var>encounterId</var> are specified, those values will go into any applicable Patient and Encounter
/// references.
/// @API.Method
/// @Argument	stream			%Stream representation of an SDA object or Container
/// @Argument	SDAClassname	Classname for the object contained in the stream (eg. HS.SDA3.Container)
/// @Argument	fhirVersion		Version of FHIR used by the resource, eg. "STU3", "R4"
/// @Argument	patientId		(optional) FHIR resource id to be assigned to the Patient resource
/// @Argument	encounterId		(optional) FHIR resource id to be assigned to the Encounter resource, if not transforming a Container
ClassMethod TransformStream(stream As %Stream.Object, SDAClassname As %String, fhirVersion As %String, patientId As %String = "", encounterId As %String = "") As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR
{
	set source = $classmethod(SDAClassname, "%New")
	if SDAClassname = "HS.SDA3.Container" {
		$$$ThrowOnError(source.InitializeXMLParse(stream, "SDA3"))
	}
	else {
		$$$ThrowOnError(source.XMLImportSDAString(stream.Read(3700000)))
	}
	return ..TransformObject(source, fhirVersion, patientId, encounterId)
}

/// Transforms an SDA object (Container or SDA class) to the specified FHIR version. Returns an instance of this class
/// which contains a "bundle" property. That property will contain a FHIR Bundle with all the resources
/// generated during the transformation, and with all references resolved. If <var>patientId</var> or
/// <var>encounterId</var> are specified, those values will go into any applicable Patient and Encounter
/// references.
/// @API.Method
/// @Argument	source			SDA object or Container
/// @Argument	fhirVersion		Version of FHIR used by the resource, eg. "STU3", "R4"
/// @Argument	patientId		(optional) FHIR resource id to be assigned to the Patient resource
/// @Argument	encounterId		(optional) FHIR resource id to be assigned to the Encounter resource, if not transforming a Container
ClassMethod TransformObject(source, fhirVersion As %String, patientId As %String = "", encounterId As %String = "") As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR
{
	set schema = ##class(HS.FHIRServer.Schema).LoadSchema(fhirVersion)
	set transformer = ..%New(schema)
	
	//SDA gets patient and encounter id and Container only gets patient id
	//because a Container can have multiple encounters and we can't assume which one they're referring to
	if source.%ClassName(1) = "HS.SDA3.Container" {
		do transformer.TransformContainer(source, patientId)
	}
	else {
		do transformer.TransformSDA(source, patientId, encounterId)
	}
	
	return transformer
}

/// Transforms an SDA Container to FHIR. Returns an instance of this class
/// which contains a "bundle" property. That property will contain a FHIR Bundle with all the resources
/// generated during the transformation, and with all references resolved. 
/// @API.Method
/// @Argument	source			SDA Container
/// @Argument	patientId		(optional) FHIR resource id to be assigned to the Patient resource
Method TransformContainer(source As HS.SDA3.Container, patientId As %String = "") As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR
{
	if ..%bundle.entry.%Size() > 0 {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Multiple Containers cannot be transformed consecutively. This API only supports single patient context."))
	}
	
	if patientId '= "" {
		set ..%patientId = patientId
		set ..%resourceIds("Patient") = patientId
	}
	
	while source.GetNextSDA(.sdaType, .sdaObj, .tSC) {
		$$$ThrowOnError(tSC)
		
		do ..TransformHelper(sdaObj)
	}
	
	return $this
}

/// Transforms an SDA object to FHIR. Returns an instance of this class
/// which contains a "bundle" property. That property will contain a FHIR Bundle with all the resources
/// generated during the transformation, and with all references resolved. 
/// @API.Method
/// @Argument	source			SDA object
/// @Argument	patientId		(optional) FHIR resource id to be assigned to the Patient resource
/// @Argument	encounterId		(optional) FHIR resource id to be assigned to the Encounter resource, if not transforming a Container
Method TransformSDA(source As HS.SDA3.SuperClass, patientId As %String = "", encounterId As %String = "") As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR
{
	if patientId '= "" {
		set ..%patientId = patientId
		set ..%resourceIds("Patient") = patientId
	}
	if encounterId '= "" {
		set ..%resourceIds("Encounter") = encounterId
	}
	
	do ..TransformHelper(source)
	
	return $this
}

/// Resets this transformer object to its initial state.
/// @API.Method
Method Reset()
{
	set ..%bundle = ##class(%DynamicObject).%New()
	set ..%bundle.resourceType = "Bundle"
	set ..%bundle.type = "transaction"
	set ..%bundle.entry = ##class(%DynamicArray).%New()
	set ..%patientId = ""
	kill ..%resourceIds, ..%resourceIndex
}

/// Helper method for the transformation
Method TransformHelper(source As HS.SDA3.SuperClass) [ Internal, Private ]
{
	set DTL = ..GetDTL(source)
	quit:(DTL="")
	
	set aux("transformer") = $this
	set target = $classmethod($classmethod(DTL, "GetTargetType"), "%New")
	$$$ThrowOnError($classmethod(DTL, "Transform", source, .target, .aux))
	
	set reference = ..AddResource(source, target)
	
	if (source.%ClassName(1) = "HS.SDA3.Medication") &&
			((target.resourceType = "MedicationDispense") || (target.resourceType = "MedicationRequest")) {
		if target.resourceType = "MedicationDispense" {
			if (target.authorizingPrescription.Count() > 0) && (target.authorizingPrescription.GetAt(1).reference '= "") {
				set medicationRequestReference = target.authorizingPrescription.GetAt(1)
				set medicationRequestId = $select((medicationRequestReference.reference [ "urn:uuid:"):$piece(medicationRequestReference.reference, "urn:uuid:", *), 1:$piece(medicationRequestReference.reference, "/", *))
				set medicationRequestJson = ..ResourceLookup("MedicationRequest", medicationRequestId)
				if medicationRequestJson '= "" {
					set medicationReference = $classmethod("HS.FHIR.DTL." _ ..fhirVersion _ ".Model.Base.Reference", "%New")
					set medicationReference.reference = medicationRequestJson.medicationReference.reference
				}
			}
		}
		else {
			set medicationReference = target.medicationReference
			set medicationRequestReference = reference
		}
		
		$$$ThrowOnError(##class(HS.FHIR.DTL.Util.SDA3.Handler.Medication).MedicationAdministration(source, .responses, .aux))
		for i=1:1:responses.Count() {
			if $get(medicationReference) '= "" {
				set responses.GetAt(i).medicationReference = medicationReference
			}
			if $get(medicationRequestReference) '= "" {
				if ..fhirVersion = "vSTU3" {
					set responses.GetAt(i).prescription = medicationRequestReference
				}
				else {
					set responses.GetAt(i).request = medicationRequestReference
				}
			}
			do ..AddResource(source.Administrations.GetAt(i), responses.GetAt(i))
		}
	}
}

/// Specifies the DTL class to use for a given SDA object. A preferred DTL will be specified in 
/// subtransformations, but will not be specified for top level transformations. Default logic
/// for top level transformations can be viewed in the FHIR annotations, under the Container
/// mappings. This can be overriden if different logic is desired.
/// @API.Overrideable
Method GetDTL(source As HS.SDA3.DataType, DTL As %Dictionary.Classname = "") As %Dictionary.Classname
{
	set useCustom = (##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetCustomDTLPackage() '= "")
	if DTL '= "" {
		return $select(useCustom: ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetDTLPackageAndClass(DTL),
						1:DTL)
	}
	set aux("transformer") = $this
	set SDAClass = source.%ClassName(1)
	for {
		set DTL = $order(^HS.XF.Transform("SDA3", ..%fhirVersion, SDAClass, DTL))
		quit:DTL=""
		
		set condition = ^HS.XF.Transform("SDA3", ..%fhirVersion, SDAClass, DTL)
		if (condition '= "") && $xecute("(source, aux) return (" _ condition _ ")", source, .aux) {
			return $select(useCustom: ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetDTLPackageAndClass(DTL),
							1:DTL)
		}
	}
	return ""
}

/// Overrideable method which indicates whether a resource is a duplicate. This method
/// shall return a reference to the original resource if the one provided is a duplicate.
/// Otherwise, it shall return an empty string. The id that will be assigned to the resource
/// if it's not a duplicate is also provided. Default implementation is to deduplicate shared
/// resources if the json representations of them are identical.
/// @API.Overrideable
Method IsDuplicate(resource As %DynamicObject, id As %String) As HS.FHIR.DTL.vR4.Model.Base.Reference [ Private ]
{
	if ..%schema.IsSharedResourceType(resource.resourceType) {
		do $system.Encryption.SHA1HashResult()
		//Hash will be computed on first 32KB of resource stream
		do $system.Encryption.SHA1HashInput(resource.%ToJSON())
		set hash = $system.Encryption.Base64Encode($system.Encryption.SHA1HashResult())
		
		if $data(..%resourceIndex("hash", hash)) {
			return ..CreateReference(resource.resourceType, ..%resourceIndex("hash", hash))
		}
		
		set ..%resourceIndex("hash", hash) = id
	}
	return ""
}

/// Returns a resource given a try and id. Default implementation is to only search
/// the resources created and in the Bundle, but other implementations may want to also search
/// in a repository
/// @API.Overrideable
Method ResourceLookup(resourceType As %String, id As %String) As %DynamicObject [ Private ]
{
	if $data(..%resourceIndex(resourceType, id)) {
		return ..%resourceIndex(resourceType, id)
	}
	else {
		return ""
	}
}

/// Ensures the resource is valid FHIR, adds the resource to the output Bundle,
/// and returns a reference to that resource. Will also output the resource as a
/// %DynamicObject.
Method AddResource(source As HS.SDA3.SuperClass, resource As %RegisteredObject, Output resourceJson As %DynamicObject) As HS.FHIR.DTL.vR4.Model.Base.Reference [ Internal ]
{
	set resourceJson = ##class(%DynamicObject).%FromJSON(resource.ToJSON())
	try {
		do ..%resourceValidator.ValidateResource(resourceJson)
	} catch ex {
		do ..HandleInvalidResource(resourceJson, ex)
		return ""
	}
	
	set entry = ##class(%DynamicObject).%New()
	set entry.request = ##class(%DynamicObject).%New()
	
	set id = ..GetId(source, resourceJson)
	if id '= "" {
		set resource.id = id
		set resourceJson.id = id
	}
	
	//Check for an SDA identifier->id mapping to maintain references
	set sourceIdentifier = ""
	if resource.resourceType = "Encounter" {
		set sourceIdentifier = source.EncounterNumber
	}
	elseif source.%Extends("HS.SDA3.SuperClass") {
		set sourceIdentifier = source.ExternalId
	}
	
	if id = "" {
		if (resource.resourceType = "Patient") && (..%patientId '= "") {
			set id = ..%patientId
		}
		elseif $get(..%resourceIds(resource.resourceType)) '= "" {
			set id = ..%resourceIds(resource.resourceType)
		}
		elseif (sourceIdentifier '= "") && $data(..%resourceIds(resource.resourceType, sourceIdentifier)) {
			set id = ..%resourceIds(resource.resourceType, sourceIdentifier)
		}
		
		if id '= "" {
			set resource.id = id
			set resourceJson.id = id
		}
	}
	
	if resource.id '= "" {
		set id = resource.id
		set entry.fullUrl = $select(..GetBaseURL()'="":..GetBaseURL() _ "/", 1:"") _ resource.resourceType _ "/" _ resource.id
		set entry.request.method = "PUT"
		set entry.request.url = resource.resourceType _ "/" _ resource.id
	}
	else {
		set id = $zconvert($system.Util.CreateGUID(), "L")
		set entry.fullUrl = "urn:uuid:" _ id
		set entry.request.method = "POST"
		set entry.request.url = resource.resourceType
	}
	
	//Save id mappings for later access
	if resource.resourceType = "Patient" {
		set ..%patientId = id
	}
	elseif sourceIdentifier '= "" {
		set ..%resourceIds(resource.resourceType, sourceIdentifier) = id
	}
	
	set duplicate = ..IsDuplicate(resourceJson, id)
	if duplicate '= "" {
		return duplicate
	}
	
	//Index for O(1) lookup if needed for post-processing
	set ..%resourceIndex(resource.resourceType, id) = resourceJson
	
	set entry.resource = resourceJson
	do ..%bundle.entry.%Push(entry)
	
	return ..CreateReference(resource.resourceType, id)
}

/// Returns a reference to the resource generated from the provided source identifier. Predominant
/// use case is to return a reference to the Encounter resource given an EncounterNumber
/// @API.Overrideable
Method GetReference(resourceType As %String, sourceIdentifier As %String) As %String
{
	if $get(..%resourceIds(resourceType)) '= "" {
		return ..CreateReference(resourceType, ..%resourceIds(resourceType))
	}
	
	if sourceIdentifier = "" {
		return ""
	}
	if '$data(..%resourceIds(resourceType, sourceIdentifier)) {
		set ..%resourceIds(resourceType, sourceIdentifier) = $zconvert($system.Util.CreateGUID(), "L")
	}
	
	return ..CreateReference(resourceType, ..%resourceIds(resourceType, sourceIdentifier))
}

/// Returns a reference to the Patient resource. Will generate an id if one isn't passed in
/// @API.Overrideable
Method GetPatientReference() As %String
{
	if ..%patientId = "" {
		set ..%patientId = $zconvert($system.Util.CreateGUID(), "L")
	}
	
	return ..CreateReference("Patient", ..%patientId)
}

/// Overrideable method that allows custom designation of a resource id. SDA source
/// and the generated resource are provided.
/// @API.Overrideable
Method GetId(source As HS.SDA3.SuperClass, resource As %DynamicObject) As %String
{
	return ""
}

/// Overrideable method that allows custom designation of a server base URL.
/// @API.Overrideable
Method GetBaseURL() [ Private ]
{
	return ""
}

/// Overrideable method that allows custom handling of an invalid resource. The default behavior
/// is to throw an exception and exit transformation.
/// @API.Overrideable
Method HandleInvalidResource(resource As %DynamicObject, exception As %Exception.AbstractException) [ Private ]
{
	throw exception
}

/// Helper method to generate a reference element
Method CreateReference(resourceType As %String, id As %String) [ Internal ]
{
	set reference = $classmethod("HS.FHIR.DTL." _ ..fhirVersion _ ".Model.Base.Reference", "%New")
	if ##class(HS.HC.Util).IsUUID(id) {
		set reference.reference = "urn:uuid:" _ id
	}
	else {
		set reference.reference = resourceType _ "/" _ id
	}
	
	return reference
}

/// Getter method for immutable property
Method bundleGet() [ Internal ]
{
	//They didn't provide an Patient id, but a reference was created
	if '$data(..%resourceIds("Patient")) && (..%patientId '= "") {
		if '$data(..%resourceIndex("Patient", ..%patientId)) {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Patient resource id was not specified and no Patient resource was transformed"))
		}
	}
	//They didn't provide an Encounter id, but a reference was created
	if $data(..%resourceIds("Encounter")) = 10 {
		//Check for the referenced resource
		set encounterNumber = ""
		for {
			set encounterNumber = $order(..%resourceIds("Encounter", encounterNumber))
			quit:encounterNumber=""
			
			set encounterId = ..%resourceIds("Encounter", encounterNumber)
			if '$data(..%resourceIndex("Encounter", encounterId)) {
				$$$ThrowStatus($$$ERROR($$$GeneralError, "Encounter resource id was not specified and Encounter with EncounterNumber " _ encounterNumber _ " was not transformed"))
			}
		}
	}
	
	return ..%bundle
}

/// Getter method for immutable property
Method fhirVersionGet() [ CodeMode = expression, Internal ]
{
..%fhirVersion
}

/// Getter method for immutable property
Method schemaGet() [ CodeMode = expression, Internal ]
{
..%schema
}

Method %OnNew(schema As HS.FHIRServer.Schema) As %Status [ Private, ServerOnly = 1 ]
{
	set ..%schema = schema
	set ..%resourceValidator = ##class(HS.FHIRServer.Util.ResourceValidator).%New(..schema)
	set ..%fhirVersion = ..GetXFSchemaFromMetadataSet(schema.FHIRMetadataSetKey)
	
	do ..Reset()
	
	quit $$$OK
}

/// Returns the transformation schema for a given metadata set
/// @API.Method
ClassMethod GetXFSchemaFromMetadataSet(metadataKey As %String) As %String
{
	//Get the base FHIR metadata set to determine the transformations to use
	// NOTE: This should take the schema (metaAPI) object ... but we can easily create another for now
	#dim metaAPI as HS.FHIRMeta.API = ##class(HS.FHIRMeta.API).getInstance(metadataKey)
	Set fhirVersion = +$E(metaAPI.FHIRVersion)
	set schema = $case(fhirVersion,  3:"vSTU3", 4:"vR4", :"")
	if schema = "" {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Transformations not defined for metadata set " _ metadataKey))
	}
	
	return schema
}

/// Returns a $List of FHIR resource names that are fed by SDA3 streamlets via SDA3 to FHIR transformations.
/// <p>
/// Indicate the schema name parameter with a string that starts with "v" and ends with the FHIR
/// major version number indicator. Examples of valid values are: "vSTU3", "vR4", etc.
/// @API.Method
ClassMethod GetTargetResourceList(schemaName As %String, Output resourceList) As %Status
{
	set tSC = $$$OK
	set resourceList = ""
	try {
		if schemaName="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "schemaName not specified"))
		}
		
		set source = "" for { set source = $order(^HS.XF.Transform("SDA3", schemaName, source), 1) quit:(source = "")
			set target = "" for { set target = $order(^HS.XF.Transform("SDA3", schemaName, source, target), 1) quit:(target = "")
				set fhirList($piece(target, ".", *)) = ""
			}
		}
		set keyList = "" for { set keyList = $order(fhirList(keyList), 1) quit:(keyList = "")
			if $extract(keyList)'?1L {
				set resourceList = resourceList _ $listbuild(keyList)
			}
		}
	} 
	catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
