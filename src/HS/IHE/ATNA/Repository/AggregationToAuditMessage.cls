Include HS.HC

Class HS.IHE.ATNA.Repository.AggregationToAuditMessage Extends %RegisteredObject
{

Property Aggregation As Aggregation;

Property AuditMessage As HS.IHE.ATNA.Repository.Data.AuditMessage;

/// API Method: Convert ATNA Aggregation to ATNA Message
ClassMethod Convert(pAggregationId, Output pAuditMessageString As %String) As %Status
{
	Try {
		Set tSC=$$$OK
		Set tConverter=..%New()
		Set tConverter.Aggregation=##class(Aggregation).%OpenId(pAggregationId)
		If tConverter.Aggregation.ATNAMessage'="" Set pAuditMessageString=tConverter.Aggregation.ATNAMessage Quit
		Set tConverter.AuditMessage=##class(HS.IHE.ATNA.Repository.Data.AuditMessage).%New()
		Set tSC=tConverter.Conversion()
		Quit:$$$ISERR(tSC)
		Set tSC=tConverter.AuditMessage.XMLExportToString(.pAuditMessageString,"AuditMessage")
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

Method Conversion() As %Status [ Internal ]
{
	Set tSC=$$$OK
	// If we already have the ATNAMessage there's nothing to convert
	If ..Aggregation.ATNAMessage'="" Quit $$$OK
	Set tEvent=..Aggregation.EventType
	Set tMethod=$TR(tEvent," _")_"Exception"
	Try {
		Set tSC=$Method(,tMethod)
	} Catch ex {
		If ex.Name="<METHOD DOES NOT EXIST>" {
			Set tSC=..Generic()
		} Else {
			Set tSC = ex.AsStatus()	
		}
	}
	Quit tSC
}

Method Generic() As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..Source(),..HumanRequestor(),..Destination(), ..AuditSource(),..Patients(),..Documents()
		Do ..Query(),..Submission()
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

/// LoginException uses the logic from method UserAuthentication.
Method LoginException() As %Status [ Internal ]
{
	Quit ..UserAuthentication()
}

/// LoginFailureException uses the logic from method UserAuthentication.
Method LoginFailureException() As %Status [ Internal ]
{
	Quit ..UserAuthentication()
}

/// LogoutException uses the logic from method UserAuthentication.
Method LogoutException() As %Status [ Internal ]
{
	Quit ..UserAuthentication()
}

/// UserAuthentication handles audit records for Login, LoginFailure
/// and Logout.  The Source ActiveParticipant is built by the
/// UserAuthenticationSource method instead of the Source method.
/// HumanRequestor, Destination, Patients, Documents, Query and
/// Submission elements are omitted.
Method UserAuthentication() As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..UserAuthenticationSource(), ..AuditSource()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// ApplicationStartException uses the logic from method ApplicationActivity.
Method ApplicationStartException() As %Status [ Internal ]
{
	Quit ..ApplicationActivity()
}

/// ApplicationStopException uses the logic from method ApplicationActivity.
Method ApplicationStopException() As %Status [ Internal ]
{
	Quit ..ApplicationActivity()
}

/// ApplicationActivity handles audit records for Application Start
/// and Application Stop.  The Source ActiveParticipant is built by
/// the ApplicationStartSource method instead of the Source method.
/// AuditSourceIdentification is built by ApplicationStartAuditSource
/// instead of AuditSource.  Destination, Patients, Documents, Query
/// and Submission elements are omitted.
Method ApplicationActivity() As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..ApplicationActivitySource(),..HumanRequestor(), ..AuditSource()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// AuditRecordingStartedException uses the logic from method SecurityAlert.
Method AuditRecordingStartedException() As %Status [ Internal ]
{
	Quit ..SecurityAlert()
}

/// AuditRecordingStoppedException uses the logic from method SecurityAlert.
Method AuditRecordingStoppedException() As %Status [ Internal ]
{
	Quit ..SecurityAlert()
}

/// SoftwareConfigurationException uses the logic from method SecurityAlert.
Method SoftwareConfigurationException() As %Status [ Internal ]
{
	Quit ..SecurityAlert()
}

/// UserSecurityAttributesChangedException uses the logic from method SecurityAlert.
Method UserSecurityAttributesChangedException() As %Status [ Internal ]
{
	Quit ..SecurityAlert()
}

/// ObjectSecurityAttributesChangedException uses the logic from method SecurityAlert.
Method ObjectSecurityAttributesChangedException() As %Status [ Internal ]
{
	Quit ..SecurityAlert()
}

/// SecurityRolesChangedException uses the logic from method SecurityAlert.
Method SecurityRolesChangedException() As %Status [ Internal ]
{
	Quit ..SecurityAlert()
}

/// SecurityAlert handles audit records for Audit Recording Started,
/// Audit Recording Stopped, Software Configuration, User Security
/// Attributes Changed, Object Security Attributes Changed and
/// Security Roles Changed.  Source, Destination, Patients,
/// Documents and Submission elements are omitted.
Method SecurityAlert() As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..HumanRequestor(), ..AuditSource()
		Do ..Query()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// RetrieveDocumentSetException handles the reversed nature of
/// Source and Destination for Retrieve Document Set.  For this
/// event the Repository is considered to be the Source and the
/// Consumer is considered to be the Destination.  The Source
/// ActiveParticipant is built by the RetrieveDocumentSetSource
/// method instead of the Source method.  The Destination
/// ActiveParticipant is built byRetrieveDocumentSetDestination
/// instead of Destination.
Method RetrieveDocumentSetException() As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..RetrieveDocumentSetSource(),..HumanRequestor(),..RetrieveDocumentSetDestination(), ..AuditSource(),..Patients(),..Documents()
		Do ..Query(),..Submission()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method Event() [ Internal ]
{
	Set tEv=##class(HS.IHE.ATNA.Repository.Data.EventIdentificationType).%New()
	Set tEv.EventActionCode=$S(..Aggregation.ActionCode]"":..Aggregation.ActionCode,1:"E")
	Set tEv.EventDateTime=..Aggregation.EventDateTime
	Set tEv.EventOutcomeIndicator=+..Aggregation.Outcome
	Set tEventInfo=..Aggregation.EventInfo
	Set:tEventInfo="" tEventInfo=..GetEventInfo(..Aggregation.EventType)
	Set tEv.EventID=..CodedValue($P(tEventInfo,"^",2))
	Do tEv.EventTypeCode.Insert(..CodedValue($P(tEventInfo,"^")))
	Quit tEv
}

ClassMethod GetEventInfo(pAgEvent) [ Internal ]
{
	Quit $Case($zcvt(pAgEvent,"L"),
		"login":"110122,DCM,Login^110114,DCM,User Authentication",
		"logout":"110123,DCM,Logout^110114,DCM,User Authentication",
		"loginfailure":"110122,DCM,Login^110114,DCM,User Authentication",
		"software configuration":"110131,DCM,Software Configuration^110113,DCM,Security Alert",
		"audit recording started":"110134,DCM,Audit Recording Started^110113,DCM,Security Alert",
		"audit recording stopped":"110133,DCM,Audit Recording Stopped^110113,DCM,Security Alert",
		"object security attributes changed":"110135,DCM,Object Security Attributes Changed^110113,DCM,Security Alert",
		"security roles changed":"110136,DCM,Security Roles Changed^110113,DCM,Security Alert",
		"user security attributes changed":"110137,DCM,User Security Attributes Changed^110113,DCM,Security Alert",
		"application start":"110120,DCM,Application Start^110100,DCM,Application Activity",
		"application stop":"110121,DCM,Application Stop^110100,DCM,Application Activity",:",,"_pAgEvent_"^,,"_pAgEvent
	)
}

Method Source() [ Internal ]
{
	If ..Aggregation.SourceNetworkAccess="",..Aggregation.SourceURI="" Quit
	// [NA2018] Need to change "Source" to "Source Role ID" in ActiveParticipant, based on DICOM Spec
	Do ..ActiveParticipant(..Aggregation.SourceURI,
		$S(..Aggregation.IsSource:..Aggregation.EnsembleSessionId,1:"")
		,"",1,"110153,DCM,Source Role ID",..Aggregation.SourceNetworkAccess)
}

/// UserAuthenticationSource builds a Source ActiveParticipant
/// for Login, LoginFailure and Logout.  The User ID is UserName
/// instead of SourceURI.  The RoleIDCode for the ActiveParticipant
/// is 110150 instead of 110153.
Method UserAuthenticationSource() [ Internal ]
{
	If ..Aggregation.SourceNetworkAccess="",..Aggregation.SourceURI="" Quit
	Do ..ActiveParticipant(..Aggregation.UserName,
		$S(..Aggregation.IsSource:..Aggregation.EnsembleSessionId,1:"")
		,"",1,"110150,DCM,Source;"_$TR($Replace(..Aggregation.Roles,"110150",""),",",";"),..Aggregation.SourceNetworkAccess)
}

/// ApplicationActivitySource builds a Source ActiveParticipant for
/// Application Start and Application Stop.  The UserIsRequestor
/// flag is specified as 0 instead of 1.  The RoleIDCode for the
/// ActiveParticipant is 110150 instead of 110153.
Method ApplicationActivitySource() [ Internal ]
{
	If ..Aggregation.SourceNetworkAccess="",..Aggregation.SourceURI="" Quit
	// [NA2018] Need to change "Source" to "Application" in ActiveParticipant, based on DICOM Spec
	Do ..ActiveParticipant(..Aggregation.SourceURI,
		$S(..Aggregation.IsSource:..Aggregation.EnsembleSessionId,1:"")
		,"",0,"110150,DCM,Application",..Aggregation.SourceNetworkAccess)
}

/// RetrieveDocumentSetSource builds a Source ActiveParticipant for
/// Retrieve Document Set.  Inclusion of AlternativeUserID is based
/// on the IsSource flag being 0 instead of 1.
Method RetrieveDocumentSetSource() [ Internal ]
{
	If ..Aggregation.SourceNetworkAccess="",..Aggregation.SourceURI="" Quit
	// [NA2018] Need to change "Source" to "Source Role ID" in ActiveParticipant, based on DICOM Spec
	Do ..ActiveParticipant(..Aggregation.SourceURI,
		$S(..Aggregation.IsSource=0:..Aggregation.EnsembleSessionId,1:"")
		,"",1,"110153,DCM,Source Role ID",..Aggregation.SourceNetworkAccess)
}

Method HumanRequestor() [ Internal ]
{
	Do ..ActiveParticipant(..Aggregation.UserName,,..Aggregation.UserFullName,1,$TR(..Aggregation.Roles,",",";"),..Aggregation.SourceNetworkAccess)
}

Method Destination() [ Internal ]
{
	If ..Aggregation.DestinationNetworkAccess="",..Aggregation.DestinationURI="" Quit
	// [NA2018] Need to change "Destination" to "Destination Role ID" in ActiveParticipant, based on DICOM Spec
	Do ..ActiveParticipant(..Aggregation.DestinationURI,
		$S(..Aggregation.IsSource=0:..Aggregation.EnsembleSessionId,1:"")
		,"",0,"110152,DCM,Destination Role ID",..Aggregation.DestinationNetworkAccess)
}

/// RetrieveDocumentSetDestination builds a Destination ActiveParticipant
/// for Retrieve Document Set.  Inclusion of AlternativeUserID is based
/// on the IsSource flag being 1 instead of 0.
Method RetrieveDocumentSetDestination() [ Internal ]
{
	If ..Aggregation.DestinationNetworkAccess="",..Aggregation.DestinationURI="" Quit
	// [NA2018] Need to change "Destination" to "Destination Role ID" in ActiveParticipant, based on DICOM Spec
	Do ..ActiveParticipant(..Aggregation.DestinationURI,
		$S(..Aggregation.IsSource:..Aggregation.EnsembleSessionId,1:"")
		,"",0,"110152,DCM,Destination Role ID",..Aggregation.DestinationNetworkAccess)
}

Method AuditSource() [ Internal ]
{
	Set tSource=##class(HS.IHE.ATNA.Repository.Data.AuditSourceIdentificationType).%New()
	Set tSource.AuditSourceID=..Aggregation.AuditSourceID
	//Need to populate AuditSourceID
	Set:tSource.AuditSourceID="" tSource.AuditSourceID=..Aggregation.InitiatedAt
	Set:tSource.AuditSourceID="" tSource.AuditSourceID=$$$HomeCommunity
	Set tSource.AuditEnterpriseSiteID=$$$HomeCommunity
	Do tSource.AuditSourceTypeCode.Insert(..CodedValue(4))
	Do ..AuditMessage.AuditSourceIdentification.Insert(tSource)
}

Method ActiveParticipant(pUserId, pAlternativeUserID = "", pUserFullName = "", pUserIsRequestor As %Boolean, pRoleIDCode, pNetworkAccessPointID = "") [ Internal ]
{
	//Must populate UserID
	Set pUserId=$S(pUserId'="":pUserId,pUserFullName'="":pUserFullName,pAlternativeUserID'="":pAlternativeUserID,1:pNetworkAccessPointID)
	Set tAP=##class(HS.IHE.ATNA.Repository.Data.ActiveParticipant).%New()
	Set tAP.UserID=pUserId,tAP.AlternativeUserID=pAlternativeUserID
	Set tAP.UserName=pUserFullName
	Set tAP.UserIsRequestor=pUserIsRequestor
	For tI=1:1:$L(pRoleIDCode,";") {
		Set tRole=$P(pRoleIDCode,";",tI)
		Do:tRole'="" tAP.RoleIDCode.Insert(..CodedValue(tRole))
	}
	Set tAP.NetworkAccessPointID=pNetworkAccessPointID
	Set:pNetworkAccessPointID'="" tAP.NetworkAccessPointTypeCode=$S($TR(pNetworkAccessPointID,"0123456789.")="":2,1:1)
	Do ..AuditMessage.ActiveParticipant.Insert(tAP)
}

Method Patients() [ Internal ]
{
	#dim tPat As HS.IHE.ATNA.Repository.Patient
	For tI=1:1:..Aggregation.Patients.Count() {
		Set tPat=..Aggregation.Patients.GetAt(tI)
		//get identifier in format id^^^&aa&ISO
		If tPat.IdentifierType="MPIID" {
			Set tIdent=tPat.Identifier_"^^^&"_$$$HomeCommunityOID_"&ISO"
		} Else {
			Set tNum=$P(tPat.Identifier,"^",2),tAA=$P(tPat.Identifier,"^",3)
			Set tAAOid=##class(HS.Data.OIDMap).GetOIDForCode(tAA)
			Set tIdent=tNum_"^^^&"_tAAOid_"&ISO"
		}
		Do ..ParticipantObject(1,1,"2,RFC-3881,Patient Number",tIdent,tPat.PatientName,,tPat.RequestId)
	}
}

Method Documents() [ Internal ]
{
	#dim tDoc As HS.IHE.ATNA.Repository.Document
	For tI=1:1:..Aggregation.Documents.Count() {
		Set tDoc=..Aggregation.Documents.GetAt(tI)
		Do ..ParticipantObject(2,3,"9,RFC-3881,Report Number",tDoc.DocumentID,"","","Repository Unique Id,"_tDoc.RepositoryID_";ihe:homeCommunityID,"_tDoc.HomeCommunityID)
	}
}

Method Query() [ Internal ]
{
	If ..Aggregation.QueryRequestID'=""&&(..Aggregation.EventInfo'="") {
		Do ..ParticipantObject(2,24,$P(..Aggregation.EventInfo,"^"),..Aggregation.QueryRequestID,"",..Aggregation.Criteria,"","MSH-10,QueryEncoding,urn:ihe:iti:xca:2010:homeCommunityId")
	} ElseIf ..Aggregation.Criteria'=""&&(..Aggregation.EventInfo'="") {
		Do ..ParticipantObject(2,24,"10,HealthShare,Criteria",..Aggregation.QueryRequestID,"",..Aggregation.Criteria)
	} ElseIf ..Aggregation.Criteria'="" {
		Do ..ParticipantObjectSystem(..Aggregation.Criteria)
	}
}

