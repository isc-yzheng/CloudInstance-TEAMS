Class HS.FHIR.DTL.Util.JSON.Adapter [ Abstract ]
{

/// A different entrance to FromJSON that starts with a directory provided in <var>dirName</var>.
/// Every file with the .json extension is consumed, the json scraped, and converted into an
/// object using FromJSON. The resulting objects are stored in <var>list</var>.
ClassMethod FromJSONDir(dirName As %String, Output list As %ListOfObjects, fhirVersion As %String(VALUELIST=",vSTU3,vR4")) As %Status
{
	set tSC = $$$OK
	try {
		set startTimer = $zts
		set list = ##class(%ListOfObjects).%New()
		
		set fileName = $zsearch(##class(%Library.File).NormalizeFilename(dirName _ "\*.json", dirName))
		if (fileName = "") {
			// "Directory contains no .json files"
		}
		while fileName '= "" {
			set obj = ..FromJSONFile(fileName, fhirVersion)
			
			set tSC = list.Insert(obj)
			$$$ThrowOnError(tSC)
			
			set fileName = $zsearch("")
		}
		set endTimer = $zts
		
		set runTime = (($piece(endTimer,",",2) - $piece(startTimer,",",2))*1000)
		//w "Runtime: " _ runTime _ " ms",!
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// A different entrance to FromJSON that starts with a full file name provided in <var>fileName</var>. JSON from
/// that file is scraped and used as the parameter in FromJSON
ClassMethod FromJSONFile(fileName As %String, fhirVersion As %String(VALUELIST=",vSTU3,vR4")) As %RegisteredObject
{
	set startTimer = $zts
	
	set obj = ""
	
	Set tFileName = ##class(%Library.File).NormalizeFilename(fileName)
	set tFileStream = ##class(%Stream.FileCharacter).%New()
	set tSC = tFileStream.LinkToFile(tFileName)
	
	set json = ##class(%Stream.TmpCharacter).%New()
	for {
		set line = tFileStream.ReadLine()
		if line = "" quit
		set tSC = json.WriteLine(line)
	}
	if json = "" {
		set tSC = $$$ERROR($$$GeneralError, "File " _ fileName _ " is empty or missing")
	}
	$$$ThrowOnError(tSC)
	
	set obj = ..FromJSON(json, fhirVersion)
	
	set endTimer = $zts
	
	set runTime = (($piece(endTimer,",",2) - $piece(startTimer,",",2))*1000)
	//w "Runtime: " _ runTime _ " ms",!
	quit obj
}

/// Deserialize a json stream into an instance of a class in HS.FHIR.DTL.<schema>.Model. This classmethod
/// should be called on the object in question whenever the type is known. Otherwise, if the object isn't a
/// resource, the deserialization will fail. eg. set obj = ##class(HS.FHIR.DTL.vSTU3.Model.Resource.Bundle).FromJSON(jsonStream)
ClassMethod FromJSON(json As %Stream.Object, fhirVersion As %String(VALUELIST=",vSTU3,vR4")) As %RegisteredObject
{
	if 'json.%Extends("%Stream.Object") {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "JSON must be stored in a class that extends %Stream.Object"))
	}
		
	Set dynamicObject = ##class(%Library.DynamicAbstractObject).%FromJSON(json)
	if '$isobject(dynamicObject) {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "Dynamic object could not be created from the JSON stream"))
	}
	
	new %propertyInfo
	quit ..FromJSONHelper(dynamicObject, fhirVersion)
}

/// Helper method for deserializing a json stream into an object.
ClassMethod FromJSONHelper(dynamicObject As %DynamicObject, fhirVersion As %String(VALUELIST=",vSTU3,vR4")) As %RegisteredObject
{
	set className =  $classname($this)
	//Extract the classname from the class the method was called on. Also search for a "resourceType" element
	//that can further narrow down the classname (eg. from Base.Resource to AllergyIntolerance). But this should
	//only be done when the caller is Base.Resource or the abstract class JSON.Adapter to prevent it being used
	//when the resourceType element isn't on a resource (eg. ExplanationOfBenefit.payee.resourceType).
	if (dynamicObject.%Get("resourceType") '= "") && ((className = ("HS.FHIR.DTL." _ fhirVersion _ ".Model.Base.Resource")) || (className = "HS.FHIR.DTL.Util.JSON.Adapter")) {
		set className = "HS.FHIR.DTL." _ fhirVersion _ ".Model.Resource." _ dynamicObject.%Get("resourceType")
	}
	if className = "HS.FHIR.DTL.Util.JSON.Adapter" {
		if '##class(%Dictionary.ClassDefinition).%ExistsId(className) {
			$$$ThrowOnError($$$ERROR($$$GeneralError, "FromJSON must be called on the class the resulting object will be an instance of or on a resource with 'resourceType' set to a valid resource"))
		}
	}
	//Create a new instance of the object
	set obj = $classmethod(className, "%New")
	
	set iter = dynamicObject.%GetIterator()
	while iter.%GetNext(.propertyName, .dynValue) {
		if (propertyName = "resourceType") || (propertyName = "fhir_comments") continue
		
		if propertyName [ "_" {
			set propertyType = "HS.FHIR.DTL." _ fhirVersion _ ".Model.Base.Extension"
			set propertyCollection = "list"
		}
		elseif '$data(%propertyInfo(className, propertyName, "Type")) {
			set propertyType = $$$comMemberKeyGet(className, $$$cCLASSproperty, propertyName, $$$cPROPtype)
			set propertyCollection = $$$comMemberKeyGet(className, $$$cCLASSproperty, propertyName, $$$cPROPcollection)
			set %propertyInfo(className, propertyName, "Type") = propertyType
			set %propertyInfo(className, propertyName, "Collection") = propertyCollection
		}
		else {
			set propertyType = %propertyInfo(className, propertyName, "Type")
			set propertyCollection = %propertyInfo(className, propertyName, "Collection")
		}
		
		if (propertyType = "") && (propertyName '[ "_") {
			if $isvalidnum(propertyName) {
    			$$$ThrowOnError($$$ERROR($$$GeneralError, className _ " has cardinality of one, but recieved a list"))
			}
			else {
    			$$$ThrowOnError($$$ERROR($$$GeneralError, "'" _ propertyName _ "' doesn't exist in " _ className))
			}
		}
		
		if propertyName [ "_" {
			// Is a primitive extension. Handles extension for singleton and list primitives.
			
			set tPrimitivePropertyName = $extract(propertyName, 2, *)
			
  			if '$data(%propertyInfo(className, tPrimitivePropertyName, "Type")) {
				set %propertyInfo(className, tPrimitivePropertyName, "Type") = $$$comMemberKeyGet(className, $$$cCLASSproperty, tPrimitivePropertyName, $$$cPROPtype)
				set %propertyInfo(className, tPrimitivePropertyName, "Collection") = $$$comMemberKeyGet(className, $$$cCLASSproperty, tPrimitivePropertyName, $$$cPROPcollection)
			}
			
			if (%propertyInfo(className, tPrimitivePropertyName, "Collection") = "list") {
	    		set tIteratorCollection = dynValue.%GetIterator()
	    		
	    		while tIteratorCollection.%GetNext(.tIndex, .dynExtension) {
					
					// Handle null values in JSON, which may occur in collections
					continue:'$IsObject(dynExtension)
					
					// If extension has id only then do not process it.
					set extension = dynExtension.extension
					if extension = "" Continue
					
					set tPositionInCollection = tIndex+1
					do ..PrimitiveExtensionHandler(extension, .obj, tPrimitivePropertyName, tPositionInCollection, fhirVersion)
				}
			} else {	    		
				// If extension has id only then do not process it.
				set extension = dynValue.extension
				if extension = "" Continue
		    	
				do ..PrimitiveExtensionHandler(extension, .obj, tPrimitivePropertyName, 0, fhirVersion)
	    	}
    	}
		//Is a list
		elseif (propertyCollection = "list") {
			//Object
			if propertyType '[ "%" {
				set list = ##class(%ListOfObjects).%New()
			}
			//Primitive
			else {
				set list = ##class(%ListOfDataTypes).%New()
			}
			
			set arrIter = dynValue.%GetIterator()
			while arrIter.%GetNext(.index, .dynArrValue) {
				//Object
				if dynValue.%GetTypeOf(index) [ "object" {
					do list.Insert($classmethod(propertyType, "FromJSONHelper", dynArrValue, fhirVersion))
				}
				//Primitive
				else {
					if $isobject(dynArrValue) {
						$$$ThrowOnError($$$ERROR($$$GeneralError, "The '" _ propertyName _ "' element in the '" _ obj.%ClassName(0) _ "' object expected a list of primitives, but got at least one object"))
					} 
					do list.Insert(dynArrValue)
				}
			}		
			set $property(obj, propertyName) = list
		}
		//Is a single
		else {
			//Object
			if (propertyCollection = "") && (propertyType '[ "%") {
				//Recursive call to the Object method uses the schema property type as its
				//class name. A new object is created using that class name and populated.
				set $property(obj, propertyName) = $classmethod(propertyType, "FromJSONHelper", dynValue, fhirVersion)
			}
			//Primitive
			else {
				if $isobject(dynValue) {
					$$$ThrowOnError($$$ERROR($$$GeneralError, "The '" _ propertyName _ "' element in the '" _ obj.%ClassName(0) _ "' object expected a primitive, but got an object"))
				} 
				set $property(obj, propertyName) = $zconvert(dynValue, "I", "JSON")
			}
		}
	}
	quit obj
}

