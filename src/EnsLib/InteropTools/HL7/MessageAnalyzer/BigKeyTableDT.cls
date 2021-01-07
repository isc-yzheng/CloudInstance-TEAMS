/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// An associative store which allows keys of any length
Class EnsLib.InteropTools.HL7.MessageAnalyzer.BigKeyTableDT Extends %RegisteredObject
{

/// Table(HASH)=VALUE
Property Table As array Of %DataType [ Private ];

/// KeyLookup(HASH)=KEY
Property KeyLookup As array Of %String [ Private ];

/// Cached table count - invalidated (set to -1) when the table is changed
Property CachedTableCount As %Integer [ InitialExpression = -1, Private ];

Method GetAt(pKey As %String) As %String [ CodeMode = expression ]
{
..Table.GetAt(..KeyToHash(pKey))
}

Method GetAtHash(pHash As %String) As %String [ CodeMode = expression ]
{
..Table.GetAt(pHash)
}

Method SetAt(pValue As %RegisteredObject, pKey As %String)
{
	Set tHash=..KeyToHash(pKey)
	$$$THROWONERROR(tSC,..Table.SetAt(pValue,tHash))
	Set ..CachedTableCount=-1
	$$$THROWONERROR(tSC,..KeyLookup.SetAt(pKey,tHash))
}

Method RemoveAt(pKey As %String)
{
	Do ..Table.RemoveAt(..KeyToHash(pKey))
	Set ..CachedTableCount=-1
}

/// Does NOT return keys in order
Method Next(pKey As %String) As %String
{
	If pKey="" {
		Set tNextHash=..Table.Next("")
	}
	Else {
		Set tNextHash=..Table.Next(..KeyToHash(pKey))
	}
	
	If tNextHash="" {
		Quit ""
	}
	Else {
		Quit ..KeyLookup.GetAt(tNextHash)
	}
}

Method Count() As %Integer
{
	If ..CachedTableCount=-1 {
		Set ..CachedTableCount=..Table.Count()
	}
	
	Quit ..CachedTableCount
}

Method IsDefined(pKey As %String) As %String [ CodeMode = expression ]
{
..Table.IsDefined(..KeyToHash(pKey))
}

Method KeyToHash(pKey As %String) As %String [ CodeMode = expression ]
{
"Z"_##class(Common).Hash(pKey)
}

Method HashToKey(pKey As %String) As %String [ CodeMode = expression ]
{
..KeyLookup.GetAt(pKey)
}

}
