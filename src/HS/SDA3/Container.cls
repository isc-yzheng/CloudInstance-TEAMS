Include HS.HC

/// The container class for the SDA3.<br>
/// This is intended to be used as an XML container to hold and manipulate<br>
/// other SDA3 objects. It is NOT intended to be used as an instantiated object<br>
/// to hold an entire patient record as an in-memory object. API methods are<br>
/// available to walk the stream and instantiate individual streamlet objects.<br>
/// Do not use the standard Caché XMLImport/Export methods on SDA.  We provide<br>
/// methods that are orders of magnitude faster, far better in memory use,<br>
/// support code translations, etc.  See InitializeXMLParse and GetNextSDA<br>
/// for importing data. Any SDA object can be exported by invoking<br>
/// ToQuickXMLStream or ToQuickXMLString on it. If you wish to use the<br>
/// Container for DTL, do it as an XML Vdoc.  When HealthShare is installed, we<br>
/// import the XML schema into the HSLIB namespace to make it available.  See<br>
/// methods ExportXMLSchema and ExportXMLSchemaAPI for how to export the XML<br>
/// schema.
/// @API.Extensible
/// @Modifier Availability InterSystems
Class HS.SDA3.Container Extends (%RegisteredObject, %XML.Adaptor, HS.SDA3.QuickXML) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// Ignore all nulls (i.e. don't store $C(0))
Parameter XMLIGNORENULL = "inputonly";

Parameter DOMAIN = "HS";

/// One patient<br><br>
/// HL7:  PID,PD1,EVN,NTE,MRG,MSH<br>
/// VIEWERLIB: see HS.SDA3.Patient
Property Patient As HS.SDA3.Patient;

/// List of encounters for this patient<br><br>
/// HL7:  PV1,PV2,PID,MRG,MSH,EVN<br>
/// VIEWERLIB: see HS.SDA3.Encounter
Property Encounters As list Of HS.SDA3.Encounter;

/// List of alerts for patient<br><br>
/// VIEWERLIB: see HS.SDA3.Alert
Property Alerts As list Of HS.SDA3.Alert;

/// List of advance directives for patient<br><br>
/// VIEWERLIB: see HS.SDA3.AdvanceDirective
Property AdvanceDirectives As list Of HS.SDA3.AdvanceDirective;

/// List of allergies that patient has<br><br>
/// HL7:  AL1,IAM,MSH<br>
/// VIEWERLIB: see HS.SDA3.Allergy
Property Allergies As list Of HS.SDA3.Allergy;

/// List of past history entries<br><br>
/// VIEWERLIB: see HS.SDA3.IllnessHistory
Property IllnessHistories As list Of HS.SDA3.IllnessHistory;

/// List of social history entries<br><br>
/// VIEWERLIB: see HS.SDA3.SocialHistory
Property SocialHistories As list Of HS.SDA3.SocialHistory;

/// List of family history entries<br><br>
/// VIEWERLIB: see HS.SDA3.FamilyHistory
Property FamilyHistories As list Of HS.SDA3.FamilyHistory;

/// List of guarantors for this patient - not supported<br>
/// This property is present for historic reasons only and should not be used.<br>
/// The Guarantor property on HS.SDA3.Encounter should be used instead.<br>
/// Attempting to process an SDA into the Streamlet Cache<br>
/// containing Guarantors in this property will cause them to be rejected with<br>
/// errors.<br><br>
/// VIEWERLIB: Not stored
Property Guarantors As list Of HS.SDA3.Guarantor;

/// List of diagnoses<br><br>
/// HL7:  DG1,MSH<br>
/// VIEWERLIB: see HS.SDA3.Diagnosis
Property Diagnoses As list Of HS.SDA3.Diagnosis;

/// List of observations made<br><br>
/// HL7ToSDA3:<br>
/// Note that the way some properties of Observation are parsed will depend on<br>
/// the ObservationCompatibilityMode setting of the HL7 Inbound Process<br>
/// operation of the Edge production. See HS.SDA3.Observation for more info.<br><br>
/// HL7:  OBX,NTE<br>
/// VIEWERLIB: see HS.SDA3.Observation
Property Observations As list Of HS.SDA3.Observation;

