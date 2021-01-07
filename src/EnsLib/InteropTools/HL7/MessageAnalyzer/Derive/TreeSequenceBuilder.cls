/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TreeSequenceBuilder Extends %RegisteredObject
{

Property PendingLeaves As %List [ Private ];

/// Sequence(1..Sequence)=ENTRY
/// <p> ENTRY is either a $List of leaves or a node object
Property Sequence [ MultiDimensional, Private ];

Method %OnNew() As %Status
{
	Set ..PendingLeaves=""
	Quit $$$OK
}

Method AddNode(pNode As %RegisteredObject)
{
	Set tLeaf=pNode.LeafValue()
	
	// if it's a leaf ..
	If tLeaf'="" {
	
		// add it to the pending list
		Set ..PendingLeaves=..PendingLeaves_$ListBuild(tLeaf)
	}
	
	// .. not a leaf ..
	Else {
		
		// flush any leaves and add the node to the sequence
		Do ..Flush()		
		Set ..Sequence($I(..Sequence))=pNode
	}
}

/// Flush pending leaves, if any
Method Flush()
{
	If ..PendingLeaves'="" {
		Set ..Sequence($I(..Sequence))=..PendingLeaves
		Set ..PendingLeaves=""
	}
}

/// If the sequence is just leaves: return them, otherwise return ""
Method JustLeaves() As %List
{
	$$$ACASSERT($Get(..Sequence),"TreeSequenceBuilder: sequence is empty")
	
	If ..Sequence=1 {
		Set tItem=..Sequence(1)
		If '$IsObject(tItem) {
			Quit tItem
		}
	}
	
	Quit ""
}

}
