Include HS.FHIRServer

Class HS.FHIRServer.Storage.Search Extends (%RegisteredObject, HS.FHIRServer.API.Interactions, HS.FHIRServer.Util.FHIRQueryUtils) [ Abstract ]
{

Property strategy As HS.FHIRServer.Storage.Json.InteractionsStrategy;

// This method is in the subclass of this (part of the Interactions object)

Method findSearchColumn(resourceType As %String, paramName As %String) As HS.FHIRServer.Storage.Json.SearchColumn [ Abstract ]
{
}

Method getSearchColumn(resourceType As %String, paramName As %String) As HS.FHIRServer.Storage.Json.SearchColumn [ Abstract ]
{
}

Method getTableForResourceType(resourceType As %String) As %String [ Abstract ]
{
}

Method searchColumnFromSearchParam(searchParam As HS.FHIRServer.SearchParam) As HS.FHIRServer.Storage.Json.SearchColumn [ CodeMode = expression ]
{
..getSearchColumn(searchParam.resourceType, searchParam.code)
}

Method Search(pResourceType As %String, pCompartment As %String, pCompartmentId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters = "", ByRef pSortKeys = "") As HS.FHIRServer.Util.SearchResult
{
	// If the name of the table is an SQL reserved word (ex: Procedure, Group), it must be quoted.
	// tType should have been validated above IsValidResourceType().
	set tableName = ..getTableForResourceType(pResourceType)
	set tSQL = "SELECT Key, _id As ResourceId, VersionId FROM "_tableName
	set tSQLParams = 0
	set clauseSeparator = " WHERE "
	
	if (pCompartment '= "") { 
		// If it is a Compartment search, first emit the selector for the compartment
		Set whereClause = ..WhereCompartment(pResourceType, pCompartment, pCompartmentId, .tSQLParams)
		if whereClause '= "" {
			set tSQL = tSQL_clauseSeparator_whereClause
			set clauseSeparator = " AND "
		}
	}
	Set paramCount = $Select(pParameters="":0, 1:pParameters.Count())
	for ord = 1:1:paramCount {
		#dim param as HS.FHIRServer.API.SearchQueryParameter = pParameters.GetAt(ord)
		
		#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn
		Set searchColumn = ..findSearchColumn(pResourceType, param.name)
		if searchColumn = "" {
			// Check to see if this is a shared search parameter
			Set searchColumn = ..findSearchColumn("Resource", param.name)
			if searchColumn = "" {
			Continue
		}
		}
		
		if param.nextInRevChain '= "" {
			Set whereClause = ..WhereRevChain(param, pResourceType, .tSQLParams)
		} elseif param.nextInChain '= "" {
			Set whereClause = ..WhereChain(param, pResourceType, .tSQLParams)
		} else {
			Set tParam = param.name
			Set tModifier = param.modifier
			// TODO:  This is now one at at time, so the clause builders can be simplified
			Set tParamValue = param.value

			// Build a where clause segment for this parameter (dispatch by parameter type)
			Set whereClause = ..WhereClause(tableName, searchColumn, tModifier, tParamValue, .tSQLParams)
		}
		// Append the segment to the SQL statement
		set tSQL = tSQL_clauseSeparator_whereClause
		
		// All subsequent clauses are separated with AND
		set clauseSeparator = " AND "
	}
	// ---- End of Query Building, Execute Base Query ---
	Set tSQL = tSQL _ ..BuildSortClause(.pSortKeys)
	// Execute
	#dim tSQLResultSet As %SQL.StatementResult = ..runQuery( .tSQL, .tSQLParams, .tSQLExecute1)
	Set tSQLIDColNum = 1
	Set tSQLResourceIdColNum = 2

	// ---- Build Temp Result Set for Post Processing  ---
	#dim tResultSet as HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()
	// Create HS.FHIRServer.Util.SearchResult from initial SQL result set.
	// Columns are: ( isDeleted, ID, RsrcType, RsrcId, VersionId, mode [match, include], Verb)
	While tSQLResultSet.%Next() {
		Set rsrcKey = tSQLResultSet.%GetData(1)
		Set tResourceId  = tSQLResultSet.%GetData(2)
		Set tVersion = tSQLResultSet.%GetData(3)
		Do tResultSet.AddRow(rsrcKey, pResourceType, tResourceId, tVersion, "match")
	}
	//$$$FSLogSQL("tParamType query complete with "_tResultSet.%ROWCOUNT_" row(s)")
	
	// We now have the data extracted from the database into a Temporary Table
	// Do more post-processing which may eliminate rows from the result set
	Do tResultSet.%SetIterator(0)
	return tResultSet
}

