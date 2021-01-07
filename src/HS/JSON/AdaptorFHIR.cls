Include (%ZEN.Utils, %occInclude)

/// Adds specialized JSON capabilities to classes.
Class HS.JSON.AdaptorFHIR [ Abstract, PropertyClass = HS.JSON.PropertyParameters, System = 2 ]
{

/// Name of field in emitted JSON that holds the type (classname) for objects.
Parameter JSONTYPEFIELD As STRING = "_class";

/// If true, emit JSON for empty (non-collection) properties.
Parameter JSONSHOWEMPTY As BOOL = 0;

/// Return the value to be used within the JSONTYPEFIELD.
ClassMethod %GetJSONType() As %String
{
	Quit $classname($this)
}

/// Write out this object's current value as FHIR JSON content.
/// <var>pFormat</var> is ignored; it is only there for compatability with the %ZEN.proxyObject %ToJSON method.
/// <var>pIsPrimitive</var> indicates whether the parent class was a primitive or not (see method IsPrimitive).
Method %ToFHIRJSON(pLevel As %Integer = 0, pFormat As %String = "aelotw", pIsPrimitive As %Boolean = 0) As %Status [ CodeMode = objectgenerator ]
{
	Set tShowEmpty = +$G(%parameter("JSONSHOWEMPTY"))

	If (%class.Abstract) {
		Quit $$$OK
	}
	
	// The HS FHIR data model classes are organized into three class
	// packages - Base, Datatype, Resource - all under the same root
	// class package.  Create variables to hold the names of these
	// three class packages and the root package.
	Set tPackageRoot = ""
	If %compiledclass.Name[".Base." {
		Set tPackageRoot=$Piece(%compiledclass.Name, ".Base.", 1)_"."
	} ElseIf %compiledclass.Name[".Datatype." {
		Set tPackageRoot=$Piece(%compiledclass.Name, ".Datatype.", 1)_"."
	} ElseIf %compiledclass.Name[".Resource." {
		Set tPackageRoot=$Piece(%compiledclass.Name, ".Resource.", 1)_"."
	}
	Set tPackageRootL = $Length(tPackageRoot)
	Set tBaseRoot = tPackageRoot_"Base."
	Set tBaseRootL = $Length(tBaseRoot)
	Set tDatatypeRoot = tPackageRoot_"Datatype."
	Set tDatatypeRootL = $Length(tDatatypeRoot)
	Set tResourceRoot = tPackageRoot_"Resource."
	Set tResourceRootL = $Length(tResourceRoot)
	
	Do %code.WriteLine(" Set tSC = $$$OK")
	Do %code.WriteLine(" Try {")
	
	// Cannot figure out tWriteBraces at compile time because we know pLevel only at run time.
	// Write enclosing curly braces only if (This is the top level of the FHIR object) OR (%class is NOT a resource type class AND %class is NOT a primitive type)
	Set tIsResource = (($Extract(%class.Name,1,tResourceRootL)=tResourceRoot)&&($Extract(%class.Name,tResourceRootL+1,*)'["."))
	Set tIsPrimitive = ..IsPrimitive(%class.Name, tPackageRoot, tBaseRoot)
	If ('tIsResource)&&('tIsPrimitive) {
		Do %code.WriteLine("  Set tWriteBraces = 1")
	} Else {
		Do %code.WriteLine("  Set tWriteBraces = (pLevel=0)")
	}
	Do %code.WriteLine("  If tWriteBraces'=1 Set pLevel=pLevel-1")

	Do %code.WriteLine("  Set tTabChar=$G(%formattabchar,$C(9))")
	Do %code.WriteLine("  Set tCr=$G(%formatcrchar,$C(13,10))")
	Do %code.WriteLine("  Set $P(tTab0,tTabChar,pLevel+1)=""""")
	Do %code.WriteLine("  Set $P(tTab,tTabChar,pLevel+2)=""""")

	// Create a set of offsets to allow setting property SequenceNumbers
	// in child classes to values higher than those for properties in
	// parent classes.  The offsets help in exporting the properties in
	// the order defined in the compiled class.  It is not a requirement
	// for FHIR JSON, but it is helpful when comparing to commonly used
	// HL7 examples, and adds overhead only at compile time.
	Do ..GetOffsets(%compiledclass.Name, 20, .tOffsets)
	
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
				Set tOffset = 0
				If tPropDef.Origin'="" Set tOffset = +$Get(tOffsets(tPropDef.Origin))
				Set tPropCount = tPropCount + 1
				Set tPropList(tPropDef.SequenceNumber+tOffset,tPropCount) = tPropDef
			}
		}
	}
	
	Do %code.WriteLine("  If tWriteBraces=1 Write tTab0,""{"",tCr")
	Do %code.WriteLine("  Set pc=0")	// count of emitted properties

	// emit type field
	Set tTypeField = $G(%parameter("JSONTYPEFIELD"),"_class")
	If (tTypeField'="") {
		Set tTypeField = $zconvert(tTypeField,"O","JSON")
		Set tTypeExpr = "$zconvert(..%GetJSONType(),""O"",""JSON"")"

		Do %code.WriteLine("  Write tTab,"""""""_tTypeField_""""":"""""","_tTypeExpr_",""""""""")
		Do %code.WriteLine("  Set pc=pc+1")
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

			Set tIsPrimitive = ..IsPrimitive(tPropType, tPackageRoot, tBaseRoot)
			
			If (tPropType=(tBaseRoot_"Extension"))||((tPropType=(tDatatypeRoot_"IdPrimitive"))&&(tPropDef.Name="id")) {
				Do %code.WriteLine("  If 'pIsPrimitive { // Start propname="_tPropName_"  proptype="_tPropType)
				Do %code.WriteLine("  Kill tHasId,tHasExt,tPrimitiveNoVal")
			} Else {
				Do %code.WriteLine("  Kill tHasId,tHasExt,tPrimitiveNoVal // Start propname="_tPropName_"  proptype="_tPropType)
			}
			
			// wrap loop around collection properties
			If (tPropDef.Collection="list") {
				// The extended checking on the list here is due to the
				// SDA to FHIR DTL transformations creating numerous objects with
				// empty values (property.value="") that cause "property":null to
				// be unnecessarily and excessively written in the absence of that
				// check.
				Do %code.WriteLine("  Set tCount=0")
				Do %code.WriteLine("  If r%"_tPropDef.Name_" {")
				Do %code.WriteLine("    Set (tHasVal,tAnyHasVal,tAnyValHasVal)=0")
				Do %code.WriteLine("    Set tCount=.."_tPropDef.Name_".Count()")
				Do %code.WriteLine("    If tCount {")
				Do %code.WriteLine("      For i=1:1:.."_tPropDef.Name_".Count() {")
				Do %code.WriteLine("        If .."_tPropName_".GetAt(i).%FHIRObjectHasValue()=1 {")
				Do %code.WriteLine("          Set tAnyHasVal=1")
				If (tIsPrimitive)&&(tPropName'="id")&&(tPropName'="url")&&($Extract(tPropType)'="%")&&($Extract(tPropType,*-8,*)'="Primitive") {
					Do %code.WriteLine("          If .."_tPropName_".GetAt(i).value'="""" Set tAnyValHasVal=1")
					Do %code.WriteLine("          If .."_tPropName_".GetAt(i).id'="""" Set tHasId(i)=.."_tPropName_".GetAt(i).id")
					Do %code.WriteLine("          If .."_tPropName_".GetAt(i).extension.Count() Set tHasExt(i)=.."_tPropName_".GetAt(i).extension.Count()")
				}
				Do %code.WriteLine("        }")
				Do %code.WriteLine("      }")
				Do %code.WriteLine("      If tAnyHasVal=0 Set tCount=0")
				If '((tIsPrimitive)&&(tPropName'="id")&&(tPropName'="url")&&($Extract(tPropType)'="%")&&($Extract(tPropType,*-8,*)'="Primitive")) {
					Do %code.WriteLine("      Set tAnyValHasVal=tAnyHasVal")
				}
				Do %code.WriteLine("    }")
				Do %code.WriteLine("  }")
				If ('tShowEmpty) {
					Do %code.WriteLine("  If tCount {")
				}

				Do %code.WriteLine("  If tAnyValHasVal {")
				Do %code.WriteLine("    Write:pc "","",tCr")
				Do %code.WriteLine("    Set pc=pc+1")

				Set tVar = "tVal"
				Do %code.WriteLine("    Write tTab,"""""""_tPropName_""""":[""")

				Do %code.WriteLine("    For n=1:1:tCount {")
				Do %code.WriteLine("      Set tVal=.."_tPropDef.Name_".GetAt(n)")
				If ($$$classIsDataType(tPropType)) {
					Do %code.Write("      Write ")
				}
			}
			ElseIf (tPropDef.Collection="array") {
				// This condition is never True for %ToFHIRJSON.
			}
			Else {
				// use property directly
				Set tVar = ".."_tPropDef.Name

				If ('tShowEmpty) {
					// - FHIR div is %String.
					// - ATTRIBUTE is for id and value attributes, which are %Strings or Numerics.
					// - HS.FHIR.Model.Datatype are FHIR Primitives which are actually objects.
					// - The remainder are objects.
					// The extended checking on HS.FHIR.Model.Datatype is due to the
					// SDA to FHIR DTL transformations creating numerous objects with
					// empty values (property.value="") that cause "property":null to
					// be unnecessarily and excessively written in the absence of that
					// check.
					Set tIsObjectVal = $Select(tPropDef.Name="div":tVar_"'=""""",(XMLPROJECTION="ATTRIBUTE")!($Extract(tPropDef.Type,*-8,*)="Primitive"):tVar_"'=""""",1:"(r%"_tPropDef.Name_")&&("_tVar_".%FHIRObjectHasValue())")
					If ('$$$classIsStream(tPropType)) {
						Do %code.WriteLine("  If ("_tIsObjectVal_") {")
					}
					Else {
						Do %code.WriteLine("  If ("_tIsObjectVal_")&&("_tVar_".Size)) {")
					}
				}
				If (tIsPrimitive)&&($Extract(tPropType)'="%")&&($Extract(tPropType,*-8,*)'="Primitive") {
					Do %code.WriteLine("  Set tPrimitiveNoVal = ("_tVar_".value="""")")
				}
				Do %code.WriteLine("  Set n=0")
				Do %code.WriteLine("  If '$Get(tPrimitiveNoVal) Write:pc "","",tCr Set pc=pc+1")
				// If it's NOT a FHIR resource name, then write the property
				// name out.  FHIR resource names don't appear as object names,
				// they only appear as "resourceType" property values.
				If ('##class(%Dictionary.ClassDefinition).%ExistsId(tResourceRoot_tPropName)) {
					// A primitive data type will only get the value
					// written out, NOT "value": plus the value.
					// http://hl7.org/fhir/json.html says:
					// "Note: If the primitive has an id attribute or extension, but no value, only the property with the _ is rendered."
					Do %code.Write("  If '$Get(tPrimitiveNoVal) Write:'pIsPrimitive tTab,"""""""_tPropName_""""":""")
					Do %code.Write("  Write:pIsPrimitive """"")
					Do %code.Write("  Write """"")
				}
			}

			If ($$$classIsStream(tPropType)) {
				// This condition is never True for %ToFHIRJSON.
			}
			ElseIf ('$$$classIsDataType(tPropType)) {
				// object
				If (JSONSUMMARY'="") {
					// This condition is never True for %ToFHIRJSON.
				}
				Else {
					Do %code.WriteLine("")
					Set tIsObjectVal = $Select(tPropDef.Collection="":"r%"_tPropDef.Name,1:"$IsObject("_tVar_")")
					Set tNotIsObjectVal = $Select(tPropDef.Collection="":"'r%"_tPropDef.Name,1:"'$IsObject("_tVar_")")
					If tIsPrimitive {
						Do %code.WriteLine("  If "_tVar_".id'="""" Set tHasId(n)="_tVar_".id")
						Do %code.WriteLine("  If "_tVar_".extension.Count() Set tHasExt(n)="_tVar_".extension.Count()")
					}
					If 'tIsPrimitive {
						Do %code.WriteLine("  If ("_tNotIsObjectVal_") {")
						Do %code.WriteLine("    Write ""null""")
					} Else {
						Do %code.WriteLine("  If "_tVar_".value="""" {")
						// http://hl7.org/fhir/json.html says:
						// "Note: If the primitive has an id attribute or extension, but no value, only the property with the _ is rendered."
						If tPropDef.Collection="" {
							Do %code.WriteLine("    // do nothing")
						} Else {
							Do %code.WriteLine("    Write ""null""")
						}
					}
					Do %code.WriteLine("  } Else {")
					If ('tIsPrimitive)&&(%class.Name'=(tBaseRoot_"ResourceContainer")) Do %code.WriteLine("   Write tCr")

					// place a trap around this to catch references to non-JSON enabled objects
					Do %code.WriteLine("   Try {")
					If %class.Name'=(tBaseRoot_"ResourceContainer") {
						Do %code.WriteLine("    Set tSC2 = "_tVar_".%ToFHIRJSON(pLevel+2,pFormat,"_tIsPrimitive_")")
					} Else {
						Do %code.WriteLine("    Set tSC2 = "_tVar_".%ToFHIRJSON(pLevel+1,pFormat,"_tIsPrimitive_")")
					}
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
			}
			Else {
				// comma in write statement
				If (tPropDef.Collection="") {
					Do %code.Write(",")
				}

				Set tClientType = $$$comClassKeyGet(tPropType,$$$cCLASSclientdatatype)
				
				If (tClientType = "BOOLEAN") {
					// convert to true/false
					Do %code.Write("$S("_tVar_"="""":""null"",+"_tVar_":""true"","_tVar_"=""true"":""true"",1:""false"")")
				}
				ElseIf (tClientType = "DOUBLE")||(tClientType = "DECIMAL")||(tClientType = "NUMERIC") {
					Do %code.Write("$S("_tVar_"="""":""null"",1:$FN("_tVar_",""LON"",$L($P("_tVar_",""."",2))))")
				}
				ElseIf (tClientType = "INTEGER") {
					Do %code.Write("$S("_tVar_"="""":""null"",1:$FN("_tVar_",""LON"",0))")
				}
				ElseIf (tClientType = "TIMESTAMP") {
					If $$$comSubMemberDefined(%class.Name,$$$cCLASSproperty,tPropDef.Name,$$$cPROPmethod,"LogicalToXSD") {
						Do %code.Write(""""""""",$ZCVT("_tVar_"LogicalToXSD("_tVar_")"_",""O"",""JSON""),""""""""")
					}
					Else {
						Do %code.Write(""""""""",$ZCVT("_tVar_",""O"",""JSON""),""""""""")
					}					
				}
				ElseIf (tClientType = "BINARY") {
					// base64
					Do %code.Write(""""""""",$replace($system.Encryption.Base64Encode("_tVar_"),$c(13,10),""""),""""""""")
				}
				ElseIf (tVar="..div") {
					// div for JSON needs open and close tags added, if necessary,
					// and the outer div tag needs the xhtml namespace.
					Do %code.Write(""""""""" Set tDivWithNS=""<div xmlns=""""http://www.w3.org/1999/xhtml"""">"" Write:$E(..div,1,42)=tDivWithNS $ZCVT(..div,""O"",""JSON"") Write:$E(..div,1,5)=""<div>"" $ZCVT(tDivWithNS_$E(..div,6,*),""O"",""JSON"") Write:($E(..div,1,5)'=""<div>"")&&($E(..div,1,42)'=tDivWithNS) $ZCVT(tDivWithNS_..div_""</div>"",""O"",""JSON"") Write """"""""")
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
				Do %code.WriteLine("    } // End If tAnyValHasVal")
				Do %code.WriteLine("    Write tCr,tTab,""]""")
				Do %code.WriteLine("  } // End If tCount")
			}

			If ('tShowEmpty) {
				If (tPropDef.Collection'="array") {
					// if not missing
					Do %code.WriteLine("  }")
				}
			}
			
			If (tPropType=(tBaseRoot_"Extension"))||((tPropType=(tDatatypeRoot_"IdPrimitive"))&&(tPropDef.Name="id")) {
				Do %code.WriteLine("  } // End If 'pIsPrimitive")
			}
			
			If tIsPrimitive {
				// If any ids or extensions on this property then process them now.
				Do %code.WriteLine("  If ($Data(tHasId))||($Data(tHasExt)) {")
				// pc = property count
				Do %code.WriteLine("    Write:pc "","",tCr Set pc=pc+1")
				// Non-list properties will have only tHasId(0) and/or tHasExt(0).
				// List properties will have tHasId(1 to n) and/or tHasExt(1 to n).
				If tPropDef.Collection="" {
					Do %code.WriteLine("    Write tTab,""""""_"_tPropName_""""":{"",tCr")
					Do %code.WriteLine("    If $Data(tHasExt(0)) {")
					Do %code.WriteLine("      Write tTab_tTabChar,""""""extension"""":["",tCr")
					Do %code.WriteLine("      For m=1:1:.."_tPropDef.Name_".extension.Count() {")
					Do %code.WriteLine("        Write:m>1 "","",tCr")
					Do %code.WriteLine("        Set tSC2 = .."_tPropDef.Name_".extension.GetAt(m).%ToFHIRJSON(pLevel+3,pFormat,0)")
					Do %code.WriteLine("      }")
					Do %code.WriteLine("      Write tCr,tTab_tTabChar,""]""")
					Do %code.WriteLine("    }")
					Do %code.WriteLine("    If $Data(tHasId(0)) Write:$Data(tHasExt(0)) "","" Write tCr,tTab_tTabChar,""""""id"""":""""""_"_tVar_".id_""""""""")
					Do %code.WriteLine("    Write tCr,tTab,""}""")
				} ElseIf tPropDef.Collection="list" {
					Do %code.WriteLine("    Write tTab,""""""_"_tPropName_""""":["",tCr")
					// ec = extension/id count
					Do %code.WriteLine("    Set ec=0")
					Do %code.WriteLine("    For n=1:1:tCount {")
					Do %code.WriteLine("      Write:ec "","",tCr Set ec=ec+1")
					Do %code.WriteLine("      If ($Data(tHasId(n))=0)&&($Data(tHasExt(n))=0) {")
					Do %code.WriteLine("        Write tTab_tTabChar,""null""")
					Do %code.WriteLine("      } Else {")
					Do %code.WriteLine("        Write tTab_tTabChar,""{"",tCr")
					Do %code.WriteLine("        If $Data(tHasExt(n)) {")
					Do %code.WriteLine("          Write tTab_tTabChar_tTabChar,""""""extension"""":["",tCr")
					Do %code.WriteLine("          For m=1:1:tHasExt(n) {")
					Do %code.WriteLine("            Write:m>1 "","",tCr")
					Do %code.WriteLine("            Set tSC2 = .."_tPropDef.Name_".GetAt(n).extension.GetAt(m).%ToFHIRJSON(pLevel+4,pFormat,0)")
					Do %code.WriteLine("          }")
					Do %code.WriteLine("          Write tCr,tTab_tTabChar_tTabChar,""]""")
					Do %code.WriteLine("        }")
					Do %code.WriteLine("        If $Data(tHasId(n)) Write:$Data(tHasExt(n)) "","" Write tCr,tTab,""""""id"""":""""""_.."_tPropDef.Name_".GetAt(n).id_""""""""")
					Do %code.WriteLine("        Write tCr,tTab_tTabChar,""}""")
					// Check to see if any more ids or extensions left.  If not then quit.
					Do %code.WriteLine("        If n<tCount {")
					Do %code.WriteLine("          Set tAnyMore=0")
					Do %code.WriteLine("          For w=(n+1):1:tCount If ($Data(tHasId(w)))||($Data(tHasExt(w))) Set tAnyMore=1 Quit")
					Do %code.WriteLine("          If 'tAnyMore Quit")
					Do %code.WriteLine("        }")
					Do %code.WriteLine("      }")
					Do %code.WriteLine("    }")
					Do %code.WriteLine("    Write tCr,tTab,""]""")
				}
				Do %code.WriteLine("  } // End If ($Data(tHasId))||($Data(tHasExt))")
			}

			// next prop
			Set k = $O(tPropList(s,k),1,tPropDef)
		}

		// next seq
		Set s = $O(tPropList(s))
	}
	Do %code.WriteLine("  If tWriteBraces=1 Write tCr,tTab0,""}""")

	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Catch(ex) {")
	Do %code.WriteLine("  Set tSC = ex.AsStatus()")
	Do %code.WriteLine(" }")
	Do %code.WriteLine(" Quit tSC")
	Quit $$$OK
}

ClassMethod GetOffsets(pClassName As %String, pOffsetLevel As %Integer, ByRef pOffSets As %String) [ Internal ]
{
	Set pOffSets(pClassName) = pOffsetLevel * 1000
	
	Set tClassObj = ##class(%Dictionary.CompiledClass).%OpenId(pClassName)
	If '$IsObject($Get(tClassObj)) Quit
	
	For i = 1:1:$Length(tClassObj.Super, ",") {
		Set tClass = $Piece(tClassObj.Super, ",", i)
		if tClass'="" Do ..GetOffsets(tClass, pOffsetLevel-1, .pOffSets)
	}
	
	Quit
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
				Set tVar = ".."_tPropDef.Name
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
					Do %code.WriteLine("   Set tVal=.."_tPropDef.Name_".GetNext(.tKey)")
				}
				Else {
					Do %code.WriteLine("")
				}
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

/// IsPrimitive returns a flag indicating whether or not the specified
/// class is a FHIR primitive type class.  A class is considered to be
/// a primitive type when it directly extends fhir Element and itself
/// has only one property, named "value".
ClassMethod IsPrimitive(pType As %String = "", pPackageRoot As %String, pBaseRoot As %String) As %Boolean [ Internal ]
{
	If pType="" Quit 0
	Set tObj = ##class(%Dictionary.ClassDefinition).%OpenId(pType)
	If $IsObject(tObj)=0 Quit 0
	If pType["Primitive" Quit 1
	If pType["%Library." Quit 1
	If pType["%String" Quit 1
	Set tPackageRootL = $Length(pPackageRoot)
	If ($Extract(pType,1,tPackageRootL)=pPackageRoot)&&(tObj.Super'=(pBaseRoot_"Element")) Quit 0
	If tObj.Properties.Count()=1 If tObj.Properties.GetAt(1).Name="value" Quit 1
	Quit 0
}

/// This method instantiates an HS FHIR object from a FHIR JSON stream or string and returns it.<br>
/// <br>
/// Inputs:<br>
/// <li>pJSONStreamOrString : (required if pJSONObject not passed in) A FHIR JSON stream object or string.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema root for FHIR resources.
///                           Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pJSONObject         : (required if pJSONStreamOrString not passed in) %DynamicObject representation
///                           of the FHIR JSON.
/// <br><br>
/// Outputs:<br>
/// <li>pHSFHIRObj          : The HS FHIR object constructed from the FHIR JSON. If an error is incurred
///                           during the construction of pHSFHIRObj, then pHSFHIRObj is returned as
///                           $$$NULLOREF.
/// <li>pJSONObject         : %DynamicObject representation of the JSON payload, created by this method
///                           if it was not passed in as input.  If pJSONObject was not passed in as
///                           input, AND if an error is incurred during the construction of pHSFHIRObj,
///                           then pJSONObject is returned as $$$NULLOREF.
ClassMethod %FromFHIRJSON(pJSONStreamOrString, ByRef pHSFHIRObj As %RegisteredObject, pResourceSchemaRoot As %String, ByRef pJSONObject As %Library.DynamicObject) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Kill pHSFHIRObj
		
		Set tJSONObjectInput = 0
		
		If $IsObject($Get(pJSONObject))&&(pJSONObject.%IsA("%Library.DynamicAbstractObject")) {
			// Just use pJSONObject if it was passed in.
			Set tJSONObjectInput = 1
		} ElseIf '$IsObject($Get(pJSONStreamOrString)) {
			// String must have a value.
			If $Length($Get(pJSONStreamOrString)) {
				Set pJSONObject = ##class(%DynamicObject).%FromJSON(pJSONStreamOrString)
				If '$IsObject($Get(pJSONObject)) {
					Set tSC = $$$ERROR($$$GeneralError, "Could not create object from FHIR JSON string")
				}
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Blank JSON data string specified")
			}
		} ElseIf $IsObject($Get(pJSONStreamOrString))&&(pJSONStreamOrString.%IsA("%Stream.Object")) {
			// Stream must have contents.
			If pJSONStreamOrString.Size{
				Set pJSONObject = ##class(%DynamicObject).%FromJSON(pJSONStreamOrString)
				If '$IsObject($Get(pJSONObject)) {
					Set tSC = $$$ERROR($$$GeneralError, "Could not create object from FHIR JSON stream")
				}
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Blank JSON data stream specified")
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError,"Invalid JSON input - must be a string, a stream object or a %DynamicAbstractObject")
		}
		If $$$ISERR(tSC) Quit
		
		Set tTopResourceName = pJSONObject.resourceType
		If tTopResourceName="" {
			Set tSC = $$$ERROR($$$GeneralError, "resourceType not found at top level of JSON object")
			Quit
		}
		
		Set tTopResourceClassName = pResourceSchemaRoot_"."_tTopResourceName
		
		// Backward compatibility to earlier versions of HS FHIR.
		If $$$defClassDefined(tTopResourceClassName)=0 {
			Set tTopResourceClassName = pResourceSchemaRoot_".Resource."_tTopResourceName
		}
		
		Set pHSFHIRObj = $ClassMethod(tTopResourceClassName, "%New")
		If '$IsObject(pHSFHIRObj) {
			Set tSC = $$$ERROR($$$GeneralError,"Could not set top level FHIR resource object")
			Quit
		}
		
		Set tSC = ..%FromFHIRJSON2(pJSONObject, pHSFHIRObj)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		Set pHSFHIRObj = $$$NULLOREF
		If '$Get(tJSONObjectInput) Set pJSONObject = $$$NULLOREF
		// 5035 is JSON 'Parsing error' Code '3' Data
		Set tExtraText = $Select($system.Status.GetErrorCodes(tSC)=5035:" - the specified content is not well-formed JSON",1:"")
		Set tSC = $$$ERROR($$$GeneralError, $system.Status.GetErrorText(tSC)_tExtraText)
	}
	
	Quit tSC
}

ClassMethod %FromFHIRJSON2(pJSONObject As %Library.DynamicObject, pHSFHIRObj As %RegisteredObject) [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tHSFHIRClass = pHSFHIRObj.%ClassName(1)
		
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(tHSFHIRClass))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tHSFHIRClass)
		
		Set tIterator = pJSONObject.%GetIterator()
		
		Set tPropName = ""
		Set tSavePropName = tPropName
		
		For {
			Set tPropName = tSavePropName
			If 'tIterator.%GetNext(.tPropName, .tData) Quit
			If tPropName="" Quit
			Set tSavePropName = tPropName
			
			// tPropName is the current property name.
			// tData can be:
			// - String value
			// - Boolean value
			// - Numeric value
			// - %Library.DynamicArray object reference
			// - %Library.DynamicObject object reference
			
			// resourceType is only used by the code calling this method, to determine the type of
			// FHIR resource (if any) that this object is.
			// fhir_comments is for the FHIR JSON equivalent of XML comments, which we want to ignore.
			If (tPropName="resourceType")||(tPropName="fhir_comments") Continue
			
			// extensions and ids will already have been processed earlier along with their
			// associated standard property.
			If $Extract(tPropName)="_" {
				If pJSONObject.%Get($Extract(tPropName,2,*))'="" {
					Continue
				} Else {
					Set tPropName = $Extract(tPropName,2,*)
				}
			}
			
			If $Data(%propsByName(tHSFHIRClass, tPropName))=0 {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid property '"_tPropName_"' found in "_tHSFHIRClass_" object")
				Quit
			}
			
			Set tPropType = %propsByName(tHSFHIRClass, tPropName, "Type")
			
			// Make a note of the object reference for the extension data, if any, for the
			// current property.
			Set tExtData = pJSONObject.%Get("_"_tPropName)
			
			Kill tExtensionCollArray
			Kill tPropIdArray
			Set tExtensionColl = ""
			
			// Property "div" and those with a type that ends in "Primitive" are not
			// objects and are not extendable.  Just set the data into them directly.
			If (tPropName="div")||($Extract(tPropType,*-8,*)="Primitive") {
				Set $Property(pHSFHIRObj, tPropName) = tData
				Continue
			}
			
			If '$IsObject(tData) {
				// This is a primitive FHIR object type such as String, Code, etc.
				// Check for extension and/or id on this item first, and build
				// collection of extensions if necessary.
				Set tPropId = ""
				If tExtData'="" {
					// Because this is not an array, the extension will be an object, not an array.
					Set tPropId = tExtData.id
					If tExtData.extension'="" {
						// Find the class definition for extension, then use it.
						If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
						Set tExtensionSchema = %propsByName(tPropType, "extension", "Type")
						Do ..%FromFHIRJSONExt(tExtData, .tExtensionColl, tExtensionSchema)
					}
				}
				Set tPropObj = $ClassMethod(tPropType,"%New")
				// At this point, will be either string or boolean.
				If tData'="" {
					If $Extract(tPropType,*-6,*)'="Boolean" {
						Set $Property(tPropObj,"value") = tData
					} Else {
						Set $Property(tPropObj,"value") = $Case(tData, "true":1, "false":0, 1:1, 0:0, :0)
					}
				}
				If tExtensionColl'="" Set $Property(tPropObj,"extension") = tExtensionColl
				If tPropId'="" Set $Property(tPropObj,"id") = tPropId
				Set $Property(pHSFHIRObj, tPropName) = tPropObj
			} ElseIf tData.%IsA("%Library.DynamicObject") {
				// This is a %DynamicObject. Instantiate a new object and make the recursive call.
				If $Extract(tPropType,*-16,*)'="ResourceContainer" {
					Set tPropObj = $ClassMethod(tPropType, "%New")
				} Else {
					// Special case: If type is ResourceContainer then the class
					// should be the resource type indicated in the JSON array.
					// Instantiate that instead of ResourceContainer, and we will
					// wrap the the resource object in a ResourceContainer after
					// returning from the ..%FromFHIRJSON2 call.
					Set tResourceType = tData.resourceType
					If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
					Set tResourcePropType = %propsByName(tPropType, tResourceType, "Type")
					Set tPropObj = $ClassMethod(tResourcePropType, "%New")
				}
				Set tSC = ..%FromFHIRJSON2(tData, .tPropObj)
				If $$$ISERR(tSC) Quit
				If $Extract(tPropType,*-16,*)="ResourceContainer" {
					Set tPropObj2 = $ClassMethod(tPropType, "%New")
					Set $Property(tPropObj2, tResourceType) = tPropObj
					Set $Property(pHSFHIRObj, tPropName) = tPropObj2
				} Else {
					Set $Property(pHSFHIRObj, tPropName) = tPropObj
				}
			} Else {
				// This is a %DynamicArray of objects or primitive object types.
				// First, loop through any counterpart extension objects for this array.
				// For each extension object and id found in the JSON, generate the
				// extension object and put it in a local array, and do the same for any
				// id values.  This array of extension object references and id values
				// will then be used when looping through the array of standard objects
				// and values.
				If tExtData'="" {
					Set tIterator2 = tExtData.%GetIterator()
					Set tPropName2 = ""
					For {
						If 'tIterator2.%GetNext(.tPropName2, .tData2) Quit
						If tPropName2="" Quit
						// Empty tData2 here means there is "null" in the JSON array element.
						If tData2="" Continue
						If tData2.id'="" Set tPropIdArray(tPropName2) = tData2.id
						If tData2.extension'="" {
							// Find the class definition for extension, then use it.
							If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
							Set tExtensionSchema = %propsByName(tPropType, "extension", "Type")
							Do ..%FromFHIRJSONExt(tData2, .tExtensionColl, tExtensionSchema)
							Set tExtensionCollArray(tPropName2) = tExtensionColl
							Kill tExtensionColl
						}
					}
					Kill tIterator2
				}
				// Loop through the array elements.
				Set tIterator2 = tData.%GetIterator()
				Set tPropName2 = ""
				For {
					If 'tIterator2.%GetNext(.tPropName2, .tData2) Quit
					If tPropName2="" Quit
					// This condition should never ever happen, but noting it anyway.
					If (tData2="")&&('$Data(tExtensionCollArray(tPropName2))) Continue
					// If tData2 is blank after this point, it means that the property
					// has no standard property value but has some extension data. 
					If ($IsObject(tData2))&&(tData2.%IsA("%Library.DynamicObject")) {
						// This is an object. Instantiate a new object and make the recursive call.
						If $Extract(tPropType,*-16,*)'="ResourceContainer" {
							Set tPropObj = $ClassMethod(tPropType, "%New")
						} Else {
							// Special case: If type is ResourceContainer then the class
							// should be the resource type indicated in the JSON array.
							// Instantiate that instead of ResourceContainer, and we will
							// wrap the the resource object in a ResourceContainer after
							// returning from the ..%FromFHIRJSON2 call.
							Set tResourceType = tData2.resourceType
							If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
							Set tResourcePropType = %propsByName(tPropType, tResourceType, "Type")
							Set tPropObj = $ClassMethod(tResourcePropType, "%New")
						}
						Set tSC = ..%FromFHIRJSON2(tData2, .tPropObj)
						If $$$ISERR(tSC) Quit
						If $Extract(tPropType,*-16,*)'="ResourceContainer" {
							Set tSC = $Property(pHSFHIRObj, tPropName).Insert(tPropObj)
						} Else {
							Set tPropObj2 = $ClassMethod(tPropType, "%New")
							Set $Property(tPropObj2, tResourceType) = tPropObj
							Set tSC = $Property(pHSFHIRObj, tPropName).Insert(tPropObj2)
						}
						If $$$ISERR(tSC) Quit
					} ElseIf '$IsObject(tData2) {
						// This is a primitive FHIR object type such as String, Code, etc.
						// Check for extension and/or id that may have been noted on this item
						// earlier, and include them when setting the property.
						Set tExtensionColl = $Get(tExtensionCollArray(tPropName2))
						Set tPropId = $Get(tPropIdArray(tPropName2))
						Set tPropObj = $ClassMethod(tPropType,"%New")
						If tData2'="" {
							If $Extract(tPropType,*-6,*)'="Boolean" {
								Set $Property(tPropObj,"value") = tData2
							} Else {
								Set $Property(tPropObj,"value") = $Case(tData2, "true":1, "false":0, 1:1, 0:0, :0)
							}
						}
						If tExtensionColl'="" Set $Property(tPropObj,"extension") = tExtensionColl
						If tPropId'="" Set $Property(tPropObj,"id") = tPropId
						If %propsByName(tHSFHIRClass,tPropName,"Collection")="" {
							Set $Property(pHSFHIRObj, tPropName) = tPropObj
						} Else {
							Set tSC = $Property(pHSFHIRObj, tPropName).Insert(tPropObj)
						}
						If $$$ISERR(tSC) Quit
						Continue
					} Else {
						// This is an array.  Unlikely that this situation exists at all.
					}
				}
				If $$$ISERR(tSC) Quit
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod %FromFHIRJSONExt(pJSONObject As %Library.DynamicObject, ByRef pExtensionColl, pExtensionClass As %String) [ Internal ]
{
	Set pExtensionColl = ##class(%Library.ListOfObjects).%New()
	Set tIterator = pJSONObject.extension.%GetIterator()
	Set tPropName = ""
	For {
		If 'tIterator.%GetNext(.tPropName, .tData) Quit
		If tPropName="" Quit
		Set tPropObj = $ClassMethod(pExtensionClass, "%New")
		Set tSC = $$$OK
		If tData'="" Set tSC = ..%FromFHIRJSON2(tData, .tPropObj)
		$$$ThrowOnError(tSC)
		Set tSC = pExtensionColl.Insert(tPropObj)
		$$$ThrowOnError(tSC)
	}
	Quit
}

