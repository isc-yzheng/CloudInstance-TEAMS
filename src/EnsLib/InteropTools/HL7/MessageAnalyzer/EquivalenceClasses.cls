/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Implementation of equivalence classes
/// <br> Groups are merged if there is an equivalence between ANY pair of elements taken from the two groups
Class EnsLib.InteropTools.HL7.MessageAnalyzer.EquivalenceClasses Extends %RegisteredObject [ Abstract ]
{

/// Groups(GROUPID,ITEMID)=""
Property Groups As %String [ MultiDimensional, Private ];

/// NotEquivalentCache(ITEMID1,ITEMID2)=""
/// <p> Each entry has ITEMID1 collating before ITEMID2
Property NotEquivalentCache As %String [ MultiDimensional, Private ];

/// Subclass responsibility: given two items, return whether they are considered equivalent
Method Equivalent(pItem1 As %String, pItem2 As %String) As %Boolean [ Abstract ]
{
}

/// Add a new item to the appropriate group, or to a new group if there is no existing group to which the item should belong
Method AddItem(pNewItem As %String)
{
	
	// look for an existing group for the new item
	Set tGroup=..GroupFor(pNewItem)
	
	// no existing group ..
	If tGroup="" {
		Set ..Groups(pNewItem,pNewItem)="" // the new group has the item's name
		
		// PATCHED
		//Write pNewItem," ~ ",pNewItem,!
	}
	
	// .. an existing group ..
	Else {
		Set ..Groups(tGroup,pNewItem)=""
		
		// PATCHED
		//Write tGroup," ~ ",pNewItem,!
	}
	
	// PATCHED
	//Do ..Dump()
}

/// Set pGroups(GROUPID,ITEMID)=""
Method GetGroups(Output pGroups)
{
	$$$SHOULDBEUNDEF(pGroups)
	
	Merge pGroups=..Groups
}

/// Dump this structure (for debugging)
Method Dump()
{
	Set tGroup="" While 1 {
		Set tGroup=$Order(..Groups(tGroup)) If tGroup="" {Quit}
		Write "Group ",tGroup,":"
		Set tItem="" While 1 {
			Set tItem=$Order(..Groups(tGroup,tItem)) If tItem="" {Quit}
			Write " ",tItem
		}
		Write !
	}
}

/// Return the group to which the given item belongs, or "" if there is none
Method GroupFor(pItem As %String) As %String [ Private ]
{
	Set tFirstFoundGroup=""
	Kill tRestFoundGroups
	Set tGroup="" While 1 {
		Set tGroup=$Order(..Groups(tGroup)) If tGroup="" {Quit}
		Set tItem="" While 1 {
			Set tItem=$Order(..Groups(tGroup,tItem)) If tItem="" {Quit}
			
			// if the items are actually the same: return the group and don't worry about merging
			If pItem=tItem {Return tGroup}
			
			// if the items are equivalent ..
			If ..EquivalentViaCache(pItem,tItem) {
			
				// note the group
				If tFirstFoundGroup="" {
					Set tFirstFoundGroup=tGroup
				}
				ElseIf tGroup'=tFirstFoundGroup {
					Set tRestFoundGroups(tGroup)=""
				}
			}
		}
	}

	// if we found more than just the first group ..
	If $Order(tRestFoundGroups(""))'="" {
	
		// merge the other groups into the first group
		Do ..MergeList(.tRestFoundGroups,tFirstFoundGroup)
	}
	
	Quit tFirstFoundGroup
}

Method EquivalentViaCache(pItem1 As %String, pItem2 As %String) As %Boolean [ Private ]
{
	Set $ListBuild(tKey1,tKey2)=$Select(pItem2]]pItem1:$ListBuild(pItem1,pItem2),1:$ListBuild(pItem2,pItem1))
	
	If $Data(..NotEquivalentCache(tKey1,tKey2)) {Quit 0}
	
	Set tEq=..Equivalent(pItem1,pItem2)
	If 'tEq {
		Set ..NotEquivalentCache(tKey1,tKey2)=""
	}
	
	Quit tEq
}

Method MergeList(ByRef pSourceGroups, pTargetGroup As %String) [ Private ]
{
	Set tSK="" While 1 {
		Set tSK=$Order(pSourceGroups(tSK)) If tSK="" {Quit}
		Merge ..Groups(pTargetGroup)=..Groups(tSK)
		Kill ..Groups(tSK)
	}
}

}
