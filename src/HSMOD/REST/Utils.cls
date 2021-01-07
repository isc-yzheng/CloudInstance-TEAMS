Include (%occErrors, HSMOD.REST)

Class HSMOD.REST.Utils [ Abstract ]
{

/// helper method for code generation elsewhere in this package. Given a (compiled) class definition, this looks up that 
/// class's value for a parameter. This is to avoid possible compilation/execution problems in the code generator, using $parameter
ClassMethod GetParameterValueForCodeGen(pClassDef As %Dictionary.CompiledClass, pParamName As %String, Output pValue As %String) As %Status [ Internal ]
{
	/* note that we can't just use the .%GetParameter() method on the class definition, because that returns empty strings. 
	For example: 
	> set test = ##class(%Dictionary.CompiledClass).%OpenId("HSMOD.UserAdmin.CallbackManager")
	> w test.%GetParameter("MODULECALLBACKBASE") 
			// ^- returns empty string
	> f loop=1:1:test.Parameters.Count() { set x = test.Parameters.GetAt(loop) w:x.Name="MODULECALLBACKBASE" !,x.Name _ ": " _ x.Default } 
			// ^- returns nonempty value for MODULECALLBACKBASE
	*/
	
	set tSC = $$$OK
	try {
		set pValue = ""
		
		set tParamCount = pClassDef.Parameters.Count()
		#dim tLoopParam as %Dictionary.CompiledParameter
		
		for tParamLoop = 1:1:tParamCount {
			set tLoopParam = pClassDef.Parameters.GetAt(tParamLoop)
			if tLoopParam.Name = pParamName {
				set pValue = tLoopParam.Default
				quit
			}
		}
	}
	catch tException {
		set tSC = tException.AsStatus()
	}
	
	quit tSC
}

/// given a <class>%Dictionary.CompiledProperty</class> property representation, 
/// this method decides whether we can support it in our code generation for serialization proxies. It returns a hardcoded string that tells 
/// the code generation what sort of handling to provide. 
ClassMethod GenerationSupportsProperty(pCompiledProperty As %Dictionary.CompiledProperty, Output pHandlingCase As %String) As %Boolean [ Internal ]
{
	set pHandlingCase = ""
	
	// everything must be typed
	if pCompiledProperty.Type = "" {
		quit 0 
	}
	
	// note that we do NOT support relationships. Since our objects are not persistent, this should never arise. 
	if pCompiledProperty.Relationship = 1 {
		quit 0
	}
	
	// other forbidden sorts of property
	if pCompiledProperty.MultiDimensional || pCompiledProperty.ServerOnly || pCompiledProperty.Internal {
		quit 0
	}
	
	// what types of collections do we support (currently)? Note that any additions to this list require implementation in the serialization 
	// proxy base class. 
	if pCompiledProperty.Collection '= "" {
		if '$case(pCompiledProperty.RuntimeType,
				"%Collection.ListOfDT":1,
				"%Collection.ListOfObj":1,
				"%Collection.ArrayOfDT":1,
				"%Collection.ArrayOfObj":1,
				:0) { 
			quit 0
		}
	}
		
	// OK, what about the type itself? For now we support only scalars (data types), non-swizzlable registered objects, and other REST serialization objects. 	
	// Swizzlable registered objects are just persistent plus serial objects. We might want to include serial objects as well in the future. 
	
	if $classmethod(pCompiledProperty.Type, "%IsA", "HSMOD.REST.SerializationProxy") {
		set pHandlingCase = $$$HSRESTProxyHandlingRESTProxy
		quit 1
	}
	
	if $classmethod(pCompiledProperty.Type, "%IsA", "%Library.SerialObject")
	{
		set pHandlingCase = $$$HSRESTProxyHandlingSerial
		quit 1
	}
	
	if $classmethod(pCompiledProperty.Type, "%IsA", "%Library.DataType") {
		set pHandlingCase = $$$HSRESTProxyHandlingDataType
		quit 1
	}
	
	if $classmethod(pCompiledProperty.Type, "%IsA", "%Stream.Object") {
		set pHandlingCase = $$$HSRESTProxyHandlingStream
		quit 1
	}
		
	quit 0
}

