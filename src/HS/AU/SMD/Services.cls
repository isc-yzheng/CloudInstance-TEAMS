/// This WebService class extends HS.Util.SOAPServer.Base so that the streams can be manipulated directly
/// which means responses need to be of type HS.Message.XMLMessage
Class HS.AU.SMD.Services Extends (HS.IHE.Common.Services.SOAPServer.Base, HS.AU.SMD.Common) [ Inheritance = right ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE;

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 0;

/// This is the name of the Service
Parameter SERVICENAME = "SealedMessageDeliveryServices";

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE;

Parameter SETTINGS As %String = "SMDProcess:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Property SMDProcess As Ens.DataType.ConfigName [ InitialExpression = "HS.AU.SMD.Process" ];

Method OnProcessInput(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage = {$$$NULLOREF}) As %Status [ ServerOnly = 1 ]
{
	Set tSC = $$$OK
	
	Try {
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		$$$HSTRACEMIN("InboundRequest","pRequest",pRequest)
		Set tAction = pRequest.AdditionalInfo.GetAt("SOAPAction")
		If (tAction="http://ns.electronichealth.net.au/smd/svc/SealedImmediateMessageDelivery/2010/SealedImmediateMessageDelivery/deliverRequest") {
			Set pRequest.Name="ImmediateDelivery"
			Set tSC = ..ImmediateDelivery(pRequest,.pResponse)
		}
		ElseIf (tAction="http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010/SealedMessageDelivery/deliverRequest") {
			Set pRequest.Name="Delivery"
			Set tSC = ..Deliver(pRequest,.pResponse)
		}
		ElseIf (tAction="http://ns.electronichealth.net.au/smd/svc/TransportResponseDelivery/2010/TransportResponseDelivery/deliverRequest") {
			Set pRequest.Name="Delivery"
			Set tSC = ..TRDProcessing(pRequest,.pResponse)
		}
		Else {
			Set tSC = $$$EnsError("Unknown SOAP action:  " _ tAction)
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
	}
	Catch ex {
		$$$LOGERROR(ex.DisplayString())
		Set tSC = ex.AsStatus()
		set pResponse.SOAPFault=..makeDeliverErrorFromStatus(tSC)
	}
	
	Quit tSC
}

/// Receive request, generate response and respond immediately
Method ImmediateDelivery(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ ProcedureBlock = 1, SoapAction = "http://ns.electronichealth.net.au/smd/svc/SealedImmediateMessageDelivery/2010/SealedImmediateMessageDelivery/deliverRequest", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	Try {
		Set tSC = $$$OK
		Set tRequest = ##class(HS.AU.Message.SMD.InboundMessageRequest).%New()

		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set tResponse=##class(HS.AU.Message.SMD.ImmediateDeliveryResponse).%New()
		Set tSC = ..GetInboundMessage(pRequest,.tRequest,.tSOAPFault)
		#; if we have a soap fault this will end processing
		If tSOAPFault ]"" Set pResponse.SOAPFault=tSOAPFault Quit

		Do ..SetAddressingOut("http://ns.electronichealth.net.au/smd/svc/SealedImmediateMessageDelivery/2010/SealedImmediateMessageDelivery/deliverResponse")
		Set tRequest.Synchronous=1
		$$$THROWONERROR(tSC,..SendRequestSync(..SMDProcess,tRequest,.tResponse))
		Set tSC = ..GenerateSynchronousResponse(tRequest,tResponse,.tEncryptedResponse)
		$$$HSTRACEMIN("WebService","Response",tEncryptedResponse)		
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) Set pResponse.SOAPFault=..makeDeliverError("Error",$system.Status.GetErrorCodes(tSC),"Failed to Process Input message.: "_$system.Status.GetErrorText(tSC)) Quit tSC
	Set tWriter = ##class(%XML.Writer).%New()
	Set tWriter.Charset = "UTF-8"
	Set tWriter.NoXMLDeclaration = 1
	Set tWriter.DefaultNamespace="http://ns.electronichealth.net.au/smd/svc/SealedImmediateMessageDelivery/2010"
	Set tSC = tWriter.OutputToStream(pResponse.ContentStream)	Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	Set tSC = tWriter.RootObject(tEncryptedResponse, tEncryptedResponse.#XMLNAME)				Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	Do pResponse.ContentStream.Rewind()

	Quit tSC
}

/// Accept request and generate a receipt acknowledgment (later send processed acknowledgment)
/// Method Deliver(pRequest As HS.Message.XMLMessage, Output pResponse As HS.AU.Message.SMD.DeliverResponse) As %Status [ Final, ProcedureBlock = 1, SoapAction = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010/SealedMessageDelivery/deliverRequest", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
Method Deliver(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ Final, ProcedureBlock = 1, SoapAction = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010/SealedMessageDelivery/deliverRequest", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	Try	{
		Set tSC=$$$OK
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set tResponse=##class(HS.AU.Types.SMD.DeliveryResponse).%New()
		Set tSC = ..GetInboundMessage(pRequest,.tRequest,.tSOAPFault)
		If $$$ISERR(tSC) $$$HSTRACEERROR("Error getting inbound message","tSCText,tSOAPFault",$zcvt($system.Status.GetErrorText(tSC),"O","HTML"),tSOAPFault)
		#; if we have a soap fault this will end processing
		If tSOAPFault ]"" Set pResponse.SOAPFault=tSOAPFault Quit

		Set tRequest.Synchronous=0
		Set tSC = ..SendRequestSync(..SMDProcess,tRequest,.tMessageResponse)
		If $$$ISERR(tSC) {
			Set pResponse.SOAPFault=..makeDeliverError("Error",$system.Status.GetErrorCodes(tSC),"Failed to Process Input message.: "_$system.Status.GetErrorText(tSC))
			quit
		}
	} catch ex {
		set tSC=ex.AsStatus()
		Set pResponse.SOAPFault=..makeDeliverErrorFromStatus(tSC)
	}
	Quit:pResponse.SOAPFault]"" $$$OK
	do ..SetAddressingOut("http://ns.electronichealth.net.au/smd/svc/SealedImmediateMessageDelivery/2010/SealedImmediateMessageDelivery/deliverResponse")
	Set:$$$ISOK(tSC) tResponse.Status=tMessageResponse.Status
	$$$HSTRACEMIN("Response","Response",tResponse)
	Set tWriter = ##class(%XML.Writer).%New()
	Set tWriter.Charset = "UTF-8"
	Set tWriter.NoXMLDeclaration = 1
	Set tWriter.DefaultNamespace="http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010"
	Set tSC = tWriter.OutputToStream(pResponse.ContentStream) Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	Set tSC = tWriter.RootObject(tResponse, tResponse.#XMLNAME)	Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
	Do pResponse.ContentStream.Rewind()
	Quit tSC
}

