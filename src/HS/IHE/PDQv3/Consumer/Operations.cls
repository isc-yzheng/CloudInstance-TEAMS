Include (HS.IHE.PDQ, HS.IHE.ATNA)

Class HS.IHE.PDQv3.Consumer.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base, HS.Util.XSLTTransformer) [ Inheritance = right, ProcedureBlock ]
{

Parameter FOUNDATION = 1;

Parameter SETTINGS = "Device:Basic:selector?Select=1&context={HS.Util.ContextSearch/DeviceOIDs},TransformPatientSearchToPDQ,TransformPDQToPatientSearch,TransformPatientSearchToQUQIIN,-XSLTDirectory";

/// Used as the sender device ID - IdentityCode from the HS.Data.OIDMap table
Property Device As %String [ InitialExpression = "PDQv3.Sender" ];

/// converted device entry to OID
Property DeviceOID As %String(MAXLEN = 64);

/// Capture the RegistryService $lb(Name,ID) from the service name
Property RegistryService As %String;

/// PatientSearchRequest to PIX query (201309)
Property TransformPatientSearchToPDQ As %String(MAXLEN = "") [ InitialExpression = "IHE/PDQ/Version1/PatientSearchToPRPAIN201305UV.xsl" ];

/// PIX response 201310 to PatientSearchResponse
Property TransformPDQToPatientSearch As %String(MAXLEN = "") [ InitialExpression = "IHE/PDQ/Version1/PRPAIN201306UVToPatientSearchResponse.xsl" ];

Property TransformPatientSearchToQUQIIN [ InitialExpression = "IHE/PDQ/Version1/PatientSearchToQUQIIN000003UV01.xsl" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.PatientSearchRequest"> 
		<Method>PDQRequest</Method>
	</MapItem>
</MapItems>
}

Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If (pRequest.Name = $$$PDQv3QueryRequest) {
			Set tAction			= $$$PDQv3QueryAction(1)
			Set pResponse.Name	= $$$PDQv3QueryResponse
		}
		ElseIf (pRequest.Name = $$$PDQv3ContinueRequest) {
			Set tAction			= $$$PDQv3ContinueAction(1)
			Set pResponse.Name	= $$$PDQv3ContinueResponse
		}
		ElseIf (pRequest.Name = $$$PDQv3CancelRequest) {
			Set tAction			= $$$PDQv3CancelAction(1)
			Set pResponse.Name	= $$$PDQv3CancelResponse
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}

		Set tSC= ..InvokeWebService(,, tAction, pRequest, .tResponse)
		Quit:$$$ISERR(tSC)
		If $$$ISERR(tSC) $$$HSTRACE("Web Service Response","tSC",tSC) Quit 
		$$$HSTRACE("Web Service Response","tResponse",tResponse) 
		Set pResponse.ContentStream	= tResponse.ContentStream
		Do $$$ATNAEvent("PDQv3Consumer",pRequest,pResponse,tSC)
	}
	Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	
	Quit tSC
}

