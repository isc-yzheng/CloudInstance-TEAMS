/// Create Mapping XML from SDA to CDA.
/// Find mapping comments from XSLT transformations, extract them, and convert
/// the mappings to XML file.
Class HS.Doc.Mapping.SDAToCDAMapper [ Abstract ]
{

/* Indicator of a regular mapping */
Parameter TARGETKW = "Target";

Parameter FIELDKW = "Field";

/* Indicator of a SDA source. Can be a SDA XPath or a SDA class and property path.
The former one is identified by "/" in path text. */
Parameter SOURCEKW = "Source";

Parameter NOTEKW = "Note";

/* Indicator of a structured mapping */
Parameter SMAPPINGKW = "StructuredMapping";

Parameter PATHKW = "Path";

Parameter SMAPPINGREFKW = "StructuredMappingRef";

Parameter COMMENTSTART = "<!--";

Parameter COMMENTEND = "-->";

/// Extract annotations from file of given path
/// then convert to mapping XML.
ClassMethod BuildMapping(Path As %String = "", Output pMap As HS.Doc.Mapping.Common.HealthShareMapping, pCDAType As %String, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	
	Try
	{
		If Path="" Set status = $$$ERROR($$$GeneralError,"Input file not specified") Quit
		
		If '##class(%File).Exists(Path) Set status = $$$ERROR($$$FileDoesNotExist,Path) Quit
		
		/* Initialize input file, mapping, and looping parameters */
		Set tFile =##class(%File).%New(Path)
		Do tFile.Open("R")
		Set pMap = ##class(HS.Doc.Mapping.Common.HealthShareMapping).%New()
		Set pMap.name = "SDA to CDA Mapping (Export)"
		Set tMappingCache = ""
		Set tInsideComment = 0
		Set tLineCounter = 0
		Set tMappingCounter = 0

		While 'tFile.AtEnd {
			Set tLine = tFile.ReadLine()
			Set tLineCounter = tLineCounter + 1
			
			If (tLine [ ..#COMMENTSTART) && '(tLine [ ..#COMMENTEND) {		// Enter a comment section
				Set tInsideComment = 1
				Set tMappingCounter = tMappingCounter + 1
				W:displayDetail "."
			}
			
			ElseIf (tLine [ ..#COMMENTEND) && '(tLine [ ..#COMMENTSTART) {	// Leave a comment section
				Set tInsideComment = 0
			}
			
			ElseIf (tInsideComment) {										// Inside a comment section
				Set tMappingCache(tMappingCounter, tLineCounter) = tLine
			}
		}
		
		Set status = ..BuildMappingFromData(.tMappingCache, .pMap, displayDetail)
		If $$$ISERR(status) Quit
		
		Do ..AddHeaders(.pMap,pCDAType)
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

/// Populate pMap using raw dataset.
ClassMethod BuildMappingFromData(ByRef pData As %String = "", Output pMap As HS.Doc.Mapping.Common.HealthShareMapping, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	
	Try
	{
		// Iterate annotation data and parse them into Mapping object
		Set tNode1 = ""
		For {
			Set tNode1 = $o(pData(tNode1))
			Q:tNode1=""
			Set tNode2 = ""
			Set tHasTarget = 0
			Set tHasStructuredMapping = 0
			For {
				Set tNode2 = $o(pData(tNode1, tNode2))
				Q:tNode2=""
				Set tLineNoWhiteSpace = $Translate(pData(tNode1, tNode2), $Char(9)_$Char(32)) 
				If (tLineNoWhiteSpace [ (..#TARGETKW_":")) {
					Set tHasTarget = 1
				}
				ElseIf (tLineNoWhiteSpace [ (..#SMAPPINGKW_":")) {
					Set tHasStructuredMapping = 1
				}
			}
			
			If (tHasTarget && 'tHasStructuredMapping) {
				Set status = ..BuildRegularMapping(.pData, tNode1, .pMap, displayDetail)
				If $$$ISERR(status) Do ..LogError("BuildRegularMapping failed - "_$system.Status.GetErrorText(status)) Continue
			}
			ElseIf (tHasStructuredMapping) {
				Set status = ..BuildStructuredMapping(.pData, tNode1, .pMap, displayDetail)
				If $$$ISERR(status) Do ..LogError("BuildStructuredMapping failed - "_$system.Status.GetErrorText(status)) Continue
			}
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

/// BuildRegularMapping depends upon the following XSLT comment structure and rules:
/// - One field mapping per comment block.
/// - Must have one Field line.
/// - Must have at least one CDA Target line, and may have multiple if there are not multiple SDA XPath Source lines.
/// - Must have one SDA Streamlet Source line.
/// - Must have at least one SDA XPath Source line, and may have multiple if there are not multiple CDA Target lines.
/// - May have zero or one StructuredMappingRef line.
/// - May have one line labeled to indicate Note.
/// - May have zero to many unlabeled lines after the Note line.  These
///   unlabeled lines are considered to be part of the Note text.
ClassMethod BuildRegularMapping(ByRef pData As %String, pNode As %String, Output pMap As HS.Doc.Mapping.Common.HealthShareMapping, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	Try
	{
		Set (tCurrentFieldName,tSDAStreamletSource,tStructuredMapping) = ""
		
		Set (tInNote,tNoteLines) = 0
		
		// pData  = Array of comment lines.
		// pNode  = Index indicating a given comment block (text between <!-- and -->).
		// tNode2 = Index for lines within a given comment block.
		Set tNode2 = ""
		For {
			Set tNode2 = $Order(pData(pNode, tNode2))
			If tNode2="" Quit
			
			Set tBeforeColon = $ZStrip($Piece(pData(pNode, tNode2), ":", 1),"<>W")
			Set tAfterColon = $ZStrip($Piece(pData(pNode, tNode2), ":", 2, 999),"<>W")
			
			If tBeforeColon = ..#FIELDKW {
				Set tCurrentFieldName = tAfterColon
			} ElseIf tBeforeColon = ..#TARGETKW {
				If $i(tTargets) Set tTargets(tTargets) = tAfterColon
			} ElseIf tBeforeColon = ..#SOURCEKW {
				If tAfterColon'["/" Set tSDAStreamletSource = tAfterColon
				If tAfterColon["/" If $i(tSDAXPathSources) Set tSDAXPathSources(tSDAXPathSources) = tAfterColon
			} ElseIf tBeforeColon = ..#SMAPPINGREFKW {
				Set tStructuredMapping = tAfterColon
				Set tInNote = 0
			} ElseIf tBeforeColon = ..#NOTEKW {
				If $i(tNoteLines) Set tNoteLines(tNoteLines) = tAfterColon
				Set tInNote = 1
			} ElseIf tInNote=1 {
				If $i(tNoteLines) Set tNoteLines(tNoteLines) = $ZStrip(pData(pNode, tNode2),"<>W")
			}
		}
		
		If tCurrentFieldName="" || ($Data(tTargets)=0) || (tSDAStreamletSource="") || ($Data(tSDAXPathSources)=0) Quit
		
		If tTargets>1,tSDAXPathSources>1 Set status = $$$ERROR($$$GeneralError,"Field "_tCurrentFieldName_" has multiple sources and targets") Quit
		
		If tTargets>1 {
			For i = 1:1:tTargets {
				Set tMapping = ##class(HS.Doc.Mapping.Common.Mapping).%New()
				Set tMappingTarget = ##class(HS.Doc.Mapping.CDA.MappingTarget).%New()
				Set tSDASource = ##class(HS.Doc.Mapping.SDA.SourceField).%New()
				
				Set tMappingTarget.Path = tTargets(i)
				Set tNote = ""
				For j = 1:1:tNoteLines {
					If tNote'="" Set tNote = tNote_$Char(10)
					Set tNote = tNote_tNoteLines(j)
				}
				If tNote'="" Set tMappingTarget.Note = tNote
				
				Set tSDASource.XPath = tSDAXPathSources(1)
				Set tSDASource.Streamlet = $Piece(tSDAStreamletSource, " ", 1)
				Set tSDASource.Path = $Piece(tSDAStreamletSource, " ", 2)
				If ('$Data(^||ISC.HS.StreamletCache(tSDASource.Streamlet))) {
					Set ^||ISC.HS.StreamletCache(tSDASource.Streamlet) = ""
				}
				If tStructuredMapping'="" Set tSDASource.StructuredMappingRef = tStructuredMapping
				
				Do tMappingTarget.Source.Insert(tSDASource)
				Do tMapping.Target.Insert(tMappingTarget)
				Set tMapping.id = tCurrentFieldName
				Do pMap.Mappings.Insert(tMapping)
				
				Kill tSDASource
				Kill tMappingTarget
				Kill tMapping
			}
		} Else {
			For i = 1:1:tSDAXPathSources {
				Set tMapping = ##class(HS.Doc.Mapping.Common.Mapping).%New()
				Set tMappingTarget = ##class(HS.Doc.Mapping.CDA.MappingTarget).%New()
				Set tSDASource = ##class(HS.Doc.Mapping.SDA.SourceField).%New()
				
				Set tMappingTarget.Path = tTargets(1)
				Set tNote = ""
				For j = 1:1:tNoteLines {
					If tNote'="" Set tNote = tNote_$Char(10)
					Set tNote = tNote_tNoteLines(j)
				}
				If tNote'="" Set tMappingTarget.Note = tNote
				
				Set tSDASource.XPath = tSDAXPathSources(i)
				Set tSDASource.Streamlet = $Piece(tSDAStreamletSource, " ", 1)
				Set tSDASource.Path = $Piece(tSDAStreamletSource, " ", 2)
				If ('$Data(^||ISC.HS.StreamletCache(tSDASource.Streamlet))) {
					Set ^||ISC.HS.StreamletCache(tSDASource.Streamlet) = ""
				}
				If tStructuredMapping'="" Set tSDASource.StructuredMappingRef = tStructuredMapping
				
				Do tMappingTarget.Source.Insert(tSDASource)
				Do tMapping.Target.Insert(tMappingTarget)
				Set tMapping.id = tCurrentFieldName
				Do pMap.Mappings.Insert(tMapping)
				
				Kill tSDASource
				Kill tMappingTarget
				Kill tMapping
			}
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

ClassMethod BuildStructuredMapping(ByRef pData As %String, pNode As %String, Output pMap As HS.Doc.Mapping.Common.HealthShareMapping, displayDetail As %Boolean = 0) As %Status
{
	// Example:
	//		>zw pData(pNode)
	//		pData(3,93)=$c(9,9,9)_"StructuredMapping: author-Human"
	//		pData(3,94)=$c(9,9,9)
	//		pData(3,95)=$c(9,9,9)_"Field"
	//		pData(3,96)=$c(9,9,9)_"Path: time/@value"
	//		pData(3,97)=$c(9,9,9)_"Source: ParentClass.EnteredOn"
	//		pData(3,98)=$c(9,9,9)_"Source: ../EnteredOn"
	//		pData(3,99)=$c(9,9,9)
	//		pData(3,100)=$c(9,9,9)_"Field:"
	//		pData(3,101)=$c(9,9,9)_"Path: assignedAuthor"
	//		pData(3,102)=$c(9,9,9)_"Source: CurrentProperty"
	//		pData(3,103)=$c(9,9,9)_"Source: ./"
	//		pData(3,104)=$c(9,9,9)_"StructuredMappingRef: assignedAuthor-Human"
	
	Set status = $$$OK
	Try
	{
		Set tMapping = ##class(HS.Doc.Mapping.Common.StructuredMapping).%New()
		Set tTargetStructure = ##class(HS.Doc.Mapping.CDA.TargetStructure).%New()
		Set tSourceStructure = ##class(HS.Doc.Mapping.SDA.SourceStructure).%New()
		
		Set (tInsideField,tInsideSources,tFieldSDASourceDefined) = 0
		Set tCurrentField = ""
		Set tNode2 = ""
		Set tCurrentKW = ""
		
		For {
			Set tNode2 = $o(pData(pNode, tNode2))
			//w " (SM) pData(",pNode,",",tNode2,")"	//b:((pNode=##) && (tNode2=##))
			If tNode2 = "" {
				If (tCurrentField '= "") {
					If tFieldSDASourceDefined Do tCurrentField.Source.Insert(tFieldSDASource)
					Do tTargetStructure.Field.Insert(tCurrentField)
					Set tCurrentField = "" 
					Set tCurrentKW = ""
				}
				Quit
			}
			
			Set tLine = pData(pNode, tNode2)
			Set tBefore = $ZStrip($piece(tLine, ":", 1),"<>W")
			Set tAfter = $ZStrip($piece(tLine, ":", 2, $l(tLine, ":")),"<>W")
			
			If (tBefore = "") && (tAfter = "") {
				
				If (tCurrentField '= "") {
					If tFieldSDASourceDefined Do tCurrentField.Source.Insert(tFieldSDASource)
					Do tTargetStructure.Field.Insert(tCurrentField)
					Set tCurrentField = ""
					Set tCurrentKW = ""
				}
				Set (tInsideField,tInsideSources,tFieldSDASourceDefined)=0
				Continue
			}
			
			if tInsideSources && (tBefore '= ..#SOURCEKW) {
				s tInsideSources = 0
				Do tCurrentField.Source.Insert(tFieldSDASource)
				Set tFieldSDASourceDefined=0
			}
			
			If (tBefore = ..#FIELDKW) {
				Set tInsideField = 1
				Set tCurrentField = ##class(HS.Doc.Mapping.Common.TargetField).%New()
				Set tCurrentKW = ""
			}
		
			ElseIf (tBefore = ..#SMAPPINGKW) {
				Set tMapping.id = tAfter
				Set tCurrentKW = ""
			}
	
			ElseIf (tBefore = ..#NOTEKW) {
				If (tInsideField) {
					Set tCurrentField.Note = tAfter
				}
				Else {
					Set tMapping.Note = tAfter
				}
				Set tCurrentKW = ..#NOTEKW
			}
	
			ElseIf (tBefore = ..#TARGETKW) {
				Set tTargetStructure.Path = tAfter
				Set tCurrentKW = ""
			}
	
			ElseIf (tBefore = ..#SOURCEKW) {
				Set status = ..ParseSourceString(tAfter, .tSources, displayDetail)
				If (tInsideField) {
					If 'tInsideSources {
						Set tInsideSources = 1
						Set tFieldSDASource = ##class(HS.Doc.Mapping.SDA.SourceField).%New()
						Set tFieldSDASourceDefined=1
					}
					For i=1:1:tSources.Count() {
						
						If (tSources.GetAt(i) [ "/") {
							Set tFieldSDASource.XPath = tSources.GetAt(i)
						}
						Else {
							Set tFieldSDASource.Streamlet = $piece(tSources.GetAt(i), " ", 1)
							Set tFieldSDASource.Path = $piece(tSources.GetAt(i), " ", 2)
						}
					}
				}
				Else {
					For i=1:1:tSources.Count() {
						Do tSourceStructure.Source.Insert(tSources.GetAt(i))
					}
				}
				Set tCurrentKW = ""
			}
			
			ElseIf (tBefore = ..#PATHKW) && (tInsideField) {
				Set tCurrentField.Path = tAfter
				Set tCurrentKW = ""
			}
			
			ElseIf (tBefore = ..#SMAPPINGREFKW) && (tInsideField) {
				Set tCurrentField.StructuredMappingRef = tAfter
				Set tCurrentKW = ""
			}
			ElseIf (tCurrentKW = ..#NOTEKW) {
				If (tInsideField) {
					Set tCurrentField.Note = tCurrentField.Note _ $Char(10) _ tBefore
				}
				Else {
					Set tMapping.Note = tMapping.Note _ $Char(10) _ tBefore
				}
			}
		}
		
		Set tTargetStructure.SourceStructure = tSourceStructure
		Set tMapping.TargetStructure = tTargetStructure
		Do pMap.StructuredMappings.Insert(tMapping)
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

ClassMethod ParseSourceString(pSource As %String = "", Output Sources As %ListOfDataTypes, displayDetail As %Boolean = 0)
{
	Set status = $$$OK
	
	Try
	{
		If pSource = "" Set status = $$$ERROR($$$GeneralError,"ParseSourceString empty string input") Quit
		
		Set Sources = ##class(%ListOfDataTypes).%New()
		Set sliceCounter = 1
		Set slice = $piece(pSource, ", ", sliceCounter)
		While (slice '= "") {
			Do Sources.Insert(slice)
			Set sliceCounter = sliceCounter + 1
			Set slice = $piece(pSource, ", ", sliceCounter)
		}
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

ClassMethod AddHeaders(Output pMap As HS.Doc.Mapping.Common.HealthShareMapping, pCDAType As %String) As %Status
{
	Set tCDADocumentType = ##class(HS.Doc.Mapping.CDA.DocumentType).%New()
	Set tSDADocumentType = ##class(HS.Doc.Mapping.SDA.DocumentType).%New()
	Set tCDADocumentType.cdaType = pCDAType
	Set tCDADocumentType.docType = "XML"
	Set tSDADocumentType.docType = "XML"
	
	Set streamlet = ""
	For {
		Set streamlet = $order(^||ISC.HS.StreamletCache(streamlet))
		Q:streamlet=""
		Do tSDADocumentType.Streamlet.Insert(streamlet)
	}
	
	Set pMap.Source = tSDADocumentType
	Set pMap.Target = tCDADocumentType
}

/// Output to XML
ClassMethod OutputMap(pPath As %String = "", pFilename As %String = "", displayDetail As %Boolean = 0) As %Status
{
	Set tStatus = $$$OK
	Try
	{
		/* truncate streamlet cache */
		Kill ^||ISC.HS.StreamletCache
		Set tStatus = ..BuildMapping(pPath,.tMapping,, displayDetail)
		If $$$ISERR(tStatus) {
			Write !, $SYSTEM.Status.GetErrorText(tStatus)
			Quit
		}
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1
		Set tWriter.IndentChars = $char(9)	// 9 is Tab
		Do tWriter.AddInstanceNamespace()	// Get rid of redundant xsi attrs
		
		If (pFilename '= "") {
			Set tStatus = tWriter.OutputToFile(pFilename)
			If $$$ISERR(tStatus) {
				Write !, $SYSTEM.Status.GetErrorText(tStatus)
				Quit
			}
		}
		Set tStatus = tWriter.RootObject(tMapping)
		If $$$ISERR(tStatus) {
			Write !, $SYSTEM.Status.GetErrorText(tStatus)
			Quit
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
		Write !, $SYSTEM.Status.GetErrorText(tStatus)
	}
	Quit tStatus
}

/// Class Method Annotations here
ClassMethod MergeMappings(pHSMappings As %ListOfObjects, Output pHSMapping As HS.Doc.Mapping.Common.HealthShareMapping, pCDAType As %String, displayDetail As %Boolean = 0) As %Status
{
	Set status = $$$OK
	
	Try
	{
		Set pHSMapping = ##class(HS.Doc.Mapping.Common.HealthShareMapping).%New()
		Set pHSMapping.name = "SDA To CDA Mapping (Export)"
	
		// Insert DocumentType SDA Header
		Set tSDADocumentType = ##class(HS.Doc.Mapping.SDA.DocumentType).%New()
		Set tSDADocumentType.docType = "XML"
		Set pHSMapping.Source = tSDADocumentType
		// Insert DocumentType CDA Type Header
		Set tCDADocumentType = ##class(HS.Doc.Mapping.CDA.DocumentType).%New()
		Set tCDADocumentType.cdaType = pCDAType
		Set tCDADocumentType.docType = "XML"
		Set pHSMapping.Target = tCDADocumentType
				
		Set streamlet = ""
		For {
			Set streamlet = $order(^||ISC.HS.StreamletCache(streamlet))
			Q:streamlet=""
			Do tSDADocumentType.Streamlet.Insert(streamlet)
		}
		
		For i=1:1:pHSMappings.Count() {
			Set tHSMapping = pHSMappings.GetAt(i)
			
			// Populate mappings
			Set tMappings = tHSMapping.Mappings
			For j=1:1:tMappings.Count() {
				Set tMapping = tMappings.GetAt(j)
				Do pHSMapping.Mappings.Insert(tMapping)
			}
			
			// Populate structured mappings
			Set tSMappings = tHSMapping.StructuredMappings
			For j=1:1:tSMappings.Count() {
				Set tSMapping = tSMappings.GetAt(j)
				Do pHSMapping.StructuredMappings.Insert(tSMapping)
			}
		}
		
	}
	Catch ex
	{
		Set status = ex.AsStatus()
	}
	
	Quit status
}

ClassMethod OutputAllMappings(pInputPaths As %ListOfDataTypes, pOutputPath As %String = "", pCDAType As %String, displayDetail As %Boolean = 0) As %Status
{
	Set tStatus = $$$OK
	Try
	{
		/* truncate streamlet cache */
		Kill ^||ISC.HS.StreamletCache
		Set tMappings = ##class(%ListOfObjects).%New()
		For i=1:1:pInputPaths.Count() {
			Set tStatus = ..BuildMapping(pInputPaths.GetAt(i),.tMapping,pCDAType, displayDetail)
			If $$$ISERR(tStatus) Do ..LogError("BuildMapping failed - "_$system.Status.GetErrorText(tStatus)) Continue
			Do tMappings.Insert(tMapping)
		}
		
		Set tStatus = ..MergeMappings(tMappings, .tHSMapping, pCDAType, displayDetail)
		If $$$ISERR(tStatus) Quit
		
		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1
		Set tWriter.IndentChars = $char(9)	// 9 is Tab
		Do tWriter.AddInstanceNamespace()	// Get rid of redundant xsi attrs
		
		Set tStatus = tWriter.OutputToFile(pOutputPath)
		If $$$ISERR(tStatus) Quit
		
		Set tStatus = tWriter.RootObject(tHSMapping)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
		Write !, $SYSTEM.Status.GetErrorText(tStatus)
	}
	
	Quit tStatus
}

ClassMethod RunOnSingleFile(pInputPath As %String = "", pOutputPath As %String = "", displayDetail As %Boolean = 0)
{
	If (pInputPath = "") {
		Set pInputPath = "C:\ccdatest\Export_Common_CCDA_Functions.xsl"
	}
	If (pOutputPath = "") {
		Set pOutputPath = "C:\ccdatest\test_output.xml"
	}
	Set status = ..OutputMap(pInputPath, pOutputPath, displayDetail)
	If $$$ISERR(status) {
		Write !, $SYSTEM.Status.GetErrorText(status)
		Quit
	}
}

ClassMethod Run(pInputDirectory As %String = "", pOutputPath As %String = "", pCDAType As %String = "", displayDetail As %Boolean = 0)
{
	Set tSC = $$$OK
	
	Try {
		Kill ^||tErrors
		
		If pOutputPath="" Set tSC = $$$ERROR($$$GeneralError,"Output file path not specified") Quit
		
		If pCDAType="" Set tSC = $$$ERROR($$$GeneralError,"CDA type not specified") Quit
	
		Set tSourceDirs = ##class(%ListOfDataTypes).%New()
		
		If pInputDirectory="" {
			// Looks in the XSLT path of the current HealthShare instance.
			Set tInstallDir=$SYSTEM.Util.InstallDirectory()
			Set tXSLTDirectory=##class(%File).NormalizeDirectory(tInstallDir_"/csp/xslt/")
			Set pInputDirectory = tXSLTDirectory_"/SDA3/CDA-Support-Files/Export"
		}
			
		// Find the correct subdirectory according to pCDAType
		Set tSC = ##class(HS.Doc.Utility).PopulateSourceDirs(pCDAType, pInputDirectory, .tSourceDirs)
		If $$$ISERR(tSC) Quit

		Set tSC = ..GetFiles(tSourceDirs, .tFiles, displayDetail)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError,"Error in GetFiles - "_$system.Status.GetErrorText(tSC)) Quit
		
		// Select a few individual files that are also used by XD-LAB.
		If pCDAType="XDLAB" {
			Set tPath = pInputDirectory_"/Entry-Modules/Comment.xsl"
			Do tFiles.Insert(tPath)
			Set tPath = pInputDirectory_"/Entry-Modules/LanguageSpoken.xsl"
			Do tFiles.Insert(tPath)
			Set tPath = pInputDirectory_"/Entry-Modules/PersonalInformation.xsl"
			Do tFiles.Insert(tPath)
		}
		
		If displayDetail {
			w !,"FILES:",!
			For i=1:1:tFiles.Count() {
				W !,i,".",tFiles.GetAt(i)
			}
			W !!,"Processing files",!
		}
		
		Set tSC = ..OutputAllMappings(tFiles, pOutputPath, pCDAType, displayDetail)
		If $$$ISERR(tSC) Quit
		
		W !!, "Build of SDA to CDA ("_pCDAType_") mapping finished"
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

ClassMethod GetFiles(pSourceDirs As %String, pFiles As %ListOfDataTypes, displayDetail As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pFiles = ##class(%ListOfDataTypes).%New()
		
		For i=1:1:pSourceDirs.Count() {
			Set tSourceDir = pSourceDirs.GetAt(i)
			If ##class(%Library.File).DirectoryExists(tSourceDir) {
				Set tSC = ..SearchDirectory(tSourceDir, .pFiles, displayDetail)
			}
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Returns the names of all the files in pSourceDir.
ClassMethod SearchDirectory(pSourceDir As %String, ByRef pFiles As %ListOfDataTypes, displayDetail As %Boolean = 0) As %Status
{
	Set tSC=$$$OK

	Try {
		w:displayDetail "Searching through ",pSourceDir," ... ",!

		Set tSortBy = ""
		Set tSC = ##class(%File).FileSetExecute(.tHandle, pSourceDir, "", tSortBy, 1, ",")

		If $$$ISOK(tSC) {
			Set tAtEnd = 0
			For {
				Set tSC = ##class(%File).FileSetFetch(.tHandle, .tRow, .tAtEnd)
				If '$$$ISOK(tSC)!($ListLength(tRow)<6) Quit
				Set tFile = $List(tRow, 6)
				Set tType = $List(tRow, 2)
				If tFile'=".DS_Store" {
					Set tPath = $list(tRow, 1)
					If ('##class(%Library.File).DirectoryExists(tPath) && (tPath '[ ".bak")) {
						Do pFiles.Insert(tPath)
					}
				}
				If tAtEnd Quit
			}	
			Set tSC = ##class(%File).FileSetClose(.tHandle)
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

ClassMethod LogError(pErrorMessage)
{
	Set ^||tErrors($i(^||tErrors))=pErrorMessage
	Quit
}

}
