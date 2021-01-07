Include SchemaMap

/// manages export to and from files for delivery purposes
Class SchemaMap.Tool.Build.Deliver [ Abstract ]
{

/// inPackage and outPackage are package names separated by dots (.) but this method reparses them as folder names when needed.
/// <p>
/// This method reads in (from the location perforceDir_"/"_inPackage_"/"_fileName) a text file
/// that is a global or ObjectScript class that has been exported to XML. It reads this file as text, line by line.
/// It replace any developer package name string it encounters, with the corresponding delivery package name string.
/// <p>
/// It writes the resulting file, line by line, to a location under the System Manager Directory on the instance
/// (the location is systemManagerDirectory_"/"_deliveryRoot_"/"_outPackage_"/"_fileName)
/// <p>
/// The resulting XML file has been refactored for delivery to the \\projects branch for the XF consumer project. 
/// It can be imported as a global or ObjectScript class, and can be archived in Perforce, as needed.
ClassMethod ExportDeliveryFile(perforceDir As %String = "", fileName As %String = "", inPackage As %String = "", deliveryRoot As %String = "", outPackage As %String = "", ByRef count As %Integer) As %Status
{
}

ClassMethod RefactorDeliveryPackage(inPackage, outPackage, xmlFileName, xmlPurpose, temporaryDir, deliveryDir, clearOld) As %Status
{
}

ClassMethod ProjectFiles(perforceDir As %String = "", exportModel As %Boolean = 0) As %Status
{
}

}
