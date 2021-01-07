Include (HS.HC, HS.IHE.PIX, HS.IHE.ATNA)

/// 
/// The PIX Consumer is used in HealthShare to accept updates from the MPI matching engine
/// All other transactions should go through the PIX manager
Class HS.IHE.PIX.Consumer.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ ClassType = persistent, Inheritance = right ]
{

Parameter DOMAIN = "HS";

Property Errors As HS.Types.IHE.Errors;

Property IHEVersion As %Integer [ InitialExpression = 1 ];

/// If defined, sent the request to the MPI Operation (only called when there is a prior MPIID)
Property MPIOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.Hub.MPI.Manager" ];

/// Other hosts to notify such as the XDS registry (only called when there is a prior MPIID)
Property NotifyOthers As %String(MAXLEN = 1024);

/// Used in a testing environment allows setting of the AffinityDomain Code (which must be defined in the OID Registry) if not
/// set the value from ##class(HS.IHE.Util).GetAffinityDomain() is used
Property AffinityDomain As %String;

Property Transformer As HS.Util.XSLTTransformer;

Property PRPAINToUpdateTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/PIX/Version1/PRPAIN201302UVToIDUpdateNotificationRequest.xsl" ];

Property MCCITransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/PIX/Version1/MCCI000002UV.xsl" ];

/// When the assigning authority (AA) type is unknown, a lookup is done against the HealthShare Assigning Authority Registry <br>
/// to derive the AA type with the code. To mitigate the cases where a given AA code is used with multiple AA types, and hence <br>
/// unable to yield a definitive type, use this setting to specify a comma delimited list of AA types to <b>not</b> considered <br>
/// when deriving the AA code type.
Property ExcludeIdentifierTypes As %String [ InitialExpression = "DL,DN" ];

/// Will default to version of inbound message but can be overridden with this value
Property V2ResponseProcessingMode As %String;

/// Will default to version of inbound message but can be overridden with this value
Property V2ResponseVersion As %String;

Parameter SETTINGS = "-IHEVersion,MPIOperations:Basic:selector?size=40&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},-AffinityDomain,NotifyOthers:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},PRPAINToUpdateTransform, MCCITransform,ExcludeIdentifierTypes,V2ResponseProcessingMode:V2Response,V2ResponseVersion:V2Response";

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	If ..AffinityDomain="" Set ..AffinityDomain=$$$AffinityDomain
	Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
	
	Try {
		If pRequest.%IsA("HS.Message.IDUpdateNotificationRequest") {
			Set tSC = ..ProcessNotification(pRequest, .pResponse)
		} ElseIf pRequest.%IsA("EnsLib.HL7.Message") {
			Set tSC = ..ProcessHL7Message(pRequest, .pResponse)
		} ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			Set tSC = ..ProcessXMLMessage(pRequest, .pResponse)
		} Else {
			$$$LOGERROR("Unknown Request")
			Set tSC=$$$ERROR($$$GeneralError,"Unknown request")
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC)) 	
	}
	
	$$$HSTRACE("Errors","Errors",..Errors)
	If ..Errors.Errors.Count() {
		$$$HSTRACE("Errors","Errors",..Errors)
		Set tErrorText="",tWarningText=""
		For tIdx=1:1:..Errors.Errors.Count() {
			Set tError = ..Errors.Errors.GetAt(tIdx)
			If tError.Severity="Error"!(tError.Severity="E") {
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

/// Convert pRequest(HL7v2) into IDUpdateNotification
Method ProcessHL7Message(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("HL7 Request from service", "pRequest", pRequest.OutputToString())
				
		// Clone pRequest to tHL7Request so that changes are only applied to tHL7Request.
		Set tHL7Request = pRequest.%ConstructClone(1)
		
		Set tMessageType = $ZConvert(pRequest.GetValueAt("MSH:9.1")_"^"_pRequest.GetValueAt("MSH:9.2"),"U")
		If tMessageType="ADT^A43" {
			Set tAffinityDomainOID=$$$AffinityDomainOIDGet(..AffinityDomain)
			Set tSourceOID = pRequest.GetValueAt("MSH:3")
			If '##class(HS.Data.OIDMap).GetCodeForOID(tSourceOID)="" Do ..Errors.logError("200","E","Unknown OID : "_tSourceOID) 
			Set tRequest = ##class(HS.Message.IDUpdateNotificationRequest).%New()
			Set tNewPID = pRequest.GetValueAt("PIDgrp(1).PID:3(1)") 
			Set tAD = $p($p(tNewPID,"^^^",2),"&",2)
			If tAD'=tAffinityDomainOID Do ..Errors.logError("200","E","Incorrect affinity domain : "_tAD)
			Set tRequest.MPIID = $p(tNewPID,"^^^")
			
			Set tOldPID = pRequest.GetValueAt("PIDgrp(1).MRG:1(1)") 
			Set tAD = $p($p(tOldPID,"^^^",2),"&",2)
			If tAD'=tAffinityDomainOID Do ..Errors.logError("200","E","Incorrect affinity domain : "_tAD) Quit
			Set tRequest.PriorMPIID = $p(tOldPID,"^^^")

			Set tIdentifier = ##class(HS.Types.Identifier).%New()
			Do tRequest.Identifiers.Insert(tIdentifier)
			Set tLocalID = pRequest.GetValueAt("PIDgrp(1).PID:3(2)") 
			Set tIdentifier.Root=##class(HS.Data.OIDMap).GetCodeForOID($p($p(tLocalID,"^^^",2),"&",2))
			Set tIdentifier.Extension=$p(tLocalID,"^^^")

			Set tOldLocalID = pRequest.GetValueAt("PIDgrp(1).MRG:1(2)")
			If (tOldLocalID'=""){
				Set tPriorIdentifier = ##class(HS.Types.Identifier).%New()
				Do tRequest.PriorIdentifiers.Insert(tPriorIdentifier)
				Set tPriorIdentifier.Root=##class(HS.Data.OIDMap).GetCodeForOID($p($p(tOldLocalID,"^^^",2),"&",2))
				Set tPriorIdentifier.Extension=$p(tOldLocalID,"^^^")
			}

			Do tRequest.AdditionalInfo.SetAt(tSourceOID,"SourceOID")
			Do tRequest.AdditionalInfo.SetAt(1,"XPID")
			Set tSC = ..ProcessNotification(tRequest,.tResponse)
			If tResponse.ErrStatus]"",$$$ISERR(tResponse.ErrStatus) Do ..Errors.logError("200","E",$system.Status.GetErrorText(tResponse.ErrStatus))
			Set tSC = ..CreateXPIDATNA(pRequest,tRequest,tResponse,tSC) If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
			Set tSC = ..GeneralHL7Response( pRequest, .pResponse)
		} ElseIf tMessageType="ADT^A31" {
			Set tSC=..RevisedPatientv2(tHL7Request, .pResponse)
			Set tEnvelopeFromService = tHL7Request.Envelope
			Set tHL7Request.Envelope = ""
			Set tFromHost = $Piece($Piece(tEnvelopeFromService,"<-",2),":",1)
			Set tEnvelopeToAudit = ""
			Set tEnvelopeToAudit = tEnvelopeToAudit_"|ToHost="_$system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName())_"|"
			Set tEnvelopeToAudit = tEnvelopeToAudit_"|FromHost="_tFromHost_"|"
			Set tHL7Request.Envelope = tEnvelopeToAudit
			Set tSC=$$$ATNAEvent("PIXv2Consumer", tHL7Request, pResponse, tSC) If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
		} Else {
			Do ..Errors.logError("200","E","Unsupported HL7 Message Type : "_tMessageType)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("204","Error",$system.Status.GetErrorText(tSC)) 	
	}
	
	If ..Errors.Errors.Count() Set tSC = ..HL7ErrorResponse(tHL7Request, .pResponse)
	
	If $Data(pResponse),$IsObject(pResponse) $$$HSTRACE("HL7 Response to service", "pResponse", pResponse.OutputToString())
	
	Quit tSC
}

/// Create the ATNA audit message for XPID transaction
Method CreateXPIDATNA(pRequest As EnsLib.HL7.Message, pUpdateRequest As HS.Message.IDUpdateNotificationRequest, pResponse As HS.Message.AddUpdateHubResponse = "", pSC As %Status) As %Status
{
	Set tATNAMessage = ##class(HS.Message.XMLMessage).%New()
	Set tATNAMessage.Name=$$$XPIDNotificationRequest
	#; take the status from the Update, overwrite if okay and the general status is an error
	Set tStatus = $S($IsObject(pResponse):pResponse.ErrStatus,1:$$$OK)
	Set:$$$ISOK(tStatus) tStatus=pSC
	Do tATNAMessage.AdditionalInfo.SetAt(tStatus,"Status")
	Do tATNAMessage.AdditionalInfo.SetAt(pRequest.GetValueAt("MSH:3"),"SendingApplication")
	Do tATNAMessage.AdditionalInfo.SetAt(pRequest.GetValueAt("MSH:4"),"SendingFacility")
	Do tATNAMessage.AdditionalInfo.SetAt(pRequest.GetValueAt("MSH:5"),"ReceivingApplication")
	Do tATNAMessage.AdditionalInfo.SetAt(pRequest.GetValueAt("MSH:6"),"ReceivingFacility")
	Set tUserRoles = $Piece($Piece(pRequest.Envelope,"|UserRoles=",2),"|",1)
	Set:tUserRoles="" tUserRoles= $Roles
	Do tATNAMessage.AdditionalInfo.SetAt(tUserRoles,"UserRoles")
	Do tATNAMessage.AdditionalInfo.SetAt($UserName,"USER:UserID")
	Do tATNAMessage.AdditionalInfo.SetAt($Piece($Piece(pRequest.Envelope,"<-",2),":",1),"FromHost")
	Do tATNAMessage.AdditionalInfo.SetAt($system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName()),"ToHost")
	Do tATNAMessage.AdditionalInfo.SetAt(pRequest.GetValueAt("MSH:10"),"MessageID")
	Do tATNAMessage.AdditionalInfo.SetAt(pUpdateRequest.PriorMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO","PriorMPIID")
	Do tATNAMessage.AdditionalInfo.SetAt(pUpdateRequest.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO","MPIID")
	Set tIdentifier = pUpdateRequest.Identifiers.GetAt(1)
	Set tIdentifier = tIdentifier.Extension_"^^^&"_tIdentifier.Root_"&ISO"
	Do tATNAMessage.AdditionalInfo.SetAt(tIdentifier,"MRN")
	$$$HSTRACE("audit message","tATNAMessage",tATNAMessage)
	Set tSC= $$$ATNAEvent("XDSbRegistry",tATNAMessage,pResponse,pSC)
	$$$HSTRACE("audit","tSC",tSC)
	Quit $$$OK
}

Method ProcessXMLMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	$$$GetTransformer(..Transformer)	
	If pRequest.Name=$$$PIXv3ReviseRequest {
		Set tSC=..RevisedPatientv3(pRequest,.pResponse)
		Do $$$ATNAEvent("PIXv3Consumer",pRequest,pResponse,tSC)
	} Else {
		$$$LOGERROR("Unknown Request")
		Set tSC=$$$ERROR($$$GeneralError,"Unknown request")
	}
		
	Quit tSC
}

Method RevisedPatientv2(pHL7Request As EnsLib.HL7.Message, Output pHL7Response As EnsLib.HL7.Message) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set tSC = $$$OK
		#dim tRequest as HS.Message.IDUpdateNotificationRequest
		Set tSC = ..HL7ToIDUpdateNotificationRequest(pHL7Request, .tRequest)
		
		$$$HSTRACE("HS Message from HL7 Request", "tRequest", tRequest)
		
		Set tSC = ..ProcessNotification(tRequest,.tResponse)
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("PIXError","Error",$system.Status.GetErrorText(tSC)) 
	}
	Try {
		Set tSC = ..HL7Response(tRequest, .pHL7Response, pHL7Request)
		$$$ThrowOnError(tSC)
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("PIXError","Error",$system.Status.GetErrorText(tSC)) 
	}
	
	Quit tSC
}

