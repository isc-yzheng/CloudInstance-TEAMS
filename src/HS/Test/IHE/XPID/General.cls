Class HS.Test.IHE.XPID.General Extends HS.Test.IHE.XDSb.Base
{

Parameter BaseClassItems = "HS.Test.IHE.XDSb.Base";

Method Test100Setup()
{
	Set tSC = ..Setup()
	Set tSC = ##class(HS.Registry.Config).AddNewKey("\IHE\Registry\XPID\ContentCode\Code","XAD-PID Link Change")
	Set tSC = ##class(HS.Registry.Config).AddNewKey("\IHE\Registry\XPID\ContentCode\Scheme","Connect-a-thon contentTypeCodes")
	Set tSC= ##class(HS.IHE.CodedEntry).ImportFromURL("xdata://"_..%ClassName(1)_":XDataContentCodes") 
	
	$$$HSTestAssertTrueOrBail(tSC,"Configured production "_tSC)
	$$$HSTestBailout
}

/// Add Patient with MPIID 7777777
Method Test120General()
{
	$$$HSTestBailout
	$$$HSTestSkipUnless("core")

	#; Create AddUpdateHubRequest
	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Father"
	Set tRequest.LastName="XPID"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1965-05-22")
	Set tRequest.MRN="FatherXPID"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient")
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error:"_tResponse.MPIID)
	Set tFatherMPIID=tResponse.MPIID
	Do ..createDocument("XPID Father#1",tFatherMPIID,.tSubmissionFather,1,tRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO")

	Set tRequest=##class(HS.Message.AddUpdateHubRequest).%New()
	Set tRequest.FirstName="Son"
	Set tRequest.LastName="XPID"
	Set tRequest.Sex="M"
	Set tRequest.DOB=tRequest.DOBDisplayToLogical("1975-04-18")
	Set tRequest.MRN="SonXPID"
	Set tRequest.AssigningAuthority="EXTERNAL"
	Set tRequest.Facility="EXTERNAL"
	Do tRequest.AdditionalInfo.SetAt(..#MPIManager,"Host")
	Do tRequest.AdditionalInfo.SetAt($$$CurrentMethod,"Caller")
	Set tSC = ##class(HS.Test.Service).SendSync(tRequest,.tResponse)
	Quit:'$$$AssertStatusOK(tSC,"AddPatient")
	Quit:'$$$AssertTrue(tResponse.ErrStatus=""||(tResponse.ErrStatus=$$$OK),"Patient added without error:"_tResponse.MPIID)
	Set tSonMPIID=tResponse.MPIID
	Do ..createDocument("XPID Son#1",tSonMPIID,.tSubmissionSon,1,tRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode("EXTERNAL")_"&ISO")

	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tFatherMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Set tFatherDoc=tQDResponse.Documents.Count()
	Quit:'$$$AssertTrue(tFatherDoc,"Have documents for Father:"_tFatherDoc)

	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tSonMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Set tSonDoc=tQDResponse.Documents.Count()
	Quit:'$$$AssertTrue(tSonDoc,"Have documents for Son:"_tSonDoc)


	Set tString="MSH|^~\&|1.3.6.1.4.1.21367.2010.1.2.300||EHRI|CH|20100112113930||ADT^A43|20100126000022537083|D|2.5|"_$c(13)_
				"EVN|A43|20100126113925"_$c(13)_
				"PID|||"_tFatherMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO^XADPID^EMPI~FatherXPID^^^&1.3.6.1.4.1.21367.2010.1.2.310&ISO^MRN^HOSP_2|||||||||||||||||||||||||||N"_$c(13)_
				"MRG|"_tSonMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO^XADPID^EMPI~SonXPID^^^&1.3.6.1.4.1.21367.2010.1.2.310&ISO"_$c(13)

	//Set tMessage=##class(EnsLib.HL7.Message).ImportFromString(tString)
	//break
	//Set tSC = ##class(Ens.Director).CreateBusinessService("HS.Generated.Test.IHE.XPID.Services",.tService)
	//Set:$$$ISOK(tSC) tSC = tService.ProcessInput(tMessage,.pOutput,60)
	Set Host="localhost",Port="48007"
	Set device="|TCP|"_Port
	Open device:(Host:Port):5 Set tOpenedPort=$T Quit:'$$$AssertTrue(tOpenedPort,"Opened XPID port")
	Use device Write tString,!,*3
	Set tResponseString=""
	For  Use device Read Response:10 Quit:'$T  Use 0 Set tResponseString=tResponseString_Response
	Close device
	Quit:'$$$AssertTrue(tResponseString["MSA|AA","Positive Acknowledgement")
	
	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tFatherMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Set tUpdatedFatherDoc=tQDResponse.Documents.Count()
	Quit:'$$$AssertTrue(tUpdatedFatherDoc,"Have documents for Father:"_tUpdatedFatherDoc)

	Set tQDRequest=##class(HS.Message.IHE.XDSb.QueryRequest).%New()
	Do tQDRequest.AddPatientId(tSonMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO")
	Do tQDRequest.AddStatusValues("Approved")
	Do tQDRequest.AddDocumentType(3)  /// Both ondemand and stable
	Do tQDRequest.AdditionalInfo.SetAt(..#DocumentConsumer,"Host") 
	Set tSC = ##class(HS.Test.Service).SendSync(tQDRequest,.tQDResponse)
	Quit:'$$$AssertStatusOK(tSC,"Query Completed without error")
	Set tUpdatedSonDoc=tQDResponse.Documents.Count()
	If $$$AssertTrue('tUpdatedSonDoc,"Have documents for Son (should be 0):"_tUpdatedSonDoc)

	If $$$AssertTrue((tUpdatedSonDoc+tUpdatedFatherDoc)=(tFatherDoc+tSonDoc),"Document count correct")
}

XData AdditionalItems
{
<Items>
<Item Name="HS.Generated.Test.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
<Setting Target="Host" Name="MergeByMPIID">2</Setting>
</Item>
<Item Name="HS.Generated.Test.IHE.XPID.Services" Category="" ClassName="HS.IHE.HL7v2.Services" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Adapter" Name="Port">48007</Setting>
<Setting Target="Host" Name="TargetConfigNames">HS.Generated.Test.IHE.PIX.Consumer.Process</Setting>
<Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
<Setting Target="Adapter" Name="JobPerConnection">1</Setting>
<Setting Target="Host" Name="AckMode">App</Setting>
</Item>
<Item Name="HS.Generated.Test.IHE.PIX.Consumer.Process" Category="" ClassName="HS.IHE.PIX.Consumer.Process" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
<Setting Target="Host" Name="MPIOperations"></Setting>  <!-- we don't want the MPI to get updated as it messes with multiple runs -->
<Setting Target="Host" Name="NotifyOthers">HS.Generated.Test.IHE.XDSb.Registry.Operations</Setting>
</Item>
</Items>
}

XData AdditionalOIDEntries
{
}

XData AdditionalRegistryEntries
{
}

XData XDataContentCodes
{
<Codes>
<CodeType name="contentTypeCode" classScheme="urn:uuid:aa543740-bdda-424e-8c96-df4873be8500">
<Code code="XAD-PID Link Change" display="XAD-PID Link Change" codingScheme="Connect-a-thon contentTypeCodes"/>
</CodeType>
</Codes>
}

}
