Include HS.HC

Class HS.FHIR.vSTU3.PIXm.Manager.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "MPIOperations,AffinityDomain,AffinityDomainIsMPIID,HUB,ApplyConsent";

/// Config Item where the Add/Update Operations will be sent 
Property MPIOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.Hub.MPI.Manager" ];

/// Used when dynamic registration is enabled.
Property HUB As Ens.DataType.ConfigName [ InitialExpression = "HS.Hub.Management.Operations" ];

/// Used in a testing environment allows setting of the AffinityDomain Code (which must be defined in the OID Registry) if not
/// set the value from ##class(HS.IHE.Util).GetAffinityDomain() is used
Property AffinityDomain As %String;

/// Used to determine whether AffinityDomain is the MPIID (true - general scenario) or whether the MPIID is in the results (typically IHE testing)
Property AffinityDomainIsMPIID As %Boolean [ InitialExpression = 1 ];

/// If true, patient search requests generated by this process will be processed by consent.
Property ApplyConsent As %Boolean [ InitialExpression = 0 ];

Property Errors As HS.Types.FHIR.Errors;

/// Class package that is the root of all resource schemas for the desired data model.
Property ResourceSchemaRoot As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Model.Resource" ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC=$$$OK
	
	Try {
		Set ..Errors = ##class(HS.Types.FHIR.Errors).%New()
		
		If ..AffinityDomain="" Set ..AffinityDomain=$$$AffinityDomain
		
		If ..AffinityDomain="" {
			Set tSC = $$$ERROR($$$GeneralError, "Affinity Domain is not defined on the business process or in the Configuration Registry")
			Quit
		}
		
		If ##class(HS.Data.OIDMap).GetURIForCode(..AffinityDomain, "")="" {
			Set tSC = $$$ERROR($$$GeneralError, "Affinity Domain '"_..AffinityDomain_"' is not defined in the OID Registry")
			Quit
		}
		
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			If pRequest.Interaction'="capabilities" {
				Set tSC = ..ProcessFHIRMessage(pRequest, .pResponse)
			} Else {
				Set tSC = ..ProcessMetadataRequest(pRequest, .pResponse)
			}
		} Else {
			Set tSC = $$$ERROR($$$GeneralError, "Message class "_pRequest.%ClassName(1)_" not handled")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($$$ISERR(tSC))||($IsObject(..Errors)&&(..Errors.Errors.Count())) {
		Set ttSC = ..FHIRErrorResponse(pRequest, .tSC, .pResponse)
		If $$$ISERR(ttSC) Set tSC = ttSC
	}
	
	If ($IsObject($Get(pResponse)))&&($$$HSTRACING) {
		If pResponse.QuickStreamId'="" {
			Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(pResponse.QuickStreamId)
			$$$HSTRACE("FHIR response message to be returned", "pResponse,tQuickStream", pResponse, tQuickStream)
		} Else {
			$$$HSTRACE("FHIR response message to be returned", "pResponse", pResponse)
		}
	}
	
	Quit tSC
}

