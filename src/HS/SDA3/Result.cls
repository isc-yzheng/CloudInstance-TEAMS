/// A Result can be a property of a LabOrder, RadOrder, or OtherOrder.<br>
/// Results may be either text or atomic. Atomic results may have ResultItems.<br>
/// Text results may have ResultText, FileType, DocumentName, Stream,<br>
/// DocumentURL, and DocumentNumber. A LabOrder can contain either text or<br>
/// atomic results, but not both. A RadOrder or OtherOrder can contain only<br>
/// text results. In HL7ToSDA3, a result is determined to be atomic if<br>
/// ORC-29.1="LAB" and either (a) at least one OBX-2 value for the result<br>
/// is NOT "FT", "TX", or "ED", or (b) not all OBX segments are for the same<br>
/// item (i.e. they don't all have the same OBX-3 value).<br>
/// Otherwise, the result is text.<br><br>
/// If HS.Gateway.HL7.InboundProcess has the compatibility setting <br>
/// MultiLineOBXCompatibilityMode turned on, requirement (b) is dropped -<br>
/// results are parsed as text even if their OBX-3 values differ, as long as<br>
/// they all have an OBX-2 value of "FT", "TX", or "ED".
Class HS.SDA3.Result Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.ResultExtension;

Parameter CANOVERRIDEPROPLIST = "ResultItems";

/// Describes the type of result<br>
/// Can be either "IM" for "Image" (text result, containing ResultText and/or<br>
/// Stream) or "AT" for "Atomic" (atomic result, containing ResultItems)<br><br>
/// HL7ToSDA3:<br>
/// If an order in an ORU message is determined to contain atomic results<br>
/// (ORC-29.1="LAB" and either (a) not all OBX-2 values for this result are "FT",<br>
/// "TX", or "ED", or (b) not all OBX-3 values are the same), then ResultType<br>
/// will be parsed as "AT".<br>
/// If the setting MultiLineOBXCompatibilityMode is turned on in <br>
/// HS.Gateway.HL7.InboundProcess, requirement (b) is dropped - results are<br>
/// parsed as text even if their OBX-3 values differ, as long as they all have<br>
/// an OBX-2 value of "FT", "TX", or "ED".<br><br>
/// Streamlet cache:<br>
/// RadOrders and OtherOrders can only have text results, so in the<br>
/// OnBeforeMatch method of the streamlet class, if ResultType is not "IM", it<br>
/// is set to "IM". If it was not initially null, a warning will be logged in<br>
/// the Ensemble Event Log.<br>
/// LabOrders can have text results (ResultText or Stream) or atomic results<br>
/// (ResultItems), but not both. In the OnBeforeMatch method of the streamlet<br>
/// class, if the Result is found to contain both text and atomic results, then<br>
/// ResultType is used to determine which to discard and which to save. If<br>
/// ResultType is "IM", atomic results are discarded, and if ResultType is<br>
/// "AT", text results are discarded. In either case a warning is logged. If<br>
/// the Result has both text and atomic results but ResultType is not "IM" or<br>
/// "AT", then an error will be logged and the streamlet will not be processed.<br>
/// If the Result contains only atomic results, ResultType is set to "AT", and<br>
/// if it contains only text results, "IM". If the Result contains no actual<br>
/// results, ResultType is set to null. Note that it is possible for a Result<br>
/// to go from having text results to atomic or vice versa. In the<br>
/// OnUpdateSDAResult method of the streamlet class (which is invoked instead<br>
/// the standard, generated SDA update code for a Result), if the ResultType of<br>
/// the inbound Result is "IM" and the existing ResultType is "AT", a warning<br>
/// is logged and the existing ResultItems set to null before proceeding with<br>
/// the update. If the inbound ResultType is "AT" and the existing is "IM", a<br>
/// warning is logged and the ResultText, FileType, DocumentName, Stream,<br>
/// DocumentURL, and DocumentNumber are all set to null before proceeding with<br>
/// the update.<br><br>
/// Viewer cache:<br>
/// For LabOrders only, if FillerId is null and Result.ResultType = "AT", then<br>
/// FillerId will be defaulted to PlacerId.<br><br>
/// HL7:  ORC-29 : OrderType<br>
/// HL7:  OBX-2 : ValueType<br>
/// VIEWERLIB: Not stored
Property ResultType As %String;

