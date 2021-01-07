Class HS.IHE.XDSb.Types.Document Extends ObjectRef [ Inheritance = right ]
{

Parameter XMLIGNORENULL = "INPUTONLY";

/*
	Internal properties, not part of the XDSb spec
*/
/// The context to create this document (MPI, MRN, Encounter, etc)
Property Context As HS.IHE.XDSb.Types.Context;

/// For on-demand documents, the snapshot ID, UniqueID and Repository
Property Snapshot As HS.IHE.XDSb.Types.Document;

/// Binary document stream
Property Body As %Stream.GlobalBinary;

/// Character document stream, if present, will be used to extract CDA information and copied to the submission attachments, unless a Body stream is defined.
Property BodyCharacter As %Stream.GlobalCharacter;

Property ZipItems As list Of HS.Types.ZipItem;

/*
	XDSb DocumentEntry properties
*/
/// List of document authors
Property Author As list Of HS.IHE.XDSb.Types.Author(XMLPROJECTION = "ELEMENT");

/// Document status, generated by the registry
Property AvailabilityStatus As %String(VALUELIST = ",Approved,Deprecated");

/// The kind of document
Property ClassCode As HS.IHE.XDSb.Types.CodedValue;

/// Comments
Property Comments As %String(MAXLEN = "");

/// The level of confidentiality - to be addressed in future IHE specifications
Property ConfidentialityCode As list Of HS.IHE.XDSb.Types.CodedValue(XMLPROJECTION = "ELEMENT");

/// Time the author created the document
Property CreationTime As %String(MAXLEN = "");

/// Optional list of the main clinical acts
Property EventCodeList As list Of HS.IHE.XDSb.Types.CodedValue(XMLPROJECTION = "ELEMENT");

/// Document format
Property FormatCode As HS.IHE.XDSb.Types.CodedValue;

/// Hash key of the document, computed by the repository
Property Hash As %String(MAXLEN = "");

/// Type of organizational setting of the encounter during which the document act occurred
Property HealthcareFacilityTypeCode As HS.IHE.XDSb.Types.CodedValue;

/// The language of character data in the document
Property LanguageCode As %String(MAXLEN = "");

/// Who has legally authenticated the document (optional)
Property LegalAuthenticator As %String(MAXLEN = "");

/// MIME type
Property MimeType As %String(MAXLEN = "");

/// ObjectType
Property ObjectType As %String(VALUELIST = ",Stable,OnDemand", XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "Stable" ];

/// Patient ID
Property PatientId As %String(CONTENT = "ESCAPE", MAXLEN = "");

/// The clinical specialty where the act that resulted in the document was performed
Property PracticeSettingCode As HS.IHE.XDSb.Types.CodedValue;

/// Repository OID of where the document is stored
Property RepositoryUniqueId As %String(MAXLEN = "");

/// Start time, UTC, HL7v2 format
Property ServiceStartTime As %String(MAXLEN = "");

/// Stop time, UTC, HL7v2 format
Property ServiceStopTime As %String(MAXLEN = "");

/// Document size, computed by repository
Property Size As %Integer;

/// Patient MRN
Property SourcePatientId As %String(CONTENT = "ESCAPE", MAXLEN = "");

/// Patient demographics
Property SourcePatientInfo As list Of HS.IHE.XDSb.Types.SlotValue(XMLITEMNAME = "Value");

/// Document title
Property Title As %String(MAXLEN = "");

/// The precise kind of document
Property TypeCode As HS.IHE.XDSb.Types.CodedValue;

/// Document OID
Property UniqueId As %String(MAXLEN = "");

/// URI used for retrieval, computed by repository
Property URI As %String(MAXLEN = "");

/// Used to maintain the XOP href when imported
Property XOP As %String(MAXLEN = "");

Property DocumentSlots As list Of HS.IHE.XDSb.Types.Slot;

Property Version As %String;

Property Availability As %String(DISPLAYLIST = ",urn:ihe:iti:2010:DocumentAvailability:Offline,urn:ihe:iti:2010:DocumentAvailability:Online", VALUELIST = ",0,1", XMLLISTPARAMETER = "DISPLAYLIST");

}