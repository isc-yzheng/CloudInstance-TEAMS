/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeTrueFalse Extends CodeItem
{

/// t or f
Property State As %String;

Storage Default
{
<Data name="CodeTrueFalseDefaultData">
<Subscript>"CodeTrueFalse"</Subscript>
<Value name="1">
<Value>State</Value>
</Value>
</Data>
<DefaultData>CodeTrueFalseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