/// A list of the lab result's items, used for atomic results<br><br>
/// HL7ToSDA3:<br>
/// If an order in an ORU message is determined to contain atomic results<br>
/// (ORC-29.1="LAB" and either (a) not all OBX-2 values for this result are "FT",<br>
/// "TX", or "ED", or (b) not all OBX-3 values are the same), the OBXs will be<br>
/// parsed to LabResultItems in ResultItems, and the NTEs among them parsed as<br>
/// LabResultItem Comments. See HS.SDA3.LabResultItem for more info.<br><br>
/// Streamlet cache:<br>
/// A Result belonging to a LabOrder may have ResultItems or ResultText/Stream,<br>
/// but not both. In the OnBeforeMatch method of the streamlet class, if the<br>
/// Result has ResultItems and ResultText/Stream, then if ResultType="AT",<br>
/// ResultText and Stream will be set to null and a warning logged. Else if<br>
/// ResultType="IM", ResultItems will be set to null and a warning logged. Else<br>
/// (ResultType is null or not recognized) an error will be logged and the<br>
/// Order will not be processed. RadOrders and OtherOrders may not have<br>
/// ResultItems. In the OnBeforeMatch method of the streamlet class, if a<br>
/// RadOrder or OtherOrder Result has ResultItems, ResultItems will be set to<br>
/// null and a warning logged. For LabOrders, rather than the standard logic to<br>
/// update SDA lists, special logic exists to update ResultItems. See<br>
/// HS.SDA3.LabResultItem for more info.<br><br>
/// HL7:  OBX,NTE<br>
/// VIEWERLIB: see HS.SDA3.LabResultItem
Property ResultItems As list Of HS.SDA3.LabResultItem;

/// Care provider who verified the Result<br><br>
/// Viewer cache:<br>
/// VerifiedBy is stored in the VISTSPathologistIDDR property for atomic<br>
/// results and in the TRCTCPDR property for text results.<br><br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.EPVisitTestSet(VISTSPathologistIDDR)<br>
/// VIEWERLIB: User.HS.OETextResult(TRCTCPDR)
Property VerifiedBy As HS.SDA3.CodeTableDetail.CareProvider;

