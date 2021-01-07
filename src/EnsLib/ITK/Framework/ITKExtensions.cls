/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Internal representation of athe ITKExtensions SOAP header. 
Class EnsLib.ITK.Framework.ITKExtensions Extends %SOAP.Header [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Internal representation of athe ITKExtensions SOAP header. 
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Parameter NAMESPACE = "urn:intersystems-itk:ns:201101";

Parameter XMLNAME = "ITKExtensions";

Property Extension As list Of %String(MAXLEN = "", XMLNAME = "Extension", XMLPROJECTION = "ELEMENT") [ Required ];

}
