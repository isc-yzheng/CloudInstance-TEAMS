Class HS.FHIR.DTL.Util.XML.Adapter [ Abstract ]
{

/// API
/// Deserialize a FHIR XML resource string or stream into an instance of a class in HS.FHIR.DTL.<i>fhirVersion</i>.Model.<br>
/// <br>
/// This classmethod can be called on the object type in question when the resource type is known.
/// For example: set object = ##class(HS.FHIR.DTL.vSTU3.Model.Resource.Patient).FromXML(xml)<br>
/// <br>
/// Otherwise, regardless of whether the resource type is known or not, you can call this method
/// via HS.FHIR.DTL.<i>fhirVersion</i>.Model.Base.Resource.<br>
/// Examples: set object = ##class(HS.FHIR.DTL.vSTU3.Model.Base.Resource).FromXML(xml),
/// set object = ##class(HS.FHIR.DTL.vDSTU2.Model.Base.Resource).FromXML(xml)<br>
/// <br>
/// Input:<br>
/// xml: (required) FHIR XML resource string or stream.<br>
/// <br>
/// Return:<br>
/// FHIR data model object instance. Use $classname(object) or object.%ClassName(1) to determine the returned object type.
ClassMethod FromXML(xml) As %RegisteredObject
{
	if $classname()="HS.FHIR.DTL.Util.XML.Adapter" {
		set sc = $$$ERROR($$$GeneralError, "FromXML() cannot be used via direct call to HS.FHIR.DTL.Util.XML.Adapter")
	} elseif '$isObject($get(xml)) {
		// Input string must have a value.
		if $length($get(xml)) {
			set tempStream = ##class(%Stream.TmpCharacter).%New()
			do tempStream.Write(xml)
			do tempStream.Rewind()
			set sc = ##class(%XML.Document).GetDocumentFromStream(tempStream, .xmlDocument)
			if $$$ISERR(sc) set sc = $$$ERROR($$$GeneralError, $system.Status.GetErrorText(sc)_" - XML input may not be well-formed")
		} else {
			set sc = $$$ERROR($$$GeneralError, "Blank XML data string specified")
		}
	} elseIf $isObject($get(xml))&&(xml.%IsA("%Stream.Object")) {
		// Input stream must have contents.
		if xml.Size{
			set sc = ##class(%XML.Document).GetDocumentFromStream(xml, .xmlDocument)
			if $$$ISERR(sc) set sc = $$$ERROR($$$GeneralError, $system.Status.GetErrorText(sc)_" - XML input may not be well-formed")
		} else {
			set sc = $$$ERROR($$$GeneralError, "Blank XML data stream specified")
		}
	} else {
		set sc = $$$ERROR($$$GeneralError,"Invalid XML input - must be a string or a stream object")
	}
	$$$ThrowOnError(sc)
	if '$isobject(xmlDocument) {
		$$$ThrowOnError($$$ERROR($$$GeneralError, "%XML.Document object could not be created from the XML stream"))
	}
	
	set tNode = xmlDocument.GetDocumentElement()
	
	new %propertyInfo
	
	quit ..FromXMLHelper(tNode)
}

