/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.CodeBuilder.CodeCaseDefault Extends CodeItem
{

Property Statements As list Of CodeItem(STORAGEDEFAULT = "array");

Storage Default
{
<Data name="Statements">
<Attribute>Statements</Attribute>
<Structure>subnode</Structure>
<Subscript>"EnsLib.InteropTools.CodeBuilder.CodeCaseDefault.Statements"</Subscript>
</Data>
<Type>%Storage.Persistent</Type>
}

}
