Include (HS.HC, HS.IHE.XCPD)

/// The passthrough process is used when testing is not using XCPD but they still wish to use XCA 
/// Ensure that the service registry entries in XCPDQueryServiceNames have the HomeCommunity entries and AssigningAuthority assigned.  The service registry entry
/// will be opened and used to determine the home community oid to be inserted into the result set
/// Also set the AssigningAuthority on the endpoint the the AssigningAuthority to be used - as in at connectathon IHEBlue, IHERed, IHEGreen
Class HS.IHE.XCPD.InitiatingGateway.PassthroughProcess Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ ClassType = persistent, Inheritance = left ]
{

Parameter SETTINGS = "XCPDQueryServiceNames,HomeCommunity,PatientLookupTarget";

/// A comma separated list of XCPD Repositories (Registry Service Names)
Property XCPDQueryServiceNames As %String(MAXLEN = "");

Property XCPDInitiatingGatewayOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCPD.InitiatingGateway.Operations" ];

Property PatientLookupTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.HC.MPI.Manager" ];

/// Code for HomeCommunity OID from HS.Data.OIDMap where type=HomeCommunity
Property HomeCommunity As %String;

/// property to hold translated HomeCommunity
Property HomeCommunityOID As %String(MAXLEN = 64);

Property Errors As HS.Types.IHE.Errors;

Method OnRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		/// this code should exist in OnInit but that is broken
		Set:..HomeCommunity="" ..HomeCommunity=$$$HomeCommunity
		Set ..HomeCommunityOID = ##class(HS.Data.OIDMap).OIDForType(..HomeCommunity,"HomeCommunity")
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set tRequest=pRequest
		If pRequest.Name = $$$XCAQueryRequest {
			Set tSC=..FindPatient(pRequest,.tRequest) $$$ThrowOnError(tSC)
		}
		Set tSC = ..SendRequestSync(..PatientLookupTarget,tRequest,.tResponse)
		Do ..PatientDiscovery(tRequest,tResponse,.pResponse)
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

Method PatientDiscovery(pSearchRequest As HS.Message.PatientSearchRequest, pRequest As HS.Message.PatientSearchResponse, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Set tMRN= pSearchRequest.MPIID
		Set tAA = $$$AffinityDomain
		For tIdx = 1:1:pRequest.MPIIDList.Count() {
			Set tMPIIDResult = pRequest.MPIIDList.GetAt(tIdx)
			For tIdxIdent = 1:1:tMPIIDResult.Identifiers.Count() {
				Set tIdent = tMPIIDResult.Identifiers.GetAt(tIdxIdent)
				Set:tIdent.Root]"" tAryID(tIdent.Root)=tIdent.Extension
			}
		}

		#; Query each XCPD responding gateway for matching patient
		Set tQuerySystems = ..XCPDQueryServiceNames
		Set tQuerySysCount=$S(tQuerySystems="":0,1:$l(tQuerySystems,","))
		$$$HSTRACE("In Query request ","tQuerySystems",tQuerySystems)
		Set pResponse = ##class(HS.Message.IHE.XCPDPatients).%New()
		For tIdx1 = 1:1:tQuerySysCount {
			Set tQuerySys = $p(tQuerySystems,",",tIdx1)
			Set (tHomeCommunityID,tAffinityDomain)=""
			#dim tServiceRegistry as HS.Registry.Service.SOAP = ##class(HS.Registry.Service.SOAP).EndPointForNameType(tQuerySys,"SOAP")

			If '$IsObject(tServiceRegistry) {
				$$$HSTRACE("ServiceRegistryentry "_tQuerySys_" not found")
				Continue
			}
			Set tHomeCommunity = tServiceRegistry.OIDMapCode.GetAt("HomeCommunity")
			Set tAssigningAuthority = tServiceRegistry.OIDMapCode.GetAt("AssigningAuthority")
			If tAssigningAuthority = tAA {
				Set tID = tMRN
			} elseIf '$D(tAryID(tAssigningAuthority),tID) {
				Continue
			}
			Set tResponse = ##class(HS.Message.IHE.XCPDPatient).%New()
			Set tResponse.HomeCommunityId = tHomeCommunity
			Set tResponse.Root = $S(tAssigningAuthority]"":tAssigningAuthority,1:tAA)
			Set tResponse.AssigningAuthorityName=tResponse.Root
			Set tResponse.Extension=tID
			Do pResponse.Patients.Insert(tResponse)
		}
		$$$HSThrowErrors(tSC)
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCPDInitiatingGatewayError","Error",$system.Status.GetErrorText(tSC))
	}
	If ..Errors.Errors.Count() $$$HSTRACE("Errors","errors",..Errors)
	Quit tSC
}

