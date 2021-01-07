Include HS.HC

Class HS.Registry.Document.RegistryPackage Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Property Attributes As array Of %String(MAXLEN = 32000, STORAGEDEFAULT = "array", XMLNAME = "Attributes", XMLPROJECTION = "ELEMENT");

Index AttributesIndex On (Attributes(ELEMENTS), Attributes(KEYS));

Property Documents As list Of HS.Registry.Document(SELECTIVITY = "99%", XMLNAME = "Document", XMLPROJECTION = "ELEMENT");

Relationship Slots As HS.Registry.Document.Slot(SELECTIVITY = ".00067%", XMLNAME = "Slot", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = RegistryPackage ];

Relationship Classifications As HS.Registry.Document.Classification(SELECTIVITY = ".00067%", XMLNAME = "Classification", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = RegistryPackage ];

Property ExternalIdentifiers As list Of HS.Registry.Document.ExternalIdentifier(SELECTIVITY = ".00067%", XMLNAME = "ExternalIdentifier", XMLPROJECTION = "ELEMENT");

Property ContentTypeCode As HS.Types.IHE.XDSb.SerialClassification;

Property PatientIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property SourceIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property UniqueIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

/// Type of registry package value is type
Property Node As HS.Types.IHE.XDSb.SerialExternalIdentifier;

/// For submission sets
Property SubmissionTime As %String;

Property IID As %String(MAXLEN = 256, SELECTIVITY = 1, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property LogicalIID As %String(MAXLEN = 256, SELECTIVITY = ".000001%", XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

Property Version As %Integer;

Property Status As HS.Types.IHE.Status(SELECTIVITY = "99%", XMLNAME = "Status", XMLPROJECTION = "Element") [ InitialExpression = "Submitted" ];

Property Type As %String(DISPLAYLIST = ",Folder,Submission Set", SELECTIVITY = "33%", VALUELIST = ",F,SS") [ InitialExpression = "SS" ];

Property Title As HS.Registry.Document.Type.ValueType(SELECTIVITY = "50%", XMLNAME = "Title", XMLPROJECTION = "ELEMENT");

Property Comments As HS.Registry.Document.Type.ValueType(SELECTIVITY = "7%", XMLNAME = "Comments", XMLPROJECTION = "ELEMENT");

Index IIDIndex On IID [ Unique ];

Index ContentTypeCodeIndex On ContentTypeCode.Code;

Index ContentTypeCodeCodingSchemeIndex On ContentTypeCode.CodingScheme;

Index PatientIdentifierIndex On PatientIdentifier.Value;

Index SourceIdentifierIndex On SourceIdentifier.Value;

Index UniqueIdentifierIndex On UniqueIdentifier.Value;

Index SubmissionTimeIndex On SubmissionTime;

Index LogicalIIDIndex On (LogicalIID, Version);

/*
sql page 126
SubmissionSet	
*/
ClassMethod ItemForIID(pIID As %String) As %String
{
	&sql(select id into :id from RegistryPackage where IID=:pIID)
	Quit $S(SQLCODE:"",1:id)
}

ClassMethod SubmissionSetsForPatient(pID As %String, ByRef pSets As %String, ByRef pQueryParams) As %Status
{
	Set tSC=$$$OK
	Set (tSQLStatus,tCounter,tStatus)=""
	For  {
		Set tCounter=$o(pQueryParams("$XDSSubmissionSetStatus",tCounter)) Quit:tCounter=""
		Set tValue="",tStatus=""
		For  {
			Set tValue=$o(pQueryParams("$XDSSubmissionSetStatus",tCounter,tValue)) Quit:tValue=""
			Set tStatus=tStatus_$S(tStatus="":"",1:",")_"'"_$p(tValue,"StatusType:",2)_"'"
		}
		Set tSQLStatus=tSQLStatus_" AND Status in ("_tStatus_")"
		Kill pQueryParams("$XDSSubmissionSetStatus")
	}
	
	Set tSQL1="select ID from HS_REGISTRY_Document.RegistryPackage where iid in (select RegistryObject from hs_registry_document.externalidentifier where identificationValue=? and IdentificationScheme='urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446')"
	Set tSQL2="select ID from HS_Registry_Document.RegistryPackage where type='SS' and PatientIdentifier_Value=?"
	For tSQL=tSQL1,tSQL2 {
		Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL_tSQLStatus,pID)
		If tRS.SQLCODE Set tSC=$$$ERROR($$$GeneralError,"SQL Erorr code: "_tRS.SQLCODE) Quit
		While tRS.%Next() {
			Set pSets(tRS.%GetData(1))=""
		}
	}
	Quit tSC
}

ClassMethod FoldersForPatient(pID As %String, ByRef pQueryParams, ByRef pSets As %String) As %Status
{
	Set tSC=$$$OK
	Set (tSQLStatus,tCounter,tStatus)=""
	For  {
		Set tCounter=$o(pQueryParams("$XDSFolderStatus",tCounter)) Quit:tCounter=""
		Set tValue="",tStatus=""
		For  {
			Set tValue=$o(pQueryParams("$XDSFolderStatus",tCounter,tValue)) Quit:tValue=""
			Set tStatus=tStatus_$S(tStatus="":"",1:",")_"'"_$p(tValue,"StatusType:",2)_"'"
		}
		Set tSQLStatus=tSQLStatus_" AND Status in ("_tStatus_")"
		Kill pQueryParams("$XDSFolderStatus")
	}
	
	Set tSQL1="select ID from HS_REGISTRY_Document.RegistryPackage where iid in (select RegistryObject from hs_registry_document.externalidentifier where identificationValue=? and IdentificationScheme='urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a')"
	Set tSQL2="select ID from HS_Registry_Document.RegistryPackage where node_value='urn:uuid:d9d542f3-6cc4-48b6-8870-ea235fbc94c2' and PatientIdentifier_Value=?"
	For tSQL=tSQL1,tSQL2 {
		Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL_tSQLStatus,pID)
		If tRS.SQLCODE Set tSC=$$$ERROR($$$GeneralError,"SQL Erorr code: "_tRS.SQLCODE) Quit
		While tRS.%Next() {
			Set pSets(tRS.%GetData(1))=""
		}
	}
	Quit tSC
}