/// Accept processed acknowledgement
Method TRDProcessing(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Try {
		set tSC=$$$OK,tSOAPFault="",tReturnValue="ok"
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set tRequest = ##class(HS.AU.Message.SMD.TransportDeliveryRequest).%New()
		
		Set tDocument=..ImportHandler
		Set tReader=##class(%XML.Reader).%New()
		Set tReader.Document=tDocument
		Do tReader.Correlate("response","HS.AU.Types.SMD.TransportResponseType")

		While tReader.Next(.response,.tSC) {
			If $$$ISERR(tSC) {
				Set tSOAPFault = ..makeDeliverErrorFromStatus(tSC)
				Quit
			}
			Do tRequest.Response.Insert(response)
		}
		If tRequest.Response.Count()=0 {
			set tSOAPFault=..makeStandardError("badMessage","No responses located")
			Quit
		}
		Set tSC = ..SendRequestSync(..SMDProcess, tRequest,.tResponse)
		Quit:$$$ISERR(tSC)
		If tResponse.Status'=$$$OK Set tSC = $$$ERROR($$$GeneralError,tResponse.Status)
	} Catch ex {
		// create a deliverError (unhandled error)
		set tSC=ex.AsStatus()
		set tSOAPFault=..makeDeliverError("Error",$system.Status.GetErrorCodes(tSC),"Unable to process received Transport Response records. "_$system.Status.GetErrorText(tSC))
	}
	If tSOAPFault="" && $$$ISERR(tSC) Set tSOAPFault = ..makeDeliverErrorFromStatus(tSC)
	Set pResponse.SOAPFault=tSOAPFault
	Quit:pResponse.SOAPFault]"" $$$OK
	Do pResponse.ContentStream.Write("<deliverResponse xmlns=""http://ns.electronichealth.net.au/smd/svc/TransportResponseDelivery/2010""><deliverResult>"_tReturnValue_"</deliverResult></deliverResponse>")
	$$$HSTRACEMIN("Response","Response",pResponse)
	Do pResponse.ContentStream.Rewind()

	Quit $$$OK
}

