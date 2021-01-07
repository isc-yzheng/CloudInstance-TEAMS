/// This class provides some stripped down methods for handling specific types
/// of audit events.  The full API is in %ZHSLIB.Audit.Log
/// These methods consolidate many of the calls.
Class HS.Audit.LogSimple [ Abstract ]
{

/// This can be called on an access gateway to create the initial log for a patient search
/// It logs it for the current user & roles. See below for args
ClassMethod PatientSearch(ByRef pInitiatingLogID As %String, pCriteria As %String, pProxyUserID As %String = "") As %Status [ Internal ]
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create("PatientSearch",.pInitiatingLogID)
	Set tAggregation.Criteria=pCriteria, tAggregation.InitiatingLogId=pInitiatingLogID
	Set tAggregation.ProxyUserName=pProxyUserID
	Quit tAggregation.RecordAudit(tAggregation)
}

/// API Method: Simplified API to Log a SearchPatient event type.  This is invoked on the hub,
/// once a request has been made, before it returns the results.
/// This returns a %Status, and outputs the inintiating log ID (if not already passed in), which needs to be passed
/// to the edge gateway for the RecordRequest, and then used on the access gateway for the
/// ViewRecord event.
/// pUserID and pRoles are for the user on the access gateway.
/// pMPIIDList is a list of MPI IDs, in $LB format
/// pMRNList is a list of MRNs, in $LB format, where each MRN is facility_"^"_actual MRN_"^"_AssigningAuthority
/// pCriteria contains the search criteria, including any authorization info
/// pBreakGlass is a boolean - If true, will log the search as break the glass
/// pSessionId is an optional Ensemble Session Id
ClassMethod SearchPatient(ByRef pInitiatingLogID As %String, pUserID As %String, pRoles As %String, pAccessGateway As %String, pMPIIDList As %String, pMRNList As %String, pCriteria As %String, pBreakGlass As %Boolean = 0, pSessionId As %String = "", pProxyUserID As %String = "") As %Status
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create($S(pBreakGlass:"SearchPatientBreakGlass",1:"SearchPatient"),.pInitiatingLogID,pAccessGateway)
	Set tAggregation.Criteria=pCriteria, tAggregation.InitiatingLogId=pInitiatingLogID
	Set tAggregation.ProxyUserName=pProxyUserID
	Set tAggregation.UserName=pUserID,tAggregation.Roles=pRoles
	Set tAggregation.Criteria=pCriteria
	Set tAggregation.EnsembleSessionId=pSessionId
	Do tAggregation.AddPatientList(pMPIIDList,pMRNList)
	Quit tAggregation.RecordAudit(tAggregation)
}

/// API Method: Simplified API to Log a RecordRequest event type.  This is invoked on the edge gateway,
/// once a request has been made, before it returns the results.
/// This returns a %Status, and passes in the initiating log ID that was generated on the
/// hub by the SearchPatient.
/// pMRN is in the format facility_"^"_actual MRN_"^"_AssigningAuthority
/// pSDA is the SDA document that gets returned
/// pCriteria contains authorization info
/// pBreakGlass is a boolean - if true, it will log the fetch as break the glass
ClassMethod RecordRequest(ByRef pInitiatingLogID As %String, pUserID As %String, pRoles As %String, pAccessGateway As %String, pMRN As %String, pSDA = "", pCriteria As %String = "", pBreakGlass As %Boolean = 0, pSessionId As %String = "", pProxyUserID As %String = "", pPatName As %String = "", pMPIID As %String = "") As %Status
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create($S(pBreakGlass:"RecordRequestBreakGlass",1:"RecordRequest"),.pInitiatingLogID,pAccessGateway)
	Set tAggregation.Criteria=pCriteria, tAggregation.InitiatingLogId=pInitiatingLogID
	Set tAggregation.ProxyUserName=pProxyUserID
	Set tAggregation.UserName=pUserID,tAggregation.Roles=pRoles
	Set tAggregation.Criteria=pCriteria
	Set tAggregation.EnsembleSessionId=pSessionId
	Do tAggregation.AddPatient(pMPIID,"MPIID",pPatName),tAggregation.AddPatient(pMRN,"MRN",pPatName)
	Set tSC=##class(%ZHSLIB.Audit.Log).CreateSDALog(pInitiatingLogID,tAggregation.EventType,.pSDA,.tSDALog)
	Quit:$$$ISERR(tSC) tSC
	Set tAggregation.RecordedLogId=tSDALog
	Quit tAggregation.RecordAudit(tAggregation)
}

