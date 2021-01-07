/// LabResultItems are stored in the ResultItems property of an HS.SDA3.Result<br>
/// containing atomic (as opposed to text) results (ResultType="AT"). Of the<br>
/// three Order types that can have Results, only LabOrder can have atomic<br>
/// results. RadOrder and OtherOrder can only have text results.<br>
/// LabResultItems are parsed from HL7 by the HL7 Inbound Process operation of<br>
/// the Edge production. Parsing is affected by the following settings:<br>
/// - KeepDuplicateOBXIdentifiers<br>
/// - ObservationCompatibilityMode (referred to here as Compatibility Mode<br>
/// on or off).<br>
/// - ActionCode="R" in ORC-1 for atomic lab results only<br>
/// LabResultItems come in two flavors, regular and antibiotic sensitivity.<br>
/// Sensitivities are part of microbiolgy results and are always "against" a<br>
/// regular item (i.e. an organism identified in a culture). Structurally,<br>
/// sensitivities are the same as regular items, and there is no one field that<br>
/// distinguishes an item as a sensitivity (although if ResultInterpretation is<br>
/// "S", "R", "I", "MS", or "VS", then the item is probably intended to be a<br>
/// sensitivity). Rather it is the SubId, ResultInterpretation, and an item's<br>
/// location in ResultItems relative to other items that distinguishes it as a<br>
/// sensitivity. Basically, the logic to determine whether an item is a<br>
/// sensitivity is:<br>
/// -If ResultInterpretation is S, R, I, MS, or VS,<br>
/// -And SubId is not null and is the same as the last non-sensitivity item<br>
/// with a non-null SubId in the result,<br>
/// -Then the item is a sensitivity against the last non-sensitivity item with<br>
/// a non-null SubId,<br>
/// -Else it is a regular item.<br>
/// Consider this excerpt from an HL7 ORU message:<br>
/// <pre>
/// 	OBX|1|ST|AAO^ORGANISM|1|MODERATE GROWTH||||||F
/// 	OBX|2|ST|AAO^ORGANISM|2|STREP, BETA HEM GROUP A||||||F
/// 	OBX|3|ST|AAT^METHOD||KB||||||F
/// 	OBX|4|ST|AM^AMPICILLIN|2|SUSCEPTIBLE|||S|||F
/// 	OBX|5|ST|CLIN^CLINDAMYCIN|2|SUSCEPTIBLE|||S|||F
/// 	OBX|6|ST|E^ERYTHROMYCIN|2|RESISTANT|||R|||F
/// </pre>
/// The 2nd OBX is the organism identified in the culture, and the 4th, 5th,<br>
/// and 6th segments are the antibiotics tested against it.<br><br>
/// In the OnUpdateSDAResult method of the LabOrder Streamlet class (invoked to<br>
/// update a Result in place of the standard, generated code), for regular (not<br>
/// sensitivity) items, inbound and existing items are matched on SubId and<br>
/// TestItemCode.Code and .SDACodingStandard. If a match is found, UpdateSDA is<br>
/// called on the existing item with the inbound item as its argument.<br>
/// Otherwise the inbound item is inserted into ResultItems. Sensitivity items<br>
/// in an update are not matched, but rather processed in "snapshot" mode. If<br>
/// an update contains sensitivities with a given SubId, then all existing<br>
/// sensitivities with that SubId are deleted and the inbound sensitivities<br>
/// inserted into ResultItems after the corresponding "organism" item.<br><br>
/// In the Viewer Cache, regular test items are stored as<br>
/// lab.HS.EPVisitTestSetData, while sensitivities are stored as<br>
/// lab.HS.EPVisitTestSetDataAntibiotics that are linked to a regular item via<br>
/// the relationship between these two classes.<br><br>
/// Also note that the matching of LabTestItem CodeTableDetails in the SDA to<br>
/// CTTestCodes in the Viewer Cache can optionally use the ResultValueUnits<br>
/// of this class as a match property. See the ResultValueUnits property for<br>
/// more details.
Class HS.SDA3.LabResultItem Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.LabResultItemExtension;