ClassMethod PrimitiveExtensionHandler(pFhirExtensionDynObj As %Library.DynamicObject, pFhirObj As %RegisteredObject, pPrimitivePropertyName As %String, pPositionInCollection As %Integer, pFhirVersion As %String)
{
	#dim tExtensionObject as HS.FHIR.DTL.vR4.Model.Base.Extension
	#dim tIteratorExtension as %Iterator.Array
	#dim tDynamicObject as %Library.DynamicObject
	#dim tIndex,tFHIRPrimitiveValue,tPrimitiveExtensionPosition
	
 	set tIteratorExtension = pFhirExtensionDynObj.%GetIterator()
 	
 	// there might be several extensions for one primitive value, for example:
 	//  the first address.line supports multiple extensions such as street and house number
 	while tIteratorExtension.%GetNext(.tIndex, .tDynamicObject) {
		
		//  added pFhirVersion parameter and vR4 model
		set tExtensionObject = $classmethod("HS.FHIR.DTL."_pFhirVersion_".Model.Base.Extension", "FromJSONHelper", tDynamicObject, pFhirVersion)
		
		// Insert the Extension in the primitiveExtension property of the Fhir Object
		do pFhirObj.primitiveExtension.Insert(tExtensionObject)
		set tPrimitiveExtensionPosition = pFhirObj.primitiveExtension.Count()
		
		// Retrieve the current value of the primitive property in preparation of creating the $list
		if (pPositionInCollection) {
			// tIndex + 1 because %GetNext() is zero-based. Get the value of the correct element in the collection.
			set tFHIRPrimitiveValue = $method($property(pFhirObj,pPrimitivePropertyName), "GetAt", pPositionInCollection)
		} else {
			set tFHIRPrimitiveValue = $property(pFhirObj, pPrimitivePropertyName)
		}
		
		// Add the position of the new Extension object in the primitiveProperty to the original value, creating the $list format if needed.
		if tFHIRPrimitiveValue '= "" {
			if '$listvalid(tFHIRPrimitiveValue) {
				set tFHIRPrimitiveValue = $listbuild(tFHIRPrimitiveValue, tPrimitiveExtensionPosition)
			} else {
				set tFHIRPrimitiveValue = tFHIRPrimitiveValue_$listbuild(tPrimitiveExtensionPosition)
			}
			
		} else {
			set tFHIRPrimitiveValue = $listbuild( , tPrimitiveExtensionPosition)
		}
		
		// Assign the $list value back to the original primitiveProperty
		if (pPositionInCollection) {
			// tIndex + 1 because %GetNext() is zero-based. Set the value of the correct element in the collection.
			do $method($property(pFhirObj,pPrimitivePropertyName), "SetAt", tFHIRPrimitiveValue, pPositionInCollection)
		} else {
			set $property(pFhirObj, pPrimitivePropertyName) = tFHIRPrimitiveValue
		}
		
	} // while
	
	return
}

