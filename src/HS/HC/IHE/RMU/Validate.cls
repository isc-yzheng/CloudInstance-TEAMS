Include HS.HC

/// 
Class HS.HC.IHE.RMU.Validate Extends HS.Util.BaseHost
{

/// List of properties which cannot be modified by RMU Update 
///    PropertyName:SpecializedError
/// Without :SpecializedError a UnmodifiableMetadataError will be returned
Property RMUPolicy As %String(MAXLEN = "") [ InitialExpression = "PatientID:XDSPatientIDReconciliationError,SourcePatientID,ObjectType,Availability,LogicalIID:XDSMetadataIdentifierError,Version,DocumentID:XDSMetadataIdentifierError,RepositoryUniqueID" ];

/// List of properties an organization would like to restrict from being updated by RMU Update (ie. Size,Hash)
/// 	PropertyName:SpecializedError
/// Without a :SpecializedError specified a LocalPolicyRestrictionError will be returned<br>
/// Other examples include ClassCode,FormatCode,HealthCareFacilityTypeCode,PracticeSettingCode,TypeCode
Property LocalRMUPolicy As %String(MAXLEN = "");

///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br><br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to other business hosts using pHost.SendRequestAsync or pHost.SendRequest.Sync<br><br>
/// <Method>ValidateRMURequest</Method> is called from both the RMU Process  takes the inbound HS.Message.IHE.XDM.DistributeDocumentSetRequest and
///  <li>Validates various aspects of the submission ensuring there are no updates to folders or submission, that the patient identifiers match and there is only one home community defined</li>
/// 	 <Parameter>pErrors as HS.Types.IHE.Errors</Parameter> Error collection reference
/// 	 <Parameter>pRequest as HS.Message.IHE.XDSb.Metadata</Parameter> Translated request object
/// 	 <Parameter>pHome as %String</Parameter> Output of HomeCommunity information
/// 	 <Parameter>pMustBeOurHome as %Boolean</Parameter> Will check to ensure it is this Community when true
///  
///   <Method>ClassMethod OnPreValidateRMURequest(pHost As Ens.Host ,ByRef pStop as %Boolean, Output pErrors as HS.Types.IHE.Errors, pRequest As HS.Message.IHE.XDSb.Metadata, ByRef pHome as %String,pMustBeHome as %Boolean) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error). </li>
/// 	<li>Updates can be done to the DistributeDocumentSet object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostValidateRMURequest(pHost As Ens.Host, Output pErrors as HS.Types.IHE.Errors, pRequest As HS.Message.IHE.XDSb.Metadata, ByRef pHome as %String,pMustBeHome as %Boolean) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
/// 
Method ValidateRMURequest(pErrors As HS.Types.IHE.Errors, pRequest As HS.Message.IHE.XDSb.Metadata, Output pHome As %String, pMustBeOurHome As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	$$$OnPre(.tStop,.pErrors,.pRequest,.pHome,.pMustBeOurHome) 
	If $G(tStop) || $$$ISERR(tSC) {
		Quit tSC
	}
	try {
		Set pHome=0
		If pRequest.Submissions.Count()>1 {
			Do pErrors.logError("XDSObjectTypeError","Error","Unexpected Submission set")
		}
		If pRequest.Folders.Count() {
			Do pErrors.logError("XDSObjectTypeError","Error","Unexpected Folders")
		}

		Set tSubmissionSet = pRequest.Submissions.GetAt(1)
		If '$IsObject(tSubmissionSet) {
			Do pErrors.logError("XDSbRegistryMetadataError","Error","Submission set is missing")
			Quit
		}

		For tIdx=1:1:pRequest.Associations.Count() {
			Set tAssociation = pRequest.Associations.GetAt(tIdx)
			Set tTargetObject = tAssociation.TargetObject
			If tTargetObject="" {
				Do pErrors.logError("XDSbRegistryMetadataError","Error","Invalid target object for Association "_tIdx)
				Quit
			}
			Set tAryTargets(tTargetObject)=""
			For tIdxSlots = 1:1:tAssociation.Slots.Count() {
				Set tSlot=tAssociation.Slots.GetAt(tIdxSlots)
				Set tPropagate = 1
				if tSlot.Name="AssociationPropagation" {
					Set tPropagate=$S($zcvt(tSlot.ValueList.GetAt(1).Value,"l")="no":0,1:1)
				}
				If 'tPropagate {
					Do pErrors.logError("XDSMetadataAnnotationError","Error","Document "_tAssociation.TargetObject_" has AssociationPropagation set to no")
				}
			}
		}
		Quit:pErrors.Errors.Count()


		Set tSubmissionPatient = tSubmissionSet.PatientIdentifier.Value
		If tSubmissionPatient="" {
			Do pErrors.logError("XDSbRegistryMetadataError","Error","Submission set patient identifier is null")
			Quit
		}

		For tIdx = 1:1:pRequest.Associations.Count() {
			Set Association = pRequest.Associations.GetAt(tIdx)
		}		

		For tIdx=1:1:pRequest.Documents.Count() {
			Set tDocument=pRequest.Documents.GetAt(tIdx)
			Kill tAryTargets(tDocument.EntryUUID)
			If tDocument.PatientIdentifier.Value '= tSubmissionPatient {
				Do pErrors.logError("XDSPatientIDReconciliationError","Error","Patient identifier for document does not match submission set")
			}
			Set tHomeCommunityOid = tDocument.HomeCommunityId
			If tHomeCommunityOid]"" {
				If '$D(pHome(tHomeCommunityOid)) {
					Do $i(pHome)
					Set tServiceObject = ##class(HS.Registry.Service.SOAP).EndPointForOID(tHomeCommunityOid,"HomeCommunity","RMU")
					Set pHome(tHomeCommunityOid)=tServiceObject.Name
					Set pHome("ServiceName")=tServiceObject.Name
					Set pHome("HomeCommunityOID")=tHomeCommunityOid
				}
			}
			Set tLogicalUUID=tDocument.LogicalUUID
			If tLogicalUUID'?1"urn:uuid:"8AN1"-"4AN1"-"4AN1"-"4AN1"-"12AN Do pErrors.logError("XDSInvalidRequestException","Error","Document Logical Entry UUID format incorrect for document ["_tIdx_"]:"_tLogicalUUID) continue
			If tLogicalUUID=tDocument.EntryUUID Do pErrors.logError("XDSInvalidRequestException","Error","Document Logical Entry UUID cannot be equal Entry UUID:"_tLogicalUUID) continue
			If $D(tAryHaveDoc(tLogicalUUID)) Do pErrors.logError("XDSRegistryMetadataError","Error","Document Logical Entry UUID appears more than once in submission for:"_tLogicalUUID) continue

			If tDocument.EntryUUID=tDocument.LogicalUUID {
				Do pErrors.logError("XDSInvalidRequestException","Error","Not an update request, EntryUUID and LogicalUUID match")
			}
			If tDocument.LogicalUUID="" {
				Do pErrors.logError("XDSInvalidRequestException","Error","Not an update request, LogicalUUID is not defined")
			}

		}
		/// All targets (from assocations) should be documents which we removed from array for each document we reviewed
		If $O(tAryTargets(""),1,tIID) {
			Do pErrors.logError("XDSObjectTypeError","Error","Object not expected "_tIID)
		}

		If pHome>1 {
			Do pErrors.logError("Error","Error","Multiple Home Community OIDs")
		} ElseIf pHome=1 && pMustBeOurHome {
			If $G(pHome("HomeCommunityOID"))'=$$$HomeCommunityOID {
				Do pErrors.logError("Error","Error","Not this community")
			}
		}

	} catch ex {
		Set tSC = ex.AsStatus()
		Do pErrors.logError("InternalError","Error",$system.Status.GetErrorText(tSC))
	}
	$$$OnPost(.pErrors,.pRequest,.pHome,.pMustBeOurHome) 
	Quit tSC
}