Method WhereClause(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pVals, ByRef pSQLParams) As %String
{
		
	Set tParamType = pSearchColumn.Type
	if (tParamType = "token") {
		set whereClause = ..WhereToken(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	}
	elseif (tParamType = "date") {
		set whereClause =  ..WhereDate(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	}
	elseif (tParamType = "string") {
		set whereClause =  ..WhereString(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	}
	elseif (tParamType = "reference") {
		set whereClause =  ..WhereReference(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	}
	elseif (tParamType = "quantity") {
		set whereClause =  ..WhereQuantity(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	}
	elseif (tParamType = "number") { 
		set whereClause =  ..WhereNumber(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	}
	elseif (tParamType = "uri") || (tParamType = "canonical") { 
		set whereClause =  ..WhereURI(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	} else {
		// This means our schema data is corrupted (or a new type was added and we don't support it
		$$$ThrowFHIR($$$HSFHIRErrUnknownSearchParameterType, pSearchColumn.ParamName, tParamType, $$$OutcomeNotSupported(400))
	}
	return whereClause
}

/// Recursive method to build a Where clause for a chained search parameter
Method WhereChain(chainedParam As HS.FHIRServer.API.SearchQueryParameter, pResourceType As %String, ByRef pSQLParams) As %String [ Private ]
{
	//w ">> WhereChain: ",pResourceType,"?",chainedParam.AsString(),!
	#dim param As HS.FHIRServer.API.SearchQueryParameter = chainedParam
	
	#dim nextParam As HS.FHIRServer.API.SearchQueryParameter = chainedParam.nextInChain
	
	#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn = ..searchColumnFromSearchParam(chainedParam.searchParam)
	if (nextParam '= "") {
		set colName = searchColumn.ColumnName
		set isColl = searchColumn.isMultiValue
		if isColl{
			Set whereClause = "FOR SOME %ELEMENT(" _ colName _ ") (%VALUE %INLIST (SELECT %DLIST( DISTINCT Key) FROM "
		}
		else {
			Set whereClause = " " _ colName _ " %INLIST (SELECT %DLIST( DISTINCT Key) FROM "
		}
		Set whereClause = whereClause _ ..getTableForResourceType(chainedParam.modifier) _ " WHERE "
		//w !,">>> WhereChain: ",param.modifier,"?",chainedParam.name,":",whereClause,!
		Set wc = ..WhereChain(nextParam, param.modifier, .pSQLParams)
		//w !,"<<< ",wc,!
		Set whereClause = whereClause _ wc
		Set whereClause = whereClause _ ")"
		if isColl{
			Set whereClause = whereClause _ ")"
		}
	} else {
		Set searchColumn = ..searchColumnFromSearchParam(chainedParam.searchParam)
		//w !,">>> bUILDWhere: ",pResourceType,"?",chainedParam.name,!
		Set whereClause = ..WhereClause(pResourceType, searchColumn, chainedParam.modifier, chainedParam.value, .pSQLParams)
		//w !,"<<< ",whereClause,!
	}
	return whereClause
}

Method WhereRevChain(chainedParam As HS.FHIRServer.API.SearchQueryParameter, pResourceType As %String, ByRef pSQLParams) As %String [ Private ]
{
	Set keysList = ""
	Set curParam = chainedParam
	for {
		Set nextParam = curParam.nextInRevChain
		Quit:(nextParam="")
		
		// Right-most query to return a list of keys
		Set resourceType = $Select((curParam = chainedParam):curParam.searchParam.resourceType, 1:curParam.value)
 		Set tableName = ..getTableForResourceType(resourceType)
		#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn = ..searchColumnFromSearchParam(nextParam.searchParam)
		set colName = searchColumn.ColumnName
		set isColl = searchColumn.isMultiValue

		Set sqlParams = 0
		Set tSQL = "Select distinct %Exact(" _ colName _ ") FROM " _ tableName _ " WHERE "
		if curParam = chainedParam {
			// This is the right-most link in the chain, perform the requested query
			Set tSQL = tSQL _  "((" _ ..WhereClause(pResourceType, ..searchColumnFromSearchParam(curParam.searchParam), curParam.modifier, curParam.value, .sqlParams)
			
			Set tSQL = tSQL _ ") AND ("
			if isColl{
				Set tSQL = tSQL _  "FOR SOME %ELEMENT(" _ colName _ ") (%VALUE like ?)"
			}
			else {
				Set tSQL = tSQL _  colName _ " like ?"
			}
			Set tSQL = tSQL _ "))"
			Set sqlParams($I(sqlParams)) = nextParam.value _ "/%"
		} else {
			// This is an intermediate link in the chain
			Set tSQL = tSQL _ "(Key %INLIST ?)"
			Set sqlParams($I(sqlParams)) = keysList
		}		
		#dim tSQLResultSet As %SQL.StatementResult = ..runQuery( .tSQL, .sqlParams, .tSQLExecute1)
	
		// Convert the result set into a unique list
		kill keySet
		// Build a unique set of keys from the result set
		While tSQLResultSet.%Next() {
			Set keyColValue = tSQLResultSet.%GetData(1)
			if 'isColl {
				if '$Data(keySet(keyColValue)) {
					Set $List(keysList,*+1) = keyColValue
					Set keySet(keyColValue) = ""
				}
			} else {
				for ord=1:1:$LL(keyColValue) {
					Set key = $LG(keyColValue, ord)
					if '$Data(keySet(key)) {
						Set $List(keysList,*+1) = key
						Set keySet(key) = ""
					}
				}
			}
		}
		// Do the next link in the chain
		set curParam = nextParam
		
	}
	
	// This is the first link in the chain ... construct the WHERE clause
	Set whereClause = "(Key %INLIST ?)"
	Set pSQLParams($I(pSQLParams)) = keysList
	
	return whereClause
}

Method SearchIncludes(pResultSet As HS.FHIRServer.Util.SearchResult, ByRef pIncludeArr, ByRef pRevIncludeArr)
{
	// Enter with the result set from the primary query.  Get the resource Ids for any
	// resources that match the _include or _revinclude spec (if any)
	If $g(pIncludeArr) || $g(pRevIncludeArr) {
		// Build list of ids of the primary resource types that have been found
		// Ignore deleted resources
		Set idList = ""
		Set revIdList = ""
		While (pResultSet.NextUndeleted()) {
			Set $LIST(idList, *+1) = pResultSet.Key
			Set $LIST(revIdList, *+1) = pResultSet.Key
		}
		Do pResultSet.%SetIterator(0)

		kill gathered
		do ..GatherIncludedResourceIds(.pIncludeArr, idList, .gathered)
		for iInclude=1:1:$g(pRevIncludeArr) {
			do ..GatherRevIncludedResourceIds(pRevIncludeArr(iInclude), revIdList, .gathered, pRevIncludeArr(iInclude,"targetType"))
		}
		if revIdList '= "" {
			$$$FSLogInclude("RevIds: "_$Lts(revIdList))
		}
		
		Do ##class(HS.FHIRServer.Util.ReferenceVisitor).adjustCrossReference(..strategy.schema, .gathered)
		Set ref = ""
		for {
			Set ref = $Order(gathered("ref", ref), 1, targetResourceKey)
			quit:ref=""
			
			if targetResourceKey '= "" {
				// Check for back reference
				Set backRefsList = ##class(HS.FHIRServer.Util.ReferenceVisitor).GetReferencingIds(ref, .gathered)
				// An empty string here means the resource was deleted
				// w "Add ",ref," | ", targetResourceKey,"|", $LTS(backRefsList),!
				Do pResultSet.AddRow(ref, $Piece(ref,"/",1),  $Piece(ref,"/",2), "", "include",,,backRefsList)
			}
			//$$$FSLogInclude("Added Row for "targetResourceKey": "_ref)
		}
	}
	$$$FSLogInclude("Total Rows: "_pResultSet.%ROWCOUNT)
	Do pResultSet.%SetIterator(0)
}

Method GatherIncludedResourceIds(ByRef pIncludeEntryArr As %CacheString, pIdList As %String, ByRef pGathered)
{
	Set targetCols = ""
	Set colCount = 1
	
	for noTarget=0:1:1 {
		for index=1:1:pIncludeEntryArr {
			if noTarget {
				// This path is run last for any _include parameters that do NOT specify a single
				// target type.  We can get all of the columns in one query.
				kill tSQLParams
				Set tSQLParams = 0
				if targetCols ="" {
					continue //otherwise get an error if no target cols
				}
				// Build a single query for all non-specific resource type references
				set tSQL = "SELECT Key," _ $lts(targetCols) _ " FROM " _ tableName
				Set tSQL = tSQL _ " WHERE Key %INLIST ?"
				Set tSQLParams($I(tSQLParams)) = pIdList
				
				Set colCount = $ll(targetCols)

				// Only once through the entries since we run a single query for all non-targeted 
				Quit:index>1
			} else {
				#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn = ..searchColumnFromSearchParam(pIncludeEntryArr(index))
				set colName = searchColumn.ColumnName
				set isColl = searchColumn.isMultiValue
				
				// Build a query for a specified target resource type specification
				Set resourceType = searchColumn.ResourceType
				set tableName = ..getTableForResourceType(resourceType)

				// Prepare to populate values for the query
				Set targetType = pIncludeEntryArr(index,"targetType")
				if targetType="" {
					// This has no target, capture the param name for later
					Set $list(targetCols, *+1) = colName
					Continue
				}
				
				// Build query to find references to a specific resource type from the
				// specified search field of the original resources
				kill tSQLParams
				Set tSQLParams = 0
				
				set tSQL = "SELECT Key, " _ colName _ " FROM " _ tableName
				
				Set tSQL = tSQL _ " WHERE Key %INLIST ?"
				Set tSQLParams($I(tSQLParams)) = pIdList
				Set tSQL = tSQL _ " and "_ colName _ " is not null"
				if targetType '= "" {
					if isColl {
						Set tSQL = tSQL _ " and FOR SOME %ELEMENT(" _ colName _") (%Value like ?)"
					}
					else {
						Set tSQL = tSQL _ " and " _ colName _" like ?"
					}
					Set tSQLParams($I(tSQLParams)) = targetType _ "/%"
				}
			}
			
			// Extract all reference values from the query.
			#dim tResultSet As %SQL.StatementResult = ..runQuery( .tSQL, .tSQLParams, .tSQLExecute)
			// Execute
			Set newRows = 0
			While (tResultSet.%Next()) {
				Set fromKey = tResultSet.%GetData(1)
				Set fromIsShared = ..strategy.schema.IsSharedResourceType($Piece(fromKey,"/"))
				for icol=2:1:colCount+1 {
					Set refList = tResultSet.%GetData(icol)
					Continue:refList=""
					// If the reference column is not a %List, create a 1-element list for
					// the subsequent processing
					// (IF-474 fixes this -- previous only selecting the first reference)
					if '$listvalid(refList){
						Set refList = $LB(refList)
					}
					
					set rix=0
					while $ListNext(refList, rix, ref) {
						if ($D( pGathered("ref", ref), refValue ) = 0) {
							// First time we've seen this reference
							do $I(newRows)

							Set tTargetType = $Piece(ref, "/", 1)
							Set tTargetId = $Piece(ref, "/", 2)

							Set metaList = ..GetResourceMeta(tTargetType, tTargetId)
							// If the resource does exist but is deleted, return status 410 Gone.
							// For a regular read, Version should be null, so the method will return the deleted status of the current version.
							if ( ' $$$RsrcMetaIsDeleted(metaList)) {
								Set pGathered("ref", ref) = $$$RsrcMetaObjectKey(metaList)
							} else {
								// Flag as deleted
								Set pGathered("ref", ref) = ""				
							}
							Set refValue = pGathered("ref", ref) 
							//$$$FSLogInclude("  Gather: " _ ref _ " = " _ $$$RsrcMetaObjectKey(metaList))
						}
						if refValue '= "" {
							// Not Deleted, Keep track of reference paths
							Do ##class(HS.FHIRServer.Util.ReferenceVisitor).AddBackReference(.pGathered, ref, fromKey, fromIsShared)
						}
					}
				}
			}
			$$$FSLogInclude("  Gathered "_newRows_" unique resources from " _ tResultSet.%ROWCOUNT _ " result rows in " _ tSQLExecute _ " sec.")
		}
	}
}

Method GatherRevIncludedResourceIds(pIncludeEntry As HS.FHIRServer.SearchParam, pIdList As %String, ByRef pGathered, pTargetType As %String)
{
	#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn = ..searchColumnFromSearchParam(pIncludeEntry)
	set colName = searchColumn.ColumnName
	set isColl = searchColumn.isMultiValue
	Set resourceType = searchColumn.ResourceType
	Set targetType = pTargetType
	
	// Look for all resources of type 'resourceType' whose 'searchParam' matches and id in pIdList
	
	//$$$FSLogInclude("Gather RevIncludes for: " _ pIncludeEntry _ " and ids: " _ $lts(pIdList))
	
	set tableName = ..getTableForResourceType(resourceType)

	// Prepare to populate values for the query
	kill tSQLParams
	Set tSQLParams = 0
	
	set tSQL = "SELECT Key, "_ colName _ " FROM " _ tableName
	if isColl {
		Set tSQL = tSQL _ " WHERE FOR SOME %ELEMENT(" _ colName _") (%Value %INLIST ?)"
	}
	else {
		Set tSQL = tSQL _ " WHERE " _ colName _" %INLIST ?"

	}
	Set tSQLParams($I(tSQLParams)) = pIdList

	// Execute
	#dim tResultSet As %SQL.StatementResult = ..runQuery( .tSQL, .tSQLParams, .tSQLExecute)

	Set newRows = 0
	While (tResultSet.%Next()) {
		Set referringKey = tResultSet.%GetData(1)
		Set refersTo = tResultSet.%GetData(2)

		if ' $D( pGathered("ref", referringKey) ) {
			Set newRows = newRows + 1
		}
		Set pGathered("ref", referringKey) = refersTo
		//$$$FSLogInclude("  Gather: " _ ref _ " = " _ storageId)
		Set fromIsShared = ..strategy.schema.IsSharedResourceType($Piece(referringKey,"/"))

		Do ##class(HS.FHIRServer.Util.ReferenceVisitor).AddBackReference(.pGathered, refersTo, referringKey, fromIsShared)
	}
	$$$FSLogInclude("  Gathered "_newRows_" unique resources from " _ tResultSet.%ROWCOUNT _ " result rows in " _ tSQLExecute _ " sec.")
}

