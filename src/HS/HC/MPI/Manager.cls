Include HS.HC

/// The default MPI Manager component.<br> 
/// Determines how to handle MPI requests; sends messages to the MPI Operations component 
/// (which is different for different MPIs).
Class HS.HC.MPI.Manager Extends (HS.HC.Util.Trace.Helper, Ens.BusinessOperation) [ Inheritance = right, ProcedureBlock ]
{

Parameter HSDEPLOY = 1;

/// Invoke InProc
Parameter INVOCATION = "InProc";

Parameter DOMAIN = "HS";

/// If there's an external patient matching engine, this should be the name of the business operation
/// that sends messages to the external patient matching engine
Property MPIOperations As Ens.DataType.ConfigName;

/// This is only applicable if there's no external patient matching engine
/// Flag to control how/if the MPI should link record based on demographic match.  Values are:
///   - Probable: Will match based on lastname+firstname+address+phone+fuzzy birthdate, OR
///               lastname+firstname+zip+birthdate, OR lastname+SSN, OR firstname+SSN+birthdate
///   - Strict: Will match based on lastname+firstname+address+phone+birthdate, OR
///               lastname+SSN+zip+birthdate, OR firstname+SSN+zip+birthdate
/// 
///   - Never: No linking of MRNs is done on demographics
Property DemographicLinkMode As %String(DISPLAYLIST = ",Probable,Strict,Never", VALUELIST = ",Probable,Strict,Never") [ InitialExpression = "Probable" ];

/// Timeout in seconds for MPI operations.  -1 means no timeout
Property MPITimeout As %Integer [ InitialExpression = -1 ];

/// For secondary MPIs, which need to be queried only after getting the primary response
Property MPISecondaryOperations As Ens.DataType.ConfigName;

/// Name of a custom business host that defines a step for the MPI Manager to perform just before it communicates with the MPI Operations component.
Property PreProcessor As Ens.DataType.ConfigName;

/// Name of a custom business host that defines a step for the MPI Manager to perform after it processes the search results, update, etc.
Property PostProcessor As Ens.DataType.ConfigName;

/// Name of the Consent Manager component in this production that applies consent filtering
Property ConsentProcessor As Ens.DataType.ConfigName;

/// Exact match mode, value is one of:
///   Exact: The search results must match only one patient. This means only one MPIID should be returned
///     by the search (perhaps with several records), else it will be aborted (returning no results).
///     The abort will occur even if later conditions (consent, infotype filters, etc) would reduce the
///     number of patients to just 1.
///   Any: The search can match any results (more than one patient)
Property MatchMode As %String(VALUELIST = ",Exact,Any") [ InitialExpression = "Any" ];

/// Set this to true if you want to permit inbound update requests to cause new facilities
/// to be added to the facility table.
Property DynamicFacilityRegistration As %Boolean [ InitialExpression = 0 ];

/// Set this to false if you do not want to permit inbound update requests to cause new assign authorities
/// to be added to the assigning authority table for medical record numbers
/// And note that an assigning authority may also get created for a facility as part of dynamic facility registration
Property DynamicAssignAuthorityRegistration As %Boolean [ InitialExpression = 1 ];

/// Name of the Push Evaluation Operation component that performs ***
Property PushEvaluator As Ens.DataType.ConfigName [ InitialExpression = "HS.Hub.Push.Evaluator" ];

/// Only applicable if there is no external patient matching engine, or
/// if we're doing a search that bypasses the external engine (by cohort, by relationship, etc.)
/// Maximum number of MPIID matches to return during a patient search
Property MaxMatches As %Integer [ InitialExpression = 50 ];

/// Which Host to send IDUpdateNotificationRequests
Property PIXManager As Ens.DataType.ConfigName;

/// If IdentifierCompatibilityMode is true, then an incoming patient update with at least one identifier
/// will clear <b>all</b> existing identifiers (except use "SN", insurance IDs), regardless of whether any of the incoming identifiers has
/// the same type.  Identifiers with use "SN" will only be replaced if one of the incoming identifiers also has use "SN".<br>
/// If IdentifierCompatibilityMode is false, then any existing identifiers will only be removed if the incoming patient update
/// has at least one identifier <b>with the same use</b>.
Property IdentifierCompatibilityMode As %Boolean [ InitialExpression = 1 ];

/// Settings for this Business Process
Parameter SETTINGS As %String = "DemographicLinkMode,MatchMode,DynamicFacilityRegistration, DynamicAssignAuthorityRegistration, , MaxMatches,PIXManager,IdentifierCompatibilityMode";

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.MergePatientRequest"> 
		<Method>MergePatient</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.PatientSearchRequest"> 
		<Method>SearchMPI</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.AddUpdateHubRequest">
		<Method>AddUpdateHub</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.FindAutoLinkMatchRequest">
		<Method>DelegateToMPI</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.IDUpdateNotificationRequest">
		<Method>ExternalUpdateMPIIDRequest</Method>
	</MapItem>

</MapItems>
}

/// Delegate this message to the MPI
Method DelegateToMPI(pRequest As Ens.Request, ByRef pResponse As Ens.Response) As %Status
{
	#dim tSC As %Status
	Set tSC = $$$OK
	Do {
		Set tSC=..InvokePreProcessor(.pRequest)
		Quit:$$$ISERR(tSC)		
		Set tSC = ..SendRequestSync(..MPIOperations,pRequest,.pResponse,..MPITimeout)
		$$$HSTRACE("Delegated to MPI","tSC,pRequest,pResponse",tSC,pRequest,pResponse)
		Quit:$$$ISERR(tSC)
		Set tSC=..InvokePostProcessor(pRequest,.pResponse)
	} While (0)
Exit
	Quit tSC
}

Method InvokePreProcessor(ByRef pRequest As Ens.Request) As %Status
{
	Quit:..PreProcessor="" $$$OK
	Set tRequest=pRequest
	Set tSC= ..SendRequestSync(..PreProcessor,tRequest,.pRequest)
	$$$HSTRACE("Sent Pre Processor","tSC,tRequest,pRequest",tSC,tRequest,pRequest)
	Quit tSC
}

Method InvokePostProcessor(pRequest As Ens.Request, ByRef pResponse As Ens.Response) As %Status
{
	Quit:..PostProcessor="" $$$OK
	Set tRequest=##Class(HS.Message.PostProcessorRequest).%New()
	Set tRequest.OriginalRequest=pRequest
	Set tRequest.OriginalResponse=pResponse
	Set tSC= ..SendRequestSync(..PostProcessor,tRequest,.pResponse)
	$$$HSTRACE("Sent Post Processor","tSC,tRequest,pResponse",tSC,tRequest,pResponse)
	Quit tSC
}

/// Utility method - pass in pAA, pMRN, and it will return either the corresponding MPIID if found, or "" if not
ClassMethod MRNtoMPIID(pAA, pMRN) As %String
{
	&SQL(Select MPIID into :tMPIID FROM HS_Registry.Patient WHERE MRN=:pMRN AND AssigningAuthority=:pAA)
	Quit:SQLCODE'=0 ""
	Quit tMPIID
}

/// Utility method
/// Used to fetch a patient search response, based on an MPIID, or MRN+AA.  For compatibility, this uses the more
/// generic search request, but ignores everything except for the MPIID, MRN, AA
/// Used to get the patient name or to get a list of MRN, for audit reports, etc.
/// pFull - if true, load the full patient.  Otherwise, just return MRN, Facility, AA
ClassMethod GetMPIID(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse, pFull As %Boolean = 1) As %Status
{
	Set pResponse=##Class(HS.Message.PatientSearchResponse).%New()
	Set tMPIID=pRequest.MPIID
	IF pRequest.MPIID="" {
		Set tMRN=pRequest.MRN,tAA=pRequest.AssigningAuthority
		&SQL(Select MPIID into :tMPIID FROM HS_Registry.Patient WHERE MRN=:tMRN AND AssigningAuthority=:tAA)
		Quit:SQLCODE'=0 $$$OK
	}
	Quit ..ReturnMPIID(tMPIID,.pResponse,pFull)
}

/// Utility method, a bit simpler than GetMPIID, for those who will be fetching only by MPIID
ClassMethod ReturnMPIID(pMPIID, ByRef pResponse, pFull As %Boolean = 0) As %Status
{
	Set pResponse=##Class(HS.Message.PatientSearchResponse).%New()
	Set tRes=##class(%SQL.Statement).%ExecDirect(,"Select %ID,AssigningAuthority,Facility,MRN from HS_Registry.Patient WHERE MPIID=? ORDER By IsNull(Facility->Tier,99999),LastEnteredOnC DESC",pMPIID)
	If tRes.SQLCODE Quit $$$ERROR(tRes.SQLCODE,tRes.%Message)
	While tRes.%Next() {
		Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
		Set tMatch.MPIID=pMPIID, tMatch.AssigningAuthority=tRes.AssigningAuthority
		Set tMatch.Facility=tRes.Facility,tMatch.MRN=tRes.MRN
		Set tMatch.CanFilterInfoTypes=1  //this distinguished primary from secondary results
		If pFull {
			Set tId=tRes.%GetData(1)
			Set tPatient=##Class(HS.Registry.Patient).%OpenId(tId)
			Set tSC=..LoadPatient(tPatient,.tMatch)
		}
		//We insert the results based on the tiered/updated ordering, so the best is first
		Do pResponse.Results.Insert(tMatch)
	}
	Quit $$$OK
}

