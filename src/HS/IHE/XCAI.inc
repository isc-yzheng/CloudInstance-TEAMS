ROUTINE HS.IHE.XCAI [Type=INC]
#; IHE XCA-I related Actions
#;
#define XCAIRetrieveAction(%Version)         $S(%Version=1:"urn:ihe:rad:2011:CrossGatewayRetrieveImagingDocumentSet",1:"SOAP Action not defined "_%Version)
#define XCAIRetrieveResponseAction(%Version) $S(%Version=1:"urn:ihe:rad:2011:CrossGatewayRetrieveImagingDocumentSetResponse",1:"SOAP Action not defined "_%Version)
#define XCAIRetrieveRequest                  "XCAI_RetrieveRequest"
#define XCAIRetrieveResponse                 "XCAI_RetrieveResponse"

#; XDS-I for IG service and IG/RG operations
#;
#define XDSIRetrieveAction(%Version)         $S(%Version=1:"urn:ihe:rad:2009:RetrieveImagingDocumentSet",1:"SOAP Action not defined "_%Version)
#define XDSIRetrieveResponseAction(%Version) $S(%Version=1:"urn:ihe:iti:2007:RetrieveDocumentSetResponse",1:"SOAP Action not defined "_%Version)
#define XDSIRetrieveRequest                  "XDSI_RetrieveRequest"
#define XDSIRetrieveResponse                 "XDSI_RetrieveResponse"

#; Actors for ATNA
#;
#define ATNAActorImagingInitiatingGW        "InitiatingImagingGateway"
#define ATNAActorImagingRespondingGW        "RespondingImagingGateway"
#define ATNAActorImagingSource              "ImagingDocumentSource"
#define ATNAActorImagingConsumer            "ImagingDocumentConsumer"

#; Response status
#;
#define XCAIStatusFailure "Failure"
#define XCAIStatusPartial "PartialSuccess"
#define XCAIStatusSuccess "Success"

#; Response error serverity
#;
#define XCAISeverityError   "Error"
#define XCAISeverityWarning "Warning"

#; Response error codes - only these are allowed XDS-I/XCA-I Retrieve
#; See: ITI TF Vol3 Table 4.2.4.1-2: Error Codes, TF RAD Vol 3, 4.69.5
#; 
#define XCAIError                        "XDSRepositoryError"
#define XCAIErrorUnknownRepositoryId     "XDSUnknownRepositoryId"
#define XCAIErrorUnknownCommunity        "XDSUnknownCommunity"
#define XCAIErrorMissingHomeCommunityId  "XDSMissingHomeCommunityId"
#define XCAIErrorUnavailableCommunity    "XDSUnavailableCommunity"
#define XCAIErrorDocumentUniqueIdError   "XDSDocumentUniqueIdError"
#; -- the following are uncommon, not used by HS
#define XCAIErrorBusy                    "XDSRepositoryBusy"
#define XCAIErrorOutOfResources          "XDSRepositoryOutOfResources"
#define XCAIErrorResultNotSinglePatient  "XDSResultNotSinglePatient"


