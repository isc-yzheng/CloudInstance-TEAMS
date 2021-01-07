Class HS.IHE.ATNA.Repository.Operations Extends (Ens.BusinessOperation, HS.IHE.Common.Actor.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		
		If (pRequest.Name = "ATNA_AuditEventRequest") {
			Set tStatus = ..SaveAuditEvent(pRequest, .pResponse) Quit:$$$ISERR(tStatus)
		}
		Else {
			Set tStatus = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
	}
	Catch eException {
		Set pResponse = $$$NULLOREF
		
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

Method SaveAuditEvent(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set tType=pRequest.AdditionalInfo.GetAt("AuditRecord:AuditMessageType")
		If tType="RFC3881" {
			Set tStatus = ##class(HS.IHE.ATNA.Repository.Data.AuditMessage).SaveRequest(pRequest, .tAuditIndex) $$$ThrowOnError(tStatus)
		} Else {
			Set tStatus = ##class(HS.IHE.ATNA.Repository.DICOMData.AuditMessage).SaveRequest(pRequest, .tAuditIndex) $$$ThrowOnError(tStatus)
		}
		Set tStatus = tAuditIndex.XMLExportToStream(.tAuditIndexStream) $$$ThrowOnError(tStatus)

		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = "ATNA_AuditEventResponse"
		Set pResponse.DocType = "AuditMessage"
		Set pResponse.ContentStream = tAuditIndexStream
	}
	Catch eException {
		Set pResponse = $$$NULLOREF
		
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

}