/// Search the MPI.  pRequest.SearchMode: user - regular view-type search.  Does consent & infotype filter, drops results whose facility has no gateway (i.e. mini-reg only)
/// Admin: administrative: no consent filter, no return of facility/MRN.
/// participation: special for RI participation gateway.  Suppress Audit
/// clinician: special consent filter - also passes if there's a relationship
/// PIXPDQ: for PIX or PDQ
/// PIXPDQ_c: for PIX or PDQ, consent applied
/// AuditReport: deprecated
Method SearchMPI(pRequest As HS.Message.PatientSearchRequest, pResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim tSC As %Status
	#dim tIndex As %String
	#dim tResponse As HS.Message.PatientSearchResponse
	#dim tMatch As HS.Message.PatientSearchMatch
	#dim tHit As HS.Message.PatientSearchMatch
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		$$$HSTRACE("SearchRequest","pRequest",pRequest)
		#dim tDupeHash
		#dim tResult As HS.Message.PatientSearchMatch
		set tNewRequest=pRequest.%ConstructClone(1)
		Set pResponse=##class(HS.Message.PatientSearchResponse).%New()
		// Invoke the pre-processor (if specified)
		Set tSC=..InvokePreProcessor(.tNewRequest)
		Quit:$$$ISERR(tSC)		
		//suppress facility filter for primary search of an external MPI - we will use this later after any secondary MPI
		Set:..MPIOperations'="" tFac=tNewRequest.Facility,tNewRequest.Facility=""
		Set tSC = ..PrimarySearch(tNewRequest,.tResponse)
		$$$HSTRACE("PrimarySearch","tResponse",tResponse)
		Set:$G(tFac)]"" tNewRequest.Facility=tFac
		Quit:$$$ISERR(tSC)

		Set tUseComposite = ##class(HS.Registry.Config).GetKeyValue("\MPI\CompositeHSPISearchResults",0)
		Set tHaveComposite = tUseComposite && ($IsObject(tResponse.MPIIDList) && tResponse.MPIIDList.Count() && $L(tResponse.MPIIDList.GetAt(1).LastName))
		Set tMatches  = $S(tHaveComposite:tResponse.MPIIDList, 1:tResponse.Results)
		Set tRankProp = $S(tHaveComposite:"Rank", 1:"RankOrScore")

		//Use results to get a ranked list of MPIIDs. 2010.2 - we no longer care about the result detail
		Kill tMPIArray
		Set tMPICount = tMatches.Count()
		For tI=1:1:tMPICount { Set tMPIMatch=tMatches.GetAt(tI)
			Set tMPIID=tMPIMatch.MPIID, tRank=$property(tMPIMatch,tRankProp)
			IF '$D(tMPIArray(tMPIID)) {
				//Check for exact match mode - if >1 MPIID, assume no match
				IF ..MatchMode="Exact",'tNewRequest.Recent,$D(tMPIArray) {Kill tMPIArray  Set tMPICount=0  Quit}
				Set tMPIArray(tMPIID)=tI
				Set tMPIArray(tMPIID,"Rank")=tRank
			} Else {
				Set:tRank>tMPIArray(tMPIID,"Rank") tMPIArray(tMPIID,"Rank")=tRank
			}
		}
		//for each MPIID found, collect all of the individual records, sorted by facility tier and last update
		Set tStatement=##Class(%SQL.Statement).%New()
		Set tSC=tStatement.%Prepare("Select %ID from HS_Registry.Patient WHERE MPIID=? ORDER By IsNull(Facility->Tier,99999),LastEnteredOnC DESC")
		Quit:$$$ISERR(tSC)
		Set tNQErr=0
		Set tMPIID="" For { Set tMPIID=$O(tMPIArray(tMPIID),1,tI)  Quit:tMPIID=""
			Set tRes=tStatement.%Execute(tMPIID), tFirst=0
			While tRes.%Next() {
				Set tId=tRes.%GetData(1)
				Set:$I(tFirst)=1 tMPIArray(tMPIID,"Best")=tId
				Set tPatient=##Class(HS.Registry.Patient).%OpenId(tId)
				Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
				Set tMatch.MPIID=tPatient.MPIID, tMatch.AssigningAuthority=tPatient.AssigningAuthority
				Set tMatch.MPIIDListItem = tI
				Set tMatch.Facility=tPatient.FacilityGetObjectId(),tMatch.MRN=tPatient.MRN
				Set tMatch.RankOrScore = tMPIArray(tMPIID,"Rank")
				Set tMatch.CanFilterInfoTypes=1  //this distinguished primary from secondary results
				Set tSC=..LoadPatient(tPatient,.tMatch)
				//We insert the results based on the tiered/updated ordering
				Do pResponse.Results.Insert(tMatch)
			}
			IF '$D(tMPIArray(tMPIID,"Best")) Kill tMPIArray(tMPIID) //no records exist in the registry
			IF 'tNQErr,tNewRequest.SearchMode="user",'tNewRequest.IgnoreSecondaryMPI,$D(^HS.XDSNQErrors(tMPIID)) Set tNQErr=1
		}
		If tNewRequest.SearchMode="user" {
			// Set up infotype filter, if present
			Kill tInfoTypeFilter
			For tI=1:1:tNewRequest.InfoTypes.Count() {
				Set tInfoType=tNewRequest.InfoTypes.GetAt(tI)
				If $L(tInfoType) {
					if $d(tInfoTypeFilter) {set tInfoTypeFilter=tInfoTypeFilter_","} else {set tInfoTypeFilter=""}
					Set tInfoTypeFilter(tInfoType)=1,tInfoTypeFilter=tInfoTypeFilter_tInfoType
				}
			}
		}
		Set pResponse.ResultsCount=tMPICount
		Set tSecondaryOps=..MPISecondaryOperations
		If tNQErr,tSecondaryOps'["HS.MPI.IHE.XDSb.Registry.SecondaryOperations" {
			Set tSecondaryOps="HS.MPI.IHE.XDSb.Registry.SecondaryOperations"_$S(tSecondaryOps="":"",1:",")_tSecondaryOps
		}
		If tSecondaryOps'="",tNewRequest.SearchMode="user",pResponse.Results.Count(),'tNewRequest.IgnoreSecondaryMPI {
			Set tRequest=##Class(HS.Message.PatientSecondarySearchRequest).%New()
			Set tRequest.PrimaryRequest=tNewRequest
			Set tRequest.PrimaryResponse=pResponse
			Set tSC = ..ProcessSecondaryMPISearch(tRequest, .pResponse,tSecondaryOps)
		}
		Quit:$$$ISERR(tSC)
		
		if (tNewRequest.SearchMode = "AuditReport") {
			/// This is for internal use by the audit report
			/// It needs to fetch a list of MRNs for that MPIID before starting the search
			$$$HSTRACE("Returning early for SearchMode=AuditReport","HS.Message.PatientSearchRequest",tNewRequest)
			Quit
		}
		
		Set tSC = ..AuditSearchResponse(tNewRequest,.pResponse) 
		Quit:$$$ISERR(tSC)
		// Audit, unless it's a Participation Gateway request
		If tNewRequest.SearchMode'="participation" {
			// For the audit trail
			Set tMPIlist="",tMRNlist=""
			For tI=1:1:pResponse.Results.Count() {
				Set tRes=pResponse.Results.GetAt(tI)
				If tRes.MPIID'="" {Set tMPIlist=tMPIlist_$LB(tRes.MPIID)}
				If tRes.MRN'="" {Set tMRNlist=tMRNlist_$LB(tRes.Facility_"^"_tRes.MRN_"^"_tRes.AssigningAuthority)}
			}
			#dim tReq AS HS.Message.PatientSearchRequest
			Set tReq=tNewRequest, tInitLog=tReq.RequestId
			Set tSC=##Class(HS.Audit.Criteria).CopyFrom(tReq,.tCriteria) Quit:$$$ISERR(tSC)  //to get only the criteria
			Set tSC=tCriteria.XMLExportToString(.tCriteriaString,"Criteria","literal")  Quit:$$$ISERR(tSC)
			//Set tSC=$$$HSAuditSearchPatient(.tInitLog,tReq.RequestingUser,tReq.RequestingUserRoles,tReq.RequestingGateway,tMPIlist,tMRNlist,tCriteriaString,tReq.BreakTheGlass,..%SessionId,tReq.RequestingForProxyUserID)  Quit:$$$ISERR(tSC)
			Quit:$$$ISERR(tSC)
			Set:tNewRequest.RequestId="" tNewRequest.RequestId=tInitLog
			Set:pResponse.RequestId="" pResponse.RequestId=tInitLog
		}

		// Invoke the post-processor (if specified)
		Set tSC=..InvokePostProcessor(tNewRequest,.pResponse)  Quit:$$$ISERR(tSC)
	
		if (pResponse.Results.Count() = 0) {			
			$$$HSTRACE("No results found","HS.Message.PatientSearchResponse",pResponse)
		} elseif tNewRequest.SearchMode="clinician"||(tNewRequest.SearchMode="PIXPDQ")||(tNewRequest.SearchMode="PIXPDQ_c") {
			$$$HSTRACE("Skipping filtering due to search mode","HS.Message.PatientSearchRequest",tNewRequest)
		} elseif tNewRequest.SearchMode'="user" { //for Admin & participation
			$$$HSTRACE("Skipping filtering due to non-user search mode","HS.Message.PatientSearchRequest",tNewRequest)
		} else {
			$$$HSTRACE("Filtering " _ pResponse.Results.Count() _ " Results","HS.Message.PatientSearchResponse",pResponse)
		}

		//Now look at each result, deal with additional info, facility filter, and infotypes filter
		For tIndex=pResponse.Results.Count():-1:1 {
			Set tResult=pResponse.Results.GetAt(tIndex)
			
			//Copy additional Info into Result, for potential use by external consent engine
			Set tElement="" For  { Set tItem = tNewRequest.AdditionalInfo.GetNext(.tElement) Quit:tElement=""  Do tResult.AdditionalInfo.SetAt(tItem,tElement)}

			IF tNewRequest.SearchMode="clinician"||(tNewRequest.SearchMode="PIXPDQ")||(tNewRequest.SearchMode="PIXPDQ_c") {
				Continue
			}
			IF tNewRequest.SearchMode'="user" { //for Admin & participation
				Set tResult.MRN="", tResult.Facility=""
				Set tSC=pResponse.Results.SetAt(tResult,tIndex) Quit:$$$ISERR(tSC)
				Continue
			}
			//check facility filter, if present
			IF tNewRequest.Facility'="", tNewRequest.Facility'=tResult.Facility {
				$$$HSTRACE("Removing PatientSearchMatch which failed facility filter","HS.Message.PatientSearchMatch",tResult)
				Do pResponse.Results.RemoveAt(tIndex)
				Continue
			}	
			Set tResult.RequestingUser=tNewRequest.RequestingUser
			Set tResult.RequestingUserRoles=tNewRequest.RequestingUserRoles
			
			//get list of information (document) types for the result and check if any match the filter (if any)
			Set tMRN = tResult.Facility_"^"_tResult.AssigningAuthority_"^"_tResult.MRN
			Set tTypes="",tType="",tInfoTypeMatch=0
			If tResult.InfoTypes'="" {
				//for secondary MPIs which supply InfoTypes
				For tI=1:1:$L(tResult.InfoTypes,",") {
					Set tType=$P(tResult.InfoTypes,",",tI)
					If $P(tType,".")'=""&&($D(tInfoTypeFilter(tType))||($D(tInfoTypeFilter($P(tType,"."))))) {Set tInfoTypeMatch=1 Quit}
				}
			} Else {
				FOR {
					Set tType=$O(^HS.InfoTypes(tMRN,tType)) Quit:tType=""
					Set tTypes=tTypes_$S(tTypes="":"",1:",")_tType
					Set tResult.InfoTypes=tTypes
					If $P(tType,".")'=""&&($D(tInfoTypeFilter(tType))||($D(tInfoTypeFilter($P(tType,"."))))) Set tInfoTypeMatch=1
				}
			}
			// If the user provided a filter, and this record does not match (and not secondary result) then reject
			IF $D(tInfoTypeFilter) { // user filter
				IF 'tInfoTypeMatch&&tResult.CanFilterInfoTypes {
					//This one fails the InfoType filter, so remove it
					$$$HSTRACE("Removing PatientSearchMatch which failed infotype filter","HS.Message.PatientSearchMatch",tResult)
					Do pResponse.Results.RemoveAt(tIndex)
					Set pResponse.InfoTypesFiltered=pResponse.InfoTypesFiltered+1
					Continue
				}
			}
		}  //end of for loop processing results
		
		Quit:$$$ISERR(tSC)

		//count results by MPIID before consent
		For tI=1:1:pResponse.Results.Count() IF $I(tMPIArray(pResponse.Results.GetAt(tI).MPIID,"Count"))

		// Consent Processing (if supplied and this is a "user" or "clinician" search)
		// or if we're searching on or maintaining a patient cohort that requires consent
		Set tProgramConsent=0
		If tNewRequest.Program'="",##Class(HS.Registry.Program).%OpenId(tNewRequest.Program).ConsentRequired Set tProgramConsent=1
		If 'tProgramConsent,tNewRequest.Membership'="",##Class(HS.Registry.Program).%OpenId(tNewRequest.Membership).ConsentRequired Set tProgramConsent=1
		If ..ConsentProcessor'="" {
			Set tSC=..ConsentProcessing(tNewRequest,.pResponse,tProgramConsent)
			Quit:$$$ISERR(tSC)
		} //end of consent processing
		
		//figure out which MPIIDs have had results filtered out
		//this will leave a results count in FCount for any MPIID remaining in the result set after filtering
		For tI=1:1:pResponse.Results.Count() IF $I(tMPIArray(pResponse.Results.GetAt(tI).MPIID,"FCount"))
		//check for MPIIDs that have been completely or partially filtered
		Set tMPIID="" For { Set tMPIID=$O(tMPIArray(tMPIID))  Quit:tMPIID=""
			IF '$D(tMPIArray(tMPIID,"FCount")) {Kill tMPIArray(tMPIID) Continue} //completely out
			IF tMPIArray(tMPIID,"Count")'=tMPIArray(tMPIID,"FCount") Set tMPIArray(tMPIID,"Filt")=1 //partially out
		}
		//Now sort the remaining MPIIDs by rank
		Set tMPIID="" For {Set tMPIID=$O(tMPIArray(tMPIID))  Quit:tMPIID=""  Set tMPISort(-tMPIArray(tMPIID,"Rank"),tMPIID)=""}
		//and correlate the remaining results by MPIID
		For tI=1:1:pResponse.Results.Count() {Set tMPIArray(pResponse.Results.GetAt(tI).MPIID,"Results",tI)=""}
		/*
		//prepare for grabbing relationships
		Set tRS=##class(%ResultSet).%New()
		Set tRS.ClassName="HS.Push.PatientClinicianRelationship"
		Set tRS.QueryName="ByPatientClinician"
		*/
		IF tNewRequest.RequestingForProxyID="" {
			//If there's no proxy, use the requestor's relationships
			Set tClinicianId=##Class(HS.Registry.Person.User).GetUserClinicianFromRequest(tNewRequest.RequestingUser)
		} Else {
			//otherwise, use the proxied user's relationships
			Set tClinicianId=tNewRequest.RequestingForProxyID
		}
		//Now, create the MPIID Matches in the response
		Set tMPICount=0
		Set tRank="" For { Set tRank=$O(tMPISort(tRank))  Quit:tRank=""
			Set tMPIID="" For { Set tMPIID=$O(tMPISort(tRank,tMPIID))  Quit:tMPIID=""
				Set tMPICount=tMPICount+1
				Set tMMatch=$$$NULLOREF
				If tHaveComposite {
					// PrimarySearch() already got a composite record from HSPI
					Set tMMatch=tResponse.MPIIDList.GetAt(pResponse.Results.GetAt($O(tMPIArray(tMPIID,"Results",""))).MPIIDListItem).%ConstructClone(1)
					Do tMMatch.SearchMatches.Clear()
				}
				If '$IsObject(tMMatch) {
					Set tMMatch=##Class(HS.Message.PatientMPIMatch).%New()
					Set tMMatch.MPIID=tMPIID
					Set tPatient=##Class(HS.Registry.Patient).%OpenId(tMPIArray(tMPIID,"Best"))
					Set tMMatch.AssigningAuthority=tPatient.AssigningAuthority
					Set tMMatch.Facility=tPatient.FacilityGetObjectId()
					Set tMMatch.MRN=tPatient.MRN
					Set tSC=..LoadPatient(tPatient,.tMMatch) Quit:$$$ISERR(tSC)
				}
				Do ##class(HS.Types.RequestInfo).CopyFrom(tNewRequest,.tMMatch)
				Set tMMatch.Rank=-tRank
				IF $D(tMPIArray(tMPIID,"Filt")) Set tMMatch.ConsentFiltered=1
				/*
				//add the relationships
				
				Set tSC=tRS.Execute(tMPIID,tClinicianId)
				While tRS.Next() {
					Do tMMatch.Relationships.Insert(tRS.Data("RelName"))
				}
				*/
				Do pResponse.MPIIDList.Insert(tMMatch)

				Set tI="" For { Set tI=$O(tMPIArray(tMPIID,"Results",tI))  Quit:tI=""
					Do tMMatch.SearchMatches.Insert(tI)
					Set:'tHaveComposite pResponse.Results.GetAt(tI).MPIID = tMPIID
					Set pResponse.Results.GetAt(tI).MPIIDListItem = pResponse.MPIIDList.Count()
				}
			}
			Quit:$$$ISERR(tSC)
		}
		Do ##class(HS.Types.RequestInfo).CopyFrom(tNewRequest,.pResponse)
		Set pResponse.ResultsCount=tMPICount
		Set:pResponse.RequestId="" pResponse.RequestId=tNewRequest.RequestId //return the initiating log ID
		Quit:$$$ISERR(tSC)
	} While (0)
Exit
	Set:$IsObject($g(pResponse)) pResponse.ErrStatus=tSC
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method AuditSearchResponse(pNewRequest, pResponse) As %Status
{
	Quit $$$OK
	/*
	try {
		// Audit, unless it's a Participation Gateway request
		If pNewRequest.SearchMode'="participation" {
			// For the audit trail
			Set tMPIlist="",tMRNlist=""
			For tI=1:1:pResponse.Results.Count() {
				Set tRes=pResponse.Results.GetAt(tI)
				If tRes.MPIID'="" {Set tMPIlist=tMPIlist_$LB(tRes.MPIID)}
				If tRes.MRN'="" {Set tMRNlist=tMRNlist_$LB(tRes.Facility_"^"_tRes.MRN_"^"_tRes.AssigningAuthority)}
			}
			#dim tReq AS HS.Message.PatientSearchRequest
			Set tReq=pNewRequest, tInitLog=tReq.RequestId
			Set tSC=##Class(HS.Audit.Criteria).CopyFrom(tReq,.tCriteria) Quit:$$$ISERR(tSC)  //to get only the criteria
			Set tSC=tCriteria.XMLExportToString(.tCriteriaString,"Criteria","literal")  Quit:$$$ISERR(tSC)
			Set tSC=$$$HSAuditSearchPatient(.tInitLog,tReq.RequestingUser,tReq.RequestingUserRoles,tReq.RequestingGateway,tMPIlist,tMRNlist,tCriteriaString,tReq.BreakTheGlass,..%SessionId,tReq.RequestingForProxyUserID)  Quit:$$$ISERR(tSC)
			Quit:$$$ISERR(tSC)
			Set:pNewRequest.RequestId="" pNewRequest.RequestId=tInitLog
			Set:pResponse.RequestId="" pResponse.RequestId=tInitLog
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
	*/
}

