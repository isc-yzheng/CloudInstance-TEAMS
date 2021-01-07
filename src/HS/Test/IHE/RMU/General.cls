/// RMU - Restricted Metadata Update is only for documents 
Class HS.Test.IHE.RMU.General Extends HS.Test.IHE.XDSb.Base
{

Parameter BaseClassItems = "HS.Test.IHE.RMU.General";

Parameter MPIManager = "HS.MPI.Manager";

Parameter Repository = "HS.IHE.XDSb.Repository.Services";

Parameter Registry = "HS.IHE.XDSb.Registry.Services";

Parameter DocumentSource = "HS.IHE.XDSb.DocumentSource.Operations";

Parameter DocumentConsumer = "HS.IHE.XDSb.Consumer.Operations";

// Parameter Administrator = "HS.IHE.XDSb.Administrator.Operations";

Parameter Administrator = "HS.HC.IHE.RMU.Process";

Method Test100Setup()
{
	///
	$$$HSTestBailout
	Do ..XDSReset(1)
	Set tSC = ..Setup()
	Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("Test.XDSb.Registry","SOAP")
	Do tEP.OIDMapCode.SetAt("HomeCommunity","HomeCommunity")
	Do tEP.OIDMapCode.SetAt("RMU","DeviceFunction")
	Set tSC = tEP.%Save()
	Quit:'$$$AssertStatusOK(tSC,"Updated XDSbRegistry end point")
    Set tPracticeSetting = ##class(HS.IHE.CodedEntry).ImportFromURL()
    For tItem = $lb("practiceSettingCode","R-30254","2.16.840.1.113883.6.96"),$lb("practiceSettingCode","R-3027B","2.16.840.1.113883.6.96") {
        Set tCodedEntry=##class(HS.IHE.CodedEntry).%New()
        Set tCodedEntry.CodeType=$li(tItem)
        Set tCodedEntry.Code=$li(tItem,2)
        Set tCodedEntry.CodingScheme=$li(tItem,3)
        Set tSC=tCodedEntry.CreateOrUpdate() 
        If $$$ISERR(tSC) $$$ThrowStatus(tSC)
    }

	Set tFacility = ##class(HS.Facility.Config).%OpenId("IHEFACILITY")
	If 'tFacility {
		Set tFacility = ##class(HS.Facility.Config).%New()
		Set tFacility.FacilityCode="IHEFACILITY"
		Set tFacility.Name="IHEFACILITY"
		Set tSC = tFacility.%Save()
		Quit:$$$ISERR(tSC)
		Do ##class(HS.Data.OIDMap).FileOID("IHEFACILITY","Facility","1.3.6.1.4.1.21367.3000.1.6",,"AssigningAuthority")
	}
	$$$HSTestBailout
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	//Do ##class(HS.Data.OIDMap).FileOID("ISC","AssigningAuthority","2.16.840.1.113883.3.86.3")
	// if there is no oid for this namespace, define it (the OID becomes the repository OID)
	//Do:##class(HS.Data.OIDMap).GetOIDForCode($namespace)="" ##class(HS.Data.OIDMap).FileOID($NAMESPACE,"Repository","2.16.840.1.113883.3.86.3.19998")
	$$$HSTestBailout
}

Method Test200AddUpdateDocument()
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	$$$HSTestBailout
	Set tHighAuditID = ..FindHighAuditID()
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="Restricted"
	Set tAPRequest.LastName="Update"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1967-01-01")
	Set tAPRequest.MRN="RestrictedMetadataUpdate"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPRequest.MRN)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	#; Create XDSb document
	Do ..createDocument("RMU#1",tAPResponse.MPIID,.tSubmission)
	Do ..FindAuditRecords(tHighAuditID,1,"R","ITI-41",.tCount)
	If '$$$AssertTrue((tCount=1),"Document source PnR audit record count:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-41",.tCount)
	If '$$$AssertTrue(tCount=1,"Repository PnR audit record count:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-42",.tCount)
	If '$$$AssertTrue(tCount=1,"Registry Register audit record count:"_tCount)
	
	Set tHighAuditID = ..FindHighAuditID()
	#; Query for XDSb document just created
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQDRequest.QueryType="GetDocuments"
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddSingleParam(2,"$MetadataLevel")
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"Single Document located")

	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the consumer:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the registry:"_tCount)

	#; Update XDSb Document created above
	Set tHighAuditID = ..FindHighAuditID()
	Set tDoc = tQDResponse.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate1"
  	Set tTypeCode = tDoc.TypeCode
	For  {
		$$$DynamicCode(tDoc,TypeCode,0)
		Quit:tDoc.TypeCode.Code'=tTypeCode.Code
	}
	Quit:'$$$AssertTrue(tTypeCode.Code'=tDoc.TypeCode.Code,"Updated type code")
	Set tSaveCode = tDoc.ClassCode 
	For  {
		$$$DynamicCode(tDoc,ClassCode,0)
		Quit:tDoc.ClassCode.Code'=tSaveCode.Code
	}
	Set tSaveCode = tDoc.FormatCode
	For  {
		$$$DynamicCode(tDoc,FormatCode,0)
		Quit:tDoc.FormatCode.Code'=tSaveCode.Code
	}
	Set tDoc.HomeCommunityId = $$$HomeCommunityOID
	Set tSC = tUpdate1.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate1.UpdateAssociations()
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse) 
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)

	#; query with no $MetadataLevel specification should be two documents
	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddSingleParam(2,"$MetadataLevel")
	Set tQDRequest.QueryType="GetDocuments"
	Do tQDRequest.AddParam("urn:uuid:"_tSubmission.Documents.GetAt(1).EntryUUID,"$XDSDocumentEntryLogicalID")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
    Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=2,"2 Documents located")
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the consumer:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the registry:"_tCount)

	#; query for document (should be 1)
	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
    Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"1 Document located")
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the consumer:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the registry:"_tCount)


	#; Deprecate Document
	Set tHighAuditID = ..FindHighAuditID()
	Set tDoc = tQDResponse.Documents.GetAt(1)
	Set tUpdate2 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate2.PatientId = tDoc.PatientId
	Set tUpdate2.SourceId = $P(tDoc.PatientId,"&",2)
	Set tUpdate2.ContentTypeCode=tUpdate1.ContentTypeCode
	Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).%New()
	Set tAssociation.ParentUUID=tUpdate2.EntryUUID
	Set tAssociation.ChildUUID=tDoc.EntryUUID
	Set tAssociation.Type ="UpdateAvailabilityStatus"
	Set tAssociation.OriginalStatus="Approved"
	Set tAssociation.NewStatus="Deprecated"
	Do tUpdate2.Associations.Insert(tAssociation)
	Do tUpdate2.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate2,.tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Status change completed without error")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)

	#; query for document (should still be 1)
	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"1 Documents located")
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the consumer:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the registry:"_tCount)
}