/// Code for test item<br><br>
/// HL7ToSDA3:<br>
/// The logic to parse TestItemCode is:<br>
/// -SDACodingStandard is always parsed from OBX-3.3 and CodeSystemVersionId<br>
/// from OBX-3.7.<br>
/// -If OBX-2="NM", parse Code from OBX-3.1, Description from OBX-3.2, and set<br>
/// IsNumeric to "true".<br>
/// -Else if OBX-2="CE" and OBX-8 is not "S", "R", "I", "MS", or "VS":<br>
/// --If KeepDuplicateOBXIdentifiers is true, or ORC-1="R", or the OBX-3.1 value<br>
/// is unique in this result, or if it has not yet appeared in this result<br>
/// with OBX-2="CE" or "ST", parse Code from OBX-3.1.<br>
/// --Else if OBX-4 is not null, parse fields 3.1 and 4 to Code as "[3.1][4]".<br>
/// --Else parse field 3.1 and the segment number to the Code as "[3.1][seg#]".<br>
/// --Parse Description from OBX-3.2.<br>
/// -Else if OBX-2="ST":<br>
/// --If KeepDuplicateOBXIdentifiers is true, or ORC-1="R", or the OBX-3.1 value<br>
/// is unique in this result, or if it has not yet appeared in this result<br>
/// with OBX-2="CE" or "ST", parse Code from OBX-3.1.<br>
/// --Else if OBX-4 is not null, parse fields 3.1 and 4 to Code as "[3.1][4]".<br>
/// --Else parse field 3.1 and the segment number to the Code as "[3.1][seg#]".<br>
/// --Parse Description from OBX-3.2.<br>
/// --Set IsNumeric to "true".<br>
/// -Else if fields 3.1 and .2 are the same as they were for the previous<br>
/// segment and Compatibility Mode is on, parse Code from OBX-3.1 as<br>
/// "[3.1] Notes" and Description from OBX-3.2 as "[3.2] Notes".<br>
/// -Else parse Code from OBX-3.1 and Description from OBX-3.2.<br>
/// -PriorCodes and OriginalText will only be parsed if the parsed Code was not<br>
/// changed from OBX-3.1 (by adding either the SubID, segment number, or<br>
/// "Notes"). Additionally, PriorCodes will only be parsed if OBX-3.4 or .5 is<br>
/// not null.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if a LabResultItem has<br>
/// no TestItemCode, it will be removed from ResultItems and a warning logged.<br>
/// Two LabResultItems in the same set of ResultItems with the same SubId and<br>
/// TestItemCode.Code and .SDACodingStandard are considered to be the same<br>
/// item. In the OnBeforeMatch method, if any duplicate LabResultItems are<br>
/// found, they are consolidated into a single LabResultItem by invoking the<br>
/// UpdateSDA method on the first LabResultItem with the second LabResultItem<br>
/// as its argument, then removing the second LabResultItem from ResultItems,<br>
/// and repeating as necessary. NOTE: This deduplication is skipped if ORC-1="R"<br>
/// In the OnUpdateSDAResult method, if a LabResultItem is determined not to<br>
/// be an antibiotic sensitivity, then it is compared to the existing<br>
/// LabResultItems on SubId and TestItemCode.Code and SDACodingStandard.<br>
/// If a match is found, the existing LabResultItem is updated by calling <br>
/// UpdateSDA on it with the inbound LabResultItem as its argument.<br><br>
/// Viewer cache:<br>
/// The Clinical Viewer does not support an atomic lab result containing two or<br>
/// more regular (not sensitivity) test items with the same code and different<br>
/// SubIds. (If the SubIds are the same, the test items are considered the same<br>
/// and will be consolidated.) If ResultItems contains data like this, a suffix<br>
/// of the form ":[#]" will be appended to the TestItemCode Code to make it<br>
/// unique within the Result. In this case, the Description is unchanged. If<br>
/// the LabResultItem is determined to be an antibiotic sensitivity, then this<br>
/// TestItemCode will be inserted into the Viewer Cache as a<br>
/// lab.HS.CTAntibiotics, referenced by a lab.HS.EPVisitTestSetDataAntibiotics<br>
/// that is related to the lab.HS.EPVisitTestSetData representing the organism<br>
/// identified. Otherwise, this TestItemCode will be stored as a CTTestCode<br>
/// referenced by EPVisitTestSetData. Note backslash ("\") is a reserved<br>
/// character for both of these tables (CTAntiobiotics and CTTestCode), so in<br>
/// the Viewer Cache only, backslashes in a TestItemCode Code or Description<br>
/// will be replaced with underscores ("_"). <br>
/// Also note that the matching of LabTestItem CodeTableDetails in the SDA to<br>
/// CTTestCodes in the Viewer Cache can optionally use the ResultValueUnits<br>
/// of this class as a match property. See the ResultValueUnits property for<br>
/// more details.<br><br>
/// HL7:  OBX-3 : ObservationIdentifier<br>
/// SDATableName=LabTestItem, ViewerClass=User.HS.CTTestCode<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDTestCodeDR)<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetDataAntibiotics(VISTAAntibioticDR)<br><br>
/// .Code<br>
/// HL7ToSDA3:<br>
/// Code is always parsed from OBX-3.1, but may be altered slightly from the<br>
/// original value depending on the message. See above.<br>
/// Viewer cache:<br>
/// As the Clinical Viewer does not support multiple instances of the same<br>
/// regular (not sensitivity) test item code with different SubIds in the same<br>
/// Result, Code may have a suffix of the form ":[#]" appended to it to make it<br>
/// unique within a the Result.<br>
/// Code will be stored in CTANTCode if this LabResultItem is determined to be<br>
/// an antibiotic sensitivity, and CTTestCode otherwise.<br>
/// HL7:  OBX-3.1 : ObservationIdentifier.Identifier<br>
/// VIEWERLIB:  User.HS.CTTestCode(CTTCCode)<br>
/// VIEWERLIB: lab.HS.CTAntibiotics(CTANTCode)<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// Description is always parsed from OBX-3.2, but may be altered slightly from<br>
/// the original value depending on the message. See above.<br>
/// HL7:  OBX-3.2 : ObservationIdentifier.Text<br>
/// VIEWERLIB: User.HS.CTTestCode(CTTCDesc)<br>
/// VIEWERLIB: lab.HS.CTAntibiotics(CTANTName)<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-3.3 : ObservationIdentifier.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .CodingSystemVersionId<br>
/// HL7:  OBX-3.7 : ObservationIdentifier.CodingSystemVersionID<br>
/// VIEWERLIB: Not stored<br>
/// .IsNumeric<br>
/// HL7ToSDA3:<br>
/// IsNumeric will be set to "true" in the SDA if OBX-2 is "NM" or "ST",<br>
/// otherwise it will not be set.<br>
/// Viewer cache:<br>
/// The CTTCShowInCummulative property and the ARCIMDisplayCumulative property of the ARCItmMast 
/// for the current order will always be set to "Y", regardless of IsNumeric.<br>
/// HL7:  OBX-2 : ValueType<br>
/// VIEWERLIB: Not stored<br>
Property TestItemCode As HS.SDA3.CodeTableDetail.LabTestItem;