Method ConsentProcessing(pNewRequest, Output pResponse, pProgramConsent) As %Status
{
	/*
	try {
		Set tSC = $$$OK
		If $$$HSLicensed("Consent Management"), (pNewRequest.SearchMode="user")||(pNewRequest.SearchMode="clinician")||(pNewRequest.SearchMode="PIXPDQ_c")||pProgramConsent {
			// We pass the search response to the ConsentProcessor and take whatever we get back from that.
			If pNewRequest.SearchMode="clinician",'pProgramConsent {
				//if there's no program consent, then clinician mode consent is OK if there's a relationship
				Set tSC=##Class(HS.Registry.Person.User).ResolveUserClinician(.tClinicianId,pNewRequest.RequestingUser)
				Set:$$$ISOK(tSC) pResponse.ClinicianId=tClinicianId
			}
			Set pResponse.RequestId=pNewRequest.RequestId
			Set pResponse.RequestingUser=pNewRequest.RequestingUser
			Set pResponse.RequestingUserRoles=pNewRequest.RequestingUserRoles
			Set pResponse.RequestingForProxyUserID=pNewRequest.RequestingForProxyUserID
			Set pResponse.BreakTheGlass=pNewRequest.BreakTheGlass
			Set pResponse.ProgramConsent=pProgramConsent
			Set tSC = ..SendRequestSync(..ConsentProcessor,pResponse,.pResponse)
			Quit:$$$ISERR(tSC)
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
	*/
	Quit $$$OK
}

ClassMethod LoadPatient(pPatient As HS.Registry.Patient, ByRef pPatientInfo As HS.Types.PatientInfo) As %Status
{
	Set tSC=$$$OK
	Do {
		Set tI=""
		For{
			Set tAddr=pPatient.Addresses.GetNext(.tI)
			Quit:((tI="")||(tAddr=""))
			Kill tCopy Set tSC=##Class(HS.Types.Address).CopyFrom(tAddr,.tCopy) Quit:$$$ISERR(tSC)
			Do pPatientInfo.Addresses.Insert(tCopy)
			If tI=1 {
				Set pPatientInfo.Street=tAddr.StreetLine,pPatientInfo.City=tAddr.City,pPatientInfo.State=tAddr.State,pPatientInfo.Zip=tAddr.PostalCode
			}
		}
		Quit:$$$ISERR(tSC)
		Set tI=""
		For{
			Set tTel=pPatient.Telecoms.GetNext(.tI)
			Quit:((tI="")||(tTel=""))
			Set tUse=tTel.Use
			IF tUse="H"||(tUse="HP") {Set pPatientInfo.Telephone=tTel.PhoneNumberFull}
			ElseIF tUse="WP" {Set pPatientInfo.BusinessPhone=tTel.PhoneNumberFull}
			Kill tCopy Set tSC=##Class(HS.Types.Telecom).CopyFrom(tTel,.tCopy) Quit:$$$ISERR(tSC)
			Do pPatientInfo.Telecoms.Insert(tCopy)
		}
		Quit:$$$ISERR(tSC)
		Set tI=""
		For{
			Set tIdentifier=pPatient.Identifiers.GetNext(.tI)
			Quit:((tI="")||(tIdentifier=""))
			Kill tCopy Set tSC=##Class(HS.Types.Identifier).CopyFrom(tIdentifier,.tCopy) Quit:$$$ISERR(tSC)
			Do pPatientInfo.Identifiers.Insert(tCopy)
		}
		Quit:$$$ISERR(tSC)
		Set tI=""
		For{
			Set tName=pPatient.Names.GetNext(.tI)
			Quit:((tI="")||(tName=""))
			Kill tCopy Set tSC=##class(HS.Types.PersonName).CopyFrom(tName,.tCopy) Quit:$$$ISERR(tSC)
			Do pPatientInfo.Names.Insert(tCopy)
		}
		Quit:$$$ISERR(tSC)
		Set:pPatient.BirthDateTime'="" pPatientInfo.DOB=$ZDH(pPatient.BirthDateTime,3)
		Set pPatientInfo.BirthPlace= pPatient.BirthPlace
		Set pPatientInfo.BirthOrder= pPatient.BirthOrder
		Set pPatientInfo.EthnicGroup= pPatient.EthnicGroup
		Set pPatientInfo.CommunicationPreference= pPatient.CommunicationPreference
		Set pPatientInfo.Sex= pPatient.Gender
		Set pPatientInfo.Language= pPatient.Language
		Set pPatientInfo.MaritalStatus= pPatient.MaritalStatus
		Set pPatientInfo.MothersMaidenSurname= pPatient.MothersMaidenSurname
		Set pPatientInfo.LastName=pPatient.Name.Family
		Set pPatientInfo.FirstName=pPatient.Name.Given
		Set pPatientInfo.MiddleName=pPatient.Name.Middle
		Set pPatientInfo.Prefix=pPatient.Name.Prefix
		Set pPatientInfo.Suffix=pPatient.Name.Suffix
		Set pPatientInfo.Race= pPatient.Race
		Set pPatientInfo.ReligiousAffiliation= pPatient.ReligiousAffiliation
		Set pPatientInfo.SSN= pPatient.SSN
		Set pPatientInfo.VIP= pPatient.VIP
		Set pPatientInfo.CustomClassName= pPatient.CustomClassName
		Set pPatientInfo.CustomXMLString= pPatient.CustomXMLString
		Set pPatientInfo.CreatedOn = pPatient.CreatedOn
		Set pPatientInfo.Extension = pPatient.Extension
		Set pPatientInfo.MothersName = pPatient.MothersName
		Set pPatientInfo.FathersName = pPatient.FathersName
		Set pPatientInfo.SpousesName = pPatient.SpousesName
	} While 0
	Quit tSC
}

Method PrimarySearch(pRequest As HS.Message.PatientSearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse) As %Status
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		set tNewRequest=pRequest.%ConstructClone(1)
		Set pResponse=##Class(HS.Message.PatientSearchResponse).%New()
		//if requesting a single MPIID
		IF tNewRequest.MPIID'="" {
			Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
			Set tMatch.MPIID=tNewRequest.MPIID, tMatch.RankOrScore=1000
			Do pResponse.Results.Insert(tMatch)
			Quit
		}
		If tNewRequest.Recent{
			Set tRecent=$G(^HS.RecentPatients(tNewRequest.RequestingUser))
			For tI=1:1:$LL(tRecent) {
				Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
				Set tMatch.MPIID=$LI(tRecent,tI), tMatch.RankOrScore=1001-tI
				Do pResponse.Results.Insert(tMatch)
			}
			Quit
		}
		//For request by MRN+AA
		Set tMRN=tNewRequest.MRN,tAA=tNewRequest.AssigningAuthority
		IF tMRN'="",tAA'="" {
			&SQL(Select MPIID into :tMPIID FROM HS_Registry.Patient WHERE MRN=:tMRN AND AssigningAuthority=:tAA)
			$$$HSTRACE("finding patient by MRN/AA","tMRN,tAA,SQLCODE",tMRN,tAA,SQLCODE)
			Quit:SQLCODE'=0
			Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
			Set tMatch.MPIID=tMPIID, tMatch.RankOrScore=1000
			Do pResponse.Results.Insert(tMatch)
			Quit
		}
		//search by analytics ID - only available in User search mode, with consent
		If tNewRequest.AnalyticsID'="", tNewRequest.SearchMode="user" {
			Quit:'$D(^HS.AnalyticsID("Out",tNewRequest.AnalyticsID),tMPIID)
			Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
			Set tMatch.MPIID=tMPIID, tMatch.RankOrScore=1000
			Do pResponse.Results.Insert(tMatch)
			Quit
		}
				
		//Check for search by deterministic identifier - in this case, we expect only one of these, and
		//will ignore everything else
		Set tDoExact=0
		#dim tIdent As HS.Types.Identifier
		For tI=1:1:tNewRequest.Identifiers.Count() {
			Set tIdent=tNewRequest.Identifiers.GetAt(tI)
			IF tIdent.AssigningAuthorityName'="",tIdent.Extension'="",tIdent.Use'="" {
				Set tType=##Class(HS.AssignAuth.IdentifierType).TypeIndexOpen(tIdent.Use)
				IF tType'="",tType.ExactMatch {Set tDoExact=1 Quit}
			}
		}
		If tDoExact {
			Set tUse=tIdent.Use,tAA=tIdent.AssigningAuthorityName,tEx=tIdent.Extension
			&SQL(Select Patient->MPIID into :tMPIID FROM HS_Registry_Patient.Identifier WHERE Use=:tUse AND Extension=:tEx AND AssigningAuthorityName=:tAA)
			Quit:SQLCODE'=0
			Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
			Set tMatch.MPIID=tMPIID, tMatch.RankOrScore=1000
			Do pResponse.Results.Insert(tMatch)
			Quit
		}
		
		IF ..MPIOperations'=""&&(tNewRequest.Relationship="")&&(tNewRequest.Program="") {Set tSC = ..SendRequestSync(..MPIOperations,tNewRequest,.pResponse,..MPITimeout) Quit}
		//do local registry search
		Set tMaxMatches = tNewRequest.MaxMatches
		Set:tMaxMatches<1||(tMaxMatches>..MaxMatches) tMaxMatches = ..MaxMatches
		Set tCond="", p=0
		Set tMaxMatches=+tMaxMatches	//prevent SQL injection
		Set tSQL="SELECT DISTINCT TOP "_tMaxMatches_" %EXACT(Pat.MPIID) FROM HS_Registry.Patient Pat"
		Do addCondition(.tCond,tNewRequest.FirstName,"Pat.Name_Given","%STARTSWITH",.p)
		Do addCondition(.tCond,tNewRequest.LastName,"Pat.Name_Family","%STARTSWITH",.p)
		Do addCondition(.tCond,tNewRequest.DOB,"convert(DATE,Pat.birthdatetime)","=",.p)
		Do addCondition(.tCond,tNewRequest.Sex,"Pat.Gender","=",.p)
		Do addCondition(.tCond,tNewRequest.MRN,"Pat.MRN","=",.p)
		Do addCondition(.tCond,$TR(tNewRequest.SSN," _-"),"Pat.StrippedSSN","=",.p)
		Do addCondition(.tCond,tNewRequest.Facility,"Pat.Facility","=",.p)
		Set tWhere=tCond
		IF tNewRequest.Identifiers.Count() {
			Set tCond=""
			Set tIdentifier=tNewRequest.Identifiers.GetAt(1)
			Do addCondition(.tCond,tIdentifier.Use,"Use","=",.p)
			Do addCondition(.tCond,tIdentifier.Extension,"Extension","=",.p)
			Do addCondition(.tCond,tIdentifier.AssigningAuthorityName,"AssigningAuthorityName","=",.p)
			Do:tCond'="" addExists(.tWhere,tCond,"Identifier")
		}
		Set tPhone=$TR(tNewRequest.Telephone," _-().,/\")
		IF tPhone'="" {
			Set tCond=""
			Do addCondition(.tCond,"%"_tPhone_"%","HS_Registry.Patient_StripPhone(PhoneNumberFull)","LIKE",.p)
			Do addExists(.tWhere,tCond,"Telecom")
		}
		IF tNewRequest.Street_tNewRequest.City_tNewRequest.State_tNewRequest.Zip'="" {
			Set tCond=""
			Do addCondition(.tCond,tNewRequest.Street,"StreetLine","=",.p)
			Do addCondition(.tCond,tNewRequest.City,"City","=",.p)
			Do addCondition(.tCond,tNewRequest.State,"State","=",.p)
			Do addCondition(.tCond,tNewRequest.Zip,"PostalCode","=",.p)
			Do addExists(.tWhere,tCond,"Address")
		}
		Set:tWhere'="" tSQL=tSQL_" WHERE "_tWhere
		Set tRank=$S(p=0:500,tNewRequest.MRN'="":900,p>2:800,p=2:700,p=1:600,1:500)
		Set tStatement=##Class(%SQL.Statement).%New()
		Set tSC=tStatement.%Prepare(tSQL) Quit:$$$ISERR(tSC)
		Set tRes=tStatement.%Execute(p...)
		While tRes.%Next() {
			Set tMatch=##Class(HS.Message.PatientSearchMatch).%New()
			Set tMatch.MPIID=tRes.%GetData(1), tMatch.RankOrScore=tRank
			Do pResponse.Results.Insert(tMatch)
		}
		
	} While 0
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
	
	// Add conditions to our SQL where clause
addCondition(tCond,tValue,pField,pOp,pParams)
	Quit:tValue=""
	Set:tCond'="" tCond=tCond_" AND "
	Set tCond=tCond_"("_pField_" "_pOp_" ?)"
	Set pParams($I(pParams)) = tValue
	Quit

addExists(tWhere,tCond,tTable)
	Set:tWhere'="" tWhere=tWhere_" AND "
	Set tWhere=tWhere_"Exists(Select * from HS_Registry_Patient."_tTable_" WHERE Patient=Pat.ID AND "_tCond_")"
	Quit
}