/* ------------------------------------------------------------------------------------ */
Method BuildSortClause(ByRef pSortKeys) As %String [ Private ]
{
	Set orderByClause = ""
	Set prefix = " Order by "
	
	Set ix = ""
	for {
		Set ix = $Order(pSortKeys(ix), 1 , isAscending)
		Quit:ix=""
		
		#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn = ..searchColumnFromSearchParam(pSortKeys(ix, "SearchParam"))
		set colName = searchColumn.ColumnName
		set isColl = searchColumn.isMultiValue
		
	
		// TODO: Resolve whether to sort descending periods on start or end time
		// TODO: Resolve whether DateTime fields can be properly sorted.
		if (searchColumn.DataType = "Period") {
			Set colName = colName _ $Select(isAscending:"Start", 1: "End")
		}
		if isColl {
			Set colName = $Select(isAscending:"HS_FHIRServer_Storage.ListFirst(", 1:"HS_FHIRServer_Storage.ListLast(") _ colName _ ")"
		}
		Set orderByClause = orderByClause _ prefix _ colName _ $Select(isAscending:" ASC", 1: " DESC")
		Set prefix = ","
	}
	return orderByClause
}

/* ------------------------------------------------------------------------------------ */
ClassMethod GetFirstInCollection(coll As %List) As %String [ SqlName = ListFirst, SqlProc ]
{
	Set len = $LL(coll)
	Set result = $ZCVT($LG(coll,1), "U")
	for ord=2:1:$LL(coll) {
		Set test = 	$ZCVT($LG(coll, ord), "U")
		if result ] test {
			Set result = test
		}
	}
	return result
}

/* ------------------------------------------------------------------------------------ */
ClassMethod GetLastInCollection(coll As %List) As %String [ SqlName = ListLast, SqlProc ]
{
	Set len = $LL(coll)
	Set result = $ZCVT($LG(coll,1), "U")
	for ord=2:1:$LL(coll) {
		Set test = 	$ZCVT($LG(coll, ord), "U")
		if test ] result {
			Set result = test
		}
	}
	return result
}

/* ------------------------------------------------------------------------------------ */
Method WhereCompartment(pType As %String, pCompartment As %String, pCompartmentId As %String, ByRef pSQLParams) As %String [ Private ]
{
	// Append a WHERE clause for selecting resources from a Compartment
	//   http://www.hl7.org/fhir/DSTU2/compartments.html
	//   http://www.hl7.org/fhir/STU3/compartments.html
	
	Set whereClause = ""
	#dim schema as HS.FHIRServer.Schema = ..strategy.schema
	if pCompartment '= "" {
		set compartmentName = $ZConvert(pCompartment, "L")
		if ' $$$IsCompartment(schema, compartmentName) {
			$$$ThrowFHIR($$$HSFHIRErrUnknownCompartment, compartmentName, $$$OutcomeInvalid(400))
		}
		if ' $$$IsTypeInCompartment(schema, compartmentName, pType) {
			$$$ThrowFHIR($$$HSFHIRErrNotInCompartment, compartmentName, pType, $$$OutcomeInvalid(400))
		}
		
	}
	
	// Given the resource type and the compartment, get the param names to search on
	set tSearchVal = pCompartment_"/"_pCompartmentId
	set separator = ""
	set whereClause = ""
	
	//$$$FSLog("WhereCompartment: "_tSearchVal)
	Set paramName = ""
	for {
		$$$NextParamNameInCompartment(schema,compartmentName,pType,paramName)
		Quit:(paramName="")
		//$$$FSLog("Search for "_tSearchVal_" in "_pType_"."_paramName)
		set param = schema.GetSearchParam(pType, paramName)
		#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn = ..searchColumnFromSearchParam(param)
		set colName = searchColumn.ColumnName
		set isColl = searchColumn.isMultiValue

		if isColl {
			set whereClause = whereClause_separator_"FOR SOME %ELEMENT("_colName_") (%VALUE=?)"
		} else {
			set whereClause = whereClause_separator_" "_colName_" =? "
		}
		set pSQLParams($I(pSQLParams)) = tSearchVal
		set separator = " OR "
	}
	if whereClause '= "" {
		set whereClause = "("_whereClause_")"
	}
	
	Return whereClause
}

