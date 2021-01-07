Include HS.AU.Common

Class HS.AU.PCEHR.Consumer.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base, HS.Util.XSLTTransformer) [ Inheritance = right, ProcedureBlock ]
{

Parameter SETTINGS = "-SOAPVersion,-SSLConfiguration,-SOAPCredentials,-Timeout,-SendSAMLAssertion,-SAMLCreator";

/// Allow a different header class by overriding paramter value
Parameter HEADERCLASS = "HS.AU.PCEHR.WebRequest";

XData MessageMap
{
<MapItems>
<MapItem MessageType="HS.AU.Message.PCEHR.DoesPCEHRExistRequest"> 
<Method>DoesPCEHRExist</Method>
</MapItem>
<MapItem MessageType="HS.AU.Message.PCEHR.GainPCEHRAccessRequest"> 
<Method>GainPCEHRAccess</Method>
</MapItem>

</MapItems>
}

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("OnMessage Request","Request",pRequest)

		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If (pRequest.Name = $$$PCEHRDoesPCEHRExistRequest) {
			Set tAction			= $$$PCEHRDoesPCEHRExistAction
			Set pResponse.Name	= $$$PCEHRDoesPCEHRExistResponse
		} ElseIf (pRequest.Name = $$$PCEHRGainPCEHRAccessRequest) {
			Set tAction			= $$$PCEHRGainPCEHRAccessAction
			Set pResponse.Name	= $$$PCEHRGainPCEHRAccessResponse
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
		Set tRequest = $classMethod(..#HEADERCLASS,"%New")
		Set tSC= ..InvokeWebService(tRequest,, tAction, pRequest, .tResponse)
		If $$$ISERR(tSC) {
			Set pResponse.SOAPFault=tSC
			Quit
		}
		$$$HSTRACE("Response","tResponse",tResponse)
		Set pResponse.ContentStream	= tResponse.ContentStream
	}
	Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	
	Quit tSC
}

/// Take Internal DoesPCEHRExistRequest and convert to AU PCEHR request
Method DoesPCEHRExist(pRequest As HS.AU.Message.PCEHR.DoesPCEHRExistRequest, ByRef pResponse As HS.AU.Message.PCEHR.DoesPCEHRExistResponse) As %Status
{
	Quit ..CommonRequest(pRequest,
			.pResponse,
			"AU/PCEHR/DoesPCEHRExistRequest.xsl",
			"AU/PCEHR/DoesPCEHRExistResponse.xsl",
			$$$PCEHRDoesPCEHRExistAction,
			$$$PCEHRDoesPCEHRExistRequest,
			$$$PCEHRDoesPCEHRExistResponse,
			"doesPCEHRExistResponse",
			"HS.AU.Message.PCEHR.DoesPCEHRExistResponse")
}

/// Take Internal GainPCEHRAccessRequest and convert to AU PCEHR request
Method GainPCEHRAccess(pRequest As HS.AU.Message.PCEHR.GainPCEHRAccessRequest, ByRef pResponse As HS.AU.Message.PCEHR.GainPCEHRAccessResponse) As %Status
{
	Quit ..CommonRequest(pRequest,
			.pResponse,
			"AU/PCEHR/GainPCEHRAccessRequest.xsl",
			"AU/PCEHR/GainPCEHRAccessResponse.xsl",
			$$$PCEHRGainPCEHRAccessAction,
			$$$PCEHRGainPCEHRAccessRequest,
			$$$PCEHRGainPCEHRAccessResponse,
			"gainPCEHRAccessResponse",
			"HS.AU.Message.PCEHR.GainPCEHRAccessResponse")
}

Method CommonRequest(pRequest As HS.Message.XMLMessage, ByRef pResponse As HS.Message.XMLMessage, pOutXSL = "", pInXSL = "", pAction = "", pRequestName = "", pResponseName = "", pInXSLTag = "", pInXSLObjectType = "") As %Status
{
	#dim tSC As %Status
	#dim eException As %Exception.AbstractException

	Set tSC=$$$OK
	try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)

		#dim tInput as %Stream.GlobalCharacter 
		#dim tWriter as %XML.Writer
  		Set tXSLArguments = ""
		Set tInput = ##class(%Stream.GlobalCharacter).%New()
		Set tWriter = ##class(%XML.Writer).%New()
		Set tSC = tWriter.OutputToStream(tInput)
		Set tSC=tWriter.RootObject(pRequest)
		IF $$$ISERR(tSC) {
	   		$$$LOGERROR("Unable to export request")
	   		Quit
	   	}
		#dim tTarget as %Stream.GlobalCharacter
	   	Set tSC = ..Transform(tInput,pOutXSL,.tTarget,.tXSLArguments) 
		Quit:$$$ISERR(tSC)		
			   	
	 	#dim tStreamTemp as %Stream.GlobalCharacter
		Set tAddRequest = ##class(HS.Message.XMLMessage).%New()
		Set tAddRequest.Name = pRequestName
		Do tAddRequest.AdditionalInfo.SetAt(pAction,"SOAPAction")
		Do:pRequest.AdditionalInfo.IsDefined("ServiceName") tAddRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("ServiceName"),"ServiceName")
		Do:pRequest.AdditionalInfo.IsDefined("NoSSL") tAddRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("NoSSL"),"NoSSL")
		Set tAddRequest.SAMLData=pRequest.SAMLData
		Set tAddRequest.ContentStream = tTarget
		Do tAddRequest.ContentStream.Rewind()
		Do tTarget.Rewind() 
		Set tSC=..OnMessage(tAddRequest,.tResponse) 
		Set pResponse.ServiceCallStatus=tSC
		If $$$ISERR(tSC) {
			// Set the ServiceCallCode and ServiceCallDescription properties, extracting values out of ServiceCallStatus
			Set pResponse.ServiceCallCode = $p($p(pResponse.ServiceCallStatus,"</ns2:errorCode>",1),"<ns2:errorCode>",2)
			Set pResponse.ServiceCallDescription = $p($p(pResponse.ServiceCallStatus,"</ns2:message>",1),"<ns2:message>",2)
			Set tSC=$$$OK
			Quit
		}


		Kill tXSLArguments
		$$$HSTRACE("Response","tResponse",tResponse)
	   	Set tSC = ..TransformIntoObject(tResponse.ContentStream,pInXSL,.tResponseObject,,pInXSLObjectType,pInXSLTag) 
		Quit:$$$ISERR(tSC)		
		If $IsObject(tResponseObject) Set pResponse=tResponseObject
	} Catch eException {
		Set tSC = eException.AsStatus()
		Set pResponse.ServiceCallStatus=tSC
	}
	
	Quit tSC
}

}
