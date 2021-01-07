Class HS.IHE.ATNA.Repository.UDP.Services Extends (Ens.BusinessService, HS.IHE.ATNA.Repository.Syslog.Common, HS.IHE.Common.Actor.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter ADAPTER = "HS.IHE.ATNA.Adapter.UDP.Inbound";

Parameter SETTINGS = "AuditRepositoryOperations,UDPDebugOutputFile,AuditMessageType";

Property AuditRepositoryOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.ATNA.Repository.Operations" ];

Property UDPDebugOutputFile As %String;

Property AuditMessageType As %String(VALUELIST = ",DICOM,RFC3881") [ InitialExpression = "DICOM" ];

Method OnProcessInput(pRequest As HS.Message.IHE.ATNA.InboundSubmission, Output pResponse As Ens.StringContainer = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If (..UDPDebugOutputFile ] "") { Set tStatus = ..OutputToDebugFile(pRequest.StringValue) }
		Set tString = pRequest.StringValue
		Set tSyslogHeader = $Piece($Case(tString [ "<?xml", 1:$Piece(tString, "<?xml", 1), :$Piece(tString, "<AuditMessage", 1)), " ", 2, $Length(tString, " "))
		Set tAuditEvent = $Extract(tString, $Find(tString, "<AuditMessage") - $Length("<AuditMessage"), $Find(tString, "</AuditMessage>"))
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRequest.Name = "ATNA_AuditEventRequest"
		Do tRequest.AdditionalInfo.SetAt(pRequest.InboundIP,"AuditRecord:InboundIP")
		Do tRequest.AdditionalInfo.SetAt(..AuditMessageType,"AuditRecord:AuditMessageType")
		Do tRequest.ContentStream.Write(tAuditEvent), tRequest.ContentStream.Rewind()
		Set tStatus = ..SendRequestSync(..AuditRepositoryOperations, tRequest, .tResponse) $$$ThrowOnError(tStatus)
	}
	Catch eException {
		$$$LOGERROR(eException.DisplayString())

		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

Method OutputToDebugFile(pAuditMessage As %String = "") As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
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
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

}
