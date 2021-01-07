/// Class used to create and/or send PDQv2 Query message to PDQv2 Supplier 
Class HS.Util.HL7Client.Operations Extends (EnsLib.HL7.Operation.TCPOperation, HS.IHE.Common.Actor.Base) [ DependsOn = HS.HC.Util.Trace.Helper, Inheritance = right, ProcedureBlock ]
{

Parameter FOUNDATION = 1;

Parameter ADAPTER = "HS.Util.TCPClient.TCPHL7OutboundAdapter";

Parameter SETTINGS = "ServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItemsByParam?Type=TCP},SendingApplication,SendingFacility";

/// The service name found in HS.Registry.Service.*
Property ServiceName As %String(MAXLEN = 512);

/// Used as the sender facility code - IdentityCode from the HS.Data.OIDMap table
Property SendingFacility As %String;

/// Converted sender facility code to OID
Property SendingFacilityOID As %String(MAXLEN = 64);

/// Caches Service Registry information for the currently selected service.
/// Format is: $lb(Service Name, Service %Id, Device OID, Assigning Authority, Receiving Application, Receiving Facility, Host, Port, StayConnected, SSLConfig)
Property RegistryService As %String;

/// Used as the sending application for MSH:3 - does not need to be an IdentityCode from the HS.Data.OIDMap table
Property SendingApplication As %String(MAXLEN = 256);

XData MessageMap
{
<MapItems>
	<MapItem MessageType="EnsLib.HL7.Message"> 
		<Method>SetService</Method>
	</MapItem>
</MapItems>
}

Method OnMessage(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
	$$$HSTRACEMIN("ServiceRequest", "RequestContent", pRequest.OutputToString())
	Set tSC=##super(pRequest, .pResponse)
	Quit:$$$ISERR(tSC) tSC
	$$$HSTRACEMIN("ServiceResponse", "ResponseContent", pResponse.OutputToString())
	Quit tSC
}

Method SetService(pRequest As EnsLib.HL7.Message, ByRef pResponse As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("HL7 Request Envelope", "pRequest.Envelope", pRequest.Envelope)
		
		// Clone pRequest to tHL7Request so that changes are only applied to tHL7Request.
		Set tHL7Request = pRequest.%ConstructClone(1)
		
		Set tServiceName = $Piece($Piece(tHL7Request.Envelope,"|ServiceName=",2),"|",1)
		If tServiceName'="" Do ..UpdateRegistryService(tServiceName)
		
		Set tSendingApplication = tHL7Request.GetValueAt("MSH:3.1")
		If tSendingApplication="" Do tHL7Request.SetValueAt(..SendingApplication, "MSH:3.1")
		
		Set tSendingFacility = tHL7Request.GetValueAt("MSH:4.1")
		If tSendingFacility="" Do tHL7Request.SetValueAt(..SendingFacility, "MSH:4.1")
		
		Set tSC = ..OnMessage(tHL7Request, .pResponse)
		Quit:$$$ISERR(tSC)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method OnInit() As %Status
{
	Set tSC=$$$OK
	try {
		Set tSC = ##super()
		If $$$ISERR(tSC) Quit
		Set ..SendingFacilityOID = ##class(HS.Data.OIDMap).OIDForType(..SendingFacility,"Device")
		If ..ServiceName'="" Do ..UpdateRegistryService(..ServiceName)
		Set ..SendingApplication = ##class(HS.IHE.Util).GetSendingApplication(..SendingApplication)
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

/// OnGetReplyAction is overridden here because the reply actions are being
/// handled later in the PIXv2/PDQv2 code, and because at this point pRequest
/// is already converted to PatientSearchResponse by the PDQv2 code.
Method OnGetReplyAction(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message, ByRef pSC As %Status) As %String
{
	Quit ""
}

}
