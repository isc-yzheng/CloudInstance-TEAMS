Include (HS.FHIRServer, HS.FHIRServer.Util.SearchResult)

Class HS.FHIRServer.Util.SearchResult Extends HS.Util.TransientTable
{

Parameter GlobalName As %String = "^IRIS.Temp.FHIRServerSearchResult";

Property IsDeleted As %Boolean [ Calculated ];

Property Key As %String [ Calculated ];

Property ResourceType As %String [ Calculated ];

Property ResourceId As %String [ Calculated ];

Property VersionId As %String [ Calculated ];

Property Mode As %String [ Calculated ];

Property Verb As %String [ Calculated ];

Property ResourceString As %String [ Calculated ];

Property ReferredToBy As %List [ Calculated ];

Property ResourceJson As %DynamicObject [ Calculated ];

Property PageSize As %Integer [ Calculated ];

Property QueryId As %String [ Calculated ];

Property MatchCount As %Integer [ Calculated ];

Property TotalUndeleted As %Integer [ Calculated ];

Property %PageSize As %Integer [ Private ];

Property %QueryId As %String [ Private ];

Property TimeIndex As %Integer [ Private ];

Property %MatchCount As %Integer [ Private ];

Property %TotalUndeleted As %Integer [ Private ];

Property PageStarts [ MultiDimensional, Private ];

ClassMethod Create(pPageSize As %Integer = 0) As HS.FHIRServer.Util.SearchResult
{
	Set result = ..%New()
	Do result.Init(pPageSize)
	return result
}

Method Init(pPageSize As %Integer)
{
	// Create the columns for this Result Set and verify that the column
	// numbers match the expected ones.  DEVNOTE: If the column number
	// macros change, we should also change the GlobalName parameter.
	$$$SearchResultAddCol("Deleted", $$$SearchResultColDeleted)
	$$$SearchResultAddCol("Key", $$$SearchResultColKey)
	$$$SearchResultAddCol("ResourceType", $$$SearchResultColResourceType)
	$$$SearchResultAddCol("ResourceId", $$$SearchResultColResourceId)
	$$$SearchResultAddCol("VersionId", $$$SearchResultColVersionId)
	$$$SearchResultAddCol("Mode", $$$SearchResultColMode)
	$$$SearchResultAddCol("Verb", $$$SearchResultColVerb)
	$$$SearchResultAddCol("ResourceString", $$$SearchResultColJson)
	$$$SearchResultAddCol("ReferredToBy", $$$SearchResultColReferredToBy)

	Set ..%QueryId = $ZConvert($system.Util.CreateGUID(), "L")
	Set ..%PageSize = +pPageSize
	Set ..PageStarts = 0
	
	return $$$OK
}

Method Reinit(pQueryId As %String)
{
	Set ..%QueryId = pQueryId
	Set ..TimeIndex = @..#GlobalName@("ByKey", pQueryId)
	Set ..%PageSize = @..#GlobalName@("ByTime", ..TimeIndex, "pagesize")
	Set ..%MatchCount = @..#GlobalName@("ByTime", ..TimeIndex, "matches")
	Set ..%TotalUndeleted = @..#GlobalName@("ByTime", ..TimeIndex, "total")
	Set ..PageStarts = 0
	Merge ..PageStarts = @..#GlobalName@("ByTime", ..TimeIndex, "pageStarts")
}

ClassMethod Restore(pQueryId As %String) As HS.FHIRServer.Util.SearchResult
{
	Set result = ..%RestoreFrom(..#GlobalName, pQueryId)
	
	Do result.Reinit(pQueryId)
	return result
}

ClassMethod Discard(key As %String)
{
	Set timeIndex =  $G(@..#GlobalName@("ByKey", key))
	if timeIndex '= "" {
		kill @..#GlobalName@(timeIndex)
		kill @..#GlobalName@(key)
	}
}

Method Save() As %String
{
	Do ..%SaveTo(..#GlobalName, ..%QueryId)
	
	if ..TimeIndex '= "" {
		kill @..#GlobalName@("ByTime", ..TimeIndex)
	}
		
	Set timevalue = $Horolog
	Set ..TimeIndex = $I(@..#GlobalName@("ByTime"))
	Set @..#GlobalName@("ByKey", ..%QueryId) = ..TimeIndex
	Set @..#GlobalName@("ByTime", ..TimeIndex, "pagesize") = ..%PageSize
	Set @..#GlobalName@("ByTime", ..TimeIndex, "id") = ..%QueryId
	Set @..#GlobalName@("ByTime", ..TimeIndex, "display") = $ZDateTime(timevalue,3)
	Set @..#GlobalName@("ByTime", ..TimeIndex, "matches") = ..%MatchCount
	Set @..#GlobalName@("ByTime", ..TimeIndex, "total") = ..%TotalUndeleted
	Kill @..#GlobalName@("ByTime", ..TimeIndex, "pageStarts")
	Merge @..#GlobalName@("ByTime", ..TimeIndex, "pageStarts") = ..PageStarts
	//zw @..#GlobalName@("ByTime", ..TimeIndex, "pageStarts")
	
	return ..%QueryId
}

Method SetIteratorToPage(pageNum As %Integer)
{
	set iter = 0
	if pageNum > 0 {
		if pageNum > ..PageStarts {
			Set iter = ..%ROWCOUNT
		} else {
			set iter = ..PageStarts(pageNum) - 1
		}
	}
	Do ..%SetIterator(iter)
}

Method NextUndeleted() As %Boolean
{
	while ..%Next() 
	{
		if ' ..IsDeletedGet() {
			return 1
		}
	}
	return 0
}

Method Paginate(pPageSize As %Integer = "") As %Integer
{
	kill ..PageStarts
	Set ..PageStarts = 0
	
	// Treat PageSize = 0 as "force one page"
	Set pageSize = $Select(pPageSize="":..%PageSize, 1:pPageSize)
	Set ..%PageSize = pageSize
	if pageSize <= 0 {
		Set pageSize = 999999999
	}
	
	Set matchCount = 0
	Set total = 0
	Do ..%SetIterator(0)
	Set found = pageSize-1
	//w !, "begin paginate for size: ",pageSize,!
	while ..NextUndeleted() {
		Set total = total + 1
		//w "row: ", total, " at ", ..%currentRow,", key is ",..Key,",d: ",..IsDeleted, !
		if ..Mode = "match" {
			Set matchCount = matchCount + 1
		}
		Set found = found + 1
		if found = pageSize {
			//w "found start at: ",..%currentRow,!
			// This is the first row of a new page
			Set ..PageStarts($I(..PageStarts)) = ..%currentRow
			Set found = 0
		}
	}
	Set ..%TotalUndeleted = total
	Set ..%MatchCount = matchCount
	Do ..%SetIterator(0)
	return ..PageStarts
}

Method AddRow(key, pResourceType, pResourceId, pVersionId, pMode, pVerb = "", pJson = "", pReferredToBy = "") As %Integer
{
	Set curRow = ..%NewRow()
	Do ..%SetData($$$SearchResultColDeleted, "")
	Do ..%SetData($$$SearchResultColKey, key)
	Do ..%SetData($$$SearchResultColResourceType, pResourceType)
	Do ..%SetData($$$SearchResultColResourceId, pResourceId)
	Do ..%SetData($$$SearchResultColVersionId, pVersionId)
	Do ..%SetData($$$SearchResultColMode, pMode)
	Do ..%SetData($$$SearchResultColVerb, pVerb)
	Do ..%SetData($$$SearchResultColReferredToBy, pReferredToBy)
	if $IsObject(pJson) && pJson.%Extends("%DynamicObject") {
		Do ..%SetData($$$SearchResultColJson, pJson.%ToJSON())
	} else {
		Do ..%SetData($$$SearchResultColJson, pJson)
	}
	$$$ThrowOnError( ..%SaveRow() )
	return curRow
}

Method MarkAsDeleted()
{
	Do ..%SetData($$$SearchResultColDeleted, 1)
}

Method IsDeletedGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColDeleted)
}

