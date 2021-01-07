Class HS.FHIR.DTL.Util.API.LookupTable [ Abstract ]
{

/// This method provides a series of Terminal-based prompts to facilitate
/// updating the value lookup tables for the SDA3 to FHIR STU3 and FHIR
/// STU3 to SDA3 transformations.<br>
/// <li>Imports the appropriate Lookup.json file into an object.
/// <li>Prompts for an item to update and for the new value.
/// <li>Saves the update to the object.
/// <li>Outputs the object to the custom version of the Lookup.json file.
/// <li>Imports the Lookup.json file into the appropriate global.
ClassMethod EditLookupTable(pNamespace As %String = "")
{
	new $Namespace
	
	if pNamespace="" set pNamespace = $Namespace
	
	set tConfigObj = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNamespace)
	if ('$isobject(tConfigObj))||(tConfigObj.Type="") {
		write !,pNamespace_" is not a valid namespace for Lookup Table editing",!
		quit
	}
	
	set $Namespace = pNamespace
	
	write !,"Edit Lookup Table for Namespace "_pNamespace,!
	
	set dirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/custom/"_pNamespace_"/"
	set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", dirName)
	if ('##class(%Library.File).DirectoryExists(dirName))||('##class(%Library.File).Exists(tFileName)) {
		set dirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/"
		if '##class(%Library.File).DirectoryExists(dirName) {
			set tSC = $$$ERROR($$$GeneralError, dirName _ " not found")
			quit
		} else {
			set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", dirName)
			if '##class(%Library.File).Exists(tFileName) {
				set tSC = $$$ERROR($$$GeneralError, tFileName _ " not found")
				quit
			}
		}
	}
	
	#dim dynObj As %Library.DynamicObject
	
	set tSC = ..ImportLookupJSONToObject(tFileName, .dynObj)
	if $$$ISERR(tSC) write !! do $system.Status.DisplayError(tSC) write ! quit
	
	Set tAbort = 0
	
	Write !
	
	For {
		Write !,"Mapping source ("
		set first = 1
		set iter = dynObj.%GetIterator()
		While iter.%GetNext(.name) {
			Write $select('first:", ", 1:"") _ $select($e(name)="v":$e(name, 2, *), 1:name)
			set first = 0
		}
		Write ")  : "
		Read tRead
		Set tRead = $ZConvert(tRead,"U")
		If tRead="" Set tAbort = 1 Quit
		If (dynObj.%Get(tRead)'= "") || (dynObj.%Get("v" _ tRead) '= "") Set tSourceSchema = tRead Quit
		Write "  invalid entry"
	}
	If tAbort Write " (aborting edit)" Quit
	
	Set tSourceSchemaInternal = $Select(tSourceSchema="SDA3":tSourceSchema,1:"v"_tSourceSchema)
	
	Write !
	
	For {
		Write !,"Mapping target ("
		set first = 1
		set iter = dynObj.%Get(tSourceSchemaInternal).%GetIterator()
		While iter.%GetNext(.name) {
			Write $select('first:", ", 1:"") _ $select($e(name)="v":$e(name, 2, *), 1:name)
			set first = 0
		}
		Write ")  : "
		Read tRead
		Set tRead = $ZConvert(tRead,"U")
		If tRead="" Set tAbort = 1 Quit
		If (dynObj.%Get(tSourceSchemaInternal).%Get(tRead)'= "") || (dynObj.%Get(tSourceSchemaInternal).%Get("v" _ tRead) '= "") Set tTargetSchema = tRead Quit
		Write "  invalid entry"
	}
	If tAbort Write " (aborting edit)" Quit
	
	Set tTargetSchemaInternal = $Select(tTargetSchema="SDA3":tTargetSchema,1:"v"_tTargetSchema)
	
	Write !
	
	#dim tIterator1 As %Iterator.Object
	Set tSourceValueSetCount = 0
	Set tIterator1 = dynObj.%Get(tSourceSchemaInternal).%Get(tTargetSchemaInternal).%GetIterator()
	For {
		If 'tIterator1.%GetNext(.NAME, .OREF) Quit
		Set tSourceValueSets($i(tSourceValueSetCount)) = NAME
	}
	
	For {
		Write !,"Select Mapping Source Value Set",!!
		For i = 1:1:tSourceValueSetCount {
			Write i_". "_tSourceValueSets(i),!
		}
		Write !,"? "
		Read tRead
		If tRead="" Set tAbort = 1 Quit
		If $Data(tSourceValueSets(tRead)) Set tSourceValueSet = tSourceValueSets(tRead) Write "  "_tSourceValueSet Quit
		Write "  invalid entry" Hang 1
	}
	If tAbort Write " (aborting edit)" Quit
	
	Write !
	
	#dim tIterator2 As %Iterator.Object
	Set tTargetValueSetCount = 0
	Set tIterator2 = dynObj.%Get(tSourceSchemaInternal).%Get(tTargetSchemaInternal).%Get(tSourceValueSet).%GetIterator()
	Kill NAME, OREF
	For {
		If 'tIterator2.%GetNext(.NAME, .OREF) Quit
		Set tTargetValueSets($i(tTargetValueSetCount)) = NAME
	}
	
	If tTargetValueSetCount=1 {
		Set tTargetValueSet = tTargetValueSets(1)
	} Else {
		For {
			Write !,"Select Mapping Target Value Set",!!
			For i = 1:1:tTargetValueSetCount {
				Write i_". "_tTargetValueSets(i),!
			}
			Write !,"? "
			Read tRead
			If tRead="" Set tAbort = 1 Quit
			If $Data(tTargetValueSets(tRead)) Set tTargetValueSet = tTargetValueSets(tRead) Quit
			Write "  invalid entry"
		}
	}
	If tAbort Write " (aborting edit)" Quit
	
	Write !!
	
	Write "Mapping Source Schema    : "_tSourceSchema,!
	Write "Mapping Target Schema    : "_tTargetSchema,!
	Write "Mapping Source Value Set : "_tSourceValueSet,!
	Write "Mapping Target Value Set : "_tTargetValueSet,!
	
	#dim tIterator3 As %Iterator.Object
	Set tValuePairsCount = 0
	Set tNameMaxLen = 0
	Set tIterator3 = dynObj.%Get(tSourceSchemaInternal).%Get(tTargetSchemaInternal).%Get(tSourceValueSet).%Get(tTargetValueSet).%GetIterator()
	Kill NAME, OREF
	For {
		If 'tIterator3.%GetNext(.NAME, .OREF) Quit
		If $Length(NAME)>tNameMaxLen Set tNameMaxLen = $Length(NAME)
		Set tValuePairs($i(tValuePairsCount)) = NAME_"||"_OREF
	}
	
	For {
		Write !,"Select Mapping Value to Modify (enter '+' to add a new entry)",!!
		For i = 1:1:tValuePairsCount {
			Write i_". "_$Piece(tValuePairs(i),"||",1),?(tNameMaxLen+5),"-> "_$Piece(tValuePairs(i),"||",2),!
		}
		Write !,"? "
		Read tRead
		If tRead="" Set tAbort = 1 Quit
		If tRead="+" Set tValuePair = "" Quit
		If $Data(tValuePairs(tRead)) Set tValuePair = tValuePairs(tRead) Quit
		Write "  invalid entry"
		Write !
	}
	If tAbort Write " (aborting edit)" Quit
	
	Write !
	Set tSourceValue = $Piece(tValuePair,"||",1)
	Set tTargetValue = $Piece(tValuePair,"||",2)
	If tSourceValue'="" Write !,"(enter '-' to delete)"
	Write !,"Source value : "_tSourceValue
	If tSourceValue="" {
		Read tRead
		If tRead="" {
			Set tAbort = 1
		} Else {
			Set tFound = 0
			For i = 1:1:tValuePairsCount If $Piece(tValuePairs(i),"||",1)=tRead Set tFound = 1 Quit
			If tFound {
				Write " already defined"
				Set tAbort = 1
			} Else {
				Set tSourceValue = tRead
			}
		}
	}
	If tAbort Write " (aborting edit)" Quit
	
	Set tPromptString = "Target value : "
	Write !,tPromptString If tTargetValue'="" Write tTargetValue,!,?($Length(tPromptString))
	Read tRead
	If (tRead="")&&(tTargetValue'="") Write "  (no change)",! Quit
	Set tTargetValue = tRead
	
	Set tSC = ..UpdateLookupObjectItem(.dynObj, tSourceSchemaInternal, tTargetSchemaInternal, tSourceValueSet, tTargetValueSet, tSourceValue, tTargetValue, (tTargetValue="-"))
	if $$$ISERR(tSC) write ! do $system.Status.DisplayError(tSC) write ! quit
	
	Set tSC = ..ExportObjectToLookupJSON(dynObj)
	if $$$ISERR(tSC) write ! do $system.Status.DisplayError(tSC) write ! quit
	
	Set tSC = ..ImportLookupJSONToGlobal()
	if $$$ISERR(tSC) write ! do $system.Status.DisplayError(tSC) write ! quit
	
	Write !!,"Item successfully "_$Select(tTargetValue="-":"deleted",1:"updated"),!
	
	Quit
}

/// API Method
/// This method populates the ^HS.XF.LookupTable global from the Lookup.json file.
/// If <i>installdirectory</i>/dev/fhir/lookup<b>/custom/<i>namespace</i></b>/Lookup.json exists, then
/// it is used. Otherwise, <i>installdirectory</i>/dev/fhir/lookup/Lookup.json is used.
ClassMethod ImportLookupJSONToGlobal(pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		if pNamespace="" set pNamespace = $Namespace
		set tConfigObj = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNamespace)
		if ('$isobject(tConfigObj))||(tConfigObj.Type="") {
			set tSC = $$$ERROR($$$GeneralError, pNamespace_" is not a valid namespace for Lookup Table")
			quit
		}
		set $Namespace = pNamespace
		set dirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/custom/"_pNamespace_"/"
		set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", dirName)
		if ('##class(%Library.File).DirectoryExists(dirName))||('##class(%Library.File).Exists(tFileName)) {
			set dirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/"
			if '##class(%Library.File).DirectoryExists(dirName) {
				set tSC = $$$ERROR($$$GeneralError, dirName _ " not found")
				quit
			} else {
				set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", dirName)
				if '##class(%Library.File).Exists(tFileName) {
					set tSC = $$$ERROR($$$GeneralError, tFileName _ " not found")
					quit
				}
			}
		}
				
		set tFileStream = ##class(%Stream.FileCharacter).%New()
		set tSC = tFileStream.LinkToFile(tFileName)
		if $$$ISERR(tSC) quit
		
		Set dynObj = ##class(%Library.DynamicAbstractObject).%FromJSON(tFileStream)
		
		TSTART
		
		Kill ^HS.XF.LookupTable
		
		set iter = dynObj.%GetIterator()
		while iter.%GetNext(.sourceSchema, .sourceSchemaVal) {
			set iter1 = sourceSchemaVal.%GetIterator()
			while iter1.%GetNext(.targetSchema, .targetSchemaVal) {
				set iter2 = targetSchemaVal.%GetIterator()
				while iter2.%GetNext(.sourceValueSet, .sourceValueSetVal) {
					set iter3 = sourceValueSetVal.%GetIterator()
					while iter3.%GetNext(.targetValueSet, .targetValueSetVal) {
						set iter4 = targetValueSetVal.%GetIterator()
						while iter4.%GetNext(.sourceCode, .targetCode) {
							set ^HS.XF.LookupTable(sourceSchema, targetSchema, sourceValueSet, targetValueSet, sourceCode) = targetCode
						}
					}
				}
			}
		}
		
		TCOMMIT
		
	} Catch ex {
		TROLLBACK
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

/// API Method
/// Import the specified Lookup JSON file into a %DynamicObject and return the object.
ClassMethod ImportLookupJSONToObject(pFileName As %String, ByRef pDynObj As %Library.DynamicObject) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tFileStream = ##class(%Stream.FileCharacter).%New()
		Set tSC = tFileStream.LinkToFile(pFileName)
		If $$$ISERR(tSC) Quit
		
		Set pDynObj = ##class(%Library.DynamicObject).%FromJSON(tFileStream)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API Method
/// Add, update or delete an item in the specified Lookup %DynamicObject, given the
/// source schema ("SDA3", "vSTU3"), target schema ("SDA3", "vSTU3", "vDSTU2"), the
/// source value set, the target value set, the source value, and, if applicable,
/// the target value. Specify 1 for the pDelete parameter if you want to delete the
/// the specified entry.
ClassMethod UpdateLookupObjectItem(pDynObj As %Library.DynamicObject, pSourceSchema As %String, pTargetSchema As %String, pSourceValueSet As %String, pTargetValueSet As %String, pSourceValue As %String, pTargetValue As %String = "", pDeleteItem As %Boolean = 0)
{
	Set tSC = $$$OK
	
	Try {
		If 'pDeleteItem {
			Set $Property(pDynObj.%Get(pSourceSchema).%Get(pTargetSchema).%Get(pSourceValueSet).%Get(pTargetValueSet), pSourceValue) = pTargetValue
		} Else {
			Do pDynObj.%Get(pSourceSchema).%Get(pTargetSchema).%Get(pSourceValueSet).%Get(pTargetValueSet).%Remove(pSourceValue)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API Method
/// Export the contents of the specified Lookup %DynamicObject to the custom version
/// of the Lookup.json file.
ClassMethod ExportObjectToLookupJSON(pDynObj As %Library.DynamicObject, pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pNamespace="" Set pNamespace = $Namespace
		
		If (pDynObj.SDA3="")||(pDynObj.vSTU3="")||(pDynObj.SDA3.vSTU3="")||(pDynObj.vSTU3.SDA3="") {
			Write !!,"The specified %DynamicObject is malformed",!
			Quit
		}
		
		Set tNewJSONStream = ##class(%Stream.TmpCharacter).%New()
		Do pDynObj.%ToJSON(.tNewJSONStream)
		Do tNewJSONStream.Rewind()
		
		Set tSC = ##class(HS.FHIR.Utils).FormatFHIR("json", tNewJSONStream, .tNewFormattedJSONStream, $Char(9), $Char(13,10))
		If $$$ISERR(tSC) Write !! Do $system.Status.DisplayError(tSC) Write ! Quit
		
		// Always output to the custom version of Lookup.json.
		Set dirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/custom/"_pNamespace_"/"
		If '##class(%Library.File).DirectoryExists(dirName) {
			If '##class(%Library.File).CreateDirectoryChain(dirName) {
				Use 0 Write !!,"Unable to create directory "_dirName,!
				Quit
			}
		}
				
		Set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", dirName)
		
		Open tFileName:"WNS":5
		If '$T {
			Use 0 Write !!,"Unable to open "_tFileName_" for output",!
			Quit
		}
		Use tFileName Do tNewFormattedJSONStream.OutputToDevice()
		Close tFileName
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