/* ------------------------------------------------------------------------------------ */
Method WhereDate(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Generate the SQL query code for 'date' type search parameters
	#; http://www.hl7.org/fhir/DSTU2/search.html#date
	#; http://www.hl7.org/fhir/STU3/search.html#date
	
	$$$FSLog("Param: "_pSearchColumn.ParamName _ ", value: " _ pValue _ ", mod: " _ pModifier)
	
	Set isPeriodParameter = pSearchColumn.DataType = "Period"
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue
	// Get the parameter name
	set paramName = pSearchColumn.ParamName
		set fieldQTName = $Select($SYSTEM.SQL.IsReservedWord(fieldName):$Char(34)_fieldName_$Char(34), 1:fieldName)

			// A search value is supposed to select a target value if the implied ranges intersect at
			//  at all. For example, a search value "gt2012-06-15" should select a stored value of "2012"
			//  because the range of the search value (everything after 2012-06-15) intersects the implied
			//  range of the target value (2012-01-01T00:00:00 to 2012-12-31T23:59:59). This is handled
			//  automatically for upper bounds (lt,le) because a less precise value sorts before a 
			//  more precise value. For lower bounds (gt,ge), however, we must explicitly include a condition
			//  to select less precise values, ie, for "gt2012-06-15", we must include a condition like:
			//  "%VALUE IN ('2012-06','2012')"
			
			// Some values are indexed as periods. Periods have explicit start and end times, and both the
			//  start time and the end time are stored and indexed in the search table. All searchable periods
			//  in the data model are indexed as periods. Additionally some values that are not periods
			//  are indexed as periods, because the searchable property is an "[x]" property and one of
			//  the types that it may be is a period and at least one is not. Ex: The "onset" parameter
			//  of Condition searches both onsetPeriod and onsetDateTime. In this case, non-period values
			//  are indexed as periods by using implicit start and end times. The way searching on periods
			//  works is, if the seach contains a lower bound (gt, ge), then we query on the "End" value.
			//  If it contains an upper bound (lt, le), then we query on the "Start" value. "Equals" as
			//  it pertains to periods means (per the spec) "the range of the search value fully contains
			//  the range of the target value", which in this case means that the first instant of the
			//  search value comes before the stored "Start" value, and the last instant of the search
			//  value comes after the "End" value.
			
			
			// If the special case above does not apply, then process each condition individually.
			set tSearchVal = pValue
	set whereClause = ""
	set valueCount = $L(tSearchVal,",")
	for tJ=1:1:valueCount {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tJ'=1) { 
			set whereClause = whereClause_") OR (" 
		} else {
			set whereClause = whereClause_"(" 
				}
				// The value should have a prefix, however if it does not, treat that as "equal"
				if ($E(tOneSearchVal,1,2) ? 2A) {
					set tPrefix = $ZCVT($E(tOneSearchVal,1,2),"L")
					if (",eq,ne,gt,lt,ge,le,sa,eb,ap," '[ (","_tPrefix_",")) { 
						$$$ThrowFHIR($$$HSFHIRErrInvalidPrefixValue, paramName, tPrefix, $$$OutcomeInvalid(400))
					}
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}
				else { set tPrefix = "eq" }
				set tOrigSearchVal = tOneSearchVal
				Do ..ValidateDate(paramName, .tOneSearchVal)

				
				if (tPrefix = "eq") {
			if (isPeriodParameter) {
						if isColl {
							set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_..#PERIODSTARTSUFFIX_") (%VALUE >= ?) AND FOR SOME %ELEMENT("_fieldName_..#PERIODENDSUFFIX_") (%VALUE <= ?))"
						}
						else {
							set whereClause = whereClause_" ("_fieldName_..#PERIODSTARTSUFFIX_" >= ? AND "_fieldName_..#PERIODENDSUFFIX_" <= ?)"
						}
						set pSQLParams($I(pSQLParams)) = ..FirstInstant(tOneSearchVal)
						set pSQLParams($I(pSQLParams)) = ..LastInstant(tOneSearchVal)
					}
					elseif ($Length(tOneSearchVal)=10)&&(pSearchColumn.DataType = "DateTime")||(pSearchColumn.DataType = "Instant") {
						// If length is 10 then assume YYYY-MM-DD. This is a date-only value being
						// applied against a dateTime or instant-typed property. Because dateTime
						// and instant are indexed in UTC time, the time window for the date-only
						// search value must be adjusted for UTC.
						Set tDH = $ZDateTimeH(tOneSearchVal,3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tFirstVal = ##class(HS.FHIRServer.Utils).ConvertToUTC(tLocal)
						Set tDH = $ZDateTimeH(tOneSearchVal_"T23:59:59",3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tSecondVal = ##class(HS.FHIRServer.Utils).ConvertToUTC(tLocal)
						if isColl {
							set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE >= ?) AND FOR SOME %ELEMENT("_fieldName_") (%VALUE <= ?))"
						}
						else {
							set whereClause = whereClause_" ("_fieldQTName_" >= ? AND "_fieldQTName_" <= ?)"
						}
						set pSQLParams($I(pSQLParams)) = tFirstVal
						set pSQLParams($I(pSQLParams)) = tSecondVal
					}
					else {
						if isColl {
							set whereClause = whereClause_" FOR SOME %ELEMENT("_fieldName_") (%VALUE %STARTSWITH ?) "
						}
						else {
							set whereClause = whereClause_" "_fieldQTName_" %STARTSWITH ? "
						}
						set pSQLParams($I(pSQLParams)) = tOneSearchVal
					}
				}
				elseif (tPrefix = "ne") {
			if (isPeriodParameter) {
						// Per the standard, "not equal" as it applies to periods means: "the range of the search
						// value does not fully contain the range of the target value". So return results where the
						// period start is less than the first instant of the search value, or the period end is
						// greater than the last instant of the search value.
						if isColl {
							set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_..#PERIODSTARTSUFFIX_") (%VALUE < ?) OR FOR SOME %ELEMENT("_fieldName_..#PERIODENDSUFFIX_") (%VALUE > ?))"
						}
						else {
							set whereClause = whereClause_" ("_fieldName_..#PERIODSTARTSUFFIX_" < ? AND "_fieldName_..#PERIODENDSUFFIX_" > ?)"
						}
						set pSQLParams($I(pSQLParams)) = ..FirstInstant(tOneSearchVal)
						set pSQLParams($I(pSQLParams)) = ..LastInstant(tOneSearchVal)
					}
					elseif ($Length(tOneSearchVal)=10)&&((pSearchColumn.DataType = "DateTime")||(pSearchColumn.DataType = "Instant")) {				
						// If length is 10 then assume YYYY-MM-DD. This is a date-only value being
						// applied against a dateTime or instant-typed property. Because dateTime
						// and instant are indexed in UTC time, the time window for the date-only
						// search value must be adjusted for UTC.
						Set tDH = $ZDateTimeH(tOneSearchVal,3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tFirstVal = ##class(HS.FHIRServer.Utils).ConvertToUTC(tLocal)
						Set tDH = $ZDateTimeH(tOneSearchVal_"T23:59:59",3,1,,,,,,,"error")
						Set tLocal = $ZDateTime(tDH,3,5,0)
						Set tSecondVal = ##class(HS.FHIRServer.Utils).ConvertToUTC(tLocal)
						if isColl {
							set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE < ?) OR FOR SOME %ELEMENT("_fieldName_") (%VALUE > ?))"
						}
						else {
							set whereClause = whereClause_" "_fieldQTName_" < ? OR "_fieldQTName_" > ?"
						}
						set pSQLParams($I(pSQLParams)) = tFirstVal
						set pSQLParams($I(pSQLParams)) = tSecondVal
					}
					else {
						if isColl {
							set whereClause = whereClause_" FOR SOME %ELEMENT("_fieldName_") (NOT %VALUE %STARTSWITH ?) "
						}
						else {
							set whereClause = whereClause_" NOT "_fieldQTName_" %STARTSWITH ? "
						}
						set pSQLParams($I(pSQLParams)) = tOneSearchVal
					}
				}
				elseif (tPrefix = "gt")||(tPrefix = "ge") {
					// For "gt" ("greater than"):
					// -If search val is "2012", we want everything from 2013 on.
					// -If search val is "2012-06", we want everything from 2012-07 on, including "2012".
					// -If search val is "2012-06-15", we want everything from 2012-06-16 on, including "2012-06" and "2012"
					// -We cannot simply do "%VALUE > ?" with the parameter being the original search value because then
					//  "gt2012" will select "2012-06", which is wrong. So we increment the search value and do "%VALUE >= ?".
					// -Then, Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
					//
					// For "ge" ("greather than or equal to"):
					// -If search val is "2012", we want everything from 2012 on.
					// -If search val is "2012-06", we want everything from 2012-06 on, including "2012".
					// -If search val is "2012-06-15" we want everything from 2012-06-15 on, include "2012-06" and "2012".
					// -So most of what we want is encompassed by "%VALUE >= ?" on the original search value.
					// -Then, Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
					//
					// Therefore, the only different between "ge" and "gt" is that "gt" must have the original search value
					//  incremented before being used in the query.
					//
					// The only thing that changes for periods is that we want to search the "End" column for the period.
					
			if (isPeriodParameter) {
						set fieldName = fieldName_..#PERIODENDSUFFIX
					} else {
						set fieldName = fieldQTName
					}
					if isColl {
						set whereClause = whereClause_" FOR SOME %ELEMENT("_fieldName_") (%VALUE >= ?"
						// Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
						// YYYY-MM-DDThh:mm:ssZ
						if ($L(tOneSearchVal)=20) { set whereClause = whereClause_" OR %VALUE IN (?,?,?)) " }
						// YYYY-MM-DD
						elseif ($L(tOneSearchVal)=10) { set whereClause = whereClause_" OR %VALUE IN (?,?)) " }
						// YYYY-MM
						elseif ($L(tOneSearchVal)=7)  { set whereClause = whereClause_" OR %VALUE=?) " }
						else { set whereClause = whereClause_") " }
					} 
					else {
						set whereClause = whereClause_" "_fieldName_" >= ?"
						// Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
						// YYYY-MM-DDThh:mm:ssZ
						if ($L(tOneSearchVal)=20) { set whereClause = whereClause_" OR "_fieldName_" IN (?,?,?) " }
						// YYYY-MM-DD
						elseif ($L(tOneSearchVal)=10) { set whereClause = whereClause_" OR "_fieldName_" IN (?,?) " }
						// YYYY-MM
						elseif ($L(tOneSearchVal)=7)  { set whereClause = whereClause_" OR "_fieldName_" =? " }
						else { set whereClause = whereClause_") " }
					}
					set:tPrefix="gt" tOneSearchVal = ..IncrementDateTime(tOneSearchVal)
					set pSQLParams($I(pSQLParams)) = tOneSearchVal
					// YYYY-MM-DDThh:mm:ssZ
					if ($L(tOneSearchVal)=20) { set pSQLParams($I(pSQLParams)) = $E(tOneSearchVal,1,10) }
					// YYYY-MM-DD
					if ($L(tOneSearchVal)>=10) { set pSQLParams($I(pSQLParams)) = $E(tOneSearchVal,1,7) }
					// YYYY-MM
					if ($L(tOneSearchVal)>=7)  { set pSQLParams($I(pSQLParams)) = $E(tOneSearchVal,1,4) }
				}
				elseif (tPrefix = "lt")||(tPrefix = "le") {
					// For "lt" ("less than"):
					// -If search val is "2012", we want everything prior to 2012.
					// -If search val is "2012-06", we want everything prior to 2012-06, including "2012".
					// -If search val is "2012-06-15, we want everything prior to 2012-06-15, including "2012-06" and "2012".
					// -All of this is encompassed by "%VALUE < ?". For example, if the search is "lt2012-06", a value of "2012" will
					//  be selected because "2012" sorts before "2012-06".
					//
					// For "le" ("less than or equal to"):
					// -If search val is "2012", we want everything prior to 2013, including "2012-06" and "2012-06-15".
					// -If search val is "2012-06", we want everything prior to 2012-07, including "2012" and "2012-06-15".
					// -If search val is "2012-06-15", we want everything prior to 2012-06-16, including "2012" and "2012-06".
					// -If we increment the search value, then all of this is encompassed by "%VALUE < ?".
					//
					// Therefore, the only difference between "lt" and "le" is that "le" must have the original search value
					//  incremented before being used in the query.
					//
					// The only thing that changes for periods is that we want to search the "Start" column for the period.
					
					// If the param name is a SQL reserved word, it needs to be quoted in the "IS NOT NULL" part.
			if (isPeriodParameter) {
						set fieldName = fieldName_..#PERIODSTARTSUFFIX
					} else {
						set fieldName = fieldQTName
					}
					if isColl {
						set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE < ?) AND ("_fieldName_" IS NOT NULL))"
					}
					else {
						set whereClause = whereClause_"  "_fieldName_" < ? AND ("_fieldName_" IS NOT NULL) "
					}
					set:tPrefix="le" tOneSearchVal = ..IncrementDateTime(tOneSearchVal)
					set pSQLParams($I(pSQLParams)) = tOneSearchVal
				}
				else { 
					$$$ThrowFHIR($$$HSFHIRErrPrefixValueNotSupported, paramName, tPrefix, $$$OutcomeNotSupported(400))
				}
					
				set whereClause = whereClause_") "
	}	// loop over OR-ed together conditions
	if valueCount > 1 {
		set whereClause = "(" _ whereClause _ ")"	
	}
	return whereClause
}

