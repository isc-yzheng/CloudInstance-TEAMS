Include HS.HC

Class HS.FHIR.vDSTU2.PDQm.Supplier.Process Extends (Ens.BusinessProcess, HS.HC.IHE.PDQ.Common) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "AffinityDomain,AffinityDomainIsMPIID,MPIOperations,ApplyRankMultiplier,ApplyConsent";

Parameter QUERYIDPARAM = "queryId";

Parameter QUERYPAGEPARAM = "page";

/// Override this class parameter to trigger more lenient handling of assigning authority
/// and facility code values that do not have an entry defined in the OID Registry. The
/// default value of "strict" retains the more strict behavior that requires that any AA
/// or facility code that is returned from a search on the designated MPI host must have
/// a URI (OID or URL) defined for it in the OID Registry. If one is not found, then the
/// associated identifier is removed from the return result set and a warning is included
/// in the returned payload. If the value of FHIRURIMODE is overidden and modified to any
/// other value, then if no data is found in the OID Registryfor a code, a URL is then
/// formulated dynamically, formatted as http://hostname/codetype/code, where hostname is
/// the host name, codetype is "assigningauthority" or "facilitycode", and code is the
/// code that was returned from the MPI. This URL will satisfy the data type requirement
/// of "uri" for the "system" property of the identifier. <b>Please note</b> that AffinityDomain
/// is exempt from the non-strict behavior, and that any use of this PDQm component
/// requires that the AffinityDomain code be defined in the Configuration Registry or on
/// this business host, and that code is defined in the OID Registry.
Parameter FHIRURIMODE = "strict";

/// Class package that is the root of all resource schemas for the desired data model.
Property ResourceSchemaRoot As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vDSTU2.Model.Resource" ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	#dim eException As %Exception.AbstractException
	try {
		Set tSC=$$$OK
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set:..AffinityDomain="" ..AffinityDomain=$$$AffinityDomain
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			If pRequest.Interaction'="conformance" {
				Set tSC = ..ProcessFHIRMessage(pRequest, .pResponse)
			} Else {
				Set tSC = ..ProcessMetadataRequest(pRequest, .pResponse)
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Message class "_pRequest.%ClassName(1)_" not handled")
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

Method ProcessFHIRMessage(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tRequest As HS.Message.FHIR.Request
		
		#; Clone pRequest to tPDQmRequest so that changes are only applied to tRequest
		Set tRequest = pRequest.%ConstructClone(1)
		
		// If invalid ContentType per DSTU2 then change it to a valid ContentType.
		Set tRequest.ContentType = ##class(HS.FHIR.Utils).EnsureContentType(tRequest.ContentType, "DSTU2")
		
		#; PDQm request must be a search or read on the Patient resource type.
		If tRequest.Type'="Patient" {
			Do ..Errors.logError("invalid", "error", "Invalid resource type for PDQm - "_tRequest.Type)
			Quit
		} ElseIf ((tRequest.Interaction'="search")&&(tRequest.Interaction'="read")) {
			Do ..Errors.logError("invalid", "error", "Invalid interaction for PDQm - "_tRequest.Interaction)
			Quit
		}
		
		Set tFullRequestURI = ##class(HS.FHIR.Utils).GetURLWithQuery(tRequest, .tSC)
		If $$$ISERR(tSC) Quit
		
		$$$HSTRACE("Request full URI", "tFullRequestURI", tFullRequestURI)
		
		#; SEARCH PARAMETERS
		#; _count - The number of search matches per page.  If the number
		#;   of matches is less than _count then no continuation links are
		#;   returned.  If the number of matches is greater than _count
		#;   then matches (_count*(page-1))+1 through (_count*(page-1))+_count
		#;   are returned and first, previous, next and last links are
		#;   included in the response.  _count is honored only on an
		#;   initial query and not on a continuation query.  For continuation,
		#;   _count is taken from _count from the initial query.
		#; page - The page number to consider the current page.  Page size
		#;   is determined by _count.  If _count is specified but page is
		#;   not specified then page is set to 1.  If page is greater than
		#;   2 and there is less than page number of pages then page is
		#;   set to the last page.
		#; _id (Patient resource id)
		#; identifier - Assigning authority OID plus identifier, for example
		#;   identifier=urn:oid:1.2.3.4|145&identifier=urn:oid:2.16.840.1.113883.4.1|123456789.
		#;   Multiple identifier parameters constitute an AND search, meaning
		#;   a given patient must have all the specified identifiers.
		#; family (string - must support :exact)
		#; given (string - must support :exact)
		#; birthdate (YYYY, YYYY-MM, YYYY-MM-DD, YYYY-MM-DDTHH:MM:SS)
		#; address (string - must support :exact)
		#; address-city (string - must support :exact)
		#; address-state (string - must support :exact)
		#; address-postalcode (string - must support :exact)
		#; address-country (string - must support :exact)
		#; telecom
		#; gender
		
		#; PDQm requires that all specified URL parameters and specified modifiers
		#; are supported by the PDQm Supplier or else a 400 Bad Request shall be
		#; returned along with an OperationOutcome resource.
		Set tValidParams(..#QUERYIDPARAM) = ""
		Set tValidParams(..#QUERYPAGEPARAM) = ""
		Set tValidParams("_count") = ""
		Set tValidParams("_format") = ""
		Set tValidParams("_id") = ""
		Set tValidParams("identifier") = ""
		Set tValidParams("family") = ",exact,"
		Set tValidParams("given") = ",exact,"
		Set tValidParams("birthdate") = ""
		Set tValidParams("address") = ""
		Set tValidParams("address-city") = ""
		Set tValidParams("address-state") = ""
		Set tValidParams("address-postalcode") = ""
		Set tValidParams("address-country") = ""
		Set tValidParams("gender") = ""
		Set tValidParams("telecom") = ""
		Set tInvalidParams = ""
		Set tInvalidMods = ""
		Set tKey = ""
		For {
			Set tParamItem = tRequest.Parameters.GetNext(.tKey)
			If tKey="" Quit
			Set tName = $Piece(tKey,":",1) 
			Set tModifier = $Piece(tKey,":",2) 
			If '$Data(tValidParams(tName)) {
				If tInvalidParams'="" Set tInvalidParams = tInvalidParams_" and "
				Set tInvalidParams = tInvalidParams_tName
				/*
				// The June 2, 2016 version of ITI-78 has contradictory language regarding
				// handling of invalid/unsupported modifiers.  This logic is inactivated
				// until this issue with the profile specification is resolved.
			} ElseIf (tModifier'="")&&(tValidParams(tName)'[(","_tModifier_",")) {
				If tInvalidMods'="" Set tInvalidMods = tInvalidMods_" and "
				Set tInvalidMods = tInvalidMods_tModifier
				*/
			}
		}
		If tInvalidParams'="" {
			Set tDescription = "Invalid request URL parameter"_$Select(tInvalidParams[" and ":"s ",1:" ")_tInvalidParams_" specified"
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(tRequest, .pResponse, "invalid", tDescription)
			Quit
		} ElseIf tInvalidMods'="" {
			Set tDescription = "Invalid request URL parameter modifier"_$Select(tInvalidMods[" and ":"s ",1:" ")_tInvalidMods_" specified"
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(tRequest, .pResponse, "invalid", tDescription)
			Quit
		}
		
		If tRequest.Interaction="search" {
			Set tSC = ..QueryRequestFHIR(tRequest, tFullRequestURI, .pResponse)
		} ElseIf tRequest.Interaction="read" {
			Set tSC = ..RetrieveRequestFHIR(tRequest, tFullRequestURI, .pResponse)
		}
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
		Do tRequest.AdditionalInfo.SetAt(tRequest.AdditionalInfo.GetAt("ClientAddr"),"FromHost")
		Do tRequest.AdditionalInfo.SetAt(tRequest.Headers.GetAt("HOST"),"ToHost")
		Set tUrl = tRequest.BaseURL
		If $Extract(tUrl,*)'="/" Set tUrl = tUrl_"/"
		Set tParams = ""
		Set tKey = ""
		For {
			Set tValue = tRequest.Parameters.GetNext(.tKey)
			If tKey="" Quit
			If tParams'="" Set tParams = tParams_"&"
			Set tParamValue = ""
			For i = 1:1:$ListLength(tValue) {
				If tParamValue'="" Set tParamValue = tParamValue_","
				Set tParamValue = tParamValue_$ListGet(tValue,i)
			}
			Set tParams = tParams_tKey_"="_tParamValue
		}
		Set tUrl = tUrl_tParams
		Do tRequest.AdditionalInfo.SetAt(tUrl, "Url")
		Set tHeaders = ""
		Set tKey = ""
		For {
			Set tValue = tRequest.Headers.GetNext(.tKey)
			If tKey="" Quit
			If $ZConvert(tKey,"U")="HOST" Continue
			If tHeaders'="" Set tHeaders = tHeaders_";"
			Set tHeaders = tHeaders_tKey_"="_tValue
		}
		Do tRequest.AdditionalInfo.SetAt(tHeaders, "Headers")
		//Do $$$ATNAEvent("PDQmSupplier", tRequest, pResponse, tSC)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	#; Assume any item in this object is Error not Warning and therefore negates any other response.
	If ($$$ISERR(tSC))||(..Errors.Errors.Count()) {
		Set tSC = ..FHIRErrorResponse(pRequest, .tSC, .pResponse)
		Do ..Errors.Errors.Clear()
	}
	
	If $$$HSTRACING {
		If pResponse.QuickStreamId'="" {
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
			$$$HSTRACE("FHIR response message to be returned", "pResponse,tQuickStream", pResponse, tQuickStream)
		} Else {
			$$$HSTRACE("FHIR response message to be returned", "pResponse", pResponse)
		}
	}
	
	Quit tSC
}

