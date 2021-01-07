Include Ensemble

/// Ensemble-specific version of context search methods.
Class HS.Util.ContextSearch Extends %ZEN.Portal.ContextSearch
{

ClassMethod DeviceOIDs(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tStatus = $$$OK
	Kill pResults, pTopResults
	Set pCaption = "",N=0
	
		// Get distinct values
		&sql(DECLARE sqlDevices1 CURSOR FOR
				select oidmap->identitycode into :Code
				FROM HS_Data.OIDMap_identitytypes where identitytypes='Device'
		   		ORDER BY IdentityCode
		)
		&sql(OPEN sqlDevices1)
		Quit:(SQLCODE '= 0)
		For {
			&sql(FETCH sqlDevices1)
			Quit:(SQLCODE '= 0)
			Set tResults(Code) = ""
			Set N = N+1, pResults(N) = Code
		}
		&sql(CLOSE sqlDevices1)
	Quit tStatus
}

ClassMethod ServiceNameItems(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tStatus = $$$OK
	Kill pResults, pTopResults
	Set pCaption = "",N=0
	
		// Get distinct values
		&sql(DECLARE sqlName1 CURSOR FOR
		     SELECT Name
		     INTO :Name
		     FROM HS_Registry_Service.SOAP
		     Where not(name LIKE 'SYNC.%')
		     order by Name
		)
		&sql(OPEN sqlName1)
		Quit:(SQLCODE '= 0)
		For {
			&sql(FETCH sqlName1)
			Quit:(SQLCODE '= 0)
			Set tResults(Name) = ""
			Set N = N+1, pResults(N) = Name
		}
		&sql(CLOSE sqlName1)
	Quit tStatus
}

/// ServiceNameItemsByParam allows the selection of all services or a subset based on various service property values.
/// Currently it supports parameter values for Type and DeviceFunction.
/// <br>
/// <br>To select all services, include this string in your SETTINGS parameter:
/// <br>ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam}
/// <br>
/// <br>Other examples:
/// <br>
/// <br>To select one service type, include the Type parameter, for example:
/// <br>ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=TCP}
/// <br>
/// <br>To select multiple service types, the Type value is a vertical bar-delimited string, for example:
/// <br>ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=SOAP|HTTP}
ClassMethod ServiceNameItemsByParam(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tStatus = $$$OK

	Kill pResults, pTopResults
	Set pCaption = ""
	
	Try {
		Set N = 0
		Set tParams = 0
		
		Set tParamName = ""
		Set tParamStr = ""
		For {
			Set tParamName = $Order(pParms(tParamName))
			If tParamName="" Quit
			If '##class(HS.Util.SQLUtils).IsValidField("HS_Registry_Service.Abstract",tParamName){
				Continue
			}
			
			For jj = 1:1:$Length(pParms(tParamName),"|") {
				Set tX = $Piece($Get(pParms(tParamName)),"|",jj)
				If tX="" Quit
				If jj=1 Set tParamStr = " AND "_tParamName_" IN("
				If jj>1 Set tParamStr = tParamStr_","
				Set tParamStr = tParamStr_"?"
				If jj=$Length(pParms(tParamName),"|") Set tParamStr = tParamStr_")"
				If $i(tParams) Set tParams(tParams)=tX
			}
		}
		
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%SelectMode=0
		Set tQuery = "SELECT Name FROM HS_Registry_Service.Abstract WHERE not(Name LIKE 'SYNC.%')"_tParamStr_" ORDER BY Name"
		Set tStatus = tStatement.%Prepare(tQuery)
		If tParams=0 Set tResultSet = tStatement.%Execute()
		If tParams=1 Set tResultSet = tStatement.%Execute(tParams(1))
		If tParams=2 Set tResultSet = tStatement.%Execute(tParams(1),tParams(2))
		If tParams=3 Set tResultSet = tStatement.%Execute(tParams(1),tParams(2),tParams(3))
		If tParams=4 Set tResultSet = tStatement.%Execute(tParams(1),tParams(2),tParams(3),tParams(4))
		If tParams=5 Set tResultSet = tStatement.%Execute(tParams(1),tParams(2),tParams(3),tParams(4),tParams(5))
		If tParams=6 Set tResultSet = tStatement.%Execute(tParams(1),tParams(2),tParams(3),tParams(4),tParams(5),tParams(6))
		While tResultSet.%Next() {
			If $i(N) Set pResults(N) = tResultSet.Name
		}
	} Catch eException {
		Kill pResults
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

/// Same as %ZEN.Portal.ContextSearch:Classes, but includes the super if specified
ClassMethod Classes(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = ##super(.pCaption,.pTopResults,.pResults,.pParms,pSearchKey)
	If $$$ISERR(tSC) Quit tSC
	Set tSuper = $G(pParms("super"))
	If tSuper]"" {
		Set n = $O(pResults(""),-1)
		Set n = n+1
		Set pResults(n) = tSuper
	}
	Quit $$$OK
}

ClassMethod TraceValues(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Kill pResults, pTopResults
	Set pResults(1)=""
	Set pResults(2)="*ERRORSONLY*"
	Set pResults(3)="*MINIMAL*"
	Set pResults(4)="*FULL*"
	Quit $$$OK
}

}