/// specific requirements for RMU requests - then call ValidateRegisterRequest called by RegistryOperations</Description>
Method RegistryValidateRMURequest(pErrors, pSubmission As HS.Types.IHE.Submission, pRequest As HS.Types.IHE.Submission, pValidatePatientId As %Boolean = 1) As %Status
{
	$$$OnPre(.tStop,.pErrors,.Submission,.pRequest,.pValidatePatientId) 
	If $G(tStop)||$$$ISERR(tSC) {
		Quit tSC
	}
	try {
		// A single Update Document Set transaction shall not contain multiple Update (DocumentEntry or Folder or Association) Status operations targeting the same logical object.
		// At any point in time there shall be at most one version of a logical DocumentEntry object with status Approved in the registry/recipient. If this version exists it shall always be the most recent version. 
		// At any point in time there shall be at most one version of a logical Folder object with status Approved in the registry/recipient. If this version exists it shall always be the most recent version.
		//#dim tConvertedRequest as HS.Message.IHE.XDSb.Metadata = ..info("ConvertedRequest")
		/// validate the home community id (this value is not stored in the registry so we need to look at the metadata object
		Set tSC = ..ValidateRMURequest(pErrors,pRequest,.tHome,1)
		If pErrors.Errors.Count() Quit
		For tIdx=1:1:pSubmission.Documents.Count() {
			#dim tDocument As HS.Registry.Document
			Set tDocument = pSubmission.Documents.GetAt(tIdx)
			Set tLogicalIID=tDocument.LogicalIID
			If tLogicalIID'?1"urn:uuid:"8AN1"-"4AN1"-"4AN1"-"4AN1"-"12AN Do pErrors.logError("XDSInvalidRequestException","Error","Document Logical Entry UUID format incorrect for document ["_tIdx_"]:"_tLogicalIID) continue
			If tLogicalIID=tDocument.IID Do pErrors.logError("XDSInvalidRequestException","Error","Document Logical Entry UUID cannot be equal Entry UUID:"_tLogicalIID) continue
			If $D(tAryHaveDoc(tLogicalIID)) Do pErrors.logError("XDSRegistryMetadataError","Error","Document Logical Entry UUID appears more than once in submission for:"_tLogicalIID) continue
			Set tAryHaveDoc(tLogicalIID)=tDocument.Version
			Set tSC = ##class(HS.Registry.Document).HighestVersionForLogicalIID(tLogicalIID,.tExistingDocumentObject)
			If $$$ISERR(tSC) {
				Do pErrors.logError("XDSRegistryMetadataError","Error","Failed to locate Document for Logical Entry UUID:"_tLogicalIID_" and version "_tDocument.Version)
				Quit
			}
			If tDocument.Version '= tExistingDocumentObject.Version {
				Do pErrors.logError("XDSMetadataVersionError","Error","Document provided with "_tDocument.Version_" but expecting "_tExistingDocumentObject.Version_" for ["_tIdx_"] "_tDocument.IID)
			}
			If tExistingDocumentObject.Status'="Approved" {
				Do pErrors.logError("UnresolvedReferenceException","Error","Existing document ["_tIdx_"] is not approved")
			}
			Do ..LocalValidateChanges(pErrors,..RMUPolicy ,tDocument,tExistingDocumentObject,"UnmodifiableMetadataError")
			Do ..LocalValidateChanges(pErrors,..LocalRMUPolicy ,tDocument,tExistingDocumentObject,"LocalPolicyRestrictionError")
		}
		
		For tIdx=1:1:pSubmission.Associations.Count() {
			Set tAssociation=pSubmission.Associations.GetAt(tIdx)
			If tAssociation.AssociationType="UpdateAvailabilityStatus" {
				Do pErrors.logError("UnmodifiableMetadataError","Error","Association at ["_tIdx_"] is attempting to update the AvailabilityStatus")
			}
		}
	} catch eException {
		Set tSC=eException.AsStatus()
		Do pErrors.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	$$$OnPost(.pErrors,.Submission,.pRequest,.pValidatePatientId)
	Quit tSC
}