Method QueryRequestFHIR(pFHIRRequest As HS.Message.FHIR.Request, pFullSearchURI As %String, Output pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tSearchRequest As HS.Message.PatientSearchRequest
		
		Set tQueryId = pFHIRRequest.GetParameterValue(..#QUERYIDPARAM)
		set tPage = pFHIRRequest.GetParameterValue(..#QUERYPAGEPARAM)
		
		If tQueryId="" {
			#; tQueryId blank means this is a new search, as opposed
			#; to getting a page of results from a previous search.
			Set tQueueObject = ##class(HS.FHIR.vDSTU2.PDQm.QueryQueue).%New()
			Set tQueueObject.InitialFHIRRequest=pFHIRRequest
			Set tQueueObject.InitialRequestDateTime = $ZDateTime($Horolog,3)
			Set tQueueObject.QueryID = $ZConvert($system.Util.CreateGUID(), "L")
			If pFHIRRequest.GetParameterValue("_count")>0 {
				Set tQueueObject.PageSize = pFHIRRequest.GetParameterValue("_count")
			} Else {
				Set tQueueObject.PageSize = 99999
			}
			Set tSC = ..FHIRQueryToPatientSearch(pFHIRRequest, .tSearchRequest)
			If $$$ISERR(tSC) Quit
			If ..Errors.Errors.Count() Quit
			
			Do tSearchRequest.AdditionalInfo.SetAt(tQueueObject.QueryID, "QueryID")
			
			Set tSC = ..SendAndFilter(tSearchRequest, .tQueueObject, "FHIR")
			If $$$ISERR(tSC) Quit
			If ..Errors.Errors.Count() Quit
			
		} Else {
			Set tQueueObject = ##class(HS.FHIR.vDSTU2.PDQm.QueryQueue).%OpenId(tQueryId)
			If $IsObject(tQueueObject)=0 Do ..Errors.logError("value", "error", "Invalid "_..#QUERYIDPARAM_" specified") Quit
		}
		
		If +tPage=0 Set tPage = 1
		
		#; create PDQm Response
		Set tSC = ..CreateQueryResponseFHIR(tQueueObject, pFullSearchURI, tPage, .pFHIRResponse)
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

Method FHIRQueryToPatientSearch(pSource As HS.Message.FHIR.Request, ByRef pTarget As HS.Message.PatientSearchRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(HS.Message.PatientSearchRequest).%New()
		
		#; Establish request as a PIX/PDQ request
		Set pTarget.SearchMode = $S(..ApplyConsent:"PIXPDQ_c",1:"PIXPDQ")
		
		If pSource.AdditionalInfo.GetAt("USER:UserID")'="" {
			Set pTarget.RequestingUser = pSource.AdditionalInfo.GetAt("USER:UserID")
		}
		If pSource.AdditionalInfo.GetAt("USER:Roles")'="" {
			Set pTarget.RequestingUserRoles = pSource.AdditionalInfo.GetAt("USER:Roles")
		}
		
		Set tId = pSource.GetParameterValue("_id", 1, .tModifier)
		If tId'="" {
			If pSource.GetParameterCount("_id")>1 Do ..Errors.logError("value", "error", "Invalid multiple _id parameters specified") Quit
			If tId["," Do ..Errors.logError("value", "error", "Invalid multiple _id values specified") Quit
			Set pTarget.MPIID = tId Quit
		}
		
		Set tIdentifier = ""
		Set tAssigningAuthorityCode = ""
		Set tAssigningAuthorityOID = ""
		Set tIdentifierType = ""
		
		Set tExactName = 0
		
		Set tName = pSource.GetParameterValue("family", 1, .tModifier)
		If tName'="" {
			If tModifier="exact" Set tExactName = 1
			Set pTarget.LastName = tName
		}
		Set tName = pSource.GetParameterValue("given", 1, .tModifier)
		If tName'="" {
			If tModifier="exact" Set tExactName = 1
			Set pTarget.FirstName = tName
		}
		Set tName = pSource.GetParameterValue("given", 2, .tModifier)
		If tName'="" {
			If tModifier="exact" Set tExactName = 1
			Set pTarget.MiddleName = tName
		}
		If tExactName=0&(pTarget.LastName'=""!(pTarget.FirstName'="")!(pTarget.MiddleName'="")) Do pTarget.AdditionalInfo.SetAt("SRCH","nameSRCH")
		
		Set tDOB = pSource.GetParameterValue("birthdate")
		If tDOB'="" {
			#; PDQm functionality here supports only equals for search
			#; by birthdate.  Not Equals, Less Than, and Greater Than
			#; are not supported.
			If tDOB?1"eq"4N1"-"2N1"-"2N Set tDOB = $Extract(tDOB, 3, *)
			If tDOB'?4N1"-"2N1"-"2N Do ..Errors.logError("value", "error", "Unsupported birthdate format specified - "_tDOB) Quit
			If tDOB["-00" Do ..Errors.logError("value", "error", "Unsupported birthdate format specified - "_tDOB) Quit
			Set pTarget.DOB = $ZDateH(tDOB,8)
		}
		
		Set tSex = pSource.GetParameterValue("gender")
		
		If tSex'="" {
			If tSex["|" Set tSex = $Piece(tSex, "|", 2)
			If tSex'="" {
				Set tSex = $Case(tSex, "male":"M", "female":"F", "other":"O", "unknown":"U", :"U")
				Set pTarget.Sex = tSex
			}
		}
		
		Set tAddr = pSource.GetParameterValue("address", 1, .tModifier)
		If tAddr'="" {
			Set tAddrObj = ##class(HS.Types.Address).%New()
			Set tAddrObj.StreetLine = $Piece(tAddr,",",1)
			Set tAddrObj.City = $Piece(tAddr,",",2)
			Set tAddrObj.State = $Piece(tAddr,",",3)
			Set tAddrObj.PostalCode = $Piece(tAddr,",",4)
			Do pTarget.Addresses.Insert(tAddrObj)
			Set pTarget.Street = $Piece(tAddr,",",1)
			Set pTarget.City = $Piece(tAddr,",",2)
			Set pTarget.State = $Piece(tAddr,",",3)
			Set pTarget.Zip = $Piece(tAddr,",",4)
		} Else {
			Set tCity = pSource.GetParameterValue("address-city", 1, .tModifier)
			If tCity'="" Set pTarget.City = tCity
			Set tState = pSource.GetParameterValue("address-state", 1, .tModifier)
			If tState'="" Set pTarget.State = tState
			Set tZip = pSource.GetParameterValue("address-postalcode", 1, .tModifier)
			If tZip'="" Set pTarget.Zip = tZip
			// There is no Country property on PatientSearchRequest, but there is one on HS.Types.Address.
			Set tCountry = pSource.GetParameterValue("address-country", 1, .tModifier)
			If (tCity'="")||(tState'="")||(tZip'="")||(tCountry'="") {
				Set tAddrObj = ##class(HS.Types.Address).%New()
				If tCity'="" Set tAddrObj.City = tCity
				If tState'="" Set tAddrObj.State = tState
				If tZip'="" Set tAddrObj.PostalCode = tZip
				If tCountry'="" Set tAddrObj.Country = tCountry
				Do pTarget.Addresses.Insert(tAddrObj)
			}
		}
		
		For i = 1:1:pSource.GetParameterCount("telecom") {
			Set tFullValue = pSource.GetParameterValue("telecom", i, .tModifier)
			If tFullValue="" Continue
			Set tP1 = $Piece(tFullValue,"|",1)
			Set tP2 = $Piece(tFullValue,"|",2)
			Set tTelecomObj = ##class(HS.Types.Telecom).%New()
			// From HS.Types.Telecom:
			// Property Type As %String(DISPLAYLIST = ",Fax,Pager,Land,Mobile,Other", VALUELIST = ",F,P,L,M,O");
			If tFullValue'["|" {
				Set tTelecomObj.PhoneNumber = tFullValue
				If pTarget.Telephone="" Set pTarget.Telephone = tFullValue
			} ElseIf (tP1="")&&(tP2'="") {
				Set tTelecomObj.PhoneNumber = tP2
				If pTarget.Telephone="" Set pTarget.Telephone = tP2
			} ElseIf (tP1'="")&&(tP2'="") {
				If tP1="phone" {
					Set tTelecomObj.PhoneNumber = tP2
					If pTarget.Telephone="" Set pTarget.Telephone = tP2
				} ElseIf tP1="fax" {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "F"
					If pTarget.Telephone="" Set pTarget.Telephone = tP2
				} ElseIf tP1="email" {
					// There is no Email property on PatientSearchRequest.
					Do ..Errors.logError("not-supported", "error", "Search by e-mail address is not supported")
					Quit
				} ElseIf tP1="pager" {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "P"
					If pTarget.Telephone="" Set pTarget.Telephone = tP2
				} ElseIf tP1="url" {
					// There is no Url property on PatientSearchRequest.
					Do ..Errors.logError("not-supported", "error", "Search by url is not supported")
					Quit
				} ElseIf tP1="sms" {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "O"
					If pTarget.Telephone="" Set pTarget.Telephone = tP2
				} Else {
					Set tTelecomObj.PhoneNumber = tP2
					Set tTelecomObj.Type = "O"
					If pTarget.Telephone="" Set pTarget.Telephone = tP2
				}
				
			}
			Do pTarget.Telecoms.Insert(tTelecomObj)
		}
		
		#; Piece 1 by vertical bar is assigning authority.
		#; Piece 2 by vertical bar is the identifier.
		For i = 1:1:pSource.GetParameterCount("identifier") {
			Set tParamVal = pSource.GetParameterValue("identifier", i)
			For j = 1:1:$Length(tParamVal,",") {
				Set tIdentifier = $Piece(tParamVal, ",", j)
				If tIdentifier'="" {
					Set tP1 = $Piece(tIdentifier,"|",1)
					Set tP2 = $Piece(tIdentifier,"|",2)
					If ((tP1="2.16.840.1.113883.4.1")||(tP1="urn:oid:2.16.840.1.113883.4.1")||(tP1="http://hl7.org/fhir/sid/us-ssn"))&&(tP2'="") {
						Set pTarget.SSN = tP2
					} ElseIf (tP1'="")&&(tP2'="") {
						Set tIdentifiers(tP1,tP2)=""
					} ElseIf (tP1'="")&&(tP2="") {
						If $Extract(tIdentifier,*)="|" {
							// Trailing vertical bar when only piece 1 is present means
							// scoping organization / targetSystem is being specified.
							Set tSC = ..SetScopingOrganization(pTarget, tP1)
							If $$$ISERR(tSC) Quit
							If ..Errors.Errors.Count() Quit
							Do pTarget.AdditionalInfo.SetAt("","ScopingOrganizations")
						} Else {
							// No trailing vertical bar means just the MRN.
							Set pTarget.MRN = tP1
						}
					} ElseIf (tP1="")&&(tP2'="") {
						// When only piece 2 is present it means just the MRN.
						Set pTarget.MRN = tP2
					} Else {
						Do ..Errors.logError("value", "error", "identifier parameter missing value", "identifier") Quit
					}
				}
			}
			If ..Errors.Errors.Count() Quit
		}
		If ..Errors.Errors.Count() Quit
		
		Set tAA = ""
		For {
			Set tAA = $Order(tIdentifiers(tAA))
			If tAA="" Quit
			Set tId = ""
			For {
				Set tId = $Order(tIdentifiers(tAA, tId))
				If tId="" Quit
				Set tSC = ..SetIdentifier(pTarget, tAA, tId)
			}
		}
		
		If pSource.GetParameterValue("_count")'="" Do pTarget.AdditionalInfo.SetAt(pSource.GetParameterValue("_count"),"_count")
		If pSource.GetParameterValue("page")'="" Do pTarget.AdditionalInfo.SetAt(pSource.GetParameterValue("page"),"page")
		
		$$$HSTRACE("HS Message from PDQm Request", "pTarget", pTarget)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC))
	}
		
	Quit tSC
}

