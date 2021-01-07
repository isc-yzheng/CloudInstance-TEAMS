/// General test for XCA (Cross Community Access)
/// Add a patient, document query
Class HS.Test.IHE.XCA.General Extends (HS.Test.IHE.XCA.Base, HS.Test.IHE.XDSb.Base) [ Inheritance = left ]
{

Method Test100Setup()
{
	// if there is no oid for this namespace, define it (the OID becomes the repository OID)
	// need to do this before the production starts
	Do:##class(HS.Data.OIDMap).GetOIDForCode($namespace)="" ##class(HS.Data.OIDMap).FileOID($NAMESPACE,"Repository","2.16.840.1.113883.3.86.3.19998")
	Set tSC = ..Setup()
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	Do ##class(HS.Data.OIDMap).FileOID("ISC","AssigningAuthority","2.16.840.1.113883.3.86.3")
}

/// Add Patient
Method Test120AddPatient1()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="John"
	Set tRequest.LastName="XCASmith"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1992-09-11")
	Set tRequest.MRN="XCA666666"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="XCAVille"
	Set tAddress.StreetLine="123 XCA Street"
	Set tAddress.PostalCode="XCA"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	#; create multiple MRN's for the patient so that the MPI Manager will return multiple results and the XCPD manager will still work
	Set tRequest.MRN = "XCA7777777"
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse2)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse2.MPIID)
	Quit:'$$$AssertTrue(tResponse2.ErrStatus=""||(tResponse2.ErrStatus=$$$OK),"Patient added without error")
	
	Set tSC = ..createDocument("XCA test",tResponse.MPIID,.tSubmission)
	Quit:'$$$AssertStatusOK(tSC,"Created sample document")

	Set tHighAuditID = ..FindHighAuditID()
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tResponse.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddCreationFrom($zdt(+$H,8))  /// docs created today
	Do tQDRequest.AddDocumentType(1)  /// Both ondemand and stable
	Do tQDRequest.AddParam(tSubmission.Documents.GetAt(1).UniqueId,"$XDSDocumentEntryUniqueId")
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Do tQDRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"Single Document located")

	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-38",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for XCA:"_tCount) break
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-38",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 Responding Gateway record for XCA:"_tCount) break
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-55",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for XCPD:"_tCount) break
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-55",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 Responding Gateway record for XCPD:"_tCount) break
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for XDSb:"_tCount) break
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-18",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 Registry record for XDSb:"_tCount) break

	//Set tDoc=##class(HS.Message.IHE.XDSb.Document).%New()
	//Set tDoc.RepositoryUniqueId=##class(HS.Data.OIDMap).GetOIDForCode($namespace)
	//Set tDoc.UniqueId=tDocument.UniqueId
	Set tHighAuditID = ..FindHighAuditID()
	Set tRetrieveRequest=##class(HS.Message.IHE.XDSb.RetrieveRequest).%New()
	Do tRetrieveRequest.Documents.Insert(tQDResponse.Documents.GetAt(1))
	Do tRetrieveRequest.AdditionalInfo.SetAt(..#XCAIGOperation,"Host") 
	Do tRetrieveRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Do tRetrieveRequest.AdditionalInfo.SetAt("Test.XCA.RespondingGateway","ServiceName")  /// service name not set on operation to handle dynamic routing
	Set tSC = ##class(HS.Test.Service).SendSync(tRetrieveRequest,.tRetrieveResponse)
	Quit:'$$$AssertStatusOK(tSC,"Submitted Retrieve Request")
	Quit:'$$$AssertTrue(tRetrieveResponse.Documents.Count()=1,"Retrieved 1 document")
	Do ..FindAuditRecords(tHighAuditID,1,"R","ITI-39",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for XCA:"_tCount) break

	If +..Manager.UserFields.GetAt("TestWithPDQ") { // Test PDQ interface, off by default because XCA/XCPD are not dependent on PDQ being installed
		$$$HSTestAssertTrueOrBail(..CreateTestClass("Test","HS.IHE.PDQv3.Supplier.Services",,1)=$$$OK,"Created repository service")
		Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,"xdata://"_..%ClassName(1)_":XCPDPDQAdditionalItems",1)
		Quit:'$$$AssertStatusOK(tSC,"Modifying production XCPDPDQAdditionalItems")
		Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,"xdata://"_..%ClassName(1)_":XCPDPDQv3",1)
		Quit:'$$$AssertStatusOK(tSC,"Modifying production XCPDPDQv3")
		Set tSC= ##class(Ens.Director).UpdateProduction() Quit:$$$ISERR(tSC)
		Quit:'$$$AssertStatusOK(tSC,"Updating production XCPDPDQAdditionalItems")
		#; resend request / this time through PDQv3
		Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
		Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
		Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"Single Document located")
		#; update to use PDQv2
		Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods($namespace,"xdata://"_..%ClassName(1)_":XCPDPDQv2",1)
		Quit:'$$$AssertStatusOK(tSC,"Modifying production XCPDPDQv2")
		Set tSC= ##class(Ens.Director).UpdateProduction() Quit:$$$ISERR(tSC)
		#; resend request / this time through PDQv2
		Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
		Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
		Quit:'$$$AssertTrue(tQDResponse.Documents.Count()=1,"Single Document located")
		
	}
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
