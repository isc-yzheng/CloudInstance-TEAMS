Include HS.IHE.ATNA

/// IHE XDSb Document Source Actor 
/// Given a CDA stream extract relevant data and build ProvideAndRegister transaction
Class HS.IHE.XDSb.DocumentSource.Operations Extends (HS.IHE.XDSb.DocumentSource.Abstract, HS.Util.SOAPClient.Operations) [ Inheritance = right, ProcedureBlock ]
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "XDSbRepositoryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},XDSbRegistryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},PIXv3ConsumerOperations,MPIOperations,DocumentTransform,XDSbConsumerOperations,DocumentsInline,AddNewPatients";

/// The XDS.b Repository actor from the HealthShare Service Registry.
Property XDSbRepositoryServiceName As %String [ InitialExpression = "XDSb.Repository" ];

/// The XDS.b Registry actor from the HealthShare Service Registry.
Property XDSbRegistryServiceName As %String [ InitialExpression = "XDSb.Registry" ];

/// The PIXv3 Consumer operation - if the patientId is not defined in the request use the sourceId and query the pix manager
Property PIXv3ConsumerOperations As %String [ InitialExpression = "HS.IHE.PIXv3.Consumer.Operations" ];

/// The XDSb Consumer operation - if the document(s) is replacing an other document locate the existing document using a query with the ReplacementContext
Property XDSbConsumerOperations As %String [ InitialExpression = "HS.IHE.XDSb.Consumer.Operations" ];

/// See %HSHOME%/csp/xslt/IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl for an example
Property DocumentTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.IHE.XDSb.RegisterRequest"> 
		<Method>XDSbRegisterRequest</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.IHE.XDSb.ProvideAndRegisterRequest"> 
		<Method>XDSbProvideAndRegisterRequest</Method>
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
		#; when using custom soap headers we might need a different type of request
		Set tWebRequest = pRequest.AdditionalInfo.GetAt("WebRequest")
		Set:tWebRequest="" tWebRequest=##class(%SOAP.WebRequest).%New()
		Set tSC = ..AddDirectHeader(tWebRequest,pRequest) Quit:$$$ISERR(tSC)
		Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction")
		If tAction = $$$XDSbProvideAndRegisterAction(1) && '..DocumentsInline Set tWebRequest.MTOMRequired=1
		Set tSC = ..InvokeWebService(tWebRequest,, tAction, pRequest, .pResponse,+pRequest.AdditionalInfo.GetAt("OneWay")) $$$HSThrowErrors(tSC)
		If pRequest.AdditionalInfo.GetAt("SOAPAction") = $$$XDSbProvideAndRegisterAction(1) {
			Do $$$ATNAEvent("XDSbSource",pRequest,pResponse,tSC)
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// The provide request can set GenerateProvideAndRegisterOnly=1 which will make the response.contentstream have the value which would be sent to the repository
/// this enables using the P&R request for signatures.
Method XDSbProvideAndRegisterRequest(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, Output pResponse As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest = {##class(%SOAP.WebRequest).%New()}) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSOAPAction = $$$XDSbProvideAndRegisterAction(1),tOnDemand=0
		For tIdx=1:1:pRequest.Documents.Count() {
			If pRequest.Documents.GetAt(tIdx).ObjectType="OnDemand" {Set tOnDemand=1}
		}
		If tOnDemand Set tSC=$$$ERROR($$$GeneralError,"Use register requests for ondemand documents") Quit
		Set tOutboundRequest = ##class(HS.Message.XMLMessage).%New()
		Set tOutboundRequest.Name=$$$XDSbProvideAndRegisterRequest
		Set tOutboundRequest.AdditionalInfo=pRequest.AdditionalInfo.%ConstructClone()
		Set tOutboundRequest.SAMLData=pRequest.SAMLData.%ConstructClone()
		Do tOutboundRequest.AdditionalInfo.SetAt(pRequest.DirectFrom,"Direct:FROM")
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tOutboundRequest)  ///SAML/User Auth
		Set tDirectTo="" For tIdx=1:1:pRequest.DirectTo.Count() {Set tDirectTo=tDirectTo_";"_pRequest.DirectTo.GetAt(tIdx)} Set tDirectTo=$e(tDirectTo,2,*)
		Do tOutboundRequest.AdditionalInfo.SetAt(tDirectTo,"Direct:TO")
		Set tService = pRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tService="" tService=..XDSbRepositoryServiceName
		Do tOutboundRequest.AdditionalInfo.SetAt(tService,"ServiceName")
		Do tOutboundRequest.AdditionalInfo.SetAt(tSOAPAction,"SOAPAction")

		#; Fetch missing information from CDA (if required)
		Set tSC = ..BuildRequest(pRequest,tOutboundRequest,.tUpdatedRequest) Quit:$$$ISERR(tSC)

		$$$HSTRACE("Provide And Register Request","tOutboundRequest,pRequest.GenerateProvideAndRegisterOnly",tOutboundRequest,pRequest.GenerateProvideAndRegisterOnly)

		If 'pRequest.GenerateProvideAndRegisterOnly {
			Do tOutboundRequest.AdditionalInfo.SetAt(pWebRequest,"WebRequest")
			Set tSC = ..OnMessage(tOutboundRequest,.pResponse)
		} Else {
			Set pResponse=tOutboundRequest
		}
	} Catch ex { Set tSC=ex.AsStatus() }
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	Quit tSC
}

