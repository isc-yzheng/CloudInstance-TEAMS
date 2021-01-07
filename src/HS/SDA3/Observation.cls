/// Note that Observations appear in three places in the SDA3 data model: <br>
/// as a list property of Container, as a list property of Vaccination <br>
/// and as a list property of SocialDeterminant.<br><br>
/// Observations under the Container are stored as their own streamlets.<br>
/// Observations that are properties of a Vaccination are stored as part of the<br>
/// Vaccination streamlet. Cases where the HL7 or Streamlet processing is<br>
/// different for independent Observations versus Vaccination Observations are<br>
/// noted in these annotations. At present Vaccination Observations are not<br>
/// stored in the Viewer Cache, so any mention of the Viewer Cache here refers<br>
/// to independent Observations only. Observations that are properties of a <br>
/// Social Determinant are stored as part of the Social Determinant streamlet.<br><br>
/// Also note that the way some properties are parsed from HL7 will depend on<br>
/// the value of the ObservationCompatibilityMode setting of the HL7 Inbound<br>
/// Process operation of the Edge production (referred to here as Compatibility<br>
/// Mode on or off).<br>
/// HS.SDA3.Observation corresponds to the CDA Vital Signs section.  An Observation<br>
/// is exported to the Vital Signs section only when the ObservationCode indicates<br>
/// a valid LOINC Vital Sign code.
Class HS.SDA3.Observation Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.ObservationExtension;

/// Time of the observation<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Observation Streamlet class, if<br>
/// ObservationTime is null, it is defaulted to EnteredOn, then to the current<br>
/// date/time.<br>
/// In the OnBeforeMatch method of the Vaccination Streamlet class, if<br>
/// ObservationTime is null, it is defaulted to the last non-null<br>
/// ObservationTime in the list (that was originally non-null, not defaulted),<br>
/// then to the EnteredOn of the current Observation, then to the current<br>
/// date/time.<br><br>
/// HL7:  OBX-14.1 : DateTimeoftheObservation.Time<br>
/// VIEWERLIB: User.HS.MRObservationEntry(OBSENTRYDate) + User.HS.MRObservationEntry(OBSENTRYTime)<br>
/// VIEWERLIB: User.HS.MRObservations(OBSDate) + User.HS.MRObservations(OBSTime)<br>
Property ObservationTime As HS.SDA3.TimeStamp;

/// Streamlet cache:<br>
/// In the OnValidate method of the Observation Streamlet class, if the<br>
/// Observation has no ObservationCode, an error will be logged and the<br>
/// Streamlet will not be saved.<br>
/// In the OnValidate method of the Vaccination Streamlet class, if any of the<br>
/// Observations in VXUObservations has no ObservationCode, an error will be<br>
/// logged and the Vaccination will not be saved.<br><br>
/// HL7:  OBX-3  : ObservationIdentifier<br>
/// SDATableName=Observation, ViewerClass=User.HS.MRCObservationItem<br>
/// VIEWERLIB: User.HS.MRObservations(OBSItemDR)<br><br>
/// .Code<br>
/// HL7:  OBX-3.1 : ObservationIdentifier.Identifier<br>
/// VIEWERLIB: User.HS.MRCObservationItem(ITMCode)<br>
/// .Description<br>
/// HL7:  OBX-3.2 : ObservationIdentifier.Text<br>
/// VIEWERLIB: User.HS.MRCObservationItem(ITMDesc)<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-3.3 : ObservationIdentifier.NameofCodingSystem<br>
/// VIEWERLIB: Not stored<br>
/// .ObservationValueUnits<br>
/// Streamlet cache:<br>
/// Note that units are not used when matching Observation Streamlets, so two<br>
/// SDA3 Observations with the same ObservationTime and Observation.Code and<br>
/// SDACodingStandard, and different ObservationValueUnits *will* match, and<br>
/// the existing value for ObservationValueUnits will be overridden.<br>
/// Viewer cache:<br>
/// Note that units *are* used for code table matching in the Viewer Cache, so<br>
/// two CodeTableDetail Observations with the same Code, Description, and<br>
/// SDACodingStandard but different ObservationValueUnits *will not* match.<br>
/// HL7:  OBX-6  : Units<br>
/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.MRCObservationItem(ITMCTUOMDR)<br>
/// .ObservationValueUnits.Code<br>
/// HL7:  OBX-6.1 : Units.Identifier<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMCode)<br>
/// .ObservationValueUnits.Description<br>
/// HL7:  OBX-6.2 : Units.Text<br>
/// VIEWERLIB: User.HS.CTUOM(CTUOMDesc)<br>
/// .ObservationValueUnits.SDACodingStandard<br>
/// HL7:  OBX-6.3 : Units.NameofCodingSystem<br>
/// VIEWERLIB: Not stored
Property ObservationCode As HS.SDA3.CodeTableDetail.Observation;

