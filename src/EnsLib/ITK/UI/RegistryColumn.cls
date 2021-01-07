/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This is used in the building of an ITK Registry
Class EnsLib.ITK.UI.RegistryColumn Extends %RegisteredObject [ System = 4 ]
{

/******************************************************************************
$Id$

Description: This is used in the building of an ITK Registry
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property DisplayName As %String(MAXLEN = "");

Property ClassProperty As %String(MAXLEN = "");

Property Required As %Boolean;

Property Key As %Boolean;

Property ValueList As %String;

Property DisplayList As %String;

Storage Default
{
<Data name="RegistryColumnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DisplayName</Value>
</Value>
<Value name="3">
<Value>ClassProperty</Value>
</Value>
<Value name="4">
<Value>Required</Value>
</Value>
<Value name="5">
<Value>Key</Value>
</Value>
<Value name="6">
<Value>ValueList</Value>
</Value>
<Value name="7">
<Value>DisplayList</Value>
</Value>
</Data>
<DataLocation>^EnsITK.UI.RegistryColumnD</DataLocation>
<DefaultData>RegistryColumnDefaultData</DefaultData>
<IdLocation>^EnsITK.UI.RegistryColumnD</IdLocation>
<IndexLocation>^EnsITK.UI.RegistryColumnI</IndexLocation>
<StreamLocation>^EnsITK.UI.RegistryColumnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
