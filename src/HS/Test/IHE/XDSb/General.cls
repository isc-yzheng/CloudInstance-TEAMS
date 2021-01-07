/// General test for XDSb Provide and Query
/// Add 3 patients 
/// Provide 5 documents, 1, 1 1, 2
/// Issue various queries 
Class HS.Test.IHE.XDSb.General Extends HS.Test.IHE.XDSb.Base
{

Method Test100Setup()
{
	Do:##class(HS.Data.OIDMap).GetOIDForCode($namespace)="" ##class(HS.Data.OIDMap).FileOID($NAMESPACE,"Repository","2.16.840.1.113883.3.86.3.19998")
	Set tSC = ..Setup()
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	Do ..XDSReset()
	Do ##class(HS.Data.OIDMap).FileOID("ISC","AssigningAuthority","2.16.840.1.113883.3.86.3")
	// if there is no oid for this namespace, define it (the OID becomes the repository OID)
	$$$HSTestBailout
}

/// Add Patient with MPIID 7777777
Method Test120AddPatient1()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="John"
	Set tRequest.LastName="Smith"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1980-09-30")
	Set tRequest.MRN="A7777777"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tRequest.MPIID="7777777"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient7777777")
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")
}

/// Add Patient with MPIID 8888888
Method Test140AddPatient2()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Jane"
	Set tRequest.LastName="Smith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1980-10-15")
	Set tRequest.MRN="A8888888"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tRequest.MPIID="8888888"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient8888888")
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")
}

/// Add Patient with MPIID 8888888
Method Test160AddPatient3()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Jack"
	Set tRequest.LastName="Black"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1976-11-15")
	Set tRequest.MRN="A9999999"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tRequest.MPIID="9999999"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient9999999")
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")
}

/// This patient should only be used by AddDocumentAndFolderJeffSmith
Method Test180AddPatientJeffSmith()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Jeff"
	Set tRequest.LastName="Smith"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1976-1-15")
	Set tRequest.MRN="AJeffSmith"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tRequest.MPIID="JeffSmith"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatientJeffSmith")
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")
}

/// Add a document for patient 1
Method Test200AddDocument1()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	#; don't assign the patient id let the system look it up from the cda
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Set tRequest.Title = "Submission Set Title"
	Set tRequest.Comments = "Submission Set Comments"
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument1",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.SourcePatientId="A7777777^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO"
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	Set tDocument.UniqueId=tDocument.UniqueId_"^TESTEXTENSIONVALUE"
	Set tCustomSlot = ##class(HS.IHE.XDSb.Types.Slot).%New()
	Set tCustomSlot.Name="urn:TestSlot"
	Set $P(tString,"VeryLongString",700)=""
	Do tCustomSlot.ValueList.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tString))
	Do tDocument.DocumentSlots.Insert(tCustomSlot) 

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")

	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ResponseStatusType:Success","Document added successfully")

	Set tQueryRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tQueryRequest.QueryType="GetSubmissionSets"
	Do tQueryRequest.AddSingleParam("urn:uuid:"_tDocument.EntryUUID,"$uuid")
	Do tQueryRequest.AdditionalInfo.SetAt($$$CurrentMethod_tQueryRequest.QueryType,"Caller")
	Do tQueryRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQueryRequest,.tQueryResponse)
	Quit:'$$$AssertStatusOK(tSC,"Sent query request for Document Entry UUID")
	Quit:'$$$AssertTrue(tQueryResponse.Submissions.Count()=1,"Found submission set")
	Set tSubmission = tQueryResponse.Submissions.GetAt(1)
	Quit:'$$$AssertTrue(tSubmission.Title="Submission Set Title","Title correctly set")
	Quit:'$$$AssertTrue(tSubmission.Comments="Submission Set Comments","Comments correctly set")
}

/// Add a document for patient 2
Method Test220AddDocument2()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.PatientId="8888888^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")

	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument2",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 8888888")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["Success","Document added successfully")
}

/// Add a documents for patient 3
Method Test240AddDocument3()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.PatientId="9999999^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")

	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument3",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")

	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tDocument.PatientId=tRequest.PatientId
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument3",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
	Set tDocument.SourcePatientId="B9999999^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO"
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added 2 Documents to Patient 9999999")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["Success","Documents added successfully")
}

/// Add a documents for patient 3
Method Test260AddDocumentMultiAddress()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.PatientId="9999999^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")

	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDMultiAddress",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added 2 Documents to Patient 9999999")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["Success","Documents added successfully")
}

Method Test280TwoSubmit() As %Status
{
	$$$HSTestBailout
	Set tMessage=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tMessage.EntryUUID="Submission1"
	Set tMessage.PatientId="7777777^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tMessage.SourceId=##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")
	Set tMessage.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Set tDocument.EntryUUID="Document1"
	Do tDocument.Body.Write("Hello World")
	Set tDocument.Hash=$zcvt(##class(HS.IHE.XDSb.Util).StreamHash(tDocument.Body),"U")
	set author = ##class(HS.Types.IHE.XDSb.Author).%New()
	Set author.EntryUUID="MyAuthor"
    set author.AuthorPerson = "^Welby^Marcus^^MD^Dr"
    Set author.AuthorInstitution="Some Hospital^^^^^^^^^1.2.3.5.8.9.1789.45"
	set tSC= tDocument.Author.Insert(author)
	do tMessage.Author.Insert(author)
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))

	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
	///
	Set tDocument.LanguageCode="en-US"
	Set tDocument.SourcePatientId="4ee29b626a8d4c4^^^&"_tMessage.SourceId_"&ISO"
	
	///
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-3|"_tDocument.SourcePatientId))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-5|Vargas^Josiah^"))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|19810109"))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-8|M"))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-11|123 Main St^^Rosemont^Il^60018"))

	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	/// again optionally supply the author
	set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New()
	Set tAuthor.EntryUUID="MyAuthorS"
    set tAuthor.AuthorPerson = "^Welby^Marcus^^MD^Dr"
    Set tAuthor.AuthorInstitution="Some Hospital^^^^^^^^^1.2.3.5.8.9.1789.45"
    Do tAuthor.AuthorSpecialty.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Specialty"))
	Do tMessage.Author.Insert(tAuthor)

	Do tMessage.Documents.Insert(tDocument)
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	For i=1,2 {
		// ensure a unique submission set id for each submission
		Set tMessage.EntryUUID=##class(HS.Util.XSLTHelper).createUUID()
		Set tMessage.UniqueId = ##class(HS.Util.XSLTHelper).uuid2oid(tMessage.EntryUUID)
		Set tSC = ##class(HS.Test.Service).SendSync(tMessage,.tResponse)
		Quit:'$$$AssertStatusOK(tSC,"Added Document to Patient 7777777")
		Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["Success","Document added successfully")
	}
	Quit $$$OK
}

Method Test300TwoSubmitIdenticalUUID() As %Status
{
	$$$HSTestBailout
	Set tMessage=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tMessage.EntryUUID="Submission1"
	Set tMessage.PatientId="7777777^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tMessage.SourceId=##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")
	Set tMessage.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tDocument.Body.Write("Hello World")
	Set tDocument.Hash=$zcvt(##class(HS.IHE.XDSb.Util).StreamHash(tDocument.Body),"U")
	set author = ##class(HS.Types.IHE.XDSb.Author).%New()
	Set author.EntryUUID="MyAuthor"
    set author.AuthorPerson = "^Welby^Marcus^^MD^Dr"
    Set author.AuthorInstitution="Some Hospital^^^^^^^^^1.2.3.5.8.9.1789.45"
	set tSC= tDocument.Author.Insert(author)
	do tMessage.Author.Insert(author)
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))

	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
	///
	Set tDocument.LanguageCode="en-US"
	Set tDocument.SourcePatientId="4ee29b626a8d4c4^^^&"_tMessage.SourceId_"&ISO"
	
	///
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-3|"_tDocument.SourcePatientId))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-5|Vargas^Josiah^"))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|19810109"))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-8|M"))
	d tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-11|123 Main St^^Rosemont^Il^60018"))

	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	/// again optionally supply the author
	set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New()
	Set tAuthor.EntryUUID="MyAuthorS"
    set tAuthor.AuthorPerson = "^Welby^Marcus^^MD^Dr"
    Set tAuthor.AuthorInstitution="Some Hospital^^^^^^^^^1.2.3.5.8.9.1789.45"
    Do tAuthor.AuthorSpecialty.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Specialty"))
	Do tMessage.Author.Insert(tAuthor)

	Do tMessage.Documents.Insert(tDocument)
	
	Do tMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tMessage,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document to Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["Success","Document added successfully")

	Set tSC = ##class(HS.Test.Service).SendSync(tMessage,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Submitted Document to Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["Failure","Document failed properly")

	Set tDoc=##class(HS.Message.IHE.XDSb.Document).%New()
	Set tDoc.RepositoryUniqueId=##class(HS.Data.OIDMap).GetOIDForCode($namespace)
	Set tDoc.UniqueId=tDocument.UniqueId
	Set obj=##class(HS.Message.IHE.XDSb.RetrieveRequest).%New()
	Do obj.Documents.Insert(tDoc)
	Do obj.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(obj,.rr)
	Quit:'$$$AssertStatusOK(tSC,"Submitted Retrieve Request")
	Quit:'$$$AssertTrue(rr.Documents.Count()=1,"Retrieved 1 document")
	
	Quit $$$OK
}

/// Add a document for patient 1 no document unique id
Method Test320AddDocumentNoDocumentUniqueId()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	#; don't assign the patient id let the system look it up from the cda
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument1",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
	Set tDocument.UniqueId=""
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.SourcePatientId="A7777777^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO"
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ErrorSeverityType:Error","Document failed properly")
}

/// Add a document for patient 1
Method Test340AddDocumentNoSubmissionUniqueId()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	#; don't assign the patient id let the system look it up from the cda
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Set tRequest.UniqueId=""
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument1",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.SourcePatientId="A7777777^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO"
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ErrorSeverityType:Error","Document failed properly")
}

Method Test360AddInvalidSourceOID()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.PatientId="8888888^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")

	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument2",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.SourcePatientId="A7777777^^^&1.0.0.0.0.0.0.0&ISO"
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 8888888")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ErrorSeverityType:Error","Document failed properly")
}

Method Test380AddInvalidSourcePatientIDFormat()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	#; don't assign the patient id let the system look it up from the cda
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument1",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.SourcePatientId="A7777777^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_""
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ErrorSeverityType:Error","Document failed properly")
}

/// patient id contains extra & at the end
Method Test400AddInvalidPatientIDFormat()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.PatientId="8888888^^^&"_$$$AffinityDomainOID_"&ISO&"
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")

	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument2",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 8888888")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ErrorSeverityType:Error","Document failed properly")
}

Method Test420AddFolder()
{
	$$$HSTestBailout

	Set tSearchCodeValue=##class(HS.IHE.XDSb.Types.CodedValue).%New("Alergy Treatments","Connect-a-thon folderCodeList","Alergy Treatments")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindFoldersMultiPatients"
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSFolderCodeList",tSearchCodeValue.Code,tSearchCodeValue.Scheme))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	Set tExistingFolderCount = tResponse.Folders.Count()
	Set sec=$zts,sec=sec*86400+$p(sec,",",2) - 15 // 15 seconds ago
	Set tSearchTimeTo = $tr($zdt((sec\86400)_","_(sec#86400),8)," :")

	// Create the message, which automatically assigns a document unique ID
	Set tRequest=##class(HS.Message.IHE.XDSb.RegisterRequest).%New()
	Set tPatientID="7777777^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest.PatientId = tPatientID
	Set tRequest.SourceId = "1.3.6.1.4.1.21367.1"
	Set tRequest.Language="en-CA"


	// Create a instance to hold the folder metadata
	Set tFolder = ##class(HS.Message.IHE.XDSb.Folder).%New()
	// Insert the folder metadata into the message
	Do tRequest.Folders.Insert(tFolder)

	Set tFolder.PatientId = tPatientID
	Set tFolder.Title = "FOLDER"
	Set tFolder.Comments = "Comments"
	Set tFolder.AvailabilityStatus = "Approved"

	Do tFolder.CodeList.Insert(tSearchCodeValue)
	Set tCodeValue=##class(HS.IHE.XDSb.Types.CodedValue).%New("Referrals","Connect-a-thon folderCodeList","Referrals")
	Do tFolder.CodeList.Insert(tCodeValue)
	Set tCodeValue=##class(HS.IHE.XDSb.Types.CodedValue).%New("Transfer of care referral","Connect-a-thon contentTypeCodes","Transfer of care referral")
	Set tRequest.ContentTypeCode=tCodeValue

	// Send the message to the test service (or directly to HS.IHE.XDSb.DocumentSource.Operations)
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC=##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ResponseStatusType:Success","Folder added successfully")

	/// now locate submitted folder
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindFolders"
	Do tRequest.AddPatientId(tPatientID,"$XDSFolderPatientId")
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Set sec=$zts,sec=sec*86400+$p(sec,",",2) - 15  // 15 seconds ago
	Set tm = $tr($zdt((sec\86400)_","_(sec#86400),8)," :")
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tm,"$XDSFolderLastUpdateTimeFrom"))
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSFolderCodeList",tSearchCodeValue.Code,tSearchCodeValue.Scheme))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	Quit:'$$$AssertTrue(tResponse.Folders.Count()=1,"Query should return 1 folder")
	/// 
	/// multi patient	
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindFoldersMultiPatients"
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSFolderCodeList",tSearchCodeValue.Code,tSearchCodeValue.Scheme))
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tSearchTimeTo,"$XDSFolderLastUpdateTimeTo"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	Quit:'$$$AssertTrue(tResponse.Folders.Count()=tExistingFolderCount,"Query should return the count of the folders before adding one")
}

Method Test440AddDocumentAndFolderJeffSmith()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tPatientID="JeffSmith^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddPatientId(tPatientID)
	Do tRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	If tResponse.Documents.Count()>0 Quit:$$$AssertTrue(tResponse.Documents.Count(),"Test already Completed")
	#; if we have documents the test has already been run - don't run again

	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.PatientId=tPatientID
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")

	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument1",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.SourcePatientId="A7777777^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO"
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	// Create a instance to hold the folder metadata
	Set tFolder = ##class(HS.Message.IHE.XDSb.Folder).%New()
	// Insert the folder metadata into the message
	Do tRequest.Folders.Insert(tFolder)
	Set tFolder.PatientId = tPatientID
	Set tFolder.Title = "FOLDER"
	Set tFolder.Comments = "Comments"
	Set tFolder.AvailabilityStatus = "Approved"
	Set tCodeValue=##class(HS.IHE.XDSb.Types.CodedValue).%New("Alergy Treatments","Connect-a-thon folderCodeList","Alergy Treatments")
	Do tFolder.CodeList.Insert(tCodeValue)
	Set tCodeValue=##class(HS.IHE.XDSb.Types.CodedValue).%New("Referrals","Connect-a-thon folderCodeList","Referrals")
	Do tFolder.CodeList.Insert(tCodeValue)
	Set tCodeValue=##class(HS.IHE.XDSb.Types.CodedValue).%New("Transfer of care referral","Connect-a-thon contentTypeCodes","Transfer of care referral")
	Set tRequest.ContentTypeCode=tCodeValue
	Set tAssociations = ##class(HS.Message.IHE.XDSb.Association).%New()
	Set tAssociations.Type = "HasMember"
	Set tAssociations.ParentUUID=tFolder.EntryUUID
	Set tAssociations.ChildUUID=tDocument.EntryUUID
	Do tRequest.Associations.Insert(tAssociations)


	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document and folder Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ResponseStatusType:Success","Document added successfully")
}

Method Test460FindDocuments()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tRequest.AddDocumentType(3)  /// Both ondemand and stable
	#; lookup two format codes
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName="$XDSDocumentEntryFormatCode"
	Do tItem.CodedValues.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88",""))
	Do tItem.CodedValues.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("2.16.840.1.113883.10.20.1","YSP",""))
	Do tRequest.Parameters.Insert(tItem)
	#; querying single values
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryClassCode","Summarization of episode","Connect-a-thon classCodes"))
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryHealthcareFacilityTypeCode","Outpatient","Connect-a-thon healthcareFacilityTypeCodes"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Documents located")

	// lookup by uniqueid
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tRequest.AddDocumentType(1)  /// stable
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName="$XDSDocumentEntryUniqueId"
	Do tItem.Values.Insert(tResponse.Documents.GetAt(1).UniqueId)
	Do tItem.Values.Insert("111.1111.1111")
	Do tRequest.Parameters.Insert(tItem)
	#; querying single values
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Documents located")
}

/// A find documents multi patient specifying the patient ids
Method Test480FindDocumentsMultiPatientsByPatient()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindDocumentsMultiPatients"

	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName="$XDSDocumentEntryPatientId"
	Do tItem.Values.Insert("8888888^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tItem.Values.Insert("7777777^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tItem.SingleValue=0
	Do tRequest.Parameters.Insert(tItem)
	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AddCreationFrom("201105") 
	Do tRequest.AddDocumentType(3)  /// Both ondemand and stable
	#; lookup two format codes
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName="$XDSDocumentEntryFormatCode"
	Do tItem.CodedValues.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88",""))
	Do tItem.CodedValues.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("2.16.840.1.113883.10.20.1","YSP",""))
	Do tRequest.Parameters.Insert(tItem)
	#; querying single values
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryClassCode","Summarization of episode","Connect-a-thon classCodes"))
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryHealthcareFacilityTypeCode","Outpatient","Connect-a-thon healthcareFacilityTypeCodes"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	
	Quit:'$$$AssertTrue(tResponse.Documents.Count()>1,"Documents located")
	Set tPatients=0 For tIdx=1:1:tResponse.Documents.Count() Set tPatientID=tResponse.Documents.GetAt(tIdx).PatientId If '$d(tPatients(tPatientID))  { Set tPatients(tPatientID)=$i(tPatients)}
	Quit:'$$$AssertTrue(tPatients>=2,"Multiple patients found")
}

/// A find documents multi patient specifying only coded values
Method Test500FindDocumentsMultiPatients()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("broken")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindDocumentsMultiPatients"

	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AddCreationFrom("201105") 
	Do tRequest.AddDocumentType(3)  /// Both ondemand and stable
	#; lookup two format codes
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName="$XDSDocumentEntryFormatCode"
	Do tItem.CodedValues.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88",""))
	Do tItem.CodedValues.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("2.16.840.1.113883.10.20.1","YSP",""))
	Do tRequest.Parameters.Insert(tItem)
	#; querying single values
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryClassCode","Summarization of episode","Connect-a-thon classCodes"))
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryHealthcareFacilityTypeCode","Outpatient","Connect-a-thon healthcareFacilityTypeCodes"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	
	Quit:'$$$AssertTrue(tResponse.Documents.Count()>1,"Documents located")
	Set tPatients=0 For tIdx=1:1:tResponse.Documents.Count() Set tPatientID=tResponse.Documents.GetAt(tIdx).PatientId If '$d(tPatients(tPatientID))  { Set tPatients(tPatientID)=$i(tPatients)}
	Quit:'$$$AssertTrue(tPatients>=3,"Multiple patients found")
}

Method Test520FindSubmissionSets()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindSubmissionSets"
	Do tRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")
	
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("201101","$XDSSubmissionSetSubmissionTimeFrom"))
	Do tRequest.AddPatientId("9999999^^^&"_$$$AffinityDomainOID_"&ISO","$XDSSubmissionSetPatientId")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located")
	/// re-query using the source id from the first document - prior to xxx it was failing
	Set tSourceId = tResponse.Submissions.GetAt(1).SourceId
	Set tNewRequest = tRequest.%ConstructClone(1)
	Do tNewRequest.AddSingleParam(tSourceId,"$XDSSubmissionSetSourceId")
	$$$HSLogSessionID
	Set tSC = ##class(HS.Test.Service).SendSync(tNewRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located (by source id)")
	/// re-query using the source id from the first document (repeated as an OR condition)
	Set tNewRequest = tRequest.%ConstructClone(1)
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Do tNewRequest.Parameters.Insert(tItem)
	Set tItem.ItemName="$XDSSubmissionSetSourceId"
	Do tItem.Values.Insert(tSourceId)
	Do tItem.Values.Insert(tSourceId)
	Set tItem.SingleValue=0
	$$$HSLogSessionID
	Set tSC = ##class(HS.Test.Service).SendSync(tNewRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located (by source id)")
	/// re-query using the a junk source id  ( as an AND condition)
	Do tNewRequest.AddSingleParam("1.0.0.1.1.1","$XDSSubmissionSetSourceId")
	$$$HSLogSessionID
	Set tSC = ##class(HS.Test.Service).SendSync(tNewRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue('tResponse.Submissions.Count(),"No Submission Set(s) located (by source id with AND)")
}

/// To review after the folder support has been added to P&R
Method Test540FindFolders()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindFolders"
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO","$XDSFolderPatientId")
	//Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("201101","$XDSFolderLastUpdateTimeFrom"))
	//Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("202001","$XDSFolderLastUpdateTimeTo"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Folders.Count(),"Folder(s) located")
}

Method Test560GetDocuments()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	#; first add a document so that we can locate it
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tRequest.PatientId="7777777^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tRequest.SourceId="1.3.6.1.4.1.21367.1"
	Set tRequest.ContentTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon contentTypeCodes","Summarization of episode")
	Set tDocument = ##class(HS.Message.IHE.XDSb.Document).%New()
	Do tRequest.Documents.Insert(tDocument)
	Set tSC = ..GetXDataAsStreamWithSubstitutions("CCDDocument1",.tStream) Quit:'$$$AssertStatusOK(tSC,"Have CCD")
	Do tDocument.BodyCharacter.CopyFrom(tStream)
	Set tDocument.CreationTime=$TR($zdt($h,8),": ")
 	Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create("N","2.16.840.1.113883.5.25","OPT-OUT"))
	Set tDocument.SourcePatientId="A7777777^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO"
	Set tDocument.ClassCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Summarization of episode","Connect-a-thon classCodes","Summarization of episode")
	Set tDocument.FormatCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("2.16.840.1.113883.10.20.1","2.16.840.1.113883.3.88","HL7 CCD Document")
	Set tDocument.MimeType="text/xml"
	Set tDocument.HealthcareFacilityTypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("Outpatient","Connect-a-thon healthcareFacilityTypeCodes","Outpatient")
	Set tDocument.PracticeSettingCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("General Medicine","Connect-a-thon practiceSettingCodes","General Medicine")
	Set tDocument.TypeCode=##class(HS.IHE.XDSb.Types.CodedValue).%New("34133-9","LOINC","Summarization of Episode Note")
	
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Added Document Patient 7777777")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read()["ResponseStatusType:Success","Document added successfully")
	
	Set tDocumentUniqueId=tDocument.UniqueId
	Set tDocumentEntryUUID="urn:uuid:"_tDocument.EntryUUID
	
	#; locate by EntryUUID
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetDocuments"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tDocumentEntryUUID,"$XDSDocumentEntryEntryUUID"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	If $$$AssertTrue(tResponse.Documents.Count(),"Documents located for EntryUUID "_tDocumentEntryUUID)

	#; locate by UniqueId
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetDocuments"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tDocumentUniqueId,"$XDSDocumentEntryUniqueId"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Documents located for UniqueId "_tDocumentUniqueId)
}

Method Test580GetFolders()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindFolders"
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO","$XDSFolderPatientId")
	//Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("201101","$XDSFolderLastUpdateTimeFrom"))
	//Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("202001","$XDSFolderLastUpdateTimeTo"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Folders.Count(),"Folder(s) located")

	#; locate the folder just submitted
	Set tFolderUniqueId=tResponse.Folders.GetAt(1).UniqueId
	Set tFolderEntryUUID = tResponse.Folders.GetAt(1).EntryUUID

	#; locate by EntryUUID
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetFolders"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tFolderEntryUUID,"$XDSFolderEntryUUID"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	If $$$AssertTrue(tResponse.Folders.Count(),"Folder located for EntryUUID "_tFolderEntryUUID)

	#; locate by UniqueId
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetFolders"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tFolderUniqueId,"$XDSFolderUniqueId"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Folders.Count(),"Folder located for UniqueId "_tFolderUniqueId)
}

