/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This is just a benchmark class for comparing operations on a list against copying the list and performing the operations on an array
Class EnsLib.InteropTools.HL7.MessageAnalyzer.LoopTest Extends %RegisteredObject
{

ClassMethod Test(pStyle As %String)
{
	Set tLoopCount=..TestLoopCount()
	Set tList=..TestList()
	
	If pStyle="COPY" {
		Set tStart=$ZH
		For tI=1:1:tLoopCount {
			Do ..Test1Copy(tList)
		}
		Set tEnd=$ZH
	}
	Else {
		Set tStart=$ZH
		For tI=1:1:tLoopCount {
			Do ..Test1Direct(tList)
		}
		Set tEnd=$ZH
	}
	Set tElapsed=tEnd-tStart
	
	Write pStyle,": ",tElapsed,!
}

ClassMethod Test1Copy(pList As %List)
{
	Kill tArr
	Set tPtr=0 While $ListNext(pList,tPtr,tElem) {
		Set tArr($I(tArr))=tElem
	}
	
	Set tLen=$ListLength(pList)
	Set tIter=tLen*3
	For tI=1:1:tIter {
		Set tDummy=tArr($Random(tLen)+1)
	}
}

ClassMethod Test1Direct(pList As %List)
{
	Set tLen=$ListLength(pList)
	Set tIter=tLen*3
	For tI=1:1:tIter {
		Set tDummy=$List(pList,$Random(tLen)+1)
	}
}

ClassMethod TestList() As %List
{
	Set tOut=""
	For tI=1:1:100 {
		Set tOut=tOut_$ListBuild("A"_$Extract(99+tI,2,3))
	}
	
	Quit tOut
}

ClassMethod TestLoopCount() As %Integer [ CodeMode = expression ]
{
100000
}

}
