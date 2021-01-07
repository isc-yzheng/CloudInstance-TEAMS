/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.AbstractStrings, EnsLib.InteropTools.HL7.MessageAnalyzer.Output, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.AbstractStringsCollection Extends %RegisteredObject
{

/// CountedLines(..)=$LB(El,El,..)
Property CountedLines As list Of %List [ Private ];

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property Sorted As %Boolean [ Private, ReadOnly ];

Property LogDetail As %Boolean [ Private ];

/// pCLIList is either a list of indexes of pCountedLines to use, or it's "" (or omitted from the call) meaning that the whole of pCountedLines is to be used
Method %OnNew(ByRef pCountedLines, pCLIList As %List = "", pConfig As Config, pLogger As Logger, pSorted As %Boolean = 0) As %Status
{
	If pCLIList="" {
		For tI=1:1:$Get(pCountedLines) {
			Do ..CountedLines.Insert(pCountedLines(tI))
		}
	}
	Else {
		Set tPtrI=0 While $ListNext(pCLIList,tPtrI,tElemI) {
			Do ..CountedLines.Insert(pCountedLines(tElemI))
		}
	}
	
	If ..CountedLines.Count()=0 {$$$FATAL("AbstractStringsCollection: no counted lines given")}
	
	Set ..Logger=pLogger
	
	Set ..Config=pConfig
	Set i%Sorted=pSorted
	
	Set ..LogDetail=..Config.IsFlagSet("LOGABSTRACTSTRINGS")
	
	Quit $$$OK
}

/// Derive an SSF pattern which will parse all lines in the collection
/// <p> Returns $LB("",PATTERN) if successful, otherwise $LB(ERRORCODE,""), where ERRORCODE values are macros $$$ASCXXX
/// <p> If pTree is passed with an object (a Tree with an *empty* choice node @pChoiceIndex) it will be updated with the derived patterns 
Method DerivePattern(pGraphName As %String, pTree As Tree = "", pChoiceIndex As %Integer = "") As %String
{
	// Attempt to use DerivePatternImpl to derive a pattern
	// - if that fails try again with sorted strings and a flag which indicates that the pattern should be order-insensitive
	
	// try the collection as constructed
	Set tTree1=$Select(pTree="":"",1:pTree.Clone())
	Set tResult=..DerivePatternImpl(pGraphName,tTree1,pChoiceIndex)
	Set $ListBuild(tError,tPattern)=tResult
	If tError="" {
		If pTree'="" {
			Do pTree.ReplaceWith(tTree1)
		}
		Quit tResult // success
	}
	
	// try again after sorting
	If $$$DBFLAG {
		Write !,"Retry after sorting",!
	}
	Do ..SortCountedLinesTo(.tCountedLines)
	Set tObj=..%New(.tCountedLines,,..Config,..Logger,1)
	Set tTree2=$Select(pTree="":"",1:pTree.Clone())
	Set tResult=tObj.DerivePatternImpl(pGraphName,tTree2,pChoiceIndex)
	Set $ListBuild(tError,tPattern)=tResult
	If tError="" {
		If pTree'="" {
			Do pTree.ReplaceWith(tTree2)
		}
		Quit tResult // success
	}
	
	Quit tResult // failure
}

