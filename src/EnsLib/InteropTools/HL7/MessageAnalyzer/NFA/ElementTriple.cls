/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.ElementTriple Extends %RegisteredObject [ Final ]
{

Property In As ElementBase [ ReadOnly ];

Property Succ As ElementBase [ Private ];

Property Fail As ElementBase [ Private ];

Method %OnNew(pIn As ElementBase, pSucc As ElementBase, pFail As ElementBase) As %Status
{
	Set i%In=pIn
	Set ..Succ=pSucc
	Set ..Fail=pFail
	
	Quit $$$OK
}

Method SetNextLinks(pSucc As %String, pFail As %String)
{
	If ..In=..Succ,..Succ=..Fail {
		Do ..In.SetNext(pSucc,pFail)
	}

	Else {
		If ..Succ'="" {
			Do ..Succ.SetNext(pSucc,"")
		}
		If ..Fail'="" {
			Do ..Fail.SetNext(pFail,"")
		}
	}
}

Method Show() As %String [ CodeMode = expression ]
{
"Triple["_..ShowElement(..In)_", "_..ShowElement(..Succ)_", "_..ShowElement(..Fail)_"]"
}

ClassMethod ShowElement(pElement As ElementBase) As %String [ CodeMode = expression, Private ]
{
$Select(pElement="":"*",1:pElement.Show())
}

}
