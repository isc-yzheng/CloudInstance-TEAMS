Include HS.JSON

/// 
/// Utility class for writing JSON
/// 
Class HS.JSON.Writer [ System = 3 ]
{

/// 
/// The '%WriteJSON' method writes any value to JSON, regardless of it's type (scalar or object type).
/// 
/// It will handle the following types of value:
///     0) Scalar values
/// 	1) HS.JSON.Adapter: Calls %ToJSON() to export it (if pUseHSJSON is true)
/// 	2) HS.JSON.AdapterFHIR: Calls %ToFHIRJSON() to export it
/// 	3) %ZEN.proxyObject: Calls %ToJSON() to export it
/// 	4) %Document.Object: Calls ToJSON() to export it 
/// 	5) %ListOfXXX: Writes a JSON list with each element; recursively calls %WriteJSON() on values
/// 	6) %ArrayOfXXX: Writes a JSON hash with each key/element; recursively calling %WriteJSON() to export values
/// 	7) Dynamic Object/Array (%Object/%Array or %DynamicObject/%DynamicArray): Calls $toJSON/%ToJSON to export it
/// 	8) Any other object: Uses the class dictionary metadata to emit the object; recursively calls %WriteJSON() to export values
/// 
ClassMethod %WriteJSON(pValue, pLevel As %Integer = 0, pUseHSJSON As %Boolean = 0) As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		
		Set tStatus = $SELECT(
		
			// Handle scalar values
			'$IsObject(pValue)								:..%WriteJSONScalar(pValue),
			
			// Composable objects
			pValue.%Extends("HS.JSON.Composable")			:..%WriteJSONObject(pValue,pLevel),
									  
			// Handle the multitude of JSON container objects
			pValue.%Extends("HS.JSON.Adaptor")&&pUseHSJSON	:pValue.%ToJSON(pLevel),
			pValue.%Extends("HS.JSON.AdaptorFHIR")			:pValue.%ToFHIRJSON(pLevel),
			pValue.%IsA("%ZEN.proxyObject")					:..%WriteJSONProxy(pValue,pLevel),
			pValue.%IsA("%Document.Object")					:pValue.%ToJSON(pLevel),
						 
			// Handle collection types
			pValue.%Extends("%Collection.AbstractList")		:..%WriteJSONList(pValue, pLevel),
			pValue.%Extends("%Collection.AbstractArray")	:..%WriteJSONArray(pValue, pLevel),
			
			// Handle streams
			pValue.%Extends("%Stream.Object")				:..%WriteJSONStream(pValue),
			
			// Handle dynamic objects
			$$$HSJsonIsSupported && pValue.%Extends($$$HSJsonQuotedClassAbstract)
															:..%WriteJSONDynamicObject(pValue, pLevel),
			
			// Finally, use brute force
			1												:..%WriteJSONObject(pValue,pLevel)
		)
		
		Quit:$$$ISERR(tStatus)
		
		WRITE:pLevel=0 !
		
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Write a value to a stream as JSON.  This method simply wraps ..%WriteJSON() with I/O redirection in order to
/// capture the output to a stream.  The caller may specify the stream to avoid any additional copying, otherwise,
/// one will be created.
/// 
ClassMethod %CaptureWriteJSONToStream(pValue, ByRef pStream As %Stream.Object, pRewindStream As %Boolean = 0) As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		Set:'$IsObject($G(pStream)) pStream=##class(%Stream.TmpBinary).%New()
		
		Set tStatus = ..%CaptureWriteJSON(pValue,pStream)
		Quit:$$$ISERR(tStatus)
		
		If pRewindStream {
			Do pStream.Rewind()
		}
		
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Write a value to a string/stream as JSON.  This method simply wraps ..%WriteJSON() with redirection to an XDEV device
/// capture the output to a stream.  The caller may specify the stream to avoid any additional copying, otherwise,
/// one will be created.
/// 
ClassMethod %CaptureWriteJSON(pValue, ByRef pOutput, pStringBuffer As HS.JSON.StringBuffer = {$$$NULLOREF}) As %Status
{
	Quit ..%CaptureWriteJSONXDEV(pValue,.pOutput,pStringBuffer)
}

/// 
/// This approach is deprecated, but has been left for reference:
/// Write a value to a string/stream as JSON.  This method simply wraps ..%WriteJSON() with I/O redirection in order to
/// capture the output to a stream.  The caller may specify the stream to avoid any additional copying, otherwise,
/// one will be created.
/// 
/// The new approach using XDEV is faster and avoids <PROTECT> errors that may result due to the reset to login roles
/// during WRITE when I/O redirection is enabled.
/// 
/// 
/// Write a value to a string/stream as JSON.  This method simply wraps ..%WriteJSON() with redirection to an XDEV device
/// capture the output to a stream.  The caller may specify the stream to avoid any additional copying, otherwise,
/// one will be created.
/// 
ClassMethod %CaptureWriteJSONXDEV(pValue, ByRef pOutput, pStringBuffer As HS.JSON.StringBuffer = {$$$NULLOREF}) As %Status [ Internal ]
{
	#dim ex As %Exception.AbstractException
	#dim tSC As %Status = $$$OK
	
	If '$IsObject(pStringBuffer) {
		Set pStringBuffer = ##class(HS.JSON.StringBuffer).%New()
	}
	
	Try {
		Set tSC = pStringBuffer.BeginCaptureOutput()
		If $$$ISERR(tSC) {
			Quit
		}
		
		// Use %WriteJSON to write the JSON
		Set tSC = ..%WriteJSON(pValue)
		If $$$ISERR(tSC) {
			Quit
		}
		
		If $IsObject($Get(pOutput)) {
			Set tSC = pStringBuffer.ReadToStream(.pOutput)
		} Else {
			Set tSC = pStringBuffer.ReadToString(.pOutput)
		}
		If $$$ISERR(tSC) {
			Quit
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Do pStringBuffer.EndCaptureOutput()
	
	Quit tSC
}

/// 
/// Emit a JSON scalar value
/// 
ClassMethod %WriteJSONScalar(pScalar, pTypeHint As %String = "") As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {

		If pTypeHint="" {
			// Detect the type ...
			Set pTypeHint = $SELECT(
			
				pScalar?1.N											:"INTEGER",
				pScalar?1.N1"."1.N									:"DECIMAL",
				pScalar?4N1"-"2N1"-"2N1" "2N1":"2N1":"2N.1(1"."1.N)	:"TIMESTAMP",
				$TR(pScalar,$C(13,10,9))?.E1.C.E					:"BINARY",
				
				// Default will produce a string ...
				1													:""
			)
		}
		
		WRITE $CASE(pTypeHint,   "BOOLEAN":$S(pScalar="":"null", +pScalar:"true", 1:"false"),
							      "DOUBLE":$S(pScalar="":"null", 1:$FN(pScalar,"LON")),
							     "DECIMAL":$S(pScalar="":"null", 1:$FN(pScalar,"LON")),
							     "INTEGER":$S(pScalar="":"null", 1:$FN(pScalar,"LON",0)),
							   "TIMESTAMP":..%JSONStr(pScalar),
							      "BINARY":..%JSONStr($system.Encryption.Base64Encode(pScalar)),
							              :..%JSONStr(pScalar))
					
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Emit a JSON list
/// 
ClassMethod %WriteJSONList(pList As %Collection.AbstractList, pLevel As %Integer = 0, pTypeHint As %String = "") As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tIndex As %Integer
		#dim tElement

		Write "["
		
		For tIndex=1:1:pList.Count() {
			If tIndex>1 {
				Write ","
	
				If pTypeHint'="OBJECT" {
					Write " "
				}
			}
			
			Set tElement = pList.GetAt(tIndex)
			
			Set tStatus = $SELECT('$IsObject(tElement):..%WriteJSONScalar(tElement,pTypeHint),
								                     1:..%WriteJSON(tElement,pLevel))
			Quit:$$$ISERR(tStatus)
		}

		Write "]"
		
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Emit a JSON array (hash)
/// 
ClassMethod %WriteJSONArray(pArray As %Collection.AbstractArray, pLevel As %Integer = 0, pTypeHint As %String = "") As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tCount As %Integer
		#dim tKey
		#dim tElement


		Set tCount = 0
		Set pLevel = pLevel + 1

		Write ..%Tab(pLevel-1),"{"

		Set tKey = ""
		For {
			Set tElement = pArray.GetNext(.tKey)
			Quit:tKey=""
			
			Write:tCount>0 ","
			Write !,..%Tab(pLevel),..%JSONKey(tKey)
			
			Set tStatus = $SELECT('$IsObject(tElement):..%WriteJSONScalar(tElement,pTypeHint),
								                     1:..%WriteJSON(tElement,pLevel))
			Quit:$$$ISERR(tStatus)
			
			Set tCount = tCount + 1
		}
		
		If tCount>0 {
			Write !,..%Tab(pLevel-1)
		}
		
		Write "}"
		
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Emit a stream as JSON.  Note: binary streams will be base64 encoded; character streams will be escaped appropriately
/// 
ClassMethod %WriteJSONStream(pStream As %Stream.Object, pLevel As %Integer = 0) As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tReadMax As %Integer = ($$$MaxLocalLength\2)
		#dim tBinary As %Boolean = 0
		
		
		If $CLASSNAME(pStream)["Binary" {
			// This is a binary stream ... we must Base64 encode it.
			Set tBinary = 1
			// Adjust read length to ensure we chunk the Base64 encoding correctly for large streams
			// 57 is the number of bytes needed to produce a 76-character line of base64 encoded data
			Set tReadMax = tReadMax - (tReadMax#57)
		}
		
		Write """"

		Do pStream.Rewind()
		While 'pStream.AtEnd {
			
			#dim tChunk As %String
			
			Set tChunk = pStream.Read(tReadMax,.tStatus)
			Quit:$$$ISERR(tStatus)
			
			Write ..%JSON($S(tBinary:$system.Encryption.Base64Encode(tChunk),1:tChunk))
		}
		
		Write """"

	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Emit a JSON object (i.e. a non-%ToJSON() object).  This is accomplished by walking the class's metadata and using
/// that to generate the JSON.  Note that the client type of any datatype property is used to determine how to emit
/// the value (e.g. BOOLEAN is true/false ... see ..%WriteJSONScalar).
/// 
ClassMethod %WriteJSONObject(pObject As %RegisteredObject, pLevel As %Integer = 0) As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tCount As %Integer


		Set tCount = 0
		Set pLevel = pLevel + 1
		
		Write ..%Tab(pLevel-1),"{"
		
		If pObject.%Extends("HS.JSON.Composable") {
			
			#dim tKey As %String
			#dim tComponent
			
			Set tKey = ""
			For {
				Set tComponent = pObject.GetNext(.tKey)
				Quit:tKey=""
				
				// Types that we can compose ... any concrete objects, or a %ZEN.proxyObject
				Set tStatus = $SELECT(
				
					tComponent.%IsA("%ZEN.proxyObject"):..emitJSONProxyBody(tComponent, pLevel, .tCount),
													  1:..emitJSONObjectBody(tComponent, pLevel, .tCount)
													  
				)
				
				Quit:$$$ISERR(tStatus)					
			}
			
			Quit:$$$ISERR(tStatus)
			
		} Else {
			// Not composable ...
			Set tStatus = ..emitJSONObjectBody(pObject, pLevel, .tCount)
			Quit:$$$ISERR(tStatus)
		}
		
		If tCount>0 {
			Write !,..%Tab(pLevel-1)
		}
		
		Write "}"
		
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Emit a dynamic object (%Object/%Array or %DynamicObject/%DynamicArray).
/// No pretty formatting is applied.
/// 
ClassMethod %WriteJSONDynamicObject(pObject As %SystemBase, pLevel As %Integer = 0) As %Status [ Internal ]
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		Write !,..%Tab(pLevel)
		
		If ($IsObject($Get(%ISCJSONOutput)) && ##class(%Library.Device).ReDirectIO()) {
			// As an optimization, output directly to the stream if one is in use (rather than using I/O redirection, which will be slower).
			Do pObject.$$$HSJsonMethodToJSON(%ISCJSONOutput)
		} Else {
			// Otherwise, output to the current device.
			// This should eventually use Do rather than Write, but can't in 2016.x due to a bug (PL 139021).
			Write pObject.$$$HSJsonMethodToJSON()
		}
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	Quit tStatus
}

/// 
/// Emit a JSON object (i.e. a non-%ToJSON() object).  This is accomplished by walking the class's metadata and using
/// that to generate the JSON.  Note that the client type of any datatype property is used to determine how to emit
/// the value (e.g. BOOLEAN is true/false ... see ..%WriteJSONScalar).
/// 
ClassMethod emitJSONObjectBody(pObject As %RegisteredObject, pLevel As %Integer = 0, ByRef pCount As %Integer) As %Status [ Internal ]
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tClass As %String = $CLASSNAME(pObject)
		#dim tShowEmpty As %Boolean = +$PARAMETER(tClass,"JSONSHOWEMPTY")
		#dim tProperty As %String
		#dim tJSONName As %String
		#dim tProjection As %String
		#dim tElement

		
		Write:pCount>0 ","
		Write !,..%Tab(pLevel),..%JSONKey("_class"),..%JSONStr(tClass)
		Set pCount = pCount + 1
		
		// Some persistent (registered) objects are used as transient containers by web services:
		//    1.  do not return a value for %Id()
		//    2.  do not have a property "%id"
		// If a client submits JSON returned by a GET for a subsequent PUT that contains any elements like the following: "_id" : "",
		// Then %ReadJSON throws an error as follows:
		//    <PROPERTY DOES NOT EXIST> 149 %ResolveObject+42^HS.JSON.Reader.1 %id,HS.Registry.Person.User.WebServices.Containers.User
		// Suppress writing the "_id" property when the %Id() method returns the empty string.
		If ($$$classIsPersistent(tClass)) && (pObject.%Id() '= "") {
			// This is a persistent class
			Write:pCount>0 ","
			Write !,..%Tab(pLevel),..%JSONKey("_id")
			Set tStatus = ..%WriteJSONScalar(pObject.%Id(),$S(pObject.%Id()?1.N:"INTEGER",1:""))
			Quit:$$$ISERR(tStatus)
			
			Set pCount = pCount + 1
		}	
	
		// Now, convert the object itself by walking the properties
		Set tProperty = ""
		For {
			Set tProperty = $$$comMemberNext(tClass,$$$cCLASSproperty,tProperty)
			Quit:tProperty=""
			
			Set tProjection = $ZCVT($$$comMemberArrayGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPparameter,"JSONPROJECTION"),"U")
			If (tProjection="") && ($ZCVT($$$comMemberArrayGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPparameter,"XMLPROJECTION"),"U")="NONE") {
				Set tProjection = "NONE"
			}

			// Ignore various types of properties:
			//   JSONPROJECTION or XMLPROJECTION=NONE
			//   %% properties
			//   Private
			//   Internal
			//   Multidimensional
			//
			If (tProjection = "NONE")
			  || ($extract(tProperty,1,2) = "%%")
			  || $$$comMemberKeyGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPprivate)
			  || $$$comMemberKeyGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPinternal)
			  || $$$comMemberKeyGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPmultidimensional) {

				Continue
			}

			// Fetch the property value ...
			Set tElement = $PROPERTY(pObject,tProperty)
			If tElement="" && 'tShowEmpty {
				// Ignore empty values (note we still show empty lists and arrays)
				Continue
			}
						
			// Look for a JSONNAME parameter
			Set tJSONName = $$$comMemberArrayGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPparameter,"JSONNAME")
			If tJSONName="" {
				// By default, convert % name prefixes to _
				Set tJSONName = $S($E(tProperty,1)="%":"_"_$E(tProperty,2,*),1:tProperty)
			}
			
			#dim tType As %String
			#dim tClsType As %String
			#dim tClientType As %String
			#dim tCollection As %String
			
			Set tType = $$$comMemberKeyGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPtype)
			Set tClsType = $$$getClassType(tType)

			Set tCollection = $$$comMemberKeyGet(tClass,$$$cCLASSproperty,tProperty,$$$cPROPcollection)
			
			Set tClientType = $CASE(tClsType,   $$$cCLASSCLASSTYPEDATATYPE:$$$defClassKeyGet(tType,$$$cCLASSclientdatatype),
											  $$$cCLASSCLASSTYPEPERSISTENT:"OBJECT",
											      $$$cCLASSCLASSTYPESERIAL:"OBJECT",
											      $$$cCLASSCLASSTYPESTREAM:"STREAM",
											      						  :"")
									