/// SetScopingOrganization takes an assigning authority value,
/// determines the Code for it, and inserts an AdditionalInfo
/// item with a key indicating that scopingOrganization.  An
/// example key would be "scopingOrganization_LIJ".
Method SetScopingOrganization(pTarget As HS.Message.PatientSearchRequest, pAA As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("Evaluating scoping organization", "pAA", pAA)
		
		Set pAA = $Piece(pAA, "|", 1)
		Set tSC = ##class(HS.FHIR.Utils).ParseISCURI(pAA, ..#FHIRURIMODE, , .tFacilityCode)
		If ($$$ISERR(tSC))||(tFacilityCode="") {
			Set tSC = $$$OK
			Do ..Errors.logError("value", "error", "targetSystem not found")
			Quit
		}
		Do pTarget.AdditionalInfo.SetAt("", "scopingOrganization_"_tFacilityCode)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

/// SetIdentifier takes an assigning authority and identifier
/// and sets the search MPIID or MRN, depending on the input
/// values.
Method SetIdentifier(pTarget As HS.Message.PatientSearchRequest, pAA As %String, pId As %String) As %String
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ##class(HS.FHIR.Utils).ParseISCURI(pAA, ..#FHIRURIMODE, .tCodeType, .tAssigningAuthorityCode)
		If ($$$ISERR(tSC))||(tAssigningAuthorityCode="")||((tCodeType'="")&&(tCodeType'="assigningauthority")) {
			Set tSC = $$$OK
			Do ..Errors.logError("code-invalid","error",pAA_" Assigning Authority not found")
			Quit
		}
		
		If ..#FHIRURIMODE="strict" {
		
			Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode, "")
			If tAssigningAuthorityOID="" Do ..Errors.logError("code-invalid","error",tAssigningAuthorityCode_" Assigning Authority not found") Quit
			
			Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain)
			// AffinityDomain info needs to be defined in the Config Registry or on the
			// "AffinityDomain" setting on this business host, combined with an entry
			// in the OID Registry, in order to accurately assess whether an identifier
			// is an MPIID or not. In the absence of those definitions, assume it is not.
			If (tAffinityDomainOID'="")&&(tAssigningAuthorityOID=tAffinityDomainOID) {
				Set pTarget.MPIID = pId
			} Else {
				Set pTarget.MRN = pId,pTarget.AssigningAuthority=tAssigningAuthorityCode
			}
		
		} Else {
			
			If (..AffinityDomain=tAssigningAuthorityCode) {
				Set pTarget.MPIID = pId
			} Else {
				Set pTarget.MRN = pId,pTarget.AssigningAuthority=tAssigningAuthorityCode
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

Method RetrieveRequestFHIR(pFHIRRequest As HS.Message.FHIR.Request, pFullSearchURI As %String, Output pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tSearchRequest As HS.Message.PatientSearchRequest
		#dim tSearchResponse As HS.Message.PatientSearchResponse
		
		Set tSC = ..PDQmRetrieveToPatientSearch(pFHIRRequest, .tSearchRequest)
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
		$$$HSTRACE("HS Message from PDQm Request", "tSearchRequest", tSearchRequest)
		
		#; take the PatientSearchRequest and execute
		Set tSC = ..SendQueryRequest(tSearchRequest, .tSearchResponse)
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
		If tSearchResponse.Results.Count()=0 {
			Do ..Errors.logError("not-found", "error", "Patient resource id "_pFHIRRequest.Id_" not found")
			Quit
		}
		
		#; create PDQ Response
		Set tSC = ..CreateRetrieveResponseFHIR(pFHIRRequest, tSearchResponse, .pFHIRResponse)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC))
	}
	
	Quit tSC
}