/// Given an AdhocQueryRequest return the Patient ID in pPatientID as ID^^^&oid&ISO
Method ExtractPatientID(pRequest As HS.Message.XMLMessage, Output pPatientID As %String) As %Status
{
	try {
		Set tSC=$$$OK
		Set pPatientID=""
		#; get original patient id
		Set tXPathNamespaces=##class(HS.IHE.Util).XPathNamespaces()
		Set tSC=##class(%XML.XPATH.Document).CreateFromStream(pRequest.ContentStream, .tDocument, , , , , tXPathNamespaces) $$$ThrowOnError(tSC)
		Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$patientId']/rim:ValueList/rim:Value", "text()", .tPatientID) $$$ThrowOnError(tSC)
		If 'tPatientID.Count() {
			Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$XDSDocumentEntryPatientId']/rim:ValueList/rim:Value", "text()", .tPatientID) $$$ThrowOnError(tSC)
			If 'tPatientID.Count() $$$ThrowStatus($$$ERROR($$$GeneralError, "Unable to find PatientID from Query request"))
		}
		Set tPatientID = $zstrip(tPatientID.GetAt(1).Value,"<>","'")
		If tPatientID="" $$$ThrowStatus($$$ERROR($$$GeneralError, "Patient ID is empty"))
		Set tAA = $P($p(tPatientID,"^",4),"&",2)
		If tAA'=$$$AffinityDomainOID $$$ThrowStatus($$$ERROR($$$GeneralError, "Unknown Affinity Domain "_tAA))
		Set pPatientID = tPatientID _"^^^&"_tAA_"&ISO"
		$$$HSTRACE("PatientID "_tPatientID)
	} Catch eException {
		Set tSC=eException.AsStatus()
		$$$HSTRACE("Status","tSC",tSC)
	}
	Quit tSC
}

/// Given an AdhocQueryRequest return the Patient ID in pPatientID as ID^^^&oid&ISO
Method FindPatient(pRequest As HS.Message.XMLMessage, Output pResponse) As %Status
{
	try {
		Set tSC=$$$OK
		Set pPatientID=""
		#; get original patient id
		Set tXPathNamespaces=##class(HS.IHE.Util).XPathNamespaces()
		Set tSC=##class(%XML.XPATH.Document).CreateFromStream(pRequest.ContentStream, .tDocument, , , , , tXPathNamespaces) $$$ThrowOnError(tSC)
		Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$patientId']/rim:ValueList/rim:Value", "text()", .tPatientID) $$$ThrowOnError(tSC)
		If 'tPatientID.Count() {
			Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$XDSDocumentEntryPatientId']/rim:ValueList/rim:Value", "text()", .tPatientID) $$$ThrowOnError(tSC)
			If 'tPatientID.Count() $$$ThrowStatus($$$ERROR($$$GeneralError, "Unable to find PatientID from Query request"))
		}
		Set tPatientID = $zstrip(tPatientID.GetAt(1).Value,"<>","'")
		If tPatientID="" $$$ThrowStatus($$$ERROR($$$GeneralError, "Patient ID is empty"))
		Set tAA = $P($p(tPatientID,"^",4),"&",2)
		If tAA'=$$$AffinityDomainOID $$$ThrowStatus($$$ERROR($$$GeneralError, "Unknown Affinity Domain "_tAA))
		Set pPatientID = tPatientID _"^^^&"_tAA_"&ISO"
		$$$HSTRACE("PatientID "_tPatientID)
	} Catch eException {
		Set tSC=eException.AsStatus()
		$$$HSTRACE("Status","tSC",tSC)
	}
	Quit tSC
}

Storage Default
{
<Data name="PassthroughProcessDefaultData">
<Subscript>"PassthroughProcess"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>XCPDQueryServiceNames</Value>
</Value>
<Value name="3">
<Value>XDSbQueryServiceName</Value>
</Value>
<Value name="4">
<Value>SenderDevice</Value>
</Value>
<Value name="5">
<Value>SenderDeviceOID</Value>
</Value>
<Value name="6">
<Value>PDQv3Consumer</Value>
</Value>
<Value name="7">
<Value>XCPDInitiatingGatewayOperations</Value>
</Value>
<Value name="8">
<Value>HomeCommunity</Value>
</Value>
<Value name="9">
<Value>HomeCommunityOID</Value>
</Value>
<Value name="10">
<Value>IHEVersion</Value>
</Value>
<Value name="11">
<Value>Transformer</Value>
</Value>
<Value name="12">
<Value>Errors</Value>
</Value>
<Value name="13">
<Value>PatientLookupTarget</Value>
</Value>
</Data>
<DefaultData>PassthroughProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
