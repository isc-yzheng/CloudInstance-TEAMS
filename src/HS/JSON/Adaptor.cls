Include (%ZEN.Utils, %occInclude)

/// Adds specialized JSON capabilities to classes.
Class HS.JSON.Adaptor [ Abstract, PropertyClass = HS.JSON.PropertyParameters, System = 2 ]
{

/// Name of field in emitted JSON that holds the type (classname) for objects.
Parameter JSONTYPEFIELD As STRING = "_class";

/// If true, emit JSON for empty (non-collection) properties.
Parameter JSONSHOWEMPTY As BOOL = 1;

/// Name of field in emitted JSON that holds the object's ID field (i.e. returned from ..%Id()).
/// If this field is not defined, or if the class is not persistent, the value is not emitted.
Parameter JSONIDFIELD As STRING;

/// Return the value to be used within the JSONTYPEFIELD.
ClassMethod %GetJSONType() As %String
{
	Quit $classname($this)
}

/// Write out this object's current value as JSON content.
/// <var>pFormat</var> is ignored; it is only there for compatability with the %ZEN.proxyObject
/// %ToJSON method.
Method %ToJSON(pLevel As %Integer = 0, pFormat As %String = "aelotw") As %Status [ CodeMode = objectgenerator ]
{
	Set tShowEmpty = +$G(%parameter("JSONSHOWEMPTY"))

	If (%class.Abstract) {
		Quit $$$OK
	}
	Do %code.WriteLine(" Set tSC = $$$OK")
	Do %code.WriteLine(" Try {")
	Do %code.WriteLine("  Set tTab0 = """"")
	Do %code.WriteLine("  Set:pLevel>0 tTab0 = $TR($J($C(9),pLevel),"" "",$C(9))")
	Do %code.WriteLine("  Set tTab = $TR($J($C(9),pLevel+1),"" "",$C(9))")

	// get count of JSON properties; sort by sequence
	Set tSkipList("%Concurrency") = 1
	Set tPropCount = 0
	For n=1:1:%compiledclass.Properties.Count() {
		Set tPropDef = %compiledclass.Properties.GetAt(n)
		
		Set XMLPROJECTION = tPropDef.Parameters.GetAt("XMLPROJECTION")
		Set JSONPROJECTION = tPropDef.Parameters.GetAt("JSONPROJECTION")
		If ((JSONPROJECTION="")&&($$$UPPER(XMLPROJECTION)="NONE")) {
			// default to XML setting
			Set JSONPROJECTION ="NONE"
		}

		If ('$D(tSkipList(tPropDef.Name))&&($$$UPPER(JSONPROJECTION)'="NONE")&&($E(tPropDef.Name,1,2)'="%%")) {
			If ('+tPropDef.MultiDimensional) {
				// skip multidimensional
				Set tPropCount = tPropCount + 1
				Set tPropList(tPropDef.SequenceNumber,tPropCount) = tPropDef
			}
		}
	}

	Do %code.WriteLine("  Write tTab0,""{"",!")
	Do %code.WriteLine("  Set pc=0")	// count of emitted properties

	// emit type field
	Set tTypeField = $G(%parameter("JSONTYPEFIELD"),"_class")
	If (tTypeField'="") {
		Set tTypeField = $zconvert(tTypeField,"O","JSON")
		Set tTypeExpr = "$zconvert(..%GetJSONType(),""O"",""JSON"")"

		Do %code.WriteLine("  Write tTab,"""""""_tTypeField_""""":"""""","_tTypeExpr_",""""""""")
		Do %code.WriteLine("  Set pc=pc+1")
	}
	Set tIDField = $G(%parameter("JSONIDFIELD"))
	If (tIDField'="") && (%compiledclass.ClassType = $$$cCLASSCLASSTYPEPERSISTENT) {
		Set tIDField = $zconvert(tIDField,"O","JSON")
		Set tIDExpr = "$zconvert(..%Id(),""O"",""JSON"")"
		Do %code.WriteLine("  If (..%Id() '= """") {")
		Do %code.WriteLine("    Write:pc "","",!")
		Do %code.WriteLine("    Write tTab,"""""""_tIDField_""""":"""""","_tIDExpr_",""""""""")
		Do %code.WriteLine("    Set pc=pc+1")
		Do %code.WriteLine("  }")
	}

	Set s = $O(tPropList(""))
	While (s'="") {
		Set k = $O(tPropList(s,""),1,tPropDef)
		While (k'="") {

			Set JSONNAME = tPropDef.Parameters.GetAt("JSONNAME")
			Set JSONSUMMARY = tPropDef.Parameters.GetAt("JSONSUMMARY")
			// replace % with _ in names (unless JSONNAME is defined)
			Set tPropName = $S(JSONNAME'="":JSONNAME,1:$TR(tPropDef.Name,"%","_"))
			Set tPropName = $zconvert(tPropName,"O","JSON")
			Set tPropType = tPropDef.Type

			// wrap loop around collection properties
			If (tPropDef.Collection="list") {

				Do %code.WriteLine("  Set tCount=.."_tPropDef.Name_".Count()")
				If ('tShowEmpty) {
					Do %code.WriteLine("  If (tCount) {")
				}

				Do %code.WriteLine("  Write:pc "","",!")
				Do %code.WriteLine("  Set pc=pc+1")

				Set tVar = "tVal"
				Do %code.WriteLine("  Write tTab,"""""""_tPropName_""""":[""")

				Do %code.WriteLine("  For n=1:1:tCount {")
				Do %code.WriteLine("   Set tVal=.."_tPropDef.Name_".GetAt(n)")
				If ($$$classIsDataType(tPropType)) {
					Do %code.Write("   Write ")
				}
			}
			ElseIf (tPropDef.Collection="array") {
				Do %code.WriteLine("  Write:pc "","",!")
				Do %code.WriteLine("  Set pc=pc+1")

				Set tVar = "tVal"
				Set tKeyName = "key"
				Set tValueName = "value"
				Set tKeyName = $zconvert(tKeyName,"O","JSON")
				Set tValueName = $zconvert(tValueName,"O","JSON")

				Do %code.WriteLine("  Write tTab,"""""""_tPropName_""""":[""")

				Do %code.WriteLine("  Set tKey=""""")
				Do %code.WriteLine("  Set tVal=.."_tPropDef.Name_".GetNext(.tKey)")
				Do %code.WriteLine("  While (tKey'="""") {")
				Do %code.WriteLine("   Write ""{"""""_tKeyName_""""":"""""",$zconvert(tKey,""O"",""JSON""),"""""","","""""""_tValueName_""""""","":""")

				If ($$$classIsDataType(tPropType)) {
					Do %code.Write("   Write ")
				}
			}
			Else {
				// use property directly
				Set tVar = ".."_$S($ZName(tPropDef.Name):tPropDef.Name,1:""""_tPropDef.Name_"""")

				If ('tShowEmpty) {
					If ('$$$classIsStream(tPropType)) {
						Do %code.WriteLine("  If ("_tVar_"'="""") {")
					}
					Else {
						Do %code.WriteLine("  If ($IsObject("_tVar_")&&"_tVar_".Size) {")
					}
				}
				Do %code.WriteLine("  Write:pc "","",!")
				Do %code.WriteLine("  Set pc=pc+1")
				Do %code.Write("  Write tTab,"""""""_tPropName_""""":""")
			}

			If ($$$classIsStream(tPropType)) {
				If (tPropType["Binary") {
					// use base64
					Do %code.WriteLine("   Set tSC = ..%StreamToJSON("_tVar_",1)")
				}
				Else {
					Do %code.WriteLine("   Set tSC = ..%StreamToJSON("_tVar_")")
				}
				Do %code.WriteLine("   Quit:$$$ISERR(tSC)")

				If (tPropDef.Collection="list") {
					// comma for list items
					Do %code.WriteLine("  Write $S(n<tCount:"","",1:"""")")
				}
			}
			ElseIf ('$$$classIsDataType(tPropType)) {
				// object
				If (JSONSUMMARY'="") {
					Do %code.WriteLine("")
					Do %code.WriteLine("  If ('$IsObject("_tVar_")) {")
					Do %code.WriteLine("   Write ""null""")
					Do %code.WriteLine("  } Else {")
					Do %code.WriteLine("   Write """""""",$zconvert("_tVar_"."_JSONSUMMARY_",""O"",""JSON""),""""""""")
					Do %code.WriteLine("  }")
				}
				Else {
					Do %code.WriteLine("")
					Do %code.WriteLine("  If ('$IsObject("_tVar_")) {")
					Do %code.WriteLine("   Write ""null""")
					Do %code.WriteLine("  } Else {")
					Do %code.WriteLine("   Write !")

					// place a trap around this to catch references to non-JSON enabled objects
					Do %code.WriteLine("   Try {")
					Do %code.WriteLine("    Set tSC2 = "_tVar_".%ToJSON(pLevel+1,pFormat)")
					Do %code.WriteLine("   }")
					Do %code.WriteLine("   Catch(ex) {")
					Do %code.WriteLine("    Set tSC2 = ex.AsStatus()")
					Do %code.WriteLine("   }")
					// write out error as JSON
					If (1) {
						Do %code.WriteLine("  Write:$$$ISERR(tSC2) """""""",$ZCVT($System.Status.GetErrorText(tSC2),""O"",""JSON""),""""""""")
					}
					Do %code.WriteLine("  }")
				}

				If (tPropDef.Collection="list") {
					// comma for list items
					Do %code.WriteLine("  Write $S(n<tCount:"","",1:"""")")
				}
				ElseIf (tPropDef.Collection="array") {
					Do %code.WriteLine("  Write !,tTab0,""}""")
					Do %code.WriteLine("   Set tVal=.."_tPropDef.Name_".GetNext(.tKey)")
					// comma for array items
					Do %code.WriteLine("   Write:(tKey'="""") "",""")
				}
			}
			Else {
				// comma in write statement
				If (tPropDef.Collection="") {
					Do %code.Write(",")
				}

				Set tClientType = $$$comClassKeyGet(tPropType,$$$cCLASSclientdatatype)
				
				If (tClientType = "BOOLEAN") {
					// convert to true/false
					Do %code.Write("$S("_tVar_"="""":""null"",+"_tVar_":""true"",1:""false"")")
				}
				ElseIf (tClientType = "DOUBLE")||(tClientType = "DECIMAL") {
					Do %code.Write("$S("_tVar_"="""":""null"",1:$FN("_tVar_",""LON""))")
				}
				ElseIf (tClientType = "INTEGER") {
					Do %code.Write("$S("_tVar_"="""":""null"",1:$FN("_tVar_",""LON"",0))")
				}
				ElseIf (tClientType = "TIMESTAMP") {
					Do %code.Write(""""""""",$ZCVT("_tVar_",""O"",""JSON""),""""""""")
				}
				ElseIf (tClientType = "BINARY") {
					// base64
					Do %code.Write(""""""""",$zconvert($system.Encryption.Base64Encode("_tVar_"),""O"",""JSON""),""""""""")
				}
				Else {
					// string
					Do %code.Write(""""""""",$ZCVT("_tVar_",""O"",""JSON""),""""""""")
				}

				If (tPropDef.Collection="list") {
					// comma for list items
					Do %code.WriteLine(",$S(n<tCount:"","",1:"""")")
				}
				ElseIf (tPropDef.Collection="array") {
					Do %code.WriteLine(",""}""")
					Do %code.WriteLine("   Set tVal=.."_tPropDef.Name_".GetNext(.tKey)")
					// comma for array items
					Do %code.WriteLine("   Write:(tKey'="""") "",""")
				}
				Else {
					Do %code.WriteLine("")
				}
			}

			// end of collection loop
			If (tPropDef.Collection="list")||(tPropDef.Collection="array") {
				Do %code.WriteLine("  }")
				Do %code.WriteLine("  Write ""]""")
			}

			If ('tShowEmpty) {
				If (tPropDef.Collection'="array") {
					// if not missing
					Do %code.WriteLine("  }")
				}
			}

			// next prop
			Set k = $O(tPropList(s,k),1,tPropDef)
		}

		// next seq
		Set s = $O(tPropList(s))
	}
	Do %code.WriteLine("  Write !,tTab0,""}""")

	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Catch(ex) {")
	Do %code.WriteLine("  Set tSC = ex.AsStatus()")
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Quit tSC")
	Quit $$$OK
}

/// Utility method. Write out the contents of the given stream as a JSON value.
ClassMethod %StreamToJSON(pStream As %Stream, pBase64 As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		// copied from jsonProvider
		Write """"
		Set tStreamMaxReadLen = ($$$MaxLocalLength\2)
		Do pStream.Rewind()
		While 'pStream.AtEnd {
			If (pBase64) {
				Write $$$ZENJSUESCAPE($System.Encryption.Base64Encode(pStream.Read(tStreamMaxReadLen)))
			}
			Else {
				Write $$$ZENJSUESCAPE(pStream.Read(tStreamMaxReadLen))
			}
		}
		Write """"
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Create a proxy object and copy this object's values into it.
/// This is an alternate way to create JSON content.<br/>
/// JSONSHOWEMPTY is ignored.
Method %CreateProxy(Output pObj As %ZEN.proxyObject) As %Status [ CodeMode = objectgenerator ]
{
	If (%class.Abstract) {
		Quit $$$OK
	}
	Do %code.WriteLine(" Set tSC = $$$OK")
	Do %code.WriteLine(" Try {")
	Do %code.WriteLine("  Set pObj = ##class(%ZEN.proxyObject).%New()")

	// get count of JSON properties; sort by sequence
	Set tSkipList("%Concurrency") = 1
	Set tPropCount = 0
	For n=1:1:%compiledclass.Properties.Count() {
		Set tPropDef = %compiledclass.Properties.GetAt(n)
		
		Set XMLPROJECTION = tPropDef.Parameters.GetAt("XMLPROJECTION")
		Set JSONPROJECTION = tPropDef.Parameters.GetAt("JSONPROJECTION")
		If ((JSONPROJECTION="")&&($$$UPPER(XMLPROJECTION="NONE"))) {
			// default to XML setting
			Set JSONPROJECTION ="NONE"
		}

		If ('$D(tSkipList(tPropDef.Name))&&($$$UPPER(JSONPROJECTION)'="NONE")&&($E(tPropDef.Name,1,2)'="%%")) {
			Set tPropCount = tPropCount + 1
			Set tPropList(tPropDef.SequenceNumber,tPropCount) = tPropDef
		}
	}

	// type field
	Set tTypeField = $G(%parameter("JSONTYPEFIELD"),"_class")
	If (tTypeField'="") {
		Do %code.WriteLine("  Set pObj."""_tTypeField_""" = ..%GetJSONType()")
	}

	Set s = $O(tPropList(""))
	While (s'="") {
		Set k = $O(tPropList(s,""),1,tPropDef)
		While (k'="") {

			Set JSONNAME = tPropDef.Parameters.GetAt("JSONNAME")
			Set JSONSUMMARY = tPropDef.Parameters.GetAt("JSONSUMMARY")
			// replace % with _ in names (unless JSONNAME is defined)
			Set tPropName = $S(JSONNAME'="":JSONNAME,1:$TR(tPropDef.Name,"%","_"))
			Set tPropType = tPropDef.Type

			// wrap loop around collection properties
			If (tPropDef.Collection="list") {
				Set tVar = "tVal"

				If ('$$$classIsDataType(tPropType)) {
					Do %code.WriteLine("  Set pObj."""_tPropName_""" = ##class(%ListOfObjects).%New()")
				}
				Else {
					Do %code.WriteLine("  Set pObj."""_tPropName_""" = ##class(%ListOfDataTypes).%New()")
				}
				Do %code.WriteLine("  Set tCount=.."_tPropDef.Name_".Count()")
				Do %code.WriteLine("  For n=1:1:tCount {")
				Do %code.WriteLine("   Set tVal=.."_tPropDef.Name_".GetAt(n)")
			}
			ElseIf (tPropDef.Collection="array") {
				Set tVar = "tVal"
				Set tKeyName = "key"
				Set tValueName = "value"

				If ('$$$classIsDataType(tPropType)) {
					Do %code.WriteLine("  Set pObj."""_tPropName_""" = ##class(%ArrayOfObjects).%New()")
				}
				Else {
					Do %code.WriteLine("  Set pObj."""_tPropName_""" = ##class(%ArrayOfDataTypes).%New()")
				}

				Do %code.WriteLine("  Set tKey=""""")
				Do %code.WriteLine("  Set tVal=.."_tPropDef.Name_".GetNext(.tKey)")
				Do %code.WriteLine("  While (tKey'="""") {")
			}
			Else {
				// use property directly
				Set tVar = ".."_$S($ZName(tPropDef.Name):tPropDef.Name,1:""""_tPropDef.Name_"""")
			}

			If ($$$classIsStream(tPropType)) {
				// use same stream
				Do %code.WriteLine("  Set pObj."""_tPropName_""" = "_tVar)
			}
			ElseIf ('$$$classIsDataType(tPropType)) {
				// object
				If (JSONSUMMARY'="") {
					Do %code.WriteLine("")
					Do %code.WriteLine("  If ('$IsObject("_tVar_")) {")
					Do %code.WriteLine("   Set pObj."""_tPropName_""" = """"")
					Do %code.WriteLine("  } Else {")
					Do %code.WriteLine("   Set pObj."""_tPropName_""" = "_tVar_"."_JSONSUMMARY)
					Do %code.WriteLine("  }")
				}
				Else {
					Do %code.WriteLine("  If ('$IsObject("_tVar_")) {")
					Do %code.WriteLine("   Set pObj."""_tPropName_""" = """"")
					Do %code.WriteLine("  } Else {")
					Do %code.WriteLine("   Set tSC = "_tVar_".%CreateProxy(.tChild)")
					Do %code.WriteLine("   Quit:$$$ISERR(tSC)")
					If (tPropDef.Collection="list") {
						Do %code.Write("   Do pObj."""_tPropName_""".Insert(tChild)")
					}
					ElseIf (tPropDef.Collection="array") {
						Do %code.Write("   Do pObj."""_tPropName_""".SetAt(tChild,tKey)")
					}
					Else {
						Do %code.WriteLine("   Set pObj."""_tPropName_""" = tChild")
					}
					Do %code.WriteLine("  }")
				}
			}
			Else {
				// literal
				If (tPropDef.Collection="list") {
					Do %code.Write("   Do pObj."""_tPropName_""".Insert(")
				}
				ElseIf (tPropDef.Collection="array") {
					Do %code.Write("   Do pObj."""_tPropName_""".SetAt(")
				}
				Else {
					Do %code.Write("  Set pObj."""_tPropName_""" = ")
				}

				Set tClientType = $$$comClassKeyGet(tPropType,$$$cCLASSclientdatatype)
				
				If (tClientType = "BOOLEAN") {
					// convert to true/false
					Do %code.Write("$S("_tVar_"="""":"""",+"_tVar_":""true"",1:""false"")")
				}
				ElseIf (tClientType = "DOUBLE")||(tClientType = "DECIMAL") {
					Do %code.Write("$S("_tVar_"="""":"""",1:$FN("_tVar_",""LON""))")
				}
				ElseIf (tClientType = "INTEGER") {
					Do %code.Write("$S("_tVar_"="""":"""",1:$FN("_tVar_",""LON"",0))")
				}
				ElseIf (tClientType = "TIMESTAMP") {
					Do %code.Write(tVar)
				}
				ElseIf (tClientType = "BINARY") {
					// base64
					Do %code.Write("$System.Encryption.Base64Encode("_tVar_")")
				}
				Else {
					// string
					Do %code.Write(tVar)
				}

				If (tPropDef.Collection="list") {
					Do %code.WriteLine(")")
				}
				ElseIf (tPropDef.Collection="array") {
					Do %code.WriteLine(",tKey)")
				}
				Else {
					Do %code.WriteLine("")
				}
			}
			
			// Iterate the key and value for the arrayOfObject and arrayOfDataType
			If (tPropDef.Collection="array") {
				Do %code.WriteLine("   Set tVal=.."_tPropDef.Name_".GetNext(.tKey)")
			}

			// end of collection loop
			If (tPropDef.Collection="list")||(tPropDef.Collection="array") {
				Do %code.WriteLine("  }")
				If ('$$$classIsDataType(tPropType)) {
					Do %code.WriteLine("  Quit:$$$ISERR(tSC)")
				}
			}

			// next prop
			Set k = $O(tPropList(s,k),1,tPropDef)
		}

		// next seq
		Set s = $O(tPropList(s))
	}

	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Catch(ex) {")
	Do %code.WriteLine("  Set tSC = ex.AsStatus()")
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Quit tSC")
	Quit $$$OK
}

}