Method Submission() [ Internal ]
{
	Set tSub=..Aggregation.SubmissionSetUniqueID  Quit:tSub=""
	Do ..ParticipantObject(2,20,"urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd,IHE XDS Metadata,submission set classificationNode",tSub)
}

/// The pairs can either come from pDetail (a semicolon delimited list of comma delimited pairs),
/// or from pInfoItems (a comma delimited list of keys into the additional info property
Method ParticipantObject(pTypeCode, pTypeCodeRole, pIDTypeCode, pID, pName = "", pQuery = "", pDetail = "", pInfoItems = "") [ Internal ]
{
	Set tPO=##class(HS.IHE.ATNA.Repository.Data.ParticipantObjectIdentificationType).%New()
	Set tPO.ParticipantObjectTypeCode=pTypeCode
	Set tPO.ParticipantObjectTypeCodeRole=pTypeCodeRole
	Set:pIDTypeCode'="" tPO.ParticipantObjectIDTypeCode=..CodedValue(pIDTypeCode)
	Set tPO.ParticipantObjectID=pID
	Set tPO.ParticipantObjectName=pName
	Set tPO.ParticipantObjectQuery=pQuery
	For tI=1:1:$L(pDetail,";") {
		Set tPair=$P(pDetail,";",tI)
		Continue:$P(tPair,",",2,99)=""
		Set tPairType=##class(HS.IHE.ATNA.Repository.Data.TypeValuePairType).%New()
		Set tPairType.type=$P(tPair,","),tPairType.value=$P(tPair,",",2,99)
		Do tPO.ParticipantObjectDetail.Insert(tPairType)
	}
	For tI=1:1:$L(pInfoItems,",") {
		Set tKey=$P(pInfoItems,",",tI)
		Continue:tKey=""
		Set tValue=..Aggregation.AdditionalInfo.GetAt(tKey)
		Continue:tValue=""
		Set tPairType=##class(HS.IHE.ATNA.Repository.Data.TypeValuePairType).%New()
		Set tPairType.type=tKey,tPairType.value=tValue
		Do tPO.ParticipantObjectDetail.Insert(tPairType)
	}
	Do ..AuditMessage.ParticipantObjectIdentification.Insert(tPO)
}

