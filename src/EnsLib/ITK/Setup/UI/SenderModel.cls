/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.SenderModel Extends EnsLib.ITK.Setup.UI.AbstractModel [ System = 4 ]
{

Property SourceAppName As %String(ZENCONTROL = "hidden");

Property BusinessServiceName As %String(ZENCONTROL = "hidden");

Property WebServiceName As %String(ZENCONTROL = "hidden");

Property InvocationPattern As %String(VALUELIST = ",Asynchronous,Synchronous,Derived", ZENATTRS = "id:invocationRadio", ZENCONTROL = "radioSet") [ Required ];

Property ValidatePayload As %Boolean(ZENCONTROL = "checkbox");

/// This callback method is invoked when a new instance of DataModel is required.
/// If implemented, it returns a new instance of the data source object
/// used by the DataModel.<br>
/// The default implementation returns the DataModel itself as the source
/// object (this allows for simple DataModel classes that have no actual
/// source object).
Method OnNewSource(Output pSC As %Status = {$$$OK}) As %RegisteredObject
{
	Quit ##class(EnsLib.ITK.Setup.SenderRegistry).%New()
}

/// This callback method is invoked when a DataModel is loaded into memory.
/// If implemented, it loads an instance of the data source object
/// used by the DataModel.<br>
/// The default implementation returns the DataModel itself as the source
/// object (this allows for simple DataModel classes that have no actual
/// source object).
Method OnOpenSource(pID As %String) As %RegisteredObject
{
	Quit ##class(EnsLib.ITK.Setup.SenderRegistry).%OpenId(pID)
}

/// This callback method is called when the DataModel is saved. If
/// implemented, it is responsible for saving changes to the data source.
Method OnSaveSource(pSource As %RegisteredObject) As %Status
{
	Set tSC = pSource.%Save()
    Set ..%id = pSource.%Id()
    Quit tSC
}

/// This callback method is called when the DataModel is deleted. If
/// implemented, it is responsible for making the appropriate deletes
/// against the data source.
ClassMethod OnDeleteSource(pID As %String) As %Status
{
	Quit ##class(EnsLib.ITK.Setup.SenderRegistry).%DeleteId(pID)
}

/// This callback method does the actual work of loading values from the source object.
Method OnLoadModel(pSource As EnsLib.ITK.Setup.SenderRegistry) As %Status
{
	Set ..SourceAppName = pSource.SourceAppName
	Set ..BusinessServiceName = pSource.BusinessServiceName
	Set ..WebServiceName = pSource.WebServiceName
	Set ..InvocationPattern = pSource.InvocationPattern
	Set ..ValidatePayload = pSource.ValidatePayload
	
	Quit $$$OK
}

/// This callback method does the actual work of copying values 
/// from the DataModel to the data source.<br>
/// The default implementation is an expression method.
Method OnStoreModel(pSource As EnsLib.ITK.Setup.SenderRegistry) As %Status
{
	Set pSource.SourceAppName = ..SourceAppName
	Set pSource.BusinessServiceName = ..BusinessServiceName
	Set pSource.WebServiceName = ..WebServiceName
	Set pSource.InvocationPattern = ..InvocationPattern
	Set pSource.ValidatePayload = ..ValidatePayload
	
	Quit pSource.%Save()
}

}