/// Get the definition information for a given property. This is currently based on class definitions.
ClassMethod GetPropInfo(pHSFHIRClass As %String) [ Internal ]
{
	// Retaining as a stub in case anyone else was inappropriately using it directly.
	Do ##class(HS.FHIR.Utils).GetPropInfo(pHSFHIRClass)
	Quit
}

Method %FHIRObjectHasValue() As %Boolean [ CodeMode = objectgenerator, GenerateAfter = %XMLGenerate ]
{
	If (%class.Abstract) {
		Quit $$$OK
	}
	
	Set tModelPackage = $Piece(%class.Name,".Model.",1)_".Model."
	Set tModelPackageL = $Length(tModelPackage)
	
	#; Parse this class' super class(es) and make an array that
	#; orders the compiled class properties. The properties from
	#; the deepest base class come first, the next deepest next,
	#; etc, with the current class properties last.
	#;
	#; tPropList(superclassnumber, sequencenumber) = property definition object
	#;
	Set tSkipList("%Concurrency") = 1
	Set tSuper(1) = %class.Super
	For i = 1:1 {
		Set tClsDef = ##class(%Dictionary.ClassDefinition).%OpenId(tSuper(i))
		If '$IsObject(tClsDef) Quit
		If tClsDef.Super="" Quit
		Set tSuper(i+1) = tClsDef.Super
		Kill tClsDef
	}
	Set tSuperCount = 0
	Set i = ""
	For {
		Set i = $Order(tSuper(i),-1)
		If i="" Quit
		If $Extract(tSuper(i),1,tModelPackageL)'=tModelPackage Continue
		Set tClsDef = ##class(%Dictionary.ClassDefinition).%OpenId(tSuper(i))
		If '$IsObject(tClsDef) Quit
		If tClsDef.Properties.Count()>0 If $i(tSuperCount)
		For j = 1:1:tClsDef.Properties.Count() {
			Set tPropDef = tClsDef.Properties.GetAt(j)
			If ('$D(tSkipList(tPropDef.Name))&&($E(tPropDef.Name,1,2)'="%%")) {
				Set tPropList(tSuperCount,tPropDef.SequenceNumber)=tPropDef
			}
		}
		Kill tClsDef
	}
	If $i(tSuperCount)
	For j = 1:1:%class.Properties.Count() {
		Set tPropDef = %class.Properties.GetAt(j)
		If ('$D(tSkipList(tPropDef.Name))&&($E(tPropDef.Name,1,2)'="%%")) {
			Set tPropList(tSuperCount,tPropDef.SequenceNumber)=tPropDef
		}
	}
	
	#; Build a single If statement that checks to see if any properties have data.
	Set tIfString = ""
	Set s = ""
	For {
		Set s = $Order(tPropList(s))
		If s="" Quit
		Set k = ""
		For {
			Set k = $Order(tPropList(s,k))
			If k="" Quit
			Set tPropDef = tPropList(s,k)
			Set tPropName = tPropDef.Name
			Set tPropType = tPropDef.Type
			// Some properties are far less likely to be populated than others.
			// Defer those properties to be at the end of the block of checks.
			If (tPropName="implicitRules")||(tPropName="language")||(tPropName="extension")||(tPropName="modifierExtension")||(tPropName="contained") {
				If $i(tDeferred)
				Set tDeferred(tDeferred,"PropName") = tPropName
				Set tDeferred(tDeferred,"PropType") = tPropType
				Set tDeferred(tDeferred,"PropColl") = tPropDef.Collection
				Set tDeferred(tDeferred,"PropParm") = tPropDef.Parameters
				Continue
			}
			Set tTestString = ""
			If tPropDef.Collection'="" {
				Set tTestString = "If ((r%"_tPropName_")&&(.."_tPropName_".Count())) { Set tHasVal=0 For i=1:1:.."_tPropName_".Count() {Set tHasVal=.."_tPropName_".GetAt(i).%FHIRObjectHasValue() If tHasVal=1 Quit} If tHasVal=1 Quit 1 }"
			} ElseIf (tPropDef.Parameters.GetAt("XMLPROJECTION")="ATTRIBUTE")||($Extract(tPropType,*-8,*)="Primitive")||(tPropName="div") {
				Set tTestString = "If .."_tPropName_"'="""" Quit 1"
			} Else {
				Set tTestString = "If (r%"_tPropName_")&&(.."_tPropName_".%FHIRObjectHasValue()) Quit 1"
			}
			Do %code.WriteLine(" "_tTestString)
		}
	}
	If $Data(tDeferred) {
		// These properties were deferred to be at the end of the block of checks
		// because they are far less likely to be populated than other properties.
		Set tN = ""
		For {
			Set tN = $Order(tDeferred(tN))
			If tN="" Quit
			Set tPropName = tDeferred(tN,"PropName")
			Set tPropType = tDeferred(tN,"PropType")
			Set tPropColl = tDeferred(tN,"PropColl")
			Set tPropParm = tDeferred(tN,"PropParm")
			Set tTestString = ""
			If tPropColl'="" {
				Set tTestString = "If ((r%"_tPropName_")&&(.."_tPropName_".Count())) { Set tHasVal=0 For i=1:1:.."_tPropName_".Count() {Set tHasVal=.."_tPropName_".GetAt(i).%FHIRObjectHasValue() If tHasVal=1 Quit} If tHasVal=1 Quit 1 }"
			} ElseIf (tPropParm.GetAt("XMLPROJECTION")="ATTRIBUTE")||($Extract(tPropType,*-8,*)="Primitive")||(tPropName="div") {
				Set tTestString = "If .."_tPropName_"'="""" Quit 1"
			} Else {
				Set tTestString = "If (r%"_tPropName_")&&(.."_tPropName_".%FHIRObjectHasValue()) Quit 1"
			}
			Do %code.WriteLine(" "_tTestString)
		}
	}
		
	Do %code.WriteLine(" Quit 0")
	
	Quit $$$OK
}

}