/// Serializes any FHIR resource that extends this class into a json Stream.
Method ToJSON() As %Stream.Object [ CodeMode = objectgenerator ]
{
	if (%class.Abstract) {
		quit $$$OK
	}
	do %code.WriteLine("    set outputStream = ##class(%Stream.TmpCharacter).%New()")
	do %code.WriteLine("    set jsonString = """"")
	do %code.WriteLine("    set tSC = ..ToJSONHelper(.outputStream, .jsonString, """", 0)")
	do %code.WriteLine("    $$$ThrowOnError(tSC)")
	do %code.WriteLine("	do outputStream.Write(jsonString)")
	do %code.WriteLine("	quit outputStream")
	
	quit $$$OK
}

/// Helper method for serialization. Should not be called externally.
Method ToJSONHelper(ByRef outputStream As %Stream.Object, Output jsonString As %String, indents As %String, inList) As %Status [ CodeMode = objectgenerator ]
{
	set tSC = $$$OK
	try {
		if (%class.Abstract) {
			quit
		}
	
		do %code.WriteLine("	set tSC = $$$OK")
		do %code.WriteLine("	try {")
		
		do %code.WriteLine("	set comma = 0")
		do %code.WriteLine("	set hasPrimitiveExtension = 0")
		do %code.WriteLine("	set newLine = $char(13, 10)")
		do %code.WriteLine("	set tabChar = ""  """)
		do %code.WriteLine("	if inList {")
		do %code.WriteLine("		set addString = indents do writeStr")
		do %code.WriteLine("	}")
		do %code.WriteLine("	set addString = ""{"" _ $char(13, 10) do writeStr")
		do %code.WriteLine("	set indents = indents _ tabChar")
		do %code.WriteLine("	")
		
		if (%compiledclass.Super [ "Base.DomainResource") || (%compiledclass.Super [ "Base.Resource") {
			do %code.WriteLine("	set addString = indents _ """"""resourceType"""": """""" _ $zconvert(..resourceType, ""O"", ""JSON"") _ """""""" do writeStr")
			do %code.WriteLine("	set comma = 1")
		}
		
		set propertyName = 0
		for i=1:1:%compiledclass.Properties.Count(){
			//Get list of properties for the given class
			set propertyName = %compiledclass.Properties.GetAt(i).Name
			set propertyType = %compiledclass.Properties.GetAt(i).Type
			set propertyCollection = %compiledclass.Properties.GetAt(i).Collection
			if (propertyName [ "%") || (propertyName = "primitiveExtension") || (propertyName = "newResource") || (propertyName = "newResourceReference") || (propertyName = "resourceType") continue
			
			//Is a list
			if propertyCollection = "list" {
				do %code.WriteLine("	if .." _ propertyName _ ".Count()>0 {")
				do %code.WriteLine("		if comma {")
				do %code.WriteLine("			set addString = "","" _ $char(13, 10) do writeStr")
				do %code.WriteLine("		}")
				do %code.WriteLine("		set comma = 1")
				do %code.WriteLine("		set addString = indents _ """"""" _ propertyName _ """"": ["" _ $char(13, 10) do writeStr")
				do %code.WriteLine("		set indents = indents _ tabChar")
				do %code.WriteLine("		for i=1:1:.." _ propertyName _ ".Count() {")
				do %code.WriteLine("			if i '= 1 set addString = "","" _ $char(13, 10) do writeStr")
				//Object
				if propertyType '[ "%" {
					do %code.WriteLine("			set tSC = .." _ propertyName _ ".GetAt(i).ToJSONHelper(.outputStream, .jsonString, indents, 1)")
					do %code.WriteLine("			quit:$$$ISERR(tSC)")
				}
				//Primitive
				else {	
					do %code.WriteLine("			set value = .." _ propertyName_".GetAt(i)")
					do %code.WriteLine("			if $listvalid(value) {")
					do %code.WriteLine("				set value = $listget(value, 1)")
					do %code.WriteLine("				set hasPrimitiveExtension = 1")
					do %code.WriteLine("			}")
					do %code.WriteLine("			if value'="""" {")

					if (propertyType [ "Integer") || (propertyType [ "Decimal") {
						do %code.WriteLine("				set addString = indents _ $select($extract(value, 1)=""."":""0"", 1:"""") _ value do writeStr")
					}
					elseif propertyType [ "Boolean" {
						do %code.WriteLine("				set addString = indents _ $select(value:""true"", 1:""false"") do writeStr")
					}
					else {
						do %code.WriteLine("				set addString = indents _ """""""" _ $zconvert(value, ""O"", ""JSON"") _ """""""" do writeStr")
					}
					do %code.WriteLine("			} elseif hasPrimitiveExtension {")
					do %code.WriteLine("				set addString = indents _ ""null"" do writeStr")
					do %code.WriteLine("			}")
				}
				do %code.WriteLine("		}")
				do %code.WriteLine("		set addString = $char(13, 10) do writeStr")
				do %code.WriteLine("		set indents = $replace(indents, tabChar,"""",, 1)")
				do %code.WriteLine("		set addString = indents _ ""]"" do writeStr")
				do %code.WriteLine("		if hasPrimitiveExtension {")
				do %code.WriteLine("			set hasPrimitiveExtension = 0")
				do %code.WriteLine("			if comma set addString = "","" _ $char(13, 10) do writeStr")
				do %code.WriteLine("			set addString = indents _ """"""_" _ propertyName _ """"": ["" _ $char(13, 10) do writeStr")
				do %code.WriteLine("			set indents = indents _ tabChar")
				do %code.WriteLine("			for i=1:1:.." _ propertyName _ ".Count() {")
				do %code.WriteLine("				if i '= 1 set addString = "","" _ $char(13, 10) do writeStr")
				do %code.WriteLine("				set value = .." _ propertyName_".GetAt(i)")
				do %code.WriteLine("				if $listvalid(value) {")
				do %code.WriteLine("					set addString = indents _ ""{"" _ $char(13, 10) do writeStr")
				do %code.WriteLine("					set indents = indents _ tabChar")
				do %code.WriteLine("					set addString = indents _ """"""extension"""": ["" _ $char(13, 10) do writeStr")
				do %code.WriteLine("					set indents = indents _ tabChar")
				do %code.WriteLine("					for extNum=2:1:$listlength(value) {")
				do %code.WriteLine("						if extNum '= 2 set addString = "","" _ $char(13, 10) do writeStr")
				do %code.WriteLine("						set extensionLocation = $listget(value, extNum)")
				do %code.WriteLine("						set tSC = ..primitiveExtension.GetAt(extensionLocation).ToJSONHelper(.outputStream, .jsonString, indents, 1)")
				do %code.WriteLine("						quit:$$$ISERR(tSC)")
				do %code.WriteLine("					}")
				do %code.WriteLine("					set addString = $char(13, 10) do writeStr")
				do %code.WriteLine("					set indents = $replace(indents, tabChar,"""",, 1)")
				do %code.WriteLine("					set addString = indents _ "" ]""_$char(13,10)  do writeStr")
				do %code.WriteLine("					set indents = $replace(indents, tabChar,"""",, 1)")
				do %code.WriteLine("					set addString = indents _ ""}""  do writeStr")
				do %code.WriteLine("				}")
				do %code.WriteLine("				else {")
				do %code.WriteLine("					set addString = indents _ ""null"" do writeStr")
				do %code.WriteLine("				}")
				do %code.WriteLine("			}")
				do %code.WriteLine("			set indents = $replace(indents, tabChar,"""",, 1)")
				do %code.WriteLine("			set addString = $char(13,10)_indents _ ""]"" do writeStr")
				do %code.WriteLine("		}")
			}
			//Is a single
			else {
				do %code.WriteLine("	if .." _ propertyName _ " '= """" {")
				//Object
				if propertyType '[ "%" {
					do %code.WriteLine("		if comma {")
					do %code.WriteLine("			set addString = "","" _ $char(13, 10) do writeStr")
					do %code.WriteLine("		}")
					do %code.WriteLine("		set addString = indents _ """"""" _ propertyName _ """"": "" do writeStr")
					do %code.WriteLine("		set tSC = .." _ propertyName _ ".ToJSONHelper(.outputStream, .jsonString, indents, 0)")
					do %code.WriteLine("		quit:$$$ISERR(tSC)")
					do %code.WriteLine("		set comma = 1")
				}
				//Primitive
				else {
					do %code.WriteLine("		set value = .." _ propertyName)
					do %code.WriteLine("		if $listvalid(.." _ propertyName _ ") {")
					do %code.WriteLine("			set value = $listget(.." _ propertyName _ ", 1)")
					do %code.WriteLine("			set hasPrimitiveExtension = 1")
					do %code.WriteLine("		}")
					do %code.WriteLine("		if value '= """" {")
					do %code.WriteLine("			if comma {")
					do %code.WriteLine("				set addString = "","" _ $char(13, 10) do writeStr")
					do %code.WriteLine("			}")
					do %code.Write("			set addString = indents _ """"""" _ propertyName _ """"": ")
					if (propertyType [ "Integer") || (propertyType [ "Decimal") {
						do %code.WriteLine(""" _ $select($extract(value, 1)=""."":""0"", 1:"""") _ value do writeStr")
					}
					elseif propertyType [ "Boolean" {
						do %code.WriteLine(""" _ $select(value:""true"", 1:""false"") do writeStr")
					}
					else {
						do %code.WriteLine(""""""" _ $zconvert(value, ""O"", ""JSON"") _ """""""" do writeStr")
					}
					do %code.WriteLine("			set comma = 1")
					do %code.WriteLine("		}")
					
					do %code.WriteLine("		if hasPrimitiveExtension {")
					do %code.WriteLine("			set hasPrimitiveExtension = 0")
					do %code.WriteLine("			if comma set addString = "","" _ $char(13, 10) do writeStr")
					do %code.WriteLine("			set addString = indents _ """"""_" _ propertyName _ """"": {"" _ $char(13, 10) do writeStr")
					do %code.WriteLine("			set indents = indents _ tabChar")
					do %code.WriteLine("			set addString = indents _ """"""extension"""": ["" _ $char(13, 10) do writeStr")
					do %code.WriteLine("			set indents = indents _ tabChar")
					do %code.WriteLine("			for extNum=2:1:$listlength(.." _ propertyName _ ") {")
					do %code.WriteLine("				if extNum '= 2 set addString = "","" _ $char(13, 10) do writeStr")
					do %code.WriteLine("				set extensionLocation = $listget(.." _ propertyName _ ", extNum)")
					do %code.WriteLine("				set tSC = ..primitiveExtension.GetAt(extensionLocation).ToJSONHelper(.outputStream, .jsonString, indents, 1)")
					do %code.WriteLine("				quit:$$$ISERR(tSC)")
					do %code.WriteLine("			}")
					do %code.WriteLine("			set addString = $char(13, 10) do writeStr")
					do %code.WriteLine("			set indents = $replace(indents, tabChar,"""",, 1)")
					do %code.WriteLine("			set addString = indents _ ""]"" _ $char(13, 10) do writeStr")
					do %code.WriteLine("			set indents = $replace(indents, tabChar,"""",, 1)")
					do %code.WriteLine("			set addString = indents _ ""}"" do writeStr")
					do %code.WriteLine("			set comma = 1")
					do %code.WriteLine("		}")
				}
			}
			do %code.WriteLine("	}")
		}
		
		do %code.WriteLine("	set indents = $replace(indents, tabChar,"""",, 1)")
		do %code.WriteLine("	set addString = $char(13, 10) do writeStr")
		do %code.WriteLine("	set addString = indents _ ""}"" do writeStr")
		
		do %code.WriteLine("	} catch ex {")
		do %code.WriteLine("		set tSC = ex.AsStatus()")
		do %code.WriteLine("	}")
		do %code.WriteLine("	quit tSC")
		do %code.WriteLine("writeStr")
		do %code.WriteLine("	if ($length(addString)+$length(jsonString))>2048 do outputStream.Write(jsonString) set jsonString = """"")
		do %code.WriteLine("	set jsonString = jsonString _ addString")
		do %code.WriteLine("	quit")
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
