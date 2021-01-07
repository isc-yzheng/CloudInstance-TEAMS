IncludeGenerator (HS.Common, %occErrors)

/// Base for SDA objects
Class HS.SDA3.SuperClass Extends HS.SDA3.DataType
{

/// Message action code<br>
/// Case-sensitive<br>
/// Supported values include:<br>
/// D = Delete<br>
/// E = Delete if empty (Encounters only)<br>
/// I = Inactivate all<br>
/// C = Clear/Delete all<br>
/// R = Replace (Patient and Encounter only)<br>
/// Any other value = Add or Update<br><br>
/// ActionCode is only supported for SDA3 classes corresponding to Streamlet<br>
/// types (Allergy, Diagnosis, etc.). Not all of the above codes are supported<br>
/// for every class. Whether ActionCode is supported and what codes are<br>
/// supported is documented in each individual subclass. For codes "C" and "I",<br>
/// all streamlets of the given type belonging to the given Patient and in the<br>
/// given Encounter (or Encounter-less if the inbound SDA object has no<br>
/// EncounterNumber) will be cleared or inactivated. Otherwise (codes "D", "E",<br>
/// "R") only the matching streamlet will be affected.
Property ActionCode As %String;

/// Optional ActionCode qualifier<br>
/// For selected SDA classes, this qualifies ActionCodes "I" (if it is<br>
/// supported) and "C" by giving them a scope. Ex: for Problems, ActionCode="C"<br>
/// and ActionScope="PAST" will only delete past problems. (The meaning of<br>
/// "past" is explained in HS.SDA3.Problem.) Whether ActionScope is supported<br>
/// and what values are supported is documented in each individual subclass.
Property ActionScope As %String;

/// User who updated source system<br><br>
/// SDATableName=User, ViewerClass=User.HS.SSUser
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// Source System name<br><br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// Date/time updated or entered.  For labs, this represents when the order was<br>
/// placed.
Property EnteredOn As HS.SDA3.TimeStamp;

/// This optional property is only utilized as a tie-breaker when aggregating<br>
/// at the Access Gateway. The system will only populate it for Encounter-less<br>
/// data, and only if no EnteredOn is supplied.  Data sources may populate<br>
/// this if they have no EnteredOn, or if EnteredOn is used to represent<br>
/// something other than how recent this record is. For Encounter-less data, if<br>
/// there are two records from different sources, we first use the facility<br>
/// tier, and if the same, we use the "most recent" record, as determined by<br>
/// this, or EnteredOn if this isn't populated.<br>
/// In addition to the above, we also populate this property when we process<br>
/// inbound SDA with an ActionCode="I" - a mass inactivate.  This is to allow<br>
/// for some poorly behaved systems that are not able to tell us that something<br>
/// (like a medication) has been discontinued - instead, they send in data<br>
/// which only contains new meds, and custom pipeline code detects this and<br>
/// inserts a mass inactivate first.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Start of time range
Property FromTime As HS.SDA3.TimeStamp;

/// End of time range
Property ToTime As HS.SDA3.TimeStamp;

/// Identifier used by systems outside HealthShare.<br><br>
/// Streamlet cache:<br>
/// If present on any SDA object corresponding to a streamlet type, ExternalId<br>
/// will be the only property used for matching (besides EncounterNumber and<br>
/// aggregation key, which are always used). For example, if two<br>
/// HS.SDA3.Allergy objects have the same EncounterNumber and ExternalId but<br>
/// different Allergy.Code values, they will still be considered a match. A<br>
/// null ExternalId will not match a non-null ExternalId. For example, if two<br>
/// HS.SDA3.Allergy objects have the same EncounterNumber and Allergy.Code, but<br>
/// one has an ExternalId and one does not, they will not match. Matching on<br>
/// ExternalId is SQLUPPER collated.
Property ExternalId As %String(MAXLEN = 220);

/// A string that uniquely identifies an Encounter within a patient record.<br>
/// In cases where HS attempts to generate an EncounterNumber, the logic is:<br>
/// -If EncounterType is "G" or "S", generate EncounterNumber as "HSgenerated"<br>
/// followed by an incremental number.<br>
/// -Else if Patient MRN and Encounter FromTime are not null, generate<br>
/// EncounterNumber as "[MRN]-[FromTime date]".<br>
/// -Else no EncounterNumber can be generated.<br><br>
/// HL7ToSDA3:<br>
/// If PV1-19.1 is null, HealthShare attempts to generate an EncounterNumber<br>
/// using the above logic. If one cannot be generated, no Encounter is parsed<br>
/// to the SDA and all the data parsed from the HL7 is Encounter-less. If one<br>
/// can be parsed or generated, then Diagnoses, Observations, Orders,<br>
/// Procedures, Problems, Appointments, and Documents, in addition to<br>
/// Encounter, will be parsed with EncounterNumber.<br><br>
/// Streamlet cache:<br>
/// For Encounters, this is the only match property (besides AggregationKey).<br>
/// See HS.SDA3.Encounter for more info on special processing of<br>
/// EncounterNumber for that type. For Patient and classes that do not<br>
/// correspond to streamlet types, EncounterNumber is not used. For classes<br>
/// that do correspond to streamlet types, EncounterNumber is optionally used<br>
/// to link an SDA object to an Encounter. Only objects linked to the same<br>
/// Encounter can match, and Encounter-less data can only match Encounter-less<br>
/// data. If an inbound SDA object contains an EncounterNumber for which no<br>
/// Encounter exists for that Patient, then an error will be logged and the<br>
/// streamlet will not be saved.<br><br>
/// Viewer cache:<br>
/// In the Viewer Cache, data is structured hierarchically. Some types are<br>
/// stored "under" an Encounter, while others are not. If an SDA object has no<br>
/// EncounterNumber but is Encounter-level in the Viewer Cache, then it will be<br>
/// inserted into the Patient's silent Encounter in the Viewer Cache only. If<br>
/// the Patient has no silent Encounter, one will be created in the Viewer<br>
/// Cache only. If an SDA object is linked to an Encounter but is not<br>
/// Encounter-level in the Viewer Cache, then that link is simply not reflected<br>
/// in the Viewer Cache, except for Allergy and Illness History. Though not<br>
/// Encounter-level, these types do have fields for EncounterNumber in the<br>
/// Viewer Cache.<br><br>
/// HL7:  PV1-19.1 : VisitNumber.IDNumber
Property EncounterNumber As %String(MAXLEN = 220);

/// The generic container to hold all sorts of data about this object<br><br>
/// Viewer cache:<br>
/// For every SDA3 type corresponding to a streamlet type except CustomObject,<br>
/// the CustomPairs are inserted into the Viewer Cache as web.SDA3.NVPairs. In<br>
/// addition to the Name and Value, web.SDA3.NVPair also stores the aggregation<br>
/// key of the patient record, the info type of the containing streamlet, and<br>
/// the ID of the corresponding object in the Viewer Cache.<br><br>
/// VIEWERLIB: web.SDA3.NVPair<br><br>
/// .Name<br>
/// VIEWERLIB: web.SDA3.NVPair(Name)<br>
/// .Value<br>
/// VIEWERLIB: web.SDA3.NVPair(Value)
Property CustomPairs As list Of HS.SDA3.NVPair;

/// Utility Method used to when exporting to a container stream or string
/// Subclasses may override if the container property isn't the simple plural (ex: Allergies)
ClassMethod StartXMLList()
{
	Quit "<"_..%ClassName()_"s>"
}

/// Utility Method used to when exporting to a container stream or string
/// Subclasses may override if the container property isn't the simple plural (ex: Allergies)
ClassMethod EndXMLList()
{
	Quit "</"_..%ClassName()_"s>"
}

/// For standard and extended SDA classes, pType will be the short SDA classname
/// For custom SDA classes, pType will be the full SDA classname
ClassMethod GetStreamletClass(pType)
{
	// for a standard SDA class, we get the streamlet class from the extension class,
	// to let the extension override it.  Classes that don't allow extension
	// can override this method
	If pType'["." Quit $Parameter("HS.Local.SDA3."_pType_"Extension","STREAMLETCLASS")
	// For custom ones, if we have a parameter, use it
	If $Parameter(,"STREAMLETCLASS")'="" Quit $Parameter(,"STREAMLETCLASS")
	//The code below is for backwards compatibility - it predates the parameter
	//and can be overridden if need be, but really one should just use the parameter
	Quit $P(pType,".",1,$L(pType,".")-1)_".Streamlet."_$P(pType,".",$L(pType,"."))
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
</Data>
<State>SuperClassState</State>
<Type>%Storage.Serial</Type>
}

}
