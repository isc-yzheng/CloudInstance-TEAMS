Include %occInclude

Class HS.XML.AdaptorFHIR [ Abstract, System = 2 ]
{

Method %GetClassName() As %String
{
	Quit $classname($this)
}

Method %ToFHIRXML(pLevel As %Integer = 0, pXMLName As %String = "", pSuppressProlog As %Boolean = 0) As %Status [ CodeMode = objectgenerator, GenerateAfter = %XMLGenerate ]
{
	If (%class.Abstract) {
		Quit $$$OK
	}
	
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
	
	Do %code.WriteLine("	Set tSC = $$$OK")
	Do %code.WriteLine("	Try {")
	Do %code.WriteLine("  		Set tTabChar=$G(%formattabchar,$C(9))")
	Do %code.WriteLine("  		Set tCr=$G(%formatcrchar,$C(13,10))")
	Do %code.WriteLine("		Set tClassName = ..%GetClassName() Set $Piece(tTab,tTabChar,pLevel+1)=""""")
	
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
		If $Extract(tSuper(i),1,tPackageRootL)'=tPackageRoot Continue
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
			Set tTestString = ""
			If tPropDef.Collection'="" {
				Set tTestString = "(('r%"_tPropName_")||((r%"_tPropName_")&&(.."_tPropName_".Count()=0)))"
			} ElseIf (tPropDef.Parameters.GetAt("XMLPROJECTION")="ATTRIBUTE")||($Extract(tPropDef.Type,*-8,*)="Primitive")||(tPropName="div") {
				Set tTestString = "(.."_tPropName_"="""")"
			} Else {
				Set tTestString = "('r%"_tPropName_")"
			}
			If tIfString="" {
				Set tIfString = tIfString_"If "_tTestString
			} Else {
				Set tIfString = tIfString_"&&"_tTestString
			}
		}
	}
	
	// An empty resource is valid. Therefore if the current class is a resource class
	// then continue on regardless of whether any of the non-attribute properties has
	// a value. The close of top tag plus the ending tag will be written in that case
	// (e.g., <Parameters xmlns="http://hl7.org/fhir"></Parameters>).
	Set tIsResourceClass =($Piece(%class.Name,".",*-1)="Resource")
	If 'tIsResourceClass {
		Do %code.WriteLine("		"_tIfString_" Quit")
	}
	
	
	Do %code.WriteLine("		If (pLevel=0)&&('pSuppressProlog) Write ""<?xml version=""""1.0"""" encoding=""""UTF-8""""?>""_tCr")
	Do %code.WriteLine("		If pXMLName'="""" { Write tTab_""<""_pXMLName } Else { Write tTab_""<""_$Piece(tClassName,""."",$Length(tClassName,""."")) }")
	Do %code.WriteLine("		If pLevel=0 Write "" xmlns=""""http://hl7.org/fhir""""""")
	
	
	#; Export the properties that are attributes first.
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
			Set tPropType = tPropList(s,k).Type
			Set tClientType = $$$comClassKeyGet(tPropType,$$$cCLASSclientdatatype)
			Set tVar = ".."_tPropName
			If (tPropDef.Parameters.GetAt("XMLPROJECTION")="ATTRIBUTE")||($Extract(tPropType,*-8,*)="Primitive")||(tPropName="div") {
				Set tRVar = ".."_tPropName_"'="""""
			} Else {
				Set tRVar = "r%"_tPropName
			}
			If tPropList(s,k).Parameters.GetAt("XMLPROJECTION")="ATTRIBUTE" {
				If tClientType="BOOLEAN" {
					Do %code.WriteLine("		If "_tRVar_" Write "" "_tPropName_"=""""""_$Select(+"_tVar_"=1:""true"","_tVar_"=""true"":""true"",1:""false"")_""""""""")
				} ElseIf tClientType="BINARY" {
					Do %code.WriteLine("		If "_tRVar_" Write "" "_tPropName_"=""""""_$ZConvert($system.Encryption.Base64Encode("_tVar_"),""O"",""XML"")_""""""""")
				} ElseIf (tClientType="DECIMAL")||(tClientType="DOUBLE")||(tClientType="NUMERIC") {
					Do %code.WriteLine("		If "_tRVar_" Write "" "_tPropName_"=""""""_$FN("_tVar_",""LON"",$L($P("_tVar_",""."",2)))_""""""""")
				} ElseIf tClientType="INTEGER" {
					Do %code.WriteLine("		If "_tRVar_" Write "" "_tPropName_"=""""""_$FN("_tVar_",""LON"",0)_""""""""")
				} ElseIf $$$comSubMemberDefined(%class.Name,$$$cCLASSproperty,tPropName,$$$cPROPmethod,"LogicalToXSD") {
					Do %code.WriteLine("		If "_tRVar_" Write "" "_tPropName_"=""""""_"_tVar_"LogicalToXSD("_tVar_")_""""""""")
				} Else {
					Do %code.WriteLine("		If "_tRVar_" Write "" "_tPropName_"=""""""_$ZConvert("_tVar_",""O"",""XML"")_""""""""")
				}
				Kill tPropList(s,k)
			}
		}
	}
	
	#; If no properties left after the attributes, then close the empty element and quit.
	If $Data(tPropList)=0 Do %code.WriteLine("		Write ""/>""_tCr Quit") Quit $$$OK
	
	
	#; Build a single If statement that checks to see if any remaining properties have data.
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
			Set tTestString = ""
			If tPropDef.Collection'="" {
				Set tTestString = "(('r%"_tPropName_")||((r%"_tPropName_")&&(.."_tPropName_".Count()=0)))"
			} ElseIf (tPropDef.Parameters.GetAt("XMLPROJECTION")="ATTRIBUTE")||($Extract(tPropDef.Type,*-8,*)="Primitive")||(tPropName="div") {
				Set tTestString = "(.."_tPropName_"="""")"
			} Else {
				Set tTestString = "('r%"_tPropName_")"
			}
			If tIfString="" {
				Set tIfString = tIfString_"If "_tTestString
			} Else {
				Set tIfString = tIfString_"&&"_tTestString
			}
		}
	}
	
	#; If no other properties have data, then close the empty element and quit.
	If 'tIsResourceClass {
		Do %code.WriteLine("		"_tIfString_" Write ""/>""_tCr Quit")
	}
	
	#; Otherwise close the starting element and proceed with the properties.
	Do %code.WriteLine("		Write "">""_tCr")

	#; Get the remaining properties.
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
			Set tVar = ".."_tPropName
			If (tPropDef.Parameters.GetAt("XMLPROJECTION")="ATTRIBUTE")||($Extract(tPropDef.Type,*-8,*)="Primitive") {
				Set tRVar = ".."_tPropName_"'="""""
			} Else {
				If tPropDef.Collection="" {
					Set tRVar = "((r%"_tPropName_")&&("_tVar_".%FHIRObjectHasValue()))"
				} Else {
					Set tRVar = "r%"_tPropName
				}
			}
			If tPropName="div" {
				Do %code.WriteLine("		If ..div'="""" {")
				Do %code.WriteLine("			Set tDivWithNS=""<div xmlns=""""http://www.w3.org/1999/xhtml"""">""")
				Do %code.WriteLine("			Write tTab_tTabChar_tDivWithNS_tCr")
				Do %code.WriteLine("			If $E(..div,1,42)=tDivWithNS {")
				Do %code.WriteLine("				Write tTab_tTabChar_tTabChar_$E(..div,43,*)_tCr")
				Do %code.WriteLine("			} ElseIf $E(..div,1,5)=""<div>"" {")
				Do %code.WriteLine("				Write tTab_tTabChar_tTabChar_$E(..div,6,*)_tCr")
				Do %code.WriteLine("			} Else {")
				Do %code.WriteLine("				Write tTab_tTabChar_tTabChar_..div_tCr")
				Do %code.WriteLine("				Write tTab_tTabChar_""</div>""_tCr")
				Do %code.WriteLine("			}")
				Do %code.WriteLine("		}")
			} ElseIf tPropDef.Collection="" {
				Do %code.WriteLine("		If "_tRVar_" Set tSC = "_tVar_".%ToFHIRXML(pLevel+1,"""_tPropDef.Parameters.GetAt("XMLNAME")_""") If $$$ISERR(tSC) Quit")
			} Else {
				Do %code.WriteLine("		If "_tRVar_" If "_tVar_".Count()>0 For i = 1:1:"_tVar_".Count() If "_tVar_".GetAt(i).%FHIRObjectHasValue() Set tSC = "_tVar_".GetAt(i).%ToFHIRXML(pLevel+1,"""_tPropDef.Parameters.GetAt("XMLNAME")_""") If $$$ISERR(tSC) Quit")
				Do %code.WriteLine("		If $$$ISERR(tSC) Quit")
			}
		}
	}
	
	#; Write the closing tag.
	Do %code.WriteLine("		If pXMLName'="""" { Write tTab_""</""_pXMLName_"">""_tCr } Else { Write tTab_""</""_$Piece(tClassName,""."",$Length(tClassName,"".""))_"">"" }")
	
	Do %code.WriteLine("	} Catch(ex) {")
	Do %code.WriteLine("		Set tSC = ex.AsStatus()")
	Do %code.WriteLine("	}")
	Do %code.WriteLine("	Quit tSC")
	
	Quit $$$OK
}