/// Helper method for deserializing a xml stream into an object.
ClassMethod FromXMLHelper(pNode As %XML.Node) As %RegisteredObject
{
	set propertyName = pNode.LocalName
	
	set className =  $classname($this)
	
	if ((className = "HS.FHIR.DTL.vR4.Model.Base.Resource")||(className = "HS.FHIR.DTL.vSTU3.Model.Base.Resource")||(className = "HS.FHIR.DTL.vDSTU2.Model.Base.Resource")) {
		// If *.Model.Base.Resource ToXML() was called, then className will be the full
		// name of the *.Model.Base.Resource class. However, className will also be
		// *.Model.Base.Resource when the current property is typed as *.Model.Base.Resource.
		// Therefore, we need to first make sure it's not a Resource-typed property.
		if (className = "HS.FHIR.DTL.vR4.Model.Base.Resource") {
			set resourceRoot = "HS.FHIR.DTL.vR4.Model.Resource"
		} elseif (className = "HS.FHIR.DTL.vSTU3.Model.Base.Resource") {
			set resourceRoot = "HS.FHIR.DTL.vSTU3.Model.Resource"
		} elseif (className = "HS.FHIR.DTL.vDSTU2.Model.Base.Resource") {
			set resourceRoot = "HS.FHIR.DTL.vDSTU2.Model.Resource"
		}
		if ((propertyName = "resource")||(propertyName = "contained")||(propertyName = "outcome")) {
			// If this is a Resource-typed property, advance down to the resource itself,
			// and change the class name to the class name for the type of resource.
			if pNode.MoveToFirstChild(1)
			set className = resourceRoot_"."_pNode.LocalName
		} else {
			// At this point, if the class is *.Model.Base.Resource, then it must
			// be the top level of the FHIR resource input.
			set className = resourceRoot_"."_propertyName
		}
	}
	
	set obj = $classmethod(className, "%New")
	
	If pNode.GetAttributeValue("url")'="" {
		Set $Property(obj, "url") = pNode.GetAttributeValue("url")
	}
	
	If pNode.GetAttributeValue("id")'="" {
		Set $Property(obj, "id") = pNode.GetAttributeValue("id")
	}
	
	// Save the current node id so that we may re-set back to it before returning.
	Set saveNodeId = pNode.NodeId
	
	if 'pNode.MoveToFirstChild(1) quit
	
	// Loop through the pNode properties.
	for {
		set propertyName = pNode.LocalName
		if $i(propertyCount(propertyName))
		if '$data(%propertyInfo(className, propertyName, "Type")) {
			set propertyType = $$$comMemberKeyGet(className, $$$cCLASSproperty, propertyName, $$$cPROPtype)
			set propertyCollection = $$$comMemberKeyGet(className, $$$cCLASSproperty, propertyName, $$$cPROPcollection)
			set %propertyInfo(className, propertyName, "Type") = propertyType
			set %propertyInfo(className, propertyName, "Collection") = propertyCollection
		}
		else {
			set propertyType = %propertyInfo(className, propertyName, "Type")
			set propertyCollection = %propertyInfo(className, propertyName, "Collection")
		}
		if (propertyCollection="")&&(propertyCount(propertyName)>1) {
			$$$ThrowOnError($$$ERROR($$$GeneralError, className _ " property '" _ propertyName _ "' has cardinality of one, but recieved a list"))
		}
		
		// Special handling of the div string property.
		if (propertyName="div") {
			// Gather div as an xhtml string with all whitespace preserved.
			set string = ""
			set sc = ..FHIRXMLDivString(pNode, .string)
			$$$ThrowOnError(sc)
			set string = $ZStrip(string, "<>W")
			set obj.div = string
			if 'pNode.MoveToNextSibling(1) quit
			continue
		}
		
		// We got url and id attributes earlier.
		// Get the value attribute, if any.
		set primitiveValue = ""
		if pNode.GetNumberAttributes()>0 {
			set primitiveValue = pNode.GetAttributeValue("value")
			if primitiveValue'="" {
				if $extract(propertyType, *-6, *)="Boolean" {
					set primitiveValue = $Case(primitiveValue, "true":1, "false":0, 1:1, 0:0, :0)
				}
				if propertyCollection="" {
					set $property(obj, propertyName) = primitiveValue
				} else {
					do $method($property(obj, propertyName), "Insert", primitiveValue)
				}
			}
		}
		
		// Save the current property node id so that we may re-set back to it after
		// returning from a recursive call to de-serialize an object property.
		set savePropNodeId = pNode.NodeId
		
		if $extract(propertyType)="%" {
			// Primitive property that has children has primitive extensions.
			if pNode.HasChildNodes(1) {
				if '$data(%propertyInfo(className, "primitiveExtension", "Type")) {
					set extensionClass = $$$comMemberKeyGet(className, $$$cCLASSproperty, "primitiveExtension", $$$cPROPtype)
				} else {
					set extensionClass = %propertyInfo(className, "primitiveExtension", "Type")
				}
				// MoveToFirstChild(1) is guaranteed to be 1 because we already checked HasChildNodes(1).
				if pNode.MoveToFirstChild(1)
				set extobj = $classmethod(extensionClass, "FromXMLHelper", pNode)
				do obj.primitiveExtension.Insert(extobj)
    			if ($listvalid(primitiveValue))&&(primitiveValue'="") {
	    			set primitiveValue = $listupdate(primitiveValue, $listlength(primitiveValue) + 1, obj.primitiveExtension.Count())
    			} else {
	    			set primitiveValue = $listbuild(primitiveValue, obj.primitiveExtension.Count())
    			}
    			if propertyCollection="" {
    				set $property(obj, propertyName) = primitiveValue
    			} else {
	    			if $listget(primitiveValue,1)="" {
	    				do $method($property(obj, propertyName), "Insert", primitiveValue)
	    			} else {
	    				do $method($property(obj, propertyName), "SetAt", primitiveValue, $property(obj, propertyName).Count())
	    			}
    			}
				for {
					if 'pNode.MoveToNextSibling(1) quit
					set extobj = $classmethod(extensionClass, "FromXMLHelper", pNode)
					do obj.primitiveExtension.Insert(extobj)
		    		set primitiveValue = $listupdate(primitiveValue, $listlength(primitiveValue) + 1, obj.primitiveExtension.Count())
	    			if propertyCollection="" {
	    				set $property(obj, propertyName) = primitiveValue
	    			} else {
		    			do $method($property(obj, propertyName), "SetAt", primitiveValue, $property(obj, propertyName).Count())
	    			}
				}
				set pNode.NodeId = savePropNodeId
				
			}
		} elseif propertyCollection="" { // singleton object
			set $property(obj, propertyName) = $classmethod(propertyType, "FromXMLHelper", pNode)
			set pNode.NodeId = savePropNodeId
		} else { // list of objects
			do $method($property(obj, propertyName), "Insert", $classmethod(propertyType, "FromXMLHelper", pNode))
			set pNode.NodeId = savePropNodeId
		}
		
		if 'pNode.MoveToNextSibling(1) quit
		continue
	}
	
	set pNode.NodeId = saveNodeId
	
	quit obj
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

