Include (HS.IHE.XDSb, HS.IHE.ATNA)

Class HS.HC.IHE.XDSb.Consumer.Operations Extends (HS.Util.SOAPClient.Operations, HS.Util.XSLTTransformer) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "XDSbRegistryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},XDSbRepositoryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},TransformToMetadata,TransformToMessage,MaximumDocumentsToProcess,BPPCEvaluator,TransformToMetadata,TransformRetrieveToMetadata,TransformToMessage,TransformResponseCleanup,TransformRetrieveToXDSb,TransformQueryToXDSb,TransformConsolidateRetrieve,TransformDocumentToSDA,TransformObjectToRetrieveDocumentSetRequest,TransformDocumentSetResponseToDocumentCache,TransformGetDocumentsRequest,TransformObjectToDocumentCache,TransformPatientFetchToFindDocumentsQuery,TransformFindDocumentResultToSDA,-TargetName,-SOAPVersion,-SSLConfiguration,-SOAPCredentials,-ServiceName";

/// Document Registry name in service registry
Property XDSbRegistryServiceName As %String(MAXLEN = 256);

/// Document Repository name in service registry
/// If this is set, all repository requests are routed to this repository (i.e. the HealthShare BUS)
/// Otherwise, the repository endpoint is determed from the repositoryUniqueId value in the message
Property XDSbRepositoryServiceName As %String(MAXLEN = 256);

Property TransformToMetadata As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Message-to-Metadata.xsl" ];

Property TransformRetrieveToMetadata As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RetrieveMessage-to-Metadata.xsl" ];

/// The transform that produces XDSb messages from metadata
Property TransformToMessage As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Metadata-to-Message.xsl" ];

Property TransformResponseCleanup As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/QueryResponseCleanup.xsl" ];

Property TransformRetrieveToXDSb As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RetrieveRequestToXDSbRetrieve.xsl" ];

Property TransformQueryToXDSb As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/QueryRequestToXDSbQuery.xsl" ];

Property TransformConsolidateRetrieve As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/ConsolidateRetrieveResponses.xsl" ];

Property TransformDocumentToSDA As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/GetDocumentAsSDA.xsl" ];

Property TransformObjectToRetrieveDocumentSetRequest As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/ExtrinsicObject-to-RetrieveDocumentSetRequest.xsl" ];

Property TransformDocumentSetResponseToDocumentCache As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RetrieveDocumentSetResponse-to-DocumentCache.xsl" ];

Property TransformGetDocumentsRequest As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/GetDocumentsRequest.xsl" ];

Property TransformObjectToDocumentCache As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/ExtrinsicObject-to-DocumentCache.xsl" ];

Property TransformPatientFetchToFindDocumentsQuery As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/PatientFetch-to-FindDocumentsQuery.xsl" ];

Property TransformFindDocumentResultToSDA As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/FindDocumentsResult-to-SDA.xsl" ];

Parameter TRANSFORMRETRIEVEWITHINLINETORETRIEVERESPONSE = "IHE/XDSb/Version1/RetrieveWithInlineToRetrieveResponse.xsl";

/// A store error will be thrown at some point, the content is available in the response, just not parsed.
Property MaximumDocumentsToProcess As %Integer [ InitialExpression = 100 ];

/// Business host for evaluating BPPC 
Property BPPCEvaluator As Ens.DataType.ConfigName;

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.IHE.XDSb.QueryRequest"> 
		<Method>XDSbQueryRequest</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.IHE.XDSb.RetrieveRequest"> 
		<Method>XDSbRetrieveRequest</Method>
	</MapItem>