/// List of observation groups<br><br>
/// VIEWERLIB: Not stored
Property ObservationGroups As list Of HS.SDA3.ObservationGroup;

/// List of problems<br><br>
/// HL7:  PRB,NTE,ROL,MSH<br>
/// VIEWERLIB: see HS.SDA3.Problem
Property Problems As list Of HS.SDA3.Problem;

/// List of physical exams conducted<br><br>
/// VIEWERLIB: see HS.SDA3.PhysicalExam
Property PhysicalExams As list Of HS.SDA3.PhysicalExam;

/// List of procedures<br><br>
/// HL7:  PR1,MSH<br>
/// VIEWERLIB: see HS.SDA3.Procedure
Property Procedures As list Of HS.SDA3.Procedure;

/// List of documents<br><br>
/// HL7:  TXA,OBX,NTE,MSH<br>
/// VIEWERLIB: see HS.SDA3.Document
Property Documents As list Of HS.SDA3.Document;

/// HL7:  ORC,OBR,NTE,TQ1,MSH<br>
/// VIEWERLIB: see HS.SDA3.LabOrder
Property LabOrders As list Of HS.SDA3.LabOrder;

/// HL7:  ORC,OBR,NTE,TQ1,MSH<br>
/// VIEWERLIB: see HS.SDA3.RadOrder
Property RadOrders As list Of HS.SDA3.RadOrder;

/// HL7:  ORC,OBR,NTE,TQ1,MSH<br>
/// VIEWERLIB: see HS.SDA3.OtherOrder
Property OtherOrders As list Of HS.SDA3.OtherOrder;

/// HL7:  ORC,TQ1,RXO,RXE,RXR,RXC,NTE,MSH<br>
/// VIEWERLIB: see HS.SDA3.Medication
Property Medications As list Of HS.SDA3.Medication;

/// HL7:  ORC,TQ1,RXA,RXR,MSH<br>
/// VIEWERLIB: see HS.SDA3.Vaccination
Property Vaccinations As list Of HS.SDA3.Vaccination;

/// HL7:  SCH,AIS,AIP,AIL,MSH,TQ1,NTE<br>
/// VIEWERLIB: see HS.SDA3.Appointment
Property Appointments As list Of HS.SDA3.Appointment;

/// VIEWERLIB: Not stored
Property Referrals As list Of HS.SDA3.Referral;

/// This is populated only from the HealthShare Registry, as part of a special<br>
/// fetch. ClinicalRelationships should not be submitted by a data provider.<br><br>
/// VIEWERLIB: see HS.SDA3.ClinicalRelationship
Property ClinicalRelationships As list Of HS.SDA3.ClinicalRelationship;

/// This is populated only from the HealthShare Registry, as part of a special<br>
/// fetch. ProgramMemberships should not be submitted by a data provider.<br><br>
/// VIEWERLIB: see HS.SDA3.ProgramMembership
Property ProgramMemberships As list Of HS.SDA3.ProgramMembership;

/// VIEWERLIB: Not stored
Property MemberEnrollments As list Of HS.SDA3.MemberEnrollment;

/// VIEWERLIB: Not stored
Property MedicalClaims As list Of HS.SDA3.MedicalClaim;

/// VIEWERLIB: Not stored
Property PharmacyClaims As list Of HS.SDA3.PharmacyClaim;

Property MedicalExplanationOfBenefits As list Of HS.SDA3.MedicalExplanationOfBenefit;

Property PharmacyExplanationOfBenefits As list Of HS.SDA3.PharmacyExplanationOfBenefit;

/// For handling custom data that can be stored as streamlets<br><br>
/// VIEWERLIB: see HS.SDA3.CustomObject
Property CustomObjects As list Of HS.SDA3.CustomObject;

/// List of Genetics orders, that can contain VCF data in a blob
/// VIEWERLIB: Not stored
Property GenomicsOrders As list Of HS.SDA3.GenomicsOrder;