/// Derive an SSF pattern which will parse all lines in the collection
/// <p> Returns $LB("",PATTERN) if successful, otherwise $LB(ERRORCODE,""), where ERRORCODE values are macros $$$ASCXXX
Method DerivePatternImpl(pGraphName As %String, pTree As Tree, pChoiceIndex As %Integer) As %String [ Private ]
{
	
	// just one unique line ..
	If ..CountedLines.Count()=1 {

		$$$LOGOUTPUTWRITEIF1(..Logger," - no variation in line: append fixed sequence "_..ShowCLIList(),..LogDetail)
				
		Set tItemList=..CountedLines.GetAt(1)
		
		If pTree'="" {			
		
			// construct subtree and return its index
			If ..Sorted {	
				Set tSubtreeIndex=..MakeSortedPatternTree(tItemList,pTree)
			}	
			Else {
				Kill tAllRemovedItems
				Kill tAllRepeatedItems
				Set tSubtreeIndex=..MakeUnsortedPatternTree(tItemList,.tAllRemovedItems,.tAllRepeatedItems,pTree)
			}
				
			// add the subtree to the choice
			Do pTree.AddReference(pChoiceIndex,tSubtreeIndex)

			Quit $ListBuild("",pTree.Pattern(tSubtreeIndex))
		}
		
		Quit $ListBuild("",$ListToString(tItemList))
	}
	
	// get relationships between all pairs of elements in the collection
	Do ..GetRelationships(.tRels)
	
	// if there are NO relationships ..
	If $Order(tRels(""))="" {
		Quit $ListBuild($$$ASCNR,"") // no relationships found
	}
	
	// list relationships
	$$$LOGOUTPUTWRITEIF1(..Logger,"Relationships",..LogDetail)
	Set tI="" While 1 {
		Set tI=$Order(tRels(tI)) If tI="" {Quit}
		$$$LOGOUTPUTWRITEIF1(..Logger," "_..ShowCLI(tI),..LogDetail) 
		Set tJ="" While 1 {
			Set tJ=$Order(tRels(tI,tJ),+1,tRelIJ) If tJ="" {Quit}
			$$$LOGOUTPUTWRITEIF1(..Logger,"  "_..ShowCLI(tJ)_": "_..Relx(tRelIJ),..LogDetail)
		}
	}
	$$$LOGOUTPUTWRITEIF1(..Logger,"",..LogDetail)
	
	// make abstract graph from relationships
	Set tAbstractGraph=##class(AbstractGraph).%New()
	For tI=1:1:..CountedLines.Count() {
		Set tUnprocessedIndex(tI)=""
	}
	Set tI="" While 1 {
		Set tI=$Order(tRels(tI)) If tI="" {Quit}
		Set tLName=..AddNodeToGraph(tAbstractGraph,tI)
		Kill tUnprocessedIndex(tI)
		Set tJ="" While 1 {
			Set tJ=$Order(tRels(tI,tJ),+1,tRelIJ) If tJ="" {Quit}
			Set tRName=..AddNodeToGraph(tAbstractGraph,tJ)
			Kill tUnprocessedIndex(tJ)
			If tRelIJ=$$$REPEATSECOND {
				Do tAbstractGraph.AddEdge(tLName,tRName,"R")
			}
			ElseIf tRelIJ=$$$OPTIONALSECOND {
				Do tAbstractGraph.AddEdge(tLName,tRName,"O")
			}
		}
	}
	
	// add elements with no relationships to the abstract graph
	Set tI="" While 1 {
		Set tI=$Order(tUnprocessedIndex(tI)) If tI="" {Quit}
		Do ..AddNodeToGraph(tAbstractGraph,tI)
	}
	
	// show the closure for each root
	Set tRoots=tAbstractGraph.Roots()
	
	Set tClosureNodeCount=0
	Set tPtrI=0 While $ListNext(tRoots,tPtrI,tElemI) {
		$$$LOGOUTPUTWRITEIF1(..Logger,"Root: "_tElemI,..LogDetail)
		Set tNodeClosure=tAbstractGraph.Closure(tElemI)
		$$$LOGOUTPUTWRITEIF1(..Logger," - closure: "_$ListToString(tNodeClosure),..LogDetail)
		Set tClosureNodeCount=tClosureNodeCount+$ListLength(tNodeClosure)
	}
	
	// see if the root closures are disjoint
	Set tRootClosuresAreDisjoint=(tClosureNodeCount = tAbstractGraph.NodeCount())
	If tRootClosuresAreDisjoint {
		$$$LOGOUTPUTWRITEIF1(..Logger,"Root closures are disjoint",..LogDetail)
	}
	Else {
		$$$LOGOUTPUTWRITEIF1(..Logger,"Root closures are NOT disjoint",..LogDetail)
	}

	// draw the graph
	If ..Config.IsFlagSet("GRAPHABSTRACTSTRINGS") {
		$$$THROWONERROR(tSC,..Digraph(tAbstractGraph,pGraphName))
	}
	
	// if the root closures are disjoint ..
	If tRootClosuresAreDisjoint {
	
		// for each root ..
		Set tChoice=""
		Set tPtrI=0 While $ListNext(tRoots,tPtrI,tElemI) {
		
			// pattern/subtree to match this root
			Set $ListBuild(tRootError,tPatternOrSubtree)=..AnalyzeRoot(tAbstractGraph,tElemI,pTree)
			
			If tRootError'="" {

				Set tRootPattern=$Select(pTree="":tPatternOrSubtree,1:pTree.Pattern())
				Return $ListBuild(tRootError,tRootPattern)
			}

			If pTree="" {
				
				// add the pattern to the choice we're building
				Set tChoice=tChoice_$ListBuild(tPatternOrSubtree)
			}
			Else {
				
				// add the subtree to the choice we're building
				Do pTree.AddReference(pChoiceIndex,tPatternOrSubtree)
			}
		}
		
		// return a pattern representing a choice
		If pTree="" {
			Quit $ListBuild("",##class(Common).ListToPattern(tChoice))
		}
		Else {
			Quit $ListBuild("",pTree.Pattern(pChoiceIndex))
		}
	}

	// failed to find a pattern
	Quit $ListBuild($$$ASCRCND,"") // root closures are not disjoint
}

