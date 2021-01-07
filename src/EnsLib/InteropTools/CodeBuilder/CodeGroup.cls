/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeGroup Extends CodeItem
{

Property Items As list Of CodeItem(STORAGEDEFAULT = "array");

Storage Default
{
<Data name="Items">
<Attribute>Items</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.InteropTools.CodeBuilder.CodeGroup.Items"</Subscript>
</Data>
<Type>%Storage.Persistent</Type>
}

}
