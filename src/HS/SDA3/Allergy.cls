/// HS.SDA3.Allergy corresponds to the CDA Allergies and Other Adverse Reactions section.
Class HS.SDA3.Allergy Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.AllergyExtension;

/// Allergy code<br><br>
/// HL7ToSDA3:<br>
/// Both AL1-3 and IAM-3 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// Streamlet cache:<br>
/// If the HS.SDA3.Allergy does not have an Allergy CodeTableDetail,<br>
/// then in the OnValidate method of the Streamlet class, an error will be<br>
/// logged in the Ensemble Event Log and the  streamlet will not be saved.<br><br>
/// SDATableName=Allergy, ViewerClass=User.HS.PACAllergy<br>
/// HL7:  AL1-3 : AllergenCodeMnemonicDescription<br>
/// HL7:  IAM-3 : AllergenCodeMnemonicDescription<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGTypeDR)<br><br>
/// .Code<br>
/// HL7:  AL1-3.1 : AllergenCodeMnemonicDescription.Identifier<br>
/// HL7:  IAM-3.1 : AllergenCodeMnemonicDescription.Identifier<br>
/// VIEWERLIB: User.HS.PACAllergy(ALGCode)<br>
/// .Description<br>
/// HL7:  AL1-3.2 : AllergenCodeMnemonicDescription.Text<br>
/// HL7:  IAM-3.2 : AllergenCodeMnemonicDescription.Text<br>
/// VIEWERLIB: User.HS.PACAllergy(ALGDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  AL1-3.3 : AllergenCodeMnemonicDescription.NameofCodingSystem<br>
/// HL7:  IAM-3.3 : AllergenCodeMnemonicDescription.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// For both AL1-3 and IAM-3, if subfield 4 or 5 is not null, then a PriorCode<br>
/// will be parsed to the SDA with Code coming from subfield 4, Description<br>
/// from 5, and CodingSystem from 6. The Type will be parsed as "A".<br>
/// HL7:  AL1-3.4 : AllergenCodeMnemonicDescription.AlternateIdentifier<br>
/// HL7:  IAM-3.4 : AllergenCodeMnemonicDescription.AlternateIdentifier<br>
/// HL7:  AL1-3.5 : AllergenCodeMnemonicDescription.AlternateText<br>
/// HL7:  IAM-3.5 : AllergenCodeMnemonicDescription.AlternateText<br>
/// HL7:  AL1-3.6 : AllergenCodeMnemonicDescription.NameofAlternateCodingSystem<br>
/// HL7:  IAM-3.6 : AllergenCodeMnemonicDescription.NameofAlternateCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .OriginalText<br>
/// HL7:  AL1-3.9 : AllergenCodeMnemonicDescription.OriginalText<br>
/// HL7:  IAM-3.9 : AllergenCodeMnemonicDescription.OriginalText<br>
/// VIEWERLIB: Not stored
Property Allergy As HS.SDA3.CodeTableDetail.Allergy;

/// The category of the allergy (e.g. Food, Medication)<br><br>
/// HL7ToSDA3:<br>
/// The HL7 field will only be parsed if subfield 1 is not null.<br><br>
/// Streamlet cache:<br>
/// If the Allergy contains no AllergyCategory, then in the OnValidate method<br>
/// of the Streamlet class, one will be defaulted with Code and Description =<br>
/// "Allergy".<br><br>
/// Viewer cache:<br>
/// Note that the code table for this type is MRC_AllType, whereas the table<br>
/// for Reaction is PAC_AllergyCategory.<br><br>
/// HL7:  AL1-2 : AllergenTypeCode<br>
/// HL7:  IAM-2 : AllergenTypeCode<br>
/// SDATableName=AllergyCategory, ViewerClass=User.HS.MRCAllType<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGMRCAllTypeDR)<br><br>
/// .Code<br>
/// HL7:  AL1-2.1 : AllergenTypeCode.Identifier<br>
/// HL7:  IAM-2.1 : AllergenTypeCode.Identifier<br>
/// VIEWERLIB: User.HS.MRCAllType(MRCATCode)<br>
/// .Description<br>
/// HL7:  AL1-2.2 : AllergenTypeCode.Text<br>
/// HL7:  IAM-2.2 : AllergenTypeCode.Text<br>
/// VIEWERLIB: User.HS.MRCAllType(MRCATDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  AL1-2.3 : AllergenTypeCode.NameofCodingSystem<br>
/// HL7:  IAM-2.3 : AllergenTypeCode.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property AllergyCategory As HS.SDA3.CodeTableDetail.AllergyCategory;