/// Must be overridden by the subclass
/// Returns true if the given search parameter on the given resource type
/// searches of property of type Period, and false otherwise. pParamName must
/// be the name of the search parameter as it appears in the parameter
/// definition, *not* the param name normalized via <method>NormalizeParamName</method>.
/// ie, "date-recorded", not "dateRecorded". If a search parameter searches
/// more than one property, this will return true if any of them is a Period.
/// For example, the "date" parameter on Procedure searches two properties,
/// performedDateTime and performedPeriod.  performedPeriod is a Period, so
/// this method returns true for that parameter.
/// Given a date or date-time, decrement it by one of whatever the precision is.
/// For example, "1932" returns "1931". "1985-01" returns "1984-12".
/// "2000-05-25T15:45Z" returns "2000-05-25T15:44Z". Valid input formats are:<br/>
/// YYYY <br/>
/// YYYY-MM <br/>
/// YYYY-MM-DD <br/>
/// YYYY-MM-DDThh:mmZ <br/>
/// YYYY-MM-DDThh:mm:ssZ <br/>
/// pDateTime is assumed to be valid and in UTC when applicable. ie, should
/// have already had <method>ValidateDate</method> called on it.
ClassMethod DecrementDateTime(pDateTime As %String) As %String
{
	// YYYY
	if (pDateTime ? 4N) {
		quit (pDateTime - 1)
	}
	// YYYY-MM
	elseif (pDateTime ? 4N1"-"2N) {
		set tYear = $P(pDateTime,"-",1)
		set tMonth = $P(pDateTime,"-",2)
		if (tMonth = "01") { set tMonth = "12", tYear = tYear-1 }
		else {
			set tMonth = tMonth-1
			if ($L(tMonth)=1) { set tMonth = "0"_tMonth }
		}
		quit (tYear_"-"_tMonth)
	}
	// YYYY-MM-DD
	elseif (pDateTime ? 4N1"-"2N1"-"2N) {
		// Convert to $H format, decrement, convert back
		set tDateH = $ZDH(pDateTime,3)
		quit $ZD(tDateH-1,3)
	}
	// YYYY-MM-DDThh:mm[:ss]Z
	elseif (pDateTime ? 4N1"-"2N1"-"2N1"T"2N1":"2N0.1(1":"2N)1"Z") {
		// In the absence of seconds, $ZDTH assumes them to be "00".
		set tDateTimeH = $ZDTH(pDateTime,3,7)
		set tDateH=$P(tDateTimeH,","), tTimeH=$P(tDateTimeH,",",2)
		// If the time is midnight (00:00:00), decrement the date and set the time to 23:59:59.
		if (tTimeH=0) { set tDateH=tDateH-1, tTimeH=86399 }
		else { set tTimeH = tTimeH-1 }
		quit $ZDT(tDateH_","_tTimeH,3,7)
	}
	else { throw ##class(%Exception.General).%New("General Exception","999",,"Invalid date-time: "_pDateTime) }
}

/// Given a date or date-time, increment it by one of whatever the precision is.
/// For example, "1932" returns "1933". "1985-12" returns "1986-01".
/// "2000-05-25T15:45Z" returns "2000-05-25T15:46Z". Valid input formats are:<br/>
/// YYYY <br/>
/// YYYY-MM <br/>
/// YYYY-MM-DD <br/>
/// YYYY-MM-DDThh:mmZ <br/>
/// YYYY-MM-DDThh:mm:ssZ <br/>
/// pDateTime is assumed to be valid and in UTC when applicable. ie, should
/// have already had <method>ValidateDate</method> called on it.
ClassMethod IncrementDateTime(pDateTime As %String) As %String
{
	// YYYY
	if (pDateTime ? 4N) {
		quit (pDateTime + 1)
	}
	// YYYY-MM
	elseif (pDateTime ? 4N1"-"2N) {
		set tYear = $P(pDateTime,"-",1)
		set tMonth = $P(pDateTime,"-",2)
		if (tMonth = 12) { set tMonth = "01", tYear = tYear+1 }
		else {
			set tMonth = tMonth+1
			if ($L(tMonth)=1) { set tMonth = "0"_tMonth }
		}
		quit (tYear_"-"_tMonth)
	}
	// YYYY-MM-DD
	elseif (pDateTime ? 4N1"-"2N1"-"2N) {
		// Convert to $H format, increment, convert back
		set tDateH = $ZDH(pDateTime,3)
		quit $ZD(tDateH+1,3)
	}
	// YYYY-MM-DDThh:mm[:ss]Z
	elseif (pDateTime ? 4N1"-"2N1"-"2N1"T"2N1":"2N0.1(1":"2N)1"Z") {
		// In the absence of seconds, $ZDTH assumes them to be "00".
		set tDateTimeH = $ZDTH(pDateTime,3,7)
		// Increment the time.
		set tDateH=$P(tDateTimeH,","), tTimeH=$P(tDateTimeH,",",2)+1
		// If this makes the time 24 hours since midnight, increment the date and set the time to 0.
		// 24*60*60=86400
		if (tTimeH=86400) { set tTimeH=0, tDateH=tDateH+1 }
		quit $ZDT(tDateH_","_tTimeH,3,7)
	}
	else { throw ##class(%Exception.General).%New("General Exception","999",,"Invalid date-time: "_pDateTime) }
}

/// Validate a date param<br>
/// Param can be in the format:<br>
/// YYYY<br>
/// YYYY-MM<br>
/// YYYY-MM-DD<br>
/// YYYY-MM-DDThh:mm<br>
/// YYYY-MM-DDThh:mm:ss<br>
/// This method will also assert that month, date, hour, minute and second values are valid<br>
/// pDate will be modified and returned if the precision on it warranted converting to UTC
ClassMethod ValidateDate(pParamName As %String, ByRef pDate As %String) As %String
{
	do {
		// YYYY
		if ($L(pDate)=4) {
			if (pDate '? 4N) { quit }
			set tFilledInDate = pDate_"-01-01T00:00:00"
		}
		// YYYY-MM
		elseif ($L(pDate)=7) {
			if (pDate '? 4N1"-"2N) { quit }
			set tFilledInDate = pDate_"-01T00:00:00"
		}
		// YYYY-MM-DD
		elseif ($L(pDate)=10) {
			if (pDate '? 4N1"-"2N1"-"2N) { quit }
			set tFilledInDate = pDate_"T00:00:00"
		}
		// YYYY-MM-DDThh:mm (no time zone)
		elseif ($L(pDate)=16) {
			if (pDate '? 4N1"-"2N1"-"2N1"T"2N1":"2N) { quit }
			set tFilledInDate = pDate_":00"
			set pDate = ##class(HS.FHIRServer.Utils).ConvertToUTC(tFilledInDate)
		}
		// YYYY-MM-DDThh:mm:ss (no time zone)
		elseif ($L(pDate)=19) {
			if (pDate '? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N) { quit }
			set tFilledInDate = pDate
			set pDate = ##class(HS.FHIRServer.Utils).ConvertToUTC(pDate)
		}
		elseif ($L(pDate)>19) {
			// YYYY-MM-DDThh:mm:ss.nnn (no time zone)
			if (pDate ? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N.1".".1N.E)&&(pDate '? .E1"+"2N1":"2N)&&(pDate '? .E1"-"2N1":"2N)&&($E(pDate,*)'="Z") {
				set tFilledInDate = pDate
				set pDate = ##class(HS.FHIRServer.Utils).ConvertToUTC(pDate)
			}
			elseif '((pDate ? 4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N.E)&&((pDate ? .E1"+"2N1":"2N)||(pDate ? .E1"-"2N1":"2N)||($E(pDate,*)="Z"))) {
				// Does not evaluate to a date and time with time zone.
				quit
			}
			else {
				// YYYY-MM-DDThh:mm:ss[.nnn] (with time zone)
				if $extract(pDate,"*")="Z" {
					set tFilledInDate = $E(pDate, 1, *-1)
				} else {
					set tFilledInDate = $E(pDate, 1, *-6)
					set pDate = ##class(HS.FHIRServer.Utils).ConvertToUTC(pDate)
				}
			}
		}
		// unrecognized length
		else {
			quit
		}
		
		// Now verify the format and that it can be converted to Cache internal format
		if ( $ZDATETIMEH(tFilledInDate,3,,,,,,,,"error") = "error") {
			Quit
		}
		// Success!
		Return
	} while 0 // End of once-through block
	// If we get here, it is an error condition
	$$$ThrowFHIR($$$HSFHIRErrInvalidQueryParameterValue, pParamName, pDate, $$$OutcomeInvalid(400))
}

/* ------------------------------------------------------------------------------------ */
Method WhereNumber(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Generate the SQL query code for 'number' type search parameters
	#; http://www.hl7.org/fhir/DSTU2/search.html#number
	#; http://www.hl7.org/fhir/STU3/search.html#number
	
	#dim tPrefixes As %String = ",eq,ne,gt,lt,ge,le,sa,eb,ap,"
	//get field metadata
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue
	// Get the parameter name
	set paramName = pSearchColumn.ParamName
		
	//Modifiers are not supported yet
	if (pModifier'="") { 
		$$$ThrowFHIR($$$HSFHIRErrUnsupportedParameterModifier, paramName, pModifier, $$$OutcomeNotSupported(400) )
	}
	set tSearchVal = pValue
	// Each val in the $LIST is a comma-delimited list of OR-ed together conditions
	//  ex: /fhir/Encounter?length=lt5,gt20
	//  "search for encounter with length <5 OR length >20"

	Set openClause = ""
	Set closeClause = ""
	Set prefix = ""
	
	if isColl || (tSearchVal [ ",") {
		Set openClause = "("
		Set closeClause = ")"
	}

	if isColl {
		set whereClause = "(FOR SOME %ELEMENT("_fieldName_") ("
		Set fieldName = "%VALUE"
	} else {
		Set whereClause = ""
	}
	
	// pValue is a single of value. It is possible to have multiple parameters for a single reference
	// in which chase, this will be called once per parameter (all clauses AND'd together)
	//  ex: /fhir/Encounter?length=gt5&length=lt20
	//  "search for encounters with length >5 AND length <20"
	// Note: attempting to combine two AND-ed inequalities with a "BETWEEN" condition
	//  does not appear to yield any performance improvement.
	set tInequalityExists=0

	// Accumulate any parameter errors and report them all			
	set tSC = $$$OK

	for tJ=1:1:$L(tSearchVal,",") {
		set tOneSearchVal = $P(tSearchVal,",",tJ)
		if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
			set tPrefix = $E(tOneSearchVal,1,2)
			set tOneSearchVal = $E(tOneSearchVal,3,*)
		}
		// No prefix is the same as "eq"
		else { 
			set tPrefix = "eq" 
		}
		if ('$IsValidNum(tOneSearchVal)) { 
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidQueryParameterValue, paramName, pDate))
		}
		set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
		if (tOp="err") { 
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidPrefixValue, paramName, tPrefix))
		}
		if (tOp["<") || (tOp[">") { 
			set tInequalityExists = 1 
		}
		Set whereClause = whereClause _ prefix _ openClause _ fieldName _ tOp _ "?" _ closeClause
		// Cast the search value to a number. Right now it is a string.
		set pSQLParams($I(pSQLParams)) = +tOneSearchVal
			
		// If we loop, include an OR
		Set prefix = " OR "
	}
	$$$ThrowOnError(tSC)
	
	
	// The "IS NOT NULL" is only stricly necessary if there is an upper bound (le,lt) with no lower bound (gt,ge),
	//  as null values are "less than" any non-null value. However, what I have observed in testing is that when
	//  there is a lower bound, the "IS NOT NULL" makes the query perform slightly better, whether there is an
	//  upper bound or not.
	if (tInequalityExists) { 
		set whereClause = whereClause_" AND "_fieldName_" IS NOT NULL" 
	}
	if isColl {
		Set whereClause = whereClause _ "))"
	}
	return whereClause
}

/* ------------------------------------------------------------------------------------ */
Method WhereQuantity(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	
	// Generate the SQL query code for 'quantity' type search parameters
	#; http://www.hl7.org/fhir/DSTU2/search.html#quantity
	#; http://www.hl7.org/fhir/STU3/search.html#quantity
	
	#dim tPrefixes As %String = ",eq,ne,gt,lt,ge,le,sa,eb,ap,"
	// Get the parameter name
	set paramName = pSearchColumn.ParamName
	set whereClause = "("
		
	//Modifiers are not supported yet
	if (pModifier'="") { 
		$$$ThrowFHIR($$$HSFHIRErrUnsupportedParameterModifier, paramName, pModifier, $$$OutcomeNotSupported(400) )
	}
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue
	
	Set tUnits=""
	Set tUnitsMatch=1
	set tSearchVal = pValue
	Set valueCount = $L(tSearchVal,",")
	
	// Values are in the form number|system|code.
	// Here we check if the 'system|code' portion is the same for
	// all search values.  If so, we can optimize the generated query
	for tJ=1:1:valueCount { 
		Set searchValue = $P(tSearchVal,",",tJ)
		set tSearchUnits = $P(searchValue, "|", 2, 3)
		if (tUnits="") { 
			set tUnits = tSearchUnits 
		} elseif (tUnits '= tSearchUnits) {
			// A mismatch .. cannot optimize
			set tUnitsMatch=0
			quit 
		}
	}
	//w "pValue ",pValue,!
	if isColl {
		// There is a separate index table for each 'Quantity' parameter.  The table name
		// is derived from the Resource Type and the parameter name
		set fullChildTableName = $TR(pParentTableName, ".", "_") _ "." _ ..NormalizeParamName(paramName)
		$$$FSLog("childTable: "_fullChildTableName)
		/*
		Optimize for a special case: all of the various AND-ed and OR-ed conditions have the exact
		 same units. In that case, rather than including a "unit" condition with each "value" condition,
		 combine all the "value" conditions and then "AND" on a single "unit" condition to those. For
		 example, given a search:
		    [base]/fhir/Observation?value-quantity=gt3.1||mmol/L&value-quantity=lt6.2||mmol/L
		Rather than generating:
		    SELECT ResourceLogicalId As ID FROM HS_Local_FHIR_Repository_Search.Observation 
		  	WHERE ResourceLogicalId IN (SELECT ResourceLogicalId FROM HS_Local_FHIR_Repository_Search_Observation.valueQuantity WHERE
		 	((value > 3.1 AND FOR SOME %ELEMENT(unit) (%VALUE='http://unitsofmeasure.org|mmol/L')) 
		 	 AND 
		  	(value < 6.2 AND FOR SOME %ELEMENT(unit) (%VALUE='http://unitsofmeasure.org|mmol/L'))))
		Instead generate:
		  	SELECT ResourceLogicalId As ID FROM HS_Local_FHIR_Repository_Search.Observation 
			WHERE ResourceLogicalId IN (SELECT ResourceLogicalId FROM HS_Local_FHIR_Repository_Search_Observation.valueQuantity WHERE
		  	FOR SOME %ELEMENT(unit) (%VALUE='http://unitsofmeasure.org|mmol/L')) AND
		  	value>3.1 AND value<6.2)
		  	
		Originally I had the idea to optimize this even further by replacing two AND-ed inequalities with
		a "BETWEEN" condition, however my testing shows no performance improvement when I do this. The SQL
		engine must be doing the same thing in either case.
		*/
		
		
		if (tUnitsMatch) {
			set whereClause = whereClause_" Key IN (SELECT Key FROM "_fullChildTableName_" WHERE (FOR SOME %ELEMENT(unit) (%VALUE=?)) AND "
			set pSQLParams($I(pSQLParams)) = tUnits
			
			Set tSC = $$$OK
			set clausePrefix = "("
			for tJ=1:1:valueCount {
				set whereClause = whereClause_ clausePrefix
				set clausePrefix = " OR "
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
					set tPrefix = $E(tOneSearchVal,1,2)
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}
				else { 
					set tPrefix = "eq"
				}
				set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
				if (tOp="err") { 
					// Accumulate all parameter errors and throw after the loop if any found
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrPrefixValueNotSupported, paramName, tPrefix))
				}
				set whereClause=whereClause_" value"_tOp_"? "
				set pSQLParams($I(pSQLParams)) = $P(tOneSearchVal,"|")
			}
			set whereClause=whereClause_"))"
			$$$ThrowOnError(tSC)
			
			
		} else {
			// pValue is a single of value. It is possible to have multiple parameters for a single reference
			// in which chase, this will be called once per parameter (all clauses AND'd together)
			//  ex: /fhir/Observation?value-quantity=le6||kpa&value-quantity=ge4.8||kpa
			//  "search for all observations with value between 4.8 and 6 kPa"
			//  (except that this example would actually be handled above)
			set whereClause = whereClause_" ResourceLogicalId IN (SELECT ResourceLogicalId FROM "__fullChildTableName_" WHERE ("
			Set tSC = $$$OK
			for tJ=1:1:valueCount {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
					set tPrefix = $E(tOneSearchVal,1,2)
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}

				// Missing prefix is the same as "eq"
				else {
					set tPrefix = "eq" 
				}
				set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
				if (tOp="err") { 
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrPrefixValueNotSupported, paramName, tPrefix))
				}
				set tValue = $P(tOneSearchVal, "|")
				set tUnits = $P(tOneSearchVal, "|", 2, 3)
			    if (tJ'=1) { 
			    	set whereClause = whereClause_" OR " 
			    }
				set whereClause = whereClause_"(Value "_tOp_" ? AND (FOR SOME %ELEMENT(unit) (%VALUE=?)))"
				set pSQLParams($I(pSQLParams)) = tValue
				set pSQLParams($I(pSQLParams)) = tUnits
			}
			set whereClause = whereClause_"))"
			// Report any syntax errors found
			$$$ThrowOnError(tSC)
		}
		
		Return whereClause _ ")"
	}

	//***************** not a collection
	else {
		if (tUnitsMatch) {
			set unit = $p(tSearchUnits,"|",2)
			set system = $p(tSearchUnits,"|",1)
			set whereClause = whereClause_" ( "
			if (unit '="") && (system'= "") {
				set whereClause = whereClause _ fieldName _ "_unit =? AND "
				set pSQLParams($I(pSQLParams)) = tSearchUnits
			}
			elseif (unit '="") {
				set whereClause = whereClause _ fieldName_"_unit LIKE ? AND "
				set pSQLParams($I(pSQLParams)) = "%|"_unit
			}
			elseif (system'="") {
				set whereClause = whereClause _ fieldName_"_unit LIKE ? AND "
				set pSQLParams($I(pSQLParams)) = system_"|%"
			} 
			
			Set tSC = $$$OK
			set clausePrefix = "("
			for tJ=1:1:valueCount {
				set whereClause = whereClause_ clausePrefix
				set clausePrefix = " OR "
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
					set tPrefix = $E(tOneSearchVal,1,2)
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}
				else { 
					set tPrefix = "eq"
				}
				set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
				if (tOp="err") { 
					// Accumulate all parameter errors and throw after the loop if any found
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrPrefixValueNotSupported, paramName, tPrefix))
				}
				set whereClause=whereClause_" "_fieldName_"_value"_tOp_"? "
				set pSQLParams($I(pSQLParams)) = $P(tOneSearchVal,"|")
			}
			set whereClause=whereClause_"))"
			$$$ThrowOnError(tSC)
			
			
		} 
		else {  //units do not match
			set whereClause = whereClause_"(( "

			Set tSC = $$$OK
			for tJ=1:1:valueCount {
				set tOneSearchVal = $P(tSearchVal,",",tJ)
				if (tPrefixes [ (","_$E(tOneSearchVal,1,2)_",")) {
					set tPrefix = $E(tOneSearchVal,1,2)
					set tOneSearchVal = $E(tOneSearchVal,3,*)
				}

				// Missing prefix is the same as "eq"
				else {
					set tPrefix = "eq" 
				}
				set tOp = $CASE(tPrefix, "eq":"=", "ne":"!=", "gt":">", "lt":"<", "ge":">=", "le":"<=", :"err")
				if (tOp="err") { 
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrPrefixValueNotSupported, paramName, tPrefix))
				}
				set tValue = $P(tOneSearchVal, "|")
				set tUnits = $P(tOneSearchVal, "|", 2, 3)
			    if (tJ'=1) { 
			    	set whereClause = whereClause_" OR " 
			    }
				set whereClause = whereClause_"("_fieldName_"_value "_tOp_" ? AND "
				//(FOR SOME %ELEMENT(unit) (%VALUE=?)))"
				set pSQLParams($I(pSQLParams)) = tValue
				set unit = $p(tUnits,"|",2)
				set system = $p(tUnits,"|",1)
				if (unit '="") && (system'= "") {
					set whereClause = whereClause_"  "_fieldName_"_unit =? ) "
					set pSQLParams($I(pSQLParams)) = tSearchUnits
				}
				elseif (unit '="") {
					set whereClause = whereClause_" ( "_fieldName_"_unit LIKE ? ) "
					set pSQLParams($I(pSQLParams)) = "%|"_unit
				}
				else {
					set whereClause = whereClause_" ( "_fieldName_"_unit LIKE ? ) "
					set pSQLParams($I(pSQLParams)) = system_"|%"
				}

				
				
			}
			set whereClause = whereClause_"))"
		
		}
		Return whereClause _ ")"
	}
}

