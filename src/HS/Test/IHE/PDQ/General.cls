/// PDQ Supplier functions<br>
Class HS.Test.IHE.PDQ.General Extends HS.Test.IHE.PDQ.Base [ Inheritance = left ]
{

Method Test100Setup()
{
	Set tSC=##class(HS.Util.Installer.Kit.Base).SetupFacility("EXTERNAL","EXTERNAL",1)
	$$$HSTestAssertTrueOrBail(##class(HS.Data.OIDMap).FileOID("EXTERNAL","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.310","External System","Facility"),"Filed EXTERNAL facility")
	Do ##class(HS.Data.OIDMap).FileOID("ISC","AssigningAuthority","2.16.840.1.113883.3.86.3")
	Set tSC = ..Setup()
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	$$$HSTestBailout
}

/// Add Patient
Method Test120QueryPatientPDQ()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Jaclyn"
	Set tRequest.LastName="PDQSmith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1943-05-07")
	Set tRequest.MRN="PDQ1"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PDQVille"
	Set tAddress.StreetLine="123 1st PDQ Street"
	Set tAddress.PostalCode="PDQP1"

	Set tTelecom = ##class(HS.Types.Telecom).%New()
	Set tTelecom.Email = "xxx@yyy.com"
	Set tTelecom.Use = "H"
	do tRequest.Telecoms.Insert(tTelecom)

	Set tTelecom = ##class(HS.Types.Telecom).%New()
	Set tTelecom.PhoneNumberFull = "1 (705) 207-5661"
	Set tTelecom.Use = "H"
	do tRequest.Telecoms.Insert(tTelecom)

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Set tMPIID=$S($$$ISOK(tSC):tResponse.MPIID,1:"")
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tMPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	Set tHighAuditID = ..FindHighAuditID()

	Set tRequest=##class(HS.Message.PatientSearchRequest).%New()
	Set tRequest.FirstName="Jaclyn"
	Set tRequest.LastName="PDQSmith"
	Set tRequest.Sex="F"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1943-05-07")
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PDQVille"
	Set tAddress.StreetLine="123 1st PDQ Street"
	Set tAddress.PostalCode="PDQP1"

	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#PDQv2Consumer,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"QueryPatient v2 no MRN")
	Set tFoundMPIID = $S('$isObject(tResponse.Results.GetAt(1)):"",1:tResponse.Results.GetAt(1).MPIID)
	If $$$AssertTrue(tResponse.ResultsCount=1,"Found "_tResponse.ResultsCount_" with matching MPIID:"_tMPIID_":"_(tMPIID=tFoundMPIID))
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-21",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PDQ Query:"_tCount) 
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-21",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PDQ supplier record for PDQ Query:"_tCount)

	Set tHighAuditID = ..FindHighAuditID()
	Do tRequest.AdditionalInfo.SetAt(..#PDQv3Consumer,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"QueryPatient v3 no MRN")
	Set tFoundMPIID = $S('$isObject(tResponse.Results.GetAt(1)):"",1:tResponse.Results.GetAt(1).MPIID)
	If $$$AssertTrue(tResponse.ResultsCount=1,"Found "_tResponse.ResultsCount_" with matching MPIID:"_tMPIID_":"_(tMPIID=tFoundMPIID)) {
		If $$$AssertTrue(tResponse.Results.GetAt(1).Telecoms.GetAt(1).Email="xxx@yyy.com","Found inserted email")
	}
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-47",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PDQ Query:"_tCount) 
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-47",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PDQ supplier record for PDQ Query:"_tCount)

	Set tHighAuditID = ..FindHighAuditID()
	Set tRequest.MRN="PDQ1"
	Set tAddress.City=""
	Set tAddress.StreetLine=""
	Set tAddress.PostalCode=""
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"QueryPatient v3 with MRN")
	Set tFoundMPIID = $S('$isObject(tResponse.Results.GetAt(1)):"",1:tResponse.Results.GetAt(1).MPIID)
	If $$$AssertTrue(tResponse.ResultsCount=1,"Found "_tResponse.ResultsCount_" with matching MPIID:"_tMPIID_":"_(tMPIID=tFoundMPIID))
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-47",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PDQ Query:"_tCount) 
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-47",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PDQ supplier record for PDQ Query:"_tCount)
	
	Set tHighAuditID = ..FindHighAuditID()
	Do tRequest.AdditionalInfo.SetAt(..#PDQv2Consumer,"Host")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"QueryPatient v2 with MRN")
	Set tFoundMPIID = $S('$isObject(tResponse.Results.GetAt(1)):"",1:tResponse.Results.GetAt(1).MPIID)
	If $$$AssertTrue(tResponse.ResultsCount=1,"Found "_tResponse.ResultsCount_" with matching MPIID:"_tMPIID_":"_(tMPIID=tFoundMPIID))
	Do ..FindAuditRecords(tHighAuditID,1,"E","ITI-21",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 source record for PDQ Query:"_tCount) 
	Do ..FindAuditRecords(tHighAuditID,0,"E","ITI-21",.tCount)
	If '$$$AssertTrue(tCount=1,"Audit should report 1 PDQ supplier record for PDQ Query:"_tCount)
}

Method Test140ContinuationPDQ()
{
	$$$HSTestBailout
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Jason"
	Set tRequest.LastName="PDQJohnson"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1955-04-25")
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PDQVille"
	Set tAddress.StreetLine="123 2nd PDQ Street"
	Set tAddress.PostalCode="PDQP2"
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	For tMPIID=1:1:15 {
		Set tAddRequest=tRequest.%ConstructClone(1)
		Set tAddRequest.MPIID=88000000+tMPIID
		Set tAddRequest.MRN="PDQ"_tMPIID
		Set tSC = ##class(HS.Test.Service).SendSync(tAddRequest,.tResponse)
	}

	For tHost=..#PDQv2Consumer,..#PDQv3Consumer {
		Set tHighAuditID = ..FindHighAuditID()
		#; Create AddUpdateHubRequest
		Set tRequest=##class(HS.Message.PatientSearchRequest).%New()
		Set tRequest.FirstName="Jason"
		Set tRequest.LastName="PDQJohnson"
		Set tRequest.Sex="M"
		Set tRequest.DOB=tRequest.DOBDisplayToLogical("1955-04-25")
		Set tRequest.AssigningAuthority="EXTERNAL"
		//Set tRequest.Facility="EXTERNAL"
		Set tAddress=##class(HS.Types.Address).%New()
		Do tRequest.Addresses.Insert(tAddress)
		Set tAddress.City="PDQVille"
		Set tAddress.StreetLine="123 2nd PDQ Street"
		Set tAddress.PostalCode="PDQP2"
		Set tRequest.MaxMatches=3
		#; send request to test service
		Do tRequest.AdditionalInfo.SetAt(tHost,"Host")
		Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
		Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
		Quit:'$$$AssertStatusOK(tSC,"QueryPatient")
		If '$$$AssertTrue(tResponse.ResultsCount=3,"Expected three results:"_tResponse.ResultsCount) 
		
		Set tRequest.MaxMatches=9
		Do tRequest.AdditionalInfo.SetAt(tResponse.AdditionalInfo.GetAt("ContinuationPointer"),"ContinuationPointer")
		Do tRequest.AdditionalInfo.SetAt(tResponse.AdditionalInfo.GetAt("OriginalQueryID"),"OriginalQueryID")
		Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
		Quit:'$$$AssertStatusOK(tSC,"QueryPatient")
		If '$$$AssertTrue(tResponse.ResultsCount=9,"Expected nine results:"_tResponse.ResultsCount)

		Do tRequest.AdditionalInfo.SetAt(tResponse.AdditionalInfo.GetAt("ContinuationPointer"),"CancelQuery")
		Do tRequest.AdditionalInfo.SetAt(tResponse.AdditionalInfo.GetAt("OriginalQueryID"),"OriginalQueryID")
		Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse) 
		Quit:'$$$AssertStatusOK(tSC,"QueryPatient:"_tHost)

	}
}

