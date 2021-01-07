/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Generic SOAP server
Class EnsLib.ITK.WebServices.adapterService Extends EnsLib.ITK.AdapterKit.Service.SOAPService [ ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: Generic SOAP server
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Method genericMethod(payload As %String) As %String [ Final, ProcedureBlock = 1, SoapAction = genericMethod, SoapBindingStyle = document, SoapBodyUse = literal, SoapMessageName = SimpleMessageResponse, WebMethod ]
{
 // Web Service Method Implementation Goes Here.
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/Services/1.0";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the type namespace for all response messages.
Parameter RESPONSETYPENAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/ToolkitUtilities/1.0";

/// This is the name of the Service
Parameter SERVICENAME = "genericMethod";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/Events/1.0";

}