Method ProcessFHIRMessage(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// If invalid ContentType per STU3 then change it to a valid ContentType.
		Set pRequest.ContentType = ##class(HS.FHIR.Utils).EnsureContentType(pRequest.ContentType, "STU3")
		
		If pRequest.Interaction="$ihe-pix" {
			Set tSC = ..QueryRequestFHIR(pRequest, .pResponse)
		} Else {
			Do ..Errors.logError("invalid", "error", "FHIR "_pRequest.Interaction_" interaction not supported on this end point")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// QueryRequestFHIR takes the HS FHIR Request and returns an HS FHIR Response.
Method QueryRequestFHIR(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..FHIRToPatientSearchRequest(pRequest, .tSearchRequest)
		If ($$$ISERR(tSC))||(..Errors.Errors.Count()) Quit
		
		Set tSC = ..SendAndFilterFHIR(tSearchRequest, .tFilteredResponse)
		If ($$$ISERR(tSC))||(..Errors.Errors.Count()) Quit
		
		Set tSC = ..PatientSearchResponseToFHIR(tFilteredResponse, .pResponse, pRequest)
		If ($$$ISERR(tSC))||(..Errors.Errors.Count()) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// SendAndFilterFHIR is called by QueryRequestFHIR.  It sends the PatientSearchRequest
/// to the MPIOperations config item, gets the response, and applies domain filters
/// as needed.
Method SendAndFilterFHIR(pSearchRequest As HS.Message.PatientSearchRequest, pFilteredSearchResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tSC = $$$OK
	
	Set pFilteredSearchResponse = ##class(HS.Message.PatientSearchResponse).%New()
	try {
		Set tSeverityError = "error"

		Set tSearchAA=pSearchRequest.AssigningAuthority
		If tSearchAA]"" {
			Set tSearchAAOID=##class(HS.Data.OIDMap).GetOIDForCode(tSearchAA,"")
			If tSearchAAOID="" {
				Set tErr = "Unable to find specified Assigning Authority "_tSearchAA
				Do ..Errors.logError("not-supported", tSeverityError, tErr, "")
			}
		}
		Set tSearchMRN=pSearchRequest.MRN
		#; if controlAA = SearchAA then we are searching by MPIID
		If tSearchAA=..AffinityDomain {
			Set pSearchRequest.AssigningAuthority=""
			Set pSearchRequest.MPIID=pSearchRequest.MRN,pSearchRequest.MRN=""
			Set tScopeFound(..AffinityDomain)=""
		} Else {
			Set:tSearchAA]"" tScopeFound(tSearchAA)=""
		}

		Set tSC = ..SendRequestSync(..MPIOperations,pSearchRequest,.tSearchResponse) 
		If $$$ISERR(tSC) {
			Set tErr = "Error executing MPI Search "_$system.Status.GetErrorText(tSC)
			Do ..Errors.logError("exception", tSeverityError, tErr)
			Quit
		}

		#; we must know the requested ID or it is an error
		If tSearchResponse.Results.Count()=0 {
			Set tErr = "Requested record not found"
			// If the response includes an HTTPStatus AdditionalInfoItem, it means the
			// PatientSearchResponse was formulated by PIXm Consumer Operations. If
			// HTTP status is 200 and Results.Count()=0, it means the source identifier
			// was found but no other identifiers were found.
			If +tSearchResponse.AdditionalInfo.GetAt("HTTPStatus")'=200 {
				If tSearchResponse.AdditionalInfo.GetAt("PIXConsumer")=1 {
					If $$$ISERR(tSearchResponse.ErrStatus) {
						#; ErrStatus will contain "Requested record not found" when the
						#; identifier was not found in the specified assigning authority
						#; domain.  If ErrStatus is 1 then it means the identifier was
						#; found in the specified assigning authority domain but no other
						#; identifiers were found in other domains, which is NOT an error.
						If $system.Status.GetErrorText(tSearchResponse.ErrStatus)[tErr {
							Do ..Errors.logError("value", tSeverityError, tErr, "")
						} Else {
							Do ..Errors.logError("exception", tSeverityError, $system.Status.GetErrorText(tSearchResponse.ErrStatus), "")
						}
					}
				} Else {
					Do ..Errors.logError("value", tSeverityError, tErr, "")
				}
			}
			Quit
		}

		Set tNode="scopingOrganization_",tIdx=0
		For  {
			Set tIdx=tIdx+1
			Do pSearchRequest.AdditionalInfo.GetNext(.tNode) Quit:tNode=""
			If $P(tNode,"_",1)'="scopingOrganization" Quit
			Set tResult=$p(tNode,"_",2,999)
			Set tOID = ##class(HS.Data.OIDMap).GetOIDForCode(tResult,"")
			If tOID="" {
				Set tErr = "Unable to identify data source:"_tResult
				Do ..Errors.logError("code-invalid", tSeverityError, tErr, "")
			} Else {
				Set tScope(tResult)=""
			}
		}

		#; PIX query is a deterministic match, so we should only have one MPIID returned
		#; loop all ID's and insert additional identifiers
		Set tCount=tSearchResponse.Results.Count()
		For tIdx=1:1:tCount {
			Set tItem=tSearchResponse.Results.GetAt(tIdx)
			#; insert the MPIID if the MPI is the AffinityDomain 
			If tIdx = 1 && ..AffinityDomainIsMPIID {
				Set tMPIID = tItem.MPIID
				Set tResult = tItem.%ConstructClone(0)
				Set tResult.MRN=tMPIID
				Set tResult.AssigningAuthority = ..AffinityDomain
				Set tResult.Facility = ..AffinityDomain
				Do tSearchResponse.Results.Insert(tResult)
				Set tScopeFound(..AffinityDomain)=""
			}

			For tIdx2 = 1:1:tItem.Identifiers.Count() {
				Set tIdentifier = tItem.Identifiers.GetAt(tIdx2)
				Set tAA = tIdentifier.Root
				Set tMRN = tIdentifier.Extension
				If tAA="" || (tMRN="") continue
				Set tResult = tItem.%ConstructClone(0)
				Set tResult.MRN=tMRN
				Set tResult.AssigningAuthority = tAA
				Do tSearchResponse.Results.Insert(tResult)
				Set tScopeFound(tAA)=""
			}
		}

		$$$HSTRACE("SearchResponse","tSearchResponse",tSearchResponse)
		#; purge any id's not in scope or equal to search criteria
		For tIdx=1:1:tSearchResponse.Results.Count() {
			Set tItem=tSearchResponse.Results.GetAt(tIdx)
			Set tAA = tItem.AssigningAuthority
			$$$HSTRACE("checking item ","tIdx,tAA,tItem,$D(tScope),tSearchAA,tSearchMRN",tIdx,tAA,tItem,$D(tScope),tSearchAA,tSearchMRN)
			If tItem.MRN="" Continue
			If $D(tScope) && ('$D(tScope(tAA))) Continue
			#; exclude the searched item
			If tSearchAA = tAA && (tSearchMRN = tItem.MRN) Continue
			$$$HSTRACE("Adding","tSearchAA,tAA,tSearchMRN,tMRN,tIdx",tSearchAA,tAA,tSearchMRN,tItem.MRN,tIdx)
			Set tResult=##class(HS.Message.IHE.PatientSearchMatch).%New()
			Do tResult.CopyFrom(tItem,tResult)
			Set tResult.AssigningAuthority = tAA
			Set tFacility = tResult.Facility
			If tFacility'="" {
				Set tFacilityObject=##class(HS.Facility.Config).%OpenId(tFacility)
				If $isObject(tFacilityObject) {
					Set tFacilityName=$s(tFacilityObject.Name="":tFacilityObject.FacilityCode,1:tFacilityObject.Name)
					Set tFacilityTel =$S(tFacilityObject.Contact.Telephone="":"tel:Unknown",1:tFacilityObject.Contact.Telephone)
					Do tResult.AdditionalInfo.SetAt(tFacilityName,"FacilityName")
					Do tResult.AdditionalInfo.SetAt(tFacilityTel,"FacilityTelephone")
				}
				Else { Set tFacility=""}
			}
			/// Add the ID
			Set tMatch = ##class(HS.Message.IHE.Match).%New()
			Set tMatch.AssigningAuthority=tAA
			Set tMatch.MRN=tResult.MRN
			If tMatch.MRN="" Continue
			Do tResult.IDs.Insert(tMatch)
			Do addResult(pFilteredSearchResponse,tResult,.tScope,.tScopeFound)
		}
		#; move all matching ID's into first record and remove others
		Set tFirstID = pFilteredSearchResponse.Results.GetAt(1),tFacility=""
		If $isObject(tFirstID) {
			Set tHaveIDs(tFirstID.AssigningAuthority_" ",tFirstID.MRN_" ")=""
			For tIdx=pFilteredSearchResponse.Results.Count():-1:2 {
				Set tItem=pFilteredSearchResponse.Results.GetAt(tIdx)
				Set tAA = tItem.AssigningAuthority
				Set tMRN = tItem.MRN
				Set tFacility = tItem.Facility
				If tMRN]"",'$d(tHaveIDs(tAA_" ",tMRN_" ")) {
					Set tHaveIDs(tAA_" ",tMRN_" ")=""
					Set tMatch = ##class(HS.Message.IHE.Match).%New()
					Set tMatch.AssigningAuthority=tAA
					Set tMatch.MRN=tMRN
					Do tFirstID.IDs.Insert(tMatch)
					If tFacility]"",tFacility '= tFirstID.Facility Set tFirstID.Facility=""
				}
				Do pFilteredSearchResponse.Results.RemoveAt(tIdx)
			}
			Set tFacility = tFirstID.Facility 
		}
		#; can only present the facility (provider organization) if there is an ID associated
		If tFacility]"" && ('$d(tHaveIDs(tFacility_" "))) Set tFirstID.Facility=""
		$$$HSTRACE("Results","Count",tSearchResponse.Results.Count())
	} Catch eException {
		Set tSC = eException.AsStatus()
		Set tErr = "Internal Error: "_$system.Status.GetErrorText(tSC)
		Do ..Errors.logError("exception", $Get(tSeverityError), tErr)
	}

	Quit tSC
