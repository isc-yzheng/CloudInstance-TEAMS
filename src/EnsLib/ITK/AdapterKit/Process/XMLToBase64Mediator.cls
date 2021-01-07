/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsITK

/// Business process to mediate conversion to Pipe and Hat Base64 from XML
/// Note this is unlikely to be precisely what is required and can be used as a sample otherwise
Class EnsLib.ITK.AdapterKit.Process.XMLToBase64Mediator Extends Ens.BusinessProcess [ ProcedureBlock, System = 4 ]
{

Property TargetConfigName As %String;

Parameter SETTINGS = "TargetConfigName";

Property Response As EnsLib.ITK.AdapterKit.Response;

Method OnRequest(pRequest As EnsLib.ITK.Framework.RequestData, Output pResponse As EnsLib.ITK.AdapterKit.Response) As %Status
{
	// a. Convert DE from XML to PH
	do ##class(EnsLib.ITK.AdapterKit.Transform.XMLDEToPHDETransform).Transform(pRequest, .deStream)
	
	// b. Send the new DE onwards
	set itkMessage = ##class(EnsLib.ITK.AdapterKit.Request).%New()
	set itkMessage.ServiceName=pRequest.ServiceName
	set itkMessage.Stream=deStream
	
	// set sc=..SendRequestAsync(..TargetConfigName, itkMessage, 1, "PassToSwitchboard")
	set sc=..SendRequestSync(..TargetConfigName, itkMessage, .itkResponse)
	set ..Response=itkResponse
	
	// If return, convert it, otherwise just response
	if $IsObject(itkResponse.ResponseBody)&&(itkResponse.ResponseBody.Size>0) {
		do ##class(EnsLib.ITK.Framework.Service.SOAPServiceBase).ProcessDistributionEnvelope(itkResponse.ResponseBody, .de, .contentStream)
		
		// c. Convert XML output DE to PH
		set origPayload=pRequest.Payload
		set pRequest.Payload=contentStream
		do ##class(EnsLib.ITK.AdapterKit.Transform.PHDEToXMLDETransform).Transform(pRequest, .responseDeStream)
		set pRequest.Payload=origPayload
	
		// d. Form response
		Set tToken = ##class(EnsLib.ITK.Util.UtilityMethods).GetDeferredToken(..%SessionId) 
		Set pResponse = ##class(EnsLib.ITK.Framework.ResponseData).%New()
		Set pResponse.MessageId = ##class(EnsLib.ITK.Util.UtilityMethods).CreateGUID()
		set pResponse.ResponseInvocationPattern = $$$ITKSyncInvocationPattern
		Set pResponse.RequestInvocationPattern = $$$ITKSyncInvocationPattern
		Set pResponse.BehaviourType = $$$ITKBPRequestResponse
		Set pResponse.SourceApplication = pRequest.SourceApplication
		Set pResponse.ResponseBody = responseDeStream
		Set pResponse.Status = $$$OK

		Set sc = ..SendDeferredResponse(tToken, pResponse)
	}
	else {
		set pResponse=itkResponse
	}
	
	quit sc
	
OnExit	
	Quit sc
}

/// Handle a 'Response'
Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
	set ..Response=response
	quit $$$OK
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigName",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

Storage Default
{
<Data name="XMLToBase64MediatorDefaultData">
<Subscript>"XMLToBase64Mediator"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
<Value name="2">
<Value>Response</Value>
</Value>
</Data>
<DefaultData>XMLToBase64MediatorDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
