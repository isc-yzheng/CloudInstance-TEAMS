Include HS.FHIRServer

Class HS.FHIRServer.Util.JsonHelper
{

/// The error text thrown by %DynamicObject %FromJSON can be obscure. This
/// method adds some text to the error from %FromJSON, to indicate the cause
/// (malformed JSON), and throws a FHIR-JSON-specific error code along with
/// the enhanced error text.
ClassMethod FromJSON(pJsonStreamOrString) As %DynamicObject
{
	Set status = $$$OK
	
	Try {
		Set json = ##class(%DynamicObject).%FromJSON(pJsonStreamOrString)
		If '$IsObject($Get(json)) {
			// It is unknown if json can be non-object at this point. Provide for
			// it anyway. Most likely an exception will already have been thrown.
			$$$ThrowStatus( $$$ERROR($$$GeneralError, "Could not create object from FHIR JSON stream")) 
		}
	} Catch eException {
		Set json = ""
		Set status = eException.AsStatus()
		// 5035 is the general exception code from %FromJSON().
		// Error text shows the internal error code, plus "Data" which seems to always only show as ''.
		// For example, "General exception Name 'Parsing error' Code '3' Data ''"
		// See %PVA.inc for the list of error Codes and meaning.
		If $system.Status.GetErrorCodes(status)=5035 {
			Do $system.Status.DecomposeStatus(status, .errorInfo)
			Set tFromJSONText = $Get(errorInfo(1,"param",1))
			Set tFromJSONCode = $Get(errorInfo(1,"param",2))
			Set tErrorText = ""
			If tFromJSONText'="" {
				Set tErrorText = tErrorText _ tFromJSONText
				If tFromJSONCode'="" Set tErrorText = tErrorText _ ", "
			}
			If tFromJSONCode'="" {
				Set tErrorText = tErrorText _ "Code "_tFromJSONCode
			}
			If tErrorText'="" Set tErrorText = tErrorText _ ":"
			// Throw a FHIR-JSON-specific error, with the error text from %FromJSON, plus additional text.
			$$$ThrowFHIR( $$$HSFHIRErrInvalidJsonContent, tErrorText, $$$OutcomeIs(400, "error", "invalid") )
		}
	}
	
	$$$ThrowOnError(status)
	
	Return json
}

ClassMethod ToJSONString(pJson As %DynamicAbstractObject, pIndentString As %String = "", pLineTerminator As %String = "") As %String
{
	Do ..ToJSONStream(pJson, .stream, pIndentString, pLineTerminator)
	return ##class(HS.Util.StreamUtils).EnsureString(stream)
}

ClassMethod ToJSONStream(pJson As %DynamicAbstractObject, ByRef pOutputStream, pIndentString As %String = "", pLineTerminator As %String = "")
{
	#define FlushToStream Do pOutputStream.Write(%perfBuffer)  Set %perfBuffer=""
	// Ensure that there is an Output stream
	If '$IsObject($Get(pOutputStream)) {
		Set pOutputStream = ##class(%Stream.TmpCharacter).%New()
	} elseif 'pOutputStream.%IsA("%Stream.Object") {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"If specified, pOutputStream must be a %Stream.Object"))
	}
	// If no indent or line-terminator, then optimize by using the built-in conversion
	if (pIndentString="") && (pLineTerminator="") {
		Do pJson.%ToJSON(pOutputStream)
		return	
	}

	Set %perfBuffer = ""
	Set %maxSize = 10000
	if pJson.%IsA("%DynamicObject") {
		Do ..PrettyObject(pJson, "object", pOutputStream, "", pIndentString, pLineTerminator)
	} elseif pJson.%IsA("%DynamicArray") {
		Do ..PrettyObject(pJson, "array", pOutputStream, "", pIndentString, pLineTerminator)
	} else {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"pJson must be a %DynamicObject or %DynamicArray"))
	}
	$$$FlushToStream
}

ClassMethod PrettyObject(pJson As %DynamicAbstractObject, pType As %String, pOutputStream As %Stream, prefix As %String, indent As %String, lineEnd As %String) [ Private ]
{
	
	#def1arg DBG(%str) w:..#DEBUG %str,!
	#define FlushToStream Do pOutputStream.Write(%perfBuffer)  Set %perfBuffer=""
	#define EmitToStream(%str) Set %perfBuffer=%perfBuffer_%str ##Continue
			if ($Length(%perfBuffer) >= %maxSize) { $$$FlushToStream }
	#define Emit(%prefix, %str) $$$EmitToStream(%prefix_%str)
	#define Quote(%str) """"_%str_""""
	#define StartNextLine(%comma, %prefix, %str)               $$$EmitToStream(%comma_lineEnd_%prefix_%str)
	#define EmitProperty(%comma, %prefix, %name, %value)       $$$StartNextLine(%comma, %prefix, $$$Quote(%name)_":"_%value)
	#define EmitStringProperty(%comma, %prefix, %name, %value) $$$StartNextLine(%comma, %prefix, $$$Quote(%name)_":"_$$$Quote(%value))
	#define EmitNL(%str) $$$EmitToStream(%str_..lineEnd)
	
	//Set lineEnd = $C(13,10)
	Set comma = ""
	Set curPrefix = prefix _ indent
	
	if pType="object" {
		$$$Emit("", "{")
		Set iter = pJson.%GetIterator()
		while iter.%GetNext(.key , .value ) {
			Set propType = pJson.%GetTypeOf(key)
			if propType = "string" {
				$$$EmitStringProperty(comma, curPrefix, key, $ZConvert(value,"O","JSON"))
			} elseif propType="number" {
				$$$EmitProperty(comma, curPrefix, key, value)
			} elseif propType="object" {
				$$$EmitProperty(comma, curPrefix, key, "")
				Do ..PrettyObject(value, propType, pOutputStream, curPrefix, indent, lineEnd)
			} elseif propType="array" {
				$$$EmitProperty(comma, curPrefix, key, "")
				Do ..PrettyObject(value, propType, pOutputStream, curPrefix, indent, lineEnd)
			} elseif propType="boolean" {
				Set bval = $Case(value, "0":"false", "1":"true", "true":"true", "false":"false", :"false")
				$$$EmitProperty(comma, curPrefix, key, bval)
			} elseif propType="null" {
				$$$EmitProperty(comma, curPrefix, key, "null")
			}
			Set comma = ","
		}
		$$$StartNextLine("", prefix, "}")
	} else {
		$$$Emit("", "[")
		Set iter = pJson.%GetIterator()
		while iter.%GetNext(.key , .value ) {
			Set propType = pJson.%GetTypeOf(key)
			if propType = "string" {
				$$$StartNextLine(comma, curPrefix, $$$Quote($ZConvert(value,"O","JSON")))
			} elseif propType="number" {
				$$$StartNextLine(comma, curPrefix, value)
			} elseif propType="object" {
				$$$StartNextLine(comma, curPrefix, "")
				Do ..PrettyObject(value, propType, pOutputStream, curPrefix, indent, lineEnd)
			} elseif propType="array" {
				$$$StartNextLine(comma, curPrefix, "")
				Do ..PrettyObject(value, propType, pOutputStream, curPrefix, indent, lineEnd)
			} elseif propType="boolean" {
				Set bval = $Case(value, "0":"false", "1":"true", "true":"true", "false":"false", :"false")
				$$$StartNextLine(comma, curPrefix, bval)
			} elseif propType="null" {
				$$$StartNextLine(comma, curPrefix, "null")
			}
			Set comma = ","
		}
		$$$StartNextLine("", prefix, "]")
	}
}

}
