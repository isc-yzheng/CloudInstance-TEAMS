/// Outbound adapter for HL7 v2 over TCP.
/// This subclass is intended only to override the SETTINGS parameter
/// of EnsLib.HL7.Adapter.TCPOutboundAdapter, so that we can hide the
/// settings that are covered by TCP Service Registry entries.
Class HS.Util.TCPClient.TCPHL7OutboundAdapter Extends EnsLib.HL7.Adapter.TCPOutboundAdapter [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter SETTINGS = "-IPAddress,-Port,-StayConnected,-SSLConfig";

}
