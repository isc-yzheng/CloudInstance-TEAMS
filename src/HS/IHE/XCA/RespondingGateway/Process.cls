Include (HS.HC, HS.IHE.XCA, HS.IHE.XDSb, HS.IHE.ATNA)

Class HS.IHE.XCA.RespondingGateway.Process Extends HS.IHE.XCA.Common [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter DOMAIN = "HS";

Parameter SETTINGS = "XDSbRegistryOperations,XCARespondingGatewayOperations,XDSbRepositoryProcess,UseIDCache,RegistryStoredQueryResponseTransform,AddHomeCommunityTransform,XCARequestTransform,XCAConsolidateResponseTransform";

Property XDSbRegistryOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Registry.Operations" ];

Property XCARespondingGatewayOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCA.RespondingGateway.Operations" ];

Property XDSbRepositoryProcess As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDSb.Repository.Process" ];

/// UseIDCache enables this business process to utilize the XCPD patient id cache that was created by the XCPD Responding Gateway business process.
Property UseIDCache As %Boolean [ InitialExpression = 0 ];

Property RegistryStoredQueryResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RegistryStoredQueryResponse.xsl" ];

Property AddHomeCommunityTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCA/Version1/AddHomeCommunityIDToQueryDocumentsResponse.xsl" ];

Property XCARequestTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCA/Version1/RequestsObjectToRequest.xsl" ];

Property XCAConsolidateResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCA/Version1/ConsolidateRetrieveResponses.xsl" ];

Method OnRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set:..HomeCommunity="" ..HomeCommunity=$$$HomeCommunity
		Set ..HomeCommunityOID = $$$HomeCommunityOIDGet(..HomeCommunity)
		$$$GetTransformer(..Transformer)

		Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction"),tIsAsync=0
		Set tReplyTo = pRequest.AdditionalInfo.GetAt("ReplyAddress")

		if tReplyTo]"" && (tReplyTo'["anonymous") {
			$$$HSTRACE("reply to","tReplyTo",tReplyTo)
			set tAck=##class(HS.Message.XMLMessage).%New()
			Do ..Reply(tAck.ContentStream)
			Set tIsAsync=1
		}

		Set pResponse=##class(HS.Message.XMLMessage).%New()
		If pRequest.Name = $$$XCAQueryRequest {
			Set tSC=..QueryRequest(pRequest,.pResponse)
			Do $$$ATNAEvent("XCARespondingGateway",pRequest,pResponse,tSC)
		} ElseIf pRequest.Name = $$$XCARetrieveRequest {
			Set tSC=..RetrieveRequest(pRequest,.pResponse)
			Do $$$ATNAEvent("XCARespondingGateway",pRequest,pResponse,tSC)
			Set pResponse.Name=$$$XCARetrieveResponse
		} Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Unhandled request type"))
		}


		If tIsAsync {
			Set tRequest = pResponse
			Do tRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("RelatesTo"),"RelatesTo")
			Do tRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("ReplyAddress"),"ReplyAddress")
			Set tAction = $Case(pRequest.Name, $$$XCAQueryResponse:$$$XCAQueryResponseAction(..IHEVersion), $$$XCARetrieveResponse:$$$XCARetrieveResponseAction(..IHEVersion),:"")
			Do tRequest.AdditionalInfo.SetAt(tAction,"SOAPAction")
			Set tSC = ..SendRequestSync(..XCARespondingGatewayOperations,tRequest,.pResponse)
		}					
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCA Error","Error",$system.Status.GetErrorText(tSC))
	}
	If ..Errors.Errors.Count() {
		$$$HSTRACE("Errors","Errors",..Errors)
		Set tErrorText="",tWarningText=""
		For tIdx=1:1:..Errors.Errors.Count() {
			Set tError = ..Errors.Errors.GetAt(tIdx)
			If tError.Severity="Error" {
				Set tErrorText = tErrorText _ "["_tError.Description_ "]"
			} Else {
				Set tWarningText = tWarningText _ "["_tError.Description_ "]"
			}
		}
		If tErrorText]"" $$$LOGERROR(tErrorText)
		If tWarningText]"" $$$LOGWARNING(tWarningText)
	}
	Quit tSC
}

