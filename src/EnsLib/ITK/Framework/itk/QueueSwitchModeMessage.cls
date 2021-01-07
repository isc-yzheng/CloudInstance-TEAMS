/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// SwitchQueueMode messagecontent.
Class EnsLib.ITK.Framework.itk.QueueSwitchModeMessage Extends (%Persistent, %XML.Adaptor) [ CompileAfter = , ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: SwitchQueueMode messagecontent. 
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "urn:intersystems-itk:ns:201101";

Parameter XMLNAME = "QueueSwitchMode";

Parameter XMLSEQUENCE = 1;

Property QueueName As %String(MAXLEN = "", XMLNAME = "QueueName") [ Required ];

Property QueueMode As %Boolean(XMLNAME = "QueueMode", XMLPROJECTION = "ELEMENT") [ Required ];

Property any As %XML.String(XMLNAME = "any", XMLPROJECTION = "ANY") [ SqlFieldName = _any ];

Storage Default
{
<Data name="QueueSwitchModeMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueueName</Value>
</Value>
<Value name="3">
<Value>QueueMode</Value>
</Value>
<Value name="4">
<Value>any</Value>
</Value>
</Data>
<DataLocation>^EnsITK.QSwitchModeMsgD</DataLocation>
<DefaultData>QueueSwitchModeMessageDefaultData</DefaultData>
<IdLocation>^EnsITK.QSwitchModeMsgD</IdLocation>
<IndexLocation>^EnsITK.QSwitchModeMsgI</IndexLocation>
<StreamLocation>^EnsITK.QSwitchModeMsgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