/// helper method for code generation elsewhere in this package. Given a (compiled) class definition for a proxy class, this returns an array 
/// of all the properties that are not calculated or "internal", and validates the property types. 
/// Used only for classes that extend <class>HSMOD.REST.SerializationProxy</class>. 
ClassMethod GetPropertyArray(pProxyClassDef As %Dictionary.CompiledClass, pPartnerClassName As %String, ByRef pPropertyNames) As %Status [ Internal ]
{
	set tSC = $$$OK
	try {
		kill pPropertyNames 
		set pProblematicPropertyName = ""
		
		// build an array of summary info about properties in the *partner* class for comparison/verification
		#dim tLoopProp as %Dictionary.CompiledProperty
		
		set pPartnerClass = ##class(%Dictionary.CompiledClass).%OpenId(pPartnerClassName,,.tSC) // assumed to exist; caller method checks this
		$$$ThrowOnError(tSC)
		
		set tPropCount = pPartnerClass.Properties.Count()
		for tPropLoop = 1:1:tPropCount {
			set tLoopProp = pPartnerClass.Properties.GetAt(tPropLoop)
			set tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyRuntimeType) = tLoopProp.RuntimeType
			set tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyType) = tLoopProp.Type
			set tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyIsCollection) = tLoopProp.Collection
		}
		
		// now we check the proxy class's properties. What's the substitute property for the ID (if there is one)? 
		set tSC = ..GetParameterValueForCodeGen(pProxyClassDef, "IDPROPERTY", .tErsatzIdPropertyName)
		$$$ThrowOnError(tSC)
		
		// every property must pass inspection in order for us to generate code for the class. 
		set tPropCount = pProxyClassDef.Properties.Count()
		for tPropLoop = 1:1:tPropCount
		{
			set tLoopProp = pProxyClassDef.Properties.GetAt(tPropLoop)
			if $extract(tLoopProp.Name,1,2) = "%%" {
				continue // skip the internal OID etc. 
			}
						
			set tHandling = ""
			// does the code generation support this type of property? 
			if '..GenerationSupportsProperty(tLoopProp, .tHandling) {
				$$$ThrowStatus($$$ERROR($$$HSModRESTErrUnhandledSerialProxyProperty, pProxyClassDef.Name, tLoopProp.Name))
			}
			
			// does it match what's in the original class? 
			if tLoopProp.Name '= tErsatzIdPropertyName {
				if $data(tPartnerPropInfo(tLoopProp.Name)) = 0 { 
					// not found
					$$$ThrowStatus($$$ERROR($$$HSModRESTErrInvalidSerialProxyPropertyName, pProxyClassDef.Name, tLoopProp.Name, pPartnerClassName))
				}
				
				// it exists ... does it match types? 
				// we can't just compare directly; if the partner class's property is a persistent object then we need 
				// the proxy class to use an appropriate proxy class in its place. 
				set tDesiredProxyPropertyType = ""
				if $classmethod(tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyType),"%Extends","%Library.Persistent") {
					// need to check the proxy's property class to ensure it's a matching proxy
					if '$classmethod(tLoopProp.Type, "%Extends", "HSMOD.REST.SerializationProxy") {
						// the proxy property isn't even a serialization proxy. nope
						$$$ThrowStatus($$$ERROR($$$HSModRESTErrMismatchedSerialProxyPropertyType, pProxyClassDef.Name, tLoopProp.Name, pPartnerClassName))
					}
					
					set tLoopPropClass = ##class(%Dictionary.CompiledClass).%OpenId(tLoopProp.Type,, .tSC)
					$$$ThrowOnError(tSC)
					
					set tSC = ..GetParameterValueForCodeGen(tLoopPropClass, "PARTNERCLASS", .tDesiredProxyPropertyType)
					$$$ThrowOnError(tSC)
				}
				else {
					// compare types directly
					set tDesiredProxyPropertyType = tLoopProp.Type
				}
				
				if (tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyType) '= tDesiredProxyPropertyType) { 
					$$$ThrowStatus($$$ERROR($$$HSModRESTErrMismatchedSerialProxyPropertyType, pProxyClassDef.Name, tLoopProp.Name, pPartnerClassName))
				}
					
				// now check the collection-ness 
				if (tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyIsCollection) '= tLoopProp.Collection)
						|| (tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyRuntimeType) '= tLoopProp.RuntimeType) { 
					$$$ThrowStatus($$$ERROR($$$HSModRESTErrMismatchedSerialProxyPropertyType, pProxyClassDef.Name, tLoopProp.Name, pPartnerClassName))
				}
				
				// make sure that both or neither properties are stream types.
				set tHasStreamHandling = (tHandling = $$$HSRESTProxyHandlingStream)
				if $classmethod(tPartnerPropInfo(tLoopProp.Name, $$$HSRESTProxyPropertyType),"%Extends","%Stream.Object") '= tHasStreamHandling {
					$$$ThrowStatus($$$ERROR($$$HSModRESTErrMismatchedSerialProxyPropertyType, pProxyClassDef.Name, tLoopProp.Name, pPartnerClassName))
				}
			}
			 
			set tPropertyInfo(tLoopProp.Name, $$$HSRESTProxyPropertyRuntimeType) = tLoopProp.RuntimeType
			set tPropertyInfo(tLoopProp.Name, $$$HSRESTProxyPropertyType) = tLoopProp.Type
			set tPropertyInfo(tLoopProp.Name, $$$HSRESTProxyHandling) = tHandling // whether it's a data type, or a serialization class, or ... 
			set tPropertyInfo(tLoopProp.Name, $$$HSRESTProxyPropertyIsCollection) = tLoopProp.Collection
			
			// Check for the custom property parameter that might tell us to skip it  
			// (defined in the property class HSMOD.REST.SerializationPropertyParams). 
			// Readonly & calculated properties are treated this way regardless. 
			set tOutputOnly = tLoopProp.Parameters.GetAt("SkipWhileDeserializing") || tLoopProp.ReadOnly || tLoopProp.Calculated
			set tPropertyInfo(tLoopProp.Name, $$$HSRESTProxySkipWhileDeSerializing) = ''tOutputOnly // if empty string, we get 0			 	
		}
		
		if $data(tPropertyInfo) = 0 {
			// we didn't find anything
			$$$ThrowStatus($$$ERROR($$$HSModRESTErrEmptySerialProxyClass, pProxyClassDef.Name))
		}
		
		merge pPropertyNames = tPropertyInfo
		set tSC = $$$OK
	} 
	catch tException {
		set tSC = tException.AsStatus()
	}
		
	quit tSC
}

