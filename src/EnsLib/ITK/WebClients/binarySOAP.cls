/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Generic binary SOAP client
Class EnsLib.ITK.WebClients.binarySOAP Extends EnsLib.ITK.Framework.Client.WebClient [ ProcedureBlock, System = 4 ]
{

/******************************************************************************
$Id$

Description: Generic binary SOAP client
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Method InvokeClient(proxy As %SOAP.ProxyDescriptor, MethodName As %String, Action As %String, OneWay As %Boolean = 0) As %Status [ Internal, ServerOnly = 1 ]
{
	set classname=$classname()_".genericMethod"
	
	set proxy =$CLASSMETHOD(classname,"%New")
	set proxy.payload=..Request
	quit ##super(proxy, MethodName, Action, OneWay)
}

Method genericMethod(payload As %CharacterStream) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("genericMethod","None").Invoke($this,"http://server:80/interoperability.toolkit/HL7v2/admitPatient",payload)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

// Parameter LOCATION = "http://server:80/interoperability.toolkit/";

/// This is the URL used to access the web service.
Parameter LOCATION = "http://127.0.0.1:10001/ITK.Framework.Service.SOAPRequestHandler.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/Services/1.0";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 0;

/// This is the type namespace for all response messages.
Parameter RESPONSETYPENAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/ToolkitUtilities/1.0";

/// This is the name of the Service
Parameter SERVICENAME = "genericMethod";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.2;

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "http://www.nhs.cfh.org/interoperability.toolkit/Events/1.0";

/// SOAPBINARY - If = 1, then binary SOAP messages will be supported.
Parameter SOAPBINARY = 1;

}
