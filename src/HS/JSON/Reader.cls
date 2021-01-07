Include HS.JSON

/// <p>Utility class for reading JSON content and creating object instances from it.
/// There are two methods to do this.</p>
/// 
/// <h3>Approach #1: <method>%ReadJSONIntoObject</method></h3>
/// <p>This approach is recommended in most cases.</p>
/// Examples:
/// <example>
/// Set tSC = ##class(HS.JSON.Reader).%ReadJSONIntoObject(.tObj,tJSON,"SomePackage.ExpectedClassName")
/// </example>
/// <p>%ReadJSONIntoObject reads a JSON object into an instance of a registered object, taking into account the metadata
/// of the target class (property types, etc.)</p>
/// 
/// <p>This may incur a slight performance overhead due to references to the class dictionary, but provides greater
/// flexibility than <method>%ReadJSON</method> to handle more complicated class definitions.</p>
/// 
/// <p>%ReadJSONIntoObject is also more secure than %ReadJSON, because the base expected class is part of the method signature
/// and is used to validate the object type specified in JSON (by default, the _class property).</p>
/// 
/// <h3>Approach #2: <method>%ReadJSON</method></h3>
/// Example:
/// <example>Set tSC = ##class(HS.JSON.Reader).%ReadJSON(tJSON,.tObj)</example>
/// 
/// <p>Internally, <method>%ReadJSON</method> reads the input JSON into a local array (graph)
/// and then copies the values within this array to objects it instantiates.</p>
/// 
/// <p>%ReadJSON treats the JSON as the authority for which properties to set in the target object.
/// It does not use the class metadata for the target class, and therefore cannot know to avoid
/// setting the values of stream, private, read-only, calculated, or multidimensional properties.</p>
/// 
/// <p>Use of %ReadJSON presents some minor security risks, because it may allow %New() to be called on an arbitrary class.
/// This can be mitigated by subclassing, overriding <method>%OnResolveObject</method>, and validating the the class against
/// a hard-coded list of expected classes before calling %New().</p>
/// 
/// <p>%ReadJSON is best used to obtain an instance of <class>%ZEN.proxyObject</class>, or of a very simple
/// registered class. It is also retained for backward-compatibility. New applications should use
/// <method>%ReadJSONIntoObject</method> in most circumstances.</p>
Class HS.JSON.Reader Extends %RegisteredObject [ System = 3 ]
{

/// Input data: either a string or a stream.
Property %JSON As %String [ Internal ];

/// Current character position within the input text.
Property %Position As %Integer [ Internal ];

/// If we have looked ahead, then this contains the next character to process.
Property %NextChar As %String [ Internal ];

/// If we have looked ahead, then this contains the next token to process.
Property %NextToken As %String [ Internal ];

/// If we have looked ahead, then this contains the next token type to process.
Property %NextTokenType As %String [ Internal ];

/// Constructor.
Method %OnNew(pJSON As %String) As %Status [ Internal ]
{
	Set ..%JSON = pJSON
	Set ..%Position = 1
	Set ..%NextChar = ""
	Set ..%NextToken = ""
	Set ..%NextTokenType = ""
	Quit $$$OK
}

/// Reset - rewind stream (if there's a stream) and reset parser position to the beginning
Method %Reset() As %Status [ Internal ]
{
	Set tStatus = $$$OK
	Try {
		Set ..%Position = 1
		Set ..%NextChar = ""
		Set ..%NextToken = ""
		Set ..%NextTokenType = ""
		If ($IsObject(..%JSON) && ..%JSON.%IsA("%Stream.Object")) {
			Set tStatus = ..%JSON.Rewind()
		}
	} Catch e {
		Set tStatus = e.AsStatus()
	}
	Quit tStatus
}

ClassMethod %MapDynamicObjectToProxyObject(pDynamicObject As %Library.DynamicAbstractObject, Output pObject As %RegisteredObject) As %Status [ Internal, Private ]
{
	#dim tIterator As %Iterator.AbstractIterator
	Set tStatus = $$$OK
	Try {
		Kill pObject

		Set tIterator = pDynamicObject.%GetIterator()
		
		If pDynamicObject.%IsA("%Library.DynamicObject") {
			Set pObject = ##class(%ZEN.proxyObject).%New()
			While tIterator.%GetNext(.tPropertyName,.tDynamicValue) {
				If $isobject(tDynamicValue) {
					Set tStatus = ..%MapDynamicObjectToProxyObject(tDynamicValue,.tValue)
					If $$$ISERR(tStatus) {
						$$$ThrowStatus(tStatus)
					}
				}
				Else {
					Set tValue = tDynamicValue
				}
				Set $property(pObject,tPropertyName) = tValue
			}
		}
		ElseIf pDynamicObject.%IsA("%Library.DynamicArray") {
			// Work out whether the incoming array contains objects or datatypes,
			// as the %Library.ListOf* classes only support one or the other
			Set tIsObjectArray = 0
			Set tArraySize = pDynamicObject.%Size()
			For tArrayPos = 0:1:tArraySize-1 {
				Set tItemType = pDynamicObject.%GetTypeOf(tArrayPos)
				If (tItemType = "null") || (tItemType = "unassigned") {
					Continue
				}
				Set tIsObjectArray = $case(tItemType,
					"object":		1,
					"array":		1,
					"oref":			1,
							:		0
				)
				Quit
			}

			If (tIsObjectArray) {
				Set pObject = ##class(%Library.ListOfObjects).%New()
				While tIterator.%GetNext(.tPos,.tDynamicObject) {
					If $isobject(tDynamicObject) {
						Set tStatus = ..%MapDynamicObjectToProxyObject(tDynamicObject,.tObject)
						If $$$ISERR(tStatus) {
							$$$ThrowStatus(tStatus)
						}
						Set tStatus = pObject.InsertAt(tObject, tPos+1)
						If $$$ISERR(tStatus) {
							$$$ThrowStatus(tStatus)
						}
					}
				}
			}
			Else {
				Set pObject = ##class(%Library.ListOfDataTypes).%New()
				// Map simple values directly
				While tIterator.%GetNext(.tPos,.tValue) {
					Set tStatus = pObject.InsertAt(tValue, tPos+1)
					If $$$ISERR(tStatus) {
						$$$ThrowStatus(tStatus)
					}
				}
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

ClassMethod %MapDynamicObjectToStaticObject(pDynamicObject As %Library.DynamicAbstractObject, pTargetClass As %Dictionary.CacheClassname, Output pObject As %RegisteredObject, pClassTypeField As %String = "_class", pLoadPersistentObjects As %Boolean = 0, ByRef pCacheReference As %Integer = 0) As %Status [ Internal, Private ]
{
	#dim tIterator As %Iterator.AbstractIterator

	Set tStatus = $$$OK
	Try {
		
		Kill tIgnoreKeys

		// Questions about target:
		//  - Persistent => IDKey
		//  - JSON.Adaptor => ID field
		//  - Is collection?
		
		
		Set tTargetClass = ""
		If (pClassTypeField '= "") && pDynamicObject.%IsA("%Library.DynamicObject") {
			// Note that while both sub-classes of %Library.AbstractDynamicObject implement the %Get() method,
			// for arrays getting a string property just gets the first item in the array - not what we want!
			Set tIgnoreKeys(pClassTypeField) = 1
			Set tSuppliedClass = pDynamicObject.%Get(pClassTypeField)
			If (tSuppliedClass '= "") {
				If ('##class(%Dictionary.CompiledClass).%ExistsId(tSuppliedClass) || '$classmethod(tSuppliedClass,"%Extends",pTargetClass)) {
					Set tStatus = $$$ERROR($$$HSJSONErrInvalidClassSpecified,tSuppliedClass,pTargetClass)
					Quit
				}
				Else {
					Set tTargetClass = tSuppliedClass
				}
			}
		}
		If (tTargetClass = "") {
			If '##class(%Dictionary.CompiledClass).%ExistsId(pTargetClass) {
				Set tStatus = $$$ERROR($$$CompiledClassDoesNotExist,pTargetClass)
				Quit
			}
			Set tTargetClass = pTargetClass
		}
		If $classmethod(tTargetClass,"%Extends","%Collection.AbstractIterator") {
			Set pObject = $classmethod(tTargetClass,"%New")
			Set tStatus = ..%MapDynamicObjectToCollection(pDynamicObject,pObject,pClassTypeField,pLoadPersistentObjects,.pCacheReference,.tIgnoreKeys)
			Quit
		}
		
		Set tStatus = ..%GetClassMeta(tTargetClass,.tTargetClassMeta,.pCacheReference)
		If $$$ISERR(tStatus) {
			Quit
		}
		
		Set tIDFields = $listget(tTargetClassMeta,2)
		If pLoadPersistentObjects && (tIDFields '= "") {
			// TODO: support opening persistent objects
			// If we use tIDFields, make sure to set tIgnoreKeys(<field>) = 1
		}
		Set tTargetInstance = $classmethod(tTargetClass,"%New")
		
		Set tIterator = pDynamicObject.%GetIterator()
		While tIterator.%GetNext(.tKey,.tDynamicValue) {
			
			If $get(tIgnoreKeys(tKey)) {
				Continue
			}

			// In the lines below, a comment with the prefix NCE is intended to indicate the "non-cached equivalent"
			If '$data(tTargetClassMeta(tKey),tPropertyMeta) {
			// NCE: '$$$comMemberDefined(tTargetClass,$$$cCLASSproperty,tKey)
				Set tStatus = $$$ERROR($$$HSJSONErrInvalidFieldSupplied,tTargetClass,tKey)
				$$$ThrowStatus(tStatus)
			}
			Set tTargetPropertyName = $listget(tPropertyMeta,1)
			// NCE: $select($extract(tKey,1) = "_": "%" _  $extract(tKey,2,*),  1: tKey)
			Set tTargetPropertyType = $listget(tPropertyMeta,3)
			// NCE: $$$comMemberKeyGet(tTargetClass,$$$cCLASSproperty,tKey,$$$cPROPtype)
			Set tTargetPropertyIsNonCollection = $listget(tPropertyMeta,2)
			// NCE: ($$$comMemberKeyGet(tTargetClass,$$$cCLASSproperty,tKey,$$$cPROPcollection) = "")
			If (tTargetPropertyIsNonCollection) {
				Set tSetDirectly = 1
				If ('$classmethod(tTargetPropertyType,"%IsA","%Library.RegisteredObject")) || ('$isobject(tDynamicValue)) {
					If $classmethod(tTargetPropertyType,"%Extends","%Stream.Object") {
						#dim tStream As %Stream.Object
						Set tSetDirectly = 0
						Set tStream = $property(tTargetInstance,tTargetPropertyName)
						Do tStream.Clear()
						If (tTargetPropertyType [ "Binary") {
							// Expect Base64 encoding.
							Set tStatus = tStream.Write($System.Encryption.Base64Decode(tDynamicValue))
							$$$ThrowOnError(tStatus)
						}
						Else {
							// Expect no encoding.
							Set tStatus = tStream.Write(tDynamicValue)
							$$$ThrowOnError(tStatus)
						}
					}
					Else {
						Set tValue = tDynamicValue
					}
				}
				Else {
					Set tStatus = ..%MapDynamicObjectToStaticObject(tDynamicValue,tTargetPropertyType,.tValue,pClassTypeField,pLoadPersistentObjects,.pCacheReference)
					If $$$ISERR(tStatus) {
						$$$ThrowStatus(tStatus)
					}
				}
				If tSetDirectly {
					Set $property(tTargetInstance,tTargetPropertyName) = tValue
				}
			}
			Else {
				Set tCollection = $property(tTargetInstance,tTargetPropertyName)
				
				Set tStatus = ..%MapDynamicObjectToCollection(tDynamicValue,tCollection,pClassTypeField,pLoadPersistentObjects,.pCacheReference)
				If $$$ISERR(tStatus) {
					$$$ThrowStatus(tStatus)
				}
			}
		}
		
		Set pObject = tTargetInstance
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

ClassMethod %MapDynamicObjectToCollection(pDynamicObject As %Library.DynamicAbstractObject, pCollection As %Collection.AbstractIterator, pClassTypeField As %String = "_class", pLoadPersistentObjects As %Boolean = 0, ByRef pCacheReference As %Integer = 0, ByRef pIgnoreKeys) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Try {
		// NormalizeClassname to handle common default (%RegisteredObject)
		Set tElementClass = $$$NormalizeClassname(pCollection.ElementType)
		If ($Length(pCollection.ElementType,":") > 1) {
			// <classname>:<propertyname>
			Set tClass = $Piece(pCollection.ElementType,":")
			Set tProperty = $Piece(pCollection.ElementType,":",2)
			Set tExternalPropertyName =  $select($extract(tProperty,1) = "%": "_"_$extract(tProperty,2,*),  1: tProperty)
			$$$ThrowOnError(..%GetClassMeta(tClass,.tMeta,.pCacheReference))
			
			If '$data(tMeta(tExternalPropertyName),tPropertyMeta) {
			// NCE: '$$$comMemberDefined(tClass,$$$cCLASSproperty,tProperty)
				Set tStatus = $$$ERROR($$$HSJSONErrInvalidFieldSupplied,tTargetClass,tKey)
				$$$ThrowStatus(tStatus)
			}
			
			// NCE: $$$comMemberKeyGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPtype)
			Set tElementClass = $listget(tPropertyMeta,3)
		}
		Set tCollectionItemIsRegistered = (tElementClass '= "") && $classmethod(tElementClass,"%IsA","%Library.RegisteredObject")
		Set tOffsetKey = (pDynamicObject.%IsA("%Library.DynamicArray") && pCollection.%IsA("%Collection.AbstractList"))
		
		Set tIterator = pDynamicObject.%GetIterator()
		While tIterator.%GetNext(.tKey,.tDynamicValue) {
			If $Data(pIgnoreKeys(tKey)) {
				Continue
			}
			Kill tIgnoreKeys
			If ('tCollectionItemIsRegistered) || '$isobject(tDynamicValue) {
				Set tValue = tDynamicValue
			}
			ElseIf 'tDynamicValue.%IsA("%Library.DynamicArray") {
				Set tStatus = ..%MapDynamicObjectToStaticObject(tDynamicValue,tElementClass,.tValue,pClassTypeField,pLoadPersistentObjects,.pCacheReference)
				If $$$ISERR(tStatus) {
					$$$ThrowStatus(tStatus)
				}
			}
			Else {
				Set tNestedCollectionClass = "%Library.ListOfDataTypes"
				If (tElementClass '= "") && (tElementClass '= "%Library.RegisteredObject") {
					If '##class(%Dictionary.CompiledClass).%ExistsId(tElementClass) || '$classmethod(tElementClass,"%IsA","%Collection.AbstractList") {
						Set tStatus = $$$ERROR($$$HSJSONErrInvalidClassSpecified,tElementClass,"%Collection.AbstractList")
						$$$ThrowStatus(tStatus)
					}
					Set tNestedCollectionClass = tElementClass
				}
				Set tValue = $classmethod(tNestedCollectionClass,"%New")
				Set tStatus = ..%MapDynamicObjectToCollection(tDynamicValue,tValue,pClassTypeField,pLoadPersistentObjects,.pCacheReference,.tIgnoreKeys)
				If $$$ISERR(tStatus) {
					$$$ThrowStatus(tStatus)
				}
			}
			Set tTargetKey = $select(tOffsetKey: tKey+1, 1: tKey)
			If pCollection.%IsA("%Collection.AbstractList") {
				Set tStatus = pCollection.InsertAt(tValue,tTargetKey)
			} Else {
				Set tStatus = pCollection.SetAt(tValue,tTargetKey)
			}
			If $$$ISERR(tStatus) {
				$$$ThrowStatus(tStatus)
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Specify pCacheReference = -1 to prevent caching of metadata
ClassMethod %GetClassMeta(pClass As %Dictionary.CacheClassname, Output pMeta, ByRef pCacheReference As %Integer = 0) As %Status [ Internal, Private ]
{
	Kill pMeta
	If ('pCacheReference) {
		Set pCacheReference = $increment(^||ISC.HS.JSON.Cache)
		Kill ^||ISC.HS.JSON.Cache(pCacheReference)
	}
	Set tInCache = 0
	If $data(^||ISC.HS.JSON.Cache(pCacheReference,pClass),tCachedMeta) {
		// Check cache is not stale using compilation signature
		If $listget(tCachedMeta,1) '= $$$comClassKeyGet(pClass,$$$cCLASScompilationsignature) {
			Kill tCachedMeta
		}
		Else {
			Set tInCache = 1
		}
	}
	If '(tInCache) {
		If '$$$comClassDefined(pClass) {
			Quit $$$ERROR($$$CompiledClassDoesNotExist,pClass)
		}
		// Note that the following code does NOT lock the compiled class nodes for pClass, so it could be 
		// rendered corrupt by a compile while the import is happening

		Set tCompilationSignature = $$$comClassKeyGet(pClass,$$$cCLASScompilationsignature)
		Set tIsJSONAdaptor = $classmethod(pClass,"%Extends","HS.JSON.Adaptor")
		
		Set tPropertyList = ""
		Set tProperty = ""
		For {
			Set tProperty = $$$comMemberNext(pClass,$$$cCLASSproperty,tProperty)
			If (tProperty = "") {
				Quit
			}
			If $extract(tProperty,1,2) = "%%" {
				Continue
			}
			If $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPserveronly)
				|| $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPreadonly)
				|| $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPprivate)
				|| $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPcalculated)
				|| $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPmultidimensional)
				|| $$$comMemberKeyGet(pClass,$$$cCLASSmethod,tProperty _ "Set",$$$cMETHprivate)
			{
				Continue
			}
			
			Set tExternalPropertyName =  $select($extract(tProperty,1) = "%": "_"_$extract(tProperty,2,*),  1: tProperty)
			Set tPropertyType = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPtype)
			Set tPropertyIsNotCollectionType = ($$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPcollection) = "")
			
			Set tPropertyMeta = $listbuild(tExternalPropertyName,tProperty,tPropertyIsNotCollectionType,tPropertyType)
			
			Set pMeta(tExternalPropertyName) = $listbuild(tProperty,tPropertyIsNotCollectionType,tPropertyType)
			
			Set tPropertyList = tPropertyList _ $listbuild(tPropertyMeta)
		}
		
		Set tIDFields = ""
		If $classmethod(pClass,"%IsA","%Library.Persistent") {
			If (tIsJSONAdaptor) {
				Set tAdaptorIDField = $parameter(pClass,"JSONIDFIELD")
				If (tAdaptorIDField '= "") {
					Set tIDFields = $listbuild(tAdaptorIDField)
				}
			}
			Else {
				&sql(SELECT (SELECT %DLIST(Property) FROM %Dictionary.CompiledIndexProperty WHERE parent = CompiledIndex.%ID) INTO :tIDKeyFields 
					FROM %Dictionary.CompiledIndex
					WHERE parent = :pClass AND IdKey = 1 AND CompilerGenerated = 0 AND SequenceNumber <> 0)
				If (SQLCODE = 0) {
					Set tIDFields = tIDKeyFields
				}
				Else {
					Set tIDFields = $listbuild("_id")
				}
			}
		}
		
		If (pCacheReference > 0) {
			Set ^||ISC.HS.JSON.Cache(pCacheReference,pClass) = $listbuild(tCompilationSignature,tIsJSONAdaptor,tIDFields,tPropertyList)
		}
	}
	Else {
		Set tCompilationSignature = $listget(tCachedMeta,1)
		Set tIsJSONAdaptor = $listget(tCachedMeta,2)
		Set tIDFields = $listget(tCachedMeta,3)
		Set tPropertyList = $listget(tCachedMeta,4)
		
		Set tPropertyPos = 0
		While $listnext(tPropertyList,tPropertyPos,tPropertyMeta) {
			Set tExternalPropertyName = $listget(tPropertyMeta,1)
			If (tExternalPropertyName '= "") {
				Set pMeta(tExternalPropertyName) = $list(tPropertyMeta,2,4)
			}
		}
	}

	Set pMeta = $listbuild(tIsJSONAdaptor,tIDFields)
		
	Quit $$$OK
}

