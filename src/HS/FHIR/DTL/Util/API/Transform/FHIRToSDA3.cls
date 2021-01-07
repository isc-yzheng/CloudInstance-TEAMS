Include HS.FHIRServer

Class HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3 Extends %RegisteredObject
{

/// All SDA objects this transformer instance creates will be stored
/// here, unless Reset() is called.
Property container As HS.SDA3.Container [ Calculated ];

Property %container As HS.SDA3.Container [ Private ];

/// The most recent SDA object this transformer instance created will
/// be stored here, unless Reset() is called.
Property object As HS.SDA3.SuperClass [ Calculated ];

Property %object As HS.SDA3.SuperClass [ Private ];

Property fhirVersion As %String [ Calculated ];

Property %fhirVersion As %String [ Private ];

Property %schema As %String [ Private ];

/// Map of each resource that has been transformed
Property %resourceMap [ MultiDimensional, Private ];

/// Contains the output of HS.FHIRServer.Util.ReferenceVisitor
Property %referenceContext [ MultiDimensional, Private ];

/// Contains the mapping from FHIR resource types and IDs to
/// SDA external ids (and encounter numbers).
Property %resourceIds [ MultiDimensional, Private ];

/// The reference to the current resource being transformed. Used to
/// help generate the identifier for a streamlet, even if the resource
/// doesn't have an id.
Property %currentReference As %String [ Private ];

/// ClassMethod which transforms a FHIR resource stream into SDA. The FHIR resource can be either a Bundle or a Patient
/// specific resource, but references will only be able to be honored when transforming a Bundle. Returns an instance
/// of this class which has an "object" property containing the result of the Transform.<br/>
/// @API.Method
/// @Argument	stream			%Stream representation of a FHIR resource
/// @Argument	fhirVersion		Version of FHIR used by the resource, eg. "STU3", "R4"
ClassMethod TransformStream(stream As %Stream.Object, fhirVersion As %String, fhirFormat As %String) As HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3
{
	set schema = ##class(HS.FHIRServer.Schema).LoadSchema(fhirVersion)
	if fhirFormat = $$$FHIRContentCodeJSON {
		set dynObj = {}.%FromJSON(stream)
	} elseif fhirFormat = $$$FHIRContentCodeXML {
		set dynObj = ##class(HS.FHIRServer.Util.XMLToJSON).XMLToJSON(stream, schema)
	}
	return ..%New(schema).Transform(dynObj)
}

/// ClassMethod which transforms a FHIR resource into SDA. The FHIR resource can be either a Bundle or a Patient
/// specific resource, but references will only be able to be honored when transforming a Bundle. Returns an instance
/// of this class which has an "object" property containing the result of the Transform.<br/>
/// @API.Method
/// @Argument	source			%DynamicObject containing a FHIR resource
/// @Argument	fhirVersion		Version of FHIR used by the resource, eg. "STU3", "R4"
ClassMethod TransformObject(source As %DynamicObject, fhirVersion As %String) As HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3
{
	return ..%New(##class(HS.FHIRServer.Schema).LoadSchema(fhirVersion)).Transform(source)
}

/// Transforms a FHIR resource into SDA. The FHIR resource can be either a Bundle or a Patient specific resource,
/// but references will only be able to be honored when transforming a Bundle. Returns an instance of this class
/// which has an "object" property containing the result of the most recent Transform and a "container" property 
/// containing the result of all Transforms using this transformer.<br/>
/// @API.Method
/// @Argument	source		%DynamicObject containing a FHIR resource
Method Transform(source As %DynamicObject) As HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3
{
	if source.resourceType = "Bundle" {
		return ..TransformBundle(source)
	}
	else {
		return ..TransformResource(source)
	}
}

/// Resets this transformer object to its initial state.
/// @API.Method
Method Reset()
{
	set ..%container = ##class(HS.SDA3.Container).%New()
	set ..%object = $$$NULLOREF, ..%currentReference = $$$NULLOREF
	kill ..%resourceIds, ..%referenceContext, ..%resourceMap
	
	set ..%referenceContext("schema") = ..%schema
}

Method TransformBundle(source As %DynamicObject) As HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3 [ Internal, Private ]
{
	//First build the map of resources so we know which should be skipped, because they're
	//referred to from other resources
	merge referenceContext = ..%referenceContext
	set entryIter = source.entry.%GetIterator()
	while entryIter.%GetNext(, .entry) {
		if (entry.fullUrl '= "") && (entry.fullUrl [ "urn:uuid:") {
			set ..%resourceMap(entry.fullUrl) = entry.resource
			if entry.resource.resourceType = "Patient" {
				set ..%resourceMap("Patient", entry.fullUrl) = entry.resource
			}
		}
		elseif (entry.resource.id '= "") {
			set ..%resourceMap(entry.resource.resourceType, entry.resource.id) = entry.resource
		}
		
		do ##class(HS.FHIRServer.Util.ReferenceVisitor).VisitAll(entry.resource, .referenceContext)
	}
	merge ..%referenceContext = referenceContext
	
	set entryIter = source.entry.%GetIterator()
	while entryIter.%GetNext(, .entry) {
		set ..%currentReference = ""
		if (entry.fullUrl '= "") && (entry.fullUrl [ "urn:uuid:") {
			set ..%currentReference = entry.fullUrl
		}
		elseif (entry.resource.id '= "") {
			set ..%currentReference = entry.resource.resourceType _ "/" _ entry.resource.id
		}
		
		do ..TransformHelper(entry.resource)
	}
	
	set ..%object = ..%container
	
	return $this
}

Method TransformResource(source As %DynamicObject) As HS.FHIR.DTL.Util.API.Transform.FHIRToSDA3 [ Internal, Private ]
{
	set ..%currentReference = ""
	if (source.id '= "") {
		set ..%resourceMap(source.resourceType, source.id) = source
		set ..%currentReference = source.resourceType _ "/" _ source.id
	}
	
	set ..%object = ..TransformHelper(source)
	
	return $this
}

Method TransformHelper(source As %DynamicObject) As HS.SDA3.DataType [ Internal, Private ]
{
	//If a resource is referenced from somewhere else, we need to handle it differently so we don't cause it
	//to be duplicated. Patient and Encounter are excluded because they are independent of any referencing resources
	set referencedFrom = ..ReferencedFrom()
	if '((referencedFrom = "") || (source.resourceType = "Patient") || (source.resourceType = "Encounter") ||
									(((source.resourceType = "Goal") || (source.resourceType = "Condition")) && (referencedFrom [ "CarePlan"))) {
		return ""
	}
	set dtlSource = $classmethod("HS.FHIR.DTL." _ ..%fhirVersion _ ".Model.Resource." _ source.resourceType, "FromJSONHelper", source, ..%fhirVersion)
	set DTL = ..GetDTL(dtlSource)
	if DTL = "" return ""
	
	set aux("transformer") = $this
	set target = $classmethod($classmethod(DTL, "GetTargetType"), "%New")
	$$$ThrowOnError($classmethod(DTL, "Transform", dtlSource, .target, .aux))
	
	if target.%ClassName() = "Patient" {
		if ..%container.IsDefined("Patient") $$$ThrowStatus($$$ERROR($$$GeneralError, "Cannot transform more than one Patient into a single Container"))
		set ..%container.Patient = target
	} else {
		set containerPropName = $zstrip(target.StartXMLList(), "<>", "<>")
		do $method($property(..%container, containerPropName), "Insert", target)
	}
	
	return target
}

/// Specifies the DTL class to use for a given FHIR object. A preferred DTL will be specified in 
/// subtransformations, but will not be specified for top level transformations. Default logic
/// for top level transformations can be viewed in the FHIR annotations, under the Bundle:entry
/// mappings. This can be overriden if different logic is desired.
/// @API.Overrideable
Method GetDTL(source As HS.FHIR.DTL.vR4.Model.Base.Resource, DTL As %Dictionary.Classname = "") As %Dictionary.Classname
{
	set useCustom = (##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetCustomDTLPackage() '= "")
	if DTL '= "" {
		return $select(useCustom: ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetDTLPackageAndClass(DTL),
						1:DTL)
	}
	
	set aux("transformer") = $this
	for {
		set DTL = $order(^HS.XF.Transform(..%fhirVersion, "SDA3", source.resourceType, DTL))
		quit:DTL=""
		
		set condition = ^HS.XF.Transform(..%fhirVersion, "SDA3", source.resourceType, DTL)
		if (condition '= "") && $xecute("(source, aux) return (" _ condition _ ")", source, .aux) {
			return $select(useCustom: ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetDTLPackageAndClass(DTL),
							1:DTL)
		}
		
	}
	return ""
}

/// Returns the resource object given a FHIR reference. This can be overriden if resources need to
/// be transformed one at a time (ie. not as a complete Bundle), but still want fully populated SDA.
/// @API.Overrideable
Method GetResourceFromReference(reference As HS.FHIR.DTL.vR4.Model.Base.Reference) As %DynamicObject [ Private ]
{
	if (reference = "") || (reference.reference = "") {
		return ""
	}
	
	//Search in the current resource if it's a reference to a contained resource
	if reference.reference?1"#".AN {
		set parentReference = {
			"reference": (..%currentReference)
		}
		set currentResource = ..GetResourceFromReference(parentReference)
		if (currentResource = "") || '$isobject(currentResource.contained) {
			return ""
		}
		for i=0:1:currentResource.contained.%Size()-1 {
			set containedResource = currentResource.contained.%Get(i)
			if containedResource.id = $piece(reference.reference, "#", *) {
				return containedResource
			}
		}
		return ""
	}
	else {
		if reference.reference [ "urn:uuid:" {
			return $get(..%resourceMap(reference.reference), "")
		}
		else {
			return $get(..%resourceMap($piece(reference.reference, "/", *-1), $piece(reference.reference, "/", *)), "")
		}
	}
}

Method TransformReference(reference As HS.FHIR.DTL.vR4.Model.Base.Reference, ByRef target As HS.SDA3.DataType, ByRef aux) As HS.SDA3.DataType [ Internal ]
{
	set resource = ..GetResourceFromReference(reference)
	if resource = "" {
		return ..HandleMissingResource(reference)
	}
	
	set previousReference = ..%currentReference
	set ..%currentReference = reference
	
	//Target not being an object means it's mapped to a string, the SDA equivalent of a reference
	if $get(target) = "" {
		if reference.reference [ "urn:uuid" {
			set resource = $get(..%resourceMap(reference.reference))
			if $isobject(resource) {
				return ..GetIdentifier(resource.resourceType, $piece(reference.reference, "urn:uuid:", *))
			}
		}
		else {
			return ..GetIdentifier($piece(reference.reference, "/", *-1), $piece(reference.reference, "/", *))
		}
	}
	
	//Get preferred DTL based on source and target types
	set DTLTarget = $replace(target.%ClassName(1), "HS.SDA3.", "")
	set DTL = ""
	for {
		set DTL = $order(^HS.XF.Transform(..%fhirVersion, "SDA3", resource.resourceType, DTL))
		quit:((DTL = "") || (DTL [ (resource.resourceType _ "." _ DTLTarget)))
	}
	if DTL = "" {
		set ..%currentReference = previousReference
		return ""
	}
	
	set DTL = ..GetDTL(resource, DTL)
	if DTL = "" {
		set ..%currentReference = previousReference
		return target
	}
	
	set dtlResource = $classmethod("HS.FHIR.DTL." _ ..%fhirVersion _ ".Model.Resource." _ resource.resourceType, "FromJSONHelper", resource, ..%fhirVersion)
	$$$ThrowOnError($classmethod(DTL, "Transform", dtlResource, .target, .aux))
	
	set ..%currentReference = previousReference
	return target
}

/// Returns a list of places the current resource is referenced from.
Method ReferencedFrom() As %List [ Internal ]
{
	merge referenceContext = ..%referenceContext
	return ##class(HS.FHIRServer.Util.ReferenceVisitor).GetReferencingIds(..%currentReference, .referenceContext)
}

/// Specifies the Container's SendingFacility property. Default behavior is to get it from the Patient
/// managingOrganization or the first MRN in their list of identifier. Will default to "FHIR" if neither
/// exist.
/// @API.Overrideable
Method GetSendingFacility() As %String [ Private ]
{
	set default = "FHIR"
	
	set patientId = $order(..%resourceMap("Patient", ""))
	if patientId = "" {
		return default
	}
	set patient = ..%resourceMap("Patient", patientId)
	
	set facility = ""
	if patient.managingOrganization '= "" {
		set facility = ..GetResourceFromReference(patient.managingOrganization)
	}
	if '$isobject(facility) {
		for i=0:1:patient.identifier.%Size()-1 {
			if $isobject(patient.identifier.%Get(i).type) && $isobject(patient.identifier.%Get(i).type.coding) && (patient.identifier.%Get(i).type.coding.%Get(0).code = "MR") {
				set facility = ..GetResourceFromReference(patient.identifier.%Get(i).assigner)
				if $isobject(facility) quit
			}
		}
	}
	
	if '$isobject(facility) {
		return default
	}
	
	for i=0:1:facility.identifier.%Size()-1 {
		if facility.identifier.%Get(i).value '= "" {
			return facility.identifier.%Get(i).value
		}
	}
	if facility.name '= "" {
		return facility.name
	}
	
	return default
}