#if 0		// Don't enable as it'll break the AngularJS UIs
			If (tClientType="OBJECT") && (tCollection="") && (tShowEmpty=0) {
				// Omit empty objects
				Continue:tElement.%IsEmpty() 
			}
#endif

			// Write out the key
			Write:pCount>0 ","
			Write !,..%Tab(pLevel),..%JSONKey(tJSONName)

			// Write out the value			
			Set tStatus = $SELECT('$IsObject(tElement):..%WriteJSONScalar(tElement,tClientType),
								                     1:..%WriteJSON(tElement,pLevel))
			Quit:$$$ISERR(tStatus)
			
			Set pCount = pCount + 1
		}

	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Emit a %ZEN.proxyObject
/// 
ClassMethod %WriteJSONProxy(pProxy As %ZEN.proxyObject, pLevel As %Integer = 0) As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {

		#dim tCount As %Integer


		Set tCount = 0
		Set pLevel = pLevel + 1
		
		Write ..%Tab(pLevel-1),"{"
		
		Set tStatus = ..emitJSONProxyBody(pProxy, pLevel, .tCount)
		Quit:$$$ISERR(tStatus)

		If tCount>0 {
			Write !,..%Tab(pLevel-1)
		}
		
		Write "}"
					
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Emit a %ZEN.proxyObject object body
/// 
ClassMethod emitJSONProxyBody(pProxy As %ZEN.proxyObject, pLevel As %Integer = 0, ByRef pCount As %Integer) As %Status
{
	#dim tException As %Exception.AbstractException
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tProperty As %String
		#dim tJSONName As %String
		#dim tElement

		// Iterate over the contents of the proxyObject
		Set tProperty = ""
		For {
			Set tProperty = $ORDER(pProxy.%data(tProperty))
			Quit:tProperty=""
			
			Set tJSONName = $S($E(tProperty,1)="%":"_"_$E(tProperty,2,*),1:tProperty)
			
			// Fetch the property value ...
			Set tElement = $PROPERTY(pProxy,tProperty)
			
			// Write out the key
			Write:pCount>0 ","
			Write !,..%Tab(pLevel),..%JSONKey(tJSONName)

			// Write out the value			
			Set tStatus = $SELECT('$IsObject(tElement):..%WriteJSONScalar(tElement),
								                     1:..%WriteJSON(tElement,pLevel))
			Quit:$$$ISERR(tStatus)
			
			Set pCount = pCount + 1			
		}
					
	} Catch (tException) {
		Set tStatus = tException.AsStatus()
	}
	
	Quit tStatus
}

/// 
/// Generate a suitable indent (use spaces, not tabs)
/// 
ClassMethod %Tab(pLevel As %Integer, pTabSize As %Integer = 4) As %String [ CodeMode = expression ]
{
$J("",(pTabSize*pLevel)-$X)
}

/// 
/// Generate a  properly escaped and quoted JSON string
/// 
ClassMethod %JSONStr(pStr As %String) As %String [ CodeMode = expression ]
{
""""_..%JSON(pStr)_""""
}

/// 
/// Generate a properly escaped and quoted JSON object key
/// 
ClassMethod %JSONKey(pKey As %String) As %String [ CodeMode = expression ]
{
""""_..%JSON(pKey)_""": "
}

/// 
/// Helper to convert any string value into a JSON-safe string value
/// 
ClassMethod %JSON(pStr As %String) As %String [ CodeMode = expression ]
{
$ZCVT(pStr,"O","JSON")
}

}