Method RevisedPatientv3(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set tSC = $$$OK

		#dim tRequest as HS.Message.IDUpdateNotificationRequest
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream, ..PRPAINToUpdateTransform /*"IHE/PIX/Version1/PRPAIN201302UVToIDUpdateNotificationRequest.xsl"*/,.tRequest,.tXSLArguments,"HS.Message.IDUpdateNotificationRequest","IDUpdateNotificationRequest")
		$$$HSTRACEENDCALL
		
		Do ##class(HS.Types.RequestInfo).XMLMessageToRequestInfo(pRequest, tRequest) //copy SAML/User Auth
		IF $$$ISERR(tSC) || '$isObject(tRequest) {
			$$$LOGINFO("unknown request:"_pRequest.ContentStream.Read(320000))
			Do ..Errors.logError("PIXError","Error","Unknown request")
			Quit
		}
	 	$$$HSTRACE("Request","Stream,tRequest,tSC",pRequest.ContentStream,tRequest,tSC)
	
		#; Extract the MPI ID from the Identifiers collection and put
		#; it in the MPIID property.  Also set the Use property on
		#; Identifiers by looking up Root value in the Assigning
		#; Authority Registry.  If unable to discern the Assigning
		#; Authority IdentifierType then discard the Identifier.
		For tIdx = tRequest.Identifiers.Count():-1:1 {
			Set tIdentifierObj = tRequest.Identifiers.GetAt(tIdx)
			Set tRoot = tIdentifierObj.Root
			Set tSC = ##class(HS.IHE.Util).AAIdentifierTypeForCode(tRoot, .tAAIdentifierType,..ExcludeIdentifierTypes)
			If tRoot = ..AffinityDomain {
				#; found the MPI ID in the identifiers collection
				Set tRequest.MPIID = tIdentifierObj.Extension
				Do tRequest.Identifiers.RemoveAt(tIdx)
			} ElseIf $$$ISERR(tSC)!(tAAIdentifierType="") {
				$$$LOGINFO("Unable to determine Use for Identifier.Root="_tRoot_" - removed Identifier")
				Do tRequest.Identifiers.RemoveAt(tIdx)
			} Else {
				Set tIdentifierObj.Use = tAAIdentifierType
			}
		}

	 	$$$HSTRACE("Request with Identifier updates","tRequest",tRequest)
	 	
		Set tAffinityDomainOID = $$$AffinityDomainOIDGet(..AffinityDomain)
		#; check to make sure the AffinityDomain on the Prior MPI ID matches the system affinity domain
		Set tPriorMPIID=pRequest.AdditionalInfo.GetAt("priorID")
		Set tPriorMPIAA = $p(tPriorMPIID,"_")
		If tPriorMPIAA]""  && (tPriorMPIAA'= tAffinityDomainOID) Do ..Errors.logError("PIXError","Error",$$$FormatText($$$Text("Assigning Authority %1 does not match the affinity domain"),tPriorMPIAA)) 
		Do ..ProcessNotification(tRequest,.tResponse)
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("PIXError","Error",$system.Status.GetErrorText(tSC)) 
	}
	Try {
		Set tOutput = ##class(%Stream.GlobalCharacter).%New()
		Do tOutput.Write("<root>")
		Do tOutput.Write("<originalRequest>")
		Do tOutput.CopyFrom(pRequest.ContentStream)
		Do tOutput.Write("</originalRequest>")
		Do ..Errors.XMLExportToString(.tErrorString)
		Do tOutput.Write(tErrorString) 
		Do tOutput.Write("</root>")
		Do tOutput.Rewind()

		Set pResponse=pRequest.%New()
		Set pResponse.Name = $$$PIXv3ReviseResponse
		Set pResponse.DocType = "MCCI_IN000002UV01"
		Set tXSLArguments("messageID") = $System.Util.CreateGUID()
		Set tXSLArguments("creationTime") = ##class(HS.Util.XSLTHelper).timestamp()
		Set tXSLArguments("typeCode") = $S(..Errors.Errors.Count():"CE",1:"CA")
		#; stream as input is any stream, it's not used in the transformation
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tOutput, ..MCCITransform /*"IHE/PIX/Version1/MCCI000002UV.xsl"*/,.tTarget,.tXSLArguments)
		$$$HSTRACEENDCALL
		If $$$ISERR(tSC) {
			$$$HSTRACE("Transform status","tSC",tSC)
		} Else {
			Set pResponse.ContentStream	= tTarget
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("PIXError","Error",$system.Status.GetErrorText(tSC)) 
	}
	
	Quit tSC
}

