/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This Business Service is responsible for creating the DTS client directory structure, client configuration file and managing the DTS Client executable. 
Class EnsLib.ITK.DTS.Framework.Service.DTSConfigFile Extends Ens.BusinessService [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "Ens.InboundAdapter";

/// Site specific Credentials for the DTS Client. 
Property DTSCredentials As %String [ InitialExpression = "1", Required ];

/// The file system path to the root of the DTS Client File Interface.
Property InterfaceRoot As %String [ InitialExpression = "C:\dtsv4", Required ];

/// The specified location of the certificate.
Property CertificatePath As %String(MAXLEN = 250) [ InitialExpression = "c:\dtsv4\certs\Class 3 Primary Certificate Authority.cer", Required ];

/// The location where the client log files dtsclient.log and dts_ssl.log will be created
Property LogPath As %String [ InitialExpression = "c:\dtsv4\log", Required ];

/// This is the location used by the client for managing working files, such as sequence id file and log rollover timestamp file.
Property WorkPath As %String [ InitialExpression = "c:\dtsv4\work", Required ];

/// The name of the DTS Server to which the DTS Client will connect.
Property PrimaryURL As %String [ InitialExpression = "dts.nhs.uk", Required ];

/// Parameter controlling the generation of reports by the DTS Client, indicating that it has taken responsibility for the Data Transfer files. 
Property CollectReport As %String [ InitialExpression = "N" ];

/// Parameter controlling the generation of reports from the DTS Client indicating that the transfer is delayed if it fails to transfer the Data Files to the DTS Server but the Client is configured to retry.
Property DelayReport As %String [ InitialExpression = "N" ];

/// Parameter controlling the generation of reports indicating that the transfer of the Data Files to the DTS Server has succeeded.
Property TransferReport As %String [ InitialExpression = "Y" ];

/// Parameter controlling the generation of reports indicating that the poll to the DTS Server to check for received transfers has succeeded or failed.
Property PollReport As %String [ InitialExpression = "Y" ];

/// Parameter controlling the copying of sent Data Transfer files into the SENT folder on successful Transfer to the DTS Server.
Property SaveSent As %String [ InitialExpression = "Y" ];

/// The number of retries allowed for a message if the DTS Server is unavailable (but not busy).
Property ServerRetry As %String [ InitialExpression = "3" ];

/// PollPeriod is defined in minutes and is the period of time the client waits between sending and receiving messages to and from the DTS Server.
Property PollPeriod As %String [ InitialExpression = "10" ];

Property FilePoll As %String [ InitialExpression = "120" ];

Property ServerPoll As %String [ InitialExpression = "15" ];

/// The number of messages that can be upload/downloaded per poll period.
Property MaxMessages As %String [ InitialExpression = "500" ];

/// An individual MaxMessages up tag have been introduced to give the administrator more control over message flow to the DTS Server.
Property MaxMessagesUp As %String [ InitialExpression = "500" ];

/// An individual MaxMessages down tag have been introduced to give the administrator more control over message flow to the DTS Server.
Property MaxMessagesDown As %String [ InitialExpression = "500" ];

/// The poll mode option offers 3 distinct ways of running the client. 
Property PollMode As %String(VALUELIST = ",Upload,Download,Reverse") [ InitialExpression = "Reverse", Required ];

/// Parameter controlling the level of logging. 1 is default. Range is 0 to 3. 0 is debug.
Property ClientLogLevel As %String [ InitialExpression = "1" ];

Parameter SETTINGS = "DTSCredentials,InterfaceRoot,CertificatePath,PrimaryURL,PollMode,PollPeriod,DTSExeLocation";

/// Location of DTS Client exe.
Property DTSExeLocation As %String [ InitialExpression = "C:\dtsv4\WIN32\DTSClient" ];

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{

	Quit $$$OK
}

// This will start the DTS Client exe

Method OnInit() As %Status
{
	/// Create the DTS Directory Structure
	set tRootDir= ..InterfaceRoot
	set tRootDirExists = ##class(%File).DirectoryExists(tRootDir)
	If 'tRootDirExists
	{
		Do ##class(%File).CreateDirectory(tRootDir)
		
		//Do ##class(%File).CreateDirectory(tMailBoxDir)
		set tInDirExists = ##class(%File).DirectoryExists(tRootDir_"\IN")
		If 'tInDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\IN")
		}
		set tOutDirExists = ##class(%File).DirectoryExists(tRootDir_"\OUT")
		If 'tOutDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\OUT")
		}
		set tSentDirExists = ##class(%File).DirectoryExists(tRootDir_"\SENT")
		If 'tSentDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\SENT")
		}
		set tTempDirExists = ##class(%File).DirectoryExists(tRootDir_"\TEMP")
		If 'tTempDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\TEMP")
		}
		set tTempRcvDirExists = ##class(%File).DirectoryExists(tRootDir_"\TEMP\RCV")
		If 'tTempRcvDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\TEMP\RCV")
		}
		set tLogDirExists = ##class(%File).DirectoryExists(tRootDir_"\log")
		If 'tLogDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\log")
		}	
		set tProxyDirExists = ##class(%File).DirectoryExists(tRootDir_"\proxy")
		If 'tProxyDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\proxy")
		}
		set tConfigDirExists = ##class(%File).DirectoryExists(tRootDir_"\config")
		If 'tConfigDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\config")
		}
		set tSigDirExists = ##class(%File).DirectoryExists(tRootDir_"\sig")
		If 'tSigDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\sig")
		}
		set tWorkDirExists = ##class(%File).DirectoryExists(tRootDir_"\working")
		If 'tWorkDirExists{
			Do ##class(%File).CreateDirectory(tRootDir_"\working")
		}
		
		/// Create the Config File
		set tDtsClientConfig = ##class(EnsLib.ITK.DTS.Framework.ConfigFile).%New()
		set tCredential = ..DTSCredentials
		&sql( Select Username,Password 
			  Into :username,:password
		  	from Ens_Config.Credentials
		  	where SystemName = :tCredential)
		set tDtsClientConfig.ClientIdentity = username
		set tDtsClientConfig.ClientAuthentication = password
		set tDtsClientConfig.InterfaceRoot = tRootDir
		set tDtsClientConfig.CertPath = ..CertificatePath
		set tDtsClientConfig.LogPath = tRootDir_"\log"
		set tDtsClientConfig.WorkPath = tRootDir_"\working"
		set tDtsClientConfig.PrimaryURL = ..PrimaryURL
		set tDtsClientConfig.CollectReport = ..CollectReport
		set tDtsClientConfig.DelayReport = ..DelayReport
		set tDtsClientConfig.TransferReport = ..TransferReport
		set tDtsClientConfig.PollReport = ..PollReport
		set tDtsClientConfig.SaveSent = ..SaveSent
		set tDtsClientConfig.ServerRetry = ..ServerRetry
		set tDtsClientConfig.SignalPath = tRootDir_"\sig"
		set tDtsClientConfig.ProxyPath = tRootDir_"\proxy"
		set tDtsClientConfig.PollPeriod = ..PollPeriod
		set tDtsClientConfig.FilePoll = ..FilePoll
		set tDtsClientConfig.ServerPoll = ..ServerPoll
		set tDtsClientConfig.MaxMessages = ..MaxMessages
		set tDtsClientConfig.MaxMessagesUp = ..MaxMessagesUp
		set tDtsClientConfig.MaxMessagesDown = ..MaxMessagesDown
		set tDtsClientConfig.PollMode = ..PollMode
		set tDtsClientConfig.ClientLogLevel = ..ClientLogLevel
	
		set tConfigFileName=tRootDir_"\config\DTSClient.cfg"
  		set tConfigFile = ##class(%Library.File).%New(tConfigFileName)
  		do tConfigFile.Open("WSN")
  		
  		set tStr=""
  		set tWriter=##class(%XML.Writer).%New()
    	set tWriter.Indent=1
		set status=tWriter.OutputToString()
		set status=tWriter.RootObject(tDtsClientConfig)
		set tStr=tWriter.GetXMLString()
		//set tSC=tDtsClientConfig.XMLExportToString(.tStr)
  		do tConfigFile.Write(tStr)
		do tConfigFile.Close()
	}

	/// Once the Config File has been created or exists start the DTS Client exe
	#dim tCmd = "Start"
	#dim tCmdArgs = 0
	Set tCmdArgs($I(tCmdArgs))=$ZUTIL(147,..DTSExeLocation)
	Set tCmdArgs($I(tCmdArgs))=tRootDir_"\config\DTSClient.cfg"
	If $ZF(-100,"/ASYNC",tCmd,.tCmdArgs)

	Quit $$$OK
}

// This will change the signal which will shut down the DTS Client exe

Method OnTearDown() As %Status
{
	set tSigFile = ##class(%Library.File).%New(..InterfaceRoot_"\sig\dtsclient.sig")
	do tSigFile.Open("WSN")
	do tSigFile.Write("1")
	do tSigFile.Close()
	Quit $$$OK
}

}