/// API
/// Serialize a FHIR data model object instance into a FHIR XML stream.<br>
/// <br>
/// Input:<br>
/// tabChar: "tab" character(s) for indent formatting. Default value is none.<br>
/// newLine: Line terminator character(s) for line end formatting. Default value is none.<br>
/// <br>
/// Return:<br>
/// FHIR XML resource stream object.<br>
Method ToXML(tabChar As %String = "", newLine As %String = "") As %Stream.Object [ CodeMode = objectgenerator ]
{
	if (%class.Abstract) {
		quit $$$OK
	}
	do %code.WriteLine("  set outputStream = ##class(%Stream.TmpCharacter).%New()")
	do %code.WriteLine("  set xmlString = """"")
	do %code.WriteLine("  set xmlString = xmlString _ ""<"" _ ..%ClassName(0) _ "" xmlns=""""http://hl7.org/fhir"""">"" _ newLine")
	do %code.WriteLine("  set tSC = ..ToXMLHelper(.outputStream, .xmlString, """", .tabChar, .newLine)")
	do %code.WriteLine("  $$$ThrowOnError(tSC)")
	do %code.WriteLine("  set xmlString = xmlString _ ""</"" _ ..%ClassName(0) _ "">"" _ newLine")
	do %code.WriteLine("  do outputStream.Write(xmlString)")
	do %code.WriteLine("  quit outputStream")
	
	quit $$$OK
}

