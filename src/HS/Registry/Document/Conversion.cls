Include (HS.HC, Ensemble)

/// 
Class HS.Registry.Document.Conversion Extends %RegisteredObject
{

ClassMethod Convert() As %Status
{
	If '$$$IsHub Write !,"Please execute from the registry namespace" Quit $$$ERROR($$$GeneralError,"Execute from registry namespace")
	Set tSC = $$$OK,tDone=0
	Set tLastID=+$G(^HS.Registry.Document.Conversion("11Doc"))
	// If we haven't previously done the data migration build the extent index for Documents
	Set tAskRebuild=+$G(^HS.Registry.Document.Conversion("AskRebuild"))
	If 'tAskRebuild {
		For  {
			Read !,"Rebuild extent index $Document? Y// ",YN
			Set:YN="" YN="Y"
			Set tAns=$zcvt($zstrip(YN,"<>W"),"l")
			If $E(tAns)="y" || ($E(tAns)="n") Quit
		}
		If tAns = "n" {
			Set tAskRebuild=1
		}
	}
	If 'tLastID || 'tAskRebuild {
		Write !,"Building extent index $Document"
		Do ##class(HS.Registry.Document).%BuildIndices($lb("$Document"),0)
	}
	Set ^HS.Registry.Document.Conversion("AskRebuild")=1
	Write !,"Starting conversion *** any key will stop ***"
	Set tRS = ##class(%SQL.Statement).%ExecDirect("","Select ID from HS_Registry.document where ID>?",tLastID)
	While tRS.%Next() {
		Set tDocID = tRS.ID
		Set tDoc=##class(HS.Registry.Document).%OpenId(tDocID)
		Set tSC=..ConvertDocument(tDoc,tDocID) 
		If $$$ISERR(tSC) {
			Set ^HS.Registry.Document.Conversion("11Doc","Failed",tDocID)=tSC
			Continue
		}
		Set ^HS.Registry.Document.Conversion("11Doc")=tDocID
		Read *c:0 If $T Write !,"Ending at user request",tDone=1 Quit
	}
	Quit:$$$ISERR(tSC) tSC
	Quit:tDone tSC

	Set tLastID=+$G(^HS.Registry.Document.Conversion("11RP"))
	Set tRS = ##class(%SQL.Statement).%ExecDirect("","Select ID from HS_Registry_document.RegistryPackage where ID>?",tLastID)
	While tRS.%Next() {
		Set tRPID = tRS.ID
		Set tRP=##class(HS.Registry.Document.RegistryPackage).%OpenId(tRPID)
		Set tSC=..ConvertRegistryPackage(tRP,tRPID)
		If $$$ISERR(tSC) {
			Set ^HS.Registry.Document.Conversion("11RP","Failed",tRPID)=tSC
			Continue
		}
		Set ^HS.Registry.Document.Conversion("11RP")=tRPID
		Read *c:0 Quit:$t
	}
	Set tID="",tCount=0
	For  Set tID=$O(^HS.Registry.Document.Conversion("11Doc","Failed",tID)) Quit:tID=""  Set tCount=tCount+1
	If tCount {
		Write !,tCount," documents failed to convert"
	}
	Set tID="",tCount=0
	For  Set tID=$O(^HS.Registry.Document.Conversion("11RP","Failed",tID)) Quit:tID=""  Set tCount=tCount+1
	If tCount {
		Write !,tCount," registry packages failed to convert"
	}
	Quit tSC
}

ClassMethod ConvertRegistryPackage(pRP As HS.Registry.Document.RegistryPackage, pRPID)
{
	tstart
	try {
		Set tSC=$$$OK
		If pRP.LogicalIID="" Set pRP.LogicalIID=pRP.IID
		If pRP.Version="" Set pRP.Version=1
		If pRP.ContentTypeCode.Code="" Set tSC=..ConvertRPClassifications("ContentTypeCode","urn:uuid:aa543740-bdda-424e-8c96-df4873be8500",pRP,pRPID) Quit:$$$ISERR(tSC)
		If pRP.UniqueIdentifier.Value="" Set tSC=..ConvertRPExternalIdentifiers("UniqueIdentifier","urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8",pRP,pRPID) Quit:$$$ISERR(tSC)
		If pRP.PatientIdentifier.Value="" Set tSC=..ConvertRPExternalIdentifiers("PatientIdentifier","urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446",pRP,pRPID) Quit:$$$ISERR(tSC)
		If pRP.SourceIdentifier.Value="" Set tSC=..ConvertRPExternalIdentifiers("SourceIdentifier","urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832",pRP,pRPID) Quit:$$$ISERR(tSC)
		If pRP.SubmissionTime="" Set tSC=..ConvertRPSlots("SubmissionTime",,pRP,pRPID) Quit:$$$ISERR(tSC)
		If pRP.Node.Value="" Set tSC=..ConvertRPClassificationNodes(pRP,pRPID) Quit:$$$ISERR(tSC)
		Set tSC = pRP.%Save()
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		trollback
	} Else {
		tcommit
	}
	Quit tSC
}