/// Clinician who diagnosed/identified allergy<br><br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGCTPCPDR)<br>
Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// The reaction to the allergen<br><br>
/// HL7ToSDA3:<br>
/// Though the HL7 fields are repeating, HL7ToSDA3 will only use the first<br>
/// instance of each. And although the HL7 field is not a coded element,<br>
/// HL7ToSDA3 will use the first piece with respect to the Component Separator<br>
/// (usually "^") as the Reaction Code.<br><br>
/// Viewer cache:<br>
/// Note that the code table for this type is PAC_AllergyCategory,<br>
/// whereas the table for AllergyCategory is MRC_AllType.<br><br>
/// HL7:  AL1-5 : AllergyReaction<br>
/// HL7:  IAM-5 : AllergyReaction<br>
/// SDATableName=Reaction, ViewerClass=User.HS.PACAllergyCategory<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGCategoryDR)
Property Reaction As HS.SDA3.CodeTableDetail.Reaction;

/// The severity of the allergy (e.g. Mild, Severe, Life-threatening)<br><br>
/// HL7ToSDA3:<br>
/// Both AL1-4 and IAM-4 will only be parsed if subfield 1 or 2 is not null.<br><br>
/// HL7:  AL1-4 : AllergySeverityCode<br>
/// HL7:  IAM-4 : AllergySeverityCode<br>
/// SDATableName=Severity, ViewerClass=User.HS.PACAllergySeverity<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGSeverityDR)<br><br>
/// .Code<br>
/// HL7:  AL1-4.1 : AllergySeverityCode.Identifier<br>
/// HL7:  IAM-4.1 : AllergySeverityCode.Identifier<br>
/// VIEWERLIB: User.HS.PACAllergySeverity(ALRGSEVCode)<br>
/// .Description<br>
/// HL7:  AL1-4.2 : AllergySeverityCode.Text<br>
/// HL7:  IAM-4.2 : AllergySeverityCode.Text<br>
/// VIEWERLIB: User.HS.PACAllergySeverity(ALRGSEVDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  AL1-4.3 : AllergySeverityCode.NameofCodingSystem<br>
/// HL7:  IAM-4.3 : AllergySeverityCode.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property Severity As HS.SDA3.CodeTableDetail.Severity;

/// The certainty of the allergy (e.g. Suspected, Confirmed, Lab-tested)<br><br>
/// SDATableName=Certainty, ViewerClass=User.HS.PACAllergyCertainty<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGCertaintyDR)
Property Certainty As HS.SDA3.CodeTableDetail.Certainty;

/// When the allergy was discovered.<br><br>
/// HL7ToSDA3:<br>
/// Though AL1-6 is technically date-only, HL7ToSDA3 will parse a<br>
/// full date/time if one is given in this field.<br><br>
/// HL7:  AL1-6 : IdentificationDate<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGDate) + User.HS.PAAllergy(ALGTime)
Property DiscoveryTime As HS.SDA3.TimeStamp;

/// When the allergy was confirmed.<br><br>
/// Viewer cache:<br>
/// Only the date part is saved to the Viewer Cache. (ALGConfirmedDate is<br>
/// date-only.)<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGConfirmedDate)<br>
Property ConfirmedTime As HS.SDA3.TimeStamp;

/// CRLF-delimited string<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGComments)
Property Comments As %String(MAXLEN = "");

/// When the allergy was no longer active.<br><br>
/// HL7ToSDA3:<br>
/// Note that while the HL7 standard describes IAM-20 as the time of any status<br>
/// change, HealthShare will always interpret this field as the time the<br>
/// allergy is declared inactive.<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class,<br>
/// if InactiveTime is not null, then Status will be<br>
/// set to "I" for "Inactive".<br><br>
/// Viewer cache:<br>
/// Only the date part is saved to the Viewer Cache. (ALGInActiveDate is<br>
/// date-only.)<br><br>
/// HL7:  IAM-20 : StatusedatDateTime<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGInActiveDate)<br>
Property InactiveTime As HS.SDA3.TimeStamp;

/// Why the allergy is considered inactive.<br>
/// CRLF-delimited string.<br><br>
/// HL7:  IAM-8 : ActionReason<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGInActiveFreeText)
Property InactiveComments As %String(MAXLEN = "");

/// When the allergy was verified<br><br>
/// Viewer cache:<br>
/// Only the date part is saved to the Viewer Cache. (ALGVerifiedDate is<br>
/// date-only.)<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGVerifiedDate)<br>
Property VerifiedTime As HS.SDA3.TimeStamp;

