Include (HS.IHE.ATNA, HS.HC)

/// Class used to create and/or send PIXv2 Query message to PIXv2 Manager 
Class HS.IHE.PIXv2.Consumer.Operations Extends HS.Util.HL7Client.Operations [ Inheritance = right, ProcedureBlock ]
{

/// Used as the sender facility code - IdentityCode from the HS.Data.OIDMap table
Property SendingFacility As %String [ InitialExpression = "PIXv2ConsumerDevice" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.PatientSearchRequest"> 
		<Method>PIXLookup</Method>
	</MapItem>
</MapItems>
}

/// given the additional info selected in the document set list issue fetch
/// 
Method PIXLookup(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tHL7Request As EnsLib.HL7.Message
		#dim tHL7Response As EnsLib.HL7.Message
		
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		
		#; Update the cached service entry data if needed.
		Do ..UpdateRegistryService(pRequest.AdditionalInfo.GetAt("ServiceName"))
		
		#; Transform PatientSearchRequest to HL7 QBP^Q23 for PIXv2
		Set tSC = ..PatientSearchRequestToHL7QBP(pRequest, .tHL7Request)
		Quit:$$$ISERR(tSC)
		
		Set tSC=..OnMessage(tHL7Request, .tHL7Response)
		Quit:$$$ISERR(tSC)
		
		Set tEnvelope = ""
		If pRequest.SAMLData.HSRoles'="" Set tEnvelope = tEnvelope_"|UserRoles="_pRequest.SAMLData.HSRoles_"|"
		Set tEnvelope = tEnvelope_"|FromHost="_$system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName())_"|"
		Set tEnvelope = tEnvelope_"|ToHost="_$ListGet(..RegistryService,7)_"|"
		Set tHL7Request.Envelope = tEnvelope
		Do $$$ATNAEvent("PIXv2Consumer", tHL7Request, tHL7Response, tSC)
		
		#; Build a PatientSearchResponse using the HL7 RSP^K23
		Set tSC = ..HL7ToPatientSearchResponse(tHL7Response, .pResponse)
		Quit:$$$ISERR(tSC)
		
		$$$HSTRACE("PatientSearchResponse from HL7 Response", "pResponse", pResponse)
		
		Set tAffinityDomain=$S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		For tIdx=1:1:pResponse.Results.Count() {
			Set tItem=pResponse.Results.GetAt(tIdx)
			For tIdx2=1:1:tItem.Identifiers.Count() {
				If tItem.Identifiers.GetAt(tIdx2).Root=tAffinityDomain Set tItem.MPIID=tItem.Identifiers.GetAt(tIdx2).Extension Quit
			}
		}
		If pResponse.AdditionalInfo.GetAt("ErrStatusText")'="" $$$LOGSTATUS($$$ERROR($$$GeneralError,pResponse.AdditionalInfo.GetAt("ErrStatusText")))
		Set pResponse.ErrStatus=$S(pResponse.AdditionalInfo.GetAt("ErrStatusText")="":$$$OK,1:$$$ERROR($$$GeneralError,pResponse.AdditionalInfo.GetAt("ErrStatusText")))
		Do pResponse.AdditionalInfo.RemoveAt("ErrStatusText")
		Set pResponse.ResultsCount=pResponse.Results.Count()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// PatientSearchRequestToHL7 transforms an HS.Message.PatientSearchRequest into an HL7 QBP^Q23 message.
Method PatientSearchRequestToHL7QBP(pSource As HS.Message.PatientSearchRequest, ByRef pTarget As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(pSource.AssigningAuthority)
		Set tAffinityDomainCode = ##class(HS.IHE.Util).GetAffinityDomain()
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAffinityDomainCode)
		
		#; Instantiate target message
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		Set pTarget.DocType = "2.5:QBP_Q21"
		
		#; Message Header (MSH)
		Do pTarget.SetValueAt("QBP", "MSH:9.1")
		Do pTarget.SetValueAt("Q23", "MSH:9.2")
		Do pTarget.SetValueAt("QBP_Q21", "MSH:9.3")
		Do pTarget.SetValueAt(..SendingApplication, "MSH:3") // Sending Application
		Do pTarget.SetValueAt(..SendingFacility, "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt($ListGet(..RegistryService,5), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt($ListGet(..RegistryService,6), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pTarget.SetValueAt("2.5", "MSH:12.1")
		
		#; Query Parameter Definition (QPD) - Person's local identifier
		Do pTarget.SetValueAt("IHE PIX Query","QPD:1") // Message Query Name
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"QPD:2") // Query Tag
		If pSource.MPIID'=""!(tAssigningAuthorityOID=tAffinityDomainOID) {
			If pSource.MPIID'="" Do pTarget.SetValueAt(pSource.MPIID, "QPD:3.1")
			If pSource.MRN'="" Do pTarget.SetValueAt(pSource.MRN, "QPD:3.1")
			Do pTarget.SetValueAt(tAffinityDomainCode, "QPD:3.4.1")
			Do pTarget.SetValueAt(tAffinityDomainOID, "QPD:3.4.2")
			Do pTarget.SetValueAt("ISO","QPD:3.4.3") // "ISO"
			Do pTarget.SetValueAt("PI","QPD:3.5") // Identifier Type
		} Else {
			Do pTarget.SetValueAt(pSource.MRN, "QPD:3.1")
			Do pTarget.SetValueAt(pSource.AssigningAuthority, "QPD:3.4.1")
			Do pTarget.SetValueAt(tAssigningAuthorityOID, "QPD:3.4.2")
			Do pTarget.SetValueAt("ISO","QPD:3.4.3") // "ISO"
			Do pTarget.SetValueAt("MR","QPD:3.5") // Identifier Type
		}
		
		#; Query Parameter Definition (QPD) - Target domain(s) to filter the response by (QPD:4).
		#; Use Facility if ScopingOrganizations not there.
		Set tQPDDomainsField = 4
		If pSource.Facility'="" && 'pSource.AdditionalInfo.IsDefined("ScopingOrganizations") {
			Set tFacilityCode = ##class(HS.Data.OIDMap).GetCodeForOID(pSource.Facility, pSource.Facility)
			Set tFacilityOID = ##class(HS.Data.OIDMap).GetOIDForCode(pSource.Facility, pSource.Facility)
			Do pTarget.SetValueAt(tFacilityCode, "QPD:"_tQPDDomainsField_".4.1")
			Do pTarget.SetValueAt(tFacilityOID, "QPD:"_tQPDDomainsField_".4.2")
			Do pTarget.SetValueAt("ISO", "QPD:"_tQPDDomainsField_".4.3")
		}
		If pSource.AdditionalInfo.IsDefined("ScopingOrganizations") {
			Set (tNodeStart,tNode) = "scopingOrganization_"
			For i = 1:1 {
				Do pSource.AdditionalInfo.GetNext(.tNode) Quit:tNode=""
				Set tFacilityCode=$Piece(tNode,tNodeStart,2)
				If tFacilityCode="" Quit
				Set tFacilityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tFacilityCode,"")
				$$$HSTRACE("Evaluating scoping organization","tFacilityOID,tFacilityCode",tFacilityOID,tFacilityCode)
				If tFacilityOID="" Set tSC = $$$ERROR($$$GeneralError, "Scoping OID not found for:"_tFacilityCode) Quit
				Do pTarget.SetValueAt(tFacilityCode, "QPD:"_tQPDDomainsField_"("_i_").4.1")
				Do pTarget.SetValueAt(tFacilityOID, "QPD:"_tQPDDomainsField_"("_i_").4.2")
				Do pTarget.SetValueAt("ISO", "QPD:"_tQPDDomainsField_"("_i_").4.3")
			}
		}
		If $$$ISERR(tSC) Quit
		
		#; Response Control Parameter (RCP)
		#; RCP:1 Query Priority is always I (Immediate)
		Do pTarget.SetValueAt("I","RCP:1.1")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method HL7ToPatientSearchResponse(pSource As EnsLib.HL7.Message, ByRef pTarget As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(HS.Message.PatientSearchResponse).%New()
		
		#; Check for error or no results
		#; This first condition specifically looks for AE that was because of patient identifier not found.
		If pSource.GetValueAt("MSA:1")="AE"&&(pSource.GetValueAt("ERR:3")="204")&&(pSource.GetValueAt("ERR:2.1")="QPD")&&(pSource.GetValueAt("ERR:2.2")="1")&&(pSource.GetValueAt("ERR:2.3")="3")&&(pSource.GetValueAt("ERR:2.4")="1") {
			Set pTarget.ErrStatus = pSource.GetValueAt("ERR:5")
		} ElseIf ("|AA|CA|" '[ ("|" _ pSource.GetValueAt("MSA:1") _ "|")) {
			Set pTarget.ErrStatus = "An non-accept (error or reject) acknowledgement was received: " _ pSource.GetValueAt("MSA:1")
		} ElseIf ("|OK|NF|" '[ ("|" _ pSource.GetValueAt("QAK:2") _ "|")) {
			Set pTarget.ErrStatus = "An error or reject status was received: " _ pSource.GetValueAt("QAK:2")
		} ElseIf ("NF" = pSource.GetValueAt("QAK:2")) {
			Set pTarget.ErrStatus = "No matches found for input patient identifier (logged as format = 'Assigning Authority / Identifier'): " _ $Case(pSource.GetValueAt("QPD:3.4.1") '= "", 1:pSource.GetValueAt("QPD:3.4.1"), :pSource.GetValueAt("QPD:3.4.2")) _ " / " _ pSource.GetValueAt("QPD:3.1")
		}
		If pTarget.ErrStatus'="" Do pTarget.AdditionalInfo.SetAt(pTarget.ErrStatus,"ErrStatusText") Quit
		
		#; Build match collection
		Set tMatch = ##class(HS.Message.PatientSearchMatch).%New()
		
		Set tIdentifier = pSource.GetValueAt("QPD:3(1).1")
		Set tAssigningAuthorityCode = pSource.GetValueAt("QPD:3(1).4.1")
		Set tAssigningAuthorityOID = pSource.GetValueAt("QPD:3(1).4.2")
		If tAssigningAuthorityCode="",tAssigningAuthorityOID'="" Set tAssigningAuthorityCode=##class(HS.Data.OIDMap).GetCodeForOID(tAssigningAuthorityOID)
		Set tIdentifierType = pSource.GetValueAt("QPD:3(1).5")
		Set tIdentifierObj = ##class(HS.Types.Identifier).%New()
		Set tIdentifierObj.Root = tAssigningAuthorityCode
		Set tIdentifierObj.Extension = tIdentifier
		Do tMatch.Identifiers.Insert(tIdentifierObj)
		If tIdentifierType="PI" Set tMatch.MPIID = tIdentifier
		
		For i = 1:1:pSource.GetValueAt("PID:3(*)") {
			Set tIdentifier = pSource.GetValueAt("PID:3("_i_").1")
			Set tAssigningAuthorityCode = pSource.GetValueAt("PID:3("_i_").4.1")
			Set tAssigningAuthorityOID = pSource.GetValueAt("PID:3("_i_").4.2")
			If tAssigningAuthorityCode="",tAssigningAuthorityOID'="" Set tAssigningAuthorityCode=##class(HS.Data.OIDMap).GetCodeForOID(tAssigningAuthorityOID)
			Set tIdentifierType = pSource.GetValueAt("PID:3("_i_").5")
			Set tIdentifierObj = ##class(HS.Types.Identifier).%New()
			Set tIdentifierObj.Root = tAssigningAuthorityCode
			Set tIdentifierObj.Extension = tIdentifier
			Do tMatch.Identifiers.Insert(tIdentifierObj)
			If tIdentifierType="PI",tMatch.MPIID="" Set tMatch.MPIID = tIdentifier
		}
		Do pTarget.Results.Insert(tMatch)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