/// HSPI sends IDUpdateNotifications - MPIID, and PriorMPIID are already set
/// Or the inbound HL7 request is converted to IDUpdateNotification and being sent out
Method ProcessNotification(pRequest As HS.Message.IDUpdateNotificationRequest, pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set pResponse=##class(HS.Message.AddUpdateHubResponse).%New(),pResponse.ErrStatus=$$$OK
		Set tSC = ..OnBeforeProcessNotification(pRequest)
		If pRequest.MPIID ="" Do ..Errors.logError("PIXError","Error","Unable to locate MPIID") Quit
		
		If pRequest.PriorMPIID]"" {
			If pRequest.PriorMPIID'=pRequest.MPIID {
				Set tAA = $Piece(pRequest.AdditionalInfo.GetAt("priorID"),"_",1)
				If tAA'="" {
					Set tPatientId = pRequest.PriorMPIID_"^^^&"_tAA_"&ISO"
					Set tSendingCommunity = ""
					For {
						Set tSendingCommunity = $Order(^HS.IHE.XCPDCache(tPatientId, tSendingCommunity))
						If tSendingCommunity="" Quit
						Set ^HS.IHE.XCPDCache(tPatientId, tSendingCommunity)=0
					}
				}
			}
			Set:..MPIOperations]"" tSC=..SendRequestSync(..MPIOperations,pRequest,.pResponse) 
			If $$$ISERR(tSC) Do ..Errors.logError(5001,"Error",$system.Status.GetErrorText(tSC)) Quit
			If pResponse.ErrStatus]"",$$$ISERR(pResponse.ErrStatus) Do ..Errors.logError("5001","Error",$system.Status.GetErrorText(pResponse.ErrStatus)) Quit
			If '..Errors.Errors.Count() {
				For tIdx = 1:1:$l(..NotifyOthers,",") {
					Set tHost = $p(..NotifyOthers,",",tIdx)
					Continue:tHost="" 
					Set tSC2=..SendRequestSync(tHost,pRequest,.tOtherResponse)
					If $$$ISERR(tSC2) {
						$$$LOGSTATUS(tSC2)
					} ElseIf tOtherResponse.ErrStatus]"",$$$ISERR(tOtherResponse.ErrStatus) { Do ..Errors.logError("5001","Error",$system.Status.GetErrorText(tOtherResponse.ErrStatus)) }
				}
			}
		}
		Set tSC = ..OnAfterProcessNotification(pRequest,.pResponse)
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("PIXError","Error",$system.Status.GetErrorText(tSC)) 
	}
	Quit tSC
}

