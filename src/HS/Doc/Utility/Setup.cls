/// Utility methods for HS.Doc.* classes.  
Class HS.Doc.Utility.Setup [ Abstract ]
{

/// Setup Global Mappings to HSSYS
ClassMethod Mapping(pNamespace = {$Namespace}, pActivate = 1, pIsUpgrade = 0) As %Status
{
	// Setup Annotations Global Mappings
	Set tClass="HS.Doc.Data.Field"
	Set tAdd=tClass_"D,"_tClass_"I,"_tClass_"S"
	Set tClass="HS.Doc.Data.Link"
	Set tAdd=tAdd_","_tClass_"D,"_tClass_"I,"_tClass_"S"
	
	If pIsUpgrade {
		// Delete the globals from this namespace
		Do ..DeleteDocGlobals(tAdd)
	}
	
	// Map globals to HSSYS
	Do ##class(HS.HC.Util.Installer).AddGlobalMappings("",pNamespace,tAdd,"HSSYS")
	
	// Activate so the changes take effect
	Do:pActivate ##class(HS.HC.Util.Installer).ActivateConfiguration("",pNamespace)
	Quit $$$OK
}

ClassMethod CheckHSSYSDocGlobals() As %Status
{
	Set Globals = 0
	If $o(^["HSSYS"]HS.Doc.Data.FieldD("")) '= "" {
		Set Globals = 1
	}
	Quit Globals
}

ClassMethod MoveDocGlobals(pAdd As %String)
{
	// HSSYS does not have the HS.Doc.Data* Globals.  
	For tIdx2=1:1:$l(tAdd,",") {
		Set tItem = $p(tAdd,",",tIdx2)
		Set tMerge = "^[""HSSYS""]"_tItem_" = ^"_tItem
		Merge @tMerge
		// Remove global from this namespace
		Kill @("^"_tItem)
	}
}

ClassMethod DeleteDocGlobals(pAdd As %String)
{
	For tIdx2=1:1:$l(pAdd,",") {
		Set tItem = $p(pAdd,",",tIdx2)
		// Remove global from this namespace
		Kill @("^"_tItem)
	}
}

/// BuildAll calls BuildAllMappingXMLs and ImportAllMappingXMLs
/// to re-generate all of the HL7 and CDA-related mappings.
ClassMethod BuildAll(displayDetail As %Boolean = 0) As %Status
{
	set status = $$$OK
	new $namespace
	set $namespace = "HSSYS"
	try {
		// NormalizeDirectory adds back slash or front slash at the end of tOutputDirectory.
		set tOutputDirectory = ##class(%File).NormalizeDirectory("Temp", $System.Util.ManagerDirectory())
		
		Set status = ..BuildAllMappingXMLs(tOutputDirectory,displayDetail,.tTempFiles)
		If $$$ISERR(status) Quit
		Set status = ..ImportAllMappingXMLs(tOutputDirectory,displayDetail)
		If $$$ISERR(status) Quit
		
		// Delete Temp Files
		for i=1:1:tTempFiles {
			Set tFileName = tTempFiles(i)
			d ##class(%File).Delete(tFileName)
		}
	}
 	catch ex {
	 	set status = ex.AsStatus()
 	}
 	quit status
}

/// BuildAllMappingXMLs creates the mapping XML files in pOutputDirectory
/// for all of the HL7 and CDA-related mappings.
ClassMethod BuildAllMappingXMLs(pOutputDirectory As %String = {##class(%File).NormalizeDirectory("Temp", $System.Util.ManagerDirectory())}, displayDetail As %Boolean = 0, tTempFiles)
{
	Set tSC = $$$OK
	// Collect path/name of temp files as generated, and return in tTempFiles
	
	Try {
	 	Set tSC = ##class(HS.Doc.Mapping.HL7ToSDAMapper).Run(pOutputDirectory_"HL7ToSDA.xml", displayDetail)
	 	Set tTempFiles($i(tTempFiles)) = pOutputDirectory_"HL7ToSDA.xml"
	 	If $$$ISERR(tSC) Quit
	 	
		Set tSC = ##class(HS.Doc.Utility).GetCDATypes(.tCDATypes)
		If $$$ISERR(tSC) Quit
		Set tCDAType = $o(tCDATypes(""))
		While (tCDAType '= "") {
		 	Set tSC = ##class(HS.Doc.Mapping.CDAToSDAMapper).Run(, pOutputDirectory_"CDAImport"_tCDAType_".xml", tCDAType, displayDetail)
		 	Set tTempFiles($i(tTempFiles)) = pOutputDirectory_"CDAImport"_tCDAType_".xml"
		 	If $$$ISERR(tSC) Quit
		 	Set tSC = ##class(HS.Doc.Mapping.SDAToCDAMapper).Run(, pOutputDirectory_"CDAExport"_tCDAType_".xml", tCDAType, displayDetail)
		 	Set tTempFiles($i(tTempFiles)) = pOutputDirectory_"CDAExport"_tCDAType_".xml"
		 	If $$$ISERR(tSC) Quit
			Set tCDAType = $o(tCDATypes(tCDAType))
	 	}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// ImportAllMappingXMLS deletes all existing stored mapping data and then
/// imports the data from all of the mapping XML files in pInputDirectory.
ClassMethod ImportAllMappingXMLs(pInputDirectory As %String = {##class(%File).NormalizeDirectory("Temp", $System.Util.ManagerDirectory())}, displayDetail As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ##class(HS.Doc.Data.Field).%DeleteExtent()
		If $$$ISERR(tSC) Quit
		Set tSC = ##class(HS.Doc.Data.Link).%DeleteExtent()
		If $$$ISERR(tSC) Quit
		
	 	Set tKeepCurrentData = 1
	 	Set tDisplayDetail = displayDetail
	 	
	 	Set tSC = ##class(HS.Doc.Mapping.ImportHL7ToSDAMapping).XMLImport(pInputDirectory_"HL7ToSDA.xml", tKeepCurrentData, tDisplayDetail)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.Doc.Utility).GetCDATypes(.tCDATypes)
		If $$$ISERR(tSC) Quit
		Set tCDAType = $o(tCDATypes(""))
		While (tCDAType '= "") {
		 	Set tSC = ##class(HS.Doc.Mapping.ImportCDAToSDAMapping).XMLImport(pInputDirectory_"CDAImport"_tCDAType_".xml", tKeepCurrentData, tDisplayDetail)
			If $$$ISERR(tSC) Quit
		 	Set tSC = ##class(HS.Doc.Mapping.ImportSDAToCDAMapping).XMLImport(pInputDirectory_"CDAExport"_tCDAType_".xml", tKeepCurrentData, tDisplayDetail)
			If $$$ISERR(tSC) Quit
			Set tCDAType = $o(tCDATypes(tCDAType))
	 	}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

}