/// Helper method for serializing a data model object instance into an xml stream.
Method ToXMLHelper(ByRef outputStream As %Stream.Object, Output xmlString As %String, indents As %String = "", tabChar As %String = "", newLine As %String = "") As %Status [ CodeMode = objectgenerator ]
{
	set tSC = $$$OK
	try {
		if (%class.Abstract) {
			quit
		}
	
		do %code.WriteLine("	set tSC = $$$OK")
		do %code.WriteLine("	try {")
		
		do %code.WriteLine("	set hasPrimitiveExtension = 0")
		do %code.WriteLine("	set indents = indents _ tabChar")
		do %code.WriteLine("	")
		
		set parent(1) = %compiledclass.Super
		for i=1:1 {
			set super = ##class(%Dictionary.ClassDefinition).%OpenId(parent(i))
			if '$isobject(super) quit
			if super.Super = "" quit
			set parent(i+1) = super.Super
		}
		set i = i - 1
		set superCount = 1
		for {
			if i = 0 quit
			set super = ##class(%Dictionary.ClassDefinition).%OpenId(parent(i))
			if '$isobject(super) quit
			
			for j=1:1:super.Properties.Count() {
				if $data(excludeList(super.Properties.GetAt(j).Name)) continue
				
				set propList(superCount, super.Properties.GetAt(j).SequenceNumber) = super.Properties.GetAt(j).Name
				set propList(superCount, super.Properties.GetAt(j).SequenceNumber, "type") = super.Properties.GetAt(j).Type
				set propList(superCount, super.Properties.GetAt(j).SequenceNumber, "collection") = super.Properties.GetAt(j).Collection
				
				set excludeList(super.Properties.GetAt(j).Name) = ""
			}
			set superCount = superCount + 1
			set i = i - 1
		}
		
		set superCount = superCount + 1
		for i=1:1:%compiledclass.Properties.Count() {
			if $data(excludeList(%compiledclass.Properties.GetAt(i).Name)) continue
			
			set propList(superCount, %compiledclass.Properties.GetAt(i).SequenceNumber) = %compiledclass.Properties.GetAt(i).Name
			set propList(superCount, %compiledclass.Properties.GetAt(i).SequenceNumber, "type") = %compiledclass.Properties.GetAt(i).Type
			set propList(superCount, %compiledclass.Properties.GetAt(i).SequenceNumber, "collection") = %compiledclass.Properties.GetAt(i).Collection
			
			set excludeList(%compiledclass.Properties.GetAt(i).Name) = ""
		}
		
		set superIndex = $order(propList(""))
		while superIndex '= "" {
			set sequenceIndex = $order(propList(superIndex, ""))
			while sequenceIndex '= "" {
				
				//Get list of properties for the given class
				set propName = propList(superIndex, sequenceIndex)
				set propType = propList(superIndex, sequenceIndex, "type")
				set propColl = propList(superIndex, sequenceIndex, "collection")
				if ($extract(propName) = "%") || (propName = "primitiveExtension") || (propName = "newResource") || (propName = "newResourceReference") || (propName = "resourceType") || ((propName = "url")&&(%compiledclass.Name[".Extension")) {
					set sequenceIndex = $order(propList(superIndex, sequenceIndex))
					continue
				}
				
				set isprimitive = ($extract(propType)="%")
				
				if propName = "div" {
					do %code.WriteLine("	if ..div'="""" {")
					do %code.WriteLine("		set tDivWithNS=""<div xmlns=""""http://www.w3.org/1999/xhtml"""">""")
					do %code.WriteLine("		set addString = indents _ tDivWithNS _ newLine do writeStr")
					do %code.WriteLine("		if $extract(..div,1,42)=tDivWithNS {")
					do %code.WriteLine("			set addString = indents _ $extract(..div,43,*) _ newLine do writeStr")
					do %code.WriteLine("		} elseif $extract(..div,1,5)=""<div>"" {")
					do %code.WriteLine("			set addString = indents _ tabChar _ $extract(..div,6,*) _ newLine do writeStr")
					do %code.WriteLine("		} else {")
					do %code.WriteLine("			set addString = indents _ tabChar _ ..div _ newLine do writeStr")
					do %code.WriteLine("			set addString = indents _ ""</div>"" _ newLine do writeStr")
					do %code.WriteLine("		}")
				}
				//Is a list
				elseif propColl = "list" {
					do %code.WriteLine("	if (r%"_propName_")&&(.." _ propName _ ".Count()>0) {")
					do %code.WriteLine("		for i=1:1:.." _ propName _ ".Count() {")
					
					//Object
					if 'isprimitive {
						do %code.Write("			set addString = indents _ ""<" _ propName _ "")
						if propType [ "Extension" {
							do %code.Write(""" _ $select(.." _ propName _ ".GetAt(i).url'="""":"" url=""""""_.." _ propName _ ".GetAt(i).url_"""""""",1:"""") _ """)
						}
						do %code.WriteLine(">"" _ newLine do writeStr")
						if propName = "contained" {
							do %code.WriteLine("			set indents = indents _ tabChar")
							do %code.WriteLine("			set addString = indents _ ""<"" _ .." _ propName _ ".GetAt(i).%ClassName(0) _ "">"" _ newLine do writeStr")
						}
						do %code.WriteLine("			set tSC = .." _ propName _ ".GetAt(i).ToXMLHelper(.outputStream, .xmlString, .indents, .tabChar, .newLine)")
						do %code.WriteLine("			quit:$$$ISERR(tSC)")
						if propName = "contained" {
							do %code.WriteLine("			set addString = indents _ ""</"" _ .." _ propName _ ".GetAt(i).%ClassName(0) _ "">"" _ newLine do writeStr")
							do %code.WriteLine("			set indents = $replace(indents, tabChar,"""",, 1)")
						}
						do %code.WriteLine("			set addString = indents _ ""</" _ propName _ ">"" _ newLine do writeStr")
					}
					//Primitive
					else {
						
						do %code.WriteLine("			set value = .." _ propName _ ".GetAt(i)")
						do %code.WriteLine("			if $listvalid(value) {")
						do %code.WriteLine("				set valueWithExt = value")
						do %code.WriteLine("				set value = $listget(value, 1)")
						do %code.WriteLine("				set hasPrimitiveExtension = 1")
						do %code.WriteLine("			}")
						do %code.WriteLine("			set addString = indents _ ""<" _ propName _ """ do writeStr")
						do %code.WriteLine("			if value'="""" {")
						do %code.Write("				set addString = "" value=""""""")
						
						if propType [ "Integer" {
							do %code.WriteLine(" _ $FN(value,""LON"",0) _ """""""" do writeStr")
						}
						// decimal-primitive regex is "-?([0]|([1-9][0-9]*))(\.[0-9]+)?"
						// For example: .12 does not match that regex, but 0.12 does.
						elseif (propType [ "Decimal") || (propType [ "Numeric") || (propType [ "Double") {
							do %code.WriteLine(" _ $FN(value,""LON"",$L($P(value,""."",2))) _ """""""" do writeStr")
						}
						elseif propType [ "Boolean" {
							do %code.WriteLine(" _ $select(+value:""true"", 1:""false"") _ """""""" do writeStr")
						}
						else {
							do %code.WriteLine(" _ $zconvert(value, ""O"", ""XML"") _ """""""" do writeStr")
						}
						do %code.WriteLine("			}")
						do %code.WriteLine("			if 'hasPrimitiveExtension {")
						do %code.WriteLine("				set addString = ""/>"" _ newLine do writeStr")
						do %code.WriteLine("			} else {")
						do %code.WriteLine("				set addString = "">"" _ newLine do writeStr")
						do %code.WriteLine("				set hasPrimitiveExtension = 0")
						do %code.WriteLine("				set indents = indents _ tabChar")
						do %code.WriteLine("				for extNum=2:1:$listlength(valueWithExt) {")
						do %code.WriteLine("					set extensionLocation = $listget(valueWithExt, extNum)")
						do %code.WriteLine("					set addString = indents _ ""<extension url="""""" _ ..primitiveExtension.GetAt(extensionLocation).url _ """""">"" _ newLine do writeStr")
						do %code.WriteLine("					set tSC = ..primitiveExtension.GetAt(extensionLocation).ToXMLHelper(.outputStream, .xmlString, .indents, .tabChar, .newLine)")
						do %code.WriteLine("					quit:$$$ISERR(tSC)")
						do %code.WriteLine("					set addString = indents _ ""</extension>"" _ newLine do writeStr")
						do %code.WriteLine("				}")
						do %code.WriteLine("				set indents = $replace(indents, tabChar,"""",, 1)")
						do %code.WriteLine("				set addString = indents _ ""</" _ propName _ ">"" _ newLine do writeStr")
						do %code.WriteLine("				kill valueWithExt")
						do %code.WriteLine("			}")
						
					}
					do %code.WriteLine("		}")
				}
				//Is a single
				else {
					do %code.WriteLine("	if "_$Select('isprimitive:"(r%"_propName_")&&(",1:"")_".." _ propName _ " '= """""_$Select('isprimitive:")",1:"")_" {")
					//Object
					if 'isprimitive {
						do %code.WriteLine("		set addString = indents _ ""<" _ propName _ ">"" _ newLine do writeStr")
						if (propName = "resource") || (propName = "outcome") {
							do %code.WriteLine("		set indents = indents _ tabChar")
							do %code.WriteLine("		set addString = indents _ ""<"" _ .." _ propName _ ".%ClassName(0) _ "">"" _ newLine do writeStr")
						}
						do %code.WriteLine("		set tSC = .." _ propName _ ".ToXMLHelper(.outputStream, .xmlString, .indents, .tabChar, .newLine)")
						do %code.WriteLine("		quit:$$$ISERR(tSC)")
						if (propName = "resource") || (propName = "outcome") {
							do %code.WriteLine("		set addString = indents _ ""</"" _ .." _ propName _ ".%ClassName(0) _ "">"" _ newLine do writeStr")
							do %code.WriteLine("		set indents = $replace(indents, tabChar,"""",, 1)")
						}
						do %code.WriteLine("		set addString = indents _ ""</" _ propName _ ">"" _ newLine do writeStr")
					}
					//Primitive
					else {
						do %code.WriteLine("		set value = .." _ propName)
						do %code.WriteLine("		if $listvalid(value) {")
						do %code.WriteLine("			set valueWithExt = value")
						do %code.WriteLine("			set value = $listget(value, 1)")
						do %code.WriteLine("			set hasPrimitiveExtension = 1")
						do %code.WriteLine("		}")
						do %code.WriteLine("		set addString = indents _ ""<" _ propName _ """ do writeStr")
						do %code.WriteLine("		if value'="""" {")
						do %code.Write("			set addString = "" value=""""""")
						if propType [ "Integer" {
							do %code.WriteLine(" _ $FN(value,""LON"",0) _ """""""" do writeStr")
						}
						// decimal-primitive regex is "-?([0]|([1-9][0-9]*))(\.[0-9]+)?"
						// For example: .12 does not match that regex, but 0.12 does.
						elseif (propType [ "Decimal") || (propType [ "Numeric") || (propType [ "Double") {
							do %code.WriteLine(" _ $FN(value,""LON"",$L($P(value,""."",2))) _ """""""" do writeStr")
						}
						elseif propType [ "Boolean" {
							do %code.WriteLine(" _ $select(value:""true"", 1:""false"") _ """""""" do writeStr")
						}
						else {
							do %code.WriteLine(" _ $zconvert(value, ""O"", ""XML"") _ """""""" do writeStr")
						}
						do %code.WriteLine("		}")
						do %code.WriteLine("		if 'hasPrimitiveExtension {")
						do %code.WriteLine("			set addString = ""/>""_ newLine do writeStr")
						do %code.WriteLine("		} else {")
						do %code.WriteLine("			set addString = "">""_ newLine do writeStr")
						do %code.WriteLine("			set hasPrimitiveExtension = 0")
						do %code.WriteLine("			set indents = indents _ tabChar")
						do %code.WriteLine("			for extNum=2:1:$listlength(valueWithExt) {")
						do %code.WriteLine("				set extensionLocation = $listget(valueWithExt, extNum)")
						do %code.WriteLine("				set addString = indents _ ""<extension url="""""" _ ..primitiveExtension.GetAt(extensionLocation).url _ """""">"" _ newLine do writeStr")
						do %code.WriteLine("				set tSC = ..primitiveExtension.GetAt(extensionLocation).ToXMLHelper(.outputStream, .xmlString, .indents, .tabChar, .newLine)")
						do %code.WriteLine("				quit:$$$ISERR(tSC)")
						do %code.WriteLine("				set addString = indents _ ""</extension>"" _ newLine do writeStr")
						do %code.WriteLine("			}")
						do %code.WriteLine("			set indents = $replace(indents, tabChar,"""",, 1)")
						do %code.WriteLine("			set addString = indents _ ""</" _ propName _ ">"" _ newLine do writeStr")
						do %code.WriteLine("			kill valueWithExt")
						do %code.WriteLine("		}")
					}
				}
				do %code.WriteLine("	}")
				
				set sequenceIndex = $order(propList(superIndex, sequenceIndex))
			}
			set superIndex = $order(propList(superIndex))
		}
		
		do %code.WriteLine("	set indents = $replace(indents, tabChar,"""",, 1)")
		
		do %code.WriteLine("	} catch ex {")
		do %code.WriteLine("		set tSC = ex.AsStatus()")
		do %code.WriteLine("	}")
		do %code.WriteLine("	quit tSC")
		do %code.WriteLine("writeStr")
		do %code.WriteLine("	if ($length(addString)+$length(xmlString))>2048 do outputStream.Write(xmlString) set xmlString = """"")
		do %code.WriteLine("	set xmlString = xmlString _ addString")
		do %code.WriteLine("	quit")
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