/// Run a patient search through multiple MPIs
Method ProcessSecondaryMPISearch(pRequest As HS.Message.PatientSecondarySearchRequest, ByRef pResponse As HS.Message.PatientSearchResponse, pSecondaryOps) As %Status
{
	#dim tSC As %Status
	Set tSC = $$$OK
	Do {

		#dim tRequestList
		#dim tRq As Ens.CallStructure
		#dim tIndex As %Integer
		#dim tSucceeded As %Integer
		
		Set tSucceeded = 0
		Set tRequestList=$L(pSecondaryOps,",")
		// Invoke the MPI
		For tIndex = 1:1:tRequestList {
			// Construct a call structure
			Set tRq = ##class(Ens.CallStructure).%New()
			Set tRq.Request = pRequest
			Set tRq.TargetDispatchName = $P(pSecondaryOps,",",tIndex)
			Set tRequestList(tIndex) = tRq
		}
		
		// Issue multiple requests concurrently
		Set tSC = ..SendRequestSyncMultiple(.tRequestList, ..MPITimeout)
		Quit:$$$ISERR(tSC)
		
		Set pResponse=pRequest.PrimaryResponse
		
		For tIndex = 1:1:$L(pSecondaryOps,",") {
			// Process the responses
			Set tRq = tRequestList(tIndex)
			If $$$ISERR(tRq.ResponseCode) {
				Set tSC = $$$ADDSC(tSC, tRq.ResponseCode)
				Continue
			}
			
			#dim tThisResponse As HS.Message.PatientSearchResponse
			Set tThisResponse = tRq.Response
			
			// Handle the results
			If $G(pResponse)=$$$NULLOREF {
				// First set of results
				Set pResponse = tThisResponse
			} Else {
				// Subsequent results, we merge them
				For tJ = 1:1:tThisResponse.Results.Count() {
					#dim tMatch As HS.Message.PatientSearchMatch
					Set tMatch = tThisResponse.Results.GetAt(tJ)
					Do pResponse.Results.Insert(tMatch)
				}
			}
			
			Set tSucceeded = tSucceeded + 1
		}
		
		// Bail out if we didn't get at least 1 result
		Quit:'tSucceeded
		
	} While (0)
Exit
	Quit tSC
}

Method AddUpdateHub(pRequest As HS.Message.AddUpdateHubRequest, Output pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	#dim tSC As %Status
	#dim tRequest As HS.Message.AddPatientRequest
	#dim tPatient As HS.Registry.Patient
	Set tSC=$$$OK,$ZT="Trap"
	DO {
		set tNewRequest=pRequest.%ConstructClone(1)
		Do tNewRequest.NewResponse(.pResponse)
		Set:tNewRequest.LastEnteredOn="" tNewRequest.LastEnteredOn=$ZDT($H,3,1)
		Set tUpdateNotification = ##class(HS.Message.IDUpdateNotificationRequest).%New()
		Set tMPIID="",tMRN=tNewRequest.Facility_"^"_tNewRequest.AssigningAuthority_"^"_tNewRequest.MRN
		Set tIsHomeFacility=0
		IF tNewRequest.Addresses.Count() {
			//copy home address (or first address is no home address) into & from old individual properties, for backwards compatibility
			#dim tAddress As HS.Types.Address
			For tI=1:1:tNewRequest.Addresses.Count(),1 {
				Set tAddress=tNewRequest.Addresses.GetAt(tI)
				If (tAddress.Use = "H")||(tAddress.Use = "HP")||((tI=1)&&$G(tCycle)) {
					Set tNewRequest.City=tAddress.City,tNewRequest.State=tAddress.State,tNewRequest.Street=tAddress.StreetLine,tNewRequest.Zip=tAddress.PostalCode
					Quit
				}
				Set tCycle=1
			}
		} ElseIf tNewRequest.City_tNewRequest.State_tNewRequest.Street_tNewRequest.Zip'="" {
			Set tAddress=##Class(HS.Types.Address).%New()
			Set tAddress.City=tNewRequest.City, tAddress.State=tNewRequest.State,tAddress.StreetLine=tNewRequest.Street,tAddress.PostalCode=tNewRequest.Zip
			Do tNewRequest.Addresses.Insert(tAddress)
		}
		IF tNewRequest.Telecoms.Count() {
			//populate old properties & new for backwards compatibility
			#dim tTele As HS.Types.Telecom
			For tI=1:1:tNewRequest.Telecoms.Count() {
				Set tTele=tNewRequest.Telecoms.GetAt(tI)
				Set tUse=tTele.Use
				IF tUse="H"||(tUse="HP"),tTele.Email="" {Set tNewRequest.Telephone=tTele.PhoneNumberFull}
				ElseIF tUse="WP" {Set tNewRequest.BusinessPhone=tTele.PhoneNumberFull}
				If (tTele.PhoneNumberFull=$C(34,34)){
					Set:(tNewRequest.BusinessPhone="") tNewRequest.BusinessPhone=$C(34,34)
					Set:(tNewRequest.Telephone="") tNewRequest.Telephone=$C(34,34)
				}
				Set:tTele.Email=$C(34,34) tTele.Email=""
			}
		} Else {
			IF tNewRequest.Telephone'="" {
				Set tTele=##Class(HS.Types.Telecom).%New()
				Set tTele.Use="H",tTele.PhoneNumberFull=tNewRequest.Telephone
				Do tNewRequest.Telecoms.Insert(tTele)
			}
			If tNewRequest.BusinessPhone'="" {
				Set tTele=##Class(HS.Types.Telecom).%New()
				Set tTele.Use="WP",tTele.PhoneNumberFull=tNewRequest.BusinessPhone
				Do tNewRequest.Telecoms.Insert(tTele)
			}
		}
		Set tSC=..InvokePreProcessor(.tNewRequest)
		Quit:$$$ISERR(tSC)

		//Keep original extension XML until after preprocessor, then update Extension property
		If (tNewRequest.CustomClassName="HS.Local.SDA3.PatientExtension"){
			Set tReader = ##class(%XML.Reader).%New()
			Do tReader.OpenString(tNewRequest.CustomXMLString)
			Do tReader.Correlate("PatientExtension","HS.Local.SDA3.PatientExtension")
			Do tReader.Next(.tExtension, .tSC)
			Set:$$$ISOK(tSC) tNewRequest.Extension = tExtension
		}
		//Validate identifiers
		Set tLegacyIDs=##class(HS.Registry.Config).GetKeyValue("\General\LegacyPatientIdentifierTypeRestriction",0)
		For tI=1:1 {
			Set tIdentifier=tNewRequest.Identifiers.GetAt(tI) Quit:tIdentifier=""
			Set tType=tIdentifier.Use
			Continue:tType=""  //we allow in ones with no "Use", but they won't be useful
			Continue:",DL,DN,LN,PI,PPN,PT,RI,SN,XX,"[(","_tType_",") 
			If 'tLegacyIDs {
				Set tObj=##class(HS.AssignAuth.IdentifierType).%OpenId(tType)
				If $IsObject(tObj),tObj.Active,tObj.InSearchList Continue
			}
			$$$LOGALERT($$$Text("Bad Identifier Type, skipping")_": "_tType)
			Do tNewRequest.Identifiers.RemoveAt(tI)
			Set tI=tI-1		//Since we just removed an element, we want the next iteration to use the same index
		}
		Quit:$$$ISERR(tSC)
		//Validate facility
		Set tFacility=##Class(HS.Facility.Config).%OpenId(tNewRequest.Facility)
		IF tFacility'="" {
			//Check to make sure this is coming from the right gateway (except HomeFacility is OK from anywhere)
			IF tFacility.Gateway.Name'=tNewRequest.GatewayName,'tFacility.HomeFacility {Set tSC=$$$ERROR($$$HSErrFacilityGatewayMismatch,tFacility.FacilityCode,tNewRequest.GatewayName) QUIT}
			Set tIsHomeFacility=tFacility.HomeFacility
		}
		ElseIf tNewRequest.GatewayName '= "" {
			IF '..DynamicFacilityRegistration {Set tSC=$$$ERROR($$$HSErrFacilityNotFound,tNewRequest.Facility) QUIT}
			//Add Facility
			Set tFacility=##Class(HS.Facility.Config).%New()
			Set tSC=##Class(HS.Gateway.Config).FindByName(tNewRequest.GatewayName,.tGateway) QUIT:$$$ISERR(tSC)
			$$$HSTRACE("Adding Facility: "_tNewRequest.Facility_" to gateway: "_tNewRequest.GatewayName,"tGateway",tGateway)
			Set tSC=tFacility.GatewaySetObjectId(tGateway) Q:'tSC
			Set tFacility.FacilityCode=tNewRequest.Facility
			Set tFacility.Name=tNewRequest.Facility
			Set tFacility.AssigningAuthority=1
			$$$HSTRACE("Saving Facility","tFacility",tFacility)
			Set tSC=tFacility.%Save() QUIT:$$$ISERR(tSC)
		}
		If 'tNewRequest.DoDelete {
			Set tSC=##Class(HS.Message.AddPatientRequest).CopyFrom(tNewRequest,.tRequest,0)
			Set tRequest.AddOrUpdate=tNewRequest.AddOrUpdate
			For i=1:1:tNewRequest.Identifiers.Count() { 
				do tRequest.Identifiers.Insert(tNewRequest.Identifiers.GetAt(i))
			
				Do tUpdateNotification.Identifiers.Insert(tNewRequest.Identifiers.GetAt(i))
			 }
			For i=1:1:tNewRequest.Telecoms.Count() { do tRequest.Telecoms.Insert(tNewRequest.Telecoms.GetAt(i)) }
			For i=1:1:tNewRequest.Addresses.Count() { do tRequest.Addresses.Insert(tNewRequest.Addresses.GetAt(i)) }
			For i=1:1:tNewRequest.Names.Count() { do tRequest.Names.Insert(tNewRequest.Names.GetAt(i)) }
			Set:'(tNewRequest.BirthPlace.%IsNull()) tRequest.BirthPlace=tNewRequest.BirthPlace.%ConstructClone()
			Set:'(tNewRequest.FathersName.%IsNull()) tRequest.FathersName=tNewRequest.FathersName.%ConstructClone()
			Set:'(tNewRequest.MothersName.%IsNull()) tRequest.MothersName=tNewRequest.MothersName.%ConstructClone()
			Set:'(tNewRequest.SpousesName.%IsNull()) tRequest.SpousesName=tNewRequest.SpousesName.%ConstructClone()
			Set:'(tNewRequest.Extension.%IsNull()) tRequest.Extension = tNewRequest.Extension.%ConstructClone()
		}
		Quit:$$$ISERR(tSC)
		
		// Create assigning authority if not there
		If ..DynamicAssignAuthorityRegistration,tNewRequest.AssigningAuthority]"" {
			$$$HSTRACE("Adding Assigning Authority: "_tNewRequest.AssigningAuthority)
			Set tSC=##class(HS.AssignAuth.Config).RegisterAssigningAuthority("MR",tNewRequest.AssigningAuthority) Quit:$$$ISERR(tSC)
		}
		
		Set tPatient=##Class(HS.Registry.Patient).MRNIndexOpen(tNewRequest.MRN,tNewRequest.AssigningAuthority,tNewRequest.Facility)
		If tNewRequest.DoDelete {
			Set tMPIID=""
			If tPatient'="" {
				Set tMPIID=tPatient.MPIID
				Do ..AAResendQ(tMPIID)
				If ..PIXManager]"" {
					#; find the identifiers for the MPIID before we update them
					Set tIDUpdateNotification = ..UpdateNotificationGetPriorIdentifiers(tMPIID)
				}
				Set tSC = ..OnMRNDelete(tNewRequest.MRN,tNewRequest.AssigningAuthority,tMPIID, tPatient.%Id()) Quit:$$$ISERR(tSC)
				If ..PIXManager]"" {
					/// the tIDUpdateNotification has the list of prior identifiers for notification
					Set tSC = ..CreateAndSendPIXNotification(tMPIID,tIDUpdateNotification)
				}
				Set:'##Class(HS.Registry.Patient).MPIIDIndexExists(tMPIID) tMPIID="" // so that we won't attempt an MPIID scope push
				If tIsHomeFacility {Set tSC=..Audit("D",tPatient,tNewRequest) Quit:$$$ISERR(tSC)}
			}
		} ElseIf tPatient="" {
			Set tSC=..AddPatient(.tRequest,tNewRequest,tIsHomeFacility) Quit:$$$ISERR(tSC)  Set tMPIID=tRequest.MPIID
		} ElseIf tNewRequest.DoMPIUpdate {
			Set tSC=..UpdatePatient(tPatient,.tRequest,tNewRequest,tIsHomeFacility) Quit:$$$ISERR(tSC)   Set tMPIID=tRequest.MPIID
		} Else {
			Set tMPIID=tPatient.MPIID
		}
		Set pResponse.MPIID=tMPIID
		// When doing Analytics integration, for Mini-reg or other cases which populate the patient registry
		// without creating SDA on an edge gateway, queue up a fetch
		If 'tNewRequest.DoDelete Do ..UpdateAnalytics(tMPIID)
		// HS 2009.1.2 - take the list of InfoTypes from AdditionalInfo and replace what is stored
		//  Note that an empty list will remove them all
		Set tInfoTypeList=tNewRequest.AdditionalInfo.GetAt("InfoTypes")
		Kill ^HS.InfoTypes(tMRN)
		//HS 2012.1 - when doing a delete, this additionalnfo won't be here, so nothing more will happen for infotypes
		If $l(tInfoTypeList) {
			For ti=1:1:$l(tInfoTypeList,",") {			
				Set tInfoType=$p(tInfoTypeList,",",ti)
				If tInfoType'="" Set ^HS.InfoTypes(tMRN,tInfoType)="" 
				If tInfoType[".",'$D(^HS.InfoTypesSub(tInfoType)) {Set ^HS.InfoTypesSub(tInfoType)=""}
			}
		}
		// If we've moved a visit, this will update the prior MRN's infotype list
		Set tInfoTypeList=tNewRequest.AdditionalInfo.GetAt("UpdatePriorInfoTypes")
		IF tInfoTypeList'="" {
			Set tPriorMRN=$P(tInfoTypeList,"^",1,3),tInfoTypeList=$P(tInfoTypeList,"^",4)
			Kill ^HS.InfoTypes(tPriorMRN)
			If $l(tInfoTypeList) {
				For ti=1:1:$l(tInfoTypeList,",") {			
					Set tInfoType=$p(tInfoTypeList,",",ti)
					If tInfoType'="" Set ^HS.InfoTypes(tPriorMRN,tInfoType)="" 
				}
			}
		}
		IF tNewRequest.LogReportingEvent {
			#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
			Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create("InboundMessage","",pRequest.RequestingGateway)
			Do tAggregation.SetUser(pRequest)
			Set tAggregation.EventSubType=tNewRequest.MessageType
			Do tAggregation.AddPatient(tNewRequest.Facility_"^"_tNewRequest.MRN_"^"_tNewRequest.AssigningAuthority,"MRN",tNewRequest.LastName_", "_tNewRequest.FirstName_" "_tNewRequest.MiddleName)
			Do tAggregation.AddPatient(tMPIID,"MPIID",tNewRequest.LastName_", "_tNewRequest.FirstName_" "_tNewRequest.MiddleName)
			Set tSC=tAggregation.RecordAudit(tAggregation)
		}
		//AAUpdateQ won't be here when doing a delete
		IF tNewRequest.AAUpdateQ.Count() {Set tSC=..AAUpdateQ(tNewRequest,tMPIID,tMRN) Quit:$$$ISERR(tSC)}
		IF tNewRequest.DoPush {
			Set tNewRequest.MPIID=pResponse.MPIID
			Set tSC=..SendRequestSync(..PushEvaluator,tNewRequest,.pResponse)
		}
		If ..PIXManager]"",'tNewRequest.DoDelete {
			Set tSC = ..CreateAndSendPIXNotification(tMPIID,tUpdateNotification)
		}
		DO:$$$ISOK(tSC) ..InvokePostProcessor(tNewRequest,.pResponse)
	} While (0)
