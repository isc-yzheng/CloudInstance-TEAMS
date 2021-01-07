/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeIf Extends CodeItem
{

Property Condition As %String(MAXLEN = "");

Property True As list Of CodeItem(STORAGEDEFAULT = "array");

Property False As list Of CodeItem(STORAGEDEFAULT = "array");

Storage Default
{
<Data name="CodeIfDefaultData">
<Subscript>"CodeIf"</Subscript>
<Value name="1">
<Value>Condition</Value>
</Value>
</Data>
<Data name="False">
<Attribute>False</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.InteropTools.CodeBuilder.CodeIf.False"</Subscript>
</Data>
<Data name="True">
<Attribute>True</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.InteropTools.CodeBuilder.CodeIf.True"</Subscript>
</Data>
<DefaultData>CodeIfDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
