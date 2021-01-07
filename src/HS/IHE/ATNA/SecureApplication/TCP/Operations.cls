Class HS.IHE.ATNA.SecureApplication.TCP.Operations Extends (Ens.BusinessOperation, HS.IHE.ATNA.SecureApplication.Syslog.Common, HS.IHE.Common.Actor.Base, HS.HC.Util.Trace.Helper) [ Inheritance = right, ProcedureBlock ]
{

Parameter ADAPTER = "HS.IHE.ATNA.SecureApplication.TCP.TextLineOutboundAdapter";

Parameter INVOCATION = "Queue";

Parameter LOGCONNECTIONS = 0;

Parameter SETTINGS = "ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=TCP},TCPDebugOutputFile,AuditMessageType,CustomAuditMessageClass";

Property TCPDebugOutputFile As %String;

/// The service name found in HS.Registry.Service.*
Property ServiceName As %String(MAXLEN = 512);

/// Caches Service Registry information for the currently selected service.
/// Format is: $lb(Service Name, Service %Id, Device OID, Assigning Authority, Receiving Application, Receiving Facility, Host, Port, StayConnected, SSLConfig)
Property RegistryService As %String;

Property AuditMessageType As %String(VALUELIST = ",DICOM,RFC3881,CUSTOM") [ InitialExpression = "DICOM" ];

/// When AuditMessageType is set to CUSTOM the class which will generate the ATNA message (likely an extension of HS.IHE.ATNA.Repository.AggregationToDICOMAuditMessage)
Property CustomAuditMessageClass As %String(MAXLEN = "");

Method OnMessage(pRequest As %Persistent, Output pResponse As %Persistent = {$$$NULLOREF}) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		If pRequest.%IsA("HS.Message.AuditAlertRequest") {
			Quit:##class(HS.IHE.ATNA.Repository.Aggregation).%OpenId(pRequest.AggregationId).ATNAMessage'=""
			Set tSyslogHeader = ..GetSyslogHeader() If (tSyslogHeader = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "An error occured while creating the syslog header for audit record ID '" _ pRequest.AggregationId _ "'"))
			Set tXMLHeader = "<?xml version=""1.0"" encoding=""UTF-8""?>"
			If ..AuditMessageType="CUSTOM" {
				Set tSC=$classmethod(..CustomAuditMessageClass,"Convert",pRequest.AggregationId,.tAuditEvent)
			} ElseIf ..AuditMessageType="RFC3881" {
				Set tSC=##class(HS.IHE.ATNA.Repository.AggregationToAuditMessage).Convert(pRequest.AggregationId,.tAuditEvent)
			} Else {
				Set tSC=##class(HS.IHE.ATNA.Repository.AggregationToDICOMAuditMessage).Convert(pRequest.AggregationId,.tAuditEvent)
			}				
			Set tAuditEvent = $Case(..StripWhitespace, 1:$Translate(tAuditEvent, $Char(13, 10, 9), ""), :tAuditEvent) If (tAuditEvent = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "Empty ATNA audit record with ID '" _ pRequest.AggregationId _ "' not sent"))
			Set tAuditMessage = (tSyslogHeader _ " " _ tXMLHeader _ tAuditEvent), tAuditMessage = $Length(tAuditMessage) _ " " _ tAuditMessage

			If (..TCPDebugOutputFile ] "") { Set tStatus = ..OutputToDebugFile(tAuditMessage) $$$ThrowOnError(tStatus) }
			$$$HSTRACE("Audit Message","tAuditMessage,Service",tAuditMessage,..ServiceName)
			Set tStatus = ..Adapter.SendMessageString(tAuditMessage) $$$ThrowOnError(tStatus)
		}
		ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			Set tSyslogHeader = ..GetSyslogHeader() If (tSyslogHeader = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "An error occured while creating the syslog header for audit record ID '" _ pRequest.AggregationId _ "'"))
			Set tXMLHeader = "<?xml version=""1.0"" encoding=""UTF-8""?>"

			Set tAuditEvent = "" While 'pRequest.ContentStream.AtEnd { Set tAuditEvent = tAuditEvent _ pRequest.ContentStream.Read() }
			Set tAuditEvent = $Case(..StripWhitespace, 1:$Translate(tAuditEvent, $Char(13, 10, 9), ""), :tAuditEvent) If (tAuditEvent = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "Empty ATNA audit record with ID '" _ pRequest.AggregationId _ "' not sent"))
			Set tAuditMessage = (tSyslogHeader _ " " _ tXMLHeader _ tAuditEvent), tAuditMessage = $Length(tAuditMessage) _ " " _ tAuditMessage
			
			If (..TCPDebugOutputFile ] "") { Set tStatus = ..OutputToDebugFile(tAuditMessage) $$$ThrowOnError(tStatus) }
			///MIKE: Trace it so we can easly find audits for adding to gazelle
			$$$HSTRACE("Audit Message","tAuditMessage",tAuditMessage)
			Set tStatus = ..Adapter.SendMessageString(tAuditMessage) $$$ThrowOnError(tStatus)
		}
		Else {
			Set tStatus = $$$EnsError("Unknown message type received:  " _ pRequest.%ClassName(1)) $$$ThrowOnError(tStatus)
		}
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
		$$$LOGSTATUS(tStatus)
	}
	
	Set pResponse = ##class(HS.Message.XMLMessage).%New()
	Set pResponse.Name = "ATNA_AuditEventResponse"

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