/// Time of result<br><br>
/// Streamlet cache:<br>
/// For LabOrder, RadOrder, and OtherOrder, in the OnBeforeMatch method of the<br>
/// streamlet class, Result.EnteredOn and Result.AuthorizationTime default to<br>
/// Result.ResultTime. In the OnValidate method, if the Order FromTime is null,<br>
/// it is defaulted to the Order EnteredOn. If the Order has a Result and<br>
/// FromTime is still null, it is defaulted to Result.ResultTime. If the Order<br>
/// has a Result and FromTime is still null, then an error will be logged and<br>
/// the Order will not be saved.<br><br>
/// Viewer cache:<br>
/// The EPVisitTestSet properties are set for atomic results only, and the<br>
/// OETextResult properties are set for text results only. Note that while<br>
/// OEORIHL7ResultTime and TRTimeUpdated are %Time values stored in $H format,<br>
/// VISTSDateOfAuthorisation is a %Float value containing the time as a number<br>
/// of minutes since midnight.<br><br>
/// HL7:  OBR-22.1 : ResultsRptStatusChngDateTime.Time<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIHL7ResultDate) + User.HS.OEOrdItem(OEORIHL7ResultTime)<br>
/// VIEWERLIB: lab.HS.EPVisitTestSet(VISTSDateOfAuthorisation) + lab.HS.EPVisitTestSet(VISTSDateOfAuthorisation)<br>
/// VIEWERLIB: User.HS.OETextResult(TRDateUpdated) + User.HS.OETextResult(TRTimeUpdated)<br>
Property ResultTime As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// For LabOrders, in the OnBeforeMatch method of the Streamlet class,<br>
/// ResultStatus is ALPHAUP collated, then possibly mapped: FIN->F, COR->K,<br>
/// C->K, ENT->R, [other]->unchanged. For RadOrders and OtherOrders, in the<br>
/// OnBeforeMatch method of the Streamlet class, ResultStatus is also ALPHAUP<br>
/// collated and possibly mapped, though the mappings are slightly different:<br>
/// FIN->F, COR->C, ENT->R, [other]->unchanged. Then, for LabOrders, RadOrders,<br>
/// and OtherOrders, ResultStatus is validated against the list of codes for<br>
/// the Trak "ResultType" Standard Type: I, R, F, C, K, V, O, S, A, P, or X. If<br>
/// ResultStatus is not one of these values or null, it is set to null and a<br>
/// warning logged. In the OnValidate method of the Streamlet classes for<br>
/// LabOrder, RadOrder, and OtherOrder, if the Order has a Result, but<br>
/// ResultStatus is null, it is defaulted to "R" for "Entered". Then, if the<br>
/// Result has ResultItems, and ResultStatus is "F" for "Final", and the<br>
/// TestItemStatus of any LabResultItem in ResultItems is "K" for "Corrected",<br>
/// ResultStatus will be set to "K" for "Corrected".<br><br>
/// Viewer cache:<br>
/// The VISTSStatusResult property is set for atomic results only, and is<br>
/// simply set to the SDA ResultStatus value. TRResStatDR is set for text<br>
/// results only and contains a reference to the User.HS.OECResultStatus with<br>
/// RESSTCode=[ResultStatus]. Note that unlike other code tables in the Viewer<br>
/// Cache, OECResultStatus is not populated dynamically as codes are processed.<br>
/// OECResultStatus is only populated by the SITE- or<br>
/// HS-Default-ResultStatus.txt file at the time the Access Gateway is reset.<br>
/// See the HS documentation for more info on working with SITE-Default files.<br>
/// TRExternalResultStatus is also set for text results only and is derived<br>
/// from the ResultStatus value.  It is set to "A" if ResultStatus is "F", "K"<br>
/// if ResultStatus is "C", and "E" otherwise. OEORIResultFlag is set for both<br>
/// text and atomic results, though with slightly different logic. For text<br>
/// results, OEORIResultFlag is set to "C" if ResultStatus is "C", and "A"<br>
/// otherwise. For atomic results, OEORIResultFlag is set to "C" if<br>
/// ResultStatus is "K", and "A" otherwise.<br><br>
/// HL7:  OBR-25 : ResultStatus<br>
/// VIEWERLIB: lab.HS.EPVisitTestSet(VISTSStatusResult)<br>
/// VIEWERLIB: User.HS.OETextResult(TRResStatDR)<br>
/// VIEWERLIB: User.HS.OETextResult(TRExternalResultStatus)<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIResultFlag)
Property ResultStatus As %String;

/// The actual text of the result<br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// ResultText is used for text results only.<br><br>
/// HL7ToSDA3:<br>
/// If the Result is determined to be text, then any NTE segments immediately<br>
/// following the OBR and before the first OBX will be parsed to the Order<br>
/// Comments. Then, if subfield 2 of the first OBX (Value Type) is not "ED"<br>
/// (for "Encapsulated Data") and subfield 5.1 does not start with "{\rtf",<br>
/// then each OBX and NTE, starting from the first OBX, will be parsed to<br>
/// ResultText. OBX-5 and NTE-3 are repeating fields, and each instance is<br>
/// parsed as one line in the ResultText. ResultText will be HL7-unescaped<br>
/// according to the annotation on HS.Gateway.HL7.HL7ToSDA3:unescape.<br><br>
/// Streamlet cache:<br>
/// If a stored text result of a LabOrder is updated to have atomic results (by<br>
/// changing ResultType from "IM" to "AT"), a warning will be logged and<br>
/// ResultText (among other properties) set to null.<br><br>
/// HL7:  OBX-5 : ObservationValue<br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: User.HS.OETextResult(ChildOETextResultSection)->User.HS.OETextResultSection(SECText)
Property ResultText As %String(MAXLEN = "");

