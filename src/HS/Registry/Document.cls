Include HS.HC

/// 
Class HS.Registry.Document Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = 1;

Parameter DSTIME = "AUTO";

Parameter DSINTERVAL = 5;

Parameter DOMAIN = "HS";

Property Attributes As array Of %String(MAXLEN = 32000, STORAGEDEFAULT = "array", XMLNAME = "Attributes", XMLPROJECTION = "ELEMENT");

Index AttributesIndex On (Attributes(ELEMENTS), Attributes(KEYS));

/// known as id in the provide and register / register
Property IID As %String(MAXLEN = 256, SELECTIVITY = 1, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property LogicalIID As %String(MAXLEN = 256, SELECTIVITY = ".000001%", XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

Property Version As %Integer;

/// 1 - online, 0 - Offline 
Property Availability As %String(DISPLAYLIST = ",urn:ihe:iti:2010:DocumentAvailability:Offline,urn:ihe:iti:2010:DocumentAvailability:Online", VALUELIST = ",0,1", XMLLISTPARAMETER = "DISPLAYLIST") [ InitialExpression = 1 ];

Property ClassCode As HS.Types.IHE.XDSb.SerialClassification(SELECTIVITY = "20%");

Property FormatCode As HS.Types.IHE.XDSb.SerialClassification(SELECTIVITY = "20%");

Property HealthCareFacilityTypeCode As HS.Types.IHE.XDSb.SerialClassification(SELECTIVITY = "20%");

Property PracticeSettingCode As HS.Types.IHE.XDSb.SerialClassification(SELECTIVITY = "20%");

Property TypeCode As HS.Types.IHE.XDSb.SerialClassification(SELECTIVITY = "20%");

Property PatientIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier(SELECTIVITY = ".0001%");

Property DocumentUniqueIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier(SELECTIVITY = 1);

/// SourceIdentifier is from the submission set, carried forward to the document
Property SourceIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier(SELECTIVITY = ".01%");

Index PatientIdentifierIndex On PatientIdentifier.Value;

Index DocumentUniqueIdentifierIndex On DocumentUniqueIdentifier.Value;

Index SourceIdentifierIndex On SourceIdentifier.Value;

Index ClassCodeIndex On ClassCode.Code [ Type = bitmap ];

Index ClassCodeCodingSchemeIndex On ClassCode.CodingScheme [ Type = bitmap ];

Index FormatCodeIndex On FormatCode.Code [ Type = bitmap ];

Index FormatCodeCodingSchemeIndex On FormatCode.CodingScheme [ Type = bitmap ];

Index HealthCareFacilityTypeCodeIndex On HealthCareFacilityTypeCode.Code [ Type = bitmap ];

Index HealthCareFacilityTypeCodeCodingSchemeIndex On HealthCareFacilityTypeCode.CodingScheme [ Type = bitmap ];

Index PracticeSettingCodeIndex On PracticeSettingCode.Code [ Type = bitmap ];

Index PracticeSettingCodeCodingSchemeIndex On PracticeSettingCode.CodingScheme [ Type = bitmap ];

Index TypeCodeIndex On TypeCode.Code [ Type = bitmap ];

Index TypeCodeCodingSchemeIndex On TypeCode.CodingScheme [ Type = bitmap ];

Property Title As HS.Registry.Document.Type.ValueType(SELECTIVITY = "50%", XMLNAME = "Title", XMLPROJECTION = "ELEMENT");

Property Comments As HS.Registry.Document.Type.ValueType(SELECTIVITY = "7%", XMLNAME = "Comments", XMLPROJECTION = "ELEMENT");

Property Name As list Of HS.Registry.Document.Type.ValueType(SELECTIVITY = "50%", STORAGEDEFAULT = "array", XMLNAME = "Name", XMLPROJECTION = "ELEMENT");

Property Description As list Of HS.Registry.Document.Type.ValueType(SELECTIVITY = "7%", XMLNAME = "Description", XMLPROJECTION = "ELEMENT");

/// Deprecated, use PatientIdentifier_Value
Property PatientID As %String(MAXLEN = 255, SELECTIVITY = 1);

/// This callback method is invoked when the current object is added to the SaveSet,
/// either because %Save() was invoked on this object or on an object that references this object.
/// %OnAddToSaveSet can modify the current object. It can also add other objects to the current
/// SaveSet by invoking %AddToSaveSet or remove objects by calling %RemoveFromSaveSet.
/// 
/// <P>If this method returns an error status then %Save() will fail and the transaction
/// will be rolled back.
Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Private, ServerOnly = 1 ]
{
	Set ..LastUpdateTimeInternal=$tr($zdt($H,8)," :")
	Quit $$$OK
}

/// Deprecated, use DocumentUniqueIdentifier.Value
Property DocumentID As %String(MAXLEN = 128, SELECTIVITY = 1);

Property MimeType As %String(SELECTIVITY = "99.9%");

Property ObjectType As %String(SELECTIVITY = "50%");

Property Status As HS.Types.IHE.Status(SELECTIVITY = "99.9%", XMLNAME = "Status", XMLPROJECTION = "Element") [ InitialExpression = "Submitted" ];

Property ExternalIdentifiers As list Of HS.Registry.Document.ExternalIdentifier(SELECTIVITY = 1, XMLNAME = "ExternalIdentifier", XMLPROJECTION = "ELEMENT");

Property Size As %String;

Property Hash As %String;

Property ServiceStartTime As %String;

Property ServiceStopTime As %String;

Property SubmissionTime As %String;

Property RepositoryUniqueID As %String;

Property SourcePatientID As %String(MAXLEN = 255);

Property CreationTime As %String;

/// since creationtime is not always accurate
Property CreationTimeInternal As %String [ InitialExpression = {$tr($zdt($H,8)," :")} ];

/// last time document was updated
Property LastUpdateTimeInternal As %String;

Property LanguageCode As %String;

Index DocumentIDIndex On DocumentID;

Index IIDIndex On IID [ Unique ];

Index LogicalIIDIndex On (LogicalIID, Version);

Index PatientIDIndex On PatientID;

Index SubmissionTimeIndex On SubmissionTime;

Index ServiceStartTimeIndex On ServiceStartTime;

Index ServiceStopTimeIndex On ServiceStopTime;

Index CreationTimeIndex On CreationTime;

Index CreationTimeInternalIndex On CreationTimeInternal;

Index RepositoryUniqueIDIndex On RepositoryUniqueID [ Type = bitmap ];

Index LastUpdateTimeInternalIndex On LastUpdateTimeInternal;

Relationship Slots As HS.Registry.Document.Slot(XMLNAME = "Slot", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = Document ];

Relationship Classifications As HS.Registry.Document.Classification(XMLNAME = "Classification", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = Document ];

ClassMethod DocumentForUniqueID(pID As %String, ByRef pAry, pOnlyApproved As %Boolean = 0, pMaxCount = 0) As %Status
{
	Set tSQLStatus=" And Status='Approved'"
	Set tSQL1="Select ID from HS_Registry.Document where DocumentUniqueIdentifier_Value =?"
	Set tSQL2="select ID from HS_registry.document where iid in (select registryobject from HS_Registry_Document.externalidentifier where identificationscheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab' and identificationvalue=?)"
	Set tCount=0
	For tSQL=tSQL1,tSQL2 {
		Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL_$S(pOnlyApproved:tSQLStatus,1:""),pID)
		If tRS.SQLCODE Set tSC=$$$ERROR($$$GeneralError,"SQL Erorr code: "_tRS.SQLCODE) Quit
		While tRS.%Next() {
			Set pAry(tRS.%GetData(1))=""
			If pMaxCount {
				Set tCount=tCount+1
				Quit:tCount>=pMaxCount
			}
		}
	}
	Quit $$$OK
}

