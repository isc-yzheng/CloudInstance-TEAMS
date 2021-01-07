/// Utility class to build properly-encoded URLs
Class HSMOD.REST.URLBuilder Extends %RegisteredObject
{

Property Path As %String(MAXLEN = "");

Property QueryParams [ MultiDimensional, Private ];

Method %OnNew(pPath As %String, ByRef pParams) As %Status [ Private, ServerOnly = 1 ]
{
	Set ..Path = $Get(pPath)
	Merge ..QueryParams = pParams
	Quit $$$OK
}

Method AppendPath(pPath As %String) As HSMOD.REST.URLBuilder
{
	Set ..Path = ..Path _ $Case($Extract(..Path,*),"/":"",:"/") _ $ZConvert(pPath,"O","URL")
	Quit $This //To support chaining
}

Method AddParameter(pName As %String, pValue As %String = "") As HSMOD.REST.URLBuilder
{
	Set ..QueryParams(pName) = pValue
	Quit $This //To support chaining
}

Method ToString() As %String
{
	Set tQueryParamList = ""
	Set tKey = ""
	For {
		Set tKey = $Order(..QueryParams(tKey),1,tValue)
		If (tKey = "") {
			Quit
		}
		Set tVal = $ZConvert(tKey,"O","URL") _ $Case(tValue,"":"",:"=") _ $ZConvert(tValue,"O","URL")
		Set tQueryParamList = tQueryParamList_$ListBuild(tVal)
	}
	Quit ..Path _ $Case(tQueryParamList,"":"",:"?" _ $ListToString(tQueryParamList,"&"))
}

}