Method PDQRequest(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		If pRequest.AdditionalInfo.GetAt("ContinuationPointer")'="" {
			Set tSC = ..PDQContinuation(pRequest, .pResponse)
		} ElseIf pRequest.AdditionalInfo.GetAt("CancelQuery")'="" {
			Set tSC = ..PDQCancel(pRequest, .pResponse)
		} Else {
			Set tSC = ..PDQLookup(pRequest, .pResponse)
		}

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// given the additional info selected in the document set list issue fetch
Method PDQLookup(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		Set tRequest = pRequest.%ConstructClone(0)
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		#; For some reason NIST PIX PDQ pre-Connecathon wants queryExtension hard-coded to NIST_CONTINUATION.
		Set tQueryExtension = $Select(pRequest.AdditionalInfo.GetAt("TestNIST"):"NIST_CONTINUATION",1:"1")
		
		#; build a PDQv3 using PatientSearchRequest
		Do ..UpdateRegistryService(tServiceName)
  		Set tXSLArguments("messageExtension") = "1"
  		Set tXSLArguments("messageID") = $system.Util.CreateGUID()
  		Set tXSLArguments("queryID") = $system.Util.CreateGUID()
  		Set tXSLArguments("queryExtension") = tQueryExtension
  		Set tXSLArguments("receiverDeviceOID") = $lg(..RegistryService,3)
		Set tXSLArguments("senderDeviceOID") = ..DeviceOID
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()

		#dim tInput as %Stream.GlobalCharacter
		$$$HSTRACE("aa "_tRequest.AssigningAuthority)
  		Set tSC = tRequest.XMLExportToStream(.tInput) Quit:$$$ISERR(tSC)
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput, ..TransformPatientSearchToPDQ /*"IHE/PDQ/Version1/PatientSearchToPRPAIN201305UV.xsl"*/,.tOutput,.tXSLArguments) 
	   	Quit:$$$ISERR(tSC) 
	   	Do tOutput.Rewind()
	   	$$$HSTRACE("PDQ Request","tOutput",tOutput)
	   	Do tOutput.Rewind()
		Set tRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRetrieveRequest.Name = $$$PDQv3QueryRequest
		Do tRetrieveRequest.ContentStream.CopyFrom(tOutput)
		Do tRetrieveRequest.ContentStream.Rewind()
		Do:tServiceName]"" tRetrieveRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRetrieveRequest) //SAML/User Auth
		Set tSC=..OnMessage(tRetrieveRequest,.tResponse) 
		Quit:$$$ISERR(tSC)
		Kill tXSLArguments
		Set tSC = ..TransformIntoObject(tResponse.ContentStream,..TransformPDQToPatientSearch /*"IHE/PDQ/Version1/PRPAIN201306UVToPatientSearchResponse.xsl"*/,.pResponse,.tXSLArguments,"HS.Message.PatientSearchResponse") 
		Set tAffinityDomain=$S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		For tIdx=1:1:pResponse.Results.Count() {
			Set tResponse=pResponse.Results.GetAt(tIdx)
			#; locate MPI ID and move to property
			For tIdx2=1:1:tResponse.Identifiers.Count() {
				Set tIdentifier = tResponse.Identifiers.GetAt(tIdx2)
				If $zcvt(tIdentifier.Root,"l")=$zcvt(tAffinityDomain,"l") Set tResponse.MPIID=tIdentifier.Extension Quit
			}
			/// Ensure response is consistent with what is returned from MPI Manager (Primarily for XCPD)
			If tResponse.MPIID]"" {
				Set tMPIMatch = ##class(HS.Message.PatientMPIMatch).%New()
				Do tMPIMatch.CopyFrom(tResponse,tMPIMatch)
				Set tMPIMatch.Names=tResponse.Names
				Set tMPIMatch.MothersName=tResponse.MothersName
				Set tMPIMatch.FathersName=tResponse.FathersName
				Set tMPIMatch.SpousesName=tResponse.SpousesName

				Do tMPIMatch.SearchMatches.Insert(tIdx)
				For tIdxA=1:1:tResponse.Addresses.Count() {
					Do tMPIMatch.Addresses.Insert(tResponse.Addresses.GetAt(tIdxA))
				}
				Do pResponse.MPIIDList.Insert(tMPIMatch)
			}
		}
		Set pResponse.ErrStatus=$S(pResponse.AdditionalInfo.GetAt("ErrStatusText")="":$$$OK,1:$$$ERROR($$$GeneralError,pResponse.AdditionalInfo.GetAt("ErrStatusText")))
		Do pResponse.AdditionalInfo.RemoveAt("ErrStatusText")
		Set pResponse.ResultsCount=pResponse.Results.Count()
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// given the additional info selected in the document set list issue fetch
Method PDQContinuation(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		Set tRequest = pRequest.%ConstructClone(0)
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		#; For some reason NIST PIX PDQ pre-Connecathon wants queryExtension hard-coded to NIST_CONTINUATION.
		Set tQueryExtension = $Select(pRequest.AdditionalInfo.GetAt("TestNIST"):"NIST_CONTINUATION",1:"1")
		
		#; build a PDQv3 using PatientSearchRequest
		Do ..UpdateRegistryService(tServiceName)
  		Set tXSLArguments("messageExtension") = "1"
  		Set tXSLArguments("messageID") = $system.Util.CreateGUID()
  		Set tXSLArguments("queryID") = pRequest.AdditionalInfo.GetAt("OriginalQueryID")
  		Set tXSLArguments("queryExtension") = tQueryExtension
  		Set tXSLArguments("receiverDeviceOID") = $lg(..RegistryService,3)
		Set tXSLArguments("senderDeviceOID") = ..DeviceOID
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()

		#dim tInput as %Stream.GlobalCharacter
		$$$HSTRACE("aa "_tRequest.AssigningAuthority)
  		Set tSC = tRequest.XMLExportToStream(.tInput) Quit:$$$ISERR(tSC)
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput, ..TransformPatientSearchToQUQIIN /*"IHE/PDQ/Version1/PatientSearchToQUQIIN000003UV01"*/,.tOutput,.tXSLArguments) 
	   	Quit:$$$ISERR(tSC) 
	   	Do tOutput.Rewind()
	   	$$$HSTRACE("PDQ Continuation","tOutput",tOutput)
	   	Do tOutput.Rewind()
		Set tRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRetrieveRequest.Name = $$$PDQv3ContinueRequest
		Do tRetrieveRequest.ContentStream.CopyFrom(tOutput)
		Do tRetrieveRequest.ContentStream.Rewind()
		Do:tServiceName]"" tRetrieveRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRetrieveRequest) //SAML/User Auth
		Set tSC=..OnMessage(tRetrieveRequest,.tResponse) 
		Quit:$$$ISERR(tSC)
		Kill tXSLArguments
		Set tSC = ..TransformIntoObject(tResponse.ContentStream,..TransformPDQToPatientSearch /*"IHE/PDQ/Version1/PRPAIN201306UVToPatientSearchResponse.xsl"*/,.pResponse,.tXSLArguments,"HS.Message.PatientSearchResponse") 
		Set tAffinityDomain=$S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		For tIdx=1:1:pResponse.Results.Count() {
			Set tResponse=pResponse.Results.GetAt(tIdx)
			#; locate MPI ID and move to property
			For tIdx2=1:1:tResponse.Identifiers.Count() {
				Set tIdentifier = tResponse.Identifiers.GetAt(tIdx2)
				If $zcvt(tIdentifier.Root,"l")=$zcvt(tAffinityDomain,"l") Set tResponse.MPIID=tIdentifier.Extension Quit
			}
		}
		Set pResponse.ErrStatus=$S(pResponse.AdditionalInfo.GetAt("ErrStatusText")="":$$$OK,1:$$$ERROR($$$GeneralError,pResponse.AdditionalInfo.GetAt("ErrStatusText")))
		Do pResponse.AdditionalInfo.RemoveAt("ErrStatusText")
		Set pResponse.ResultsCount=pResponse.Results.Count()
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// given the additional info selected in the document set list issue fetch
Method PDQCancel(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		Set tRequest = pRequest.%ConstructClone(0)
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		#; For some reason NIST PIX PDQ pre-Connecathon wants queryExtension hard-coded to NIST_CONTINUATION.
		Set tQueryExtension = $Select(pRequest.AdditionalInfo.GetAt("TestNIST"):"NIST_CONTINUATION",1:"1")
		
		#; build a PDQv3 using PatientSearchRequest
		Do ..UpdateRegistryService(tServiceName)
  		Set tXSLArguments("messageExtension") = "1"
  		Set tXSLArguments("messageID") = $system.Util.CreateGUID()
  		Set tXSLArguments("queryID") = pRequest.AdditionalInfo.GetAt("OriginalQueryID")
  		Set tXSLArguments("queryExtension") = tQueryExtension
  		Set tXSLArguments("receiverDeviceOID") = $lg(..RegistryService,3)
		Set tXSLArguments("senderDeviceOID") = ..DeviceOID
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()

		#dim tInput as %Stream.GlobalCharacter
		$$$HSTRACE("aa "_tRequest.AssigningAuthority)
  		Set tSC = tRequest.XMLExportToStream(.tInput) Quit:$$$ISERR(tSC)
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput, ..TransformPatientSearchToQUQIIN /*"IHE/PDQ/Version1/PatientSearchToQUQIIN000003UV01"*/,.tOutput,.tXSLArguments) 
	   	Quit:$$$ISERR(tSC) 
	   	Do tOutput.Rewind()
	   	$$$HSTRACE("PDQ Continuation","tOutput",tOutput)
	   	Do tOutput.Rewind()
		Set tRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRetrieveRequest.Name = $$$PDQv3CancelRequest
		Do tRetrieveRequest.ContentStream.CopyFrom(tOutput)
		Do tRetrieveRequest.ContentStream.Rewind()
		Do:tServiceName]"" tRetrieveRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRetrieveRequest) //SAML/User Auth
		Set tSC=..OnMessage(tRetrieveRequest,.tResponse) 
		Quit:$$$ISERR(tSC)
		Kill tXSLArguments
		Set tSC = ..TransformIntoObject(tResponse.ContentStream,..TransformPDQToPatientSearch /*"IHE/PDQ/Version1/PRPAIN201306UVToPatientSearchResponse.xsl"*/,.pResponse,.tXSLArguments,"HS.Message.PatientSearchResponse") 
		Set tAffinityDomain=$S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		For tIdx=1:1:pResponse.Results.Count() {
			Set tResponse=pResponse.Results.GetAt(tIdx)
			#; locate MPI ID and move to property
			For tIdx2=1:1:tResponse.Identifiers.Count() {
				Set tIdentifier = tResponse.Identifiers.GetAt(tIdx2)
				If $zcvt(tIdentifier.Root,"l")=$zcvt(tAffinityDomain,"l") Set tResponse.MPIID=tIdentifier.Extension Quit
			}
		}
		Set pResponse.ErrStatus=$S(pResponse.AdditionalInfo.GetAt("ErrStatusText")="":$$$OK,1:$$$ERROR($$$GeneralError,pResponse.AdditionalInfo.GetAt("ErrStatusText")))
		Do pResponse.AdditionalInfo.RemoveAt("ErrStatusText")
		Set pResponse.ResultsCount=pResponse.Results.Count()
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

ClassMethod OnProductionStart(pConfigName As %String = "Unknown Actor") As %Status
{
	Quit $$$OK
}

/// This user callback method is called when the system is being stopped
ClassMethod OnProductionStop(pConfigName As %String = "Unknown Actor") As %Status
{
	Quit $$$OK
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
	Quit:$lg(..RegistryService)=pService
	Set tRegistryService = ##class(HS.Registry.Service.SOAP).EndPointForNameType(pService,"SOAP")
	Quit:'$IsObject(tRegistryService)
	Set tDeviceOID=##class(HS.Data.OIDMap).OIDForType(tRegistryService.OIDMapCode.GetAt("Device"),"Device")
	Set ..RegistryService = $lb(tRegistryService.Name,tRegistryService.%Id(),tDeviceOID,tRegistryService.OIDMapCode.GetAt("AssigningAuthority"))
}

}
