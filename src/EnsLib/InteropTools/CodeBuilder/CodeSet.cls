/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeSet Extends CodeItem
{

Property Variable As %String(MAXLEN = "");

Property Value As %String(MAXLEN = "");

Property Action As %String;

Storage Default
{
<Data name="CodeSetDefaultData">
<Subscript>"CodeSet"</Subscript>
<Value name="1">
<Value>Variable</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
<Value name="3">
<Value>Action</Value>
</Value>
</Data>
<DefaultData>CodeSetDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
