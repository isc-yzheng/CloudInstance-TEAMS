/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeCOS Extends CodeItem
{

Property Lines As list Of %String(MAXLEN = "", STORAGEDEFAULT = "array");

Storage Default
{
<Data name="Lines">
<Attribute>Lines</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.InteropTools.CodeBuilder.CodeCOS.Lines"</Subscript>
</Data>
<Type>%Storage.Persistent</Type>
}

}
