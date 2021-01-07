/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Name Extends EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Base
{

Property Qualifier As %String [ Private ];

Property Name As %String [ Private ];

Method %OnNew(pQualifier As %String = "", pName As %String) As %Status
{
	Set ..Qualifier=pQualifier
	Set ..Name = pName
	Quit $$$OK
}

Method GenerateElement(pMachine As Machine, ByRef pGenerateContext, pHierarchy As %List) As ElementTriple
{
	#Dim tHierarchy As %List
	#Dim tLeaf As LeafElement
	
	Set tHierarchy=pHierarchy_$ListBuild(..DigraphLabel())

	// leaf element
	Set tLeaf=##class(LeafElement).%New(pMachine,..Label(),tHierarchy,..SourceOffset)
	
	Quit ##class(ElementTriple).%New(tLeaf,tLeaf,tLeaf)
}

Method OptimizedPattern() As %String
{
	Quit ..Label()
}

Method Pattern() As %String [ CodeMode = expression ]
{
..Label()
}

Method BuildDeriveTree(pTreeBuilder As TreeBuilder) As %Integer
{
	ZTrap // structure nodes should handle this node without calling this method
}

Method LeafValue() As %String [ CodeMode = expression ]
{
..Label()
}

Method PatternAlternatives(Output pAlternatives) As %String
{
	$$$SHOULDBEUNDEF(pAlternatives)
	
	Set tLabel=..Label()
	Set pAlternatives($I(pAlternatives))=tLabel
	Quit tLabel
}

Method Label() As %String [ CodeMode = expression ]
{
$Select(
	..Qualifier="":..Name,
	1:..Qualifier_":"_..Name)
}

Method TypeCode() As %String [ CodeMode = expression ]
{
""
}

Method GetChildren(ByRef pChildren)
{
	// none
}

Method MatchesEmpty() As %Boolean [ CodeMode = expression ]
{
0
}

}