/// VIEWERLIB: Not stored
Property CarePlans As list Of HS.SDA3.CarePlan;

/// VIEWERLIB: Not stored
Property HealthConcerns As list Of HS.SDA3.HealthConcern;

/// VIEWERLIB: Not stored
Property Goals As list Of HS.SDA3.Goal;

/// List of Social Determinants<br><br>
/// VIEWERLIB: TBD
Property SocialDeterminants As list Of HS.SDA3.SocialDeterminant;

/// Not used<br><br>
/// VIEWERLIB: Not stored
Property SessionId As %String(MAXLEN = 32000);

/// ControlId or message ID (for tracking and debugging)<br>
/// Assigned by the system<br><br>
/// VIEWERLIB: Not stored<br>
Property ControlId As %String(MAXLEN = 32000);

/// What action to take for this SDA in the ECR<br><br>
/// HL7ToSDA3:<br>
/// The Action parsed to the SDA depends on the value of MSH-9 (Message Type):<br>
/// ADT_A13 -> CancelDischarge<br>
/// ADT_A09 -> DeleteEncounter<br>
/// ADT_A18 -> Merge<br>
/// ADT_A23 -> DeleteEncounter<br>
/// ADT_A29 -> DeletePatient<br>
/// ADT_A30 -> Merge<br>
/// ADT_A39 -> Merge<br>
/// ADT_A45 -> Move<br>
/// ADT_A50 -> Merge<br>
/// Any other supported type -> AddOrUpdate<br><br>
/// Streamlet cache:<br>
/// The actions to be taken against the Patient or Encounter will be determined<br>
/// from the Action and the EventDescription, not just one or the other.<br>
/// Additionally, the Patient ActionCode may take precedence over Action and<br>
/// EventDescription. The full logic to determine the Patient action is:<br>
/// -If Patient ActionCode="R", Patient action is "Replace".<br>
/// -Else if Patient ActionCode="D", Patient action is "Delete".<br>
/// -Else if Action="DeletePatient", Patient action is "Delete".<br>
/// -Else if EventDescription="ADT_A47", Patient action is "ChangeNum".<br>
/// -Else if EventDescription="ADT_A50", Patient action is null (regular<br>
/// add/update).<br>
/// -Else if Action="Merge", Patient action is "Merge".<br>
/// -Else Patient action is null (regular add/update).<br><br>
/// The logic to determine the Encounter action is:<br>
/// -If Action="DeleteEncounter", Encounter action is "Delete".<br>
/// -Else if EventDescription="ADT_A50", Encounter action is "ChangeNum".<br>
/// -Else if EventDescription="ADT_A45", Encounter action is "Move".<br>
/// -Else if EventDescription="ADT_A13", Encounter action is "CD"<br>
/// -Else the Encounter action is determined from the Encounter ActionCode.<br><br>
/// Note, for instance, that Action="CancelDischarge" actually doesn't do<br>
/// anything, but rather it is EventDescription="ADT_A13" that cancels a<br>
/// discharge. "AddOrUpdate" is the default and is the same as Action="".<br>
/// "CancelAdmit" and "QueryResponse" do nothing and are the same as null or<br>
/// "AddOrUpdate". On export, Action is always set to "QueryResponse".<br><br>
/// VIEWERLIB: Not stored
Property Action As %String(VALUELIST = ",AddOrUpdate,Merge,Move,DeletePatient,DeleteEncounter,CancelAdmit,CancelDischarge,QueryResponse");

/// A description of the event that precipitated this message.<br><br>
/// Streamlet cache:<br>
/// The actions to be taken against the Patient or Encounter will be determined<br>
/// from the Action and the EventDescription, not just one or the other.<br>
/// Additionally, the Patient ActionCode may take precedence over Action and<br>
/// EventDescription. See the annotation on Action for a full description of<br>
/// the logic.<br>
/// In the MPIUpdateManager, if the MPIUpdateFlag (either from the update<br>
/// request, or, if that is null, the DefaultMPIUpdateMode setting of the<br>
/// operation) is "ADTOnly", then the update will only be sent to the Registry<br>
/// on add or if EventDescription starts with "ADT".<br><br>
/// HL7:  MSH-9 : MessageType<br>
/// VIEWERLIB: Not stored<br>
Property EventDescription As %String(MAXLEN = 220, TRUNCATE = 1);

