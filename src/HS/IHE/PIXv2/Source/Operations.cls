Include (HS.IHE.ATNA, HS.HC)

Class HS.IHE.PIXv2.Source.Operations Extends HS.Util.HL7Client.Operations [ Inheritance = right, ProcedureBlock ]
{

/// Used as the sender facility code - IdentityCode from the HS.Data.OIDMap table.  Receiver is defined by Device in Service Registry end point
Property SendingFacility As %String [ InitialExpression = "PIXv2.Sender" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.AddUpdateHubRequest"> 
		<Method>PIXAddUpdate</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.MergePatientRequest"> 
		<Method>PIXMerge</Method>
	</MapItem>
</MapItems>
}

Method PIXAddUpdate(pRequest As HS.Message.AddUpdateHubRequest, ByRef pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		
		Set tRequest=pRequest.%ConstructClone(1)  /// Copy request so that updates are not saved
		
		#; Update the cached service entry data if needed.
		Do ..UpdateRegistryService(tRequest.AdditionalInfo.GetAt("ServiceName"))
		
		If tRequest.MPIID]"" {
			Set tIdentifer=##class(HS.Types.Identifier).%New()
			Set tIdentifer.Root=$$$AffinityDomain
			Set tIdentifer.Extension=pRequest.MPIID
			Set tIdentifer.Use="PT"
			Do tRequest.Identifiers.Insert(tIdentifer)
		}
		
		#; Transform AddUpdateHubRequest to HL7 ADT A01, A04 A05 or A08 for PIXv2
		Set tSC = ..TransformHSMessageToHL7(tRequest, .tHL7Request)
		
		#; ..OnMessage handles send/receive of HL7 Request and HL7 Response and does $$$HSTRACE of them.
		Set tSC=..OnMessage(tHL7Request, .tHL7Response) 
		Quit:$$$ISERR(tSC)
		
		Set tEnvelope = ""
		If pRequest.SAMLData.HSRoles'="" Set tEnvelope = tEnvelope_"|UserRoles="_pRequest.SAMLData.HSRoles_"|"
		Set tEnvelope = tEnvelope_"|FromHost="_$system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName())_"|"
		Set tEnvelope = tEnvelope_"|ToHost="_$ListGet(..RegistryService,7)_"|"
		Set tHL7Request.Envelope = tEnvelope
		Do $$$ATNAEvent("PIXv2Source", tHL7Request, tHL7Response, tSC)
		
		#; Transform the HL7 response to an AddUpdateHubResponse
		Set tMessageType = $ZConvert(tHL7Response.GetValueAt("MSH:9.1")_"^"_tHL7Response.GetValueAt("MSH:9.2"),"U")
		If tMessageType="ACK^A01"!(tMessageType="ACK^A04")!(tMessageType="ACK^A05")!(tMessageType="ACK^A08") {
			Set pResponse = ##class(HS.Message.AddUpdateHubResponse).%New()
			If tHL7Response.GetValueAt("MSA:1")="AA" Set pResponse.MPIID=tHL7Response.GetValueAt("MSA:3"),pResponse.ErrStatus=$$$OK
			If tHL7Response.GetValueAt("MSA:1")="AE" Set pResponse.ErrStatus=$$$ERROR($$$GeneralError,tHL7Response.GetValueAt("ERR:1"))
		} Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Unsupported HL7v2 Message Encountered: "_tMessageType))
		}

		$$$HSTRACE("AddUpdateHubResponse from HL7 Response", "pResponse", pResponse)
		
		/*
		If tValue'="CA" {
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tResponse.ContentStream,"/hl7:MCCI_IN000002UV01/hl7:acknowledgement/hl7:acknowledgementDetail/hl7:text","text()",.tValue,.tDocument)
			Set pResponse.ErrStatus=$$$ERROR($$$GeneralError,tValue)
		} Else {
			If ..OperationToLocateMPIID]"" {
				Set tQueryRequest=##class(HS.Message.PatientSearchRequest).%New()
				Set tQueryRequest.MRN=pRequest.MRN
				Set tQueryRequest.AssigningAuthority=pRequest.AssigningAuthority
				Set tSC = ..SendRequestSync(..OperationToLocateMPIID,tQueryRequest,.tQueryResponse)
				If $$$ISOK(tSC) && (tQueryResponse.Results.Count()=1) {
					Set pResponse.MPIID=tQueryResponse.Results.GetAt(1).MPIID
					Do tResponse.AdditionalInfo.SetAt(tQueryResponse.Results.GetAt(1).MPIID_"^^^&"_$$$HomeCommunityOID_"&ISO","PatientId")
					Set pResponse.ErrStatus=tQueryRequest.ErrStatus
				}
			}
		}
		*/
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method PIXMerge(pRequest As HS.Message.MergePatientRequest, ByRef pResponse As HS.Message.MergePatientResponse) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = pRequest.NewResponse(.pResponse)
		Quit:$$$ISERR(tSC)
		
		Set tRequest=pRequest.%ConstructClone(1)  /// Copy request so that updates are not saved
		
		#; Update the cached service entry data if needed.
		Do ..UpdateRegistryService(tRequest.AdditionalInfo.GetAt("ServiceName"))
		
		#; Transform MergePatientRequest to HL7 ADT^A40 for PIXv2.
		Set tSC = ..TransformHSMessageToHL7(tRequest, .tHL7Request)
		Quit:$$$ISERR(tSC)
		
		#; ..OnMessage handles send/receive of HL7 Request and HL7 Response and does $$$HSTRACE of them.
		Set tSC=..OnMessage(tHL7Request, .tHL7Response) 
		Quit:$$$ISERR(tSC)
		
		Set tEnvelope = ""
		If pRequest.SAMLData.HSRoles'="" Set tEnvelope = tEnvelope_"|UserRoles="_pRequest.SAMLData.HSRoles_"|"
		Set tEnvelope = tEnvelope_"|FromHost="_$system.INetInfo.HostNameToAddr($system.INetInfo.LocalHostName())_"|"
		Set tEnvelope = tEnvelope_"|ToHost="_$ListGet(..RegistryService,7)_"|"
		Set tHL7Request.Envelope = tEnvelope
		Do $$$ATNAEvent("PIXv2Source", tHL7Request, tHL7Response, tSC)
		
		#; Transform the HL7 response to an MergePatientResponse
		Set tMessageType = $ZConvert(tHL7Response.GetValueAt("MSH:9.1")_"^"_tHL7Response.GetValueAt("MSH:9.2"),"U")
		If tMessageType="ACK^A01"!(tMessageType="ACK^A40") {
			Set pResponse = ##class(HS.Message.MergePatientResponse).%New()
			If tHL7Response.GetValueAt("MSA:1")="AA" Set pResponse.TargetMPIID=tHL7Response.GetValueAt("MSA:3"),pResponse.Accepted=1
			If tHL7Response.GetValueAt("MSA:1")="AE" Set pResponse.Text=tHL7Response.GetValueAt("ERR:1")
		} Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Unsupported HL7v2 Message Encountered: "_tMessageType))
		}
		
		$$$HSTRACE("MergePatientResponse from HL7 Response", "pResponse", pResponse)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Three supported HL7v2 messages:
