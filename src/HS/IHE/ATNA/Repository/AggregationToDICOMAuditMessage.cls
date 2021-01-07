Include HS.HC

Class HS.IHE.ATNA.Repository.AggregationToDICOMAuditMessage Extends %RegisteredObject
{

Property Aggregation As Aggregation;

Property AuditMessage As HS.IHE.ATNA.Repository.DICOMData.AuditMessage;

/// API Method: Convert ATNA Aggregation to ATNA DICOM Message
ClassMethod Convert(pAggregationId, Output pAuditMessageString As %String) As %Status
{
	Try {
		Set tSC=$$$OK
		Set tConverter=..%New()
		Set tConverter.Aggregation=##class(Aggregation).%OpenId(pAggregationId)
		If tConverter.Aggregation.ATNAMessage'="" Set pAuditMessageString=tConverter.Aggregation.ATNAMessage Quit
		Set tConverter.AuditMessage=##class(HS.IHE.ATNA.Repository.DICOMData.AuditMessage).%New()
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
		Do ..UserAuthenticationSource(),..HumanRequestor(), ..AuditSource()
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

/// Needed an exception because the new 2016 validator wants to exclude documents
Method "ProvideandRegisterDocumentSet-bException"() As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..Source(),..HumanRequestor(),..Destination(), ..AuditSource(),..Patients()
		Do ..Query(),..Submission()
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

/// DSUB Subscribe / CancelSubscription
Method DocumentMetadataSubscribeException() As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..Source()
		Do ..ParticipantObject(2,20,$P(..Aggregation.EventInfo,"^"),..Aggregation.AdditionalInfo.GetAt("SubscriptionAddress"),"","","","")
		Do ..HumanRequestor(),..Destination(), ..AuditSource(),..Patients(),..Documents()
		Do ..Query(),..Submission()
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

/// Exception DSUB Notification
Method DocumentMetadataNotifyException() As %Status
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..Source()
		Do ..Destination()
		Do ..HumanRequestor()
		Do ..AuditSource(),..Patients()
		Set tTopic = ..Aggregation.AdditionalInfo.GetAt("Topic")
		if tTopic = "SubmissionSetMetadata" {
			Set tHomeCommunityID = ..Aggregation.AdditionalInfo.GetAt("HomeCommunityID")
			Do ..ParticipantObject(2,3,"urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd,IHE XDS Metadata,submission set classification node",..Aggregation.AdditionalInfo.GetAt("SubmissionSetUUID"),"","",$S(tHomeCommunityID]"":"urn:ihe:iti:xca:2010:homeCommunityId;"_tHomeCommunityID,1:""))
		} Else {
			//documents
			#dim tDoc As HS.IHE.ATNA.Repository.Document
			For tI=1:1:..Aggregation.Documents.Count() {
				Set tDoc=..Aggregation.Documents.GetAt(tI)
				Set tType = $S(tDoc.ObjectType="urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248":"on-demand document entry object type",tDoc.ObjectType="":"registry object reference",1:"document entry object type")
				Set tHomeCommunityID = tDoc.HomeCommunityID
				Set tAdditional = $S(tHomeCommunityID]"":";urn:ihe:iti:xca:2010:homeCommunityId,"_tHomeCommunityID,1:"")
				Set:tDoc.RepositoryID]"" tAdditional=tAdditional_";Repository Unique Id,"_tDoc.RepositoryID
				Do ..ParticipantObject(2,3,$S(tDoc.ObjectType="":"urn:ihe:iti:2017:ObjectRef",1:tDoc.ObjectType)_",IHE XDS Metadata,"_tType,tDoc.DocumentID,"","",$Extract(tAdditional,2,*))
			}
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Exception DSUB Notification
Method DocumentMetadataPublishException() As %Status
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..Source()
		Do ..HumanRequestor()
		Do ..Destination()
		Do ..AuditSource(),..Patients()
		Set tHomeCommunityID = ..Aggregation.AdditionalInfo.GetAt("HomeCommunityID")
		Do ..ParticipantObject(2,3,"urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd,IHE XDS Metadata,submission set classification node",..Aggregation.AdditionalInfo.GetAt("SubmissionSetUUID"),"","",$S(tHomeCommunityID]"":"urn:ihe:iti:xca:2010:homeCommunityId;"_tHomeCommunityID,1:""))
		//documents
		#dim tDoc As HS.IHE.ATNA.Repository.Document
		For tI=1:1:..Aggregation.Documents.Count() {
			Set tDoc=..Aggregation.Documents.GetAt(tI)
			Set tType = $S(tDoc.ObjectType="urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248":"on-demand document entry object type",tDoc.ObjectType="":"registry object reference",1:"document entry object type")
			Set tHomeCommunityID = tDoc.HomeCommunityID
			Set tAdditional = $S(tHomeCommunityID]"":";urn:ihe:iti:xca:2010:homeCommunityId,"_tHomeCommunityID,1:"")
			Set:tDoc.RepositoryID]"" tAdditional=tAdditional_";Repository Unique Id,"_tDoc.RepositoryID
			Do ..ParticipantObject(2,3,$S(tDoc.ObjectType="":"urn:ihe:iti:2017:ObjectRef",1:tDoc.ObjectType)_",IHE XDS Metadata,"_tType,tDoc.DocumentID,"","",$Extract(tAdditional,2,*))
		}
	} Catch ex {
			Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// ITI-86 Remove Documents
Method RemoveDocumentsException() As %Status
{
	Try {
		Set tSC=$$$OK
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..Source()
		Do ..Destination()
		Do ..AuditSource()
		For tIdx = 1:1:..Aggregation.Documents.Count() {
			Set tDoc = ..Aggregation.Documents.GetAt(1)
			//Do ..ParticipantObject(2,3,"",tDoc.DocumentID,"","","urn:ihe:iti:xds:2007:repositoryUniqueId,"_tDoc.RepositoryID)
			//Method ParticipantObject(pTypeCode, pTypeCodeRole, pIDTypeCode, pID, pName = "", pQuery = "", pDetail = "", pInfoItems = "") [ Internal ]
			//<ParticipantObjectIDTypeCode csd-code="9" codeSystemName="RFC-3881" originalText="Report Number"/>
			Do ..ParticipantObject(2,3,9,tDoc.DocumentID,"","","urn:ihe:iti:xds:2007:repositoryUniqueId,"_tDoc.RepositoryID)
		}
	} Catch ex {
			Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// XDS-I [RAD-69]
Method RetrieveImagingDocumentSetException() As %Status
{
	#; Same as XCA-I
	Quit ..CrossGatewayRetrieveImagingDocumentSetException()
}

/// XCA-I [RAD-75]
Method CrossGatewayRetrieveImagingDocumentSetException() As %Status
{
	Set tSC = $$$OK
	Try {
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..HumanRequestor()
		If ..Aggregation.IsSource {  ##; DICOM Images Transferred needs source/dest
			Do ..Source()
			Do ..Destination()
		}
		Do ..AuditSource()
		Do ..Patients()
		Do ..Studies()
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method RemoveMetadataException() As %Status
{
	Set tSC = $$$OK
	Try {
		Set ..AuditMessage.EventIdentification=..Event()
		Do ..Source()
		Do ..Destination()
		Do ..AuditSource()
		Do ..Patients()
		For tIdx=1:1:..Aggregation.CustomPairs.Count() {
			Set tPair = ..Aggregation.CustomPairs.GetAt(tIdx)
			If tPair.Name'["deleted_ref::" {Continue}
			Do ..ParticipantObject(2,3,tPair.Value,$Piece(tPair.Name,"deleted_ref::",2))

		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method Event() [ Internal ]
{
	Set tEv=##class(HS.IHE.ATNA.Repository.DICOMData.EventIdentificationContents).%New()
	Set tEv.EventActionCode=$S(..Aggregation.ActionCode]"":..Aggregation.ActionCode,1:"E")
	Set tEv.EventDateTime=..Aggregation.EventDateTime
	Set tEv.EventOutcomeIndicator=+..Aggregation.Outcome
	Set tEventInfo=..Aggregation.EventInfo
	Set:tEventInfo="" tEventInfo=..GetEventInfo(..Aggregation.EventType)
	Set tEventInfo=$Replace(tEventInfo,"PIXv3","PIX") //***something has changed for DICOM
	Set tEv.EventID=..CodedValue($P(tEventInfo,"^",2),"HS.IHE.ATNA.Repository.DICOMData.EventID")
	Do tEv.EventTypeCode.Insert(..CodedValue($P(tEventInfo,"^"),"HS.IHE.ATNA.Repository.DICOMData.EventTypeCode"))
	Quit tEv
}

ClassMethod GetEventInfo(pAgEvent) [ Internal ]
{
	// [NA2018] CP-ITI-824, Change "UserAuthenticated" to "User Authentication"
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
		//,"",1,"110150,DCM,Source;"_$TR($Replace(..Aggregation.Roles,"110150",""),",",";"),..Aggregation.SourceNetworkAccess)
		,"",1,"110150,DCM,Source;",..Aggregation.SourceNetworkAccess)
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
		,"",0,"110153,DCM,Source Role ID",..Aggregation.SourceNetworkAccess)
}

Method HumanRequestor() [ Internal ]
{
	If ..Aggregation.UserName="",..Aggregation.UserFullName="",..Aggregation.SourceNetworkAccess="" Quit
	Do ..ActiveParticipant(..Aggregation.UserName,,..Aggregation.UserFullName,1,$TR(..Aggregation.Roles,",",";"),..Aggregation.SourceNetworkAccess)
}

Method Destination() [ Internal ]
{
	If ..Aggregation.DestinationNetworkAccess="",..Aggregation.DestinationURI="",..Aggregation.AdditionalInfo.GetAt("MediaType")="" Quit
	// [NA2018] Need to change "Destination" to "Destination Role ID" in ActiveParticipant, based on DICOM Spec
	Do ..ActiveParticipant(..Aggregation.DestinationURI,
		$S(..Aggregation.IsSource=0:..Aggregation.EnsembleSessionId,1:"")
		,"",0,"110152,DCM,Destination Role ID",..Aggregation.DestinationNetworkAccess,
		..Aggregation.AdditionalInfo.GetAt("MediaType"))
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
	Set tSource=##class(HS.IHE.ATNA.Repository.DICOMData.AuditSourceIdentificationContents).%New()
	Set tSource.AuditSourceID=..Aggregation.AuditSourceID
	//Need to populate AuditSourceID
	Set:tSource.AuditSourceID="" tSource.AuditSourceID=..Aggregation.InitiatedAt
	Set:tSource.AuditSourceID="" tSource.AuditSourceID=$$$HomeCommunity
	Set tSource.AuditEnterpriseSiteID=$$$HomeCommunity
	Set tSourceType=##class(HS.IHE.ATNA.Repository.DICOMData.AuditSourceTypeCodeContent).%New()
	//cp1638 - use csdcode
	Set tSourceType.csdcode=4
	Do tSource.AuditSourceTypeCode.Insert(tSourceType)
	Set ..AuditMessage.AuditSourceIdentification=tSource
}

Method ActiveParticipant(pUserId, pAlternativeUserID = "", pUserFullName = "", pUserIsRequestor As %Boolean, pRoleIDCode, pNetworkAccessPointID = "", pMediaType = "") [ Internal ]
{
	//Must populate UserID
	Set pUserId=$S(pUserId'="":pUserId,pUserFullName'="":pUserFullName,pAlternativeUserID'="":pAlternativeUserID,1:pNetworkAccessPointID)
	Set tAP=##class(HS.IHE.ATNA.Repository.DICOMData.ActiveParticipantContents).%New()
	Set tAP.UserID=pUserId,tAP.AlternativeUserID=pAlternativeUserID
	Set tAP.UserName=pUserFullName
	Set tAP.UserIsRequestor=pUserIsRequestor
	For tI=1:1:$L(pRoleIDCode,";") {
		Set tRole=$P(pRoleIDCode,";",tI)
		Do:tRole'="" tAP.RoleIDCode.Insert(..CodedValue(tRole,"HS.IHE.ATNA.Repository.DICOMData.RoleIDCode"))
	}
	Set tAP.NetworkAccessPointID=pNetworkAccessPointID
	Set:pNetworkAccessPointID'="" tAP.NetworkAccessPointTypeCode=$S($TR(pNetworkAccessPointID,"0123456789.")="":2,1:1)
	if (pMediaType '= "") {
		Set tMediaType = ##class(HS.IHE.ATNA.Repository.DICOMData.EventTypeCode).%New()
		Set tMediaType.csdcode = pMediaType
		Set tMediaType.codeSystemName = "DCM"
		Set tMediaType.originalText = $Case(pMediaType,110030:"USB Disk Emulation", 110031:"Email",110032:"CD",110033:"DVD",110034:"Compact Flash",110035:"Multi-media Card", 110036:"Secure Digital Card",110037:"URI",110010:"Film",110038:"Paper Document")
		Set tMediaType.displayName = tMediaType.originalText
		Set tMediaIdentifer = ##class(HS.IHE.ATNA.Repository.DICOMData.MediaIdentifier).%New()
		Set tMediaIdentifer.MediaType = tMediaType
		Set tAP.MediaIdentifier = tMediaIdentifer
	}
	Do ..AuditMessage.ActiveParticipant.Insert(tAP)
}

Method Patients() [ Internal ]
{
	#dim tPat As HS.IHE.ATNA.Repository.Patient
	For tI=1:1:..Aggregation.Patients.Count() {
		Set tPat=..Aggregation.Patients.GetAt(tI)
		//get identifier in format id^^^&aa&ISO
		If tPat.IdentifierType="MPIID" {
			Set tIdent=tPat.Identifier_"^^^&"_$$$AffinityDomainOID_"&ISO"
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

/// Used by XDS-I/XCA-I, @studyInstanceUID is stored in the Documents(x).DocumentID
Method Studies() [ Internal ]
{
	#dim tDoc As HS.IHE.ATNA.Repository.Document
	For tI=1:1:..Aggregation.Documents.Count() {
		Set tDoc=..Aggregation.Documents.GetAt(tI)
		Do ..ParticipantObject(2,3,"110180,DCM,Study Instance UID",tDoc.DocumentID)
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
	Set tPO=##class(HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectIdentificationContents).%New()
	Set tPO.ParticipantObjectTypeCode=pTypeCode
	Set tPO.ParticipantObjectTypeCodeRole=pTypeCodeRole
	Set pIDTypeCode=$Replace(pIDTypeCode,"PIXv3","PIX") //***something changed for DICOM
	Set:pIDTypeCode'="" tPO.ParticipantObjectIDTypeCode=..CodedValue(pIDTypeCode,"HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectIDTypeCode")
	Set tPO.ParticipantObjectID=pID
	Set tPO.ParticipantObjectName=pName
	Set tPO.ParticipantObjectQuery=pQuery
	For tI=1:1:$L(pDetail,";") {
		Set tPair=$P(pDetail,";",tI)
		Continue:$P(tPair,",",2,99)=""
		Set tPairType=##class(HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectDetail).%New()
		Set tPairType.type=$P(tPair,","),tPairType.value=$P(tPair,",",2,99)
		Do tPO.ParticipantObjectDetail.Insert(tPairType)
	}
	For tI=1:1:$L(pInfoItems,",") {
		Set tKey=$P(pInfoItems,",",tI)
		Continue:tKey=""
		Set tValue=..Aggregation.AdditionalInfo.GetAt(tKey)
		Continue:tValue=""
		Set tPairType=##class(HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectDetail).%New()
		Set tPairType.type=tKey,tPairType.value=tValue
		Do tPO.ParticipantObjectDetail.Insert(tPairType)
	}
	Do ..AuditMessage.ParticipantObjectIdentification.Insert(tPO)
}

/// ParticipantObjectSystem is for System events, and puts the detailed
/// description of the system event in the ParticipantObjectQuery string.
Method ParticipantObjectSystem(pQuery = "") [ Internal ]
{
	Set tPO=##class(HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectIdentificationContents).%New()
	Set tPO.ParticipantObjectIDTypeCode=..CodedValue("10,HealthShare,Criteria","HS.IHE.ATNA.Repository.DICOMData.ParticipantObjectIDTypeCode")
	Set tPO.ParticipantObjectID="S"
	Set tPO.ParticipantObjectQuery=pQuery
	Do ..AuditMessage.ParticipantObjectIdentification.Insert(tPO)
}

ClassMethod CodedValue(pTriplet, pClassName) As %Persistent [ Internal ]
{
	If $P(pTriplet,",")="" Set $P(pTriplet,",")=$P(pTriplet,",",3)
	If $P(pTriplet,",",3)="" Set $P(pTriplet,",",3)=$P(pTriplet,",")
	If $P(pTriplet,",",2)="" Set $P(pTriplet,",",2)="HealthShare"
	Set tCoded=$ClassMethod(pClassName,"%New")
	Set tCoded.csdcode=$P(pTriplet,",",1)
	Set tCoded.codeSystemName=$P(pTriplet,",",2)
	Set tCoded.originalText=$P(pTriplet,",",3)
	Quit tCoded
}

}
