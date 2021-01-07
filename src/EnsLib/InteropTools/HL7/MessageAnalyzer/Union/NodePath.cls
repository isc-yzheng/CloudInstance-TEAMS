/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Node

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.NodePath Extends %RegisteredObject
{

Property Root As Base [ Private ];

Property Path As %List [ Private ];

Property Nodes As Base [ MultiDimensional, Private ];

Method %OnNew(pRoot As Base, pPath As %List, ByRef pNodes) As %Status
{
	Set ..Root=pRoot
	Set ..Path=pPath
	If $Data(pNodes)\10 {
		$$$ACASSERT($Order(pNodes(""),-1)=$ListLength(pPath),"NodePath constructor: given pNodes does not match pPath")
		Merge ..Nodes=pNodes
	}
	Else {
		Do ..MakeNodes()
	}
	Quit $$$OK
}

Method ParentNode() As Base [ CodeMode = expression ]
{
..Nodes($ListLength(..Path)-1)
}

Method Copy() As %List
{
	Kill tNodes
	Merge tNodes=..Nodes
	Quit ##class(NodePath).%New(..Root,..Path,.tNodes)
}

Method MakeNodes() [ Private ]
{
	
	Set tNode=..Root
	For tI=1:1:$ListLength(..Path) { // not expected to be long enough for $ListNext to be needed
		Kill tChildren
		Do tNode.GetChildren(.tChildren)
		Set tNode=tChildren($List(..Path,tI))
		Set ..Nodes(tI)=tNode
	}
	
	Quit tNode
}

}