/// This method instantiates an HS FHIR object from a FHIR XML stream or string and returns it.<br>
/// <br>
/// Inputs:<br>
/// <li>pXMLStreamOrString  : (required if pXMLDocument not passed in) An XML stream object or string.
/// <li>pResourceSchemaRoot : (required) Class package to use as the schema root for FHIR resources.
///                           Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pXMLDocument        : (required if pXMLStreamOrString not passed in) %XML.Document representation
///                           of the FHIR XML.
/// <br><br>
/// Outputs:<br>
/// <li>pHSFHIRObj          : The HS FHIR object constructed from the FHIR XML. If an error is incurred
///                           during the construction of pHSFHIRObj, then pHSFHIRObj is returned as
///                           $$$NULLOREF.<br>
/// <li>pXMLDocument        : %XML.Document representation of the XML payload, created by this method
///                           if it was not passed in as input.  If pXMLDocument was not passed in as
///                           input, AND if an error is incurred during the construction of pHSFHIRObj,
///                           then pXMLDocument is returned as $$$NULLOREF.
ClassMethod %FromFHIRXML(pXMLStreamOrString, ByRef pHSFHIRObj As %RegisteredObject, pResourceSchemaRoot As %String, ByRef pXMLDocument As %XML.Document) As %Status
{
	Set tSC = $$$OK
	
	#dim tNode As %XML.Node
	
	Try {
		Kill pHSFHIRObj
		
		Set tXMLDocumentInput = 0
		
		If $IsObject($Get(pXMLDocument))&&(pXMLDocument.%IsA("%XML.Document")) {
			// Just use pXMLDocument if it was passed in.
			Set tXMLDocumentInput = 1
		} ElseIf '$IsObject($Get(pXMLStreamOrString)) {
			// String must have a value.
			If $Length($Get(pXMLStreamOrString)) {
				Set tTempStream = ##class(%Stream.TmpCharacter).%New()
				Do tTempStream.Write(pXMLStreamOrString)
				Do tTempStream.Rewind()
				Set tSC = ##class(%XML.Document).GetDocumentFromStream(tTempStream, .pXMLDocument)
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Blank XML data string specified")
			}
		} ElseIf $IsObject($Get(pXMLStreamOrString))&&(pXMLStreamOrString.%IsA("%Stream.Object")) {
			// Stream must have contents.
			If pXMLStreamOrString.Size{
				Set tSC = ##class(%XML.Document).GetDocumentFromStream(pXMLStreamOrString, .pXMLDocument)
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Blank XML data stream specified")
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError,"Invalid XML input - must be a string, a stream object or a %XML.Document object")
		}
		If $$$ISERR(tSC) Quit
		
		Set tNode = pXMLDocument.GetDocumentElement()
		
		Set tTopResourceName = ""
		
		If tNode.NodeType=$$$xmlELEMENTNODE {
			If tNode.Namespace'="http://hl7.org/fhir" {
				Set tSC = $$$ERROR($$$GeneralError,"FHIR namespace not found")
				Quit
			}
			Set tTopResourceName = tNode.LocalName
		}
		If tTopResourceName="" {
			Set tSC = $$$ERROR($$$GeneralError,"Top level FHIR resource name not found")
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
		
		Set tSC = ..%FromFHIRXML2(tNode, pHSFHIRObj)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		Set pHSFHIRObj = $$$NULLOREF
		If '$Get(tXMLDocumentInput) Set pXMLDocument = $$$NULLOREF
	}
	
	Quit tSC
}