/// Free-text value of the observation<br><br>
/// HL7ToSDA3:<br>
/// If Compatibility Mode is on and the OBX segment is for an independent (not<br>
/// Vaccination) Observation, then ObservationValue is parsed from each<br>
/// instance of OBX-5.1 (OBX-5 is repeating) concatenated together with ", ".<br>
/// If Compatibility Mode is off or if the OBX segment is for a Vaccination<br>
/// Observation, then the behavior depends on the value of OBX-2:<br>
/// -If OBX-2 is CE, CWE, or CNE, ObservationValue is populated by OBX-5.2<br>
///  (ObservationValue.Text) or OBX-5.9 (ObservationValue.OriginalText) if that<br>
///  is null.<br>
/// -If OBX-2 is TS or DT, then OBX-5 should contain an HL7 timestamp, and<br>
///  ObservationValue will be parsed as that time in YYYY-MM-DD hh:mm:ssZ<br>
///  format.<br>
/// -If OBX-2 is SN, then ObservationValue will be parsed as subfields 1<br>
///  through 4 of OBX-5 all concatenated together.
/// -If OBX-2 is none of these values, then ObservationValue is parsed from<br>
/// each instance of OBX-5.1 (OBX-5 is repeating) concatenated together with<br>
/// ", ".<br><br>
/// HL7:  OBX-5  : ObservationValue<br>
/// VIEWERLIB: User.HS.MRObservations(OBSValue)
Property ObservationValue As %String(MAXLEN = 999);

/// HL7ToSDA3:<br>
/// The Value Type affects how ObservationValue is parsed and whether<br>
/// ObservationCodedValue or ObservationValueTime will be parsed as well. See<br>
/// the annotations on those properties for more info.<br><br>
/// HL7:  OBX-2 : ValueType<br>
/// VIEWERLIB: Not stored
Property ObservationValueType As %String;

/// HL7ToSDA3:<br>
/// If Compatibility Mode is off or the OBX is for a Vaccination Observation,<br>
/// and if OBX-2 (Value Type) is TS or DT, the ObservationValueTime is parsed<br>
/// as OBX-5.1, converted to XML timestamp format. Otherwise HL7ToSDA3 does<br>
/// not set this.<br><br>
/// HL7:  OBX-5.1 : ObservationValue<br>
/// VIEWERLIB: Not stored<br>
Property ObservationValueTime As HS.SDA3.TimeStamp;

