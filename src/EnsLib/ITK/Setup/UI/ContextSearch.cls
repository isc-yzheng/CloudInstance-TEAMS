/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class EnsLib.ITK.Setup.UI.ContextSearch Extends %ZEN.Portal.ContextSearch [ System = 4 ]
{

ClassMethod ServiceDefinitions(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Set tStatus = $$$OK
	Kill pResults, pTopResults
	Set pCaption = ""

	Set tProduction = $get(pParms("productionName"))
	Set tType = $select($get(pParms("targets")): -$$$eHostTypeService, 1: "")
	Set tRS = ##class(%ResultSet).%New("EnsLib.ITK.Setup.ServiceDefinition:GetServiceList")
	Set tStatus = tRS.%Execute()
	If $$$ISERR(tStatus) Quit tStatus

	While tRS.%Next(.tStatus) {
		Set pResults($i(pResults)) = tRS.%Get("ServiceName")
	}
	Quit tStatus
}

}
