Include (HS.HC, HS.IHE.PDQ, HS.IHE.ATNA)

Class HS.IHE.PDQ.Supplier.Process Extends (Ens.BusinessProcess, HS.HC.IHE.PDQ.Common) [ ClassType = persistent, Inheritance = right ]
{

/* todo:
	Support wildcard MO* CHI* see IHE test
	LivingSubjectName is a repeatable field with an 'or' condition between each
*/
Parameter HSDEPLOY = 1;

Parameter SETTINGS = "-HomeCommunity,AffinityDomain,AffinityDomainIsMPIID,MPIOperations,IHEVersion,TransformPDQToPatientSearch,TransformPatientSearchResponseToPDQ,TransformContinuationRequest,TransformCancellationRequest,TransformCancellationResponse,ApplyRankMultiplier,ApplyConsent,MatchCodeWithOID";

/// Potentially the HomeCommunity is different than the AffinityDomain
Property HomeCommunity As %String;

Property TransformPDQToPatientSearch As %String(MAXLEN = "") [ InitialExpression = "IHE/PDQ/Version1/PRPAIN201305UVToPatientSearchRequest.xsl" ];

Property TransformPatientSearchResponseToPDQ As %String(MAXLEN = "") [ InitialExpression = "IHE/PDQ/Version1/PatientSearchResponseToPRPAIN201306UV.xsl" ];

Property TransformContinuationRequest As %String(MAXLEN = "") [ InitialExpression = "IHE/PDQ/Version1/PDQContinueToXMLMessage.xsl" ];

Property TransformCancellationRequest As %String(MAXLEN = "") [ InitialExpression = "IHE/PDQ/Version1/PDQCancelToXMLMessage.xsl" ];

Property TransformCancellationResponse As %String(MAXLEN = "") [ InitialExpression = "IHE/PDQ/Version1/MCCI000002UV.xsl" ];

Property IHEVersion As %Integer [ InitialExpression = 1 ];

Property IHEExtension As %String;

Property Transformer As HS.Util.XSLTTransformer;

/// Applies to HL7 PDQv2 only. When this is checked (true), if an ISO-formatted assigning
/// authority or facility in an incoming HL7 message includes both a code (NamespaceID)
/// and an OID (UniversalID), then the code must match the IdentityCode defined for the
/// OID in the OID Registry. Otherwise, if this setting is not checked and both code and
/// OID are included in the identifier, then OID is considered to be the authoritative
/// value.
Property MatchCodeWithOID As %Boolean [ InitialExpression = 0 ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set tSC=$$$OK
		Set ..IHEExtension=$s(..IHEVersion=1:"02",1:"")
		$$$GetTransformer(..Transformer)
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set:..AffinityDomain="" ..AffinityDomain=$$$AffinityDomain
		If pRequest.%IsA("EnsLib.HL7.Message") {
			Set tSC = ..ProcessHL7Message(pRequest, .pResponse)
		} ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			Set tSC = ..ProcessXMLMessage(pRequest, .pResponse)
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Message class "_pRequest.%ClassName(1)_" not handled")
			Quit
		}
	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC)) 	
	}
	If ..Errors.Errors.Count() {
		$$$HSTRACE("Errors","Errors",..Errors)
		Set tErrorText="",tWarningText=""
		For tIdx=1:1:..Errors.Errors.Count() {
			Set tError = ..Errors.Errors.GetAt(tIdx)
			If tError.Severity="Error"!(tError.Severity="error")!(tError.Severity="E") {
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

Method ProcessHL7Message(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tHL7Request As EnsLib.HL7.Message
		#dim tRequest As HS.Message.PatientSearchRequest
				
		$$$HSTRACE("HL7 Request from service", "pRequest", pRequest.OutputToString())
		
		// Clone pRequest to tHL7Request so that changes are only applied to tHL7Request.
		Set tHL7Request = pRequest.%ConstructClone(1)
		
		Set tMessageCode = $ZConvert(tHL7Request.GetValueAt("MSH:9.1"), "U")
		Set tTriggerEvent = $ZConvert(tHL7Request.GetValueAt("MSH:9.2"), "U")
		Set tMessageType = tMessageCode_"^"_tTriggerEvent
		If tMessageType="QBP^Q22" {
			If tHL7Request.GetValueAt("DSC:1")="" {
				Set tSC=..QueryRequestv2(tHL7Request, .pResponse)
				Set tEnvelopeFromService = tHL7Request.Envelope
				Set tHL7Request.Envelope = ""
				Set tFromHost = $Piece($Piece(tEnvelopeFromService,"<-",2),":",1)
				Set tEnvelopeToAudit = ""
				Set tEnvelopeToAudit = tEnvelopeToAudit_"|ToHost="_$system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName())_"|"
				Set tEnvelopeToAudit = tEnvelopeToAudit_"|FromHost="_tFromHost_"|"
				Set tHL7Request.Envelope = tEnvelopeToAudit
				Do $$$ATNAEvent("PDQv2Supplier", tHL7Request, pResponse, tSC)
			} Else {
				Set tSC=..ContinuationRequestv2(tHL7Request, .pResponse)
			}
		} ElseIf tMessageType="QCN^J01" {
			Set tSC=..CancelRequestv2(tHL7Request, .pResponse)
		} Else {
			Do ..Errors.logError("200","E","Unsupported HL7 Message Type : "_tMessageType)
		}

		If ..Errors.Errors.Count() Set tSC = ..HL7ErrorResponse(tHL7Request, .pResponse)
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $Data(pResponse),$IsObject(pResponse) $$$HSTRACE("HL7 Response to service", "pResponse", pResponse.OutputToString())
	
	Quit tSC
}

Method ProcessXMLMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		
		If pRequest.Name=$$$PDQv3QueryRequest {
			Set tSC=..QueryRequestv3(pRequest,.pResponse)
			Do $$$ATNAEvent("PDQv3Supplier",pRequest,pResponse,tSC)
		} ElseIf pRequest.Name=$$$PDQv3ContinueRequest {
			Set tSC=..ContinuationRequestv3(pRequest,.pResponse)
		} ElseIf pRequest.Name=$$$PDQv3CancelRequest {
			Set tSC=..CancelRequestv3(pRequest,.pResponse)
		} Else {
			$$$LOGERROR("Unknown Request")
		} 
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method QueryRequestv2(pHL7Request As EnsLib.HL7.Message, Output pHL7Response As EnsLib.HL7.Message) As %Status
{
	Try {
		Set tSC = ..HL7ToPatientSearchRequest(pHL7Request, .tSearchRequest)
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
		$$$HSTRACE("HS Message from HL7 Request", "tSearchRequest", tSearchRequest)

		#; the tQueueObject is needed to process the response - even in error
		Set tQueueObject = ##class(HS.IHE.PDQ.QueryQueue).%New()
		Set tQueueObject.InitialHL7Request=pHL7Request
		Set tQueueObject.InitialRequestDateTime = $ZDateTime($Horolog,3)

		Set tSC = ..SendAndFilter(tSearchRequest, .tQueueObject, "v2")
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
		#; create PDQ Response
		Set tSC = ..CreateQueryResponsev2(tQueueObject, .pHL7Response)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("207","E",$system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

Method QueryRequestv3(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		#; the tQueueObject is needed to process the response - even in error
		Set tQueueObject = ##class(HS.IHE.PDQ.QueryQueue).%New()
		Set tQueueObject.InitialRequest=pRequest
		Set tQueueObject.InitialRequestDateTime = $ZDateTime($Horolog,3)
		
		#dim tSearchResponse as HS.Message.PatientSearchResponse
		Kill tXSLArguments,tTarget
		Do ##class(HS.Types.RequestInfo).GetUserInfo(pRequest, .tUserName, .tUserRoles)   ///SAML/User Auth
		Set tXSLArguments("userName")		= $zcvt(tUserName,"O","XML")
		Set tXSLArguments("userRoles")		= tUserRoles
		Set tXSLArguments("gatewayName")	= $Namespace
		
		#dim pSearchRequest As HS.Message.PatientSearchRequest
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream,..TransformPDQToPatientSearch /* "IHE/PDQ/Version1/PRPAIN201305UVToPatientSearchRequest.xsl" */, .pSearchRequest,.tXSLArguments,"HS.Message.PatientSearchRequest","PatientSearchRequest")
		$$$HSTRACEENDCALL
		If $$$ISERR(tSC) Do ..Errors.logError("204","Error","Unable to transform request:"_$system.Status.GetErrorText(tSC)) Quit
		$$$HSTRACE("Transform SearchRequest","201305,SearchRequest,tSC",pRequest.ContentStream,pSearchRequest,tSC)
		Set:..ApplyConsent pSearchRequest.SearchMode="PIXPDQ_c"
		#; copy saml user information to the search request
		Do ##class(HS.Types.RequestInfo).XMLMessageToRequestInfo(pRequest,pSearchRequest)  /// SAML/User auth
		
		Set tSC = ..SendAndFilter(pSearchRequest, .tQueueObject, "v3")
		If $$$ISERR(tSC) Quit
		
		#; create PDQ Response
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name=$$$PDQv3QueryResponse
		Set tSC = ..CreateQueryResponsev3(tQueueObject,pResponse)
		$$$HSTRACE("response","pResponse",pResponse)
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC)) 	
	}
	Quit tSC
}

Method ContinuationRequestv2(pHL7Request As EnsLib.HL7.Message, Output pHL7Response As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..HL7ToPatientSearchRequest(pHL7Request, .tContinueRequest)
		If $$$ISERR(tSC) Quit
		
		$$$HSTRACE("HS Message from HL7 Request", "tContinueRequest", tContinueRequest)

		Set tQueryID=tContinueRequest.AdditionalInfo.GetAt("QueryID")
		Set tQueryQuantity=tContinueRequest.AdditionalInfo.GetAt("QueryQuantity")
		Set tStartResultNumber=tContinueRequest.AdditionalInfo.GetAt("StartResultNumber")
		
		Set tSC = ..GetQueryQueueForContinue(pHL7Request, tQueryID, tQueryQuantity, tStartResultNumber, .tQueueObject)
		If $$$ISERR(tSC) Quit
		
		#; create PDQ Response
		Set tSC = ..CreateQueryResponsev2(tQueueObject, .pHL7Response)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("207","E",$system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

Method ContinuationRequestv3(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream,..TransformContinuationRequest /*"IHE/PDQ/Version1/PDQContinueToXMLMessage.xsl"*/, .tContinueRequest, .tXSLArguments,"HS.Message.XMLMessage")
		$$$HSTRACEENDCALL
		
		Quit:$$$ISERR(tSC)
		Set tQueryID=tContinueRequest.AdditionalInfo.GetAt("QueryID")_"::"_tContinueRequest.AdditionalInfo.GetAt("QueryExtension")
		Set tQueryQuantity=tContinueRequest.AdditionalInfo.GetAt("QueryQuantity")
		Set tStartResultNumber=tContinueRequest.AdditionalInfo.GetAt("StartResultNumber")
		
		Set tSC = ..GetQueryQueueForContinue(pRequest, tQueryID, tQueryQuantity, tStartResultNumber, .tQueueObject)
		If $$$ISERR(tSC) Quit

		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name=$$$PDQv3QueryResponse
		Set tSC=..CreateQueryResponsev3(tQueueObject, pResponse, pRequest)
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// GetQueryQueueForContinue is called by ContinuationRequestv2 and
/// ContinuationRequestv3.  It does the common logic for finding and
/// updating the QueryQueue object for the specified QueryID.
Method GetQueryQueueForContinue(pRequest As %Library.Persistent, pQueryID As %String, pQueryQuantity As %String, pStartResultNumber As %String, Output pQueueObject As HS.IHE.PDQ.QueryQueue) As %Status
{
	#dim eException As %Exception.AbstractException
	Set tSC = $$$OK
	try {
		Set pQueueObject = ##class(HS.IHE.PDQ.QueryQueue).%OpenId(pQueryID)
		If '$IsObject(pQueueObject) Set tSC=$$$ERROR($$$GeneralError,"Query ID: "_pQueryID_" not found") Quit
		If pRequest.%IsA("EnsLib.HL7.Message") Set pQueueObject.InitialHL7Request=pRequest
		//Set tSearchResponse=pQueueObject.SearchResponse
		//Set tSearchRequest=pQueueObject.SearchRequest
		Set tInitialQuantity=pQueueObject.InitialQuantity
		If pQueryQuantity]"" Set (tInitialQuantity,pQueueObject.InitialQuantity)=pQueryQuantity
		
		If pStartResultNumber]"" Set pQueueObject.QuantityReturned=pStartResultNumber-1
		
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method CancelRequestv2(pHL7Request As EnsLib.HL7.Message, Output pHL7Response As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..HL7ToCancelRequest(pHL7Request, .tCancelRequest)
		If $$$ISERR(tSC) Quit
		
		$$$HSTRACE("HS Message from HL7 Request", "tCancelRequest", tCancelRequest)

		Set tQueryID = tCancelRequest.AdditionalInfo.GetAt("CancelQuery")
		
		Set tSC = ##class(HS.IHE.PDQ.QueryQueue).%DeleteId(tQueryID)
		$$$ThrowOnError(tSC)
		
		#; Instantiate target message
		Set pHL7Response = ##class(EnsLib.HL7.Message).%New()
		
		#; IHE requires 2.5, so force the document type assignment		
		Set pHL7Response.DocType = "2.5:ACK"
		
		#; Force original request's document type to be QCN_J01
		Set pHL7Request.DocType = "2.5:QCN_J01"
		
		#; Message Header (MSH)
		Do pHL7Response.SetValueAt("ACK", "MSH:9.1")
		Do pHL7Response.SetValueAt("J01", "MSH:9.2")
		Do pHL7Response.SetValueAt("ACK", "MSH:9.3")
		Do pHL7Response.SetValueAt(pHL7Request.GetValueAt("MSH:5.1"), "MSH:3.1") // Sending Application
		Do pHL7Response.SetValueAt(pHL7Request.GetValueAt("MSH:6.1"), "MSH:4.1") // Sending Facility
		Do pHL7Response.SetValueAt(pHL7Request.GetValueAt("MSH:3.1"), "MSH:5.1") // Receiving Application
		Do pHL7Response.SetValueAt(pHL7Request.GetValueAt("MSH:4.1"), "MSH:6.1") // Receiving Facility
		Do pHL7Response.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pHL7Response.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pHL7Response.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pHL7Response.SetValueAt("2.5", "MSH:12")
		
		#; Message Acknowledgment (MSA)
		Do pHL7Response.SetValueAt("AA", "MSA:1")
		Do pHL7Response.SetValueAt(pHL7Request.GetValueAt("MSH:10"), "MSA:2")
				
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("207","E",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method CancelRequestv3(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream,..TransformCancellationRequest /*"IHE/PDQ/Version1/PDQCancelToXMLMessage.xsl"*/,.tContinueRequest,.tXSLArguments,"HS.Message.XMLMessage") 
		$$$HSTRACEENDCALL
		Quit:$$$ISERR(tSC)
		Set tQueryID=tContinueRequest.AdditionalInfo.GetAt("QueryID")_"::"_tContinueRequest.AdditionalInfo.GetAt("QueryExtension")
		Set tSC = ##class(HS.IHE.PDQ.QueryQueue).%DeleteId(tQueryID)
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name=$$$PDQv3CancelResponse
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()
		Set tXSLArguments("typeCode") = $S(..Errors.Errors.Count():"CE",1:"CA")
		
		Set tOutput = ##class(%Stream.GlobalCharacter).%New()
		Do tOutput.Write("<root>")
		#; Need the current request for its message id and extension.
		Do tOutput.Write("<request>")
		Do pRequest.ContentStream.Rewind()
		While 'pRequest.ContentStream.AtEnd {
			Do tOutput.Write(pRequest.ContentStream.Read())
		}
		Do tOutput.Write("</request>")
		Do tOutput.Write("</root>")
		Do tOutput.Rewind()

		$$$HSTRACE("toutput","tOutput",tOutput)
		Do tOutput.Rewind()

		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tOutput,..TransformCancellationResponse /* "IHE/PDQ/Version1/MCCI000002UV.xsl" */,.tResponse, .tXSLArguments)
		$$$HSTRACEENDCALL
		Quit:$$$ISERR(tSC)
		Do pResponse.ContentStream.CopyFrom(tResponse)
		Do pResponse.ContentStream.Rewind()
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method CreateQueryResponsev2(pQueueObject As HS.IHE.PDQ.QueryQueue, Output pResponse As EnsLib.HL7.Message) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set tQueryID = pQueueObject.QueryID
		
		Set tSC = ..CreateQuerySearchResponse(.pQueueObject, .tInitQuantity, .tOutputResults, .tRemaining, .tQuantity)
		$$$ThrowOnError(tSC)
		
		Set tContinue=0 If tRemaining'=0 Set tContinue = tQueryID_":"_(pQueueObject.QuantityReturned+1)
		
		Set tSC = ..PatientSearchResponseToHL7(tOutputResults, .pResponse, pQueueObject.InitialHL7Request, tContinue)
		
		If tRemaining'=0 {
			Set tSC=pQueueObject.%Save()
			// Try to purge the QueryQueue. If we fail, it's not fatal to the query, just log a warning.
			Set ttSC = ##class(HS.IHE.PDQ.QueryQueue).PurgeQueryQueue(24)
			If $$$ISERR(ttSC) $$$LOGWARNING("Error purging QueryQueue - "_$system.Status.GetErrorText(ttSC))
		}

	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("204","E",$system.Status.GetErrorText(tSC)) 	
	}
	Quit tSC
}

