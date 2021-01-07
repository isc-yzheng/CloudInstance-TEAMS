Include (HS.HC, HS.IHE.XDSb, HS.IHE.XCA)

Class HS.IHE.XCA.InitiatingGateway.Process Extends HS.IHE.XCA.Common
{

Parameter HSDEPLOY = 1;

/// Domain used for localization.
Parameter DOMAIN = "HS";

Parameter SETTINGS = "XDSbQueryServiceName,XCAInitiatingGatewayOperations,XCPDInitiatingGatewayProcess,XCAInitiatingGatewayServiceNames,Publisher,XCARequestTransform,XCAConsolidateQueryTransform,XCAConsolidateRetrieveTransform,XCAReplacePatientIdTransform,MetadataTransform";

/// Optional local XDSb Registry Service Name
Property XDSbQueryServiceName As %String(MAXLEN = 512);

/// Process to handle the Cross Community Patient Discovery can be null if just forwarding to 
/// Big Bus (which may querying back into this community)
Property XCPDInitiatingGatewayProcess As Ens.DataType.ConfigName;

/// Optional - Registry Service names of other initiating gateways to send the original request
Property XCAInitiatingGatewayServiceNames As %String(MAXLEN = "");

Property XCAInitiatingGatewayOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCA.InitiatingGateway.Operations" ];

/// DSUB Publisher 
Property Publisher As Ens.DataType.ConfigName;

Property XCARequestTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCA/Version1/RequestsObjectToRequest.xsl" ];

Property XCAConsolidateQueryTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCA/Version1/ConsolidateQueryResponses.xsl" ];

Property XCAConsolidateRetrieveTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCA/Version1/ConsolidateRetrieveResponses.xsl" ];

Property XCAReplacePatientIdTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCA/Version1/QueryRequestReplacePatientId.xsl" ];

Property MetadataTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

Method OnRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		$$$GetTransformer(..Transformer)
		Set:..HomeCommunity="" ..HomeCommunity=$$$HomeCommunity
		Set ..HomeCommunityOID = $$$HomeCommunityOIDGet(..HomeCommunity)
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		If pRequest.Name [ "Query" {
			Set tSC = ..QueryRequest(pRequest,.pResponse)
		} ElseIF pRequest.Name [ "Retrieve" {
			Set tSC = ..RetrieveRequest(pRequest,.pResponse)
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

/// Query registry defined by XDSbConsumer and any targets identified by ..QueryTargets
Method QueryRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Set tXDSbQueryResponses = ##class(%Stream.GlobalCharacter).%New()
		Do tXDSbQueryResponses.Write("<XDSbQueryResponses xmlns:query=""urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0"" xmlns:rim=""urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0"" xmlns:rs=""urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0"" xmlns:lcm=""urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0"">")
		#; get query type
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery","@id",.tValue,.tDocument)
		If $$$ISERR(tSC) Do ..Errors.logError("XCA","Error","Unable to execute xpath expression") Quit
		#; get home community id
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery","@home",.tHomeID,tDocument)
		If $$$ISERR(tSC) Do ..Errors.logError("XCA","Error","Unable to execute xpath expression") Quit
		If tHomeID]"" {
			Set tSC = ..QueryToHomeCommunity(pRequest,.tRequestList,tDocument)
		} Else {
			#; query by UUID using home community id or by PatientID (Else)
			If tValue=$$$XDSbQueryGetDocuments {
				Set tSC = ..QueryToHomeCommunity(pRequest,.tRequestList,tDocument)
			} Else {
				Set tSC = ..QueryByPatient(pRequest,.tRequestList)
			}
		}
		Set tPartialResults=0,tHaveSomeResults=0
		If $g(tRequestList) {
			Set tSC = ..SendRequestSyncMultiple(.tRequestList, ..FailureTimeout)
		} 
		If $$$ISERR(tSC) {
			Do ..Errors.logError("XCA","Error","Error sending request:"_$system.Status.GetErrorText(tSC))
		}

		For tIdx1=1:1:$g(tRequestList) {
			Set tRq = tRequestList(tIdx1)
			Set tRequest = tRq.Request
			Set tResponse = tRq.Response
			Set tResult = tRq.ResponseCode
			If $$$ISERR(tResult) || (tResponse=$$$NULLOREF) {
				Do ..Errors.logError("XCAInitiatingGateway","Warning","No response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Set tPartialResults=1
				Set tSuccess($$$QueryFailure)=""
				$$$HSTRACE("Timed out for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				$$$LOGERROR("Timed out for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Continue
			}
			ElseIf (tResponse.ContentStream.%IsNull()){
				Do ..Errors.logError("XCAInitiatingGateway","Warning","Empty response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Set tPartialResults=1
				Set tSuccess($$$QueryFailure)=""
				$$$HSTRACE("Empty response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				$$$LOGERROR("Empty response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Continue
			}
			Set tHaveSomeResults=1
			Do tXDSbQueryResponses.CopyFrom(tResponse.ContentStream)
			
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/query:AdhocQueryResponse","@status",.tValue)
			If $$$ISERR(tSC) Do ..Errors.logError("XCA","Error","Unable to execute xpath expression for query response: "_$System.Status.GetErrorText(tSC)) Continue
			Set:tValue="" tValue=$$$QueryFailure //"urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"
			Set tSuccess(tValue)=""
			Do tXDSbQueryResponses.MoveToEnd()
			$$$HSTRACE("Status from query response"_tValue)
		}
		Do ..Errors.XMLExportToString(.tErrorString)
		Do tXDSbQueryResponses.Write(tErrorString)
		Do tXDSbQueryResponses.Write("</XDSbQueryResponses>")
		If ..Errors.HighestError="Error" Set tSuccess($$$QueryFailure)=""
		If $D(tSuccess($$$QueryFailure)) {
			If '$D(tSuccess($$$QuerySuccess)) {
				Set tStatus=$$$QueryFailure
			} Else {
				Set tStatus=$$$QueryPartialSuccess
			}
		} Else {
			Set tStatus=$$$QuerySuccess //"urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success"
		}
		Set tXSLArguments("homeCommunityID") = ..HomeCommunityOID
		Set tXSLArguments("status")=tStatus
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tXDSbQueryResponses, ..XCAConsolidateQueryTransform /*"IHE/XCA/Version1/ConsolidateQueryResponses.xsl"*/, .tOutputStream, .tXSLArguments)
		$$$HSTRACEENDCALL
		$$$HSThrowErrors(tSC)
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$XCAQueryResponse
		Set pResponse.ContentStream = tOutputStream
		///Implement DSUB notifications from a query
		If ..Publisher]""  {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(pResponse.ContentStream,"/rs:RegistryResponse/rs:RegistryErrorList/rs:RegistryError[1]","@codeContext",.tValue)
			If $Get(tValue)="" {
				Set tSC = ..Transformer.TransformIntoObject(pResponse.ContentStream, ..MetadataTransform /*"IHE/XDSb/Version1/Message-to-MetadataObject.xsl"*/,.tRequest,.tParam,"HS.Message.IHE.XDSb.Metadata","Metadata")
				Set tRequest.Name=pResponse.Name
				Set tSC = ..SendRequestAsync(..Publisher,tRequest)
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCA Error","Error",$system.Status.GetErrorText(tSC))
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

/// If passthrough (XCPDInitGatewayProcess = "") then 
Method QueryByPatient(pRequest As HS.Message.XMLMessage, ByRef pRequestList As %String) As %Status
{
	try {
		Set tSC=$$$OK
		#; Get patients to query
		
		#; Some cases we will only query out to other initiating gateways (passthrough)
		Set tPassThrough = (..XCPDInitiatingGatewayProcess="")
		If 'tPassThrough {
			Set tSC = ..ExtractPatientID(pRequest,.tPatientID) 
			If $$$ISERR(tSC) Do ..Errors.logError("XCPDInitiatingGateway","Error","Unable to execute XCPD Query:"_$system.Status.GetErrorText(tSC)) Set tSC=$$$OK Quit
			Set tRequest = ##class(HS.Message.PatientSearchRequest).%New()
			Set tRequest.MPIID=$p(tPatientID,"^")
			Set tRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
			Set tRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
			Set tSC = ..SendRequestSync(..XCPDInitiatingGatewayProcess,tRequest,.tResponsePatients)
			If $$$ISERR(tSC) Do ..Errors.logError("XCPDInitiatingGateway","Error","Unable to execute XCPD Query:"_$system.Status.GetErrorText(tSC)) Set tSC=$$$OK Quit
		}
		#; it could be that the original transaction needs to be passed to another Initiating Gateway (NHIN model)
		#; put these at the start because they will take the longest to execute
		Set tQuerySystems = ..XCAInitiatingGatewayServiceNames
		Set tQuerySysCount=$S(tQuerySystems="":0,1:$l(tQuerySystems,","))
		For tIdx1 = 1:1:tQuerySysCount {
			Set tQuerySys = $p(tQuerySystems,",",tIdx1)
			Set tRq = ##class(Ens.CallStructure).%New()
			Set tSysEndPoint=##class(HS.Registry.Service.SOAP).EndPointForNameType(tQuerySys,"SOAP")
			Set tRequest=pRequest.%ConstructClone(0)
			Set tRequest.ContentStream = ##class(%Stream.GlobalCharacter).%New()
			Do tRequest.ContentStream.CopyFrom(pRequest.ContentStream)
			Set tRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
			Set tRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
			Do tRequest.AdditionalInfo.SetAt(tQuerySys,"ServiceName")
			Set tRequest.Name=$$$XDSbQueryRequest
			Set tRq.Request = tRequest
			Set tRq.TargetDispatchName = ..XCAInitiatingGatewayOperations
			Set pRequestList($i(pRequestList)) = tRq
			$$$HSTRACE("Adding Request","tRq,tRequest",tRq,tRequest)
			Set tRq=""
		}
		
		#; not a passthrough and have a response from XCPD with a list of patients, query those gateways
		If 'tPassThrough && $isObject(tResponsePatients) {
			For tIdx =1:1:tResponsePatients.Patients.Count() {
				Set tItem = tResponsePatients.Patients.GetAt(tIdx)
				#; remove extraneous urn:oid: if presented
				Set:$e(tItem.HomeCommunityId,1,8)="urn:oid:" tItem.HomeCommunityId=$e(tItem.HomeCommunityId,9,*)
				Set tNewRequest=pRequest.%ConstructClone(0)
				Set tNewRequest.Name = $$$XCAQueryRequest
				Set tNewRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  //SAML/User Auth
				Set tNewRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  //SAML/User Auth
				Set tNewPatientID=tItem.Extension_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(tItem.Root)_"&ISO"
				$$$HSTRACE("query with new patient ","HomeCommunityOID,PatientID,tNewPatientID",tItem.HomeCommunityId,tPatientID,tNewPatientID)
				If tNewPatientID="" $$$ThrowOnError($$$ERROR($$$GeneralError,"Unable to find community patient id"))

				Set tXSLArguments("patientID") = tNewPatientID
				Do pRequest.ContentStream.Rewind()
			
				$$$HSTRACESTARTCALL
				Set tSC = ..Transformer.Transform(pRequest.ContentStream, ..XCAReplacePatientIdTransform /*"IHE/XCA/Version1/QueryRequestReplacePatientId.xsl"*/, .tOutputStream, .tXSLArguments) $$$ThrowOnError(tSC)
				$$$HSTRACEENDCALL
				Set tNewRequest.ContentStream = ##class(%Stream.GlobalCharacter).%New()
				Do tNewRequest.ContentStream.CopyFrom(tOutputStream)
				$$$HSTRACE("in XCA ","PatientID,HomeCommunityID,Status",tXSLArguments("patientID"),tItem.HomeCommunityId,$zcvt($system.Status.GetErrorText(tSC),"O","XML"))

				Set tSysEndPoint=##class(HS.Registry.Service.SOAP).EndPointForID(tItem.HomeCommunityId,"HomeCommunity","XCA.Query","SOAP",1)
				If '$isObject(tSysEndPoint) {
					Do ..Errors.logError("XCAError","Error",$$$FormatText("Unable to locate Service Registry entry with DeviceFunction XCA.Query and HomeCommunity: %1",tItem.HomeCommunityId))
					Continue
				}
				$$$HSTRACE("in XCA "_tXSLArguments("patientID")_$system.Status.GetErrorText(tSC))
				Set tRq = ##class(Ens.CallStructure).%New()
				$$$HSTRACE("XCA ","tSysEndPointDevice",tSysEndPoint.Name)
				Do tNewRequest.AdditionalInfo.SetAt(tSysEndPoint.Name,"ServiceName")
				Do tNewRequest.AdditionalInfo.SetAt($$$XCAQueryAction(1),"SOAPAction")
				Set tRq.Request = tNewRequest
				Set tRq.TargetDispatchName = ..XCAInitiatingGatewayOperations
				Set pRequestList($i(pRequestList)) = tRq
				$$$HSTRACE("Adding Request","tRq,tNewRequest",tRq,tNewRequest)
				Set tRq=""
			
			}
		}

		#; Add request for local registry
		If ..XDSbQueryServiceName]"" {
			Set tRq = ##class(Ens.CallStructure).%New()
			Set tRequest=pRequest.%ConstructClone(1)		///SAML Note: this will copy user auth info from add'l info
			$$$HSTRACE("Target Name "_..XDSbQueryServiceName)
			Do tRequest.AdditionalInfo.SetAt(..XDSbQueryServiceName,"ServiceName")
			Do tRequest.AdditionalInfo.SetAt($$$XDSbQueryAction(1),"SOAPAction")
			Set tRequest.Name=$$$XDSbQueryRequest
			Set tRq.Request = tRequest
			Set tRq.TargetDispatchName = ..XCAInitiatingGatewayOperations
			$$$HSTRACE("Adding Request","tRequest",tRequest)
			Set pRequestList($i(pRequestList)) = tRq
			Set tRq=""
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCA Error","Error",$system.Status.GetErrorText(tSC))
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

Method QueryToHomeCommunity(pRequest As HS.Message.XMLMessage, ByRef pRequestList As %String, pDocument) As %Status
{
	try {
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery","@home",.tHomeID,pDocument)
		Set:$e(tHomeID,1,8)="urn:oid:" tHomeID=$e(tHomeID,9,*)
		Set tRq = ##class(Ens.CallStructure).%New()
		Set tRequest=pRequest.%ConstructClone(1)    ///SAML Note: this will copy user auth info from additional info too
		If tHomeID="" || (tHomeID = ..HomeCommunityOID) {
			Set tRequest.Name=$$$XDSbQueryRequest
			Set tSysEndPoint = ..XDSbQueryServiceName
		} Else {
			Set tRequest.Name=$$$XCAQueryRequest
			Set tObjSysEndPoint = ##class(HS.Registry.Service.SOAP).EndPointForOID(tHomeID,"HomeCommunity","XCA.Query","SOAP",1)
			If '$IsObject(tObjSysEndPoint) $$$ThrowStatus($$$ERROR($$$GeneralError,"No end point for home id "_tHomeID))
			Set tSysEndPoint = tObjSysEndPoint.Name
		}
		Do tRequest.AdditionalInfo.SetAt(tSysEndPoint,"ServiceName")
		Set tRq.Request = tRequest
		Set tRq.TargetDispatchName = ..XCAInitiatingGatewayOperations
		Set pRequestList($i(pRequestList)) = tRq
		Set tRq=""
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCA Error","Error",$system.Status.GetErrorText(tSC))
		$$$LOGSTATUS(tSC)

	}
	Quit tSC
}

Method RetrieveRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$XCARetrieveResponse
		Set tSC = ..getRetrieveRequestObjects(pRequest,.tRequestGroups) $$$ThrowOnError(tSC)
		
		For tIdx = 1:1:tRequestGroups.Count() {
			Set tRequests = tRequestGroups.GetAt(tIdx)
			#; using the first request in the group get the end point (Service Name)
			Set tRequest = tRequests.Request.GetAt(1)
			Set tEndPointName = tRequest.AdditionalInfo.GetAt("ServiceName")
			Set tHome = tRequest.AdditionalInfo.GetAt("HOME")
			Set tAction = $s(tHome:$$$XDSbRetrieveAction(..IHEVersion),1:$$$XCARetrieveAction(..IHEVersion))
			$$$HSTRACE("Building request for ","tEndPointName,tHome",tEndPointName,tHome)
			Set tSC = tRequests.XMLExportToStream(.tRequestStream)
			$$$HSTRACESTARTCALL
			Set tSC = ..Transformer.Transform(tRequestStream, ..XCARequestTransform /*"IHE/XCA/Version1/RequestsObjectToRequest.xsl"*/,.tOutput)
			$$$HSTRACEENDCALL
			$$$HSTRACE("Transform status ","tSC",tSC)
			$$$ThrowOnError(tSC)
			Set tRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
			Set tRetrieveRequest.Name=$s(tHome=1:$$$XDSbRetrieveRequest,1:$$$XCARetrieveRequest)
			Set tRetrieveRequest.ContentStream = tOutput
			Set tRetrieveRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone() ///SAML/User Auth
			Set tRetrieveRequest.SAMLData = pRequest.SAMLData.%ConstructClone() ///SAML/User Auth
			Do tRetrieveRequest.AdditionalInfo.SetAt(tAction,"SOAPAction")			
			Do tRetrieveRequest.AdditionalInfo.SetAt(tEndPointName,"ServiceName")
			Set tRq = ##class(Ens.CallStructure).%New()
			Set tRq.Request = tRetrieveRequest
			Set tRq.TargetDispatchName = ..XCAInitiatingGatewayOperations
			$$$HSTRACE("Adding Request","tRetrieveRequest",tRetrieveRequest)
			Set tRequestList($i(tRequestList)) = tRq
		}				
		Set:$G(tRequestList) tSC = ..SendRequestSyncMultiple(.tRequestList, ..FailureTimeout)

		$$$HSTRACE("Sending External Requests","tSC",tSC)
		$$$HSThrowErrors(tSC)

		Set tResponses = ##class(%Stream.GlobalCharacter).%New()
		Do tResponses.Write("<XDSbRetrieveResponses xmlns=""urn:ihe:iti:xds-b:2007"">")
		For tIdx1=1:1:$g(tRequestList) {
			Set tRq = tRequestList(tIdx1)
			Set tRequest = tRq.Request
			Set tResponse = tRq.Response
			Set tResult = tRq.ResponseCode
			If $$$ISOK(tResult),tResponse=$$$NULLOREF {
				$$$HSTRACE("Timed out for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				$$$LOGERROR("Timed out for "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Set tSuccess("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure")=""
				Do ..Errors.logError("XCA","Error","No response from "_tRequest.AdditionalInfo.GetAt("ServiceName")) 
				Continue
			}
			If '$IsObject(tResponse) {
				$$$LOGERROR("No response for "_tRequest.AdditionalInfo.GetAt("ServiceName")_ " idx:"_tIdx1)
				Do ..Errors.logError("XCA","Error","No response from "_tRequest.AdditionalInfo.GetAt("ServiceName")) 
				Set tSuccess("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure")=""
				Continue
			}
			ElseIf (tResponse.ContentStream.%IsNull()){
				$$$LOGERROR("Empty response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Do ..Errors.logError("XCA","Error","Empty response from "_tRequest.AdditionalInfo.GetAt("ServiceName"))
				Set tSuccess("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure")=""
				Continue
			}
			
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/xdsb:RetrieveDocumentSetResponse/rs:RegistryResponse","@status",.tValue)
			If $$$ISERR(tSC) Do ..Errors.logError("XCA","Error","Unable to execute xpath expression for retrieve response"_tSC) Continue
			Set:tValue="" tValue=$$$QueryFailure //"urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"
			Set tSuccess(tValue)=""

			Do tResponses.CopyFrom(tResponse.ContentStream)
			#; move attachments over to final response
			For tIdx2=1:1:tResponse.StreamCollection.Count() {
				Do pResponse.StreamCollection.Insert(tResponse.StreamCollection.GetAt(tIdx2))
				Set tSuccess("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success")=""

			}
			Do tResponses.MoveToEnd()
		}
		Do ..Errors.XMLExportToString(.tErrorString)
		Do tResponses.Write(tErrorString)

		Do tResponses.Write("</XDSbRetrieveResponses>")
		$$$HSTRACE("Retrieve Responses","tResponses",tResponses)

		Set tXSLArguments("homeCommunityID") = ..HomeCommunityOID
		If $D(tSuccess($$$QueryFailure)) {
			If '$D(tSuccess($$$QuerySuccess)) {
				Set tStatus=$$$QueryFailure
			} Else {
				Set tStatus=$$$QueryPartialSuccess
			}
		} Else {
			Set tStatus=$$$QuerySuccess //"urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success"
		}
		Set tXSLArguments("status")=tStatus
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tResponses, ..XCAConsolidateRetrieveTransform /*"IHE/XCA/Version1/ConsolidateRetrieveResponses.xsl"*/, .tOutputStream, .tXSLArguments)
		$$$HSTRACEENDCALL
		$$$HSThrowErrors(tSC)
		Set pResponse.ContentStream = tOutputStream
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCA Error","Error",$system.Status.GetErrorText(tSC))
		$$$LOGSTATUS(tSC)
		Do ##class(HS.IHE.XDSb.Util).ErrorResponse(tSC, $$$XCARetrieveResponse, .pResponse)
	}
	Quit tSC
}

/// Given an AdhocQueryRequest return the Patient ID in pPatientID as ID^^^&oid&ISO
ClassMethod ExtractPatientID(pRequest As HS.Message.XMLMessage, Output pPatientID As %String) As %Status
{
	try {
		Set tSC=$$$OK
		Set pPatientID=""
		#; get original patient id
		Set tXPathNamespaces=##class(HS.IHE.Util).XPathNamespaces()
		Set tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryRequest/rim:AdhocQuery","@id",.tQueryType,.tDocument)
		If $$$ISERR(tSC) Set tSC =$$$ERROR($$$GeneralError,$$$Text("Unable to execute xpath expression")) Quit

		Set tExpression = $Case(tQueryType,	
				$$$XDSbQueryFindDocuments:"/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$XDSDocumentEntryPatientId']/rim:ValueList/rim:Value",
				$$$XDSbQueryFindFolders:"/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$XDSFolderPatientId']/rim:ValueList/rim:Value",
				$$$XDSbQueryGetAll:"/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot[@name='$patientId']/rim:ValueList/rim:Value",
				1:"")
		Set tPatientID=""
		Set:tExpression]"" tSC = ##class(HS.IHE.Util).GetXPathValue(pRequest.ContentStream,tExpression,"text()",.tPatientID,.tDocument)
		Set tPatientID = $zstrip(tPatientID,"<>","'")
		If tPatientID="" $$$ThrowStatus($$$ERROR($$$GeneralError, "Patient ID is empty"))
		Set tAA = $P($p(tPatientID,"^",4),"&",2)
		Set pPatientID = tPatientID 
	} Catch eException {
		Set tSC=eException.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>PIXv3ConsumerOperations</Value>
</Value>
<Value name="2">
<Value>XDSbConsumerOperations</Value>
</Value>
<Value name="3">
<Value>QueryXCATargets</Value>
</Value>
<Value name="4">
<Value>iHomeCommunityOID</Value>
</Value>
<Value name="5">
<Value>InitiatingGatewayOperations</Value>
</Value>
<Value name="6">
<Value>TraceOperations</Value>
</Value>
<Value name="7">
<Value>iIHEExtension</Value>
</Value>
<Value name="8">
<Value>HomeCommunityOID</Value>
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
<Value>Timeout</Value>
</Value>
<Value name="13">
<Value>XDSbQueryServiceName</Value>
</Value>
<Value name="14">
<Value>XCAQueryServiceNames</Value>
</Value>
<Value name="15">
<Value>PIXv3Consumer</Value>
</Value>
<Value name="16">
<Value>HomeCommunityAsAssigningAuthority</Value>
</Value>
<Value name="17">
<Value>PDQv3Consumer</Value>
</Value>
<Value name="18">
<Value>XCPDInitiatingGatewayProcess</Value>
</Value>
<Value name="19">
<Value>XCPDServiceNames</Value>
</Value>
<Value name="20">
<Value>XCAInitiatingGatewayOperations</Value>
</Value>
<Value name="21">
<Value>XCAInitiatingGatewayServiceNames</Value>
</Value>
<Value name="22">
<Value>Errors</Value>
</Value>
<Value name="23">
<Value>Publisher</Value>
</Value>
<Value name="24">
<Value>XCARequestTransform</Value>
</Value>
<Value name="25">
<Value>XCAConsolidateQueryTransform</Value>
</Value>
<Value name="26">
<Value>MetadataTransform</Value>
</Value>
<Value name="27">
<Value>XCAReplacePatientIdTransform</Value>
</Value>
<Value name="28">
<Value>XCAConsolidateRetrieveTransform</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
