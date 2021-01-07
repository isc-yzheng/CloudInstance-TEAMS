Class HS.FHIRServer.Util.ReferenceVisitor Extends %RegisteredObject
{

/// @API
/// VisitAll traverses all properties of type Reference within a Resource.  It builds a set of all reference values.
/// Optionally, the caller may specify a method to be called when each reference is visited allowing the caller to perform
/// custom processing on that reference.
/// 
/// <br<context("schema"): Schema object for the input object
/// <br<context("callbackInstance"): [optional] Instance object implementing the callbackMethod (used when callbackMethod is a Method)
/// <br<context("callbackClass"): [optional[ Classname (used when callbackMethod is a ClassMethod)
/// <br<context("callbackMethod"): Method name to call with each reference (must be accompanied with either "callbackClass" or "callbackInstance")
/// <br<context("_va"): Internal Bookkeeping for the VisitAll method
/// <br<All other keys are available to the caller (and callback) to maintain it required context 
///    callback signature is: <br<callback(context, pRefObj as %DynamicObject, pRefValue as %String, context)
ClassMethod VisitAll(pRsrcObj As %DynamicObject, ByRef context)
{
	Set prevReferencingId = $Get(context("_va", "curId"))
	Set prevShared = $Get(context("_va", "curIdIsShared"))
	Set context("_va", "curId") = pRsrcObj.resourceType _ "/" _ pRsrcObj.id
	Set context("_va", "curIdIsShared") = context("schema").IsSharedResourceType(pRsrcObj.resourceType)
	Set pathsList = context("schema").GetReferencePaths(pRsrcObj.resourceType)
	Set pathsCount = $LL(pathsList)
	
	set ptr = 0
	while $ListNext(pathsList, ptr, pathList) {
		// Walk the property path to obtain the reference value
		do ..AddReferencesFromPath(pRsrcObj, pathList, 1, .context)
	}
	// Now add any references from extensions
	Set extnList = pRsrcObj.extension
	if extnList'="" {
		Do ..AddReferencesFromExtension(extnList, .context)
	}
	Set context("_va", "curId") = prevReferencingId
	Set context("_va", "curIdIsShared") = prevShared
}

ClassMethod AddReferencesFromPath(pObj As %DynamicObject, pathList As %String, index As %Integer, ByRef context) [ Private ]
{
	Set pathListLength = $LL(pathList)
	Set iprop = index
	Set obj = pObj
	
	while iprop < pathListLength {
		Set propName = $LG(pathList, iprop)
		Set isArray = $LG(pathList, iprop+1)
		Set obj = obj.%Get(propName)
		// Done if there's no object along the path
		if obj="" Return
		
		//Object that has a property with the same name as itself
		//indicates recursion. Walk down as far as the recursive
		//property is populated, checking for references
		if obj.%Get(propName) '= "" {
			Do ..AddReferencesFromPath(obj.%Get(propName), pathList, iprop, .context)
		}
		
		Set iprop = iprop + 2
		if isArray {
			Set amax = obj.%Size() - 1
			for ord=0:1:amax {
				// RECURSE for each array element using the remaining path elements
				Set aobj = obj.%Get(ord)
				Continue:aobj=""
				Do ..AddReferencesFromPath( aobj, pathList, iprop, .context )
			}
			return
		} 
	}
	// If we get here, 'obj' is a Reference object.
	// Make sure the reference property is populated - a reference object
	// could have the identifier property populated instead of reference.
	If obj.reference '= "" {
		Do ..AddReferenceObj(obj, .context)
	}
}

ClassMethod AddReferencesFromExtension(pExtnList As %DynamicArray, ByRef context) [ Private ]
{
	#dim iter as %Iterator.Array = pExtnList.%GetIterator()
	while iter.%GetNext(.subsc, .extn) {
		Set obj = extn.valueReference
		// Make sure the reference property is populated - a reference object
		// could have the identifier property populated instead of reference.
		if (obj '= "") && (obj.reference '= "") {
			Do ..AddReferenceObj(obj, .context)
		}
		if extn.extension'="" {
			Do ..AddReferencesFromExtension(extn.extension, .context)	
		}
	}
}

ClassMethod AddReferenceObj(obj As %DynamicObject, ByRef context)
{
	Do ..AddBackReference(.context, obj.reference, context("_va", "curId"), context("_va", "curIdIsShared"))
	if $D(context("callbackInstance")) = 1 {
		Do $Method(context("callbackInstance"), context("callbackMethod"), .context, obj)
	} elseif $D(context("callbackClass")) = 1 {
		Do $ClassMethod(context("callbackClass"), context("callbackMethod"), .context, obj)
	}
}

ClassMethod AddBackReference(ByRef context, toId As %String, fromId As %String, fromIsShared As %Boolean)
{
	Set context("_va", "ref", toId, "from", fromId) = fromIsShared
}

ClassMethod adjustCrossReference(schema As HS.FHIRServer.Schema, ByRef visitContext)
{
	set toId = ""
	for {
		// Loop through each Resource that has BackReferences
		Set toId = $Order(visitContext("_va", "ref", toId))
		Quit:toId=""
		// Referenced Resource
		if '$D( visitContext("_va", "adj", toId)) {
			if schema.IsSharedResourceType($Piece(toId, "/"))
			{
				Do ..adjustBackRefs(schema, .visitContext, toId)
			} else {
				// We only care about references to shared resources
				kill visitContext("_va", "ref", toId)
			}
		}
	}
	//zw visitContext("_va", "ref")
}

/// This method is called for a shared resource.  It builds the list of non-shared resources that
/// refer to it.  If it finds a shared resource the refers to it, it recurses, replacing the shared-resource
/// reference with the set of non-shared resources that refer to referring shared resource
ClassMethod adjustBackRefs(schema As HS.FHIRServer.Schema, ByRef visitContext, toId As %String) [ Private ]
{
	/// <br<context("_va", "adj", <Id>) = "" (indicates that the Id has been adjusted 
	/// <br<context("_va", "ref", <toId>, "from", <fromId>) = # of refs TO an Id Accumulated a set of all backward references 
	Set visitContext("_va", "adj", toId) = ""
	set fromId = ""
	for {
		// Loop through each Resource backreference to this resource.  Capture whether the
		// referring resource is shared
		Set fromId = $Order(visitContext("_va", "ref", toId, "from", fromId), 1, isShared)
		Quit:fromId=""
		// Referenced Resource
		if isShared {
			if '$D(visitContext("_va", "adj", fromId)) {
				// The referencing resource is shared.  Recurse to resolve its referees to unshared, then copy
				// its references to us as well
				Do ..adjustBackRefs(schema, .visitContext, fromId)
			}
			// Whatever non-shared resources reference our referencer, reference us as well
			kill visitContext("_va", "ref", toId, "from", fromId)
			merge visitContext("_va", "ref", toId, "from") = visitContext("_va", "ref", fromId, "from")
			//w "Merge into ",toId,":",!
			//zw visitContext("_va", "ref", fromId, "from")
		}
	}
}

/// Returns a %List of all resources referenced by the specified resource Id as determined by
/// the processing of "VisitAll"
ClassMethod GetReferencingIds(referencedId As %String, ByRef context) As %List
{
	Set list = ""
	Set target = ""
	for {
		Set target = $Order(context("_va", "ref", referencedId, "from", target))
		Quit:target=""
		Set $List(list, *+1) = target
	}
	return list
}

}