/// Return SSF pattern or Tree subtree index to match this given root
/// <p> If no tree is given: returns $LB("",PATTERN) if successful, otherwise $LB(ERRORCODE,""), where ERRORCODE values are macros $$$ASCXXX
/// <p> If a tree is given: returns $LB("",SUBTREEINDEX) if successful, otherwise $LB(ERRORCODE,""), where ERRORCODE values are macros $$$ASCXXX
/// <br> client MUST NOT pass a graph with looping cycles!
Method AnalyzeRoot(pAbstractGraph As AbstractGraph, pRootNode As %String, pTree As Tree) As %CacheString [ Private ]
{
	// find the extremal nodes (leaves) from the root, for both repeat and optional
	// - this code ASSUMES that the graph has no cycles
	Set tDests=pAbstractGraph.Dests(pRootNode)
	Set tPtrI=0 While $ListNext(tDests,tPtrI,tElemI) {
	
		Set $ListBuild(tDestNode,tLabel)=tElemI
		
		// get the leaves
		Set tLeaves=..SameLabelPathLeaves(pAbstractGraph,tDestNode,tLabel)
		If tLeaves="" {
			Return $ListBuild($$$ASCTV,"") // collection cannot be resolved as repeats and optionals
		}
		
		// note the leaves
		Set tPtrJ=0 While $ListNext(tLeaves,tPtrJ,tElemJ) {
			Set tAllLeaves(tLabel,tElemJ)=""
		}
	}
	
	// move the leaves (optional and repeat) from the arrays to lists 
	Set tLeaves("O")=..ArrToList1(.tAllLeaves,"O")
	$$$LOGOUTPUTWRITEIF1(..Logger,"Optional leaves: "_$ListToString(tLeaves("O")),..LogDetail)
	Set tLeaves("R")=..ArrToList1(.tAllLeaves,"R")
	$$$LOGOUTPUTWRITEIF1(..Logger,"Repeat leaves: "_$ListToString(tLeaves("R")),..LogDetail)
	
	Set tRootNodeList=pAbstractGraph.GetNode(pRootNode)
	
	// analyse the optional leaves
	Set tPtrI=0 While $ListNext(tLeaves("O"),tPtrI,tElemI) {
	
		Set tLeafNodeList=pAbstractGraph.GetNode(tElemI)
		Set tRemovedItems=..RemovedListItems(tRootNodeList,tLeafNodeList)
		$$$LOGOUTPUTWRITEIF1(..Logger,"Optional: "_$ListToString(tRemovedItems),..LogDetail)
		
		Set tPtrJ=0 While $ListNext(tRemovedItems,tPtrJ,tElemJ) {
			Set tAllRemovedItems(tElemJ)=""
		}
	}

	// analyse the repeat leaves
	Set tPtrI=0 While $ListNext(tLeaves("R"),tPtrI,tElemI) {
	
		Set tLeafNodeList=pAbstractGraph.GetNode(tElemI)
		Set tRepeatedItems=..RepeatedListItems(tLeafNodeList)
		$$$LOGOUTPUTWRITEIF1(..Logger,"Repeated: "_$ListToString(tRepeatedItems),..LogDetail)
		
		Set tPtrJ=0 While $ListNext(tRepeatedItems,tPtrJ,tElemJ) {
			Set tAllRepeatedItems(tElemJ)=""
		}
	}
	

	
	If pTree="" {
	
		// construct pattern and return it
		If ..Sorted {	
			Quit $ListBuild("",..MakeSortedPattern(tRootNodeList))
		}
		Else {
			Quit $ListBuild("",..MakeUnsortedPattern(tRootNodeList,.tAllRemovedItems,.tAllRepeatedItems))
		}
	}
	
	Else {
		
		// construct subtree and return its index
		If ..Sorted {	
			Set tSubtreeIndex=..MakeSortedPatternTree(tRootNodeList,pTree)
			Quit $ListBuild("",tSubtreeIndex)
		}	
		Else {
			Set tSubtreeIndex=..MakeUnsortedPatternTree(tRootNodeList,.tAllRemovedItems,.tAllRepeatedItems,pTree)
			Quit $ListBuild("",tSubtreeIndex)
		}
	}
}

