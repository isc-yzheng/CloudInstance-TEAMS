/// Convert class annotations to HL7-SDA mapping xmls.
Class HS.Doc.Mapping.HL7ToSDAMapper [ Abstract ]
{

Parameter HL7VERSION = "2.5.1";

Parameter HL7IDENTIFIER = "HL7:";

/// HL7 -> SDA
ClassMethod BuildMapping(pSDAClassName As %String = "", Output pMap As HS.Doc.Mapping.Common.HealthShareMapping, displayDetail As %Boolean = 0) As %Status
{
	Set tStatus = $$$OK
	Set identifier = ..#HL7IDENTIFIER	// Sign of existed HL7 mapping
	
	Try {
		Set pMap = ""
		If (pSDAClassName = "") || '##class(%Dictionary.CompiledClass).%ExistsId(pSDAClassName) {
			Set tStatus = $$$ERROR($$$ClassDoesNotExist,pSDAClassName)
			Quit
		}
		Set tClassData = ##class(%Dictionary.CompiledClass).%OpenId(pSDAClassName,,.tStatus)
		If $$$ISERR(tStatus) Quit
		
		Set pMap = ##class(HS.Doc.Mapping.Common.HealthShareMapping).%New()
		Set pMap.name = "Test " _ pSDAClassName
		
		// Insert DocumentType Headers
		Set tHL7DocumentType = ##class(HS.Doc.Mapping.HL7.DocumentType).%New()
		Set tHL7DocumentType.docType = "HL7"
		Set tHL7DocumentType.Version = ..#HL7VERSION
		// Do tHL7DocumentType.MessageType.Insert("")	// A list of qualified message types
														// Leave blank for now
		Set tSDADocumentType = ##class(HS.Doc.Mapping.SDA.DocumentType).%New()
		Set tSDADocumentType.docType = "XML"
		Do tSDADocumentType.Streamlet.Insert(pSDAClassName)	// A list of streamlets can be updated
															// Only 1 for now
		
		Set pMap.Source = tHL7DocumentType
		Set pMap.Target = tSDADocumentType
		
		Set tMapping = ##class(HS.Doc.Mapping.Common.Mapping).%New()
		Do pMap.Mappings.Insert(tMapping)

		#dim tProperty As %Dictionary.CompiledProperty
		// Loop over tClass.Properties
		For i=1:1:tClassData.Properties.Count() {
			Set tProperty = tClassData.Properties.GetAt(i)
			If (tProperty.Description '= "") && (tProperty.Description [ identifier) {
				Set tTarget = ##class(HS.Doc.Mapping.SDA.MappingTarget).%New()
				Set tTarget.Streamlet = pSDAClassName
				Set tTarget.Root = tProperty.Name
				
				// Extract note for <target> property
				// If contains "HL7ToSDA3:", Use the content before that as note
				If (tProperty.Description [ "HL7ToSDA3:") {
					Set note = $piece(tProperty.Description, "HL7ToSDA3:", 1)
				}
				// Else, use the first line as note
				Else {
					Set note = $piece(tProperty.Description, "<br>", 1)
				}
				
				If $Replace($Translate(note,$Char(9,10,13,32)),"<br>","")'="" {
					Set tTarget.Note = $Replace(note, "<br>", "")
				}
				
				// Parse description to SDA target fields
				Set st = ..DescriptionToSDATargetFields(tProperty.Description, .SDATargetFields)
				If (st) && (SDATargetFields.Count() '= 0) {
					For j=1:1:SDATargetFields.Count() {
						Do tTarget.Field.Insert(SDATargetFields.GetAt(j))
					}
				}
				Do tMapping.Target.Insert(tTarget)
			}
			
			Write:displayDetail "."	// Progress indicator
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Output a SDA class mapping to file.
ClassMethod OutputMap(pSDAClassName As %String = "", pFilename As %String = "", displayDetail As %Boolean = 0) As %Status
{
	Set tStatus = $$$OK
	Try
	{
		Set tStatus = ..BuildMapping(pSDAClassName,.tMapping, displayDetail)
		If $$$ISERR(tStatus) {
			Write $SYSTEM.Status.GetErrorText(tStatus)
			Quit
		}
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1
		Set tWriter.IndentChars = $char(9)	// 9 is Tab
		Do tWriter.AddInstanceNamespace()	// Get rid of extra xsi attrs
		
		If (pFilename '= "") {
			Set tStatus = tWriter.OutputToFile(pFilename)
			If $$$ISERR(tStatus) {
				Write $SYSTEM.Status.GetErrorText(tStatus)
				Quit
			}
		}
		Set tStatus = tWriter.RootObject(tMapping)
		If $$$ISERR(tStatus) {
			Write $SYSTEM.Status.GetErrorText(tStatus)
			Quit
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
		Write $SYSTEM.Status.GetErrorText(tStatus)
	}
	Quit tStatus
}

/// Output a SDA class mapping to file.
ClassMethod OutputAllMappings(pSDAClassNames As %ListOfDataTypes, pOutputPath As %String = "", displayDetail As %Boolean = 0) As %Status
{
	Set tStatus = $$$OK
	Try
	{
		Set tHSMappings = ##class(%ListOfObjects).%New()
		
		For i=1:1:pSDAClassNames.Count() {
			Set pSDAClassName = pSDAClassNames.GetAt(i)
			Set tStatus = ..BuildMapping(pSDAClassName,.tHSMapping, displayDetail)
			If $$$ISERR(tStatus) Do ..LogError("BuildMapping failed - "_$system.Status.GetErrorText(tStatus)) Continue
			Do tHSMappings.Insert(tHSMapping)
		}
		
		Set tStatus = ..MergeMappings(tHSMappings, .tAllMappings, displayDetail)
		If $$$ISERR(tStatus) Quit
		
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1
		Set tWriter.IndentChars = $char(9)	// 9 is Tab
		Do tWriter.AddInstanceNamespace()	// Get rid of extra xsi attrs
		
		Set tStatus = tWriter.OutputToFile(pOutputPath)
		If $$$ISERR(tStatus) Quit
		
		Set tStatus = tWriter.RootObject(tAllMappings)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Class Method Annotations here
ClassMethod MergeMappings(pMappings As %ListOfObjects, Output pAllMappings As HS.Doc.Mapping.Common.HealthShareMapping, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	
	Try
	{
		Set pAllMappings = ##class(HS.Doc.Mapping.Common.HealthShareMapping).%New()
		Set pAllMappings.name = "HL7 to SDA3 Mapping"
		
		// Insert DocumentType Headers
		Set tHL7DocumentType = ##class(HS.Doc.Mapping.HL7.DocumentType).%New()
		Set tHL7DocumentType.docType = "HL7"
		Set tHL7DocumentType.Version = ..#HL7VERSION

		Set tSDADocumentType = ##class(HS.Doc.Mapping.SDA.DocumentType).%New()
		Set tSDADocumentType.docType = "XML"
		
		For i=1:1:pMappings.Count() {
			Set tHSMapping = pMappings.GetAt(i)
			// W !, tHSMapping.name , " ", tHSMapping.Mappings.GetAt(1).Target.Count()
			// Populate streamlets
			Set tStreamlets = tHSMapping.Target.Streamlet
			For j=1:1:tStreamlets.Count() {
				Set tStreamlet = tStreamlets.GetAt(j)
				If (tSDADocumentType.Streamlet.Find(tStreamlet) = "") {
					Do tSDADocumentType.Streamlet.Insert(tStreamlet)
				}
			}
			
			// Populate mappings
			Set tMappings = tHSMapping.Mappings
			For j=1:1:tMappings.Count() {
				Set tMapping = tMappings.GetAt(j)
				Do pAllMappings.Mappings.Insert(tMapping)
			}
			
			// Populate structured mappings
			Set tSMappings = tHSMapping.StructuredMappings
			For j=1:1:tSMappings.Count() {
				Set tSMapping = tSMappings.GetAt(j)
				Do pAllMappings.StructuredMappings.Insert(tSMapping)
			}
		}
		
		Set pAllMappings.Source = tHL7DocumentType
		Set pAllMappings.Target = tSDADocumentType
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

/// Helper method
/// Description -> Mapping.TargetField(s)
ClassMethod DescriptionToSDATargetFields(Description As %String = "", Output Fields As %ListOfObjects, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	Set start = "HL7ToSDA3:"	// Section starts here
	Set end = "VIEWERLIB:"		// Section ends here
	Set linebreak = "<br>"
	Set Fields = ##class(%ListOfObjects).%New()
	Set delims = ##class(%ListOfDataTypes).%New()

	Try
	{	
		// Find lines start with "." and use them as delimiters
		For i=1:1:$length(Description, linebreak) {
			Set line = $piece(Description, linebreak, i)
			if ($extract(line, 3, 3) = ".") {
				Do delims.Insert(line)
			}
		}
		
		Set remainder = Description
		// Extract each section in reverse order
		For i=delims.Count():-1:1 {
			if (remainder '= "") {
				Set section = $piece(remainder, delims.GetAt(i), 2, $l(remainder, delims.GetAt(i)))
				Set remainder = $piece(remainder, delims.GetAt(i), 1)
				if (section '= "") {
					// Build XPath
					Set path = $piece(delims.GetAt(i), ".", 2, $l(delims.GetAt(i), "."))
					Set path = $replace(path, ".", "/")
					Set path = path _ "/text()"
					Set st = ..SectionToTargetField(path, section, 0, .field, displayDetail)
					if (st) {
						Do Fields.InsertAt(field, 1)
					}
				}
			}
		}
		
		// Get the single field (without path) from the unamed section
		Set section = Description
		If (Description [ start) {
			Set section = $piece(Description, start, 2, $l(Description, start))
		}
		Set section = $piece(section, end, 1)
		Set st = ..SectionToTargetField("text()", section, 0, .field, displayDetail)
		if (st) {
			Do Fields.InsertAt(field, 1)
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

/// Helper method
/// Description section contains HL7 mappings -> HS.Doc.Mapping.Common.TargetField
ClassMethod SectionToTargetField(Path As %String = "", Section As %String = "", IgnoreNote As %Integer = 0, Output TargetField As HS.Doc.Mapping.Common.TargetField, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	Set delim = "<br>"
	Set identifier = "HL7:  "
	Set TargetField = ##class(HS.Doc.Mapping.Common.TargetField).%New()
	Set TargetField.Path = Path
	
	Try
	{
		if ('IgnoreNote) {
		// Extract note
			Set note = Section
			if (note [ "HL7ToSDA3:<br>") {
				Set note = $piece(note, "HL7ToSDA3:<br>", 2, $l(note, "HL7ToSDA3:<br>"))
			}
			Set note = $piece(note, identifier, 1)
			Set note = $piece(note, "Viewer cache:", 1)
			Set note = $piece(note, "Streamlet cache:", 1)
			If $Replace($Translate(note,$Char(9,10,13,32)),"<br>","")'="" {
				Set TargetField.Note = $Replace(note, "<br>", "")
			}
		}
		Set remainder = identifier _ $piece(Section, identifier, 2, $l(Section, identifier))
		for i=1:1:$length(remainder, delim) {
			Set line = $piece(remainder, delim, i)
			if (line [ identifier) {
				// Line -> HL7.SourceField
				Set st = ..LineToSourceField(line, .SourceField, displayDetail)
				if (st) { Do TargetField.Source.Insert(SourceField) }
			}
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

/// Helper method
/// Description Line -> HL7.SourceField
ClassMethod LineToSourceField(Line As %String = "", Output SourceField As HS.Doc.Mapping.HL7.SourceField, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	Set SourceField = ##class(HS.Doc.Mapping.HL7.SourceField).%New()
	
	Try
	{
		Set hl7Codes = $piece($piece(Line, "HL7:  ", 2), " : ", 1)
		Set name = $piece(Line, " : ", 2)
		Set segment = $piece(hl7Codes, "-", 1)
		Set number = $piece(hl7Codes, "-", 2, $l(hl7Codes, "-"))
		
		Set hl7Field = ##class(HS.Doc.Mapping.HL7.HL7Field).%New()
		Set st = ..GetHL7DataType(segment, 
								$piece(number, ".", 1),
								.structure,
								displayDetail)
		If (st) {
			Set hl7Field.structure = structure
		}
		// Set hl7Field.Note = "" // Not exist
		Set hl7Field.Name = name
		Set hl7Field.Number = number
		
		Set SourceField.Segment = segment
		Set SourceField.Field = hl7Field
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	Quit status
}

/// Helper method
/// Retrieve HL7 Data Type fields by segment name and number. 
ClassMethod GetHL7DataType(Segment As %String = "", Number As %String = "", Output DataType As %String, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	Try
	{
		If (Segment = "") || (Number = "") {
			Set status = $$$ERROR($$$GeneralError,"Invalid segment or number")
		}
		ElseIf $data(^||ISC.HS.AnnotationCache(Segment)) {
			Set DataType = $piece($get(^||ISC.HS.AnnotationCache(Segment,Number,"DS")), ":", 2)
		}
		Else {
			Set tSchema = ##class(HS.HL7.Annotation.Data).%New("HealthShare_2.5")
     		Do tSchema.LoadSS(Segment, .tData)
     		Merge ^||ISC.HS.AnnotationCache(Segment) = tData
     		Set DataType = $piece($G(tData(Number, "DS")), ":", 2)
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

ClassMethod Run(OutputPath As %String = "", displayDetail As %Boolean = 0)
{
	Set tSC = $$$OK
	
	Try {
		Kill ^||tErrors
		
		If OutputPath="" Set tSC = $$$ERROR($$$GeneralError,"Output file path not specified") Quit
		
		Set tSC = ..ProcessAllStreamlets(OutputPath, displayDetail)
		If $$$ISERR(tSC) Quit
	
		W !!, "Build of HL7 to SDA mapping finished"
		If $g(^||tErrors)>0 {
			w !,"Errors: ",?16,^||tErrors
			for i=1:1:^||tErrors w !,?16,^||tErrors(i)
			w !
			// If we don't already have a failure status then put the last error into status.
			If $$$ISOK(tSC) Set tSC = $$$ERROR($$$GeneralError,^||tErrors(^||tErrors))
		}
			
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) Write !,$SYSTEM.Status.GetErrorText(tSC),!!
	
	Quit tSC
}

/// Look up all streamlet classes (ignore abstact ones) and output
/// mapping XMLs to given output directory.
ClassMethod ProcessAllStreamlets(OutputPath = "", displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	Try {
		Set tSDAClassNames = ##class(%ListOfDataTypes).%New()
		Set tResultSet = ##class(%SQL.Statement).%ExecDirect(,"SELECT Name FROM %Dictionary.CompiledClass WHERE Name %STARTSWITH 'HS.SDA3.Streamlet.'")
		While tResultSet.%Next() {
			Set tClass = tResultSet.Name
			Set tShortClass = $piece(tClass,".",$l(tClass, "."))
			If (tShortClass [ "Abstract") {
				// Don't process abstract classes
				Continue
			}
			Set tSDA3Class = "HS.SDA3." _ tShortClass
			If '##class(%Dictionary.CompiledClass).%ExistsId(tSDA3Class) {
				// Don't try to map classes that don't exist in the HS.SDA3 package
				Continue
			}
			
			Do tSDAClassNames.Insert(tSDA3Class)
		}
		Set status = ..OutputAllMappings(tSDAClassNames, OutputPath, displayDetail)
		If $$$ISERR(status) Quit
	}
	Catch ex {
		Set status = ex.AsStatus()
	}
	Quit status
}

ClassMethod LogError(pErrorMessage)
{
	Set ^||tErrors($i(^||tErrors))=pErrorMessage
	Quit
}

}