Method UniqueIDForObject() As %String
{
	If ..DocumentUniqueIdentifier.Value]"" Quit ..DocumentUniqueIdentifier.Value
	Set tUniqueID=""
	For tIdx=1:1:..ExternalIdentifiers.Count() {
		Set tExtIdent = ..ExternalIdentifiers.GetAt(tIdx)
		If tExtIdent.IdentificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" Set tUniqueID=tExtIdent.IdentificationValue Quit
	}
	Quit tUniqueID
}

Method PatientIDForObject() As %String
{
	If ..PatientIdentifier.Value]"" Quit ..PatientIdentifier.Value
	Set tUniqueID=""
	For tIdx=1:1:..ExternalIdentifiers.Count() {
		Set tExtIdent = ..ExternalIdentifiers.GetAt(tIdx)
		If tExtIdent.IdentificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427" Set tUniqueID=tExtIdent.IdentificationValue Quit
	}
	Quit tUniqueID
}

ClassMethod DocumentForEntryID(pID As %String) As %String
{
	Set tRS=##class(%SQL.Statement).%ExecDirect(,"select ID from HS_registry.document where iid=?",pID)
	If tRS.SQLCODE && (tRS.SQLCODE'=100) Set tSC=$$$ERROR($$$GeneralError,"SQL Erorr code: "_tRS.SQLCODE) Quit ""
	Do tRS.%Next() 
	Quit tRS.%GetData(1)
}

ClassMethod DocumentsForLogicalID(pID As %String, Output pAry) As %Status
{
	Set tRS=##class(%SQL.Statement).%ExecDirect(,"select ID from HS_registry.document where Logicaliid=?",pID)
	If tRS.SQLCODE && (tRS.SQLCODE'=100) Set tSC=$$$ERROR($$$GeneralError,"SQL Erorr code: "_tRS.SQLCODE) Quit $$$OK
	While tRS.%Next() {
		Set pAry(tRS.%GetData(1))=""
	}
	Quit $$$OK
}

ClassMethod ObjectForIID(pIID As %String) As Document
{
	Set (SQLCODE,id)=""
	&sql(select ID into :id from hs_registry.Document where iid=:pIID)
	Quit $S(SQLCODE:"",1:..%OpenId(id))
}

ClassMethod HashForIID(pIID As %String) As %String
{
	Try {
		Set tHash=""
		Set tDocument=..ObjectForIID(pIID)
		If '$IsObject(tDocument) $$$HSThrowErrors($$$ERROR($$$GeneralError,"Document not found for ID: "_pIID))
		Set tHash= tDocument.SlotValueForObject("hash")
	} catch eException {
		Throw eException
	}
	Quit tHash
}

Method SlotValueForObject(pSlotName = "") As %String
{
	#; new storage for single value slots
	If pSlotName="creationTime" {Quit:..CreationTime]"" ..CreationTime}
	ElseIf pSlotName="repositoryUniqueId" {Quit:..RepositoryUniqueID]"" ..RepositoryUniqueID}
	ElseIf pSlotName="serviceStartTime" {Quit:..ServiceStartTime]"" ..ServiceStartTime}
	ElseIf pSlotName="serviceStopTime" {Quit:..ServiceStopTime ..ServiceStopTime}
	ElseIf pSlotName="hash" {Quit:..Hash]"" ..Hash}
	ElseIf pSlotName="size" {Quit:..Size]"" ..Size}
	ElseIf pSlotName="submissionTime" {Quit:..SubmissionTime]"" ..SubmissionTime}
	ElseIf pSlotName="sourcePatientId" {Quit:..SourcePatientID]"" ..SourcePatientID}
	ElseIf pSlotName="languageCode" {Quit:..LanguageCode]"" ..LanguageCode}
	
	Set tValue=""
	try {
		For tIdx=1:1:..Slots.Count() {
			Set tSlot=..Slots.GetAt(tIdx)
			If tSlot.Name'=pSlotName Continue
			Set tValue=tSlot.ValueList.GetAt(1)
			Quit
		}
	} catch eException {
		Throw eException
	}
	Quit tValue
}

