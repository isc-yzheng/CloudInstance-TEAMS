/// Abstract class to be extended by all classes representing parameters of a request 
Class HS.REST.AbstractParameter Extends %RegisteredObject [ Abstract, DependsOn = HS.REST.AdaptorHelper, PropertyClass = HS.REST.AbstractParameterProps ]
{

/// The path to be used as part of the request that is built using properties of this class.
/// If there are properties that should be placed in the path, the path template will 
/// indicate the location of those properties by placing {propertyName} in the path.
Parameter PathTemplate As STRING [ Abstract ];

/// Indicates whether the raw data should be populated from properties as a <class>%String</class> 
/// (i.e. only one property which contains all the POST raw data)
/// OR if raw data should be built as a <class>%DynamicAbstractObject</class> from the properties.
Parameter RawDataAsJSON As BOOLEAN = 0;

ClassMethod "%%CheckClassValidity"() As %Status [ CodeMode = objectgenerator, ForceGenerate ]
{
	Quit ##class(%ZHSLIB.PackageManager.Core.CodeGenUtils.VerifyAbstractMembersDefined).CheckCompiledClassValidityAgainstAbstractClass(%compiledclass, "HSTools.JIRA.AbstractParameter")
}

/// Using the properties of this class, populate the parameters necessary to create a request using <class>HS.REST.Client</class>. <br />
/// @Argument	pPath			Path to use when calling the <method>Send</method> of the request. <br />
/// @Argument	pQuery			Subscripted array with key-value pairs corresponding to URL parameter key-value pairs (i.e. parameters after ? in the URL). <br />
/// @Argument	pHeaders		Subscripted array with key-value pairs corresponding to headers of the request (e.g. ContentType, Authorization, etc.)
/// @Argument	pFormData		Form data as a subscripted array of key-value pairs for the body of the request. <br />	
/// @Argument	pRawData		Raw data as a <class>%String</class> for the body of the request. <br />
Method GetRequestComponents(Output pPath As %String, Output pQuery, Output pHeaders, Output pFormData, Output pRawData As %String) [ CodeMode = objectgenerator, ForceGenerate ]
{
	// Generate a single line of code, prepended by a tab
	#define Generate(%line) Do %code.WriteLine($Char(9)_%line)
	If %class.Abstract {
		Quit $$$OK
	}
	
	$$$Generate("Kill pPath, pQuery, pHeaders, pFormData, pRawData")
	$$$Generate("Set pPath = "_$$$QUOTE(%parameter("PathTemplate")))
	Set tRawDataAsJSON = +%parameter("RawDataAsJSON")
	If tRawDataAsJSON {
		$$$Generate("Set pRawData = ##class(%DynamicObject).%New()")
	}
	Set tClassname = %class.Name
	Set tPropName = ""
	While 1 {
		Set tPropName = $$$defMemberNext(tClassname, $$$cCLASSproperty, tPropName)
		If tPropName = "" {
			Quit
		}
		
		// Ensure required properties have value
		If $$$defMemberKeyGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPrequired) {
			$$$Generate("If .."_tPropName_" = """" {")
			$$$Generate("	$$$ThrowStatus($$$ERROR($$$GeneralError, ""Property '"_tPropName_"' is required so cannot be empty""))")
			$$$Generate("}")
		}
		
		// Get property parameters
		Set tInPath = $$$defMemberArrayGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPparameter, "InPath")
		Set tInQuery = $$$defMemberArrayGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPparameter, "InQuery")
		Set tInHeader = $$$defMemberArrayGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPparameter, "InHeader")
		Set tInFormData = $$$defMemberArrayGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPparameter, "InFormData")
		Set tInRawData = $$$defMemberArrayGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPparameter, "InRawBody")
		
		// Make sure property is a data type
		Set tPropType = $$$NormalizeClassname($$$comMemberKeyGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPtype))
		Set tTypeOfPropType = $$$comClassKeyGet(tPropType, $$$cCLASSclasstype)
		
		Set tCollectionType = $$$defMemberKeyGet(tClassname, $$$cCLASSproperty, tPropName, $$$cPROPcollection)
		// Assign property to necessary part of request
		If tInPath {
			$$$Generate("Set pPath = $Replace(pPath, ""{"_tPropName_"}"", .."_tPropName_")")
		} ElseIf tInQuery {
			Do ..GenerateArrayInitialize("pQuery", tCollectionType, tPropName, %code)
		} ElseIf tInHeader {
			Do ..GenerateArrayInitialize("pHeader", tCollectionType, tPropName, %code)
		} ElseIf tInFormData {
			Do ..GenerateArrayInitialize("pFormData", tCollectionType, tPropName, %code)
		} ElseIf tInRawData {
			If tRawDataAsJSON {
				Set tJSONType = ##class(HS.REST.AdaptorHelper).GetJSONType(tPropType)
				If tJSONType = "" {
					$$$ThrowStatus($$$ERROR($$$GeneralError, "Property "_tPropName_" must be a data type or a JSON object"))
				} ElseIf tJSONType = "json" {
					$$$Generate("If $IsObject(.."_tPropName_") {")
					$$$Generate("	Do pRawData.%Set("_$$$QUOTE(tPropName)_", .."_tPropName_")")
					$$$Generate("}")
				} Else {
					$$$Generate("If .."_tPropName_" '= """" {")
					$$$Generate("	Do pRawData.%Set("_$$$QUOTE(tPropName)_", .."_tPropName_", "_$$$QUOTE(tJSONType)_")")
					$$$Generate("}")
				}
			} Else {
				$$$Generate("Set pRawData = .."_tPropName)
			}
			
		} Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "No specification provided for where '"_tPropName_"' should be located in request"))
		}
	}
}

/// Generates code to initialize a subscripted array (that contains information about parameters for a request)
/// from the given property of this class. <br />
/// @Argument	pArrayName			Name of subscripted array to initialize. <br />
/// @Argument	pCollectionType		The collection type of the property. <br />
/// @Argument	pPropName			Name of property whose value will be transmitted to the subscripted array. <br />
/// @Argument	pCode				Stream to use to generate code. <br />
ClassMethod GenerateArrayInitialize(pArrayName As %String, pCollectionType As %String, pPropName As %Dictionary.Identifier, pCode As %Stream.MethodGenerator) [ Internal ]
{
	// Generate a single line of code, prepended by a tab
	#define Generate(%line) Do pCode.WriteLine($Char(9)_%line)
	If pCollectionType = $$$cPROPCOLLECTIONLIST {
		$$$Generate("If .."_pPropName_" '= """" {")
		$$$Generate("	For i=1:1:.."_pPropName_".Count() {")
		$$$Generate("		Set "_pArrayName_"("""_pPropName_"[""_(i-1)_""]"") = .."_pPropName_".GetAt(i)")
		$$$Generate("	}")
		$$$Generate("}")
	} ElseIf pCollectionType = $$$cPROPCOLLECTIONARRAY {
		$$$ThrowStatus($$$ERROR($$$NotImplemented))
	} Else {
		$$$Generate("If .."_pPropName_" '= """" {")
		$$$Generate("	Set "_pArrayName_"("""_pPropName_""") = .."_pPropName)
		$$$Generate("}")
	}
}

}