Method Test600GetAssociations()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tRequest.AddDocumentType(3)  /// Both ondemand and stable
	Set tRequest.ReturnType="OR"
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.ObjectRefs.Count(),"Documents located")

	Set tDocumentEntryUUID=tResponse.ObjectRefs.GetAt(1).EntryUUID
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetAssociations"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tDocumentEntryUUID,"$uuid"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Associations.Count(),"Association(s) located")
}

Method Test620GetDocsAndAssociations()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tRequest.AddStatusValues("Approved")
	Set tRequest.ReturnType="OR"
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.ObjectRefs.Count(),"Documents located")

	Set tDocumentEntryUUID=tResponse.ObjectRefs.GetAt(1).EntryUUID
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetDocsAndAssociations"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tDocumentEntryUUID,"$XDSDocumentEntryEntryUUID"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Associations.Count(),"Association(s) located")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Document(s) located")
	
	Set tDocumentUniqueId=tResponse.Documents.GetAt(1).UniqueId
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetDocsAndAssociations"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tDocumentUniqueId,"$XDSDocumentEntryUniqueId"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Associations.Count(),"Association(s) located")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Document(s) located")
}

Method Test640GetSubmissionSets()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	#; issue get all for JeffSmith to find a document and folder then use the uuid to find the submission set
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetAll"
	Do tRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")
	
	//Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("201101","$XDSSubmissionSetSubmissionTimeFrom"))
	Do tRequest.AddPatientId("JeffSmith^^^&"_$$$AffinityDomainOID_"&ISO","$patientId")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Document(s) located")
	Quit:'$$$AssertTrue(tResponse.Folders.Count(),"Folder(s) located")

	For tIdx = 1:1:tResponse.Associations.Count() { Set tAssociation = tResponse.Associations.GetAt(tIdx) If $D(tAry(tAssociation.ID)) {Quit:'$$$AssertTrue(0,"Duplicate Association found ")} Set tAry(tAssociation.ID)=""}

	#; use the document entry uuid and the folder entry uuid to locate submission sets
	Set tDocumentEntryUUID = tResponse.Documents.GetAt(1).EntryUUID
	Set tFolderEntryUUID = tResponse.Folders.GetAt(1).EntryUUID
	For uuid=tDocumentEntryUUID,tFolderEntryUUID {
		Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		Set tRequest.QueryType="GetSubmissionSets"
		Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(uuid,"$uuid"))
		Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
		Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
		Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
		Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
		Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located")
	}
}

Method Test660GetSubmissionSetsAndContents()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	#; issue get all for JeffSmith to find a document and folder then use the uuid to find the submission set
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetAll"
	Do tRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")
	
	//Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("201101","$XDSSubmissionSetSubmissionTimeFrom"))
	Do tRequest.AddPatientId("JeffSmith^^^&"_$$$AffinityDomainOID_"&ISO","$patientId")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located")

	#; use the document entry uuid and the folder entry uuid to locate submission sets
	Set tSubmissionEntryUUID = tResponse.Submissions.GetAt(1).EntryUUID
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetSubSetsAndContents"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tSubmissionEntryUUID,"$XDSSubmissionSetEntryUUID"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located")

	Set tSubmissionUniqueId = tResponse.Submissions.GetAt(1).UniqueId
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetSubSetsAndContents"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tSubmissionUniqueId,"$XDSSubmissionSetUniqueId"))
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Document(s) located")
	Quit:'$$$AssertTrue(tResponse.Folders.Count(),"Folder(s) located")
	Quit:'$$$AssertTrue(tResponse.Associations.Count(),"Association(s) located")
}

Method Test680GetFoldersAndContents()
{
}

Method Test700GetRelatedDocuments()
{
}

Method Test720GetAll()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetAll"
	Do tRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")
	
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("201101","$XDSSubmissionSetSubmissionTimeFrom"))
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO","$patientId")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Submissions.Count(),"Submission Set(s) located")
	Quit:'$$$AssertTrue(tResponse.Folders.Count(),"Folder(s) located")
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Document(s) located")
	Quit:'$$$AssertTrue(tResponse.Associations.Count(),"Association(s) located")
}

Method Test740MetadataUpdate()
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	$$$HSTestBailout
	Set tHighAuditID = ..FindHighAuditID()
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="Metadata"
	Set tAPRequest.LastName="Update"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1970-01-01")
	Set tAPRequest.MRN="MetadataUpdate"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	Set tAPRequest.MPIID="100111000"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPRequest.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	#; Create XDSb document
	Do ..createDocument("MU#1",tAPRequest.MPIID,.tSubmission)
	Do ..FindAuditRecords(tHighAuditID,1,"R","ITI-41",.tCount)
	If '$$$AssertTrue((tCount=1),"Document source PnR audit record count:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-41",.tCount)
	If '$$$AssertTrue(tCount=1,"Repository PnR audit record count:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-42",.tCount)
	If '$$$AssertTrue(tCount=1,"Registry Register audit record count:"_tCount)
	//Do ..FindAuditRecords(tHighAuditID,1,"C","ITI-42",.tCount)
	//Quit:'$$$AssertTrue(tCount=1,"Registry Register audit record")
	//Code: ITI-57,IHE Transactions,Update Document Set --- ID: 110107,DCM,Import
	//Code: ITI-18,IHE Transactions,Registry Stored Query --- ID: 110112,DCM,Query
	//Code: ITI-41,IHE Transactions,Provide and Register Document Set-b --- ID: 110106,DCM,Export
	//Code: ITI-41,IHE Transactions,Provide and Register Document Set-b --- ID: 110107,DCM,Import
	//Code: ITI-42,IHE Transactions,Register Document Set-b --- ID: 110107,DCM,Import
	
	//Quit:'$$$AssertTrue(tCount=2,"Audit should report 2 Subscriptions for the source:"_tCount)
	//Do ..FindAuditRecords(tHighAuditID,1,"D","ITI-52",.tCount)
	//Quit:'$$$AssertTrue(tCount=1,"Audit should report 1 cancel subscription for the source:"_tCount)
	
	Set tHighAuditID = ..FindHighAuditID()
	#; Query for XDSb document just created
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPRequest.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddParam(2,"$MetadataLevel")
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	//Quit:'$$$AssertStatusOK(tQDRequest.QueryByEntryUUID(tDocUUID),"Query by Entry UUID")
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
	Set tUpdate1 = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0)
	Set tDoc.EntryUUID="DocUpdate1"
	$$$DynamicCode(tDoc,TypeCode,0)
	Set tSC = tUpdate1.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-57",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-57",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)

	#; query with no $MetadataLevel specification should be two documents
	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPRequest.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddParam(2,"$MetadataLevel")
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
	Do tQDRequest.AddPatientId(tAPRequest.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
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
	Set tUpdate2 = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
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
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-57",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the administrator:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-57",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 update for the registry:"_tCount)

	#; query for document (should be now be 0)
	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPRequest.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=0,"0 Documents located")
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the consumer:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 query for the registry:"_tCount)
}

/// This is just to ensure a different query path - ensure that no bitmap index is used (by setting the BitMapCount = 1)
Method Test760NoIndexCodePath()
{
	
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,"xdata://"_..%ClassName(1)_":XDataNoIndexItems",1)
	Quit:'$$$AssertStatusOK(tSC,"Modifying production NoIndexCodePath")
	Set tSC= ##class(Ens.Director).UpdateProduction() Quit:$$$ISERR(tSC)
	Quit:'$$$AssertStatusOK(tSC,"Updating production NoIndexCodePath")
	Set tSC=..createDocument("NoIndexCodePath#1",7777777,.tRequest)
	/// create second identical document but change the UUID's/UniqueID's
	Set tRequest.EntryUUID = ##class(HS.Util.XSLTHelper).createUUID()
	Set tRequest.UniqueId = ##class(HS.Util.XSLTHelper).uuid2oid(tRequest.EntryUUID)
	Set tDocument = tRequest.Documents.GetAt(1)
	Set tDocument.EntryUUID = ##class(HS.Util.XSLTHelper).createUUID()
	Set tDocument.UniqueId = ##class(HS.Util.XSLTHelper).uuid2oid(tDocument.EntryUUID)
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"second document submission")
	Quit:'$$$AssertTrue(tResponse.ContentStream.Read(300000000)["Success","second document submission has success status")
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddPatientId("7777777^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tRequest.AddDocumentType(1)  /// just stable - ondemand won't allow the restriction based on CreationTime
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryEventCodeList",tDocument.EventCodeList.GetAt(1).Code,tDocument.EventCodeList.GetAt(1).Scheme))	
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertTrue(tResponse.Documents.Count(),"Found documents")
	/// restore production setting to original state
	Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,"xdata://"_..%ClassName(1)_":XDataRegularIndexItems",1)
	Quit:'$$$AssertStatusOK(tSC,"Restoring production NoIndexCodePath")
	Set tSC= ##class(Ens.Director).UpdateProduction() Quit:$$$ISERR(tSC)
	Quit:'$$$AssertStatusOK(tSC,"Restoring production NoIndexCodePath")
}

Method Test780VeryLongIIDs()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	/// If the test is run multiple times we need to cleanup
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tRequest.AddSingleParam("100000001^^^&"_$$$AffinityDomainOID_"&ISO","$patientId")
	Set tRequest.QueryType="GetAll"
	Do tRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")
	Do tRequest.AddDocumentType(1)  /// stable
	Set tItem=##class(HS.Message.IHE.XDSb.QueryItem).%New()
	Set tItem.ItemName="$XDSDocumentEntryUniqueId"
	Do tItem.Values.Insert("2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001")
	Do tRequest.Parameters.Insert(tItem)
	#; querying single values
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error Documents:"_tResponse.Documents.Count())
	If tResponse.Documents.Count() {
		Quit:'$$$AssertTrue((tResponse.Documents.Count()=1),"1 Document located")
		Set tDelDocRequest = ##class(HS.Message.IHE.XDSb.DeleteDocumentSetRequest).%New()
		Set UUID = tResponse.Documents.GetAt(1).EntryUUID
		Do tDelDocRequest.ObjectRefs.Insert(UUID)
		For tIdx=1:1:tResponse.Associations.Count() {
			Set tAssociation = tResponse.Associations.GetAt(tIdx)
			If tAssociation.Type="HasMember" {
				If tAssociation.ChildUUID=UUID Do tDelDocRequest.ObjectRefs.Insert(tAssociation.ID)
			}
		}
		Do tDelDocRequest.AdditionalInfo.SetAt("Test.XDSb.Registry","ServiceName") 
		Do tDelDocRequest.AdditionalInfo.SetAt(..#Administrator,"Host") 
		Do tDelDocRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
		Set tSC = ##class(HS.Test.Service).SendSync(tDelDocRequest,.tDelDocResponse)
		Quit:'$$$AssertStatusOK(tSC,"Delete Completed without error")
	}
	Set %SubmissionSetUniqueId="SubmissionSet:274465.2194357.000000000000000001"
	If tResponse.Submissions.Count() {
		Set %SubmissionSetUniqueId="SubmissionSet:"_$zh_".000000000000000001"
	}
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Very"
	Set tRequest.LastName="LongIIDs"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1985-04-20")
	Set tRequest.MRN="VeryLongIIDS"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tAddResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient VeryLongIIDs")
	Quit:'$$$AssertTrue(tAddResponse.ErrStatus=""||(tAddResponse.ErrStatus=$$$OK),"Patient added without error")
	Set %PatientID=tAddResponse.MPIID_"^^^&amp;"_$$$AffinityDomainOID_"&amp;ISO"
	//{$expression{%PatientID}}
	//
	/// this is the actual test
	Set tRequest = ##class(HS.Message.XMLMessage).%New()
	Set tStream = tRequest.ContentStream
	Set tSC = ..GetXDataAsStreamWithSubstitutions("VeryLongIIDs",.tStream) 
	Set tRequest.Name=$$$XDSbRegisterRequest
	Do tRequest.ContentStream.CopyFrom(tStream)
	Quit:'$$$AssertStatusOK(tSC,"Have PnR")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRequest.AdditionalInfo.SetAt("Test.XDSb.Registry","ServiceName") 
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt($$$XDSbRegisterAction(1),"SOAPAction")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse),"Successfully registered document")
	quit
	Set tHighAuditID = ..FindHighAuditID()
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="ClassCode"
	Set tAPRequest.LastName="VeryLong"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1976-04-06")
	Set tAPRequest.MRN="VeryLongIID"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPResponse.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	#; Create XDSb document
	Do ..createDocument("MU#1",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")
	Set t=##class(HS.Util.XSLTTransformer).%New()
	Set tSC = t.TransformFromObject(tSubmission,"IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl",.tStream)
	
	//
	Set tSC = t.TransformIntoObject(tStream,"IHE/XDSb/Version1/Message-to-MetadataObject.xsl",.tMetadata,"","HS.Message.IHE.XDSb.Metadata")
	Set tMetadata.Name=$$$XDSbRegisterRequest
	Set tDoc = tMetadata.Documents.GetAt(1)
	Set tDoc.PatientIdentifier.Value=tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tDoc.RepositoryUniqueId=##class(HS.Data.OIDMap).GetOIDForCode($namespace)
	Set tDoc.Size=0
	Set tDoc.Hash="da39a3ee5e6b4b0d3255bfef95601890afd80709"
	Set tDoc.ClassCode.IID = tDoc.DocumentUniqueIdentifier.Value_"ClassCode1"
	Set tRegRequest = ##class(HS.Message.XMLMessage).%New()
	Set tRegStream = tRegRequest.ContentStream
	Quit:'$$$AssertStatusOK(##class(HS.IHE.XDSb.DocumentSource.Abstract).GetUpdatedAssociations(tMetadata),"Updated associations")
	Set tSC = t.TransformFromObject(tMetadata,"IHE/XDSb/Version1/MetadataObject-to-Message.xsl",.tRegStream)
	Do tRegRequest.AdditionalInfo.SetAt(..#DocumentSource,"Host") 
	Do tRegRequest.AdditionalInfo.SetAt($$$XDSbRegisterAction(1),"SOAPAction")
	Do tRegRequest.AdditionalInfo.SetAt("Test.XDSb.Registry","ServiceName") 
	Do tRegRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRegRequest,.tResponse)
	Quit:'$$$AssertStatusOK(##class(HS.IHE.XDSb.Util).ProcessResponse(tResponse),"Successfully registered document")
}

Method Test800InlineDocument()
{
	
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,"xdata://"_..%ClassName(1)_":XDataInlineDocument",1)
	Quit:'$$$AssertStatusOK(tSC,"Modifying production InlineDocument")
	Set tSC= ##class(Ens.Director).UpdateProduction() Quit:$$$ISERR(tSC)
	Quit:'$$$AssertStatusOK(tSC,"Updating production InlineDocument")
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Janice"
	Set tRequest.LastName="InlineDocument"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1955-01-03")
	Set tRequest.MRN="InlineDocument"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient")
	Quit:'$$$AssertTrue(tResponse.MPIID]"","AddPatient MPIID:"_tResponse.MPIID)

	Set tText="InlineDocument",$p(tText,"-",30000)=""
	Set tSC=..createDocument(tText,tResponse.MPIID,.tSubmission)
	Quit:'$$$AssertStatusOK(tSC,"document submitted")
}

Method Test900HSHC190()
{
	#define DynamicCode(%object,%field,%multiple,%table) Do ..DynamicCode(##quote(%table),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	$$$HSTestBailout
	Set tHighAuditID = ..FindHighAuditID()
	Do $$$LogMessage("If Test900HSHC190 fails, ensure the test is run with /ResetData=1, running this test multiple times will cause a failure")
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="HSHCMetadata"
	Set tAPRequest.LastName="190Update"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1900-01-01")
	Set tAPRequest.MRN="HSHC190"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPResponse.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	Set tSubmission=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tSubmission.RequestingUser="SFARRELL"
	Set tSubmission.RequestingUserRoles="%HS_Clinician"

	#; Create XDSb document
	Set tSC= ..createDocument("MU#1",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")
	Set tFolder = ##class(HS.Message.IHE.XDSb.Folder).%New()
	Set tFolder.PatientId=tSubmission.PatientId
	Set tFolder.Title="TestFolder"
	Set tFolder.AvailabilityStatus="Approved"
	$$$DynamicCode(tFolder,CodeList,1,FolderCodeList)
	Do tSubmission.Folders.Insert(tFolder)

	Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).%New()
	Set tAssociation.ParentUUID = tFolder.EntryUUID
	Set tAssociation.ChildUUID = tSubmission.Documents.GetAt(1).EntryUUID
	Set tAssociation.Type = "HasMember"
	Do tSubmission.Associations.Insert(tAssociation)
	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tSubmissionResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Document and folder submitted without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tSubmissionResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document and folder created without error")

	#; Query for XDSb document just created
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(1)  /// just stable, otherwise can't limit by CreationFrom (bitmap)
	Do tQDRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tQDRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tQDRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")
	Set tQDRequest.QueryType="GetAll"
	Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO","$patientId"))
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"Single Document located:"_tQDResponse.Documents.Count())
	Set tDocumentUUID = tQDResponse.Documents.GetAt(1).EntryUUID
	Set tFolderUUID = tQDResponse.Folders.GetAt(1).EntryUUID
	Set tDocumentUUID = tQDResponse.Documents.GetAt(1).EntryUUID
	Set tFolderUUID = tQDResponse.Folders.GetAt(1).EntryUUID
	Set tFoundAssociation=0
	For tIdx =1:1:tQDResponse.Associations.Count() {
		If tQDResponse.Associations.GetAt(tIdx).ParentUUID = tFolderUUID && (tQDResponse.Associations.GetAt(tIdx).ChildUUID = tDocumentUUID) {
			Set tFoundAssociation=1
		}
	}
	Quit:'$$$AssertTrue(tFoundAssociation,"Found folder->document association")
	#; Update XDSb Document created above
	Set tHighAuditID = ..FindHighAuditID()
	Set tDoc = tQDResponse.Documents.GetAt(1)
	Set tUpdate1 = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
	Set tUpdate1.PatientId = tDoc.PatientId
	Set tUpdate1.SourceId = $P(tDoc.PatientId,"&",2)
	$$$DynamicCode(tUpdate1,ContentTypeCode,0,ContentTypeCode)
	Set tDoc.EntryUUID="DocUpdate1"
	$$$DynamicCode(tDoc,TypeCode,0,TypeCode)
	Set tSC = tUpdate1.Documents.Insert(tDoc) 
	Quit:'$$$AssertStatusOK(tSC,"Inserted document")
	Do tUpdate1.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate1,.tUpdateResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Update Completed without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document updated without error")

	#; query with no $MetadataLevel specification should be one document
	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	//Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddStatusValues("Approved,Deprecated","$XDSDocumentEntryStatus")
	Do tQDRequest.AddStatusValues("Approved,Deprecated","$XDSFolderStatus")
	Do tQDRequest.AddStatusValues("Approved,Deprecated","$XDSSubmissionSetStatus")
	Set tQDRequest.QueryType="GetAll"
	Set tQDRequest.ReturnType="LC"
	Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO","$patientId"))
	//Do tQDRequest.AddParam("urn:uuid:"_tSubmission.Documents.GetAt(1).EntryUUID,"$XDSDocumentEntryLogicalID")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Submitted without error")
	Quit:'$$$AssertTrue(tQDResponse.Errors.Errors.Count()=0,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"1 Documents located:"_tQDResponse.Documents.Count())
	Set tDocumentUUID = tQDResponse.Documents.GetAt(1).EntryUUID

	Set tFoundAssociation=0
	For tIdx =1:1:tQDResponse.Associations.Count() {
		If tQDResponse.Associations.GetAt(tIdx).ParentUUID = tFolderUUID && (tQDResponse.Associations.GetAt(tIdx).ChildUUID = tDocumentUUID) {
			Set tFoundAssociation=1
		}
	}
	Quit:'$$$AssertTrue(tFoundAssociation,"Found folder->document association")
	
	#; Deprecate Document
	Set tHighAuditID = ..FindHighAuditID()
	Set tDoc = tQDResponse.Documents.GetAt(1)
	Set tUpdate2 = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
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
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate2,.tUpdateResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Status change completed without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Update completed without error")

	#; query for document (should be now be 0)
	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved","$XDSDocumentEntryStatus")
	Do tQDRequest.AddStatusValues("Approved","$XDSFolderStatus")
	Do tQDRequest.AddStatusValues("Approved","$XDSSubmissionSetStatus")
	Set tQDRequest.QueryType="GetAll"
	Set tQDRequest.ReturnType="LC"
	Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO","$patientId"))
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)

	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=0,"0 Documents located")
}

/// Test various query restrictions and error changes in HSHC184
/// This test does not present anything valid to return documents, just validates the parameter restrictions 
Method Test910HSHC184()
{
	$$$HSTestBailout
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetDocuments"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryEntryUUID"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryUniqueId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryParamNumber","Query should have reported XDSStoredQueryParamNumber error")

	/// GetFolders
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetFolders"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSFolderEntryUUID"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSFolderUniqueId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryParamNumber","Query should have reported XDSStoredQueryParamNumber error")
	///	
	///GetDocumentsAndAssociations
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetDocsAndAssociations"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryEntryUUID"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryUniqueId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryParamNumber","Query should have reported XDSStoredQueryParamNumber error")
	///
	///GetSubmissionSetAndContents
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetSubSetsAndContents"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSSubmissionSetEntryUUID"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSSubmissionSetUniqueId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryParamNumber","Query should have reported XDSStoredQueryParamNumber error")
	///
	//GetFolderAndContents
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetFolders"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSFolderEntryUUID"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSFolderUniqueId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryParamNumber","Query should have reported XDSStoredQueryParamNumber error")
	//
	//GetFoldersForDocument
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetFoldersForDocument"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryEntryUUID"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryUniqueId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryParamNumber","Query should have reported XDSStoredQueryParamNumber error")
	///
	///GetRelatedDocuments
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetRelatedDocuments"
	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(##class(HS.Types.IHE.Association).LogicalToDisplay("HasMember"),"$AssociationTypes"))
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryEntryUUID"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryUniqueId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryParamNumber","Query should have reported XDSStoredQueryParamNumber error")
	///
	/// FindDocuments
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindDocuments"
	Do tRequest.AddStatusValues("Approved")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSDocumentEntryPatientId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	//
	/// FindDocumentsMultiPatients
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindDocumentsMultiPatients"
	Do tRequest.AddStatusValues("Deprecated,Approved")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSDocumentEntryClassCode","Summarization of episode","Connect-a-thon classCodes"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0||(tResponse.Errors.Errors.GetAt(1).Code="XDSTooManyResults"),"Query should have no errors")
	//
	//FindSubmissionSets
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindSubmissionSets"
	Do tRequest.AddStatusValues("Deprecated,Approved","$XDSSubmissionSetStatus")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_"FindSubmissionSets","Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSSubmissionSetPatientId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	//
	// FindFolders
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindFolders"
	Do tRequest.AddStatusValues("Deprecated,Approved","$XDSFolderStatus")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$XDSFolderPatientId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	//
	// GetAll
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetAll"
	Do tRequest.AddStatusValues("Deprecated,Approved","$XDSDocumentEntryStatus")
	Do tRequest.AddStatusValues("Deprecated,Approved","$XDSFolderStatus")
	Do tRequest.AddStatusValues("Deprecated,Approved","$XDSSubmissionSetStatus")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$patientId"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	//
	// GetAssociations
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetAssociations"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$uuid"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	//
	// GetSubmissionSets
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="GetSubmissionSets"
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("1.2.3","$uuid"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
	//
	// FindFoldersMultiPatients
	Set tRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Set tRequest.QueryType="FindFoldersMultiPatients"
	Do tRequest.AddStatusValues("Deprecated,Approved","$XDSFolderStatus")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod_tRequest.QueryType,"Caller")
	Do tRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count(),"Query should have reported an error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.GetAt(1).Code="XDSStoredQueryMissingParam","Query should have reported XDSStoredQueryMissingParam error")

	Do tRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).CodedValue("$XDSFolderCodeList","SomeCode","SomeScheme"))
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tResponse.Errors.Errors.Count()=0,"Query should have no errors")
}

