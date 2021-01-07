/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Setup.UI.AbstractModel Extends %ZEN.DataModel.ObjectDataModel [ Abstract, System = 4 ]
{

Parameter RESOURCE = "%Ens_ITK:READ";

Parameter EDITRESOURCE = "%Ens_ITK:WRITE";

/// This callback method is invoked when a new instance of DataModel is required.
/// If implemented, it returns a new instance of the data source object
/// used by the DataModel.<br>
/// The default implementation returns the DataModel itself as the source
/// object (this allows for simple DataModel classes that have no actual
/// source object).
Method %OnNewSource(Output pSC As %Status = {$$$OK}) As %RegisteredObject
{
	If '##class(EnsPortal.Utils).CheckResourceList(..#EDITRESOURCE) {
		Set pSC = $$$ERROR($$$InsufficientPrivilegeForOperation)
		Quit $$$NULLOREF
	}
	Quit ..OnNewSource(.pSC)
}

Method OnNewSource(Output pSC As %Status = {$$$OK}) As %RegisteredObject
{
	Set pSC = $$$ERROR($$$NotImplemented)
	Quit $$$NULLOREF
}

/// This callback method is invoked when a DataModel is loaded into memory.
/// If implemented, it loads an instance of the data source object
/// used by the DataModel.<br>
/// The default implementation returns the DataModel itself as the source
/// object (this allows for simple DataModel classes that have no actual
/// source object).
Method %OnOpenSource(pID As %String) As %RegisteredObject
{
	If '##class(EnsPortal.Utils).CheckResourceList(..#RESOURCE) {
		Quit $$$NULLOREF
	}
	Quit ..OnOpenSource(pID)
}

Method OnOpenSource(pID As %String) As %RegisteredObject
{
	Quit $$$NULLOREF
}

/// This callback method is called when the DataModel is saved. If
/// implemented, it is responsible for saving changes to the data source.
Method %OnSaveSource(pSource As %RegisteredObject) As %Status
{
	If '##class(EnsPortal.Utils).CheckResourceList(..#EDITRESOURCE) {
		Quit $$$ERROR($$$InsufficientPrivilegeForOperation)
	}
	Quit ..OnSaveSource(pSource)
}

Method OnSaveSource(pSource As %RegisteredObject) As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

/// This callback method is called when the DataModel is deleted. If
/// implemented, it is responsible for making the appropriate deletes
/// against the data source.
ClassMethod %OnDeleteSource(pID As %String) As %Status
{
	If '##class(EnsPortal.Utils).CheckResourceList(..#EDITRESOURCE) {
		Quit $$$ERROR($$$InsufficientPrivilegeForOperation)
	}
	Quit ..OnDeleteSource(pID)
}

ClassMethod OnDeleteSource(pID As %String) As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

/// This callback method does the actual work of loading values from the source object.
Method %OnLoadModel(pSource As %RegisteredObject) As %Status
{
	If '##class(EnsPortal.Utils).CheckResourceList(..#RESOURCE) {
		Quit $$$ERROR($$$InsufficientPrivilegeForOperation)
	}
	Quit ..OnLoadModel(pSource)
}

Method OnLoadModel(pSource As %RegisteredObject) As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

/// This callback method does the actual work of copying values 
/// from the DataModel to the data source.<br>
/// The default implementation is an expression method.
Method %OnStoreModel(pSource As %RegisteredObject) As %Status
{
	If '##class(EnsPortal.Utils).CheckResourceList(..#RESOURCE) {
		Quit $$$ERROR($$$InsufficientPrivilegeForOperation)
	}
	Quit ..OnStoreModel(pSource)
}

Method OnStoreModel(pSource As %RegisteredObject) As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

}
