/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeSwitch Extends CodeItem
{

Property Cases As list Of CodeCase;

Storage Default
{
<Data name="CodeSwitchDefaultData">
<Subscript>"CodeSwitch"</Subscript>
<Value name="1">
<Value>Cases</Value>
</Value>
</Data>
<DefaultData>CodeSwitchDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
