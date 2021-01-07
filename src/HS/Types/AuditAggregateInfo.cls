Class HS.Types.AuditAggregateInfo Extends (%RegisteredObject, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property EventType As %String(MAXLEN = "");

Property EventSubType As %String(MAXLEN = "");

/// UTC Time - not what you usually want for reporting.
/// Use computed LocalDateTime for display, and computed IndexedDate for efficient queries
Property EventDateTime As %TimeStamp;

Property UserName As %String(MAXLEN = "");

/// UserName is doing the request on behalf of the ProxyUser
Property ProxyUserName As %String(MAXLEN = "");

Property Roles As %String(MAXLEN = "");

/// The Native Audit log ID, where the sequence of transactions started (where available)
Property InitiatingLogId As %String(MAXLEN = "");

/// The hub or gateway associated with the initiating log (where available)
Property InitiatedAt As %String(MAXLEN = "");

/// The native Audit log ID associated with the particular transaction (where available)
Property RecordedLogId As %String(MAXLEN = "");

/// The hub or gateway where this audit event was recorded (where available)
Property RecordedAt As %String(MAXLEN = "");

/// The Ensemble session ID, where available
Property EnsembleSessionId As %String(MAXLEN = "");

/// The ATNA Audit Message ID which has been aggregated into this format
/// No longer used as of hscore 13
Property ATNAAuditMessageId As %String(MAXLEN = "");

/// The list of MPIIDs associated with thie transaction (0 or more)
Property MPIIDs As list Of %String(MAXLEN = "");

/// The list of MRNs associate with this transaction (0 or more)
/// Each is of format: Facility^number^Assigning Authority (number might actually be a string)
Property MRNs As list Of %String(MAXLEN = "");

/// Search or other criteria
Property Criteria As %String(MAXLEN = "");

/// Push or other document ID - can contain repository gateway prefix
/// For XDSb documents, this will contain info copied from the first document, in format
///  "XDSb/"_pHomeCommunityID_"/"_pRepositoryID_"/"_pDocumentID
Property DocumentId As %String(MAXLEN = "");

/// The patient's name, for those events where we can reasonably include a single patient name
/// If there are multiple ones, this can contain the name of the first patient
Property PatientName As %String(MAXLEN = "");

/// The source of the event being audited (when available)
/// Each IHE audit message includes a source based on the SOAP addressing header
Property SourceURI As %String(MAXLEN = "");

/// The source of the event being audited (when available)
/// Each IHE audit message includes a destination based on the SOAP addressing header
Property DestinationURI As %String(MAXLEN = "");

/// For provider directory (HPD, etc.) transaction
Property ProviderName As %String(MAXLEN = "");

/// For provider directory (HPD, etc.) transaction
Property ProviderId As %String(MAXLEN = "");

/// from IHE event
Property ActionCode As %String(MAXLEN = "");

/// From IHE event
Property Outcome As %String(MAXLEN = "");

/// From IHE event source
Property SourceNetworkAccess As %String(MAXLEN = "");

/// From IHE event destination ;
Property DestinationNetworkAccess As %String(MAXLEN = "");

/// From IHE human requestor
Property UserFullName As %String(MAXLEN = "");

/// From IHE Audit Source
Property AuditSourceID As %String(MAXLEN = "");

/// From XDS submission set
Property SubmissionSetUniqueID As %String(MAXLEN = "");

/// From IHE/ATNA Query
Property QueryRequestID As %String(MAXLEN = "");

/// For externally received ATNA events - the XML string for the full ATNA message
Property ATNAMessage As %String(MAXLEN = "");

/// recorded for IHE events logged by HealthShare - most of these log two events,
/// one for the source and one for the destination
Property IsSource As %Boolean;

/// For IHE events, this will contain the event type triplet_"^"_the event ID triplet.
/// Should someone submit an IHE event as an aggregation via the API, this must be populated.
Property EventInfo As %String(MAXLEN = 180);

/// To hold misc. other items
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

/// For externally received ATNA events - is the XML string stored in ATNAMessage DICOM or RFC3881
/// Populated for all newly received message - this will be blank for messages predating DICOM support,
/// and therefore treated as RFC3881
Property ATNAMessageType As %String(VALUELIST = ",DICOM,RFC3881");

}
