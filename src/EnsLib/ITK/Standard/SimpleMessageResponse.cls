/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Standard.SimpleMessageResponse Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$
   
Update history:
2010-08-15 	RobertHickingbotham  Corrected namespace
******************************************************************************/
Property Response As %String(MAXLEN = "", XMLPROJECTION = "CONTENT") [ InitialExpression = "OK" ];

Parameter XMLPREFIX As STRING = "itk";

Parameter XMLNAME = "SimpleMessageResponse";

Parameter NAMESPACE As STRING = "urn:nhs-itk:ns:201005";

Storage Default
{
<Data name="SimpleMessageResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Response</Value>
</Value>
</Data>
<DataLocation>^EnsITK.Std.SimpleMsgRspD</DataLocation>
<DefaultData>SimpleMessageResponseDefaultData</DefaultData>
<IdLocation>^EnsITK.Std.SimpleMsgRspD</IdLocation>
<IndexLocation>^EnsITK.Std.SimpleMsgRspI</IndexLocation>
<StreamLocation>^EnsITK.Std.SimpleMsgRspS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
