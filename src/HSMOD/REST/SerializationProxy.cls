Include HSMOD.REST

IncludeGenerator HSMOD.REST

/// <p>
/// Common base class for serializing persistent classes for the purposes of REST-enabled application modules. 
/// If the class and all its contents are registered only (not persistent), then 
/// this machinery is unnecessary. If the properties of the proxy are datatypes, non-swizzlable registered classes 
/// and/or other serialization proxy classes, then we can generate methods for serializing and de-serializing. 
/// Currently does not handle serial objects. 
/// </p><p>
/// Suppose we have a persistent class and we want to send and receive JSON representations of that class. The 
/// serialization class acts as an intermediary and has methods to generate itself from the persistent class, as 
/// well as to create or find-and-update the existing persistent object using the values in a proxy object. 
/// If the class has an IdKey, it is used to find and open existing objects; otherwise the proxy class 
/// must have a designated property for storing the internal ID (identified via a class parameter). 
/// The serialization class is then what's used generate the JSON, and vice versa. 
/// </p><p>
/// The proxy deals with only an explicit subset of the properties; we do not automatically generate properties 
/// for the proxy. 
/// </p><p>
/// The proxy object has no built-in machinery for serializing or de-serializing itself to/from JSON. The assumption is 
/// that the modules will use the HS.JSON module's read/write methods for that. 
/// </p><p>
/// Each such class needs to be specifically extended from <class>HSMOD.REST.SerializationProxy</class>, typically by simply specifying 
/// properties. Properties in the serialization class must have the same name as a property in the associated class, and 
/// will be associated automatically. The extension would typically be in a "Foo.Auxil" package of an application or module. 
/// </p>
/// @API.Object
/// @API.Extensible
Class HSMOD.REST.SerializationProxy Extends %RegisteredObject [ Abstract, DependsOn = HSMOD.REST.Utils, PropertyClass = HSMOD.REST.SerializationPropertyParams ]
{

/// the name of the class that the current serialization proxy class represents
/// @API.Parameter
Parameter PARTNERCLASS;

/// default is left empty to support classes with custom IdKeys. In most cases 
/// the serialization class will have a custom property called IdValue or similar,  
/// which should be specified here. 
/// @API.Parameter
Parameter IDPROPERTY;

/// the name of the unique index to use to locate an existing target object in ProduceObjectFromContent
/// if unspecified, and if IDPROPERTY is not overridden, the partner class's IDKEY index will be used instead.
Parameter UNIQUEINDEXNAME;

/// given a persistent object of the proper class, create a new serialization proxy object and return it
/// @API.Method
ClassMethod CreateFromObject(pSourceObject As %Persistent, Output pNewObject As HSMOD.REST.SerializationProxy) As %Status
{
	set pNewObject = ..%New()
	quit pNewObject.PopulateFromObject(pSourceObject)
}

/// Implementation for instantiating and populating the serialization class from the original persistent object. 
/// Default behavior is to loop through the properties of the serialization class and match them 
/// to identically-named properties in the partner class. For the %Id(), we use whatever's identified 
/// by the IDPROPERTY parameter. If this base implementation is insufficient, it can be overridden with custom (non-generated) code. 
/// @API.Method
Method PopulateFromObject(pSourceObject As %Persistent) As %Status [ CodeMode = objectgenerator ]
{
	set tRetVal = $$$OK
	
			
	try {
		if %compiledclass.Abstract {
			// we don't bother for abstract classes such as the base class HSMOD.REST.SerializationProxy itself
			do %code.WriteLine(" quit $$$OK")
			set tRetVal = $$$OK
			quit
		}
		
		set tSC = ##class(HSMOD.REST.Utils).ValidateSerialProxyClassForCodeGeneration(%compiledclass, .tPartnerClassName, .tPropertyNames)
		$$$ThrowOnError(tSC)
		 
		// insert further tests here as needed
		
		/*
		From this point on, we assume that we should be able to generate the code. 
		*/
	
		do %code.WriteLine(" set tRetVal = $$$OK")
		
		do %code.WriteLine(" if 'pSourceObject.%IsA(""" _ tPartnerClassName _ """) { ")
		do %code.WriteLine("	set tSourceClass = $classname(pSourceObject)")
		do %code.WriteLine("	set tProxyClass = $classname()")
		do %code.WriteLine("	quit $$$ERROR($$$HSModRESTErrInvalidSerialProxyRequest,tSourceClass,tProxyClass) ")
		do %code.WriteLine(" } ")
			
		do %code.WriteLine(" try {")
					
		set tSC = ##class(HSMOD.REST.Utils).GetParameterValueForCodeGen(%compiledclass, "IDPROPERTY", .tErsatzIdPropertyName)
		$$$ThrowOnError(tSC)
		
		if tErsatzIdPropertyName '= "" {
			do %code.WriteLine("	set .." _ tErsatzIdPropertyName _ " = pSourceObject.%Id() ")
		}
		
		set tPropertyName = ""
		while 1 {
			set tPropertyName = $o(tPropertyNames(tPropertyName))
			if tPropertyName = "" {
				quit
			}
			
			// if we have an ID placeholder property, skip it because we already populated it above
			if tPropertyName = tErsatzIdPropertyName {
				continue
			}
			
			kill tPropertyInfo
			merge tPropertyInfo = tPropertyNames(tPropertyName)
			
			// is it a collection or not? 
			if tPropertyInfo($$$HSRESTProxyPropertyIsCollection) '= 1 {
				if tPropertyInfo($$$HSRESTProxyHandling) = $$$HSRESTProxyHandlingRESTProxy {
					/*
					note that tPropertyInfo($$$HSRESTProxyPropertyType) is the prescribed type of the property in question, but in practice it might 
					be an instance of a subclass of that type. However, we don't implement any special "override" to tell us what to 
					do. If a class needs to have special handling, then the serialization class should be subclassed further, either 
					to override the property declaration or to override this method (and maybe call ##super and then re-do the property). 
					We can't automate this because a given class might have multiple serialization proxy classes defined to stand in for it. 
					*/
					
					do %code.WriteLine("	set tSC = ##class(" _ tPropertyInfo($$$HSRESTProxyPropertyType) _ ").CreateFromObject(pSourceObject."_tPropertyName_",.tSubObject)")
					do %code.WriteLine("	$$$ThrowOnError(tSC)")
					do %code.WriteLine("	set .." _ tPropertyName _ " = tSubObject")
				}
				elseif tPropertyInfo($$$HSRESTProxyHandling) = $$$HSRESTProxyHandlingStream {
					do %code.WriteLine("	do .." _ tPropertyName _ ".Clear()")
					do %code.WriteLine("	set tSC = .."_tPropertyName_".CopyFrom(pSourceObject."_tPropertyName_")")
					do %code.WriteLine("	$$$ThrowOnError(tSC)")
				}
				else {
					// datatype or serial 
					do %code.WriteLine("	set .." _ tPropertyName _ " = pSourceObject." _ tPropertyName)
				}
			}
			else {
				/* 
				it's a collection
				for now we assume that the runtime type is one of: 
				- list of data types
				- list of objects
				- array of data types
				- array of objects
				*/
				
				do %code.WriteLine("	if '$isobject(.." _ tPropertyName _ ") { ")
				set tRuntimeType = tPropertyInfo($$$HSRESTProxyPropertyRuntimeType) 
				do %code.WriteLine("		set .." _ tPropertyName _ " = ##class(" _ tRuntimeType _ ".%New()")
				do %code.WriteLine("	}")
				
				// regardless of whether it's a list or array, we can use the GetNext() and SetAt() methods 
				// to work with the collection.
				do %code.WriteLine("	set tKey = """"")
				do %code.WriteLine("	while 1 {")
				do %code.WriteLine("		set tItem = pSourceObject."_tPropertyName_".GetNext(.tKey)")
				do %code.WriteLine("		if tKey = """" quit")
			
				if tPropertyInfo($$$HSRESTProxyHandling) = $$$HSRESTProxyHandlingRESTProxy {
					// we need to make a serialized version of the original
					do %code.WriteLine("		set tSC = ##class(" _ tPropertyInfo($$$HSRESTProxyPropertyType) _ ").CreateFromObject(tItem,.tSubObject)")
					do %code.WriteLine("		$$$ThrowOnError(tSC)")
					do %code.WriteLine("		do .." _ tPropertyName _ ".SetAt(tSubObject,tKey)")
				}
				else { 
					// it's data type or serial; copy the value in
					do %code.WriteLine("		do .." _ tPropertyName _ ".SetAt(tItem,tKey)")
				}
				
				do %code.WriteLine("	}") // end the WHILE loop
			}
		}
		
		do %code.WriteLine(" }")
		do %code.WriteLine(" catch tException {")
		do %code.WriteLine("	set tRetVal = tException.AsStatus()")
		do %code.WriteLine(" }")
		
		do %code.WriteLine(" quit tRetVal")
		do %code.WriteLine(" ")
		
		set tRetVal =  $$$OK
	}
	catch tException {
		set tRetVal = tException.AsStatus()
	}
	
	quit tRetVal
}

/// if the current serialization object represents an existing (saved) object, this method instantiates the existing "real" object, 
/// copies property values, and returns it (without saving). If it represents new data, 
/// this method creates a new instance of the "real" class, populates it, and returns (without saving). 
/// @API.Method
Method ProduceObjectFromContent(Output pTargetObject As %Persistent) As %Status [ CodeMode = objectgenerator ]
{
	set tRetVal = $$$OK
	
	try {
		
		if %compiledclass.Abstract {
			// we don't make a fuss for abstract classes such as the base class HSMOD.REST.SerializationProxy itself
			do %code.WriteLine(" quit $$$OK")
			set tRetVal = $$$OK
			quit
		}
		
		set tSC = ##class(HSMOD.REST.Utils).ValidateSerialProxyClassForCodeGeneration(%compiledclass, .tPartnerClassName, .tPropertyNames)
		$$$ThrowOnError(tSC)
		 
		// further tests here: 
		
		set tSC = ##class(HSMOD.REST.Utils).GetParameterValueForCodeGen(%compiledclass, "IDPROPERTY", .tErsatzIdPropertyName)
		$$$ThrowOnError(tSC)
					
		set tSC = ##class(HSMOD.REST.Utils).GetParameterValueForCodeGen(%compiledclass, "UNIQUEINDEXNAME", .tUniqueIndexName)
		$$$ThrowOnError(tSC)
		
		if (tErsatzIdPropertyName '= "") && (tUniqueIndexName '= "") {
			$$$ThrowStatus($$$ERROR($$$HSModRESTErrInvalidSerialProxyIndexParameters,%compiledclass.Name))
		}
	 	
		if tErsatzIdPropertyName = "" {
			if (tUniqueIndexName '= "") {
				set tIdKeyName = tUniqueIndexName
				set tSC = ##class(HSMOD.REST.Utils).GetUniqueKeyProperties(tPartnerClassName, tUniqueIndexName, .tIdKeyProperties)
			}
			else {
				set tSC = ##class(HSMOD.REST.Utils).GetIdKeyProperties(tPartnerClassName, .tIdKeyName, .tIdKeyProperties)
			}
			$$$ThrowOnError(tSC)
			if $listlength(tIdKeyProperties) = 0 {
				// no index in the partner class is flagged as an IdKey, and this class has no IDPROPERTY value specified, so 
				// we don't know how to instantiate objects of the partner class. 
				$$$ThrowStatus($$$ERROR($$$HSModRESTErrInvalidSerialProxyUniqueID,%compiledclass.Name,tPartnerClassName))
			}
		} 
		
		do %code.WriteLine(" set pTargetObject = """"")
		
		do %code.WriteLine(" set tRetVal = $$$OK")
		do %code.WriteLine(" try {")
		
		if tErsatzIdPropertyName '= "" {
			do %code.WriteLine(" set tIdVal = .." _ tErsatzIdPropertyName)
			do %code.WriteLine(" if tIdVal = """" {")
			// case where serialization object represents a "new" instance
			do %code.WriteLine("	set pTargetObject = ##class(" _ tPartnerClassName _ ").%New())")
			do %code.WriteLine(" } else { " )
			// case where serialization object represents an update to an existing instance
			do %code.WriteLine("	set pTargetObject = ##class(" _ tPartnerClassName _ ").%OpenId(tIdVal,, .tSC)")
			do %code.WriteLine("	$$$ThrowOnError(tSC)")
			// TODO: validate that we actually got an object ... what kind of exception to throw? 
			do %code.WriteLine(" }")
			set tSkipProps(tErsatzIdPropertyName) = 1
		}
		else {
			// work with tIdKeyProperties
			
			set tOpenProps = "" // list of properties to use when attempting to open the object
			
			//set tIteration = 0
			set tPointer = 0
			while $listnext(tIdKeyProperties,tPointer,tIndexPropertyName) {
				set tSkipProps(tIndexPropertyName) = 1
				set tOpenProps = tOpenProps _ $lb(".." _ tIndexPropertyName)
			}
			
			do %code.WriteLine("	if ##class(" _ tPartnerClassName _ ")." _ tIdKeyName _ "Exists(" _ $listtostring(tOpenProps) _ ",.tObjectId) {")
			do %code.WriteLine("		set pTargetObject = ##class(" _ tPartnerClassName _ ").%OpenId(tObjectId,, .tSC)")
			do %code.WriteLine("		$$$ThrowOnError(tSC)")
			do %code.WriteLine("	}")
			do %code.WriteLine("	else {")
			do %code.WriteLine("		set pTargetObject = ##class(" _ tPartnerClassName _ ").%New()")
			
			// if we had to create a "new" instance, we need to populate the idkey properties in this case only. This means 
			// looping through the index properties a second time. We could build these commands during the previous loop, 
			// but then we'd have to loop through some new array to put them into the stream here. 
			set tPointer = 0
			while $listnext(tIdKeyProperties,tPointer,tIndexPropertyName) {
				do %code.WriteLine("		set pTargetObject." _ tIndexPropertyName _ " = .." _ tIndexPropertyName)
			}
			
			do %code.WriteLine("	}") // close the "if exists"
		}
		
		set tPropertyName = ""
		while 1 {
			set tPropertyName = $o(tPropertyNames(tPropertyName))
			if tPropertyName = "" {
				quit
			}
			
			if $data(tSkipProps(tPropertyName)) > 0 {
				continue
			}
			
			kill tPropertyInfo
			merge tPropertyInfo = tPropertyNames(tPropertyName)
			
			// if it's an output-only property, we don't need to push its contents into the "real" object
			if $get(tPropertyInfo($$$HSRESTProxySkipWhileDeSerializing)) = 1 { 
				continue
			}
		
			if tPropertyInfo($$$HSRESTProxyPropertyIsCollection) '= 1 {
				if tPropertyInfo($$$HSRESTProxyHandling) = $$$HSRESTProxyHandlingRESTProxy { 
					do %code.WriteLine("	set tSC = .." _ tPropertyName _ ".ProduceObjectFromContent(.tSubObject)")
					do %code.WriteLine("	$$$ThrowOnError(tSC)")
					do %code.WriteLine("	set pTargetObject." _ tPropertyName _ " = tSubObject")
				}
				elseif tPropertyInfo($$$HSRESTProxyHandling) = $$$HSRESTProxyHandlingStream {
					do %code.WriteLine("	do pTargetObject." _ tPropertyName _ ".Clear()")
					do %code.WriteLine("	set tSC = pTargetObject."_tPropertyName_".CopyFrom(.."_tPropertyName_")")
					do %code.WriteLine("	$$$ThrowOnError(tSC)")
				}
				else {
					do %code.WriteLine("	set pTargetObject." _ tPropertyName _ " = .." _ tPropertyName)
				}
			}
			else { 
				// it's a collection. 				
				// the runtime type will be listofDT or arrayofObj or some such
				
				do %code.WriteLine("	if '$isobject(pTargetObject." _ tPropertyName _ ") { ")
				set tRuntimeType = tPropertyInfo($$$HSRESTProxyPropertyRuntimeType) 
				
				do %code.WriteLine("		set pTargetObject." _ tPropertyName _ " = ##class(" _ tRuntimeType _ ".%New()")
				do %code.WriteLine("	}")
			
				// lists and arrays both support the GetNext()/SetAt() methods so we can handle them all the same way
				do %code.WriteLine("	set tKey = """"")
				do %code.WriteLine("	while 1 {")
				do %code.WriteLine("		set tItem = .."_tPropertyName_".GetNext(.tKey)")
				do %code.WriteLine("		if tKey = """" quit")
				
				if tPropertyInfo($$$HSRESTProxyHandling) = $$$HSRESTProxyHandlingRESTProxy {
					// we need to make a deserialized version					
					do %code.WriteLine("		set tSC = tItem.ProduceObjectFromContent(.tSubObject)")
					do %code.WriteLine("		$$$ThrowOnError(tSC)")
					do %code.WriteLine("		do pTargetObject." _ tPropertyName _ ".SetAt(tSubObject,tKey)")
				}
				else {
					// data type or serial object
					do %code.WriteLine("		do pTargetObject." _ tPropertyName _ ".SetAt(tItem,tKey)")
				}
				
				do %code.WriteLine("	}") // end the WHILE loop
			}		
		}
	
		do %code.WriteLine(" }")
		do %code.WriteLine(" catch tException {")
		do %code.WriteLine("	set tRetVal = tException.AsStatus()")
		do %code.WriteLine(" }")
		
		do %code.WriteLine(" quit tRetVal")
		do %code.WriteLine(" ")
			
		set tRetVal =  $$$OK
	}
	catch tException {
		set tRetVal = tException.AsStatus()
	}
	
	quit tRetVal
}

}