addResult(pFilteredResponse,pResult,pScoping,pScopeFound)
	If pResult]"" {
		If pResult.MRN]"" {
			Do pFilteredResponse.Results.Insert(pResult)
			Set pScopeFound(pResult.AssigningAuthority)=""
		$$$HSTRACE("Adding Result","Result,MRN,MPIID,AA,Facility",pResult,pResult.MRN,pResult.MPIID,pResult.AA,pResult.Facility)
		}
	}
	Quit
}

Method FHIRToPatientSearchRequest(pFHIRRequest As HS.Message.FHIR.Request, Output pPatientSearchRequest As HS.Message.PatientSearchRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If pFHIRRequest.Type'="Patient" Do ..Errors.logError("invalid", "error", "Invalid resource type specified") Quit
		
		Set tValidURLParams = ",sourceIdentifier,targetSystem,_format,"
		Set tInvalidURLParam = ""
		For {
			Set tVal = pFHIRRequest.Parameters.GetNext(.tWholeURLParam)
			If tWholeURLParam="" Quit
			Set tURLParamName = $Piece(tWholeURLParam, ":", 1)
			If tValidURLParams'[(","_tURLParamName_",") Set tInvalidURLParam = tURLParamName Quit
		}
		If tInvalidURLParam'="" Do ..Errors.logError("invalid", "error", "Invalid search parameter "_tInvalidURLParam_" specified") Quit
		
		Set pPatientSearchRequest = ##class(HS.Message.PatientSearchRequest).%New()
		
		#; Establish request as a PIX/PDQ request
		Set pPatientSearchRequest.SearchMode = $S(..ApplyConsent:"PIXPDQ_c",1:"PIXPDQ")
		
		If pFHIRRequest.AdditionalInfo.GetAt("USER:UserID")'="" {
			Set pPatientSearchRequest.RequestingUser = pFHIRRequest.AdditionalInfo.GetAt("USER:UserID")
		}
		If pFHIRRequest.AdditionalInfo.GetAt("USER:Roles")'="" {
			Set pPatientSearchRequest.RequestingUserRoles = pFHIRRequest.AdditionalInfo.GetAt("USER:Roles")
		}
		
		Set tSourceIdentifier = pFHIRRequest.GetParameterValue("sourceIdentifier")
		If tSourceIdentifier="" Do ..Errors.logError("required", "error", "sourceIdentifier not specified") Quit
		
		Set tTargetSystems = pFHIRRequest.GetParameterValue("targetSystem")
		
		#; Piece 1 by vertical bar is assigning authority or patient domain.
		#; Piece 2 by vertical bar is the identifier.
		#; The assigning authority in the URL parameter may be a URL or an OID,
		#; but the OID Registry IdentityCode to which it maps must have an OID
		#; defined.
		Set tAssigningAuthorityURI = $Piece(tSourceIdentifier,"|",1)
		Set tIdentifier = $Piece(tSourceIdentifier,"|",2)
		Set tAssigningAuthorityCode = ##class(HS.Data.OIDMap).GetCodeForURI(tAssigningAuthorityURI, "")
		If tAssigningAuthorityCode="" Do ..Errors.logError("code-invalid", "error", "sourceIdentifier Assigning Authority not found") Quit
		Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode, "")
		If tAssigningAuthorityOID="" Do ..Errors.logError("code-invalid", "error", "sourceIdentifier Assigning Authority not found") Quit
		
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain)
		
		If tIdentifier ] "" {
			#; Get MRN if we need to.
			#; The only indicator that tIdentifier is an MPIID is
			#; that the AA OID matches the affinity domain OID.
			If tAssigningAuthorityOID'=tAffinityDomainOID {
				Set tSC = ##class(HS.IHE.Util).AAIdentifierTypeForCode(tAssigningAuthorityCode, .tAAIdentifierType)
				If $$$ISERR(tSC)!(tAAIdentifierType="") {
					Do ..Errors.logError("code-invalid", "error", "Unknown Assigning Authority Type for "_tAssigningAuthorityCode) Quit
				} ElseIf tAAIdentifierType="MR" {
					Set pPatientSearchRequest.AssigningAuthority = tAssigningAuthorityCode
					Set pPatientSearchRequest.MRN = tIdentifier
				} Else {
					#; Get other identifiers
					Set tNewIdentifer = ##class(HS.Types.Identifier).%New()
					Set tNewIdentifer.Root = tAssigningAuthorityCode
					Set tNewIdentifer.Extension = tIdentifier
					Set tNewIdentifer.AssigningAuthorityName = tAssigningAuthorityCode
					Set tNewIdentifer.Use = tAAIdentifierType
					Do pPatientSearchRequest.Identifiers.Insert(tNewIdentifer)
				}
			}
			Else {
				#; Perform search based on other identifier
				Set tNewIdentifer = ##class(HS.Types.Identifier).%New()
				Set tNewIdentifer.Root = tAssigningAuthorityCode
				Set tNewIdentifer.Extension = tIdentifier
				Set tNewIdentifer.AssigningAuthorityName = tAssigningAuthorityCode
				Set tNewIdentifer.Use = "PT"
				Do pPatientSearchRequest.Identifiers.Insert(tNewIdentifer)
				Set pPatientSearchRequest.MPIID = tIdentifier
			}
		}
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
		Set tDomainFound = 0
		For i = 1:1:$Length(tTargetSystems, ",") {
			Set tTargetSystemURI = $Piece(tTargetSystems, ",", i)
			If tTargetSystemURI="" Quit
			#; The targetSystem in the URL parameter may be a URL or an OID.
			Set tScopingOrganizationCode = ##class(HS.Data.OIDMap).GetCodeForURI(tTargetSystemURI, "")
			If tScopingOrganizationCode="" Do ..Errors.logError("code-invalid", "error", "targetSystem not found") Quit
			Do pPatientSearchRequest.AdditionalInfo.SetAt("","scopingOrganization_"_tScopingOrganizationCode)
			Set tDomainFound = 1
		}
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		If tDomainFound=1 Do pPatientSearchRequest.AdditionalInfo.SetAt("","ScopingOrganizations")
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method PatientSearchResponseToFHIR(pPatientSearchResponse As HS.Message.PatientSearchResponse, Output pFHIRResponse As HS.Message.FHIR.Response, pOriginalRequest As HS.Message.FHIR.Request) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = pOriginalRequest.NewResponse(.pFHIRResponse)
		If $$$ISERR(tSC) Quit
		
		Set pFHIRResponse.Type = pOriginalRequest.Type
		Set pFHIRResponse.ContentType = pOriginalRequest.ContentType
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pFHIRResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tSourceIdentifier = pOriginalRequest.GetParameterValue("sourceIdentifier")
		
		#; Build an array of the system portion of any specified targetSystems.
		Set tTargetSystems = pOriginalRequest.GetParameterValue("targetSystem")
		If tTargetSystems'="" {
			For i = 1:1:$Length(tTargetSystems,",") {
				Set tX = $Replace($Piece(tTargetSystems,",",i),"urn:oid:","")
				If tX'="" Set tTargetSystemsSystems(tX) = ""
			}
		}
		
		#; Piece 1 by vertical bar is assigning authority or patient domain.
		#; Piece 2 by vertical bar is the identifier.
		Set tQueriedAssigningAuthorityURI = $Piece(tSourceIdentifier,"|",1)
		Set tQueriedIdentifier = $Piece(tSourceIdentifier,"|",2)
		Set tAssigningAuthorityCode = ##class(HS.Data.OIDMap).GetCodeForURI(tQueriedAssigningAuthorityURI, tQueriedAssigningAuthorityURI)
		Set tQueriedAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode, "")
		Set tQueriedAssigningAuthorityURL = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode, "")
		
		Set tParameters = ##class(HS.FHIR.vSTU3.Model.Resource.Parameters).%New()
		
		#; Patient Identification (PID)
		Kill tIDs
		Set tAffinityDomainOID = ##class(HS.Data.OIDMap).GetOIDForCode(..AffinityDomain)
		Set tFieldNo = 0
		If pPatientSearchResponse.Results.Count()=1 && (pPatientSearchResponse.Results.GetAt(1).%IsA("HS.Message.IHE.PatientSearchMatch")) {
			Set tResultItem = pPatientSearchResponse.Results.GetAt(1)
			For tIdx = 1:1:tResultItem.IDs.Count() {
				Set tMatch = tResultItem.IDs.GetAt(tIdx)
				Set tAA=tMatch.AssigningAuthority
				Set tMRN=tMatch.MRN
				Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAA,"")
				Set tAssigningAuthorityURL = ##class(HS.Data.OIDMap).GetURLForCode(tAA,"")
				#; If this match is the identifier that we queried on, then skip it.
				If tMRN=tQueriedIdentifier {
					If (tAssigningAuthorityOID'="")&&($Replace(tAssigningAuthorityOID,"urn:oid:","")=$Replace(tQueriedAssigningAuthorityOID,"urn:oid:","")) continue
					If (tAssigningAuthorityURL'="")&&(tAssigningAuthorityURL=tQueriedAssigningAuthorityURL) continue
				}
				If $i(tFieldNo)
				#; If targetSystems were specified, then use the AA as it was specified
				#; in the targetSystem parameter (OID or URL).  Otherwise, if a URL is
				#; defined for the AA code then use it.  Otherwise use the OID that is
				#; defined for the AA code.
				If (tAssigningAuthorityURL'="")&&($Data(tTargetSystemsSystems(tAssigningAuthorityURL))) {
					Set tAssigningAuthorityURI = tAssigningAuthorityURL
				} ElseIf (tAssigningAuthorityOID'="")&&($Data(tTargetSystemsSystems($Replace(tAssigningAuthorityOID,"urn:oid:","")))) {
					Set tAssigningAuthorityURI = tAssigningAuthorityOID
				} ElseIf tAssigningAuthorityURL'="" {
					Set tAssigningAuthorityURI = tAssigningAuthorityURL
				} Else {
					Set tAssigningAuthorityURI = tAssigningAuthorityOID
				}
				Set tParam = ##class(HS.FHIR.vSTU3.Model.Resource.Parameters.Parameter).%New()
				Set tSC = tParam.SetName("targetIdentifier") Quit:$$$ISERR(tSC)
				Set tSC = tParam.SetValueIdentifier(tMRN, tAssigningAuthorityURI, "official") Quit:$$$ISERR(tSC)
				Set tSC = tParameters.parameter.Insert(tParam) Quit:$$$ISERR(tSC)
			}
		} ElseIf pPatientSearchResponse.Results.Count() {
			For i = 1:1:pPatientSearchResponse.MPIIDList.Count() {
				If pPatientSearchResponse.MPIIDList.GetAt(i).MPIID=tQueriedIdentifier,tAffinityDomainOID=tQueriedAssigningAuthorityOID continue
				If $i(tFieldNo)
				Set tParam = ##class(HS.FHIR.vSTU3.Model.Resource.Parameters.Parameter).%New()
				Set tSC = tParam.SetName("targetIdentifier") Quit:$$$ISERR(tSC)
				Set tSC = tParam.SetValueIdentifier(pPatientSearchResponse.MPIIDList.GetAt(i).MPIID, tAffinityDomainOID, "official") Quit:$$$ISERR(tSC)
				Set tSC = tParameters.parameter.Insert(tParam) Quit:$$$ISERR(tSC)
			}
			For i = 1:1:pPatientSearchResponse.Results.Count() {
				Set tAssigningAuthorityCode = pPatientSearchResponse.Results.GetAt(i).AssigningAuthority
				Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAssigningAuthorityCode)
				Set tMRN = pPatientSearchResponse.Results.GetAt(i).MRN
				Set tAssigningAuthorityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAA,"")
				Set tAssigningAuthorityURL = ##class(HS.Data.OIDMap).GetURLForCode(tAA,"")
				#; If this match is the identifier that we queried on, then skip it.
				If tMRN=tQueriedIdentifier {
					If (tAssigningAuthorityOID'="")&&($Replace(tAssigningAuthorityOID,"urn:oid:","")=$Replace(tQueriedAssigningAuthorityOID,"urn:oid:","")) continue
					If (tAssigningAuthorityURL'="")&&(tAssigningAuthorityURL=tQueriedAssigningAuthorityURL) continue
				}
				If $Data(tIDs(tMRN,tAssigningAuthorityCode)) continue
				Set tIDs(tMRN,tAssigningAuthorityCode)=""
				If $i(tFieldNo)
				#; If targetSystems were specified, then use the AA as it was specified
				#; in the targetSystem parameter (OID or URL).  Otherwise, if a URL is
				#; defined for the AA code then use it.  Otherwise use the OID that is
				#; defined for the AA code.
				If (tAssigningAuthorityURL'="")&&($Data(tTargetSystemsSystems(tAssigningAuthorityURL))) {
					Set tAssigningAuthorityURI = tAssigningAuthorityURL
				} ElseIf (tAssigningAuthorityOID'="")&&($Data(tTargetSystemsSystems($Replace(tAssigningAuthorityOID,"urn:oid:","")))) {
					Set tAssigningAuthorityURI = tAssigningAuthorityOID
				} ElseIf tAssigningAuthorityURL'="" {
					Set tAssigningAuthorityURI = tAssigningAuthorityURL
				} Else {
					Set tAssigningAuthorityURI = tAssigningAuthorityOID
				}
				Set tParam = ##class(HS.FHIR.vSTU3.Model.Resource.Parameters.Parameter).%New()
				Set tSC = tParam.SetName("targetIdentifier") Quit:$$$ISERR(tSC)
				Set tSC = tParam.SetValueIdentifier(tMRN, tAssigningAuthorityURI, "official") Quit:$$$ISERR(tSC)
				Set tSC = tParameters.parameter.Insert(tParam) Quit:$$$ISERR(tSC)
			}
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pFHIRResponse.ContentType, tParameters, .tResponseStream, pOriginalRequest.FormatFHIROutput) Quit:$$$ISERR(tSC)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC))
		Set tSC = $$$OK
	}
	
	Quit tSC
}

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
		
		Set tOperationOutcome = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome).%New()
		Set tIssue = ##class(HS.FHIR.vSTU3.Model.Resource.OperationOutcome.Issue).%New()
		
		Set tEmptyParameters = ##class(HS.FHIR.vSTU3.Model.Resource.Parameters).%New()
		
		If $$$ISERR(pSC) {
			Set pFHIRResponse.Type = "OperationOutcome"
			Set tSC = tIssue.SetSeverity("error") Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetCode("exception") Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetDetails(, , , $system.Status.GetErrorText(pSC)) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetDiagnostics($system.Status.GetErrorText(pSC)) Quit:$$$ISERR(tSC)
			Set tSC = tIssue.SetLocation("") Quit:$$$ISERR(tSC)
			Set tSC = tOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
			Set pFHIRResponse.Status = 500
			Set pSC = $$$OK
		} Else {
			For i = 1:1:..Errors.Errors.Count() {
				Set tError = ..Errors.Errors.GetAt(i)
				If tError.Severity="error" {
					If (tError.Code="value")&&(tError.DetailsText="Requested record not found") {
						Set pFHIRResponse.Status = 404
						Set pFHIRResponse.Type = "OperationOutcome"
						Set tSC = tIssue.SetSeverity("error") Quit:$$$ISERR(tSC)
						Set tSC = tIssue.SetCode("not-found") Quit:$$$ISERR(tSC)
						Set tSC = tIssue.SetDetails(, , , "sourceIdentifier Patient Identifier not found") Quit:$$$ISERR(tSC)
						Set tSC = tIssue.SetDiagnostics("sourceIdentifier Patient Identifier not found") Quit:$$$ISERR(tSC)
						Set tSC = tIssue.SetLocation("") Quit:$$$ISERR(tSC)
						Set tSC = tOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
						Quit
					} ElseIf (tError.Code="code-invalid")&&(tError.DetailsText="sourceIdentifier Assigning Authority not found") {
						Set pFHIRResponse.Status = 400
					} ElseIf (tError.Code="code-invalid")&&(tError.DetailsText="targetSystem not found") {
						Set pFHIRResponse.Status = 403
					} Else {
						If tError.Code="exception" {
							Set pFHIRResponse.Status = 500
						} Else {
							Set pFHIRResponse.Status = 400
						}
					}
					Set pFHIRResponse.Type = "OperationOutcome"
					Set tSC = tIssue.SetSeverity("error") Quit:$$$ISERR(tSC)
					Set tSC = tIssue.SetCode(tError.Code) Quit:$$$ISERR(tSC)
					Set tSC = tIssue.SetDetails(, , , tError.DetailsText) Quit:$$$ISERR(tSC)
					Set tSC = tIssue.SetDiagnostics(tError.DetailsText) Quit:$$$ISERR(tSC)
					Set tSC = tIssue.SetLocation("") Quit:$$$ISERR(tSC)
					Set tSC = tOperationOutcome.issue.Insert(tIssue) Quit:$$$ISERR(tSC)
					Quit
				}
			}
		}
		
		If pFHIRResponse.Type="Parameters" {
			Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pFHIRRequest.ContentType, tEmptyParameters, .tResponseStream, pFHIRRequest.FormatFHIROutput)
		} ElseIf pFHIRResponse.Type="OperationOutcome" {
			Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pFHIRRequest.ContentType, tOperationOutcome, .tResponseStream, pFHIRRequest.FormatFHIROutput)
		}
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Do ..Errors.Errors.Clear()
	
	Quit tSC
}

