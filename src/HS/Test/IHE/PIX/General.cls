/// PIX Manager functions<br>
/// <li>Add</li>
/// 	<li>Revise</li>
/// 	<li>Merge</li>
/// 	<li>Query</li>
/// PIX Consumer function<br>
/// <li>receive notification</li>
Class HS.Test.IHE.PIX.General Extends HS.Test.IHE.PIX.Base [ Inheritance = left ]
{

Method Test100Setup()
{
	Set tSC = ..Setup()
	Set tSC=##class(HS.Util.Installer.Kit.Base).SetupFacility("EXTERNAL","EXTERNAL",1)
	$$$HSTestAssertTrueOrBail(##class(HS.Data.OIDMap).FileOID("EXTERNAL","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.310","External System","Facility"),"Filed EXTERNAL facility")
	Set tSC=##class(HS.Util.Installer.Kit.Base).SetupFacility("EXTERNAL2","EXTERNAL2",1)
	$$$HSTestAssertTrueOrBail(##class(HS.Data.OIDMap).FileOID("EXTERNAL2","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.320","External System","Facility"),"Filed EXTERNAL2 facility")
	Set tSC=##class(HS.Util.Installer.Kit.Base).SetupFacility("EXT_WITH_MULTI_UNDERSCORE","EXT_WITH_MULTI_UNDERSCORE",1)
	$$$HSTestAssertTrueOrBail(##class(HS.Data.OIDMap).FileOID("EXT_WITH_MULTI_UNDERSCORE","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.330","External System","Facility"),"Filed EXTERNAL facility")
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	Do ##class(HS.Data.OIDMap).FileOID("ISC","AssigningAuthority","2.16.840.1.113883.3.86.3")
}

/// Add Patient
Method Test120AddPatientPIXv2()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	Set tHighAuditID = ..FindHighAuditID()
	Set tStartV2=..MessagesForItem("HS.Generated.Test.IHE.PIXv2.Consumer.Services")
	Set tStartV3=..MessagesForItem("HS.Generated.Test.IHE.PIXv3.Consumer.Services")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Jaclyn"
	Set tRequest.LastName="PIXSmith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1958-10-31")
	Set tRequest.MRN="PIX1"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="123 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv2Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	Do ..FindAuditRecords(tHighAuditID,1,"C","ITI-8",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PIX Feed:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-8",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PIX manager record for PIX Feed:"_tCount)

	Hang 2 /// wait for consumer records to be delivered
	Do ..MessagesForItem("HS.Generated.Test.IHE.PIXv2.Consumer.Services",tStartV2,.tCount)
	If '$$$AssertTrue(tCount=1,"Notified "_tCount_" v2 consumer records")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-8",.tCount,"HS.IHE.PIX.Consumer.Process")
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PIX consumer record for PIX v2 feed:"_tCount)

	Do ..MessagesForItem("HS.Generated.Test.IHE.PIXv3.Consumer.Services",tStartV3,.tCount)
	If '$$$AssertTrue(tCount=1,"Notified "_tCount_" v3 consumer records")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-44",.tCount,"HS.IHE.PIX.Consumer.Process")
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PIX consumer record for PIX v3 Feed:"_tCount)


	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.AddOrUpdate="U"
	Set tRequest.FirstName="Jaclyn"
	Set tRequest.LastName="PIXSmith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1959-10-31")
	Set tRequest.MRN="PIX1"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="123 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv2Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	Do ..FindAuditRecords(tHighAuditID,1,"C","ITI-8",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PIX Feed:"_tCount) 
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-8",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PIX manager record for PIX Feed:"_tCount)
}

