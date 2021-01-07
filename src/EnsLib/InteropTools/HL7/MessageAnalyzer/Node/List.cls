/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Node.List Extends EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Base
{

Property Nodes As list Of Base [ Private ];

Method Add(pNode As Base)
{
	Do ..Nodes.Insert(pNode)
}

Method GenerateElement(pMachine As Machine, ByRef pGenerateContext, pHierarchy As %List) As ElementTriple
{
	#Dim tItems,tI,tContextKey,tProgressVar
	#Dim tHierarchy,tFinalItemSucc,tItemFail,tItemSucc As %List
	#Dim tIn As NoteProgress
	#Dim tTriple As ElementTriple
	#Dim tFinalSuccess As LinkElement
	#Dim tFinalFailure As BacktrackElement
	
	Set tHierarchy=pHierarchy_$ListBuild(..DigraphLabel())

	// the item nodes
	Kill tItems
	Do ..GetChildren(.tItems)
	
	// the entry and failure-exit nodes
	Set tContextKey="List.Backtrack"
	Set tProgressVar=tContextKey_$I(pGenerateContext(tContextKey))
	Set tIn=##class(NoteProgress).%New(pMachine,tProgressVar,tHierarchy,..SourceOffset)
	Set tFinalFailure=##class(BacktrackElement).%New(pMachine,tProgressVar,tHierarchy,..SourceOffset)
	Set tItemFail=$ListBuild(tFinalFailure.ElementName)
		
	// generate element triple from each item node
	For tI=1:1:$Get(tItems) {
		Set tTriple(tI)=tItems(tI).GenerateElement(pMachine,.pGenerateContext,tHierarchy)
	}
	
	// final success
	Set tFinalSuccess=##class(LinkElement).%New(pMachine,"",$ListBuild(..DigraphLabel()_" Success"),..SourceOffset)
	Set tFinalItemSucc=$ListBuild(tFinalSuccess.ElementName)
	
	// point the entry node to the first item
	Do tIn.SetNext($ListBuild(tTriple(1).In.ElementName),"")
	
	// point each item but the last to the one which follows it
	For tI=1:1:$Get(tItems)-1 {
		Set tItemSucc=$ListBuild(tTriple(tI+1).In.ElementName)
		Do tTriple(tI).SetNextLinks(tItemSucc,tItemFail)
	}
	
	// point the last item to the final success
	Do tTriple($Get(tItems)).SetNextLinks(tFinalItemSucc,tItemFail)
	
	Quit ##class(ElementTriple).%New(tIn,tFinalSuccess,tFinalFailure)
}

Method OptimizedPattern() As %String
{
	Set tNodeCount=..Nodes.Count()
	Kill tArr // tArr(1..tArr)=CHILDPATTERN
	For tI=1:1:tNodeCount {
		Set tThis=..Nodes.GetAt(tI).OptimizedPattern()
		Set tArr($I(tArr))=tThis
	}
	
	Set tOut=""
	Set tI=1 While tI<=$Get(tArr) {
		
		Set tThis=tArr(tI)
		Set tI=tI+1
		
		Set tToWrite=tThis
		If tI<=tArr {

			Set tNext=tArr(tI)
			
			// if the patterns aren't the same as-given, but are equal when the outer [..] and {..} are removed ,,
			Set tThisBase=$ZStrip(tThis,"<>","[]{}")
			Set tNextBase=$ZStrip(tNext,"<>","[]{}")
			If tThis'=tNext,tThisBase=tNextBase {
			
				Set tI=tI+1
				
				Set tThisType=$$type(tThis)
				Set tNextType=$$type(tNext)
				
				// if either is undecorated or is a repeat ..
				If (tThisType="") || (tNextType="") || (tThisType="R") || (tNextType="R") {
					Set tToWrite="{"_tThisBase_"}"
				}
				
				// .. anything else ..
				Else {
					Set tToWrite="[{"_tThisBase_"}]"
				}								
			}
		}
		
		Set tOut=tOut_$ListBuild(tToWrite)
	}
	
	Quit $ListToString(tOut)
	
type(pattern)
	If $Extract(pattern,1,2)="[{" {Quit "OR"}
	Quit $Case($Extract(pattern),"[":"O","{":"R",:"")
}