Method PDQmRetrieveToPatientSearch(pSource As HS.Message.FHIR.Request, ByRef pTarget As HS.Message.PatientSearchRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pTarget = ##class(HS.Message.PatientSearchRequest).%New()
		
		#; Establish request as a PIX/PDQ request
		Set pTarget.SearchMode = $S(..ApplyConsent:"PIXPDQ_c",1:"PIXPDQ")
		
		If pSource.AdditionalInfo.GetAt("USER:UserID")'="" {
			Set pTarget.RequestingUser = pSource.AdditionalInfo.GetAt("USER:UserID")
		}
		If pSource.AdditionalInfo.GetAt("USER:Roles")'="" {
			Set pTarget.RequestingUserRoles = pSource.AdditionalInfo.GetAt("USER:Roles")
		}
		
		Set pTarget.MPIID = pSource.Id
		
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC))
	}
		
	Quit tSC
}

Method CreateQueryResponseFHIR(pQueueObject As HS.FHIR.vDSTU2.PDQm.QueryQueue, pFullSearchURI As %String, pPage As %Integer, Output pPDQmResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = pQueueObject.InitialFHIRRequest.NewResponse(.pPDQmResponse) Quit:$$$ISERR(tSC)
		
		$$$HSTRACE("pQueueObject filtered response", "pQueueObject.SearchResponse", pQueueObject.SearchResponse.%ConstructClone(1))
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pPDQmResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tQueryId = pQueueObject.QueryID
		Set tTotal = pQueueObject.SearchResponse.Results.Count()
		Set tPageSize = pQueueObject.PageSize
		
		Set tSC = ..GetPageLinks(pQueueObject.InitialFHIRRequest, tQueryId, tTotal, tPageSize, pPage, .tFirstUrl, .tPrevUrl, .tNextUrl, .tLastUrl)
		Quit:$$$ISERR(tSC)
		
		// Set the cache index boundaries for the current response Bundle.
		if tTotal'>tPageSize {
			set tStart = 1
			set tEnd = tTotal
		} elseif pPage=1 {
			set tStart = 1
			set tEnd = tPageSize
		} else {
			set tStart = (tPageSize*(pPage-1))+1
			if (tPageSize*pPage)'<tTotal {
				set tEnd = tTotal 
			} else {
				set tEnd = tPageSize*pPage
			}
		}
		
		Set tBundle = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle).%New()
		Set tSC = tBundle.SetId($ZConvert($SYSTEM.Util.CreateGUID(),"L")) Quit:$$$ISERR(tSC)
		Do tBundle.SetType("searchset")
		Set tBase = ##class(HS.FHIR.Utils).GetURLBase(pQueueObject.InitialFHIRRequest, .tSC) Quit:$$$ISERR(tSC)
		If tFirstUrl'="" Set tSC = tBundle.SetLink("first", tFirstUrl) Quit:$$$ISERR(tSC)
		If tPrevUrl'="" Set tSC = tBundle.SetLink("previous", tPrevUrl) Quit:$$$ISERR(tSC)
		Set tQueryURL = ##class(HS.FHIR.Utils).GetURLWithQuery(pQueueObject.InitialFHIRRequest, .tSC) Quit:$$$ISERR(tSC)
		Set tSC = tBundle.SetLink("self", tQueryURL) Quit:$$$ISERR(tSC)
		If tNextUrl'="" Set tSC = tBundle.SetLink("next", tNextUrl) Quit:$$$ISERR(tSC)
		If tLastUrl'="" Set tSC = tBundle.SetLink("last", tLastUrl) Quit:$$$ISERR(tSC)
		
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain, ..AffinityDomain)
		
		#dim tResult As HS.Message.PatientSearchMatch
		For i = tStart:1:tEnd {
			#; Note that this SearchResponse is one formulated for pQueueObject,
			#; and is slightly different from the SearchResponse returned
			#; directly from MPIOperations.
			Set tResult = pQueueObject.SearchResponse.Results.GetAt(i)
			Set tPatient = ##class(HS.FHIR.vDSTU2.Model.Resource.Patient).%New()
			
			If tResult.MPIID'="" {
				Set tIdentifier = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New()
				Do tIdentifier.SetUse("official")
				Do tIdentifier.SetType(, , , "MPIID")
				Set tSC = tIdentifier.SetValue(tResult.MPIID) Quit:$$$ISERR(tSC)
				// AffinityDomain info needs to be defined in the Config Registry or on the
				// "AffinityDomain" setting on this business host, combined with an entry
				// in the OID Registry, in order to get the system OID to use.
				If tAffinityDomainOID'="" {
					Set tSC = tIdentifier.SetSystem(tAffinityDomainOID) Quit:$$$ISERR(tSC)
					Set tSC = tIdentifier.SetAssigner( , ..AffinityDomain) Quit:$$$ISERR(tSC)
				}
				Do tPatient.identifier.Insert(tIdentifier)
				Do tPatient.SetId(tResult.MPIID)
			}
			
			For j = 1:1:tResult.IDs.Count() {
				Set tAssigningAuthority = tResult.IDs.GetAt(j).AssigningAuthority
				Set tAssigningAuthorityType = tResult.IDs.GetAt(j).AssigningAuthorityType
				Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthority, tAssigningAuthority)
				// AffinityDomain info needs to be defined in the Config Registry or on the
				// "AffinityDomain" setting on this business host, combined with an entry
				// in the OID Registry, in order to accurately assess whether an identifier
				// is an MPIID or not. In the absence of those definitions, assume it is not.
				If (tAffinityDomainOID'="")&&(tAssigningAuthorityOID=tAffinityDomainOID) {
					If tResult.MPIID="" {
						Set tIdentifier = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New()
						Do tIdentifier.SetUse("official")
						Do tIdentifier.SetType(, , , "MPIID")
						Set tSC = tIdentifier.SetValue(tResult.IDs.GetAt(j).MRN) Quit:$$$ISERR(tSC)
						Set tSystemURI = ##class(HS.FHIR.Utils).GetURI("assigningauthority", tAssigningAuthority, ..#FHIRURIMODE, tAssigningAuthority)
						If '##class(HS.HC.Util).IsURI(tSystemURI, 1) {
							Do ..Errors.logError("code-invalid", "warning", "Unable to determine URI for assigning authority '"_tAssigningAuthority_"' - identifier '"_tResult.IDs.GetAt(j).MRN_"' removed from search response")
							Continue
						} Else {
							Set tSC = tIdentifier.SetSystem(tSystemURI) Quit:$$$ISERR(tSC)
						}
						Set tSC = tIdentifier.SetAssigner( , tResult.IDs.GetAt(j).AssigningAuthority) Quit:$$$ISERR(tSC)
						Do tPatient.identifier.Insert(tIdentifier)
						Do tPatient.SetId(tResult.IDs.GetAt(j).MRN)
					}
				} ElseIf tAssigningAuthorityType="PAT" {
					If '((tResult.MPIID=tResult.IDs.GetAt(j).MRN)&&(tAffinityDomainOID="")) {
						Set tIdentifier = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New()
						Do tIdentifier.SetUse("official")
						Do tIdentifier.SetType("MR", "Medical Record Number", "http://hl7.org/fhir/v2/0203", "MRN")
						Set tSC = tIdentifier.SetValue(tResult.IDs.GetAt(j).MRN) Quit:$$$ISERR(tSC)
						Set tSystemURI = ##class(HS.FHIR.Utils).GetURI("assigningauthority", tAssigningAuthority, ..#FHIRURIMODE, tAssigningAuthority)
						If '##class(HS.HC.Util).IsURI(tSystemURI, 1) {
							Do ..Errors.logError("code-invalid", "warning", "Unable to determine URI for assigning authority '"_tAssigningAuthority_"' - identifier '"_tResult.IDs.GetAt(j).MRN_"' removed from search response")
							Continue
						} Else {
							Set tSC = tIdentifier.SetSystem(tSystemURI) Quit:$$$ISERR(tSC)
						}
						Set tSC = tIdentifier.SetAssigner( , tResult.IDs.GetAt(j).AssigningAuthority) Quit:$$$ISERR(tSC)
						Do tPatient.identifier.Insert(tIdentifier)
					}
				}
			}
			Quit:$$$ISERR(tSC)
			
			If tResult.SSN'="" {
				Set tSSNURI = ##class(HS.Data.OIDMap).GetURIForCode("SSN", "")
				If tSSNURI="" Set tSSNURI = "urn:oid:2.16.840.1.113883.4.1"
				// "SB" (Social Beneficiary Identifier) is as per the expansion of
				// value set http://hl7.org/fhir/identifier-type, as noted at
				// http://hl7.org/fhir/DSTU2/valueset-identifier-type.html.
				// ISC deems SB to be the more appropriate alternative to SSN and TAXID.
				Set tSC = tPatient.SetIdentifier(tResult.SSN, tSSNURI, "official", "SB", "http://hl7.org/fhir/identifier-type")
				Quit:$$$ISERR(tSC)
			}
			
			Do tPatient.SetActive(1)
			
			// Get the primary name in the search result.
			Set tNameText = tResult.FirstName_$Select(tResult.FirstName'="":" ",1:"")_tResult.MiddleName_$Select(tResult.MiddleName'="":" ",1:"")_tResult.LastName
			Set tSC = tPatient.SetName(tResult.LastName, tResult.FirstName, tResult.MiddleName, tResult.Prefix, tResult.Suffix, "official", tNameText)
			Quit:$$$ISERR(tSC)
			
			// Because SDA3-to-AddUpdateHub.xsl at this time only puts Aliases into the Names
			// collection, this code assumes that anything in the Names collection is an Alias.
			#dim tName As HS.Types.PersonName
			For j = 1:1:tResult.Names.Count() {
				Set tName = tResult.Names.GetAt(j)
				Set tNameText = tName.Given_$Select(tName.Given'="":" ",1:"")_tName.Middle_$Select(tName.Middle'="":" ",1:"")_tName.Family
				Set tSC = tPatient.SetName(tName.Family, tName.Given, tName.Middle, tName.Prefix, tName.Suffix, "anonymous", tNameText)
				Quit:$$$ISERR(tSC)
			}
			If $$$ISERR(tSC) Quit
			
			For j = 1:1:tResult.Telecoms.Count() {
				Set tTelecom = tResult.Telecoms.GetAt(j)
				If tTelecom.Email'="" {
					Set tSystem = "email"
					Set tValue = tTelecom.Email
				} Else {
					Set tSystem = $Case(tTelecom.Type, "F":"fax", "P":"pager", "L":"phone", "M":"phone", "O":"other", :"phone")
					Set tValue = tTelecom.PhoneNumberFull
				}
				Set tUse = $Case(tTelecom.Use, "AS":"home", "BAD":"old", "DIR":"home", "EC":"home", "H":"home", "HP":"home", "HV":"home", "MC":"mobile", "PG":"mobile", "PUB":"work", "TMP":"temp", "WP":"work", :"")
				Set tSC = tPatient.SetTelecom(tValue, tSystem, tUse) Quit:$$$ISERR(tSC)
			}
			Quit:$$$ISERR(tSC)
			
			Do tPatient.SetGender($Case($ZConvert(tResult.Sex,"U"), "M":"male", "MALE":"male", "F":"female", "FEMALE":"female", "O":"other", "OTHER":"other", "U":"unknown", "UNKNOWN":"unknown", :"unknown"))
			
			If tResult.DOB'="" Set tSC = tPatient.SetBirthDate($ZDate(tResult.DOB,3)) Quit:$$$ISERR(tSC)
			
			For j = 1:1:tResult.Addresses.Count() {
				Set tAddress = tResult.Addresses.GetAt(j)
				Set tFHIRAddress = ##class(HS.FHIR.vDSTU2.Model.Base.Address).%New()
				For k = 1:1:$Length(tAddress.StreetLine,";") {
					Set tP = $ZStrip($Piece(tAddress.StreetLine,";",k),"<>W")
					If tP'="" Do tFHIRAddress.SetLine(tP)
				}
				Do tFHIRAddress.SetCity(tAddress.City)
				Do tFHIRAddress.SetState(tAddress.State)
				Do tFHIRAddress.SetPostalCode(tAddress.PostalCode)
				Do tFHIRAddress.SetCountry(tAddress.Country)
				Set tUse = $Case(tAddress.Use, "ABC":"home", "BAD":"old", "H":"home", "HP":"home", "HV":"home", "IDE":"home", "PHYS":"home", "PST":"home", "SYL":"home", "TMP":"temp", "WP":"work", "BIL":"home", "ML":"home", :"home")
				Do tFHIRAddress.SetUse(tUse)
				Do tFHIRAddress.SetType("both")
				Do tPatient.address.Insert(tFHIRAddress)
			}
			Quit:$$$ISERR(tSC)
			
			If tResult.MothersMaidenSurname'="" {
				Set tExtension = ##class(HS.FHIR.vDSTU2.Model.Base.Extension).%New()
				Set tExtension.url = "http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName"
				Set tSC = tExtension.SetValueString(tResult.MothersMaidenSurname) Quit:$$$ISERR(tSC)
				Set tSC = tPatient.extension.Insert(tExtension) Quit:$$$ISERR(tSC)
			}
			
			If tResult.ReligiousAffiliation'="" {
				Set tExtension = ##class(HS.FHIR.vDSTU2.Model.Base.Extension).%New()
				Set tExtension.url = "http://hl7.org/fhir/StructureDefinition/patient-religion"
				Set tSC = tExtension.SetValueCodeableConcept(tResult.ReligiousAffiliation, tResult.ReligiousAffiliation) Quit:$$$ISERR(tSC)
				Set tSC = tPatient.extension.Insert(tExtension) Quit:$$$ISERR(tSC)
			}
			
			If +tResult.BirthOrder=0 {
				Set tSC = tPatient.SetMultipleBirthBoolean(0)
			} Else {
				Set tSC = tPatient.SetMultipleBirthInteger(tResult.BirthOrder)
			}
			
			// PatientSearchMatch MaritalStatus is a string, put it into the code property
			// and text property of the FHIR CodeableConcept.
			If tResult.MaritalStatus'="" {
				If $Data(tMS)=0 {
					Set tMS("A")="Annulled"
					Set tMS("D")="Divorced"
					Set tMS("I")="Interlocutory"
					Set tMS("L")="Legally Separated"
					Set tMS("M")="Married"
					Set tMS("P")="Polygamous"
					Set tMS("S")="Single"
					Set tMS("T")="Domestic Partner"
					Set tMS("U")="Unmarried"
					Set tMS("W")="Widowed"
				}
				Set tDescription = ""
				Set tSystem = ""
				If $Data(tMS(tResult.MaritalStatus)) {
					Set tDescription = tMS(tResult.MaritalStatus)
					Set tSystem = "http://hl7.org/fhir/v3/MaritalStatus"
				}
				Set tSC = tPatient.SetMaritalStatus(tResult.MaritalStatus, tDescription, tSystem, tResult.MaritalStatus)
				Quit:$$$ISERR(tSC)
			}
			
			// PatientSearchMatch Language is a string, put it into the code property
			// and text property of the FHIR CodeableConcept.
			If tResult.Language'="" {
				Set tCommunication = ##class(HS.FHIR.vDSTU2.Model.Resource.Patient.Communication).%New()
				Set tSC = tCommunication.SetLanguage(tResult.Language, , , tResult.Language)
				Quit:$$$ISERR(tSC)
				Set tSC = tPatient.communication.Insert(tCommunication)
				Quit:$$$ISERR(tSC)
			}
			
			// FHIR Patient deceased is a variant, can be dateTime or boolean but not both.
			If tResult.DeathTime'="" {
				Set tSC = tPatient.SetDeceasedDateTime($ZDate(tResult.DeathTime,3))
				Quit:$$$ISERR(tSC)
			} ElseIf tResult.DeathStatus'="" {
				Set tSC = tPatient.SetDeceasedBoolean(tResult.DeathStatus)
				Quit:$$$ISERR(tSC)
			}
			
			Set tEntry = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Entry).%New()
			Set tSC = tEntry.SetResource(tPatient) Quit:$$$ISERR(tSC)
			Set tSearch = ##class(HS.FHIR.vDSTU2.Model.Resource.Bundle.Search).%New()
			Do tSearch.SetMode("match")
			// Score must be between 0 and 1. We do not currently have a means to convert
			// the score from the MPI into number from 0 to 1. JIRA is HSHC-72.
			//Do tSearch.SetScore(tResult.RankOrScore)
			Set tEntry.search = tSearch
			Set tSC = tEntry.SetFullUrl(tBase_"/Patient/"_tResult.MPIID) Quit:$$$ISERR(tSC)
			Set tSC = tBundle.entry.Insert(tEntry) Quit:$$$ISERR(tSC)
		}
		Quit:$$$ISERR(tSC)
		
		// Save the query cache object if it may be needed for additional queries.
		If tTotal>tPageSize set tSC = pQueueObject.%Save() quit:$$$ISERR(tSC)
		
		Set tSC = tBundle.SetTotal(tTotal) quit:$$$ISERR(tSC)
		
		If ..Errors.Errors.Count() {
			If tBundle.entry.Count() {
				Set tSC = ..FHIRErrorResponseObject(tSC, pQueueObject.InitialFHIRRequest.Interaction, .tOperationOutcome, .tHTTPStatus)
				Do ..Errors.Errors.Clear()
				If $$$ISERR(tSC) Quit
				Set tSC = tBundle.SetEntry(tOperationOutcome)
				If $$$ISERR(tSC) Quit
			} Else {
				Set tSC = ..FHIRErrorResponse(pQueueObject.InitialFHIRRequest, tSC, .pPDQmResponse)
				Do ..Errors.Errors.Clear()
				Quit
			}
		}
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pQueueObject.InitialFHIRRequest.ContentType, tBundle, .tResponseStream, pQueueObject.InitialFHIRRequest.FormatFHIROutput)
		Quit:$$$ISERR(tSC)
		Set pPDQmResponse.ContentType = pQueueObject.InitialFHIRRequest.ContentType
		Set pPDQmResponse.Type = pQueueObject.InitialFHIRRequest.Type
		
		Set pPDQmResponse.Status = 200
		
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC)) 	
	}
	
	Quit tSC
}