Method Test300AddUpdateDocumentExternal()
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	$$$HSTestBailout
	Set tHighAuditID = ..FindHighAuditID()
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="Restricted"
	Set tAPRequest.LastName="Update"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1967-01-01")
	Set tAPRequest.MRN="RestrictedMetadataUpdate"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPRequest.MRN)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	#; Create XDSb document
	Do ..createDocument("RMU#1",tAPResponse.MPIID,.tSubmission)
	#; Query for XDSb document just created
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQDRequest.QueryType="GetDocuments"
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddSingleParam(2,"$MetadataLevel")
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"Single Document located")

	#; Update XDSb Document created above
	Set tHighAuditID = ..FindHighAuditID()
	Set tDoc = tQDResponse.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate1"
  	Set tTypeCode = tDoc.TypeCode
	For  {
		$$$DynamicCode(tDoc,TypeCode,0)
		Quit:tDoc.TypeCode.Code'=tTypeCode.Code
	}
	Quit:'$$$AssertTrue(tTypeCode.Code'=tDoc.TypeCode.Code,"Updated type code")
	Set tSaveCode = tDoc.ClassCode 
	For  {
		$$$DynamicCode(tDoc,ClassCode,0)
		Quit:tDoc.ClassCode.Code'=tSaveCode.Code
	}
	Set tSaveCode = tDoc.FormatCode
	For  {
		$$$DynamicCode(tDoc,FormatCode,0)
		Quit:tDoc.FormatCode.Code'=tSaveCode.Code
	}
	Set tDoc.HomeCommunityId = $$$HomeCommunityOID
	Set tSC = tUpdate1.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Set tTransformer = ##class(HS.Util.XSLTTransformer).%New()

	//Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate1.UpdateAssociations()
	Set tSC = tUpdate1.XMLExportToStream(.tStream,"UpdateDocumentSetRequest")
	#; convert message to RegisterRequest
	Set tSC=tTransformer.Transform(tStream, "IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl",.tMessage) Quit:$$$ISERR(tSC)
	Set tNewRequest = ##class(HS.Message.XMLMessage).%New()
	Set tNewRequest.Name=$$$RMUDocumentSetRequest
	Do tNewRequest.ContentStream.CopyFrom(tMessage)
	Do tNewRequest.AdditionalInfo.SetAt($$$RMUDocumentSetAction(1),"SOAPAction") 
	Do tNewRequest.AdditionalInfo.SetAt("Test.XDSb.Registry","ServiceName") 
	Do tNewRequest.AdditionalInfo.SetAt("HS.IHE.RMU.Initiator.Operations","Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tNewRequest,.tUpdateResponse)  
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error")
	Quit:'$$$AssertTrue(tUpdateResponse.AdditionalInfo.GetAt("ResponseSOAPAction") = $$$RMUDocumentSetResponseAction(1),"Correct response action")
}

/// Add patients for Test300
Method addRMU1000(Output pAPResponse1, Output pAPResponse2)
{
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="Restricted"
	Set tAPRequest.LastName="Update"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1967-01-01")
	Set tAPRequest.MRN="RMU1000"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.pAPResponse1)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPRequest.MRN) tSC

	#; Create Patient 1003 with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="Restricted"
	Set tAPRequest.LastName="Update-1003"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1957-10-01")
	Set tAPRequest.MRN="RMU1003"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.pAPResponse2)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPRequest.MRN) tSC
    Quit tSC
}

Method addDocuments1000And1003(pAPResponse1, pAPResponse2, Output pMeta1, Output pMeta2, Output pMeta3) As %Status
{
  
    Set tSC = $$$OK
	Set tTransformer = ##class(HS.Util.XSLTTransformer).%New()
	Set %PatientID=pAPResponse1.MPIID_"^^^&amp;"_$$$AffinityDomainOID_"&amp;ISO"
	Set tSC = ##class(HS.Test.TestCase).GetXDataAsStreamWithSubstitutions("xdata://"_..%ClassName(1)_":ConnectathonPatient1Sub1",.tStream) 
	Quit:'$$$AssertStatusOK(tSC,"Submission 1 ")
	Set tMessage1 = ##class(HS.Message.XMLMessage).%New()
	Do tMessage1.ContentStream.CopyFrom(tStream)
	Set tMessage1.Name = $$$XDSbProvideAndRegisterRequest
	Set tSC = tTransformer.TransformIntoObject(tStream,"IHE/XDSb/Version1/Message-to-MetadataObject.xsl",.pMeta1,,"HS.Message.IHE.XDSb.Metadata","Metadata")
	//Quit:'$$$AssertStatusOK(tSC,"Transform Submission 1 - 1 doc")
	Do tMessage1.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tMessage1.AdditionalInfo.SetAt($$$XDSbRegisterAction(1),"SOAPAction")
	Do tMessage1.AdditionalInfo.SetAt("Test.XDSb.Registry","ServiceName")
	Set tSC = ##class(HS.Test.Service).SendSync(tMessage1,.tPnRResponse1)
	Quit:'$$$AssertStatusOK(tSC,"First Submission") tSC
	Quit:'$$$AssertTrue($IsObject(tPnRResponse1)&&(tPnRResponse1.ContentStream.Read()["Success")) $$$ERROR($$$GeneralError,"Failed pnr2")

	Set tSC = ##class(HS.Test.TestCase).GetXDataAsStreamWithSubstitutions("xdata://"_..%ClassName(1)_":ConnectathonPatient1Sub2",.tStream) 
	Quit:'$$$AssertStatusOK(tSC,"Submission 2 - 2 docs")
	Set tMessage2 = ##class(HS.Message.XMLMessage).%New()
	Do tMessage2.ContentStream.CopyFrom(tStream)
	Set tMessage2.Name = $$$XDSbProvideAndRegisterRequest
	Do tMessage2.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tMessage2.AdditionalInfo.SetAt($$$XDSbRegisterAction(1),"SOAPAction")
	Do tMessage2.AdditionalInfo.SetAt("Test.XDSb.Registry","ServiceName")
	Set tSC = tTransformer.TransformIntoObject(tStream,"IHE/XDSb/Version1/Message-to-MetadataObject.xsl",.pMeta2,,"HS.Message.IHE.XDSb.Metadata","Metadata")
	Set tSC = ##class(HS.Test.Service).SendSync(tMessage2,.tPnRResponse2)
	Quit:'$$$AssertStatusOK(tSC,"Second Submission") $$$OK
	Quit:'$$$AssertTrue($IsObject(tPnRResponse2)&&(tPnRResponse2.ContentStream.Read()["Success")) $$$ERROR($$$GeneralError,"Failed pnr2")

	Set %PatientID=pAPResponse2.MPIID_"^^^&amp;"_$$$AffinityDomainOID_"&amp;ISO"

	/// register document for patient 2 (1003)
	Set tSC = ##class(HS.Test.TestCase).GetXDataAsStreamWithSubstitutions("xdata://"_..%ClassName(1)_":ConnectathonPatient2Sub1",.tStream) 
	Quit:'$$$AssertStatusOK(tSC,"Submission 3 ")
	Set tMessage3 = ##class(HS.Message.XMLMessage).%New()
	Do tMessage3.ContentStream.CopyFrom(tStream)
	Set tMessage3.Name = $$$XDSbProvideAndRegisterRequest
	Do tMessage3.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tMessage3.AdditionalInfo.SetAt($$$XDSbRegisterAction(1),"SOAPAction")
	Do tMessage3.AdditionalInfo.SetAt("Test.XDSb.Registry","ServiceName")
	Set tSC = tTransformer.TransformIntoObject(tStream,"IHE/XDSb/Version1/Message-to-MetadataObject.xsl",.pMeta3,,"HS.Message.IHE.XDSb.Metadata","Metadata")
	Set tSC = ##class(HS.Test.Service).SendSync(tMessage3,.tPnRResponse3)
	Quit:'$$$AssertStatusOK(tSC,"Third Submission") tSC
	Quit:'$$$AssertTrue($IsObject(tPnRResponse3)&&(tPnRResponse3.ContentStream.Read()["Success")) $$$ERROR($$$GeneralError,"Failed pnr3")

    Quit tSC
}