Method Pattern() As %String
{
	Set tTopCount=..Nodes.Count()
	Set tOut=""
	For tI=1:1:tTopCount {
		Set tOut=tOut_$ListBuild(..Nodes.GetAt(tI).Pattern())
	}
	
	Quit $ListToString(tOut)
}

Method BuildDeriveTree(pTreeBuilder As TreeBuilder) As %Integer
{
	Kill tChildren
	Do ..GetChildren(.tChildren)
	Quit pTreeBuilder.WriteStructure($$$STYPE,.tChildren)
}

Method PatternAlternatives(Output pAlternatives) As %String
{
	$$$SHOULDBEUNDEF(pAlternatives)

	Kill tPrefixes
	Set tBase=""
	Set tTopCount=..Nodes.Count()
	For tI=1:1:tTopCount {
		Kill tThesePrefixes
		Set tAlt=..PatternAlternativesForNode(..Nodes.GetAt(tI),.tThesePrefixes)
		If tAlt'="" {
			Set tBase=tBase_$ListBuild(tAlt)
		}
		Merge tPrefixes(tI)=tThesePrefixes
	}
	
	For tI=1:1:tTopCount {
	
		Set tCommonPrefix=$ListToString($List(tBase,1,tI-1))
		If tCommonPrefix'="" {
			Set tCommonPrefix=tCommonPrefix_","
		}

		Set tCommonSuffix=$ListToString($List(tBase,tI+1,*))
		If tCommonSuffix'="" {
			Set tCommonSuffix=","_tCommonSuffix
		}
		
		Set tK="" While 1 {
			Set tK=$Order(tPrefixes(tI,tK),+1,tOnePrefix) If tK="" {Quit}
			
			If tOnePrefix="" {
				If tCommonPrefix="" {
					Set pAlternatives($I(pAlternatives))=$Extract(tCommonSuffix,2,*)
				}
				ElseIf tCommonSuffix="" {
					Set pAlternatives($I(pAlternatives))=$Extract(tCommonPrefix,1,*-1)
				}
				Else {
					Set pAlternatives($I(pAlternatives))=tCommonPrefix_$Extract(tCommonSuffix,2,*)
				}
			}
			Else {
				Set pAlternatives($I(pAlternatives))=tCommonPrefix_tOnePrefix_tCommonSuffix
			}
		}
	}
	
	Quit $ListToString(tBase)
}

Method Wrapper() As %List [ CodeMode = expression ]
{
$ListBuild("","")
}

Method Label() As %String [ CodeMode = expression ]
{
""
}

Method TypeCode() As %String [ CodeMode = expression ]
{
"L"
}

Method GetChildren(ByRef pChildren)
{
	#Dim tI
	
	For tI=1:1:..Nodes.Count() {
		Set pChildren($I(pChildren))=..Nodes.GetAt(tI)
	}
}

Method MatchesEmpty() As %Boolean
{
	#Dim tChildren,tI
	
	Kill tChildren
	Do ..GetChildren(.tChildren)
	For tI=1:1:$Get(tChildren) {
		If 'tChildren(tI).MatchesEmpty() {
			Return 0
		}
	}
	
	Quit 1
}

ClassMethod PatternAlternativesForNode(pNode As Base, ByRef pPrefixes) As %String [ Private ]
{
	Kill tNodeAlternatives
	Set tBase=pNode.PatternAlternatives(.tNodeAlternatives)
	
	If '$Get(pPrefixes) {
		Set pPrefixes($I(pPrefixes))=""
	}
	
	Set tStartIndex=$Order(pPrefixes(""))
	Set tEndIndex=pPrefixes
	For tI=tStartIndex:1:tEndIndex {
		Set tBasePrefix=pPrefixes(tI)
		Kill pPrefixes(tI)
		For tJ=1:1:tNodeAlternatives {
			Set tAlt=tNodeAlternatives(tJ)
			If tAlt="" {
				Set pPrefixes($I(pPrefixes))=tBasePrefix
			}
			ElseIf tBasePrefix="" {
				Set pPrefixes($I(pPrefixes))=tAlt
			}
			Else {
				Set pPrefixes($I(pPrefixes))=tBasePrefix_","_tAlt
			} 
		}
	}
	
	Quit tBase
}

}
