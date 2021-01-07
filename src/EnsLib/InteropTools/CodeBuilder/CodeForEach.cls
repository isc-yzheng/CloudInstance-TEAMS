/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeForEach Extends CodeItem
{

Property Property As %String(MAXLEN = "");

Property Variable As %String(MAXLEN = "");

Property Lines As list Of CodeItem(STORAGEDEFAULT = "array");

Storage Default
{
<Data name="CodeForEachDefaultData">
<Subscript>"CodeForEach"</Subscript>
<Value name="1">
<Value>Variable</Value>
</Value>
<Value name="2">
<Value>Property</Value>
</Value>
</Data>
<Data name="Lines">
<Attribute>Lines</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.InteropTools.CodeBuilder.CodeForEach.Lines"</Subscript>
</Data>
<DefaultData>CodeForEachDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