/// Result's value<br><br>
/// HL7ToSDA3:<br>
/// The logic to parse ResultValue is:<br>
/// -If OBX-2 is "TX" or "FT":<br>
/// --Parse each instance of this OBX-5.1 (OBX-5 is repeating) to its own line<br>
/// in ResultValue, HL7-unescaped according to the annotation on<br>
/// HS.Gateway.HL7.HL7ToSDA3:unescape. If the next segment is an OBX with the<br>
/// same values for OBX-3.1 and .2, parse that OBX-5.1 to this ResultValue in<br>
/// the same way. Continue doing this until a non-OBX segment or an OBX with<br>
/// different values in fields 3.1 or 3.2 is encountered.<br>
/// -Else if Compatibility Mode is off and OBX-2="SN", parse ResultValue from<br>
/// OBX-5 as: "[5.1][5.2][5.3][5.4]". Ex: if OBX-5 = ">^5", then <br>
/// ResultValue = ">5"; if OBX-5="^1^-^10", then ResultValue="1-10".<br>
/// -Else if Compatibility Mode is off and OBX-2 is "CE", "CNE", or "CWE",<br>
/// parse OBX-5.2 to ResultValue.<br>
/// -Else if OBX-2="DT", parse the first non-null instance of OBX-5.1<br>
/// (converted from HL7 timestamp to XML timestamp format) to ResultValue.<br>
/// -Else parse the first non-null instance of OBX-5.1 (HL7-unescaped according<br>
/// to the annotation on HS.Gateway.HL7.HL7ToSDA3:unescape) to ResultValue.<br><br>
/// Viewer cache:<br>
/// The logic to insert ResultValue into the Viewer Cache is:<br>
/// -If the LabResultItem is an antibiotic sensitivity:<br>
/// --If the ResultValue consists of only punctuation and/or numbers, it is<br>
/// inserted into the VISTAResultMIC property of<br>
/// lab.HS.EPVisitTestSetDataAntibiotics.<br>
/// --Else ResultValue is not inserted into the Viewer Cache.<br>
/// -If the LabResultItem is not an antibiotic sensitivity, then the characters<br>
/// "^", "\", and "|" in the ResultValue are translated to $C(16), $C(17), and<br>
/// $C(18), respectively, before ResultValue is inserted into the VISTDTestData<br>
/// property of lab.HS.EPVisitTestSetData. (The reverse translation will be<br>
/// done when the data is displayed in the Clinical Viewer.)<br><br>
/// HL7:  OBX-5 : ObservationValue<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetDataAntibiotics(VISTAResultMIC)<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDTestData)
Property ResultValue As %String(MAXLEN = "");

/// An ID that ties together different parts of a result (e.g. multiple<br>
/// organisms in a culture battery, multiple diagnostic impressions of a chest<br>
/// x-ray, etc.)<br><br>
/// HL7ToSDA3:<br>
/// In some situations where an OBX-3.1 value appears more than once in a<br>
/// result, OBX-4 may get appended to it to make the TestItemCode Code unique<br>
/// within the Result. See TestItemCode for more info.<br>
/// If OBX-2="NM", OBX-4 is not null, and the following segment is an OBX that<br>
/// matches the current one on OBX-3.1 but not on OBX-4, then OBX-5.1 of the<br>
/// next segment will be parsed to the Comments of the current LabResultItem.<br>
/// See Comments for more info.<br><br>
/// Streamlet cache:<br>
/// Once saved to the Streamlet Cache, SubId cannot be deleted. In the<br>
/// OnBeforeMatch method of the LabOrder Streamlet class, if the SubId of an<br>
/// inbound LabResultItem is two double quotes (the delete instruction), it<br>
/// will be set to null and a warning logged. LabResultItems with the same<br>
/// SubId and TestItemCode.Code and .SDACodingStandard are considered to be the<br>
/// same item, so in the OnBeforeMatch method, any matching LabResultItems in<br>
/// the inbound ResultItems are condensed by calling UpdatedSDA on the first<br>
/// item with the second as its argument, removing the second from ResultItems,<br>
/// and repeating as necessary. Note that this excludes LabResultItems that are<br>
/// susceptibilities (ResultInterpretation= "S", "R", "I", "MS", "VS") and<br>
/// includes items with null SubIds.<br>
/// In the OnUpdateSDAResult method, if an inbound LabResultItem is determined<br>
/// not to be an antibiotic susceptibility, then it is compared to items in the<br>
/// existing Result on SubId and TestItemCode.Code and .SDACodingStandard. If a<br>
/// match is found, the existing item is updated by calling UpdateSDA on it with<br>
/// the inbound item as its argument. Otherwise the inbound item is inserted<br>
/// into the existing ResultItems.<br>
/// Sensitivities are processed in snapshot mode, so if an inbound<br>
/// LabResultItem is determined to be a sensitivity, then any existing<br>
/// sensitivities with the same SubId are deleted, and the inbound item is<br>
/// inserted into ResultItems after the organism item with the same SubId. This<br>
/// deletion only happens once per update though, so sensitivities just<br>
/// inserted will not be deleted.<br><br>
/// Viewer cache:<br>
/// A LabResultItem will be inserted into the Viewer Cache as a<br>
/// lab.HS.EPVisitTestSetDataAntibiotics if the ResultInterpretation is "S",<br>
/// "R", "I", "MS", or "VS", if SubId is not null, and if the last regular (not<br>
/// sensitivity) item processed had the same SubId. The<br>
/// EPVisitTestSetDataAntibiotics will be linked to the EPVisitTestSetData<br>
/// created by that item via the relationship between them.<br>
/// VISTDMachineDR is only set for regular (not sensitivity) items.<br><br>
/// HL7:  OBX-4 : SubId<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDMachineDR)
Property SubId As %String(MAXLEN = 30);

