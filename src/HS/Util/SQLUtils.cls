Class HS.Util.SQLUtils [ Abstract ]
{

ClassMethod IsValidTable(pTable As %String) As %Boolean
{
	Set tID = ""
	Set tSchemaName = $Piece(pTable,".")
	Set tTableName = $Piece(pTable,".",2,*)
	Set tTableNameNoQuotes = $tr(tTableName,"""")	//My_Package."Classname" is valid if the real table name is My_Package.Classname
	&SQL(SELECT ID INTO :tID from INFORMATION_SCHEMA.TABLES
		where TABLE_SCHEMA = :tSchemaName AND
			TABLE_NAME = :tTableNameNoQuotes)
	Quit:(SQLCODE'=0) 0
	Quit (tID'="")
}

ClassMethod ClassNameFromTable(pTable As %String) As %String
{
	Set tClassName = ""
	Set tSchemaName = $Piece(pTable,".")
	Set tTableName = $Piece(pTable,".",2,*)
	Set tTableNameNoQuotes = $tr(tTableName,"""")	//My_Package."Classname" is valid if the real table name is My_Package.Classname
	&SQL(SELECT CLASSNAME INTO :tClassName from INFORMATION_SCHEMA.TABLES
		where TABLE_SCHEMA = :tSchemaName AND
			TABLE_NAME = :tTableNameNoQuotes)
	Quit:(SQLCODE'=0) ""
	Quit tClassName
}

ClassMethod TableFromClassName(pClassName As %String) As %String
{
	Quit $$$comClassKeyGet(pClassName,$$$cCLASSsqlqualifiednameQ)
}

ClassMethod IsValidField(pTable As %String, pField As %String) As %Boolean
{
	Set tID = ""
	Set tSchemaName = $Piece(pTable,".")
	Set tTableName = $Piece(pTable,".",2,*)
	Set tTableNameNoQuotes = $tr(tTableName,"""")	//My_Package."Classname" is valid if the real table name is My_Package.Classname
	&SQL(SELECT ID INTO :tID from INFORMATION_SCHEMA.COLUMNS
		where TABLE_SCHEMA = :tSchemaName AND
			TABLE_NAME = :tTableNameNoQuotes
			AND COLUMN_NAME = :pField)
	Quit:(SQLCODE'=0) 0
	Quit (tID'="")
}

}
