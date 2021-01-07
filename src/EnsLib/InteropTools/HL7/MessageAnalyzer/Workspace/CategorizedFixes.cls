/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.CategorizedFixes Extends %RegisteredObject
{

/// Fixes=COUNT
/// Fixes(STATUS)=COUNT
/// Fixes(STATUS,CATEGORY)=COUNT
/// Fixes(STATUS,CATEGORY,SUBCATEGORY)=COUNT
/// Fixes(STATUS,CATEGORY,SUBCATEGORY,OPERATIONKEY)=INSTANCE
/// <p> STATUS is one of "pending", "ignored" or "tofix"
/// <p> CATEGORY is one of "CT", "DT" or "SS"
/// <p> SUBCATEGORY is the name of a particular code table, data structure or segment structure
/// <p> OPERATIONKEY is the operation key associated with the instance
/// <p> INSTANCE is an instance of SegmentValidationBase
Property Fixes As SegmentValidationBase [ MultiDimensional, Private ];

Method %OnNew(ByRef pInstances) As %Status
{
	Do ..CategorizeInstances(.pInstances)
	Quit $$$OK
}

/// For the total count: pass no arguments; for a count of items with a particular status: pass just pStatus; and so on.
Method Count(pStatus As %String, pCategory As %String, pSubCategory As %String) As %Integer
{
	If '$Data(pStatus) {Quit $Get(..Fixes,0)}
	If '$Data(pCategory) {Quit $Get(..Fixes(pStatus),0)}
	If '$Data(pSubCategory) {Quit $Get(..Fixes(pStatus,pCategory),0)}
	Quit $Get(..Fixes(pStatus,pCategory,pSubCategory),0)
}

/// For the status keys: pass no arguments; for the categories for a particular status: pass just pStatus; and so on.
Method Keys(pStatus As %String, pCategory As %String, pSubCategory As %String) As %List
{
	If '$Data(pStatus) {Quit $$statuskeys}
	If '$Data(pCategory) {Quit $$categorykeys}
	If '$Data(pSubCategory) {Quit $$subcategorykeys}
	Quit $$operationkeys
	
statuskeys()		Set out="" Set key="" While 1 {Set key=$Order(..Fixes(key)) If key="" {Quit} Set out=out_$ListBuild(key)} Quit out 
categorykeys()	Set out="" Set key="" While 1 {Set key=$Order(..Fixes(pStatus,key)) If key="" {Quit} Set out=out_$ListBuild(key)} Quit out 
subcategorykeys()	Set out="" Set key="" While 1 {Set key=$Order(..Fixes(pStatus,pCategory,key)) If key="" {Quit} Set out=out_$ListBuild(key)} Quit out 
operationkeys()	Set out="" Set key="" While 1 {Set key=$Order(..Fixes(pStatus,pCategory,pSubCategory,key)) If key="" {Quit} Set out=out_$ListBuild(key)} Quit out
}

Method Instance(pStatus As %String, pCategory As %String, pSubCategory As %String, pOperationKey As %String) As SegmentValidationBase [ CodeMode = expression ]
{
..Fixes(pStatus,pCategory,pSubCategory,pOperationKey)
}

Method GetStatusInstances(pStatus As %String, Output tSomeInstances)
{
	$$$SHOULDBEUNDEF(tSomeInstances)
	
	Set tCategory="" While 1 {
		Set tCategory=$Order(..Fixes(pStatus,tCategory)) If tCategory="" {Quit}
		Set tSubCategory="" While 1 {
			Set tSubCategory=$Order(..Fixes(pStatus,tCategory,tSubCategory)) If tSubCategory="" {Quit}
			Set tOperationKey="" While 1 {
				Set tOperationKey=$Order(..Fixes(pStatus,tCategory,tSubCategory,tOperationKey),+1,tInstance) If tOperationKey="" {Quit}
				Set tSomeInstances($I(tSomeInstances))=tInstance
			}
		}
	}
}

Method QueueForFix(pCategory As %String, pSubCategory As %String, pOperationKey As %String)
{
	If '$Data(..Fixes("pending",pCategory,pSubCategory,pOperationKey)) {ZTrap}
	
	// instance record
	Set ..Fixes("tofix",pCategory,pSubCategory,pOperationKey)=..Fixes("pending",pCategory,pSubCategory,pOperationKey)
	Kill ..Fixes("pending",pCategory,pSubCategory,pOperationKey)
	
	// subcategory count
	If $I(..Fixes("tofix",pCategory,pSubCategory))
	If '$I(..Fixes("pending",pCategory,pSubCategory),-1) {
		Kill ..Fixes("pending",pCategory,pSubCategory)
	}
	
	// category count
	If $I(..Fixes("tofix",pCategory))
	If '$I(..Fixes("pending",pCategory),-1) {
		Kill ..Fixes("pending",pCategory)
	}

	// status count
	If $I(..Fixes("tofix"))
	If '$I(..Fixes("pending"),-1) {
		Kill ..Fixes("pending")
	}
}

Method CategorizeInstances(ByRef pInstances) [ Private ]
{
	Set tOperationKey="" While 1 {
		Set tOperationKey=$Order(pInstances(tOperationKey),+1,tOneInstance) If tOperationKey="" {Quit}
		Set $ListBuild(tCategory,tSubCategory)=tOneInstance.GetFixTarget()
		If $I(..Fixes)
		If $I(..Fixes("pending"))
		If $I(..Fixes("pending",tCategory))
		If $I(..Fixes("pending",tCategory,tSubCategory))
		Set ..Fixes("pending",tCategory,tSubCategory,tOperationKey)=tOneInstance
	}
}

}