/// Units of result value<br><br>
/// Streamlet cache:<br>
/// ResultValueUnits is not stored for antibiotic sensitivities. In the<br>
/// OnUpdateSDAResult method of the LabOrder Streamlet class, if a<br>
/// LabResultItem is determined to be a sensitivity, ResultValueUnits will be<br>
/// set to null.<br><br>
/// Viewer cache:<br>
/// For a regular (not sensitivity) test item, a "^" in ResultValueUnits will<br>
/// be translated to $C(16) before being inserted into CTTCUnits. (The reverse<br>
/// translation will be done when the value is displayed in the Clinical<br>
/// Viewer.)<br>
/// Also, if ResultValueUnits contains any "\" characters, these will be<br>
/// translated to "_" before being stored in the Viewer Cache. This translation<br>
/// is done in the Viewer Cache only. The original SDA is not affected.<br>
/// When LabTestItem CodeTableDetails are compared to CTTestCodes in the Viewer<br>
/// Cache to determine if there is a match, ResultValueUnits can optionally be<br>
/// included in the matching. If the value of the Configuration Registry key<br>
/// "\Viewer\LabTestItem\MatchOnUnits" is 1, then ResultValueUnits is used as<br>
/// a match property. It must match the CTTCUnits value for the comparison to<br>
/// be considered a match. Because of this, the CT_TestCode table can contain<br>
/// multiple instances of the same Code (made unique by uniqueness suffixes) so<br>
/// long as they have different CTTCUnits values. If this key is not set or if<br>
/// the value is not 1, ResultValueUnits is not used as a match property.<br>
/// LabTestItems will be matched on Code and SDACodingStandard only. If a<br>
/// LabTestItem and a CTTestCode match but the units differ, CTTCUnits will be<br>
/// updated with the ResultValueUnits value.<br>
/// ResultValueUnits is not stored in the Viewer Cache for sensitivities.<br><br>
/// HL7:  OBX-6.1 : Units.Identifier<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDTestCodeDR)->User.HS.CTTestCode(CTTCUnits)
Property ResultValueUnits As %String(MAXLEN = 30);

/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the LabOrder Streamlet class, for regular<br>
/// (not sensitivity) test items, ResultNormalRange is normalized via a call to<br>
/// NormalizeRange. The logic is:<br>
/// -Strip out any control characters (via $ZSTRIP, mask code "C").<br>
/// -If the first non-whitespace character is "<" or ">", the value is<br>
/// unchanged.<br>
/// -Else determine the high and low values of the range:<br>
/// --If the first non-whitespace character is "-" and the value contains "/",<br>
/// the low value is everything before the "/" and the high value is everything<br>
/// after. (This assumes only one "/".)<br>
/// --Else if the first non-whitespace character is "-" and the value contains<br>
/// at least one more "-", the low value is everything before the second "-",<br>
/// and the high value is everything after.<br>
/// --Else the low value is everything before "-", and the high value<br>
/// everything after. If there is no "-", the entire value is treated as the<br>
/// low value.<br>
/// -Once the high and low values have been determined, then if stripping the<br>
/// leading and trailing whitespace ($ZSTRIP, mask code "W") would make them<br>
/// valid numbers (determined by $IsValidNum), then this is done.<br>
/// -If both the low and high values are not null, the value is returned as:<br>
/// "[lo]-[hi]".<br>
/// -If the low value is null and the high value is not:<br>
/// --If the high value is a valid number ($IsValidNum), the value returned is<br>
/// returned as "<[hi]", else the high value is returned.<br>
/// -If the high value is null and the low value is not:<br>
/// --If the low value is a valid number ($IsValidNum), the value returned is<br>
/// returned as ">[lo]", else the low value is returned.<br>
/// -Else a null string is returned.<br>
/// After normalization, ResultNormalRange should have the form "&lt;x", "<=x",<br>
/// ">x", ">=x", "-x-y", "x-y", or some non-numeric value. ResultNormalRange is<br>
/// not used to calculate ResultInterpretation for this LabResultItem, however<br>
/// it may be used to flag the containing Result as abnormal. In the OnValidate<br>
/// method of the LabOrder Streamlet class, if a LabResultItem has an abnormal<br>
/// ResultInterpretation (H, HH, L, LL, A, or AA) or if it has no<br>
/// ResultInterpretation but ResultValue is numeric, ResultNormalRange is one<br>
/// of the numeric forms, and ResultValue is outside of ResultNormalRange, then<br>
/// ResultInterpretation of the containing Result will be set to "A".<br>
/// ResultNormalRange is not stored for antibiotic sensitivities. In the<br>
/// OnUpdateSDAResult method , if a LabResultItem is determined to be a<br>
/// sensitivity, ResultNormalRange will be set to null.<br><br>
/// Viewer cache:<br>
/// ResultNormalRange is stored as separate high and low values in the Viewer<br>
/// Cache. The logic to parse them out of the ResultNormalRange (which should<br>
/// have been normalized) is:<br>
/// -If the first non-whitespace character is "<", the value is stored as the<br>
/// high value and the low value is null.<br>
/// -Else if the first non-whitespace character is ">", the value is stored as<br>
/// the low value and the high value is null.<br>
/// -Else if the first non-whitespace character is "-", everything before the<br>
/// second "-" is the low value and everything after is the high value. If<br>
/// there isn't another "-", the entire value is stored as the low value.<br>
/// -Else if the value contains at least one "-", everything before the first<br>
/// "-" is the low value, and everything after is the high value.<br>
/// -Else the value is stored as the low value.<br><br>
/// HL7:  OBX-7 : ReferencesRange<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDResultRefRangeLow) + lab.HS.EPVisitTestSetData(VISTDResultRefRangeHigh)
Property ResultNormalRange As %String(MAXLEN = 220);