ClassMethod ItemForUniqueID(pID As %String, pType = "SS") As %String
{
	#; look in the RegistryPackage for the UniqueID value, if not found, look in the externalidentifiers
	Set tRS=##class(%SQL.Statement).%ExecDirect(,"select ID from HS_Registry_Document.RegistryPackage where Type=? and UniqueIdentifier_Value=?",pType,pID)
	If tRS.%Next() Quit tRS.%GetData(1)
	
	Set tScheme = $S(pType="SS":"urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8",pType="F":"urn:uuid:75df8f67-9973-4fbe-a900-df66cefecc5a",1:"")
	Set tRS=##class(%SQL.Statement).%ExecDirect(,"select ID INTO :tID from HS_Registry_Document.RegistryPackage where Type=? and iid in (select registryobject from HS_Registry_Document.externalidentifier where identificationscheme=? and identificationvalue=?)",pType,tScheme,pID)
	If tRS.%Next() Quit tRS.%GetData(1)
	Quit ""
}

ClassMethod ItemForEntryID(pID As %String, pType = "SS") As %String
{
	&sql(select id into :tID from registryPackage where Type=:pType and IID=:pID)
	Quit $S(SQLCODE:"",1:tID)
}

ClassMethod ItemsForLogicalID(pID As %String, pType = "F", Output pAry) As %Status
{
	&sql(DECLARE LogicalIDS CURSOR FOR select id into :tID from registryPackage where Type=:pType and LogicalIID=:pID)
	&sql(OPEN LogicalIDS)
	For  {
		&SQL(FETCH LogicalIDS)
		Quit:SQLCODE
		Set pAry(ID)=""
	}
	&sql(CLOSE LogicalIDS)
	Quit $$$OK
}

Method PatientIDForObject() As %String
{
	If ..PatientIdentifier.Value]"" Quit ..PatientIdentifier.Value
	Set tScheme = $S(..Type="SS":"urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446",1:"urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a")
	Set tUniqueID=""
	For tIdx=1:1:..ExternalIdentifiers.Count() {
		Set tExtIdent = ..ExternalIdentifiers.GetAt(tIdx)
		If tExtIdent.IdentificationScheme=tScheme Set tUniqueID=tExtIdent.IdentificationValue Quit
	}
	Quit tUniqueID
}

Method LastUpdateTime() As %String
{
	try {
		Set tLastUpdateTime=""
		For tIdxF=1:1:..Slots.Count() {
			Set tSlot=..Slots.GetAt(tIdxF)
			If tSlot.Name="lastUpdateTime" Set tLastUpdateTime=tSlot
		}
	} catch eException {
		Throw eException
	}
	Quit tLastUpdateTime
}