/// API Method: Simplified API to Log a ViewRecords event type.  This is invoked on the access gateway,
/// after the patient lookup, and prior to passing the combined SDA to the viewer.
/// This returns a %Status, and passes in the initiating log ID that was generated on the
/// hub by the SearchPatient.
/// pMRNList is a list of MRNs, in $LB format, where each MRN is facility_"^"_actual MRN_"^"_AssigningAuthority
/// pAPI is used for API based and XDS-b dynamic content fetches
/// pDummy is no longer used
ClassMethod ViewRecords(pDummy, pInitiatingLogID As %String, pUserID As %String, pRoles As %String, pAccessGateway As %String, pMRNList As %String, pSessionId As %String = "", pProxyUserID As %String = "", pPatName As %String = "", pAPI As %Boolean = 0, pMPIIDList = "") As %Status
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create($S(pAPI:"ExportRecords",1:"ViewRecords"),.pInitiatingLogID,pAccessGateway)
	Set tAggregation.ProxyUserName=pProxyUserID
	Set tAggregation.UserName=pUserID,tAggregation.Roles=pRoles
	Set tAggregation.EnsembleSessionId=pSessionId
	Do tAggregation.AddPatientList(pMPIIDList,pMRNList,pPatName)
	Quit tAggregation.RecordAudit(tAggregation)
}

/// API Method: Simplified API to Log a Consent Policy Update event type.  This is invoked on the hub,
/// when the policy is updated.
/// This returns a %Status.  Unlike many of the other events, this happens in isolation,
/// so it doesn't need to worry about the initiating log ID
/// pUserID and pRoles are for the user on the access gateway.
/// pUID is a the patient's MPI ID, or the facility code for facility policy, or null for system-wide
/// pConsentPolicy contains a string representing both the old and new entire consent policy
/// pType is "P" for patient policy (default), "F" for facility policy, or "S" for System-Wide
ClassMethod ConsentUpdate(pUserID As %String = "", pRoles As %String = "", pAccessGateway As %String = "", pUID As %String, pConsentPolicy As %String, pType As %String = "P", pPatName As %String = "") As %Status
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create("ConsentUpdate-"_pType,.pInitiatingLogID,pAccessGateway)
	Set:pRoles="" pRoles=$Roles
	Set:pUserID="" pUserID=$UserName
	Set tAggregation.UserName=pUserID,tAggregation.Roles=pRoles
	Set tAggregation.Criteria=pConsentPolicy
	If pType="P" {
		Do tAggregation.AddPatient(pUID,"MPIID",pPatName)
	} ElseIf pType="F" {
		Set tAggregation.FacilityInternal=pUID
	}
	Quit tAggregation.RecordAudit(tAggregation)
}

/// API Method: Simplified API to Log a consent evaluation event type.  This is invoked on the hub,
/// by the MPI Consent Engine.
/// This returns a %Status, and passes in the initiating log ID that was generated on the
/// hub by the SearchPatient.
/// pMPIID is the patient's MPIID
/// pMRN is in the format facility_"^"_actual MRN_"^"_AssigningAuthority
/// pPolicySnapshots contains the pointers to the 3 relevant snapshots of consent policies needed to do this.
///  in the format system-wide snapshot ID_"^"_facility-wide snapshot ID_"^"_patient snapshot ID
/// pBreakGlass is a boolean - if true, it will log this as consent evaluation with break the glass
/// pSessionId is an option Ensemble session ID
ClassMethod ConsentEvaluation(ByRef pInitiatingLogID As %String, pUserID As %String, pRoles As %String, pAccessGateway As %String, pMRN As %String, pMPIID As %String, pBreakGlass As %Boolean = 0, pPolicySnapshots As %String, pSessionId As %String = "", pProxyUserID As %String = "", pPatName As %String = "") As %Status
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create($S(pBreakGlass:"ConsentEvaluationBreakGlass",1:"ConsentEvaluation"),.pInitiatingLogID,pAccessGateway)
	Set tAggregation.ProxyUserName=pProxyUserID
	Set tAggregation.UserName=pUserID,tAggregation.Roles=pRoles
	Set tAggregation.EnsembleSessionId=pSessionId
	Do tAggregation.AddPatient(pMPIID,"MPIID",pPatName)
	Do tAggregation.AddPatient(pMRN,"MRN",pPatName)
	Set tAggregation.DocumentId=pPolicySnapshots
	Quit tAggregation.RecordAudit(tAggregation)
}

/// Methods to log sending & requesting push documents
/// pSource should contain the facility code and subscription subject that created the document,
/// or, for ad-hoc messages, the clinician name
ClassMethod DocumentRequest(pUserID, pRoles, pGateway, pMPIID, pDocumentId, pSource, pPatName As %String = "") [ Internal ]
{
	Quit ..PushDocument("DocumentRequest",pUserID,pRoles,pGateway,pMPIID,pDocumentId,pSource,pPatName)
}