/// specific requirements for RMU requests - then call ValidateRegisterRequest called by RegistryOperations
/// Method called in context of Registry.Operations with 
/// <var>pDocument</var> 
///  
Method LocalValidateChanges(pErrors, pPolicyList, pDocument, pExistingDocument, pDefaultError)
{
	$$$OnPre(.tStop,.pErrors,.pPolicyList,.pDocument,.pExistingDocument,.pDefaultError) 
	If $G(tStop)||$$$ISERR(tSC) {
		Quit tSC
	}
	try {
		For tPropertyIdx = 1:1:$L(pPolicyList,",") {
			Set tProperty = $p(pPolicyList,",",tPropertyIdx)
			Continue:tProperty=""
			/// tError could be customized in the string Size:MySpecificError,Hash
			Set tError = $p(tProperty,":",2),tProperty=$p(tProperty,":")
			If tProperty ]"" {
				Set:tError="" tError=pDefaultError
				Set tIs = $property(pDocument,tProperty)
				Set tWas = $property(pExistingDocument,tProperty)
				If $IsObject(tIs) || $IsObject(tWas) {
					If '$IsObject(tWas) {
						Set tWas = tIs.%New()
					} ElseIf '$IsObject(tIs) {
						Set tIs = tWas.%New()
					}
					Do tIs.XMLExportToString(.tIsString)
					Do tWas.XMLExportToString(.tWasString)
					If tIs.%IsA("HS.Types.IHE.XDSb.SerialClassification") {
						If tIs.Code	'= tWas.Code || (tIs.CodingScheme '= tWas.CodingScheme) {
							Do pErrors.logError(tError,"Error","Property "_tProperty_" improperly updated from "_tWasString_" to "_tIsString )
						}					
					} ElseIf tIs.%IsA("HS.Types.IHE.XDSb.SerialExternalIdentifier") {
						If tIs.Value '= tWas.Value  {
							Do pErrors.logError(tError,"Error","Property "_tProperty_" improperly updated from "_tWasString_" to "_tIsString )
						}					

					} Else {
						If tIsString'=tWasString {
							Do pErrors.logError(tError,"Error","Property "_tProperty_" improperly updated from "_tWasString_" to "_tIsString )
						}
					}
					
				} ElseIf tIs'=tWas {
					Do pErrors.logError(tError,"Error","Property "_tProperty_" improperly updated from "_tWas_" to "_tIs )
				}
			}
		}
	} catch eException {
		Set tSC=eException.AsStatus()
		Do pErrors.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	$$$OnPost(.pErrors,.pPolicyList,.pDocument,.pExistingDocument,.pDefaultError) 
	Quit $$$OK
}

}
