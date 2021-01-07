Include (HS.HC, HS.IHE.PIX, HS.IHE.ATNA)

/// Class used to create and/or send PIX v3 Query message to PIX Manager 
Class HS.IHE.PIXv3.Consumer.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base, HS.Util.XSLTTransformer) [ Inheritance = right, ProcedureBlock ]
{

Parameter FOUNDATION = 1;

Parameter SETTINGS = "Device:Basic:selector?Select=1&context={HS.Util.ContextSearch/DeviceOIDs},TransformPatientSearchToPIX,TransformPIXToPatientSearch,-XSLTDirectory";

/// Used as the sender device ID - IdentityCode from the HS.Data.OIDMap table
Property Device As %String [ InitialExpression = "PIXv3.Consumer" ];

/// PatientSearchRequest to PIX query (201309)
Property TransformPatientSearchToPIX As %String(MAXLEN = "") [ InitialExpression = "IHE/PIX/Version1/PatientSearchToPRPAIN201309UV.xsl" ];

/// PIX response 201310 to PatientSearchResponse
Property TransformPIXToPatientSearch As %String(MAXLEN = "") [ InitialExpression = "IHE/PIX/Version1/PRPAIN201310UVToPatientSearchResponse.xsl" ];

/// converted device entry to OID
Property DeviceOID As %String(MAXLEN = 64);

/// Capture the RegistryService $lb(Name,ID) from the service name
Property RegistryService As %String;

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.PatientSearchRequest"> 
		<Method>PIXLookup</Method>
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
		If (pRequest.Name = $$$PIXv3QueryRequest) {
			Set tAction			= $$$PIXv3QueryAction(1)
			Set pResponse.Name	= $$$PIXv3QueryResponse
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) 
			Quit
		}

		Set tSC= ..InvokeWebService(,, tAction, pRequest, .tResponse)
		Quit:$$$ISERR(tSC)
		$$$HSTRACE("PIX Response","tResponse",tResponse)
		Set pResponse.ContentStream	= tResponse.ContentStream
		Set tSC = $$$ATNAEvent("PIXv3Consumer",pRequest,pResponse,tSC)
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
	}
	Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	
	Quit tSC
}

/// given the additional info selected in the document set list issue fetch
/// 
Method PIXLookup(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		#; build a PIXv3 using PatientSearchRequest
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		Do ..UpdateRegistryService(tServiceName)
  		Set tXSLArguments = ""
  		Set tXSLArguments("queryID") = $system.Util.CreateGUID()
  		Set tXSLArguments("queryExtension") = "1"
  		Set tXSLArguments("receiverDeviceOID") = $lg(..RegistryService,3)
		Set tXSLArguments("senderDeviceOID") = ..DeviceOID
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()
		
		#dim tInput as %Stream.GlobalCharacter
  		Set tSC = pRequest.XMLExportToStream(.tInput) Quit:$$$ISERR(tSC)
	  	Do tInput.Rewind() 
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput,..TransformPatientSearchToPIX /*"IHE/PIX/Version1/PatientSearchToPRPAIN201309UV.xsl"*/,.tTarget,.tXSLArguments) 
	   	IF $$$ISERR(tSC) {
	   		$$$LOGERROR("Unable to transform PatientSearch to pix")
	   		Quit
	   	}
	   	
	 	#dim tRetrieveRequest as HS.Message.XMLMessage
	 	#dim tRetrieveResponse as HS.Message.XMLMessage
	 	#dim tStreamTemp as %Stream.GlobalCharacter
		Set tRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRetrieveRequest.Name = $$$PIXv3QueryRequest
		Set tRetrieveRequest.ContentStream = tTarget
		Do tRetrieveRequest.ContentStream.Rewind()
		Do tTarget.Rewind() 
		Do:tServiceName]"" tRetrieveRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRetrieveRequest)  ///SAML/User Auth
		Set tSC=..OnMessage(tRetrieveRequest,.tResponse) 
		Quit:$$$ISERR(tSC)
		Kill tXSLArguments
		Set tSC = ..TransformIntoObject(tResponse.ContentStream,..TransformPIXToPatientSearch /*"IHE\PIX\Version1\PRPAIN201310UVToPatientSearchResponse.xsl"*/,.pResponse,.tXSLArguments,"HS.Message.PatientSearchResponse","PatientSearchResponse") 
		Set tAffinityDomain=$S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		For tIdx=1:1:pResponse.Results.Count() {
			Set tItem=pResponse.Results.GetAt(tIdx)
			For tIdx2=1:1:tItem.Identifiers.Count() {
				If $zcvt(tItem.Identifiers.GetAt(tIdx2).Root,"l")=$zcvt(tAffinityDomain,"l") Set tItem.MPIID=tItem.Identifiers.GetAt(tIdx2).Extension Quit
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