Exit
	Set pResponse.ErrStatus=tSC
	If $$$ISERR(tSC) {
		Set tErr=$system.Status.GetErrorText(tSC)
		$$$LOGERROR(tErr)
	}
	// Note: always return OK, else Ensemble thinks there is a system error and does not return pResponse
	Quit $$$OK
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method AddPatient(ByRef pRequest As HS.Message.AddPatientRequest, pAddUpRequest As HS.Message.AddUpdateHubRequest, pIsHomeFacility) As %Status
{
	#define DeleteIfQuotes(%val) $S(%val=$C(34,34):"",1:%val)	//two double quotes mean delete the value
	Do {
		Set $ZT="Trap", tSC=$$$OK
		#dim tSC As %Status
		Set tPatient=##Class(HS.Registry.Patient).%New()
		Set tPatient.AdditionalInfo=pRequest.AdditionalInfo
		For tI=1:1:pRequest.Addresses.Count() {Set x=##Class(HS.Registry.Patient.Address).%New(),tSC=x.CopyFrom(pRequest.Addresses.GetAt(tI),.x) Quit:$$$ISERR(tSC)  Do tPatient.Addresses.Insert(x)}
		Quit:$$$ISERR(tSC)
		Set tI=""
		For{
			Set tPhone = pRequest.Telecoms.GetNext(.tI)
			Quit:(tI="")

			Set x=##Class(HS.Registry.Patient.Telecom).%New()
			If (tPhone.PhoneNumber=$C(34,34)){
				Set pRequest.%ClearFields=pRequest.%ClearFields_$S(pRequest.%ClearFields="":"",1:",")_"Telecoms"
				Do pRequest.Telecoms.RemoveAt(tI)
				Set tI=tI-1
				Continue
			}
			Set tSC=x.CopyFrom(tPhone,.x)
			Quit:$$$ISERR(tSC)
			Do tPatient.Telecoms.Insert(x)
		}
		Quit:$$$ISERR(tSC)
		For tI=1:1:pRequest.Identifiers.Count() {
			If (pRequest.Identifiers.GetAt(tI).Extension=$C(34,34)){
				Set pRequest.%ClearFields=pRequest.%ClearFields_$S(pRequest.%ClearFields="":"",1:",")_"Identifiers"
				Do tPatient.Identifiers.Clear()
				Do pRequest.Identifiers.Clear()
				Quit
			}
			Set x=##Class(HS.Registry.Patient.Identifier).%New()
			Set tSC=x.CopyFrom(pRequest.Identifiers.GetAt(tI),.x) Quit:$$$ISERR(tSC)
			Do tPatient.Identifiers.Insert(x)
		}
		Quit:$$$ISERR(tSC)
		For tI=1:1:pRequest.Names.Count() {Set x=##Class(HS.Registry.Patient.Name).%New(),tSC=x.CopyFrom(pRequest.Names.GetAt(tI),.x) Quit:$$$ISERR(tSC)  Do tPatient.Names.Insert(x)}
		Quit:$$$ISERR(tSC)
		Set tPatient.AssigningAuthority=pRequest.AssigningAuthority
		Set:((pRequest.DOB'="")&&(pRequest.DOB'=$C(34,34))) tPatient.BirthDateTime=$ZDT(pRequest.DOB,3) //note - DOB is a date, has no time
		Set tPatient.BirthPlace=..CopyAndHandleQuotes(pRequest.BirthPlace)
		Set tPatient.BirthOrder=$$$DeleteIfQuotes(pRequest.BirthOrder)
		Set tPatient.EthnicGroup=$$$DeleteIfQuotes(pRequest.EthnicGroup)
		Set tPatient.CommunicationPreference=$$$DeleteIfQuotes(pRequest.CommunicationPreference)
		Do tPatient.FacilitySetObjectId(pRequest.Facility)
		Set tPatient.Gender=$$$DeleteIfQuotes(pRequest.Sex)
		Set tPatient.Language=$$$DeleteIfQuotes(pRequest.Language)
		//Set tPatient.LastUpdated not needed
		Set tPatient.MaritalStatus=$$$DeleteIfQuotes(pRequest.MaritalStatus)
		Set tPatient.MothersMaidenSurname=$$$DeleteIfQuotes(pRequest.MothersMaidenSurname)
		Set tPatient.MRN=pRequest.MRN
		Set tPatient.Name.Family=$$$DeleteIfQuotes(pRequest.LastName)
		Set tPatient.Name.Given=$$$DeleteIfQuotes(pRequest.FirstName)
		Set tPatient.Name.Middle=$$$DeleteIfQuotes(pRequest.MiddleName)
		Set tPatient.Name.Prefix=$$$DeleteIfQuotes(pRequest.Prefix)
		Set tPatient.Name.Suffix=$$$DeleteIfQuotes(pRequest.Suffix)
		Set tPatient.Race=$$$DeleteIfQuotes(pRequest.Race)
		Set tPatient.ReligiousAffiliation=$$$DeleteIfQuotes(pRequest.ReligiousAffiliation)
		Set tPatient.SSN=$$$DeleteIfQuotes(pRequest.SSN)
		Set tPatient.VIP=$$$DeleteIfQuotes(pRequest.VIP)
		// do not use two double quotes - delete instruction
		Set:pRequest.DeathTime'=$C(34,34) tPatient.DeathTime=pRequest.DeathTime
		Set tPatient.DeathStatus = $$$DeleteIfQuotes(pRequest.DeathStatus)
		Set tPatient.CreatedOn=pRequest.CreatedOn
		Set:tPatient.CreatedOn="" tPatient.CreatedOn=pRequest.LastEnteredOn
		Set tPatient.CreatedBy=pRequest.CreatedBy
		Set:tPatient.CreatedBy="" tPatient.CreatedBy=pRequest.LastEnteredBy
		Set tPatient.LastEnteredOn=pRequest.LastEnteredOn
		Set tPatient.LastEnteredBy=pRequest.LastEnteredBy
		Set:'(pRequest.FathersName.%IsNull()) tPatient.FathersName=..CopyAndHandleQuotes(pRequest.FathersName)
		Set:'(pRequest.MothersName.%IsNull()) tPatient.MothersName=..CopyAndHandleQuotes(pRequest.MothersName)
		Set:'(pRequest.SpousesName.%IsNull()) tPatient.SpousesName=..CopyAndHandleQuotes(pRequest.SpousesName)
		Set tPatient.CustomClassName=pRequest.CustomClassName
		Set tPatient.CustomXMLString=pRequest.CustomXMLString
		Set:'(pRequest.Extension.%IsNull()) tPatient.Extension=pRequest.Extension
		IF ..MPIOperations'="" {
			//We are passing in a new AddOrUpdate property, used by mini-reg.  
			//= nil- current behavior (let it decide)
			//="F" - let it decide, but force an override of all fields (we have a complete record)
			//="U" - we expect it to update a specific MPIID record with our added MRN
			//="A" - we expect it to create a new MPIID for our MRN
			//SMB 7/25/2012 - for HSPI, tell it the MPIID if we deterministically know this from the MRN+AA
			// with this change, the HSPI behavior of U and F are identical
			If pRequest.MPIID="" {
				&SQL(Select MPIID INTO :tMPIID FROM HS_Registry.Patient WHERE AssigningAuthority = UPPER(:pRequest.AssigningAuthority) AND MRN = UPPER(:pRequest.MRN))
				Set:SQLCODE=0 pRequest.MPIID=tMPIID
			}
			Set tSC = ..SendRequestSync(..MPIOperations,pRequest,.tResponse,..MPITimeout)
			$$$HSTRACE("Sent Add to MPI","tSC,pRequest,tResponse",tSC,pRequest,$G(tResponse))
			Quit:$$$ISERR(tSC)
			IF tResponse.PatientId="" {
				Set tSC=$$$ERROR($$$HSErrMPIIDNotReturned,..MPIOperations,pRequest.Facility_"^"_pRequest.AssigningAuthority_"^"_pRequest.MRN)
				Quit
			}
			//validation - if we have some other MPIID linked to a patient with the same AA & MRN, there's a problem
			&SQL(Select MPIID INTO :tMPIID FROM HS_Registry.Patient WHERE AssigningAuthority = UPPER(:pRequest.AssigningAuthority) AND MRN = UPPER(:pRequest.MRN))
			IF SQLCODE=0,tMPIID'=tResponse.PatientId {
				Set tSC=$$$ERROR($$$HSErrMPIIDInconsistent,..MPIOperations,tResponse.PatientId,pRequest.Facility_"^"_pRequest.AssigningAuthority_"^"_pRequest.MRN,tMPIID)
				Quit
			}
			Set pRequest.MPIID=tResponse.PatientId,tPatient.MPIID=pRequest.MPIID
			Set tSC=tPatient.%Save()
		} Else {
			//The lock is added to protect an unusual situation where simultaneous addupdate request comes in for
			// the same person at different facilities, and the person is new - it might not link the two records.
			Lock +^HS.Registry.Patient.MPIIDCount
			Try {
				Set tSC=..DetermineMPIID(.pRequest),tPatient.MPIID=pRequest.MPIID
				Set:$$$ISOK(tSC) tSC=tPatient.%Save()
			} catch ex {
				Set tSC = ex.AsStatus()
			}
			Lock -^HS.Registry.Patient.MPIIDCount
		}
		Quit:$$$ISERR(tSC)
		If pIsHomeFacility {
			Set tSC=..Audit("C",tPatient,pAddUpRequest)
		}
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method UpdatePatient(pPatient As HS.Registry.Patient, ByRef pRequest As HS.Message.AddPatientRequest, pAddUpRequest As HS.Message.AddUpdateHubRequest, pIsHomeFacility) As %Status
{
	#define DeleteIfQuotes(%val) $S(%val=$C(34,34):"",1:%val)	//two double quotes mean delete the value
	Do {
		Set $ZT="Trap", tSC=$$$OK
		#dim tSC As %Status
		Set tForceUpdate=(pRequest.AddOrUpdate'="")
		
		//serialize old data for audit, for home facility
		If pIsHomeFacility {
			Set tSC=pPatient.XMLExportToString(.tOldData,"BeforeUpdate","literal") Quit:$$$ISERR(tSC)
		}
		IF pRequest.MPIID="" {
			Set pRequest.MPIID=pPatient.MPIID
		} ELSEIF pRequest.MPIID'=pPatient.MPIID {
			Set tSC=$$$ERROR($$$HSErrMPIIDInconsistent,"UpdatePatient",pPatient.MPIID,pRequest.Facility_"^"_pRequest.AssigningAuthority_"^"_pRequest.MRN,pRequest.MPIID)
		}
		// Note -- for now, we're assuming that for multi-instance fields if there is any data then it replaces all instances.
		// For single instance fields if there is no data then we leave the field as is
		// (Except for insurance number, which replace only other insurance number identifiers.)
		If pRequest.AdditionalInfo.Count()>0 {
			Set tSC=pPatient.AdditionalInfo.Clear() Quit:$$$ISERR(tSC)
			Set pPatient.AdditionalInfo=pRequest.AdditionalInfo
		}
		If (pRequest.Addresses.Count()>0)||tForceUpdate { Set tSC=pPatient.Addresses.Clear() Quit:$$$ISERR(tSC) }
		If (pRequest.Telecoms.Count()>0)||tForceUpdate { Set tSC=pPatient.Telecoms.Clear() Quit:$$$ISERR(tSC) }
		If (pRequest.Names.Count()>0)||tForceUpdate { Set tSC=pPatient.Names.Clear() Quit:$$$ISERR(tSC) }
		For tI=1:1:pRequest.Addresses.Count() {Set x=##Class(HS.Registry.Patient.Address).%New(),tSC=x.CopyFrom(pRequest.Addresses.GetAt(tI),.x) Quit:$$$ISERR(tSC)  Do pPatient.Addresses.Insert(x)}
		Quit:$$$ISERR(tSC)
		Set tI=""
		For{
			Set tPhone = pRequest.Telecoms.GetNext(.tI)
			Quit:(tI="")

			Set x=##Class(HS.Registry.Patient.Telecom).%New()
			If (tPhone.PhoneNumber=$C(34,34)){
				Set pRequest.%ClearFields=pRequest.%ClearFields_$S(pRequest.%ClearFields="":"",1:",")_"Telecoms"
				Do pRequest.Telecoms.RemoveAt(tI)
				Set tI=tI-1
				Continue
			}
			Set tSC=x.CopyFrom(tPhone,.x)
			Quit:$$$ISERR(tSC)
			Do pPatient.Telecoms.Insert(x)
		}
		Quit:$$$ISERR(tSC)
		For tI=1:1:pRequest.Names.Count() {Set x=##Class(HS.Registry.Patient.Name).%New(),tSC=x.CopyFrom(pRequest.Names.GetAt(tI),.x) Quit:$$$ISERR(tSC)  Do pPatient.Names.Insert(x)}
		Quit:$$$ISERR(tSC)
		
		//How many identifiers are coming in with the request (vs. copied over from the patient)
		Set tNewIDCount = pRequest.Identifiers.Count()
		If ..IdentifierCompatibilityMode {
			// Replace insurance numbers if we have them, or if coming from mini-Reg.  Otherwise leave them as is.
			If tForceUpdate {
				Set tUpdateIdentifiers=1
			} Else {
				For tI=1:1:pRequest.Identifiers.Count() If pRequest.Identifiers.GetAt(tI).Use = "SN" Set tUpdateIdentifiers=1 Quit
			}
			If (('$G(tUpdateIdentifiers))&&(pRequest.Identifiers.Count()>0)) {
				Set tUpdateIdentifiers = 1
				For tI=1:1:pPatient.Identifiers.Count() {
					Set tIdentifier=pPatient.Identifiers.GetAt(tI)
					If tIdentifier.Use = "SN" {
						Set x=##Class(HS.Types.Identifier).%New(),tSC=x.CopyFrom(tIdentifier,.x) Quit:$$$ISERR(tSC)  
						Do pRequest.Identifiers.Insert(x)
					}
				}
			}
		}
		Else {
			If tForceUpdate||(pRequest.Identifiers.Count()>0) {
				Set tUpdateIdentifiers=1
			}
			// Only replace identifiers if we have a new identifier of the same Use.
			If pRequest.Identifiers.Count()>0{
				Kill tIDUses
				For tI=1:1:pRequest.Identifiers.Count(){
					Set tIDUses(" "_pRequest.Identifiers.GetAt(tI).Use)=1
				}
				For tI=1:1:pPatient.Identifiers.Count(){
					Set tPatIdent = pPatient.Identifiers.GetAt(tI)
					If '$G(tIDUses(" "_tPatIdent.Use)){	//copy the patient identifiers, if we don't already have one of that Use in the request
						Set tIdent = ##class(HS.Types.Identifier).%New()
						Set tSC = tIdent.CopyFrom(tPatIdent,.tIdent)
						Quit:$$$ISERR(tSC)
						Do pRequest.Identifiers.Insert(tIdent)
					}
				}
				Quit:$$$ISERR(tSC)
			}
		}
		If $G(tUpdateIdentifiers) {
			Set tSC=pPatient.Identifiers.Clear() Quit:$$$ISERR(tSC)
			For tI=1:1:pRequest.Identifiers.Count() {
				Set x=##Class(HS.Registry.Patient.Identifier).%New(),tSC=x.CopyFrom(pRequest.Identifiers.GetAt(tI),.x)
				Quit:$$$ISERR(tSC)
				If ((tNewIDCount=1)&&(x.Extension=$C(34,34))){
					Set pRequest.%ClearFields=pRequest.%ClearFields_$S(pRequest.%ClearFields="":"",1:",")_"Identifiers"
					Do pRequest.Identifiers.Clear()
					Quit
				}
				Do pPatient.Identifiers.Insert(x)
			}
		}
		Quit:$$$ISERR(tSC)
		
		Do pPatient.FacilitySetObjectId(pRequest.Facility)
		Set pPatient.MRN=pRequest.MRN
		Set pPatient.AssigningAuthority=pRequest.AssigningAuthority
		Set pPatient.MPIID=pRequest.MPIID
		Set pPatient.LastUpdated=+$H
		If pRequest.LastName_pRequest.FirstName_pRequest.MiddleName]""||tForceUpdate {
			Set pPatient.Name.Family=$$$DeleteIfQuotes(pRequest.LastName)
			Set pPatient.Name.Given=$$$DeleteIfQuotes(pRequest.FirstName)
			Set pPatient.Name.Middle=$$$DeleteIfQuotes(pRequest.MiddleName)
			Set pPatient.Name.Prefix=$$$DeleteIfQuotes(pRequest.Prefix)
			Set pPatient.Name.Suffix=$$$DeleteIfQuotes(pRequest.Suffix)
		}
		
		If (pRequest.DOB=$C(34,34)) { Set pPatient.BirthDateTime = "" }
		ElseIf ((pRequest.DOB'="")||(tForceUpdate)) {Set pPatient.BirthDateTime=$S(pRequest.DOB]"":$ZDT(pRequest.DOB,3),1:"") } //note - DOB is a date, has no time
		Set:('pRequest.BirthPlace.%IsNull())||tForceUpdate pPatient.BirthPlace=..CopyAndHandleQuotes(pRequest.BirthPlace)
		Set:pRequest.BirthOrder]""||tForceUpdate pPatient.BirthOrder=$$$DeleteIfQuotes(pRequest.BirthOrder)
		Set:pRequest.EthnicGroup]""||tForceUpdate pPatient.EthnicGroup=$$$DeleteIfQuotes(pRequest.EthnicGroup)
		Set:pRequest.CommunicationPreference]""||tForceUpdate pPatient.CommunicationPreference=$$$DeleteIfQuotes(pRequest.CommunicationPreference)
		Set:pRequest.Sex]""||tForceUpdate pPatient.Gender=$$$DeleteIfQuotes(pRequest.Sex)
		Set:pRequest.Language]""||tForceUpdate pPatient.Language=$$$DeleteIfQuotes(pRequest.Language)
		Set:pRequest.MaritalStatus]""||tForceUpdate pPatient.MaritalStatus=$$$DeleteIfQuotes(pRequest.MaritalStatus)
		Set:pRequest.MothersMaidenSurname]""||tForceUpdate pPatient.MothersMaidenSurname=$$$DeleteIfQuotes(pRequest.MothersMaidenSurname)
		Set:pRequest.Race]""||tForceUpdate pPatient.Race=$$$DeleteIfQuotes(pRequest.Race)
		Set:pRequest.ReligiousAffiliation]""||tForceUpdate pPatient.ReligiousAffiliation=$$$DeleteIfQuotes(pRequest.ReligiousAffiliation)
		Set:pRequest.SSN]""||tForceUpdate pPatient.SSN=$$$DeleteIfQuotes(pRequest.SSN)
		Set:pRequest.VIP]""||tForceUpdate pPatient.VIP=$$$DeleteIfQuotes(pRequest.VIP)
		Set:pRequest.DeathTime]""||tForceUpdate pPatient.DeathTime=$$$DeleteIfQuotes(pRequest.DeathTime)
		Set:pRequest.DeathStatus]""||tForceUpdate pPatient.DeathStatus = $$$DeleteIfQuotes(pRequest.DeathStatus)
		Set:pRequest.LastEnteredOn]"" pPatient.LastEnteredOn=pRequest.LastEnteredOn
		Set:pRequest.LastEnteredBy]"" pPatient.LastEnteredBy=pRequest.LastEnteredBy
		Set:pPatient.CreatedOn="" pPatient.CreatedOn=pRequest.CreatedOn
		Set:pPatient.CreatedOn="" pPatient.CreatedOn=pRequest.LastEnteredOn
		Set:pPatient.CreatedBy="" pPatient.CreatedBy=pRequest.CreatedBy
		Set:pPatient.CreatedBy="" pPatient.CreatedBy=pRequest.LastEnteredBy

		Set:'(pRequest.FathersName.%IsNull()) pPatient.FathersName=..CopyAndHandleQuotes(pRequest.FathersName)
		Set:'(pRequest.MothersName.%IsNull()) pPatient.MothersName=..CopyAndHandleQuotes(pRequest.MothersName)
		Set:'(pRequest.SpousesName.%IsNull()) pPatient.SpousesName=..CopyAndHandleQuotes(pRequest.SpousesName)

		Set:pRequest.CustomClassName]""||tForceUpdate pPatient.CustomClassName=pRequest.CustomClassName,pPatient.CustomXMLString=pRequest.CustomXMLString
		Set:'(pRequest.Extension.%IsNull()) pPatient.Extension=pRequest.Extension
		Set tSC=pPatient.%Save()
		Quit:$$$ISERR(tSC)
		IF ..MPIOperations'="" {
			Set tSC = ..SendRequestSync(..MPIOperations,pRequest,.tResponse,..MPITimeout)
			$$$HSTRACE("Sent Update to MPI","tSC,pRequest,tResponse",tSC,pRequest,$G(tResponse))
			Quit:$$$ISERR(tSC)
		} 
		If pIsHomeFacility {
			Set tSC=..Audit("U",pPatient,pAddUpRequest,tOldData)
		}
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Copies an object, replacing any properties equal to double quotes with an empty value<br>
/// Recurses on object properties, and handles array and list collections of both objects and datatypes
ClassMethod CopyAndHandleQuotes(pOriginal As %RegisteredObject) As %RegisteredObject
{
	//two double quotes mean delete the value
	#define DeleteIfQuotes(%val) $S(%val=$C(34,34):"",1:%val)
	Set tClassname = pOriginal.%ClassName(1)
	Set tCopy = $ClassMethod(tClassname,"%New")
	Set tPropName=""
	For{
		Set tPropName = $$$comMemberNext(tClassname,$$$cCLASSproperty,tPropName)
		Quit:(tPropName="")
		//don't try to copy or check calculated properties
		$$$comMemberKeyGetLvar(tCalculated,tClassname,$$$cCLASSproperty,tPropName,$$$cPROPcalculated)
		$$$comMemberKeyGetLvar(tPrivate,tClassname,$$$cCLASSproperty,tPropName,$$$cPROPprivate)
		Continue:(tCalculated||tPrivate)
		If $IsObject($Property(pOriginal,tPropName)){
			If $Property(pOriginal,tPropName).%Extends("%Collection.AbstractListOfDT"){
				Set tList = $Property(pOriginal,tPropName)
				Set tCopyList = $Property(tCopy,tPropName)
				For tIdx=1:1:tList.Count(){
					If (tList.GetAt(tIdx)'=$C(34,34)){
						Do tCopyList.Insert(tList.GetAt(tIdx))
					}
				}
			}
			ElseIf $Property(pOriginal,tPropName).%Extends("%Collection.AbstractListOfObj"){
				Set tList = $Property(pOriginal,tPropName)
				Set tCopyList = $Property(tCopy,tPropName)
				For tIdx=1:1:tList.Count(){
					Do tCopyList.Insert(..CopyAndHandleQuotes(tList.GetAt(tIdx)))
				}
			}
			ElseIf $Property(pOriginal,tPropName).%Extends("%Collection.AbstractArrayOfDT"){
				Set tIdx=""
				Set tArray = $Property(pOriginal,tPropName)
				Set tCopyArray = $Property(tCopy,tPropName)
				For{
					Set tInstance = tArray.GetNext(.tIdx)
					Quit:(tIdx="")
					Do:(tInstance'=$C(34,34)) tCopyArray.SetAt(tInstance,tIdx)
				}
			}
			ElseIf $Property(pOriginal,tPropName).%Extends("%Collection.AbstractArrayOfObj"){
				Set tIdx=""
				Set tArray = $Property(pOriginal,tPropName)
				Set tCopyArray = $Property(tCopy,tPropName)
				For{
					Set tInstance = tArray.GetNext(.tIdx)
					Quit:(tIdx="")
					Do tCopyArray.SetAt(..CopyAndHandleQuotes(tInstance),tIdx)
				}
			}
			Else{//recurse
				Set $Property(tCopy,tPropName) = ..CopyAndHandleQuotes($Property(pOriginal,tPropName))
			}
		}
		Else{
			Set $Property(tCopy,tPropName) = $$$DeleteIfQuotes($Property(pOriginal,tPropName))
		}
	}
	Quit tCopy
}

/// If no external patient matching engine, determine this directly from the registry
Method DetermineMPIID(ByRef pRequest As HS.Message.AddPatientRequest) As %Status
{
	#dim tSC As %Status
	#dim SQLCODE As %Integer
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		If pRequest.MPIID="" {
			//First, search by MRN+AA without facility (if we have 'em)
			IF pRequest.MRN'=""&& (pRequest.AssigningAuthority'="") {
				&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient
		 			WHERE AssigningAuthority = UPPER(:pRequest.AssigningAuthority)
					AND MRN = UPPER(:pRequest.MRN))
				IF SQLCODE=100 Set tMPIID="" //to get around nasty SQL behavior
				If (SQLCODE'=0) && (SQLCODE'=100) {
					Set tSC = $$$ERROR($$$SQLError,$Get(SQLCODE),$Get(%msg)) Quit
				}
		 		$$$HSTRACE("Trying Link by MRN+AA","SQLCODE,MPIID,MRN,AA",SQLCODE,tMPIID,pRequest.MRN,pRequest.AssigningAuthority)
			}
		} Else {
			Set tMPIID=pRequest.MPIID
		}
			
		// Check for deterministic identifiers, validating them
		#dim tIdent As HS.Types.Identifier
		For tI=1:1:pRequest.Identifiers.Count() {
			Set tIdent=pRequest.Identifiers.GetAt(tI)
			IF tIdent.AssigningAuthorityName=""||(tIdent.Extension="")||(tIdent.Use="") CONTINUE
			Set tType=##Class(HS.AssignAuth.IdentifierType).TypeIndexOpen(tIdent.Use)
			IF tType="" CONTINUE
			IF 'tType.ExactMatch CONTINUE
			Set tUse=tIdent.Use,tAA=tIdent.AssigningAuthorityName,tEx=tIdent.Extension
			&SQL(Select Patient->MPIID into :txMPIID FROM HS_Registry_Patient.Identifier WHERE Use=:tUse AND Extension=:tEx AND AssigningAuthorityName=:tAA)
			Set:SQLCODE'=0 txMPIID=""
			// Make sure the MPIID we found matches what we expect
			If txMPIID'="" {
				If tMPIID="",pRequest.AddOrUpdate'="A" {
					Set tMPIID=txMPIID
				} ElseIf (txMPIID'=tMPIID) { 
					Set tSC=$$$HSError($$$HSErrDuplicateIdentifier,tEx,txMPIID) Quit
				}
			}
		}
		Quit:$$$ISERR(tSC)
		
		If (pRequest.AddOrUpdate="A") { Set tMPIID= "" Quit } // Adding a new MPI ID
		Quit:tMPIID'=""  //got a deterministic match
		Quit:..DemographicLinkMode="Never" // No probablistic linking
		
		Set tSSN=$TR(pRequest.SSN," _-") Set:tSSN="" tSSN="*NOMATCH*"
		// Note: If several match, return the first
		//First try with name, address, and fuzzy DOB
		IF ..DemographicLinkMode="Probable" {
			&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Given = :pRequest.FirstName
			 		  AND Name_Family = :pRequest.LastName
			 		  AND Exists(Select * from HS_Registry_Patient.Address A Where P.ID=A.Patient AND A.City=:pRequest.City AND A.State=:pRequest.State AND A.StreetLine=:pRequest.Street AND A.PostalCode=:pRequest.Zip)
			 		  AND HS_Registry.Patient_FuzzyDateMatch(:pRequest.DOB,Cast(BirthDateTime As Date)) = 1)
			 	$$$HSTRACE("Trying Probable Link1","SQLCODE,MPIID,First,Last,Street,City,State,Zip,DOB",SQLCODE,tMPIID,pRequest.FirstName,pRequest.LastName,pRequest.Street,pRequest.City,pRequest.State,pRequest.Zip,pRequest.DOB)
			//Next, try with name, zip, DOB
			IF SQLCODE=100 {
				&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Given = :pRequest.FirstName
			 		  AND Name_Family = :pRequest.LastName
			 		  AND Exists(Select * from HS_Registry_Patient.Address A Where P.ID=A.Patient AND A.PostalCode=:pRequest.Zip)
			 		  AND Cast(BirthDateTime As Date) = :pRequest.DOB)
			 	$$$HSTRACE("Trying Probable Link2","SQLCODE,MPIID,First,Last,Zip,DOB",SQLCODE,tMPIID,pRequest.FirstName,pRequest.LastName,pRequest.Zip,pRequest.DOB)
			}
			//Next, try with last name and SSN
			IF SQLCODE=100 {
				&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Family = :pRequest.LastName AND StrippedSSN=:tSSN)
			 	$$$HSTRACE("Trying Probable Link3","SQLCODE,MPIID,Last,SSN",SQLCODE,tMPIID,pRequest.LastName,tSSN)
			}
			//Next, try with first name, DOB, and SSN
			IF SQLCODE=100 {
				&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Given = :pRequest.FirstName
			 		  AND Cast(BirthDateTime As Date) = :pRequest.DOB AND StrippedSSN=:tSSN)
			 	$$$HSTRACE("Trying Probable Link4","SQLCODE,MPIID,First,DOB,SSN",SQLCODE,tMPIID,pRequest.FirstName,pRequest.DOB,tSSN)
			}
	
			IF SQLCODE=100 Set tMPIID="" //to get around nasty SQL behavior
			
			If (SQLCODE'=0) && (SQLCODE'=100) {
				Set tSC = $$$ERROR($$$SQLError,$Get(SQLCODE),$Get(%msg))
			 }
		}
		IF ..DemographicLinkMode="Strict" {
			&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Given = :pRequest.FirstName
			 		  AND Name_Family = :pRequest.LastName
			 		  AND Exists(Select * from HS_Registry_Patient.Address A Where P.ID=A.Patient AND A.City=:pRequest.City AND A.State=:pRequest.State AND A.StreetLine=:pRequest.Street AND A.PostalCode=:pRequest.Zip)
			 		  AND Cast(BirthDateTime As Date)=:pRequest.DOB)
			//Next, try with name, zip, DOB
			IF SQLCODE=100 {
				&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Given = :pRequest.FirstName
			 		  AND Name_Family = :pRequest.LastName
			 		  AND Cast(BirthDateTime As Date) = :pRequest.DOB
			 		  AND Exists(Select * from HS_Registry_Patient.Address A Where P.ID=A.Patient AND A.PostalCode=:pRequest.Zip))
			}
			//Next, try with last name, ZIP, SSN and DOB
			IF SQLCODE=100 {
				&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Family = :pRequest.LastName
			 		  AND Cast(BirthDateTime As Date) = :pRequest.DOB
			 		  AND Exists(Select * from HS_Registry_Patient.Address A Where P.ID=A.Patient AND A.PostalCode=:pRequest.Zip)
			 		  AND StrippedSSN=:tSSN)
			}
			//Next, try with first name, ZIP, DOB, and SSN
			IF SQLCODE=100 {
				&sql(SELECT MPIID INTO :tMPIID
					FROM HS_Registry.Patient P
			 		WHERE Name_Given = :pRequest.FirstName
			 		  AND Cast(BirthDateTime As Date) = :pRequest.DOB
			 		  AND Exists(Select * from HS_Registry_Patient.Address A Where P.ID=A.Patient AND A.PostalCode=:pRequest.Zip)
					  AND StrippedSSN=:tSSN)
			}
	
			IF SQLCODE=100 Set tMPIID="" //to get around nasty SQL behavior

			If (SQLCODE'=0) && (SQLCODE'=100) {
				Set tSC = $$$ERROR($$$SQLError,$Get(SQLCODE),$Get(%msg))
			 }
		}
		 
	} While(0)

	IF tMPIID="" {
		IF '$D(^HS.Registry.Patient.MPIIDCount) Set ^HS.Registry.Patient.MPIIDCount=100000000
		Set tMPIID=$I(^HS.Registry.Patient.MPIIDCount)
	}
	Set pRequest.MPIID=tMPIID

Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method MergePatient(pRequest As HS.Message.MergePatientRequest, Output pResponse As HS.Message.MergePatientResponse) As %Status
{
	Do {
		Set $ZT="Trap"
		#dim tSC As %Status = $$$OK
		Set pResponse=##class(HS.Message.MergePatientResponse).%New()
		Set tOldMRN=pRequest.Facility_"^"_pRequest.PriorAssigningAuthority_"^"_pRequest.PriorMRN
		Set tNewMRN=pRequest.Facility_"^"_pRequest.AssigningAuthority_"^"_pRequest.MRN
		Quit:tOldMRN=tNewMRN
		Set tSC=..InvokePreProcessor(.pRequest) Quit:$$$ISERR(tSC)

		#; maintain a reference to the prior patient so that we can pass it in to the OnMRNMerge
		Set tPriorPatient=##Class(HS.Registry.Patient).MRNIndexOpen(pRequest.PriorMRN,pRequest.PriorAssigningAuthority,pRequest.Facility)
		Set tPriorMPIID = $S($isObject(tPriorPatient):tPriorPatient.MPIID,1:"")
		
		Set tSC=..MergeLink(pRequest,.pResponse) Quit:$$$ISERR(tSC)
		#; process cohort / relationship / consent updates
		If $IsObject(tPriorPatient) {
			#; if no prior patient is in the registry there couldn't be consent/cohorts/relationships assigned
			Set tTargetPatient=##Class(HS.Registry.Patient).MRNIndexOpen(pRequest.MRN,pRequest.AssigningAuthority,pRequest.Facility)
			$$$HSTRACE("Target Patient","pResponse,tTargetPatient,MRN,AA,FAC",pResponse,tTargetPatient,pRequest.MRN,pRequest.AssigningAuthority,pRequest.Facility)
			Set tSC = ..OnMRNMerge(pRequest,tPriorMPIID,tTargetPatient.MPIID) Quit:$$$ISERR(tSC)
		}

		Merge ^HS.InfoTypes(tNewMRN)=^HS.InfoTypes(tOldMRN) kill ^HS.InfoTypes(tOldMRN)
		If ..MPIOperations'="" {
			//send merge to external patient matching engine
			//This has to be done after running OnMRNMerge, to avoid a possible timing problem.
			//The matching engine may send an async HS.Message.IDUpdateNotificationRequest.
			//If so, this must happen after completing OnMRNMerge.
			Set tSC = ..SendRequestSync(..MPIOperations,pRequest,.pResponse,..MPITimeout)
		}
		Set tSC=..InvokePostProcessor(pRequest,.pResponse)
		Quit
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

Method MergeLink(pRequest As HS.Message.MergePatientRequest, Output pResponse As HS.Message.MergePatientResponse) As %Status
{
	Do {
		Set $ZT="Trap"
		#dim tSC As %Status
		#dim tPriorPatient As HS.Registry.Patient
		#dim tTargetPatient As HS.Registry.Patient
		Set tSC=$$$OK
		Set tPriorPatient=##Class(HS.Registry.Patient).MRNIndexOpen(pRequest.PriorMRN,pRequest.PriorAssigningAuthority,pRequest.Facility)
		Set tTargetPatient=##Class(HS.Registry.Patient).MRNIndexOpen(pRequest.MRN,pRequest.AssigningAuthority,pRequest.Facility)
		IF ..MPIOperations="" {
			//Where there is no external patient matching engine, do this ourselves
			Quit:tPriorPatient=""  //nothing to merge
			IF tTargetPatient="" {
			//If there's no patient with the target MRN, change the MRN of the prior one
				Set tPriorPatient.AssigningAuthority=pRequest.AssigningAuthority
				Set tPriorPatient.MRN=pRequest.MRN
				Set tSC=tPriorPatient.%Save()
				Set tTargetPatient=tPriorPatient
				Set tIDUpdateRequest = ..UpdateNotificationGetPriorIdentifiers(tPriorPatient.MPIID)
				Set tIDUpdateRequest.MPIID=tPriorPatient.MPIID
				Set tSC = ..UpdateMPIIDRequest(tIDUpdateRequest,.tIDUpdateResponse)
				Quit:$$$ISERR(tSC)
			} ElseIf tPriorPatient.MPIID'=tTargetPatient.MPIID {
				// Both the prior & target MRNs exist
				Set tTargetMPIID=tTargetPatient.MPIID, tPriorMPIID=tPriorPatient.MPIID
				#; 1st message move the MRN to the new MPI
				Set tIDUpdateRequest = ..UpdateNotificationGetPriorIdentifiers(tPriorPatient.MPIID)
				Set tIDUpdateRequest.Identifiers = tIDUpdateRequest.PriorIdentifiers,tIDUpdateRequest.PriorIdentifiers=""
				Set tIDUpdateRequest.MPIID=tTargetMPIID
				Set tIDUpdateRequest.PriorMPIID=tPriorMPIID
				Set tSC = ..UpdateMPIIDRequest(tIDUpdateRequest,.tIDUpdateResponse)
				Quit:$$$ISERR(tSC)

			}
			//last but not least delete the old one
			Set:tPriorPatient'=tTargetPatient tSC=tPriorPatient.%DeleteId(tPriorPatient.%Id())
			Set tIDUpdateRequest = ..UpdateNotificationGetPriorIdentifiers(tPriorPatient.MPIID)
			Set tIDUpdateRequest.Identifiers = tIDUpdateRequest.PriorIdentifiers,tIDUpdateRequest.PriorIdentifiers=""
			Set tSC = ..UpdateMPIIDRequest(tIDUpdateRequest,.tIDUpdateResponse)
			Quit:$$$ISERR(tSC)

		} Else {
			//Where there is an external matching engine, here we just clean up the patient registry
			//Any updating of MPIIDs will come later after we tell the matching engine about the merge				
			If tPriorPatient'="" {
				If tTargetPatient="" {
					//If there's no patient with the target MRN, change the MRN of the prior one
					Set tPriorPatient.AssigningAuthority=pRequest.AssigningAuthority
					Set tPriorPatient.MRN=pRequest.MRN
					Set tSC=tPriorPatient.%Save()	
				} Else {
					// If both prior and target exist, we delete the prior
					Set tSC=tPriorPatient.%DeleteId(tPriorPatient.%Id())
				}
			}
		}
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

ClassMethod UpdateNotificationGetPriorIdentifiers(pMPIID As %String) As HS.Message.IDUpdateNotificationRequest
{
	try {
		Set tResponse = ##class(HS.Message.IDUpdateNotificationRequest).%New()
		Set tResponse.MPIID = pMPIID
		Set tSearchRequest = ##class(HS.Message.PatientSearchRequest).%New()
		Set tSearchRequest.MPIID=pMPIID
		Set tSC = ..GetMPIID(tSearchRequest,.tSearchResponse)
		For tIdx =1:1:tSearchResponse.Results.Count() {
			Set tMatch = tSearchResponse.Results.GetAt(tIdx)
			If tIdx=1 Set tResponse.PatientDemographics = tMatch
			Set tIdentifier = ##class(HS.Types.Identifier).%New() 
			Set tIdentifier.Root=tMatch.AssigningAuthority
			Set tIdentifier.Extension=tMatch.MRN
			Do tResponse.PriorIdentifiers.Insert(tIdentifier)
		}
	} catch ex {
		Throw ex
	}
	quit tResponse
}

Method CreateAndSendPIXNotification(pMPIID, pUpdateNotification As HS.Message.IDUpdateNotificationRequest = "") As %Status
{
	try {
		Set tSC = $$$OK
		If '$IsObject(pUpdateNotification) {
			Set pUpdateNotification = ##class(HS.Message.IDUpdateNotificationRequest).%New()
		} 
		Set pUpdateNotification.MPIID=pMPIID
		For tIdx=1:1:pUpdateNotification.Identifiers.Count() {
			Set tIdentifier=pUpdateNotification.Identifiers.GetAt(tIdx)
			Set tIdent(tIdentifier.Root_" ",tIdentifier.Extension_" ")=""
		}
		Set tSearchRequest = ##class(HS.Message.PatientSearchRequest).%New()
		Set tSearchRequest.MPIID=pMPIID
		Set tSC = ..GetMPIID(tSearchRequest,.tSearchResponse)
		For tIdx = 1:1:tSearchResponse.Results.Count() {
			Set tMatch = tSearchResponse.Results.GetAt(tIdx)
			If tIdx=1 && '$IsObject(pUpdateNotification.PatientDemographics) Set pUpdateNotification.PatientDemographics = tMatch
			Set tIdentifier = ##class(HS.Types.Identifier).%New() 
			Set tIdentifier.Root=tMatch.AssigningAuthority
			Set tIdentifier.Extension=tMatch.MRN
			If $D(tIdent(tIdentifier.Root_" ",tIdentifier.Extension_" ")) Continue
			Set tIdent(tIdentifier.Root_" ",tIdentifier.Extension_" ")=""
			Do pUpdateNotification.Identifiers.Insert(tIdentifier)
			For tIdx2 = 1:1:tMatch.Identifiers.Count() {
				Set tIdentifier=tMatch.Identifiers.GetAt(tIdx2)
				If $D(tIdent(tIdentifier.Root_" ",tIdentifier.Extension_" ")) Continue
				Set tIdent(tIdentifier.Root_" ",tIdentifier.Extension_" ")=""
				Do pUpdateNotification.Identifiers.Insert(tIdentifier)
			}
		}
		$$$HSTRACE("Notification","pUpdateNotification,tSearchResponse",pUpdateNotification,tSearchResponse)
		Set tSC = ..SendRequestAsync(..PIXManager,pUpdateNotification)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Invoke pre and postprocessors when an inbound request is received from an external MPI to update the MPI ID for one or many MRN's
Method ExternalUpdateMPIIDRequest(pRequest As HS.Message.IDUpdateNotificationRequest, Output pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	Try {
		Set tSC = $$$OK
		Set pResponse = ##class(HS.Message.AddUpdateHubResponse).%New()
		Set tSC=..InvokePreProcessor(.pRequest) Quit:$$$ISERR(tSC)		
		Set tSC=..UpdateMPIIDRequest(pRequest,.pResponse) Quit:$$$ISERR(tSC)
		Set tResponse=##class(Ens.Response).%New()	
		Set tSC=..InvokePostProcessor(pRequest,.tResponse)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}

	Set pResponse.ErrStatus=tSC
	Quit tSC
}

/// An inbound request from the MPI to update the MPI ID for one or many MRN's
Method UpdateMPIIDRequest(pRequest As HS.Message.IDUpdateNotificationRequest, Output pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	Try {
		Set tSC = $$$OK
		Set pResponse = ##class(HS.Message.AddUpdateHubResponse).%New()
		#; if we are sending out transactions from the pix manager get the demographics
		If ..PIXManager]"" {
			#; grab the patient demographics and prior identifiers
			Set tIDUpdateNotification = ..UpdateNotificationGetPriorIdentifiers($Select(pRequest.PriorMPIID]"":pRequest.PriorMPIID,1:pRequest.MPIID))
			$$$HSTRACE("tIDUpdateNotification","tIDUpdateNotification",tIDUpdateNotification)
			If '$IsObject(tIDUpdateNotification.PatientDemographics) {
				#; if the prior mpiid has no records, then the demographics will be empty, fetch demo's from new mpiid
				Set tIDUpdateDemographics = ..UpdateNotificationGetPriorIdentifiers(pRequest.MPIID)
				Set tIDUpdateNotification.PatientDemographics=tIDUpdateDemographics.PatientDemographics
			}
			Set pRequest.PatientDemographics = tIDUpdateNotification.PatientDemographics
			/// only update the prior identifiers if they weren't given
			Set:'pRequest.PriorIdentifiers.Count() pRequest.PriorIdentifiers=tIDUpdateNotification.PriorIdentifiers
		}

		#; only need to update the MPIID if it is different
		If pRequest.MPIID'=pRequest.PriorMPIID && (pRequest.PriorMPIID]"") {
			Set tHome=##class(HS.Facility.Config).GetHomeFacility()
			Set tSQL="SELECT ID FROM HS_Registry.Patient WHERE AssigningAuthority = ? AND MRN = ?"
			TSTART
			For tIdx = 1:1:pRequest.Identifiers.Count() {
				Set tIdentifier = pRequest.Identifiers.GetAt(tIdx)
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,tSQL,tIdentifier.Root,tIdentifier.Extension)
				If 'tRS.SQLCODE {
					While tRS.%Next() {
						Set tPatient=##class(HS.Registry.Patient).%OpenId(tRS.ID)
						If tPatient.MPIID'=pRequest.MPIID {
							If tPatient.MPIID=pRequest.PriorMPIID {
								// Can only have one MRN for the home facility
								
								If tIdentifier.Root=tHome {
									&SQL(SELECT ID INTO :tId FROM HS_Registry.Patient WHERE MPIID=:pRequest.MPIID AND Facility = :tHome )
									If 'SQLCODE {
										Set tDPatient=##class(HS.Registry.Patient).%OpenId(tId)
										Set tSC=##class(HS.Registry.Patient).%DeleteId(tId)
										$$$ThrowOnError(tSC)
										Set tSC=..Audit("D",tDPatient,pRequest)
										$$$ThrowOnError(tSC)
									}
								}
							} Else {
								$$$LOGWARNING($$$FormatText($$$Text("MPI ID update expected ID %1 or %2 but found %3"),pRequest.PriorMPIID, pRequest.MPIID, tPatient.MPIID))
							}
							Set tPatient.MPIID = pRequest.MPIID
							Set tSC = tPatient.%Save()
							$$$ThrowOnError(tSC)
						}
					} 
				} Else {
					$$$LOGWARNING($$$FormatText($$$Text("MPI ID update for unknown MRN %1"),tIdentifier.Root_" - "_tIdentifier.Extension))	
				}
			}
			Set tSC = ..OnMPIUpdate(pRequest) $$$ThrowOnError(tSC)
			TCOMMIT
		}

		If ..PIXManager]"" {
			If pRequest.PriorMPIID'=pRequest.MPIID && (pRequest.PriorMPIID]"") {
				$$$HSTRACE("Send notification about MPI ID Update","pRequest",pRequest)
				#; send directly as CreateAndSend will get all identifiers - this is the notification of the moving identifiers
				Set tSC = ..SendRequestAsync(..PIXManager,pRequest)
				$$$ThrowOnError(tSC)
				#; need to send a notification about the prior mpiid
				Set tSearchRequest = ##class(HS.Message.PatientSearchRequest).%New()
				Set tSearchRequest.MPIID=pRequest.PriorMPIID
				Set tSC = ..GetMPIID(tSearchRequest,.tSearchResponse)
				$$$ThrowOnError(tSC)
				If tSearchResponse.Results.Count()=0 {
					Set tSearchRequest.MPIID=pRequest.MPIID
					Set tSC = ..GetMPIID(tSearchRequest,.tSearchResponse)
					$$$ThrowOnError(tSC)
				}
				Set tIDUpdateNotification = ##class(HS.Message.IDUpdateNotificationRequest).%New()
				Set tIDUpdateNotification.PatientDemographics = $S($IsObject(tSearchResponse.Results.GetAt(1)):tSearchResponse.Results.GetAt(1),1:##Class(HS.Message.PatientSearchMatch).%New())
				Set tSC = ..CreateAndSendPIXNotification(pRequest.PriorMPIID,tIDUpdateNotification)
				$$$ThrowOnError(tSC)
			}
			#; this is the notification of the identifiers currently on the mpi (after the update)
			Set tSC = ..CreateAndSendPIXNotification(pRequest.MPIID)
			$$$ThrowOnError(tSC)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {TROLLBACK}
	Set pResponse.ErrStatus=tSC
	Quit tSC
}

