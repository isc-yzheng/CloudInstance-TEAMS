Include (HS.IHE.ATNA, HS.HC.Invoke)

/// Internal coding of ATNA/Auditing implementation
Class HS.IHE.ATNA.Repository.Aggregation Extends (%Persistent, HS.Types.AuditAggregateInfo, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// Track updates for DeepSee
Parameter DSTIME As STRING = "AUTO";

Parameter DSINTERVAL = 1;

Parameter XMLIGNORENULL = "inputonly";

// Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 0;

/// The EventDateTime is stored as UTC time.  This calculated property converts this to the local date-time, for reporting convenience
Property LocalDateTime As %TimeStamp [ Calculated, SqlComputeCode = { Set {LocalDateTime} = $zdt($zdth({EventDateTime},3,7),3) }, SqlComputed ];

/// The EventDateTime is stored as UTC time.  This calculated property converts this to the local date, for reporting convenience
/// Use this for date based queries.
Property IndexedDate As %TimeStamp [ Calculated, SqlComputeCode = { Set {IndexedDate} = $zdate($zdth({EventDateTime},3,7),3) }, SqlComputed ];

/// New property introduced in hscore 13 to enable capturing and storing the thing we're using for PrimaryFacility at save time
/// This is only input if HS.IHE.ATNA.Repository.Data.AuditMessage gets it from SAMLData's Organization
/// Since we're not running a data conversion, this will only exist for newly saved entries
/// We'll also use this to store the facility for facility consent policies
Property FacilityInternal As %String(MAXLEN = 220) [ Internal ];

/// Computed property - the clinician's (user's) primary facility
/// If we have stored the FacilityInternal, we'll use that, otherwise compute it when referenced
Property PrimaryFacility As %String [ Calculated, SqlComputeCode = { Set {PrimaryFacility} = $S({FacilityInternal}="":##Class(HS.IHE.ATNA.Repository.Aggregation).GetPrimFac({UserName}),1:{FacilityInternal})}, SqlComputed ];

ClassMethod GetPrimFac(pUserName) [ Internal ]
{
	Set tFac=""
	$$$HCInvoke(tSC,$$$OK,"GetPrimFac",pUserName,.tFac)
	Quit tFac
}

/// Computed property - the patient's facility (for events that record a single MRN)
Property PatientFacility As %String [ Calculated, SqlComputeCode = { Set {PatientFacility} = $S($LL({MRNs})=1:$P($LIST({MRNs}),"^",1),1:"")}, SqlComputed ];

Property MPILIST As %String(MAXLEN = "") [ Calculated, SqlComputeCode = { Set {MPILIST} =  $LTS({MPIIDs},", ") }, SqlComputed ];

Property MRNLIST As %String(MAXLEN = "") [ Calculated, SqlComputeCode = { Set {MRNLIST} =  $LTS({MRNs},", ") }, SqlComputed ];

Property EventCodes As %String(MAXLEN = "") [ Calculated, SqlComputeCode = { Set {EventCodes} = "Code: "_$Replace($S({EventInfo}="":##Class(HS.IHE.ATNA.Repository.AggregationToAuditMessage).GetEventInfo({EventType}),1:{EventInfo}),"^"," --- ID: ")}, SqlComputed ];

Relationship Patients As HS.IHE.ATNA.Repository.Patient [ Cardinality = children, Inverse = AggregationID ];

Relationship Documents As HS.IHE.ATNA.Repository.Document [ Cardinality = children, Inverse = AggregationID ];

Relationship CustomPairs As HS.IHE.ATNA.Repository.CustomPair [ Cardinality = children, Inverse = AggregationID ];

Index EventType On EventType;

Index EventSubType On EventSubType;

Index EventDateTime On EventDateTime;

Index UserName On UserName;

Index ProxyUserName On ProxyUserName;

Index InitiatingLogId On InitiatingLogId;

Index RecordedLogId On RecordedLogId;

Index EnsembleSessionId On EnsembleSessionId;

Index ATNAAuditMessageId On ATNAAuditMessageId;

Index LocalDateTime On (LocalDateTime, EventType);

Index IndexDateEvent On (IndexedDate, EventType) [ Type = bitmap ];

Index IndexDate On IndexedDate [ Type = bitmap ];

Index Providers On ProviderId;

/// API Method. Utility helper method to create and initialize a new event
ClassMethod Create(pEvent As %String, ByRef pInitiatingLogID, pAccessGateway As %String = "", pActionCode As %String = "") As Aggregation
{
	Set tAggregation=..%New()
	Do tAggregation.Initialize(pEvent, .pInitiatingLogID, pAccessGateway, pActionCode)
	Quit tAggregation
}

/// API Method. Utility method to insert default values after creating a new one
Method Initialize(pEvent As %String, ByRef pInitiatingLogID, pAccessGateway As %String = "", pActionCode As %String = "E")
{
	Set ..EventType=pEvent
	Set ..ActionCode=pActionCode, ..Outcome=0
	Set ..UserName=$UserName, ..Roles=$Roles
	Set ..EventDateTime=$ZDT($ZDT($H,-3),3) //converts to UTC time
	Set ..RecordedAt=$ZU(131,1)_":"_$Namespace
	If $G(pInitiatingLogID)="",pAccessGateway'="" {
		Set ..InitiatedAt=pAccessGateway
	} ElseIf $G(pInitiatingLogID)'="" {
		Set ..InitiatedAt=$P(pInitiatingLogID,":",1,3)
	} Else {
		Set ..InitiatedAt=..RecordedAt
	}
	Set ..SourceNetworkAccess=$P(..InitiatedAt,":")
	Set:$G(pInitiatingLogID)="" pInitiatingLogID=##Class(%ZHSLIB.Audit.Log).NewInitiatingLog()
	Set ..InitiatingLogId=pInitiatingLogID
	Quit
}

/// API Method. Utility Helper method to set user info
Method SetUser(pRequest As HS.Types.RequestInfo)
{
	Set ..UserName=pRequest.RequestingUser,..Roles=pRequest.RequestingUserRoles
	Set ..ProxyUserName=pRequest.RequestingForProxyUserID
	Set tKey=""
	For {
		Set tVal=pRequest.CustomAuditInfo.GetNext(.tKey)
		Quit:tKey=""
		Set tPair=##class(HS.IHE.ATNA.Repository.CustomPair).%New()
		Set tPair.Name=tKey, tPair.Value=tVal
		Do ..CustomPairs.Insert(tPair)
	}
	Quit
}

/// API Method. Utility method to add a list of MPIIDs and MRNs (all for the same patient name) to an event
Method AddPatientList(pMPIIDList, pMRNList, pName As %String = "")
{
	For tI=1:1:$LL(pMPIIDList) {
		Set tMPIID=$LG(pMPIIDList,tI)
		Continue:$D(tMPIIDs(tMPIID))  //avoid redundant logging of MPIIDs, where we have multiple MRNs for the same one
		Set tMPIIDs(tMPIID)=""
		Do ..AddPatient(tMPIID,"MPIID",pName)
	}
	For tI=1:1:$LL(pMRNList) {
		Do ..AddPatient($LG(pMRNList,tI),"MRN",pName)
	}
}

/// API Method. Utility Method to add a patient to an event
Method AddPatient(pIdentifier As %String, pIdentifierType As %String, pPatientName As %String = "", pRequestId As %String = "")
{
	Set tPat=##Class(HS.IHE.ATNA.Repository.Patient).%New()
	Set tPat.Identifier=pIdentifier, tPat.IdentifierType=pIdentifierType
	Set tPat.PatientName=pPatientName, tPat.RequestId=pRequestId
	Do ..Patients.Insert(tPat)
	Set:..PatientName="" ..PatientName=pPatientName
	Quit
}

Method AddXDSbDocument(pDocumentID As %String, pRepositoryID As %String, pHomeCommunityID As %String) [ Internal ]
{
	Set tDoc=##class(HS.IHE.ATNA.Repository.Document).%New()
	Set tDoc.DocumentID=pDocumentID, tDoc.RepositoryID=pRepositoryID,tDoc.HomeCommunityID=pHomeCommunityID
	Do ..Documents.Insert(tDoc)
	Set:..DocumentId="" ..DocumentId="XDSb/"_pHomeCommunityID_"/"_pRepositoryID_"/"_pDocumentID
}

ClassMethod ListEventTypes() As HS.Reports.XMLMessageContainer [ Internal ]
{
	Set tList=##Class(HS.Reports.XMLMessageContainer).%New()
	Set tList.Status=$$$OK
	Set tSQL="select distinct EventType from HS_IHE_ATNA_Repository.Aggregation Order By EventType"
	Set tRS=##class(%ResultSet.SQL).%Prepare(tSQL,.tSC)
	If '$isObject(tRS) Set tList.Status=tSC quit tList
	While tRS.%Next()  {
		DO tList.StringCollection.Insert(tRS.%Get("EventType"))
	}
	Quit tList
}

/// Can be invoked from any HealthShare namespace
/// Either pAggregation or pXML will be passed in, but not both
ClassMethod RecordAudit(pAggregation As Aggregation = "", pXML As %String = "") As %Status [ Internal ]
{
	Try {
		Set tSC=$$$OK
		If $$$IsRunningAuditInstance(tDB) {
			If '$IsObject(pAggregation) {
				Set tReader = ##class(%XML.Reader).%New()
				Do tReader.OpenString(pXML)
				Do tReader.Correlate("Aggregation","HS.IHE.ATNA.Repository.Aggregation")
				Set tGot= tReader.Next(.pAggregation,.tSC)
				Quit:$$$ISERR(tSC)  Quit:'tGot
			}
			Set tSC=..StoreAudit(pAggregation)
		} Else {
			If $IsObject(pAggregation) {
				// check for excluded events
				If $IsObject(##class(HS.IHE.ATNA.Repository.Exclusion).%OpenId($zcvt(pAggregation.EventType,"U"))) Quit
				//export to xml
				Set pXML="",tSC=pAggregation.XMLExportToString(.pXML,"Aggregation") Quit:$$$ISERR(tSC)
			}
			Set ^HS.AuditQueue($I(^HS.AuditQueue("C")))=pXML
		}
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

ClassMethod StoreAudit(pAggregation As Aggregation) As %Status [ Internal ]
{
	//Check for excluded event types before saving
	If $IsObject(##class(HS.IHE.ATNA.Repository.Exclusion).%OpenId($zcvt(pAggregation.EventType,"U"))) Quit $$$OK
	Do ..PreSave(.pAggregation)
	Set tSC=##class(%ZHSLIB.Audit.Log).SaveIHE(pAggregation) Quit:$$$ISERR(tSC) tSC
	Set ^HS.AuditAlertQueue(pAggregation.%Id())=""
	Quit $$$OK
}

ClassMethod PreSave(ByRef pAggregation As Aggregation) [ Internal ]
{
	#dim tPat As Patient
	Do pAggregation.MPIIDs.Clear(),pAggregation.MRNs.Clear()
	For tI=1:1:pAggregation.Patients.Count() {
		Set tPat=pAggregation.Patients.GetAt(tI)
		If tPat.PatientName'="",pAggregation.PatientName="" Set pAggregation.PatientName=tPat.PatientName
		Continue:tPat.Identifier=""
		If tPat.IdentifierType="MPIID" {
			Do pAggregation.MPIIDs.Insert(tPat.Identifier)
		} Else {
			Do pAggregation.MRNs.Insert(tPat.Identifier)
		}
	}
	If pAggregation.FacilityInternal="",pAggregation.UserName'="" {
		 Set pAggregation.FacilityInternal=..GetPrimFac(pAggregation.UserName)
	}
	
	If pAggregation.DocumentId="",pAggregation.Documents.Count() {
		Set pAggregation.DocumentId=pAggregation.Documents.GetAt(1).DocumentID
	}
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="AggregationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventType</Value>
</Value>
<Value name="3">
<Value>EventDateTime</Value>
</Value>
<Value name="4">
<Value>UserName</Value>
</Value>
<Value name="5">
<Value>Roles</Value>
</Value>
<Value name="6">
<Value>InitiatingLogId</Value>
</Value>
<Value name="7">
<Value>InitiatedAt</Value>
</Value>
<Value name="8">
<Value>RecordedLogId</Value>
</Value>
<Value name="9">
<Value>RecordedAt</Value>
</Value>
<Value name="10">
<Value>EnsembleSessionId</Value>
</Value>
<Value name="11">
<Value>ATNAAuditMessageId</Value>
</Value>
<Value name="12">
<Value>MPIIDs</Value>
</Value>
<Value name="13">
<Value>MRNs</Value>
</Value>
<Value name="14">
<Value>Criteria</Value>
</Value>
<Value name="15">
<Value>DocumentId</Value>
</Value>
<Value name="16">
<Value>LocalDateTime</Value>
</Value>
<Value name="17">
<Value>ProxyUserName</Value>
</Value>
<Value name="18">
<Value>PatientName</Value>
</Value>
<Value name="19">
<Value>SourceURI</Value>
</Value>
<Value name="20">
<Value>DestinationURI</Value>
</Value>
<Value name="21">
<Value>ProviderName</Value>
</Value>
<Value name="22">
<Value>ProviderId</Value>
</Value>
<Value name="23">
<Value>EventSubType</Value>
</Value>
<Value name="24">
<Value>FacilityInternal</Value>
</Value>
<Value name="25">
<Value>ActionCode</Value>
</Value>
<Value name="26">
<Value>Outcome</Value>
</Value>
<Value name="27">
<Value>SourceNetworkAccess</Value>
</Value>
<Value name="28">
<Value>DestinationNetworkAccess</Value>
</Value>
<Value name="29">
<Value>UserFullName</Value>
</Value>
<Value name="30">
<Value>AuditSourceID</Value>
</Value>
<Value name="31">
<Value>SubmissionSetUniqueID</Value>
</Value>
<Value name="32">
<Value>QueryRequestID</Value>
</Value>
<Value name="33">
<Value>ATNAMessage</Value>
</Value>
<Value name="34">
<Value>Documents</Value>
</Value>
<Value name="35">
<Value>IsSource</Value>
</Value>
<Value name="36">
<Value>EventInfo</Value>
</Value>
<Value name="37">
<Value>ATNAMessageType</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.Audit("AggregationD")</DataLocation>
<DefaultData>AggregationDefaultData</DefaultData>
<ExtentSize>100000000</ExtentSize>
<IdLocation>^HS.IHE.Audit("AggregationD")</IdLocation>
<IndexLocation>^HS.IHE.Audit("AggregationI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("AggregationS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