/// Read the JSON content in <var>pJSON</var> (which can be a string or a stream)
/// and convert it to a local object of the type specified in <var>pExpectedType</var>. For system 
/// library classes (e.g. %Library.Foo) the usual name abbreviation of %Foo will work. Likewise for 
/// classes in the User package: User.MyClass can be referred to as simply MyClass. <br/>
/// <var>pTypeField</var>, if present, is the name of the JSON field that defines the server-side
/// object class. By default this is "_class". This property only needs to be specified
/// when the incoming data uses subclasses of the classes in the object tree referenced from an instance
/// of <var>pExpectedType</var>. <br/>
/// Set <var>pCacheMode</var> = 0 to disable class metadata caching. <br/>
/// This differs from <method>%ReadJSON</method> in that the class metadata for the expected type is consulted. This introduces
/// a performance overhead, but also enables reading in of some types that <method>%ReadJSON</method> does not support (for
/// example, classes with calculated, read-only, and private properties). <br/>
ClassMethod %ReadJSONIntoObject(Output pObject As %RegisteredObject, pJSON As %CacheString, pExpectedType As %Dictionary.CacheClassname, pTypeField As %String = "_class", pCacheMode As %Boolean = 1, pLoadPersistentObjects As %Boolean = 0) As %Status
{
	Set tStatus = $$$OK
	Try {
		
		// handle possible class name shortcuts/abbreviations: %Library... & User...
		Set tExpectedType = $$$NormalizeClassname(pExpectedType)
		If '##class(%Dictionary.CompiledClass).%ExistsId(tExpectedType)  {
			Set tStatus = $$$ERROR($$$CompiledClassDoesNotExist,pExpectedType) 
			// pass back the original class name in the error, not tExpectedType
			Quit
		}

		// NOTE: Invalid JSON will trigger an exception
		Set tDynamicObject = ##class(%Library.DynamicAbstractObject).%FromJSON(pJSON)

		If (tExpectedType = "%Library.DynamicAbstractObject") || (tExpectedType = "%Library.DynamicObject") || (tExpectedType = "%Library.DynamicArray") {
			Set pObject = tDynamicObject
		}
		ElseIf (tExpectedType = "%ZEN.proxyObject") {
			Set tStatus = ..%MapDynamicObjectToProxyObject(tDynamicObject,.pObject)
			If $$$ISERR(tStatus) {
				Quit
			}
		}
		Else {
			If ('pCacheMode) {
				// disable class metadata cache
				Set tCacheReference = -1
			}
			Else {
				// allow code to automatically assign new cache reference
				Set tCacheReference = 0
			}
			Set tStatus = ..%MapDynamicObjectToStaticObject(tDynamicObject,tExpectedType,.pObject,pTypeField,pLoadPersistentObjects,.tCacheReference)
			If $$$ISERR(tStatus) {
				Quit
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Read the JSON content in <var>pJSON</var> (which can be a string or a stream)
/// and convert it to a local object.<br/>
/// <var>pTypeField</var>, if present, is the name of the JSON field that defines the server-side
/// object class. By default this is "_class".
/// If no type field is defined, <class>%ZEN.proxyObject</class> is used. <br/>
/// This differs from <method>%ReadJSONIntoObject</method> in that <method>%ReadJSON</method> does not consult class metadata. This makes
/// it fast, but prevents it from being able to handle certain classes, and introduces some minor security risks. <br/>
ClassMethod %ReadJSON(pJSON As %String, Output pObject As %RegisteredObject, pTypeField As %String = "_class") As %Status
{
	Set tSC = $$$OK
	Try {
		Set pObject = ""
		Set tSC = ..%ParseJSON(pJSON,.tData)
		If $$$ISERR(tSC) Quit

		// walk down data (in reverse so that we can resolve references)
		Set tNodeNo = $O(tData(""),-1)
		While (tNodeNo'="") {
			Set p = $O(tData(tNodeNo,""))
			If (p="") {
				// empty
			}
			ElseIf (p=+p) {
				// array
				// what type of list?
				If $E($G(tData(tNodeNo,p))="@") {
					Set tObj = ##class(%ListOfObjects).%New()
				}
				Else {
					Set tObj = ##class(%ListOfDataTypes).%New()
				}
				Set tObjectList(tNodeNo) = tObj

				While(+p>0) {
					Set tValue = $G(tData(tNodeNo,p))
					If ($E(tValue,1,3)="@O:") {
						Set tValue=$G(tObjectList($P(tValue,":",2)),##class(%ZEN.proxyObject).%New())
					}
					ElseIf ($E(tValue,1,3)="@A:") {
						Set tValue=$G(tObjectList($P(tValue,":",2)),##class(%ListOfDataTypes).%New())
					}
					Do tObj.Insert(tValue)
					Set p = $O(tData(tNodeNo,p))
				}
			}
			Else {
				// object
				Set tSC = ..%ResolveObject(.tObj,.tData,tNodeNo,.tObjectList,pTypeField)
				If $$$ISERR(tSC) Quit

				Set tObjectList(tNodeNo) = tObj
			}

			Set tNodeNo = $O(tData(tNodeNo),-1)
		}

		// return first object in set
		Set pObject = $G(tObjectList(1))
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Set pObject = ""
	}
	Quit tSC
}

/// Callback for <method>%ReadJSON</method>.<br/>
/// This is called as each object is processed from the JSON input.
/// It is responsible for creating an object to hold the data for the JSON input
/// and copying this data into the object.<br/>
/// <var>pData</var> is the complete set of data processed from the JSON input.
/// <var>pNodeNo</var> the node in <var>pData</var> containing the data for the current object.<br/>
/// <var>pObjectList</var> is an array of objects already created. This is used to resolve
/// properties that refer to objects or arrays.<br/>
ClassMethod %ResolveObject(Output pObject As %RegisteredObject, ByRef pData, pNodeNo As %Integer, ByRef pObjectList, pTypeField As %String = "") As %Status [ Final, Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tSC = ..%OnResolveObject(.pObject,.pData,pNodeNo,pTypeField)
		If $$$ISERR(tSC) Quit

		// load properties
		Set p = $Order(pData(pNodeNo,""))
		While (p'="") {
			// resolve references
			Set tValue = $Get(pData(pNodeNo,p))
		    //replace a leading underscore with a percent
			Set tPropName = $Select($Extract(p,1)="_":"%"_$Extract(p,2,*),1:p)
			If ($extract(tValue,1,3)="@O:") {
				// this could be an array
				Set tProp = $Property(pObject,tPropName)
				If $IsObject(tProp) && tProp.%IsA("%Collection.ArrayOfDT") {
					// When empty, we are creating an empty %ArrayOfDataTypes, this gets converted automatically when assigned to property
					// Ditto, for all %ArrayOfObjects, %ListOfDataTypes, and %ListOfObjects below
					Set tValue=$Get(pObjectList($Piece(tValue,":",2)),##class(%ArrayOfDataTypes).%New())
				} ElseIf $IsObject(tProp) && tProp.%IsA("%Collection.ArrayOfObj") {
					Set tValue=$Get(pObjectList($Piece(tValue,":",2)),##class(%ArrayOfObjects).%New())
				} Else {
					Set tValue=$Get(pObjectList($Piece(tValue,":",2)),##class(%ZEN.proxyObject).%New())
				}
			}
			ElseIf ($E(tValue,1,3)="@A:") {
				Set tProp = $Property(pObject,tPropName)
				If $IsObject(tProp) && tProp.%IsA("%Collection.ListOfDT") {
					Set tValue=$Get(pObjectList($Piece(tValue,":",2)),##class(%ListOfDataTypes).%New())
				} Else {
					Set tValue=$Get(pObjectList($Piece(tValue,":",2)),##class(%ListOfObjects).%New())
				}
			}
			Else {
				If '$IsObject(tValue) {
					// unescape @
					Set tValue = $Replace(tValue,"@@","@")
				}
			}
			// skip type field
			If (p'=pTypeField) {
				// convert _ to % for initial character only. The Writer class does the reverse. 
				Set tPropName = $Select($Extract(p,1) = "_":"%" _ $Extract(p,2,*),1:p)
				Try {
					Set $Property(pObject,tPropName) = tValue
				}
				Catch(ex) {
					Set tSC = $$$EMBEDSC($$$ERROR($$$HSJSONErrResolveObjectPropertySet,$get(tPropName),$classname(pObject)),ex.AsStatus())
					Set pObject = ""
				}
				If $$$ISERR(tSC) Quit
			}
			Set p = $Order(pData(pNodeNo,p))
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Set pObject = ""
	}
	Quit tSC
}

/// Callback for <method>%ReadJSON</method>.<br/>
/// This is called as each object is processed from the JSON input.
/// It is responsible for creating an object to hold the data for the JSON input.<br/>
/// <var>pData</var> is the complete set of data processed from the JSON input.
/// <var>pNodeNo</var> the node in <var>pData</var> containing the data for the current object.<br/>
/// Subclass can override this method.
ClassMethod %OnResolveObject(Output pObject As %RegisteredObject, ByRef pData, pNodeNo As %Integer, pTypeField As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pObject = ""
		If (pTypeField'="") {
			Set tClass = $G(pData(pNodeNo,pTypeField))
			If (tClass'="") {
				Set pObject = $classmethod(tClass,"%New")
			}
		}
		If '$IsObject(pObject) {
			// default implementation: create a proxy object
			Set pObject = ##class(%ZEN.proxyObject).%New()
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Set pObject = ""
	}
	Quit tSC
}

/// Parse the string <var>pJSON</var> containing JSON notation
/// and copy its contents into the local array, <var>pData</var>.
/// <var>pJSON</var> can also be a character stream.<br/>
ClassMethod %ParseJSON(pJSON As %String, Output pData) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Kill pData
		Set tParser = ..%New(pJSON)
		
		Set tSC = tParser.%Parse(.pData,$I(pData))
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method %Parse(ByRef pData, pNodeNo As %Integer, pLevel = 1) As %Status [ Internal ]
{
	Set tStatus = $$$OK
	Try {
		Set tParsed = 0
		If $$$HSJsonIsSupported && $$$HSJsonIsEnabled {
			Set tStatus = ..%ParseAbstractObject(.pData,pNodeNo,pLevel)
			If $$$ISOK(tStatus) {
				Set tParsed = 1
			} Else {
				Set tStatus = ..%Reset()
				If $$$ISERR(tStatus) {
					Quit
				}
			}
		}
		
		//Fall back to old parser if unable to parse using newer techniques.
		If 'tParsed {
			Set tStatus = ..%ParseManual(.pData,pNodeNo,pLevel)
			If $$$ISERR(tStatus) {
				Quit
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

Method %ParseAbstractObject(ByRef pData, pNodeNo As %Integer, pLevel As %Integer = 1) As %Status [ Internal ]
{
	Set tStatus = $$$OK
	Try {

		Set tObject = ##class(%Library.DynamicAbstractObject).%FromJSON(..%JSON)

		Set tStatus = ..%MapIterableData(tObject,.pData,pNodeNo)
		If $$$ISERR(tStatus) {
			Quit
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

Method %MapIterableData(pIterableObject As %Library.SystemBase, ByRef pData, pNodeNo As %Integer) As %Status [ Internal ]
{
	Set tStatus = $$$OK
	Try {
		Set tIterator = pIterableObject.$$$HSJsonMethodGetIterator()
		Set tIsArray = pIterableObject.%IsA($$$HSJsonQuotedClassArray)
		
		// Add a 0th subscript to denote empty arrays.
		If (tIsArray && (pIterableObject.$$$HSJsonMethodSize() = 0)) {
			Set pData(pNodeNo,0) = ""
		} Else {
			While tIterator.$$$HSJsonMethodGetNext(.tKey,.tValue) {
				// Need to add 1 to the key if it's an array (0-based indices)
				Set tIndex = $Select(tIsArray:tKey+1,1:tKey)
				If $IsObject(tValue) {
					Set tNewNodeNo = $i(pData)
					Set pData(pNodeNo,tIndex) = "@" _ $select(tValue.%IsA($$$HSJsonQuotedClassArray): "A", 1: "O") _ ":" _ tNewNodeNo
					Set tStatus = ..%MapIterableData(tValue,.pData,tNewNodeNo)
					If $$$ISERR(tStatus) {
						Quit
					}
				}
				Else {
					// Concatenate with empty string to treat numbers as strings (matching pre-dynamic object behavior)
					Set pData(pNodeNo,tIndex) = ""_tValue
				}
			}
			If $$$ISERR(tStatus) {
				Quit
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// 
/// Parse JSON input.  JSON can not only contain object, but arrays and scalar values
/// 
Method %ParseManual(ByRef pData, pNodeNo As %Integer, pLevel = 1) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tDone = 0
		Set tType = ""
		While ('tDone) {
			Set tToken = ..%ReadNextToken(.tType,.tSC)
			If $$$ISERR(tSC) Quit

			If (tType="END") Quit

			If (tType="OP") && (tToken="{") {
				// Object
				Set ..%NextToken = tToken
				Set ..%NextTokenType = tType
				Set tSC = ..%ParseObject(.pData,pNodeNo,pLevel)
				If $$$ISERR(tSC) Quit
			} ElseIf (tType="OP") && (tToken="[") {
				// Array
				Set ..%NextToken = tToken
				Set ..%NextTokenType = tType
				Set tSC = ..%ParseArray(.pData,pNodeNo,pLevel)
				If $$$ISERR(tSC) Quit
			} Else {
				
				// TODO: Handle scalar values: STR, NUM, STREAM
				//       But how to return them since the API returns a %ZEN.proxyObject?
				
				Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONCharacter,tToken,"'{', '['",..%Position)
				Quit
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Read from the current data source and process all the properties of the current JSON object.
Method %ParseObject(ByRef pData, pNodeNo As %Integer, pLevel = 1) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tDone = 0
		Set tState = 0
		Set tType = ""
		While ('tDone) {
			Set tToken = ..%ReadNextToken(.tType,.tSC)
			If $$$ISERR(tSC) Quit

			If (tType="END") Quit

			If (tState = 0) {
				If (tType="OP")&&(tToken="{") {
					// start of object
					Set tState = 1
					Set tProp = ""
					Set tValue = ""
				}
			}
			ElseIf (tState = 1) {
				If (tType="OP")&&(tToken="}") {
					// end of object
					Set tDone = 1
				}
				ElseIf ((tType="STR")||(tType="TOKEN")) {
					// property
					Set tProp = tToken
					Set tState = 2
				}
				Else {
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONCharacter,tToken,"'}', STR, TOKEN",..%Position)
				}
			}
			ElseIf (tState = 2) {
				// looking for ":"
				If (tType="OP")&&(tToken=":") {
					Set tState = 3
				}
				Else {
					// error
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONCharacter,tToken,"':'",..%Position)
				}
			}
			ElseIf (tState = 3) {
				// value
				If (tType="STR") {
					Set tValue = $Replace(tToken,"@","@@")
					Set tState = 4
				}
				ElseIf (tType="STREAM") {
					// tToken is actually a stream OREF
					Set tValue = tToken
					Set tState = 4
				}
				ElseIf (tType="NUM") {
					Set tValue = tToken
					Set tState = 4
				}
				ElseIf (tType="TOKEN") {
					Set tValue = $Case(tToken,"true":1,"false":0,"null":"",:tToken)
					Set tState = 4
				}
				ElseIf ((tType="OP")&&(tToken="{")) {
					// object value: recurse
					Set tNodeNo = $I(pData)
					Set ..%NextToken = tToken
					Set ..%NextTokenType = tType
					Set tSC = ..%ParseObject(.pData,tNodeNo,pLevel+1)
					If $$$ISERR(tSC) Quit

					// set value to new node
					Set tValue = "@O:"_tNodeNo
					Set tState = 4
				}
				ElseIf ((tType="OP")&&(tToken="[")) {
					// array value: recurse
					Set tNodeNo = $I(pData)
					Set ..%NextToken = tToken
					Set ..%NextTokenType = tType
					Set tSC = ..%ParseArray(.pData,tNodeNo,pLevel+1)
					If $$$ISERR(tSC) Quit

					// set value to new node
					Set tValue = "@A:"_tNodeNo
					Set tState = 4
				}
				Else {
					// error
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONValueRequired,..%Position)
				}
			}
			ElseIf (tState = 4) {
				
				// Validate the property name
				If (tType="OP") && (tProp="") {
					// TODO: { "": "hello" } is actually valid ... but we can't have a null subscript
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONPropertyNameRequired,..%Position)
					Quit
				}
				
				If ((tType="OP")&&(tToken=",")) {
					// add to current node
					Set pData(pNodeNo,tProp) = tValue
					Set tProp = ""
					Set tValue = ""
					Set tState = 1
				}
				ElseIf ((tType="OP")&&(tToken="}")) {
					Set pData(pNodeNo,tProp) = tValue
					Set tDone = 1
				}
				Else {
					// error
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONCharacter,tToken,"',', '}'",..%Position)
				}
			}
			If $$$ISERR(tSC) Quit
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Read from the current data source and process all the elements of the current JSON array.
Method %ParseArray(ByRef pData, pNodeNo As %Integer, pLevel = 1) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tIndexNo = ""
		Set tDone = 0
		Set tState = 0
		Set tType = ""
		While ('tDone) {
			Set tToken = ..%ReadNextToken(.tType,.tSC)
			If $$$ISERR(tSC) Quit

			If (tType="END") Quit

			If (tState = 0) {
				If (tType="OP")&&(tToken="[") {
					// start of array
					Set tState = 1
					Set tIndexNo = ""
				}
				Else {
					// error
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONArray,tToken,tState,..%Position)
				}
			}
			ElseIf (tState=1) {
				// next element
				If (tType="OP")&&(tToken="{") {
					// object value: recurse
					Set tNodeNo = $I(pData)
					Set ..%NextToken = tToken
					Set ..%NextTokenType = tType
					Set tSC = ..%ParseObject(.pData,tNodeNo,pLevel+1)
					If $$$ISERR(tSC) Quit

					Set pData(pNodeNo,$I(tIndexNo)) = "@O:"_tNodeNo
					Set tState = 2
				}
				ElseIf (tType="OP")&&(tToken="[") {
					// array value: recurse
					Set tNodeNo = $I(pData)
					Set ..%NextToken = tToken
					Set ..%NextTokenType = tType
					Set tSC = ..%ParseArray(.pData,tNodeNo,pLevel+1)
					If $$$ISERR(tSC) Quit

					Set pData(pNodeNo,$I(tIndexNo)) = "@A:"_tNodeNo
					Set tState = 2
				}
				ElseIf (tType="STR") {
					Set pData(pNodeNo,$I(tIndexNo)) = $Replace(tToken,"@","@@")
					Set tState = 2
				}
				ElseIf (tType="STREAM") {
					Set pData(pNodeNo,$I(tIndexNo)) = tToken
					Set tState = 2
				}
				ElseIf (tType="NUM") {
					Set pData(pNodeNo,$I(tIndexNo)) = tToken
					Set tState = 2
				}
				ElseIf (tType="TOKEN") {
					Set pData(pNodeNo,$I(tIndexNo)) = $Case(tToken,"true":1,"false":0,:tToken)
					Set tState = 2
				}
				ElseIf (tType="OP")&&(tToken="]") {
					// empty array.  0th subcript means empty array
					Set pData(pNodeNo,0)=""
					Set tDone = 1					
				} Else {
					// error
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONArray,tToken,tState,..%Position)
				}
			}
			ElseIf (tState = 2) {
				If (tType="OP")&&(tToken="]") {
					// end of array
					Set tDone = 1
				}
				ElseIf ((tType="OP")&&(tToken=",")) {
					// next element
					Set tProp = tToken
					Set tState = 1
				}
				Else {
					// error
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONArray,tToken,tState,..%Position)
				}
			}

			If $$$ISERR(tSC) Quit
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Test if char is a JSON "operator" (delimiter).
ClassMethod %IsOperator(char As %String) As %Boolean [ CodeMode = expression, Internal ]
{
(char="{")||(char="}")||(char="[")||(char="]")||(char=",")||(char=":")
}

/// Test if char is whitespace.
ClassMethod %IsWhitespace(char As %String) As %Boolean [ CodeMode = expression, Internal ]
{
(char=" ")||(char=$C(10))||(char=$C(13))||(char=$C(9))
}

/// Read and return the next token from the input data.
Method %ReadNextToken(Output pType As %String, Output tSC As %Status) As %String [ Internal ]
{
#define MATCHHEXCHARS(%hex,%n) (%hex ? %n(1N,1(1"A",1"B",1"C",1"D",1"E",1"F",1"a",1"b",1"c",1"d",1"e",1"f")))

	Set tSC = $$$OK
	Set pType = "END"
	Set tToken = ""
	Set tTokenStream = $$$NULLOREF
	Set tDone = 0
	Set tState = 0
	Set ch = ""
	
	If (..%NextTokenType'="") {
		Set pType = ..%NextTokenType
		Set tToken = ..%NextToken
		Set ..%NextTokenType = ""
		Set ..%NextToken = ""
		Quit tToken
	}

	While ('tDone) {
		// read next character
		Set ch = ""
		Set tEscaped = 0
		If (..%NextChar'="") {
			// stashed
			Set ch = ..%NextChar
			Set ..%NextChar = ""
		}
		Else {
			// read character
			// use mini-fsm to look for escaped characters (\n etc.)
			Set tCharState = 0
			While (1) {
				If ($IsObject(..%JSON)) {
					// stream
	 				If (..%JSON.AtEnd) Quit
	 				While(1) {
						Set ch = ..%JSON.Read(1,.tSC)
						If $$$ISERR(tSC) Quit
					
						If (ch'="")||(..%JSON.AtEnd) {
							Quit
						}
	 				}
				}
				Else {
	 				If (..%Position > $L(..%JSON)) Quit
					Set ch = $E(..%JSON,..%Position)
				}
				Set ..%Position = ..%Position + 1

				If (tCharState=0) {
					If (ch="\") {
						Set tCharState = 1
					}
					Else {
						Quit
					}
				}
				ElseIf (tCharState=1) {
					If (ch = "u") {
						Set tUnicodeHex = ""
						Set tCharState = 2
					}
					// add special case support for \xNN escape sequences that are valid in Javascript
					ElseIf (ch = "x") {
						Set tHex = ""
						Set tCharState = 3
					}
					Else {
						// Support escape sequences defined in RFC 4627, as well as \'
						Set tEscaped = 1
						Set ch = $Case(ch, "\": "\", "'": "'", """": """", "/": "/", "b": $char(8), "f": $char(12), "n": $char(10), "r": $char(13), "t": $char(9), : "\" _ ch)
						Quit
					}
				}
				ElseIf (tCharState=2) {
					// in \uXXXX escape sequence
					Set tUnicodeHex = tUnicodeHex _ ch
					If ($length(tUnicodeHex) = 4) {
						#; Check that we do actually have a Hex value
						If $$$MATCHHEXCHARS(tUnicodeHex,4) {
							Set tUnicodeDecimal = $zhex(tUnicodeHex)
							Set ch = $char(tUnicodeDecimal)
						}
						Else {
							Set ch = "\u" _ tUnicodeHex
						}
						Quit
					}
				}
				ElseIf (tCharState=3) {
					// in \xNN escape sequence
					Set tHex = tHex _ ch
					If ($length(tHex) = 2) {
						#; Check that we do actually have a Hex value
						If $$$MATCHHEXCHARS(tHex,2) {
							Set tCodeDecimal = $zhex(tHex)
							Set ch = $char(tCodeDecimal)
						}
						Else { // Not a hex escape
							Set ch = "\x" _ tHex
						}
						Quit
					}
				}
			}
		}

		If (ch = "") {
			Set pType = "END"
			Quit
		}

		// token state
		If (tState = 0) {
			If ..%IsOperator(ch) {
				// delimiter "operator"
				Set pType = "OP"
				Set tToken = ch
				Set tDone = 1
			}
			ElseIf ($IsValidNum(ch)) {
				Set pType = "NUM"
				Set tToken = ch
				Set tState = 1
			}
			ElseIf ..%IsWhitespace(ch) {
				// ignore whitespace
			}
			ElseIf ('tEscaped)&&(ch="""") {
				Set pType = "STR"
				Set tToken = ""
				Set tState = 3
			}
			Else {
				// token
				Set pType = "TOKEN"
				Set tToken = ch
				Set tState = 2
			}
		}
		ElseIf (tState = 1) { // NUM
			If ($IsValidNum(ch) || (ch="E") || (ch="e")) {
				Set tToken = tToken _ ch
				If ('$IsValidNum(tToken)) {
					Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONNumber,tToken,..%Position)
					Quit
				}
			}
			ElseIf ((ch = ".")||(ch = "-")) {
				// we don't have to be perfect:
				// we will eventually figure out if this is a valid number
				Set tToken = tToken _ ch
			}
			ElseIf (..%IsWhitespace(ch)) {
				Set tDone = 1
			}
			ElseIf (..%IsOperator(ch)) {
				Set ..%NextChar = ch
				Set tDone = 1
			}
			Else {
				Set tSC = $$$ERROR($$$HSJSONErrInvalidJSONNumber,tToken,..%Position)
				Quit
			}
		}
		ElseIf (tState = 2) { // TOKEN
			If (..%IsWhitespace(ch)) {
				Set tDone = 1
			}
			ElseIf (..%IsOperator(ch)) {
				Set ..%NextChar = ch
				Set tDone = 1
			}
			Else {
				Set tToken = tToken _ ch
			}
		}
		ElseIf (tState = 3) { // STRING
			If ('tEscaped)&&(ch="""") {

				If pType="STREAM" {
					// NOTE: If we switched to a stream ... we need to flush any remaining output and switch tToken to the
					//       stream object
					Set tSC = tTokenStream.Write(tToken)
					
					// We'll return the stream as the token ... call will need to use $IsObject() on it
					Set tToken = tTokenStream
				}
				
				Set tDone = 1				
			}
			Else {
				If $L(tToken)+$L(ch)<$$$MaxLocalLength {
					// Append to the string token.  If pType is STREAM, we'll need to flush this when we are done
					Set tToken = tToken _ ch
				} Else {
					// We have reached the MAX string length of 3641144 (or 32768 if long strings are disabled).  We
					// cannot append any more without causing a <MAXSTRING> error.  So we must switch to writing to
					// a stream.
					
					If pType="STR" {
						Set tTokenStream = ##class(%Stream.TmpCharacter).%New()
						Set pType="STREAM"
					}
					
					// Flush the current token to the stream and continue with the current character
					Set tSC = tTokenStream.Write(tToken),tToken=ch
				}
			}
		}
	}
	Quit tToken
}

}