/// <ul>
/// 		<li>Patient Add:  ADT_A04</li>
/// 		<li>Patient Update:  ADT_A08</li>
/// 		<li>Patient Merge:  ADT_A40</li>
/// <ul>
Method TransformHSMessageToHL7(pSource As %Library.Persistent, ByRef pTarget As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pSource.%IsA("HS.Message.AddUpdateHubRequest") {
			If (pSource.AddOrUpdate = "A") {
				$$$ThrowOnError(..AddRequestToHL7(pSource, .pTarget))
			} ElseIf (pSource.AddOrUpdate = "U") {
				$$$ThrowOnError(..UpdateRequestToHL7(pSource, .pTarget))
			} Else {
				$$$ThrowOnError(..UpdateRequestToHL7(pSource, .pTarget))
			}
		} ElseIf pSource.%IsA("HS.Message.MergePatientRequest") {
			$$$ThrowOnError(..MergeRequestToHL7(pSource, .pTarget))
		} Else {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Unsupported Message Encountered:  " _ pSource.%ClassName(1)))
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method AddRequestToHL7(pSource As HS.Message.AddUpdateHubRequest, ByRef pTarget As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		Set pTarget.DocType = "2.5:ADT_A01"
		
		#; Message Header (MSH)
		Do pTarget.SetValueAt("ADT", "MSH:9.1")
		Set tTrigger = "A04"
		If pSource.EventType="I"!(pSource="IP") Set tTrigger = "A01"
		If pSource.EventType="P"!(pSource="PRE") Set tTrigger = "A05"
		Do pTarget.SetValueAt(tTrigger, "MSH:9.2")
		Do pTarget.SetValueAt("ADT_A01", "MSH:9.3")
		Do pTarget.SetValueAt("2.3.1", "MSH:12.1")
		
		#; Event (EVN)
		Do pTarget.SetValueAt(tTrigger, "EVN:1")
		
		$$$ThrowOnError(..AddOrUpdateRequestToHL7(pSource, .pTarget))
		
		#; Patient Visit (PV1)
		Do pTarget.SetValueAt(1, "PV1:1")
		Do pTarget.SetValueAt("I", "PV1:2")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method UpdateRequestToHL7(pSource As HS.Message.AddUpdateHubRequest, ByRef pTarget As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		Set pTarget.DocType = "2.5:ADT_A01"
		Do pTarget.SetValueAt("2.3.1", "MSH:12.1")
		
		#; Message Header (MSH)
		Do pTarget.SetValueAt("ADT", "MSH:9.1")
		Do pTarget.SetValueAt("A08", "MSH:9.2")
		Do pTarget.SetValueAt("ADT_A01", "MSH:9.3")
		
		#; Event (EVN)
		Do pTarget.SetValueAt("A08", "EVN:1")
		
		$$$ThrowOnError(..AddOrUpdateRequestToHL7(pSource, .pTarget))
		
		#; Patient Visit (PV1)
		Do pTarget.SetValueAt(1, "PV1:1")
		Do pTarget.SetValueAt("I", "PV1:2")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method AddOrUpdateRequestToHL7(pSource As HS.Message.AddUpdateHubRequest, ByRef pTarget As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tCurrentDateTime = $Translate($ZDateTime($Horolog, 3), "-: ", "")
		Do pTarget.SetValueAt(..SendingApplication, "MSH:3") // Sending Application
		Do pTarget.SetValueAt(pSource.Facility, "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt($ListGet(..RegistryService,5), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt($ListGet(..RegistryService,6), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt(tCurrentDateTime, "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		
		#; Event (EVN)
		Do pTarget.SetValueAt(tCurrentDateTime, "EVN:2")
		
		#; Person's Name
		Do pTarget.SetValueAt(pSource.Prefix, "PID:5.5")
		Do pTarget.SetValueAt(pSource.FirstName, "PID:5.2")
		Do pTarget.SetValueAt(pSource.MiddleName, "PID:5.3")
		Do pTarget.SetValueAt(pSource.LastName, "PID:5.1")
		Do pTarget.SetValueAt(pSource.Suffix, "PID:5.4")
		Do pTarget.SetValueAt("L", "PID:5.7")
		
		#; Person's Address
		#;
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
		Do pTarget.SetValueAt(tStreet, "PID:11.1.1")
		Do pTarget.SetValueAt(tCity, "PID:11.3")
		Do pTarget.SetValueAt(tState, "PID:11.4")
		Do pTarget.SetValueAt(tZip, "PID:11.5")
		
		#; Person's Telecoms
		#; Telephone and BusinessPhone are older properties, and
		#; the Telecoms collection is the newer property.
		#; Assume that pSource uses only the old properties or the
		#; new one, and not both.
		If pSource.Telecoms.Count()>1 {
			Set tTelephoneCount = 0
			Set tBusinessPhoneCount = 0
			For tIndex = 1:1:pSource.Telecoms.Count() {
				If pSource.Telecoms.GetAt(tIndex).Use="WP" {
					Set tBusinessPhoneCount = tBusinessPhoneCount + 1
					Set tCurrentCount = tBusinessPhoneCount
					Set tField = 14
				} Else {
					Set tTelephoneCount = tTelephoneCount + 1
					Set tCurrentCount = tTelephoneCount
					Set tField = 13
				}
				
				Set tTelecomUse = pSource.Telecoms.GetAt(tIndex).Use
				Set tUseCode = $Case(tTelecomUse, "AS":"ASN", "WP":"WPN", "H":"PRN", "HP":"PRN", "HV":"VHN", "EC":"EMR", :"")
				
				Set tTelecomType = pSource.Telecoms.GetAt(tIndex).Type
				Set tEquipmentType = $Case(tTelecomType, "F":"FX", "P":"BP", "L":"PH", "M":"CP", :"")
				
				If pSource.Telecoms.GetAt(tIndex).PhoneNumberFull'="",pSource.Telecoms.GetAt(tIndex).PhoneNumber="" {
					Do pTarget.SetValueAt(pSource.Telecoms.GetAt(tIndex).PhoneNumberFull,"PID:"_tField_"("_tCurrentCount_").1")
					Do pTarget.SetValueAt(tUseCode,"PID:"_tField_"("_tCurrentCount_").2")
					Do pTarget.SetValueAt(tEquipmentType,"PID:"_tField_"("_tCurrentCount_").3")
				} ElseIf pSource.Telecoms.GetAt(tIndex).PhoneNumber'="" {
					Do pTarget.SetValueAt(tUseCode,"PID:"_tField_"("_tCurrentCount_").2")
					Do pTarget.SetValueAt(tEquipmentType,"PID:"_tField_"("_tCurrentCount_").3")
					Do pTarget.SetValueAt(pSource.Telecoms.GetAt(tIndex).PhoneCountryCode,"PID:"_tField_"("_tCurrentCount_").5")
					Do pTarget.SetValueAt(pSource.Telecoms.GetAt(tIndex).PhoneAreaCode,"PID:"_tField_"("_tCurrentCount_").6")
					Do pTarget.SetValueAt(pSource.Telecoms.GetAt(tIndex).PhoneNumber,"PID:"_tField_"("_tCurrentCount_").7")
				}			
			}
		} ElseIf pSource.Telephone'=""!(pSource.BusinessPhone'="") {
			Do pTarget.SetValueAt(pSource.Telephone, "PID:13.1")
			Do pTarget.SetValueAt(pSource.BusinessPhone, "PID:14.1")
		}
		
		#; Person's Identifiers
		Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(pSource.AssigningAuthority,"")
		Do pTarget.SetValueAt(pSource.MRN, "PID:2.1")
		Do pTarget.SetValueAt(pSource.AssigningAuthority, "PID:2.4.1")
		Do pTarget.SetValueAt(tAssigningAuthorityOID, "PID:2.4.2")
		Do pTarget.SetValueAt("ISO", "PID:2.4.3")
		Do pTarget.SetValueAt(pSource.MRN, "PID:3(1).1")
		Do pTarget.SetValueAt(pSource.AssigningAuthority, "PID:3(1).4.1")
		Do pTarget.SetValueAt(tAssigningAuthorityOID, "PID:3(1).4.2")
		Do pTarget.SetValueAt("ISO", "PID:3(1).4.3")
		Do pTarget.SetValueAt("MR", "PID:3(1).5")
		Do pTarget.SetValueAt(pSource.SSN, "PID:19")
		Do pTarget.SetValueAt(pSource.DriversLicenseNumber, "PID:20.1")
		
		#; Other Values
		Do pTarget.SetValueAt(pSource.Sex, "PID:8")
		Do pTarget.SetValueAt($Translate($ZDateTime(pSource.DOB,3), "-: ", ""), "PID:7.1")
		Do pTarget.SetValueAt(pSource.MaritalStatus, "PID:16.1")
		Do pTarget.SetValueAt(pSource.ReligiousAffiliation, "PID:17.1")
		Do pTarget.SetValueAt(pSource.Language, "PID:15.1")
		Do pTarget.SetValueAt(pSource.Race, "PID:10.1")
		Do pTarget.SetValueAt(pSource.EthnicGroup, "PID:22.1")
		If pSource.MothersMaidenSurname'="" {
			Do pTarget.SetValueAt(pSource.MothersMaidenSurname, "PID:6.1")
			Do pTarget.SetValueAt("L", "PID:6.7")
		}
		//Do pTarget.SetValueAt(pSource.VIP, "PV1:16")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method MergeRequestToHL7(pSource As HS.Message.MergePatientRequest, ByRef pTarget As EnsLib.HL7.Message) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tCurrentDateTime = $Translate($ZDateTime($Horolog, 3), "-: ", "")
		
		Set pTarget = ##class(EnsLib.HL7.Message).%New()
		Set pTarget.DocType = "2.5:ADT_A39"
		Do pTarget.SetValueAt("2.3.1", "MSH:12.1")
		
		Set tCurrentDateTime = $Translate($ZDateTime($Horolog, 3), "-: ", "")

		#; Message Header (MSH)
		Do pTarget.SetValueAt("ADT", "MSH:9.1")
		Do pTarget.SetValueAt("A40", "MSH:9.2")
		Do pTarget.SetValueAt("ADT_A39", "MSH:9.3")
		Do pTarget.SetValueAt(..SendingApplication, "MSH:3") // Sending Application
		Do pTarget.SetValueAt(pSource.Facility, "MSH:4.1") // Sending Facility
		Do pTarget.SetValueAt($ListGet(..RegistryService,5), "MSH:5.1") // Receiving Application
		Do pTarget.SetValueAt($ListGet(..RegistryService,6), "MSH:6.1") // Receiving Facility
		Do pTarget.SetValueAt(tCurrentDateTime, "MSH:7.1") // Message Date/Time
		Do pTarget.SetValueAt(##class(HS.IHE.Util).GetIdForHL7(),"MSH:10") // Message Control ID
		Do pTarget.SetValueAt("P","MSH:11") // Processing ID (P = Production)
		
		#; Event (EVN)
		Do pTarget.SetValueAt("A40", "EVN:1")
		Do pTarget.SetValueAt(tCurrentDateTime, "EVN:2")

		#; Person's Name
		Do pTarget.SetValueAt(pSource.AdditionalInfo.GetAt("familyName"), "PIDgrp(1).PID:5.1")
		Do pTarget.SetValueAt(pSource.AdditionalInfo.GetAt("givenName"), "PIDgrp(1).PID:5.2")
		Do pTarget.SetValueAt("L", "PIDgrp(1).PID:5.7")
		
		#; Person's new identifiers
		Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(pSource.AssigningAuthority,"")
		Do pTarget.SetValueAt(pSource.MRN, "PIDgrp(1).PID:2.1")
		Do pTarget.SetValueAt(pSource.AssigningAuthority, "PIDgrp(1).PID:2.4.1")
		Do pTarget.SetValueAt(tAssigningAuthorityOID, "PIDgrp(1).PID:2.4.2")
		Do pTarget.SetValueAt("ISO", "PIDgrp(1).PID:2.4.3")
		Do pTarget.SetValueAt(pSource.MRN, "PIDgrp(1).PID:3(1).1")
		Do pTarget.SetValueAt(pSource.AssigningAuthority, "PIDgrp(1).PID:3(1).4.1")
		Do pTarget.SetValueAt(tAssigningAuthorityOID, "PIDgrp(1).PID:3(1).4.2")
		Do pTarget.SetValueAt("ISO", "PIDgrp(1).PID:3(1).4.3")
		Do pTarget.SetValueAt("MR", "PIDgrp(1).PID:3(1).5")
		
		#; Person's prior identifiers
		Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(pSource.PriorAssigningAuthority,"")
		Do pTarget.SetValueAt(pSource.PriorMRN, "PIDgrp(1).MRG:4.1")
		Do pTarget.SetValueAt(pSource.PriorAssigningAuthority, "PIDgrp(1).MRG:4.4.1")
		Do pTarget.SetValueAt(tAssigningAuthorityOID, "PIDgrp(1).MRG:4.4.2")
		Do pTarget.SetValueAt("ISO", "PIDgrp(1).MRG:4.4.3")
		Do pTarget.SetValueAt(pSource.PriorMRN, "PIDgrp(1).MRG:1(1).1")
		Do pTarget.SetValueAt(pSource.PriorAssigningAuthority, "PIDgrp(1).MRG:1(1).4.1")
		Do pTarget.SetValueAt(tAssigningAuthorityOID, "PIDgrp(1).MRG:1(1).4.2")
		Do pTarget.SetValueAt("ISO", "PIDgrp(1).MRG:1(1).4.3")
		Do pTarget.SetValueAt("MR", "PIDgrp(1).MRG:1(1).5")
		
		#; Patient Visit (PV1)
		Do pTarget.SetValueAt(1, "PIDgrp(1).PV1:1")
		Do pTarget.SetValueAt("I", "PIDgrp(1).PV1:2")
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
