/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.AbstractGraph Extends %RegisteredObject
{

/// ..Nodes(NODENAME)=""
Property Nodes As array Of %String [ Private ];

/// ..Edges(SOURCENODE)(DESTNODE)=ABSTRACTLABEL
Property Edges As array Of %ArrayOfDataTypes [ Private ];

/// ..CachedClosure(STARTNODE)=CLOSURELIST (cache)
Property CachedClosure As array Of %List [ Private ];

/// ..CachedCycle(STARTNODE)=0/1 (cache)
Property CachedCycle As array Of %Boolean [ Private ];

/// ..CachedRoots=$LB(RootName1,RootName2,...) (cache)
/// <p> Value of "" indicates that this is unset
Property CachedRoots As %List [ Private ];

/// virtual default
Method EdgeLabel(pSourceNode As %String, pDestNode As %String, pAbstractLabel As %String = "") As %String
{
	Quit pAbstractLabel // use abstract label
}

Method SetNode(pSourceNodeName As %String, pObject As %RegisteredObject)
{
	$$$THROWONERROR(tSC,..Nodes.SetAt(pObject,pSourceNodeName))
}

Method GetNode(pSourceNodeName As %String) As %RegisteredObject [ CodeMode = expression ]
{
..Nodes.GetAt(pSourceNodeName)
}

Method AddEdge(pSourceNodeName As %String, pDestNodeName As %String, pAbstractLabel As %String = "")
{
	Do ..ClearCaches()
	
	If '..Nodes.IsDefined(pSourceNodeName) {
		$$$THROWONERROR(tSC,..Nodes.SetAt("",pSourceNodeName))
	}
	
	If '..Nodes.IsDefined(pDestNodeName) {
		$$$THROWONERROR(tSC,..Nodes.SetAt("",pDestNodeName))
	}
	
	If ..Edges.IsDefined(pSourceNodeName),..Edges.GetAt(pSourceNodeName).IsDefined(pDestNodeName) {
		$$$FATAL("AbstractGraph: edge added twice - "_pSourceNodeName_" --> "_pDestNodeName)
	}
	
	If '..Edges.IsDefined(pSourceNodeName) {
		$$$THROWONERROR(tSC,..Edges.SetAt(##class(%ArrayOfDataTypes).%New(),pSourceNodeName))
	}
	$$$THROWONERROR(tSC,..Edges.GetAt(pSourceNodeName).SetAt(pAbstractLabel,pDestNodeName))
}

Method RemoveNode(pNodeName As %String)
{
	Do ..ClearCaches()
	
	Do ..Nodes.RemoveAt(pNodeName)

	Do ..Edges.RemoveAt(pNodeName)
	
	Set tSourceNode="" While 1 {
		Set tSourceNode=..Edges.Next(tSourceNode) If tSourceNode="" {Quit}
		Do ..Edges.GetAt(tSourceNode,).RemoveAt(pNodeName)
	}
}

Method NodeCount() As %Integer [ CodeMode = expression ]
{
..Nodes.Count()
}

Method NodesStartingWith(pPrefix As %String) As %List
{
	Set tLenPrefix=$Length(pPrefix)
	Set tOut=""
	Set tKey=..Nodes.Previous(pPrefix)
	While 1 {
		Set tKey=..Nodes.Next(tKey) If tKey="" {Quit}
		If $Extract(tKey,1,tLenPrefix)'=pPrefix {Quit}
		Set tOut=tOut_$ListBuild(tKey)
	}
	
	Quit tOut
}

/// return a list of all the nodes which have no incoming edge
Method Roots() As %List
{
	If ..CachedRoots="" {
	
		// copy ..Nodes to tNodes
		Set tKey="" While 1 {
			Set tKey=..Nodes.Next(tKey) If tKey="" {Quit}
			Set tNodes(tKey)=..Nodes.GetAt(tKey)
		}
		
		Set tSourceNode="" While 1 {
			Set tSourceNode=..Edges.Next(tSourceNode) If tSourceNode="" {Quit}
			Set tSubArray=..Edges.GetAt(tSourceNode)
			Set tDestNode="" While 1 {
				Set tDestNode=tSubArray.Next(tDestNode) If tDestNode="" {Quit}
				Kill tNodes(tDestNode)
			}
		}
		
		Set tOut=""
		Set tNodeName="" While 1 {
			Set tNodeName=$Order(tNodes(tNodeName)) If tNodeName="" {Quit}
			Set tOut=tOut_$ListBuild(tNodeName)
		}
		
		Set ..CachedRoots=tOut
	}
	
	Quit ..CachedRoots
}

// return a list of $LB(DESTNODE,EDGELABEL) which are edge destinations of this node

Method Dests(pNodeName As %String) As %List
{
	Set tOut=""

	If ..Edges.IsDefined(pNodeName) {
	
		Set tSubArray=..Edges.GetAt(pNodeName)
	
		Set tDestNode="" While 1 {
			Set tDestNode=tSubArray.Next(tDestNode) If tDestNode="" {Quit}
			Set tAbstractLabel=tSubArray.GetAt(tDestNode)
			Set tOut=tOut_$ListBuild($ListBuild(tDestNode,tAbstractLabel))
		}
	}
		
	Quit tOut
}