Method updatePatient1003(pAPResponse2, pMeta) As %Status
{
    Set tHighAuditID = ..FindHighAuditID()
	#; Query for XDSb document patient 1003
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse2.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse1)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error") tSC
	Quit:'$$$AssertTrue(tQResponse1.Documents.Count()=1 && (tQResponse1.Errors.Errors.Count()=0),"Single Document located") $$$ERROR($$$GeneralError,"More than 1 doc")

	#; Update XDSb Document created above
	Set tHighAuditID = ..FindHighAuditID()
	Set tDoc = tQResponse1.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate1"
	For tIdx = 1:1:tDoc.Author.Count() {
		Set tAuthor = tDoc.Author.GetAt(tIdx)
		If tAuthor.AuthorPerson="^Shah^Kendra^^^" {
			Set tAuthor.AuthorPerson="^Author^New^^^"
			Quit
		}
	}
	Set tDoc.Comments = "RMU updated comments"
	Do tDoc.ConfidentialityCode.Clear()
	Do tDoc.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New("R","2.16.840.1.113883.5.25","restricted"))
	Set tDoc.CreationTime=$zd($H,8)
	Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New("urn:connectathon:bppc:foundational:policy", "1.3.6.1.4.1.21367.2017.3", "Foundational Connectathon Read-Access Policy")
	Do tDoc.EventCodeList.Insert(tCodedValue)

	Set tDoc.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("urn:ihe:pcc:cm:2008","1.3.6.1.4.1.19376.1.2.3", "Care Management (CM)")
	Set tDoc.HealthcareFacilityTypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).%New("42665001","2.16.840.1.113883.6.96", "Nursing home")
	Set tDoc.LanguageCode="es"
	For tIdx = 1:1:tDoc.DocumentSlots.Count() {
		Set tSlot = tDoc.DocumentSlots.GetAt(tIdx)
		If tSlot.Name = "legalAuthenticator" {
			Do tSlot.ValueList.Clear()
			Do tSlot.ValueList.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("^Authenticator^New^^^^MD"))
			//w tDoc.DocumentSlots.GetAt(2).ValueList.GetAt(1).Value

		}
		If tSlot.Name = "urn:ihe:iti:xds:2013:referenceIdList" {
			For tIdxVL = 1:1:tSlot.ValueList.Count() {
				If tSlot.ValueList.GetAt(tIdxVL).Value = "3333-O^^^&1.3.6.1.4.1.21367.13.202.2000&ISO^urn:ihe:iti:xds:2013:order" {
					Set tSlot.ValueList.GetAt(tIdxVL).Value = "4444-New^^^&1.3.6.1.4.1.21367.13.202.2000&ISO^urn:ihe:iti:xds:2013:order"
				}
			}

		}
		//i%DocumentSlots(1) = $lb($lb("",$lb($lb($lb("3333-R^^^&1.3.6.1.4.1.21367.13.202.1000&ISO^urn:ihe:iti:xds:2013:referral")),$lb($lb("3333-O^^^&1.3.6.1.4.1.21367.13.202.2000&ISO^urn:ihe:iti:xds:2013:order")))))
	}
	Set tDoc.PracticeSettingCode = ##class(HS.IHE.XDSb.Types.CodedValue).%New("R-30254", "2.16.840.1.113883.6.96", "General Medicine")
	Set tNow = $H
	Set tDoc.ServiceStartTime = $tr($ZDT(+tNow_","_($p(tNow,",",2)-300),8),": ")
	Set tDoc.ServiceStopTime = $tr($ZDT(tNow,8),": ")
	For tIdx = 1:1:tDoc.SourcePatientInfo.Count() {
		Set tSPI = tDoc.SourcePatientInfo.GetAt(tIdx).Value
		If $p(tSPI,"|",1)="PID-7" {
			Set tNewSlot = ##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|19660606")
			//Do tDoc.SourcePatientInfo.RemoveAt(tIdx)
			Do tDoc.SourcePatientInfo.SetAt(tNewSlot,tIdx)
		}
	}
	Set tDoc.Title = "RMU - New Title"
	Set tDoc.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).%New("11488-4", "2.16.840.1.113883.6.1", "Progress Note")
	Set tDoc.HomeCommunityId = $$$HomeCommunityOID
	Set tSC = tUpdate1.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate1.UpdateAssociations()
	//Set tUpdate1.Associations.GetAt(1).AssociationPropagation="no"
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)


	/// Verify the changes
	/// ----------
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse2.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse1V)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQResponse1V.Documents.Count()=1 && (tQResponse1V.Errors.Errors.Count()=0),"Single Document located")
	Set tDoc = tQResponse1V.Documents.GetAt(1)

	Set tFoundUpdate=0
	For tIdx = 1:1:tDoc.Author.Count() {
		Set tAuthor = tDoc.Author.GetAt(tIdx)
		If tAuthor.AuthorPerson="^Author^New^^^" {
			Set tFoundUpdate=1
			Quit
		}
	}
	If '$$$AssertTrue(tFoundUpdate,"Author update found")
	If '$$$AssertTrue(tDoc.Comments = "RMU updated comments")
	If '$$$AssertTrue(tDoc.ConfidentialityCode.GetAt(1).Code="R")
	If '$$$AssertTrue(tDoc.CreationTime=$zd($H,8))
	Set tFoundUpdate=0
	For tIdx = 1:1:tDoc.EventCodeList.Count() {
		Set tEvent = tDoc.EventCodeList.GetAt(tIdx)
		If tEvent.Code = "urn:connectathon:bppc:foundational:policy" {
			Set tFoundUpdate=1
			Quit
		}
	}
	If '$$$AssertTrue(tFoundUpdate,"EventCodeList update found")
	If '$$$AssertTrue(tDoc.FormatCode.Code="urn:ihe:pcc:cm:2008")
	If '$$$AssertTrue(tDoc.HealthcareFacilityTypeCode.Code="42665001")
	If '$$$AssertTrue(tDoc.LanguageCode="es")
	Set tFoundUpdate=0
	For tIdx = 1:1:tDoc.DocumentSlots.Count() {
		Set tSlot = tDoc.DocumentSlots.GetAt(tIdx)
		If tSlot.Name = "legalAuthenticator" {
			If tSlot.ValueList.GetAt(1).Value = "^Authenticator^New^^^^MD" {
				Set tFoundUpdate=1
				Quit
			}
		}
	}
	If '$$$AssertTrue(tFoundUpdate,"legal Authenticator update found")

	Set tFoundUpdate=0
	For tIdx = 1:1:tDoc.DocumentSlots.Count() {
		Set tSlot = tDoc.DocumentSlots.GetAt(tIdx)
		If tSlot.Name = "urn:ihe:iti:xds:2013:referenceIdList" {
			For tIdxVL = 1:1:tSlot.ValueList.Count() {
				If tSlot.ValueList.GetAt(tIdxVL).Value = "4444-New^^^&1.3.6.1.4.1.21367.13.202.2000&ISO^urn:ihe:iti:xds:2013:order" {
					Set tFoundUpdate=1
				}
			}

		}
		//i%DocumentSlots(1) = $lb($lb("",$lb($lb($lb("3333-R^^^&1.3.6.1.4.1.21367.13.202.1000&ISO^urn:ihe:iti:xds:2013:referral")),$lb($lb("3333-O^^^&1.3.6.1.4.1.21367.13.202.2000&ISO^urn:ihe:iti:xds:2013:order")))))
	}
	If '$$$AssertTrue(tFoundUpdate,"reference id list update found")
	If '$$$AssertTrue(tDoc.PracticeSettingCode.Code="R-30254")
	Set tNow = $H
	If '$$$AssertTrue($tr($ZDT(+tNow_","_($p(tNow,",",2)-300),8),": ")-tDoc.ServiceStartTime<10)
	If '$$$AssertTrue($tr($ZDT(+tNow_","_($p(tNow,",",2)),8),": ")-tDoc.ServiceStopTime<10)
	Set tFoundUpdate=0
	For tIdx = 1:1:tDoc.SourcePatientInfo.Count() {
		Set tSPI = tDoc.SourcePatientInfo.GetAt(tIdx).Value
		If $p(tSPI,"|",1)="PID-7" {
			If tSPI="PID-7|19660606" Set tFoundUpdate = 1
		}
	}
	If '$$$AssertTrue(tFoundUpdate,"missing DOB update")
	If '$$$AssertTrue(tDoc.Title = "RMU - New Title")
	If '$$$AssertTrue(tDoc.TypeCode.Code="11488-4")
    Quit $$$OK
}

