Include Ensemble

Class HS.FHIR.DTL.Util.HC.Transform
{

/// Loop through every entry in a Bundle after it has been transformed from
/// SDA3 and ensure all references are added and that each resource is given
/// an id.
/// bundle - The bundle object to be processed
/// callbackObject - instance of the callback class that determines certain
/// behavior like how resource ids should be assigned.
ClassMethod ProcessBundle(ByRef bundle As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3) As %Status
{
	set tSC = $$$OK
	try {
		set i = 1
		for {
			//Condition is analyzed here to prevent for loop optimization, since
			//the size of bundle.entry grows throughout the loop.
			if i > bundle.entry.Count() quit
			
			set resource = bundle.entry.GetAt(i).resource
			set entry = bundle.entry.GetAt(i)
			set tSC = ..ProcessEntry(.resource, .entry, callbackObject)
			quit:$$$ISERR(tSC)
			
			set tSC = ..LinkResources(.resource, .bundle, callbackObject)
			quit:$$$ISERR(tSC)
			
			set i = i + 1
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Ensure the resource has an id, and add the fullUrl value for the resource.
/// resource - The resource to be processed
/// entry - the Bundle entry containing the resource to be processed.
/// callbackObject - instance of the callback class that determines certain
/// behavior like how resource ids should be assigned.
ClassMethod ProcessEntry(ByRef resource As HS.FHIR.DTL.vSTU3.Model.Base.Resource, ByRef entry As HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3) As %Status
{
	set tSC = $$$OK
	try {
		if resource.id = "" {
			set resource.id = callbackObject.AssignResourceId(resource.resourceType)
		}
		
		if resource.id '= "" {
			set prefix = callbackObject.GetURLPrefix()
			
			if prefix '= "" {
				set entry.fullUrl = prefix _ "/" _ resource.resourceType _ "/" _ resource.id
			}
			else {
				set entry.fullUrl = resource.resourceType _ "/" _ resource.id
			}	
			set entry.request = ##class(HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry.request).%New()
			set entry.request.method = "PUT"
			set entry.request.url = resource.resourceType _ "/" _ resource.id
		}
		
		set entry.resource = resource
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Extract additional resources created when transforming between SDA3 and STU3 and 
/// link them using references. These additional resources can be in any object within the
/// resource, stored in the newResource property, so each object will need to be inspected.
/// Once they are found, they will be assigned a resource id (if they aren't duplicatesand a reference will be created
/// to the first resource. Then the newly created resource will be added to the end of the Bundle.
/// resource - The current resource that's being searched
/// bundle - The bundle that will have newly created resources added to the end.
/// callbackObject - instance of the callback class that determines certain
/// behavior like how resource ids should be assigned.
ClassMethod LinkResources(ByRef resource As HS.FHIR.DTL.vSTU3.Model.Base.Resource, ByRef bundle As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, callbackObject As HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3) As %Status
{
	set tSC = $$$OK
	try {
		set referencedResources = resource.newResource
		for j=1:1:referencedResources.Count() {
			set newResource = referencedResources.GetAt(j)
			set isDuplicate = 0
			
			if newResource.id = "" {
				set isDuplicate = callbackObject.IsDuplicate(newResource, .id)
				
				if id = "" {
					set id = callbackObject.AssignResourceId(newResource.resourceType)
					quit:$$$ISERR(tSC)
				}
				set newResource.id = id
			}
			
			set reference = ##class(HS.FHIR.DTL.vSTU3.Model.Base.Reference).%New()
			set reference.reference = newResource.resourceType _ "/" _ newResource.id
			
			set referenceLocation = $lg(resource.newResourceReference, j)
			
			set tSC = ##class(Ens.DataTransform).instantiateProps(resource, "target." _ $replace($replace(referenceLocation, "[n]", ""), "[1]", ""))
			quit:$$$ISERR(tSC)
			
			if (referenceLocation [ "[n]") || (referenceLocation [ "[1]") {
				set listName = $piece(referenceLocation, "[", 1)
				set referenceFieldName = $piece(referenceLocation, "].", *)
				
				set list = $property(resource, listName)
				
				set propColl = $$$comMemberKeyGet(list.ElementType, $$$cCLASSproperty, referenceFieldName, $$$cPROPcollection)
				if referenceLocation [ "[n]" {
					set listObject = $classmethod(list.ElementType, "%New")
				}
				else {
					set index = 0
					for k=1:1:j {
						if $listget(resource.newResourceReference, k) = referenceLocation {
							set index = index + 1
						}
					}
					//Keep incrementing if the reference field is already defined, until we find the
					//one that isn't defined.
					for {
						if propColl = "list" {
							if $method($property(list.GetAt(index), referenceFieldName), "GetAt", 1) '= "" {
								set index = index + 1
							}
							else {
								quit
							}
						}
						else {
							if $property(list.GetAt(index), referenceFieldName) '= "" {
								set index = index + 1
							}
							else {
								quit
							}
						}
					}
					set listObject = list.GetAt(index)
				}
				
				if propColl = "list" {
					do $method($property(listObject, referenceFieldName), "Insert", reference)
				}
				else {
					set $property(listObject, referenceFieldName) = reference
				}
				
				if referenceLocation [ "[n]" {
					do list.Insert(listObject)
				}
			}
			else {
				set object = resource
				set fieldName = $piece(referenceLocation, ".", 1)
				set referenceLocation = $piece(referenceLocation, ".", 2, *)
				while referenceLocation '= "" {
					set object = $property(object, fieldName)
					set fieldName = $piece(referenceLocation, ".", 1)
					set referenceLocation = $piece(referenceLocation, ".", 2, *)
				}
				set propColl = $$$comMemberKeyGet($classname(object), $$$cCLASSproperty, fieldName, $$$cPROPcollection)
				if propColl = "list" {
					do $method($property(object, fieldName), "Insert", reference)
				}
				else {
					set $property(object, fieldName) = reference
				}
			}
			
			set newEntry = ##class(HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry).%New()
			set tSC = ..ProcessEntry(.newResource, .newEntry, callbackObject)
			quit:$$$ISERR(tSC)
			
			if 'isDuplicate {
				do bundle.entry.Insert(newEntry)
			}
		}
		
		set propName = 0
		set className = $classname(resource)
		for {
			//Get list of properties for the given class
			set propName = $$$comMemberNext(className, $$$cCLASSproperty, propName)
			if propName="" quit
			if (propName [ "%") || (propName = "primitiveExtension") || (propName = "newResource") || (propName = "newResourceReference") continue
			
			if $isobject($property(resource, propName)) {
				if $property(resource, propName).%Extends("%Collection.AbstractIterator") {
					for i=1:1:$property(resource, propName).Count() {
						if $isobject($property(resource, propName).GetAt(i)) {
							set temp = $property(resource, propName).GetAt(i)
							set tSC = ..LinkResources(.temp, .bundle, callbackObject)
							quit:$$$ISERR(tSC)
							do $method($property(resource, propName), "SetAt", temp, i)
						}
					}
				}
				else {
					set temp = $property(resource, propName)
					set tSC = ..LinkResources(.temp, .bundle, callbackObject)
					quit:$$$ISERR(tSC)
					set $property(resource, propName) = temp
				}
			}
			quit:$$$ISERR(tSC)
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Pre-process the bundle so the STU3 to SDA3 transform knows which resources to skip (to prevent duplicate
/// streamlets) and index the Bundle so it can be quickly searched to find referenced resources).
/// bundle - the Bundle to preprocess.
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object. Also will contain the skip list and the bundle index.
ClassMethod PreProcess(bundle As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, Output aux) As %Status
{
	set tSC = $$$OK
	try {
		set aux("skipList") = ""
		set aux("bundleIndex") = ""
		for i=1:1:bundle.entry.Count() {
			set resource = bundle.entry.GetAt(i).resource
			set referencePath = ""
			set tSC = ..IndexResource(resource, i, .aux)
			quit:$$$ISERR(tSC)
			
			for {
				set referencePath = $order(^HS.XF.ReferenceField("HC", "vSTU3", "SDA3", resource.resourceType, referencePath))
				if referencePath = "" quit
				set tSC = ..BuildSkipList(resource, referencePath, .aux)
				quit:$$$ISERR(tSC)
			}
			quit:$$$ISERR(tSC)
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Store the resource and it's location in the bundle within the 'aux' parameter so that a lookup can be done
/// in O(1) time instead of O(n) time. This is crucial because every time a reference is encountered, the resource
/// that is being referenced will need to be fetched.
/// resource - the resource to be indexed
/// index - the index in the bundle entry list
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object.
ClassMethod IndexResource(resource As HS.FHIR.DTL.vSTU3.Model.Base.Resource, index As %Integer, ByRef aux) As %Status
{
	set tSC = $$$OK
	try {
		//Cannot have more than one Patient in a Bundle
		if resource.resourceType = "Patient" {
			if $data(aux("bundleIndex", "Patient")) {
				set tSC = $$$ERROR($$$GeneralError, "Cannot have multiple Patient resources in a Bundle")
				quit
			}
			set aux("bundleIndex", "Patient") = resource
		}
		
		if resource.id = "" {
			$$$LOGALERT("'" _ resource.resourceType _ "' is missing an id. It cannot be linked with any other resources, and if its transformation target isn't a property of HS.SDA3.Container, this resource will be dropped.")
		}
		else {
			set aux("bundleIndex", resource.id, resource.resourceType) = resource
			set aux("bundleIndex", "index", resource.id, resource.resourceType) = index
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// For every path in ^HS.XF.ReferenceField, which contains all paths from reference elements to
/// SDA3 objects, check to see if the current resource has a value in that location. If it does,
/// the referenced resource can be added to the skip list, since it will be transformed when
/// transforming the current resource, and we want to prevent duplicates from being created.
/// object - Object to be searched
/// path - Element path where a reference could be stored, eg. "Patient:managingOrganization" or "Encounter:participant[n].actor"
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object.
ClassMethod BuildSkipList(object As %RegisteredObject, path As %String, ByRef aux) As %Status
{
	set tSC = $$$OK
	try {
		set elementName = $piece(path, ".", 1)
		set path = $piece(path, ".", 2, *)
		set object = $property(object, elementName)
		quit:'$isobject(object)
		
		if path = "" {
			if object.%Extends("%Collection.AbstractIterator") {
				for i=1:1:object.Count() {
					if object.GetAt(i).reference '= "" {
						set referenceValue = object.GetAt(i).reference
						if referenceValue [ "/" {
							set resource = $piece(referenceValue, "/", *-1)
							set id = $piece(referenceValue, "/", *)
						}
						else {
							set id = $piece(referenceValue, "urn:uuid:" , *)
							set resource = ""
							if $data(aux("bundleIndex", id)) {
								set resource = $order(aux("bundleIndex", id, ""))
							}
						}
						if (resource = "Patient") || (resource = "Encounter") continue
						if ((resource '= "") && (id '= "")) {
							set aux("skipList", resource, id) = ""
						}
					}
				}
			}
			else {
				if object.reference '= "" {
					set referenceValue = object.reference
					if referenceValue [ "/" {
						set resource = $piece(referenceValue, "/", *-1)
						set id = $piece(referenceValue, "/", *)
					}
					else {
						set id = $piece(referenceValue, "urn:uuid:" , *)
						set resource = ""
						if $data(aux("bundleIndex", id)) {
							set resource = $order(aux("bundleIndex", id, ""))
						}
					}
					if (resource = "Patient") || (resource = "Encounter") quit
					if ((resource '= "") && (id '= "")) {
						set aux("skipList", resource, id) = ""
					}
				}
			}
		}
		else {
			if object.%Extends("%Collection.AbstractIterator") {
				for i=1:1:object.Count() {
					set tSC = ..BuildSkipList(object.GetAt(i), path, .aux)
					quit:$$$ISERR(tSC)
				}
			}
			else {
				set tSC = ..BuildSkipList(object, path, .aux)
				quit:$$$ISERR(tSC)
			}
			
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Determines whether or not a resource should be skipped when transforming a Bundle to a Container. Will
/// look in the skip list generated before beginning the transformation.
/// resource - Resource in question
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object. Also contains the skip list.
ClassMethod ShouldSkip(ByRef resource As HS.FHIR.DTL.vSTU3.Model.Base.Resource, ByRef aux) As %Boolean
{
	if resource.id '= "" {
		quit ($data(aux("skipList", resource.resourceType, resource.id)) || $data(aux("skipList", resource.id)))
	}
	else {
		quit 0
	}
}

}
