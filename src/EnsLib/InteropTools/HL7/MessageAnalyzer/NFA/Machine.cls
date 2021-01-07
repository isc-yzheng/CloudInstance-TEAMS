/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Machine Extends %RegisteredObject
{

Property MachineArray As array Of ElementBase [ Private ];

Property MachineArrayCount As %Integer [ InitialExpression = 0, Private ];

Property NextSerial As %Integer [ InitialExpression = 1, Private ];

Method Count() As %Integer [ CodeMode = expression ]
{
..MachineArrayCount
}

Method CreatedCount() As %Integer [ CodeMode = expression ]
{
..NextSerial-1
}

/// Returns the key of the added element
Method SetAtWithSerial(pValue As ElementBase, pPrefix As %String) As %String
{
	Set tKey=..MakeKey($Get(pPrefix,pValue.%ClassName(0)))
	$$$THROWONERROR(tSC,..MachineArray.SetAt(pValue,tKey))
	Set ..MachineArrayCount=..MachineArrayCount+1
	
	Quit tKey
}

Method SetAt(pValue As ElementBase, pKey As %String)
{
	$$$THROWONERROR(tSC,..MachineArray.SetAt(pValue,pKey))
	Set ..MachineArrayCount=..MachineArrayCount+1
}

Method GetAt(pKey As %String) As ElementBase [ CodeMode = expression ]
{
..MachineArray.GetAt(pKey)
}

Method Next(pKey As %String) As %String [ CodeMode = expression ]
{
..MachineArray.Next(pKey)
}

Method IsDefined(pKey As %String) As %Boolean [ CodeMode = expression ]
{
..MachineArray.IsDefined(pKey)
}

Method RemoveAt(pKey As %String)
{
	Do ..MachineArray.RemoveAt(pKey)
	Set ..MachineArrayCount=..MachineArrayCount-1
}

Method MakeKey(pPrefix As %String) As %String
{
	Set tSerial=..NextSerial
	Set ..NextSerial=..NextSerial+1
	Quit pPrefix_"#"_$Extract("00000",1,*-$Length(tSerial))_tSerial
}

}