Method updatePatient1000Sub1(pAPResponse1, pMeta1)
{
    Set tHighAuditID = ..FindHighAuditID()
	//
	/// update the first document on 1000
	#; Query for XDSb document patient 1000
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse1.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="GetDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AddParam(pMeta1.Documents.GetAt(1).DocumentUniqueIdentifier.Value,"$XDSDocumentEntryUniqueId")
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse2)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	/// update first doc for 1000
	Set tDoc = tQResponse2.Documents.GetAt(1)
	Set tUpdate2 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate2.PatientId = tDoc.PatientId
	Set tUpdate2.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate2,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate2"
	Set tDoc.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9", "2.16.840.1.113883.6.1", "Summary of episode note")

	Set tDoc.HomeCommunityId = $$$HomeCommunityOID
	Set tSC = tUpdate2.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Do tUpdate2.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate2.UpdateAssociations()
	//Set tUpdate1.Associations.GetAt(1).AssociationPropagation="no"
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate2,.tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)

	/// re-query to ensure updated
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse2)
    If '$$$AssertTrue(tQResponse2.Errors.Errors.Count()=0)
	If '$$$AssertTrue(tQResponse2.Documents.GetAt(1).TypeCode.Code="34133-9")

	/// update the second and third documents on 1000
	#; Query for XDSb document patient 1000
	Set tHighAuditID = ..FindHighAuditID()
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse1.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AddParam(pMeta1.Documents.GetAt(1).DocumentUniqueIdentifier.Value,"$XDSDocumentEntryUniqueId")
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse2)
    If '$$$AssertTrue( (tQResponse2.Errors.Errors.Count()=0))
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	/// update first doc for 1000
	For tIdx = 1:1:tQResponse2.Documents.Count() {
		Set tDoc = tQResponse2.Documents.GetAt(tIdx)
		If tDoc.UniqueId = pMeta1.Documents.GetAt(1).DocumentUniqueIdentifier.Value Quit
	}
	Set tUpdate2 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate2.PatientId = tDoc.PatientId
	Set tUpdate2.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate2,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate2"
	Set tDoc.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9", "2.16.840.1.113883.6.1", "Summary of episode note")

	Set tDoc.HomeCommunityId = $$$HomeCommunityOID
	Set tSC = tUpdate2.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Do tUpdate2.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate2.UpdateAssociations()
	//Set tUpdate1.Associations.GetAt(1).AssociationPropagation="no"
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate2,.tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)

	/// re-query to ensure updated
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse2)
    If '$$$AssertTrue( (tQResponse2.Errors.Errors.Count()=0))
	For tIdx = 1:1:tQResponse2.Documents.Count() {
		Set tDoc = tQResponse2.Documents.GetAt(tIdx)
		If tDoc.UniqueId = pMeta1.Documents.GetAt(1).DocumentUniqueIdentifier.Value Quit
	}
    If '$$$AssertTrue(tDoc.TypeCode.Code="34133-9")
    Quit $$$OK
}

Method updatePatient1000Sub2(pAPResponse1, pMeta2)
{
	Set tHighAuditID = ..FindHighAuditID()
	/// update the first document on 1000
	#; Query for XDSb document patient 1000
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse1.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse2)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
    If '$$$AssertTrue(tQResponse2.Errors.Errors.Count()=0)
 	/// update the second document
	For tIdx = 1:1:tQResponse2.Documents.Count() {
		Set tDoc = tQResponse2.Documents.GetAt(tIdx)
		/// Find prescription document
		If tDoc.FormatCode.Code = "urn:ihe:pharm:pre:2010" {
            Quit
        }

	}
	Set tUpdate3 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate3.PatientId = tDoc.PatientId
	Set tUpdate3.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate3,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate3"
	Do tDoc.ConfidentialityCode.Clear()
	Do tDoc.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New("R","2.16.840.1.113883.5.25","restricted"))
	Set tCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New("T-15750", "2.16.840.1.113883.6.96", "Ankle joint")
	Do tDoc.EventCodeList.Insert(tCodedValue)
	//()
	Set tDoc.HomeCommunityId = $$$HomeCommunityOID
	Set tSC = tUpdate3.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Do tUpdate3.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate3.UpdateAssociations()
	//Set tUpdate1.Associations.GetAt(1).AssociationPropagation="no"
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate3,.tUpdateResponse) 
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error") tSC
 	Quit:'$$$AssertTrue($IsObject(tUpdateResponse)&&(tUpdateResponse.ContentStream.Read()["Success")) $$$ERROR($$$GeneralError,"Failed Update 3")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-92",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)

    Set tQRequest.QueryType="GetDocuments"
	//Do tQRequest.AddPatientId(pAPResponse1.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQRequest.AddParam(tDoc.LogicalUUID,"$XDSDocumentEntryLogicalID")
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse2)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
    Quit:'$$$AssertTrue(tQResponse2.Documents.Count()=1 && (tQResponse2.Errors.Errors.Count()=0),"Single Document located")

    Set tDoc = tQResponse2.Documents.GetAt(1)
    If '$$$AssertTrue(tDoc.ConfidentialityCode.GetAt(1).Code ="R")
    Set tFound=0
    For tIdx = 1:1:tDoc.EventCodeList.Count() {
        Set tEvent = tDoc.EventCodeList.GetAt(tIdx)
        If tEvent.Code = "T-15750" && (tEvent.Scheme="2.16.840.1.113883.6.96") {
            Set tFound=1
        }
    }
    If '$$$AssertTrue(tFound,"Found event list item")

    Quit $$$OK
}

Method Test300ConnectathonSubmissions()
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	$$$HSTestBailout
	Do ..XDSReset(1)  /// static ID's so the documents need to be cleared
	Set tHighAuditID = ..FindHighAuditID()
    Set tSC = ..addRMU1000(.tAPResponse1,.tAPResponse2) Quit:$$$ISERR(tSC)
	Quit:'$$$AssertTrue(tAPResponse1.ErrStatus=""||(tAPResponse1.ErrStatus=$$$OK),"Patient 1000 added without error")
	Quit:'$$$AssertTrue(tAPResponse2.ErrStatus=""||(tAPResponse2.ErrStatus=$$$OK),"Patient 1003 added without error")

    Set tSC = ..addDocuments1000And1003(tAPResponse1,tAPResponse2,.tMeta1,.tMeta2,.tMeta3)

    Set tSC = ..updatePatient1003(tAPResponse2,.tMeta3)

    Set tSC = ..updatePatient1000Sub1(tAPResponse1,.tMeta1)
	Set tSC = ..updatePatient1000Sub2(tAPResponse1,.tMeta2)
}

