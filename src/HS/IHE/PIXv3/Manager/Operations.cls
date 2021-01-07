Include (HS.HC, HS.IHE.PIX, HS.IHE.ATNA)

Class HS.IHE.PIXv3.Manager.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base) [ Inheritance = right, ProcedureBlock ]
{

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		If (pRequest.Name = "PIXv3_QueryRequest") {
			Set tAction = "urn:hl7-org:v3:PRPA_IN201309UV02"
			Set pResponse.Name	= "PIXv3_QueryResponse"
		} ElseIf (pRequest.Name = "PIXv3_PatientAddRequest") {
			Set tAction = "urn:hl7-org:v3:PRPA_IN201301UV02"
			Set pResponse.Name = "PIXv3_PatientAddResponse"
		} ElseIf (pRequest.Name = "PIXv3_PatientReviseRequest") {
			Set tAction = "urn:hl7-org:v3:PRPA_IN201302UV02"
			Set pResponse.Name = "PIXv3_PatientReviseResponse"
		} ElseIf (pRequest.Name = "PIXv3_PatientMergeRequest") {
			Set tAction = "urn:hl7-org:v3:PRPA_IN201304UV02"
			Set pResponse.Name = "PIXv3_PatientMergeResponse"
		} Else {
			Set tStatus = $$$EnsError("Unknown message type received:  " _ pRequest.Name)

			Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		}

		Set tStatus = ..InvokeWebService(,, tAction, pRequest, .pResponse)
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}

	Quit tStatus
}

}
