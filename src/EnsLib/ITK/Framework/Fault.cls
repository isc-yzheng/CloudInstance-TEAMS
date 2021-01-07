/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Internal representation of an ITK SOAP fault
Class EnsLib.ITK.Framework.Fault Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Parameter SrcVer = "$Id$";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property faultcode As %String(MAXLEN = "");

Property faultstring As %String(MAXLEN = "");

Property faultactor As %String(MAXLEN = "");

/// XML element that gives error details.
/// The contents of detail will not be escaped.
Property detail As EnsLib.ITK.Framework.ToolkitErrorInfoStruct;

}