/// extract inbound delivery message (for immediate and asynchronous)
Method GetInboundMessage(pRequest As HS.Message.XMLMessage, Output pInboundMessage As HS.AU.Message.SMD.InboundMessageRequest, Output pSOAPFault)
{
	try {
		Set pSOAPFault=""
		Set pInboundMessage = ##class(HS.AU.Message.SMD.InboundMessageRequest).%New()
		Set tDocument=..ImportHandler
		Set tReader=##class(%XML.Reader).%New()
		Set tReader.Document=tDocument
		Do tReader.Correlate("keys","HS.AU.SMD.KeyListType")

		If 'tReader.Next(.keys,.sc) {
			set pSOAPFault=..makeStandardError("badEncryption","Target system failed to locate encrypted key.")
			quit
		}

		Set tReader=##class(%XML.Reader).%New()
		Set tReader.Document=tDocument
		Do tReader.Correlate("message","HS.AU.Types.SMD.SealedMessageType")
		If 'tReader.Next(.tMessage,.tSC) {
			set pSOAPFault=..makeStandardError("badEncryption","Target system failed to decrypt message.")
			quit
		} Else {
			Set pInboundMessage.Metadata=tMessage.Metadata
		}
		if '##class(%XML.Security.EncryptedData).ValidateDocument(.tDocument,keys.EncryptedKey) {
			set pSOAPFault=..makeStandardError("badEncryption","Target system failed to decrypt message.")
			quit
		}
		set tReader=##class(%XML.Reader).%New()
		set tReader.Document=tDocument
		do tReader.Correlate("signatures","HS.AU.SMD.SignatureListType")
		if 'tReader.Next(.tSignatures,.tSC) {
			; Failed to retrieve signedPayload signatures 
			if $$$ISOK(tSC) {
				set pSOAPFault=..makeStandardError("badlyFormedMsg","No signatures element found.")
				quit
			} else {
				set pSOAPFault=..makeStandardError("badlyFormedMsg","Failed to build Signatures object with error: ("_$system.Status.GetErrorText(tSC)_")")
				quit
			}
		}
		// Validate Signatures.  Only one is actually used in this Secure Messaging Standard.
		$$$THROWONERROR(tSC,..ValidateSignatures(tDocument,tSignatures,.pSOAPFault))

		Set pInboundMessage.DigestValue = tSignatures.Signature.GetAt(1).SignedInfo.Reference.GetAt(1).DigestValue
		Do tSignatures.XMLExportToString(.tSig)
		
		Set pInboundMessage.X509Credentials=tSignatures.Signature.GetAt(1).X509Credentials

		// Create seperate stream with <signedPayloadData> only
		$$$THROWONERROR(tSC,..GetSignedPayloadStream(tDocument,.tSignedPayloadStream))
		Set pInboundMessage.PayloadStream=tSignedPayloadStream
		
	} Catch ex {
		$$$LOGERROR(ex.DisplayString())
		Set tSC = ex.AsStatus()
		set pSOAPFault=..makeDeliverErrorFromStatus(tSC)
	}
	Quit tSC
}