ClassMethod ConvertDocument(pDoc As HS.Registry.Document, pDocID)
{
	tstart
	try {
		Set tSC=$$$OK
		If pDoc.LogicalIID="" Set pDoc.LogicalIID=pDoc.IID
		If pDoc.Version="" Set pDoc.Version=1
		If pDoc.Availability="" Set pDoc.Availability=1
		If pDoc.Size="" Set tSC=..ConvertSlots("Size",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.Hash="" Set tSC=..ConvertSlots("Hash",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.ServiceStartTime="" Set tSC=..ConvertSlots("ServiceStartTime",pDoc,pDocID) Quit:$$$ISERR(tSC)
		IF pDoc.ServiceStopTime="" Set:tSC tSC=..ConvertSlots("ServiceStopTime",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.SubmissionTime="" Set tSC=..ConvertSlots("SubmissionTime",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.RepositoryUniqueID="" Set tSC=..ConvertSlots("RepositoryUniqueID",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.SourcePatientID="" Set tSC=..ConvertSlots("SourcePatientID",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.CreationTime="" Set tSC=..ConvertSlots("CreationTime",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.LanguageCode="" Set tSC=..ConvertSlots("LanguageCode",pDoc,pDocID) Quit:$$$ISERR(tSC)

		If pDoc.ClassCode.Code="" Set tSC=..ConvertDocumentClassifications("ClassCode","urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.FormatCode.Code="" Set tSC=..ConvertDocumentClassifications("FormatCode","urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.HealthCareFacilityTypeCode.Code="" Set tSC=..ConvertDocumentClassifications("HealthCareFacilityTypeCode","urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.PracticeSettingCode.Code="" Set tSC=..ConvertDocumentClassifications("PracticeSettingCode","urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.TypeCode.Code="" Set tSC=..ConvertDocumentClassifications("TypeCode","urn:uuid:f0306f51-975f-434e-a61c-c59651d33983",pDoc,pDocID) Quit:$$$ISERR(tSC)

		If pDoc.DocumentUniqueIdentifier.Value="" Set tSC=..ConvertExternalIdentifiers("DocumentUniqueIdentifier","urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab",pDoc,pDocID) Quit:$$$ISERR(tSC)
		If pDoc.PatientIdentifier.Value="" Set tSC=..ConvertExternalIdentifiers("PatientIdentifier","urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427",pDoc,pDocID) Quit:$$$ISERR(tSC)

		Set tName = pDoc.Name.GetAt(1)
		If $IsObject(tName) {
			Set pDoc.Title.ValueText=tName.ValueText
			Set pDoc.Title.Charset=tName.Charset
			Set pDoc.Title.Lang=tName.Lang
		}

		Set tDescription = pDoc.Description.GetAt(1)
		If $IsObject(tDescription) {
			Set pDoc.Comments.ValueText=tDescription.ValueText
			Set pDoc.Comments.Charset=tDescription.Charset
			Set pDoc.Comments.Lang=tDescription.Lang
		}
		Set tSC=pDoc.%Save()

		///SRF244 - fix serial classifications and missing source identifier
		Set tDocumentData = ^HS.Registry.DocumentD(pDocID)
		For tIdx = 13,24:1:30 {
			Set tCodeData=$li(tDocumentData,tIdx)
			If $lg(tCodeData,9)="",$lg(tCodeData,4)'="" {
				Set $li(tCodeData,9)=$lb($lb($lb($li(tCodeData,4),"","")))
				Set $li(tDocumentData,tIdx)=tCodeData
				Set ^HS.Registry.DocumentD(pDocID)=tDocumentData
			}
		}

	} catch ex {
		Set tSC = ex.AsStatus()
	}		
	If $$$ISERR(tSC) {
		trollback
	} Else {
		tcommit
	}
	Quit tSC
}

ClassMethod ConvertSlots(pNewField, pDocument, pDocumentID, pOriginalField = "")
{
	Set tSC=$$$OK
	Set:pOriginalField="" pOriginalField=pNewField
	
	Set tRS = ##class(%ResultSet.SQL).%Prepare("select id from hs_registry_document.slot where name=? and document=?",.tER,,pOriginalField,pDocumentID)
	While tRS.%Next() {
		Set tValue=tRS.ID.ValueList.GetAt(1)
		Set $property(pDocument,pNewField)=tValue
		Set tSlotPos=pDocument.Slots.FindObjectId(tRS.ID.%Id())
		Do:tSlotPos]"" pDocument.Slots.RemoveAt(tSlotPos)
		Set tSC = tRS.ID.%DeleteId(tRS.ID.%Id()) Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod ConvertDocumentClassifications(pNewField, pScheme = "", pDocument, pDocumentID) [ Private ]
{
	Set tSC=$$$OK
	Set tRS = ##class(%ResultSet.SQL).%Prepare("select id from hs_registry_document.classification where classificationScheme=? and document=?",.tER,,pScheme,pDocumentID)
	While tRS.%Next() {
		Set tNew=##class(HS.Types.IHE.XDSb.SerialClassification).%New()
		Set tNew.IID=tRS.ID.IID
		Set tNew.Code=tRS.ID.NodeRepresentation
		Set tNew.CodingScheme=tRS.ID.Slots.GetAt(1).ValueList.GetAt(1)
		If $isObject(tRS.ID.Name) {
			Do tNew.Names.Insert(tRS.ID.Name.GetAt(1).ValueText)
		} Else {
			Do tNew.Names.Insert(tRS.ID.Name)
		}
		Set $property(pDocument,pNewField)=tNew
		Set tNode=pDocument.Classifications.FindObjectId(tRS.ID.%Id())
		Do:tNode]"" pDocument.Classifications.RemoveAt(tNode)
		Set tSC = tRS.ID.%DeleteId(tRS.ID.%Id()) Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod ConvertExternalIdentifiers(pNewField, pScheme = "", pDocument, pDocumentID) [ Private ]
{
	Set tSC=$$$OK
	Set tDocIID = pDocument.IID
	For tIdx = 1:1:pDocument.ExternalIdentifiers.Count() {
		#dim tIdentifier as HS.Registry.Document.ExternalIdentifier = pDocument.ExternalIdentifiers.GetAt(tIdx)
		Continue:tIdentifier.IdentificationScheme'=pScheme 
		Set tNew=##class(HS.Registry.Document.SerialExternalIdentifier).%New()
		Set tNew.Value=tIdentifier.IdentificationValue
		Set tNew.IID=tIdentifier.IID
		Set $property(pDocument,pNewField)=tNew
		Do pDocument.ExternalIdentifiers.RemoveAt(tIdx)
		Set tSC = ##class(HS.Registry.Document.ExternalIdentifier).%DeleteId(tIdentifier.%Id()) Quit:$$$ISERR(tSC)  
		Quit
	}
	Quit tSC
}

ClassMethod ConvertRPExternalIdentifiers(pNewField, pScheme = "", pRP, pRPID) [ Private ]
{
	Set tSC=$$$OK
	For tIdx = 1:1:pRP.ExternalIdentifiers.Count() {
		#dim tIdentifier as HS.Registry.Document.ExternalIdentifier = pRP.ExternalIdentifiers.GetAt(tIdx)
		Continue:tIdentifier.IdentificationScheme'=pScheme 
		Set tNew=##class(HS.Registry.Document.SerialExternalIdentifier).%New()
		Set tNew.Value=tIdentifier.IdentificationValue
		Set tNew.IID=tIdentifier.IID
		Set $property(pRP,pNewField)=tNew
		Do pRP.ExternalIdentifiers.RemoveAt(tIdx)
		Set tSC = ##class(HS.Registry.Document.ExternalIdentifier).%DeleteId(tIdentifier.%Id()) Quit:$$$ISERR(tSC)  

		#; update the document with the source identifier
		If pScheme="urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832" {  // source identifier
			Set tRSD = ##class(%ResultSet.SQL).%Prepare("select ID from Hs_registry.document where IID in (SELECT TargetObject from HS_Registry_Document.Association where SourceObject=?)",.tER,,pRP.IID)
			While tRSD.%Next() {
				Set tRSD.ID.SourceIdentifier=tNew
				Set tSC=tRSD.ID.%Save() Quit:$$$ISERR(tSC)
			}
		}

		Quit
	}
	Quit tSC
}

ClassMethod ConvertRPClassifications(pNewField, pScheme, pRP, pRPID)
{
	Set tSC=$$$OK
	Set tRS = ##class(%ResultSet.SQL).%Prepare("select id from hs_registry_document.classification where classificationScheme=? and registrypackage=?",.tER,,pScheme,pRPID)
	While tRS.%Next() {
		Set tNew=##class(HS.Types.IHE.XDSb.SerialClassification).%New()
		Set tNew.IID=tRS.ID.IID
		Set tNew.Code=tRS.ID.NodeRepresentation
		Set tNew.CodingScheme=tRS.ID.Slots.GetAt(1).ValueList.GetAt(1)
		If $isObject(tRS.ID.Name) {
			Do tNew.Names.Insert(tRS.ID.Name.GetAt(1).ValueText)
		} Else {
			Do tNew.Names.Insert(tRS.ID.Name)
		}
		Set $property(pRP,pNewField)=tNew
		Set tNode=pRP.Classifications.FindObjectId(tRS.ID.%Id())
		Do:tNode]"" pRP.Classifications.RemoveAt(tNode)
		Set tSC = tRS.ID.%DeleteId(tRS.ID.%Id()) Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod ConvertRPClassificationNodes(pRP, pRPID)
{
	Set tSC=$$$OK
	Set tRS = ##class(%ResultSet.SQL).%Prepare("select id from hs_registry_document.classification where registrypackage=? and not(classificationNode is null)",.tER,,pRPID)
	While tRS.%Next() {
		Set tNew=##class(HS.Registry.Document.SerialExternalIdentifier).%New()
		Set tNew.IID=tRS.ID.IID
		Set tNew.Value=tRS.ID.ClassificationNode
		Set pRP.Node=tNew
		Set tNode=pRP.Classifications.FindObjectId(tRS.ID.%Id())
		Do:tNode]"" pRP.Classifications.RemoveAt(tNode)
		Set tSC = tRS.ID.%DeleteId(tRS.ID.%Id()) Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod ConvertRPSlots(pNewField, pOriginalField = "", pRP, pRPID)
{
	Set tSC=$$$OK
	Set:pOriginalField="" pOriginalField=pNewField
	Set tRS = ##class(%ResultSet.SQL).%Prepare("select id from hs_registry_document.slot where name=? and registrypackage=?",.tER,,pOriginalField,pRPID)
	While tRS.%Next() {
		Set tValue=tRS.ID.ValueList.GetAt(1)
		Set $property(pRP,pNewField)=tValue
		Set tSlotPos=pRP.Slots.FindObjectId(tRS.ID.%Id())
		Do:tSlotPos]"" pRP.Slots.RemoveAt(tSlotPos)
		Set tSC = tRS.ID.%DeleteId(tRS.ID.%Id()) Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod FixMissingSourceIdentifier() As %Status
{
	Set tSC = $$$OK
	Write !,"Starting conversion *** any key will stop ***"
	Set tSC = $$$OK,tDone=0
	Set tLastID=+$G(^HS.Registry.Document.Conversion("13Doc"))
	Set tRSDoc = ##class(%ResultSet.SQL).%Prepare("select iid,id from hs_registry.document where sourceidentifier_value is null and ID>?",.tER,,tLastID)
	While tRSDoc.%Next() {
		break
		Set tDocIID = tRSDoc.IID
		Set tRSRP = ##class(%ResultSet.SQL).%Prepare("select sourceidentifier_value Value,sourceidentifier_iid IID from hs_registry_document.registrypackage where iid in (select sourceobject from hs_registry_document.association where targetobject = ?)",.tER,,tRSDoc.IID)
		While tRSRP.%Next() {
			Set tRSDoc.ID.SourceIdentifier.Value=tRSRP.Value
			Set tRSDoc.ID.SourceIdentifier.IID=tRSRP.IID
			Set tSC = tRSDoc.ID.%Save()	If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
			Set ^HS.Registry.Document.Conversion("13Doc")=tRSDoc.ID.%Id()
			Read *c:0 If $T Write !,"Ending at user request",tDone=1 Quit
		}
	}
	Quit tSC
}

ClassMethod FixSourceIDSlots() As %Status
{
	Set tSC =  $$$OK
	Set tRS = ##class(%SQL.Statement).%ExecDirect("","Select ID,document from HS_Registry_document.Slot where name='urn:healthshare:slots:sourceId'")
	While tRS.%Next() {
		Set tDoc = ##class(HS.Registry.Document).%OpenId(tRS.Document)
		Set tPos=tDoc.Slots.FindObjectId(tRS.ID)
		If tPos {
			Do tDoc.Slots.RemoveAt(tPos)
			Set tSC = tDoc.%Save()
			If '$$$ISERR(tSC) {
				Set tSC = ##class(HS.Registry.Document.Slot).%DeleteId(tRS.ID)
			}
		}
		If 'tPos || $$$ISERR(tSC) {
			Set ^HS.Registry.Document.Conversion("SourceIDSlots","Failed","Doc",tRS.Document,"Slot",tRS.ID)=tSC
			Write !,"Failure with document ",tRS.Document," and slot ",tRS.ID
		}
	}
	Write !,"Complete"
}

}