/// This property is not used. Rather, the UpdateECRDemographics property of<br>
/// HS.Message.ECRUpdateRequest is used to determine whether to update Patient<br>
/// and Encounter streamlets. See ECRUpdateRequest for full documentation.<br><br>
/// VIEWERLIB: Not stored<br>
Property UpdateECRDemographics As %Boolean [ InitialExpression = 1 ];

/// The sending facility; the organization which sent the message<br>
/// Strictly speaking, it may not be the originator of the data, as the<br>
/// SendingFacility may just be a "relay". But this distinction is not always<br>
/// followed.<br><br>
/// Streamlet cache:<br>
/// As Container is not a streamlet, SendingFacility is not stored as part of<br>
/// any streamlet. However it is stored as part of the internal MRN that<br>
/// HealthShare stores for every Patient streamlet. The format is:<br>
/// <pre>
/// [SendingFacility]^[PatientNumber.Organization.Code]^[PatientNumber.Number]<br>
/// </pre>
/// Where PatientNumber is the first item in HS.SDA3.Patient:PatientNumbers<br>
/// with NumberType="MRN". Aggregation keys are indexed by MRN and vice versa<br>
/// in ^HS.SDAStreamletMRN:<br>
/// <pre>
/// ^HS.SDAStreamletMRN("MRN", [MRN]) = [AggregationKey]<br>
/// ^HS.SDAStreamletMRN("Key", [AggregationKey]) = [MRN]<br>
/// </pre>
/// Patient streamlets are matched on MRN/AggregationKey.<br>
/// In the EncounterActions method of HS.SDA3.Streamlet.Encounter, if a new<br>
/// Encounter has no HealthCareFacility, one is defaulted in with Code and<br>
/// Organization.Code = SendingFacility.<br><br>
/// Viewer cache:<br>
/// If any HealthCareFacility CodeTableDetail with no Organization is loaded<br>
/// into the Viewer Cache, an Organization with Code = SendingFacility will be<br>
/// defaulted in.<br><br>
/// HL7:  MSH-4.1 : SendingFacility.NamespaceID<br>
/// VIEWERLIB: Not stored
Property SendingFacility As %String(MAXLEN = 220);

/// The data contained within AdditionalInfo will not be used or stored in the<br>
/// Streamlet Cache, however it will be copied to the AddUpdateHubRequest and<br>
/// sent to the Registry where a pre- and/or post-processor on the Hub MPI<br>
/// Manager can make use of it.<br>
/// The support for user-defined "InfoTypes" was removed in 2009.1.2, and keys<br>
/// starting with "InfoTypes" should no longer be used. (They are used<br>
/// internally, and will be overwritten).<br>
/// Example syntax for AdditionalInfo:<br>
/// <pre>
/// &lt;AdditionalInfo&gt;&lt;AdditionalInfoItem AdditionalInfoKey="MyData"&gt;ABC&lt;/AdditionalInfoItem&gt;&lt;/AdditionalInfo&gt;
/// </pre>
/// VIEWERLIB: Not stored
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