Method CreateQueryResponsev3(pQueueObject As HS.IHE.PDQ.QueryQueue, Output pResponse As HS.Message.XMLMessage, pRequest As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set tQueryID = pQueueObject.QueryID
		Set tSC = ..CreateQuerySearchResponse(.pQueueObject, .tInitQuantity, .tOutputResults, .tRemaining, .tQuantity)
		$$$ThrowOnError(tSC)

		Set tSC = tOutputResults.XMLExportToStream(.tSearchResponseStream) Quit:$$$ISERR(tSC)
		
		#; HomeCommunityOID is for XCPD queries
		Set tXSLArguments("homeCommunityOID") = $$$HomeCommunityOID
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()
		Set tXSLArguments("queryStatus") = $S(..Errors.Errors.Count():"AE",tQuantity=0:"NF",1:"OK")
		Set tXSLArguments("resultQuantity") = tQuantity	
		Set tXSLArguments("resultQuantityInitial") = tInitQuantity
		Set tXSLArguments("resultQuantityRemaining") = tRemaining
		Set tXSLArguments("ackTypeCode") = $S(..Errors.Errors.Count():"AE",1:"AA")
		$$$HSTRACE("building response input")

		Set tOutput = ##class(%Stream.GlobalCharacter).%New()
		Do tOutput.Write("<root>")
		Do ..Errors.XMLExportToString(.tErrorString)
		Do tOutput.Write(tErrorString)
		#; If there are errors there may not
		If '..Errors.Errors.Count() {
			While 'tSearchResponseStream.AtEnd {
				Do tOutput.Write(tSearchResponseStream.Read())
			}
		}
		#; Need the current request for its message id and extension.
		If $IsObject($Get(pRequest)) {
			Do tOutput.Write("<request>")
			Do pRequest.ContentStream.Rewind()
			While 'pRequest.ContentStream.AtEnd {
				Do tOutput.Write(pRequest.ContentStream.Read())
			}
			Do tOutput.Write("</request>")
		} Else {
			Do tOutput.Write("<request>")
			Do pQueueObject.InitialRequest.ContentStream.Rewind()
			While 'pQueueObject.InitialRequest.ContentStream.AtEnd {
				Do tOutput.Write(pQueueObject.InitialRequest.ContentStream.Read())
			}
			Do tOutput.Write("</request>")
		}
		Do tOutput.Write("<originalRequest>")
		Do pQueueObject.InitialRequest.ContentStream.Rewind()
		While 'pQueueObject.InitialRequest.ContentStream.AtEnd {
			Do tOutput.Write(pQueueObject.InitialRequest.ContentStream.Read())
		}
		Do tOutput.Write("</originalRequest></root>")
		Do tOutput.Rewind()

		$$$HSTRACE("toutput","tOutput",tOutput)
		Do tOutput.Rewind()
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tOutput,..TransformPatientSearchResponseToPDQ /* "IHE/PDQ/Version1/PatientSearchResponseToPRPAIN201306UV.xsl" */,.tPDQResponse, .tXSLArguments) 
		$$$HSTRACEENDCALL
		Quit:$$$ISERR(tSC)
		$$$HSTRACE("response","tSearchResponseStream,tSC,tPDQResponse",tSearchResponseStream,tSC,tPDQResponse)
		Do pResponse.ContentStream.CopyFrom(tPDQResponse)
		Do pResponse.ContentStream.Rewind()

		If tRemaining'=0 {
			Set tSC=pQueueObject.%Save()
			// Try to purge the QueryQueue. If we fail, it's not fatal to the query, just log a warning.
			Set ttSC = ##class(HS.IHE.PDQ.QueryQueue).PurgeQueryQueue(24)
			If $$$ISERR(ttSC) $$$LOGWARNING("Error purging QueryQueue - "_$system.Status.GetErrorText(ttSC))
		}

	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC)) 	
	}
	Quit tSC
}