/// Called when an MRN is deleted.
ClassMethod OnMRNDelete(pMRN As %String, pAA As %String, pMPIID As %String, pPatientId As %String)
{
	Set tSC=##class(HS.Registry.Patient).%DeleteId(pPatientId) Quit:$$$ISERR(tSC)
	Quit $$$OK
}

/// Called when one MRN is merged into another to update cohorts / consent
ClassMethod OnMRNMerge(pRequest As HS.Message.MergePatientRequest, pPriorMPIID As %String, pTargetMPIID As %String) As %Status
{
	Quit $$$OK
}

/// Updating the MPI ID from one value to another 
ClassMethod OnMPIUpdate(pIDUpdateRequest As HS.Message.IDUpdateNotificationRequest = "") As %Status
{
	Quit $$$OK
}

/// event action - C - create, U - Update, D - Delete
ClassMethod Audit(pEventAction, pPatient As HS.Registry.Patient, pRequest As HS.Types.RequestInfo, pOldData As %String = "") As %Status
{
	Set tSC=$$$OK
	Do {
		#dim tAggregation As HS.IHE.ATNA.Repository.Aggregation
		Set tAggregation=##class(HS.IHE.ATNA.Repository.Aggregation).Create("Patient Record",.pInitiatingLogID,,pEventAction)
		DO tAggregation.SetUser(pRequest)
		Set tTag=$Case(pEventAction,"C":"Patient","D":"Patient",:"AfterUpdate")
		Set tSC=pPatient.XMLExportToString(.tPatientData,tTag,"literal") Quit:$$$ISERR(tSC)
		If pEventAction="C" {Set tDetails="<Create>"_tPatientData_"</Create>"}
		ElseIf pEventAction="U" {Set tDetails="<Update>"_pOldData_tPatientData_"</Update>"}
		Else {Set tDetails="<Delete>"_tPatientData_"</Delete>"}
		Set tMRN=pPatient.Facility.FacilityCode_"^"_pPatient.MRN_"^"_pPatient.AssigningAuthority
		Set tName=pPatient.Name.Family_", "_pPatient.Name.Given
		Set:pPatient.Name.Middle'="" tName=tName_", "_pPatient.Name.Middle
		Set tAggregation.Criteria=tDetails
		Do tAggregation.AddPatient(tMRN,"MRN",tName)
		Set tSC= tAggregation.RecordAudit(tAggregation)
	} While 0
	Quit tSC
}