Method Test920MultipleAuthorInstitutionsHSHC1442()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")
	Do ..createDocument("MU#1","100000001",.tSubmission,0,"Test^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO")
	Set tDocument = tSubmission.Documents.GetAt(1)
	set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New()
	Set tAuthor.EntryUUID="MyAuthor"
    set tAuthor.AuthorPerson = "^Welby^Marcus^^MD^Dr"
    Do tAuthor.AuthorInstitution.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Some Hospital"))
    do tAuthor.AuthorInstitution.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Lahey Clinic"))
    Do tAuthor.AuthorRole.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Role1"))
    Do tAuthor.AuthorRole.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Role2"))
    Do tAuthor.AuthorSpecialty.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Specialty"))
    Do tAuthor.AuthorSpecialty.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Specialty2"))
    Do tAuthor.AuthorTelecommunication.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("email1@isc.com"))
    Do tAuthor.AuthorTelecommunication.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("email2@isc.com"))
	Do tDocument.Author.Insert(tAuthor)
	set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New()
	Set tAuthor.EntryUUID="MyAuthor"
    set tAuthor.AuthorPerson = "^Welby^Marcus^^MD^Dr"
    Do tAuthor.AuthorInstitution.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Some Hospital"))
    do tAuthor.AuthorInstitution.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Lahey Clinic"))
    Do tAuthor.AuthorRole.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Role1"))
    Do tAuthor.AuthorRole.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Role2"))
    Do tAuthor.AuthorSpecialty.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Specialty"))
    Do tAuthor.AuthorSpecialty.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("Specialty2"))
    Do tAuthor.AuthorTelecommunication.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("email1@isc.com"))
    Do tAuthor.AuthorTelecommunication.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("email2@isc.com"))
	Do tDocument.Author.Insert(tAuthor)
		
	Set t=##class(HS.Util.XSLTTransformer).%New()
	Set tSC = t.TransformFromObject(tSubmission,"IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl",.tStream)
	/// check to make sure Institution / Role / Specialty / Telecom are together
	Set tString = tStream.Read(30000000000)
	Set tPos=0
	#define Check(%string,%value1,%value2,%pos) Set %pos = $f(%string,%value1_"</rim:Value><rim:Value>"_%value2_"</rim:Value>",%pos)
	For tIdx = 1,2 {
		$$$Check(tString,"Some Hospital","Lahey Clinic",tPos)
		Quit:'$$$AssertTrue(tPos,"AuthorInstitution values positioned correctly")
		$$$Check(tString,"Role1","Role2",tPos)
		Quit:'$$$AssertTrue(tPos,"Roles positioned correctly")
		$$$Check(tString,"Specialty","Specialty2",tPos)
		Quit:'$$$AssertTrue(tPos,"Specialty values positioned correctly")
		$$$Check(tString,"email1@isc.com","email2@isc.com",tPos)
		Quit:'$$$AssertTrue(tPos,"AuthorTelecommunication values positioned correctly")
	}
}

Method Test940CheckLocksAfterMergeHSHC1476()
{
	/// ensure there are no existing locks
	Quit:'$$$AssertTrue($O(^$LOCK("^HS.Registry.Document.Patient"))'["^HS.Registry.Document.Patient")
	/// create patient and document
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="HSHCLocks"
	Set tAPRequest.LastName="1476Failure"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1900-05-01")
	Set tAPRequest.MRN="HSHC1476"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPResponse.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	Set tSubmission=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	Set tSubmission.RequestingUser="SFARRELL"
	Set tSubmission.RequestingUserRoles="%HS_Clinician"

	#; Create XDSb document
	Set tSC= ..createDocument("HSHC1476",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")

	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tSubmissionResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Document submitted without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tSubmissionResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document created without error")

	///move it back first (if we have already run)
	Set tMerge = ##class(HS.Message.IDUpdateNotificationRequest).%New()
	Set tMerge.PriorMPIID="MPIID-HSHC-1476"
	Set tMerge.MPIID = tAPResponse.MPIID
	Set tID = ##class(HS.Types.Identifier).%New()
	Set tID.Root=tAPRequest.AssigningAuthority,tID.Extension=tAPRequest.MRN
	do tMerge.Identifiers.Insert(tID)
	Do tMerge.AdditionalInfo.SetAt("HS.IHE.XDSb.Registry.Operations","Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tMerge,.tMergeResponse,,.tSessionID)


	Set tMerge = ##class(HS.Message.IDUpdateNotificationRequest).%New()
	Set tMerge.MPIID="MPIID-HSHC-1476"
	Set tMerge.PriorMPIID = tAPResponse.MPIID
	Set tID = ##class(HS.Types.Identifier).%New()
	Set tID.Root=tAPRequest.AssigningAuthority,tID.Extension=tAPRequest.MRN
	do tMerge.Identifiers.Insert(tID)
	Do tMerge.AdditionalInfo.SetAt("HS.IHE.XDSb.Registry.Operations","Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tMerge,.tMergeResponse,,.tSessionID)

	Set tMerge = ##class(HS.Message.IDUpdateNotificationRequest).%New()
	Set tMerge.PriorMPIID="MPIID-HSHC-1476"
	Set tMerge.MPIID = tAPResponse.MPIID
	Set tID = ##class(HS.Types.Identifier).%New()
	Set tID.Root=tAPRequest.AssigningAuthority,tID.Extension=tAPRequest.MRN
	do tMerge.Identifiers.Insert(tID)
	Do tMerge.AdditionalInfo.SetAt("HS.IHE.XDSb.Registry.Operations","Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tMerge,.tMergeResponse,,.tSessionID)
	Quit:'$$$AssertTrue($O(^$LOCK("^HS.Registry.Document.Patient"))'["^HS.Registry.Document.Patient")
}

/// Submit On-Demand document and query for parameters including CreationTime / ServiceStart / ServiceStop
Method Test950HSHC1790()
{
	#define DynamicCode(%object,%field,%multiple,%table) Do ..DynamicCode(##quote(%table),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	$$$HSTestBailout
	Set tHighAuditID = ..FindHighAuditID()
	//Do $$$LogMessage("If Test900HSHC190 fails, ensure the test is run with /ResetData=1, running this test multiple times will cause a failure")
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="HSHC"
	Set tAPRequest.LastName="1790Query"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1990-04-01")
	Set tAPRequest.MRN="HSHC1790"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPResponse.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	#;Deprecate documents
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")

	Set tSubmission=##class(HS.Message.IHE.XDSb.RegisterRequest).%New()
	Set tSubmission.RequestingUser="SFARRELL"
	Set tSubmission.RequestingUserRoles="%HS_Clinician"

	Do ..Manager.UserFields.SetAt(1,"RegisterOnly")
	#; Create XDSb document
	Set tSC= ..createDocument("OnDemand#1",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")
	Set tDocument = tSubmission.Documents.GetAt(1) 
	Set tDocument.ObjectType="OnDemand"
	Set tDocument.Size=""
	Set tDocument.Hash=""
	Set tDocument.CreationTime=""
	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tSubmissionResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"OnDemand Document submitted without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tSubmissionResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document created without error")

	#; Query for XDSb document just created
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	//Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count(),"Document(s) located:"_tQDResponse.Documents.Count())

	#; Query for XDSb document with creationFrom
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddCreationTo($zdt(+$H+365,8))  /// docs created until today+365
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count(),"Document(s) located:"_tQDResponse.Documents.Count()_" for CreationFrom / To")

	#; Query for XDSb document with serviceStartFrom
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam($zdt(+$H,8),"$XDSDocumentEntryServiceStartTimeFrom"))
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count(),"Document(s) located:"_tQDResponse.Documents.Count())
	
	/// remove documents then query for edge cases
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Set tSC = ..DeprecateDocuments(tQDRequest) 
	
	
	Set tSubmission=##class(HS.Message.IHE.XDSb.RegisterRequest).%New()
	Set tSC= ..createDocument("Query Test#1",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")
	Set tDocument = tSubmission.Documents.GetAt(1)
	Set tDocument.CreationTime="20190102150438"
	Set tDocument.ServiceStartTime = "20190101"
	Set tDocument.ServiceStopTime = "20190102235959"
	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tSubmissionResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"OnDemand Document submitted without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tSubmissionResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document created without error")

	/// 
	/// $lb(Stable/OnDemand,#docs,Valid CreationTime, Valid ServiceStart, Valid ServiceStop)
	Set Cases = $lb($lb(1,1,1,"",""),$lb(2,0,1,"",""),$lb(3,1,1,"",""),$lb(1,0,0,"",""),$lb(2,0,0,"",""),$lb(3,0,0,"",""),
	 		$lb(1,1,1,1,""),$lb(2,0,1,1,""),$lb(3,1,1,1,""),$lb(1,0,1,0,""),$lb(2,0,1,0,""),$lb(3,0,1,0,""),
	 		$lb(1,1,1,1,1),$lb(2,0,1,1,1),$lb(3,1,1,1,1),$lb(1,0,1,0,0),$lb(2,0,1,0,0),$lb(3,0,1,0,0),$lb(1,0,0,0,0))
	For CaseIdx = 1:1:$ll(Cases) {
		Set Case=$li(Cases,CaseIdx)
		Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		Do tQDRequest.AddDocumentType($li(Case))  
		If $li(Case,3) {
			Do tQDRequest.AddCreationFrom("20190101")  /// **valid docs for the year 
			Do tQDRequest.AddCreationTo("20191231")  /// docs created for the year
		} Else {
			Do tQDRequest.AddCreationFrom($zdt(+$H-1,8))  /// *** invalid docs created yesterday
			Do tQDRequest.AddCreationTo($zdt(+$H-1,8))  /// docs created yesterday
		}
		
		If $li(Case,4)="" {
		} ElseIf $li(Case,4) {
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20190101","$XDSDocumentEntryServiceStartTimeFrom"))
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20190103","$XDSDocumentEntryServiceStartTimeTo"))
		} Else {
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20180101","$XDSDocumentEntryServiceStartTimeFrom"))
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20181231","$XDSDocumentEntryServiceStartTimeTo"))
		}
		If $li(Case,5)="" {
		} ElseIf $li(Case,5) {
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20190101","$XDSDocumentEntryServiceStopTimeFrom"))
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20190103","$XDSDocumentEntryServiceStopTimeTo"))
		} Else {
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20180101","$XDSDocumentEntryServiceStopTimeFrom"))
			Do tQDRequest.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam("20181231","$XDSDocumentEntryServiceStopTimeTo"))
		}

		Do tQDRequest.AddStatusValues("Approved")
		Do tQDRequest.AddPatientId(tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
		Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
		Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse,,.tSessionID)
		Do $$$LogMessage("Session: "_tSessionID)
		Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
		Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=$li(Case,2),"Documents located:"_tQDResponse.Documents.Count()_" Expected "_$li(Case,2))
	}
}

/// Submit stable without size and hash 
Method Test970()
{
	$$$HSTestBailout
	Set tHighAuditID = ..FindHighAuditID()
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="Missing"
	Set tAPRequest.LastName="SizeAndHash"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1990-04-01")
	Set tAPRequest.MRN="MissingSizeAndHash"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPResponse.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	/// Ensure OnDemand files without Size Hash CreationTime
	Set tSubmission=##class(HS.Message.IHE.XDSb.RegisterRequest).%New()
	Set tSubmission.RequestingUser="SFARRELL"
	Set tSubmission.RequestingUserRoles="%HS_Clinician"

	Do ..Manager.UserFields.SetAt(1,"RegisterOnly")
	#; Create XDSb document
	Set tSC= ..createDocument("OnDemand#1",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")
	Set tDocument = tSubmission.Documents.GetAt(1) 
	Set tDocument.ObjectType="OnDemand"
	Set tDocument.Size=""
	Set tDocument.Hash=""
	Set tDocument.CreationTime=""
	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tSubmissionResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"OnDemand Document submitted without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tSubmissionResponse)
	Quit:'$$$AssertStatusOK(tSC,"Document created without error")

	/// Ensure Stable document fails without Size / Hash
	Set tSubmission=##class(HS.Message.IHE.XDSb.RegisterRequest).%New()
	Do ..Manager.UserFields.SetAt(1,"RegisterOnly")
	#; Create XDSb document
	Set tSC= ..createDocument("Stable",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")
	Set tDocument = tSubmission.Documents.GetAt(1) 
	Set tDocument.Size=""
	Set tDocument.Hash=""
	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tSubmissionResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"OnDemand Document submitted without error")
	Set tStatusText = $zcvt(tSubmissionResponse.ContentStream.Read(),"l")
	/// ensure we see two errors
	If '(tStatusText["missing size value" && (tStatusText["missing hash value")) {
		Quit:'$$$AssertTrue(0,"Failed to report size or hash error")
	}
}

/// Submit stable without size and hash 
Method Test990()
{
	$$$HSTestBailout
	Set tHighAuditID = ..FindHighAuditID()
	#; Create Patient with AddUpdateHubRequest
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="Update"
	Set tAPRequest.LastName="LocalizedString"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1992-03-03")
	Set tAPRequest.MRN="LocalizedString"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPResponse.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	/// Ensure OnDemand files without Size Hash CreationTime
	Set tSubmission=##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	#; Create XDSb document
	Set tSC= ..createDocument("LocalizedString#1",tAPResponse.MPIID,.tSubmission,0,tAPRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tAPRequest.AssigningAuthority)_"&ISO")
	Set tDocument = tSubmission.Documents.GetAt(1) 
	Set tDocument.UniqueId="DocUniqueId990"
	Set tSubmission.UniqueId="SSUniqueId990"
	Set tSubmission.GenerateProvideAndRegisterOnly=1
	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tRequestMessage,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Document created without error")
	Set tContents = tRequestMessage.ContentStream.Read()
	For text = "XDSSubmissionSet.patientId","XDSDocumentEntry.patientId","XDSSubmissionSet.uniqueId","XDSDocumentEntry.uniqueId" {
		If $f(tContents,text) {
			Set tContents = $p(tContents,text,1)_$p(text,".",2)_$p(tContents,text,2)
		}		
	}
	Do tRequestMessage.ContentStream.Rewind()
	Do tRequestMessage.ContentStream.Write(tContents)

	Set t=##class(HS.Util.XSLTTransformer).%New()
	Set tSC = t.Transform(tContents,"IHE/XDSb/Version1/Message-To-Metadata.xsl",.tMetadataStream)
	Quit:'$$$AssertStatusOK(tSC,"Message to Metadata transform")
	Quit:'$$$AssertTrue(tMetadataStream[tDocument.UniqueId)
	Quit:'$$$AssertTrue(tMetadataStream[tSubmission.UniqueId)
	Set tPos = 0
	For tIdx=1,2 {
		Set tPos = $F(tMetadataStream,"<PatientId>"_tAPResponse.MPIID,tPos)
	}
	Quit:'$$$AssertTrue(tPos,"Found doc and submission patient id's")
	Do tRequestMessage.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequestMessage,.tResponseMessage,,.tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Document submitted without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tResponseMessage)
	Quit:'$$$AssertStatusOK(tSC,"Document created without error")
	Set tRS = ..FindAuditRecords(tHighAuditID,1,"R","ITI-41",.tCount)
	Quit:'$$$AssertTrue(tRS.SubmissionSetUniqueID=tSubmission.UniqueId,"Found SubmissionSet unique id in audit") 
	Quit:'$$$AssertTrue(tRS.DocumentId=tDocument.UniqueId,"Found document unique id in audit") 
	Quit:'$$$AssertTrue($li(tRS.MPIIDs)=tAPResponse.MPIID,"Found Patient ID in audit")
}