Method OnBeforeProcessNotification(pRequest As HS.Message.IDUpdateNotificationRequest) As %Status [ CodeMode = expression ]
{
$$$OK
}

Method OnAfterProcessNotification(pRequest As HS.Message.IDUpdateNotificationRequest, pResponse As HS.Message.AddUpdateHubResponse) As %Status [ CodeMode = expression ]
{
$$$OK
}

/// NotifyMPIIDUpdate is called by RevisedPatientv2 and RevisedPatientv3.
Method NotifyMPIIDUpdate(pRequest As HS.Message.IDUpdateNotificationRequest) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set tSC = $$$OK
		#; is this an MPI ID update then change the request to a IDUpdateNotification otherwise we're done
		If tRequest.PriorMPIID="" Quit
		
	 	$$$HSTRACE("OnMPISplit","pRequest,tPriorMPIID,Errors",pRequest,tPriorMPIID,..Errors.Errors.Count())
		If '..Errors.Errors.Count() && (..MPIOperations]"") {
			Set tSC=..SendRequestSync(..MPIOperations,pRequest,.tResponse)
			If $$$ISERR(tSC) {
				Do ..Errors.logError("PIXError","Error","Unable to update record "_$system.Status.GetErrorText(tSC)) 
			} Else {
				If $$$ISERR(tResponse.ErrStatus) Do ..Errors.logError("PIXError","Error","Unable to update record "_$system.Status.GetErrorText(tResponse.ErrStatus)) 
			}
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("PIXError","Error",$system.Status.GetErrorText(tSC)) 
	}
	
	Quit tSC
}