/// Attempt to change DocumentEntry.availabilityStatus from Approved to Deprecated. Update Responder does not perform the update and should return error code: UnmodifiableMetadataError.
Method Test400Errors()
{
    Set tSC = ..addRMU1000(.tAPResponse1,.tAPResponse2) 
    Quit:'$$$AssertStatusOK(tSC,"Failed to add patients")
    Do ..Errors400AvailabilityStatus(tAPResponse2)
    Do ..Errors400SourcePatientId(tAPResponse2)
    Do ..Errors400PatientIdAA(tAPResponse2)
    Do ..Errors400PreviousVersion(tAPResponse2)
}

/// Attempt to change DocumentEntry.availabilityStatus from Approved to Deprecated. Update Responder does not perform the update and should return error code: UnmodifiableMetadataError.
Method Errors400AvailabilityStatus(pAPResponse2)
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	#; Query for XDSb document patient 1003
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse2.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse1)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error") tSC
	Quit:'$$$AssertTrue(tQResponse1.Documents.Count()=1 && (tQResponse1.Errors.Errors.Count()=0),"Single Document located") $$$ERROR($$$GeneralError,"Not 1 doc")

	#; Update XDSb Document created above
	Set tDoc = tQResponse1.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	//Set tDoc.EntryUUID="DocUpdate1"
	Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).%New()
	Set tAssociation.ParentUUID=tUpdate1.EntryUUID
	Set tAssociation.ChildUUID=tDoc.LogicalUUID
	Set tAssociation.Type ="UpdateAvailabilityStatus"
	Set tAssociation.OriginalStatus="Approved"
	Set tAssociation.NewStatus="Deprecated"
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
    Do tUpdate1.Associations.Insert(tAssociation)   /// remove this line
	Do tUpdate1.UpdateAssociations()
	//Set tUpdate1.Associations.GetAt(1).AssociationPropagation="no"
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse) 
	Quit:'$$$AssertStatusOK(tSC,"Failure submission") tSC
	Quit:'$$$AssertTrue($IsObject(tUpdateResponse)&&(tUpdateResponse.ContentStream.Read()["Failure")) $$$ERROR($$$GeneralError,"Failed pnr2")
}

/// Attempt to update the value of DocumentEntry.sourcePatientId. The Update Responder does not perform the update and should return error code: UnmodifiableMetadataError.
Method Errors400SourcePatientId(pAPResponse2)
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	#; Query for XDSb document patient 1003
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse2.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse1)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error") tSC
	Quit:'$$$AssertTrue(tQResponse1.Documents.Count()=1 && (tQResponse1.Errors.Errors.Count()=0),"Single Document located") $$$ERROR($$$GeneralError,"Not 1 doc")

	#; Update XDSb Document created above
	Set tDoc = tQResponse1.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate1"
    Do tUpdate1.Documents.Insert(tDoc)
    Set tDoc.SourcePatientId="foo_"_tDoc.PatientId
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate1.UpdateAssociations()
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse)
    Quit:'$$$AssertStatusOK(tSC,"Failure submission") tSC
	Quit:'$$$AssertTrue($IsObject(tUpdateResponse)) $$$ERROR($$$GeneralError,"Failed update")
    Set tResponse = tUpdateResponse.ContentStream.Read()
    Quit:'$$$AssertTrue(tResponse["Failure" && (tResponse["UnmodifiableMetadataError")) $$$ERROR($$$GeneralError,"Incorrect response to update")
}

/// Attempt to update the value of DocumentEntry.confidentialityCode (an update-able atribute) However, the assigningAuthority value for DocumentEntry.patientId in the update request is different than the assigningAuthority value in the existing DocumentEntry. The Update Responder does not perform the update and should return error code: XDSPatientIDReconciliationError
Method Errors400PatientIdAA(pAPResponse2)
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	#; Query for XDSb document patient 1003
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse2.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse1)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error") tSC
	Quit:'$$$AssertTrue(tQResponse1.Documents.Count()=1 && (tQResponse1.Errors.Errors.Count()=0),"Single Document located") $$$ERROR($$$GeneralError,"Not 1 doc")

	#; Update XDSb Document created above
	Set tDoc = tQResponse1.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate1"
    Do tUpdate1.Documents.Insert(tDoc)
    Set tPID = tDoc.PatientId
    Set $p(tPID,"&",2)="1.2.3.4.5"
    Set tDoc.PatientId = tPID
	Set tUpdate1.PatientId = tPID
	Do tDoc.ConfidentialityCode.Clear()
	Do tDoc.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New("R","2.16.840.1.113883.5.25","restricted"))
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate1.UpdateAssociations()
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Failure submission") tSC
	Quit:'$$$AssertTrue($IsObject(tUpdateResponse)) $$$ERROR($$$GeneralError,"Failed update")
    Set tResponse = tUpdateResponse.ContentStream.Read()
    Quit:'$$$AssertTrue(tResponse["Failure" && (tResponse["XDSPatientIDReconciliationError")) $$$ERROR($$$GeneralError,"Incorrect response to update")
}

/// Attempt to updated the value of SubmissionSet.author (or other SubmissionSet attribute). The Update Responder does not perform the update and should return error code: XDSObjectTypeError.
Method Errors400SubmissionSetAuthor(pAPResponse2)
{
    Quit  /// unable to do this test because the message doesn't support folders or additional submission sets
}

/// Attempt to update the deprecated version of a DocumentEntry. The update request contains an SS-DE HasMember Association t and has a Slot with name PreviousVersion. The value of the PreviousVersion Slot does NOT match the version number of the existing DocumentEntry. The Update Responder does not perform the update and should return error code: XXDSMetadataVersionError
Method Errors400PreviousVersion(pAPResponse2)
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	#; Query for XDSb document patient 1003
	Set tQRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQRequest.AddPatientId(pAPResponse2.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tQRequest.QueryType="FindDocuments"
	Do tQRequest.AddStatusValues("Approved")
	Do tQRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQRequest,.tQResponse1)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error") tSC
	Quit:'$$$AssertTrue(tQResponse1.Documents.Count()=1 && (tQResponse1.Errors.Errors.Count()=0),"Single Document located") $$$ERROR($$$GeneralError,"Not 1 doc")

	#; Update XDSb Document created above
	Set tDoc = tQResponse1.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.RMU.DocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate1"
    Do tUpdate1.Documents.Insert(tDoc)
 	Do tDoc.ConfidentialityCode.Clear()
	Do tDoc.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New("R","2.16.840.1.113883.5.25","restricted"))
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Do tUpdate1.UpdateAssociations()
    Set tUpdate1.Associations.GetAt(1).PreviousVersion=1 
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Failure submission") tSC
	Quit:'$$$AssertTrue($IsObject(tUpdateResponse)) $$$ERROR($$$GeneralError,"Failed update")
    Set tResponse = tUpdateResponse.ContentStream.Read()
    Quit:'$$$AssertTrue(tResponse["Failure" && (tResponse["XDSMetadataVersionError")) $$$ERROR($$$GeneralError,"Incorrect response to update")
}