/// ParticipantObjectSystem is for System events, and puts the detailed
/// description of the system event in the ParticipantObjectQuery string.
Method ParticipantObjectSystem(pQuery = "") [ Internal ]
{
	Set tPO=##class(HS.IHE.ATNA.Repository.Data.ParticipantObjectIdentificationType).%New()
	Set tPO.ParticipantObjectIDTypeCode=..CodedValue("10,HealthShare,Criteria")
	Set tPO.ParticipantObjectID="S"
	Set tPO.ParticipantObjectQuery=pQuery
	Do ..AuditMessage.ParticipantObjectIdentification.Insert(tPO)
}

ClassMethod CodedValue(pTriplet) As HS.IHE.ATNA.Repository.Data.CodedValueType [ Internal ]
{
	If $P(pTriplet,",")="" Set $P(pTriplet,",")=$P(pTriplet,",",3)
	If $P(pTriplet,",",2)="" Set $P(pTriplet,",",2)="HealthShare"
	Set tCoded=##class(HS.IHE.ATNA.Repository.Data.CodedValueType).%New()
	Set tCoded.code=$P(pTriplet,",",1)
	Set tCoded.codeSystemName=$P(pTriplet,",",2)
	Set tCoded.displayName=$P(pTriplet,",",3)
	Quit tCoded
}

}