/// Drug group to which patient is allergic<br><br>
/// SDATableName=ATCCode, ViewerClass=User.HS.PHCSubCat<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGPHCSCDR)
Property ATCCode As HS.SDA3.CodeTableDetail.ATCCode;

/// Why allergy can't be coded (e.g. too imprecise).<br>
/// CRLF-delimited string.<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGReasonNotCoded)<br>
Property ReasonNotCoded As %String(MAXLEN = "");

/// Allergy description if it can't be typed/coded<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGFreeTextAllergy)
Property FreeTextAllergy As %String(MAXLEN = 5000);

/// CRLF-delimited string<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGDesc)
Property QualifyingDetails As %String(MAXLEN = 32000);

/// HL7ToSDA3:<br>
/// Though IAM-17 is coded, HL7ToSDA3 will only parse the Identifier<br>
/// (subfield 1).<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if Status is not "A",<br>
/// "I", "R", or "C" (for "Active", "Inactive", "Resolved", and "To Be<br>
/// Confirmed", respectively) or null or the delete instruction, it will be set<br>
/// to null. Also, no matter what value is passed in for Status, if the Allergy<br>
/// has an InactiveTime, Status will be set to "I". In the OnValidate method of<br>
/// the Streamlet class, if Status is null, it will be defaulted to "A".<br><br>
/// Viewer cache:<br>
/// The value that appears in the Viewer does not come from the DISPLAYLIST of<br>
/// the ALGStatus property, but rather the Description for the corresponding<br>
/// AllergyStatus Standard Type Item.  See the HS documentation for guidance on<br>
/// configuring this.<br><br>
/// HL7:  IAM-17.1 : AllergyClinicalStatusCode.Identifier<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGStatus)<br>
Property Status As %String;

/// Streamlet cache:<br>
/// Unlike EncounterNumber, this property may be filled in or updated<br>
/// after the Allergy is initially created, and is not used for matching.<br><br>
/// Viewer cache:<br>
/// The ALGEncounter field in the Viewer Cache is used for both EncounterNumber<br>
/// and AssociatedEncounter, whichever is present.  If both are present,<br>
/// EncounterNumber is used.<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGEncounter)
Property AssociatedEncounter As %String(MAXLEN = 220);

/// Supported values:<br>
/// D = Delete<br>
/// I = Inactivate All (set Status="I")<br>
/// C = Clear All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// HL7ToSDA3:<br>
/// Two double quotes ("") in the Set ID field (AL1-1 or IAM-1) will be parsed<br>
/// as ActionCode="I", and four double quotes ("""") as "C".  In either case<br>
/// the rest of the segment is ignored.<br>
/// If IAM-6.1 is "D", HL7ToSDA3 will parse this as ActionCode="D". Any other value<br>
/// is ignored.<br><br>
/// HL7:  AL1-1 : SetIDAL1<br>
/// HL7:  IAM-1 : SetIDIAM<br>
/// HL7:  IAM-6.1 : AllergyActionCode.Identifier<br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// HL7ToSDA3:<br>
/// Only Description is parsed from IAM-14, not Code or SDACodingStandard.<br><br>
/// HL7:  IAM-14 : ReportedBy<br>
/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGUpdateUserDR)<br>
/// .Description<br>
/// The name is formatted as "[Family], [Given]" to make the Description.<br>
/// HL7:  IAM-14.1.1 : FamilyName.Surname<br>
/// HL7:  IAM-14.2 : GivenName<br>
/// VIEWERLIB: User.HS.SSUser(SSUSRName)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// HL7ToSDA3:<br>
/// MSH-4.1 is parsed to the EnteredAt Code. HL7ToSDA3 does not set the<br>
/// Description.<br><br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGLastUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// HL7:  IAM-13 : ReportedDateTime<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGLastUpdateDate) + User.HS.PAAllergy(ALGLastUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// The time of the onset of the allergy.<br><br>
/// Viewer cache:<br>
/// Only the date part is stored in the Viewer Cache. (ALGOnsetDate is<br>
/// date-only.)<br><br>
/// HL7:  AL1-6 : IdentificationDate<br>
/// HL7: IAM-11 : OnsetDate<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGOnsetDate)
Property FromTime As HS.SDA3.TimeStamp;

/// The time the allergy is no longer present<br><br>
/// Viewer cache:<br>
/// Only the date part is saved to the Viewer Cache. (ALGExpiryDate is<br>
/// date-only.)<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGExpiryDate)
Property ToTime As HS.SDA3.TimeStamp;

