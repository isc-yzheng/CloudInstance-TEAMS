/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Node

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.ENodeCollection Extends %RegisteredObject
{

Property ENodes As ENode [ MultiDimensional, Private ];

Method %OnNew(pRootNode As Base) As %Status
{
	Do ..Build(pRootNode,1,0) // root at index 1
	
	Quit $$$OK
}

Method Dump()
{
	Do ..Root().Dump($This)
}

Method Root() As ENode [ CodeMode = expression ]
{
..ENodes(1)
}

Method ENodeAt(pIndex As %Integer) As ENode [ CodeMode = expression ]
{
..ENodes(pIndex)
}

Method Build(pNode As Base, ByRef pIndex As %Integer, pParentIndex As %Integer) As ENode [ Private ]
{
	// REMOVE pIndex!
	Set tThisIndex=pIndex
	Set pIndex=pIndex+1
	
	Kill tChildren
	Do ..GetProperChildren(pNode,.tChildren)
	
	Kill tEChildren
	For tI=1:1:$Get(tChildren) {
		Set tEChildren($I(tEChildren))=..Build(tChildren(tI),.pIndex,tThisIndex)
	}
	
	Set ..ENodes(tThisIndex)=##class(ENode).%New(pNode.Pattern(),$List(pNode.GetSourceOffset()),pParentIndex,.tEChildren)
	
	Quit tThisIndex
}

ClassMethod GetProperChildren(pNode As Base, Output pChildren) [ Private ]
{
	$$$SHOULDBEUNDEF(pChildren)

	Do pNode.GetChildren(.pChildren)
	
	Set tTypeCode=pNode.TypeCode()
	If tTypeCode'="","ROC"[tTypeCode {
		$$$ACASSERT($Get(pChildren)=1,"ENodeCollection: not exactly one child for type-"_tTypeCode_" node")
		Set tOnlyNode=pChildren(1)
		Kill pChildren
		Do tOnlyNode.GetChildren(.pChildren)
	}
}

}