Method QueryRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		If ..XDSbRegistryOperations="" {
			/// When RegistryOperations is "" we are routing the transaction based on the AssigningAuthority of the patient ID
			Set tSC=..QueryRequestBigBus(pRequest,.pResponse)
			Quit
		}

		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery","@home",.tHomeCommunity,.tDocObject)
		If $$$ISERR(tSC) {
			Do ..Errors.logError("Error","Error","Unable to parse home community")
		} Else {
			If ($p(tHomeCommunity,"urn:oid:",2)'=..HomeCommunityOID) {
				If $p(tHomeCommunity,"urn:oid:",2)="" {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot","@name",.tSlotName,.tDocObject)
					If tSlotName="$XDSDocumentEntryUniqueId" Do ..Errors.logError("XDSMissingHomeCommunityId","Error","HomeCommunity is missing","/query:AdhocQueryRequest/rim:AdhocQuery/@home")
				} Else {
					Do ..Errors.logError("XDSUnknownCommunity","Error",tHomeCommunity_" is not known","/query:AdhocQueryRequest/rim:AdhocQuery/@home")
				}
			}
		}
		If ..Errors.Errors.Count() {
			Do ..BuildErrorResponse(..Errors,.pResponse)
			Set tSC = $$$OK
			Quit
		}

		#; AdditionalInfo sendingCommunityId was extracted from the URL that
		#; came to XCA Responding Gateway Services.  If sendingCommunityId
		#; has a value then the Id cache will be checked for this XCA query.
		Set tSendingCommunityId = pRequest.AdditionalInfo.GetAt("sendingCommunityId")
		If (..UseIDCache=1)&&(tSendingCommunityId'="") {
			Set tPatientIdOK = 1
			For i = "$XDSDocumentEntryPatientId", "$XDSSubmissionSetPatientId" {
				#; ITI-38 (Cross Gateway Query) is based on ITI-18 (Registry
				#; Stored Query), which allows only one value for
				#; $XDSSubmissionSetPatientId or $XDSSubmissionSetPatientId.
				Set ttSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='"_i_"']/rim:ValueList/rim:Value[1]","text()",.tPatientID,.tDocObject)
				#; Assume that if tPatientID is null then we need to look at the next slot name instead.
				If tPatientID="" Continue
				If $Extract(tPatientID)="'" Set tPatientID = $Extract(tPatientID,2,*)
				If $Extract(tPatientID,*)="'" Set tPatientID = $Extract(tPatientID,1,*-1)
				If tPatientID'="" {
					If $Data(^HS.IHE.XCPDCache(tPatientID,tSendingCommunityId))#10=0 Set tPatientIdOK = 0 Quit
					If ^HS.IHE.XCPDCache(tPatientID,tSendingCommunityId)=0 Do ..Errors.logError("XDSUnknownPatientId","Error","Patient Id "_$Piece(tPatientID,"^")_" from "_$Piece(tPatientID,"&",2)_" no longer valid") Set tPatientIdOK = 0 Quit
				}
			}
			#; tPatientIdOK = 1 if a cache node for the Patient Id is present and has a non-zero value.
			#; tPatientIdOK = 0 if there is no cache node or a zero-valued cache node for the Patient Id.
			If (tPatientIdOK=0)&&(..Errors.Errors.Count()=0) {
				Set pResponse.Name = $$$XCAQueryResponse
				Set tSC = pResponse.ContentStream.Write("<query:AdhocQueryResponse xmlns=""urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"" xmlns:query=""urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"" status=""urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success"">")
				Set tSC = pResponse.ContentStream.Write("</query:AdhocQueryResponse>")
				Quit
			} 
			#; tPatientIdOK = 0, has errors - build failure response and quit
			#; tPatientIdOK = 0, no errors  - build empty response (none found) and quit
			#; tPatientIdOK = 1, has errors - build failure response and quit
			#; tPatientIdOK = 1, no errors  - continue
		}

		If ..Errors.Errors.Count() {
			Do ..BuildErrorResponse(..Errors,.pResponse)
			Set tSC = $$$OK
			Quit
		}
		#; if not acting as a big bus, send to the local registry
		Set tRequest=pRequest.%ConstructClone(1)
		Set tRequest.Name = "XDSb_QueryRequest"
		Do tRequest.AdditionalInfo.SetAt($$$XDSbQueryAction(..IHEVersion),"SOAPAction")
		Do tRequest.AdditionalInfo.SetAt("","ReplyAddress")
		Set tSC = ..SendRequestSync(..XDSbRegistryOperations,tRequest,.tResponse)
		$$$ThrowOnError(tSC)
		Set tXSLArguments("homeCommunityID") = ..HomeCommunityOID
		$$$HSTRACE("home community id"_..HomeCommunityOID)
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tResponse.ContentStream, ..AddHomeCommunityTransform /*"IHE/XCA/Version1/AddHomeCommunityIDToQueryDocumentsResponse.xsl"*/, .tOutputStream, .tXSLArguments)
		$$$HSTRACEENDCALL
		$$$HSTRACE("transform status","tSC,tOutputStream",tSC,$g(tOutputStream))
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$XCAQueryResponse
		Set pResponse.ContentStream = tOutputStream

	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