/* ------------------------------------------------------------------------------------ */
Method WhereReference(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Generate the SQL query code for 'reference' type search parameters
	#; http://www.hl7.org/fhir/DSTU2/search.html#reference
	#; http://www.hl7.org/fhir/STU3/search.html#reference
	
	// Get the parameter name
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue

	set paramName = pSearchColumn.ParamName
	set whereClause = "("
	
	// The modifier, if present, is the type of the referenced resource
	// pValue is a single of value. It is possible to have multiple parameters for a single reference
	// in which chase, this will be called once per parameter (all clauses AND'd together)
	//  Ex: Find patients linked to careProvider A (Organization) and careProvider B (Practitioner)
	set tSearchVal = pValue
	// The search value may be comma-delimited list, which indicates OR-ed together conditions
	set tNumSearchVals = $L(tSearchVal,",")
	if isColl {
		if (tNumSearchVals=1) {
			set whereClause = whereClause_" FOR SOME %ELEMENT("_fieldName_") (%VALUE=?) "
		}
		else {
			set whereClause = whereClause_" FOR SOME %ELEMENT("_fieldName_") (%VALUE IN (?"
				for tJ=2:1:tNumSearchVals { set whereClause = whereClause_",?" }
			set whereClause = whereClause_"))"
		}
	}
	else {
		if (tNumSearchVals=1) {
			set whereClause = whereClause_" "_fieldName_"=? "
		}
		else {
			set whereClause = whereClause_" "_fieldName_" IN (?"
			for tJ=2:1:tNumSearchVals { set whereClause = whereClause_",?" }
			set whereClause = whereClause_")"
		}
	}
	
	/// Logic Here.
	/// 1. If there is a modifier, then the search should only match that type
	/// 1a. reject any fully qualified values a conflicting type
	/// 1b. qualify any unqualified values
	/// 2. If there is no modifier, then
	/// 2a. If the search allows more than one type, reject unqualified values
	/// 2a1. Qualify if only one type allowed
	/// 2b. Verify that the value's requested type is allowed
	Set qualifier = ""
	if pModifier '="" {
		// If the param has a modifier, validate its type and set it as the "qualifier"
		if '$ListFind(pSearchColumn.Target, pModifier) {
			$$$ThrowFHIR($$$HSFHIRErrBadReferenceModifier, pModifier, pSearchColumn.ParamName, $LTS(pSearchColumn.Target), $$$OutcomeInvalid(400))
		}
		Set qualifier = pModifier
	} elseif $ListLength(pSearchColumn.Target) = 1 {
		// Otherwise, if we only have one target type, make it the qualifier
		set qualifier = $List(pSearchColumn.Target)
	}

	for tJ=1:1:tNumSearchVals { 
		set tOneSearchVal = $P(tSearchVal,",",tJ)
		// Check if the value is qualified
		if ($L(tOneSearchVal,"/")=1) {	
			// Unqualified ....
			if qualifier = "" {
				$$$ThrowFHIR($$$HSFHIRErrAmbiguousReferenceParam, pSearchColumn.ResourceType, pSearchColumn.ParamName, $LTS(pSearchColumn.Target), $$$OutcomeInvalid(400))
			}
		 	set tOneSearchVal = qualifier_"/"_tOneSearchVal 
		} else {
			// Qualified
			Set paramType = $Piece(tOneSearchVal,"/",1)
			if '$ListFind(pSearchColumn.Target, paramType) {
				$$$ThrowFHIR($$$HSFHIRErrInvalidReferenceType, pSearchColumn.ParamName, paramType, $LTS(pSearchColumn.Target), $$$OutcomeInvalid(400))
			}		
			if (pModifier '= "") && (paramType '= pModifier) {
				$$$ThrowFHIR($$$HSFHIRErrConflictingReferenceParam, pModifier, pSearchColumn.ParamName, tOneSearchVal, $$$OutcomeInvalid(400))
			}
		}
		set pSQLParams($I(pSQLParams)) = tOneSearchVal
	}
	Return whereClause _ ")"
}