/// For ImmediateDelivery take response and sign and encrypt
Method GenerateSynchronousResponse(pRequest As HS.AU.Message.SMD.InboundMessageRequest, pProcessorResponse As HS.AU.Message.SMD.MessageType, Output pResponse As HS.AU.Message.SMD.ImmediateDeliveryResponse) As %Status
{
	try {
		Set tSC=$$$OK
		Set pResponse = ##class(HS.AU.Types.SMD.ImmediateDeliveryResponse).%New()
		#; Get This configuration's X509 certificate for signing the Immediate response back.
		$$$THROWONERROR(tSC,..GetSigningX509(pRequest.Metadata.ReceiverOrganisation,.tX509SignWith))
		
		#; Get metadata object for This SOAP Response
		$$$THROWONERROR(tSC,..GetResponseMetadata(pRequest.Metadata,.tMetadataOut))
		
		#; Build the sealed message response from the Processor response message		
		set pResponse.Response=##class(HS.AU.Types.SMD.SealedMessageType).%New()
		
		#; Add the metadata
		set pResponse.Response.Metadata=tMetadataOut
		
		#; Sign and encrypt the message before sending			
		#; Get the response target's public key (from the incoming message)
		set tSC=..SignAndEncrypt(pProcessorResponse,tX509SignWith,pRequest.X509Credentials,.tEncryptedPayload)
		set pResponse.Response.EncryptedPayload=tEncryptedPayload
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Errors regarding the content of the message, or the format.  Message delivered, but failure to process.
Method makeStandardError(code = "", message = "", SOAPFaultCode As %String = "") As %SOAP.Fault12
{
	set se=##class(HS.AU.Types.SMD.StandardErrorType).%New()
	set se.ErrorCode=code
	set se.Message=message
	set SOAPFault=..BuildSoapFault(se,SOAPFaultCode)
	quit SOAPFault
}

/// Errors that occur as part of code or configuration - failure the deliver the message in the firstplace
Method makeDeliverError(responseClass = "Error", responseCode = "", message = "", SOAPFaultCode As %String = "") As %SOAP.Fault12
{
	set de=##class(HS.AU.Types.SMD.DeliverErrorType).%New()
	set de.DeliveryResponse.ResponseClass=responseClass
	set de.DeliveryResponse.ResponseCode=responseCode
	set de.DeliveryResponse.Message =message
	set SOAPFault=..BuildSoapFault(de,SOAPFaultCode)
	quit SOAPFault
}

/// Errors that occur as part of code or configuration - failure the deliver the message in the firstplace
Method makeDeliverErrorFromStatus(tSC As %Status, SOAPFaultCode As %String = "") As %SOAP.Fault12
{
	quit ..makeDeliverError("Error",$system.Status.GetErrorCodes(tSC),$system.Status.GetErrorText(tSC),SOAPFaultCode)
}

Method ValidateSignatures(document As %XML.Document, signatures As HS.AU.SMD.SignatureListType, Output SOAPFault) As %Status
{
	set tSC=$$$OK
	Try	{
		// Validate Signatures.  Only one is actually used in this Secure Messaging Standard.
		for i=1:1:signatures.Signature.Count() {
			#dim sig As %XML.Security.Signature = signatures.Signature.GetAt(i)
			set tSC=sig.ValidateDocument(document)
			if $$$ISERR(tSC) {
				set SOAPFault=..makeStandardError("badSignature","Bad Signature ("_i_"): "_$system.Status.GetErrorText(tSC))
				quit
			}
		}	
		
	} catch exc {
		set tSC=exc.AsStatus()
	}
	
	quit tSC
}

Method GetSignedPayloadStream(document As %XML.Document, Output pStream As %GlobalBinaryStream) As %Status
{
	Set tSC=$$$OK
	Try	{
		#dim node as %XML.Node=document.GetDocumentElement()
		kill pStream

		Set tReader = ##class(%XML.Reader).%New()
		Set tReader.Document=document
		Do tReader.Correlate("signedPayloadData","HS.AU.SMD.SignedPayloadContentStream")
		If tReader.Next(.payload,.sc)  {
			Set pStream = payload.Content
		}
	} catch ex {
		set tSC=ex.AsStatus()
	}
	quit tSC
}

/// This method is used to build a SOAPFault that will be delivered as a response.  
/// it must receive as the second argugment, either an object: StandardErrorType or a DeliverErrorType
Method BuildSoapFault(ErrorObjectType As %RegisteredObject, SOAPFaultCode As %String = "") As %SOAP.Fault12 [ Internal ]
{
	set:SOAPFaultCode="" SOAPFaultCode=$$$FAULTServer
	
	if ErrorObjectType.%IsA("HS.AU.Types.SMD.StandardErrorType") {
		set CodeValue=ErrorObjectType.ErrorCode
		set Text=ErrorObjectType.Message
	}  else {
		set CodeValue=ErrorObjectType.DeliveryResponse.ResponseCode
		set Text=ErrorObjectType.DeliveryResponse.Message	
	}

	// Add the Detail element	
	do ErrorObjectType.XMLExportToString(.xmlDetail)

	set SOAPFault=..MakeFault12(SOAPFaultCode,Text,xmlDetail)
	quit SOAPFault
}

/// This method returns an X509 Credentials object by looking at the HPIO configurations and
/// is used to sign the immediate responses
ClassMethod GetSigningX509(pHPIONumber As %String, x509Cert As %SYS.X509Credentials) As %Status
{
	set tSC=$$$OK
	Try {

		// Use default X509 Alias name stored against the configuration.
		set tConfig=##class(HS.AU.SMD.Configuration).HPIOIndexOpen(pHPIONumber)
		if '$IsObject(tConfig) {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Configuration settings for HPI-O number: '"_pHPIONumber_"' not found."))
		}
		set x509Cert=##Class(%SYS.X509Credentials).GetByAlias(tConfig.SigningX509Alias)
		if x509Cert="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Unable to get Default Certificiate for signing using alias: '"_tConfig.SigningX509Alias_"'"))
		}
	} catch ex {
		set tSC=ex.AsStatus()
	}	
	quit tSC
}

