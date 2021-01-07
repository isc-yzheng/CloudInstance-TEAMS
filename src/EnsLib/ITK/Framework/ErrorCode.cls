/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.ITK.Framework.ErrorCode Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, ProcedureBlock, System = 4 ]
{

/// Copied, for code control purposes, from a class created from: c:/temp/xsd/itkdatatypes-2010-05.xsd
Parameter SrcVer = "$Id$";

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "urn:nhs-itk:ns:201005";

Parameter XMLNAME = "ErrorCode";

Parameter XMLSEQUENCE = 1;

Property content As %String(MAXLEN = "", XMLNAME = "content", XMLPROJECTION = "CONTENT");

Property codeSystem As %String(MAXLEN = "", XMLNAME = "codeSystem", XMLPROJECTION = "ATTRIBUTE");

Storage Default
{
<Data name="ErrorCodeState">
<Value name="1">
<Value>content</Value>
</Value>
<Value name="2">
<Value>codeSystem</Value>
</Value>
</Data>
<State>ErrorCodeState</State>
<StreamLocation>^EnsITK.ErrorCodeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
