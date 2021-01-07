/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Choice Extends EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Base
{

/// a List node
Property ChoiceBody As Base [ Private ];

Method %OnNew(pChoiceBody As Base) As %Status
{
	Set ..ChoiceBody = pChoiceBody
	Quit $$$OK
}

Method GenerateElement(pMachine As Machine, ByRef pGenerateContext, pHierarchy As %List) As ElementTriple
{
	#Dim tChoices,tI
	#Dim tHierarchy,tChoiceSucc,tChoiceFail,tChoiceNames As %List
	#Dim tIn As ChoiceElement
	#Dim tFinalSuccess As LinkElement
	#Dim tFinalFailure As CountedFailureElement
	#Dim tTriple As ElementTriple
	
	Set tHierarchy=pHierarchy_$ListBuild(..DigraphLabel())
	
	// entry element
	Set tIn=##class(ChoiceElement).%New(pMachine,"",$ListBuild(..DigraphLabel()_" In"),..SourceOffset)
	
	// the choice nodes
	Kill tChoices
	Do ..ChoiceBody.GetChildren(.tChoices)
	
	// final success
	Set tFinalSuccess=##class(LinkElement).%New(pMachine,"",$ListBuild(..DigraphLabel()_" Success"),..SourceOffset)
	Set tChoiceSucc=$ListBuild(tFinalSuccess.ElementName)
	
	// final failure
	Set tFinalFailure=##class(CountedFailureElement).%New(pMachine,$Get(tChoices),$ListBuild(..DigraphLabel()_" CountedFailure"),..SourceOffset) // the second constructor argument is the number of failures to consider an overall failure
	Set tChoiceFail=$ListBuild(tFinalFailure.ElementName)
	
	// collect choice names and point each choice to the final success
	Set tChoiceNames=""
	For tI=1:1:$Get(tChoices) {
		Set tTriple=tChoices(tI).GenerateElement(pMachine,.pGenerateContext,tHierarchy)
		Set tChoiceNames=tChoiceNames_$ListBuild(tTriple.In.ElementName)
		Do tTriple.SetNextLinks(tChoiceSucc,tChoiceFail)
	}
	
	// point the entry element to all the choice elements
	Do tIn.SetNext(tChoiceNames,"")
	
	Quit ##class(ElementTriple).%New(tIn,tFinalSuccess,tFinalFailure)
}

Method OptimizedPattern() As %String
{
	// the choice nodes
	Kill tChoices
	Do ..ChoiceBody.GetChildren(.tChoices)
	
	Kill tArr // tArr(RAWHASH)=ITEM
	For tI=1:1:$Get(tChoices) {	
		Set tItem=tChoices(tI).OptimizedPattern()
		Set tItemHash=##class(Common).RawHash(tItem)
		Set tArr(tItemHash)=tItem
	}

	// Omit duplicates items in choice
	Set tOut=""
	Set tItemHash="" While 1 {

		Set tItemHash=$Order(tArr(tItemHash),+1,tItem) If tItemHash="" {Quit}
			
		// unless there's an entry with {..} around this entry ..
		Set tRepeatItemHash=##class(Common).RawHash("{"_tItem_"}")
		If '$Data(tArr(tRepeatItemHash)) {
			Set tOut=tOut_$ListBuild(tItem)
		}
	}
	
	If $ListLength(tOut)=1 {
		Quit $List(tOut)
	}
	Else {
		Quit "<"_$ListToString(tOut,"|")_">"
	}
}

Method Pattern() As %String
{
	// the choice nodes
	Kill tChoices
	Do ..ChoiceBody.GetChildren(.tChoices)

	Set tOut=""
	For tI=1:1:$Get(tChoices) {
		Set tOut=tOut_$ListBuild(tChoices(tI).Pattern())
	}
	
	Quit "<"_$ListToString(tOut,"|")_">"
}

Method BuildDeriveTree(pTreeBuilder As TreeBuilder) As %Integer
{
	Kill tChildren
	Do ..ChoiceBody.GetChildren(.tChildren)
	Quit pTreeBuilder.WriteStructure($$$CTYPE,.tChildren)
}

Method PatternAlternatives(Output pAlternatives) As %String
{
	$$$SHOULDBEUNDEF(pAlternatives)
	
	// the choice nodes
	Kill tChoices
	Do ..ChoiceBody.GetChildren(.tChoices)
	
	Set tBase=""
	For tI=1:1:$Get(tChoices) {
		Kill tChoiceAlternatives
		Set tBase=tBase_$ListBuild(tChoices(tI).PatternAlternatives(.tChoiceAlternatives))
		For tJ=1:1:tChoiceAlternatives {
			Set pAlternatives($I(pAlternatives))=tChoiceAlternatives(tJ)
		}
	}
	
	Quit "<"_$ListToString(tBase,"|")_">"
}

Method Label() As %String [ CodeMode = expression ]
{
"CHOICE"
}

Method TypeCode() As %String [ CodeMode = expression ]
{
"C"
}

Method GetChildren(ByRef pChildren)
{
	Set pChildren($I(pChildren))=..ChoiceBody
}

Method MatchesEmpty() As %Boolean
{
	#Dim tChildren,tI
	
	Kill tChildren
	Do ..GetChildren(.tChildren)
	For tI=1:1:$Get(tChildren) {
		If tChildren(tI).MatchesEmpty() {
			Return 1
		}
	}
	
	Quit 0
}

}
