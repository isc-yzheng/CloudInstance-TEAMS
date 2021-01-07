ROUTINE HS.IHE.XDSb [Type=INC]
#define XDSbQueryAction(%Version)		$S(%Version=1:"urn:ihe:iti:2007:RegistryStoredQuery",1:"SOAP Action not defined "_%Version)
#define XDSbQueryMultiPatientAction(%Version)	$S(%Version=1:"urn:ihe:iti:2009:MultiPatientStoredQuery",1:"SOAP Action not defined "_%Version)
#define XDSbQueryMultiPatientResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2009:MultiPatientStoredQueryResponse",1:"SOAP Action not defined "_%Version)
#define XDSbQueryResponseAction(%Version)		$S(%Version=1:"urn:ihe:iti:2007:RegistryStoredQueryResponse",1:"SOAP Action not defined "_%Version)
#define XDSbQueryRequest				"XDSb_QueryRequest"
#define XDSbQueryMultiPatientRequest	"XDSb_QueryMultiPatientRequest"
#define XDSbQueryResponse				"XDSb_QueryResponse"
#define XDSbRegisterAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:RegisterDocumentSet-b",1:"SOAP Action not defined "_%Version)
#define XDSbRegisterResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:RegisterDocumentSet-bResponse",1:"SOAP Action not defined "_%Version)
#define XDSbRegisterRequest				"XDSb_RegisterRequest"
#define XDSbRegisterResponse			"XDSb_RegisterResponse"
#define XDSbUpdateDocumentSetAction(%Version)	$S(%Version=1:"urn:ihe:iti:2010:UpdateDocumentSet",1:"SOAP Action not defined "_%Version)
#define XDSbUpdateDocumentSetResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2010:UpdateDocumentSetResponse",1:"SOAP Action not defined "_%Version)
#define XDSbUpdateDocumentSetRequest	"XDSb_UpdateDocumentSetRequest"
#define XDSbUpdateDocumentSetResponse	"XDSb_UpdateDocumentSetResponse"
#define XDSbDeleteDocumentSetAction(%Version)	$S(%Version=1:"urn:ihe:iti:2010:DeleteDocumentSet",1:"SOAP Action not defined "_%Version)
#define XDSbDeleteDocumentSetResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2010:DeleteDocumentSetResponse",1:"SOAP Action not defined "_%Version)
#define XDSbDeleteDocumentSetRequest	"XDSb_DeleteDocumentSetRequest"
#define XDSbDeleteDocumentSetResponse	"XDSb_DeleteDocumentSetResponse"

#define XDSbRegisterOnDemandAction(%Version)	$S(%Version=1:"urn:ihe:iti:2010:RegisterOnDemandDocumentEntry",1:"SOAP Action not defined "_%Version)
#define XDSbRegisterOnDemandResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2010:RegisterOnDemandDocumentResponse",1:"SOAP Action not defined "_%Version)
#define XDSbRegisterOnDemandRequest				"XDSb_RegisterOnDemandRequest"
#define XDSbRegisterOnDemandResponse			"XDSb_RegisterOnDemandResponse"
#define XDRProvideAndRegisterAction(%Version) $S(%Version=1:"urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b",1:"SOAP Action not defined "_%Version)
#define XDRProvideAndRegisterResponseAction(%Version) $S(%Version=1:"urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-bResponse",1:"SOAP Action not defined "_%Version)
#define XDRProvideAndRegisterRequest		"XDR_ProvideAndRegisterRequest"
#define XDRProvideAndRegisterResponse		"XDR_ProvideAndRegisterResponse"

#; IHE XDSb Push Stable/OnDemand Related
#define XDSbPushDeliveryRequest 				"XDSb_PushDeliveryRequest"
#define XDSbOnDemandPersistenceRequest	"XDSb_OnDemandPersistenceRequest"
#define XDSbOnDemandDocumentList				"XDSb_OnDemandDocumentList"