</MapItems>
}

Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Try {
		If $$$HSTRACING Do ..TraceXMLMessage(##this,$$$CurrentClass,$$$CurrentMethod,pRequest.Name,"pRequest",pRequest)
		If (pRequest.Name = $$$XDSbQueryRequest) {
			Set tSC = ..DocumentQuery(pRequest, .pResponse) $$$ThrowOnError(tSC)
			//%HS_NotifyAndQueryOperations is only used for an internal message - don't audit
			Do:pRequest.SAMLData.HSRoles'="%HS_NotifyAndQueryOperations" $$$ATNAEvent("XDSbConsumer",pRequest,pResponse,tSC)
		}
		ElseIf (pRequest.Name = $$$XDSbRetrieveRequest) {
			Set tSC = ..DocumentRetrieve(pRequest, .pResponse) $$$ThrowOnError(tSC)
			//%HS_NotifyAndQueryOperations is only used for an internal message - don't audit
			Do:pRequest.SAMLData.HSRoles'="%HS_NotifyAndQueryOperations" $$$ATNAEvent("XDSbConsumer",pRequest,pResponse,tSC)
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
		If $$$HSTRACING Do:$IsObject($G(pResponse)) ..TraceXMLMessage(##this,$$$CurrentClass,$$$CurrentMethod,pResponse.Name,"pResponse",pResponse)
	}
	Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Dump XMLMessage attachments as character streams rather than binary
ClassMethod TraceXMLMessage(pHost As HS.HC.Util.Trace.Helper, pClass As %String, pMethod As %String, pCaption As %String, pVarName As %String, pMessage As HS.Message.XMLMessage)
{
	If pHost.TraceOperations'="" {
		Do pHost.HSTrace(pClass,pMethod,pCaption,pVarName,pMessage)
		If $IsObject($G(pMessage))  {
			Set i="" For { Set tItem=pMessage.StreamCollection.GetNext(.i) Quit:i=""
				Set tItem=pMessage.StreamCollection.GetAt(i)
				Set tCharStream=##class(%GlobalCharacterStream).%New() 
				Do tCharStream.CopyFrom(tItem.Body)
				Do tCharStream.Rewind()
				Do pHost.HSTrace(pClass,pMethod,pCaption_": Attachment "_i,"Attachment"_i,tCharStream)
				Do pMessage.StreamCollection.GetAt(i).Body.Rewind()
			}
		}
	}
}

Method XDSbRetrieveRequest(pRequest As HS.Message.IHE.XDSb.RetrieveRequest, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Try {
		#; split different repositories into different requests
		Set tRequests = ##class(%ListOfObjects).%New()
		If pRequest.Documents.Count()=1 {
			Do tRequests.Insert(pRequest)
		} Else {
			Set tLastRepo=""
			For tIdx=1:1:pRequest.Documents.Count() {
				Set tDocument = pRequest.Documents.GetAt(tIdx)
				Set tRepo=tDocument.RepositoryUniqueId
				#;***todo check to see if repo is null or not defined
				Set tRequestForRepo = $G(tRequests(tRepo))
				If '$IsObject(tRequestForRepo) {
					 Set tRequestForRepo=pRequest.%ConstructClone(1) do tRequestForRepo.Documents.Clear()
					 Set tRequests(tRepo)=tRequestForRepo
					 Do tRequests.Insert(tRequestForRepo)
				}
				Do tRequestForRepo.Documents.Insert(tDocument)
			}
		}
		$$$HSTRACE("Requests","tRequests,Count",tRequests,tRequests.Count())
		Set tResponseStream=##class(%Stream.GlobalCharacter).%New()
		Do tResponseStream.Write("<xdsb:XDSbRetrieveResponses xmlns:xdsb='urn:ihe:iti:xds-b:2007'>")
		Set tListDocuments = ##class(%ListOfObjects).%New()
		For tIdx = 1:1:tRequests.Count() {
			Set tRepositoryRequest=tRequests.GetAt(tIdx)
			Set tSC = tRepositoryRequest.XMLExportToStream(.tStream,"RetrieveRequest")
			// Transform internal XDSb Retrieve Request Message into XDSb Retrieve Request
			Set tSC=..Transform(tStream,..TransformRetrieveToXDSb /*"IHE/XDSb/Version1/RetrieveRequestToXDSbRetrieve.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
			Set tRequest = ##class(HS.Message.XMLMessage).%New()
			Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
			Do tRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
			Set tRequest.Name=$$$XDSbRetrieveRequest
			Do tRequest.ContentStream.CopyFrom(tMessage)
			Set tRequest.SAMLData=pRequest.SAMLData
			Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRequest)  ///SAML/User Auth
			Set tSC = ##class(HS.IHE.Util).MergeAdditionalInfo(pRequest, tRequest)
			Set tSC = ..OnMessage(tRequest,.tResponse) 
			If $$$ISERR(tSC) {
				Do tResponseStream.Write("<xdsb:RetrieveDocumentSetResponse><rs:RegistryResponse xmlns:rs='urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0' status='urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error'><rs:RegistryErrorList highestSeverity='urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error'><rs:RegistryError errorCode='XDSbRegistry' codeContext='"_$zcvt($system.Status.GetErrorText(tSC),"O","XML")_"' severity='urn:oasis:names:tc:ebxml-regrep:ErrorSeverityType:Error' code='$XDSbRepositoryError' location=''/></rs:RegistryErrorList></rs:RegistryResponse></xdsb:RetrieveDocumentSetResponse>")
				Continue
			}
			$$$HSTRACE("RetrieveRequest","tRequest,tResponse",tRequest,tResponse)
			do tResponse.ContentStream.Rewind()
			Do tResponseStream.CopyFrom(tResponse.ContentStream)
			For tIdx1=1:1:tResponse.StreamCollection.Count() {
				Do tListDocuments.Insert(tResponse.StreamCollection.GetAt(tIdx1))
			}
		}
		Do tResponseStream.Write("</xdsb:XDSbRetrieveResponses>")
		$$$HSTRACE("Response Stream","ResponseStream",tResponseStream)
		// Consolidate multiple Retrieve Responses into a single stream
		Set tSC=..Transform(tResponseStream,..TransformConsolidateRetrieve /*"IHE/XDSb/Version1/ConsolidateRetrieveResponses.xsl"*/,.tConsolidatedResponseStream) Quit:$$$ISERR(tSC)
		// Transform Consolidated Retrieve Response stream into Metadata in internal XDSb Retrieve Response Message
		Set tSC=..TransformIntoObject(tConsolidatedResponseStream, ..TransformRetrieveToMetadata /*"IHE/XDSb/Version1/RetrieveMessage-to-Metadata.xsl"*/, .pResponse,.tParams, "HS.Message.IHE.XDSb.RetrieveResponse","Metadata",1) Quit:$$$ISERR(tSC)
		For tIdx=1:1:tListDocuments.Count() {
			Do pResponse.StreamCollection.Insert(tListDocuments.GetAt(tIdx))
		}
		Do pResponse.ContentStream.CopyFrom(tConsolidatedResponseStream)
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

Method XDSbQueryRequest(pRequest As HS.Message.IHE.XDSb.QueryRequest, Output pResponse As HS.Message.IHE.XDSb.QueryResponse) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC = pRequest.XMLExportToStream(.tStream,"QueryRequest")
		Set tSC = pRequest.NewResponse(.pResponse)
		// Transform internal XDSb Query Request message to XDSb Query Request
		Set tSC=..Transform(tStream,..TransformQueryToXDSb /*"IHE/XDSb/Version1/QueryRequestToXDSbQuery.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		Do tRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		
		Set tMultiPatient=$Case(pRequest.QueryType,"FindDocumentsMultiPatients":1,"FindFoldersMultiPatients":1,:0)
		Set tRequest.Name=$$$XDSbQueryRequest
		Do tRequest.ContentStream.CopyFrom(tMessage)
		Set tRequest.SAMLData=pRequest.SAMLData
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRequest)  ///SAML/User Auth
		Set tSC = ##class(HS.IHE.Util).MergeAdditionalInfo(pRequest, tRequest)
		Set tSC = ..OnMessage(tRequest,.tResponse) Quit:$$$ISERR(tSC)
		$$$HSTRACE("query response","tResponse",tResponse)
		Set tParams("includeSlots")=1
		Set tSC = ##class(HS.IHE.Util).GetXPathExpression(tResponse.ContentStream,"/query:AdhocQueryResponse/rim:RegistryObjectList/rim:ExtrinsicObject","@id",.value,.tDocument)

		If value.Count()<..MaximumDocumentsToProcess {
			// Transform XDSb Query Response message to Metadata in internal XDSb Query Response Message
			Set tSC=..TransformIntoObject(tResponse.ContentStream, ..TransformToMetadata /*"IHE/XDSb/Version1/Message-to-Metadata.xsl"*/, .pResponse,.tParams, "HS.Message.IHE.XDSb.QueryResponse","Metadata",1)
			For tIdx=1:1:pRequest.Parameters.Count() {
				Set tItem = pRequest.Parameters.GetAt(tIdx)
				Set tName=tItem.ItemName
				If $e(tName,1,4)'="urn:" Continue
				Set tCustom($zcvt(tName,"U")_" ",tIdx)=tItem.Values  ;# conditions for slot
			}
			Set tItemsRemoved=0
			;# only check if the query contained custom requests #SlotName with Values
			If $D(tCustom) {
				$$$HSTRACE("Begin Custom Filters","pResponse",pResponse)
				For tIdx=pResponse.Documents.Count():-1:1 {
					Merge tFoundCustom=tCustom
					Set tDocument = pResponse.Documents.GetAt(tIdx)
					For tIdx3=1:1:tDocument.DocumentSlots.Count() {
						Set tSlot=tDocument.DocumentSlots.GetAt(tIdx3)
						Set tUName = $zcvt(tSlot.Name,"U")_" "
						Continue:'$D(tFoundCustom(tUName))
						Set tIdx2=""
						For  {
							Set tIdx2=$O(tFoundCustom(tUName,tIdx2)) Quit:tIdx2=""
							Set tValueList = tFoundCustom(tUName,tIdx2)
							For tIdx4=1:1:tSlot.ValueList.Count() {
								Set tValue=tSlot.ValueList.GetAt(tIdx4).Value
								If tValueList.Find(tValue) Kill tFoundCustom(tUName,tIdx2) Quit
							}
						}
						If $D(tFoundCustom(tUName)) {
							Set tValues="",i="" For { Set i=$o(tFoundCustom(tUName,i)) q:i=""  f j=1:1:tFoundCustom(tUName,i).Count() s tValues=tValues_","_tFoundCustom(tUName,i).GetAt(j) }
							$$$HSTRACE("Document removed","uuid,slot,value",tDocument.EntryUUID,tSlot.Name,tValues)
						}
					}
					If $D(tFoundCustom) {
						Do pResponse.Documents.RemoveAt(tIdx) Set tItemsRemoved=1  ;# did not match all critera - remove it
						For i=1:1:pResponse.ObjectRefs.Count() {
							$$$HSTRACE("ObjRefCheck","oref",pResponse.ObjectRefs.GetAt(i).EntryUUID)
							If pResponse.ObjectRefs.GetAt(i).EntryUUID=tDocument.EntryUUID {
								Do pResponse.ObjectRefs.RemoveAt(i)	
								Quit
							}	
						}
					}
				}			
			}
			If tItemsRemoved  {
				Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
				// since items were removed we need to cleanup the query response (removing any entries from the response)
				Set tSC=..TransformFromObject(pResponse, ..TransformResponseCleanup /*"IHE/XDSb/Version1/QueryResponseCleanup.xsl"*/, .tStream,"", "QueryResponse",1)
				Do pResponse.ContentStream.CopyFrom(tStream)
			} 
			Else { Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)}
		} else {
			Set pResponse=##class(HS.Message.IHE.XDSb.QueryResponse).%New()
			Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
			Do pResponse.Errors.logError("XDSbConsumer","Error","Unable to parse due to number of results")
		}
	} Catch ex {
		Set tSC=ex.AsStatus() 
		If $isObject($g(tResponse)) {
			Set pResponse=##class(HS.Message.IHE.XDSb.QueryResponse).%New()
			Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
			Do pResponse.Errors.logError("XDSbConsumer","Error",$system.Status.GetErrorText(tSC))
		}		
	}
	Quit tSC
}

