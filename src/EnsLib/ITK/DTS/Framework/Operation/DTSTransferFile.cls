/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This Business Operation is responsible for creating the data and control files 
/// for the DTS data transfer and could either receive an ITK or DTS Canonical Message. 
/// The location of the files and Installation specific configurations required for the 
/// control file can be configured through this component. 
Class EnsLib.ITK.DTS.Framework.Operation.DTSTransferFile Extends Ens.BusinessOperation [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Property Adapter As EnsLib.File.OutboundAdapter;

/// Version of Control File
Property Version As %String [ InitialExpression = "1.0" ];

/// Identifies the type of address. Can be SMTP - SMTP Address, DTS - DTSname addressing and ALL - Used by DTS Server when sending to DTS client.
Property AddressType As %String [ InitialExpression = "DTS" ];

/// Identifies the type of transfer. Can be Data - Will have a data file and control file, Report - Will have a control file only.
Property MessageType As %String [ InitialExpression = "Data" ];

/// Should be set to Y unless there are good business reasons
Property Compress As %String [ InitialExpression = "Y" ];

/// DTS transmissions are encrypted on-the-wire and hence the encrypt setting SHOULD NOT be used
Property Encrypt As %String [ InitialExpression = "N" ];

/// Identifies the originator of data transfer. DTS name as given in site configuration file14 'ClientIdentity' element
/// Needs to be the source application name as per ITK subscription rules
Property FromDTS As %String;

/// Subject of the DTS Transfer Data.
Property Subject As %String [ InitialExpression = "Discharge Summary Report" ];

/// Value to indicate whether entire Distribution envelope or just the CDA needs to be part of the data file.
Property TransferType As %String(VALUELIST = ",ITK,Payload") [ InitialExpression = "ITK", Required ];

/// Identifier for the workflow that the data transfer is part of. 
Property WorkflowId As %String(MAXLEN = 250);

/// The transaction sequence identifier, SequenceIdentifier, will be incorporated into the file names 
/// used in the transaction between the host application and the DTS Client.
/// Transactions initiated by the host application will have the sequence identifier applied by the host application.
/// Tansactions initiated by the DTS Client will have the sequence identifier applied by the DTS Client.
Property SequenceIdentifier As %String(VALUELIST = ",Host,DTSClient") [ InitialExpression = "DTSClient", Required ];

Parameter SETTINGS = "Version,AddressType,MessageType,Compress,Encrypt,FromDTS,Subject,TransferType,WorkflowId,SequenceIdentifier";

Parameter INVOCATION = "Queue";

Method CreateDTSClientFileFromITK(pRequest As EnsLib.ITK.Framework.RequestData, Output pResponse As Ens.Response) As %Status
{

	/// Mapping of ITK Request Message to DTS Control file
	set tDTSClient=##class(EnsLib.ITK.DTS.Framework.Message).%New()
	set tDTSControl=##class(EnsLib.ITK.DTS.Framework.ControlFile).%New()
	/// Fixed Values
	set tDTSControl.Version=..Version
	set tDTSControl.AddressType=..AddressType 
	set tDTSControl.MessageType=..MessageType
	set tDTSControl.Compress=..Compress
	set tDTSControl.Encrypted=..Encrypt
	/// DTS Name as given in the site configuration file 
	///Should be the SENDER
	set tDTSControl.FromDTS=..FromDTS
	
	/// Verify
	set tDTSControl.Subject=..Subject
	/// Local Id needs to be Distribution envelope tracking ID 
	set tDTSControl.LocalId=pRequest.DistributionEnvelope.TrackingId
	/// Verify
	set tDTSControl.DTSId=pRequest.MessageId
	/// Interaction ID from Handling Specification or Distribution Envelope Service Name
	If ..WorkflowId=""
	{
		set tDTSControl.WorkflowId=pRequest.ServiceName
	}
	Else
	{
		set tDTSControl.WorkflowId=..WorkflowId
	}
	set tDTSClient.DTSControlFile=tDTSControl
	/// Transactions initiated by host application will have sequence identifier applied by the source 
	/// application or by the DTS Client.
	If ..SequenceIdentifier="Host"
	{
		set tDTSClient.SequenceNo=tOriginalMessage.SequenceNumber 
	}
	Else
	{
		set tDTSClient.SequenceNo=..CreateSequenceNumber()
	}
	set tURI=pRequest.DistributionEnvelope.AddressList.GetAt(1)		
	set tDTSControl.ToDTS= ..%ConfigName
	set tDTSClient.AppName=pRequest.ServiceName
	set tDTSClient.SiteId= tDTSControl.ToDTS
	//Determine Payload for the Data File - ITK Distribution Envelope or CDA
	set tStart="",tEnd="",tSize="",tBytesRead="",tOffset=""
	If ..TransferType="ITK"
	{
		do tDTSClient.DTSDataFile.CopyFrom(pRequest.Payload)
	}
	Else
	{
		set tStatus=pRequest.Payload.Rewind()
		set tSize=pRequest.Payload.SizeGet()
		set tPayload=##class(%GlobalCharacterStream).%New()
		do tPayload.CopyFrom(pRequest.Payload)
		set tStart=tPayload.FindAt(1,"<ClinicalDocument ")
		set tEnd=tPayload.FindAt(1,"</itk:CDADocument>")
		do tPayload.MoveTo(tStart)
		set tOffset=tEnd-tStart
		set i=0
		While i<=tOffset
		{
			set i=i+32000
			If i>tOffset
			{
				set line= tPayload.ReadLine(tOffset, ,.sc)
				do tDTSClient.DTSDataFile.Write(line)
			}
			Else
			{	
				set line= tPayload.ReadLine(32000, ,.sc)
				do tDTSClient.DTSDataFile.Write(line)
			}
			
		}
		
	}	

	set tFilePath=..Adapter.FilePath

	//Create the Data file
	set tDataFileName=tDTSClient.SiteId_tDTSClient.AppName_tDTSClient.SequenceNo_".dat"
	Set tSC=..Adapter.PutStream(tDataFileName,tDTSClient.DTSDataFile)
	
	// create the ctl file
	set tStr=""
	set tCtlFileName=tFilePath_"\"_tDTSClient.SiteId_tDTSClient.AppName_tDTSClient.SequenceNo_".ctl"
  	set tCtlFile = ##class(%Library.File).%New(tCtlFileName)
  	do tCtlFile.Open("WSN")
  	
  	/// DTS does not like XML Export without Indent
  	//set tSC=pRequest.DTSControlFile.XMLExportToString(.tStr)
  	set tWriter=##class(%XML.Writer).%New()
    set tWriter.Indent=1
	set status=tWriter.OutputToString()
	set status=tWriter.RootObject(tDTSControl)
	set tStr=tWriter.GetXMLString()
	do tCtlFile.Write(tStr)
	do tCtlFile.Close()
	
	///Create DTS Log
	set tTransferLog=##class(EnsLib.ITK.DTS.Framework.TransferLog).%New()
	set tTransferLog.FileName = $PIECE(tDataFileName,".",1)
	set tTransferLog.TrackingId = tDTSControl.LocalId
	set tTransferLog.WorkflowId =  tDTSControl.WorkflowId
	set tTransferLog.Sender =  tDTSControl.FromDTS
	set tTransferLog.Destination =  tDTSControl.ToDTS
	set tTransferLog.DTSId =  tDTSControl.DTSId
	
	do tTransferLog.%Save()
	    	
	Quit tSC
}

Method CreateDTSClientFile(pRequest As EnsLib.ITK.DTS.Framework.Message, Output pResponse As Ens.Response) As %Status
{

	/// Local Id, DTS Id and Workflow Id should be part of the incoming request
	
	/// Fixed Values
	set pRequest.DTSControlFile.Version=..Version
	set pRequest.DTSControlFile.AddressType=..AddressType 
	set pRequest.DTSControlFile.MessageType=..MessageType
	set pRequest.DTSControlFile.Compress=..Compress
	set pRequest.DTSControlFile.Encrypted=..Encrypt
	/// DTS Name as given in the site configuration file 
	///Should be the SENDER
	set pRequest.DTSControlFile.FromDTS=..FromDTS
	
	/// Verify
	set pRequest.DTSControlFile.Subject=..Subject
	
	If pRequest.DTSControlFile.WorkflowId=""
	{
		set pRequest.DTSControlFile.WorkflowId=..WorkflowId
	}
	
	/// Transactions initiated by host application will have sequence identifier applied by the source 
	/// application or by the DTS Client.
	If ..SequenceIdentifier="DTSClient"
	{
		set pRequest.SequenceNo=..CreateSequenceNumber()
	}
	/// ToDTS should be part of the incoming request
	/// App Name should be part of the incoming request
	/// Site Id should be part of the incoming request
	
	set tFilePath=..Adapter.FilePath

	//Create the Data file
	set tFileName=pRequest.SiteId_pRequest.AppName_pRequest.SequenceNo
	set tFileName=tFileName_".dat"
	Set tSC=..Adapter.PutStream(tFileName,pRequest.DTSDataFile)
	
	// create the ctl file
	set tStr=""
	set tCtlFileName=tFilePath_"\"_tFileName_".ctl"
  	set tCtlFile = ##class(%Library.File).%New(tCtlFileName)
  	do tCtlFile.Open("WSN")
  	
  	/// DTS does not like XML Export without Indent
  	//set tSC=pRequest.DTSControlFile.XMLExportToString(.tStr)
  	set tWriter=##class(%XML.Writer).%New()
    set tWriter.Indent=1
	set status=tWriter.OutputToString()
	set status=tWriter.RootObject(pRequest.DTSControlFile)
	set tStr=tWriter.GetXMLString()
	do tCtlFile.Write(tStr)
	do tCtlFile.Close()
	
	///Create DTS Log
	set tTransferLog=##class(EnsLib.ITK.DTS.Framework.TransferLog).%New()
	set tTransferLog.FileName = $PIECE(tFileName,".",1)
	set tTransferLog.TrackingId = pRequest.DTSControlFile.LocalId
	set tTransferLog.WorkflowId =  pRequest.DTSControlFile.WorkflowId
	set tTransferLog.Sender =  pRequest.DTSControlFile.FromDTS
	set tTransferLog.Destination =  pRequest.DTSControlFile.ToDTS
	set tTransferLog.DTSId =  pRequest.DTSControlFile.DTSId
	
	do tTransferLog.%Save()
	    	
	Quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="EnsLib.ITK.Framework.RequestData"> 
		<Method>CreateDTSClientFileFromITK</Method>
	</MapItem>
	<MapItem MessageType="EnsLib.ITK.DTS.Framework.Message"> 
		<Method>CreateDTSClientFile</Method>
	</MapItem>

</MapItems>
}

/// Create the 8 digit sequence number
ClassMethod CreateSequenceNumber() As %String
{

	If $GET(^DTS.TSI)=""
	{
		set ^DTS.TSI = 0
	}
	set sequenceno=$i(^DTS.TSI)
	If sequenceno>99999999
	{
		set ^DTS.TSI = 1
	}	
	set ^DTS.TSI=sequenceno
	set outputSeqLength=8
	for x = 1:1:outputSeqLength
	{
	 	set padString = $get(padString)_"0"
	} 
	set output=$extract(padString, 1, outputSeqLength - $length(sequenceno))_sequenceno 
	quit output
}

}