Method KeyGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColKey)
}

Method ResourceTypeGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColResourceType)
}

Method ResourceIdGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColResourceId)
}

Method VersionIdGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColVersionId)
}

Method ModeGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColMode)
}

Method VerbGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColVerb)
}

Method ResourceStringGet() As %String [ CodeMode = expression ]
{
..%GetData($$$SearchResultColJson)
}

Method ReferredToByGet() As %List [ CodeMode = expression ]
{
..%GetData($$$SearchResultColReferredToBy)
}

Method SetReferredToBy(idList As %List)
{
	Do ..%SetData($$$SearchResultColReferredToBy, idList)

	$$$ThrowOnError( ..%SaveRow() )
}

Method ResourceJsonGet() As %DynamicObject
{
	Set string = ..%GetData($$$SearchResultColJson)
	if string '= "" {
		return ##class(%DynamicObject).%FromJSON(string)
	}
	return ""
}

Method PageSizeGet() [ CodeMode = expression ]
{
..%PageSize
}

Method QueryIdGet() [ CodeMode = expression ]
{
..%QueryId
}

Method MatchCountGet() [ CodeMode = expression ]
{
..%MatchCount
}

Method TotalUndeletedGet() [ CodeMode = expression ]
{
..%TotalUndeleted
}

}
