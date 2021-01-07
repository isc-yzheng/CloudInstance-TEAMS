/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Base class for all ITK Requests
Class EnsLib.ITK.Framework.RequestBase Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

Parameter SrcVer = "$Id$";

/// Holds the name of the service
Property ServiceName As %String(MAXLEN = "");

Method ModifyAction(ByRef action As %String, behaviourType As %String) As %Status
{
	Quit $$$OK
}

Storage Default
{
<Data name="RequestBaseDefaultData">
<Subscript>"RequestBase"</Subscript>
<Value name="1">
<Value>ServiceName</Value>
</Value>
<Value name="2">
<Value>Sender</Value>
</Value>
<Value name="3">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EnsLib.ITK.Fra3D2E.RequestBaseD</DataLocation>
<DefaultData>RequestBaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.ITK.Fra3D2E.RequestBaseD</IdLocation>
<IndexLocation>^EnsLib.ITK.Fra3D2E.RequestBaseI</IndexLocation>
<StreamLocation>^EnsLib.ITK.Fra3D2E.RequestBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