XData Items
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

  <Item Name="HS.IHE.XDSb.Registry.Services" Category="" ClassName="HS.IHE.XDSb.Registry.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbQueryTarget">HS.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterTarget">HS.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterOnDemandTarget">HS.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbUpdateDocumentSetTarget">HS.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbDeleteDocumentSetTarget">HS.IHE.XDSb.Registry.Operations</Setting>
	<Setting Target="Host" Name="RequireValidSAMLToken">1</Setting>
  </Item>
  <Item Name="HS.IHE.RMU.Initiator.Operations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

  
  <Item Name="HS.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">1</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XDSb.Repository</Setting>
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
	<Setting Target="Host" Name="PIXv3ConsumerOperations">HS.MPI.Manager</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Consumer.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName">Test.XDSb.Repository</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>

  <Item Name="HS.IHE.XDSb.Repository.Services" Category="" ClassName="HS.IHE.XDSb.Repository.Services" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbProvideAndRegisterTarget">HS.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="XDSbRetrieveTarget">HS.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="RequireValidSAMLToken">1</Setting>
  </Item>

<Item Name="HS.HC.IHE.RMU.Process" Category="" ClassName="HS.HC.IHE.RMU.Process" PoolSize="5" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
</Item>

<Item Name="HS.IHE.XDSb.Repository.Process" Category="" ClassName="HS.IHE.XDSb.Repository.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="RepositoryOperations">HS.IHE.XDSb.Repository.Operations</Setting>
<Setting Target="Host" Name="RegistryOperations">HS.IHE.XDSb.Repository.Operations</Setting>
</Item>

  <Item Name="HS.IHE.XDSb.Repository.Operations" Category="" ClassName="HS.IHE.XDSb.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
  <Item Name="HS.MPI.Manager" Category="" ClassName="HS.HC.MPI.Manager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  
  <Item Name="HS.IHE.XDSb.Administrator.Operations" Category="" ClassName="HS.IHE.XDSb.Administrator.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">Test.XDSb.Registry</Setting>
    <Setting Target="Host" Name="TraceOperations">1</Setting>
  </Item>
</Items>
}

XData AdditionalItems
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.MPI.Manager" Category="" ClassName="HS.HC.MPI.Manager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>

</Items>
}

XData OIDEntries
{
<Items>
<Item><OID>1.3.6.1.4.1.21367.2010.1.2.300.100</OID><IdentityCode>HSREGISTRY</IdentityCode><IdentityTypes><OIDType><Description>Repository</Description></OIDType></IdentityTypes></Item>
</Items>
}

XData RegistryEntries
{
<Items>
<!-- Registry / Repository -->
<WebService>
<Name>Test.XDSb.Registry</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.IHE.XDSb.Registry.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>Test.XDSb.Repository</Name>
<EndPoint>http://{HostAndPort}/csp/healthshare/{Namespace}/services/HS.IHE.XDSb.Repository.Services.cls</EndPoint>
<MTOM>1</MTOM>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>

</Items>
}

XData AdditionalOIDEntries
{
}

XData AdditionalRegistryEntries
{
}

XData ConnectathonPatient1Sub1
{
<lcm:SubmitObjectsRequest xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
    xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0">
    <rim:RegistryObjectList xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
        xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
        <rim:ExtrinsicObject id="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" mimeType="text/plain" objectType="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1">
            <rim:Slot name="urn:ihe:iti:xds:2013:referenceIdList">
                <rim:ValueList>
                    <rim:Value>2222-R^^^&amp;1.3.6.1.4.1.21367.13.202.1000&amp;ISO^urn:ihe:iti:xds:2013:referral</rim:Value>
                    <rim:Value>2222-O^^^&amp;1.3.6.1.4.1.21367.13.202.2000&amp;ISO^urn:ihe:iti:xds:2013:order</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="creationTime">
                <rim:ValueList>
                    <rim:Value>20181124</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="languageCode">
                <rim:ValueList>
                    <rim:Value>en-us</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="legalAuthenticator">
                <rim:ValueList>
                    <rim:Value>^Welby^Marcus^^^Dr^MD</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStartTime">
                <rim:ValueList>
                    <rim:Value>201811230800</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStopTime">
                <rim:ValueList>
                    <rim:Value>201811230900</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientId">
                <rim:ValueList>
                    <rim:Value>IHEFACILITY-1000^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientInfo">
                <rim:ValueList>
                    <rim:Value>PID-3|IHEFACILITY-1000^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                    <rim:Value>PID-5|Hon^Charles^^^</rim:Value>
                    <rim:Value>PID-7|19610131</rim:Value>
                    <rim:Value>PID-8|M</rim:Value>
                    <rim:Value>PID-11|3015 E Sagebrush^^Tucson^AZ^85712^USA</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="repositoryUniqueId">
                <rim:ValueList>
                    <rim:Value>1.3.6.1.4.1.21367.13.40.308</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="hash">
                <rim:ValueList>
                    <rim:Value>31e311402a7e717d1bede88df6b42c0b8e91ea91</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="size">
                <rim:ValueList>
                    <rim:Value>1459</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Name>
                <rim:LocalizedString value="RMU Title - Charles Hon - Id 1000 - Doc1"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="RMU Comments - Charles Hon - Id 1000 - Doc1"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_1" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Smitty^Gerald^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>Parma Community</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Attending</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Orthopedic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_2" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Dopplemeyer^Sherry^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>Cleveland Clinic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Primary Surgeon</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Orthopedic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_3" nodeRepresentation="SUMMARY" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.19376.1.2.6.1</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Summary"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_4" nodeRepresentation="N" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.5.25</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="normal"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_5" nodeRepresentation="urn:ihe:pcc:xds-ms:2007" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.19376.1.2.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="XDS Medical Summaries"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_6" nodeRepresentation="35971002" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Ambulatory care site"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_7" nodeRepresentation="R-30254" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="General Medicine"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_8" nodeRepresentation="T-D9200" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Knee"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983" classifiedObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" id="id_9" nodeRepresentation="18842-5" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.1</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Discharge summary"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_10" identificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_11" identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e" value="1.2.42.20200120112333.590">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:ExtrinsicObject>
        <rim:RegistryPackage id="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:RegistryPackage">
            <rim:Slot name="submissionTime">
                <rim:ValueList>
                    <rim:Value>20181225235050</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Name>
                <rim:LocalizedString value="Physical"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="Annual physical"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:a7058bb9-b4e4-4307-ba5b-e3f0ab85e12d" classifiedObject="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" id="id_12" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Dopplemeyer^Sherry^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>Cleveland Clinic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Primary Surgeon</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Orthopedic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:aa543740-bdda-424e-8c96-df4873be8500" classifiedObject="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" id="id_13" nodeRepresentation="394747008" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Health Authority"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_14" identificationScheme="urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" value="1.2.42.20200120112333.591">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_15" identificationScheme="urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" value="1.3.6.1.4.1.21367.4">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.sourceId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_16" identificationScheme="urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:RegistryPackage>
        <rim:Classification classificationNode="urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd" classifiedObject="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" id="urn:uuid:eef99c3f-685e-4325-838d-e7302a13d0be" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:88bc53de-b382-4e21-94f8-903d432b54e3" sourceObject="urn:uuid:3709c076-4a53-4062-935b-cb385de28135" targetObject="urn:uuid:448eaa67-e376-4778-b0f2-ea24a335da8e">
            <rim:Slot name="SubmissionSetStatus">
                <rim:ValueList>
                    <rim:Value>Original</rim:Value>
                </rim:ValueList>
            </rim:Slot>
        </rim:Association>
    </rim:RegistryObjectList>
</lcm:SubmitObjectsRequest>
}