/// Called by query request when XDSbRegistryOperations is null.  The only query which is valid is PatientID, and because the AssigningAuthority of the patient is used
/// only one AA is valid (no splitting of the request)
Method QueryRequestBigBus(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status [ Internal ]
{
	Set tSC=$$$OK
	try {
		#; if acting as a big bus need to get the patient ID (affinity domain) to locate the 
		#; responding gateway for the request
		Set tErrors = ##class(HS.Types.IHE.Errors).%New()
		Set tSC = ##class(HS.HC.IHE.XDSb.Registry.Operations).ParseQueryParameters(pRequest.ContentStream,.tQueryParams,.tErrors,.tQueryType,.tReturnType)
		If $$$ISERR(tSC) || (tErrors.Errors.Count()) {
			Do tErrors.logError("XCA","Error","Unable to parse parameters:"_$system.Status.GetErrorText(tSC))
			Do ..BuildErrorResponse(.tErrors,.pResponse)
			Quit
		}
		
		Set tError=""
		IF '$D(tQueryParams("$XDSDocumentEntryPatientId")) Set tError=tError_" $XDSDocumentEntryPatientId"
		If '$D(tQueryParams("$XDSDocumentEntryStatus")) Set tError=tError_" $XDSDocumentEntryStatus"
		If tError]"" {
			Do tErrors.logError("XDSRegistryMetadataError","Error","Missing "_tError) 
			Do ..BuildErrorResponse(.tErrors,.pResponse)
			Quit
		}
		Set (tIdx,tPatientID,tAA,tLastAA)=""
		For  {
			Set tIdx=$o(tQueryParams("$XDSDocumentEntryPatientId",tIdx)) Quit:tIdx=""
			For  {
				Set tPatientID=$o(tQueryParams("$XDSDocumentEntryPatientId",tIdx,tPatientID)) Quit:tPatientID=""
				Set tAA = $p($p(tPatientID,"^^^",2),"&",2)
				Set:tLastAA="" tLastAA=tAA
				If tAA'=tLastAA {
					Do tErrors.logError("Error","Error",$$$FormatText($$$Text("Multiple assigning authorities found '%1' and '%2', where only 1 is supported per message."),tAA,tLastAA))
					Set tLastAA=tAA
				} 
			}
		}

		Set tEndPoint = ##class(HS.Registry.Service.Abstract).EndPointForOID(tAA,"AssigningAuthority","XCA.Query","SOAP")
		If '$isObject(tEndPoint) {
			Do tErrors.logError("Error","Error",$$$FormatText($$$Text("Unable to locate service registry entry for assigning authority '%1' where device function is 'XCA.Query'"),tAA)) 
		}
		If tErrors.Errors.Count() {
			Do ..BuildErrorResponse(.tErrors,.pResponse)
			Set tSC=$$$OK
			Quit
		}
		Do pRequest.AdditionalInfo.SetAt(tEndPoint.Name,"ServiceName")
		Set tSC = ..SendRequestSync(..XCARespondingGatewayOperations,pRequest,.pResponse)
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