/// helper method for code generation elsewhere in this package. Given a class definition, this method checks to 
/// see whether the class has an IdKey. If yes, then the method returns the name of the IdKey index as well as 
/// an incremented array containing the names of the properties found there, in order. 
ClassMethod GetIdKeyProperties(pClassName As %Dictionary.Classname, Output pIndexName As %String, Output pPropertyNames As %List) As %Status [ Internal ]
{
	set pIndexName = ""
	set pPropertyNames = ""
	
	set tClassDef = ##class(%Dictionary.CompiledClass).%OpenId(pClassName,,.tSC)
	if $$$ISERR(tSC) {
		quit tSC
	}
	
	set tIndexCount = tClassDef.Indices.Count()
	#dim tLoopIndex as %Dictionary.CompiledIndex
	
	for tIndexLoop = 1:1:tIndexCount
	{
		set tLoopIndex = tClassDef.Indices.GetAt(tIndexLoop)
		if tLoopIndex.IdKey = 1 {
			set pIndexName = tLoopIndex.Name
			set tPropertyString = tLoopIndex.Properties
			for tPropertyLoop = 1:1:$length(tPropertyString,",")
			{
				set pPropertyNames = pPropertyNames _ $listbuild($piece(tPropertyString,",",tPropertyLoop))
			}
			quit
		}
	}
	quit $$$OK
}

ClassMethod GetUniqueKeyProperties(pClassName As %Dictionary.Classname, pIndexName As %String, Output pPropertyNames As %List) As %Status [ Internal ]
{
	set pPropertyNames = ""
	
	set tIndexDef = ##class(%Dictionary.CompiledIndex).%OpenId(pClassName_"||"_pIndexName,,.tSC)
	if $$$ISERR(tSC) {
		quit tSC
	}
	
	set tPropertyString = tIndexDef.Properties
	for tPropertyLoop = 1:1:$length(tPropertyString,",")
	{
		set pPropertyNames = pPropertyNames _ $listbuild($piece(tPropertyString,",",tPropertyLoop))
	}
	
	quit $$$OK
}

