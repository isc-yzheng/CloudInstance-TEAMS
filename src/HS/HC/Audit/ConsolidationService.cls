Include (%ZHSLIB, HS.IHE.ATNA)

Class HS.HC.Audit.ConsolidationService Extends (Ens.BusinessService, HS.HC.Util.Trace.Helper) [ Inheritance = right, ProcedureBlock ]
{

Parameter ADAPTER = "HS.Util.InboundAdapterNoWait";

Parameter DOMAIN = "HS";

/// A comma separated list of additional operations to invoke after an audit event is saved.
/// These can save events in external repositories, generate email alerts, etc.
/// This should only be used when this service is deployed in the audit database.
Property AuditAlertOperations As %String(MAXLEN = 512);

Parameter SETTINGS As %String = "AuditAlertOperations:Basic,Timeout";

Method OnProcessInput(pInput As %RegisteredObject = "", pOutput As %RegisteredObject, pHint) As %Status
{
	Set ..%WaitForNextCallInterval=1
	//this should only run in an audit instance, either in the registry or in an audit repository
	If '($$$IsRunningAuditInstance(tAuditDB)) || (tAuditDB'=$Namespace) Quit $$$OK
	Quit ..ProcessAlerts()
}

Method ProcessAlerts() As %Status
{
	Try {
		Set tSC=$$$OK
		For {
			Set tAgKey=$O(^HS.AuditAlertQueue("")) Quit:tAgKey=""
			Set tSingleFailure=0
			IF $TR(..AuditAlertOperations,",")'="" {
				#dim tAuditAlertRequest As HS.Message.AuditAlertRequest
				Set tAggregate=##class(HS.IHE.ATNA.Repository.Aggregation).%OpenId(tAgKey)
				If '$IsObject(tAggregate) {
					//shouldn't happen, but just in case . . . but don't log failure otherwise we'll get stuck
					$$$LOGERROR($$$FormatText($$$Text("Unable to open Audit Aggregation message with key:%1"),tAgKey))
				} Else {
					For tI=1:1:$L(..AuditAlertOperations,",") {
						Set tOperation=$TR($P(..AuditAlertOperations,",",tI)," ")
						/// if we have an operation, and we haven't sent to this operation previously
						If tOperation'="" && '$G(^HS.AuditAlertQueue(tAgKey,tOperation)) {
							Set tAuditAlertRequest=##class(HS.Message.AuditAlertRequest).%New()
							Set tSC=##Class(HS.Message.AuditAlertRequest).CopyFrom(tAggregate,.tAuditAlertRequest)
							If $$$ISERR(tSC) {
								$$$LOGERROR($$$FormatText($$$Text("Unable to copy Audit Aggregation message with key:%1"),tAgKey))
								$$$LOGSTATUS(tSC)
								Continue
							}
							Set tAuditAlertRequest.AggregationId=tAgKey
							Set tSC=..SendRequestAsync(tOperation,tAuditAlertRequest)
							If $$$ISERR(tSC) {
								$$$LOGERROR($$$FormatText($$$Text("Unable to send Audit Alert Request message with key:%1 to operation %2"),tAgKey,tOperation))
								$$$LOGSTATUS(tSC)
							}
						}
					}
				}
			}
			Kill ^HS.AuditAlertQueue(tAgKey)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

}