/// HL7ToSDA3:<br>
/// Each non-null instance of OBX-8 (as it is repeating) will be parsed to<br>
/// ResultInterpretation, separated by a comma. The value parsed may affect the<br>
/// way OBX-3 is parsed to TestItemCode. See TestItemCode for more info.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the LabOrder Streamlet class, if<br>
/// ResultInterpretation is not N, H, HH, L, LL, A, AA, S, I, R, MS, VS, null,<br>
/// or two double quotes (the delete instruction), it will be set to null and a<br>
/// warning logged. Also in the OnBeforeMatch method, LabResultItems with the<br>
/// same SubId and TestItemCode.Code and .SDACodingStandard are consolidated as<br>
/// they are considered to be the same item, except for items with<br>
/// ResultInterpretation= S, R, I, MS, or VS, as this indicates an antibiotic<br>
/// sensitivity, and the same antibiotic may appear multiple times in a result<br>
/// if multiple organisms were detected.<br>
/// In the OnUpdateSDAResult method, ResultInterpretation is used to determine<br>
/// whether an item is a sensitivity. The full logic is:<br>
/// -If (ResultInterpretation is S, R, I, MS, or VS,),<br>
/// -and (SubId is not null),<br>
/// -and ((this SubId appears in the existing data) OR (this SubId is the same<br>
/// as for the last non-sensitivity item with a non-null SubId)),<br>
/// -then this LabResultItem is a sensitivity,<br>
/// -else is is a regular item.<br>
/// Sensitivies are processed differently from regular items in this method.<br>
/// See the annotations on each property for more info.<br>
/// In the OnValidate method, if a LabResultItem has an abnormal<br>
/// ResultInterpretation (H, HH, L, LL, A, or AA) or if it has no<br>
/// ResultInterpretation but ResultValue is numeric, ResultNormalRange is a<br>
/// numeric form, and ResultValue is outside of ResultNormalRange, then<br>
/// ResultInterpretation of the containing Result will be set to "A".<br><br>
/// Viewer cache:<br>
/// ResultInterpretation is used in the Viewer Cache to determine whether to<br>
/// insert a LabResultItem as a regular item (lab.HS.EPVisitTestSetData) or a<br>
/// sensitivitiy (lab.HS.EPVisitTestSetDataAntibiotics). The full logic is:<br>
/// -If ResultInterpretation is S, R, I, MS, or VS,<br>
/// -and SubId is not null,<br>
/// -and SubId matches the last regular test item inserted with a non-null<br>
/// SubId, but is not the item itself,<br>
/// -then insert the item as a sensitivity,<br>
/// -else insert it as a regular test item.<br>
/// If this item is inserted as a sensitivity, VISTAResultDR of the<br>
/// EPVisitTestSetDataAntibiotics will reference the lab.HS.CTSensitivity with<br>
/// CTSNCode=[ResultInterpretation]. Else ResultInterpretation will populate<br>
/// VISTDInstrumentFlags of EPVisitTestSetData.<br><br>
/// HL7:  OBX-8 : AbnormalFlags<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetDataAntibiotics(VISTAResultDR)->lab.HS.CTSensitivity(CTSNCode)<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDInstrumentFlags)
Property ResultInterpretation As %String(MAXLEN = 100);

/// Note that within HealthShare, the code for an item status of "Corrected" is<br>
/// "K", not "C".<br><br>
/// HL7ToSDA3:<br>
/// An OBX-11 value of "C" will be parsed to the SDA as "K". Any other value<br>
/// will be parsed as-is.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the LabOrder Streamlet class, a<br>
/// TestItemStatus of "C" will be mapped to "K". Any other value will be<br>
/// unchanged.<br>
/// In the OnUpdateSDAResult method, if a match is found between an existing<br>
/// LabResultItem and an inbound item (for regular items only, sensitivities<br>
/// are not matched), if the existing TestItemStatus is "F" or "K", then if the<br>
/// ResultValue or ResultNormalRange of the existing item is updated or deleted<br>
/// by the inbound item, then TestItemStatus will be set to "K", regardless of<br>
/// what was passed in. Otherwise, TestItemStatus will be updated normally.<br>
/// Note that a deletion will only cause the status to be set to "K" if the<br>
/// existing item has a non-null value to delete.<br>
/// TestItemStatus is not stored for antibiotic sensitivities. In the<br>
/// OnUpdateSDAResult method, if a LabResultItem is determined to be a<br>
/// sensitivity, TestItemStatus will be set to null.<br>
/// In the OnValidate method, if the TestItemStatus of any<br>
/// LabResultItem is "K" and the ResultStatus of the containing Result is "F",<br>
/// the ResultStatus will be changed to "K".<br><br>
/// Viewer cache:<br>
/// VISTDResultStatus is set for regular (not sensitivity) items. The value<br>
/// that will appear in the Clinical Viewer is the Description for the<br>
/// Trak "TestItemStatusHealthShare" Standard Type item with<br>
/// Internal Value = [TestItemStatus]. See the HS documentation for guidance on<br>
/// configuring Standard Types. For sensitivities, TestItemStatus is not<br>
/// inserted into the Viewer Cache.<br><br>
/// HL7:  OBX-11 : ObservationResultStatus<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDResultStatus)
Property TestItemStatus As %String(MAXLEN = 100);

/// HL7ToSDA3:<br>
/// Each instance of each NTE-3 following an OBX in an atomic result will be<br>
/// parsed as one line in Comments. It is also possible for subsequent OBXs to<br>
/// be parsed as Comments on the current one. If the current OBX-2 is "NM" and<br>
/// the current OBX-4 is not null, and if the next segment is an OBX that<br>
/// matches the current one on OBX-3.1 but not on OBX-4, then each instance of<br>
/// the next OBX-5.1 will be parsed as a line in Comments. Each line will be<br>
/// HL7-unescaped according to the annotation on<br>
/// HS.Gateway.HL7.HL7ToSDA3:unescape. Once every instance of OBX-5.1 has been<br>
/// parsed, then if the next segment is an OBX with the same OBX-3.1 and .2,<br>
/// then that OBX-5.1 will be parsed in the same way. This will continue until<br>
/// a non-OBX or an OBX that does not match on fields 3.1 and .2 is<br>
/// encountered. Then, if any NTEs are following the last OBX, the NTE-3 values<br>
/// will be parsed to Comments as well.<br><br>
/// Streamlet cache:<br>
/// Comments is not stored for antibiotic sensitivities. In the<br>
/// OnUpdateSDAResult method, if a LabResultItem is determined to be a<br>
/// sensitivity, Comments will be set to null.<br><br>
/// Viewer cache:<br>
/// For regular test items only (not sensitivities), the characters "^", "\",<br>
/// and "|" in Comments will be translated to $C(16), $C(17), and $C(18),<br>
/// respectively, before being saved to the Viewer Cache. (The reverse<br>
/// translation is done when Comments is output to the Clinical Viewer.)<br>
/// VISTDComments is set for regular test items only. Comments on sensitivites<br>
/// are not stored in the Viewer Cache.<br><br>
/// HL7:  NTE-3 : Comments<br>
/// HL7:  OBX-5.1 : ObservationValue<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDComments)
Property Comments As %String(MAXLEN = "");