Method OnInit() As %Status
{
	Set tSC=$$$OK
	try {
		Set tSC = ##super()
		If $$$ISERR(tSC) Quit
		If ..ServiceName'="" Do ..UpdateRegistryService(..ServiceName)
		If (..AuditMessageType="CUSTOM") {
			If ..CustomAuditMessageClass="" {
				Set tSC = $$$ERROR($$$GeneralError,"CustomAuditMessageClass required when CUSTOM is selected for AuditMessageType")
				Quit
			} ElseIf '##class(%Library.CompiledClass).%ExistsId(..CustomAuditMessageClass) {
				Set tSC = $$$ERROR($$$GeneralError,"CustomAuditMessageClass requires a valid value when CUSTOM Audit Message Type is selected")
				Quit
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

/// UpdateRegistryService updates - if needed - the info in the RegistryService
/// property.  Update is based on pService, the ServiceName setting, and the
/// info currently in RegistryService.  The ServiceName setting is the default
/// service name to use, and may be overridden by pRequest.AdditionalInfo.GetAt("ServiceName").
/// If RegistryService is updated, then the properties on this BO's TCP adapter
/// are also updated.
/// If Service Registry settings on a TCP service are changed, then this BO
/// should be restarted to guarantee that the changes are effective at run time.
Method UpdateRegistryService(pService)
{
	Set:pService="" pService=..ServiceName
	If $lg(..RegistryService)'=pService,pService'="" {
		Set tRegistryService = ##class(HS.Registry.Service.TCP).EndPointForNameType(pService,"TCP")
		If $IsObject(tRegistryService) {
			Set tDeviceOID=##class(HS.Data.OIDMap).OIDForType(tRegistryService.OIDMapCode.GetAt("Device"),"Device")
			Set ..RegistryService = $lb(tRegistryService.Name,tRegistryService.%Id(),tDeviceOID,tRegistryService.OIDMapCode.GetAt("AssigningAuthority"),tRegistryService.OIDMapCode.GetAt("ReceivingApplication"),tRegistryService.OIDMapCode.GetAt("ReceivingFacility"),tRegistryService.Host,tRegistryService.Port,tRegistryService.StayConnected,tRegistryService.SSLConfig)
			Set ..Adapter.IPAddress = tRegistryService.Host
			Set ..Adapter.Port = tRegistryService.Port
			Set ..Adapter.StayConnected = tRegistryService.StayConnected
			Set ..Adapter.SSLConfig = tRegistryService.SSLConfig
		}
	}
}

}