/// The type of data e.g PDF, DOC, RTF, TXT<br>
/// FileType is used for text results only.<br><br>
/// HL7ToSDA3:<br>
/// If the result is text, then if field 2 of the first OBX (Value Type) is<br>
/// "ED" for "Encapsulated Data", then FileType will be parsed from field 5.3<br>
/// of that OBX. Else if field 5.1 of that OBX starts with "{\rtf", FileType<br>
/// will be set to "RTF". Else FileType is not set in the SDA.<br><br>
/// Streamlet cache:<br>
/// For LabOrders, RadOrders, and OtherOrders, in the OnValidate method of the<br>
/// Streamlet classes, if the Order has a text result, and DocumentName and<br>
/// DocumentURL are null, and the Result has a Stream of Size > 0, then<br>
/// DocumentName will be defaulted to FileType.<br>
/// If a stored text result of a LabOrder is updated to have atomic results (by<br>
/// changing ResultType from "IM" to "AT"), a warning will be logged and<br>
/// FileType (among other properties) set to null.<br><br>
/// Viewer cache:<br>
/// If the Result has a Stream of Size > 0, Stream will be stored in a<br>
/// websys.Document[xxx], where [xxx] is determined by finding the entry in<br>
/// websys.Document:ClassNames corresponding to the entry in<br>
/// websys.Document:ValidTypes that matches FileType. For example, if<br>
/// FileType="PDF", Stream will be stored in a websys.DocumentPDF. If<br>
/// FileType="HTML", Stream will be stored in a websys.DocumentOTHER. If no<br>
/// entry in ValidTypes matches FileType, Stream will be stored in a<br>
/// websys.DocumentOTHER. FileType itself is stored as the docType of a<br>
/// websys.Document.<br><br>
/// HL7:  OBX-5.3 : ObservationValue.DataSubtype<br>
/// VIEWERLIB: websys.Document(docType)<br>
Property FileType As %String;

/// The name of the document<br>
/// DocumentName is used for text results only.<br>
/// The MAXLEN comes from the Trak property (TRDocumentName).<br><br>
/// Streamlet cache:<br>
/// For LabOrders, RadOrders, and OtherOrders, in the OnValidate method of the<br>
/// Streamlet classes, if the Order has a text result and DocumentName is null,<br>
/// it will be defaulted to DocumentURL. If still null and the Result has a<br>
/// Stream of Size > 0, DocumentName will be defaulted to FileType.<br>
/// If a stored text result of a LabOrder is updated to have atomic results (by<br>
/// changing ResultType from "IM" to "AT"), a warning will be logged and<br>
/// DocumentName (among other properties) set to null.<br><br>
/// Viewer cache:<br>
/// If the Result has a GUID that is not expired (GUIDExpDate in the future),<br>
/// then TRDocumentName will be set to "View Image". Else TRDocumentName will<br>
/// be set to the Result DocumentName. Note that TRDocumentName is used as the<br>
/// text of the link to the document in the Clinical Viewer.<br><br>
/// VIEWERLIB: User.HS.OETextResult(TRDocumentName)
Property DocumentName As %String(MAXLEN = 220);

