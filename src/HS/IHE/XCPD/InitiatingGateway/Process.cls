Include (HS.HC, HS.IHE.XCPD)

Class HS.IHE.XCPD.InitiatingGateway.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ ClassType = persistent, Inheritance = left ]
{

Parameter HSDEPLOY = 1;

/// Domain used for localization.
Parameter DOMAIN = "HS";

/*
	Take the response from a search request and use the demographics to build the 
*/
Parameter SETTINGS = "PDQv3Consumer,XCPDQueryServiceNames,XCPDInitiatingGatewayOperations,HomeCommunity,SenderDevice,QueryInitiator,ApplyConsent,TransformPDQToPatientSearch, TransformPatientSearchToXCPD,NationalPatientIdentifier:Basic";

/// A comma separated list of XCPD Repositories (Registry Service Names)
Property XCPDQueryServiceNames As %String(MAXLEN = "");

/// Query back to the initiator if true will cause a query back to the initiator, then looking for documents from the initiator.  Another option
/// is if the AssigningAuthority is not set on the XCPD service registry entry for the initiator then it will not be excluded.
Property QueryInitiator As %Boolean [ InitialExpression = 1 ];

/// Code for SenderDevice OID from HS.Data.OIDMap where type=Device
Property SenderDevice As %String(MAXLEN = 100);

Property SenderDeviceOID As %String(MAXLEN = 100);

/// To locate the patient demographics given the MPIID
Property PDQv3Consumer As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PDQv3.Consumer.Operations" ];

Property XCPDInitiatingGatewayOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XCPD.InitiatingGateway.Operations" ];

/// If true, the PDQ lookup requests used by this process to get patient demographic information will be processed by consent.
Property ApplyConsent As %Boolean [ InitialExpression = 0 ];

/// Code for HomeCommunity OID from HS.Data.OIDMap where type=HomeCommunity
Property HomeCommunity As %String;

/// property to hold translated HomeCommunity
Property HomeCommunityOID As %String(MAXLEN = 64);

Property IHEVersion As %Integer [ InitialExpression = 1 ];

Property Transformer As HS.Util.XSLTTransformer;

Property Errors As HS.Types.IHE.Errors;

/// In a National Identifier situation, the National Identifier is sent to the responding gateway instead of demographics.  Locate <br>
/// the MPIID and return it (no demographics) 
Property NationalPatientIdentifier As %Boolean [ InitialExpression = 0 ];

/// Config registry value for \IHE\NationalPatientIdentifierAA
Property NationalPatientIdentifierAA As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\IHE\NationalPatientIdentifierAA")} ];

Property TransformPDQToPatientSearch As %String(MAXLEN = 250) [ InitialExpression = "IHE/XCPD/Version1/PRPAIN201306UVToPatientSearchResponse.xsl" ];

Property TransformPatientSearchToXCPD As %String(MAXLEN = 250) [ InitialExpression = "/IHE/XCPD/Version1/PatientSearchToPRPAIN201305UV.xsl" ];

Method OnRequest(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		/// this code should exist in OnInit but that is broken
		Set:..HomeCommunity="" ..HomeCommunity=$$$HomeCommunity
		Set ..HomeCommunityOID = ##class(HS.Data.OIDMap).OIDForType(..HomeCommunity,"HomeCommunity")
		Set ..SenderDeviceOID = ##class(HS.Data.OIDMap).OIDForType(..SenderDevice,"Device")
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		$$$GetTransformer(..Transformer)
		If pRequest.%IsA("HS.Message.PatientSearchRequest") {
			Set tSC=..PatientDiscovery(pRequest,.pResponse) $$$ThrowOnError(tSC)
		} ElseIf pRequest.Name = $$$XCAQueryRequest {
			Set tSC=..XCAPatientDiscovery(pRequest,.pResponse) $$$ThrowOnError(tSC)
		} 
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCPD Error","Error",$system.Status.GetErrorText(tSC))
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

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

/// pRequest contains the XCA_QueryRequest which contains the Patient ID - Query the Systems listed in XCPDQueryServiceNames and build a list of PatientID's
/// This method is deprecated, in favor of accepting the HS.Message.PatientSearchRequest with the MPIID defined
Method XCAPatientDiscovery(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	try {
		Set tResponses = ##class(HS.Message.IHE.XCPDPatients).%New()
		Set tResponsesStream=""
		#; if there are no XCPDQueryServiceNames there is not point in getting the patient demographics
		If ..XCPDQueryServiceNames]"" {
			#; need to get demographics related to the patient ID 
			#; get the patient id as ID^^^&oid&ISO
			Set tSC = ##class(HS.IHE.XCA.InitiatingGateway.Process).ExtractPatientID(pRequest,.tPatientID)
			If $$$ISERR(tSC) Do ..Errors.logError("XCPDInitiatingGatewayError","Error",$$$Text("Unable to extract patient id from request ")_$system.Status.GetErrorText(tSC)) Quit
			$$$HSTRACE("patientid from extract:"_tPatientID)
			Set tRequest = ##class(HS.Message.PatientSearchRequest).%New()
			Set tRequest.MPIID=$p(tPatientID,"^")
			Set tSC = ..PatientDiscovery(tRequest,.tResponse) 
			If $$$ISERR(tSC) Do ..Errors.logError("XCPDInitiatingGatewayError","Error",$$$Text("Unable to execute the patient discovery ")_$system.Status.GetErrorText(tSC)) Quit
			
			Set tSC = tResponses.XMLExportToStream(.tResponsesStream)
		$$$HSTRACE("Responses","tResponsesStream",tResponsesStream)
		$$$HSThrowErrors(tSC)
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = $$$XCAQueryResponse
		
		Set pResponse.ContentStream = tResponsesStream
		
		}		
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCPDInitiatingGatewayError","Error",$system.Status.GetErrorText(tSC))
	}
	If ..Errors.Errors.Count() $$$HSTRACE("Errors","errors",..Errors)
	Quit tSC
}

/// pRequest is an internal PatientSearchRequest message with the MPIID of the patient we are looking for
Method PatientDiscovery(pRequest As HS.Message.PatientSearchRequest, Output pResponse As HS.Message.IHE.XCPDPatients) As %Status
{
	Set tSC=$$$OK
	try {
		Set pResponse = ##class(HS.Message.IHE.XCPDPatients).%New()
		#; if there are no XCPDQueryServiceNames there is not point in getting the patient demographics
		If ..XCPDQueryServiceNames]"" {
			#; Get local Patient Demographics
			#dim tPatientMatch as HS.Message.PatientSearchMatch
			Set tSC = ..GetPatientDemographics(pRequest,.tPatientMatch,.tIdentifiers)
			If $$$ISERR(tSC) {
				Do ..Errors.logError("XCPDInitiatingGatewayError","Error","Unable extract patient id from request "_$system.Status.GetErrorText(tSC)) Quit
			}
			If '$IsObject(tPatientMatch) {
				Do ..Errors.logError("XCPDInitiatingGatewayError","Error","Unable extract patient id from request "_$system.Status.GetErrorText(tSC)) Quit
			}
			Set tInitiatingAssigningAuthority = tPatientMatch.AssigningAuthority
			#; Query each XCPD responding gateway for matching patient
			Set tQuerySystems = ..XCPDQueryServiceNames
			Set tQuerySysCount=$S(tQuerySystems="":0,1:$l(tQuerySystems,","))
			$$$HSTRACE("In Query request ","tQuerySystems",tQuerySystems)
			For tIdx1 = 1:1:tQuerySysCount {
				Set tQuerySys = $p(tQuerySystems,",",tIdx1)
				Set tSysEndPoint=##class(HS.Registry.Service.SOAP).EndPointForNameType(tQuerySys,"SOAP")
				If '$IsObject(tSysEndPoint) Do ..Errors.logError("XCPDInitiatingGatewayError","Error","Unable to locate end point for name "_tQuerySys) Continue
				#; don't query the system that initiated the query
				If '..QueryInitiator && (tSysEndPoint.OIDMapCode.GetAt("AssigningAuthority")=tInitiatingAssigningAuthority) Continue  
			
				#; if querying with XCA.Query endpoint, they must not handle XCPD, use the ID for that community and continue
				If tSysEndPoint.DeviceFunction="XCA.Query" {
					Set tHomeCommunity = tSysEndPoint.OIDMapCode.GetAt("HomeCommunity")
					Set tResponse = ##class(HS.Message.IHE.XCPDPatient).%New()
					Set tAssigningAuthorityName = tSysEndPoint.OIDMapCode.GetAt("AssigningAuthority")
					Set tAssigningAuthority = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityName)
					Set tOtherMPIID = $g(tIdentifiers(tAssigningAuthorityName_" "),tPatientMatch.MPIID)
					If tOtherMPIID="" {
						Set tSC2 = $$$ERROR($$$GeneralError,$$$FormatText("No identifier found for %1",tQuerySys))
						$$$LOGERROR($System.Status.GetErrorText(tSC2))
						Continue
					}
					Set tResponse.HomeCommunityId = tHomeCommunity
					Set tResponse.Extension= tOtherMPIID
					Set tResponse.Root=tAssigningAuthorityName

					Do pResponse.Patients.Insert(tResponse)
					Continue
				} 
				#; Standard XCPD Processing
				Set tSC =  ..getQueryMessage(tPatientMatch,.tOutput,tSysEndPoint) If $$$ISERR(tSC) Do ..Errors.logError("XCPDInitiatingGatewayError","Error",$system.Status.GetErrorText(tSC)) Continue
				If $$$ISERR(tSC) $$$HSTRACE("error transforming","tSC",tSC)
				Set tRq = ##class(Ens.CallStructure).%New()
				Set tNewSearchRequest = ##class(HS.Message.XMLMessage).%New()
				Set tNewSearchRequest.Name=$$$XCPDPatientDiscoveryRequest
				Do tNewSearchRequest.ContentStream.CopyFrom(tOutput)
				Set tNewSearchRequest.AdditionalInfo = pRequest.AdditionalInfo.%ConstructClone()  ///SAML/User Auth
				Set tNewSearchRequest.SAMLData = pRequest.SAMLData.%ConstructClone()  ///SAML/User Auth
				$$$HSTRACE("xcpd ","tSysEndPoint",tQuerySys)
				Do tNewSearchRequest.AdditionalInfo.SetAt(tQuerySys,"TargetName")
				Set tRq.Request = tNewSearchRequest
				Set tRq.TargetDispatchName = ..XCPDInitiatingGatewayOperations
				Set tRequestList($i(tRequestList)) = tRq
				Set tRq=""
				$$$HSTRACE("Adding Request","tRq,tNewSearchRequest",tRq,tNewSearchRequest)
			}
			If $G(tRequestList) Set tSC = ..SendRequestSyncMultiple(.tRequestList, ..FailureTimeout)
		
			For tIdx1=1:1:$G(tRequestList) {
				Set tRq = tRequestList(tIdx1)
				Set tRequest = tRq.Request
				Set tResponse = tRq.Response
				Set tResult = tRq.ResponseCode
				If $$$ISOK(tResult),tResponse=$$$NULLOREF {
					$$$HSTRACE("Timed out for "_tRequest.AdditionalInfo.GetAt("TargetName"))
					$$$LOGERROR("Timed out for "_tRequest.AdditionalInfo.GetAt("TargetName"))
					Continue
				}
				If '$IsObject(tResponse) {
					$$$LOGERROR("No valid response "_tRequest.AdditionalInfo.GetAt("TargetName"))
					Continue
				}
				If '$isObject(tResponse.ContentStream) {
					Do ..Errors.logError("XCPDInitiatingGatewayError","Warning","Unknown response")
					Continue 
				}
				ElseIf (tResponse.ContentStream.%IsNull()){
					Do ..Errors.logError("XCPDInitiatingGatewayError","Warning","Empty response from "_tRequest.AdditionalInfo.GetAt("TargetName"))
					Continue
				}
				$$$HSTRACESTARTCALL
				Set tSC = ..Transformer.TransformIntoObject(tResponse.ContentStream, ..TransformPDQToPatientSearch /*"IHE/XCPD/Version1/PRPAIN201306UVToPatientSearchResponse.xsl"*/,.tSearchResponse,.tXSLArguments,"HS.Message.PatientSearchResponse","PatientSearchResponse")
				$$$HSTRACEENDCALL
				If $$$ISERR(tSC) {
					$$$HSTRACE("error transforming response "_tRequest.AdditionalInfo.GetAt("TargetName"))
					$$$LOGERROR("error transforming response  "_tRequest.AdditionalInfo.GetAt("TargetName"))
					Continue
				}
				Set tResponse = ##class(HS.Message.IHE.XCPDPatient).%New()
				$$$HSTRACE("tSearchResponse","tSearchResponse",tSearchResponse)
				If '$isObject(tSearchResponse) $$$HSTRACE("No search response "_tIdx1) continue
				If tSearchResponse.Results.Count()>1 $$$LOGWARNING("More than 1 match found for XCPD Query to "_tRequest.AdditionalInfo.GetAt("TargetName")) Continue
				Set tResponseItem = tSearchResponse.Results.GetAt(1) if '$isobject(tResponseItem)  $$$HSTRACE("No search response item "_tIdx1)  continue
				Set tResponse.HomeCommunityId = tResponseItem.AdditionalInfo.GetAt("Custodian")
				#; first identifier will be the entry from the <id> which is the item to use table 3.55.4.2.2-1
				Set tResponse.Extension= tResponseItem.Identifiers.GetAt(1).Extension
				Set tResponse.Root=tResponseItem.Identifiers.GetAt(1).Root
				Do pResponse.Patients.Insert(tResponse)
			}
		}
		
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("XCPDInitiatingGatewayError","Error",$system.Status.GetErrorText(tSC))
	}
	If ..Errors.Errors.Count() $$$HSTRACE("Errors","errors",..Errors)
	Quit tSC
}

