/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// /// DTS XML Class to represent DTS Canonical Message Structure
Class EnsLib.ITK.DTS.Framework.Message Extends Ens.Request [ System = 4 ]
{

Property DTSControlFile As EnsLib.ITK.DTS.Framework.ControlFile;

Property DTSDataFile As %GlobalCharacterStream;

Property SiteId As %Library.String;

Property AppName As %Library.String;

Property SequenceNo As %Library.String;

Storage Default
{
<Data name="MessageDefaultData">
<Subscript>"Message"</Subscript>
<Value name="1">
<Value>DTSControlFile</Value>
</Value>
<Value name="2">
<Value>DTSDataFile</Value>
</Value>
<Value name="3">
<Value>SiteId</Value>
</Value>
<Value name="4">
<Value>AppName</Value>
</Value>
<Value name="5">
<Value>SequenceNo</Value>
</Value>
</Data>
<DefaultData>MessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
