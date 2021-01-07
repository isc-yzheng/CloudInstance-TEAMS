/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeItem Extends %Persistent [ Abstract ]
{

Property Annotation As %String(MAXLEN = "");

Property Disabled As %Boolean [ InitialExpression = 0 ];

/// After the code has been completed this offers the ability to discard particular items by setting this boolean, versus trying to remove items from the collection
Property Discard As %Boolean [ InitialExpression = 0 ];

Storage Default
{
<Data name="CodeItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Annotation</Value>
</Value>
<Value name="3">
<Value>Disabled</Value>
</Value>
<Value name="4">
<Value>Discard</Value>
</Value>
</Data>
<DataLocation>^EnsLib.InteropToo2573.CodeItemD</DataLocation>
<DefaultData>CodeItemDefaultData</DefaultData>
<IdLocation>^EnsLib.InteropToo2573.CodeItemD</IdLocation>
<IndexLocation>^EnsLib.InteropToo2573.CodeItemI</IndexLocation>
<StreamLocation>^EnsLib.InteropToo2573.CodeItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
