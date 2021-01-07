Include (HS.IHE.ATNA, HS.IHE.XCPD)

Class HS.IHE.XCPD.InitiatingGateway.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "IHEVersion,-TargetName,-SOAPVersion,-SSLConfiguration,-SOAPCredentials";

Property IHEVersion As %Integer [ InitialExpression = 1 ];

Property IHEExtension As %String;

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()

		If (pRequest.Name = "XCPD_PatientDiscoveryRequest") {
			Set tAction					= "urn:hl7-org:v3:PRPA_IN201305UV02:CrossGatewayPatientDiscovery"
			Set pResponse.Name			= "XCPD_PatientDiscoveryResponse"
			Set ..TargetName = pRequest.AdditionalInfo.GetAt("TargetName")
			$$$HSTRACE("XCPD Request","pRequestName,pRequest,TargetName",pRequest.Name,pRequest.ContentStream,..TargetName)
			Set tSC	=..InvokeWebService(,,tAction, pRequest, .pResponse)
			$$$HSTRACE("Web Service Response","pResponse,tSC",pResponse.ContentStream,tSC)
			Do $$$ATNAEvent("XCPDInitiatingGateway",pRequest,pResponse,tSC)
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
	} Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	Quit tSC
}

}