Method DeprecateDocuments(pQueryRequest As HS.Message.IHE.XDSb.QueryRequest)
{
	Do pQueryRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(pQueryRequest,.tResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error") tSC
	For tIdx = 1:1:tResponse.Documents.Count() {
		Set tDoc = tResponse.Documents.GetAt(tIdx)
		Set tSC = ..DeprecateDocument(tDoc)
		Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

Method DeprecateDocument(pDoc) As %Status
{
	#define DynamicCode(%object,%field,%multiple) Do ..DynamicCode(##quote(%field),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	#; Deprecate Document
	Set tUpdate2 = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
	Set tUpdate2.PatientId = pDoc.PatientId
	Set tUpdate2.SourceId = $P(pDoc.PatientId,"&",2)
	//Set tUpdate2.ContentTypeCode=pDoc.TypeCode
	$$$DynamicCode(tUpdate2,ContentTypeCode,0)
	Set tAssociation = ##class(HS.Message.IHE.XDSb.Association).%New()
	Set tAssociation.ParentUUID=tUpdate2.EntryUUID
	Set tAssociation.ChildUUID=pDoc.EntryUUID
	Set tAssociation.Type ="UpdateAvailabilityStatus"
	Set tAssociation.OriginalStatus="Approved"
	Set tAssociation.NewStatus="Deprecated"
	Do tUpdate2.Associations.Insert(tAssociation)
	Do tUpdate2.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate2,.tUpdateResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Status change completed without error") tSC
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Update completed without error") tSC
	Quit $$$OK
}

/// multiple folder updates https://usjira.iscinternal.com/browse/HSHC-2232 not updating version correctly
Method Test995HSHC2232()
{
	#define DynamicCode(%object,%field,%multiple,%table) Do ..DynamicCode(##quote(%table),.tCode,.tScheme,.tDescription) If tCode]"" { if '%multiple{Set %object.%field=##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription)} else {Do %object.%field.Insert(##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode,tScheme,tDescription))}}
	$$$HSTestBailout
	Set tAPRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tAPRequest.FirstName="HSHC"
	Set tAPRequest.LastName="2232Folders"
	Set tAPRequest.Sex="M"
	Set tAPRequest.DOB=tAPRequest.DOBDisplayToLogical("1990-04-01")
	Set tAPRequest.MRN="HSHC2232"
	Set tAPRequest.AssigningAuthority="EXTERNAL"
	Set tAPRequest.Facility="EXTERNAL"
	#; send request to test service
	Do tAPRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tAPRequest,.tAPResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient "_tAPResponse.MPIID)
	Quit:'$$$AssertTrue(tAPResponse.ErrStatus=""||(tAPResponse.ErrStatus=$$$OK),"Patient added without error")

	Set tSubmission = ##class(HS.Message.IHE.XDSb.ProvideAndRegisterRequest).%New()
	SET tSubmission.PatientId = tAPResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	Set tSubmission.SourceId=##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")
	$$$DynamicCode(tSubmission,ContentTypeCode,0,ContentTypeCode)
	Set tSubmission.Title = "Submission Set Title"
	Set tSubmission.Comments = "Submission Set Comments"

	Set tFolder = ##class(HS.Message.IHE.XDSb.Folder).%New()
	Set tFolder.PatientId=tSubmission.PatientId
	Set tFolder.Title="FolderTitle"
	Set tFolder.AvailabilityStatus="Approved"
	$$$DynamicCode(tFolder,CodeList,1,FolderCodeList)
	Do tSubmission.Folders.Insert(tFolder)
	Do tSubmission.AdditionalInfo.SetAt(..#DocumentSource,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tSubmission,.tSubmissionResponse,,.tSessionID)
	Do $$$LogMessage("Session: "_tSessionID)
	Quit:'$$$AssertStatusOK(tSC,"Document and folder submitted without error")

	Set tUpdate2 = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
	Set tUpdate2.PatientId = tFolder.PatientId
	Set tUpdate2.SourceId = tSubmission.SourceId
	Set tFolder.LogicalUUID=tFolder.EntryUUID
	Set tFolder.EntryUUID="FolderUpdate"
	Set tFolder.Title="UpdatedTitle"
	Do tUpdate2.Folders.Insert(tFolder)
	Do tUpdate2.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate2,.tFolderUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Status change completed without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tFolderUpdateResponse)

	Set tUpdate3 = ##class(HS.Message.IHE.XDSb.UpdateDocumentSetRequest).%New()
	Set tUpdate3.PatientId = tFolder.PatientId
	Set tUpdate3.SourceId = tSubmission.SourceId
	Set tFolder.EntryUUID="FolderUpdate"
	Set tFolder.Title="UpdatedTitleNew"
	Do tUpdate3.Folders.Insert(tFolder)
	Do tUpdate3.AdditionalInfo.SetAt(..#Administrator,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tUpdate3,.tFolderUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Status change completed without error")
	Set tSC = ##class(HS.IHE.XDSb.Util).ProcessResponse(tFolderUpdateResponse)
	Quit:'$$$AssertStatusOK(tSC,"Update processed without error")
	Set tFolderID=$S(tFolder.LogicalUUID["urn:uuid:":tFolder.LogicalUUID,1:"urn:uuid:"_tFolder.LogicalUUID)
	Set tRS = ##Class(%SQL.Statement).%ExecDirect(,"SELECT Top 1 Version from HS_Registry_Document.RegistryPackage where LogicalIID=? ORDER BY Version DESC",tFolderID)
	Do tRS.%Next()
	Quit:'$$$AssertTrue(tRS.Version=3,"Expected version 3 of folder found: "_tRS.Version)
}

XData XDataNoIndexItems
{
<Items>
  <Item Name="HS.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="QueryMaxCountBitmapParam">1</Setting>
  </Item>
</Items>
}

XData XDataRegularIndexItems
{
<Items>
  <Item Name="HS.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="QueryMaxCountBitmapParam">10000</Setting>
  </Item>
</Items>
}

XData XDataInlineDocument
{
<Items>
<Item Name="HS.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="DocumentsInline">1</Setting>
</Item>
</Items>
}

XData CCDDocument1
{
<?xml version="1.0" encoding="UTF-8"?> 
<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 CDA.xsd">
<!-- 
********************************************************
 CDA Header 
********************************************************
-->
<realmCode code="US"/>
<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
<templateId root="2.16.840.1.113883.10.20.1"/>
<templateId root="2.16.840.1.113883.10.20.2"/>
<templateId root="2.16.840.1.113883.10.20.3"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.1"/>
<templateId root="2.16.840.1.113883.3.88.11.32.1"/>
<id root="3e8fb01c-6fa7-42db-8b8f-c64d1fec061e"/>
<code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Summarization of episode note"/>
<title>Demo Hospital Continuity of Care Document</title>
<effectiveTime value="20110510102615-0500"/>
<confidentialityCode code="N" displayName="Normal" codeSystem="2.16.840.1.113883.5.25" codeSystemName="Confidentiality"/>
<languageCode code="en-US"/>
<recordTarget>
<patientRole>
<id extension="A7777777" root='{$method{##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")}}'/>
<addr>
<streetAddressLine>123 Main St</streetAddressLine>
<streetAddressLine>Suite 1100</streetAddressLine>
<city>Rosemont</city>
<state>Il</state>
<postalCode>60018</postalCode>
</addr>
<telecom value="tel:847-720-2200"/>
<patient>
<name>
<given>John</given>
<family>Smith</family>
</name>
<administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1"/>
<birthTime value="19800930"/>
</patient>
<providerOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</providerOrganization>
</patientRole>
</recordTarget>
<author>
<time value="20110510102615-0500"/>
<assignedAuthor>
<id root="bb27e853-b44c-419b-b17e-3e1f50a78171"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given>James</given>
<family>Jones</family>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id nullFlavor="NA"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedEntity>
</informant>
<custodian>
<assignedCustodian>
<representedCustodianOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="ASKU"/>
<addr nullFlavor="ASKU"/>
</representedCustodianOrganization>
</assignedCustodian>
</custodian>
<legalAuthenticator >
<time value="20110510102615"/>
<signatureCode code="U"/>
<assignedEntity>
<id nullFlavor="NI"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name></name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
</representedOrganization>
</assignedEntity>
</legalAuthenticator >
<documentationOf>
<serviceEvent classCode="PCPR">
<effectiveTime>
<low value="20091209081057"/>
<high value="20110510102615"/>
</effectiveTime>
<performer typeCode="PRF">
<assignedEntity>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
</representedOrganization>
</assignedEntity>
</performer>
</serviceEvent>
</documentationOf>
<!-- 
********************************************************
 CDA Body 
********************************************************
-->
<component>
<structuredBody>
<!-- 
********************************************************
Purpose Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.13"/>
<code code="48764-5" displayName="PURPOSE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Summary Purpose</title>
<text>Tranfer of care</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.30"/>
<code code="23745001" displayName="Documentation procedure" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
<statusCode code="completed"/>
<entryRelationship typeCode="RSON">
<act classCode="ACT" moodCode="EVN">
<code code="308292007" displayName="Transfer of care" codeSystem="2.16.840.1.113883.6.96"/>
<statusCode code="completed"/>
</act>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!-- 
********************************************************
Advance Directives Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.1"/>
<code code="42348-3" displayName="ADVANCE DIRECTIVES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Advance Directives</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Directives</th>
<th>Description</th>
<th>Verification</th>
<th>Supporting Document(s)</th>
</tr>
</thead>
<tbody>
<tr>
<td>No Known Directives</td>
<td>&#160;</td>
<td>&#160;</td>
<td>&#160;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
<!-- 
********************************************************
Alerts (Allergy, Adverse Reaction) Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.2"/>
<code code="48768-6" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Alerts (Allergy, Adverse Reaction)</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Substance</th>
<th>Reaction</th>
<th>Severity</th>
<th>Commment</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td ID="alg-0">ampicillin</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-0">Sob</td>
<td ID="cstat-0">Active</td>
</tr>
<tr>
<td ID="alg-1">Bactrim</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-1">Dysphagia</td>
<td ID="cstat-1">Active</td>
</tr>
<tr>
<td ID="alg-2">Codeine Sulfate</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-2">Anaphylaxis</td>
<td ID="cstat-2">Active</td>
</tr>
<tr>
<td ID="alg-3">Latex</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-3">Latex</td>
<td ID="cstat-3">Active</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="eebe1d5f-11f5-4ea6-9fa5-07f2abe703f1"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="afa5f159-8edf-4694-8dc3-dd781520098a"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="416098002" codeSystem="2.16.840.1.113883.6.96" displayName="Drug Allergy"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-0"/></originalText>
</code>
<name>ampicillin</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-0"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-0"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="416090f8-e1e8-4202-a491-99c029692e2a"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="de5be386-f987-4f04-8992-a1adf7816cb5"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="416098002" codeSystem="2.16.840.1.113883.6.96" displayName="Drug Allergy"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-1"/></originalText>
</code>
<name>Bactrim</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-1"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-1"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="1c580099-3fc6-413d-b4c5-b11d64427c3d"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="01a81fa7-5993-46f9-8c32-cf3a01b38e56"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="419199007" codeSystem="2.16.840.1.113883.6.96" displayName="Allergy to substance"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-2"/></originalText>
</code>
<name>Codeine Sulfate</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-2"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-2"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="8c6b0dd5-d957-4e7e-b5d0-d43506e1886e"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="90524101-2d8f-4846-a9b1-dc18d21e0425"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="419199007" codeSystem="2.16.840.1.113883.6.96" displayName="Allergy to substance"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-3"/></originalText>
</code>
<name>Latex</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-3"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-3"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!-- 
********************************************************
Medications Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.8"/>
<code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Medications</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Medication</th>
<th>Instructions</th>
<th>Date</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td ID="med-0">Ciprofloxacin</td>
<td>    Entered brand: Cipro 250 mg oral tablet</td>
<td>Dec 09, 2009 08:10</td>
<td>Active</td>
</tr>
<tr>
<td ID="med-1">Lapase</td>
<td>50 MG ORAL BID</td>
<td>Apr 05, 2011 13:31</td>
<td>Active</td>
</tr>
</tbody>
</table>
</text>
<informant>
<assignedEntity>
<id nullFlavor="NA"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedEntity>
</informant>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.24"/>
<id root="be13d63e-fa87-419a-848f-a46fa8fbff4a"/>
<statusCode code="active"/>
<effectiveTime xsi:type="IVL_TS">
<low value="20091209081000"/>
<high nullFlavor="UNK"/>
</effectiveTime>
<routeCode code="UNK"/>
<consumable>
<manufacturedProduct>
<templateId root="2.16.840.1.113883.10.20.1.53"/>
<manufacturedMaterial>
<code>
<originalText>
<reference value="#med-0">
</reference>
</originalText>
</code>
<name>Ciprofloxacin</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<precondition>
<criterion>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<text>
<reference value="#precon-0"/>
</text>
</criterion>
</precondition>
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.24"/>
<id root="3c71786c-ed0c-4a13-a2b2-9c90f746f618"/>
<statusCode code="active"/>
<effectiveTime xsi:type="IVL_TS">
<low value="20110405133100"/>
<high nullFlavor="UNK"/>
</effectiveTime>
<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
<period value="12" unit="h">
</period>
</effectiveTime>
<routeCode code="ORAL" displayName="PO" codeSystem="2.16.840.1.113883.5.112" codeSystemName="RouteOfAdministration"/>
<doseQuantity value="50"/>
<administrationUnitCode code="MG" codeSystem="2.16.840.1.113883.6.96" displayName="UNK"/>
<consumable>
<manufacturedProduct>
<templateId root="2.16.840.1.113883.10.20.1.53"/>
<manufacturedMaterial>
<code>
<originalText>
<reference value="#med-1">
</reference>
</originalText>
</code>
<name>Lapase</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
</substanceAdministration>
</entry>
</section>
</component>
<!-- 
********************************************************
Problems Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.11"/>
<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Problems</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>No Known Problems</td>
<td>&#160;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
<!-- 
********************************************************
Procedures Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.12"/>
<code code="47519-4" displayName="History of procedures" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Procedures</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td> IV</td>
<td> SITE 1-  Patient&apos;s identity verified by;  patient stating name;  hospital ID bracelet;  20 gauge catheter inserted;  Site of IV: into left antecubital;  in 1 attempt;  Saline lock established, flushed with normal saline;  amount 10;  ml;  Labs drawn at time of placement;  Specimen labeled in the presence of the patient and sent to lab;  After procedure, no swelling noted at site;  After procedure, no drainage noted at site;  After procedure, no redness;  2x3 ensure dressing applied;  Patient tolerated procedure well;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
</structuredBody>
</component>
</ClinicalDocument>
}

XData CCDDocument2
{
<?xml version="1.0" encoding="UTF-8"?> 
<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 CDA.xsd">
<!-- 
********************************************************
 CDA Header 
********************************************************
-->
<realmCode code="US"/>
<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
<templateId root="2.16.840.1.113883.10.20.1"/>
<templateId root="2.16.840.1.113883.10.20.2"/>
<templateId root="2.16.840.1.113883.10.20.3"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.1"/>
<templateId root="2.16.840.1.113883.3.88.11.32.1"/>
<id root="3e8fb01c-6fa7-42db-8b8f-c64d1fec061e"/>
<code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Summarization of episode note"/>
<title>Demo Hospital Continuity of Care Document</title>
<effectiveTime value="20110510102615-0500"/>
<confidentialityCode code="N" displayName="Normal" codeSystem="2.16.840.1.113883.5.25" codeSystemName="Confidentiality"/>
<languageCode code="en-US"/>
<recordTarget>
<patientRole>
<id extension="A8888888" root='{$method{##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")}}'/>
<addr>
<streetAddressLine>123 Frood Road</streetAddressLine>
<city>Sudbury</city>
<state>MA</state>
<postalCode>22222</postalCode>
</addr>
<telecom value="tel:555-555-1212"/>
<patient>
<name>
<given>Jane</given>
<family>Smith</family>
</name>
<administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1"/>
<birthTime value="19801015"/>
</patient>
<providerOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</providerOrganization>
</patientRole>
</recordTarget>
<author>
<time value="20110510102615-0500"/>
<assignedAuthor>
<id root="bb27e853-b44c-419b-b17e-3e1f50a78171"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given>James</given>
<family>Jones</family>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id nullFlavor="NA"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedEntity>
</informant>
<custodian>
<assignedCustodian>
<representedCustodianOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="ASKU"/>
<addr nullFlavor="ASKU"/>
</representedCustodianOrganization>
</assignedCustodian>
</custodian>
<legalAuthenticator >
<time value="20110510102615"/>
<signatureCode code="U"/>
<assignedEntity>
<id nullFlavor="NI"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name></name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
</representedOrganization>
</assignedEntity>
</legalAuthenticator >
<documentationOf>
<serviceEvent classCode="PCPR">
<effectiveTime>
<low value="20091209081057"/>
<high value="20110510102615"/>
</effectiveTime>
<performer typeCode="PRF">
<assignedEntity>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
</representedOrganization>
</assignedEntity>
</performer>
</serviceEvent>
</documentationOf>
<!-- 
********************************************************
 CDA Body 
********************************************************
-->
<component>
<structuredBody>
<!-- 
********************************************************
Purpose Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.13"/>
<code code="48764-5" displayName="PURPOSE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Summary Purpose</title>
<text>Tranfer of care</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.30"/>
<code code="23745001" displayName="Documentation procedure" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
<statusCode code="completed"/>
<entryRelationship typeCode="RSON">
<act classCode="ACT" moodCode="EVN">
<code code="308292007" displayName="Transfer of care" codeSystem="2.16.840.1.113883.6.96"/>
<statusCode code="completed"/>
</act>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!-- 
********************************************************
Advance Directives Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.1"/>
<code code="42348-3" displayName="ADVANCE DIRECTIVES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Advance Directives</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Directives</th>
<th>Description</th>
<th>Verification</th>
<th>Supporting Document(s)</th>
</tr>
</thead>
<tbody>
<tr>
<td>No Known Directives</td>
<td>&#160;</td>
<td>&#160;</td>
<td>&#160;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
<!-- 
********************************************************
Alerts (Allergy, Adverse Reaction) Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.2"/>
<code code="48768-6" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Alerts (Allergy, Adverse Reaction)</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Substance</th>
<th>Reaction</th>
<th>Severity</th>
<th>Commment</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td ID="alg-0">ampicillin</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-0">Sob</td>
<td ID="cstat-0">Active</td>
</tr>
<tr>
<td ID="alg-1">Bactrim</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-1">Dysphagia</td>
<td ID="cstat-1">Active</td>
</tr>
<tr>
<td ID="alg-2">Codeine Sulfate</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-2">Anaphylaxis</td>
<td ID="cstat-2">Active</td>
</tr>
<tr>
<td ID="alg-3">Latex</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-3">Latex</td>
<td ID="cstat-3">Active</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="eebe1d5f-11f5-4ea6-9fa5-07f2abe703f1"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="afa5f159-8edf-4694-8dc3-dd781520098a"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="416098002" codeSystem="2.16.840.1.113883.6.96" displayName="Drug Allergy"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-0"/></originalText>
</code>
<name>ampicillin</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-0"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-0"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="416090f8-e1e8-4202-a491-99c029692e2a"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="de5be386-f987-4f04-8992-a1adf7816cb5"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="416098002" codeSystem="2.16.840.1.113883.6.96" displayName="Drug Allergy"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-1"/></originalText>
</code>
<name>Bactrim</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-1"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-1"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="1c580099-3fc6-413d-b4c5-b11d64427c3d"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="01a81fa7-5993-46f9-8c32-cf3a01b38e56"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="419199007" codeSystem="2.16.840.1.113883.6.96" displayName="Allergy to substance"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-2"/></originalText>
</code>
<name>Codeine Sulfate</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-2"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-2"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="8c6b0dd5-d957-4e7e-b5d0-d43506e1886e"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="90524101-2d8f-4846-a9b1-dc18d21e0425"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="419199007" codeSystem="2.16.840.1.113883.6.96" displayName="Allergy to substance"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-3"/></originalText>
</code>
<name>Latex</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-3"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-3"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!-- 
********************************************************
Medications Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.8"/>
<code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Medications</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Medication</th>
<th>Instructions</th>
<th>Date</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td ID="med-0">Ciprofloxacin</td>
<td>    Entered brand: Cipro 250 mg oral tablet</td>
<td>Dec 09, 2009 08:10</td>
<td>Active</td>
</tr>
<tr>
<td ID="med-1">Lapase</td>
<td>50 MG ORAL BID</td>
<td>Apr 05, 2011 13:31</td>
<td>Active</td>
</tr>
</tbody>
</table>
</text>
<informant>
<assignedEntity>
<id nullFlavor="NA"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedEntity>
</informant>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.24"/>
<id root="be13d63e-fa87-419a-848f-a46fa8fbff4a"/>
<statusCode code="active"/>
<effectiveTime xsi:type="IVL_TS">
<low value="20091209081000"/>
<high nullFlavor="UNK"/>
</effectiveTime>
<routeCode code="UNK"/>
<consumable>
<manufacturedProduct>
<templateId root="2.16.840.1.113883.10.20.1.53"/>
<manufacturedMaterial>
<code>
<originalText>
<reference value="#med-0">
</reference>
</originalText>
</code>
<name>Ciprofloxacin</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<precondition>
<criterion>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<text>
<reference value="#precon-0"/>
</text>
</criterion>
</precondition>
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.24"/>
<id root="3c71786c-ed0c-4a13-a2b2-9c90f746f618"/>
<statusCode code="active"/>
<effectiveTime xsi:type="IVL_TS">
<low value="20110405133100"/>
<high nullFlavor="UNK"/>
</effectiveTime>
<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
<period value="12" unit="h">
</period>
</effectiveTime>
<routeCode code="ORAL" displayName="PO" codeSystem="2.16.840.1.113883.5.112" codeSystemName="RouteOfAdministration"/>
<doseQuantity value="50"/>
<administrationUnitCode code="MG" codeSystem="2.16.840.1.113883.6.96" displayName="UNK"/>
<consumable>
<manufacturedProduct>
<templateId root="2.16.840.1.113883.10.20.1.53"/>
<manufacturedMaterial>
<code>
<originalText>
<reference value="#med-1">
</reference>
</originalText>
</code>
<name>Lapase</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
</substanceAdministration>
</entry>
</section>
</component>
<!-- 
********************************************************
Problems Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.11"/>
<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Problems</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>No Known Problems</td>
<td>&#160;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
<!-- 
********************************************************
Procedures Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.12"/>
<code code="47519-4" displayName="History of procedures" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Procedures</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td> IV</td>
<td> SITE 1-  Patient&apos;s identity verified by;  patient stating name;  hospital ID bracelet;  20 gauge catheter inserted;  Site of IV: into left antecubital;  in 1 attempt;  Saline lock established, flushed with normal saline;  amount 10;  ml;  Labs drawn at time of placement;  Specimen labeled in the presence of the patient and sent to lab;  After procedure, no swelling noted at site;  After procedure, no drainage noted at site;  After procedure, no redness;  2x3 ensure dressing applied;  Patient tolerated procedure well;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
</structuredBody>
</component>
</ClinicalDocument>
}

XData CCDDocument3
{
<?xml version="1.0" encoding="UTF-8"?> 
<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 CDA.xsd">
<!-- 
********************************************************
 CDA Header 
********************************************************
-->
<realmCode code="US"/>
<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
<templateId root="2.16.840.1.113883.10.20.1"/>
<templateId root="2.16.840.1.113883.10.20.2"/>
<templateId root="2.16.840.1.113883.10.20.3"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.1.1"/>
<templateId root="2.16.840.1.113883.3.88.11.32.1"/>
<id root="3e8fb01c-6fa7-42db-8b8f-c64d1fec061e"/>
<code code="34133-9" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Summarization of episode note"/>
<title>Demo Hospital Continuity of Care Document</title>
<effectiveTime value="20110510102615-0500"/>
<confidentialityCode code="N" displayName="Normal" codeSystem="2.16.840.1.113883.5.25" codeSystemName="Confidentiality"/>
<languageCode code="en-US"/>
<recordTarget>
<patientRole>
<id extension="A9999999" root='{$method{##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")}}'/>
<addr>
<streetAddressLine>123 Any St</streetAddressLine>
<city>AnyTown</city>
<state>MA</state>
<postalCode>02142</postalCode>
</addr>
<telecom value="tel:888-711-1200"/>
<patient>
<name>
<given>Jack</given>
<family>Black</family>
</name>
<administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1"/>
<birthTime value="19761115"/>
</patient>
<providerOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</providerOrganization>
</patientRole>
</recordTarget>
<author>
<time value="20110510102615-0500"/>
<assignedAuthor>
<id root="bb27e853-b44c-419b-b17e-3e1f50a78171"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given>James</given>
<family>Jones</family>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id nullFlavor="NA"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedEntity>
</informant>
<custodian>
<assignedCustodian>
<representedCustodianOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="ASKU"/>
<addr nullFlavor="ASKU"/>
</representedCustodianOrganization>
</assignedCustodian>
</custodian>
<legalAuthenticator >
<time value="20110510102615"/>
<signatureCode code="U"/>
<assignedEntity>
<id nullFlavor="NI"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name></name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
</representedOrganization>
</assignedEntity>
</legalAuthenticator >
<documentationOf>
<serviceEvent classCode="PCPR">
<effectiveTime>
<low value="20091209081057"/>
<high value="20110510102615"/>
</effectiveTime>
<performer typeCode="PRF">
<assignedEntity>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<addr nullFlavor="UNK"/>
<telecom nullFlavor="UNK"/>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"/>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr nullFlavor="UNK"/>
</representedOrganization>
</assignedEntity>
</performer>
</serviceEvent>
</documentationOf>
<!-- 
********************************************************
 CDA Body 
********************************************************
-->
<component>
<structuredBody>
<!-- 
********************************************************
Purpose Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.13"/>
<code code="48764-5" displayName="PURPOSE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Summary Purpose</title>
<text>Tranfer of care</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.30"/>
<code code="23745001" displayName="Documentation procedure" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
<statusCode code="completed"/>
<entryRelationship typeCode="RSON">
<act classCode="ACT" moodCode="EVN">
<code code="308292007" displayName="Transfer of care" codeSystem="2.16.840.1.113883.6.96"/>
<statusCode code="completed"/>
</act>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!-- 
********************************************************
Advance Directives Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.1"/>
<code code="42348-3" displayName="ADVANCE DIRECTIVES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Advance Directives</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Directives</th>
<th>Description</th>
<th>Verification</th>
<th>Supporting Document(s)</th>
</tr>
</thead>
<tbody>
<tr>
<td>No Known Directives</td>
<td>&#160;</td>
<td>&#160;</td>
<td>&#160;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
<!-- 
********************************************************
Alerts (Allergy, Adverse Reaction) Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.2"/>
<code code="48768-6" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Alerts (Allergy, Adverse Reaction)</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Substance</th>
<th>Reaction</th>
<th>Severity</th>
<th>Commment</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td ID="alg-0">ampicillin</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-0">Sob</td>
<td ID="cstat-0">Active</td>
</tr>
<tr>
<td ID="alg-1">Bactrim</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-1">Dysphagia</td>
<td ID="cstat-1">Active</td>
</tr>
<tr>
<td ID="alg-2">Codeine Sulfate</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-2">Anaphylaxis</td>
<td ID="cstat-2">Active</td>
</tr>
<tr>
<td ID="alg-3">Latex</td>
<td>&#160;</td>
<td>&#160;</td>
<td ID="comm-3">Latex</td>
<td ID="cstat-3">Active</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="eebe1d5f-11f5-4ea6-9fa5-07f2abe703f1"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="afa5f159-8edf-4694-8dc3-dd781520098a"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="416098002" codeSystem="2.16.840.1.113883.6.96" displayName="Drug Allergy"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-0"/></originalText>
</code>
<name>ampicillin</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-0"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-0"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="416090f8-e1e8-4202-a491-99c029692e2a"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="de5be386-f987-4f04-8992-a1adf7816cb5"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="416098002" codeSystem="2.16.840.1.113883.6.96" displayName="Drug Allergy"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-1"/></originalText>
</code>
<name>Bactrim</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-1"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-1"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="1c580099-3fc6-413d-b4c5-b11d64427c3d"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="01a81fa7-5993-46f9-8c32-cf3a01b38e56"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="419199007" codeSystem="2.16.840.1.113883.6.96" displayName="Allergy to substance"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-2"/></originalText>
</code>
<name>Codeine Sulfate</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-2"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-2"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode="DRIV">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.27"/>
<id root="8c6b0dd5-d957-4e7e-b5d0-d43506e1886e"/>
<code nullFlavor="NA"/>
<statusCode code="active"/>
<effectiveTime>
<low nullFlavor="UNK"/>
</effectiveTime>
<entryRelationship typeCode="SUBJ">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.18"/>
<id root="90524101-2d8f-4846-a9b1-dc18d21e0425"/>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<statusCode code="completed"/>
<value xsi:type="CD" code="419199007" codeSystem="2.16.840.1.113883.6.96" displayName="Allergy to substance"/>
<participant typeCode="CSM">
<participantRole classCode="MANU">
<playingEntity classCode="MMAT">
<code>
<originalText><reference value="#alg-3"/></originalText>
</code>
<name>Latex</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode="REFR" inversionInd="false">
<observation classCode="OBS" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.39"/>
<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Status"/>
<text><reference value="cstat-3"/></text>
<statusCode code="completed"/>
<value xsi:type="CD" code="55561003" displayName="Active" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode="SUBJ" inversionInd="true">
<act classCode="ACT" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.40"/>
<templateId root="1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code="48767-8" displayName="Annotation Comment" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<text><reference value="#comm-3"/></text>
<statusCode code="completed"/>
</act>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
</section>
</component>
<!-- 
********************************************************
Medications Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.8"/>
<code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Medications</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Medication</th>
<th>Instructions</th>
<th>Date</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td ID="med-0">Ciprofloxacin</td>
<td>    Entered brand: Cipro 250 mg oral tablet</td>
<td>Dec 09, 2009 08:10</td>
<td>Active</td>
</tr>
<tr>
<td ID="med-1">Lapase</td>
<td>50 MG ORAL BID</td>
<td>Apr 05, 2011 13:31</td>
<td>Active</td>
</tr>
</tbody>
</table>
</text>
<informant>
<assignedEntity>
<id nullFlavor="NA"/>
<addr/>
<telecom nullFlavor="UNK"/>
<assignedPerson>
<name>
<given/>
<family/>
</name>
</assignedPerson>
<representedOrganization>
<id root="1.3.6.1.4.1.21367.2010.1.2.777"></id>
<name>Demo Hospital</name>
<telecom nullFlavor="UNK"/>
<addr/>
</representedOrganization>
</assignedEntity>
</informant>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.24"/>
<id root="be13d63e-fa87-419a-848f-a46fa8fbff4a"/>
<statusCode code="active"/>
<effectiveTime xsi:type="IVL_TS">
<low value="20091209081000"/>
<high nullFlavor="UNK"/>
</effectiveTime>
<routeCode code="UNK"/>
<consumable>
<manufacturedProduct>
<templateId root="2.16.840.1.113883.10.20.1.53"/>
<manufacturedMaterial>
<code>
<originalText>
<reference value="#med-0">
</reference>
</originalText>
</code>
<name>Ciprofloxacin</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<precondition>
<criterion>
<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
<text>
<reference value="#precon-0"/>
</text>
</criterion>
</precondition>
</substanceAdministration>
</entry>
<entry typeCode="DRIV">
<substanceAdministration classCode="SBADM" moodCode="EVN">
<templateId root="2.16.840.1.113883.10.20.1.24"/>
<id root="3c71786c-ed0c-4a13-a2b2-9c90f746f618"/>
<statusCode code="active"/>
<effectiveTime xsi:type="IVL_TS">
<low value="20110405133100"/>
<high nullFlavor="UNK"/>
</effectiveTime>
<effectiveTime xsi:type="PIVL_TS" institutionSpecified="true" operator="A">
<period value="12" unit="h">
</period>
</effectiveTime>
<routeCode code="ORAL" displayName="PO" codeSystem="2.16.840.1.113883.5.112" codeSystemName="RouteOfAdministration"/>
<doseQuantity value="50"/>
<administrationUnitCode code="MG" codeSystem="2.16.840.1.113883.6.96" displayName="UNK"/>
<consumable>
<manufacturedProduct>
<templateId root="2.16.840.1.113883.10.20.1.53"/>
<manufacturedMaterial>
<code>
<originalText>
<reference value="#med-1">
</reference>
</originalText>
</code>
<name>Lapase</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
</substanceAdministration>
</entry>
</section>
</component>
<!-- 
********************************************************
Problems Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.11"/>
<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Problems</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>No Known Problems</td>
<td>&#160;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
<!-- 
********************************************************
Procedures Section
********************************************************
-->
<component>
<section>
<templateId root="2.16.840.1.113883.10.20.1.12"/>
<code code="47519-4" displayName="History of procedures" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
<title>Procedures</title>
<text>
<table border="1" width="100%">
<thead>
<tr>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td> IV</td>
<td> SITE 1-  Patient&apos;s identity verified by;  patient stating name;  hospital ID bracelet;  20 gauge catheter inserted;  Site of IV: into left antecubital;  in 1 attempt;  Saline lock established, flushed with normal saline;  amount 10;  ml;  Labs drawn at time of placement;  Specimen labeled in the presence of the patient and sent to lab;  After procedure, no swelling noted at site;  After procedure, no drainage noted at site;  After procedure, no redness;  2x3 ensure dressing applied;  Patient tolerated procedure well;</td>
</tr>
</tbody>
</table>
</text>
</section>
</component>
</structuredBody>
</component>
</ClinicalDocument>
}

XData CCDMultiAddress
{
<ClinicalDocument xmlns = "urn:hl7-org:v3" xmlns:sdtc = "urn:hl7-org:sdtc" xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation = "urn:hl7-org:v3 http://xreg2.nist.gov:8080/hitspValidation/schema/cdar2c32/infrastructure/cda/C32_CDA.xsd">
<realmCode code = "US"/>
<typeId root = "2.16.840.1.113883.1.3" extension = "POCD_HD000040"/>
<templateId root = "2.16.840.1.113883.3.27.1776" assigningAuthorityName = "CDA/R2"/>
<templateId root = "2.16.840.1.113883.10.20.3" assigningAuthorityName = "HL7/CDT Header"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.1.1" assigningAuthorityName = "IHE/PCC"/>
<templateId root = "2.16.840.1.113883.3.88.11.32.1" assigningAuthorityName = "HITSP/C32"/>
<templateId root = "2.16.840.1.113883.10.20.10" assigningAuthorityName = "CDA4CDT Level 1"/>
<templateId root = "2.16.840.1.113883.10.20.20" assigningAuthorityName = "CDA4CDT Level 2"/>
<templateId root = "2.16.840.1.113883.10.20.30" assigningAuthorityName = "CDA4CDT Level 3"/>
<id root = "2.16.840.1.113883.3.86.3" extension = "ISC_CORP_ANNOTATED_MODEL_C32" assigningAuthorityName = "InterSystems"/>
<code code = "34133-9" displayName = "Summarization of episode note" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<title>C32 for Patient1 MRN1a</title>
<effectiveTime value = "20111020130945"/>
<confidentialityCode/>
<languageCode code = "en-US"/>
<recordTarget>
<patientRole>
<id root = "2.16.840.1.113883.3.86.3" extension = "MRN1a"/>
<addr use = "HP">
<streetAddressLine>20 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<addr use = "WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<telecom use = "HP" value = "tel:6472253133"/>
<telecom use = "WP" value = "tel:8001111111;ext=1234"/>
<telecom use = "MC" value = "tel:6472222222"/>
<telecom value = "mailto:testatintersystems.com"/>
<patient>
<name>
<prefix/>
<given>One</given>
<given></given>
<family>Patient</family>
<suffix></suffix>
</name>
<administrativeGenderCode code = "M" codeSystem = "2.16.840.1.113883.5.1" codeSystemName = "AdministrativeGenderCode" displayName = "Male"/>
<birthTime value = "19000101000000"/>
<maritalStatusCode code = "M" codeSystem = "2.16.840.1.113883.5.2" codeSystemName = "MaritalStatus" displayName = "Married"/>
<religiousAffiliationCode code = "1022" displayName = "Independent" codeSystem = "2.16.840.1.113883.5.1076" codeSystemName = "religiousAffiliation"/>
<raceCode code = "2106-3" codeSystem = "2.16.840.1.113883.6.238" codeSystemName = "Race" displayName = "White"/>
<ethnicGroupCode code = "2186-5" displayName = "Not Hispanic or Latino" codeSystem = "2.16.840.1.113883.6.238" codeSystemName = "CDC Race and Ethnicity"/>
<languageCommunication>
<templateId root = "2.16.840.1.113883.3.88.11.83.2"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.2.1"/>
<languageCode code = "en"/>
<preferenceInd value = "true"/>
</languageCommunication>
</patient>
</patientRole>
</recordTarget>
<author typeCode = "AUT">
<time value = "20111013142100"/>
<assignedAuthor classCode = "ASSIGNED">
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<addr use = "WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.86" extension = "2.16.840.1.113883.3.86"/>
<name>Intersystems Corporation</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "UNK"/>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.86.3"/>
<name>HealthShare</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "2.16.840.1.113883.3.86"/>
<name>InterSystems Corporation</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
<custodian>
<assignedCustodian>
<representedCustodianOrganization>
<id root = "2.16.840.1.113883.3.86" extension = "2.16.840.1.113883.3.86"/>
<name>InterSystems Corporation</name>
<telecom/>
<addr/>
</representedCustodianOrganization>
</assignedCustodian>
</custodian>
<legalAuthenticator typeCode = "LA" contextControlCode = "OP">
<time value = "20111013142100-0300"/>
<signatureCode code = "s"/>
<assignedEntity>
<id nullFlavor = "UNK"/><!--Null IDs must be expressed as nullFlavor-->
<addr use = "WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
<telecom use = "WP" value = "tel:+13122919000"/>
<assignedPerson>
<name use = "L">
<given>John</given>
<given>Q</given>
<family>Authenticator</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.86.3"/>
<name>HealthShare</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "HP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "2.16.840.1.113883.3.86" extension = "2.16.840.1.113883.3.86"/>
<name>Intersystems Corporation</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "HP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</legalAuthenticator>
<participant typeCode = "IND">
<templateId root = "2.16.840.1.113883.3.88.11.83.3" assigningAuthorityName = "HITSP/C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.2.4" assigningAuthorityName = "IHE/PCC"/>
<time value = "20101014"/>
<associatedEntity classCode = "NOK">
<code code = "GRMTH" displayName = "Grandmother" codeSystem = "2.16.840.1.113883.5.111" codeSystemName = "RoleCode"/>
<addr use = "HP">
<streetAddressLine>7 Woodlands Way</streetAddressLine>
<city>Abington</city>
<state>MA</state>
<postalCode>02351</postalCode>
<country>USA</country>
</addr>
<telecom use = "HP" value = "tel:6472253133"/>
<associatedPerson>
<name>
<prefix/>
<given>GRANNIE</given>
<given>P</given>
<family>RUBLIC</family>
<suffix/>
</name>
</associatedPerson>
</associatedEntity>
</participant>
<participant typeCode = "IND">
<associatedEntity classCode = "CAREGIVER">
<code code = "STPDAU" displayName = "Step-Daughter" codeSystem = "2.16.840.1.113883.5.111" codeSystemName = "RoleCode"/>
<addr>
<streetAddressLine>1500 86th Street</streetAddressLine>
<city>Brooklyn</city>
<state>NY</state>
<postalCode>11228</postalCode>
<country>USA</country>
</addr>
<telecom use = "HP" value = "tel:+1-718-555-9856"/>
<telecom use = "WP" value = "tel:+1-800-867-5309"/>
<associatedPerson>
<name use = "L">
<given>Jenny</given>
<family>Igotyournumber</family>
</name>
</associatedPerson>
</associatedEntity>
</participant>
<documentationOf typeCode = "DOC">
<serviceEvent classCode = "PCPR">
<effectiveTime>
<low value = "20020601"/>
<high value = "20111013"/>
</effectiveTime>
<performer typeCode = "PRF">
<templateId root = "2.16.840.1.113883.3.88.11.83.4" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.2.3" assigningAuthorityName = "IHE PCC"/>
<functionCode code = "PP" displayName = "Primary Care Provider" codeSystem = "2.16.840.1.113883.12.443" codeSystemName = "HL7 Provider Role">
<originalText>Primary Care Provider</originalText>
</functionCode>
<time>
<low value = "20020716"/>
<high value = "20111013"/>
</time>
<assignedEntity>
<id extension = "Unknown" root = "2.16.840.1.113883.4.6" assigningAuthorityName = "NPI"/>
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<code code = "200000000X" displayName = "Allopathic &amp; Osteopathic Physicians" codeSystemName = "Provider Codes" codeSystem = "2.16.840.1.113883.6.101"/>
<addr use = "HP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.72.5"/>
<name>NIST HL7 Test Laboratory</name>
<telecom/>
<addr/>
</representedOrganization>
</assignedEntity>
</performer>
<performer typeCode = "PRF">
<templateId root = "2.16.840.1.113883.3.88.11.83.4" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.2.3" assigningAuthorityName = "IHE PCC"/>
<functionCode code = "PP" displayName = "Primary Care Provider" codeSystem = "2.16.840.1.113883.12.443" codeSystemName = "HL7 Provider Role">
<originalText>Primary Care Provider</originalText>
</functionCode>
<time>
<low value = "20020716"/>
<high value = "20070915"/>
</time>
<assignedEntity>
<id extension = "Unknown" root = "2.16.840.1.113883.4.6" assigningAuthorityName = "NPI"/>
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<code code = "200000000X" displayName = "Allopathic and Osteopathic Physicians" codeSystemName = "Provider Codes" codeSystem = "2.16.840.1.113883.6.101"/>
<addr/>
<telecom value = "tel:+1-301-975-3251" use = "HP"/>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.72.5"/>
<name>NIST HL7 Test Laboratory</name>
<telecom/>
<addr/>
</representedOrganization>
</assignedEntity>
</performer>
</serviceEvent>
</documentationOf>
<component>
<structuredBody>
<component>
<section>
<templateId root = "2.16.840.1.113883.3.88.11.83.102" assigningAuthorityName = "HITSP/C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.13" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.2" assigningAuthorityName = "HL7 CCD"/>
<code code = "48765-2" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Allergies"/>
<title>Allergies and Adverse Reactions</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Type</th>
<th>Substance</th>
<th>Reaction</th>
<th>Severity</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr ID = "ALGSUMMARY_1">
<td ID = "ALGTYPE_1">Drug Allergy</td>
<td ID = "ALGSUB_1">Penicillin</td>
<td ID = "ALGREACT_1">Hives</td>
<td ID = "ALGSEV_1">Moderate</td>
<td ID = "ALGSTATUS_1">Active</td>
</tr>
<tr ID = "ALGSUMMARY_2">
<td ID = "ALGTYPE_2">Drug Intolerance</td>
<td ID = "ALGSUB_2">Aspirin</td>
<td ID = "ALGREACT_2">Wheezing</td>
<td ID = "ALGSEV_2">Mild</td>
<td ID = "ALGSTATUS_2">Active</td>
</tr>
<tr ID = "ALGSUMMARY_3">
<td ID = "ALGTYPE_3">Drug Intolerance</td>
<td ID = "ALGSUB_3">Codeine</td>
<td ID = "ALGREACT_3">Nausea</td>
<td ID = "ALGSEV_3">Fatal</td>
<td ID = "ALGSTATUS_3">Active</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.6" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.27" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.3" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.1" assigningAuthorityName = "IHE PCC"/>
<id root = "36e3e930-7b14-11db-9fe1-0800200c9a66"/>
<code nullFlavor = "NA"/>
<statusCode code = "active"/>
<effectiveTime value = "20111024000000-0300">
<low value = "20020101"/>
</effectiveTime>
<entryRelationship typeCode = "SUBJ" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.6" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.18" assigningAuthorityName = "CCD"/>
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<id root = "4adc1020-7b14-11db-9fe1-0800200c9a66"/>
<code code = "416098002" codeSystem = "2.16.840.1.113883.6.96" displayName = "drug allergy" codeSystemName = "SNOMED CT"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<text>
<reference value = "#ALGSUMMARY_1"/>
</text>
<statusCode code = "completed"/>
<value xsi:type = "CD" code = "70618" codeSystem = "2.16.840.1.113883.6.88" displayName = "Penicillin" codeSystemName = "RxNorm">
<originalText>
<reference value = "#ALGSUB_1"/>
</originalText>
</value>
<participant typeCode = "CSM">
<participantRole classCode = "MANU">
<addr/>
<telecom/>
<playingEntity classCode = "MMAT">
<code code = "70618" codeSystem = "2.16.840.1.113883.6.88" displayName = "Penicillin" codeSystemName = "RxNorm">
<originalText>
<reference value = "#ALGSUB_1"/>
</originalText>
</code>
<name>Penicillin</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode = "MFST" inversionInd = "true">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"/>
<templateId root = "2.16.840.1.113883.10.20.1.54"/>
<templateId root = "2.16.840.1.113883.10.20.1.28"/>
<id nullflavor = "UNK"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<code code = "ASSERTION" codeSystem = "2.16.840.1.113883.5.4"/>
<statusCode code = "completed"/>
<value xsi:type = "CD" code = "247472004" codeSystem = "2.16.840.1.113883.6.96" displayName = "Hives">
<originalText>
<reference value = "#ALGREACT_1"/>
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.55" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.1"/>
<code code = "SEV" displayName = "Severity" codeSystemName = "HL7 ActCode" codeSystem = "2.16.840.1.113883.5.4"/>
<text>
<reference value = "#ALGSEV_1"/>
</text>
<statusCode code = "completed"/>
<value xsi:type = "CD" displayName = "moderate" code = "6736007" codeSystemName = "SNOMED" codeSystem = "2.16.840.1.113883.6.96"></value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.39"/>
<code code = "33999-4" codeSystem = "2.16.840.1.113883.6.1" displayName = "Status"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "55561003" codeSystem = "2.16.840.1.113883.6.96" displayName = "Active">
<originalText>
<reference value = "#ALGSTATUS_1"/>
</originalText>
</value>
</observation>
</entryRelationship>
<author typeCode = "AUT">
<time value = "20111002000000-0300"/>
<assignedAuthor classCode = "ASSIGNED">
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<code code = "200000000X" displayName = "Allopathic and Osteopathic Physicians" codeSystemName = "Provider Codes" codeSystem = "2.16.840.1.113883.6.101"/>
<addr use = "WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.86"/>
<name>Intersystems Corporation</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "HP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode = "DRIV">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.6" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.27" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.3" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.1" assigningAuthorityName = "IHE PCC"/>
<id root = "eb936010-7b17-11db-9fe1-0800200c9a66"/>
<code nullFlavor = "NA"/>
<statusCode code = "active"/>
<effectiveTime value = "20111024000000-0300">
<low nullFlavor = "UNK"/>
</effectiveTime>
<entryRelationship typeCode = "SUBJ" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.6" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<templateId root = "2.16.840.1.113883.10.20.1.18" assigningAuthorityName = "CCD"/>
<id root = "eb936011-7b17-11db-9fe1-0800200c9a66"/>
<code displayName = "propensity to adverse reactions to drug" code = "419511003" codeSystemName = "SNOMED CT" codeSystem = "2.16.840.1.113883.6.96"/>
<text>
<reference value = "#ALGSUMMARY_2"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<value xsi:type = "CD" code = "1191" codeSystem = "2.16.840.1.113883.6.88" displayName = "Aspirin" codeSystemName = "RxNorm">
<originalText>
<reference value = "#ALGSUB_2"/>
</originalText>
</value>
<participant typeCode = "CSM">
<participantRole classCode = "MANU">
<addr/>
<telecom/>
<playingEntity classCode = "MMAT">
<code code = "1191" codeSystem = "2.16.840.1.113883.6.88" displayName = "Aspirin" codeSystemName = "RxNorm">
<originalText>
<reference value = "#ALGSUB_2"/>
</originalText>
</code>
<name>Aspirin</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode = "MFST" inversionInd = "true">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"/>
<templateId root = "2.16.840.1.113883.10.20.1.54"/>
<templateId root = "2.16.840.1.113883.10.20.1.28"/>
<id nullflavor = "UNK"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<code code = "ASSERTION" codeSystem = "2.16.840.1.113883.5.4"/>
<statusCode code = "completed"/>
<value xsi:type = "CD" code = "272040008" codeSystem = "2.16.840.1.113883.6.96" displayName = "Wheezing">
<originalText>
<reference value = "#ALGREACT_2"/>
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.55" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.1"/>
<code code = "SEV" displayName = "Severity" codeSystemName = "HL7 ActCode" codeSystem = "2.16.840.1.113883.5.4"/>
<text>
<reference value = "#ALGSEV_2"/>
</text>
<statusCode code = "completed"/>
<value xsi:type = "CD" displayName = "Mild" code = "255604002 " codeSystemName = "SNOMED" codeSystem = "2.16.840.1.113883.6.96"></value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.39"/>
<code code = "33999-4" codeSystem = "2.16.840.1.113883.6.1" displayName = "Status"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "55561003" codeSystem = "2.16.840.1.113883.6.96" displayName = "Active">
<originalText>
<reference value = "#ALGSTATUS_2"/>
</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode = "DRIV">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.6" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.27" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.3" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.1" assigningAuthorityName = "IHE PCC"/>
<id root = "c3df3b61-7b18-11db-9fe1-0800200c9a66"/>
<code nullFlavor = "NA"/>
<statusCode code = "active"/>
<effectiveTime value = "20111024000000-0300">
<low nullFlavor = "UNK"/>
</effectiveTime>
<entryRelationship typeCode = "SUBJ" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.18"/>
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.6" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.18" assigningAuthorityName = "CCD"/>
<id root = "c3df3b60-7b18-11db-9fe1-0800200c9a66"/>
<code code = "59037007" codeSystem = "2.16.840.1.113883.6.96" displayName = "drug intolerance" codeSystemName = "SNOMED CT"/>
<text>
<reference value = "#ALGSUMMARY_3"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "20051201"/>
<high value = "20060101"/>
</effectiveTime>
<value xsi:type = "CD" code = "2670" codeSystem = "2.16.840.1.113883.6.88" displayName = "Codeine" codeSystemName = "RxNorm">
<originalText>
<reference value = "#ALGSUB_3"/>
</originalText>
</value>
<participant typeCode = "CSM">
<participantRole classCode = "MANU">
<addr/>
<telecom/>
<playingEntity classCode = "MMAT">
<code code = "2670" codeSystem = "2.16.840.1.113883.6.88" displayName = "Codeine" codeSystemName = "RxNorm">
<originalText>
<reference value = "#ALGSUB_3"/>
</originalText>
</code>
<name>Codeine</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode = "MFST" inversionInd = "true">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"/>
<templateId root = "2.16.840.1.113883.10.20.1.54"/>
<templateId root = "2.16.840.1.113883.10.20.1.28"/>
<id nullflavor = "UNK"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<code code = "ASSERTION" codeSystem = "2.16.840.1.113883.5.4"/>
<text/>
<statusCode code = "completed"/>
<value xsi:type = "CD" code = "73879007" codeSystem = "2.16.840.1.113883.6.96" displayName = "Nausea">
<originalText>
<reference value = "#ALGREACT_3"/>
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.55" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.1"/>
<code code = "SEV" displayName = "Severity" codeSystemName = "HL7 ActCode" codeSystem = "2.16.840.1.113883.5.4"/>
<text>
<reference value = "#ALGSEV_3"/>
</text>
<statusCode code = "completed"/>
<value xsi:type = "CD" displayName = "Fatal" code = "399166001" codeSystemName = "SNOMED" codeSystem = "2.16.840.1.113883.6.96"></value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.39"/>
<code code = "33999-4" codeSystem = "2.16.840.1.113883.6.1" displayName = "Status"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "55561003" codeSystem = "2.16.840.1.113883.6.96" displayName = "Active">
<originalText>
<reference value = "#ALGSTATUS_3"/>
</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.3.88.11.83.103" assigningAuthorityName = "HITSP/C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.6" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.11" assigningAuthorityName = "HL7 CCD"/>
<code code = "11450-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Problem list"/>
<title>Problems</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Problem</th>
<th>Effective Dates</th>
<th>Problem Status</th>
</tr>
</thead>
<tbody>
<tr ID = "PROBSUMMARY_1">
<td ID = "PROBKIND_1">Asthma</td>
<td>1950</td>
<td ID = "PROBSTATUS_1">Active</td>
</tr>
<tr ID = "PROBSUMMARY_2">
<td ID = "PROBKIND_2">Pneumonia</td>
<td>Jan 1997</td>
<td ID = "PROBSTATUS_2">Resolved</td>
</tr>
<tr ID = "PROBSUMMARY_3">
<td ID = "PROBKIND_3">Pneumonia</td>
<td>Mar 1999</td>
<td ID = "PROBSTATUS_3">Resolved</td>
</tr>
<tr ID = "PROBSUMMARY_4">
<td ID = "PROBKIND_4">Myocardial Infarction</td>
<td>Jan 1997</td>
<td ID = "PROBSTATUS_4">Resolved</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.7" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.27" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.1" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.2" assigningAuthorityName = "IHE PCC"/>
<id root = "6a2fa88d-4174-4909-aece-db44b60a3abb"/>
<code nullFlavor = "NA"/>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "19500101"/>
<high nullFlavor = "UNK"/>
</effectiveTime>
<performer typeCode = "PRF">
<assignedEntity>
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<addr use = "HP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.72.5"/>
<name>NIST HL7 Test Laboratory</name>
<telecom/>
<addr/>
</representedOrganization>
</assignedEntity>
</performer>
<entryRelationship typeCode = "SUBJ" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<id root = "d11275e7-67ae-11db-bd13-0800200c9a66"/>
<code code = "64572001" displayName = "Condition" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED-CT"/>
<text>
<reference value = "#PROBKIND_1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "19500101"/>
</effectiveTime>
<value xsi:type = "CD" displayName = "Asthma" code = "195967001" codeSystemName = "SNOMED" codeSystem = "2.16.840.1.113883.6.96"/>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.50"/>
<code code = "33999-4" codeSystem = "2.16.840.1.113883.6.1" displayName = "Status"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "55561003" codeSystem = "2.16.840.1.113883.6.96" displayName = "Active">
<originalText>
<reference value = "#PROBSTATUS_1"/>
</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode = "DRIV">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.7" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.27" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.1" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.2" assigningAuthorityName = "IHE PCC"/>
<id root = "ec8a6ff8-ed4b-4f7e-82c3-e98e58b45de7"/>
<code nullFlavor = "NA"/>
<statusCode code = "active"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<performer typeCode = "PRF">
<assignedEntity>
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<addr use = "HP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.72.5"/>
<name>NIST HL7 Test Laboratory</name>
<telecom/>
<addr/>
</representedOrganization>
</assignedEntity>
</performer>
<entryRelationship typeCode = "SUBJ" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<id root = "ab1791b0-5c71-11db-b0de-0800200c9a66"/>
<code displayName = "Condition" code = "64572001" codeSystemName = "SNOMED-CT" codeSystem = "2.16.840.1.113883.6.96"/>
<text>
<reference value = "#PROBKIND_2"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "19970101"/>
<high value = "19970101"/>
</effectiveTime>
<value xsi:type = "CD" displayName = "Pneumonia" code = "233604007" codeSystemName = "SNOMED" codeSystem = "2.16.840.1.113883.6.96"/>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.50"/>
<code code = "33999-4" codeSystem = "2.16.840.1.113883.6.1" displayName = "Status"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "413322009" codeSystem = "2.16.840.1.113883.6.96" displayName = "Resolved">
<originalText>
<reference value = "#PROBSTATUS_2"/>
</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode = "DRIV">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.7" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.27" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.1" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.2" assigningAuthorityName = "IHE PCC"/>
<id root = "d11275e9-67ae-11db-bd13-0800200c9a66"/>
<code nullFlavor = "NA"/>
<statusCode code = "active"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<performer typeCode = "PRF">
<assignedEntity>
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<addr use = "HP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.72.5"/>
<name>NIST HL7 Test Laboratory</name>
<telecom/>
<addr/>
</representedOrganization>
</assignedEntity>
</performer>
<entryRelationship typeCode = "SUBJ" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<id root = "9d3d416d-45ab-4da1-912f-4583e0632000"/>
<code displayName = "Condition" code = "64572001" codeSystemName = "SNOMED-CT" codeSystem = "2.16.840.1.113883.6.96"/>
<text>
<reference value = "#PROBKIND_3"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "19990301"/>
<high value = "19990301"/>
</effectiveTime>
<value xsi:type = "CD" displayName = "Pneumonia" code = "233604007" codeSystemName = "SNOMED" codeSystem = "2.16.840.1.113883.6.96"/>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.50"/>
<code code = "33999-4" codeSystem = "2.16.840.1.113883.6.1" displayName = "Status"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "413322009" codeSystem = "2.16.840.1.113883.6.96" displayName = "Resolved">
<originalText>
<reference value = "#PROBSTATUS_3"/>
</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
<entry typeCode = "DRIV">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.7" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.27" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.1" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.2" assigningAuthorityName = "IHE PCC"/>
<id root = "5a2c903c-bd77-4bd1-ad9d-452383fbfefa"/>
<code nullFlavor = "NA"/>
<statusCode code = "active"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<performer typeCode = "PRF">
<assignedEntity>
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<addr use = "HP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.72.5"/>
<name>NIST HL7 Test Laboratory</name>
<telecom/>
<addr/>
</representedOrganization>
</assignedEntity>
</performer>
<entryRelationship typeCode = "SUBJ" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "HL7 CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<id root = "107c2dc0-67a5-11db-bd13-0800200c9aac"/>
<code displayName = "Condition" code = "64572001" codeSystemName = "SNOMED-CT" codeSystem = "2.16.840.1.113883.6.96"/>
<text>
<reference value = "#PROBKIND_4"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "19970101"/>
<high value = "19970101"/>
</effectiveTime>
<value xsi:type = "CD" displayName = "Myocardial infarction" code = "22298006" codeSystemName = "SNOMED" codeSystem = "2.16.840.1.113883.6.96"/>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.50"/>
<code code = "33999-4" codeSystem = "2.16.840.1.113883.6.1" displayName = "Status"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "413322009" codeSystem = "2.16.840.1.113883.6.96" displayName = "Resolved">
<originalText>
<reference value = "#PROBSTATUS_4"/>
</originalText>
</value>
</observation>
</entryRelationship>
</observation>
</entryRelationship>
</act>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.3.88.11.83.112" assigningAuthorityName = "HITSP/C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.19" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.8" assigningAuthorityName = "HL7 CCD"/>
<code code = "10160-0" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "History of medication use"/>
<title>Medications</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Medication</th>
<th>Dose</th>
<th>Form</th>
<th>Route</th>
<th>Sig Text</th>
<th>Dates</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr ID = "MEDSUMMARY_1">
<td ID = "MEDNAME_1">Albuterol inhalant</td>
<td ID = "MEDDOSE_1">2 puffs</td>
<td ID = "MEDFORM_1">inhaler</td>
<td ID = "MEDROUTE_1">inhalation</td>
<td ID = "SIGTXT_1">2 puffs QID PRN (as needed for wheezing)</td>
<td>July 2005+</td>
<td ID = "MEDSTATUS_1">Active</td>
</tr>
<tr ID = "MEDSUMMARY_2">
<td ID = "MEDNAME_2">clopidogrel (Plavix)</td>
<td ID = "MEDDOSE_2">75 mg</td>
<td ID = "MEDFORM_2">tablet</td>
<td ID = "MEDROUTE_2">oral</td>
<td ID = "SIGTXT_2">75mg PO daily</td>
<td>unknown</td>
<td ID = "MEDSTATUS_2">Active</td>
</tr>
<tr ID = "MEDSUMMARY_3">
<td ID = "MEDNAME_3">metoprolol</td>
<td ID = "MEDDOSE_3">25 mg</td>
<td ID = "MEDFORM_3">tablet</td>
<td ID = "MEDROUTE_3">oral</td>
<td ID = "SIGTXT_3">25mg PO BID</td>
<td>Nov 2007+</td>
<td ID = "MEDSTATUS_3">Active</td>
</tr>
<tr ID = "MEDSUMMARY_4">
<td ID = "MEDNAME_4">prednisone (Deltasone)</td>
<td ID = "MEDDOSE_4">20 mg</td>
<td ID = "MEDFORM_4">tablet</td>
<td ID = "MEDROUTE_4">oral</td>
<td ID = "SIGTXT_4">20mg PO daily</td>
<td>Mar 28, 2000+</td>
<td ID = "MEDSTATUS_4">Active</td>
</tr>
<tr ID = "MEDSUMMARY_5">
<td ID = "MEDNAME_5">cephalexin (Keflex)</td>
<td ID = "MEDDOSE_5">500 mg</td>
<td ID = "MEDFORM_5">tablet</td>
<td ID = "MEDROUTE_5">oral</td>
<td ID = "SIGTXT_5">500mg PO QID x 7 days (for bronchitis)</td>
<td>Mar-Apr 2000</td>
<td ID = "MEDSTATUS_5">Completed</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.1" assigningAuthorityName = "IHE PCC"/>
<id root = "cdbd33f0-6cde-11db-9fe1-0800200c9a66"/>
<text>
<reference value = "#SIGTEXT_1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime xsi:type = "IVL_TS">
<low value = "20050701"/>
<high nullFlavor = "UNK"/>
</effectiveTime>
<effectiveTime xsi:type = "PIVL_TS" institutionSpecified = "false" operator = "A">
<period value = "6" unit = "h"/>
</effectiveTime>
<routeCode code = "C38216" displayName = "Respiratory (Inhalation)" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA RouteOfAdministration">
<originalText>
<reference value = "#MEDROUTE_1"/>
</originalText>
<translation code = "IPINHL" codeSystem = "2.16.840.1.113883.5.112" codeSystemName = "HL7 RouteOfAdministration" displayName = "Inhalation, oral"/>
</routeCode>
<doseQuantity value = "2" unit = "puffs"/>
<administrationUnitCode code = "C42944" displayName = "Inhalant" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA Dosage Forms">
<originalText>
<reference value = "#MEDFORM_1"/>
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.3.88.11.83.8.2" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "307782" displayName = "Albuterol 0.09 MG/ACTUAT inhalant solution" codeSystemName = "RxNorm" codeSystem = "2.16.840.1.113883.6.88">
<originalText>
<reference value = "#MEDNAME_1"/>
</originalText>
</code>
<name>Albuterol Inhalent</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<entryRelationship typeCode = "SUBJ">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8.1" assigningAuthorityName = "HITSP C83"/>
<code code = "73639000" codeSystem = "2.16.840.1.113883.6.96" displayName = "Prescription Drug"/>
</observation>
</entryRelationship>
<entryRelationship typeCode = "RSON">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<id root = "cdbd5b08-6cde-11db-9fe1-0800200c9a66"/>
<code displayName = "Condition" code = "64572001" codeSystemName = "SNOMED-CT" codeSystem = "2.16.840.1.113883.6.96"/>
<text>
<reference value = "#SIGTEXT_1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "20000328"/>
</effectiveTime>
<value xsi:type = "CD" code = "56018004" displayName = "Wheezing" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT"/>
</observation>
</entryRelationship>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.47"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<value xsi:type = "CE" code = "55561003" displayName = "Active" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT">
<originalText>
<reference value = "#MEDSTATUS_1"/>
</originalText>
</value>
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.1" assigningAuthorityName = "IHE PCC"/>
<id root = "cdbd5b05-6cde-11db-9fe1-0800200c9a66"/>
<text>
<reference value = "#SIGTEXT_2"/>
</text>
<statusCode code = "completed"/>
<effectiveTime xsi:type = "IVL_TS">
<low value = "20111020"/>
<high value = "20120120"/>
</effectiveTime>
<effectiveTime xsi:type = "PIVL_TS" institutionSpecified = "false" operator = "A">
<period value = "24" unit = "h"/>
</effectiveTime>
<routeCode code = "C38288" displayName = "Oral" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA RouteOfAdministration">
<originalText>
<reference value = "#MEDROUTE_2"/>
</originalText>
<translation displayName = "Swallow, oral" code = "PO" codeSystemName = "HL7 RouteOfAdministration" codeSystem = "2.16.840.1.113883.5.112"/>
</routeCode>
<doseQuantity value = "75" unit = "mg"/>
<administrationUnitCode code = "C42998" displayName = "Tablet" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA Dosage Forms">
<originalText>
<reference value = "#MEDFORM_2"/>
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.3.88.11.83.8.2" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "309362" codeSystem = "2.16.840.1.113883.6.88" displayName = "Clopidogrel 75 MG oral tablet" codeSystemName = "RxNorm">
<originalText>
<reference value = "#MEDNAME_2"/>
</originalText>
<translation code = "174742" codeSystem = "2.16.840.1.113883.6.88" displayName = "Plavix" codeSystemName = "RxNorm"/>
</code>
<name>Plavix</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.47"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<value xsi:type = "CE" displayName = "Active" code = "55561003" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT">
<originalText>
<reference value = "#MEDSTATUS_2"/>
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8.1" assigningAuthorityName = "HITSP C83"/>
<code code = "73639000" codeSystem = "2.16.840.1.113883.6.96" displayName = "Prescription Drug"/>
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.1" assigningAuthorityName = "IHE PCC"/>
<id root = "cdbd5b01-6cde-11db-9fe1-0800200c9a66"/>
<text>
<reference value = "#SIGTEXT_3"/>
</text>
<statusCode code = "completed"/>
<effectiveTime xsi:type = "IVL_TS">
<low value = "20071121"/>
<high nullFlavor = "UNK"/>
</effectiveTime>
<effectiveTime xsi:type = "PIVL_TS" institutionSpecified = "false" operator = "A">
<period value = "12" unit = "h"/>
</effectiveTime>
<routeCode code = "C38288" displayName = "Oral" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA RouteOfAdministration">
<originalText>
<reference value = "#MEDROUTE_3"/>
</originalText>
<translation displayName = "Swallow, oral" code = "PO" codeSystemName = "HL7 RouteOfAdministration" codeSystem = "2.16.840.1.113883.5.112"/>
</routeCode>
<doseQuantity value = "25" unit = "mg"/>
<administrationUnitCode code = "C42998" displayName = "Tablet" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA Dosage Forms">
<originalText>
<reference value = "#MEDFORM_3"/>
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.3.88.11.83.8.2" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "430618" displayName = "Metoprolol 25 MG oral tablet" codeSystemName = "RxNorm" codeSystem = "2.16.840.1.113883.6.88">
<originalText>
<reference value = "#MEDNAME_3"/>
</originalText>
</code>
<name/>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<entryRelationship typeCode = "SUBJ">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8.1" assigningAuthorityName = "HITSP C83"/>
<code code = "73639000" codeSystem = "2.16.840.1.113883.6.96" displayName = "Prescription Drug"/>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ">
<act classCode = "ACT" moodCode = "INT">
<templateId root = "2.16.840.1.113883.10.20.1.49" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.3" assigningAuthorityName = "IHE PCC"/>
<code code = "PINSTRUCT" codeSystem = "1.3.6.1.4.1.19376.1.5.3.2" codeSystemName = "IHEActCode"/>
<text>
This is the text of the Patient Instruction.  Note that this instruction is printed in the narrative text of the parent Section and is refereced by the following pointer to it.
<reference value = "PntrtoSectionText"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
<entryRelationship typeCode = "SUBJ">
<act classCode = "ACT" moodCode = "INT">
<templateId root = "2.16.840.1.113883.10.20.1.43" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.3.1" assigningAuthorityName = "IHE PCC"/>
<code code = "FINSTRUCT" codeSystem = "1.3.6.1.4.1.19376.1.5.3.2" codeSystemName = "IHEActCode"/>
<text>
This is the text of the Fulfillment Instruction.  Note that this instruction is printed in the narrative text of the parent Section and is refereced by the following pointer to it.
<reference value = "PntrtoSectionText"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.47"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<value xsi:type = "CE" displayName = "Active" code = "55561003" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT">
<originalText>
<reference value = "#MEDSTATUS_3"/>
</originalText>
</value>
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.1" assigningAuthorityName = "IHE PCC"/>
<id root = "cdbd5b03-6cde-11db-9fe1-0800200c9a66"/>
<text>
<reference value = "#SIGTEXT_4"/>
</text>
<statusCode code = "completed"/>
<effectiveTime xsi:type = "IVL_TS">
<low value = "20000328"/>
<high nullFlavor = "UNK"/>
</effectiveTime>
<effectiveTime xsi:type = "PIVL_TS" institutionSpecified = "false" operator = "A">
<period value = "24" unit = "h"/>
</effectiveTime>
<routeCode code = "C38288" displayName = "Oral" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA RouteOfAdministration">
<originalText>
<reference value = "#MEDROUTE_4"/>
</originalText>
<translation displayName = "Swallow, oral" code = "PO" codeSystemName = "HL7 RouteOfAdministration" codeSystem = "2.16.840.1.113883.5.112"/>
</routeCode>
<doseQuantity value = "20" unit = "mg"/>
<administrationUnitCode code = "C42998" displayName = "Tablet" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA Dosage Forms">
<originalText>
<reference value = "#MEDFORM_4"/>
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.3.88.11.83.8.2" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "312615" displayName = "Prednisone 20 MG oral tablet" codeSystemName = "RxNorm" codeSystem = "2.16.840.1.113883.6.88">
<originalText>
<reference value = "#MEDNAME_4"/>
</originalText>
<translation code = "227730" displayName = "Deltasone" codeSystemName = "RxNorm" codeSystem = "2.16.840.1.113883.6.88"/>
</code>
<name>Deltasone</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.47"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<value xsi:type = "CE" code = "55561003" displayName = "Active" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT">
<originalText>
<reference value = "#MEDSTATUS_4"/>
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8.1" assigningAuthorityName = "HITSP C83"/>
<code code = "329505003" codeSystem = "2.16.840.1.113883.6.96" displayName = "Over the counter product"/>
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.1" assigningAuthorityName = "IHE PCC"/>
<id root = "cdbd5b07-6cde-11db-9fe1-0800200c9a66"/>
<text>
<reference value = "#SIGTEXT_5"/>
</text>
<statusCode code = "completed"/>
<effectiveTime xsi:type = "IVL_TS">
<low value = "20000328"/>
<high value = "20000404"/>
</effectiveTime>
<effectiveTime xsi:type = "PIVL_TS" institutionSpecified = "false" operator = "A">
<period value = "6" unit = "h"/>
</effectiveTime>
<routeCode code = "C38288" displayName = "Oral" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA RouteOfAdministration">
<originalText>
<reference value = "#MEDROUTE_2"/>
</originalText>
<translation displayName = "Swallow, oral" code = "PO" codeSystemName = "HL7 RouteOfAdministration" codeSystem = "2.16.840.1.113883.5.112"/>
</routeCode>
<doseQuantity value = "500" unit = "mg"/>
<administrationUnitCode code = "C42998" displayName = "Tablet" codeSystem = "2.16.840.1.113883.3.26.1.1" codeSystemName = "NCI - FDA Dosage Forms">
<originalText>
<reference value = "#MEDFORM_5"/>
</originalText>
</administrationUnitCode>
<consumable>
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.3.88.11.83.8.2" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "197454" displayName = "Cephalexin 500 MG oral tablet" codeSystemName = "RxNorm" codeSystem = "2.16.840.1.113883.6.88">
<originalText>
<reference value = "#MEDNAME_5"/>
</originalText>
<translation code = "203167" codeSystem = "2.16.840.1.113883.6.88" displayName = "Keflex" codeSystemName = "RxNorm"/>
</code>
<name>Keflex</name>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.47"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<value xsi:type = "CE" code = "73425007" displayName = "No Longer Active" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT">
<originalText>
<reference value = "#MEDSTATUS_5"/>
</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.8.1" assigningAuthorityName = "HITSP C83"/>
<code code = "73639000" codeSystem = "2.16.840.1.113883.6.96" displayName = "Prescription Drug"/>
</observation>
</entryRelationship>
<entryRelationship typeCode = "RSON">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.28" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5" assigningAuthorityName = "IHE PCC"/>
<id root = "cdbd5b08-6cde-11db-9fe1-0800200c9a66"/>
<code displayName = "Condition" code = "64572001" codeSystemName = "SNOMED-CT" codeSystem = "2.16.840.1.113883.6.96"/>
<text>
<reference value = "#SIGTEXT_5"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low value = "20000328"/>
</effectiveTime>
<value xsi:type = "CD" code = "32398004" displayName = "Bronchitis" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT"/>
</observation>
</entryRelationship>
</substanceAdministration>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.3.88.11.83.122" assigningAuthorityName = "HITSP/C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.28" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.14" assigningAuthorityName = "CCD"/>
<code code = "30954-2" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Results"/>
<title>Diagnostic Results</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>&#160;</th>
<th>March 23, 2000</th>
<th>April 06, 2000</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan = "3">
<content styleCode = "BoldItalics">Hematology</content>
</td>
</tr>
<tr ID = "TESTSUMMARY_1">
<td ID = "TESTRANGE_1">HGB (13-18 g/dl)</td>
<td>13.2</td>
<td>&#160;</td>
</tr>
<tr>
<td ID = "TESTRANGE_2">WBC (4.3-10.8 10+3/ul)</td>
<td>6.7</td>
<td>&#160;</td>
</tr>
<tr>
<td ID = "TESTRANGE_3">PLT (135-145 meq/l)</td>
<td>123 (L)</td>
<td>&#160;</td>
</tr>
<tr>
<td colspan = "3">
<content styleCode = "BoldItalics">Chemistry</content>
</td>
</tr>
<tr>
<td ID = "TESTRANGE_4">NA (135-145meq/l)</td>
<td>&#160;</td>
<td>140</td>
</tr>
<tr>
<td ID = "TESTRANGE_5">K (3.5-5.0 meq/l)</td>
<td>&#160;</td>
<td>4.0</td>
</tr>
<tr>
<td ID = "TESTRANGE_6">CL (98-106 meq/l)</td>
<td>&#160;</td>
<td>102</td>
</tr>
<tr>
<td ID = "TESTRANGE_7">HCO3 (18-23 meq/l)</td>
<td>&#160;</td>
<td>35 (H)</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<templateId root = "1.3.6.1.4.1.19376.1.3.1"/>
<act classCode = "ACT" moodCode = "EVN">
<entryRelationship typeCode = "COMP">
<organizer classCode = "BATTERY" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.3.1.4"/>
<templateId root = "2.16.840.1.113883.10.20.1.32" assigningAuthorityName = "CCD"/>
<id root = "7d5a02b0-67a4-11db-bd13-0800200c9a66"/>
<code code = "43789009" codeSystem = "2.16.840.1.113883.6.96" displayName = "CBC WO DIFFERENTIAL"/>
<statusCode code = "completed"/>
<effectiveTime value = "200003231430"/>
<component>
<procedure classCode = "PROC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.17" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.29" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.19" assigningAuthorityName = "IHE PCC"/>
<id root = "107c2dc0-67a5-11db-bd13-0800200c9aaa"/>
<code code = "43789009" codeSystem = "2.16.840.1.113883.6.96" displayName = "CBC WO DIFFERENTIAL">
<originalText>
Extract blood for CBC test
<reference value = "Ptr to text  in parent Section"/>
</originalText>
</code>
<text>
Extract blood for CBC test. Note that IHE rules require description and reference to go here rather than in originalText of code.
<reference value = "Ptr to text  in parent Section"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200003231430"/>
<performer>
<assignedEntity>
<id extension = "PseudoMD-1" root = "2.16.840.1.113883.3.72.5.2"/>
<addr>See documentationOf in Header</addr>
<telecom/>
</assignedEntity>
</performer>
</procedure>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.15.1" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.31" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "IHE PCC"/>
<id root = "107c2dc0-67a5-11db-bd13-0800200c9a66"/>
<code code = "30313-1" codeSystem = "2.16.840.1.113883.6.1" displayName = "HGB" codeSystemName = "LOINC"/>
<text>
<reference value = "#TESTSUMMARY_1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200003231430"/>
<value xsi:type = "PQ" value = "13.2" unit = "g/dl"/>
<interpretationCode code = "N" codeSystem = "2.16.840.1.113883.5.83"/>
<referenceRange>
<observationRange>
<text>
<reference value = "#TESTRANGE_1"/>
</text>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.15.1" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.31" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "IHE PCC"/>
<id root = "8b3fa370-67a5-11db-bd13-0800200c9a66"/>
<code code = "33765-9" codeSystem = "2.16.840.1.113883.6.1" displayName = "WBC" codeSystemName = "LOINC"/>
<text>
<reference value = "#TESTSUMMARY_2"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200003231430"/>
<value xsi:type = "PQ" value = "6.7" unit = "10+3/ul"/>
<interpretationCode code = "N" codeSystem = "2.16.840.1.113883.5.83"/>
<referenceRange>
<observationRange>
<text>
<reference value = "#TESTRANGE_2"/>
</text>
<value xsi:type = "IVL_PQ">
<low value = "4.3" unit = "10+3/ul"/>
<high value = "10.8" unit = "10+3/ul"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.15.1" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.31" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "IHE PCC"/>
<id root = "80a6c740-67a5-11db-bd13-0800200c9a66"/>
<code code = "26515-7" codeSystem = "2.16.840.1.113883.6.1" displayName = "PLT" codeSystemName = "LOINC"/>
<text>
<reference value = "#TESTSUMMARY_3"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200003231430"/>
<value xsi:type = "PQ" value = "123" unit = "10+3/ul"/>
<interpretationCode code = "L" codeSystem = "2.16.840.1.113883.5.83"/>
<referenceRange>
<observationRange>
<text>
<reference value = "#TESTRANGE_3"/>
</text>
<value xsi:type = "IVL_PQ">
<low value = "150" unit = "10+3/ul"/>
<high value = "350" unit = "10+3/ul"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
</organizer>
</entryRelationship>
</act>
</entry>
<entry typeCode = "DRIV">
<templateId root = "1.3.6.1.4.1.19376.1.3.1"/>
<act classCode = "ACT" moodCode = "EVN">
<entryRelationship typeCode = "COMP">
<organizer classCode = "BATTERY" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.3.1.4"/>
<templateId root = "2.16.840.1.113883.10.20.1.32" assigningAuthorityName = "CCD"/>
<id root = "a40027e0-67a5-11db-bd13-0800200c9a66"/>
<code code = "20109005" codeSystem = "2.16.840.1.113883.6.96" displayName = "LYTES" codeSystemName = "SNOMED CT"/>
<statusCode code = "completed"/>
<effectiveTime value = "200004061300"/>
<component>
<procedure classCode = "PROC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.17" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.29" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.19" assigningAuthorityName = "IHE PCC"/>
<id root = "107c2dc0-67a5-11db-bd13-0800200c9aab"/>
<code code = "20109005" codeSystem = "2.16.840.1.113883.6.96" displayName = "LYTES" codeSystemName = "SNOMED CT">
<originalText>
Extract blood for electrolytes tests
<reference value = "Ptr to text  in parent Section"/>
</originalText>
</code>
<text>
Extract blood for electrolytes tests. Not IHE rules require description and reference to go here rather than in originalText of code.
<reference value = "Ptr to text  in parent Section"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200004061300"/>
<performer>
<assignedEntity>
<id extension = "PseudoMD-3" root = "2.16.840.1.113883.3.72.5.2"/>
<addr>See documentationOf in Header</addr>
<telecom/>
</assignedEntity>
</performer>
</procedure>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.15" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.31" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "IHE PCC"/>
<id root = "a40027e1-67a5-11db-bd13-0800200c9a66"/>
<code code = "2951-2" codeSystem = "2.16.840.1.113883.6.1" displayName = "NA" codeSystemName = "LOINC"/>
<text>
<reference value = "#TESTSUMMARY_4"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200004061300"/>
<value xsi:type = "PQ" value = "140" unit = "meq/l"/>
<interpretationCode code = "N" codeSystem = "2.16.840.1.113883.5.83"/>
<referenceRange>
<observationRange>
<text>
<reference value = "#TESTRANGE_4"/>
</text>
<value xsi:type = "IVL_PQ">
<low value = "135" unit = "meq/l"/>
<high value = "145" unit = "meq/l"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.15" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.31" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "IHE PCC"/>
<id root = "a40027e2-67a5-11db-bd13-0800200c9a66"/>
<code code = "2823-3" codeSystem = "2.16.840.1.113883.6.1" displayName = "K" codeSystemName = "LOINC"/>
<text>
<reference value = "#TESTSUMMARY_5"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200004061300"/>
<value xsi:type = "PQ" value = "4.0" unit = "meq/l"/>
<interpretationCode code = "N" codeSystem = "2.16.840.1.113883.5.83"/>
<referenceRange>
<observationRange>
<text>
<reference value = "#TESTRANGE_5"/>
</text>
<value xsi:type = "IVL_PQ">
<low value = "3.5" unit = "meq/l"/>
<high value = "5.0" unit = "meq/l"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.15" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.31" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "IHE PCC"/>
<id root = "a40027e3-67a5-11db-bd13-0800200c9a66"/>
<code code = "2075-0" codeSystem = "2.16.840.1.113883.6.1" displayName = "CL" codeSystemName = "LOINC"/>
<text>
<reference value = "#TESTSUMMARY_6"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200004061300"/>
<value xsi:type = "PQ" value = "102" unit = "meq/l"/>
<interpretationCode code = "N" codeSystem = "2.16.840.1.113883.5.83"/>
<referenceRange>
<observationRange>
<text>
<reference value = "#TESTRANGE_6"/>
</text>
<value xsi:type = "IVL_PQ">
<low value = "98" unit = "meq/l"/>
<high value = "106" unit = "meq/l"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.15" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.31" assigningAuthorityName = "CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "IHE PCC"/>
<id root = "a40027e4-67a5-11db-bd13-0800200c9a66"/>
<code code = "1963-8" codeSystem = "2.16.840.1.113883.6.1" displayName = "HCO3" codeSystemName = "LOINC"/>
<text>
<reference value = "#TESTSUMMARY_7"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "200004061300"/>
<value xsi:type = "PQ" value = "35" unit = "meq/l"/>
<interpretationCode code = "H" codeSystem = "2.16.840.1.113883.5.83"/>
<referenceRange>
<observationRange>
<text>
<reference value = "#TESTRANGE_7"/>
</text>
<value xsi:type = "IVL_PQ">
<low value = "18" unit = "meq/l"/>
<high value = "23" unit = "meq/l"/>
</value>
</observationRange>
</referenceRange>
</observation>
</component>
</organizer>
</entryRelationship>
</act>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.3.88.11.83.119"/>
<templateId root = "2.16.840.1.113883.10.20.1.16"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.25"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"/>
<code code = "8716-3" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Vital Signs"/>
<title>Vital Signs</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Vital Name</th>
<th>Observation Time</th>
<th>Observation Value</th>
<th>Comments</th>
</tr>
</thead>
<tbody>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.1">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.1">Pulse</td>
<td>2008-10-29T14:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.1">88</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.1"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.2">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.2">Temperature</td>
<td>2008-10-29T14:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.2">38.8</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.2"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.3">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.3">Respirations</td>
<td>2008-10-29T14:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.3">20</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.3"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.4">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.4">Diastolic</td>
<td>2008-10-29T14:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.4">100</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.4"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.5">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.5">Systolic</td>
<td>2008-10-29T14:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.5">160</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.5"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.6">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.6">Pulse</td>
<td>2008-10-29T16:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.6">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.6"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.7">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.7">Temperature</td>
<td>2008-10-29T16:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.7">38.1</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.7"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.8">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.8">Respirations</td>
<td>2008-10-29T16:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.8">20</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.8"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.9">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.9">Diastolic</td>
<td>2008-10-29T16:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.9">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.9"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.10">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.10">Systolic</td>
<td>2008-10-29T16:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.10">140</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.10"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.11">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.11">Pulse</td>
<td>2008-10-29T18:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.11">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.11"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.12">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.12">Temperature</td>
<td>2008-10-29T18:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.12">37.9</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.12"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.13">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.13">Respirations</td>
<td>2008-10-29T18:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.13">22</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.13"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.14">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.14">Diastolic</td>
<td>2008-10-29T18:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.14">80</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.14"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.15">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.15">Systolic</td>
<td>2008-10-29T18:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.15">140</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.15"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.16">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.16">Pulse</td>
<td>2008-10-29T20:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.16">92</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.16"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.17">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.17">Temperature</td>
<td>2008-10-29T20:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.17">37.6</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.17"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.18">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.18">Respirations</td>
<td>2008-10-29T20:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.18">22</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.18"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.19">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.19">Diastolic</td>
<td>2008-10-29T20:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.19">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.19"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.20">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.20">Systolic</td>
<td>2008-10-29T20:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.20">134</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.20"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.21">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.21">Pulse</td>
<td>2008-10-30T11:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.21">88</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.21"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.22">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.22">Temperature</td>
<td>2008-10-30T11:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.22">39.8</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.22"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.23">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.23">Respirations</td>
<td>2008-10-30T11:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.23">25</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.23"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.24">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.24">Diastolic</td>
<td>2008-10-30T11:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.24">120</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.24"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.25">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.25">Systolic</td>
<td>2008-10-30T11:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.25">170</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.25"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.26">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.26">Pulse</td>
<td>2008-10-30T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.26">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.26"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.27">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.27">Temperature</td>
<td>2008-10-30T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.27">38.1</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.27"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.28">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.28">Respirations</td>
<td>2008-10-30T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.28">22</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.28"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.29">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.29">Diastolic</td>
<td>2008-10-30T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.29">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.29"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.30">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.30">Systolic</td>
<td>2008-10-30T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.30">140</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.30"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.31">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.31">Pulse</td>
<td>2008-10-30T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.31">92</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.31"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.32">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.32">Temperature</td>
<td>2008-10-30T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.32">37.2</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.32"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.33">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.33">Respirations</td>
<td>2008-10-30T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.33">22</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.33"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.34">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.34">Diastolic</td>
<td>2008-10-30T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.34">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.34"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.35">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.35">Systolic</td>
<td>2008-10-30T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.35">140</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.35"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.36">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.36">Pulse</td>
<td>2008-10-31T10:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.36">88</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.36"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.37">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.37">Temperature</td>
<td>2008-10-31T10:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.37">38.9</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.37"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.38">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.38">Respirations</td>
<td>2008-10-31T10:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.38">19</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.38"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.39">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.39">Diastolic</td>
<td>2008-10-31T10:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.39">100</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.39"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.40">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.40">Systolic</td>
<td>2008-10-31T10:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.40">150</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.40"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.41">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.41">Pulse</td>
<td>2008-10-31T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.41">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.41"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.42">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.42">Temperature</td>
<td>2008-10-31T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.42">38.4</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.42"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.43">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.43">Respirations</td>
<td>2008-10-31T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.43">20</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.43"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.44">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.44">Diastolic</td>
<td>2008-10-31T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.44">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.44"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.45">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.45">Systolic</td>
<td>2008-10-31T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.45">140</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.45"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.46">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.46">Pulse</td>
<td>2008-10-31T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.46">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.46"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.47">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.47">Temperature</td>
<td>2008-10-31T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.47">37.9</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.47"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.48">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.48">Respirations</td>
<td>2008-10-31T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.48">23</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.48"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.49">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.49">Diastolic</td>
<td>2008-10-31T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.49">80</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.49"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.50">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.50">Systolic</td>
<td>2008-10-31T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.50">140</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.50"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.51">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.51">Pulse</td>
<td>2008-10-31T14:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.51">92</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.51"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.52">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.52">Temperature</td>
<td>2008-10-31T14:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.52">38.6</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.52"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.53">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.53">Respirations</td>
<td>2008-10-31T14:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.53">21</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.53"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.54">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.54">Diastolic</td>
<td>2008-10-31T14:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.54">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.54"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.55">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.55">Systolic</td>
<td>2008-10-31T14:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.55">140</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.55"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.56">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.56">Pulse</td>
<td>2008-10-29T14:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.56">88</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.56"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.57">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.57">Pulse</td>
<td>2008-10-29T16:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.57">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.57"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.58">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.58">Pulse</td>
<td>2008-10-29T18:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.58">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.58"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.59">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.59">Pulse</td>
<td>2008-10-29T20:00:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.59">92</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.59"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.60">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.60">Pulse</td>
<td>2008-10-30T11:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.60">88</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.60"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.61">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.61">Pulse</td>
<td>2008-10-30T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.61">90</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.61"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.62">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.62">Pulse</td>
<td>2008-10-30T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.62">92</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.62"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.63">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.63">Pulse</td>
<td>2008-10-31T10:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.63">88</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.63"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.64">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.64">Pulse</td>
<td>2008-10-31T12:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.64">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.64"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.65">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.65">Pulse</td>
<td>2008-10-31T13:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.65">89</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.65"/>
</tr>
<tr ID = "vitalSignNarrativeLink-CGH.HSVN00004_200810290945.66">
<td ID = "vitalSignIdentifierLink-CGH.HSVN00004_200810290945.66">Pulse</td>
<td>2008-10-31T14:45:00Z</td>
<td ID = "vitalSignValueLink-CGH.HSVN00004_200810290945.66">92</td>
<td ID = "vitalSignCommentsLink-CGH.HSVN00004_200810290945.66"/>
</tr>
</tbody>
</table>
</text>
<entry>
<organizer classCode = "BATTERY" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.32"/>
<templateId root = "2.16.840.1.113883.10.20.1.35"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.1"/>
<id root = "a40027e0-67a5-11db-bd13-0800200c9a66"/>
<code code = "46680005" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT" displayName = "Vital signs"/>
<statusCode code = "completed"/>
<effectiveTime value = "20081029140000"/>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "UNK"/>
</assignedPerson>
<representedOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.1" extension = "CGH"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300.2.1</name>
<telecom nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300" extension = "HomeCommunity"/>
<name>Home Community</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029140000"/>
<value xsi:type = "ST">88</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.1"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.2"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029140000"/>
<value xsi:type = "ST">38.8</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.2"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.3"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029140000"/>
<value xsi:type = "ST">20</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.3"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.4"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029140000"/>
<value xsi:type = "ST">100</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.4"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.5"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029140000"/>
<value xsi:type = "ST">160</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.5"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.6"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029160000"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.6"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.7"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029160000"/>
<value xsi:type = "ST">38.1</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.7"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.8"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029160000"/>
<value xsi:type = "ST">20</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.8"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.9"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029160000"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.9"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.10"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029160000"/>
<value xsi:type = "ST">140</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.10"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.11"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029180000"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.11"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.12"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029180000"/>
<value xsi:type = "ST">37.9</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.12"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.13"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029180000"/>
<value xsi:type = "ST">22</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.13"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.14"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029180000"/>
<value xsi:type = "ST">80</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.14"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.15"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029180000"/>
<value xsi:type = "ST">140</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.15"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.16"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029200000"/>
<value xsi:type = "ST">92</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.16"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.17"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029200000"/>
<value xsi:type = "ST">37.6</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.17"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.18"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029200000"/>
<value xsi:type = "ST">22</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.18"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.19"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029200000"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.19"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.20"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029200000"/>
<value xsi:type = "ST">134</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.20"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.21"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030114500"/>
<value xsi:type = "ST">88</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.21"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.22"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030114500"/>
<value xsi:type = "ST">39.8</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.22"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.23"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030114500"/>
<value xsi:type = "ST">25</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.23"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.24"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030114500"/>
<value xsi:type = "ST">120</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.24"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.25"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030114500"/>
<value xsi:type = "ST">170</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.25"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.26"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030124500"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.26"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.27"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030124500"/>
<value xsi:type = "ST">38.1</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.27"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.28"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030124500"/>
<value xsi:type = "ST">22</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.28"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.29"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030124500"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.29"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.30"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030124500"/>
<value xsi:type = "ST">140</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.30"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.31"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030134500"/>
<value xsi:type = "ST">92</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.31"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.32"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030134500"/>
<value xsi:type = "ST">37.2</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.32"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.33"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030134500"/>
<value xsi:type = "ST">22</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.33"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.34"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030134500"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.34"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.35"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030134500"/>
<value xsi:type = "ST">140</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.35"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.36"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031104500"/>
<value xsi:type = "ST">88</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.36"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.37"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031104500"/>
<value xsi:type = "ST">38.9</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.37"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.38"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031104500"/>
<value xsi:type = "ST">19</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.38"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.39"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031104500"/>
<value xsi:type = "ST">100</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.39"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.40"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031104500"/>
<value xsi:type = "ST">150</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.40"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.41"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031124500"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.41"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.42"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031124500"/>
<value xsi:type = "ST">38.4</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.42"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.43"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031124500"/>
<value xsi:type = "ST">20</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.43"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.44"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031124500"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.44"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.45"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031124500"/>
<value xsi:type = "ST">140</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.45"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.46"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031134500"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.46"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.47"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031134500"/>
<value xsi:type = "ST">37.9</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.47"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.48"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031134500"/>
<value xsi:type = "ST">23</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.48"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.49"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031134500"/>
<value xsi:type = "ST">80</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.49"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.50"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031134500"/>
<value xsi:type = "ST">140</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.50"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.51"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031144500"/>
<value xsi:type = "ST">92</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.51"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8310-5" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Body temperature">
<originalText>Temperature</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.52"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031144500"/>
<value xsi:type = "ST">38.6</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.52"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "9279-1" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Resp rate">
<originalText>Respirations</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.53"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031144500"/>
<value xsi:type = "ST">21</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.53"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8462-4" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP dias">
<originalText>Diastolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.54"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031144500"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.54"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8480-6" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "BP sys">
<originalText>Systolic</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.55"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031144500"/>
<value xsi:type = "ST">140</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.55"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.56"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029140000"/>
<value xsi:type = "ST">88</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.56"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.57"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029160000"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.57"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.58"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029180000"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.58"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.59"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081029200000"/>
<value xsi:type = "ST">92</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.59"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.60"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030114500"/>
<value xsi:type = "ST">88</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.60"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.61"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030124500"/>
<value xsi:type = "ST">90</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.61"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.62"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081030134500"/>
<value xsi:type = "ST">92</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.62"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.63"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031104500"/>
<value xsi:type = "ST">88</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.63"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.64"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031124500"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.64"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.65"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031134500"/>
<value xsi:type = "ST">89</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.65"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.14"/>
<templateId root = "2.16.840.1.113883.10.20.1.31"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.2"/>
<id root = "57d07056-bd97-4c90-891d-eb716d3170c8"/>
<code code = "8867-4" displayName = "Heart rate" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC">
<originalText>Pulse</originalText>
</code>
<text>
<reference value = "#vitalSignNarrativeLink-CGH.HSVN00004_200810290945.66"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20081031144500"/>
<value xsi:type = "ST">92</value>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value xsi:type = "CE" code = "final" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "2.16.840.1.113883.6.96" displayName = "final">
<originalText>final</originalText>
</value>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.11"/>
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Annotation Comment"/>
<text>
<reference value = "#vitalSignCommentsLink-CGH.HSVN00004_200810290945.66"/>
</text>
<statusCode code = "completed"/>
</act>
</entryRelationship>
</observation>
</component>
<component>
<encounter classCode = "ENC" moodCode = "EVN">
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.1" extension = "HSVN00004_200810290945"/>
</encounter>
</component>
</organizer>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.10.20.1.1"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.116" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.34" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.35" assigningAuthorityName = "IHE PCC"/>
<code code = "42348-3" displayName = "ADVANCE DIRECTIVES" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<title>Advance Directives</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Directive</th>
<th>Effective Date</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<content ID = "advdir_0" xmlns = "urn:hl7-org:v3">Do Not Resuscitate</content>
</td>
<td>5/16/2011</td>
</tr>
<tr>
<td>
<content ID = "advdir_1" xmlns = "urn:hl7-org:v3">Life Support</content>
</td>
<td>5/16/2011</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.17" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.7" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.12"/>
<id root = "35186a4f-aaca-40b4-99ef-4a748f7f640f"/>
<code code = "304251008" displayName = "Resuscitation" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT">
<originalText>
<reference value = "#advdir_0"/>
</originalText>
</code>
<text>
<reference value = "advdir_0"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20110516">
<low value = "20110516"/>
<high nullFlavor = "UNK"/>
</effectiveTime>
<value nullFlavor = "NA" xsi:type = "CD"/>
<informant>
<assignedEntity>
<id root = "20140" extension = "95899"/>
<addr>
<streetAddressLine>
2384 EUclid Heights
Blvd
</streetAddressLine>
<streetAddressLine>Apt 106</streetAddressLine>
<city>Cleveland</city>
<state>OH</state>
<postalCode>44106</postalCode>
</addr>
<telecom use = "HP" value = "tel:+1-2161234567"/>
<assignedPerson>
<name>
<family>Onebmstest</family>
<given>PatientA</given>
</name>
</assignedPerson>
</assignedEntity>
</informant>
<participant typeCode = "CST">
<participantRole classCode = "AGNT">
<addr>
<streetAddressLine>
592 Rockaway
Avenue
</streetAddressLine>
<city>Brooklyn</city>
<state>NY</state>
<postalCode>11212</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-7183455000"/>
<playingEntity>
<name>
Brownsville Multi-Services Family
Health
</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.37"/>
<code code = "33999-4" displayName = "Verified With Family Only" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value code = "425396000" displayName = "Verified With Family Only" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT" xsi:type = "CE"/>
</observation>
</entryRelationship>
</observation>
</entry>
<entry typeCode = "DRIV">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13" assigningAuthorityName = "HITSP C83"/>
<templateId root = "2.16.840.1.113883.10.20.1.17" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.7" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.12"/>
<id root = "323e362b-5961-4446-b777-ad146a58af4a"/>
<code code = "78823007" displayName = "Life Support" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT">
<originalText>
<reference value = "#advdir_1"/>
</originalText>
</code>
<text>
<reference value = "advdir_1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20110516">
<low value = "20110516"/>
<high nullFlavor = "UNK"/>
</effectiveTime>
<value nullFlavor = "NA" xsi:type = "CD"/>
<informant>
<assignedEntity>
<id root = "20140" extension = "95899"/>
<addr>
<streetAddressLine>
2384 EUclid Heights
Blvd
</streetAddressLine>
<streetAddressLine>Apt 106</streetAddressLine>
<city>Cleveland</city>
<state>OH</state>
<postalCode>44106</postalCode>
</addr>
<telecom use = "HP" value = "tel:+1-2161234567"/>
<assignedPerson>
<name>
<family>Onebmstest</family>
<given>PatientA</given>
</name>
</assignedPerson>
</assignedEntity>
</informant>
<participant typeCode = "CST">
<participantRole classCode = "AGNT">
<addr>
<streetAddressLine>
592 Rockaway
Avenue
</streetAddressLine>
<city>Brooklyn</city>
<state>NY</state>
<postalCode>11212</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-7183455000"/>
<playingEntity>
<name>
Brownsville Multi-Services Family
Health
</name>
</playingEntity>
</participantRole>
</participant>
<entryRelationship typeCode = "REFR">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.37"/>
<code code = "33999-4" displayName = "Verified With Family Only" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<statusCode code = "completed"/>
<value code = "425396000" displayName = "Verified With Family Only" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT" xsi:type = "CE"/>
</observation>
</entryRelationship>
</observation>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.10.20.1.6"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.117" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.23" assigningAuthorityName = "IHE PCC"/>
<code code = "11369-6" displayName = "HISTORY OF IMMUNIZATIONS" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<title>Immunizations</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Vaccine</th>
<th>Date</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<content ID = "imm_0" xmlns = "urn:hl7-org:v3">meningococcal polysaccharide vaccine (MPSV4)</content>
</td>
<td>May-16-2011</td>
<td>completed</td>
</tr>
<tr>
<td>
<content ID = "imm_1" xmlns = "urn:hl7-org:v3">VACCINATION FOR DTP-DTAP</content>
</td>
<td>May-16-2011</td>
<td>completed</td>
</tr>
<tr>
<td>
<content ID = "imm_2" xmlns = "urn:hl7-org:v3">VAC-MEASLE-MUMPS-RUBELLA</content>
</td>
<td>May-16-2011</td>
<td>completed</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN" negationInd = "false">
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.13" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.12" assigningAuthorityName = "IHE PCC"/>
<id root = "330b6cdc-d9e4-442c-9a4a-079434d33065"/>
<code code = "IMMUNIZ" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "ActCode"/>
<text>
<reference value = "#imm_0"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20110516"/>
<consumable typeCode = "CSM">
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "32" codeSystem = "2.16.840.1.113883.6.59" codeSystemName = "CVX" displayName = "meningococcal polysaccharide vaccine (MPSV4)">
<originalText>
<reference value = "#imm_0"/>
</originalText>
</code>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
</substanceAdministration>
</entry>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN" negationInd = "false">
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.13" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.12" assigningAuthorityName = "IHE PCC"/>
<id root = "0fb56347-7991-4fb3-a44c-bbc1e90754aa"/>
<code code = "IMMUNIZ" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "ActCode"/>
<text>
<reference value = "#imm_1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20110516"/>
<consumable typeCode = "CSM">
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "115" codeSystem = "2.16.840.1.113883.6.59" codeSystemName = "CVX" displayName = "tetanus toxoid, reduced diphtheria toxoid and acellular pertussis vaccine adsorbed (Tdap)">
<originalText>
<reference value = "#imm_1"/>
</originalText>
</code>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
</substanceAdministration>
</entry>
<entry typeCode = "DRIV">
<substanceAdministration classCode = "SBADM" moodCode = "EVN" negationInd = "false">
<templateId root = "2.16.840.1.113883.10.20.1.24" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.13" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.12" assigningAuthorityName = "IHE PCC"/>
<id root = "26eb5cd4-cd09-46cb-b694-25a4272d314b"/>
<code code = "IMMUNIZ" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "ActCode"/>
<text>
<reference value = "#imm_2"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20110516"/>
<consumable typeCode = "CSM">
<manufacturedProduct>
<templateId root = "2.16.840.1.113883.10.20.1.53" assigningAuthorityName = "HL7 SDTC CCD"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.7.2" assigningAuthorityName = "IHE PCC"/>
<manufacturedMaterial>
<code code = "3" codeSystem = "2.16.840.1.113883.6.59" codeSystemName = "CVX" displayName = "measles, mumps and rubella virus vaccine">
<originalText>
<reference value = "#imm_2"/>
</originalText>
</code>
</manufacturedMaterial>
</manufacturedProduct>
</consumable>
</substanceAdministration>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.10.20.1.12"/>
<templateId root = "2.16.840.1.113883.3.88.11.83.108" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.11" assigningAuthorityName = "IHE PCC"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.12" assigningAuthorityName = "IHE PCC"/>
<code code = "47519-4" displayName = "HISTORY OF PROCEDURES" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<title>Procedures</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Procedure</th>
<th>Date</th>
</tr>
</thead>
<tbody>
<tr>
<td ID = "Proc_0">Laparoscopic Appendectomy</td>
<td>OCT-01-1999</td>
</tr>
<tr>
<td ID = "Proc_1">CABG with vein only, 2 grafts</td>
<td>May-02-2011</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<procedure classCode = "PROC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.17" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.19" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.29" assigningAuthorityName = "CCD"/>
<id nullFlavor = "UNK"/>
<code code = "44970" displayName = "Laparoscopic Appendectomy" codeSystem = "2.16.840.1.113883.6.12" codeSystemName = "CPT4">
<originalText>
<reference value = "#Proc_0"/>
</originalText>
</code>
<text>
<reference value = "#Proc_0"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20110520">
<low value = "19990101"/>
<high value = "19990101"/>
</effectiveTime>
<performer typeCode = "PRF">
<assignedEntity>
<id root = "2.16.840.1.113883.3.86.3.112" extension = "DRNICK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Nick</given>
<family>Ramirez</family>
</name>
</assignedPerson>
<representedOrganization>
<id nullFlavor = "UNK"/>
<name>Springfield Hospital</name>
<telecom nullFlavor = "UNK"/>
<addr use = "HP">
<streetAddressLine>1 Homer Drive</streetAddressLine>
<city>Springfield</city>
<state>??</state>
<postalCode>12345-6789</postalCode>
</addr>
</representedOrganization>
</assignedEntity>
</performer>
<author typeCode = "AUT">
<assignedAuthor classCode = "ASSIGNED">
<id root = "2.16.840.1.113883.3.86.3.112" extension = "DRNICK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Nick</given>
<family>Ramirez</family>
</name>
</assignedPerson>
<representedOrganization>
<id nullFlavor = "UNK"/>
<name>Springfield Hospital</name>
<telecom nullFlavor = "UNK"/>
<addr use = "HP">
<streetAddressLine>1 Homer Drive</streetAddressLine>
<city>Springfield</city>
<state>??</state>
<postalCode>12345-6789</postalCode>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "NA"/>
</assignedPerson>
<representedOrganization>
<id nullFlavor = "UNK"/>
<name>Springfield Hospital</name>
<telecom nullFlavor = "UNK"/>
<addr use = "HP">
<streetAddressLine>1 Homer Drive</streetAddressLine>
<city>Springfield</city>
<state>??</state>
<postalCode>12345-6789</postalCode>
</addr>
</representedOrganization>
</assignedEntity>
</informant>
</procedure>
</entry>
<entry typeCode = "DRIV">
<procedure classCode = "PROC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.17" assigningAuthorityName = "HITSP C83"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.19" assigningAuthorityName = "IHE PCC"/>
<templateId root = "2.16.840.1.113883.10.20.1.29" assigningAuthorityName = "CCD"/>
<id nullFlavor = "UNK"/>
<code code = "33511" displayName = "CABG with vein only, 2 grafts" codeSystem = "2.16.840.1.113883.6.12" codeSystemName = "CPT4">
<originalText>
<reference value = "#Proc_1"/>
</originalText>
</code>
<text>
<reference value = "#Proc_1"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20110502">
<low value = "20081010"/>
<high value = "20081010"/>
</effectiveTime>
<author typeCode = "AUT">
<assignedAuthor classCode = "ASSIGNED">
<id root = "2.16.840.1.113883.3.86.3.111" extension = "HAWKEYE"/>
<addr nullFlavor = "UNK"/>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Hawkeye</given>
<family>Pierce</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.86"/>
<name>Intersystems Corporation</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "HP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "NA"/>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.86.3.111"/>
<name>HealthShare Heart Clinic</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "WP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "2.16.840.1.113883.3.86"/>
<name>InterSystems Corporation</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
</procedure>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.3.88.11.83.127"/>
<templateId root = "2.16.840.1.113883.10.20.1.3"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3"/>
<code code = "46240-8" displayName = "History of Encounters" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<title>Encounters</title>
<text>
<table border = "1" width = "100%">
<thead>
<tr>
<th>Start Date/Time</th>
<th>End Date/Time</th>
<th>Encounter Type</th>
<th>Admission Type</th>
<th>Care Provider</th>
<th>Care Facility</th>
<th>Care Department</th>
<th>Encounter ID</th>
</tr>
</thead>
<tbody>
<tr ID = "encounterNarrativeLink-PHLS.HSVN00005_200810100907.1">
<td>2008-10-10 09:07:00</td>
<td>2008-10-10 09:07:00</td>
<td ID = "encounterDescriptionLink-PHLS.HSVN00005_200810100907.1">Outpatient</td>
<td ID = "encounterAdmissionLink-PHLS.HSVN00005_200810100907.1"/>
<td>Moore, James</td>
<td>PHLS</td>
<td>PHLS</td>
<td>HSVN00005_200810100907</td>
</tr>
<tr ID = "encounterNarrativeLink-PHLS.HSVN00005_200810100907.2">
<td>2008-10-10 09:07:00</td>
<td>2008-10-10 09:07:00</td>
<td ID = "encounterDescriptionLink-PHLS.HSVN00005_200810100907.2">Outpatient</td>
<td ID = "encounterAdmissionLink-PHLS.HSVN00005_200810100907.2"/>
<td>Moore, James</td>
<td>PHLS</td>
<td>PHLS</td>
<td>HSVN00005_200810100907</td>
</tr>
<tr ID = "encounterNarrativeLink-HC6.HSVN00002_200810130907.3">
<td>2008-10-13 09:07:00</td>
<td>2008-10-13 09:07:00</td>
<td ID = "encounterDescriptionLink-HC6.HSVN00002_200810130907.3">Outpatient</td>
<td ID = "encounterAdmissionLink-HC6.HSVN00002_200810130907.3"/>
<td>Moore, James</td>
<td>HC6</td>
<td>HC6</td>
<td>HSVN00002_200810130907</td>
</tr>
<tr ID = "encounterNarrativeLink-HC6.HSVN00003_200810220945.4">
<td>2008-10-22 09:45:00</td>
<td>2008-10-22 09:45:00</td>
<td ID = "encounterDescriptionLink-HC6.HSVN00003_200810220945.4">Outpatient</td>
<td ID = "encounterAdmissionLink-HC6.HSVN00003_200810220945.4"/>
<td>Moore, James</td>
<td>HC6</td>
<td>HC6</td>
<td>HSVN00003_200810220945</td>
</tr>
<tr ID = "encounterNarrativeLink-CGH.HSVN00004_200810290945.5">
<td>2008-10-29 09:45:00</td>
<td>2008-10-31 15:00:00</td>
<td ID = "encounterDescriptionLink-CGH.HSVN00004_200810290945.5">Inpatient</td>
<td ID = "encounterAdmissionLink-CGH.HSVN00004_200810290945.5"/>
<td>Farrell, Sam</td>
<td>CGH</td>
<td>CGH</td>
<td>HSVN00004_200810290945</td>
</tr>
</tbody>
</table>
</text>
<entry>
<encounter classCode = "ENC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.16"/>
<templateId root = "2.16.840.1.113883.10.20.1.21"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.14"/>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.5" extension = "HSVN00005_200810100907" assigningAuthorityName = "PHLS"/>
<code code = "AMB" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "2.16.840.1.113883.5.4" displayName = "Ambulatory">
<originalText>
<reference value = "#encounterDescriptionLink-PHLS.HSVN00005_200810100907.1"/>
</originalText>
</code>
<text>
<reference value = "#encounterNarrativeLink-PHLS.HSVN00005_200810100907.1"/>
</text>
<effectiveTime>
<low value = "20081010090700"/>
<high value = "20081010090700"/>
</effectiveTime>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "UNK"/>
</assignedPerson>
<representedOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.5" extension = "PHLS"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300.2.5</name>
<telecom nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300" extension = "HomeCommunity"/>
<name>Home Community</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
</encounter>
</entry>
<entry>
<encounter classCode = "ENC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.16"/>
<templateId root = "2.16.840.1.113883.10.20.1.21"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.14"/>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.5" extension = "HSVN00005_200810100907" assigningAuthorityName = "PHLS"/>
<code code = "AMB" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "2.16.840.1.113883.5.4" displayName = "Ambulatory">
<originalText>
<reference value = "#encounterDescriptionLink-PHLS.HSVN00005_200810100907.2"/>
</originalText>
</code>
<text>
<reference value = "#encounterNarrativeLink-PHLS.HSVN00005_200810100907.2"/>
</text>
<effectiveTime>
<low value = "20081010090700"/>
<high value = "20081010090700"/>
</effectiveTime>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "UNK"/>
</assignedPerson>
<representedOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.5" extension = "PHLS"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300.2.5</name>
<telecom nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300" extension = "HomeCommunity"/>
<name>Home Community</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
</encounter>
</entry>
<entry>
<encounter classCode = "ENC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.16"/>
<templateId root = "2.16.840.1.113883.10.20.1.21"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.14"/>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.3" extension = "HSVN00002_200810130907" assigningAuthorityName = "HC6"/>
<code code = "AMB" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "2.16.840.1.113883.5.4" displayName = "Ambulatory">
<originalText>
<reference value = "#encounterDescriptionLink-HC6.HSVN00002_200810130907.3"/>
</originalText>
</code>
<text>
<reference value = "#encounterNarrativeLink-HC6.HSVN00002_200810130907.3"/>
</text>
<effectiveTime>
<low value = "20081013090700"/>
<high value = "20081013090700"/>
</effectiveTime>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "UNK"/>
</assignedPerson>
<representedOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.3" extension = "HC6"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300.2.3</name>
<telecom nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300" extension = "HomeCommunity"/>
<name>Home Community</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
</encounter>
</entry>
<entry>
<encounter classCode = "ENC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.16"/>
<templateId root = "2.16.840.1.113883.10.20.1.21"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.14"/>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.3" extension = "HSVN00003_200810220945" assigningAuthorityName = "HC6"/>
<code code = "AMB" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "2.16.840.1.113883.5.4" displayName = "Ambulatory">
<originalText>
<reference value = "#encounterDescriptionLink-HC6.HSVN00003_200810220945.4"/>
</originalText>
</code>
<text>
<reference value = "#encounterNarrativeLink-HC6.HSVN00003_200810220945.4"/>
</text>
<effectiveTime>
<low value = "20081022094500"/>
<high value = "20081022094500"/>
</effectiveTime>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "UNK"/>
</assignedPerson>
<representedOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.3" extension = "HC6"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300.2.3</name>
<telecom nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300" extension = "HomeCommunity"/>
<name>Home Community</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
</encounter>
</entry>
<entry>
<encounter classCode = "ENC" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.3.88.11.83.16"/>
<templateId root = "2.16.840.1.113883.10.20.1.21"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.14"/>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.1" extension = "HSVN00004_200810290945" assigningAuthorityName = "CGH"/>
<code code = "IMP" codeSystem = "2.16.840.1.113883.5.4" codeSystemName = "2.16.840.1.113883.5.4" displayName = "Inpatient Encounter">
<originalText>
<reference value = "#encounterDescriptionLink-CGH.HSVN00004_200810290945.5"/>
</originalText>
</code>
<text>
<reference value = "#encounterNarrativeLink-CGH.HSVN00004_200810290945.5"/>
</text>
<effectiveTime>
<low value = "20081029094500"/>
<high value = "20081031150000"/>
</effectiveTime>
<informant>
<assignedEntity>
<id nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<telecom nullFlavor = "UNK"/>
<assignedPerson>
<name nullFlavor = "UNK"/>
</assignedPerson>
<representedOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300.2.1" extension = "CGH"/>
<name>1.3.6.1.4.1.21367.2010.1.2.300.2.1</name>
<telecom nullFlavor = "UNK"/>
<addr nullFlavor = "UNK"/>
<asOrganizationPartOf>
<effectiveTime nullFlavor = "UNK"/>
<wholeOrganization>
<id root = "1.3.6.1.4.1.21367.2010.1.2.300" extension = "HomeCommunity"/>
<name>Home Community</name>
<telecom use = "WP" value = "tel:(617) 621-0600"/>
<addr use = "WP">
<streetAddressLine>One Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142</postalCode>
<country>USA</country>
</addr>
</wholeOrganization>
</asOrganizationPartOf>
</representedOrganization>
</assignedEntity>
</informant>
</encounter>
</entry>
</section>
</component>
<component>
<section>
<templateId root = "2.16.840.1.113883.10.20.1.15"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"/>
<code code = "29762-2" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC" displayName = "Social History"/>
<title>Social History</title>
<text>
<table>
<thead>
<tr>
<th>Hx Item</th>
<th>Status</th>
<th>Date</th>
<th>Comment</th>
</tr>
</thead>
<tbody>
<tr>
<td ID = "REFTITLE_0">History of Smoking (1 Pack / Day or less)</td>
<td ID = "REFSTATUS_0">Inactive</td>
<td ID = "REFDATE_0">1/1/2000 - 12/30/2008</td>
<td ID = "REFCOMMENT_0">Patient smoked 1/2 to 1 pack a day for approx. 8 years. Quit due to complications from asthma.</td>
</tr>
</tbody>
</table>
</text>
<entry typeCode = "DRIV">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.33"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.4"/>
<code codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED CT" code = "282291009" displayName = "Smoking">
<translation>
<reference value = "#REFTITLE_0"/>
</translation>
</code>
<text>
<reference value = "#REFTITLE_0"/>
</text>
<statusCode code = "completed"/>
<effectiveTime value = "20100123000000-0300">
<low value = "20000101"/>
<high value = "20091231"/>
</effectiveTime>
<value xsi:type = "CE" code = "55561003" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMEDCT" displayName = "Active"/>
<entryRelationship typeCode = "REFR" inversionInd = "false">
<observation classCode = "OBS" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.57"/>
<templateId root = "2.16.840.1.113883.10.20.1.50"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"/>
<templateId root = "2.16.840.1.113883.10.20.1.28"/>
<id extension = "21404100063" root = "1.3.6.1.4.1.22812.3.8390702.3.4.1.2.1"/>
<code code = "33999-4" displayName = "Status" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<text>
<reference value = "#REFSTATUS_0"/>
</text>
<statusCode code = "completed"/>
<effectiveTime>
<low nullFlavor = "UNK"/>
</effectiveTime>
<value xsi:type = "CD" code = "229819007" codeSystem = "2.16.840.1.113883.6.96" codeSystemName = "SNOMED-CT" displayName = "Tobacco Use and Exposure"/>
</observation>
</entryRelationship>
<entryRelationship typeCode = "SUBJ" inversionInd = "true">
<act classCode = "ACT" moodCode = "EVN">
<templateId root = "2.16.840.1.113883.10.20.1.40"/>
<templateId root = "1.3.6.1.4.1.19376.1.5.3.1.4.2"/>
<code code = "48767-8" displayName = "Annotation Comment" codeSystem = "2.16.840.1.113883.6.1" codeSystemName = "LOINC"/>
<text>
<reference value = "#REFCOMMENT_0"/>
</text>
<statusCode code = "completed"/>
<author typeCode = "AUT">
<time value = "20111002000000-0300"/>
<assignedAuthor classCode = "ASSIGNED">
<id root = "2.16.840.1.113883.3.86" extension = "BOMBAY"/>
<addr use = "WP">
<streetAddressLine>22 Massachusetts Ave</streetAddressLine>
<streetAddressLine>Suite 500</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<assignedPerson>
<name>
<prefix>Dr.</prefix>
<given>Bom</given>
<family>Bay</family>
</name>
</assignedPerson>
<representedOrganization>
<id root = "2.16.840.1.113883.3.86"/>
<name>Intersystems Corporation</name>
<telecom use = "WP" value = "tel:+1-617-225-3133"/>
<addr use = "HP">
<streetAddressLine>1 Memorial Drive</streetAddressLine>
<city>Cambridge</city>
<state>MA</state>
<postalCode>02142-1356</postalCode>
</addr>
</representedOrganization>
</assignedAuthor>
</author>
</act>
</entryRelationship>
</observation>
</entry>
</section>
</component>
</structuredBody>
</component>
</ClinicalDocument>
}

XData VeryLongIIDs
{
<lcm:SubmitObjectsRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:query="urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0" xmlns:lcm="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0" xmlns:ihe="urn:ihe:iti:xds-b:2007">
<rim:RegistryObjectList xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
<rim:ExtrinsicObject id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" mimeType="text/xml" objectType="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1">
<rim:Slot name="creationTime">
<rim:ValueList>
	<rim:Value>20170911094558</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="languageCode">
<rim:ValueList>
	<rim:Value>en-us</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="sourcePatientId">
<rim:ValueList>
	<rim:Value>274465^^^&amp;1.3.6.1.4.1.21367.2010.1.2.310&amp;ISO</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="serviceStartTime">
<rim:ValueList>
	<rim:Value>20170911</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="serviceStopTime">
<rim:ValueList>
	<rim:Value>20170911</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="sourcePatientInfo">
<rim:ValueList>
	<rim:Value>PID-3|274465^^^&amp;1.3.6.1.4.1.21367.2010.1.2.310&amp;ISO</rim:Value>
	<rim:Value>PID-5|George^Alexander^^^</rim:Value>
	<rim:Value>PID-7|20040402</rim:Value>
	<rim:Value>PID-8|M</rim:Value>
	<rim:Value>PID-11|452 EAST 21ST ST^^NEW YORK^NY^15075^USA</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="repositoryUniqueId">
<rim:ValueList>
	<rim:Value>1.3.6.1.4.1.21367.2010.1.2.300.100</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="hash">
<rim:ValueList>
	<rim:Value>da39a3ee5e6b4b0d3255bfef95601890afd80709</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Slot name="size">
<rim:ValueList>
	<rim:Value>15</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Name>
<rim:LocalizedString charset="en-us" value="CCD.000000000000000001.XML" xml:lang="UTF-8"/>
</rim:Name>
<rim:Classification classificationScheme="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a" classifiedObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001cl02" nodeRepresentation="34133-9">
<rim:Slot name="codingScheme">
	<rim:ValueList>
		<rim:Value>2.16.840.1.113883.6.1</rim:Value>
	</rim:ValueList>
</rim:Slot>
<rim:Name>
	<rim:LocalizedString charset="en-us" value="Summarization of Episode Note" xml:lang="UTF-8"/>
</rim:Name>
</rim:Classification>
<rim:Classification classificationScheme="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f" classifiedObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001cl03" nodeRepresentation="1.3.6.1.4.1.21367.2006.7.101">
<rim:Slot name="codingScheme">
	<rim:ValueList>
		<rim:Value>Connect-a-thon confidentialityCodes</rim:Value>
	</rim:ValueList>
</rim:Slot>
<rim:Name>
	<rim:LocalizedString charset="en-us" value="Clinical-Staff" xml:lang="UTF-8"/>
</rim:Name>
</rim:Classification>
<rim:Classification classificationScheme="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d" classifiedObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001cl04" nodeRepresentation="CDAR2/IHE 1.0">
<rim:Slot name="codingScheme">
	<rim:ValueList>
		<rim:Value>Connect-a-thon formatCodes</rim:Value>
	</rim:ValueList>
</rim:Slot>
<rim:Name>
	<rim:LocalizedString charset="en-us" value="CDAR2/IHE 1.0" xml:lang="UTF-8"/>
</rim:Name>
</rim:Classification>
<rim:Classification classificationScheme="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1" classifiedObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001cl05" nodeRepresentation="Hospital Setting">
<rim:Slot name="codingScheme">
	<rim:ValueList>
		<rim:Value>Connect-a-thon healthcareFacilityTypeCodes</rim:Value>
	</rim:ValueList>
</rim:Slot>
<rim:Name>
	<rim:LocalizedString charset="en-us" value="Hospital Setting" xml:lang="UTF-8"/>
</rim:Name>
</rim:Classification>
<rim:Classification classificationScheme="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead" classifiedObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001cl06" nodeRepresentation="General Medicine">
<rim:Slot name="codingScheme">
	<rim:ValueList>
		<rim:Value>Connect-a-thon practiceSettingCodes</rim:Value>
	</rim:ValueList>
</rim:Slot>
<rim:Name>
	<rim:LocalizedString charset="en-us" value="General Medicine" xml:lang="UTF-8"/>
</rim:Name>
</rim:Classification>
<rim:Classification classificationScheme="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983" classifiedObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001cl07" nodeRepresentation="34133-9">
<rim:Slot name="codingScheme">
	<rim:ValueList>
		<rim:Value>2.16.840.1.113883.6.1</rim:Value>
	</rim:ValueList>
</rim:Slot>
<rim:Name>
	<rim:LocalizedString charset="en-us" value="Summarization of Episode Note" xml:lang="UTF-8"/>
</rim:Name>
</rim:Classification>
<rim:ExternalIdentifier id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001ei01" registryObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" identificationScheme="urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427" objectType="ExternalIdentifier" value="{$expression{%PatientID}}">
<rim:Name>
	<rim:LocalizedString value="XDSDocumentEntry.patientId"/>
</rim:Name>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier id="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001ei02" registryObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001" identificationScheme="urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab" objectType="ExternalIdentifier" value="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001">
<rim:Name>
	<rim:LocalizedString value="XDSDocumentEntry.uniqueId"/>
</rim:Name>
</rim:ExternalIdentifier>
</rim:ExtrinsicObject>
<rim:RegistryPackage id="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357">
<rim:Slot name="submissionTime">
<rim:ValueList>
	<rim:Value>20170911094558</rim:Value>
</rim:ValueList>
</rim:Slot>
<rim:Classification classificationScheme="urn:uuid:aa543740-bdda-424e-8c96-df4873be8500" classifiedObject="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357" id="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357cl09" nodeRepresentation="34133-9">
<rim:Slot name="codingScheme">
	<rim:ValueList>
		<rim:Value>2.16.840.1.113883.6.1</rim:Value>
	</rim:ValueList>
</rim:Slot>
<rim:Name>
	<rim:LocalizedString charset="en-us" value="Summarization of Episode Note" xml:lang="UTF-8"/>
</rim:Name>
</rim:Classification>
<rim:ExternalIdentifier id="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357ei03" registryObject="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357" identificationScheme="urn:uuid:96fdda7c-d067-4183-912e-bf5ee74998a8" objectType="ExternalIdentifier" value="{$expression{%SubmissionSetUniqueId}}">
<rim:Name>
	<rim:LocalizedString value="XDSSubmissionSet.uniqueId"/>
</rim:Name>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier id="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357ei04" registryObject="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357" identificationScheme="urn:uuid:554ac39e-e3fe-47fe-b233-965d2a147832" objectType="ExternalIdentifier" value="2.16.840.1.113883.3.1579.835755544848.1.100">
<rim:Name>
	<rim:LocalizedString value="XDSSubmissionSet.sourceId"/>
</rim:Name>
</rim:ExternalIdentifier>
<rim:ExternalIdentifier id="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357ei05" registryObject="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357" identificationScheme="urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446" objectType="ExternalIdentifier" value="{$expression{%PatientID}}">
<rim:Name>
	<rim:LocalizedString value="XDSSubmissionSet.patientId"/>
</rim:Name>
</rim:ExternalIdentifier>
</rim:RegistryPackage>
<rim:Classification classifiedObject="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357" id="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357cl10" classificationNode="urn:uuid:a54d6aa5-d40d-43f9-88c5-b4633d873bdd"/>
<rim:Association id="SuperVeryLongSubmissionIDToBlowEverythingUpHaHa0f488715-9853-4ad0-bde5-c46804db27eb" associationType="urn:oasis:names:tc:ebxml-regrep:AssociationType:HasMember" sourceObject="SuperVeryLongExternalIdentifierToBlowEverythingUpSubmissionSet:274465.2194357" targetObject="2.16.840.1.113883.3.4111.339212342426.2.333.4146237.000000000000000001">
<rim:Slot name="SubmissionSetStatus">
<rim:ValueList>
	<rim:Value>Original</rim:Value>
</rim:ValueList>
</rim:Slot>
</rim:Association>
</rim:RegistryObjectList>
</lcm:SubmitObjectsRequest>
}

XData AdditionalItems
{
}

XData AdditionalOIDEntries
{
}

XData AdditionalRegistryEntries
{
}

}
