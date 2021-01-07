/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// Generic Web Client used for all Web Requests. 
Class EnsLib.ITK.Framework.Client.WebClient Extends %SOAP.WebRequest [ Abstract, System = 4 ]
{

/******************************************************************************
$Id$

Description: Generic Web Client used for all Web Requests. 
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

/// WSADDRESSING parameter controls automatic generation of WS-Addressing headers.
Parameter WSADDRESSING As STRING [ Constraint = ",OFF,AUTO", Flags = ENUM ] = "AUTO";

Parameter SERVICENAME;

Parameter SOAPHEADERS As STRING = "ITKExtensions:EnsLib.ITK.Framework.ITKExtensions";

ClassMethod GetSoapParameters(ByRef bindingStyle As %String, ByRef bodyUse As %String, ByRef namespace As %String, ByRef xmlimportnamespace As %String, ByRef typeNamespace As %String, ByRef oneWay As %Boolean, ByRef xmlelement As %Boolean, ByRef bare As %Boolean, pServiceName As %String = "")
{
	Set tProxy = ..WebMethod(..#SERVICENAME)
	Do tProxy.GetSoapParameters(.bindingStyle,.bodyUse,.namespace,.xmlimportnamespace,.typeNamespace,.oneWay,.xmlelement,.bare)
}

}