Method HL7ToIDUpdateNotificationRequest(pSource As EnsLib.HL7.Message, Output pTarget As HS.Message.IDUpdateNotificationRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; IHE requires 2.5, so force the document type assignment
		Set pSource.DocType = "2.5:ADT_A05"
		
		#; Instantiate target message
		Set pTarget = ##class(HS.Message.IDUpdateNotificationRequest).%New()
		
		Set pTarget.Facility = pSource.GetValueAt("MSH:4.1")
		
		#; Build Identifiers collection and set MPIID
		For i = 1:1:pSource.GetValueAt("PID:3(*)") {
			Set tIdentifier = pSource.GetValueAt("PID:3("_i_").1")
			Set tAssigningAuthorityCode = pSource.GetValueAt("PID:3("_i_").4.1")
			Set tAssigningAuthorityOID = pSource.GetValueAt("PID:3("_i_").4.2")
			If tAssigningAuthorityCode="",tAssigningAuthorityOID'="" Set tAssigningAuthorityCode=##class(HS.Data.OIDMap).GetCodeForOID(tAssigningAuthorityOID)
			Set tAAIdentifierType = pSource.GetValueAt("PID:3("_i_").5")
			#; If the IdentifierType is null use the value from the Assigning Authority Registry
			If tAAIdentifierType="" {
				Set tSC = ##class(HS.IHE.Util).AAIdentifierTypeForCode(tAssigningAuthorityCode, .tAAIdentifierType,..ExcludeIdentifierTypes)
			}
			If tAssigningAuthorityCode = ..AffinityDomain {
				Set pTarget.MPIID = tIdentifier
			} ElseIf $$$ISERR(tSC)!(tAAIdentifierType="") {
				$$$LOGINFO("Unknown Assigning Authority Type for "_tAssigningAuthorityCode_" - removed Identifier")
			} Else {
				Set tIdentifierObj = ##class(HS.Types.Identifier).%New()
				Set tIdentifierObj.Root = tAssigningAuthorityCode
				Set tIdentifierObj.Extension = tIdentifier
				Set tIdentifierObj.AssigningAuthorityName = tAssigningAuthorityCode
				Set tIdentifierObj.Use = tAAIdentifierType
				Do pTarget.Identifiers.Insert(tIdentifierObj)
			}
		}
		Do pTarget.SetValueAt("S", "PID:5(2).7")
		
		#; TODO: HANDLE PRIOR MPIID? WHAT IS THE SPEC TO INDICATE PRIOR MPIID?
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method HL7Response(pSource As HS.Message.IDUpdateNotificationRequest, Output pTarget As EnsLib.HL7.Message, pOriginalRequest As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		
		#; IHE requires 2.5, so force the document type assignment		
		Set pTarget.DocType = "2.5:ACK"
		
		#; Force original request's document type to be ADT_A05
		Set pOriginalRequest.DocType = "2.5:ADT_A05"
		
		#; MSH Segment (MSH)
		Do pTarget.SetValueAt(..AffinityDomain, "MSH:4.1")
		Do pTarget.SetValueAt("ACK", "MSH:9.1")
		Do pTarget.SetValueAt("A31", "MSH:9.2")
		Do pTarget.SetValueAt("ACK", "MSH:9.3")
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:5.1"), "MSH:3.1") // Sending Application
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:6.1"), "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:3.1"), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:4.1"), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Set tMode = pOriginalRequest.GetValueAt("MSH:11")
		Set tVersion = pOriginalRequest.GetValueAt("MSH:12")
		If ..V2ResponseProcessingMode]"" {
			Set tMode = ..V2ResponseProcessingMode
		}
		If ..V2ResponseVersion]"" {
			Set tVersion = ..V2ResponseVersion
		}
		Do pTarget.SetValueAt(tMode,"MSH:11") // Processing ID (P = Production)
		Do pTarget.SetValueAt(tVersion, "MSH:12")
		
		#; Message Acknowledgment (MSA)
		If '..Errors.Errors.Count() {
			Do pTarget.SetValueAt("AA", "MSA:1")
			Do pTarget.SetValueAt(pSource.MPIID, "MSA:3")
		}
		Else {
			Do pTarget.SetValueAt("AE", "MSA:1")
			If $$$ISERR(pSource.ErrStatus) {
				Do pTarget.SetValueAt($System.Status.GetOneErrorText(pSource.ErrStatus), "ERR:1")
			} Else {
				Do pTarget.SetValueAt(..Errors.Errors.GetAt(1).Description, "ERR:1")
			}
			
		}
		Do pTarget.SetValueAt(pOriginalRequest.GetValueAt("MSH:10"), "MSA:2")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
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
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pTarget.SetValueAt("2.5", "MSH:12")
		
		#; For now just use the first error to populate MSA and QAK.
		Set tErrorCode = ..Errors.Errors.GetAt(1).Code
		Set tAckCode = $Select(tErrorCode>99&(tErrorCode<200):"AE",1:"AR")
		
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
		Do ..Errors.logError("207","E",$system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

/// Code to generate XPID_Notification response
Method GeneralHL7Response(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pResponse = ##class(EnsLib.HL7.Message).%New()
		
		#; IHE requires 2.5, so force the document type assignment		
		Set pResponse.DocType = "2.5:ACK"
		
		#; Message Header (MSH)
		Do pResponse.SetValueAt(pRequest.GetValueAt("MSH:9.1"), "MSH:9.1")
		Do pResponse.SetValueAt(pRequest.GetValueAt("MSH:9.1"), "MSH:9.2")
		Do pResponse.SetValueAt(pRequest.GetValueAt("MSH:5.1"), "MSH:3.1") // Sending Application
		Do pResponse.SetValueAt(pRequest.GetValueAt("MSH:6.1"), "MSH:4.1") // Sending Facility
		Do pResponse.SetValueAt(pRequest.GetValueAt("MSH:3.1"), "MSH:5.1") // Receiving Application
		Do pResponse.SetValueAt(pRequest.GetValueAt("MSH:4.1"), "MSH:6.1") // Receiving Facility
		Do pResponse.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pResponse.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pResponse.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pResponse.SetValueAt("2.5", "MSH:12")


		Set tAckCode = "AA"
		If ..Errors.Errors.Count() {
			#; For now just use the first error to populate MSA 
			Set tErrorCode = ..Errors.Errors.GetAt(1).Code
			Set tAckCode = $Select(tErrorCode>199&(tErrorCode<204):"AR",1:"AE")
		}
		
		#; Message Acknowledgment (MSA)
		Do pResponse.SetValueAt(tAckCode, "MSA:1")
		Do pResponse.SetValueAt(pRequest.GetValueAt("MSH:10"), "MSA:2")
		
		For i = 1:1:..Errors.Errors.Count() {
			Set tLoc = ..Errors.Errors.GetAt(i).Location
			If tLoc'="" {
				Set tSegID = $Piece($Piece(tLoc,":",1),"(",1)
				Set tSegSQ = $Piece($Piece($Piece(tLoc,":",1),"(",2),")",1)
				If tSegSQ="" Set tSegSQ = 1
				Set tFldPos = $Piece($Piece(tLoc,":",2),"(",1)
				Set tFldRep = $Piece($Piece($Piece(tLoc,":",2),"(",2),")",1)
				Do pResponse.SetValueAt(tSegID, "ERR("_i_"):2.1")
				Do pResponse.SetValueAt(tSegSQ, "ERR("_i_"):2.2")
				Do pResponse.SetValueAt(tFldPos, "ERR("_i_"):2.3")
				Do pResponse.SetValueAt(tFldRep, "ERR("_i_"):2.4")
			}
			Do pResponse.SetValueAt(..Errors.Errors.GetAt(i).Code, "ERR("_i_"):3")
			Do pResponse.SetValueAt(..Errors.Errors.GetAt(i).Severity, "ERR("_i_"):4")
			Set tDesc = ..Errors.Errors.GetAt(i).Description
			If tDesc'="" {
				Set tDesc = $Translate(tDesc,pResponse.Separators,$Extract("          ",1,$Length(pResponse.Separators)))
				Do pResponse.SetValueAt(tDesc, "ERR("_i_"):5")
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	
	Quit tSC
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>IHEVersion</Value>
</Value>
<Value name="3">
<Value>IHEExtension</Value>
</Value>
<Value name="4">
<Value>Transformer</Value>
</Value>
<Value name="5">
<Value>DeviceID</Value>
</Value>
<Value name="6">
<Value>MPIOperations</Value>
</Value>
<Value name="7">
<Value>UpdateMPI</Value>
</Value>
<Value name="8">
<Value>Errors</Value>
</Value>
<Value name="9">
<Value>AffinityDomain</Value>
</Value>
<Value name="10">
<Value>NotifyOthers</Value>
</Value>
<Value name="11">
<Value>PRPAINToUpdateTransform</Value>
</Value>
<Value name="12">
<Value>MCCITransform</Value>
</Value>
<Value name="13">
<Value>ExcludeIdentifierTypes</Value>
</Value>
<Value name="14">
<Value>V2ResponseProcessingMode</Value>
</Value>
<Value name="15">
<Value>V2ResponseVersion</Value>
</Value>
</Data>
<Data name="ValueSet">
<Attribute>ValueSet</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.IHE.PIXv3.Consumer.Process.ValueSet"</Subscript>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
