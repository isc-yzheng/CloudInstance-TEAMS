/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This Business Service is responsible for polling the DTS control Files which could
/// be either DTS Data Control files or DTS Transfer reports.
Class EnsLib.ITK.DTS.Framework.Service.DTSControlFile Extends Ens.BusinessService [ ProcedureBlock, System = 4 ]
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
	set tStreamInput=$zobjclassmethod(..#CONTAINERCLASS,"%New",pInput)
	Set tReader = ##class(%XML.Reader).%New()
	Do tReader.OpenStream(pInput)
	/// Correlate Object from the XML files
	Do tReader.Correlate("DTSControl","EnsLib.ITK.DTS.Framework.ControlFile")
	Do tReader.Next(.tObject,.Status)
	if (($$$ISOK(Status)) && (tObject '= "")) {
		/// In case of DTS Transfer reports update the status of DTS Transfer
		If (tObject.MessageType="Report")
		{
			///Update the DTS Log for the transfer
			set tDTSId=tObject.DTSId
			&sql(select ID from EnsLib_ITK_DTS_Framework.TransferLog 
			WHERE DTSId=:tDTSId)

			if (SQLCODE=0)
				{
					set tDateTime=tObject.StatusRecord.DateTime
					set tDescription=tObject.StatusRecord.Description
					set tEvent=tObject.StatusRecord.Event
					set tStatus=tObject.StatusRecord.Status
					set tStatusCode=tObject.StatusRecord.StatusCode

					&sql(Update EnsLib_ITK_DTS_Framework.TransferLog
					set Result_DateTime=:tDateTime,
					Result_Description=:tDescription,
					Result_Event=:tEvent,
					Result_Status=:tStatus,
					Result_StatusCode=:tStatusCode
					WHERE DTSId=:tDTSId)

				//[FIX ME] In case of failure Create Infrastructure NACK and send to ITK Message Router
				// OR raise an alert in case of DTS Transfer
			}
			Else
			{
				// Handle any other report control file
				set tSC= tObject.%Save()
			}
		}
		ElseIf (tObject.MessageType="Data")
		{

			/// This is required for storing the data control files in case their correspondiong 
			///data files have still not arrived.
			///Create a log of the incoming control file for the data transfer.
			set tFileName=$P(tStreamInput.OriginalFilename,".",1)

			///Check if the corresponding Data File has already been polled
			set tDataFile = ##class(EnsLib.ITK.DTS.Framework.FileLog).%OpenId(tFileName)
			if $IsObject(tDataFile) //data file exists
			{
				If ..TransferType="ITK"
				{
					set tRequest=##class(EnsLib.ITK.Framework.RequestData).%New()
					set tRequest.ServiceName=tObject.WorkflowId
					set tRequest.Action=..Service_tObject.WorkflowId
					set tRequest.InvocationPattern=..InvocationPattern
					set tRequest.SourceApplication=tObject.FromDTS
					set tRequest.MessageId=tObject.DTSId
					set tRequest.To=..EndpointURL
					set tRequest.SequenceNumber=""
					set tRequest.DistributionMode=..DistributionMode
					do tRequest.DistributionEnvelope.AddressList.Insert(tObject.ToDTS)
					set tRequest.DistributionEnvelope.TrackingId=tObject.LocalId
					set tRequest.DistributionEnvelope.Service=..Service_tObject.WorkflowId
					do tRequest.Payload.CopyFrom(tDataFile.Payload)
				
				}
				Else
				{
					/// In case of non ITK Transfer create the DTS Canonical Message
					set tRequest=##class(EnsLib.ITK.DTS.Framework.Message).%New()
					set tRequest.DTSControlFile=tObject
					do tRequest.DTSDataFile.CopyFrom(tDataFile.Payload)
				
				}
				set tSC=..SendRequestAsync(..TargetConfigName,tRequest)	
			}
			Else
			{
				///Data file does not exist and needs to be just logged
				
				set tFileLog=##class(EnsLib.ITK.DTS.Framework.FileLog).%New()
				set tFileLog.FileName = tFileName
				set tFileLog.TrackingId = tObject.LocalId
				set tFileLog.WorkflowId =  tObject.WorkflowId
				set tFileLog.Sender =  tObject.FromDTS
				set tFileLog.Destination =  tObject.ToDTS
				set tFileLog.DTSId =  tObject.DTSId
				set tFileLog.AddressType = tObject.AddressType
				set tFileLog.MessageType = tObject.MessageType
				set tFileLog.Compress =  tObject.Compress
				set tFileLog.Version = tObject.Version
				set tFileLog.Encrypted = tObject.Encrypted
				set tSC= tFileLog.%Save()
			}
			
		}
		Else
		{
			///Any undhandled Control files
			set tSC= tObject.%Save()
		}
	}
	Quit tSC
}

}