/// Used to generate the metadata for a synchronous response
Method GetResponseMetadata(pMetadataIn As HS.AU.Types.SMD.MessageMetadataType, ByRef pMetadataOut As HS.AU.Types.SMD.MessageMetadataType) As %Status
{
	set tSC=$$$OK
	try {
		
		#; Create reverse metadata values based off of the original incoming message 
		set pMetadataOut=##class(HS.AU.Types.SMD.MessageMetadataType).%New()
		set pMetadataOut.CreationTime=$zdt($h,3,1)
		set pMetadataOut.ExpiryTime=$System.SQL.DATEADD("mi",5,pMetadataIn.CreationTime) 
		set pMetadataOut.InvocationId=pMetadataIn.InvocationId
		set pMetadataOut.ReceiverIndividual=pMetadataIn.SenderIndividual
		set pMetadataOut.ReceiverOrganisation=pMetadataIn.SenderOrganisation 
		set pMetadataOut.SenderIndividual=pMetadataIn.ReceiverIndividual
		set pMetadataOut.SenderOrganisation=pMetadataIn.ReceiverOrganisation 
		set pMetadataOut.ServiceCategory=pMetadataIn.ServiceCategory 
		set pMetadataOut.ServiceInterface=pMetadataIn.ServiceInterface
	
	} catch exc {
		set tSC=exc.AsStatus()
	}	
	
	quit tSC
}

Method TransportResponseDelivery(pResponses As %ListOfObjects(ELEMENTTYPE="HS.AU.Types.SMD.TransportResponseType",XMLPROJECTION="element",XMLNAME="response")) As %String [ Final, ProcedureBlock = 1, SoapAction = "http://ns.electronichealth.net.au/smd/svc/TransportResponseDelivery/2010/TransportResponseDelivery/deliverRequest", SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	/// Stub method for the web service
}

}