/// utility for code generation validation, for tests used by serialization and deserialization code. Other validations can be performed by the code generators. 
ClassMethod ValidateSerialProxyClassForCodeGeneration(pProxyClass As %Dictionary.CompiledClass, Output pPartnerClassName, Output pPropertyInfoArray) As %Status [ Internal ]
{
	set tSC = $$$OK
	try {
		set pPartnerClassName = ""
		kill pPropertyInfoArray
		
		set tSC = ..GetParameterValueForCodeGen(pProxyClass, "PARTNERCLASS", .pPartnerClassName)
		$$$ThrowOnError(tSC)
		
		if pPartnerClassName = "" {
			$$$ThrowStatus($$$ERROR($$$HSModRESTErrInvalidSerialProxyClassPartner, pProxyClass.Name, pPartnerClassName))
		}
		
		if '##class(%Dictionary.CompiledClass).%ExistsId(pPartnerClassName) {
			$$$ThrowStatus($$$ERROR($$$HSModRESTErrInvalidSerialProxyClassPartner, pProxyClass.Name, pPartnerClassName))
		}
		
		// now look at the properties in the current class. If any of them are a complex type or structure that we don't handle, 
		// we pull the plug and generate a trivial implementation
		
		set tSC = ..GetPropertyArray(pProxyClass, pPartnerClassName, .pPropertyInfoArray)
		$$$ThrowOnError(tSC)
		
	}
	catch tException {
		set tSC = tException.AsStatus()
	}
	
	quit tSC
}

/// non-API utility to support <class>HSMOD.REST.Base</class>. Throws a status error if validation failed. <br/>
/// The class & method used in the API call are used to construct error statuses if something went wrong, to help locate the problem. <br/>
/// The "specified" class name is what the calling code specified as the request object class when calling the 
/// SimpleRESTRequestResponse method; the "expected" class name is what we found in the method signature. These must be compatible. 
ClassMethod ValidateRESTRequestObject(pAPIClassName As %Dictionary.Classname, pAPIMethodName As %String, pRequestObject As %RegisteredObject, pSpecifiedClassName As %Dictionary.Classname, pExpectedClassName As %Dictionary.Classname)
{
	do ..ValidateRequestOrResponse(pAPIClassName, pAPIMethodName, pRequestObject, pSpecifiedClassName, pExpectedClassName, 1)
}

/// non-API utility to support <class>HSMOD.REST.Base</class>. Throws a status error if validation failed. <br/>
/// The class & method used in the API call are used to construct error statuses if something went wrong, to help locate the problem. <br/>
/// The "specified" class name is what the calling code specified as the response object class when calling the 
/// SimpleRESTRequestResponse method; the "expected" class name is what we found in the method signature. These must be compatible. 
ClassMethod ValidateRESTResponseObject(pAPIClassName As %Dictionary.Classname, pAPIMethodName As %String, pResponseObject As %RegisteredObject, pSpecifiedClassName As %Dictionary.Classname, pExpectedClassName As %Dictionary.Classname)
{
	do ..ValidateRequestOrResponse(pAPIClassName, pAPIMethodName, pResponseObject, pSpecifiedClassName, pExpectedClassName, 0)
}

/// called by <method>ValidateRESTRequestObject</method> and <method>ValidateRESTResponseObject</method> for common logic
ClassMethod ValidateRequestOrResponse(pAPIClassName As %Dictionary.Classname, pAPIMethodName As %String, pObjectToValidate As %RegisteredObject, pSpecifiedClassName As %Dictionary.Classname, pExpectedClassName As %Dictionary.Classname, pIsRequest As %Boolean) [ Private ]
{
	#define FailInvalid(%msg)  $$$ThrowStatus($$$ERROR($case(pIsRequest,1:$$$HSModRESTErrInvalidRESTRequestObject,:$$$HSModRESTErrInvalidRESTResponseObject), pAPIClassName, pAPIMethodName, %msg))
	#define FailInvalidDistinguishing(%requestmsg, %responsemsg)  $$$FailInvalid($case(pIsRequest,1:%requestmsg,:%responsemsg))
	
	if '$isobject(pObjectToValidate)
	{
		$$$FailInvalidDistinguishing("Object not provided","Object not created")
	}
		
	// now we look at the object's class - does it match what we are expecting? 
	
	// if they're both empty, we can just plow ahead and make the call. 
    // if they're both non-empty, we can verify, but the class specified by the argument must extend the expected class
    // otherwise we can verify with whichever one is non-empty
    // This works out to: use the specified value unless it's empty and the expected value is not, in which case use that. Furthermore, verify compatibility. 

    set tClassNameToCheck = pSpecifiedClassName
    if pSpecifiedClassName '= pExpectedClassName {
        if pSpecifiedClassName = "" {
	        set tClassNameToCheck = pExpectedClassName
        }
        elseif pExpectedClassName '= "" {
	       // both are nonempty, but they're different. are they compatible? If so, we can use the specified one
	       if '$classmethod(pSpecifiedClassName, "%Extends", pExpectedClassName) {
		       $$$FailInvalid("Class " _ pExpectedClassName _ " does not extend " _ pSpecifiedClassName)
	       }
        }
    }
	
    if tClassNameToCheck '= "" {
        if ('pObjectToValidate.%IsA(tClassNameToCheck)) || ($$$ISERR(pObjectToValidate.%ValidateObject()))
        {
	        $$$FailInvalidDistinguishing("Expected a valid request object of type " _ tClassNameToCheck,"Failed to create valid response object of type " _ tClassNameToCheck)
        }
    }
}

