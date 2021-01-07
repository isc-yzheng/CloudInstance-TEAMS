Include HS.FHIRServer

Class HS.FHIRServer.Util.RunSQLQuery [ Abstract ]
{

/// @API Helper Method to prepare and execute a query
ClassMethod runQuery(pSQL As %String, ByRef pSQLParams, Output time = "") As %SQL.StatementResult
{
	// Prepare
	set tStatement = ##class(%SQL.Statement).%New()
	set tStart = $ZHOROLOG
	$$$FSLogSQL("Run Query: "_pSQL)
	set tSC = tStatement.%Prepare(.pSQL)
	if $$$ISERR(tSC) {
		$$$ThrowStatus( $$$ERROR($$$GeneralError, "Error preparing query for search interaction: "_$system.Status.GetErrorText(tSC)))
	}
	if ($Get(pSQLParams,0)>0) && $$$FSLogIsActive($$$FSChannelSQL) {
		Set list=""  for ord=1:1:pSQLParams { Set $List(list, *+1) = pSQLParams(ord) }
		$$$FSLogSQL("Parameters: ("_$lts(list)_")")
	}

	set tSQLResultSet = tStatement.%Execute(pSQLParams...)
	if (tSQLResultSet.%SQLCODE < 0) { 
		$$$ThrowStatus(  $$$ERROR($$$GeneralError, "Error executing query for search interaction: SQL error, SQLCODE="_tSQLResultSet.%SQLCODE_", Msg="_tSQLResultSet.%Message))
	}
	set time = ($ZHorolog-tStart)
	$$$FSLogSQL("Execution Time: "_time)
	return tSQLResultSet
}

}