ClassMethod MakeSortedPatternTree(pRootNodeList As %List, pTree As Tree) As %Integer [ Private ]
{
	// create a sequence node
	Set tSequenceIndex=pTree.NewTopLevelEntry($$$SNODE)
	
	// for each item ..
	Set tPtrI=0 While $ListNext(pRootNodeList,tPtrI,tElemI) {
	
		// create and add node for the element text
		Set tElemNode=$$$PLAINNODE($ListBuild(tElemI))
		Set tElemIndex=pTree.NewTopLevelEntry(tElemNode)
		
		// wrap an Optional node around it
		Set tOptionalIndex=##class(TreeModel).CreateOptional(tElemIndex,pTree,"") // every item is optional
		
		// add it to the sequence
		Do pTree.AddReference(tSequenceIndex,tOptionalIndex)
	}

	// wrap a repeat around the sequence
	Set tRepeatIndex=##class(TreeModel).CreateRepeat(tSequenceIndex,pTree,"") // the whole pattern is repeated
			
	Quit tRepeatIndex
}

ClassMethod MakeUnsortedPatternTree(pRootNodeList As %List, ByRef pAllRemovedItems, ByRef pAllRepeatedItems, pTree As Tree) As %Integer [ Private ]
{
	// create a sequence node
	Set tSequenceIndex=pTree.NewTopLevelEntry($$$SNODE)
	
	// for each item ..
	Set tPtrI=0 While $ListNext(pRootNodeList,tPtrI,tElemI) {
		
		// create and add node for the element text
		Set tElemNode=$$$PLAINNODE($ListBuild(tElemI))		
		Set tElemIndex=pTree.NewTopLevelEntry(tElemNode)
	
		Set tIsOptional=$Data(pAllRemovedItems(tElemI))
		Set tIsRepeated=$Data(pAllRepeatedItems(tElemI))
	
		Set tIndex=tElemIndex
		If tIsOptional,tIsRepeated {

			// wrap a Repeat node around it
			Set tIndex=##class(TreeModel).CreateRepeat(tIndex,pTree,"") // the whole pattern is repeated

			// wrap an Optional node around it
			Set tIndex=##class(TreeModel).CreateOptional(tIndex,pTree,"") // every item is optional
		}
		ElseIf tIsOptional {

			// wrap an Optional node around it
			Set tIndex=##class(TreeModel).CreateOptional(tIndex,pTree,"") // every item is optional
 		}
		ElseIf tIsRepeated {
		
			// wrap a Repeat node around it
			Set tIndex=##class(TreeModel).CreateRepeat(tIndex,pTree,"") // the whole pattern is repeated
		}
		Else {
			// each item is as-is (one and only one)
		}
		
		// add it to the sequence
		Do pTree.AddReference(tSequenceIndex,tIndex)
	}

	Quit tSequenceIndex
}