ClassMethod DocumentSend(pUserID, pRoles, pGateway, pMPIID, pDocumentId, pSource, pPatName As %String = "", pDocType As %String = "") As %Status [ Internal ]
{
	Quit ..PushDocument("DocumentSend||"_pDocType,pUserID,pRoles,pGateway,pMPIID,pDocumentId,pSource,pPatName)
}

ClassMethod PushDocument(pEvent, pUserID, pRoles, pGateway, pMPIID, pDocumentId, pSource, pPatName As %String = "") As %Status [ Internal ]
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create($P(pEvent,"||"),.pInitiatingLogID,pGateway)
	Set tAggregation.EventSubType=$P(pEvent,"||",2)
	Set tAggregation.UserName=pUserID,tAggregation.Roles=pRoles
	Do tAggregation.AddPatient(pMPIID,"MPIID",pPatName)
	Set tAggregation.DocumentId=pDocumentId
	Set tAggregation.Criteria=pSource
	Quit tAggregation.RecordAudit(tAggregation)
}

/// Audit relationship change.  pAddOrRemove should be "Add" or "Remove".  pDetails should contain
/// the relationship name as well as the clinician name
ClassMethod AddRemoveRelationShip(pUserID, pRoles, pGateway, pMPIID, pAddOrRemove, pDetails, pPatName As %String = "", pMRNs As %Library.ListOfDataTypes = "") [ Internal ]
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create(pAddOrRemove_"Relationship",.pInitiatingLogID,pGateway)
	Set tAggregation.UserName=pUserID,tAggregation.Roles=pRoles
	If pMPIID'="" Do tAggregation.AddPatient(pMPIID,"MPIID",pPatName)
	If $IsObject(pMRNs) && pMRNs.Count()>0{
		For tI = 1:1:pMRNs.Count(){
			Do tAggregation.AddPatient(pMRNs.GetAt(tI),"MRN",pPatName)
		}
	}
	Set tAggregation.Criteria=pDetails
	Quit tAggregation.RecordAudit(tAggregation)
}

/// UIDList is $LB(MPIIDs)
ClassMethod LogGen(ByRef pInitiatingLogID As %String, pEventID As %String, pUserID As %String, pRoles As %String, pAccessGateway As %String, pMPIIDList As %String = "", pMRNList As %String = "", pCriteria As %String = "", pSDA = "", pSessionId As %String = "", pProxyUserID As %String = "", pPatName As %String = "") As %Status [ Internal ]
{
	#DIM logref as %ZHSLIB.Audit.Log
	Set tSC=##Class(%ZHSLIB.Audit.Log).CreateLog(.logref,.pInitiatingLogID,pEventID,,,,pUserID,pRoles,pAccessGateway,pProxyUserID)
	QUIT:$$$ISERR(tSC) tSC
	IF pCriteria'="" {Set tSC=logref.AddParticipant(10,,"S",,pCriteria)
		QUIT:$$$ISERR(tSC) tSC}
	FOR i=1:1:$LL(pMPIIDList) {
		Set tSC=logref.AddParticipant(2,,$List(pMPIIDList,i),pPatName) QUIT:$$$ISERR(tSC)
	}
	QUIT:$$$ISERR(tSC) tSC
	FOR i=1:1:$LL(pMRNList) {
		Set tSC=logref.AddParticipant(1,,$List(pMRNList,i),pPatName) QUIT:$$$ISERR(tSC)
	}
	QUIT:$$$ISERR(tSC) tSC
	If pSessionId'="" {Set tSC=logref.AddParticipant(21,,pSessionId) Q:$$$ISERR(tSC) tSC}
	IF pSDA'="" {Set tSC=logref.LogSDA(.pSDA) QUIT:$$$ISERR(tSC) tSC}
	QUIT logref.SaveLog()
}

ClassMethod ActorStart(pActor As %String) As %Status [ Internal ]
{
	Quit ..ActorStartStop(pActor,"Start")
}

ClassMethod ActorStop(pActor As %String) As %Status [ Internal ]
{
	Quit ..ActorStartStop(pActor,"Stop")
}

ClassMethod ActorStartStop(pActor As %String, pStartStop As %String) As %Status [ Internal ]
{
	#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
	Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create("Application "_pStartStop)
	Set tAggregation.Criteria=pActor, tAggregation.SourceURI=pActor
	Quit tAggregation.RecordAudit(tAggregation)
}

}
