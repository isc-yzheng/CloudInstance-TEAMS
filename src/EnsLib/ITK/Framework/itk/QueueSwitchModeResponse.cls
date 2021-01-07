/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// SwitchQueueMode message response content.
Class EnsLib.ITK.Framework.itk.QueueSwitchModeResponse Extends (%Persistent, %XML.Adaptor) [ CompileAfter = , ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: SwitchQueueMode message response content. 
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "urn:intersystems-itk:ns:201101";

Parameter XMLNAME = "QueueSwitchModeResponse";

Parameter XMLSEQUENCE = 1;

Property QueueMode As %Boolean(XMLNAME = "QueueMode", XMLPROJECTION = "ELEMENT") [ Required ];

Property MessageCount As %Integer(XMLNAME = "MessageCount") [ Required ];

Property MessageHandle As list Of %String(MAXLEN = "", XMLNAME = "MessageHandle", XMLPROJECTION = "ELEMENT") [ Required ];

Property any As %XML.String(XMLNAME = "any", XMLPROJECTION = "ANY") [ SqlFieldName = _any ];

Storage Default
{
<Data name="QueueSwitchModeResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueueMode</Value>
</Value>
<Value name="3">
<Value>MessageCount</Value>
</Value>
<Value name="4">
<Value>MessageHandle</Value>
</Value>
<Value name="5">
<Value>any</Value>
</Value>
</Data>
<DataLocation>^EnsITK.QSwitchModeRspD</DataLocation>
<DefaultData>QueueSwitchModeResponseDefaultData</DefaultData>
<IdLocation>^EnsITK.QSwitchModeRspD</IdLocation>
<IndexLocation>^EnsITK.QSwitchModeRspI</IndexLocation>
<StreamLocation>^EnsITK.QSwitchModeRspS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