/// Coded value of observation<br><br>
/// HL7ToSDA3:<br>
/// ObservationCodedValue will only be parsed if Compatibility Mode is off or<br>
/// the OBX is for a Vaccination Observation, and OBX-2 (Value Type) is CE,<br>
/// CWE, or CNE<br><br>
/// HL7:  OBX-5 : ObservationValue<br>
/// VIEWERLIB: Not stored<br><br>
/// .Code<br>
/// HL7:  OBX-5.1 : ObservationValue<br>
/// .Description<br>
/// HL7:  OBX-5.2 : ObservationValue<br>
/// .SDACodingStandard<br>
/// HL7:  OBX-5.3 : ObservationValue<br>
/// .CodeSystemVersionId<br>
/// HL7:  OBX-5.7 : ObservationValue<br>
/// .OriginalText<br>
/// HL7:  OBX-5.9 : ObservationValue<br>
/// .PriorCodes<br>
/// HL7ToSDA3:<br>
/// In addition to the above condition for parsing ObservationCodedValue, if<br>
/// OBX-5.4 or .5 are not null, then OBX-5.4, .5, .6, and .8 will be parsed<br>
/// into a PriorCode as Code, Description, CodeSystem, and CodeSystemVersionId,<br>
/// respectively.<br>
/// HL7:  OBX-5.4 : ObservationValue<br>
/// HL7:  OBX-5.5 : ObservationValue<br>
/// HL7:  OBX-5.6 : ObservationValue<br>
/// HL7:  OBX-5.8 : ObservationValue
Property ObservationCodedValue As HS.SDA3.CodeTableDetail.ObservationValueCode;

/// Comments on the observation<br>
/// The MAXLEN comes from the Trak property.<br><br>
/// HL7:  NTE-3 : Comment<br>
/// VIEWERLIB: User.HS.MRObservations(OBSShortDesc)<br>
Property Comments As %String(MAXLEN = 999);

/// Clinician who made the observation<br><br>
/// SDATableName=CareProvider, ViewerClass=User.HS.CTCareProv<br>
/// VIEWERLIB: User.HS.MRObservations(OBSCTCPDR)<br>
Property Clinician As HS.SDA3.CodeTableDetail.CareProvider;

/// If this observation was taken as part of a group, this is the
/// identifier of that group.<br>
/// The SDA2-to-SDA3 transform populates this field with the SDA2
/// ExternalId property.<br><br>
/// HL7ToSDA3:<br>
/// GroupId will only be parsed for Vaccination Observations.<br><br>
/// HL7:  OBX-4 : ObservationSubId<br>
/// VIEWERLIB: User.HS.MRObservations(OBSExternalId)
Property GroupId As %String;

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
/// HL7:  OBX-17.7 : ObservationMethod.AlternateCodingSystemVersion
Property ObservationMethods As list Of HS.SDA3.CodeTableDetail.ObservationMethod;

/// Supported values:<br>
/// D = Delete<br>
/// C = Clear/Delete All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.MRObservations(OBSUserDR)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.MRObservations(OBSUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.MRObservations(OBSUpdateDate) + User.HS.MRObservations(OBSUpdateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Not used.
Property ActionScope As %String;

/// Id of the observation group this observation belongs to.
Property ObservationGroup As %String;

/// Id of a streamlet containing this obsrvation, used only for memebers of a group
Property ObservationId As %String;

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
<Value>ObservationTime</Value>
</Value>
<Value name="14">
<Value>ObservationCode</Value>
</Value>
<Value name="15">
<Value>ObservationValue</Value>
</Value>
<Value name="16">
<Value>Comments</Value>
</Value>
<Value name="17">
<Value>Clinician</Value>
</Value>
<Value name="18">
<Value>GroupId</Value>
</Value>
<Value name="19">
<Value>ObservationCodedValue</Value>
</Value>
<Value name="20">
<Value>AnalysisTime</Value>
</Value>
<Value name="21">
<Value>ObservationMethod</Value>
</Value>
<Value name="22">
<Value>ObservationValueTime</Value>
</Value>
<Value name="23">
<Value>ObservationMethods</Value>
</Value>
<Value name="24">
<Value>ObservationValueType</Value>
</Value>
<Value name="25">
<Value>Extension</Value>
</Value>
<Value name="26">
<Value>ObservationGroup</Value>
</Value>
<Value name="27">
<Value>ObservationId</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
