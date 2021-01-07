/// IHE XDSb Document Administrator Actor 
/// Used for metadata update and RMD transactions
/// RMD is limited to usage with the ISC XDSb Registry, as it's using the registry to determine what to delete and not calculating itself
Class HS.IHE.XDSb.Administrator.Operations Extends (HS.IHE.XDSb.DocumentSource.Abstract, HS.Util.SOAPClient.Operations, HS.Util.BaseHost) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "XDSbRegistryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},XDSbConsumerOperations,-SOAPVersion,-SSLConfiguration,-SOAPCredentials,-SendSAMLAssertion,-SAMLCreator,-ServiceName,RegistryResponseTransform:Transforms,MetadataTransform:Transforms";

/// The XDS.b Registry actor from the HealthShare Service Registry.
Property XDSbRegistryServiceName As %String [ InitialExpression = "XDSb.Registry" ];

/// The XDSb Consumer operation - used for sending query requests (as HealthShare messages versus having the administrator create them
Property XDSbConsumerOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Consumer.Operations" ];

Property XDSbRegistryTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

Property Transformer As HS.Util.XSLTTransformer;

/// See %HSHOME%/csp/xslt/IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl for an example
Property DocumentTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl" ];

/// Transform to produce response
Property RegistryResponseTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/RegisterResponse.xsl" ];

/// Transform to determine errors from repository
Property MetadataTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.IHE.XDSb.DeleteDocumentSetRequest"> 
		<Method>XDSbDeleteDocumentSetRequest</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.IHE.XDSb.UpdateDocumentSetRequest"> 
		<Method>UpdateDocumentSetRequest</Method>
	</MapItem>
</MapItems>
}

/// If doing any security related signing the request comes and generated (with a security document 
/// as a placeholder), the caller then adds the security document and calls the source again, 
/// this time it will be audited and sent to the repository
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction")
		Set tSC = ..InvokeWebService(,, tAction, pRequest, .pResponse) $$$HSThrowErrors(tSC)
		Set tSC = $$$ATNAEvent("Administrator",pRequest,pResponse,tSC)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// RMD ITI-62 and ITI-86
/// Accept pRequest as HS.Message.IHE.XDSb.DeleteDocumentSetRequest which will contain a list of ObjectRefs and/or an array of UniqueIdentifiers
/// 	where the UniqueIdentifiers node is the document id (an array so that the administrator inserts the repository id as the value when sending to the repository)
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Overriding the document delete for a particular document can be done by defining the OnPreXDSbDeleteDocumentSetRequest method
///  <Method>ClassMethod OnPreXDSbDeleteDocumentSetRequest(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDSb.DeleteDocumentSetRequest,Output pResponse As HS.Message.IHE.XDSb.DeleteDocumentSetResponse) as %Status</Method>
/// 	<li>if pStopProcessing is true processing this document (returned from the method). </li>
/// 	<li>Updates can be done to the pDocument object prior to any additional processing</li>
///  <Method>ClassMethod OnPostXDSbDeleteDocumentSetRequest(pHost As Ens.Host, pRequest As HS.Message.IHE.XDSb.DeleteDocumentSetRequest,Output pResponse As HS.Message.IHE.XDSb.DeleteDocumentSetResponse) as %Status</Method>
Method XDSbDeleteDocumentSetRequest(pRequest As HS.Message.IHE.XDSb.DeleteDocumentSetRequest, Output pResponse As HS.Message.IHE.XDSb.DeleteDocumentSetResponse) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		$$$OnPre(.tStop,pRequest,.pResponse) 
		If $G(tStop,0) || $$$ISERR(tSC) {
			If $$$ISERR(tSC) {
				Set tErrorMsg = $system.Status.GetErrorText(tSC)
			} Else {
				Set tErrorMsg = "Local policy prevents document delete"
			}
			Do pResponse.Errors.logError("XDSRemoveDocumentsError","Error",tErrorMsg)
			Set tSC = $$$OK
			Quit
		}		
		Set tSC = ..SendRequestSync(..XDSbRegistryTarget,pRequest,.tResponse)
		If $$$ISERR(tSC) {
			Do pResponse.Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
			If $ISObject($g(tResponse)) Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
			Set tSC = $$$OK
		} Else {
			/// Copy any errors from the registry if there are any
			///
			For tIdx = 1:1:tResponse.Errors.Errors.Count() {
				Set tError = tResponse.Errors.Errors.GetAt(tIdx)
				Do pResponse.Errors.Errors.Insert(tError)
				Do pResponse.Errors.setHighest(tError)
			}
			If $ISObject($g(tResponse)) Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
		}

		/// if the registry had an error nothing was processed
		If pResponse.Errors.HighestError="Error" {
			Set tReturnStatus = "Failure"
		} Else {
			/// it could be there are still references to the document, the response will have a list of documents $document_{docuniqueid} that should be removed
			Set tDocument = "$documents"
			Set tKey = ""
			Set tCount = 0
			For  {
				Set tRepoID = tResponse.AdditionalInfo.GetNext(.tKey) 
				Quit:$E(tKey,1,11)'="$documents_"
				Set tCount = tCount+1
				Set tMessage = $G(tAry(tRepoID))
				If '$IsObject(tMessage) {
					Set tMessage = ##class(HS.Message.XMLMessage).%New()
					Set tMessage.Name = $$$RMDRequest
					Set tStream = tMessage.ContentStream
					Do tStream.WriteLine("<rmd:RemoveDocumentsRequest xmlns:rmd='urn:ihe:iti:rmd:2017' xmlns:xds='urn:ihe:iti:xds-b:2007'>")
					Set tAry(tRepoID)=tMessage
					Set tEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForOID(tRepoID,"Repository","RMD")
					Set tAry(tRepoID,"EP")=$S($IsObject(tEndPoint):tEndPoint.Name,1:"")
				}
				Set tStream = tMessage.ContentStream
				Do tStream.WriteLine("<xds:DocumentRequest><xds:RepositoryUniqueId>"_tRepoID_"</xds:RepositoryUniqueId><xds:DocumentUniqueId>"_$P(tKey,"$documents_",2)_"</xds:DocumentUniqueId></xds:DocumentRequest> ")
			}
			If 'tCount {
				Quit  /// no repository documents to delete
			}
			/// Finish and send message(s) for repository(ies)
			Set tRepoID = ""
			For  {
				Set tRepoID=$Order(tAry(tRepoID),1,tMessage) Quit:tRepoID=""
				Do tMessage.ContentStream.WriteLine("</rmd:RemoveDocumentsRequest>")	
				Do tMessage.AdditionalInfo.SetAt(tAry(tRepoID,"EP"),"ServiceName")
				Do tMessage.AdditionalInfo.SetAt($$$RMDAction(1),"SOAPAction")
				$$$HSTRACE("del message","tMessage",tMessage)
				Set tSC = ..OnMessage(tMessage,.tResponse)
				If $$$ISERR(tSC) {
					Do pResponse.Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
					Set tSC = $$$OK
				} Else {
					Set tSC = ..Transformer.TransformIntoObject(tResponse.ContentStream,..MetadataTransform /*"IHE/XDSb/Version1/Message-to-MetadataObject.xsl"*/,.tResponseObject,,"HS.Message.IHE.XDSb.Metadata","Metadata")
					If $$$ISOK(tSC) {
						For tIdx = 1:1:tResponseObject.Errors.Errors.Count() {
							Set tError = tResponseObject.Errors.Errors.GetAt(tIdx)
							Do pResponse.Errors.Errors.Insert(tError)
							Do pResponse.Errors.setHighest(tError)
						}
						Set tStatus = $P(tResponseObject.Status,"ResponseStatusType:",2)
						Set tReturnStatus(tStatus)=1
					} Else {
						Do pResponse.Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
						$$$LOGERROR(tSC)  // failure transforming, this shouldn't happen
						Set tSC = $$$OK  /// let continue
					}
				}
			}
			If pResponse.Errors.HighestError="Error" {
				Set tReturnStatus("Failure")=1
			}
		}
	} Catch ex { 
		Set tSC=ex.AsStatus() 
		Do pResponse.Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
	}
	Set tParam("status")=$S($D(tReturnStatus)#10:tReturnStatus,'$D(tReturnStatus("Success"))&&'$D(tReturnStatus("Failure")):"Success",$D(tReturnStatus("Success"))&&$D(tReturnStatus("Failure")):"PartialSuccess",$D(tReturnStatus("Success")):"Success",1:"Failure")
	Set pResponse.Status = "urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:"_tParam("status")
	Do pResponse.XMLExportToStream(.tErrors)
	Quit ..Transform(tErrors, ..RegistryResponseTransform /*"IHE/XDSb/Version1/RegisterResponse.xsl"*/,pResponse.ContentStream,.tParam)
}

