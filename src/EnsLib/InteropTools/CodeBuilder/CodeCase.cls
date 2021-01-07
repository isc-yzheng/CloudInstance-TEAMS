/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeCase Extends CodeItem
{

Property Condition As %String(MAXLEN = "");

Property Statements As list Of CodeItem(STORAGEDEFAULT = "array");

Storage Default
{
<Data name="CaseDefaultData">
<Subscript>"Case"</Subscript>
<Value name="1">
<Value>Condition</Value>
</Value>
</Data>
<Data name="Statements">
<Attribute>Statements</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.InteropTools.CodeBuilder.Case.Statements"</Subscript>
</Data>
<DefaultData>CaseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
