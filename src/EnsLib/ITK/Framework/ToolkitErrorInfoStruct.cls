/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Framework.ToolkitErrorInfoStruct Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/// Copied, for code control purposes, from a class created from: c:/temp/xsd/itkdatatypes-2010-05.xsd
Parameter SrcVer = "$Id$";

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "urn:nhs-itk:ns:201005";

Parameter XMLNAME = "ToolkitErrorInfoStruct";

Parameter XMLSEQUENCE = 1;

Property ErrorID As %String(MAXLEN = "", XMLNAME = "ErrorID") [ Required ];

Property ErrorCode As EnsLib.ITK.Framework.ErrorCode(XMLNAME = "ErrorCode") [ Required ];

Property ErrorText As %String(MAXLEN = "", XMLNAME = "ErrorText") [ Required ];

Property ErrorDiagnosticText As %String(MAXLEN = "", XMLNAME = "ErrorDiagnosticText");

Property any As %XML.String(XMLNAME = "any", XMLPROJECTION = "ANY") [ SqlFieldName = _any ];

Storage Default
{
<Data name="ToolkitErrorInfoStructDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ErrorID</Value>
</Value>
<Value name="3">
<Value>ErrorCode</Value>
</Value>
<Value name="4">
<Value>ErrorText</Value>
</Value>
<Value name="5">
<Value>ErrorDiagnosticText</Value>
</Value>
<Value name="6">
<Value>any</Value>
</Value>
</Data>
<DataLocation>^EnsITK.ToolkitErrorInfoStructD</DataLocation>
<DefaultData>ToolkitErrorInfoStructDefaultData</DefaultData>
<IdLocation>^EnsITK.ToolkitErrorInfoStructD</IdLocation>
<IndexLocation>^EnsITK.ToolkitErrorInfoStructI</IndexLocation>
<StreamLocation>^EnsITK.ToolkitErrorInfoStructS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