/// CreateQuerySearchResponse is called by CreateQueryResponsev2 and
/// CreateQueryResponsev3.  It creates the PatientSearchResponse
/// based on the contents of the QueryQueue object.  It also calculates
/// some values (pInitQuantity, pRemaining, pQuantity) and returns them.
Method CreateQuerySearchResponse(ByRef pQueueObject As HS.IHE.PDQ.QueryQueue, ByRef pInitQuantity As %String, Output pPatientSearchResponse As HS.Message.PatientSearchResponse, Output pRemaining As %String, Output pQuantity As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		;# save the new result set
		//Set tSearchRequest = pQueueObject.SearchRequest
		Set tQuantityReturned = pQueueObject.QuantityReturned
		Set pInitQuantity = pQueueObject.InitialQuantity
		//Set tQueryID= pQueueObject.QueryID
		//Set tMinRank=pQueueObject.MinRank
		Set tResults=pQueueObject.SearchResponse.Results
		Set pPatientSearchResponse = ##class(HS.Message.PatientSearchResponse).%New()
		#; potentially there was an error and there may not be results
		If '$IsObject(tResults) Set tResults = pPatientSearchResponse.Results
		Set pQuantity=tResults.Count(),pRemaining=0,tCount=0
		Set:pInitQuantity="" pInitQuantity=999
		If pInitQuantity {
			If pInitQuantity>pQuantity Set pInitQuantity=pQuantity
			For tIdx=(tQuantityReturned+1):1:(tQuantityReturned+pInitQuantity) {
				Set tResult=tResults.GetAt(tIdx)
				If '$isObject(tResult) Continue
				Do pPatientSearchResponse.Results.Insert(tResult)
				Set tCount=tCount+1
			}
		}
		Set pQueueObject.QuantityReturned=pQueueObject.QuantityReturned+tCount
		Set pRemaining=pQuantity-pQueueObject.QuantityReturned
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method HL7ToPatientSearchRequest(pSource As EnsLib.HL7.Message, ByRef pTarget As HS.Message.PatientSearchRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; IHE requires 2.5, so force the document type assignment		
		Set pSource.DocType = "2.5:QBP_Q21"
		
		#; Instantiate target message
		Set pTarget = ##class(HS.Message.PatientSearchRequest).%New()
		
		#; Establish request as a PIX/PDQ request
		Set pTarget.SearchMode = $S(..ApplyConsent:"PIXPDQ_c",1:"PIXPDQ")
		Set tIdentifier = ""
		Set tAssigningAuthorityCode = ""
		Set tAssigningAuthorityOID = ""
		Set tIdentifierType = ""
		Set tStreet = ""
		Set tCity = ""
		Set tState = ""
		Set tZip = ""
		Set tHomeTelephone = ""
		
		#; TODO: Do we need to implement support for multiple PID:3 identifiers?
		Set tCount = 0
		For i = 1:1:pSource.GetValueAt("QPD:3(*)") {
			Set tField = pSource.GetValueAt("QPD:3("_i_").1")
			Set tValue = pSource.GetValueAt("QPD:3("_i_").2")
			If tField=""!(tValue="") continue
			If $i(tCount)
			If tField="@PID.3.1" Set tIdentifier = tValue continue
			If tField="@PID.3.4.1" Set tAssigningAuthorityCode = tValue continue
			If tField="@PID.3.4.2" Set tAssigningAuthorityOID = tValue continue
			If tField="@PID.3.5" Set tIdentifierType = tValue continue
			If tField="@PID.5.1.1" {
				If tValue="*" continue
				If $Extract(tValue,*)="*" {
					Set tValue=$Extract(tValue,1,*-1)
					Do pTarget.AdditionalInfo.SetAt("SRCH","nameSRCH")
				}
				Set pTarget.LastName = tValue
				continue
			}
			If tField="@PID.5.2" Set pTarget.FirstName = tValue continue
			If tField="@PID.5.3" Set pTarget.MiddleName = tValue continue
			If tField="@PID.7.1" Set pTarget.DOB = $ZDateH(tValue,8) continue
			If tField="@PID.8" Set pTarget.Sex = tValue continue
			If tField="@PID.11.1"!(tField="@PID.11.1.1") Set tStreet = tValue continue
			If tField="@PID.11.3" Set tCity = tValue continue
			If tField="@PID.11.4" Set tState = tValue continue
			If tField="@PID.11.5" Set tZip = tValue continue
			If tField="@PID.18.1" Do pTarget.AdditionalInfo.SetAt(tValue, "AccountNumber") continue
			If tField="@PID.6.1" Set pTarget.MothersMaidenSurname = tValue continue
			If tField="@PID.13.1" {
				Set tTelObj = ##class(HS.Types.Telecom).%New()
				Set tTelObj.PhoneNumber = tValue
				Set tTelObj.Use = "HP"
				Set tSC = pTarget.Telecoms.Insert(tTelObj)
				If $$$ISERR(tSC) Quit
			}
		}
		If $$$ISERR(tSC) Quit
		If tCount=0 Do ..Errors.logError("204","E","PDQ search criteria missing","QPD:3") Quit
		
		If tStreet'=""!(tCity'="")!(tState'="")!(tZip'="") {
			Set pTarget.Street = tStreet
			Set pTarget.City = tCity
			Set pTarget.State = tState
			Set pTarget.Zip = tZip
			Set tAddrObj = ##class(HS.Types.Address).%New()
			Set tAddrObj.StreetLine = tStreet
			Set tAddrObj.City = tCity
			Set tAddrObj.State = tState
			Set tAddrObj.PostalCode = tZip
			Set tSC = pTarget.Addresses.Insert(tAddrObj)
			If $$$ISERR(tSC) Quit
		}
		
		Set tPath = "QPD:3"
		Set tType = "Assigning Authority"
		
		Set tCodeFromRegistry = ##class(HS.Data.OIDMap).GetCodeForOID(tAssigningAuthorityOID, "")
		
		If (tAssigningAuthorityCode'="")&&(tAssigningAuthorityOID'="") {
			If tCodeFromRegistry="" {
				Do ..Errors.logError("204","E","Unknown "_tType_" "_tAssigningAuthorityOID, tPath_".4.2")
			} Else {
				If ..MatchCodeWithOID {
					If $ZConvert(tCodeFromRegistry,"U")=$ZConvert(tAssigningAuthorityCode,"U") {
						Set tAssigningAuthorityCode = tCodeFromRegistry
					} Else {
						Do ..Errors.logError("204","E","Unknown "_tType_" "_tAssigningAuthorityCode, tPath_".4.1")
					}
				} Else {
					Set tAssigningAuthorityCode = tCodeFromRegistry
				}
			}
			
		} ElseIf (tAssigningAuthorityCode="")&&(tAssigningAuthorityOID'="") {
			If tCodeFromRegistry="" {
				Do ..Errors.logError("204","E","Unknown "_tType_" "_tAssigningAuthorityOID, tPath_".4.2")
			} ElseIf tAssigningAuthorityCode="" {
				Set tAssigningAuthorityCode = tCodeFromRegistry
			}
			
		} ElseIf (tAssigningAuthorityCode'="")&&(tAssigningAuthorityOID="") {
			Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode, "")
			If tAssigningAuthorityOID="" {
				Do ..Errors.logError("101","E","Unknown "_tType_" "_tAssigningAuthorityCode, tPath_".4.1")
			}
		}
		If ..Errors.Errors.Count() Quit
		
		If tAssigningAuthorityOID'="",tIdentifier'="" {
			Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain)
			If tIdentifierType="" {
				If tAssigningAuthorityOID=tAffinityDomainOID {
					Set tIdentifierType = "PI"
				} Else {
					Set tIdentifierType = "MR"
				}
			}
			#; TODO: LivingSubjectIDs not really implemented, but just leave this code as is anyway.
			If tIdentifierType="PI" {
				Set pTarget.MPIID = tIdentifier
			} ElseIf tIdentifierType="MR" {
				Set pTarget.MRN = tIdentifier,pTarget.AssigningAuthority=tAssigningAuthorityCode
			} Else {
				Do pTarget.AdditionalInfo.SetAt("","livingSubjectId_"_tAssigningAuthorityCode_"_"_tIdentifier)
				Do pTarget.AdditionalInfo.SetAt("","LivingSubjectIDs")
			}
		} ElseIf tAssigningAuthorityOID="",tIdentifier'="" {
			Set pTarget.MRN = tIdentifier
		}
		
		#; Target domain(s) to filter the response by.
		Set tDomainFound = 0
		Set tQPDDomainsField = 8
		For i = 1:1:pSource.GetValueAt("QPD:"_tQPDDomainsField_"(*)") {
			Set tFacilityCode = pSource.GetValueAt("QPD:"_tQPDDomainsField_"("_i_").4.1")
			Set tFacilityOID = pSource.GetValueAt("QPD:"_tQPDDomainsField_"("_i_").4.2")
			If tFacilityCode="",tFacilityOID="" Quit
			$$$HSTRACE("Evaluating scoping organization","tFacilityOID,tFacilityCode",tFacilityOID,tFacilityCode)
			Do ..ValidateOIDAndCode(pSource, "QPD:"_tQPDDomainsField_"("_i_")", ..MatchCodeWithOID, "Facility", .tFacilityCode, .tFacilityOID)
			If ..Errors.Errors.Count() Quit
			Do pTarget.AdditionalInfo.SetAt("","scopingOrganization_"_tFacilityCode)
			Set tDomainFound = 1
		}
		If ..Errors.Errors.Count() Quit
		If tDomainFound=1 Do pTarget.AdditionalInfo.SetAt("","ScopingOrganizations")
		
		#; Resolve and capture Sender Device OID
		Set tSendingDeviceOID = $Case(pSource.GetValueAt("MSH:3.1") '= "", 1:##class(HS.Data.OIDMap).OIDForType(pSource.GetValueAt("MSH:3.1"), "Device"), :"")
		If (tSendingDeviceOID '= "") { Do pTarget.AdditionalInfo.SetAt(tSendingDeviceOID, "SenderOID") }
		
		#; Response Control Parameter (RCP)
		#; RCP:1 Query Priority is always I (Immediate)
		#; RCP:2.1 Quantity Limited Request - Number
		#; RCP:2.2 Quantity Limited Request - Units - always RD (Records)
		Set tRCP21 = +pSource.GetValueAt("RCP:2.1")
		If tRCP21>0 Do pTarget.AdditionalInfo.SetAt(tRCP21,"InitialQuantity")
		
		#; Continuation Pointer (DSC)
		Set tDSC1 = pSource.GetValueAt("DSC:1")
		If tDSC1'="" {
			Do pTarget.AdditionalInfo.SetAt(tDSC1,"ContinuationPointer")
			Do pTarget.AdditionalInfo.SetAt($Piece(tDSC1,":",1),"QueryID")
			Do pTarget.AdditionalInfo.SetAt($Piece(tDSC1,":",2),"StartResultNumber")
			Do pTarget.AdditionalInfo.SetAt(tRCP21,"QueryQuantity")
		} Else {
			Do pTarget.AdditionalInfo.SetAt(pSource.GetValueAt("QPD:2"),"QueryID")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError(207,"E",$system.Status.GetErrorText(tSC))
	}

	Quit tSC
}