/// Get the links for paging to first, previous, next and last, based
/// on the total search results, page size, and current page values.
Method GetPageLinks(pRequest As HS.Message.FHIR.Request, pQueryId As %String, pTotal As %Integer, pPageSize As %Integer, pPage As %Integer, ByRef pFirst As %String, ByRef pPrev As %String, ByRef pNext As %String, ByRef pLast As %String)
{
	try {
		set tSC = $$$OK
		
		set (tFirst, tPrev, tNext, tLast) = ""
		set (pFirst, pPrev, pNext, pLast) = ""
		
		if pTotal>pPageSize {
			
			set tFirst = 1
			
			If (pTotal#pPageSize)=0 {
				set tLast = pTotal\pPageSize
			} else {
				set tLast = (pTotal\pPageSize)+1
			}
			
			// Previous should not point to the current page.
			if pPage=2 {
				set tPrev = 1
			} elseif pPage>2 {
				set tPrev = pPage-1
			}
			
			// Next should not point to the current page.
			if pPage=(tLast-1) {
				set tNext = tLast
			} elseif pPage<(tLast-1) {
				set tNext = pPage+1
			}
			
			// Include the _format parameter in the page links only if it was provided in the search URL.
			set tFormat = pRequest.GetParameterValue("_format")
			set tFormat = $ZConvert(tFormat, "O", "URL")
			set tUrl = ##class(HS.FHIR.Utils).GetURLBase(pRequest)_"/"_pRequest.Type_"?"_$Select(tFormat'="":"_format="_tFormat_"&",1:"")_"page=<PAGE>&queryId="_pQueryId
			set pFirst = $Replace(tUrl, "<PAGE>", tFirst)
			if tPrev'="" set pPrev = $Replace(tUrl, "<PAGE>", tPrev)
			if tNext'="" set pNext = $Replace(tUrl, "<PAGE>", tNext)
			set pLast = $Replace(tUrl, "<PAGE>", tLast)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Method CreateRetrieveResponseFHIR(pPDQmRequest As HS.Message.FHIR.Request, pSearchResponse As HS.Message.PatientSearchResponse, Output pPDQmResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#dim tMPIMatch As HS.Message.PatientMPIMatch
		
		#; Note that this SearchResponse is one returned directly
		#; from MPIOperations, and is slightly different format than
		#; those formulated for pQueueObject.
		
		If pSearchResponse.MPIIDList.Count()>1 Do ..Errors.logError("invalid", "error", "multiple patients found") Quit
		
		Set tMPIMatch = pSearchResponse.MPIIDList.GetAt(1)

		Set tPatient = ##class(HS.FHIR.vDSTU2.Model.Resource.Patient).%New()
		
		Set tSC = tPatient.SetId(tMPIMatch.MPIID) Quit:$$$ISERR(tSC)
		
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain, ..AffinityDomain)
		
		#dim tResult As HS.Message.PatientSearchMatch
		
		For j = 1:1:tMPIMatch.SearchMatches.Count() {
			Set tResultNumber = tMPIMatch.SearchMatches.GetAt(j)
			Set tResult = pSearchResponse.Results.GetAt(tResultNumber)
			For n = 1:1:tResult.Identifiers.Count() {
				Set tAssigningAuthority = tResult.Identifiers.GetAt(n).Root
				Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthority, tAssigningAuthority)
				// AffinityDomain info needs to be defined in the Config Registry or on the
				// "AffinityDomain" setting on this business host, combined with an entry
				// in the OID Registry, in order to accurately assess whether an identifier
				// is an MPIID or not. In the absence of those definitions, assume it is not.
				If ('((tAffinityDomainOID'="")&&(tAssigningAuthorityOID=tAffinityDomainOID)))&&'((tResult.MPIID=tResult.Identifiers.GetAt(n).Extension)&&(tAffinityDomainOID="")) {
					Set tIdentifier = ##class(HS.FHIR.vDSTU2.Model.Base.Identifier).%New()
					Do tIdentifier.SetUse("official")
					Do tIdentifier.SetType("MR", "Medical Record Number", "http://hl7.org/fhir/v2/0203", "MRN")
					Set tSC = tIdentifier.SetValue(tResult.Identifiers.GetAt(n).Extension) Quit:$$$ISERR(tSC)
					Set tSystemURI = ##class(HS.FHIR.Utils).GetURI("assigningauthority", tAssigningAuthority, ..#FHIRURIMODE, tAssigningAuthority)
					If '##class(HS.HC.Util).IsURI(tSystemURI, 1) {
						Do ..Errors.logError("code-invalid", "warning", "Unable to determine URI for assigning authority '"_tAssigningAuthority_"' - identifier '"_tResult.Identifiers.GetAt(n).Extension_"' removed from search response")
						Continue
					} Else {
						Set tSC = tIdentifier.SetSystem(tSystemURI) Quit:$$$ISERR(tSC)
					}
					Set tSC = tIdentifier.SetAssigner( , tAssigningAuthority) Quit:$$$ISERR(tSC)
					Do tPatient.identifier.Insert(tIdentifier)
				}
			}
		}
		Quit:$$$ISERR(tSC)
		
		If tMPIMatch.SSN'="" {
			Set tSSNURI = ##class(HS.Data.OIDMap).GetURIForCode("SSN", "")
			If tSSNURI="" Set tSSNURI = "urn:oid:2.16.840.1.113883.4.1"
			Set tSC = tPatient.SetIdentifier(tResult.SSN, tSSNURI, "official", "SB", "http://hl7.org/fhir/identifier-type")
			Quit:$$$ISERR(tSC)
		}
		
		Set tSC = tPatient.SetIdentifier(tMPIMatch.MPIID, ##class(HS.Data.OIDMap).GetURIForCode(..AffinityDomain), "official", "MPIID")
		Quit:$$$ISERR(tSC)
		
		Do tPatient.SetActive(1)
		
		Set tNameText = tMPIMatch.FirstName_$Select(tMPIMatch.FirstName'="":" ",1:"")_tMPIMatch.MiddleName_$Select(tMPIMatch.MiddleName'="":" ",1:"")_tMPIMatch.LastName
		Set tSC = tPatient.SetName(tMPIMatch.LastName, tMPIMatch.FirstName, tMPIMatch.MiddleName, tMPIMatch.Prefix, tMPIMatch.Suffix, "official", tNameText)
		Quit:$$$ISERR(tSC)
		
		For j = 1:1:tMPIMatch.Telecoms.Count() {
			Set tTelecom = tMPIMatch.Telecoms.GetAt(j)
			If tTelecom.Email'="" {
				Set tSystem = "email"
				Set tValue = tTelecom.Email
			} Else {
				Set tSystem = $Case(tTelecom.Type, "F":"fax", "P":"pager", "L":"phone", "M":"phone", "O":"other", :"phone")
				Set tValue = tTelecom.PhoneNumberFull
			}
			Set tUse = $Case(tTelecom.Use, "AS":"home", "BAD":"old", "DIR":"home", "EC":"home", "H":"home", "HP":"home", "HV":"home", "MC":"mobile", "PG":"mobile", "PUB":"work", "TMP":"temp", "WP":"work", :"")
			Set tSC = tPatient.SetTelecom(tValue, tSystem, tUse) Quit:$$$ISERR(tSC)
		}
		Quit:$$$ISERR(tSC)
		
		Do tPatient.SetGender($Case($ZConvert(tMPIMatch.Sex,"U"), "M":"male", "MALE":"male", "F":"female", "FEMALE":"female", "O":"other", "OTHER":"other", "U":"unknown", "UNKNOWN":"unknown", :"unknown"))
		
		If tMPIMatch.DOB'="" Set tSC = tPatient.SetBirthDate($ZDate(tMPIMatch.DOB,3)) Quit:$$$ISERR(tSC)
		
		For j = 1:1:tMPIMatch.Addresses.Count() {
			Set tAddress = tMPIMatch.Addresses.GetAt(j)
			Set tFHIRAddress = ##class(HS.FHIR.vDSTU2.Model.Base.Address).%New()
			For k = 1:1:$Length(tAddress.StreetLine,";") {
				Set tP = $ZStrip($Piece(tAddress.StreetLine,";",k),"<>W")
				If tP'="" Do tFHIRAddress.SetLine(tP)
			}
			Do tFHIRAddress.SetCity(tAddress.City)
			Do tFHIRAddress.SetState(tAddress.State)
			Do tFHIRAddress.SetPostalCode(tAddress.PostalCode)
			Do tFHIRAddress.SetCountry(tAddress.Country)
			Set tUse = $Case(tAddress.Use, "ABC":"home", "BAD":"old", "H":"home", "HP":"home", "HV":"home", "IDE":"home", "PHYS":"home", "PST":"home", "SYL":"home", "TMP":"temp", "WP":"work", "BIL":"home", "ML":"home", :"home")
			Do tFHIRAddress.SetUse(tUse)
			Do tFHIRAddress.SetType("both")
			Do tPatient.address.Insert(tFHIRAddress)
		}
		Quit:$$$ISERR(tSC)
		
		Set tSC = tPatient.SetMaritalStatus(tMPIMatch.MaritalStatus, , , tMPIMatch.MaritalStatus) Quit:$$$ISERR(tSC)

		Do pPDQmRequest.NewResponse(.pPDQmResponse)
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pPDQmResponse.QuickStreamId = tResponseStream.%Id()
		
		Set pPDQmResponse.ContentType = pPDQmRequest.ContentType
		Set pPDQmResponse.Type = pPDQmRequest.Type
		Set pPDQmResponse.Id = pPDQmRequest.Id
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pPDQmResponse.ContentType, tPatient, .tResponseStream, pPDQmRequest.FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		// Retrieve response must ignore assigning authority-related problems
		// converting search response to FHIR.
		Do ..Errors.Errors.Clear()
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// FHIRErrorResponse is called when there are Errors to report and no search result
/// payload to return.
Method FHIRErrorResponse(pFHIRRequest As HS.Message.FHIR.Request, ByRef pSC As %Status, ByRef pFHIRResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pFHIRResponse)) {
			Set tSC = pFHIRRequest.NewResponse(.pFHIRResponse)
			If $$$ISERR(tSC) Quit
		}
		Set pFHIRResponse.ContentType = pFHIRRequest.ContentType
		
		If pFHIRResponse.QuickStreamId'="" {
			Set tResponseStream = ##class(HS.SDA3.QuickStream).%OpenId(pFHIRResponse.QuickStreamId)
		} Else {
			Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
			Set pFHIRResponse.QuickStreamId = tResponseStream.%Id()
		}
		
		Set tSC = ..FHIRErrorResponseObject(pSC, pFHIRRequest.Interaction, .tOperationOutcome, .tHTTPStatus)
		If $$$ISERR(tSC) Quit
		
		Set pFHIRResponse.Type = "OperationOutcome"
		
		If $$$ISERR(pSC) {
			Set pFHIRResponse.Status = 500
			Set pSC = $$$OK
		} ElseIf ..Errors.Errors.Count() {
			Set pFHIRResponse.Status = tHTTPStatus
		}
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pFHIRRequest.ContentType, tOperationOutcome, .tResponseStream, pFHIRRequest.FormatFHIROutput) Quit:$$$ISERR(tSC)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// FHIRErrorResponseObject is called when there are Errors to report AND there is also
/// some search result payload to return.
Method FHIRErrorResponseObject(pSC As %Status, pInteraction As %String, ByRef pOperationOutcome As HS.FHIR.vDSTU2.Model.Resource.OperationOutcome, ByRef pHTTPStatus As %String) As %Status
{
	Set tSC = $$$OK
	
	Set pHTTPStatus = ""
	
	Try {
		Set pOperationOutcome = ##class(HS.FHIR.vDSTU2.Model.Resource.OperationOutcome).%New()
		Set tSC = pOperationOutcome.SetId("PDQmError") Quit:$$$ISERR(tSC)
		Set tIssue = ##class(HS.FHIR.vDSTU2.Model.Resource.OperationOutcome.Issue).%New()
		
		If $$$ISERR(pSC) {
			Set tSC = tIssue.SetSeverity("error") Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetCode("exception") Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetDetails(, , , $system.Status.GetErrorText(pSC)) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetDiagnostics($system.Status.GetErrorText(pSC)) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetLocation("") Quit:$$$ISERR(tSC)
			Set tSC = pOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
			Set pHTTPStatus = 500
		} ElseIf ..Errors.Errors.Count() {
			Set tBadRequest = 0
			Set tNotFound = 0
			Set tException = 0
			For i = 1:1:..Errors.Errors.Count() {
				Set tError = ..Errors.Errors.GetAt(i)
				Set tSC = tIssue.SetSeverity(tError.Severity) Quit:$$$ISERR(tSC)
				Set tSC = tIssue.SetCode(tError.Code) Quit:$$$ISERR(tSC)
				Set tSC = tIssue.SetDetails(, , , tError.Description) Quit:$$$ISERR(tSC)
				Set tSC = tIssue.SetDiagnostics(tError.Description) Quit:$$$ISERR(tSC)
				Set tSC = tIssue.SetLocation("") Quit:$$$ISERR(tSC)
				Set tSC = pOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
				If tError.Code="exception" {
					Set tException = 1
				} ElseIf (tError.Code="value")&&(tError.Description["targetSystem not found") {
					Set tNotFound = 1
				} ElseIf (tError.Code="not-supported") {
					Set tBadRequest = 1
				} ElseIf (tError.Code="code-invalid")&&(tError.Description["Assigning Authority not found") {
					Set tBadRequest = 1
				} ElseIf (pInteraction="read")&&(tError.Code="not-found") {
					Set tNotFound = 1
				}
			}
			If tException {
				Set pHTTPStatus = 500
			} ElseIf tBadRequest {
				Set pHTTPStatus = 400
			} ElseIf tNotFound {
				Set pHTTPStatus = 404
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method ProcessMetadataRequest(pRequest As HS.Message.FHIR.Request, pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tResourceId = pRequest.AdditionalInfo.GetAt("ConformanceId")
		If tResourceId="" {
			Set tSC = $$$ERROR($$$GeneralError, "Conformance resource id not specified")
			Quit
		}
		Set tXDataName = "ISCPDQmSupplier"
		
		Set tSC = pRequest.NewResponse(.pResponse)
		If $$$ISERR(tSC) Quit
		
		Set pResponse.ContentType = pRequest.ContentType
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tSC = ##class(HS.FHIR.Utils).GetCapabilityStatementFromXData(pRequest.ContentType, tXDataName, ..%ClassName(1), ..ResourceSchemaRoot, tResourceId, pRequest.BaseURL, pRequest.AdditionalInfo.GetAt("OAuthClient"), ('pRequest.AdditionalInfo.GetAt("DisableCORS")=1), pRequest.FormatFHIROutput, .tResponseStream)
		If $$$ISERR(tSC) Quit
		
		If $$$HSTRACING {
			If pResponse.QuickStreamId'="" {
				Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
				$$$HSTRACE("FHIR response message to be returned", "pResponse,tQuickStream", pResponse, tQuickStream)
			} Else {
				$$$HSTRACE("FHIR response message to be returned", "pResponse", pResponse)
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

XData ISCPDQmSupplier
{
<Conformance xmlns="http://hl7.org/fhir">
  <placeholder>resource_id</placeholder>
  <text>
    <status value="additional" />
    <div xmlns="http://www.w3.org/1999/xhtml">Conformance Statement for Supplier Actor in the IHE IT Infrastructure Technical Framework Supplement 
      <a href="http://wiki.ihe.net/index.php/Patient_Demographics_Query_for_Mobile_(PDQm)">Patient Demographics Query for Mobile (PDQm)</a></div>
  </text>
  <placeholder>url</placeholder>
  <name value="IHE.PDQm.supplier" />
  <status value="active" />
  <experimental value="false" />
  <date value="2018-03-19" />
  <publisher value="InterSystems Corporation" />
  <description value="see http://wiki.ihe.net/index.php/Patient_Demographics_Query_for_Mobile_(PDQm)" />
  <kind value="instance" />
  <placeholder>software</placeholder>
  <implementation>
    <description value="InterSystems PDQm Supplier"/>
    <placeholder>implementation_url</placeholder>
  </implementation>
  <fhirVersion value="1.0.2" />
  <acceptUnknown value="no" />
  <format value="xml" />
  <format value="application/xml+fhir" />
  <format value="json" />
  <format value="application/json+fhir" />
  <rest>
    <mode value="server" />
    <documentation value="PDQm server provides capability to query for Patient resources matching a sub-set of the FHIR core Patient resource query parameters" />
    <security>
      <placeholder>security_oauth_uris_extension</placeholder>
      <placeholder>security_cors</placeholder>
      <placeholder>security_service</placeholder>
    </security>
    <resource>
      <type value="Conformance" />
      <interaction>
        <code value="read" />
      </interaction>
    </resource>
    <resource>
      <type value="Patient" />
      <interaction>
        <code value="read" />
      </interaction>
      <interaction>
        <code value="search-type" />
      </interaction>
      <searchParam>
        <name value="_id" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-_id" />
        <type value="token" />
        <documentation value="Logical id of this artifact" />
      </searchParam>
      <searchParam>
        <name value="address-city" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-address-city" />
        <type value="string" />
        <documentation value="A city specified in an address" />
      </searchParam>
      <searchParam>
        <name value="address-country" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-address-country" />
        <type value="string" />
        <documentation value="A country specified in an address" />
      </searchParam>
      <searchParam>
        <name value="address-postalcode" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-address-postalcode" />
        <type value="string" />
        <documentation value="A postalCode specified in an address" />
      </searchParam>
      <searchParam>
        <name value="address-state" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-address-state" />
        <type value="string" />
        <documentation value="A state specified in an address" />
      </searchParam>
      <searchParam>
        <name value="birthdate" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-birthdate" />
        <type value="date" />
        <documentation value="The patient's date of birth" />
      </searchParam>
      <searchParam>
        <name value="family" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-family" />
        <type value="string" />
        <documentation value="A portion of the family name of the patient" />
      </searchParam>
      <searchParam>
        <name value="gender" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-gender" />
        <type value="token" />
        <documentation value="Gender of the patient" />
      </searchParam>
      <searchParam>
        <name value="given" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-given" />
        <type value="string" />
        <documentation value="A portion of the given name of the patient" />
      </searchParam>
      <searchParam>
        <name value="identifier" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-identifier" />
        <type value="token" />
        <documentation value="A patient identifier" />
      </searchParam>
      <searchParam>
        <name value="telecom" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-telecom" />
        <type value="token" />
        <documentation value="The value in any kind of telecom details of the patient" />
      </searchParam>
      <searchParam>
        <name value="_lastUpdated" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-_lastUpdated" />
        <type value="date" />
        <documentation value="When the resource version last changed" />
      </searchParam>
    </resource>
  </rest>
</Conformance>
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>AffinityDomain</Value>
</Value>
<Value name="2">
<Value>AffinityDomainIsMPIID</Value>
</Value>
<Value name="3">
<Value>ApplyConsent</Value>
</Value>
<Value name="4">
<Value>MPIOperations</Value>
</Value>
<Value name="5">
<Value>Errors</Value>
</Value>
<Value name="6">
<Value>ApplyRankMultiplier</Value>
</Value>
<Value name="7">
<Value>ResourceSchemaRoot</Value>
</Value>
<Value name="8">
<Value>TraceOperations</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