Method Test140AddPatientPIXv3()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Janice"
	Set tRequest.LastName="PIXv3Smith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1958-10-31")
	Set tRequest.MRN="PIXv3-1"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="123 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv3Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	Do ..FindAuditRecords(tHighAuditID,1,"C","ITI-44",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PIX Feed:"_tCount) 
	Do ..FindAuditRecords(tHighAuditID,0,"C","ITI-44",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PIX manager record for PIX Feed:"_tCount) 

	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.AddOrUpdate="U"
	Set tRequest.FirstName="Janice"
	Set tRequest.LastName="PIXv3Smith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1959-10-31")
	Set tRequest.MRN="PIXv3-1"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="123 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv3Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"UpdatePatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient updated without error")
	Do ..FindAuditRecords(tHighAuditID,1,"U","ITI-44",.tCount)
	If '$$$AssertTrue(tCount>1,"Audit should report 1 source record for PIX Feed:"_tCount) 
	Do ..FindAuditRecords(tHighAuditID,0,"U","ITI-44",.tCount)
	If '$$$AssertTrue(tCount>1,"Audit should report 1 PIX manager record for PIX Feed:"_tCount) 


	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Jaclyn"
	Set tRequest.LastName="PIXv3Smith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1958-10-31")
	Set tRequest.MRN="PIXv3-2"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="123 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv3Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")


	Set tMergeRequest=##class(HS.Message.MergePatientRequest).%New()
	Set tMergeRequest.Facility="EXTERNAL"
	Set tMergeRequest.AssigningAuthority="EXTERNAL"
	Set tMergeRequest.MRN="PIXv3-1"
	Set tMergeRequest.PriorMRN="PIXv3-2"
	Set tMergeRequest.PriorAssigningAuthority="EXTERNAL"
	Do tMergeRequest.AdditionalInfo.SetAt(..#PIXv3Source,"Host")
	Do tMergeRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tMergeRequest,.tMergeResponse)
	Quit:'$$$AssertStatusOK(tSC,"MergePatients")
	Quit:'$$$AssertTrue(tMergeResponse.Accepted=1,"Patient merged without error")
	Do ..FindAuditRecords(tHighAuditID,1,"D","ITI-44",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PIX Merge:"_tCount)
	Do ..FindAuditRecords(tHighAuditID,0,"D","ITI-44",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PIX manager record for PIX Merge:"_tCount)
}

Method Test150AddPatientPIXv3()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Test150"
	Set tRequest.LastName="PIXv3"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1968-8-31")
	Set tRequest.MRN="PIXv3-150"
	Set tRequest.MPIID="PIXv3-150-1"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Set tAddress.Use="H"
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="150 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Jimmy"
	Set tName.Middle="Middle"
	Set tName.Family="PIXv3"
	Set tName.Suffix="III"
	Set tName.Type="Alias"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Johnny"
	Set tName.Middle="Middle"
	Set tName.Family="PIXv3"
	Set tName.Suffix="III"
	Set tName.Type="Alias"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Test150"
	Set tName.Middle="Middle"
	Set tName.Family="Smith-PIXv3"
	Set tName.Suffix=""
	Set tName.Type="Birth"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mrs"
	Set tName.Given="Mary"
	Set tName.Middle="no-Middle"
	Set tName.Family="Jones-PIXv3"
	Set tName.Suffix=""
	Set tRequest.MothersName=tName
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="John"
	Set tName.Middle="no-Middle"
	Set tName.Family="Smith-PIXv3"
	Set tName.Suffix=""
	Set tRequest.FathersName=tName
	Set tIdentifier = ##class(HS.Types.Identifier).%New()
	Set tIdentifier.Use="XX"
	Set tIdentifier.Root="EXTERNAL"
	Set tIdentifier.AssigningAuthorityName="EXTERNAL"
	Set tIdentifier.Extension="12345678"
	Do tRequest.Identifiers.Insert(tIdentifier)
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv3Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	/// Add same patient with different MRN linking based on MPIID
	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Test150"
	Set tRequest.LastName="PIXv3"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1968-8-31")
	Set tRequest.MRN="PIXv3-150-2"
	Set tRequest.MPIID="PIXv3-150-1"
	Set tRequest.AssigningAuthority="EXTERNAL2"
	Set tRequest.Facility="EXTERNAL2"
	Set tAddress=##class(HS.Types.Address).%New()
	Set tAddress.Use="H"
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="150 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv3Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")
	
	/// Add same patient with different MRN linking based on MPIID
	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Test150"
	Set tRequest.LastName="PIXv3"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1968-8-31")
	Set tRequest.MRN="PIXv3-150-3"
	Set tRequest.MPIID="PIXv3-150-1"
	Set tRequest.AssigningAuthority="EXT_WITH_MULTI_UNDERSCORE"
	Set tRequest.Facility="EXT_WITH_MULTI_UNDERSCORE"
	Set tAddress=##class(HS.Types.Address).%New()
	Set tAddress.Use="H"
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PIXVille"
	Set tAddress.StreetLine="150 1st PIX Street"
	Set tAddress.PostalCode="PIXP1"
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PIXv3Source,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	Set tSearchRequest = ##class(HS.Message.PatientSearchRequest).%New()
	Set tSearchRequest.MRN="PIXv3-150-2"
	Set tSearchRequest.AssigningAuthority="EXTERNAL2"
	Set tSearchRequest.Facility = "EXT_WITH_MULTI_UNDERSCORE"
	Do tSearchRequest.AdditionalInfo.SetAt(..#PIXv3Consumer,"Host")
	Do tSearchRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tSearchRequest,.tSearchResponse)
	Quit:'$$$AssertStatusOK(tSC,"Ran query")
	Quit:'$$$AssertTrue(tSearchResponse.Results.Count()=1,"Found 1 patient")
	Quit:'$$$AssertTrue(tSearchResponse.Results.GetAt(1).Identifiers.Count()=1,"Found 1 identifier")
	Quit:'$$$AssertTrue(tSearchResponse.Results.GetAt(1).Identifiers.GetAt(1).Root="EXT_WITH_MULTI_UNDERSCORE","Found correct scoping organizaiton")
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
