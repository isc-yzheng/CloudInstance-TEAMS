/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Generic SOAP client
Class EnsLib.ITK.WebClients.genericService Extends EnsLib.ITK.Framework.Client.WebClient [ ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: Generic SOAP client
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Method genericMethod(payload As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("genericMethod","None").Invoke($this,"http://server:80/interoperability.toolkit/HL7v2/admitPatient",payload)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://server:80/interoperability.toolkit/";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/Services/1.0";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 0;

/// This is the type namespace for all response messages.
Parameter RESPONSETYPENAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/ToolkitUtilities/1.0";

/// This is the name of the Service
Parameter SERVICENAME = "genericMethod";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/Events/1.0";

}