Method Test150PDQ()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	Set tHighAuditID = ..FindHighAuditID()
	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Test150"
	Set tRequest.LastName="PDQ"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1978-5-25")
	Set tRequest.MRN="PDQ-150"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Set tAddress=##class(HS.Types.Address).%New()
	Do tRequest.Addresses.Insert(tAddress)
	Set tAddress.City="PDQVille"
	Set tAddress.StreetLine="150 1st PDQ Street"
	Set tAddress.PostalCode="PDQP1"
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Jimmy"
	Set tName.Middle="Middle"
	Set tName.Family="PDQ"
	Set tName.Suffix="III"
	Set tName.Type="Alias"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Johnny"
	Set tName.Middle="Middle"
	Set tName.Family="PDQ"
	Set tName.Suffix="III"
	Set tName.Type="Alias"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="Test150"
	Set tName.Middle="Middle"
	Set tName.Family="Smith-PDQ"
	Set tName.Suffix=""
	Set tName.Type="Birth"
	Do tRequest.Names.Insert(tName)
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mrs"
	Set tName.Given="Mary"
	Set tName.Middle="no-Middle"
	Set tName.Family="Jones-PDQ"
	Set tName.Suffix=""
	Set tRequest.MothersName=tName
	Set tName = ##class(HS.Types.PersonName).%New()
	Set tName.Prefix="Mr"
	Set tName.Given="John"
	Set tName.Middle="no-Middle"
	Set tName.Family="Smith-PDQ"
	Set tName.Suffix=""
	Set tRequest.FathersName=tName
	Set tRequest.MothersMaidenSurname="Jones-PDQ"
	#; send request to test service
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient:"_tResponse.MPIID)
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error")

	Set tSearchRequest=##class(HS.Message.PatientSearchRequest).%New()
	Do tSearchRequest.CopyFrom(tRequest,tSearchRequest,1)
	Set tSearchRequest.MothersName = tRequest.MothersName
	Set tSearchRequest.FathersName = tRequest.FathersName
	
	Do tSearchRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	For tHost=..#PDQv3Consumer {
		Do tSearchRequest.AdditionalInfo.SetAt(tHost,"Host")
		Set tSC = ##class(HS.Test.Service).SendSync(tSearchRequest,.tSearchResponse)
		Quit:'$$$AssertStatusOK(tSC,"Search Patient OK")
		Quit:'$$$AssertTrue(1=tSearchResponse.Results.Count(),"Found one patient for the search")
		Set tResult = tSearchResponse.Results.GetAt(1)
		If $$$AssertTrue(tResult.FathersName.Family]"","Have Fathers name")
		If $$$AssertTrue(tResult.MothersName.Family]"","Have Mothers name")
		If $$$AssertTrue(tResult.Names.Count()=3,"Have 3 Names (2 aliases and a birth name)")
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