/// return a list of node names for the transitive closure of the edge graph from the given node
/// <br> the given node is included in the list
Method Closure(pNodeName As %String) As %List
{
	If '..CachedClosure.IsDefined(pNodeName) {
	
		Set tOut=""
		Set tTodo(pNodeName)=""
		Set tSeen(pNodeName)=""
		Set tCycle=0		
		Do {
		
			// next node to do
			Set tNode=$Order(tTodo("")) Kill tTodo(tNode)
			
			// add it to the output
			Set tOut=tOut_$ListBuild(tNode)
			
			// for each destination node of tNode ..
			Set tDests=..Dests(tNode)
			Set tPtrI=0 While $ListNext(tDests,tPtrI,tElemI) {
			
				Set tOneDest=$List(tElemI)
				
				// if we've seen it already ..
				If $Data(tSeen(tOneDest)) {
					Set tCycle=1
				}
				
				// .. not seen it already ..
				Else {
							
					// note it to do and as seen
					Set tTodo(tOneDest)=""
					Set tSeen(tOneDest)=""
				}
			}
		} While $Data(tTodo)\10
		
		$$$THROWONERROR(tSC,..CachedClosure.SetAt(tOut,pNodeName))
		$$$THROWONERROR(tSC,..CachedCycle.SetAt(tCycle,pNodeName))
	}
	
	Quit ..CachedClosure.GetAt(pNodeName)
}

/// return whether the given node heads a cycle
/// <br> this will trigger the closure traversal of the node unless it's available in the cache
Method Cyclic(pNodeName As %String) As %Boolean
{
	If '..CachedCycle.IsDefined(pNodeName) {
		Do ..Closure(pNodeName)
	}
	
	Quit ..CachedCycle.GetAt(pNodeName)
}

Method AddToDigraph(pDigraph As %CPT.Tree.SimpleDigraph, pRootNodeColor As %String = "")
{
	If pRootNodeColor'="" {
		Set tRoots=..Roots()
		Set tPtrI=0 While $ListNext(tRoots,tPtrI,tElemI) {
			$$$THROWONERROR(tSC,pDigraph.AddNode(tElemI,,pRootNodeColor))
			Set tSeenNode(tElemI)=""
		}
	}
	
	Set tSourceNode="" While 1 {
		Set tSourceNode=..Edges.Next(tSourceNode) If tSourceNode="" {Quit}
		Set tSubArray=..Edges.GetAt(tSourceNode)
		Do ..NodeForDigraph(pDigraph,tSourceNode,.tSeenNode)
		Set tDestNode="" While 1 {
			Set tDestNode=tSubArray.Next(tDestNode) If tDestNode="" {Quit}
			Set tAbstractLabel=tSubArray.GetAt(tDestNode)
			Do ..NodeForDigraph(pDigraph,tSourceNode,.tSeenNode)
			$$$THROWONERROR(tSC,pDigraph.AddEdge(tSourceNode,tDestNode,..EdgeLabel(tSourceNode,tDestNode,tAbstractLabel)))
		}
	}
}

Method Dump()
{
	Write !
	
	Write "NODES",!
	Set tNodeKey="" While 1 {
		Set tNodeKey=..Nodes.Next(tNodeKey) If tNodeKey="" {Quit}
		Write " ",tNodeKey," = ",$ListToString(..Nodes.GetAt(tNodeKey)),!
	}
	
	Write "EDGES",!
	Set tEdgeSourceKey="" While 1 {
		Set tEdgeSourceKey=..Edges.Next(tEdgeSourceKey) If tEdgeSourceKey="" {Quit}
		Set tEdgeSourceArr=..Edges.GetAt(tEdgeSourceKey)
		Set tEdgeDestKey="" While 1 {
			Set tEdgeDestKey=tEdgeSourceArr.Next(tEdgeDestKey) If tEdgeDestKey="" {Quit}
			Set tEdgeLabel=tEdgeSourceArr.GetAt(tEdgeDestKey)
			Write " ",tEdgeSourceKey," --",tEdgeLabel,"--> ",tEdgeDestKey,!
		}
	}
	
	Write "ROOTS",!
	Set tRoots=..Roots()
	Set tPtrI=0 While $ListNext(tRoots,tPtrI,tElemI) {
		Write " ",tElemI,!
	}
}

Method NodeForDigraph(pDigraph As %CPT.Tree.SimpleDigraph, pNodeName As %String, ByRef pSeenNode) [ Private ]
{
	If '$Data(pSeenNode(pNodeName)) {
		Set pSeenNode(pNodeName)=""
		If ..Nodes.IsDefined(pNodeName) {
			Set tNode=..Nodes.GetAt(pNodeName)
			Set tLabel=..NodeGraphLabel(tNode)
			If tLabel'="" {
				$$$THROWONERROR(tSC,pDigraph.AddNode(pNodeName,,,,$ListBuild($ListBuild("label",""""_tLabel_""""))))
			}
		}
	}
}

/// Returns "" if no label
ClassMethod NodeGraphLabel(Arg) As %String [ Private ]
{
	If $IsObject(Arg) {
		Quit Arg.NodeGraphLabel()
	}
	Else {
		Try {
			Return $ListToString(Arg)
		}
		Catch e {
			Return Arg
		}
	}
}

Method ClearCaches() [ Private ]
{
	Do ..CachedClosure.Clear()
	Do ..CachedCycle.Clear()
	Set ..CachedRoots=""
}

}