/// HL7:  IAM-7.1 : AllergyUniqueIdentifier.EntityIdentifier<br>
/// VIEWERLIB: User.HS.PAAllergy(ALGExternalId)<br>
Property ExternalId As %String(MAXLEN = 220);

/// Viewer cache:<br>
/// The ALGEncounter field in the viewer cache is used for both EncounterNumber<br>
/// and AssociatedEncounter, whichever is present.  If both are present,<br>
/// EncounterNumber is used.<br><br>
/// VIEWERLIB: User.HS.PAAllergy(ALGEncounter)
Property EncounterNumber As %String;

/// Not used.
Property ActionScope As %String;

ClassMethod StartXMLList()
{
	Quit "<Allergies>"
}

ClassMethod EndXMLList()
{
	Quit "</Allergies>"
}

Storage Default
{
<Data name="AllergyDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
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
<Value>AllergyType</Value>
</Value>
<Value name="11">
<Value>Allergy</Value>
</Value>
<Value name="12">
<Value>Clinician</Value>
</Value>
<Value name="13">
<Value>Reaction</Value>
</Value>
<Value name="14">
<Value>Severity</Value>
</Value>
<Value name="15">
<Value>Certainty</Value>
</Value>
<Value name="16">
<Value>DiscoveryTime</Value>
</Value>
<Value name="17">
<Value>ConfirmedTime</Value>
</Value>
<Value name="18">
<Value>Comments</Value>
</Value>
<Value name="19">
<Value>InactiveTime</Value>
</Value>
<Value name="20">
<Value>InactiveComments</Value>
</Value>
<Value name="21">
<Value>VerifiedTime</Value>
</Value>
<Value name="22">
<Value>ATCCode</Value>
</Value>
<Value name="23">
<Value>ReasonNotCoded</Value>
</Value>
<Value name="24">
<Value>FreeTextAllergy</Value>
</Value>
<Value name="25">
<Value>QualifyingDetails</Value>
</Value>
<Value name="26">
<Value>LinkedEncounterNumber</Value>
</Value>
<Value name="27">
<Value>Status</Value>
</Value>
<Value name="28">
<Value>Deleted</Value>
</Value>
<Value name="29">
<Value>AllergyCategory</Value>
</Value>
<Value name="30">
<Value>UpdatedOn</Value>
</Value>
<Value name="31">
<Value>CustomPairs</Value>
</Value>
<Value name="32">
<Value>AssociatedEncounter</Value>
</Value>
<Value name="33">
<Value>Extension</Value>
</Value>
</Data>
<Data name="SuperSerialClassState">
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>EnteredBy</Value>
</Value>
<Value name="3">
<Value>EnteredAt</Value>
</Value>
<Value name="4">
<Value>EnteredOn</Value>
</Value>
<Value name="5">
<Value>ExternalId</Value>
</Value>
<Value name="6">
<Value>ActionScope</Value>
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
<Value>AllergyType</Value>
</Value>
<Value name="11">
<Value>Allergy</Value>
</Value>
<Value name="12">
<Value>Clinician</Value>
</Value>
<Value name="13">
<Value>Reaction</Value>
</Value>
<Value name="14">
<Value>Severity</Value>
</Value>
<Value name="15">
<Value>Certainty</Value>
</Value>
<Value name="16">
<Value>DiscoveryTime</Value>
</Value>
<Value name="17">
<Value>ConfirmedTime</Value>
</Value>
<Value name="18">
<Value>Comments</Value>
</Value>
<Value name="19">
<Value>InactiveTime</Value>
</Value>
<Value name="20">
<Value>InactiveComments</Value>
</Value>
<Value name="21">
<Value>VerifiedTime</Value>
</Value>
<Value name="22">
<Value>ATCCode</Value>
</Value>
<Value name="23">
<Value>ReasonNotCoded</Value>
</Value>
<Value name="24">
<Value>FreeTextAllergy</Value>
</Value>
<Value name="25">
<Value>QualifyingDetails</Value>
</Value>
<Value name="26">
<Value>LinkedEncounterNumber</Value>
</Value>
<Value name="27">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^HS.SDA3.AllergyD</DataLocation>
<DefaultData>AllergyDefaultData</DefaultData>
<IdLocation>^HS.SDA3.AllergyD</IdLocation>
<IndexLocation>^HS.SDA3.AllergyI</IndexLocation>
<StreamLocation>^HS.SDA3.AllergyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