Method HL7ToCancelRequest(pSource As EnsLib.HL7.Message, ByRef pTarget As HS.Message.PatientSearchRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; IHE requires 2.5, so force the document type assignment		
		Set pSource.DocType = "2.5:QCN_J01"
		
		#; Instantiate target message
		Set pTarget = ##class(HS.Message.PatientSearchRequest).%New()
		
		Do pTarget.AdditionalInfo.SetAt($Piece(pSource.GetValueAt("QID:1"),":",1),"CancelQuery")
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError(207,"E",$system.Status.GetErrorText(tSC))
	}

	Quit tSC
}

Method PatientSearchResponseToHL7(pSource As HS.Message.PatientSearchResponse, ByRef pTarget As EnsLib.HL7.Message, pOriginalRequest As EnsLib.HL7.Message, pContinue As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		
		#; IHE requires 2.5, so force the document type assignment
		#; On Cache/Ensemble 2014.1 and later, DocType should be
		#; "2.5:RSP_K22". Otherwise it should be "2.5:RSP_K21".
		If $system.Version.GetMajor()<2014 {
			Set pTarget.DocType = "2.5:RSP_K21"
		} Else {
			Set pTarget.DocType = "2.5:RSP_K22"
		}
		
		#; Force original request's document type to be QBP_Q21 (which is used by QBP_Q22)
		Set pOriginalRequest.DocType = "2.5:QBP_Q21"
		
		#; Message Header (MSH)
		Do pTarget.SetValueAt("RSP", "MSH:9.1")
		Do pTarget.SetValueAt("K22", "MSH:9.2")
		#; Message Type Message Structure should always be RSP_K21.
		Do pTarget.SetValueAt("RSP_K21", "MSH:9.3")
		
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:5.1"), "MSH:3.1") // Sending Application
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:6.1"), "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:3.1"), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:4.1"), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pTarget.SetValueAt("2.5", "MSH:12")
		
		#; Message Acknowledgment (MSA) and Query Acknowledgment (QAK)
		If pSource.Results.Count() {
			Do pTarget.SetValueAt("AA", "MSA:1")
			Do pTarget.SetValueAt("OK", "QAK:2")
		}
		Else {
			Do pTarget.SetValueAt("AA", "MSA:1")
			Do pTarget.SetValueAt("NF", "QAK:2")
		}
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("QPD:2"), "QAK:1")
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:10"), "MSA:2")
		
		#; Query Parameter Definition (QPD)
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("QPD"), "QPD")
		
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain)
		
		#dim tMatch As HS.Message.IHE.PatientSearchMatch
		
		#; PID Segments - One PID segment per patient, with all identifiers in PID:3
		If pSource.Results.Count() {
			For i = 1:1:pSource.Results.Count() {
				Do pTarget.SetValueAt(i, "PIDgrp("_i_").PID:1")
				Set tMatch = pSource.Results.GetAt(i)
				Set tPatientIdentifierNo = 0
				If tMatch.MPIID'="" {
					If $i(tPatientIdentifierNo)
					Do pTarget.SetValueAt(tMatch.MPIID, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").1")
					Do pTarget.SetValueAt(..AffinityDomain, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.1")
					Do pTarget.SetValueAt(tAffinityDomainOID, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.2")
					Do pTarget.SetValueAt("ISO", "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.3")
					Do pTarget.SetValueAt("PI", "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").5")
				}
				For j = 1:1:tMatch.IDs.Count() {
					Set tIdentifier = tMatch.IDs.GetAt(j).MRN
					Set tAssigningAuthorityCode = tMatch.IDs.GetAt(j).AssigningAuthority
					Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode)
					Set tAssigningAuthorityType = tMatch.IDs.GetAt(j).AssigningAuthorityType
					If tAssigningAuthorityType="PAT" {
						If $i(tPatientIdentifierNo)
						Do pTarget.SetValueAt(tIdentifier, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").1")
						Do pTarget.SetValueAt(tAssigningAuthorityCode, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.1")
						Do pTarget.SetValueAt(tAssigningAuthorityOID, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.2")
						Do pTarget.SetValueAt("ISO", "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.3")
						Do pTarget.SetValueAt("MR", "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").5")
					}
					If tAssigningAuthorityType="IDENT",tAssigningAuthorityCode'="",'(tIdentifier=tMatch.MPIID&(tAssigningAuthorityOID=tAffinityDomainOID)) {
						If $i(tPatientIdentifierNo)
						Do pTarget.SetValueAt(tIdentifier, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").1")
						Do pTarget.SetValueAt(tAssigningAuthorityCode, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.1")
						Do pTarget.SetValueAt(tAssigningAuthorityOID, "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.2")
						Do pTarget.SetValueAt("ISO", "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").4.3")
						Do pTarget.SetValueAt("PI", "PIDgrp("_i_").PID:3("_tPatientIdentifierNo_").5")
					}
				}
				If tMatch.SSN'="" {
					Do pTarget.SetValueAt(tMatch.SSN,"PIDgrp("_i_").PID:19")
				}
				Do pTarget.SetValueAt(tMatch.LastName, "PIDgrp("_i_").PID:5.1.1")
				Do pTarget.SetValueAt(tMatch.FirstName, "PIDgrp("_i_").PID:5.2")
				Do pTarget.SetValueAt(tMatch.MiddleName, "PIDgrp("_i_").PID:5.3")
				Do pTarget.SetValueAt("L", "PIDgrp("_i_").PID:5.7")
				If tMatch.DOB'="" Do pTarget.SetValueAt($Translate($ZDateTime(tMatch.DOB,3),":- "), "PIDgrp("_i_").PID:7")
				Do pTarget.SetValueAt(tMatch.Sex, "PIDgrp("_i_").PID:8")
				
				#; Get Address from either the individual properties or
				#; from the first item in the Addresses collection.  The
				#; individual properties take precedence.
				Set tStreet = ""
				Set tCity = ""
				Set tState = ""
				Set tZip = ""
				Set tAddrObj = tMatch.Addresses.GetAt(1)
				If tMatch.Street'=""!(tMatch.City'="")!(tMatch.State'="")!(tMatch.Zip'="") {
					Set tStreet = tMatch.Street
					Set tCity = tMatch.City
					Set tState = tMatch.State
					Set tZip = tMatch.Zip
				} ElseIf $IsObject(tAddrObj) {
					Set tStreet = tAddrObj.StreetLine
					Set tCity = tAddrObj.City
					Set tState = tAddrObj.State
					Set tZip = tAddrObj.PostalCode
				}
				Do pTarget.SetValueAt(tStreet, "PIDgrp("_i_").PID:11.1")
				Do pTarget.SetValueAt(tCity, "PIDgrp("_i_").PID:11.3")
				Do pTarget.SetValueAt(tState, "PIDgrp("_i_").PID:11.4")
				Do pTarget.SetValueAt(tZip, "PIDgrp("_i_").PID:11.5")
				
				Do pTarget.SetValueAt(tMatch.AdditionalInfo.GetAt("AccountNumber"), "PIDgrp("_i_").PID:18")
			}
		}
		
		If pContinue'=0 {
			Do pTarget.SetValueAt(pContinue,"DSC:1")
			Do pTarget.SetValueAt("I","DSC:2")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError(207,"E",$system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

Method HL7ErrorResponse(pOriginalRequest As EnsLib.HL7.Message, Output pTarget As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		
		#; IHE requires 2.5, so force the document type assignment		
		Set pTarget.DocType = "2.5:RSP_K21"
		
		#; Force original request's document type to be QBP_Q21 (which is used by QBP_Q22)
		Set pOriginalRequest.DocType = "2.5:QBP_Q21"
		
		#; Message Header (MSH)
		Do pTarget.SetValueAt("RSP", "MSH:9.1")
		Do pTarget.SetValueAt("K22", "MSH:9.2")
		Do pTarget.SetValueAt("RSP_K21", "MSH:9.3")
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:5.1"), "MSH:3.1") // Sending Application
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:6.1"), "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:3.1"), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:4.1"), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pTarget.SetValueAt("2.5", "MSH:12")
		
		#; For now just use the first error to populate MSA and QAK.
		Set tErrorCode = ..Errors.Errors.GetAt(1).Code
		Set tAckCode = $Select(tErrorCode>199&(tErrorCode<204):"AR",1:"AE")
		
		#; Message Acknowledgment (MSA) and Query Acknowledgment (QAK)
		Do pTarget.SetValueAt(tAckCode, "MSA:1")
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("QPD:2"), "QAK:1")
		Do pTarget.SetValueAt(tAckCode, "QAK:2")
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:10"), "MSA:2")
		
		#; Query Parameter Definition (QPD)
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("QPD"), "QPD")
		
		/*
		For i = 1:1:..Errors.Errors.Count() {
			Set tLoc = ..Errors.Errors.GetAt(i).Location
			If tLoc'="" {
				Set tSegID = $Piece($Piece(tLoc,":",1),"(",1)
				Set tSegSQ = $Piece($Piece($Piece(tLoc,":",1),"(",2),")",1)
				If tSegSQ="" Set tSegSQ = 1
				Set tFldPos = $Piece($Piece(tLoc,":",2),"(",1)
				Set tFldRep = $Piece($Piece($Piece(tLoc,":",2),"(",2),")",1)
				Do pTarget.SetValueAt(tSegID, "ERR("_i_"):2.1")
				Do pTarget.SetValueAt(tSegSQ, "ERR("_i_"):2.2")
				Do pTarget.SetValueAt(tFldPos, "ERR("_i_"):2.3")
				Do pTarget.SetValueAt(tFldRep, "ERR("_i_"):2.4")
			}
			Do pTarget.SetValueAt(..Errors.Errors.GetAt(i).Code, "ERR("_i_"):3")
			Do pTarget.SetValueAt(..Errors.Errors.GetAt(i).Severity, "ERR("_i_"):4")
			Set tDesc = ..Errors.Errors.GetAt(i).Description
			If tDesc'="" {
				Set tDesc = $Translate(tDesc,pTarget.Separators,$Extract("          ",1,$Length(pTarget.Separators)))
				Do pTarget.SetValueAt(tDesc, "ERR("_i_"):5")
			}
		}
		*/
		
		#; The PDQv2 spec seems to imply that multiple ERR segments should
		#; be supported (ITI TF Vol2a Rev 9.0 page 161 paragraph 4265), but
		#; document type RSP_K21 supports only a single ERR segment.  So
		#; return only the first error in the collection.
		Set tLoc = ..Errors.Errors.GetAt(1).Location
		If tLoc'="" {
			Set tSegID = $Piece($Piece(tLoc,":",1),"(",1)
			Set tSegSQ = $Piece($Piece($Piece(tLoc,":",1),"(",2),")",1)
			If tSegSQ="" Set tSegSQ = 1
			Set tFldPos = $Piece($Piece(tLoc,":",2),"(",1)
			Set tFldRep = $Piece($Piece($Piece(tLoc,":",2),"(",2),")",1)
			If tFldRep="" Set tFldRep = 1
			Do pTarget.SetValueAt(tSegID, "ERR:2.1")
			Do pTarget.SetValueAt(tSegSQ, "ERR:2.2")
			Do pTarget.SetValueAt(tFldPos, "ERR:2.3")
			Do pTarget.SetValueAt(tFldRep, "ERR:2.4")
		}
		Do pTarget.SetValueAt(..Errors.Errors.GetAt(1).Code, "ERR:3")
		Do pTarget.SetValueAt(..Errors.Errors.GetAt(1).Severity, "ERR:4")
		Set tDesc = ..Errors.Errors.GetAt(1).Description
		If tDesc'="" {
			Set tDesc = $Translate(tDesc,pTarget.Separators,$Extract("      ",1,$Length(pTarget.Separators)))
			Do pTarget.SetValueAt(tDesc, "ERR:5")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ValidateOIDAndCode(pHL7Message, pPath As %String, pMatchCode As %Boolean, pType As %String, ByRef pCode As %String, ByRef pOID As %String)
{
	// ITI TF Vol2a Section 3.8.4.1.2.3
	// Assigning Authority may have code and oid and universal type,
	// or just code, or just oid and universal type.  If code and
	// oid are populated then they must reference the same thing.
	
	// HL7 NamespaceID
	Set pCode = pHL7Message.GetValueAt(pPath_".4.1")
	// HL7 UniversalID
	Set pOID = pHL7Message.GetValueAt(pPath_".4.2")
	// HL7 UniversalIDType
	Set tUIT = pHL7Message.GetValueAt(pPath_".4.3")
	
	Set tCodeFromRegistry = ##class(HS.Data.OIDMap).GetCodeForOID(pOID, "")
	
	If (pCode="")&&(pOID="") {
		Do ..Errors.logError("101","E","Missing "_pType, pPath_".4.2")
		
	} ElseIf (pCode'="")&&(pOID'="") {
		If tCodeFromRegistry="" {
			Do ..Errors.logError("204","E","Unknown "_pType_" "_pOID, pPath_".4.2")
		} Else {
			If pMatchCode {
				If $ZConvert(tCodeFromRegistry,"U")=$ZConvert(pCode,"U") {
					Set pCode = tCodeFromRegistry
				} Else {
					Do ..Errors.logError("204","E","Unknown "_pType_" "_pCode, pPath_".4.1")
				}
			} Else {
				Set pCode = tCodeFromRegistry
			}
		}
		If tUIT="" {
			Do ..Errors.logError("101","E","Missing Universal ID Type", pPath_".4.3")
		} ElseIf tUIT'="ISO" {
			Do ..Errors.logError("101","E","Invalid Universal ID Type", pPath_".4.3")
		}
		
	} ElseIf (pCode="")&&(pOID'="") {
		If tCodeFromRegistry="" {
			Do ..Errors.logError("204","E","Unknown "_pType_" "_pOID, pPath_".4.2")
		} ElseIf pCode="" {
			Set pCode = tCodeFromRegistry
		}
		If tUIT="" {
			Do ..Errors.logError("101","E","Missing Universal ID Type", pPath_".4.3")
		} ElseIf tUIT'="ISO" {
			Do ..Errors.logError("101","E","Invalid Universal ID Type", pPath_".4.3")
		}
		
	} ElseIf (pCode'="")&&(pOID="") {
		Set pOID = ##class(HS.Data.OIDMap).GetOIDForCode(pCode, "")
		If pOID="" {
			Do ..Errors.logError("101","E","Unknown "_pType_" "_pCode, pPath_".4.1")
		}
	}
	
	Quit
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>HomeCommunity</Value>
</Value>
<Value name="3">
<Value>AffinityDomain</Value>
</Value>
<Value name="4">
<Value>AffinityDomainIsMPIID</Value>
</Value>
<Value name="5">
<Value>ApplyConsent</Value>
</Value>
<Value name="6">
<Value>MPIOperations</Value>
</Value>
<Value name="7">
<Value>TransformPDQToPatientSearch</Value>
</Value>
<Value name="8">
<Value>TransformPatientSearchResponseToPDQ</Value>
</Value>
<Value name="9">
<Value>TransformContinuationRequest</Value>
</Value>
<Value name="10">
<Value>TransformCancellationRequest</Value>
</Value>
<Value name="11">
<Value>TransformCancellationResponse</Value>
</Value>
<Value name="12">
<Value>IHEVersion</Value>
</Value>
<Value name="13">
<Value>IHEExtension</Value>
</Value>
<Value name="14">
<Value>Transformer</Value>
</Value>
<Value name="15">
<Value>Errors</Value>
</Value>
<Value name="16">
<Value>ApplyRankMultiplier</Value>
</Value>
<Value name="17">
<Value>MatchCodeWithOID</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