Method ProcessMetadataRequest(pRequest As HS.Message.FHIR.Request, pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tResourceId = pRequest.AdditionalInfo.GetAt("CapabilityStatementId")
		If tResourceId="" {
			Set tSC = $$$ERROR($$$GeneralError, "CapabilityStatement resource id not specified")
			Quit
		}
		Set tXDataName = "ISCPIXmManager"
		
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

XData ISCPIXmManager
{
<CapabilityStatement xmlns="http://hl7.org/fhir">
  <placeholder>resource_id</placeholder>
  <text>
    <status value="additional" />
    <div xmlns="http://www.w3.org/1999/xhtml">CapabilityStatement for PIXm Manager Actor in the IHE IT Infrastructure Technical Framework Supplement 
      <a href="http://wiki.ihe.net/index.php/Patient_Identifier_Cross-Reference_for_Mobile_(PIXm)">Patient Identifier Cross-reference for Mobile (PIXm)</a></div>
  </text>
  <placeholder>url</placeholder>
  <name value="IHE.PIXm.manager" />
  <title value="IHE ITI Patient Identifier Cross-reference for Mobile (PIXm) - InterSystems PIXm Manager (server)" />
  <status value="active" />
  <experimental value="false" />
  <date value="2018-03-19" />
  <publisher value="InterSystems Corporation" />
  <description value="see http://wiki.ihe.net/index.php/Patient_Identifier_Cross-Reference_for_Mobile_(PIXm)" />
  <kind value="instance" />
  <placeholder>software</placeholder>
  <implementation>
    <description value="InterSystems PIXm Manager"/>
    <placeholder>implementation_url</placeholder>
  </implementation>
  <fhirVersion value="3.0.1" />
  <acceptUnknown value="no" />
  <format value="xml" />
  <format value="application/fhir+xml" />
  <format value="json" />
  <format value="application/fhir+json" />
  <rest>
    <mode value="server" />
    <documentation value="PIXm server provides capability to query for Patient resources by identifier" />
    <security>
      <placeholder>security_oauth_uris_extension</placeholder>
      <placeholder>security_cors</placeholder>
      <placeholder>security_service</placeholder>
    </security>
    <resource>
      <type value="CapabilityStatement" />
      <interaction>
        <code value="read" />
      </interaction>
    </resource>
    <resource>
      <type value="Patient" />
      <interaction>
        <code value="search-type" />
      </interaction>
      <searchParam>
        <name value="sourceIdentifier" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-sourceidentifier" />
        <type value="token" />
        <documentation value="The Patient identifier search parameter that will be used by the Patient Identifier Cross-reference Manager to find cross matching identifiers associated with the Patient Resource." />
      </searchParam>
      <searchParam>
        <name value="targetSystem" />
        <definition value="http://hl7.org/fhir/SearchParameter/Patient-targetsystem" />
        <type value="uri" />
        <documentation value="The target Patient Identifier Assigning Authority from which the returned identifiers should be selected." />
      </searchParam>
     </resource>
    <operation>
      <name value="ihe-pix"/>
      <definition>
        <reference value="http://hl7.org/fhir/OperationDefinition/patient-ihepix"/>
      </definition>
    </operation>
  </rest>
</CapabilityStatement>
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>TraceOperations</Value>
</Value>
<Value name="2">
<Value>MPIOperations</Value>
</Value>
<Value name="3">
<Value>HUB</Value>
</Value>
<Value name="4">
<Value>AffinityDomain</Value>
</Value>
<Value name="5">
<Value>AffinityDomainIsMPIID</Value>
</Value>
<Value name="6">
<Value>ApplyConsent</Value>
</Value>
<Value name="7">
<Value>Errors</Value>
</Value>
<Value name="8">
<Value>ResourceSchemaRoot</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}