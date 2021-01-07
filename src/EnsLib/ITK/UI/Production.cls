/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.UI.Production Extends Ens.Config.Production [ System = 4 ]
{

Parameter XMLTYPE = "ITKProduction";

Query ITKProductionStatus() As %Query(ROWSPEC = "Production:%String,Status:%String,LastStartTime:%String,LastStopTime:%String,StatusEnum:%String,ITKState:%String")
{
}

ClassMethod ITKProductionStatusExecute(ByRef qHandle As %Binary) As %Status
{
	Set tIndex=$increment(^IRIS.Temp)
	Set tSC = ##class(Ens.Director).GetProductionStatus(.tProductionName,.tState) Quit:$$$ISERR(tSC)
	Set tRS=##class(%ResultSet).%New("Ens.Config.Production:Extent")
	Set tSC=tRS.Execute()
	For {
		Quit:tRS.Next()=0
		Set tThisProduction = tRS.GetData(1)
		
		set tRSItems=##class(%ResultSet).%New("Ens.Config.Production:EnumerateConfigItems")
		Set tSC=tRSItems.Execute(tThisProduction,$$$eHostTypeProcess)
		For {
			Quit:tRSItems.Next()=0
			set tClassName = tRSItems.GetDataByName("ClassName")
			
			if (tClassName="EnsLib.ITK.Framework.Process.ITKMessageRouter")
			{
				Set ^IRIS.Temp(tIndex,tThisProduction)=$s(tThisProduction=tProductionName:tState,1:$$$eProductionStateStopped)
				Quit		
			}
		}
		
	}
	Set qHandle=$lb(tIndex,"")
	Quit $$$OK
}

ClassMethod ITKProductionStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProductionStatusExecute ]
{
	Set index=$list(qHandle,1)
	Set class=$list(qHandle,2)
	Set class=$order(^IRIS.Temp(index,class))
	If class="" {
		Set Row="",AtEnd=1
	} Else {
		do ..GetITKMissingItems(class,.items)
		
		Set display=##class(Ens.Config.Production).ProductionStateToText(^IRIS.Temp(index,class))
		
		set state = $S(items.Count()=0:"Complete",1:"Incomplete")
		Set Row=$lb(class,display,$$$timeUTCtoLocal($get(^Ens.Configuration("csp","Activity",class,"started"))),$$$timeUTCtoLocal($get(^Ens.Configuration("csp","Activity",class,"stopped"))),^IRIS.Temp(index,class),state),AtEnd=$order(^IRIS.Temp(index,class))=""
	}
	Set qHandle=$lb(index,class)
	Quit $$$OK
}

ClassMethod ProductionStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProductionStatusExecute ]
{
	Set index=$list(qHandle,1)
	Kill ^IRIS.Temp(index)
	Set qHandle=""
	Quit $$$OK
}

ClassMethod GetITKMissingItems(production As %String, ByRef items As %ArrayOfDataTypes)
{
	set items = ##class(%ArrayOfDataTypes).%New()
	
	set tRs=##class(%ResultSet).%New()
	set tSC=tRs.Prepare("select distinct %EXACT BusinessServiceName from EnsLib_ITK_Setup.SenderRegistry")
	set tSC=tRs.Execute()
	For
	{
		Quit:tRs.Next()=0
		do items.SetAt("EnsLib.ITK.Framework.Service.SOAPRequestHandler",tRs.GetData(1))
	}
	set subscribers = ##class(EnsLib.ITK.Setup.SubscriptionRules).GetAllSubscribers()
	For i=1:1:$L(subscribers,",") 
	{ 
		Set tOne=$ZStrip($P(subscribers,",",i),"<>W")   
		continue:tOne=""
		set approuter=""
		set app = ##class(EnsLib.ITK.Setup.SystemDefinition).%OpenId(tOne)
		Set:$IsObject(app) approuter = app.ApplicationRouter
		
		do items.SetAt($S(approuter="":"EnsLib.ITK.Framework.Operation.SOAPOperation",1:"EnsLib.MsgRouter.RoutingEngine"),$S(approuter="":tOne,1:approuter))
	}
	
	// Distribution Rules
	Set rs= ##class(%ResultSet).%New("EnsLib.ITK.Setup.DistributionRules:DistributionTargets")
	do rs.Execute()
	while rs.Next()
	{
		do items.SetAt("EnsLib.ITK.Framework.Operation.SOAPOperation",rs.GetData(1))
	}
	set tRSItems=##class(%ResultSet).%New("Ens.Config.Production:EnumerateConfigItems")
	Set tSC=tRSItems.Execute(production)
	For 
	{
			Quit:tRSItems.Next()=0
			set tConfigItem = tRSItems.GetDataByName("ConfigName")
			do items.RemoveAt(tConfigItem)
	}
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