/// An alternative to ResultText, this property may contain the result as a<br>
/// stream of either plaintext or binary data (e.g. DOC, PDF, JPG), with the<br>
/// type of data given by FileType. Stream is used for text results only,<br>
/// never atomic.<br><br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// Note that because of the type of this property (%GlobalBinaryStream),<br>
/// character data written to it must be single-width, ie, no double-wide<br>
/// Unicode characters. On export, the content will be Base64 encoded, and on<br>
/// import, Base64 decoded.<br><br>
/// HL7ToSDA3:<br>
/// If the result is determined to be text, then if field 2 of the first OBX<br>
/// (Value Type) is "ED" for "Encapsulated Data", or if field 5.1 of that OBX<br>
/// starts with "{\rtf", then the result will be parsed to Stream. Starting<br>
/// with the first OBX following the OBR, each OBX-5 and NTE-3 value will be<br>
/// parsed to Stream. OBX-5 and NTE-3 are repeating fields, and each instance<br>
/// of both will be parsed as its own line in Stream. For each OBX, if field 2<br>
/// is "ED", the value will be parsed from field 5.5, else the value will be<br>
/// parsed from field 5 in its entirety. Note that the maximum amount of data<br>
/// that can parsed this way is about 3.6 million characters. If the result is<br>
/// longer than this, it will be truncated. If no OBX-2 value in the result is<br>
/// "ED", then entire body of parsed text will be HL7-unescaped according to<br>
/// the annotation on HS.Gateway.HL7.HL7ToSDA3:unescape. If field 5.4 of the<br>
/// first OBX is not "BASE64" (case-insensitive), then the parsed text will be<br>
/// base-64 encoded before being inserted into the SDA.<br><br>
/// Streamlet cache:<br>
/// If a stored text result of a LabOrder is updated to have atomic results (by<br>
/// changing ResultType from "IM" to "AT"), a warning will be logged and<br>
/// Stream (among other properties) set to null.<br><br>
/// Viewer cache:<br>
/// OETextResult references a websys.Document, which references a<br>
/// websys.Document[xxx] (where [xxx] is derived from FileType, see the<br>
/// annotation on that property), which is where Stream is actually stored in<br>
/// the Viewer Cache. Note that the websys.Document does not contain an actual<br>
/// reference to the Document[xxx], but rather stores its ID in the DataId<br>
/// property.<br>
/// If the value of the Configuration Registry key<br>
/// "\Viewer\SDA3ResultStreamEncoded" is "1", then the content of Stream will<br>
/// be converted from UTF-8 output format (ie, $ZCVT(,"I","UTF8")) before being<br>
/// inserted into the Viewer Cache. This is useful in cases where the original<br>
/// document data contained double-wide Unicode characters that had to be<br>
/// converted to UTF-8 output format before being written to the stream, since<br>
/// it cannot contain double-wide characters.<br><br>
/// HL7:  OBX-5 : ObservationValue<br>
/// HL7:  NTE-3 : Comments<br>
/// VIEWERLIB: User.HS.OETextResult(TRDocumentDR)->websys.Document<br>
/// VIEWERLIB: websys.Document[xxx](docData)
Property Stream As %GlobalBinaryStream [ Transient ];

/// The full URL where the document can be accessed<br>
/// DocumentURL is used for text results only.<br><br>
/// Streamlet cache:<br>
/// For LabOrders, RadOrders, and OtherOrders, in the OnValidate method of the<br>
/// Streamlet class, if the Order has a text result and DocumentName is null,<br>
/// it will be defaulted to DocumentURL.<br>
/// If a stored text result of a LabOrder is updated to have atomic results (by<br>
/// changing ResultType from "IM" to "AT"), a warning will be logged and<br>
/// DocumentURL (among other properties) set to null.<br><br>
/// Viewer cache:<br>
/// If the Result has a GUID that is not expired (GUIDExpDate in the future),<br>
/// then TRDocumentURL will be set based on the GUID and whichever third-party<br>
/// image viewing service HealthShare is integrated with. Else TRDocumentURL<br>
/// will be set to the Result DocumentURL.  In the Clinical Viewer, a link to<br>
/// TRDocumentURL will appear with the Result.<br><br>
/// VIEWERLIB: User.HS.OETextResult(TRDocumentURL)<br>
Property DocumentURL As %String(MAXLEN = 32000);

/// Used as an external reference ID<br>
/// DocumentNumber is used for text results only.<br><br>
/// Streamlet cache:<br>
/// If a stored text result of a LabOrder is updated to have atomic results (by<br>
/// changing ResultType from "IM" to "AT"), a warning will be logged and<br>
/// DocumentNumber (among other properties) set to null.<br><br>
/// VIEWERLIB: User.HS.OETextResult(TRDocumentExtId)<br>
Property DocumentNumber As %String(MAXLEN = 220);

