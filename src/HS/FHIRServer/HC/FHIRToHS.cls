Include (HS.HC, HS.FHIRServer)

/// This class provides methods for converting FHIRServer request information into an HS request message.
Class HS.FHIRServer.HC.FHIRToHS
{

Parameter SupportedParams As %String = ",_count,_id,family,given,birthdate,gender,address,address-street,address-city,address-state,address-postalcode,address-country,telecom,phone,identifier,";

ClassMethod IsSearchParamSupported(paramName As %String)
{
	return $Find(..#SupportedParams, "," _ paramName _ ",") > 0
}

/// Convert FHIRServer Patient Search request information into a HS Patient Search request message and return it.
ClassMethod FHIRQueryToPatientSearch(pParameters As HS.FHIRServer.API.Data.QueryParameters = "", pUserID As %String = "", pRoles As %String = "", pSearchMode As %String = "user", pBreakTheGlass As %Boolean = 0, pAffinityDomainCode As %String = "", pURIMode As %String = "strict") As HS.Message.PatientSearchRequest
{
	// Gather multiple errors into tSC. Intialize to 1 here.
	Set tSC = $$$OK
	
	// Instantiate target message
	Set tHSRequest = ##class(HS.Message.PatientSearchRequest).%New()
	
	// Validate SearchMode based on the tHSRequest class.
	Set tHSRequest.SearchMode = pSearchMode
	$$$ThrowOnError(tHSRequest.%ValidateObject())
	
	Set tHSRequest.RequestingUser = pUserID
	Set tHSRequest.RequestingUserRoles = pRoles
	
	Set tId = pParameters.GetParameterValue("_id", 1, .tModifier)
	If tId'="" {
		If pParameters.GetParameterCount("_id")>1 {
			$$$FHIRAddError(tSC, $$$ERROR($$$GeneralError, "Invalid multiple _id parameters specified", $$$OutcomeInvalid(400)))
		}
		If tId["," {
			$$$FHIRAddError(tSC, $$$ERROR($$$GeneralError, "Invalid multiple _id values specified", $$$OutcomeInvalid(400)))
		}
		Set tHSRequest.MPIID = tId
	}
	
	Set tExactName = 0
	
	Set tName = pParameters.GetParameterValue("family", 1, .tModifier)
	If tName'="" {
		If tModifier="exact" Set tExactName = 1
		Set tHSRequest.LastName = tName
	}
	Set tName = pParameters.GetParameterValue("given", 1, .tModifier)
	If tName'="" {
		If tModifier="exact" Set tExactName = 1
		Set tHSRequest.FirstName = tName
	}
	Set tName = pParameters.GetParameterValue("given", 2, .tModifier)
	If tName'="" {
		If tModifier="exact" Set tExactName = 1
		Set tHSRequest.MiddleName = tName
	}
	If ('tExactName) && ((tHSRequest.LastName'="") || (tHSRequest.FirstName'="") || (tHSRequest.MiddleName'="")) {
		Do tHSRequest.AdditionalInfo.SetAt("SRCH", "nameSRCH")
	}
	
	// HS handling of DOB date range is very limited. Only handles range by
	// specifying DOB and DOBRangeEnd. In FHIR this can be expressed using
	// birthdate=geDOBDate&birthdate=leDOBRangeEndDate.
	Set tBirthParamName = "birthdate"
	For i = 1, 2 {
		Set tDOB(i) = pParameters.GetParameterValue(tBirthParamName, i)
		Set tPre = $Extract(tDOB(i), 1, 2)
		If tPre?2L {
			Set tPrefixes(i) = tPre
			Set tPrefixes(tPre) = i
		}
	}
	
	If tDOB(1)'="" {
		If (tDOB(1)[",") || (tDOB(2)[",") {
			// HS does not handle multiple birthdate (OR) values on single parameter,
			$$$FHIRAddError(tSC, $$$ERROR($$$GeneralError, "Unsupported multiple values on birthdate parameter specified", $$$OutcomeIs(400, "error", "not-supported")))
		} ElseIf (tDOB(1)'?.2L4N1"-"2N1"-"2N) || (tDOB(1)["-00") {
			// Date search value must be well-formed.
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidQueryParameterValue, tBirthParamName, tDOB(1), $$$OutcomeInvalid(400)))
		} ElseIf (tDOB(2)'="") && ((tDOB(2)'?.2L4N1"-"2N1"-"2N) || (tDOB(2)["-00")) {
			// Date search value must be well-formed.
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidQueryParameterValue, tBirthParamName, tDOB(2), $$$OutcomeInvalid(400)))
		} ElseIf tDOB(2)'="" {
			// If two birthdate parameters, then one must have ge prefix and one must have le prefix.
			If ($Data(tPrefixes("ge"))) && ($Data(tPrefixes("le"))) {
				Set tHSRequest.DOB = $ZDateH($Extract(tDOB(tPrefixes("ge")), 3, *), 8)
				Set tHSRequest.DOBRangeEnd = $ZDateH($Extract(tDOB(tPrefixes("le")), 3, *), 8)
			} Else {
				If ($Get(tPrefixes(1))'="") && ($Get(tPrefixes(1))'="ge") && ($Get(tPrefixes(1))'="le") {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrPrefixValueNotSupported, tBirthParamName, tPrefixes(1), $$$OutcomeIs(400, "error", "not-supported")))
				} ElseIf ($Get(tPrefixes(2))'="") && ($Get(tPrefixes(2))'="ge") && ($Get(tPrefixes(2))'="le") {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrPrefixValueNotSupported, tBirthParamName, tPrefixes(2), $$$OutcomeIs(400, "error", "not-supported")))
				}
			}
		} Else {
			If $Get(tPrefixes(1))="eq" {
				Set tHSRequest.DOB = $ZDateH($Extract(tDOB(1), 3 ,*), 8)
			} ElseIf $Get(tPrefixes(1))'="" {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrPrefixValueNotSupported, tBirthParamName, tPrefixes(1), $$$OutcomeIs(400, "error", "not-supported")))
			} Else {
				Set tHSRequest.DOB = $ZDateH(tDOB(1), 8)
			}
		}
	}
	
	Set tSex = pParameters.GetParameterValue("gender")
	
	If tSex'="" {
		If tSex["|" Set tSex = $Piece(tSex, "|", 2)
		If tSex'="" {
			Set tSex = $Case(tSex, "male":"M", "female":"F", "other":"O", "unknown":"U", :"U")
			Set tHSRequest.Sex = tSex
		}
	}
	
	// address (not address-*) will work, but only in narrow uses.
	// - street line, city, state, postalCode must be separated by comma.
	// - From the start, each value must be stated as a whole match, not as
	//   a "starts with". For example, searching on "1 Memorial" will not
	//   find addresses whose street is "1 Memorial Drive".
	Set tAddr = pParameters.GetParameterValue("address", 1, .tModifier)
	If tAddr'="" {
		Set tDelim = "|"
		Set tStreet = $ZStrip($Piece(tAddr, tDelim, 1), "<>W")
		Set tCity = $ZStrip($Piece(tAddr, tDelim, 2), "<>W")
		Set tState = $ZStrip($Piece(tAddr, tDelim, 3), "<>W")
		Set tZip = $ZStrip($Piece(tAddr, tDelim, 4), "<>W")
		Set tCountry = $ZStrip($Piece(tAddr, tDelim, 5), "<>W")
		Set tAddrObj = ##class(HS.Types.Address).%New()
		Set tAddrObj.StreetLine = tStreet
		Set tAddrObj.City = tCity
		Set tAddrObj.State = tState
		Set tAddrObj.PostalCode = tZip
		Set tAddrObj.Country = tCountry
		Do tHSRequest.Addresses.Insert(tAddrObj)
		Set tHSRequest.Street = tStreet
		Set tHSRequest.City = tCity
		Set tHSRequest.State = tState
		Set tHSRequest.Zip = tZip
	} Else {
		Set tStreet = pParameters.GetParameterValue("address-street", 1, .tModifier)
		If tStreet'="" Set tHSRequest.Street = tStreet
		Set tCity = pParameters.GetParameterValue("address-city", 1, .tModifier)
		If tCity'="" Set tHSRequest.City = tCity
		Set tState = pParameters.GetParameterValue("address-state", 1, .tModifier)
		If tState'="" Set tHSRequest.State = tState
		Set tZip = pParameters.GetParameterValue("address-postalcode", 1, .tModifier)
		If tZip'="" Set tHSRequest.Zip = tZip
		// There is no Country property on PatientSearchRequest, but there is one on HS.Types.Address.
		Set tCountry = pParameters.GetParameterValue("address-country", 1, .tModifier)
		If (tCity'="")||(tState'="")||(tZip'="")||(tCountry'="") {
			Set tAddrObj = ##class(HS.Types.Address).%New()
			If tStreet'="" Set tAddrObj.StreetLine = tStreet
			If tCity'="" Set tAddrObj.City = tCity
			If tState'="" Set tAddrObj.State = tState
			If tZip'="" Set tAddrObj.PostalCode = tZip
			If tCountry'="" Set tAddrObj.Country = tCountry
			Do tHSRequest.Addresses.Insert(tAddrObj)
		}
	}
	
	For tParamName = "telecom", "phone" {
		For i = 1:1:pParameters.GetParameterCount(tParamName) {
			Set tFullValue = pParameters.GetParameterValue(tParamName, i, .tModifier)
			If tFullValue="" Continue
			Set tP1 = $Piece(tFullValue,"|",1)
			Set tP2 = $Piece(tFullValue,"|",2)
			Set tTelecomObj = ##class(HS.Types.Telecom).%New()
			// From HS.Types.Telecom:
			// Property Type As %String(DISPLAYLIST = ",Fax,Pager,Land,Mobile,Other", VALUELIST = ",F,P,L,M,O");
			If tFullValue'["|" {
				Set tTelecomObj.PhoneNumber = tFullValue
				If tHSRequest.Telephone="" Set tHSRequest.Telephone = tFullValue
			} ElseIf (tP1="")&&(tP2'="") {
				Set tTelecomObj.PhoneNumber = tP2
				If tHSRequest.Telephone="" Set tHSRequest.Telephone = tP2
			} ElseIf (tP1'="")&&(tP2'="") {
				If tP1="phone" {
					Set tTelecomObj.PhoneNumber = tP2
					If tHSRequest.Telephone="" Set tHSRequest.Telephone = tP2
				} ElseIf tP1="fax" {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "F"
					If tHSRequest.Telephone="" Set tHSRequest.Telephone = tP2
				} ElseIf tP1="email" {
					// There is no Email property on PatientSearchRequest.
					$$$FHIRAddError(tSC, $$$ERROR($$$GeneralError, "Search by e-mail address is not supported", $$$OutcomeIs(400, "error", "not-supported")))
				} ElseIf tP1="pager" {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "P"
					If tHSRequest.Telephone="" Set tHSRequest.Telephone = tP2
				} ElseIf tP1="url" {
					// There is no Url property on PatientSearchRequest.
					$$$FHIRAddError(tSC, $$$ERROR($$$GeneralError, "Search by url is not supported", $$$OutcomeIs(400, "error", "not-supported")))
				} ElseIf tP1="sms" {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "O"
					If tHSRequest.Telephone="" Set tHSRequest.Telephone = tP2
				} Else {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "O"
					If tHSRequest.Telephone="" Set tHSRequest.Telephone = tP2
				}
				
			}
			Do tHSRequest.Telecoms.Insert(tTelecomObj)
		}
	}
	
	Set tIdentifier = ""
	Set tIdentifierType = ""
	
	// Piece 1 by vertical bar is assigning authority (aka system).
	// Piece 2 by vertical bar is the identifier.
	For i = 1:1:pParameters.GetParameterCount("identifier") {
		Set tParamVal = pParameters.GetParameterValue("identifier", i)
		For j = 1:1:$Length(tParamVal,",") {
			Set tIdentifier = $Piece(tParamVal, ",", j)
			If tIdentifier'="" {
				Set tP1 = $Piece(tIdentifier,"|",1)
				Set tP2 = $Piece(tIdentifier,"|",2)
				If ((tP1="2.16.840.1.113883.4.1")||(tP1="urn:oid:2.16.840.1.113883.4.1")||(tP1="http://hl7.org/fhir/sid/us-ssn"))&&(tP2'="") {
					Set tHSRequest.SSN = tP2
				} ElseIf (tP1'="")&&(tP2'="") {
					// system and code
					Set tIdentifiers(tP1,tP2)=""
				} ElseIf (tP1'="")&&(tP2="") {
					If $Extract(tIdentifier,*)="|" {
						// Trailing vertical bar when only piece 1 is present means
						// scoping organization / targetSystem is being specified.
						//Set tSC = ..SetScopingOrganization(tHSRequest, tP1)
						// HS Patient Search does not handle this, the returned
						// search results will need to be further filtered by
						// this system/assigningAuthority/scopingOrganization.
						Set tAA = $Piece(tP1, "|", 1)
						Set tSC2 = ..ParseISCURI(tAA, pURIMode, .tCodeType, .tFacilityCode)
						If $$$ISERR(tSC2) {
							$$$FHIRAddError(tSC, tSC2)
						} ElseIf tFacilityCode="" {
							$$$FHIRAddError(tSC, $$$ERROR($$$GeneralError, "targetSystem not found", $$$OutcomeIs(400, "error", "value")))
						}
						Do tHSRequest.AdditionalInfo.SetAt("", "scopingOrganization_"_tFacilityCode)
						Do tHSRequest.AdditionalInfo.SetAt("","ScopingOrganizations")
					} Else {
						// No trailing vertical bar means just the MRN.
						// HS Patient Search handles this as desired.
						Set tHSRequest.MRN = tP1
					}
				} ElseIf (tP1="")&&(tP2'="") {
					// When only piece 2 is present it means just the MRN.
					Set tHSRequest.MRN = tP2
				} Else {
					// Just a single vertical bar?
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidQueryParameterValue, "identifier", tIdentifier, $$$OutcomeIs(400, "error", "value")))
				}
			}
		}
	}
	
	Set tAA = ""
	For {
		Set tAA = $Order(tIdentifiers(tAA))
		If tAA="" Quit
		Set tId = ""
		For {
			Set tId = $Order(tIdentifiers(tAA, tId))
			If tId="" Quit
			Do ..SetIdentifier(tHSRequest, tAA, tId, pAffinityDomainCode, pURIMode, .tSC)
		}
	}
	
	$$$ThrowOnError(tSC)
	
	Return tHSRequest
}

