/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Class to represent all of the sender registry entries between an App and a business service
Class EnsLib.ITK.Setup.UI.Sender Extends (Ens.Settings, %ZEN.DataModel.Adaptor) [ System = 4 ]
{

Property SourceAppName As %String;

Property BusinessServiceName As %String;

Property Senders As %String [ MultiDimensional ];

Property SenderList As %String;

Property VirtualSettings As list Of %String;

Parameter SETTINGS = "SourceAppName,BusinessServiceName,SenderList:Basic:selector?multiSelect=1&context={ITK.Setup.UI.ContextSearch/ServiceDefinitions}";

///  Even though this is not a persistent object - it wraps
///  real persistent objects, so we expose an interface like it
/// pId is id of one SenderRegistry entry that we use to 
/// get all with same source app and bus service
ClassMethod %OpenId(pId As %String, Output pSC) As Sender
{
		If $G(pId)="" Quit $$$ERROR($$$EnsErrGeneral, "Invalid id")
		Set tSR = ##class(EnsLib.ITK.Setup.SenderRegistry).%OpenId(pId,.pSC)
		Quit:$$$ISERR(pSC) pSC
		
		Set tSender = ##class(Sender).%New()
		
		Set tSender.SourceAppName = tSR.SourceAppName
		Set tSender.BusinessServiceName = tSR.BusinessServiceName
		
		// Now run the sender registry query to get all with same App + BS
		Set tRS = ##class(%ResultSet).%New("EnsLib.ITK.Setup.SenderRegistry:QuerySenderRegistry")
		Set pSC = tRS.Execute(tSR.SourceAppName, tSR.BusinessServiceName)
		
		Quit:$$$ISERR(pSC) pSC
		
		Set Sync = 0, Async = 0
		While tRS.Next(.pSC) {
			Quit:$$$ISERR(pSC)
			
			Set tSender.Senders(tRS.Data("WebServiceName")) = $LB(tRS.Data("ID"),tRS.Data("InvocationPattern"),tRS.Data("ValidatePayload"))
			If tRS.Data("InvocationPattern")="Synchronous" {
				Set Sync = Sync + 1
			} elseif tRS.Data("InvocationPattern")="Asynchronous" {
				Set Async = Async + 1	
			}
		}
		
		Set tSender.Senders = Sync_" Synchronous service(s) and "_Async_" Asynchronous service(s)"
		
		Quit tSender
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
	quit $$$OK
}

}