Method AddDirectHeader(pWebRequest, pRequest) As %Status
{
	Set tSC=$$$OK
	try {
		Set tFrom=pRequest.AdditionalInfo.GetAt("Direct:FROM")
		#; list needs to be converted to / from list to string to list for passing in the additional info
		Set tTo=pRequest.AdditionalInfo.GetAt("Direct:TO")
		If tFrom]"",tTo]"" {
			Set tHeader=##class(HS.IHE.XDSb.Types.AddressBlockHeader).%New()
			Set tHeader.from=tFrom
			For tIdx=1:1:$l(tTo,";") Do tHeader.to.Insert($p(tTo,";",tIdx))
			Set tHeader.role="urn:direct:addressing:destination"
			Do pWebRequest.HeadersOut.SetAt(tHeader,"addressBlock")
			Set tHeader=##class(HS.IHE.XDSb.Types.MetadataLevelHeader).%New()
			Set tHeader.Level="XDS"
			Do pWebRequest.HeadersOut.SetAt(tHeader,"metadata-level")
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Take the inbound request fetch any missing values and build outbound request
Method BuildRequest(pInboundRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, pOutboundRequest As HS.Message.XMLMessage, ByRef pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	try {
		Set tSC=$$$OK
		#; if the request is CDA we may need to extract values from the document and update the request
		#; for this reason tUpdatedRequest is used so that the original transaction is not updated
		Set tSC =..GetUpdatedProvideRequest(pInboundRequest,.pUpdatedRequest)
		$$$HSTRACE("patientid and tsc","patientid,tSC,",pInboundRequest.PatientId,tSC)
		Quit:$$$ISERR(tSC)
		#; Move attachments into outbound message 
		#;  need to do this before transforming this as we'll move documents around
		Set tSC = ..AttachDocuments(pUpdatedRequest,pOutboundRequest) Quit:$$$ISERR(tSC)

		/// 
		#; convert message to ProvideAndRegister
		Set:pUpdatedRequest.SourcePatientId="" pUpdatedRequest.SourcePatientId=pUpdatedRequest.PatientId
		If pUpdatedRequest.PatientId="" Set tSC=$$$ERROR($$$GeneralError,"Unknown patient ID") Quit
		Set tSC = pUpdatedRequest.XMLExportToStream(.tStream,"ProvideAndRegisterRequest")
		$$$HSTRACESTARTCALL
		Set tSC=..Transform(tStream, ..DocumentTransform /*"IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
		$$$HSTRACEENDCALL
		Do pOutboundRequest.ContentStream.CopyFrom(tMessage)
		Do tMessage.Rewind(),tStream.Rewind()
		$$$HSTRACE("OutboundRequest","pOutboundRequest,tMessage,tStream",pOutboundRequest,tMessage.Read(),tStream)
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method XDSbRegisterRequest(pRequest As HS.Message.IHE.XDSb.RegisterRequest, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tSOAPAction = $$$XDSbRegisterAction(1),tStable=0,tOnDemand=0
		For tIdx=1:1:pRequest.Documents.Count() {
			If pRequest.Documents.GetAt(tIdx).ObjectType="OnDemand" {
				Set tSOAPAction = $$$XDSbRegisterOnDemandAction(1),tOnDemand=1
			} Else {
				Set tStable=1
			}
		}
		If tStable && tOnDemand Set tSC=$$$ERROR($$$GeneralError,"Either submit stable or ondemand documents, but not both") Quit
		#; Even though there is no document GetUpdatedProvideRequest may fill in some blanks and handle replacement contexts		
		Set tSC =..GetUpdatedProvideRequest(pRequest,.tUpdatedRequest)
		$$$HSTRACE("patientid and tsc","patientid,tSC,",pRequest.PatientId,tSC)
		/// 
		#; convert message to RegisterRequest
		Set:tUpdatedRequest.SourcePatientId="" tUpdatedRequest.SourcePatientId=tUpdatedRequest.PatientId
		If tUpdatedRequest.PatientId="" Set tSC=$$$ERROR($$$GeneralError,"Unknown patient ID") Quit
		Set tSC = tUpdatedRequest.XMLExportToStream(.tStream)
		$$$HSTRACE("tUpdatedRequest","tUpdatedRequest,Stream",tUpdatedRequest,tStream)
		Set tSC=..Transform(tStream, ..DocumentTransform /*"IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl"*/,.tMessage) Quit:$$$ISERR(tSC)
		Set tRequest = ##class(HS.Message.XMLMessage).%New()
		Do ##class(HS.Types.RequestInfo).RequestInfoToXMLMessage(pRequest, tRequest)  ///SAML/User Auth
		Set tRequest.Name=$S(tOnDemand:$$$XDSbRegisterOnDemandRequest,1:$$$XDSbRegisterRequest)
		Do tRequest.ContentStream.CopyFrom(tMessage)
		Set tRequest.AdditionalInfo=pRequest.AdditionalInfo.%ConstructClone()
		Set tRequest.SAMLData=pRequest.SAMLData.%ConstructClone()
		Do tRequest.AdditionalInfo.SetAt(pRequest.DirectFrom,"Direct:FROM")
		Set tDirectTo="" For tIdx=1:1:pRequest.DirectTo.Count() {Set tDirectTo=tDirectTo_";"_pRequest.DirectTo.GetAt(tIdx)} Set tDirectTo=$e(tDirectTo,2,*)
		Do tRequest.AdditionalInfo.SetAt(tDirectTo,"Direct:TO")
		Set tService = pRequest.AdditionalInfo.GetAt("ServiceName")
		Set:tService="" tService=..XDSbRegistryServiceName
		Do tRequest.AdditionalInfo.SetAt(tService,"ServiceName")
		Do tRequest.AdditionalInfo.SetAt(tSOAPAction,"SOAPAction")
		$$$HSTRACE("Register Request","tRequest",tRequest)
		Set tSC = ..OnMessage(tRequest,.pResponse)
	} Catch ex { Set tSC=ex.AsStatus() }
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	Quit tSC
}

Method AddDemographics(pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, pAddRequest As HS.Message.AddUpdateHubRequest, pDocument As HS.Message.IHE.XDSb.Document, pDocObject As %XML.XPATH.Document) As %Status
{
	try {
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given","text()",.tValue,.pDocObject)
		Set pAddRequest.FirstName=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:family","text()",.tValue,.pDocObject)
		Set pAddRequest.LastName=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:middle","text()",.tValue,.pDocObject)
		Set pAddRequest.MiddleName=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode","@code",.tValue,.pDocObject)
		Set pAddRequest.Sex="M"
		#; BirthDate
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime","@value",.tValue,.pDocObject)
		Set pAddRequest.DOB=$zdh($e(tValue,1,8),8,,,,,,,"")
		Set pAddRequest.Facility=pAddRequest.AssigningAuthority
		Set tAddr=##class(HS.Types.Address).%New()
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:streetAddressLine","text()",.tValue,.pDocObject)
		Set tAddr.StreetLine=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:city","text()",.tValue,.pDocObject)
		Set tAddr.City=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:state","text()",.tValue,.pDocObject)
		Set tAddr.State=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:postalCode","text()",.tValue,.pDocObject)
		Set tAddr.PostalCode=tValue
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]","@use",.tValue,.pDocObject)
		Set tAddr.Use=$Case(tValue,"":"HP","H":"HP","W":"WP",:tValue)
		Do pAddRequest.Addresses.Insert(tAddr)
		Set tSC= ..SendRequestSync("HS.IHE.PIXv3.Source.Operations",pAddRequest,.pAddResponse)
		Set tSC = ..FindPatientID(pAddRequest.MRN,pAddRequest.AssigningAuthority,.tSearchResponse)
		Set pUpdatedRequest.PatientId=tSearchResponse.Results.GetAt(1).MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method GetReplacementId(pDocument As HS.Message.IHE.XDSb.Document, pPatientId) As %Status
{
	try {
		Set tSC=$$$OK
		$$$HSTRACE("in GetReplacementId")
		Set tReplacementQuery=##class(HS.Message.IHE.XDSb.QueryRequest).%New(),tHavePatientID=0,tHaveStatus=0
		Set tReplacementQuery.ReturnType="LC"  //needs to be LC so consumer can filter on custom slots
		If pDocument.ReplacementContext.Count()=1,pDocument.ReplacementContext.GetAt(1).ItemName="$XDSDocumentEntryUniqueId" {
			Set tReplacementQuery.QueryType="GetDocuments"
			Do tReplacementQuery.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(pDocument.ReplacementContext.GetAt(1).Values.GetAt(1),"$XDSDocumentEntryUniqueId"))
		} else {
			For tIdx=1:1:pDocument.ReplacementContext.Count() {
				Set tItem = pDocument.ReplacementContext.GetAt(tIdx)
				Do tReplacementQuery.Parameters.Insert(tItem)
				If tItem.ItemName="$XDSDocumentEntryPatientId" Set tHavePatientID=1
				If tItem.ItemName="$XDSDocumentEntryStatus" Set tHaveStatus=1
			}
			If 'tHaveStatus Do tReplacementQuery.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).StatusValues("Approved"))
			If 'tHavePatientID Do tReplacementQuery.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).PatientId(pPatientId))
		}

		Set tSC = ..SendRequestSync(..XDSbConsumerOperations,tReplacementQuery,.tReplacementResponse)
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
		Set tCount=tReplacementResponse.Documents.Count()
		If tCount>1 $$$LOGWARNING("Registry returned more than one document with the same context, unable to issue replacement using document "_pDocument.EntryUUID) Quit
		Set:tCount pDocument.ReplaceSource=$p(tReplacementResponse.Documents.GetAt(1).EntryUUID,"urn:uuid:",2)
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
/// 	$XDSDocumentEntryEntryUUID
///		$XDSDocumentEntryUniqueId
///		$XDSDocumentEntryPracticeSettingCode
///		$XDSDocumentEntryClassificationNode
///		$XDSDocumentEntryClassCode
///		$XDSDocumentEntryConfidentialityCode
///		$XDSDocumentEntryEventCodeList
///		$XDSDocumentEntryFormatCode
///		$XDSDocumentEntryHealthcareFacilityTypeCode
///		$XDSDocumentEntryTypeCode
///		$XDSDocumentEntryType
///		$XDSDocumentEntryPatientId
///		$XDSDocumentEntryAuthorPerson
///		$XDSDocumentEntryServiceStartTimeFrom
///		$XDSDocumentEntryServiceStartTimeTo
///		$XDSDocumentEntryServiceStopTimeFrom
///		$XDSDocumentEntryServiceStopTimeTo
///		$XDSDocumentEntryStatus (will default to Approved)
}

}