/// SetIdentifier takes an assigning authority and identifier and
/// sets the search MPIID or MRN, depending on the input values.
ClassMethod SetIdentifier(pHSRequest As HS.Message.PatientSearchRequest, pAA As %String, pId As %String, pAffinityDomainCode As %String = "", pURIMode As %String = "strict", ByRef pSC As %Status)
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..ParseISCURI(pAA, pURIMode, .tCodeType, .tAssigningAuthorityCode)
		If $$$ISERR(tSC) {
			$$$FHIRAddError(pSC, tSC)
		} ElseIf ((tAssigningAuthorityCode="") || ((tCodeType'="") && (tCodeType'="assigningauthority"))) {
			$$$FHIRAddError(pSC, $$$ERROR($$$GeneralError, pAA_" Assigning Authority not found", $$$OutcomeIs(400, "error", "code-invalid")))
		}
		
		If pURIMode="strict" {
			Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode, "")
			If tAssigningAuthorityOID="" {
				$$$FHIRAddError(pSC, $$$ERROR($$$GeneralError, tAssigningAuthorityCode_" Assigning Authority not found", $$$OutcomeIs(400, "error", "code-invalid")))
			}
			
			Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(pAffinityDomainCode)
			
			// AffinityDomain info needs to be defined in the Config Registry or on the
			// "AffinityDomain" setting on this business host, combined with an entry
			// in the OID Registry, in order to accurately assess whether an identifier
			// is an MPIID or not. In the absence of those definitions, assume it is not.
			If (tAffinityDomainOID'="") && (tAssigningAuthorityOID=tAffinityDomainOID) {
				Set pHSRequest.MPIID = pId
			} Else {
				Set pHSRequest.MRN = pId
				Set pHSRequest.AssigningAuthority = tAssigningAuthorityCode
			}
		
		} Else {
			If (pAffinityDomainCode=tAssigningAuthorityCode) {
				Set pHSRequest.MPIID = pId
			} Else {
				Set pHSRequest.MRN = pId
				Set pHSRequest.AssigningAuthority = tAssigningAuthorityCode
			}
		}
		
	} Catch eException {
		Set pSC = $$$OK
		$$$FHIRAddError(pSC, $$$ERROR($$$GeneralError, eException.AsStatus(), $$$OutcomeIs(500, "error", "exception")))
	}
	
	Quit
}

/// GetURI wraps the logic for obtaining a Code, based on a specified URI.
ClassMethod ParseISCURI(pURI As %String, pMode As %String = "strict", Output pType As %String, Output pCode As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pType = ""
	Set pCode = ""
	
	Try {
		// Look in the OID Registry for a Code that maps to the specified URI.
		set pCode = ##class(HS.Data.OIDMap).GetCodeForURI(pURI, "")
		if pCode'="" quit
		
		if pMode="strict" quit
		
		// If none found, then try to derive a Code from a "ISC-formatted URL".
		if ($length(pURI,"/")<5)||(($extract(pURI,1,7)'="http://")&&($extract(pURI,1,8)'="https://")) {
			set tSC = $$$ERROR($$$GeneralError,"Invalid URI: "_pURI)
			quit
		}
		set pType = $piece(pURI,"/",$length(pURI,"/")-1)
		set pCode = $piece(pURI,"/",$length(pURI,"/"))
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
