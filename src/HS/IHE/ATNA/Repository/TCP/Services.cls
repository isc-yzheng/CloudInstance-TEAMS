Class HS.IHE.ATNA.Repository.TCP.Services Extends (Ens.BusinessService, HS.IHE.ATNA.Repository.Syslog.Common, HS.IHE.Common.Actor.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter ADAPTER = "HS.Util.TCPServer.ATNAInboundAdapter";

Parameter LOGCONNECTIONS = 0;

Parameter SETTINGS = "AuditRepositoryOperations,TCPDebugOutputFile,AuditMessageType";

Property AuditRepositoryOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.ATNA.Repository.Operations" ];

Property TCPDebugOutputFile As %String;

Property AuditMessageType As %String(VALUELIST = ",DICOM,RFC3881") [ InitialExpression = "DICOM" ];

Method OnProcessInput(pInput As HS.Message.IHE.ATNA.InboundSubmission, Output pOutput As Ens.StringContainer) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If (..TCPDebugOutputFile ] "") { Set tStatus = ..OutputToDebugFile(pInput.StringValue) }

		Set tString = pInput.StringValue

		#; At least one audit message is expected per packet.
		If ($Find(tString, "</AuditMessage>") = 0) $$$LOGWARNING("Audit message missing </AuditMessage>: " _ tString)

		Set tSyslogHeader = $Piece($Case(tString [ "<?xml", 1:$Piece(tString, "<?xml", 1), :$Piece(tString, "<AuditMessage", 1)), " ", 2, $Length(tString, " "))
		Set tAuditEvent = $Extract(tString, $Find(tString, "<AuditMessage") - $Length("<AuditMessage"), $Find(tString, "</AuditMessage>"))
		Set tRecordActualLength = $Length($Extract($Piece(tString, " ", 2, $Length(tString, " ")), 1, $Find(tString, "</AuditMessage>")))
		Set tRecordReportedLength = $Piece(tString, " ", 1)

		#; Only one audit message is expected per packet.  If there are more, log an error.
		Set tRemainingCharacters = $Extract(tString, $Find(tString, "</AuditMessage>"), *)		
		If ($ZStrip(tRemainingCharacters, "<>W",$C(13,10)) '= "") $$$LOGWARNING("Extraneous data found after parsing audit event from input data stream:  " _ tRemainingCharacters)
		
		#; Check to see if audit event length is as reported in the packet header
		If (tRecordReportedLength '= tRecordActualLength) $$$LOGERROR("Input header reports an audit record length of " _ tRecordReportedLength _ " characters, but actual audit record has " _ tRecordActualLength _ " characters.  Raw message captured is:  " _ tString)

		#; Parse syslog header
		Set tStatus = ..ParseSyslogHeader(tSyslogHeader, .tSyslogArray) $$$ThrowOnError(tStatus)
		
		#; Create Audit Message, then forward to Audit Repository operations
		#dim tRequest As HS.Message.XMLMessage
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRequest.Name = "ATNA_AuditEventRequest"
		Set tRequest.DocType = "AuditMessage"
		If ($IsObject(tSyslogArray) && tSyslogArray.Count()) Set tRequest.AdditionalInfo = tSyslogArray
		Do tRequest.AdditionalInfo.SetAt(tRecordActualLength, "AuditRecord:ActualSize")
		Do tRequest.AdditionalInfo.SetAt(tRecordReportedLength, "AuditRecord:ReportedSize")
		Do tRequest.AdditionalInfo.SetAt(pInput.InboundIP,"AuditRecord:InboundIP")
		Do tRequest.AdditionalInfo.SetAt(..AuditMessageType,"AuditRecord:AuditMessageType")
		Do tRequest.ContentStream.Write($ZCVT(tAuditEvent,"I","UTF8")), tRequest.ContentStream.Rewind()
		
		Set tStatus = ..SendRequestSync(..AuditRepositoryOperations, tRequest, .tResponse) Quit:$$$ISERR(tStatus)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

Method OutputToDebugFile(pAuditMessage As %String = "") As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If (..TCPDebugOutputFile ] "") {
			Set tOldIO = $IO
			Open ..TCPDebugOutputFile:"WAS":1
			Use ..TCPDebugOutputFile Write pAuditMessage,!!
			Close ..TCPDebugOutputFile
			Use tOldIO
		}
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

}