/* ------------------------------------------------------------------------------------ */
Parameter DEFAULTCHARSACCENTED = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüýÿ";

Parameter DEFAULTCHARSUNACCENTED = "AAAAAACEEEEIIIINOOOOOOUUUUYaaaaaaceeeeiiiinoooooouuuuyy";

Method WhereString(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Generate the SQL query code for 'string' type search parameters
	#; http://www.hl7.org/fhir/DSTU2/search.html#string
	#; http://www.hl7.org/fhir/STU3/search.html#string

	// Get the parameter name
	set paramName = pSearchColumn.ParamName
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue

	Set whereClause = "("
	
	// TO DO: Accent-sensitivity of "exact" searches
	//  Right now if the client does an exact search for "Marche" and the original value is "Marché", the
	//  resource will be returned (even though it shouldn't be) because both "Marche" and "Marché" exist in
	//  the search table and there is no distinction as to which is the original value.
	
	// An unrecognized modifier returns an error. This gets returned to the client.
	if (",exact,contains,," '[ (","_pModifier_",")) { 
		$$$ThrowFHIR($$$HSFHIRErrUnsupportedModifier, paramName, pModifier, $$$OutcomeInvalid(400))
	}
	// Per the FHIR spec, string search is case-insensitive unless the "exact" modifier is used.
	// However the "[" operator uses exact collation. See:
	//   http://<host>:<port>/csp/docbook/DocBook.UI.Page.cls?KEY=GSQL_langelements#GSQL_langelements_ops_relational
	// For this reason, we must do that collation within the query. So %VALUE is UPPER collated here,
	//  and the the search value is UPPER collated below.
	if isColl {
		if (pModifier="contains") { set tCondition = " (%UPPER(%VALUE) [ ?) " }
		elseif (pModifier="exact") { set tCondition = " (%EXACT(%VALUE)= ?) " }
		else { set tCondition = " (%VALUE %STARTSWITH ?) " }
	}
	else {
		if (pModifier="contains") { set tCondition = " (%UPPER("_fieldName_") [ ?) " }
		elseif (pModifier="exact") { set tCondition = " (%EXACT("_fieldName_")= ?) " }
		else { set tCondition = " ("_fieldName_" %STARTSWITH ?) " }
	}
	
	// pValue is a single of value. It is possible to have multiple parameters for a single reference
	// in which chase, this will be called once per parameter (all clauses AND'd together)
	set tValue = pValue
	set tNumSearchVals = $L(tValue,",")
	for tJ=1:1:tNumSearchVals {
		set tOneVal = $P(tValue, ",", tJ)
		if (tJ'=1) { 
			set whereClause = whereClause_" OR " 
		}
		if isColl {
			set whereClause = whereClause _ " (FOR SOME %ELEMENT("_fieldName _ ") " _ tCondition _ ")"
		}
		else {
			set whereClause = whereClause _ " (" _ tCondition _ ")"
		}
		// Collation 5 = UPPER (converts letters to uppercase)
		if (pModifier="contains") { 
			set tOneVal = $system.Util.Collation(tOneVal,5) 
		}
		// Normalize for accents if the modifier is not "exact".
		if (pModifier'="exact") {
			set pSQLParams($I(pSQLParams)) = ..NormalizeAccents(tOneVal) 
		}
		else {
			set pSQLParams($I(pSQLParams)) = tOneVal 
		}
	}

	Return whereClause _ ")"
}