ClassMethod MakeSortedPattern(pRootNodeList As %List) As %String [ Private ]
{
	
	Set tPattern=""
	Set tPtrI=0 While $ListNext(pRootNodeList,tPtrI,tElemI) {
		
		Set tPatternPart="["_tElemI_"]" // every item is optional
		
		Set tPattern=tPattern_$ListBuild(tPatternPart)
	}
	Quit "{"_$ListToString(tPattern)_"}" // the whole pattern is repeated
}

ClassMethod MakeUnsortedPattern(pRootNodeList As %List, ByRef pAllRemovedItems, ByRef pAllRepeatedItems) As %String [ Private ]
{
	Set tPattern=""
	Set tPtrI=0 While $ListNext(pRootNodeList,tPtrI,tElemI) {
		
		Set tIsOptional=$Data(pAllRemovedItems(tElemI))
		Set tIsRepeated=$Data(pAllRepeatedItems(tElemI))
	
		If tIsOptional,tIsRepeated {
			Set tPatternPart="[{"_tElemI_"}]" // each item is optional repeat
		}
		ElseIf tIsOptional {
			Set tPatternPart="["_tElemI_"]" // each item is optional
		}
		ElseIf tIsRepeated {
			Set tPatternPart="{"_tElemI_"}" // each item is repeat
		}
		Else {
			Set tPatternPart=tElemI // each item is as-is (one and only one)
		}
		
		Set tPattern=tPattern_$ListBuild(tPatternPart)
	}

	Quit $ListToString(tPattern)
}

/// Return a list of all the items in pList1 which are not in pList2
ClassMethod RemovedListItems(pList1 As %List, pList2 As %List) As %List [ Private ]
{
	Set tList2=pList2
	Set tOut=""
	Set tPtrI=0 While $ListNext(pList1,tPtrI,tElemI) {
		Set tPos=$ListFind(tList2,tElemI)
		If 'tPos {
			Set tOut=tOut_$ListBuild(tElemI)
		}
		Else {
			Set tList2=$List(tList2,1,tPos-1)_$List(tList2,tPos+1,*)
		}
	}
	
	Quit tOut
}

/// Return a list of every item in the list which ever appears next to another copy of itself - there are NO repeats in the returned list
ClassMethod RepeatedListItems(pList As %List) As %List [ Private ]
{
	Set tLast=""
	Set tPtrI=0 While $ListNext(pList,tPtrI,tElemI) {
		If tElemI=tLast {
			Set tRepeated(tElemI)=""
		}
		Else {
			Set tLast=tElemI
		}
	}
	
	Quit ..ArrToList0(.tRepeated)
}

/// Return a list of the top-level keys in the given array
ClassMethod ArrToList0(ByRef pArr) As %List [ Private ]
{
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=$Order(pArr(tKey)) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tKey)
	}
	
	Quit tOut
}

/// Return a list of the second-level keys under the given key in the given array
ClassMethod ArrToList1(ByRef pArr, pKey1 As %String) As %List [ Private ]
{
	Set tOut=""
	Set tKey2="" While 1 {
		Set tKey2=$Order(pArr(pKey1,tKey2)) If tKey2="" {Quit}
		Set tOut=tOut_$ListBuild(tKey2)
	}
	
	Quit tOut
}