XData ConnectathonPatient1Sub2
{
<lcm:SubmitObjectsRequest xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
    xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0">
    <rim:RegistryObjectList xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
        xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
        <rim:ExtrinsicObject id="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" mimeType="text/plain" objectType="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1">
            <rim:Slot name="creationTime">
                <rim:ValueList>
                    <rim:Value>20181126</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="languageCode">
                <rim:ValueList>
                    <rim:Value>en-us</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStartTime">
                <rim:ValueList>
                    <rim:Value>201812260800</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStopTime">
                <rim:ValueList>
                    <rim:Value>201812260816</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientId">
                <rim:ValueList>
                    <rim:Value>IHEFACILITY-1000^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientInfo">
                <rim:ValueList>
                    <rim:Value>PID-3|IHEFACILITY-1000^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                    <rim:Value>PID-5|Hon^Charles^^^</rim:Value>
                    <rim:Value>PID-7|19610131</rim:Value>
                    <rim:Value>PID-8|M</rim:Value>
                    <rim:Value>PID-11|3015 E Sagebrush^^Tucson^AZ^85712^USA</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="repositoryUniqueId">
                <rim:ValueList>
                    <rim:Value>1.3.6.1.4.1.21367.13.40.308</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="hash">
                <rim:ValueList>
                    <rim:Value>9bfe835f036c95397a0783a1d6babd6a54869f46</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="size">
                <rim:ValueList>
                    <rim:Value>23</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Name>
                <rim:LocalizedString value="RMU Title - Charles Hon - Id 1000 - Prescription in Folder"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="RMU Comments - Charles Hon - Id 1000 - Prescription in Folder"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_1" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Dopplemeyer^Sherry^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>Cleveland Clinic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Primary Surgeon</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Orthopedic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_2" nodeRepresentation="PRESCRIPTIONS" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.19376.1.2.6.1</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Prescribed Treatments and Diagnoses"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_3" nodeRepresentation="N" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.5.25</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="normal"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_4" nodeRepresentation="urn:ihe:pharm:pre:2010" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.19376.1.2.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Pharmacy Pre"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_5" nodeRepresentation="264372000" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Pharmacy"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_6" nodeRepresentation="R-3027B" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="General Medicine"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_7" nodeRepresentation="T-15001" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Joint"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983" classifiedObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" id="id_8" nodeRepresentation="57833-6" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.1</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Prescription for medication Document"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_9" identificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_10" identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f" value="1.2.42.20200120112333.592">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:ExtrinsicObject>
        <rim:ExtrinsicObject id="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" mimeType="text/plain" objectType="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1">
            <rim:Slot name="creationTime">
                <rim:ValueList>
                    <rim:Value>20181126</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="languageCode">
                <rim:ValueList>
                    <rim:Value>en-us</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStartTime">
                <rim:ValueList>
                    <rim:Value>201812260800</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStopTime">
                <rim:ValueList>
                    <rim:Value>201812260816</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientId">
                <rim:ValueList>
                    <rim:Value>IHEFACILITY-1000^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientInfo">
                <rim:ValueList>
                    <rim:Value>PID-3|IHEFACILITY-1000^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                    <rim:Value>PID-5|Hon^Charles^^^</rim:Value>
                    <rim:Value>PID-7|19610131</rim:Value>
                    <rim:Value>PID-8|M</rim:Value>
                    <rim:Value>PID-11|3015 E Sagebrush^^Tucson^AZ^85712^USA</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="repositoryUniqueId">
                <rim:ValueList>
                    <rim:Value>1.3.6.1.4.1.21367.13.40.308</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="hash">
                <rim:ValueList>
                    <rim:Value>8bbd20ec8db50bd2b29cf14471699d8d75ba3e07</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="size">
                <rim:ValueList>
                    <rim:Value>3638</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Name>
                <rim:LocalizedString value="RMU Title - Charles Hon - Id 1000 - Privacy Consent Doc in Folder"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="RMU Comments - Charles Hon - Id 1000 - Privacy Consent Doc in Folder"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_11" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Dopplemeyer^Sherry^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>Cleveland Clinic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Primary Surgeon</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Orthopedic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_12" nodeRepresentation="Consent" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.21367.2017.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Consent"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_13" nodeRepresentation="N" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.5.25</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="normal"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_14" nodeRepresentation="urn:ihe:iti:bppc:2007" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.19376.1.2.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Basic Patient Privacy Consents"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_15" nodeRepresentation="264372000" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Pharmacy"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_16" nodeRepresentation="Practice-L" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.21367.2017.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Other"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_17" nodeRepresentation="urn:connectathon:bppc:foundational:policy" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.21367.2017.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Foundational Connectathon Read-Access Policy"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_18" nodeRepresentation="urn:connectathon:policy:full-access" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.21367.2017.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="FULL ACCESS TO ALL POLICY"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983" classifiedObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" id="id_19" nodeRepresentation="57016-8" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.1</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Privacy Policy Acknowledgement Document"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_20" identificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_21" identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36" value="1.2.42.20200120112333.593">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:ExtrinsicObject>
        <rim:RegistryPackage id="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:RegistryPackage">
            <rim:Slot name="submissionTime">
                <rim:ValueList>
                    <rim:Value>201812270800</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Name>
                <rim:LocalizedString value="Post-surgery Prescription SS Title"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="Post-surgery Prescription SS Comments"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:a7058bb9-b4e4-4307-ba5b-e3f0ab85e12d" classifiedObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" id="id_22" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Dopplemeyer^Sherry^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>Cleveland Clinic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Primary Surgeon</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Orthopedic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:aa543740-bdda-424e-8c96-df4873be8500" classifiedObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" id="id_23" nodeRepresentation="264372000" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Pharmacy"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_24" identificationScheme="urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" value="1.2.42.20200120112333.594">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_25" identificationScheme="urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" value="1.3.6.1.4.1.21367.4">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.sourceId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_26" identificationScheme="urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:RegistryPackage>
        <rim:RegistryPackage id="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:RegistryPackage">
            <rim:Name>
                <rim:LocalizedString value="RMU Folder"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="RMU comments go here"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5" classifiedObject="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067" id="id_27" nodeRepresentation="Referrals" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.21367.2017.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Prescriptions"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_28" identificationScheme="urn:uuid:75df8f67-9973-4fbe-a900-df66cefecc5a" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067" value="1.2.42.20200120112333.595">
                <rim:Name>
                    <rim:LocalizedString value="XDSFolder.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_29" identificationScheme="urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSFolder.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:RegistryPackage>
        <rim:Classification classificationNode="urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd" classifiedObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" id="urn:uuid:fbf51ca5-f3a2-443d-8e32-ad19a790d931" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"/>
        <rim:Classification classificationNode="urn:uuid:d9d542f3-6cc4-48b6-8870-ea235fbc94c2" classifiedObject="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067" id="urn:uuid:44876ac0-2507-4644-b418-926ab62c39dd" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:d2ff3509-9dbb-4549-a911-f5b11c6b8450" sourceObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" targetObject="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:88ff0f47-dda2-4968-94ba-92bea0110a1d" sourceObject="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067" targetObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:fd9f5f16-335e-4162-bafb-fe7fe9327b50" sourceObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" targetObject="urn:uuid:88ff0f47-dda2-4968-94ba-92bea0110a1d"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:615f5ac8-3292-4518-899e-a7a2a3ff6a49" sourceObject="urn:uuid:bb0d6a6f-d0d2-47a7-811a-cc3e20a54067" targetObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:115fcb3d-4a46-4210-815d-91942eb75212" sourceObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" targetObject="urn:uuid:615f5ac8-3292-4518-899e-a7a2a3ff6a49"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:843cc04c-5d41-4db3-afc6-af667cecb498" sourceObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" targetObject="urn:uuid:06ef1b04-a7ee-43d2-a74c-bf25b8088d6f">
            <rim:Slot name="SubmissionSetStatus">
                <rim:ValueList>
                    <rim:Value>Original</rim:Value>
                </rim:ValueList>
            </rim:Slot>
        </rim:Association>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:55ca609d-9aba-47fc-a8b3-c9af3be8a5b1" sourceObject="urn:uuid:1e557855-be16-425f-be37-ebcd49d8bac8" targetObject="urn:uuid:769071df-b997-49bb-af7d-9a01aa49ec36">
            <rim:Slot name="SubmissionSetStatus">
                <rim:ValueList>
                    <rim:Value>Original</rim:Value>
                </rim:ValueList>
            </rim:Slot>
        </rim:Association>
    </rim:RegistryObjectList>
</lcm:SubmitObjectsRequest>
}