Method UpdateTime() As %Status
{
	Quit:..Type'="F" $$$ERROR($$$GeneralError,"Not a Folder")
	Set tLastUpdateTime=""
	For tIdxF=1:1:..Slots.Count() {
		Set tSlot=..Slots.GetAt(tIdxF)
		If tSlot.Name="lastUpdateTime" Set tLastUpdateTime=tSlot Quit
	}
	If tLastUpdateTime="" {
		Set tLastUpdateTime=##class(HS.Registry.Document.Slot).%New()
		Set tLastUpdateTime.Name="lastUpdateTime"
		//UTC time - see IHE spec Vol 3 table 4.2.3.1.7-2, DTM data type
		Set tTM=$tr($zdt($zts,8)," :")
		Do tLastUpdateTime.ValueList.InsertAt(tTM,1)
		Do ..Slots.Insert(tLastUpdateTime)
	}
	Quit $$$OK
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ ServerOnly = 1 ]
{
	try {
		Set obj=..%Open(oid,4,.tSC) $$$HSThrowErrors(tSC)
		tstart
		For tIdx=obj.Slots.Count():-1:1 {
			Set tSlot = obj.Slots.GetAt(tIdx)
			Set tSC = tSlot.%DeleteId(tSlot.%Id()) $$$HSThrowErrors(tSC)
		}

		For tIdx=obj.Classifications.Count():-1:1 {
			Set tClassification = obj.Classifications.GetAt(tIdx)
			Set tSC=tClassification.%DeleteId(tClassification.%Id()) $$$HSThrowErrors(tSC)
		}

		For tIdx=obj.ExternalIdentifiers.Count():-1:1 {
			Set tEI = obj.ExternalIdentifiers.GetAt(tIdx)
			Set tSC=tEI.%DeleteId(tEI.%Id()) $$$HSThrowErrors(tSC)
		}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		trollback
	} Else {
		tcommit
	}
	Quit tSC
}

Method SlotValueForObject(pSlotName = "") As %String
{
	#; new storage for single value slots
	If pSlotName="submissionTime" {Quit:..SubmissionTime]"" ..SubmissionTime}

	Set tRS=##class(%SQL.Statement).%ExecDirect(,"select valuelist from hs_registry_document.slot_valuelist where slot->name=? and slot->registrypackage=?",pSlotName,..%Id())
	Do tRS.%Next()
	Set tString=tRS.%GetData(1)
	Quit tString
}

ClassMethod ObjectForIIDOfHighestVersion(pIID As %String, Output pFolder) As %Status
{
	try {
		Set tSC=$$$OK
		Set pFolder = ..IIDIndexOpen(pIID)
		Quit:'$IsObject(pFolder)
		&SQL(select ID into :tID from HS_Registry_Document.RegistryPackage where LogicalIID=:pFolder.LogicalIID and Type='F' order by Version desc)
		IF SQLCODE Set tSC=$$$ERROR($$$GeneralError,"Couldn't find folder version") Quit
		If tID'=pFolder.%Id() Set tSC=$$$ERROR($$$GeneralError,"Folder is not highest version") Quit
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="Comments">
<Attribute>Comments</Attribute>
<Structure>subnode</Structure>
<Subscript>"Comments"</Subscript>
</Data>
<Data name="RegistryPackageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Documents</Value>
</Value>
<Value name="3">
<Value>ExternalIdentifiers</Value>
</Value>
<Value name="4">
<Value>IID</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>ContentTypeCode</Value>
</Value>
<Value name="8">
<Value>PatientIdentifier</Value>
</Value>
<Value name="9">
<Value>SourceIdentifier</Value>
</Value>
<Value name="10">
<Value>SubmissionTime</Value>
</Value>
<Value name="11">
<Value>UniqueIdentifier</Value>
</Value>
<Value name="12">
<Value>Node</Value>
</Value>
<Value name="14">
<Value>Title</Value>
</Value>
<Value name="15">
<Value>LogicalIID</Value>
</Value>
<Value name="16">
<Value>Version</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.DocRegistryPackD</DataLocation>
<DefaultData>RegistryPackageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.DocRegistryPackD</IdLocation>
<IndexLocation>^HS.Registry.DocRegistryPackI</IndexLocation>
<StreamLocation>^HS.Registry.DocRegistryPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
