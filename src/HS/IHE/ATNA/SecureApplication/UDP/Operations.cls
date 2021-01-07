Class HS.IHE.ATNA.SecureApplication.UDP.Operations Extends (Ens.BusinessOperation, HS.IHE.ATNA.SecureApplication.Syslog.Common, HS.IHE.Common.Actor.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter ADAPTER = "HS.IHE.ATNA.Adapter.UDP.Outbound";

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "UDPDebugOutputFile,AuditMessageType";

Property UDPDebugOutputFile As %String;

Property AuditMessageType As %String(VALUELIST = ",DICOM,RFC3881") [ InitialExpression = "DICOM" ];

Method OnMessage(pRequest As %Persistent, Output pResponse As %Persistent = {$$$NULLOREF}) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		If pRequest.%IsA("HS.Message.AuditAlertRequest") {
			Quit:##class(HS.IHE.ATNA.Repository.Aggregation).%OpenId(pRequest.AggregationId).ATNAMessage'=""
			Set tSyslogHeader = ..GetSyslogHeader() If (tSyslogHeader = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "An error occured while creating the syslog header for audit record ID '" _ pRequest.AggregationId _ "'"))
			Set tXMLHeader = "<?xml version=""1.0"" encoding=""UTF-8""?>"
			If ..AuditMessageType="RFC3881" {
				Set tSC=##class(HS.IHE.ATNA.Repository.AggregationToAuditMessage).Convert(pRequest.AggregationId,.tAuditEvent)
			} Else {
				Set tSC=##class(HS.IHE.ATNA.Repository.AggregationToDICOMAuditMessage).Convert(pRequest.AggregationId,.tAuditEvent)
			}				
			Quit:$$$ISERR(tSC)
			Set tAuditEvent = $Case(..StripWhitespace, 1:$Translate(tAuditEvent, $Char(13, 10, 9), ""), :tAuditEvent) If (tAuditEvent = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "Empty ATNA audit record with ID '" _ pRequest.AggregationId _ "' not sent"))
			Set tAuditMessage = tSyslogHeader _ " " _tXMLHeader _ tAuditEvent
			If (..UDPDebugOutputFile ] "") { Set tSC = ..OutputToDebugFile(tAuditMessage) $$$ThrowOnError(tSC) }
			$$$HSTRACE("Audit Message","tAuditMessage",tAuditMessage)
			Set tSC = ..Adapter.SendMessageString(tAuditMessage) $$$ThrowOnError(tSC)
		}
		ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			If 'pRequest.ContentStream.Size $$$ThrowStatus($$$ERROR($$$GeneralError, "Empty ATNA audit record with ID '" _ pRequest.AggregationId _ "' not sent"))
			
			Set tSyslogHeader = ..GetSyslogHeader() If (tSyslogHeader = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "An error occured while creating the syslog header for audit record ID '" _ pRequest.AggregationId _ "'"))
			Set tXMLHeader = "<?xml version=""1.0"" encoding=""UTF-8""?>"

			Set tAuditEvent = "" While 'pRequest.ContentStream.AtEnd { Set tAuditEvent = tAuditEvent _ pRequest.ContentStream.Read() }
			Set tAuditMessage = tSyslogHeader _ " " _tXMLHeader _ $Case(..StripWhitespace, 1:$Translate(tAuditEvent, $Char(13, 10, 9), ""), :tAuditEvent)

			If (..UDPDebugOutputFile ] "") { Set tSC = ..OutputToDebugFile(tAuditMessage) $$$ThrowOnError(tSC) }
			Set tSC = ..Adapter.SendMessageString(tAuditMessage) $$$ThrowOnError(tSC)
		}
		Else {
			Set tSC = $$$EnsError("Unknown message type received:  " _ pRequest.%ClassName(1)) $$$ThrowOnError(tSC)
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	
	Set pResponse = ##class(HS.Message.XMLMessage).%New()
	Set pResponse.Name = "ATNA_AuditEventResponse"

	Quit tSC
}

Method OutputToDebugFile(pAuditMessage As %String = "") As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		If (..UDPDebugOutputFile ] "") {
			Set tOldIO = $IO
			Open ..UDPDebugOutputFile:"WAS":1
			Use ..UDPDebugOutputFile Write pAuditMessage,!!
			Close ..UDPDebugOutputFile
			Use tOldIO
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
