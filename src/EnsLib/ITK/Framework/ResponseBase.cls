/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Base class for all ITK Responses
Class EnsLib.ITK.Framework.ResponseBase Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

Parameter SrcVer = "$Id$";

/// Holds the ID of the original message we are responding to
Property MessageId As %String(MAXLEN = "");

/// Holds the Body of the response
Property ResponseBody As %Stream.GlobalCharacter;

/// Holds the internal status of this response
Property Status As %Status;

Index ResponseDataBaseU1 On MessageId [ Unique ];

Storage Default
{
<Data name="ResponseBaseDefaultData">
<Subscript>"ResponseBase"</Subscript>
<Value name="1">
<Value>MessageId</Value>
</Value>
<Value name="2">
<Value>ResponseBody</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EnsLib.ITK.Fr3D2E.ResponseBaseD</DataLocation>
<DefaultData>ResponseBaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.ITK.Fr3D2E.ResponseBaseD</IdLocation>
<IndexLocation>^EnsLib.ITK.Fr3D2E.ResponseBaseI</IndexLocation>
<StreamLocation>^EnsLib.ITK.Fr3D2E.ResponseBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
