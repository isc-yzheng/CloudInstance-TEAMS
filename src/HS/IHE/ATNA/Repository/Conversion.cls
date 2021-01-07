/// Upgrade Conversion to HSCORE 13 Aggregation structure
Class HS.IHE.ATNA.Repository.Conversion [ Abstract ]
{

/// This will run through all existing logs, in reverse order (most recent first)
/// If the old AuditMessage structure exists for any entry, it will convert that entry
/// and then purge it
ClassMethod Convert() As %Status
{
	Try {
		Set tSC=$$$OK
		If '$D(^HS.IHE.Audit("Conversion")) Set ^HS.IHE.Audit("Conversion")=$G(^HS.IHE.Audit("AggregationD"))+1
		For {
			Set tID=^HS.IHE.Audit("Conversion")
			Set tID=$O(^HS.IHE.Audit("AggregationD",tID),-1)
			If tID {
				Set tSC=..ConvertOne(tID, .tDoUpdate, .tAg,.tATNAPurge,.tIsUnknown)
				Quit:$$$ISERR(tSC)  // error in convertone
				If tIsUnknown {
					//unknown event, gotta xml export the whole thing
					Set tAuditMessage=##class(HS.IHE.ATNA.Repository.Data.AuditMessage).%OpenId(tATNAPurge)
					Set tXML="",tSC=tAuditMessage.XMLExportToString(.tXML,"AuditMessage")
					Set tAg.ATNAMessage=tXML
				}
				If tDoUpdate {
					Do ##Class(HS.IHE.ATNA.Repository.Aggregation).PreSave(.tAg)
					Set tSC=tAg.%Save()
					Quit:$$$ISERR(tSC)  // error in save
				}
				//We have already nulled out this Aggregation's ATNAAuditMessageId
				//We first zap any other Aggregation records pointing to this, which may have
				//been created because in earlier versions, if there were multiple XDSb documents,
				//we'd create one aggregation record per document
				&SQL(Delete HS_IHE_ATNA_Repository.Aggregation WHERE ATNAAuditMessageId=:tATNAPurge)
				//Now we can delete the AuditMessage
				Do ##class(HS.IHE.ATNA.Repository.Exclusion).PurgeATNA(tATNAPurge)
			}
			Set ^HS.IHE.Audit("Conversion")=tID
			Quit:'tID
		}
		Quit:$$$ISERR(tSC)
		Kill ^HS.IHE.Audit("AggregationI","MRNs"),^HS.IHE.Audit("AggregationI","MPIIDs")
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

ClassMethod ConvertOne(pID, Output pDoUpdate, Output pAg As HS.IHE.ATNA.Repository.Aggregation, Output pATNAPurge, Output pIsUnknown As %Boolean) As %Status
{
	Try {
		Set pDoUpdate=0, pATNAPurge="", pIsUnknown=0
		Set tSC=$$$OK
		Set pAg=##class(HS.IHE.ATNA.Repository.Aggregation).%OpenId(pID)
		Quit:'$ISOBJECT(pAg)
		Quit:pAg.ATNAAuditMessageId=""
		Set tAuditMessage=##class(HS.IHE.ATNA.Repository.Data.AuditMessage).%OpenId(pAg.ATNAAuditMessageId)
		Quit:'$ISOBJECT(tAuditMessage)
		Set pDoUpdate=1
		Set pATNAPurge=pAg.ATNAAuditMessageId, pAg.ATNAAuditMessageId=""
		Set tEvt=$ZCVT(pAg.EventType,"L")
		Set tSysEvents=$LB("login","logout","loginfailure","software configuration","audit recording started",
			"audit recording stopped","object security attributes changed","security roles changed",
			"user security attributes changed","application start","application stop")
		If $LF(tSysEvents,tEvt) {
			Set pAg.ActionCode=tAuditMessage.EventIdentification.EventActionCode
			Set pAg.Outcome=tAuditMessage.EventIdentification.EventOutcomeIndicator
			Set pAg.AuditSourceID=tAuditMessage.AuditSourceIdentification.GetAt(1).AuditSourceID
			Do ##class(HS.IHE.ATNA.Repository.Data.AuditMessage).Participants(tAuditMessage,.pAg)
			Quit
		}
		Set tInternalEvents=$LB("patientsearch","searchpatient","searchpatientbreakglass","recordrequest",
			"recordrequestbreakglass","exportrecords","viewrecords","consentupdate-p","consentupdate-s",
			"consentupdate-f","consentevaluation","consentevaluationbreakglass","documentrequest","documentsend",
			"addrelationship","removerelationship")
		If $LF(tInternalEvents,tEvt) {
			//Need to create patient relationships
			Set tMPIIDs=$LFS(pAg.MPILIST,", "), tMRNs=$LFS(pAg.MRNLIST,", ")
			Do pAg.AddPatientList(tMPIIDs,tMRNs,pAg.PatientName)
			Quit
		}
		If tAuditMessage.EventIdentification.EventTypeCode.Count() {
			//this should always be true for IHE events
    		Set tEvent=tAuditMessage.EventIdentification.EventTypeCode.GetAt(1)
    		Set tEventId=tAuditMessage.EventIdentification.EventID
    		Set pAg.EventInfo=tEvent.code_","_tEvent.codeSystemName_","_tEvent.displayName_"^"
    			_tEventId.code_","_tEventId.codeSystemName_","_tEventId.displayName
		}
		Set pAg.ActionCode=tAuditMessage.EventIdentification.EventActionCode
		Set pAg.Outcome=tAuditMessage.EventIdentification.EventOutcomeIndicator
		Set pAg.AuditSourceID=tAuditMessage.AuditSourceIdentification.GetAt(1).AuditSourceID
		Do ##class(HS.IHE.ATNA.Repository.Data.AuditMessage).Participants(tAuditMessage,.pAg)
		Set tIHEEvents=$LB("document metadata notify","document metadata publish","document metadata subscribe",
			"patient demographics query","patient identity feed","pix query","pixv3 add","pixv3 update","pixv3 delete",
			"pixv2 add","pixv2 update","pixv2 delete","pixv3 query","cross gateway query","cross gateway retrieve",
			"cross gateway patient discovery","distribute document set on media","provide and register document set-b",
			"registry stored query","multi-patient query","register document set-b","register on-demand document entry"
			,"retrieve document set","update document set","update document set","notify xad-pid link change")
		Set:'$LF(tIHEEvents,tEvt) pIsUnknown=1
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

ClassMethod Test(pTest = "")
{
	Set tNewTest=$I(^Test.HS.IHE.Audit)
	Merge ^Test.HS.IHE.Audit(tNewTest)=^HS.IHE.Audit
	If pTest {
		Kill ^HS.IHE.Audit
		Merge ^HS.IHE.Audit=^Test.HS.IHE.Audit(pTest)
	}
	Do ..Convert()
}

ClassMethod Test2(pTest = "")
{
	Set tNewTest=$I(^Test.HS.IHE.Audit)
	Merge ^Test.HS.IHE.Audit(tNewTest)=^HS.IHE.Audit
	If pTest {
		Kill ^HS.IHE.Audit
		Merge ^HS.IHE.Audit=^Test.HS.IHE.Audit(pTest)
	}
	Kill ^Test2.HS.IHE.Audit
	For tID=1:1:$G(^HS.IHE.Audit("AggregationD")) {
		Continue:'$D(^HS.IHE.Audit("AggregationD",tID))
		Set tSC=..ConvertOne(tID, .tDoUpdate, .tAg,.tATNAPurge,.tIsUnknown)
		If $$$ISERR(tSC) Break  // error in convertone
		If tIsUnknown Break   //unknown
		If tATNAPurge {
			Set tAuditMessage=##class(HS.IHE.ATNA.Repository.Data.AuditMessage).%OpenId(tATNAPurge)
			Set tXML="",tSC=tAuditMessage.XMLExportToString(.tXML,"AuditMessage")
			Set ^Test2.HS.IHE.Audit(tID,"RAW")=tXML
			
			Set tSC=$$$OK
			Set tConverter=##class(HS.IHE.ATNA.Repository.AggregationToAuditMessage).%New()
			Set tConverter.Aggregation=tAg
			Set tConverter.AuditMessage=##class(HS.IHE.ATNA.Repository.Data.AuditMessage).%New()
			Set tSC=tConverter.Conversion()
			Break:$$$ISERR(tSC)
			Set tSC=tConverter.AuditMessage.XMLExportToString(.tATNAString,"AuditMessage")
			Break:tID=2358
			Set ^Test2.HS.IHE.Audit(tID,"GEN")=tATNAString
		}
			
	}
}

}
