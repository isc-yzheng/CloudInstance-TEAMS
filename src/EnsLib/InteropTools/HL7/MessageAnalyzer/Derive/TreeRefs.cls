/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TreeRefs Extends %RegisteredObject
{

Property Refs As list Of %Integer [ Private ];

Method AddRef(pRefValue As %Integer) As %Integer
{
	Do ..Refs.Insert(pRefValue)
	Quit ..Refs.Count()
}

Method GetRef(pRefIndex As %Integer) As %Integer [ CodeMode = expression ]
{
..Refs.GetAt(pRefIndex)
}

Method ChangeRefs(pOldIndex As %Integer, pNewIndex As %Integer)
{
	For tI=1:1:..Refs.Count() {
		If ..Refs.GetAt(tI)=pOldIndex {
			$$$THROWONERROR(tSC,..Refs.SetAt(pNewIndex,tI))
		}
	}
}

}
