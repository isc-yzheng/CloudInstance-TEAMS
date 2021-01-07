Include (HS.IHE.XCA, HS.IHE.ATNA, HS.IHE.XDSb)

Class HS.IHE.XCA.InitiatingGateway.Operations Extends (HS.Util.SOAPClient.Operations, HS.IHE.Common.Actor.Base, HS.Util.XSLTTransformer) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "-TargetName,-SOAPVersion,-SSLConfiguration,-SOAPCredentials, TransformToMetadata, TransformRetrieveToMetadata, TransformToMessage, TransformResponseCleanup, TransformQueryToXDSb, TransformRetrieveToXDSb, TransformConsolidateRetrieve";

Property TransformToMetadata As %String [ InitialExpression = "IHE/XDSb/Version1/Message-to-Metadata.xsl" ];

Property TransformRetrieveToMetadata As %String [ InitialExpression = "IHE/XDSb/Version1/RetrieveMessage-to-Metadata.xsl" ];

/// The transform that produces XDSb messages from metadata
Property TransformToMessage As %String [ InitialExpression = "IHE/XDSb/Version1/Metadata-to-Message.xsl" ];

Property TransformResponseCleanup As %String [ InitialExpression = "IHE/XDSb/Version1/QueryResponseCleanup.xsl" ];

Property TransformQueryToXDSb As %String [ InitialExpression = "IHE/XDSb/Version1/QueryRequestToXDSbQuery.xsl" ];

Property TransformRetrieveToXDSb As %String [ InitialExpression = "IHE/XDSb/Version1/RetrieveRequestToXDSbRetrieve.xsl" ];

Property TransformConsolidateRetrieve As %String [ InitialExpression = "IHE/XDSb/Version1/ConsolidateRetrieveResponses.xsl" ];

/// A store error will be thrown at some point, the content is available in the response, just not parsed.
Property MaximumDocumentsToProcess As %Integer [ InitialExpression = 100 ];

XData MessageMap
{
<MapItems>
<MapItem MessageType="HS.Message.IHE.XCA.QueryRequest"> 
<Method>QueryRequest</Method>
</MapItem>
<MapItem MessageType="HS.Message.IHE.XDSb.QueryRequest"> 
<Method>QueryRequest</Method>
</MapItem>
<MapItem MessageType="HS.Message.IHE.XCA.RetrieveRequest"> 
<Method>RetrieveRequest</Method>
</MapItem>
<MapItem MessageType="HS.Message.IHE.XDSb.RetrieveRequest"> 
<Method>RetrieveRequest</Method>
</MapItem>
</MapItems>
}

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()

		If (pRequest.Name = $$$XCAQueryRequest) {
			Set tAction					= $$$XCAQueryAction(1)
			Set pResponse.Name			= $$$XCAQueryResponse
			Set ..TargetName = pRequest.AdditionalInfo.GetAt("TargetName")
			$$$HSTRACE("XCA Request","pRequestName,pRequest,TargetName",pRequest.Name,pRequest.ContentStream,..TargetName)
			Set tSC	=..InvokeWebService(,,tAction, pRequest, .pResponse)
			$$$HSTRACE("Web Service Response","pResponse,tSC",pResponse.ContentStream,tSC)
			Do $$$ATNAEvent("XCAInitiatingGateway",pRequest,pResponse,tSC)
		}
		ElseIf (pRequest.Name = $$$XCARetrieveRequest) {
			Set tAction					= $$$XCARetrieveAction(1)
			Set pResponse.Name			= $$$XCARetrieveResponse
			Set tSOAPClient= ##class(%SOAP.WebRequest).%New()
			Set tSOAPClient.MTOMRequired=1
			Set ..TargetName = pRequest.AdditionalInfo.GetAt("TargetName")
			$$$HSTRACE("XCA Request","pRequestName,pRequest,TargetName",pRequest.Name,pRequest.ContentStream,..TargetName)
			Set tSC	=..InvokeWebService(tSOAPClient,, tAction, pRequest, .pResponse)
			Do $$$ATNAEvent("XCAInitiatingGateway",pRequest,pResponse,tSC)
		}
		ElseIf (pRequest.Name = $$$XDSbQueryRequest) {
			Set tAction					= $$$XDSbQueryAction(1)
			Set pResponse.Name			= $$$XDSbQueryResponse
			Set ..TargetName = pRequest.AdditionalInfo.GetAt("TargetName")
			Set tSC	=..InvokeWebService(,,tAction, pRequest, .pResponse)
			$$$HSTRACE("Web Service Response","pResponse,tSC",pResponse.ContentStream,tSC)
			Do $$$ATNAEvent("XCAInitiatingGateway",pRequest,pResponse,tSC)
		}
		ElseIf (pRequest.Name = $$$XDSbRetrieveRequest) {
			Set tAction					= $$$XDSbRetrieveAction(1)
			Set pResponse.Name			= $$$XDSbRetrieveResponse
			Set tSOAPClient= ##class(%SOAP.WebRequest).%New()
			Set tSOAPClient.MTOMRequired=1
			Set ..TargetName = pRequest.AdditionalInfo.GetAt("TargetName")
			Set tSC	=..InvokeWebService(tSOAPClient,, tAction, pRequest, .pResponse)
			$$$HSTRACE("Web Service Response","pResponse,tSC",pResponse.ContentStream,tSC)
			Do $$$ATNAEvent("XCAInitiatingGateway",pRequest,pResponse,tSC)
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) Quit
		}
	} Catch eOnMessage {
		Set tSC = eOnMessage.AsStatus()
	}
	Quit tSC
}