/// Return a list of leaf nodes reachable from the given node - or return "" if any of the intermediate edges have a label other than the given label
/// <p> Client MUST NOT pass a graph with looping cycles!
Method SameLabelPathLeaves(pAbstractGraph As AbstractGraph, pNode As %String, pLabel As %String) As %String [ Private ]
{
	Set tLeaves=""
	Set tTodo(pNode)=""
	Do {
	
		// next node to do
		Set tNode=$Order(tTodo("")) Kill tTodo(tNode)
	
		// get a list of outgoing links for this node
		Set tDests=pAbstractGraph.Dests(tNode)
		
		// if there aren't any outgoing links ..
		If tDests="" {
		
			// record the node as a leaf
			Set tLeaves=tLeaves_$ListBuild(tNode)
		}
		
		// .. there are outgoing links ..
		Else {
		
			// for each outgoing link ..
			Set tPtrI=0 While $ListNext(tDests,tPtrI,tElemI) {
			
				Set $ListBuild(tDestNode,tDestLabel)=tElemI
				
				// if the edge label does not match the expected label: return FAILURE
				If tDestLabel'=pLabel {Return ""}
				
				// note that the link target node needs to be processed
				Set tTodo(tDestNode)=""
			}
		}
	} While $Data(tTodo)\10
	
	Quit tLeaves
}

/// Given a list of indexes to ..CountedLines: for each pair of lines (triangular), set pRels(Index1,Index2) - and pRels(Index2,Index1) - to a code representing the relationship between the lines (if any)
Method GetRelationships(Output pRels) [ Private ]
{
	$$$SHOULDBEUNDEF(pRels)
	
	// for each left index ..
	For tI=1:1:..CountedLines.Count() {
	
		Set tCLE1=..CountedLines.GetAt(tI)
		
		// for each right index following the left index ..
		For tJ=tI+1:1:..CountedLines.Count() {
		
			Set tCLE2=..CountedLines.GetAt(tJ)
			
			// if there is a relationship between the lines ..
			Set tRel=..CLRelationship(tCLE1,tCLE2)
			If tRel {
			
				// set the relationship and its inverse
				Set pRels(tI,tJ)=tRel
				Set pRels(tJ,tI)=-tRel
			}
		}
	}
}

ClassMethod Relx(pRel As %Integer) As %String [ CodeMode = expression, Private ]
{
$Case(pRel,$$$REPEATFIRST:"first has repeats",$$$REPEATSECOND:"second has repeats",$$$OPTIONALFIRST:"first lacks optional items of second",$$$OPTIONALSECOND:"second lacks optional items of first",:"??"_pRel)
}

/// Each argument is a list of elements
/// <p> 0 => unknown, +1/-1 => pCLE1/pCLE2 has repeats, +2/-2 => pCLE2/pCLE1 is like pCLE1/pCLE2 but with some removed
Method CLRelationship(pCLE1 As %List, pCLE2 As %List) As %Integer [ Private ]
{
	If pCLE1=pCLE2 {$$$FATAL("CLRelationship: lists to compare are equal")}
	Set tCLENR1=..NoRepeats(pCLE1)
	Set tCLENR2=..NoRepeats(pCLE2)
	If tCLENR1=pCLE2 {Quit $$$REPEATFIRST} // first has repeats
	If tCLENR2=pCLE1 {Quit $$$REPEATSECOND} // second has repeats
	
	// if pCLE2 had no repeats ..
	If pCLE2=tCLENR2 {
		If ..FirstRemovesSomeOfSecond(pCLE1,pCLE2) {Quit $$$OPTIONALFIRST}
	}
	
	// if pCLE1 had no repeats ..
	If pCLE1=tCLENR1 {
		If ..FirstRemovesSomeOfSecond(pCLE2,pCLE1) {Quit $$$OPTIONALSECOND}
	}
	
	Quit 0
}

/// Use Graphviz to draw a graph representing the relationship diagram
Method Digraph(pAbstractGraph As AbstractGraph, pGraphName As %String) As %Status [ Private ]
{
	#Dim tDigraph As %CPT.Tree.SimpleDigraph

	Set tDigraph=##class(%CPT.Tree.SimpleDigraph).%New(pGraphName)
	Do pAbstractGraph.AddToDigraph(tDigraph,"red")
	Do ##class(Common).ShowDigraph(tDigraph,pGraphName,..Config)
	
	Quit $$$OK
}

