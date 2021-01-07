/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class is a business operation that supports sending a basic
/// message to an ITK consumer. The message can be a simple fire and
/// forget post, or it can be a synchronous request/response. The
/// message will be signed and/or encrypted in line with the settings
/// in the ITKOperationBase
Class EnsLib.ITK.AdapterKit.Operation.SOAPOperation Extends EnsLib.ITK.Framework.Operation.SOAPOperationBase [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Basic ITK SOAP Opereration to send post and simple request
			 response messages to ITK consumers.
   
Update history:
2011-05-04  Initial Version
******************************************************************************/
Parameter SrcVer = "$Id$";

/// The logical url from which the request is being sent request
Property FromURL As %String(MAXLEN = "");

/// If the Adapter is to receive asynchronous responses then this Buisness Operation must be paired with an ITK Business Service
Property PairedBusinessService As %String;

/// Synchronous or Asynchronous invocation
Property InvocationPattern As %String(VALUELIST = ",Asynchronous,Synchronous") [ InitialExpression = "Asynchronous" ];

Parameter SETTINGS = "FromURL,InvocationPattern,PairedBusinessService";

XData MessageMap
{
<MapItems>
  <MapItem MessageType="EnsLib.ITK.AdapterKit.Request">
    <Method>SendWebRequest</Method>
  </MapItem>  
</MapItems>
}

/// This method determines the invocation pattern for the request.
/// This must be implemented by the derived class
Method DetermineInvocationPattern(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef pattern As %String) As %Status
{
	set sc = $$$OK
	
	set pattern=..InvocationPattern

	set:pRequest.IsResponse pattern = $$$ITKAsyncInvocationPattern
	
	quit sc
}

/// This method determines the logical url to send the request into
/// Note the default endpoint is used if there is one 
Method DetermineLogicalURL(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef url As %String) As %Status
{
	set sc = $$$OK
	
	set url=..EndpointBaseURL
	set:url="" url=..Adapter.WebServiceURL
	set:pRequest.PartialLogicalURL'="" url=url_pRequest.PartialLogicalURL
	set:pRequest.PartialLogicalURL="" url=url_pRequest.PartialPhysicalURL
	
	quit sc
}

/// The method determines the physical url to send the request into
Method DeterminePhysicalURL(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef url As %String) As %Status
{
	set sc = $$$OK
	
	set url=..Adapter.WebServiceURL_pRequest.PartialPhysicalURL

	quit sc
}

/// This method determines the payload. This is either as per the request
/// or if the request status is not OK then it forms a fault payload.
Method DeterminePayload(pRequest As EnsLib.ITK.Framework.RequestData, ByRef payload As %GlobalCharacterStream) As %Status
{
	set payload=pRequest.Payload 
	
	quit $$$OK
}

/// The method determines the from url to send the request into
/// This must be implemented by the derived class
Method DetermineAddressing(pRequest As EnsLib.ITK.Framework.RequestBase, ByRef fromURL As %String, ByRef relatesTo As %String) As %Status
{
	set fromURL = ..FromURL
	set relatesTo=""
	set:pRequest.IsResponse relatesTo=pRequest.RelatesToMessageId

	quit $$$OK
}

/// This method builds a response message and populates it with specifics relevant to the context
/// This method must be implemented by the derived class
Method GenerateResponse(pRequest As EnsLib.ITK.Framework.RequestBase, pResponseInvocationPattern As %String, pBehaviourType As %String, sourceApplication As %String) As EnsLib.ITK.Framework.ResponseBase
{
	set tResponse = ##class(EnsLib.ITK.AdapterKit.Response).%New()
	
	Quit tResponse
}

/// This is called when forming the SOAP header if we have an asynchronous request.
Method DetermineAsyncReplyAddresses(ByRef pReplyTo As %String, ByRef pFaultTo As %String) As %Status
{
	set pReplyTo=""
	set pFaultTo=""
	
	// Get Response Endpoint Business Service Name
	set:..PairedBusinessService'="" pReplyTo=##class(Ens.Director).GetHostSettingValue($$$EnsRuntime("Name")_"||"_..PairedBusinessService,"EndpointURL",.tSC)
	set:pReplyTo="" pReplyTo=..FromURL
	
	quit $$$OK
}

}
