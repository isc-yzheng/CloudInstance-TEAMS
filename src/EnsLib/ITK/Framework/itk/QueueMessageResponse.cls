/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Framework.itk.QueueMessageResponse Extends (%Persistent, %XML.Adaptor) [ CompileAfter = , ProcedureBlock, System = 4 ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "urn:nhs-itk:ns:201005";

Parameter XMLNAME = "QueueMessageResponse";

Parameter XMLSEQUENCE = 1;

Property MessageCount As %Integer(XMLNAME = "MessageCount") [ Required ];

Property Message As list Of EnsLib.ITK.Framework.MessageDetails(XMLNAME = "Message", XMLPROJECTION = "ELEMENT");

Property any As %XML.String(XMLNAME = "any", XMLPROJECTION = "ANY") [ SqlFieldName = _any ];

Storage Default
{
<Data name="QueueMessageResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessageCount</Value>
</Value>
<Value name="3">
<Value>Message</Value>
</Value>
<Value name="4">
<Value>any</Value>
</Value>
</Data>
<DataLocation>^EnsLib.ITK3F27.QueueMessag421ED</DataLocation>
<DefaultData>QueueMessageResponseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.ITK3F27.QueueMessag421ED</IdLocation>
<IndexLocation>^EnsLib.ITK3F27.QueueMessag421EI</IndexLocation>
<StreamLocation>^EnsLib.ITK3F27.QueueMessag421ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