/// Given a list: return the list with no consecutive repeats
Method NoRepeats(pCLE As %List) As %List [ Private ]
{
	Set tLast=""
	Set tOut=""
	Set tPtrI=0 While $ListNext(pCLE,tPtrI,tElemI) {
		If tElemI'=tLast {
			Set tOut=tOut_$ListBuild(tElemI)
			Set tLast=tElemI
		}
	}
	
	Quit tOut
}

/// Each argument is a list of elements
/// <br> Return true if the first is like the second but without some of its elements
Method FirstRemovesSomeOfSecond(pCLE1 As %List, pCLE2 As %List) As %Boolean [ Private ]
{
	// the first is LONGER than the second, so the first can't be the second with some removed
	If $ListLength(pCLE1) >= $ListLength(pCLE2) {Quit 0}
	
	Set tI1=1
	Set tI2=1
	While tI1 <= $ListLength(pCLE1) {
		Set tCL1=$List(pCLE1,tI1)
		While tI2 <= $ListLength(pCLE2), $List(pCLE2,tI2)'=tCL1 {
			Set tI2=tI2+1
		}
		If tI2 > $ListLength(pCLE2) {Return 0} // exhausted pCLE2 while pCLE1 still has elements
		
		Set tI1=tI1+1
		Set tI2=tI2+1
	}
	
	// there may be some pCLE2 left but that's just a final "removal"
	Quit 1
}

/// Return a readable representation of the given list of indexes into ..CountedLines
/// <p> Truncates the result to 50 characters
Method ShowCLIList() As %String
{
	Set tOut=""
	For tI=1:1:..CountedLines.Count() {
		Set tOut=tOut_$ListBuild(..ShowCLI(tI))
	}
	
	Quit ..Truncate($ListToString(tOut,"  "),50)
}

/// Return a readable representation of the counted line at the given index
Method ShowCLI(pCLI As %Integer) As %String [ CodeMode = expression, Private ]
{
$ListToString(..CountedLines.GetAt(pCLI))
}

Method SortCountedLinesTo(Output pSorted) [ Private ]
{
	$$$SHOULDBEUNDEF(pSorted)
	
	Kill tArr
	For tI=1:1:..CountedLines.Count() {
		Set tItem=..CountedLines.GetAt(tI)
		Set tSortedItem=..SortList(tItem)
		Set tArr(##class(Common).RawHash(tSortedItem))=tSortedItem
	}	
	
	Set tKey="" While 1 {
		Set tKey=$Order(tArr(tKey),+1,tSortedItem) If tKey="" {Quit}
		Set pSorted($I(pSorted))=tSortedItem
	}
}

ClassMethod SortList(pList As %List) As %List [ Private ]
{
	Set tI=1
	Set tPtrI=0 While $ListNext(pList,tPtrI,tElemI) {
		Set tArr(tElemI_tI)=$Length(tI)
		Set tI=tI+1
	}
	
	Set tResult=""
	Set tKey="" While 1 {
		Set tKey=$Order(tArr(tKey),+1,tLen) If tKey="" {Quit}
		Set tResult=tResult_$ListBuild($Extract(tKey,1,*-tLen))
	}
	
	Quit tResult
}

/// Add a node to the given abstract graph
Method AddNodeToGraph(pAbstractGraph As AbstractGraph, pCLI As %Integer) As %String [ Private ]
{
	Set tName=..ShowCLI(pCLI)
	Do pAbstractGraph.SetNode(tName,..CountedLines.GetAt(pCLI))
	Quit tName
}

/// Return the given string truncated if necessary to the given limit, with trailing "..."
ClassMethod Truncate(pString As %String, pLimit As %Integer) As %String [ CodeMode = expression, Private ]
{
$Select($Length(pString)>pLimit:$Extract(pString,1,pLimit-3)_"...",1:pString)
}

}
