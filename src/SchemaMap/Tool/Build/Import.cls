Include SchemaMap

/// manages import to and from files for various purposes,
/// related to developer collaboration and Perforce storage of shared work
Class SchemaMap.Tool.Build.Import [ Abstract ]
{

ClassMethod Tool(dirName As %String = "") As %Status
{
}

ClassMethod JSONDataFiles(dirName As %String = "") As %Status
{
}

ClassMethod JSONToolFiles(dirName As %String = "") As %Status
{
}

/// JSONDataFiles must be run first, before CSVFiles, so that project configuration values are established first.
ClassMethod CSVFiles(dirName As %String = "", skipClasses As %Boolean = 0) As %Status
{
}

ClassMethod LibDTL(dirName As %String = "") As %Status
{
}

ClassMethod Test(dirName As %String = "") As %Status
{
}

}
