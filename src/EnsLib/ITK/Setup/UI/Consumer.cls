/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.Consumer Extends (Ens.Settings, %ZEN.DataModel.Adaptor) [ System = 4 ]
{

Property ConsumerName As %String;

// Property ConsumerServices As list Of EnsLib.ITK.Setup.ConsumerServiceRegistry;

// Value to pass to customer consumerEditor composite component in format "<consumer name>|<number of services>"

/// Number of Services configured for consumption.  Click magnifying glass to edit list.
Property Services As %String;

// Value to pass to customer distRuleEditor composite component in format "<consumer name>|<number of rules>"

/// Number of Distrubution Rules with this Consumer as the target.  Click magnifying glass to edit list.
Property DistributionRules As %String;

Property BusHost As Ens.Config.Item;

Property BusHostStatus As %String [ Calculated ];

Property BusHostId As %String [ Calculated ];

Property VirtualSettings As list Of %String;

Parameter SETTINGS = "ConsumerName:Info:text?readOnly=1,Services:Consumer:consumerEditor,DistributionRules:Consumer:consumerEditor";

/// Return the object populated with name (matching a SystemDefinition)
/// and a list of the ConsumerServiceRegistry objects if defined
ClassMethod %OpenId(pId As %String) As Consumer
{
		
	Set obj = ##class(Consumer).%New()
	Set obj.ConsumerName = pId
	
	&sql(SELECT Count(*) INTO :svcCount FROM EnsLib_ITK_Setup.ConsumerServiceRegistry WHERE ConsumerName = :pId)
	&sql(SELECT Count(*) INTO :distCount FROM EnsLib_ITK_Setup.DistributionRules WHERE TargetComponent = :pId)
	
	Set obj.Services = pId_"|"_svcCount_"|EditConsumers"
	Set obj.DistributionRules = pId_"|"_distCount_"|EditDistributionRules"
		
	Quit obj
}

/// Special version of openId that takes a production id
/// This is needed so we can check id there is a business operation associated
/// with this consumer
ClassMethod OpenWithHost(pId As %String, pProdId As %String) As Consumer
{
	Set obj = ..%OpenId(pId)
	If $IsObject(obj) {
		Set tProd = ##class(Ens.Config.Production).%OpenId(pProdId)
		If $IsObject(tProd) {
			Set tBusOp = tProd.FindItemByConfigName(pProdId_"||"_pId_"|EnsLib.ITK.Framework.Operation.SOAPOperation")
			Set:$IsObject(tBusOp) obj.BusHost = tBusOp
		}
	}
		
	Quit obj
}

/// Populate the VirtualSettings collection.
Method PopulateVirtualSettings() As %Status
{
	do ..VirtualSettings.Clear()
	/*
	set tIndex="" for  {
		set tIndex = ..Settings.Next(tIndex)  quit:tIndex=""
		set tOneSetting = ..Settings.GetAt(tIndex)
		set tAlreadyDefined(tOneSetting.Target,tOneSetting.Name)=tOneSetting.Value
	}*/
	
	set tTarget=$CLASSNAME()
	
	set rs = ##class(%ResultSet).%New()
	set rs.ClassName = tTarget
	set rs.QueryName = "EnumerateSettings"
	if ('rs.QueryIsValid()) Quit $$$OK
	set tSC = rs.Execute()
	while (rs.Next()) {
		set tName = $G(rs.Data("Name"))
		set tDefault = $G(rs.Data("Default"))
		set tDefaultType=$$$eConfigSettingValueTypeProperty
		set tValue=$PROPERTY($this, tName)
		set tValueType=$$$eConfigSettingValueTypeProperty
		
		#; Target,Name,Value,ValueType,Default,DefaultType,Description,Type,MAXLEN,MINVAL,MAXVAL,VALUELIST,DISPLAYLIST,IsRequired,LocalizedName,Category,LocalizedCategory,EditorContext
		set tData = $lb("Core",tName,tValue,tValueType,tDefault,tDefaultType)
		set tData = tData _ $lb($g(rs.Data("Description")))
		set tData = tData _ $lb($g(rs.Data("Type")))
		set tData = tData _ $lb($g(rs.Data("MAXLEN")))
		set tData = tData _ $lb($g(rs.Data("MINVAL")))
		set tData = tData _ $lb($g(rs.Data("MAXVAL")))
		set tData = tData _ $lb($g(rs.Data("VALUELIST")))
		set tData = tData _ $lb($g(rs.Data("DISPLAYLIST")))
		set tData = tData _ $lb($g(rs.Data("IsRequired")))
		set tData = tData _ $lb($g(rs.Data("LocalizedName")))
		set tData = tData _ $lb($g(rs.Data("Category")))
		set tData = tData _ $lb($g(rs.Data("LocalizedCategory")))
		set tData = tData _ $lb($g(rs.Data("EditorContext")))
		do ..VirtualSettings.Insert(tData)
	}
	
	If $IsObject(..BusHost) {
		Do ..BusHost.GetStaticSettings(.tStatic)
		Set key = $O(tStatic(""),1,setting)
		While key '= "" {
			Do ..VirtualSettings.Insert(setting)
			Set key = $O(tStatic(key),1,setting)
		}		
		Do ..BusHost.PopulateVirtualSettings()
		For i=1:1:..BusHost.VirtualSettings.Count() {
			Do ..VirtualSettings.Insert(..BusHost.VirtualSettings.GetAt(i))
		}
	}
	
	quit $$$OK
}

Method BusHostStatusGet() As %String
{
	If $IsObject(..BusHost) {
		If ..BusHost.Enabled {
			Quit "ok"
		} else {
			Quit "disabled"
		}
	}
	
	Quit ""
}

Method BusHostIdGet() As %String
{
	If $IsObject(..BusHost) {
		Quit ..BusHost.%Id()
	}
	
	Quit ""
}

Query GetConsumerServicesByConsumerName(pName As %String) As %SQLQuery(CONTAINID = 1)
{
	  SELECT %ID FROM EnsLib_ITK_Setup.ConsumerServiceRegistry
	  WHERE ConsumerName = :pName
}

Query GetAll() As %SQLQuery
{
	SELECT ApplicationName as ID FROM EnsLib_ITK_Setup.SystemDefinition
}

}
