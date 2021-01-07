Include (HS.HC, HS.IHE.PIX, HS.IHE.ATNA)

Class HS.IHE.PIXv3.Source.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base, HS.Util.XSLTTransformer) [ Inheritance = right, ProcedureBlock ]
{

Parameter FOUNDATION = 1;

Parameter SETTINGS = "Device:Basic:selector?Select=1&context={HS.Util.ContextSearch/DeviceOIDs},TransformAddUpdateHubToPIX,OperationToLocateMPIID,TransformMergeToPIX";

/// Used as the sender device ID - IdentityCode from the HS.Data.OIDMap table.  Receiver is defined by Device in Service Registry end point
Property Device As %String [ InitialExpression = "PIXv3.Sender" ];

/// PatientSearchRequest to PIX query (201309)
Property TransformAddUpdateHubToPIX As %String(MAXLEN = "") [ InitialExpression = "IHE/PIX/Version1/AddUpdateHubRequestToPRPAIN201301UV.xsl" ];

/// PIX response 201310 to PatientSearchResponse
Property TransformPIXToPatientSearch As %String(MAXLEN = "") [ InitialExpression = "IHE/PIX/Version1/PRPAIN201310UVToPatientSearchResponse.xsl" ];

Property TransformMergeToPIX As %String(MAXLEN = "") [ InitialExpression = "IHE/PIX/Version1/MergePatientRequestToPRPAIN201304UV.xsl" ];

/// converted device entry to OID
Property DeviceOID As %String(MAXLEN = 64);

/// Optional - When defined as the PIX consumer operation, issue a query to determine the MPIID to be inserted into the response
/// HS.IHE.PIXv3.Consumer.Operations
Property OperationToLocateMPIID As Ens.DataType.ConfigName;

/// Capture the RegistryService $lb(Name,ID) from the service name
Property RegistryService As %String;

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.AddUpdateHubRequest"> 
		<Method>PIXAddUpdate</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.MergePatientRequest"> 
		<Method>PIXMerge</Method>
	</MapItem>
</MapItems>
}

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("In PIX Request","Request",pRequest)

		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If (pRequest.Name = $$$PIXv3AddRequest) {
			Set tAction			= $$$PIXv3AddAction(1)
			Set pResponse.Name	= $$$PIXv3AddResponse
		} ElseIf (pRequest.Name = $$$PIXv3ReviseRequest) {
			Set tAction			= $$$PIXv3ReviseAction(1)
			Set pResponse.Name	= $$$PIXv3ReviseResponse
		} ElseIf (pRequest.Name = $$$PIXv3MergeRequest) {
			Set tAction			= $$$PIXv3MergeAction(1)
			Set pResponse.Name	= $$$PIXv3MergeResponse
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
		Set tSC= ..InvokeWebService(,, tAction, pRequest, .tResponse)
		Quit:$$$ISERR(tSC)
		$$$HSTRACE("PIX Response","tResponse",tResponse)
		Set pResponse.ContentStream	= tResponse.ContentStream
	}
	Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	
	Quit tSC
}