Method UpdateDocumentSetRequest(pRequest As HS.Message.IHE.XDSb.UpdateDocumentSetRequest, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSOAPAction = $$$XDSbUpdateDocumentSetAction(1)
		For tIdx=1:1:pRequest.Documents.Count() {
			Set tDocument=pRequest.Documents.GetAt(tIdx)
			If tDocument.EntryUUID=tDocument.LogicalUUID {
				Set tSC = $$$ERROR($$$GeneralError,"Not a metadata update request, EntryUUID and LogicalUUID match") Quit
			}
			If tDocument.LogicalUUID="" {
				Set tSC = $$$ERROR($$$GeneralError,"Not a metadata update request, LogicalUUID is not defined") Quit
			}
		}
		Set tSC=..UpdateAssociations(pRequest)
		$$$HSTRACE("updated associations","tSC,pRequest",tSC,pRequest)
		
		Set:pRequest.SourcePatientId="" pRequest.SourcePatientId=pRequest.PatientId
		If pRequest.PatientId="" Set tSC=$$$ERROR($$$GeneralError,"Unknown patient ID") Quit
		Set tSC = pRequest.XMLExportToStream(.tStream)
		$$$HSTRACE("updated request","tStream",tStream)
		#; convert message to RegisterRequest
		Set tSC=..Transform(tStream, ..DocumentTransform /*"IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set tRequest.Name=$$$XDSbUpdateDocumentSetRequest
		Do tRequest.ContentStream.CopyFrom(tMessage)
		Set tRequest.AdditionalInfo=pRequest.AdditionalInfo.%ConstructClone()
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRequest)  ///SAML/User Auth
		Set tRequest.SAMLData=pRequest.SAMLData.%ConstructClone()
		Set tService = pRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tService="" tService=..XDSbRegistryServiceName
		Do tRequest.AdditionalInfo.SetAt(tService,"ServiceName")
		Do tRequest.AdditionalInfo.SetAt(tSOAPAction,"SOAPAction")
		$$$HSTRACE("Update Document Set Request","tRequest",tRequest)
		Set tSC = ..OnMessage(tRequest,.pResponse)


	} Catch ex { Set tSC=ex.AsStatus() }
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	Quit tSC
}

Method OnInit() As %Status
{
	#dim tSC As %Status
	#dim eException as %Exception.AbstractException

	Set tSC=$$$OK
	try {
		If (..Transformer="") {
			Set ..Transformer = ##class(HS.Util.XSLTTransformer).%New()
		}
		$$$ThrowOnError(..ValidateCustomProcessor())
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

}
