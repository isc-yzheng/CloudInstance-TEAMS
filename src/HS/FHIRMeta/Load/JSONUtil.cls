Class HS.FHIRMeta.Load.JSONUtil [ Abstract ]
{

/* ---------------------------------------- */
/// Returns an array of all objects in the input %DynamicArray with a specific value
/// <br> @Input array A %DynamicArray containing a set of Json objects
/// <br> @Input field The name of the field whose value is being tested
/// <br> @Input value The value to be matched.  If the contents of 'field' matches 'value', then the object is returned in the
/// result array
/// <br> @Output A multidimensional array that receives the result.  The scalar value is the count of returned objects, Each
/// object is in a subnode numerically indexed starting at 1.
/// <br> @Return The count of objects found
ClassMethod JFind(array As %DynamicArray, field As %String, value As %String, Output result) As %Integer
{
	Set result = 0
	if array '= "" {
		Set iter = array.%GetIterator()
		while iter.%GetNext(.subsc, .obj ) {
			if obj.%Get(field) = value {
				Set result($I(result)) = obj
			}	
		}
	}
	return result
}

/// Returns the index of a value within an array
/// <br> @Input array A %DynamicArray containing a set of values
/// <br> @Input value The value to be matched.  If the contents of 'field' matches 'value', then the index of that value is returned
/// <br> @Input fromIndex The location to start searching.
/// <br> @Return The index of the located object, or -1 if not found
ClassMethod JIndex(array As %DynamicArray, value As %String, fromIndex As %Integer = 0) As %Integer
{
	Set result = -1
	Set count = $Select(array="":0, 1:array.%Size())
	if (fromIndex >= 0) && (fromIndex < count) {
		for ord=fromIndex:1:count-1 {
			if array.%Get(ord) = value {
				return ord
			}	
		}
	}
	return result
}

ClassMethod JFindMulti(array As %DynamicArray, ByRef criteria, Output result) As %Integer
{
	Set result = 0
	if array '= "" {
		Set iter = array.%GetIterator()
		while iter.%GetNext(.subsc, .obj ) {
			Set field = ""
			Set found = 1
			for { 
				Set field = $Order(criteria(field), 1, value)
				Quit:field=""
				
				if obj.%Get(field) '= value {
					set found = 0
					Quit
				}
			}
			if found {
				Set result($I(result)) = obj
			}
		}
	}
	return result
}

/// Get an array of all extensions in the array with the desired URL.
/// <br> @Input array A %DynamicArray containing a set of Extension objects
/// <br> @Input ur; The name of the field whose value is being tested
/// <br> @Input value The value to be matched.  If the contents of 'field' matches 'value', then the object is returned in the
/// result array
/// <br> @Output A multidimensional array that receives the result.  The scalar value is the count of returned objects, Each
/// object is in a subnode numerically indexed starting at 1.
/// <br> @Return The count of objects found
ClassMethod JFindExtensions(object As %DynamicObject, url As %String, Output result)
{
	Set result = 0
	if $IsObject(object) {
		return ..JFind(object.extension, "url", url, .result)
	}
	return 0
}

/// Returns an array of the value of a specified field from each element of a %DynamicArray containing %DynamicObjects
/// <br> @Input array A %DynamicArray containing a set of Json objects
/// <br> @Input valueField The name of the field whose value is being returned
/// <br> @Output A multidimensional array that receives the result.  The scalar value is the count of returned objects, Each
/// value is in a subnode numerically indexed starting at 1.
/// <br> @Return The count of values found
ClassMethod JGetValues(array As %DynamicArray, valueField As %String, Output result) As %Integer
{
	return ..JGetValuesWhere(array, "", "", valueField, .result)
}

/// Returns an array of all objects in the input %DynamicArray with a specific value
/// <br> @Input array A %DynamicArray containing a set of Json objects
/// <br> @Input whereField The name of the field whose value is being tested
/// <br> @Input whereValue The value to be matched.  If the contents of 'field' matches 'value', then the value of 'valueField' is returned in the
/// result array
/// <br> @Input valueField The name of the field whose value is being returned
/// <br> @Output A multidimensional array that receives the result.  The scalar value is the count of returned objects, Each
/// object is in a subnode numerically indexed starting at 1.
/// <br> @Return The count of objects found
ClassMethod JGetValuesWhere(array As %DynamicArray, whereField As %String, whereValue As %String, valueField As %String, Output result) As %Integer
{
	Set result = 0
	Set noTest = (whereField = "")
	if $IsObject(array) {
		Set iter = array.%GetIterator()
		while iter.%GetNext(.subsc, .obj ) {
			if (noTest) || (obj.%Get(whereField) = whereValue) {
				Set val = obj.%Get(valueField)
				if val '= "" {
					Set result($I(result)) = val
				}
			}	
		}
	}
	return result
}

ClassMethod ArrayToList(ByRef array) As %List
{
	Set list = ""
	for ord=1:1:$Get(array,0) {
		Set $List(list, *+1) = array(ord)
	}
	return list
}

ClassMethod JsonArrayToArray(jarray As %DynamicArray, Output array)
{
	Set array = 0
	if $IsObject(jarray) {
		Set array = jarray.%Size()
		for ord=1:1:array {
			Set array(ord) = jarray.%Get(ord-1)
		}
	}
}

}