ClassMethod NormalizeAccents(pVal As %String) As %String
{
	#; For now, the functionality to get the "from" and "to" strings from the
	#; config registry is being disabled while we decide how we want to enable
	#; the user to customize these values. The DEFAULTCHARSACCENTED and
	#; DEFAULTCHARSUNACCENTED parameters of this class will be used for the time being.
	#; The original annotation:
/// This method will $TRANSLATE accented chars to unaccented, since string search
/// is supposed to be accent-insensitive. The "from" string comes from the
/// Configuration Registry entry with the key:<br>
///   /FHIR/Search/CharsAccented<br>
/// The "to" string comes from the entry:<br>
///   /FHIR/Search/CharsUnaccented<br>
/// If either of these values is null or not defined, then the default values from
/// the parameters <parameter>DEFAULTCHARSACCENTED</parameter> and <parameter>DEFAULTCHARSUNACCENTED</parameter>
/// will be used.
	/*
	#dim RegistryKeyCharsAccented = "/FHIR/Search/CharsAccented"
	#dim RegistryKeyCharsUnaccented = "/FHIR/Search/CharsUnaccented"
	
	if ($G(%FHIR("CharsAccented"))="")||($G(%FHIR("CharsUnaccented"))) {
		set tCharsAccented = ##class(HS.Registry.Config).GetKeyValue(RegistryKeyCharsAccented)
		set tCharsUnaccented = ##class(HS.Registry.Config).GetKeyValue(RegistryKeyCharsUnaccented)
		// Both keys must have a value, or neither will be used
		// (To prevent something like a user mistyping one of the keys, so one string from the Registry
		//  being used with one of the default strings - a disaster)
		if (tCharsAccented'="")&&(tCharsUnaccented'="") {
			set %FHIR("CharsAccented") = tCharsAccented
			set %FHIR("CharsUnaccented") = tCharsUnaccented
		}
		else {
			set %FHIR("CharsAccented") = ..#DEFAULTCHARSACCENTED
			set %FHIR("CharsUnaccented") = ..#DEFAULTCHARSUNACCENTED
		}
	}
	
	quit $TRANSLATE(pVal, %FHIR("CharsAccented"), %FHIR("CharsUnaccented"))
	*/
	quit $TRANSLATE(pVal, ..#DEFAULTCHARSACCENTED, ..#DEFAULTCHARSUNACCENTED)
}

/* ------------------------------------------------------------------------------------ */
Method WhereToken(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Generate the SQL query code for 'token' type search parameters
	#; http://www.hl7.org/fhir/DSTU2/search.html#token
	#; http://www.hl7.org/fhir/STU3/search.html#token

	// Get the list of datatypes this parameter supports
	Set columnType = pSearchColumn.DataType
	set paramName = pSearchColumn.ParamName
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue

	Set whereClause = ""

	//Modifiers are not supported yet
	// The repository operation will check for the text "Unsupported modifier on param" in the error so it can return a
	// 400 (Bad Request) rather than a 500 (Internal Server Error).
	if (pModifier'="") { 
		$$$ThrowFHIR($$$HSFHIRErrUnsupportedParameterModifier, paramName, pModifier, $$$OutcomeNotSupported(400) ) 
	}
	
	set tSearchVal = pValue
	// The search value may be comma-delimited list, which indicates OR-ed together conditions
	set tNumSearchVals = $L(tSearchVal,",")
	if isColl {
		if (tNumSearchVals=1) {
			set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE=?)) "
		}
		else {
			set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE IN (?"
			for tJ=2:1:tNumSearchVals { 
				set whereClause = whereClause_",?" 
			}
			set whereClause = whereClause_")))"
		}
	
	}
	else {
		if (tNumSearchVals=1) {
			set whereClause = whereClause_" ("_fieldName_"=?) "
		}
		else {
			set whereClause = whereClause_" ("_fieldName_"  IN (?"
			for tJ=2:1:tNumSearchVals { 
				set whereClause = whereClause_",?" 
			}
			set whereClause = whereClause_"))"
		}
	
	}
	for tJ=1:1:tNumSearchVals { 
		set tOneSearchVal = $P(tSearchVal,",",tJ)
		// For each search value, if we can determine it is a phone number, normalize it
		// for search. The search val is a phone number if it is formatted as:
		//      [system]-[use]|[value]
		// And "[system]" is "phone", "fax", or "beeper"
		set tSystem = $P(tOneSearchVal,"|",1)
		Set tCode = $P(tOneSearchVal,"|",2)
		if (tCode '= "") {
			// A two part value (system,code)
			if (columnType = "CodeableConcept") || (columnType = "Coding") || (columnType = "Identifier") {
				// These types allow a 'system' specification
			} elseif (columnType = "ContactPoint") {
				// This is a phone number style value, we normalize for better searching
				// Note this is only for STU3.
			if ($L(tSystem,"-")=2) && (",phone,fax,beeper," [ (","_$P(tSystem,"-")_",")) {
				set $P(tOneSearchVal,"|",2) = ..NormalizePhone($P(tOneSearchVal,"|",2))
			}
			} else {
				// No other token types allow the 2-part value
				$$$ThrowFHIR($$$HSFHIRErrCodeSystemNotAllowed, paramName, $$$OutcomeNotSupported(400))
		}
		}
		set pSQLParams($I(pSQLParams)) = tOneSearchVal
	}
	
	Return whereClause
}

/* ------------------------------------------------------------------------------------ */

/* ------------------------------------------------------------------------------------ */
Method WhereURI(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Generate the SQL query code for 'uri' type search parameters
	#; http://www.hl7.org/fhir/DSTU2/search.html#uri
	#; http://www.hl7.org/fhir/STU3/search.html#uri
	
	// Get the parameter name
	set paramName = pSearchColumn.ParamName
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue

	
	
	if (pModifier'="")&&(pModifier'="above")&&(pModifier'="below") { 
		$$$ThrowFHIR($$$HSFHIRErrUnsupportedParameterModifier, paramName, pModifier, $$$OutcomeNotSupported(400) ) 
	}
	
	set tSearchVal = pValue
	// Each val in the $LIST is a comma-delimited list of OR-ed together conditions
	set whereClause = "("
	for tJ=1:1:$L(tSearchVal,",") {
		set tOneSearchVal = $P(tSearchVal,",",tJ)
		if (tJ'=1) { 
			set whereClause = whereClause_" OR " 
		}
		if (+$Extract(..strategy.schema.FHIRVersion) >= 3) && ($e(tOneSearchVal,1,4)="urn:") && ((pModifier="above") || (pModifier="below")) {
			$$$ThrowFHIR($$$HSFHIRErrModifierInvalidForURN, paramName, $$$OutcomeInvalid(400))
		}
		if isColl {
			if (pModifier="below") {
				set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE %STARTSWITH ?)) " 
			}
			elseif (pModifier="above") {
				set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") ((? %STARTSWITH %VALUE) AND (%VALUE IS NOT NULL))) " 
			} else {
				set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE=?)) " 
			}
		}
		else {
			if (pModifier="below") {
				set whereClause = whereClause_" "_fieldName_" %STARTSWITH ? " 
			}
			elseif (pModifier="above") {
				set whereClause = whereClause_" ? %STARTSWITH "_fieldName_" AND "_fieldName_" IS NOT NULL " 
			} else {
				set whereClause = whereClause_" "_fieldName_"=? " 
			}

		}
		set pSQLParams($I(pSQLParams)) = tOneSearchVal
	}
	Set whereClause = whereClause_" )"
	Return whereClause
}

}
