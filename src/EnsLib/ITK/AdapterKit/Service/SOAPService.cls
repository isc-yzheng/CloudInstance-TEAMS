/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsITK, EnsConstants)

/// ITK Switchboard SOAP Service 
Class EnsLib.ITK.AdapterKit.Service.SOAPService Extends EnsLib.ITK.Framework.Service.SOAPServiceBase [ System = 4 ]
{

/// Semi-colon ';' separted value list of applications authorised to invoke this service
Property AuthorizedApplications As %String(MAXLEN = "");

/// Whether requests made a synchronous or asychronous
Property InvocationPattern As %String;

Parameter SETTINGS = "AuthorizedApplications,InvocationPattern";

Method DetermineGenericService(Output pClass As %String, Output pMethod As %String)
{
	set pClass = "EnsLib.ITK.WebServices.adapterService"
	set pMethod = "genericMethod"
}

Method AuthorizeRequest(Output invocationPattern) As %Boolean
{
	set aplist = $LFS(..AuthorizedApplications,";")
	
	set invocationPattern=..InvocationPattern
	
	set authorised =($LF(aplist,..Username)>0)
	set:'authorised authorised =($LF(aplist,..Username)>0)
	
	Quit authorised
}

}