Method %OnNew(data = "") As %Status [ Internal ]
{
	set ..SessionId = data
	quit $$$OK
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:TestTranslate
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod TestTranslate() [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","TestTranslate")
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:TranslateSDAStream
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod TranslateSDAStream(pSDAIn As %Stream.Object, pSDAOut As %Stream.Object = "", pTransProfile As %String = "", pForceDefaulting As %Boolean = 0) As %Status [ CodeMode = expression ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","TranslateSDAStream",pSDAIn,.pSDAOut,pTransProfile,pForceDefaulting)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:NormalizeSDAStream
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod NormalizeSDAStream(pSDAIn As %Stream.Object, ByRef pSDAOut As %Stream.Object = "", ByRef pErrList As %ListOfDataTypes) As %Status [ CodeMode = expression ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","NormalizeSDAStream",pSDAIn,.pSDAOut,.pErrList)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:TestMake
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod TestMake() [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","TestMake")
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:MakeSDAStream
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod MakeSDAStream(pAgKey As %String = "", ByRef pSDAStream As %GlobalCharacterStream = "", pFiltersObj = "", pUseFilters As %Integer = 0, pTransProfile As %String = "", pIncompleteResult As %Boolean = 0) As %Status [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","MakeSDAStream",pAgKey,.pSDAStream,pFiltersObj, pUseFilters, pTransProfile, pIncompleteResult)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:GetStreamlets
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod GetStreamlets(pRequest, ByRef pSDAStream As %GlobalCharacterStream = "", pTransProfile As %String = "") As %Status [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","GetStreamlets",pRequest, .pSDAStream, pTransProfile)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:WriteSDAStream
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod WriteSDAStream(pSDAStream, pClass, pID, pWrap As %Boolean = 0, pStreamlet) As %Status [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","WriteSDAStream",pSDAStream, pClass, pID, pWrap, pStreamlet)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:ListStreamletIds
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod ListStreamletIds(pStreamletType, pAgKey = "", pPAPersonId = "", ByRef pStreamletIds) As %Status [ CodeMode = expression ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","ListStreamletIds",pStreamletType, pAgKey, pPAPersonId, .pStreamletIds)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:LoadSDAObject
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod LoadSDAObject(pStreamletId, ByRef pSDA) As %Status [ CodeMode = expression ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","LoadSDAObject",pStreamletId, .pSDA)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:LoadSDAArray
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod LoadSDAArray(pStreamletId, pArray) As %Status [ CodeMode = expression ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","LoadSDAArray",pStreamletId, pArray)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:LoadTranslationProfile
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod LoadTranslationProfile(pProfile) As %Status [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","LoadTranslationProfile",pProfile)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:PurgeDataBySession
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod PurgeDataBySession(pSessionId As %String) As %Status [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","PurgeDataBySession",pSessionId)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:PurgeAggregationCache
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod PurgeAggregationCache(pAgKey) As %Status [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","PurgeAggregationCache",pAgKey)
}

/// Deprecated - see HS.SDA3.Streamlet.ContainerMethods:PurgeAllData
/// @API.Overrideable
/// @Modifier Availability InterSystems
ClassMethod PurgeAllData() As %Status [ CodeMode = expression, Internal ]
{
$classMethod("HS.SDA3.Streamlet.ContainerMethods","PurgeAllData")
}

/// The properties below are used only for the XML parsing methods
Property StreamOref As %Stream.Object(XMLPROJECTION = "NONE") [ Transient ];

Property StreamPos As %Integer(XMLPROJECTION = "NONE") [ Transient ];

Property StreamBuffer As %String(XMLPROJECTION = "NONE") [ Transient ];

Property CollectionTags As %String(XMLPROJECTION = "NONE") [ MultiDimensional, Transient ];

Property SingleTags As %String(XMLPROJECTION = "NONE") [ MultiDimensional, Transient ];

Property CollectionType As %String(XMLPROJECTION = "NONE") [ Transient ];

Property StreamContentType As %String(XMLPROJECTION = "NONE") [ Transient ];

Property Reader As %XML.Reader(XMLPROJECTION = "NONE") [ Transient ];

ClassMethod TestXMLParse() [ Internal ]
{
	Set tSC=$$$OK
FN	R !,"Enter File Name: ",tFileName Quit:tFileName=""  GoTo FN:tFileName["*"
	Set tFile=##Class(%File).%New(tFileName)
	Set tSC=tFile.Open("RU")
	IF $$$ISERR(tSC) { W !,"Error Opening: ",$system.Status.GetErrorText(tSC) Quit  }
	Set tCont=..%New()
	Set tSC=tCont.InitializeXMLParse(tFile) 
	IF $$$ISERR(tSC) { W !,"Error Initializing: ",$system.Status.GetErrorText(tSC) Quit  }
	For  {
		Break //before get next
		Set tGot=tCont.GetNextSDA(.tType,.tSDA,.tSC,.tDate,.tSDAString)
		IF $$$ISERR(tSC) { W !,"Error on Get Next ",$system.Status.GetErrorText(tSC) Quit  }
		Quit:'tGot
		W !,"Got "_tType,!
		Break //after got
	}
	If $$$ISOK(tSC) W !!,"All Done"
}

/// API Method
/// Initializes an SDA3 stream for import.
/// pStreamContentType is always SDA3 - streamlet type is only for possible future use
/// @API.Method
Method InitializeXMLParse(ByRef pStream, pStreamContentType = "SDA3") As %Status
{
	Set pStreamContentType="SDA3",..StreamContentType="SDA3"
	Do pStream.Rewind()
	//XSLT to normalize/sort SDA3, strip white space
	set tStyleSheet = "OrderSDAElements"_$S($$$IsEdgeGW:"Edge",1:"")
	Set tTransform=##class(HS.Util.Transformer).%New("SDA3",tStyleSheet_".xsl")
	Do tTransform.OnInit()
	Set tStream=##class(%GlobalCharacterStream).%New()
	Set tSC=tTransform.Transform(pStream, tStyleSheet, ,.tStream) Quit:$$$ISERR(tSC) tSC
	Set ..StreamOref=tStream,..StreamPos=1
	Do ..StreamOref.Rewind()
	//To allow for a custom container,class,  one needs to set the configuration registry key: \CustomSDA3Container
	//to the name of the container class.  This is needed in order to know about the set of collection properties.
	Set tContainerClass=##class(HS.Registry.Config).GetKeyValue("\CustomSDA3Container","HS.SDA3.Container")
	Set tProp=""
	Set ..CollectionTags("Container")=""
	For {
		Set tProp = $$$comMemberNext(tContainerClass,$$$cCLASSproperty,tProp)
		Quit:tProp=""
		$$$comMemberKeyGetLvar(runtimetype,tContainerClass,$$$cCLASSproperty,tProp,$$$cPROPruntimetype)
		If runtimetype["ListOfObj" {
			Set ..CollectionTags(tProp)=$$$comMemberKeyGet(tContainerClass,$$$cCLASSproperty,tProp,$$$cPROPtype)
			Set ..CollectionTags("/"_tProp)=""
		} Else {
			Set ..SingleTags(tProp)=""
		}
	}
	#Define MAXBUF 3600000
	Set tLen=$$$MAXBUF
	Set ..StreamBuffer= ..StreamOref.Read(.tLen,.tSC) Quit:$$$ISERR(tSC) tSC
	Quit $$$OK
}

/// API Method
/// Gets the next SDA stream.
/// pDate will be the date used when aggregating at an access gateway - if we detect a duplicate, and the facility tier
/// is the same, we use this as a tie-breaker to determine the best record - the "most recent" one is better.
/// This is computed by first looking at UpdatedOn, then if missing, EnteredOn; if missing, then use today
/// pSDAString is deprecated and should no longer be used.  It will fail on any SDA class that contains a blob,
/// since the blob may exceed the string length.
/// @API.Method
Method GetNextSDA(ByRef pType, ByRef pSDA As HS.SDA3.SuperClass, ByRef pStatus, ByRef pDate, ByRef pSDAString) As %Boolean
{
	Set pStatus=$$$OK,pType="",pSDA="",$ZT="Trap"
	Set pStatus=..FillBuffer() Quit:$$$ISERR(pStatus) 0
	For {
		Do PopTag  Quit:tTag="/Container"
		If tTag'?1A.AN,$E(tTag)'="/" {
			Continue:$E(tTag,*)="/"  //empty tag
			If $E(tTag)="?" CONTINUE
			IF $P(tTag," ")?1A.AN {Set tTag=$P(tTag," ")}
			Else {Set pStatus = $$Error^%apiOBJ(5001,"Bad Tag: "_tTag) Quit}
		}
		If $D(..CollectionTags(tTag)) Set ..CollectionType=..CollectionTags(tTag) Continue
		If ..CollectionType="",tTag'="Patient"{
			If '$D(..SingleTags(tTag)) {Set pStatus = $$Error^%apiOBJ(5001,"Bad Tag: "_tTag) Quit}
			Do PopTag Continue //for things like Action, which we want to ignore
		}
		Quit
	}
	Quit:tTag="/Container"||$$$ISERR(pStatus) 0
	Set tClass=$S(tTag="Patient":"HS.SDA3.Patient",1:..CollectionType)
	Set pType=$S($P(tClass,".",1,2)="HS.SDA3":$P(tClass,".",3),1:tClass)
	Set tPos=..StreamPos
	Set pSDA=$ClassMethod(tClass,"%New"),pStatus=pSDA.XMLImportSDAString(..StreamBuffer,tTag,.tPos,,$This)
	Set pSDAString="<"_tTag_">"_$E(..StreamBuffer,..StreamPos,tPos-1)
	Set ..StreamPos=tPos
	If $$$ISOK(pStatus) Set pDate=pSDA.EnteredOn Set:pDate="" pDate=pSDA.UpdatedOn Set:pDate="" pDate=$ZDT($H,3,1)
	Quit $S($$$ISERR(pStatus):0,1:1)
Trap
	Set $ZT="",pStatus=$$$EnsSystemError
	Quit 0

PopTag Set f=$F(..StreamBuffer,">",..StreamPos),tTag=$E(..StreamBuffer,..StreamPos+1,f-2),..StreamPos=f Quit
}

Method FillBuffer(ByRef pStreamBuffer, ByRef pPos = 0) As %Status [ Internal ]
{
	#Define ADDCHUNK 600000
	Set tSC=$$$OK
	Set:pPos ..StreamPos=pPos
	While ..StreamPos>$$$ADDCHUNK&&(..StreamOref.AtEnd=0) {
		Set tLen=$$$ADDCHUNK
		Set tChunk=..StreamOref.Read(.tLen,.tSC) Quit:$$$ISERR(tSC)
		Set ..StreamBuffer=$E(..StreamBuffer,$$$ADDCHUNK+1,*)_tChunk,..StreamPos=..StreamPos-$$$ADDCHUNK
		Set pStreamBuffer=..StreamBuffer, pPos=pPos-$$$ADDCHUNK
	}
	Quit tSC
}

ClassMethod ExportXMLSchema() [ Internal ]
{
FN	R !,"Enter File Name: ",tFileName Quit:tFileName=""  GoTo FN:tFileName["*"
INC	R !,"Include Documentation: Y // ",tDoc Set:tDoc="" tDoc="Y"
	Set tDoc=$ZCVT($E(tDoc),"U") IF tDoc'="Y",tDoc'="N" GoTo INC
	Set tSC=..ExportXMLSchemaAPI(tFileName,tDoc="Y")
	If $$$ISERR(tSC) d $SYSTEM.Status.DisplayError(tSC) GoTo FN
	Write !,"OK"
	Quit
}

/// API Method: Export XML Schema to file 
/// @API.Method
ClassMethod ExportXMLSchemaAPI(pFileName, pIncludeDoc = 0) As %Status
{
	Set tFile=##Class(%File).%New(pFileName), tIO=$IO, tsC=$$$OK
	Do {
		Set tSC= tFile.Open("WSN") Quit:$$$ISERR(tSC)
		Set tSC=tFile.Write("") Quit:$$$ISERR(tSC)
		Use pFileName
		Write "<s:schema xmlns:s=""http://www.w3.org/2001/XMLSchema"">",!
		Set tSchema("documentation")=pIncludeDoc
		Set tSC= ..XMLSchema("","","",0,0,.tSchema) Quit:$$$ISERR(tSC)
		Write !,"</s:schema>"
	} While 0
	Use tIO Quit tSC
}

}
