Include SchemaMap

Class SchemaMap.Tool.SQL.Base
{

ClassMethod AddTable(Output sql As %String, from As %String, to As %String = "") As %Status
{
}

ClassMethod AddWhere(Output sql As %String, Output sqlargs, schema As %String, pathColumn As %String, path As %String, contained As %Boolean, clause As %String) As %Status
{
}

ClassMethod AddClause(Output sql, clause As %String) As %Status
{
}

ClassMethod AddOrder(Output sql, schema As %String, pathColumn As %String) As %Status
{
}

ClassMethod AddSet(Output sql, setColumn As %String, setValue As %String) As %Status
{
}

/// Puts the contents of <var>whereArgs</var> before args, and returns the contents in <var>args</var>.
ClassMethod CombineArgs(Output args, Output whereArgs, setValue As %String = "") As %Status
{
}

ClassMethod CompleteQuery(Output sql As %String, Output args, from As %String, to As %String = "", pathColumn As %String, path As %String, contained As %Boolean, clause As %String, order As %Boolean = 0, setColumn As %String = "", setValue As %String = "") As %Status
{
}

ClassMethod Execute(sql As %String, Output result As %SQL.StatementResult, sqlargs...)
{
}

}
