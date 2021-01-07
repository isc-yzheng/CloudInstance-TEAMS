Include HS.FHIRServer

Class HS.FHIRServer.Config.FHIRLogHandler Extends %CSP.REST
{

Parameter MaxRows = 20000;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/data/:from" Method="GET" Call="GetDataRequest" />
<Route Url="/data" Method="DELETE" Call="ClearDataRequest" />

</Routes>
}

ClassMethod GetDataRequest(from As %String) As %Status
{
    #dim %request as %CSP.Request
    #dim %response as %CSP.Response

	
	Set afterRow = +$Piece(from, "|", 1)
	Set since = $Piece(from, "|", 2)
	if (since = "") || (since '= ..GetLastClear()) {
		set afterRow = 0
	}
   	#dim result as %DynamicObject = ..GetLogData(afterRow)
    write result.%ToJSON()
	Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Status = 200
    
    return $$$OK
}

ClassMethod ClearDataRequest() As %Status
{
    Do ..ClearLog()
    
	Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Status = 200
    Set nextKey = "0|" _ ..GetLastClear()
    w { "nextKey": (nextKey) }.%ToJSON()

    return $$$OK
}

/*
 --------------- Implementation of the service.  Could be factored into a separate class -------
*/
ClassMethod GetLogCount() As %Integer
{
	return $Get($$$FSLogGlobal, 0)
}

ClassMethod GetLogData(ByRef fromIndex As %Integer, toIndex As %Integer = 999999999) As %DynamicObject
{
	Set lastIndex = toIndex
	Set count = ..GetLogCount()
	if lastIndex > count {
		Set lastIndex = count
	}

	Set result = $$$NewJSONObject
	Set rows = $$$NewJSONArray
	Set result.rows = rows
	Set result.nextKey = lastIndex _ "|" _ ..GetLastClear()
	
	//w fromIndex, " to ",lastIndex,!
	
	if fromIndex < lastIndex {
		Set result.firstRow = fromIndex + 1
		Set rowIndex = fromIndex
		while $I(rowIndex) <= lastIndex {
			do rows.%Push( $Get($$$FSLogGlobal(rowIndex)) )
		}
	}
	return result
}

ClassMethod GetLastClear() As %String [ CodeMode = expression ]
{
$Get($$$FSLogGlobal("since"))
}

ClassMethod ClearLog()
{
	kill $$$FSLogGlobal
	Set lastClear = $ZDT($H,3,7)
	Set $$$FSLogGlobal("since") = lastClear
}

}
