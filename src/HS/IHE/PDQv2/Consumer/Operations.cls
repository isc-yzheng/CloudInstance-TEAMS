Include (HS.HC, HS.IHE.ATNA)

/// Class used to create and/or send PDQv2 Query message to PDQv2 Supplier 
Class HS.IHE.PDQv2.Consumer.Operations Extends HS.Util.HL7Client.Operations [ Inheritance = right, ProcedureBlock ]
{

/// Used as the sender facility code - IdentityCode from the HS.Data.OIDMap table
Property SendingFacility As %String [ InitialExpression = "PDQv2ConsumerDevice" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.PatientSearchRequest"> 
		<Method>PDQLookup</Method>
	</MapItem>
</MapItems>
}

Method PDQLookup(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tHL7Request As EnsLib.HL7.Message
		#dim tHL7Response As EnsLib.HL7.Message
		
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		
		#; Update the cached service entry data if needed.
		Do ..UpdateRegistryService(pRequest.AdditionalInfo.GetAt("ServiceName"))
		
		If pRequest.AdditionalInfo.GetAt("CancelQuery")="" {
			#; Transform PatientSearchRequest to HL7 QBP^Q23 for PIXv2
			Set tSC = ..PatientSearchRequestToHL7QBP(pRequest, .tHL7Request)
		} Else {
			#; Transform PatientSearchRequest to HL7 QCN^J01 for PIXv2
			Set tSC = ..PatientSearchRequestToHL7QCN(pRequest, .tHL7Request)
		}
		Quit:$$$ISERR(tSC)
		
		Set tSC=..OnMessage(tHL7Request, .tHL7Response)
		Quit:$$$ISERR(tSC)
		
		Set tEnvelope = ""
		If pRequest.SAMLData.HSRoles'="" Set tEnvelope = tEnvelope_"|UserRoles="_pRequest.SAMLData.HSRoles_"|"
		Set tEnvelope = tEnvelope_"|FromHost="_$system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName())_"|"
		Set tEnvelope = tEnvelope_"|ToHost="_$ListGet(..RegistryService,7)_"|"
		Set tHL7Request.Envelope = tEnvelope
		Do $$$ATNAEvent("PDQv2Consumer", tHL7Request, tHL7Response, tSC)
		
		If tHL7Response.GetValueAt("MSH:9.1")="ACK",tHL7Response.GetValueAt("MSH:9.2")="J01" {
			#; Build a cancel reponse using the HL7 ACK^J01
			Set tSC = ..HL7ToCancelResponse(tHL7Response, .pResponse)
		} Else {
			#; Build a PatientSearchResponse using the HL7 RSP^K23
			Set tSC = ..HL7ToPatientSearchResponse(tHL7Response, .pResponse)
		}
		Quit:$$$ISERR(tSC)
		
		$$$HSTRACE("PatientSearchResponse from HL7 response", "pResponse", pResponse)
		
		Set tAffinityDomain=$S($lg(..RegistryService,4)]"":$lg(..RegistryService,4),1:$$$AffinityDomain)
		For tIdx=1:1:pResponse.Results.Count() {
			Set tItem=pResponse.Results.GetAt(tIdx)
			For tIdx2=1:1:tItem.Identifiers.Count() {
				If tItem.Identifiers.GetAt(tIdx2).Root=tAffinityDomain Set tItem.MPIID=tItem.Identifiers.GetAt(tIdx2).Extension Quit
			}
			/// Ensure response is consistent with what is returned from MPI Manager (Primarily for XCPD)
			If tItem.MPIID]"" {
				Set tMPIMatch = ##class(HS.Message.PatientMPIMatch).%New()
				Do tMPIMatch.CopyFrom(tItem,tMPIMatch)
				Do tMPIMatch.SearchMatches.Insert(tIdx)
				For tIdxA=1:1:tItem.Addresses.Count() {
					Do tMPIMatch.Addresses.Insert(tItem.Addresses.GetAt(tIdxA))
				}
				Do pResponse.MPIIDList.Insert(tMPIMatch)
			}
		}
		Set pResponse.ErrStatus=$S(pResponse.AdditionalInfo.GetAt("ErrStatusText")="":$$$OK,1:$$$ERROR($$$GeneralError,pResponse.AdditionalInfo.GetAt("ErrStatusText")))
		Do pResponse.AdditionalInfo.RemoveAt("ErrStatusText")
		Set pResponse.ResultsCount=pResponse.Results.Count()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// PatientSearchRequestToHL7 transforms an HS.Message.PatientSearchRequest into an HL7 QBP^Q22 message.
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
		Do pTarget.SetValueAt("Q22", "MSH:9.2")
		Do pTarget.SetValueAt("QBP_Q21", "MSH:9.3")
		Do pTarget.SetValueAt(..SendingApplication, "MSH:3") // Sending Application
		Do pTarget.SetValueAt(..SendingFacility, "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt($ListGet(..RegistryService,5), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt($ListGet(..RegistryService,6), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pTarget.SetValueAt("2.5", "MSH:12.1")
		
		#; Query Parameter Definition (QPD)
		Do pTarget.SetValueAt("IHE PDQ Query","QPD:1") // Message Query Name
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"QPD:2") // Query Tag
		
		Set tFieldNo = 0
		Set tIdentifier = ""
		Set tIdentifierType = ""
		
		#; If assigning authority equals the affinity domain then assume it's a PatientId.
		If pSource.MPIID'=""!(tAssigningAuthorityOID=tAffinityDomainOID) {
			If pSource.MPIID'="" {
				Set tIdentifier = pSource.MPIID
				If pSource.AssigningAuthority="" Set tAssigningAuthorityOID=tAffinityDomainOID
			} ElseIf pSource.MRN'=""  {
				Set tIdentifier = pSource.MRN
			}
			Set tIdentifierType = "PI"
		} ElseIf pSource.MRN'="",tAssigningAuthorityOID'="" {
			Set tIdentifier = pSource.MRN
			Set tIdentifierType = "MR"
		}
		
		#; If tIdentifier is set then assume that AA and type are set too.
		If pSource.MRN'="",tAssigningAuthorityOID="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.3.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.MRN,"QPD:3("_tFieldNo_").2")
		}
		If tIdentifier'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.3.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(tIdentifier,"QPD:3("_tFieldNo_").2")
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.3.4.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.AssigningAuthority,"QPD:3("_tFieldNo_").2")
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.3.4.2","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(tAssigningAuthorityOID,"QPD:3("_tFieldNo_").2")
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.3.4.3","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt("ISO","QPD:3("_tFieldNo_").2")
		}
		#; Trailing asterisk is the de facto way to indicate non-exact match for v2.
		Set tLastName = pSource.LastName
		If pSource.AdditionalInfo.GetAt("ExactMatch")="0",tLastName'="",$Extract(tLastName,*)'="*" Set tLastName = tLastName_"*"
		If pSource.LastName'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.5.1.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(tLastName,"QPD:3("_tFieldNo_").2")
		}
		If pSource.FirstName'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.5.2","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.FirstName,"QPD:3("_tFieldNo_").2")
		}
		If pSource.MiddleName'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.5.3","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.MiddleName,"QPD:3("_tFieldNo_").2")
		}
		If pSource.DOB'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.7.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt($Translate($ZDateTime(pSource.DOB, 3), "-: ", ""),"QPD:3("_tFieldNo_").2")
		}
		If pSource.Sex'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.8","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.Sex,"QPD:3("_tFieldNo_").2")
		}
		
		#; Get Address from either the individual properties or
		#; from the first item in the Addresses collection.  The
		#; individual properties take precedence.
		Set tStreet = ""
		Set tCity = ""
		Set tState = ""
		Set tZip = ""
		Set tAddrObj = pSource.Addresses.GetAt(1)
		If pSource.Street'=""!(pSource.City'="")!(pSource.State'="")!(pSource.Zip'="") {
			Set tStreet = pSource.Street
			Set tCity = pSource.City
			Set tState = pSource.State
			Set tZip = pSource.Zip
		} ElseIf $IsObject(tAddrObj) {
			Set tStreet = tAddrObj.StreetLine
			Set tCity = tAddrObj.City
			Set tState = tAddrObj.State
			Set tZip = tAddrObj.PostalCode
		}
		If tStreet'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.11.1.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(tStreet,"QPD:3("_tFieldNo_").2")
		}
		If tCity'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.11.3","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(tCity,"QPD:3("_tFieldNo_").2")
		}
		If tState'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.11.4","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(tState,"QPD:3("_tFieldNo_").2")
		}
		If tZip'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.11.5","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(tZip,"QPD:3("_tFieldNo_").2")
		}
		
		If pSource.AdditionalInfo.GetAt("AccountNumber")'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.18.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.AdditionalInfo.GetAt("AccountNumber"),"QPD:3("_tFieldNo_").2")
		}
		If pSource.MothersMaidenSurname'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.6.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.MothersMaidenSurname,"QPD:3("_tFieldNo_").2")
		}
		If pSource.Telephone'="" {
			If $i(tFieldNo)
			Do pTarget.SetValueAt("@PID.13.1","QPD:3("_tFieldNo_").1")
			Do pTarget.SetValueAt(pSource.Telephone,"QPD:3("_tFieldNo_").2")
		}
		
		#; TODO: Do we need to implement support for multiple PID:3 identifiers?
		/*
		For i = 1:1:pSource.Identifiers.Count() {
			Set tIdentifier = pSource.Identifiers.GetAt(i).Extension
			Set tAssigningAuthority = pSource.Identifiers.GetAt(i).Root
			Set tIdentifierType = "livingSubjectID"
			If tIdentifier'="" {
				If $i(tFieldNo)
				Do pTarget.SetValueAt("@PID.3.1","QPD:3("_tFieldNo_").1")
				Do pTarget.SetValueAt(tIdentifier,"QPD:3("_tFieldNo_").2")
				If $i(tFieldNo)
				Do pTarget.SetValueAt("@PID.3.4.2","QPD:3("_tFieldNo_").1")
				Do pTarget.SetValueAt(tAssigningAuthority,"QPD:3("_tFieldNo_").2")
				If $i(tFieldNo)
				Do pTarget.SetValueAt("@PID.3.4.3","QPD:3("_tFieldNo_").1")
				Do pTarget.SetValueAt("ISO","QPD:3("_tFieldNo_").2")
				If $i(tFieldNo)
				Do pTarget.SetValueAt("@PID.3.5","QPD:3("_tFieldNo_").1")
				Do pTarget.SetValueAt(tIdentifierType,"QPD:3("_tFieldNo_").2")
			}
		}
		*/

		#; Query Parameter Definition (QPD) - Target domain(s) to filter the response by (QPD:8).
		#; Use Facility if ScopingOrganizations not there.
		Set tQPDDomainsField = 8
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
		#; RCP:2.1 Quantity Limited Request - Number
		#; RCP:2.2 Quantity Limited Request - Units - always RD (Records)
		Do pTarget.SetValueAt("I","RCP:1.1")
		Set tMaxMatches = $Select(pSource.MaxMatches'="":pSource.MaxMatches,1:50)
		If pSource.MaxMatches'="" {
			Do pTarget.SetValueAt(tMaxMatches,"RCP:2.1")
			Do pTarget.SetValueAt("RD","RCP:2.2")
		}
		
		#; Continuation Pointer (DSC)
		#; DSC:1 Continuation Pointer should be the value previously received back from RSP^K22.
		#; DSC:2 Continuation Style is always I (Interactive)
		If pSource.AdditionalInfo.GetAt("ContinuationPointer")'="" {
			Do pTarget.SetValueAt(pSource.AdditionalInfo.GetAt("ContinuationPointer"),"DSC:1")
			Do pTarget.SetValueAt("I","DSC:2")
			Do pTarget.SetValueAt(pSource.AdditionalInfo.GetAt("OriginalQueryID"),"QPD:2") // Query Tag
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method PatientSearchRequestToHL7QCN(pSource As HS.Message.PatientSearchRequest, ByRef pTarget As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {		
		#; Instantiate target message
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		Set pTarget.DocType = "2.5:QCN_J01"
		
		#; Message Header (MSH)
		Do pTarget.SetValueAt("QCN", "MSH:9.1")
		Do pTarget.SetValueAt("J01", "MSH:9.2")
		Do pTarget.SetValueAt("QCN_J01", "MSH:9.3")
		Do pTarget.SetValueAt(..SendingApplication, "MSH:3") // Sending Application
		Do pTarget.SetValueAt(..SendingFacility, "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt($ListGet(..RegistryService,5), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt($ListGet(..RegistryService,6), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt($Translate($ZDateTime($Horolog, 3), "-: ", ""), "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		Do pTarget.SetValueAt("2.5", "MSH:12.1")
		
		#; Query Identification (QID)
		Do pTarget.SetValueAt(pSource.AdditionalInfo.GetAt("OriginalQueryID"),"QID:1") // Query Tag (QueryID)
		Do pTarget.SetValueAt("IHE PDQ Query","QID:2") // Message Query Name
		
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
		If ("|AA|CA|" '[ ("|" _ pSource.GetValueAt("MSA:1") _ "|")) $$$ThrowStatus($$$ERROR($$$GeneralError, "An non-accept (error or reject) acknowledgement was received: " _ pSource.GetValueAt("MSA:1")))
		If ("|OK|NF|" '[ ("|" _ pSource.GetValueAt("QAK:2") _ "|")) $$$ThrowStatus($$$ERROR($$$GeneralError, "An error or reject status was received: " _ pSource.GetValueAt("QAK:2")))
		If ("NF" = pSource.GetValueAt("QAK:2")) { $$$LOGINFO("No matches found for input patient identifier (logged as format = 'Assigning Authority / Identifier'): " _ $Case(pSource.GetValueAt("QPD:3.4.1") '= "", 1:pSource.GetValueAt("QPD:3.4.1"), :pSource.GetValueAt("QPD:3.4.2")) _ " / " _ pSource.GetValueAt("QPD:3.1")) Quit }
		
		#; Build match collection
		For i = 1:1:pSource.GetValueAt("PIDgrp(*)") {
			Set tMatch = ##class(HS.Message.PatientSearchMatch).%New()
			For j = 1:1:pSource.GetValueAt("PIDgrp("_i_").PID:3(*)") {
				Set tIdentifier = pSource.GetValueAt("PIDgrp("_i_").PID:3("_j_").1")
				Set tAssigningAuthorityCode = pSource.GetValueAt("PIDgrp("_i_").PID:3("_j_").4.1")
				Set tAssigningAuthorityOID = pSource.GetValueAt("PIDgrp("_i_").PID:3("_j_").4.2")
				If tAssigningAuthorityCode="",tAssigningAuthorityOID'="" Set tAssigningAuthorityCode=##class(HS.Data.OIDMap).GetCodeForOID(tAssigningAuthorityOID)
				Set tIdentifierType = pSource.GetValueAt("PIDgrp("_i_").PID:3("_j_").5")
				Set tIdentifierObj = ##class(HS.Types.Identifier).%New()
				Set tIdentifierObj.Root = tAssigningAuthorityCode
				Set tIdentifierObj.Extension = tIdentifier
				Do tMatch.Identifiers.Insert(tIdentifierObj)
				If tIdentifierType="PI",tMatch.MPIID="" Set tMatch.MPIID = tIdentifier
			}
			Set tMatch.LastName = pSource.GetValueAt("PIDgrp("_i_").PID:5.1.1")
			Set tMatch.FirstName = pSource.GetValueAt("PIDgrp("_i_").PID:5.2")
			Set tMatch.MiddleName = pSource.GetValueAt("PIDgrp("_i_").PID:5.3")
			Set tDOB = pSource.GetValueAt("PIDgrp("_i_").PID:7.1")
			If tDOB'="" Set tDOB = $Extract(tDOB,1,8)
			If $Length(tDOB)=8 Set tMatch.DOB = $ZDateH(tDOB, 8)
			Set tMatch.Sex = pSource.GetValueAt("PIDgrp("_i_").PID:8.1")
			Set tMatch.Street = pSource.GetValueAt("PIDgrp("_i_").PID:11.1")
			Set tMatch.City = pSource.GetValueAt("PIDgrp("_i_").PID:11.3")
			Set tMatch.State = pSource.GetValueAt("PIDgrp("_i_").PID:11.4")
			Set tMatch.Zip = pSource.GetValueAt("PIDgrp("_i_").PID:11.5")
			Set tAccount = pSource.GetValueAt("PIDgrp("_i_").PID:18") If tAccount'="" Do tMatch.AdditionalInfo.SetAt(tAccount, "AccountNumber")
			Set tMatch.MothersMaidenSurname = pSource.GetValueAt("PIDgrp("_i_").PID:6.1")
			Set tMatch.Telephone = pSource.GetValueAt("PIDgrp("_i_").PID:13.1")
			Set tMatch.SSN = pSource.GetValueAt("PIDgrp("_i_").PID:19")
			
			Do pTarget.Results.Insert(tMatch)
		}
		
		#; If there is a continuation returned, we'll also need the original
		#; QPD:2 which is returned in QAK:1.  The NIST PIX PDQ testing tool
		#; wants the original ID to be in the continuation query(s).
		Set tDSC1 = pSource.GetValueAt("DSC:1")
		#; TODO: The use of pSource.OutputToString() here is a workaround until
		#; we move to 2013.2 or later, or KDS003 is ported back to 2013.1.
		#; This following If block should be removed when either of those happens.
		If tDSC1="" {
			Set tSep1 = $Extract(pSource.Separators,1)
			Set tDSC1 = $Piece($Piece(pSource.OutputToString(),"DSC"_tSep1,2),tSep1_"I",1)
			If tDSC1'="",tDSC1[tSep1 Set tDSC1=""
		}
		If tDSC1'="" {
			Do pTarget.AdditionalInfo.SetAt(tDSC1,"ContinuationPointer")
			Do pTarget.AdditionalInfo.SetAt(pSource.GetValueAt("QAK:1"),"OriginalQueryID")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method HL7ToCancelResponse(pSource As EnsLib.HL7.Message, ByRef pTarget As HS.Message.PatientSearchResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(HS.Message.PatientSearchResponse).%New()
		
		#; Check for error
		If ("|AA|CA|" '[ ("|" _ pSource.GetValueAt("MSA:1") _ "|")) $$$ThrowStatus($$$ERROR($$$GeneralError, "An non-accept (error or reject) acknowledgement was received: " _ pSource.GetValueAt("MSA:1")))
		
		Do pTarget.AdditionalInfo.SetAt("1","CancelResponse")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