/// Using the patient match and the end point device create the XCPD request for a target system and return in pOutput
Method getQueryMessage(pPatientMatch, Output pOutput, pSysEndPoint) As %Status
{
	Set tSC=$$$OK
	try {
		If ..NationalPatientIdentifier {
			If ..NationalPatientIdentifierAA = "" {
				Return $$$ERROR($$$Text("Configuration registry for \IHE\NationalPatientIdentifierAA must have a value when NationalPatientIdentifier is true"))
			}
		}
		Set tOtherHomeCommunity=##class(HS.Data.OIDMap).GetOIDForCode(pSysEndPoint.OIDMapCode.GetAt("HomeCommunity"))
		Set tReceiverDevice=##class(HS.Data.OIDMap).GetOIDForCode(pSysEndPoint.OIDMapCode.GetAt("Device"))
		$$$HSTRACE("patientmatch ","pPatientMatch",pPatientMatch)
		Set tXSLArguments("homeCommunityOID") = ..HomeCommunityOID
		Set tXSLArguments("otherCommunityOID") = tOtherHomeCommunity
		If ..NationalPatientIdentifier {
			For tIdx = 1:1:pPatientMatch.Identifiers.Count() {
				Set tIdentifier = pPatientMatch.Identifiers.GetAt(tIdx)
				If tIdentifier.Root = ..NationalPatientIdentifierAA {
					Set tXCPDAssigningAuthority = ..NationalPatientIdentifierAA
					Set tXCPDPatientID = tIdentifier.Extension
				}
			} 
			If $G(tXCPDPatientID)="" Return $$$ERROR($$$GeneralError,"Unable to locate national patient identifier")
		} Else {
			Set tXCPDAssigningAuthority = pPatientMatch.AssigningAuthority
			Set tXCPDPatientID = pPatientMatch.MPIID
		}
		Set tXSLArguments("XCPDAssigningAuthority") = tXCPDAssigningAuthority
		Set tXSLArguments("XCPDPatientID") = tXCPDPatientID
		Set tXSLArguments("senderDeviceOID") = ..SenderDeviceOID
		Set tXSLArguments("receiverDeviceOID") = tReceiverDevice
		Set tXSLArguments("queryID") = $System.Util.CreateGUID()
		Set tXSLArguments("queryExtension") = "1"
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("messageExtension") = "1"
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()
		Set tXSLArguments("nationalPatientIdentifierAA") = $S(..NationalPatientIdentifier:..NationalPatientIdentifierAA,1:"")

		#; pPatientMatch is the MPI level match from GetPatientDemographics - do not overwrite AssigningAuthority or MPIID
		Set pPatientMatch.MRN="",pPatientMatch.Facility=""

		Do pPatientMatch.XMLExportToStream(.tPatientMatchStream)
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tPatientMatchStream,..TransformPatientSearchToXCPD /*"/IHE/XCPD/Version1/PatientSearchToPRPAIN201305UV.xsl"*/,.pOutput,.tXSLArguments)
		$$$HSTRACEENDCALL
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

/// Given an AdhocQueryRequest return the PatientSearchResponse (from a PDQ lookup)
Method GetPatientDemographics(pRequest As HS.Message.PatientSearchRequest, Output pSearchMatch As HS.Message.PatientSearchRequest = "", Output pIdentifiers) As %Status
{
	try {
		Set tSC=$$$OK
		Set pSearchMatch = $$$NULLOREF
		Set pRequest.SearchMode="PIXPDQ"
		Set:..ApplyConsent pRequest.SearchMode="PIXPDQ_c"
		Set tAA=$$$AffinityDomain,pRequest.AssigningAuthority=tAA
		Set tService = pRequest.AdditionalInfo.GetAt("ServiceName")
		If tService="" {
			Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForID(tAA,"AssigningAuthority","PDQv3.Supplier")
			Set:$IsObject(tServiceObject) tService=tServiceObject.Name
		}
		Do:tService]"" pRequest.AdditionalInfo.SetAt(tService,"ServiceName")
		Set tSC = ..SendRequestSync(..PDQv3Consumer,pRequest,.tResponse)
		If $$$ISERR(tSC) Do ..Errors.logError("XCPDInitiatingGatewayError","Error","Error from PDQ request "_$system.Status.GetErrorText(tSC)) Quit
		For tIdx = 1:1:tResponse.Results.Count() {
			Set tMatch = tResponse.Results.GetAt(tIdx)
			If tMatch.MPIID]"" {
				Set pSearchMatch=tMatch 
				Set pIdentifiers($$$AffinityDomain_" ")=tMatch.MPIID
			}
			For tIdx2 = 1:1:tMatch.Identifiers.Count() {
				Set tIdentifier=tMatch.Identifiers.GetAt(tIdx2)
				$$$HSTRACE("validating "_tIdentifier.Root_" against "_tAA)
				
				If tIdentifier.Root = tAA Set pSearchMatch=tMatch,pSearchMatch.MPIID=tIdentifier.Extension 
				Set pIdentifiers($zcvt(tIdentifier.Root,"U")_" ")=tIdentifier.Extension
			}
		}
		Set:$isObject(pSearchMatch) pSearchMatch.AssigningAuthority=tAA
		$$$HSTRACE("pSearchMatch","pSearchMatch",pSearchMatch)
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	If '$isObject(pSearchMatch) Do ..Errors.logError("XCPDInitiatingGatewayError","Error","Did not find MPI result when searching ")
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>XCAQueryServiceNames</Value>
</Value>
<Value name="2">
<Value>XDSbQueryServiceName</Value>
</Value>
<Value name="3">
<Value>PIXv3Consumer</Value>
</Value>
<Value name="4">
<Value>InitiatingGatewayOperations</Value>
</Value>
<Value name="5">
<Value>HomeCommunityAsAssigningAuthority</Value>
</Value>
<Value name="6">
<Value>TraceOperations</Value>
</Value>
<Value name="7">
<Value>IHEVersion</Value>
</Value>
<Value name="8">
<Value>IHEExtension</Value>
</Value>
<Value name="9">
<Value>Transformer</Value>
</Value>
<Value name="10">
<Value>PDQv3Consumer</Value>
</Value>
<Value name="11">
<Value>XCPDQueryServiceNames</Value>
</Value>
<Value name="12">
<Value>XCPDInitiatingGatewayOperations</Value>
</Value>
<Value name="13">
<Value>HomeCommunityOID</Value>
</Value>
<Value name="14">
<Value>SenderDeviceOID</Value>
</Value>
<Value name="15">
<Value>SenderDevice</Value>
</Value>
<Value name="16">
<Value>HomeCommunity</Value>
</Value>
<Value name="17">
<Value>Errors</Value>
</Value>
<Value name="18">
<Value>PDQLowThreshold</Value>
</Value>
<Value name="19">
<Value>QueryInitiator</Value>
</Value>
<Value name="20">
<Value>TransformPDQToPatientSearch</Value>
</Value>
<Value name="21">
<Value>TransformPatientSearchToXCPD</Value>
</Value>
<Value name="22">
<Value>ApplyConsent</Value>
</Value>
<Value name="23">
<Value>NationalPatientIdentifier</Value>
</Value>
<Value name="24">
<Value>NationalPatientIdentifierAA</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