Method PIXAddUpdate(pRequest As HS.Message.AddUpdateHubRequest, ByRef pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		$$$HSTRACE("in pix")
		Set tRequest=pRequest.%ConstructClone(1)  /// Copy request so that updates are not saved
		#; build a PIXv3 using AddUpdateHubRequest
		#; ensure the service name / id is up-to-date
		Do ..UpdateRegistryService(tRequest.AdditionalInfo.GetAt("ServiceName"))
	
		Set tFacility = ##class(HS.Facility.Config).%OpenId(tRequest.Facility)
		Set tName = $S($isObject(tFacility)&&(tFacility.Name'=""):tFacility.Name,1:tRequest.Facility)
		Set tTelephone = $S($isObject(tFacility)&&(tFacility.Contact.Telephone'=""):tFacility.Contact.Telephone,1:"unknown")
		Do tRequest.AdditionalInfo.SetAt(tName,"FacilityName")
		Do tRequest.AdditionalInfo.SetAt($$$AffinityDomain,"AffinityDomainName")
		Do tRequest.AdditionalInfo.SetAt($$$AffinityDomain,"AffinityDomain")
		Do tRequest.AdditionalInfo.SetAt(tTelephone,"FacilityTelephone")

		If tRequest.MPIID]"" {
			Set tIdentifer=##class(HS.Types.Identifier).%New()
			Set tIdentifer.Root=$$$AffinityDomain
			Set tIdentifer.Extension=pRequest.MPIID
			Set tIdentifer.Use="PT"
			Do tRequest.Identifiers.Insert(tIdentifer)
		}
  		Set tXSLArguments = ""
  		Set tXSLArguments("receiverDeviceOID") = $lg(..RegistryService,3)
		Set tXSLArguments("senderDeviceOID") = ..DeviceOID
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()
		#dim tInput as %Stream.GlobalCharacter
  		Set tSC = tRequest.XMLExportToStream(.tInput) Quit:$$$ISERR(tSC)
	  	Do tInput.Rewind() 
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput,..TransformAddUpdateHubToPIX /*"IHE\PIX\Version1\AddUpdateHubRequestToPRPAIN201301UV.xsl"*/,.tTarget,.tXSLArguments) 

	   	IF $$$ISERR(tSC) {
	   		$$$LOGERROR("Unable to transform AddUpdateHubRequest to pix")
	   		Quit
	   	}
			   	
	 	#dim tStreamTemp as %Stream.GlobalCharacter
		Set tAddRequest = ##class(HS.Message.XMLMessage).%New()
		Set tAddRequest.Name = $S(tRequest.AddOrUpdate="U":$$$PIXv3ReviseRequest,1:$$$PIXv3AddRequest)
		Do tAddRequest.AdditionalInfo.SetAt($S(pRequest.AddOrUpdate="U":$$$PIXv3ReviseAction(1),1:$$$PIXv3AddAction(1)),"SOAPAction")
		Set tAddRequest.ContentStream = tTarget
		Do tAddRequest.ContentStream.Rewind()
		Do tTarget.Rewind() 
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(tRequest, tAddRequest)  ///SAML/User Auth
		
		Set tSC=..OnMessage(tAddRequest,.tResponse) 
		Quit:$$$ISERR(tSC)
		Kill tXSLArguments
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/hl7:MCCI_IN000002UV01/hl7:acknowledgement/hl7:typeCode","@code",.tValue,.tDocument)
		Quit:$$$ISERR(tSC)
		If tValue'="CA" {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/hl7:MCCI_IN000002UV01/hl7:acknowledgement/hl7:acknowledgementDetail/hl7:text","text()",.tValue,.tDocument)
			Set pResponse.ErrStatus=$$$ERROR($$$GeneralError,tValue)
		} Else {
			If ..OperationToLocateMPIID]"" {
				Set tQueryRequest=##class(HS.Message.PatientSearchRequest).%New()
				Set tQueryRequest.MRN=pRequest.MRN
				Set tQueryRequest.SearchMode="admin"
				Set tQueryRequest.AssigningAuthority=pRequest.AssigningAuthority
				Set tSC = ..SendRequestSync(..OperationToLocateMPIID,tQueryRequest,.tQueryResponse)
				#; if OperationToLocateMPIID is HUB results might be > 1 but MPIIDList will be 1, if using PIX Consumer, then MPIIDList=0 but Results should be 1
				If $$$ISOK(tSC) && (tQueryResponse.MPIIDList.Count()=1 || (tQueryResponse.Results.Count()=1)) {
					Set pResponse.MPIID=tQueryResponse.Results.GetAt(1).MPIID
					Do tResponse.AdditionalInfo.SetAt(tQueryResponse.Results.GetAt(1).MPIID_"^^^&"_$$$HomeCommunityOID_"&ISO","PatientId")
					Set pResponse.ErrStatus=tQueryRequest.ErrStatus
				}
			}
		}
		$$$HSTRACE("Add patient response","tResponse",tResponse)
		Do $$$ATNAEvent("PIXv3Source",tAddRequest,tResponse,tSC)

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

Method PIXMerge(pRequest As HS.Message.MergePatientRequest, ByRef pResponse As HS.Message.MergePatientResponse) As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		#; ensure the service name / id is up-to-date
		Do ..UpdateRegistryService(pRequest.AdditionalInfo.GetAt("ServiceName"))

		
  		Set tXSLArguments = ""
  		Set tXSLArguments("receiverDeviceOID") = $lg(..RegistryService,3)
		Set tXSLArguments("senderDeviceOID") = ..DeviceOID
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()
		
		Set tFacility = ##class(HS.Facility.Config).%OpenId(pRequest.Facility)
		Set tName = $S($isObject(tFacility)&&(tFacility.Name'=""):tFacility.Name,1:pRequest.Facility)
		Set tXSLArguments("facilityName") = tName

		If pRequest.AdditionalInfo.GetAt("familyName")'=""!(pRequest.AdditionalInfo.GetAt("givenName")'="") {
			Set tXSLArguments("patientFirstName") = pRequest.AdditionalInfo.GetAt("givenName")
			Set tXSLArguments("patientLastName") = pRequest.AdditionalInfo.GetAt("familyName")
		} Else {
			Set tPatient = ##class(HS.Registry.Patient).GetRecordForMRN(pRequest.AssigningAuthority,pRequest.MRN)
			If '$isObject(tPatient) Set tPatient=##class(HS.Registry.Patient).%New()
			Set tXSLArguments("patientFirstName") = tPatient.Name.Given
			Set tXSLArguments("patientLastName") = tPatient.Name.Family
		}

		#dim tInput as %Stream.GlobalCharacter
  		Set tSC = pRequest.XMLExportToStream(.tInput) Quit:$$$ISERR(tSC)
	  	Do tInput.Rewind() 

	   	IF $$$ISERR(tSC) {
	   		$$$LOGERROR("Unable to transform AddUpdateHubRequest to pix")
	   		Quit
	   	}
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput,..TransformMergeToPIX /*"IHE\PIX\Version1\MergePatientRequestToPRPAIN201304UV.xsl"*/,.tTarget,.tXSLArguments) 
		Quit:$$$ISERR(tSC)		
			   	
	 	#dim tStreamTemp as %Stream.GlobalCharacter
		Set tAddRequest = ##class(HS.Message.XMLMessage).%New()
		Set tAddRequest.Name = $$$PIXv3MergeRequest
		Do tAddRequest.AdditionalInfo.SetAt($$$PIXv3MergeAction(1),"SOAPAction")
		Set tAddRequest.ContentStream = tTarget
		Do tAddRequest.ContentStream.Rewind()
		Do tTarget.Rewind() 
		Set tSC=..OnMessage(tAddRequest,.tResponse) 
		Quit:$$$ISERR(tSC)
		Kill tXSLArguments
		$$$HSTRACE("patient search response","tResponse",tResponse)
		Do $$$ATNAEvent("PIXv3Source",tAddRequest,tResponse,tSC)
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/hl7:MCCI_IN000002UV01/hl7:acknowledgement/hl7:typeCode","@code",.tValue,.tDocument)
		Quit:$$$ISERR(tSC)
		If tValue'="CA" {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/hl7:MCCI_IN000002UV01/hl7:acknowledgement/hl7:acknowledgementDetail/hl7:text","text()",.tValue,.tDocument)
			Set pResponse.Accepted=0,pResponse.Text=tValue
		} Else {
			Set pResponse.Accepted=1
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

Method OnInit() As %Status
{
	#dim tSC As %Status
	#dim eException as %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set ..DeviceOID = ##class(HS.Data.OIDMap).OIDForType(..Device,"Device")
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

/// Generally the ServiceName will be defined, but in some cases the service may be picked up from 
/// the request.AdditionalInfo.GetAt("ServiceName") which will override the default service
Method UpdateRegistryService(pService)
{
	Set:pService="" pService=..ServiceName
	Set ..ServiceName=pService
	Quit:$lg(..RegistryService)=pService
	Set tRegistryService = ##class(HS.Registry.Service.SOAP).EndPointForNameType(..ServiceName,"SOAP")
	Quit:'$IsObject(tRegistryService)
	Set tDeviceOID=##class(HS.Data.OIDMap).OIDForType(tRegistryService.OIDMapCode.GetAt("Device"),"Device")
	Set ..RegistryService = $lb(tRegistryService.Name,tRegistryService.%Id(),tDeviceOID)
}

}
