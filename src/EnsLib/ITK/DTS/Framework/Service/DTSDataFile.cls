/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This Business Service periodically polls for new DTS files to download and 
/// transforms them into ITK or DTS Canonical message. 
Class EnsLib.ITK.DTS.Framework.Service.DTSDataFile Extends Ens.BusinessService [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

/// Configuration item to which to send file stream messages
Property TargetConfigName As %String(MAXLEN = 1000);

/// The complete URL of this Business Service. <br>
/// E.g. http://server:port/csp/itk/ITK.Framework.Service.SOAPRequestHandler.cls
Property EndpointURL As %String(MAXLEN = "");

/// Workflow ID of DTS needs to be prefixed with the Service Name
Property Service As %String(MAXLEN = "") [ InitialExpression = "urn:nhs-itk:services:201005:" ];

/// Determines whether the Transfer type is DTS or ITK. In case of ITK it constructs the distribution
/// Envelope whereas in case of DTS it will construct DTS canonical Message.
Property TransferType As %String(VALUELIST = ",DTS,ITK") [ InitialExpression = "ITK", Required ];

/// Determines how Distribution Envelope wrapped messages will be delivered.
/// Messages distributed from a 'Relay' service will be distributed using the 
/// best match from both Authoritive and Non-authoritive rules 
Property DistributionMode As %String(VALUELIST = ",Relay,Authoritative,Non-Authoritative") [ InitialExpression = "Relay", Required ];

/// Determines the Invocation Pattern which for DTS should be Asynchronous.
Property InvocationPattern As %String(VALUELIST = ",Asynchronous,Derived") [ InitialExpression = "Asynchronous", Required ];

Parameter SETTINGS = "TargetConfigName,EndpointURL,DistributionMode,TransferType,InvocationPattern,Service";

Parameter CONTAINERCLASS = "Ens.StreamContainer";

Method OnProcessInput(pInput As %Stream.Object, pOutput As %RegisteredObject) As %Status
{
	
	set tSC=$$$OK
	set tFileName=""
	set tStreamInput=$zobjclassmethod(..#CONTAINERCLASS,"%New",pInput)
	
	//$$$TRACE(tStreamInput.OriginalFilename)
	set tFileName=$PIECE(tStreamInput.OriginalFilename,".",1)
	
	///Check if the corresponding control file has already been polled
	set tControlFile = ##class(EnsLib.ITK.DTS.Framework.FileLog).%OpenId(tFileName)
	if $IsObject(tControlFile) //control file exists
	{
   		If ..TransferType="ITK"
		{
			set tRequest=##class(EnsLib.ITK.Framework.RequestData).%New()
			set tRequest.ServiceName=tControlFile.WorkflowId
			set tRequest.Action=..Service_tControlFile.WorkflowId
			set tRequest.InvocationPattern=..InvocationPattern
			set tRequest.SourceApplication=tControlFile.Sender
			set tRequest.MessageId=tControlFile.DTSId
			set tRequest.To=..EndpointURL
			set tRequest.SequenceNumber=""
			set tRequest.DistributionMode=..DistributionMode
			do tRequest.DistributionEnvelope.AddressList.Insert(tControlFile.Destination)
			set tRequest.DistributionEnvelope.TrackingId=tControlFile.TrackingId
			set tRequest.DistributionEnvelope.Service=..Service_tControlFile.WorkflowId
			do tRequest.Payload.CopyFrom(pInput)
		}
		Else
		{
			///For non ITK Transfer create the DTS Canonical Message
			set tRequest=##class(EnsLib.ITK.DTS.Framework.Message).%New()	
			do tRequest.DTSDataFile.CopyFrom(pInput)
			set tControl=##class(EnsLib.ITK.DTS.Framework.ControlFile).%New()
			set tControl.Version=tControl.Version
			set tControl.AddressType=tControlFile.AddressType
			set tControl.MessageType=tControlFile.MessageType
			set tControl.Compress=tControlFile.Compress
			set tControl.Encrypted=tControlFile.Encrypted
			set tControl.WorkflowId=tControlFile.WorkflowId
			set tControl.FromDTS=tControlFile.Sender
			set tControl.ToDTS=tControlFile.Destination
			set tControl.LocalId=tControlFile.TrackingId
			set tControl.DTSId=tControlFile.DTSId
			set tRequest.DTSControlFile=tControl
		}
		set tSC=..SendRequestAsync(..TargetConfigName,tRequest)
	}
	Else
	{
		//In case the control file has not been polled, data file needs to be logged
		set tFileLog=##class(EnsLib.ITK.DTS.Framework.FileLog).%New()
		set tFileLog.FileName = tFileName
		do tFileLog.Payload.CopyFrom(pInput)
		do tFileLog.%Save()	
	 
	} 
	
	quit tSC
}

}