/// *** Deprecated ***
/// find registryObject references from ExternalIdentifier where patient id = pID 
ClassMethod DocumentsForPatient(pID As %String, ByRef pDocuments As %String) As %Status
{
	Set tSC=$$$OK
	Set tRS=##class(%ResultSet).%New()
	Set tSC=tRS.Prepare("select registryObject from hs_registry_document.externalidentifier where identificationscheme='urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427' and identificationvalue=?") $$$HSThrowErrors(tSC)
	Set tSC=tRS.Execute(pID) $$$HSThrowErrors(tSC)
	While tRS.%Next() {
		Set pDocuments(tRS.GetData(1))=""
	}
	Set tRS=##class(%SQL.Statement).%ExecDirect(,"select IID from hs_registry.document where patientidentifier_Value=?",pID)
	While tRS.%Next() {
		Set pDocuments(tRS.%GetData(1))=""
	}
	Quit tSC
}

/// Find document ids for Patient
ClassMethod DocumentIDsForPatient(pID As %String, ByRef pDocuments As %String, ByRef pQueryParams, ByRef pIIDs As %String, %pTempGbl As %String = "", pRemoveParams As %Boolean = 1) As %Status
{
	Set tSC=$$$OK
	Set (pDocuments,pIIDs,tSQL,tCounter)=""
	Set tParams = 0
	Set tParams($I(tParams)) = pID
	For  {
		Set tCounter=$o(pQueryParams("$XDSDocumentEntryStatus",tCounter)) Quit:tCounter=""
		Set tValue="",tStatus="", tStatusString = ""
		For  {
			Set tValue=$o(pQueryParams("$XDSDocumentEntryStatus",tCounter,tValue)) Quit:tValue=""
			Set tParams($I(tParams)) = $p(tValue,"StatusType:",2)
			Set tStatusString = tStatusString_$S(tStatusString="":"",1:",")_"?"
		}
		Set tSQL=tSQL_" AND Status in ("_tStatusString_")"
	}

	Set tCounter="", tTypeString = ""
	For  {
		Set tCounter=$o(pQueryParams("$XDSDocumentEntryType",tCounter)) Quit:tCounter=""
		Set tValue="",tType=""
		For  {
			Set tValue=$o(pQueryParams("$XDSDocumentEntryType",tCounter,tValue)) Quit:tValue=""
			Set tParams($I(tParams)) = tValue
			Set tTypeString = tTypeString_$S(tTypeString="":"",1:",")_"?"
		}
		Set tSQL=tSQL_" AND ObjectType in ("_tTypeString_")"
	}


	Set tStatement=##class(%SQL.Statement).%New()
	Set tSQL="select ID,IID from hs_registry.document where patientid=?"_tSQL
	Set tSC=tStatement.%Prepare(tSQL) $$$HSThrowErrors(tSC)
	Set tRS=tStatement.%Execute(tParams...) $$$HSThrowErrors(tSC)
	While tRS.%Next() {
		Set $li(pDocuments,$ll(pDocuments)+1)=tRS.%GetData(1)
		Set $li(pIIDs,$ll(pIIDs)+1)=tRS.%GetData(2)
		Set:%pTempGbl]"" @%pTempGbl@(tRS.%GetData(1))=tRS.%GetData(2)
	}
	If pRemoveParams For tParam="$XDSDocumentEntryPatientId","$XDSDocumentEntryType","$XDSDocumentEntryStatus" Kill pQueryParams(tParam)

	Quit tSC
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ ServerOnly = 1 ]
{
	try {
		Set tSC = $$$OK
		Set obj=..%Open(oid,4,.tSC) $$$HSThrowErrors(tSC)
		Set tDocID=obj.%Id()
		Set tDocIID=obj.IID
		Set tPatientID = obj.PatientIDForObject()
		tstart
		Set tRS = ##class(%ResultSet.SQL).%Prepare("select count(*) as RowCount from hs_registry_document.association where sourceobject=?",.tER,"",tDocIID)
		IF $isObject(tER) Set tSC = tER.Status Quit
		Do tRS.%Next() If tRS.RowCount Set tSC = $$$ERROR($$$GeneralError,"Document has other documents referencing it by association") Quit
		#; 
		Set tRS = ##class(%ResultSet.SQL).%Prepare("select count(*) as RowCount from hs_registry_document.association where sourceobject in (select sourceobject from hs_registry_document.association where targetobject=?) and targetobject<>? ",.tER,"",tDocIID,tDocIID)
		IF $isObject(tER) Set tSC = tER.Status Quit
		Do tRS.%Next() If tRS.RowCount Set tSC = $$$ERROR($$$GeneralError,"RegistryPackage has other documents referencing it by association") Quit
		
		Set tRS = ##class(%ResultSet.SQL).%Prepare("Select ID from HS_Registry_Document.RegistryPackage where IID in (Select SourceObject from hs_registry_document.association where targetobject=?)",.tER,"",tDocIID)
		IF $isObject(tER) Set tSC = tER.Status Quit
		While tRS.%Next() {
			Do tRS.ID.%DeleteId(tRS.ID.%Id())
		}

		Set tRS = ##class(%ResultSet).%New()
		Set tSC = tRS.Prepare("delete from hs_registry_document.association where targetobject=?") Quit:$$$ISERR(tSC)
		Set tSC = tRS.Execute(tDocIID) Quit:$$$ISERR(tSC)

		#; delete document classifications 
		For tIdx = obj.Classifications.Count():-1:1 {
			Set tClassification = obj.Classifications.GetAt(tIdx)
			Set tSC=tClassification.%DeleteId(tClassification.%Id()) $$$HSThrowErrors(tSC)
		}
		#; delete document slots
		For tIdx = obj.Slots.Count():-1:1 {
			Set tSlot = obj.Slots.GetAt(tIdx)
			Set tSC = tSlot.%DeleteId(tSlot.%Id())
			$$$HSThrowErrors(tSC)
		}
		#; delete document externalidentifiers (including slots and classifications[slots])
		For tIdx = obj.ExternalIdentifiers.Count():-1:1 {
			Set tExternalIdentifier=obj.ExternalIdentifiers.GetAt(tIdx)
			Set tSC = tExternalIdentifier.%DeleteId(tExternalIdentifier.%Id()) $$$HSThrowErrors(tSC)
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

ClassMethod IIDForUniqueID(pUniqueID As %String, Output pAryIID) As %Status
{
	&sql(DECLARE UniqueIIDCursor CURSOR for 
			select IID into :IID from HS_Registry.Document WHERE DocumentID=:pUniqueID and Status='Approved')
	&sql(OPEN UniqueIIDCursor)
	For  {
		&sql(FETCH UniqueIIDCursor)
		Quit:SQLCODE
		Set pAryIID(IID)=pUniqueID
	}
	&sql(CLOSE UniqueIIDCursor)
	Quit $$$OK
}

ClassMethod ObjectForIIDOfHighestVersion(pIID As %String, Output pDocument) As %Status
{
	try {
		Set tSC=$$$OK
		Set pDocument = ..IIDIndexOpen(pIID)
		Quit:'$IsObject(pDocument)
		&SQL(select ID into :tID from HS_Registry.Document where LogicalIID=:pDocument.LogicalIID order by Version desc)
		If SQLCODE Set tSC=$$$ERROR($$$GeneralError,"Couldn't find version") Quit
		If tID'=pDocument.%Id() Set tSC=$$$ERROR($$$GeneralError,$$$FormatText($$$Text("Document is not highest version expected '%1' have '%2' for logicalIID '%3'"),tID,pDocument.%Id(),pDocument.LogicalIID)) Quit
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod HighestVersionForLogicalIID(pIID As %String, Output pDocument) As %Status
{
	Set pDocument=""
	Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT top 1 ID from HS_Registry.Document where LogicalIID = ? Order by Version DESC",pIID)
	If 'tRS.SQLCODE && tRS.%Next() {
		Set pDocument = ..%OpenId(tRS.ID,0)
	}
	Quit $S(tRS.SQLCODE:$$$ERROR($$$SQLError,tRS.SQLCODE,tRS.%Message),1:$$$OK)
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
<Data name="DataElements">
<Attribute>DataElements</Attribute>
<Structure>subnode</Structure>
<Subscript>"DataElements"</Subscript>
</Data>
<Data name="Description">
<Attribute>Description</Attribute>
<Structure>subnode</Structure>
<Subscript>"Description"</Subscript>
</Data>
<Data name="DocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>PatientAssigningAuthority</Value>
</Value>
<Value name="5">
<Value>SourcePatientID</Value>
</Value>
<Value name="6">
<Value>SourcePatientAssigningAuthority</Value>
</Value>
<Value name="7">
<Value>DocumentID</Value>
</Value>
<Value name="8">
<Value>MimeType</Value>
</Value>
<Value name="9">
<Value>ObjectType</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>ExternalIdentifiers</Value>
</Value>
<Value name="12">
<Value>LogicalID</Value>
</Value>
<Value name="13">
<Value>ClassCode</Value>
</Value>
<Value name="14">
<Value>Size</Value>
</Value>
<Value name="15">
<Value>Hash</Value>
</Value>
<Value name="16">
<Value>ServiceStartTime</Value>
</Value>
<Value name="17">
<Value>ServiceStopTime</Value>
</Value>
<Value name="18">
<Value>SubmissionTime</Value>
</Value>
<Value name="19">
<Value>RepositoryUniqueID</Value>
</Value>
<Value name="20">
<Value>CreationTime</Value>
</Value>
<Value name="21">
<Value>CreationTimeInternal</Value>
</Value>
<Value name="22">
<Value>LastUpdateTimeInternal</Value>
</Value>
<Value name="23">
<Value>LanguageCode</Value>
</Value>
<Value name="24">
<Value>FormatCode</Value>
</Value>
<Value name="25">
<Value>HealthCareFacilityTypeCode</Value>
</Value>
<Value name="26">
<Value>PracticeSettingCode</Value>
</Value>
<Value name="27">
<Value>TypeCode</Value>
</Value>
<Value name="28">
<Value>PatientIdentifier</Value>
</Value>
<Value name="29">
<Value>DocumentUniqueIdentifier</Value>
</Value>
<Value name="30">
<Value>SourceIdentifier</Value>
</Value>
<Value name="31">
<Value>Title</Value>
</Value>
<Value name="32">
<Value>LogicalIID</Value>
</Value>
<Value name="33">
<Value>Version</Value>
</Value>
<Value name="34">
<Value>Availability</Value>
</Value>
</Data>
<Data name="Name">
<Attribute>Name</Attribute>
<Structure>subnode</Structure>
<Subscript>"Name"</Subscript>
</Data>
<DataLocation>^HS.Registry.DocumentD</DataLocation>
<DefaultData>DocumentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.DocumentD</IdLocation>
<IndexLocation>^HS.Registry.DocumentI</IndexLocation>
<StreamLocation>^HS.Registry.DocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