ClassMethod %FromFHIRXML2(pNode As %XML.Node, ByRef pHSFHIRObj As %RegisteredObject) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tHSFHIRClass = pHSFHIRObj.%ClassName(1)
		
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(tHSFHIRClass))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tHSFHIRClass)
		
		Set tHasChild = pNode.HasChildNodes(1)
		Set tNumAtt = pNode.GetNumberAttributes()
		
		If tNumAtt>0 {
			Set tAttName = ""
			For {
				Set tAttName = pNode.NextAttributeName(tAttName)
				If tAttName="" Quit
				Set tValue = pNode.GetAttributeValue(tAttName)
				If tAttName="value" {
					If $Extract(tHSFHIRClass,*-7,*)'=".Boolean" {
						Set pHSFHIRObj.value = tValue
					} Else {
						Set pHSFHIRObj.value = $Case(tValue, "true":1, "false":0, 1:1, 0:0, :0)
					}
				} ElseIf tAttName="url" {
					Set pHSFHIRObj.url = tValue
				} ElseIf tAttName="id" {
					Set pHSFHIRObj.id = tValue
				}
			}
		}
		If $$$ISERR(tSC) Quit
		
		If 'tHasChild Quit
		
		// Save the current node id so that we may re-set back to it before returning.
		Set tSaveNodeId = pNode.NodeId
		If 'pNode.MoveToFirstChild(1) Quit
		
		For {
			Set tPropName = pNode.LocalName
			If '$Data(%propsByName(tHSFHIRClass,tPropName)) {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid property '"_tPropName_"' for class "_tHSFHIRClass)
				Quit
			}
			
			If (tPropName="div")&&($Extract(tHSFHIRClass,*-9,*)=".Narrative") {
				If (pNode.Namespace="")||(pNode.Namespace="http://hl7.org/fhir") {
					Set pNode.Namespace = "http://www.w3.org/1999/xhtml"
				}
				If pNode.Namespace="http://www.w3.org/1999/xhtml" {
					// Gather div as an xhtml string with all whitespace preserved.
					Set tString = ""
					Set tSC = ..FHIRXMLDivString(pNode, .tString)
					If $$$ISERR(tSC) Quit
					Set tString = $ZStrip(tString,"<>W")
					Set pHSFHIRObj.div = tString
					If 'pNode.MoveToNextSibling(1) Quit
					Continue
				} Else {
					Set tSC = $$$ERROR($$$GeneralError,"Invalid namespace on Narrative div property")
					Quit
				}
			}
			
			Set tHSFHIRPropClass = $Get(%propsByName(tHSFHIRClass, tPropName, "Type"))
			If tHSFHIRPropClass="" {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid property '"_tPropName_"' found on "_tHSFHIRClass_" object")
				Quit
			}
			
			Set tPropertyObj = $ClassMethod(tHSFHIRPropClass, "%New")
			Set tSC = ..%FromFHIRXML2(pNode, .tPropertyObj)
			If $$$ISERR(tSC) Quit
			If '%propsByName(tHSFHIRClass, tPropName, "Collection") {
				Set $Property(pHSFHIRObj, tPropName) = tPropertyObj
			} Else {
				Set tSC = $Property(pHSFHIRObj, tPropName).Insert(tPropertyObj)
				If $$$ISERR(tSC) Quit
			}
			If 'pNode.MoveToNextSibling(1) Quit
			Continue
		}
		
		Set pNode.NodeId = tSaveNodeId
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// FHIRXMLDivString parses the div of a FHIR XML resource and builds and returns
/// a string that represents the div xhtml with whitespace preserved.
ClassMethod FHIRXMLDivString(pNode As %XML.Node, ByRef pDivString As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		For {
			Set tNodeType = pNode.NodeType
			
			If tNodeType=$$$xmlELEMENTNODE {
				Set tPropName = pNode.LocalName
				Set pDivString = pDivString_"<"_tPropName
				Set tNumAtt = pNode.GetNumberAttributes()
				Set tHasChild = pNode.HasChildNodes()
				If tNumAtt>0 {
					Set tAttName = ""
					For {
						Set tAttName = pNode.NextAttributeName(tAttName)
						If tAttName="" Quit
						Set tAttValue = pNode.GetAttributeValue(tAttName)
						Set pDivString = pDivString_" "_tAttName_"="""_$ZConvert(tAttValue,"O","HTML")_""""
					}
				}
				If tHasChild {
					Set pDivString = pDivString_">"
					Set tSaveNodeId = pNode.NodeId
					Set tBoolean = pNode.MoveToFirstChild()
					Set tSC = ..FHIRXMLDivString(pNode, .pDivString)
					If $$$ISERR(tSC) Quit
					Set pNode.NodeId = tSaveNodeId
					Set pDivString = pDivString_"</"_tPropName_">"
					Set tBoolean = pNode.MoveToNextSibling()
				} Else {
					Set pDivString = pDivString_">"
					Set tBoolean = pNode.MoveToNextSibling()
				}
				If 'tBoolean Quit
			} Else {
				// is $$$xmlTEXTNODE or $$$xmlWHITESPACENODE
				Set pDivString = pDivString_pNode.NodeData
				Set tBoolean = pNode.MoveToNextSibling()
				If 'tBoolean Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Get the definition information for a given property. This is currently based on class definitions.
ClassMethod GetPropInfo(pHSFHIRClass As %String) [ Internal ]
{
	// Retaining as a stub in case anyone else was inappropriately using it directly.
	Do ##class(HS.FHIR.Utils).GetPropInfo(pHSFHIRClass)
	Quit
}

}
