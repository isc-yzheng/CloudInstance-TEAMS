/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// The simple class passed to content based business rules
Class EnsLib.ITK.Framework.ContentContext Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/// The service
Property Service As %String;

/// The distribution envelope (without payload)
Property Envelope As EnsLib.EDI.XML.Document;

/// The core payload
/// FUTURE: This may become more generic to support different types of content
Property Content As EnsLib.EDI.XML.Document;

Storage Default
{
<Data name="ContentContextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Service</Value>
</Value>
<Value name="3">
<Value>Envelope</Value>
</Value>
<Value name="4">
<Value>Content</Value>
</Value>
</Data>
<DataLocation>^EnsLib.ITK3D2E.ContentContextD</DataLocation>
<DefaultData>ContentContextDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.ITK3D2E.ContentContextD</IdLocation>
<IndexLocation>^EnsLib.ITK3D2E.ContentContextI</IndexLocation>
<StreamLocation>^EnsLib.ITK3D2E.ContentContextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