Method QueryRequest(pRequest As HS.Message.IHE.XCA.QueryRequest, Output pResponse As HS.Message.IHE.XCA.QueryResponse) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSC = pRequest.XMLExportToStream(.tStream,"QueryRequest")
		Set tSC = pRequest.NewResponse(.pResponse)
		Set tSC=..Transform(tStream, ..TransformQueryToXDSb /*"IHE/XDSb/Version1/QueryRequestToXDSbQuery.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
		Do:tServiceName]"" tRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
		
		Set tMultiPatient=$Case(pRequest.QueryType,"FindDocumentsMultiPatients":1,"FindFoldersMultiPatients":1,:0)
		Set tRequest.Name=$$$XCAQueryRequest
		Do tRequest.ContentStream.CopyFrom(tMessage)
		Set tRequest.SAMLData=pRequest.SAMLData
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRequest)  ///SAML/User Auth
		Set tSC = ##class(HS.IHE.Util).MergeAdditionalInfo(pRequest, tRequest)
		Set tSC = ..OnMessage(tRequest,.tResponse) Quit:$$$ISERR(tSC)
		$$$HSTRACE("query response","tResponse",tResponse)
		Set tParams("includeSlots")=1
		Set tSC = ##class(HS.IHE.Util).GetXPathExpression(tResponse.ContentStream,"/query:AdhocQueryResponse/rim:RegistryObjectList/rim:ExtrinsicObject","@id",.value,.tDocument)

		If value.Count()<..MaximumDocumentsToProcess {
			Set tSC=..TransformIntoObject(tResponse.ContentStream, ..TransformToMetadata /*"IHE/XDSb/Version1/Message-to-Metadata.xsl"*/, .pResponse,.tParams, "HS.Message.IHE.XCA.QueryResponse","Metadata",1)
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
				#; since items were removed we need to cleanup the query response (removing any entries from the response)
				Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
				Set tSC=..TransformFromObject(pResponse, ..TransformResponseCleanup /*"IHE/XDSb/Version1/QueryResponseCleanup.xsl"*/, .tStream,"", "QueryResponse",1)
				Do pResponse.ContentStream.CopyFrom(tStream)
			} 
			Else { Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)}
		} else {
			Set pResponse=##class(HS.Message.IHE.XCA.QueryResponse).%New()
			Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
			Do pResponse.Errors.logError("XDSbConsumer","Error","Unable to parse due to number of results")
		}
	} Catch ex {
		Set tSC=ex.AsStatus() 
		If $isObject($g(tResponse)) {
			Set pResponse=##class(HS.Message.IHE.XCA.QueryResponse).%New()
			Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
			Do pResponse.Errors.logError("XDSbConsumer","Error",$system.Status.GetErrorText(tSC))
		}		
	}
	Quit tSC
}

Method RetrieveRequest(pRequest As HS.Message.IHE.XCA.RetrieveRequest, Output pResponse As HS.Message.IHE.XCA.RetrieveResponse) As %Status
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
			Set tSC=..Transform(tStream, ..TransformRetrieveToXDSb /*"IHE/XDSb/Version1/RetrieveRequestToXDSbRetrieve.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
			Set tRequest = ##class(HS.Message.XMLMessage).%New()
			Set tServiceName=pRequest.AdditionalInfo.GetAt("ServiceName")
			If tServiceName=""&&(..ServiceName="") {
				Set tHomeOID = tRepositoryRequest.Documents.GetAt(1).HomeCommunityId
				If tHomeOID]"" {
					If $E(tHomeOID,1,8)="urn:oid:" {
						Set tHomeOID=$E(tHomeOID,9,*)
					}
					Set tSR = ##class(HS.Registry.Service.SOAP).EndPointForHomeCommunityOID(tHomeOID,"XCA.Retrieve","SOAP")
					If $isobject(tSR) {
						Set tServiceName=tSR.Name
					}
				}
			}
			$$$HSTRACE("Service Name","tServiceName",tServiceName)
			If tServiceName]"" {
				Do tRequest.AdditionalInfo.SetAt(tServiceName,"ServiceName")
			}
			Set tRequest.Name=$$$XCARetrieveRequest
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
		Set tSC=..Transform(tResponseStream,..TransformConsolidateRetrieve /*"IHE/XDSb/Version1/ConsolidateRetrieveResponses.xsl"*/,.tConsolidatedResponseStream) Quit:$$$ISERR(tSC)
		Set tSC=..TransformIntoObject(tConsolidatedResponseStream, ..TransformRetrieveToMetadata , .pResponse,.tParams, "HS.Message.IHE.XCA.RetrieveResponse","Metadata",1) Quit:$$$ISERR(tSC)
		For tIdx=1:1:tListDocuments.Count() {
			Do pResponse.StreamCollection.Insert(tListDocuments.GetAt(tIdx))
		}
		Do pResponse.ContentStream.CopyFrom(tConsolidatedResponseStream)
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

}