/// helper method for <class>HSMOD.REST.Base</class>. Throws exceptions for any validation problem; caller will handle the exception. <br />
ClassMethod ValidateAPIMethodSignature(pAPIClassName As %Dictionary.Classname, pAPIMethodName As %String, Output pExpectedRequestClassName As %Dictionary.Classname, Output pExpectedResponseClassName As %Dictionary.Classname)
{
	kill pExpectedRequestClassName
	kill pExpectedResponseClassName
	
	#define FailInvalid(%msg)  $$$ThrowStatus($$$ERROR($$$HSModRESTErrInvalidRESTRequestResponseMethodSignature, pAPIClassName, pAPIMethodName, %msg))
	
	if '$$$comClassDefined(pAPIClassName) {
		// we use the "general" error instead of $$$CompiledClassDoesNotExist so that we can control the phrasing. 
		$$$FailInvalid("Class does not exist")
	}
	
	if '$$$comMemberDefined(pAPIClassName, $$$cCLASSmethod, pAPIMethodName) {			
		// we use the General error instead of $$$MethodDoesNotExist so that we can control the phrasing. 
		$$$FailInvalid("Method does not exist")
	}
	
	// the return type is defined in both ^oddDEF and ^oddCOM, but the one in ^oddDEF might be a truncated system class name (e.g. "%Status") 
	// while the one in ^oddCOM is fully specified ("%Library.Status"). We'll check the ^oddCOM one for simplicity's sake. 
	if $$$comMemberKeyGet(pAPIClassName, $$$cCLASSmethod, pAPIMethodName, $$$cMETHreturntype) '= "%Library.Status" {
		$$$FailInvalid("Method does not return a %Status value")
	}

	// whether something is a class method is defined in the class definition in ^oddDEF, but not in the compiled class metadata in ^oddCOM	
	if $$$defMemberKeyGet(pAPIClassName, $$$cCLASSmethod, pAPIMethodName, $$$cMETHclassmethod) = 0 {
		$$$FailInvalid("Method is not a class method")
	}
	
	set tArgumentSpec = $$$comMemberKeyGet(pAPIClassName, $$$cCLASSmethod, pAPIMethodName, $$$cMETHformalspecparsed)
	
	if $listlength(tArgumentSpec) '= 2 {
		$$$FailInvalid("Method does not have two arguments")
	}
	
	set tPosition = 0
	set tPtr = 0
	
	while $listnext(tArgumentSpec, tPtr, tArgumentItem) {
		set tPosition = tPosition + 1
		set tErrorCommon = "Argument " _ tPosition 
		
		/* 
		tArgumentItem should be a list of four values: 
		- argument name (which we don't care about)
		- argument type
		- "&" for ByRef, "*" for output, "" for neither
		- default
		*/ 
		
		set tArgumentType = $listget(tArgumentItem, 2)
		if tArgumentType = "" {
			$$$FailInvalid(tErrorCommon _ " is untyped")
		}
		// we can assume that a nonempty value is a legitimate class; otherwise, the method's class would not have compiled.
		if '$classmethod(tArgumentType, "%Extends", "%RegisteredObject") {
			$$$FailInvalid(tErrorCommon _ " does not extend %Library.RegisteredObject")
		}
		
		if tPosition = 1 {
			set tRequestClass = tArgumentType
			if $listget(tArgumentItem, 3) '= "" {
				$$$FailInvalid(tErrorCommon _ " should be an input argument")
			}
		}
		else {
			set tResponseClass = tArgumentType
			if $listget(tArgumentItem, 3) '= "*" {
				$$$FailInvalid(tErrorCommon _ " should be an output argument")
			}
		}
		
		if $listget(tArgumentItem, 4) '= "" {
			$$$FailInvalid(tErrorCommon _ " should not have a default value")
		}
	}
	
	set pExpectedRequestClassName = $get(tRequestClass)
	set pExpectedResponseClassName = $get(tResponseClass)
}

}
