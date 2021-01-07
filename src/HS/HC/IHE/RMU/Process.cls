Include (HS.HC, HS.IHE.XDSb, HS.IHE.ATNA)

/// IHE RMU Document Initiator Actor 
/// Take internal HS.Message.IHE.XDSb.UpdateDocumentSetRequest validate and format for Registry / Update Responder
/// Take external requests, validate, and route to registry or Update Responder
Class HS.HC.IHE.RMU.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper, HS.Util.BaseHost, HS.HC.IHE.RMU.Validate) [ ClassType = persistent, Inheritance = left ]
{

Property Errors As HS.Types.IHE.Errors;

Property Transformer As HS.Util.XSLTTransformer;

Property HomeCommunityOID As %String;

Parameter SETTINGS = "CustomProcessor:Basic,XDSbRegistryOperations,DocumentTransform,MetadataTransform,RegisterResponseTransform,InitiatorOperations";

/// InitiatorOperations is likely just an operation with class HS.Util.SOAPClient.Operations named HS.IHE.RMU.Initiator.Operations
Property InitiatorOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.RMU.Initiator.Operations" ];

Property XDSbRegistryOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

/// See %HSHOME%/csp/xslt/IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl for an example
Property DocumentTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl" ];

Property MetadataTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

Property RegisterResponseTransform As %String(MAXLEN = "") [ InitialExpression = "IHE/XDSb/Version1/RegisterResponse.xsl" ];

/// Receive to transform or transformed
/// route
Method OnRequest(pRequest As %Persistent, Output pResponse As %Persistent) As %Status
{
	Set tSC = $$$OK
	$$$OnPre(.tStop,.pRequest,.pResponse)
	If $G(tStop) || $$$ISERR(tSC) {
		Quit tSC
	}
	Try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		$$$GetTransformer(..Transformer)
		Set ..HomeCommunityOID = $$$HomeCommunityOID
		Set tRequest = pRequest
		Set tOutboundRequest = pRequest
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set tInternalRequest = 0
		If pRequest.%IsA("HS.Message.IHE.RMU.DocumentSetRequest") {
			Set pRequest.Name = $$$RMUDocumentSetRequest
			Set tInternalRequest = 1
			Set tSC = ..TransformUpdate(pRequest,.tHome,.tOut)
			If $$$ISERR(tSC) {
				Do ..Errors.logError("InternalError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
				Quit
			}
			Set tOutboundRequest = tOut
		} ElseIf 'pRequest.%IsA("HS.Message.XMLMessage") {
			Do ..Errors.logError("Error","Error","Unexpected message: "_pRequest.%ClassName(1))
			Quit
		}
		/// Convert XMLMessage to MetadataObject
		Set tSC = ..TransformToMetadaObject(tOutboundRequest,.tRequest)
		If $$$ISERR(tSC) {
			Do ..Errors.logError("InternalError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
			Quit
		}

		Set tSC = ..ValidateRMURequest(..Errors,tRequest,.tHome)
		IF $$$ISERR(tSC) {
			Do ..Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
			$$$HSTRACE("error"_$system.Status.GetErrorText(tSC))
			Quit
		}
		If tInternalRequest {
			//Updates for ATNA
			Do tOutboundRequest.AdditionalInfo.SetAt($$$RMUDocumentSetAction(1),"SOAPAction")
			Do tOutboundRequest.AdditionalInfo.SetAt("http://"_$$$HSNetworkHostName_"/Internal","WSA:From")
			If tHome {
				Do tOutboundRequest.AdditionalInfo.SetAt("http://"_$$$HSNetworkHostName_"/Internal","WSA:To")
			} Else {
				Set tTarget = "Unknown target"
				Set tService = ##class(HS.Registry.Service.SOAP).EndPointForNameType($G(tHome("ServiceName")),"SOAP")
				If $IsObject(tService) {
					Set tTarget = tService.EndPoint
				}
				Do tOutboundRequest.AdditionalInfo.SetAt(tTarget,"WSA:To")
			}
		}
		If 'tHome || ($G(tHome("HomeCommunityOID"))=$$$HomeCommunityOID) {
			Set tSC = ..SendRequestSync(..XDSbRegistryOperations,tOutboundRequest,.pResponse)
			Quit:$$$ISERR(tSC)
		} Else {
			If $G(tHome("ServiceName"))="" {
				Do ..Errors.logError("XDSUnknownCommunity","Error","Community unresolvable "_tRequest.Documents.GetAt(1).HomeCommunityId_" for document "_tRequest.Documents.GetAt(1).LogicalUUID) 
			} Else {
				$$$HSTRACE("Here","tOutboundRequest",tOutboundRequest)
				Do tOutboundRequest.AdditionalInfo.SetAt(tHome("ServiceName"),"ServiceName")
				Do tOutboundRequest.AdditionalInfo.SetAt($$$RMUDocumentSetAction(1),"SOAPAction")
				Set tSC = ..SendRequestSync(..InitiatorOperations,tOutboundRequest,.pResponse)
			}
		}
		If tInternalRequest {
			Set tSCATNA=$$$ATNAEvent("RMU",tOutboundRequest,pResponse,tSC)
			If $$$ISERR(tSCATNA) $$$LOGSTATUS(tSCATNA)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("Error","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
	}
	$$$OnPost(.pRequest,.pResponse)
	If ..Errors.Errors.Count() {
		Set tStream=##class(%Stream.GlobalCharacter).%New()
		Do ..Errors.XMLExportToString(.tErrors)
		Do tStream.Write("<Submission>"_tErrors_"</Submission>")
		Set tParam("status")=$S(..Errors.Errors.Count()=0:"Success",1:"Failure")
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tStream,..RegisterResponseTransform /*"IHE/XDSb/Version1/RegisterResponse.xsl"*/,.tResponseStream,.tParam)
		$$$HSTRACEENDCALL
		If $$$ISERR(tSC) {
			$$$LOGSTATUS(tSC)
		} Else {
			Do pResponse.ContentStream.CopyFrom(tResponseStream)
		}

	}
	$$$HSTRACE("Errors","Errors",..Errors)
	Quit tSC
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

/// Convert internal request to an External Request (preparing for XDSb.Registry or RMU Update Responder)
Method TransformUpdate(pRequest As HS.Message.IHE.XDSb.UpdateDocumentSetRequest, ByRef pHome, Output pNewRequest As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	$$$OnPre(.tStop,.pRequest,.pHome,.pNewRequest)
	If $G(tStop) || $$$ISERR(tSC) {
		Quit tSC
	}
	Try {
		Set tSC=pRequest.UpdateAssociations()
		If $$$ISERR(tSC) {
			Quit
		}
		Set tSC = pRequest.XMLExportToStream(.tStream,"UpdateDocumentSetRequest")
		#; convert message to RegisterRequest
		Set tSC=..Transformer.Transform(tStream, ..DocumentTransform /*"IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
		Set pNewRequest = ##class(HS.Message.XMLMessage).%New()
		Set pNewRequest.Name=$$$RMUDocumentSetRequest
		Do pNewRequest.ContentStream.CopyFrom(tMessage)
		Set pNewRequest.AdditionalInfo=pRequest.AdditionalInfo.%ConstructClone()
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, pNewRequest)  ///SAML/User Auth
		Set pNewRequest.SAMLData=pRequest.SAMLData.%ConstructClone()
		Do pNewRequest.AdditionalInfo.SetAt($$$RMUDocumentSetAction(1),"SOAPAction")
	} Catch ex { 
		Set tSC=ex.AsStatus() 
	}
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	$$$OnPost(.pRequest,.pHome,.pNewRequest)
	Quit tSC
}

Method TransformToMetadaObject(pRequest As HS.Message.XMLMessage, Output pMessage As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	$$$OnPre(.tStop,.pRequest,.pMessage)
	If $G(tStop) || $$$ISERR(tSC) {
		Quit tSC
	}
	Try {
		#; convert message to RegisterRequest
		Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream,..MetadataTransform /*"IHE/XDSb/Version1/Message-to-MetadataObject.xsl"*/,.pMessage,,"HS.Message.IHE.XDSb.Metadata","Metadata")
		If $$$ISERR(tSC) {
			Do ..Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
		}
	} Catch ex { 
		Set tSC=ex.AsStatus()
		Do ..Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
	}
	$$$OnPost(.pRequest,.pMessage)
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>Errors</Value>
</Value>
<Value name="2">
<Value>LocalRMUPolicy</Value>
</Value>
<Value name="3">
<Value>HomeCommunityOID</Value>
</Value>
<Value name="4">
<Value>InitiatorOperations</Value>
</Value>
<Value name="5">
<Value>XDSbRegistryOperations</Value>
</Value>
<Value name="6">
<Value>DocumentTransform</Value>
</Value>
<Value name="7">
<Value>MetadataTransform</Value>
</Value>
<Value name="8">
<Value>RegisterResponseTransform</Value>
</Value>
<Value name="9">
<Value>RMUPolicy</Value>
</Value>
<Value name="10">
<Value>TraceOperations</Value>
</Value>
<Value name="11">
<Value>Transformer</Value>
</Value>
<Value name="12">
<Value>CustomProcessor</Value>
</Value>
<Value name="13">
<Value>CustomProcessorIsValid</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