/// Streamlet cache:<br>
/// ReferenceComment is not stored for antibiotic sensitivities. In the<br>
/// OnUpdateSDAResult method, if a LabResultItem is determined to be a<br>
/// sensitivity, ReferenceComment will be set to null.<br><br>
/// Viewer cache:<br>
/// VISTDHL7ReferenceComment is set for regular test items only, not<br>
/// sensitivities.<br><br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDHL7ReferenceComment)<br>
Property ReferenceComment As %String(MAXLEN = 1000);

/// PerformedAt / ProducersID<br>
/// This can be used to specify the external organization that actually did the<br>
/// test.<br><br>
/// HL7ToSDA3:<br>
/// If subfield 1 or 10 of OBX-23 is not null, Code, Description, and<br>
/// SDACodingStandard will be parsed from OBX-23. Else if subfield 1 or 2 of<br>
/// OBX-15 is not null, Code, Description, and SDACodingStandard will be parsed<br>
/// from OBX-15.<br><br>
/// Streamlet cache:<br>
/// PerformedAt is not stored for antibiotic sensitivities. In the<br>
/// OnUpdateSDAResult method, if a LabResultItem is determined to be a<br>
/// sensitivity, PerformedAt will be set to null.<br><br>
/// Viewer cache:<br>
/// VISTDPerformedAtDR is set for regular test items only, not sensitivities.<br><br>
/// HL7:  OBX-15 : ProducersReference<br>
/// HL7:  OBX-23 : PerformingOrganizationName<br>
/// HL7:  OBX-24 : PerformingOrganizationAddress<br>
/// HL7:  OBX-25 : PerformingOrganizationMedicalDirector<br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDPerformedAtDR)<br><br>
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
/// OBX-17 is a repeating field. Each non-null instance will be parsed as one<br>
/// ObservationMethod in this list.<br><br>
/// HL7:  OBX-17 : ObservationMethod<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBX-17.1 : ObservationMethod.Identifier<br>
/// .Description<br>
/// HL7:  OBX-17.2 : ObservationMethod.Text<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-17.3 : ObservationMethod.NameofCodingSystem<br>
/// .CodeSystemVersionId<br>
/// HL7:  OBX-17.7 : ObservationMethod.CodingSystemVersionID<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If OBX-17.4 or .5 are not null, then OBX-17.4, .5, .6, and .8 will be<br>
/// parsed to a PriorCode as Code, Description, CodeSystem, and<br>
/// CodeSystemVersionId, respectively.<br>
/// HL7:  OBX-17.4 : ObservationMethod.AlternateIdentifier<br>
/// HL7:  OBX-17.5 : ObservationMethod.AlternateText<br>
/// HL7:  OBX-17.6 : ObservationMethod.AlternateNameofCodingSystem<br>
/// HL7:  OBX-17.8 : ObservationMethod.AlternateCodingSystemVersion
Property ObservationMethods As list Of HS.SDA3.CodeTableDetail.ObservationMethod;

/// Time of analyis<br><br>
/// HL7:  OBX-19.1 : DateTimeoftheAnalysis.Time<br>
/// VIEWERLIB: Not stored
Property AnalysisTime As HS.SDA3.TimeStamp;

/// HL7:  OBX-2 : ValueType<br>
/// VIEWERLIB: Not stored
Property ObservationValueType As %String;

/// Coded value of result<br><br>
/// HL7ToSDA3:<br>
/// If OBX-2 is "CE", "CWE", or "CNE" and OBX-5.3 is not null, then OBX-5 will<br>
/// be parsed to ResultCodedValue.<br><br>
/// HL7:  OBX-5 : ObservationValue<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBX-5.1 : ObservationValue<br>
/// .Description<br>
/// HL7:  OBX-5.2 : ObservationValue<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-5.3 : ObservationValue<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// If subfield 4 or 5 of OBX-5 is not null, then subfields 4, 5, 6, and 8 will<br>
/// be parsed to the Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively, of a PriorCode in the list of PriorCodes.<br>
/// HL7:  OBX-5.4 : ObservationValue<br>
/// HL7:  OBX-5.5 : ObservationValue<br>
/// HL7:  OBX-5.6 : ObservationValue<br>
/// HL7:  OBX-5.8 : ObservationValue<br>
/// .CodeSystemVersionId<br>
/// HL7:  OBX-5.7 : ObservationValue<br>
/// .OriginalText<br>
/// HL7:  OBX-5.9 : ObservationValue
Property ResultCodedValue As HS.SDA3.CodeTableDetail.ObservationValueCode;

/// HL7:  OBX-14.1 : DateTimeOfTheObservation.Time<br>
/// VIEWERLIB: lab.HS.EPVisitTestSetData(VISTDInstrumentDate) + lab.HS.EPVisitTestSetData(VISTDInstrumentTime)
Property ObservationTime As HS.SDA3.TimeStamp;

