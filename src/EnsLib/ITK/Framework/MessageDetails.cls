/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Copied, for code control purposes from: c:/temp/xsd/queuecollectionmessagetypes-2010-05.xsd
/// MessagePayload becomes %GlobalCharacterStream
Class EnsLib.ITK.Framework.MessageDetails Extends (%Persistent, %XML.Adaptor) [ CompileAfter = , ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: Copied, for code control purposes, from a class created from: c:/temp/xsd/itkdatatypes-2010-05.xsd
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "urn:nhs-itk:ns:201005";

Parameter XMLNAME = "MessageDetails";

Parameter XMLSEQUENCE = 1;

Property ServiceMessageType As %String(MAXLEN = "", XMLNAME = "ServiceMessageType") [ Required ];

Property MessageHandle As %String(MAXLEN = "", XMLNAME = "MessageHandle") [ Required ];

Property RelatesTo As %String(MAXLEN = "", XMLNAME = "RelatesTo");

Property MessagePayload As %XML.GlobalCharacterStream(XMLNAME = "MessagePayload") [ Required ];

Property any As %XML.String(XMLNAME = "any", XMLPROJECTION = "ANY") [ SqlFieldName = _any ];

Storage Default
{
<Data name="MessageDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceMessageType</Value>
</Value>
<Value name="3">
<Value>MessageHandle</Value>
</Value>
<Value name="4">
<Value>RelatesTo</Value>
</Value>
<Value name="5">
<Value>MessagePayload</Value>
</Value>
<Value name="6">
<Value>any</Value>
</Value>
</Data>
<DataLocation>^EnsITK.MessageDetailsD</DataLocation>
<DefaultData>MessageDetailsDefaultData</DefaultData>
<IdLocation>^EnsITK.MessageDetailsD</IdLocation>
<IndexLocation>^EnsITK.MessageDetailsI</IndexLocation>
<StreamLocation>^EnsITK.MessageDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