ClassMethod AAUpdateQ(pRequest, pMPIID, pMRN) As %Status
{
	Set tSC=$$$OK,$ZT="Trap"
	//The shared lock is just to protect this from the snapshot copying of the queue
	Lock +^HS.AADBQ(pMPIID)
	Do {
		//First, process resends
		Set tKey="R",tFac=pRequest.Facility
		For {
			Set tVal=pRequest.AAUpdateQ.GetNext(.tKey) Quit:$E(tKey)'="R"
			//key=R^facility^AA^medrec#
			Set tPat=##Class(HS.Registry.Patient).MRNIndexOpen($P(tKey,"^",4),$P(tKey,"^",3),$P(tKey,"^",2))
			If '$IsObject(tPat) CONTINUE
			Do ..AAResendQ(tPat.MPIID,1)
		}
		Quit:$D(^HS.AADBQ(pMPIID,"Resend"))  //no point in continuing if we're going to do a full resend
		//next, process all inserts, updates, deletes
		For tAction="I","U","D" {
			set tKey=tAction
			For {
				Set tVal=pRequest.AAUpdateQ.GetNext(.tKey) Quit:$E(tKey)'=tAction
				//key=I or U or D^streamlettype, val is a comma separated list of streamlet IDs_"^"_hasencflag, ending in comma
				Set tType=$P(tKey,"^",2)
				For tI=1:1:$L(tVal,",")-1 {
					Set tItem=$P(tVal,",",tI),tTag=pRequest.Facility_"^"_$P(tItem,"^"),tHasEnc=$P(tItem,"^",2)
					If tAction="I" {Set ^HS.AADBQ(pMPIID,"Update",tTag)="I^"_tType_"^"_tHasEnc Continue} //for inserts
					//for inserts and deletes, first check for pending moves
					If tAction="D" {  //for deletes
						//if not pending, just flag as delete
						If '$D(^HS.AADBQ(pMPIID,"Update",tTag),tUp) {Set ^HS.AADBQ(pMPIID,"Update",tTag)="D^"_tType_"^"_tHasEnc}
						//discard pending insert if we're just gonna delete it
						ElseIf $P(tUp,"^")="I"  {Kill ^HS.AADBQ(pMPIID,"Update",tTag)}
						//change pending update to delete
						ElseIf $P(tUp,"^")="U" {Set $P(tUp,"^")="D",^HS.AADBQ(pMPIID,"Update",tTag)=tUp}
						Continue
					}
					//for updates
					//if not pending, just flag as update
					If '$D(^HS.AADBQ(pMPIID,"Update",tTag),tUp) {Set ^HS.AADBQ(pMPIID,"Update",tTag)="U^"_tType_"^"_tHasEnc}
					//change pending insert to update
					ElseIf $P(tUp,"^")="I" {Set $P(tUp,"^")="U",^HS.AADBQ(pMPIID,"Update",tTag)=tUp}
					//can't have a pending delete if we're updating it
				}
			}
		}
	} While 0
Exit
	Lock -^HS.AADBQ(pMPIID)
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

ClassMethod UpdateAnalytics(pMPIID)
{
	/*
	Quit:'$$$AnalyticsFeed
	Quit:$D(^HS.AADBQ(pMPIID,"Resend"))
	Quit:..HasFeedableMRNs(pMPIID)
	Set ^HS.AADBQ(pMPIID,"Update","*PatientRegistry*^*")="U^Patient^0" 
	*/
}

/// pNoCheck avoids a redundant check to see if we're doing analytics feeding
ClassMethod AAResendQ(pMPIID, pNoCheck = 0)
{
}

/// This is jobbed by the management operations when it receives a gateway registration request which changes a
/// gateway's FeedAnalytics property, and when we're globally set up to do analytics feeding
ClassMethod AAQBackground(pGateway)
{
	Set $ZT="Trap",tSC=$$$OK
	$$$LOGINFO($$$Text("Started"))
	Do {
		Set tSQL="Select MPIID from HS_Registry.Patient where Facility->Gateway->Name =?"
		SET tStatement = ##class(%SQL.Statement).%New()
		Set tSC=tStatement.%Prepare(tSQL) Quit:$$$ISERR(tSC)
		Set tRS=tStatement.%Execute(pGateway)
		While tRS.%Next() {
			Do ..AAResendQ(tRS.%GetData(1),1)
		}
	} While 0
Exit
	Set $ZT=""
	If $$$ISOK(tSC) {
		$$$LOGINFO($$$Text("Completed OK"))
	} Else {
		$$$LOGERROR($system.Status.GetErrorText(tSC))
	}
	Quit
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Pass in an MPIID.  Will determine if the MPIID has any MRNs which belong to facilities
/// which reside on a gateway that is configured to feed analytics
ClassMethod HasFeedableMRNs(pMPIID) As %Boolean
{
	&SQL(Select Count(*) INTO :tCount
	 FROM HS_Registry.Patient P,HS_Facility.Config F
	 WHERE MPIID=:pMPIID AND P.Facility=F.FacilityCode and F.Gateway->FeedAnalytics=1)
	 Quit tCount>0
}

Storage Default
{
<Data name="ManagerDefaultData">
<Subscript>"Manager"</Subscript>
<Value name="1">
<Value>MPIOperations</Value>
</Value>
<Value name="2">
<Value>MatchMode</Value>
</Value>
<Value name="3">
<Value>PreProcessor</Value>
</Value>
<Value name="4">
<Value>PostProcessor</Value>
</Value>
<Value name="5">
<Value>UpdatePreProcessor</Value>
</Value>
<Value name="6">
<Value>SearchPostProcessor</Value>
</Value>
</Data>
<DefaultData>ManagerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