#; XDSb RegistryStoredQuery type UUIDs (ITI TF-2a: 3.18.4.1.2.4)
#define XDSbQueryFindDocuments          "urn:uuid:14d4debf-8f97-4251-9a74-a90016b0af0d"
#define XDSbQueryFindSubmissionSets     "urn:uuid:f26abbcb-ac74-4422-8a30-edb644bbc1a9"
#define XDSbQueryFindFolders            "urn:uuid:958f3006-baad-4929-a4de-ff1114824431"
#define XDSbQueryGetAll					"urn:uuid:10b545ea-725c-446d-9b95-8aeb444eddf3"
#define XDSbQueryGetDocuments           "urn:uuid:5c4f972b-d56b-40ac-a5fc-c8ca9b40b9d4"
#define XDSbQueryGetFolders             "urn:uuid:5737b14c-8a1a-4539-b659-e03a34a5e1e4"
#define XDSbQueryGetAssociations        "urn:uuid:a7ae438b-4bc2-4642-93e9-be891f7bb155"
#define XDSbQueryGetDocsAndAssociations "urn:uuid:bab9529a-4a10-40b3-a01f-f68a615d247a"
#define XDSbQueryGetSubmissionSets      "urn:uuid:51224314-5390-4169-9b91-b1980040715a"
#define XDSbQueryGetSubSetsAndContents  "urn:uuid:e8e3cb2c-e39c-46b9-99e4-c12f57260b83"
#define XDSbQueryGetFolderAndContents   "urn:uuid:b909a503-523d-4517-8acf-8e5834dfc4c7"
#define XDSbQueryGetFoldersForDocument  "urn:uuid:10cae35a-c7f9-4cf5-b61e-fc3278ffb578"
#define XDSbQueryGetRelatedDocuments    "urn:uuid:d90e5407-b356-4d91-a89f-873917b4b0e6"
#define XDSbQueryFindDocumentsByReferenceId "urn:uuid:12941a89-e02e-4be5-967c-ce4bfc8fe492"
#; XDSb multi patient
#define XDSbQueryFindDocumentsMultiPatients "urn:uuid:3d1bdb10-39a2-11de-89c2-2f44d94eaa9f"
#define XDSbQueryFindFoldersMultiPatients "urn:uuid:50d3f5ac-39a2-11de-a1ca-b366239e58df"
#; XDSb ExtrinsicObject type UUIDs
#define XDSbStableDocument   "urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1"
#define XDSbOnDemandDocument "urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248"

#define QueryFailure "urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"
#define QuerySuccess "urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success"
#define QueryPartialSuccess "urn:ihe:iti:2007:ResponseStatusType:PartialSuccess"

#; macros require for the HS.IHE.XDSb.Repository transactions
#define XDSbProvideAndRegisterAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-b",1:"SOAP Action not defined "_%Version)
#define XDSbProvideAndRegisterResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:ProvideAndRegisterDocumentSet-bResponse",1:"SOAP Action not defined "_%Version)
#define XDSbProvideAndRegisterRequest			"XDSb_ProvideAndRegisterRequest"
#define XDSbProvideAndRegisterResponse			"XDSb_ProvideAndRegisterResponse"
#define XDSbRetrieveAction(%Version)			$S(%Version=1:"urn:ihe:iti:2007:RetrieveDocumentSet",1:"SOAP Action not defined "_%Version)
#define XDSbRetrieveResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2007:RetrieveDocumentSetResponse",1:"SOAP Action not defined "_%Version)
#define XDSbRetrieveRequest						"XDSb_RetrieveRequest"
#define XDSbRetrieveResponse					"XDSb_RetrieveResponse"

#define XDMDistributeDocumentSetOnMediaRequest "XDM_DistributeDocumentSetOnMediaRequest"

#define RMUDocumentSetAction(%Version)	$S(%Version=1:"urn:ihe:iti:2018:RestrictedUpdateDocumentSet",1:"SOAP Action not defined "_%Version)
#define RMUDocumentSetResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2018:RestrictedUpdateDocumentSetResponse",1:"SOAP Action not defined "_%Version)
#define RMUDocumentSetRequest	"RMU_DocumentSetRequest"
#define RMUDocumentSetResponse	"RMU_DocumentSetResponse"

#; RMDAction relates to Repository as the registry was previously defined as DeleteDocumentSet
#define RMDAction(%Version)	$S(%Version=1:"urn:ihe:iti:2017:RemoveDocuments",1:"SOAP Action not defined "_%Version)
#define RMDResponseAction(%Version)	$S(%Version=1:"urn:ihe:iti:2017:RemoveDocumentsResponse",1:"SOAP Action not defined "_%Version)
#define RMDRequest					"RMDRequest"
#define RMDResponse					"RMDResponse"