/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// HL7ToSDA3:<br>
/// For atomic results, Comments is parsed from the NTE segments following the<br>
/// OBR but before the first OBX. For text results, Result Comments cannot be<br>
/// parsed from HL7. (NTEs in the same place in a text result are parsed as<br>
/// Comments on the Order.)<br><br>
/// Viewer cache:<br>
/// OEORITestSetComments is set for both text and atomic results.<br>
/// TRTestSetComments is set for text results only.<br><br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORITestSetComments)<br>
/// VIEWERLIB: User.HS.OETextResult(TRTestSetComments)
Property Comments As %String(MAXLEN = "");

/// Time the result was authenticated/verified<br>
/// AuthorizationTime is meant to be used for text results only.<br><br>
/// HL7ToSDA3:<br>
/// OBR-22 is parsed to AuthorizationTime for text results only.<br><br>
/// Viewer cache:<br>
/// The OETextResult properties are set for text results only.<br><br>
/// HL7:  OBR-22.1 : ResultsRptStatusChngDateTime.Time<br>
/// VIEWERLIB: User.HS.OETextResult(TRDateVerified) + User.HS.OETextResult(TRTimeVerified)
Property AuthorizationTime As HS.SDA3.TimeStamp;

/// PerformedAt / ProducersID<br>
/// This can be used to specify the external organization that actually did the<br>
/// test.<br><br>
/// HL7ToSDA3:<br>
/// PerformedAt is only set at the result level for text results. For atomic<br>
/// results, it is set at the item level. For text results, it is parsed from<br>
/// the fields of the first OBX segment.<br>
/// If subfield 1 or 10 of OBX-23 is not null, Code, Description, and<br>
/// SDACodingStandard will be parsed from OBX-23. Else if subfield 1 or 2 of<br>
/// OBX-15 is not null, Code, Description, and SDACodingStandard will be parsed<br>
/// from OBX-15.<br><br>
/// Viewer cache:<br>
/// TRPerformedAtDR is set for text results only.<br><br>
/// HL7:  OBX-15 : ProducersReference<br>
/// HL7:  OBX-23 : PerformingOrganizationName<br>
/// HL7:  OBX-24 : PerformingOrganizationAddress<br>
/// HL7:  OBX-25 : PerformingOrganizationMedicalDirector<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.OETextResult(TRPerformedAtDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// If being parsed from OBX-23, subfield 10 will be used if not null, else<br>
/// subfield 3 will be used.<br>
/// HL7:  OBX-23.10 : PerformingOrganizationName.OrganizationIdentifier<br>
/// HL7:  OBX-23.3 : PerformingOrganizationName.IDNumber<br>
/// HL7:  OBX-15.1 : ProducersReference.Identifier<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCode)<br>
/// .Description<br>
/// HL7:  OBX-23.10 : PerformingOrganizationName.OrganizationName<br>
/// HL7:  OBX-15.2 : ProducersReference.Text<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-23.6 : PerformingOrganizationName.AssigningAuthority<br>
/// HL7:  OBX-15.3 : ProducersReference.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br><br>
/// .Address<br>
/// HL7ToSDA3:<br>
/// Address will only be parsed from OBX-24 is subfield 1 or 5 is not null. For<br>
/// the City, State, Zip, Country, and County properties, the HL7 field will be<br>
/// parsed to the Code. HL7ToSDA3 does not set the Description.<br>
/// HL7:  OBX-24 : PerformingOrganizationAddress<br>
/// .Address.Street<br>
/// HL7ToSDA3:<br>
/// If OBX-24.2 is not null, Street will be parsed as "[.1]; [.2]". Otherwise<br>
/// Street will simply be parsed from OBX-24.1.<br>
/// HL7:  OBX-24.1 : PerformingOrganizationAddress.Street<br>
/// HL7:  OBX-24.2 : PerformingOrganizationAddress.OtherDesignation<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPAddress)<br>
/// .Address.City<br>
/// HL7:  OBX-24.3 : PerformingOrganizationAddress.City<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCity)<br>
/// .Address.State<br>
/// HL7:  OBX-24.4 : PerformingOrganizationAddress.StateorProvince<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPProvinceDR)<br>
/// .Address.Zip<br>
/// HL7:  OBX-24.5 : PerformingOrganizationAddress.ZiporPostalCode<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPZipDR)<br>
/// .Address.Country<br>
/// HL7:  OBX-24.6 : PerformingOrganizationAddress.Country<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCountryDR)<br>
/// .Address.County<br>
/// HL7:  OBX-24.9 : PerformingOrganizationAddress.CountyParishCode<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCountyParishDR)<br><br>
/// .MedicalDirector<br>
/// HL7ToSDA3:<br>
/// MedicalDirector will only be parsed from OBX-25 if subfield 1, 2, or 9 is<br>
/// not null.<br>
/// HL7:  OBX-25 : PerformingOrganizationMedicalDirector<br>
/// VIEWERLIB: Not stored<br>
/// .MedicalDirector.Code<br>
/// HL7:  OBX-25.1 : IDNumber<br>
/// .MedicalDirector.Description<br>
/// HL7ToSDA3:<br>
/// The family and given names are concatenated together as "[Family], [Given]"<br>
/// to make the Description.<br>
/// HL7:  OBX-25.2 : FamilyName<br>
/// HL7:  OBX-25.3 : GivenName<br>
/// .MedicalDirector.SDACodingStandard<br>
/// HL7:  OBX-25.9 : AssigningAuthority<br>
/// .MedicalDirector.Name.FamilyName<br>
/// HL7:  OBX-25.2 : FamilyName<br>
/// .MedicalDirector.Name.GivenName<br>
/// HL7:  OBX-25.3 : GivenName<br>
/// .MedicalDirector.Name.MiddleName<br>
/// HL7:  OBX-25.4 : SecondandFurtherGivenNamesorInitialsThereof<br>
/// .MedicalDirector.Name.NamePrefix<br>
/// HL7:  OBX-25.6 : Prefix<br>
/// .MedicalDirector.Name.NameSuffix<br>
/// HL7:  OBX-25.5 : Suffix<br>
/// .MedicalDirector.Name.ProfessionalSuffix<br>
/// HL7:  OBX-25.21 : ProfessionalSuffix
Property PerformedAt As HS.SDA3.CodeTableDetail.Organization;