XData ConnectathonPatient2Sub1
{
<lcm:SubmitObjectsRequest xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" 
    xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0">
    <rim:RegistryObjectList xmlns="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" 
        xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
        <rim:ExtrinsicObject id="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" mimeType="text/plain" objectType="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1">
            <rim:Slot name="urn:ihe:iti:xds:2013:referenceIdList">
                <rim:ValueList>
                    <rim:Value>3333-R^^^&amp;1.3.6.1.4.1.21367.13.202.1000&amp;ISO^urn:ihe:iti:xds:2013:referral</rim:Value>
                    <rim:Value>3333-O^^^&amp;1.3.6.1.4.1.21367.13.202.2000&amp;ISO^urn:ihe:iti:xds:2013:order</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="creationTime">
                <rim:ValueList>
                    <rim:Value>20170110</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="languageCode">
                <rim:ValueList>
                    <rim:Value>en-us</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="legalAuthenticator">
                <rim:ValueList>
                    <rim:Value>^Lopez^Anna^^^^MD</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStartTime">
                <rim:ValueList>
                    <rim:Value>201701102200</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="serviceStopTime">
                <rim:ValueList>
                    <rim:Value>201701102217</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientId">
                <rim:ValueList>
                    <rim:Value>IHEFACILITY-1003^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="sourcePatientInfo">
                <rim:ValueList>
                    <rim:Value>PID-3|IHEFACILITY-1003^^^&amp;1.3.6.1.4.1.21367.3000.1.6&amp;ISO</rim:Value>
                    <rim:Value>PID-5|Smith^Albert^^^</rim:Value>
                    <rim:Value>PID-7|19601231</rim:Value>
                    <rim:Value>PID-8|M</rim:Value>
                    <rim:Value>PID-11|60 N Saguaro^^Tucson^AZ^85701^USA</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="repositoryUniqueId">
                <rim:ValueList>
                    <rim:Value>1.3.6.1.4.1.21367.13.40.308</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="hash">
                <rim:ValueList>
                    <rim:Value>31e311402a7e717d1bede88df6b42c0b8e91ea91</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Slot name="size">
                <rim:ValueList>
                    <rim:Value>1459</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Name>
                <rim:LocalizedString value="RMU Title - Albert Smith - Id 1003 - Doc1"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="RMU Comments - Albert Smith - Id 1003 - Doc1"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_1" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Smitty^Gerald^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>Parma Community</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Attending</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Orthopedic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_2" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Shah^Kendra^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>ABC Clinic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Referring</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Oncology</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_3" nodeRepresentation="PLANS" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.19376.1.2.6.1</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Treatment Plan or Protocol"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_4" nodeRepresentation="N" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.5.25</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="normal"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_5" nodeRepresentation="urn:ihe:pcc:crc:2008" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.19376.1.2.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Cancer Registry Content (CRC)"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_6" nodeRepresentation="22232009" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Hospital"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_7" nodeRepresentation="Practice-L" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>1.3.6.1.4.1.21367.2017.3</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Other"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_8" nodeRepresentation="T-28000" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Lung"/>
                </rim:Name>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983" classifiedObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" id="id_9" nodeRepresentation="56447-6" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.1</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Plan of Care Note"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_10" identificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_11" identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014" value="1.2.42.20200120112333.596">
                <rim:Name>
                    <rim:LocalizedString value="XDSDocumentEntry.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:ExtrinsicObject>
        <rim:RegistryPackage id="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:RegistryPackage">
            <rim:Slot name="submissionTime">
                <rim:ValueList>
                    <rim:Value>20171225235050</rim:Value>
                </rim:ValueList>
            </rim:Slot>
            <rim:Name>
                <rim:LocalizedString value="RMU Submission 1003"/>
            </rim:Name>
            <rim:Description>
                <rim:LocalizedString value="RMU Submission 1003"/>
            </rim:Description>
            <rim:Classification classificationScheme="urn:uuid:a7058bb9-b4e4-4307-ba5b-e3f0ab85e12d" classifiedObject="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" id="id_12" nodeRepresentation="" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="authorPerson">
                    <rim:ValueList>
                        <rim:Value>^Shah^Kendra^^^</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorInstitution">
                    <rim:ValueList>
                        <rim:Value>ABC Clinic</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorRole">
                    <rim:ValueList>
                        <rim:Value>Referring</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Slot name="authorSpecialty">
                    <rim:ValueList>
                        <rim:Value>Oncology</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
            </rim:Classification>
            <rim:Classification classificationScheme="urn:uuid:aa543740-bdda-424e-8c96-df4873be8500" classifiedObject="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" id="id_13" nodeRepresentation="394747008" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification">
                <rim:Slot name="codingScheme">
                    <rim:ValueList>
                        <rim:Value>2.16.840.1.113883.6.96</rim:Value>
                    </rim:ValueList>
                </rim:Slot>
                <rim:Name>
                    <rim:LocalizedString value="Health Authority"/>
                </rim:Name>
            </rim:Classification>
            <rim:ExternalIdentifier id="id_14" identificationScheme="urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" value="1.2.42.20200120112333.597">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.uniqueId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_15" identificationScheme="urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" value="1.3.6.1.4.1.21367.4">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.sourceId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
            <rim:ExternalIdentifier id="id_16" identificationScheme="urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:ExternalIdentifier" registryObject="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" value="{$expression{%PatientID}}">
                <rim:Name>
                    <rim:LocalizedString value="XDSSubmissionSet.patientId"/>
                </rim:Name>
            </rim:ExternalIdentifier>
        </rim:RegistryPackage>
        <rim:Classification classificationNode="urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd" classifiedObject="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" id="urn:uuid:c50da50f-66bf-4c77-900e-b971c55f7a6d" objectType="urn:oasis:names:tc:ebxml-regrep:ObjectType:RegistryObject:Classification"/>
        <rim:Association associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" id="urn:uuid:4fa8ac45-b00c-412f-8d94-9da2eaaa2a44" sourceObject="urn:uuid:cf9c962c-5b30-4abc-9fd5-e5a8c3bd449d" targetObject="urn:uuid:1ed8477b-26e5-41c5-a0c0-c57912b6c014">
            <rim:Slot name="SubmissionSetStatus">
                <rim:ValueList>
                    <rim:Value>Original</rim:Value>
                </rim:ValueList>
            </rim:Slot>
        </rim:Association>
    </rim:RegistryObjectList>
</lcm:SubmitObjectsRequest>
}

}