Method DocumentQuery(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage, pIgnoreSecondaryMPI As %Boolean, pWebRequest As %SOAP.WebRequest = {##class(%SOAP.WebRequest).%New()}) As %Status
{
	Set tSC=$$$OK
	Try {
		Set ..ServiceName=..XDSbRegistryServiceName
		#; Determine the target. Usually this is inferred from the repositoryUniqueId
		#; but may be overriden by the host (i.e. routing all traffic through HSBUS)
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tServiceName="" tServiceName=..ServiceName
		
		$$$HSTRACE("Registry Target is: "_tServiceName)

		Do pRequest.ContentStream.Rewind()
		Do pRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name		= $$$XDSbQueryResponse
		Set pResponse.DocType	= "AdhocQueryResponse"
		If pRequest.AdditionalInfo.GetAt("MultiPatient") {
			Set tAction = $$$XDSbQueryMultiPatientAction(1)
		} Else {
			Set tAction = $$$XDSbQueryAction(1)
		}
		$$$HSTRACE("pRequest","pRequest,tAction",pRequest,tAction)

		Set tSC=..InvokeWebService(pWebRequest,, tAction, pRequest, .pResponse) Quit:$$$ISERR(tSC)
		
		Set tSC=##class(HS.IHE.XDSb.Util).ProcessResponse(pResponse) Quit:$$$ISERR(tSC)
		
		If ..BPPCEvaluator]"",pRequest.SAMLData.HSRoles'["%HS_NotifyAndQueryOperations" {
			Set tBPPCRequest = ##class(HS.Message.IHE.BPPC.EvaluationRequest).%New()
			Set tBPPCRequest.QueryRequest = pRequest
			Set tBPPCRequest.QueryResponse = pResponse
			Set tSC = ..SendRequestSync(..BPPCEvaluator,tBPPCRequest,.pResponse) $$$ThrowOnError(tSC)
		}
		
	}		
	Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

Method DocumentRetrieve(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest = {##Class(%SOAP.WebRequest).%New()}) As %Status
{
	Set tSC=$$$OK
	Try {
		#; Determine the target. Usually this is inferred from the repositoryUniqueId
		#; but may be overriden by the host (i.e. routing all traffic through HSBUS)
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tServiceName="" tServiceName=..XDSbRepositoryServiceName
		
		$$$HSTRACE("Service Name is (xdsbrepositoryservicename): "_tServiceName)
		Set:tServiceName="" tServiceName=..GetRepositoryTarget(pRequest,.tSC) Quit:$$$ISERR(tSC)
		$$$HSTRACE("service name is (calculated): "_tServiceName,"pRequest",pRequest)
		If tServiceName="" $$$ThrowStatus($$$ERROR($$$GeneralError,"Unable to determine document retrieve target"))
		$$$HSTRACE("Target is: "_tServiceName)

		Do pRequest.ContentStream.Rewind()
		Do pRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name		= $$$XDSbRetrieveResponse
		Set pResponse.DocType	= "RetrieveDocumentSetResponse"
		Set tAction = $$$XDSbRetrieveAction(1)
		Set tSC=..InvokeWebService(pWebRequest, , tAction, pRequest, .pResponse) Quit:$$$ISERR(tSC)
		Set tSC=##class(HS.IHE.XDSb.Util).ProcessResponse(pResponse) Quit:$$$ISERR(tSC)
		#; check to see if there are inline documents (versus mtom attachments) if so move them to be attachments
		Set tSC = ..MoveInline(pResponse) Quit:$$$ISERR(tSC)
	}
	Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// check to see if there are inline documents (versus mtom attachments) if so move them to be attachments
ClassMethod MoveInline(pResponse As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC=$$$OK
		Set tTransformStream=##class(%Stream.GlobalCharacter).%New()
		Do tTransformStream.Write("<root>")
		Set tInline=0
		Set tXPathNamespaces=##class(HS.IHE.Util).XPathNamespaces()
		Set tSC=##class(%XML.XPATH.Document).CreateFromStream(pResponse.ContentStream, .tResponseDocument,,,,,tXPathNamespaces) Quit:$$$ISERR(tSC)
		Set tSC=tResponseDocument.EvaluateExpression("/ihe:RetrieveDocumentSetResponse/ihe:DocumentResponse", "ihe:Document/text()", .tResults) Quit:$$$ISERR(tSC) 
		Set i="" For { Set tResult=tResults.GetNext(.i) Quit:i=""
			Set tSC=tResponseDocument.EvaluateExpression("/ihe:RetrieveDocumentSetResponse/ihe:DocumentResponse["_i_"]/ihe:Document/xop:Include", "@href", .tXOP) Quit:$$$ISERR(tSC) 
			If 'tXOP.Count() {
				Set tSC=tResponseDocument.EvaluateExpression("/ihe:RetrieveDocumentSetResponse/ihe:DocumentResponse["_i_"]/ihe:DocumentUniqueId", "text()", .tID) Quit:$$$ISERR(tSC) 
				Set tID=tID.GetAt(1).Value
				Do tTransformStream.Write("<document><xop:Include xmlns:xop=""http://www.w3.org/2004/08/xop/include"" href=""cid:"_tID_"""></xop:Include></document>")
				Set tAttach=##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
				If $IsObject(tResult.Value) {
					Set tInlineDocument = tResult.Value
					While 'tInlineDocument.AtEnd {
						Set tEncodedDocument = tInlineDocument.Read()
						Set tDecodedDocument = $System.Encryption.Base64Decode(tEncodedDocument)
						Do tAttach.Body.Write(tDecodedDocument) 
					}
				} Else {
					Do tAttach.Body.Write($system.Encryption.Base64Decode(tResult.Value))
				}
				Set tAttach.ContentId=tID
				Set tAttach.ContentTransferEncoding="binary"
				Set tAttach.ContentType="text/xml"
				Do pResponse.StreamCollection.InsertAt(tAttach,i)
				Set tInline=1
			} Else {
				Do tTransformStream.Write("<document/>")
			}
		}
		#; if no inline documents we're done, otherwise we need to move the inline to an attachment and build the correct references 
		Quit:'tInline 
		Do pResponse.ContentStream.Rewind()
		Do tTransformStream.Write("<original>")
		Set tSize=3000000
		For  Set tVal=pResponse.ContentStream.Read(.tSize) Quit:tSize<0  do tTransformStream.Write(tVal)
		Do tTransformStream.Write("</original>")
		Do tTransformStream.Write("</root>")
		Set transformer=##class(HS.Util.XSLTTransformer).%New()
		// Transform XDSb Retrieve Response with inline document into XDSb Retrieve Response using MIME Attachments
		Set tSC=transformer.Transform(tTransformStream,..#TRANSFORMRETRIEVEWITHINLINETORETRIEVERESPONSE /*"IHE/XDSb/Version1/RetrieveWithInlineToRetrieveResponse.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
		Do pResponse.ContentStream.CopyFrom(tMessage),pResponse.ContentStream.Rewind()
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method GetRepositoryTarget(pMessage As HS.Message.XMLMessage, Output pSC As %Status) As %String
{
	#;TODO: handle multple documents (and thus multiple repositories) -- is that the job of the repo?	
	#;TODO: handle both XDSb and XCA
	Set pSC=$$$OK,tTarget=""
	Try {

		#; Get repository OID from input request
		Set tXPathNamespaces=##class(HS.IHE.Util).XPathNamespaces()
		Set tSC=##class(%XML.XPATH.Document).CreateFromStream(pMessage.ContentStream, .tDocument, , , , , tXPathNamespaces) Quit:$$$ISERR(tSC)
		Set tStatus = tDocument.EvaluateExpression("/xdsb:RetrieveDocumentSetRequest/xdsb:DocumentRequest/xdsb:RepositoryUniqueId", "text()", .tRepositoryIDs) Throw:$$$ISERR(tStatus) ##class(%Exception.StatusException).CreateFromStatus(tStatus)
		If 'tRepositoryIDs.Count() $$$ThrowStatus($$$ERROR($$$GeneralError, "Unable to retrieve RepositoryUniqueId from RetrieveDocumentSet request"))
		Set tRepositoryID = tRepositoryIDs.GetAt(1).Value

		#; Get service object from repository OID
		Set tService = ##class(HS.Registry.Service.Abstract).EndPointForOID(tRepositoryID,"Repository","XDSb.Retrieve", "SOAP")
		If '$IsObject(tService) $$$ThrowStatus($$$ERROR($$$GeneralError, "Repository service not configured for OID '" _ tRepositoryID _ "'"))
		Set tTarget=tService.Name		

	} Catch ex { Set pSC=ex.AsStatus() }
	Quit tTarget
}

}