/// HL7ToSDA3: <br>
/// Though OBX-16 is a repeating field, only the first non-null instance will<br>
/// be parsed.<br><br>
/// Streamlet cache:<br>
/// EnteredBy is not stored for antibiotic sensitivities. In the<br>
/// OnUpdateSDAResult method, if a LabResultItem is determined to be a<br>
/// sensitivity, EnteredBy will be set to null.<br><br>
/// HL7:  OBX-16 : ResponsibleObserver<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBX-16.1 : ResponsibleObserver.IDNumber<br>
/// .Description<br>
/// HL7ToSDA3:<br>
/// The family and given names are concatenated together as "[Family], [Given]"<br>
/// to make the Description.<br>
/// HL7:  OBX-16.2.1 : ResponsibleObserver.FamilyName.Surname<br>
/// HL7:  OBX-16.3 : ResponsibleObserver.GivenName<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-16.9 : ResponsibleObserver.AssigningAuthority<br>
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// Not used.
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Not used.
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

/// Not used.
Property FromTime As HS.SDA3.TimeStamp;

/// Not used.
Property ToTime As HS.SDA3.TimeStamp;

/// Returns whether a result is (H)igh,(L)ow,(N)ormal, or Not Applicable("") compared to the reference range 
ClassMethod RangeResult(pResult As %String = "", pRange As %String = "") As %String
{
	Set tRange=..GetRange(pRange)
	If ('$IsValidNum(pResult))||($TR(tRange,"|")="") { Quit "" }
	
	// If they have an = when using <= or => etc then strip it
	Set tRangeL=$p(tRange,"|",1),tRangeH=$p(tRange,"|",2)
	// Strip the = from >= or <=, but make a note of it for later
	Set tLContainsEquals = $S($find(tRangeL,"=")>0:1,1:0)
	Set tHContainsEquals = $S($find(tRangeH,"=")>0:1,1:0)
	Set tRangeL=$TR(tRangeL,"="),tRangeH=$TR(tRangeH,"=")

	//Strip spaces
	set tRangeL=$ZStrip(tRangeL,"*W"),tRangeH=$ZStrip(tRangeH,"*W")
	
	//For > or <, nudge the comparison slightly; for >= or <=, leave as is	
	Set tLAdjust = $Case(tLContainsEquals,1:0,:0.00000001)	
	If tRangeL[">" { Set tRangeL=$TR(tRangeL,">")+tLAdjust }
	ElseIf tRangeL["<" { Set tRangeL=$TR(tRangeL,"<")-tLAdjust } ; this probably shouldn't happen
	Set tHAdjust = $Case(tHContainsEquals,1:0,:0.00000001)
	If tRangeH[">" { Set tRangeH=$TR(tRangeH,">")+tHAdjust } ; this probably shouldn't happen
	ElseIf tRangeH["<" { Set tRangeH=$TR(tRangeH,"<")-tHAdjust }
	
	If $IsValidNum(tRangeL),pResult<tRangeL Quit "L"
	If $IsValidNum(tRangeH),pResult>tRangeH Quit "H"
	If ($IsValidNum(tRangeL)||(tRangeL=""))&$IsValidNum(tRangeH) Quit "N"
	If $IsValidNum(tRangeL)&(tRangeH="") Quit "N"
	Quit ""
}

/// Convert range to rangeL|rangeH
ClassMethod GetRange(range As %Library.String = "") As %Library.String
{
 set range=$ZStrip(range,"*C")
	// Evaluate range information without spaces but use the data including spaces.
 set val=$ZStrip(range,"*W")
 if $e(val)="<" quit "|"_range
 if $e(val)=">" quit range_"|"
 if $e(val)="-"&&(range["/") {set rangeL=$p(range,"/"),rangeH=$p(range,"/",2)}
 elseif $e(val)="-"&&($e(val,2,99)["-") {set rangeL="-"_$p(range,"-",2),rangeH=$p(range,"-",3,99)}
 else {set rangeL=$p(range,"-"),rangeH=$p(range,"-",2)}
 // Check for numeric values.
 set valL=$ZStrip(rangeL,"<>W")
 set valH=$ZStrip(rangeH,"<>W")
 if $IsValidNum(valL) set rangeL=valL
 if $IsValidNum(valH) set rangeH=valH
 set rangeo=rangeL_"|"_rangeH
 quit $s(rangeo="|":"",1:rangeo)
}

/// Copied from the generated code and modified to fit the needs of this class.  Changes to the default
/// generated code are commented.
Method UpdateSDA(pFromObject, pOmitProperties, pIsDeleted As %Boolean = 0)
{
	If (pIsDeleted){
		Set ..EnteredAt=""
		Set ..EnteredOn=""
		Do ..CustomPairs.Clear()
		Set ..Extension=""
		Set ..TestItemCode=""
		Set ..ResultValue=""
		Set ..SubId=""
		Set ..ResultValueUnits=""
		Set ..ResultNormalRange=""
		Set ..ResultInterpretation=""
		Set ..TestItemStatus=""
		Set ..Comments=""
		Set ..ReferenceComment=""
		Set ..PerformedAt=""
		Do ..ObservationMethods.Clear()
		Set ..AnalysisTime=""
		Set ..ObservationValueType=""
		Set ..ResultCodedValue=""
		Set ..ObservationTime=""
		Set ..EnteredBy=""
		Set ..ActionCode=""
		Set ..ActionScope=""
		Set ..UpdatedOn=""
		Set ..ExternalId=""
		Set ..EncounterNumber=""
		Set ..FromTime=""
		Set ..ToTime=""
	}
	//Before we can save anything, we must determine whether this constitutes a "correction" (existing
	//status is Final or Corrected and result or range has changed. Deletions only count as changes if 
	//there is data to delete.)
	set tIsCorrection = 0
	if (((..TestItemStatus = "F")||(..TestItemStatus = "K"))&&
	    (((pFromObject.ResultValue'="")&&(pFromObject.ResultValue'="""""")&&(pFromObject.ResultValue'=..ResultValue))||
	    ((pFromObject.ResultValue="""""")&&(..ResultValue'=""))||
	    ((pFromObject.ResultNormalRange'="")&&(pFromObject.ResultNormalRange'="""""")&&(pFromObject.ResultNormalRange'=..ResultNormalRange))||
	    ((pFromObject.ResultNormalRange="""""")&&(..ResultNormalRange'=""))))
	{
		set tIsCorrection = 1
	}
	Set val=pFromObject.ActionCode If val'="" Set ..ActionCode=$S(val="""""":"",1:val)
	Set val=pFromObject.ActionScope If val'="" Set ..ActionScope=$S(val="""""":"",1:val)
	If pFromObject.IsDefined("EnteredBy") {Set:..EnteredBy="" ..EnteredBy=##class(HS.SDA3.CodeTableDetail.User).%New() Do ..EnteredBy.UpdateSDA(pFromObject.EnteredBy,,pIsDeleted)}
	If pFromObject.IsDefined("EnteredAt") {Set:..EnteredAt="" ..EnteredAt=##class(HS.SDA3.CodeTableDetail.Organization).%New() Do ..EnteredAt.UpdateSDA(pFromObject.EnteredAt,,pIsDeleted)}
	Set val=pFromObject.EnteredOn If val'="" Set ..EnteredOn=$S(val="""""":"",1:val)
	Set val=pFromObject.FromTime If val'="" Set ..FromTime=$S(val="""""":"",1:val)
	Set val=pFromObject.ToTime If val'="" Set ..ToTime=$S(val="""""":"",1:val)
	Set val=pFromObject.ExternalId If val'="" Set ..ExternalId=$S(val="""""":"",1:val)
	Set val=pFromObject.EncounterNumber If val'="" Set ..EncounterNumber=$S(val="""""":"",1:val)
	If pFromObject.IsDefined("TestItemCode") {Set:..TestItemCode="" ..TestItemCode=##class(HS.SDA3.CodeTableDetail.LabTestItem).%New() Do ..TestItemCode.UpdateSDA(pFromObject.TestItemCode,,pIsDeleted)}
	Set val=pFromObject.ResultValue If val'="" Set ..ResultValue=$S(val="""""":"",1:val)
	//SubId cannot be changed. Anything that calls this should assert that the SubIds of the from and to objects are the same.
	//Set val=pFromObject.SubId If val'="" Set ..SubId=$S(val="""""":"",1:val)
	Set val=pFromObject.ResultValueUnits If val'="" Set ..ResultValueUnits=$S(val="""""":"",1:val)
	Set val=pFromObject.ResultNormalRange If val'="" Set ..ResultNormalRange=$S(val="""""":"",1:val)
	Set val=pFromObject.ResultInterpretation If val'="" Set ..ResultInterpretation=$S(val="""""":"",1:val)
	//If we have determined this is a correction, set the status to K for Corrected no matter what was passed in
	if (tIsCorrection) { set ..TestItemStatus = "K" }
	else { Set val=pFromObject.TestItemStatus If val'="" Set ..TestItemStatus=$S(val="""""":"",1:val) }
	Set val=pFromObject.Comments If val'="" Set ..Comments=$S(val="""""":"",1:val)
	Set val=pFromObject.ReferenceComment If val'="" Set ..ReferenceComment=$S(val="""""":"",1:val)
	If pFromObject.IsDefined("PerformedAt") {Set:..PerformedAt="" ..PerformedAt=##class(HS.SDA3.CodeTableDetail.Organization).%New() Do ..PerformedAt.UpdateSDA(pFromObject.PerformedAt,,pIsDeleted)}
	Set val=pFromObject.ObservationTime If val'="" Set ..ObservationTime=$S(val="""""":"",1:val)
	If pFromObject.IsDefined("ObservationMethods") {
		Set aval=pFromObject.ObservationMethods,c=aval.Count(),j=0
		If c {
			Do ..ObservationMethods.Clear()
			F k=1:1:c {
				Set val=aval.GetAt(k)
				Do:$IsObject(val) ..ObservationMethods.Insert(##Class(HS.SDA3.CodeTableDetail.ObservationMethod).%New()),..ObservationMethods.GetAt($I(j)).UpdateSDA(pFromObject.ObservationMethods.GetAt(k),,pIsDeleted)
			}
		}
	}
	Set val=pFromObject.AnalysisTime If val'="" Set ..AnalysisTime=$S(val="""""":"",1:val)
	Set val=pFromObject.ObservationValueType If val'="" Set ..ObservationValueType=$S(val="""""":"",1:val)
	If pFromObject.IsDefined("ResultCodedValue") {Set:..ResultCodedValue="" ..ResultCodedValue=##class(HS.SDA3.CodeTableDetail.ObservationValueCode).%New() Do ..ResultCodedValue.UpdateSDA(pFromObject.ResultCodedValue,,pIsDeleted)}
	Quit
}

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
<Value>TestItemCode</Value>
</Value>
<Value name="14">
<Value>ResultValue</Value>
</Value>
<Value name="15">
<Value>SubId</Value>
</Value>
<Value name="16">
<Value>ResultValueUnits</Value>
</Value>
<Value name="17">
<Value>ResultNormalRange</Value>
</Value>
<Value name="18">
<Value>ResultInterpretation</Value>
</Value>
<Value name="19">
<Value>TestItemStatus</Value>
</Value>
<Value name="20">
<Value>Comments</Value>
</Value>
<Value name="21">
<Value>ReferenceComment</Value>
</Value>
<Value name="22">
<Value>PerformedAt</Value>
</Value>
<Value name="23">
<Value>ObservationMethods</Value>
</Value>
<Value name="24">
<Value>AnalysisTime</Value>
</Value>
<Value name="25">
<Value>ObservationValueType</Value>
</Value>
<Value name="26">
<Value>ResultCodedValue</Value>
</Value>
<Value name="27">
<Value>ObservationTime</Value>
</Value>
<Value name="28">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