Method BuildErrorResponse(pErrors, ByRef pResponse) As %Status
{
	try {
		Set tSC=$$$OK
		Set pResponse.Name = $$$XCAQueryResponse
		#; Assume we just got the one error about Patient Id.
		#; Respond with "Failure" status
		Kill tXSLArguments
		Set tXSLArguments("status") = "Failure"
		Do pErrors.XMLExportToStream(.tOutput) Do tOutput.Rewind()
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tOutput, ..RegistryStoredQueryResponseTransform /*"IHE/XDSb/Version1/RegistryStoredQueryResponse.xsl"*/,.tResponse,.tXSLArguments)
		$$$HSTRACEENDCALL
		If $$$ISERR(tSC) $$$HSTRACE("Problem transforming failure","tSC,tOutput",tSC,tOutput)
		Set pResponse.ContentStream=tResponse
		Do pResponse.ContentStream.Rewind()
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

Method RetrieveRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Do pRequest.AdditionalInfo.SetAt($$$XDSbRetrieveAction(..IHEVersion),"SOAPAction")
		#; Build a collection (list) of HS.Types.IHE.DocumentRequest objects from an inbound Retrieve request
		Set tSC = ..getRetrieveRequestObjects(pRequest,.tRetrieveObjectsList) $$$ThrowOnError(tSC)
		Set (tRequestList,tRq)=""
		For tIdx = 1:1:tRetrieveObjectsList.Count() {
			Set tRequests = tRetrieveObjectsList.GetAt(tIdx)
			#; using the first request in the group get the end point (Service Name)
			Set tRequest = tRequests.Request.GetAt(1)
			Set tEndPointName = tRequest.AdditionalInfo.GetAt("ServiceName")
			Set tHome = tRequest.AdditionalInfo.GetAt("HOME")
			$$$HSTRACE("Building request for ","tEndPointName,tHome",tEndPointName,tHome)
			Set tSC = tRequests.XMLExportToStream(.tRequestStream)
			$$$HSTRACESTARTCALL
			Set tSC = ..Transformer.Transform(tRequestStream, ..XCARequestTransform /*"IHE/XCA/Version1/RequestsObjectToRequest.xsl"*/,.tOutput)
			$$$HSTRACEENDCALL
			$$$HSTRACE("Transform status ","tSC",$system.Status.GetErrorText(tSC))
			$$$ThrowOnError(tSC)
			Set tName = $s(tHome:$$$XDSbRetrieveRequest,1:$$$XCARetrieveRequest)
			Set tAction = $s(tHome:$$$XDSbRetrieveAction(..IHEVersion),1:$$$XCARetrieveAction(..IHEVersion))

			Set tRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
			Set tRetrieveRequest.Name=tName
			Set tRetrieveRequest.ContentStream = tOutput
			Set tRetrieveRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone() // Copy SAML data
			Set tRetrieveRequest.SAMLData = pRequest.SAMLData.%ConstructClone() // Copy SAML data
			Do tRetrieveRequest.AdditionalInfo.SetAt(tEndPointName,"ServiceName")
			Do tRetrieveRequest.AdditionalInfo.SetAt(tAction,"SOAPAction")
			Do tRetrieveRequest.AdditionalInfo.RemoveAt("RelatesTo")
			Do tRetrieveRequest.AdditionalInfo.RemoveAt("ReplyAddress")
			
			Set tRq = ##class(Ens.CallStructure).%New()
			Set tRq.Request = tRetrieveRequest
			Set tRq.TargetDispatchName = $S(tHome:..XDSbRepositoryProcess,1:..XCARespondingGatewayOperations)
			$$$HSTRACE("Adding Request","tRetrieveRequest,Dispatch",tRetrieveRequest,tRq.TargetDispatchName)
			Set tRequestList($i(tRequestList)) = tRq
		}
		
		If $G(tRequestList) && $isObject(tRq) && (..Errors.HighestError'="Error") {
			Set tSC = ..SendRequestSyncMultiple(.tRequestList, ..FailureTimeout)
			$$$HSTRACE("Sending External Requests","tSC",tSC)
			If $$$ISERR(tSC) {
				Do ..Errors.logError("InternalError","Error",$system.Status.GetErrorText(tSC),"")
			}
		}
		Set tResponses = ##class(%Stream.GlobalCharacter).%New()
		Do tResponses.Write("<XDSbRetrieveResponses xmlns=""urn:ihe:iti:xds-b:2007"">")
		If ..Errors.Errors.Count() {
			Do ..Errors.XMLExportToString(.tErrors)
			Do tResponses.Write(tErrors)
			Set tStatus($$$QueryFailure)=""
		}
		For tIdx1=1:1:$g(tRequestList) {
			Set tRq = tRequestList(tIdx1)
			Set tRequest = tRq.Request
			Set tResponse = tRq.Response
			Set tResult = tRq.ResponseCode
			If $$$ISERR(tResult){
				$$$HSTRACE("Error contacting "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				$$$LOGERROR("Error contacting "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Continue
			}
			ElseIf (tResponse=$$$NULLOREF){
				$$$HSTRACE("Timed out for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				$$$LOGERROR("Timed out for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Set tStatus($$$QueryFailure)=""
				Do ..Errors.logError("XCA","Error","Timed out for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Continue
			}
			ElseIf (tResponse.ContentStream.%IsNull()){
				$$$HSTRACE("Empty response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				$$$LOGERROR("Empty response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Set tStatus($$$QueryFailure)=""
				Do ..Errors.logError("XCA","Error","Empty response for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Continue
			}
			Do tResponses.CopyFrom(tResponse.ContentStream)
			#; move attachments over to final response
			For tIdx2=1:1:tResponse.StreamCollection.Count() {
				Do pResponse.StreamCollection.Insert(tResponse.StreamCollection.GetAt(tIdx2))
			}
			Do tResponses.MoveToEnd()
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/query:AdhocQueryResponse","@status",.tStatusItem)
			If $$$ISERR(tSC) Do ..Errors.logError("XCA","Error","Unable to execute xpath expression for query response"_tSC) Quit
			$$$HSTRACE("Status from retrieve response"_tStatusItem)
			Set:tStatusItem="" tStatusItem=$$$QueryFailure
			Set tStatus(tStatusItem)=""
		}
		Do ..Errors.XMLExportToString(.tErrorString)
		Do tResponses.Write(tErrorString)
		Do tResponses.Write("</XDSbRetrieveResponses>")

		$$$HSTRACE("Retrieve Responses","tResponses",tResponses)
		Set tXSLArguments("homeCommunityID") = ..HomeCommunityOID
		If $D(tStatus($$$QueryFailure)) {
			If '$D(tStatus($$$QuerySuccess)) {
				Set tStatus=$$$QueryFailure
			} Else {
				Set tStatus=$$$QueryPartialSuccess
			}
		} Else {
			Set tStatus=$$$QuerySuccess //"urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success"
		}
		Set tXSLArguments("status") = tStatus
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tResponses, ..XCAConsolidateResponseTransform /*"IHE/XCA/Version1/ConsolidateRetrieveResponses.xsl"*/, .tOutputStream, .tXSLArguments)
		$$$HSTRACEENDCALL
		$$$ThrowOnError(tSC)
		$$$HSTRACE("Transformed Stream","tOutputStream",tOutputStream)
		Set pResponse.ContentStream = tOutputStream
		
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>MPIOperations</Value>
</Value>
<Value name="2">
<Value>XDSbConsumerOperations</Value>
</Value>
<Value name="3">
<Value>PIXv3ManagerOperations</Value>
</Value>
<Value name="4">
<Value>OrganizationID</Value>
</Value>
<Value name="5">
<Value>OrganizationCode</Value>
</Value>
<Value name="6">
<Value>OrganizationName</Value>
</Value>
<Value name="7">
<Value>XCARespondingGatewayOperations</Value>
</Value>
<Value name="8">
<Value>XDSbRegistryOperations</Value>
</Value>
<Value name="9">
<Value>IHEVersion</Value>
</Value>
<Value name="10">
<Value>IHEExtension</Value>
</Value>
<Value name="11">
<Value>Transformer</Value>
</Value>
<Value name="12">
<Value>XDSbRepositoryOperations</Value>
</Value>
<Value name="13">
<Value>XDSbRepositoryProcess</Value>
</Value>
<Value name="14">
<Value>UseIDCache</Value>
</Value>
<Value name="15">
<Value>RegistryStoredQueryResponseTransform</Value>
</Value>
<Value name="16">
<Value>AddHomeCommunityTransform</Value>
</Value>
<Value name="17">
<Value>XCARequestTransform</Value>
</Value>
<Value name="18">
<Value>XCAConsolidateResponseTransform</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