/// HL7ToSDA3:<br>
/// For text results, if any instance of any OBX-8 value (OBX-8 is a repeating<br>
/// field) is "A" for "Abnormal", ResultInterpretation will be set to "A".<br>
/// HL7ToSDA3 does not set the ResultInterpretation at the result level for<br>
/// atomic results.<br><br>
/// Streamlet cache:<br>
/// For RadOrders, OtherOrders, and LabOrders with text results, in the<br>
/// OnBeforeMatch method of the Streamlet classes, if ResultInterpretation is<br>
/// not null, "A", or two double quotes (the delete instruction), it is set to<br>
/// null and a warning logged. For LabOrders with atomic results, in the<br>
/// OnBeforeMatch method of the Streamlet class, if ResultInterpretation is not<br>
/// null, it is set to null. In the OnValidate method, if a LabResultItem has<br>
/// an abnormal ResultInterpretation (H, HH, L, LL, A, or AA) or if it has no<br>
/// ResultInterpretation but ResultValue is numeric, the normalized<br>
/// ResultNormalRange is one of the numeric forms (see the annotation on<br>
/// HS.SDA3.LabResultItem:ResultNormalRange), and ResultValue is outside of<br>
/// ResultNormalRange, then this ResultInterpretation will be set to "A".<br><br>
/// Viewer cache:<br>
/// For both text and atomic results, if ResultInterpretation="A",<br>
/// OEORIAbnormal will be set to "Y". Else, OEORIAbnormal will be set to null.<br><br>
/// HL7:  OBX-8 : AbnormalFlags<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIAbnormal)
Property ResultInterpretation As %String;

