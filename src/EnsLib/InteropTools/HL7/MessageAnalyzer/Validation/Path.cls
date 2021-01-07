/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Path Extends %RegisteredObject
{

/// PathDict(KIND:NAME) = $ListBuild(COPIED,UPDATEDREF)
Property PathDict As array Of %List [ Private ];

/// Order(N)=KIND:NAME
Property Order As list Of %String [ Private ];

Method AddToPath(pKind As %String, pName As %String)
{
	Set tKey=pKind_":"_pName
	If ..PathDict.IsDefined(tKey) {ZTrap}
	
	$$$THROWONERROR(tSC,..PathDict.SetAt($ListBuild(0,0),tKey))
	$$$THROWONERROR(tSC,..Order.Insert(tKey))
}

Method SetCopied(pKind As %String, pName As %String)
{
	Do ..Set(pKind,pName,1)
}

Method SetUpdatedRef(pKind As %String, pName As %String)
{
	Do ..Set(pKind,pName,2)
}

Method PathRepr() As %String
{
	Set tOut=""
	For tI=1:1:..Order.Count() {
		Set tKey=..Order.GetAt(tI)
		Set tName=$Piece(tKey,":",2)
		Set $ListBuild(tCopied,tUpdatedRef)=..PathDict.GetAt(tKey)
		Set tCopiedMark=$Select(tCopied:"+",1:"")
		Set tUpdatedRefMark=$Select(tUpdatedRef:"*",1:"")
		Set tOut=tOut_tName_tCopiedMark
		If tI'=..Order.Count() {
			Set tOut=tOut_" -"_tUpdatedRefMark_"-> "
		}
	}
	
	Quit "Path: "_tOut
}

ClassMethod Documentation() As %String [ CodeMode = expression ]
{
"a '+' means that the item was copied to the custom schema; a '*' means that the given reference was updated"
}

Method Set(pKind As %String, pName As %String, pListIndex As %Integer) [ Private ]
{
	Set tKey=pKind_":"_pName
	If '..PathDict.IsDefined(tKey) {ZTrap}
	
	Set tPair=..PathDict.GetAt(tKey)
	$$$ACASSERT('$List(tPair,pListIndex),"SetCopied/SetUpdatedRef: already set")
	Set $List(tPair,pListIndex)=1
	$$$THROWONERROR(tSC,..PathDict.SetAt(tPair,tKey))
}

}
