/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (Ensemble, EnsITK)

/// ITK Switchboard SOAP Service 
Class EnsLib.ITK.Framework.Service.SOAPRequestHandler Extends EnsLib.ITK.Framework.Service.SOAPServiceBase [ System = 4 ]
{

/// Determines how Distribution Envelope wrapped messages will be delivered.
/// Messages distributed from a 'Relay' service will be distributed using the 
/// best match from both Authoritive and Non-authoritive rules 
Property DistributionMode As %String(VALUELIST = ",Relay,Authoritative,Non-Authoritative") [ InitialExpression = "Relay", Required ];

Parameter SETTINGS = "DistributionMode";

Method DetermineGenericService(Output pClass As %String, Output pMethod As %String)
{
	set pClass = "EnsLib.ITK.WebServices.genericService"
	set pMethod = "genericMethod"
}

Method AuthorizeRequest(Output invocationPattern) As %Boolean
{
	Set sc = $$$OK
	
	set user = ##class(EnsLib.ITK.Util.UtilityMethods).CNfromDN(..Username)
	Set tIsAllowed = ##class(EnsLib.ITK.Setup.SenderRegistry).CheckSenderPermission(user, ..WebServiceName, ..%ConfigName, .invocationPattern)
	
	If ('tIsAllowed) {	
		Set sc = $$$ERROR($$$EnsErrGeneral,$$$ITKUnauthorisedRequest_"Sender ("_user_") not registered to invoke Web Service ("_..WebServiceName_") on this target ("_..%ConfigName_")")
	}
	
	Quit sc
}

Method DetermineDistributionMode() As %String
{
	Quit ..DistributionMode
}

}