/// If HealthShare is integrated with a third-party image viewing service (such<br>
/// as eHealth Technologies), and that service has an image for this Result,<br>
/// then this GUID identifies that image. GUID is meant to come from the image<br>
/// viewing service, not the data provider that submitted the Result. Therefore<br>
/// GUID should not be included in an inbound SDA. See the HS Documentation for<br>
/// more info on how HealthShare can be integrated with an image viewing<br>
/// service.<br><br>
/// Streamlet cache:<br>
/// The way GUID gets set in the Streamlet Cache will depend on which image<br>
/// viewing service HealthShare is integrated with. See the HS Documentation<br>
/// for more info.<br><br>
/// Viewer cache:<br>
/// If GUID is not null and the current date/time is not after GUIDExpDate,<br>
/// then a link to the image will appear with the Result in the Clinical<br>
/// Viewer.<br><br>
/// VIEWERLIB: Not stored
Property GUID As %String;

/// If HealthShare is integrated with a third-party image viewing service (such<br>
/// as eHealth Technologies), and that service has an image for this Result,<br>
/// then this is the date and time that the received GUID for the image<br>
/// expires. Like GUID, GUIDExpDate is meant to come from the image viewing<br>
/// service, not the data provider that submitted the Result. Therefore<br>
/// GUIDExpDate should not be included in an inbound SDA. See the HS<br>
/// Documentation for more info on how HealthShare can be integrated with an<br>
/// image viewing service.<br><br>
/// Streamlet cache:<br>
/// The way GUIDExpDate gets set in the Streamlet Cache will depend on which<br>
/// image viewing service HealthShare is integrated with. See the HS<br>
/// Documentation for more info.<br><br>
/// Viewer cache:<br>
/// If GUID is not null and the current date/time is not after GUIDExpDate,<br>
/// then a link to the image will appear with the Result in the Clinical<br>
/// Viewer.<br><br>
/// VIEWERLIB: Not stored
Property GUIDExpDate As HS.SDA3.TimeStamp;

/// Viewer cache:<br>
/// The properties of OETextResult are set for text results only.<br><br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIResultUpdateUserDR)<br>
/// VIEWERLIB: User.HS.OETextResult(TRUserVerified)<br>
/// VIEWERLIB: User.HS.OETextResult(TRUserCreated)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// Viewer cache:<br>
/// TRLastUpdateHospitalDR is set for text results only.<br><br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIResultUpdateHospitalDR)<br>
/// VIEWERLIB: User.HS.OETextResult(TRLastUpdateHospitalDR)<br>
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Viewer cache:<br>
/// The properties of OETextResult are set for text results only.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIResultUpdateDate) + User.HS.OEOrdItem(OEORIResultUpdateTime)<br>
/// VIEWERLIB: User.HS.OETextResult(TRDateCreated) + User.HS.OETextResult(TRTimeCreated)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// For LabOrders, RadOrders, and OtherOrders, in the OnBeforeMatch method of<br>
/// the Streamlet classes, if the Order FillerId is null, it is defaulted to<br>
/// the Result ExternalId. FillerId undergoes other processing as well. See the<br>
/// annotation on HS.SDA3.AbstractOrder:FillerId for more info.<br><br>
/// VIEWERLIB: Not stored
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>ResultType</Value>
</Value>
<Value name="14">
<Value>ResultItems</Value>
</Value>
<Value name="15">
<Value>VerifiedBy</Value>
</Value>
<Value name="16">
<Value>ResultTime</Value>
</Value>
<Value name="17">
<Value>ResultStatus</Value>
</Value>
<Value name="18">
<Value>ResultText</Value>
</Value>
<Value name="19">
<Value>FileType</Value>
</Value>
<Value name="20">
<Value>DocumentName</Value>
</Value>
<Value name="21">
<Value>DocumentURL</Value>
</Value>
<Value name="22">
<Value>DocumentNumber</Value>
</Value>
<Value name="23">
<Value>Comments</Value>
</Value>
<Value name="24">
<Value>AuthorizationTime</Value>
</Value>
<Value name="25">
<Value>PerformedAt</Value>
</Value>
<Value name="26">
<Value>ResultInterpretation</Value>
</Value>
<Value name="27">
<Value>GUID</Value>
</Value>
<Value name="28">
<Value>GUIDExpDate</Value>
</Value>
<Value name="29">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
