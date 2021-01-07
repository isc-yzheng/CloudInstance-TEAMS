/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Node

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.ENode Extends %RegisteredObject
{

Property Repr As %String [ Private ];

Property SourceStartOffset As %Integer [ Private ];

/// 0 => root
Property ParentIndex As %Integer [ Private ];

Property ChildIndexes As %Integer [ MultiDimensional, Private ];

Method %OnNew(pRepr As %String, pSourceStartOffset As %Integer, pParentIndex As %Integer, ByRef pChildIndexes As %Integer) As %Status
{
	Set ..Repr=pRepr
	Set ..SourceStartOffset=pSourceStartOffset
	Set ..ParentIndex=pParentIndex

	Set ..ChildIndexes=0 // in case there aren't any children
	Merge ..ChildIndexes=pChildIndexes
	
	Quit $$$OK
}

Method ReprGet() As %String [ CodeMode = expression ]
{
i%Repr
}

Method SourceStartOffsetGet() As %Integer [ CodeMode = expression ]
{
i%SourceStartOffset
}

/// Returns "" for root
Method GetParent(pENodeCollection As ENodeCollection) As ENode [ CodeMode = expression ]
{
$Select(..ParentIndex=0:"",1:pENodeCollection.ENodeAt(..ParentIndex))
}

Method GetChildren(pENodeCollection As ENodeCollection, Output pChildren)
{
	$$$SHOULDBEUNDEF(pChildren)

	For tI=1:1:..ChildIndexes {
		Set pChildren($I(pChildren))=..GetChildENodeAt(pENodeCollection,tI)
	}
}

Method GetDescendantLeaves(pENodeCollection As ENodeCollection, Output pLeaves)
{
	$$$SHOULDBEUNDEF(pLeaves)
	Do ..GetDescendantLeavesImpl(pENodeCollection,.pLeaves)
}

Method GetDescendantLeavesImpl(pENodeCollection As ENodeCollection, ByRef pLeaves) [ Private ]
{
	If ..ChildIndexes=0 {
		Set pLeaves(i%Repr,$I(pLeaves(i%Repr)))=$This
	}
	Else {
		For tI=1:1:..ChildIndexes {
			Do ..GetChildENodeAt(pENodeCollection,tI).GetDescendantLeavesImpl(pENodeCollection,.pLeaves)
		}
	}
}

Method GetChildENodeAt(pENodeCollection As ENodeCollection, pIndex As %Integer) As ENode [ CodeMode = expression, Private ]
{
pENodeCollection.ENodeAt(..ChildIndexes(pIndex))
}

Method GetAtPath(pPath As %List) As ENode [ CodeMode = expression ]
{
..GetAtPathImpl(pPath,1)
}

Method GetAtPathImpl(pPath As %List, pFromIndex As %Integer) As ENode [ Private ]
{
	If pFromIndex > $ListLength(pPath) {
		Quit $This
	}
	
	Quit ..ChildIndexes($List(pPath,pFromIndex)).GetAtPathImpl(pPath,pFromIndex+1)
}

Method Dump(pENodeCollection As ENodeCollection, pIndent As %String = "")
{
	Write pIndent,..Repr," ^",..ParentRepr(pENodeCollection),!
	Set tNewIndent=pIndent_" "
	For tI=1:1:..ChildIndexes {
		Do ..GetChildENodeAt(pENodeCollection,tI).Dump(pENodeCollection,tNewIndent)
	}
}

Method ParentRepr(pENodeCollection As ENodeCollection) As %String [ CodeMode = expression, Private ]
{
$Case(..ParentIndex,0:"(none)",1:"(root)",:pENodeCollection.ENodeAt(..ParentIndex).Repr)
}

}