/// Given a resource type and id, will return a unique (to this transformer) identifier
/// that will be used for EncounterNumbers and in some cases ExternalId.
/// @API.Overrideable
Method GetIdentifier(resourceType As %String, id As %String) As %String
{
	if (id = "") {
		if ..%currentReference [ "urn:uuid" {
			set id = $piece(..%currentReference, "urn:uuid:", *)
		}
		else {
			set id = $piece(..%currentReference, "/", *)
		}
	}
	if (id = "") {
		return ""
	}
	
	if $get(..%resourceIds(resourceType, id)) = "" {
		set ..%resourceIds(resourceType, id) = $i(..%resourceIds(resourceType, "count"))
	}
	
	return ..%resourceIds(resourceType, id)
}

/// Allows overrides to behavior when a referenced resource doesn't exist. User may choose
/// to throw an exception, log a warning, or proceed silently.
/// @API.Overrideable
Method HandleMissingResource(reference As HS.FHIR.DTL.vR4.Model.Base.Reference) [ Private ]
{
	return ""
}

/// Getter method for immutable property
Method containerGet() [ Internal ]
{
	//Ensure that the Container has at least a Patient object
	if '..%container.IsDefined("Patient") {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Container is not valid because no Patient object has been created yet"))
	}
	set ..%container.SendingFacility = ..GetSendingFacility()
	
	return ..%container
}

/// Getter method for immutable property
Method objectGet() [ CodeMode = expression, Internal ]
{
..%object
}

/// Getter method for immutable property
Method fhirVersionGet() [ CodeMode = expression, Internal ]
{
..%fhirVersion
}

Method %OnNew(schema As HS.FHIRServer.Schema) As %Status [ Private, ServerOnly = 1 ]
{
	set ..%schema = schema
	set ..%fhirVersion = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).GetXFSchemaFromMetadataSet(schema.FHIRMetadataSetKey)
	
	do ..Reset()
	
	quit $$$OK
}

}
