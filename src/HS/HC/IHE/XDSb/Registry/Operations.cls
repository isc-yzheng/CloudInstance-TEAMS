Include (HS.IHE.XDSb, HS.IHE.ATNA)

/// Used to forward registry messages from the BUS to the Registry via XDSbRegistryServiceName
Class HS.HC.IHE.XDSb.Registry.Operations Extends (HS.HC.Util.Trace.Helper, HS.Util.SOAPClient.Operations, HS.Util.BaseHost, HS.HC.IHE.RMU.Validate, HS.HC.IHE.XDSb.RMD) [ Inheritance = right, ProcedureBlock ]
{

Parameter HSDEPLOY = 1;

Parameter INVOCATION = "Queue";

Parameter DOMAIN = "HS";

Parameter SETTINGS = "CustomProcessor:Basic,IHEVersion,XDSbRegistryServiceName,-TargetName,ValidatePatientID,ValidateSourcePatientID,ValidateRepositoryOID,-IgnoreInvalidParameters,IgnoreInvalidClassifications,IgnoreMissingRequiredItems,XDSbQueryConsentTarget,MergeByMPIID,RegisterPostProcessor,Publisher,AffinityDomain,-CreateMPIOnDemand:OnDemand,-OnDemandRepository:OnDemand,-OnDemandRegistryServiceName:OnDemand,-ExtendedOnDemandCleanup:OnDemand,MaximumDocumentsToProcess,MetadataTransform,RegisterToDocumentTransform,RegistryAddResponseTransform,RegistryStoredQueryResponseTransform,RegisterResponseTransform,DocumentTransform,TransformQueryToXDSb,TransformToMetadata,TransformResponseCleanup,QueryMaxRowsLeafClass:Basic,QueryMaxRowsObjectRef:Basic,QueryMaxCountDateParam:Basic,QueryMaxCountBitmapParam:Basic,RMUPolicy:RMU,LocalRMUPolicy:RMU";

/// If forwarding the message on (from a bus, for example), the RegistryService entry for the XDSb Registry actor.  If this value is defined the message will not be
/// processed by this operation
Property XDSbRegistryServiceName As %String(MAXLEN = 512);

Property PDQConsumer As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.PDQv3.Consumer.Operations" ];

Property IHEVersion As %Integer [ InitialExpression = 1 ];

/// ***Deprecated*** Disable strict checking of query parameters (the XDS spec says to ignore unknown parameters)
Property IgnoreInvalidParameters As %Boolean [ InitialExpression = 1 ];

/// Disable strict checking of classification codes
Property IgnoreInvalidClassifications As %Boolean [ InitialExpression = 0 ];

/// Disable strict checking of required items
Property IgnoreMissingRequiredItems As %Boolean [ InitialExpression = 0 ];

/// Default defined by IHE is to merge by the MPIID and not the source MRN
Property MergeByMPIID As %Integer(DISPLAYLIST = ",By MRN,By MPIID, By XPID", VALUELIST = ",0,1,2") [ InitialExpression = 0 ];

/// HS.IHE.DSUB.NotificationBroker.Operations - if not an internal broker, build process to wrap transaction and send to service
Property Publisher As Ens.DataType.ConfigName;

Property Transformer As HS.Util.XSLTTransformer;

/// During testing it is sometimes necessary to turn off patient validation (Existence in the MPI)
Property ValidatePatientID As %Boolean [ InitialExpression = 1 ];

/// During testing it is sometimes necessary to turn off source patient validation 
/// Validates source patient ID exists and AssigningAuthority OID exists and formatted correctly
Property ValidateSourcePatientID As %Boolean [ InitialExpression = 1 ];

/// When true, lookup OID to ensure that the Repository OID is known
Property ValidateRepositoryOID As %Boolean;

/// ConfigName of the business host for consent evaluation for query responses.
/// By default, consent is not evaluated for query.
Property XDSbQueryConsentTarget As Ens.DataType.ConfigName;

/// Comma delmited list of business host names for additional processing after document registration.
Property RegisterPostProcessor As %String(MAXLEN = 512);

Property Errors As HS.Types.IHE.Errors;

Property QueryReturnType As %String;

/// Defaults to \IHE\AffinityDomain [##class(HS.IHE.Util).GetAffinityDomain()]
/// if "" any patient will be accepted (versus turning off patient id validation) the AA in the request is sent to the 
Property AffinityDomain As %String [ InitialExpression = {##class(HS.IHE.Util).GetAffinityDomain()} ];

Property OutputSet As HS.Types.IHE.Submission;

/// used to store collected information cleared out at the start of every request
Property info As %String [ MultiDimensional ];

/// used to store id to guid substitution cleared out at the start of every request
Property substitutionAry As %String [ MultiDimensional ];

/// various settings defined at startup
Property settings As %String [ MultiDimensional ];

/// Cache the content type code / scheme 
Property XPIDContentCode As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\IHE\Registry\XPID\ContentCode\Code")_"||||"_##class(HS.Registry.Config).GetKeyValue("\IHE\Registry\XPID\ContentCode\Scheme")_"||||"_##class(HS.Registry.Config).GetKeyValue("\IHE\Registry\XPID\ContentCode\Description")} ];

/// internal value for patient id's to lock for parallel processing
Property lockedEntries As %String(MAXLEN = "");

Property MetadataTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

Property RegisterToDocumentTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RegisterToDocument.xsl" ];

Property RegistryAddResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RegistryAddResponse.xsl" ];

Property RegistryStoredQueryResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RegistryStoredQueryResponse.xsl" ];

Property RegisterResponseTransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/RegisterResponse.xsl" ];

Property DocumentTransform As %String(MAXLEN = 250) [ InitialExpression = "/IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl" ];

/// A store error will be thrown at some point, the content is available in the response, just not parsed.
Property MaximumDocumentsToProcess As %Integer [ InitialExpression = 100 ];

Property TransformQueryToXDSb As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/QueryRequestToXDSbQuery.xsl" ];

Property TransformToMetadata As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/Message-to-Metadata.xsl" ];

Property TransformResponseCleanup As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/QueryResponseCleanup.xsl" ];

/// Default of 100 for performance
Property QueryMaxRowsLeafClass As %Integer [ InitialExpression = 100 ];

/// Maximum value around 70,000 due to a maxstring on the list of IDS used
Property QueryMaxRowsObjectRef As %Integer(MAXVAL = 70000) [ InitialExpression = 10000 ];

/// For Multi-Patient queries (typically), when querying results in a date range, the maximum number of results before the query returns an error requesting to refine.  By increasing the number too high it increases the probability that the system won't respond in the timeout period.
Property QueryMaxCountDateParam As %Integer [ InitialExpression = 10000 ];

/// For Multi-Patient queries (typically), when querying results with bitmapped parameters, the maximum number of results before the query starts using the dates (when available) as the primary search.  By increasing the number too high it increases the probability that the system won't respond in the timeout period.
Property QueryMaxCountBitmapParam As %Integer [ InitialExpression = 10000 ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.IDUpdateNotificationRequest"> 
		<Method>MergeNotification</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.IHE.XDSb.QueryRequest"> 
		<Method>XDSbQueryRequest</Method>
	</MapItem>
</MapItems>
}

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eOnMessage As %Exception.AbstractException
	Set tSC = $$$OK
	
	Try {
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Kill ..info,..substitutionAry
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		If ..lockedEntries]"" Do ..lockEntries()  // release all locks

		Set isAsync = (pRequest.AdditionalInfo.GetAt("ReplyAddress")]"")
		#; if the XDSbRegistryServiceName is defined forward the request there, if it is asynchronous though, send it synchronous and reply from here
		If ..XDSbRegistryServiceName]"" {
			Set ..TargetName=..XDSbRegistryServiceName
			Set tAction=pRequest.AdditionalInfo.GetAt("SOAPAction")
			If isAsync {
				Set tReplyTo = pRequest.AdditionalInfo.GetAt("ReplyAddress")
				Do pRequest.AdditionalInfo.SetAt("","ReplyAddress")
			}
			Set tSC = ..InvokeWebService(,, tAction, pRequest, .pResponse) $$$HSThrowErrors(tSC)
			If isAsync {
				Do pResponse.AdditionalInfo.SetAt(tReplyTo,"ReplyAddress")
			}
			Quit
		}

		Set ..info("RequestName")=pRequest.Name
		If (pRequest.Name = $$$XDSbDeleteDocumentSetRequest) || (pRequest.%IsA("HS.Message.IHE.XDSb.DeleteDocumentSetRequest")) {
			/// ExecuteDeleteDocumentSet in HS.HC.IHE.XDSb.RMD
			Set tSC=..ExecuteDeleteDocumentSet(pRequest,.pResponse)
		} Else {
			$$$HSTRACESTARTCALL
			Set tSC = ..Transformer.TransformIntoObject(pRequest.ContentStream,..MetadataTransform /*"IHE/XDSb/Version1/Message-to-MetadataObject.xsl"*/,.tRequest,,"HS.Message.IHE.XDSb.Metadata","Metadata")
			Set ..info("ConvertedRequestSC")=tSC
			$$$HSTRACEENDCALL
			Set:'$IsObject($g(tRequest)) tRequest=##class(HS.Message.IHE.XDSb.Metadata).%New()
			Set tRequest.Name=pRequest.Name
			Do tRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("SOAPAction"),"SOAPAction")
			Do tRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("USER:Roles"),"USER:Roles")
			Do tRequest.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("USER:UserID"),"USER:UserID")
			Set ..info("ConvertedRequest")=tRequest

			#; process the request
			If (pRequest.Name = $$$XDSbRegisterRequest || (pRequest.Name=$$$XDSbUpdateDocumentSetRequest) || (pRequest.Name=$$$RMUDocumentSetRequest)) {
				Set tSC=..RegisterRequest(pRequest,.pResponse) 
				If pRequest.AdditionalInfo.GetAt("AuditRegistration")'=0 { //must be explicitly set to exclude
					Do $$$ATNAEvent("XDSbRegistry",pRequest,pResponse,tSC)
					
				}
				$$$ThrowOnError(tSC)
				Set tAction = $S(pRequest.Name=$$$XDSbRegisterRequest:$$$XDSbRegisterResponseAction(1),pRequest.Name=$$$RMUDocumentSetRequest:$$$RMUDocumentSetResponseAction(1),1:$$$XDSbUpdateDocumentSetResponseAction(1))
				#; for Async requests take response and run through again to send to target end point
				If isAsync {
					Do pResponse.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("RelatesTo"),"RelatesTo")
					Set tSC = ..InvokeWebService(,pRequest.AdditionalInfo.GetAt("ReplyAddress"),tAction,pResponse,.tResponse,1) $$$ThrowOnError(tSC)
				}
				#; Send pRequest to the DSUB Publisher only if one is specified
				#; and there was no error returned from the register request.
				If ..Publisher]""  {
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(pResponse.ContentStream,"/rs:RegistryResponse/rs:RegistryErrorList/rs:RegistryError[1]","@codeContext",.tValue)
					If $Get(tValue)="" {
						If $IsObject($g(..info("ConvertedRequest"))) Set tSC = ..SendRequestAsync(..Publisher,..info("ConvertedRequest"))
					}
				}
			} ElseIf (pRequest.Name = $$$XDSbQueryRequest || (pRequest.Name = $$$XDSbQueryMultiPatientRequest)) {
				Set tSC=..QueryRequest(pRequest,.pResponse)

				//%HS_NotifyAndQueryOperations is only used for an internal message - don't audit
				Do:pRequest.SAMLData.HSRoles'="%HS_NotifyAndQueryOperations" $$$ATNAEvent("XDSbRegistry",pRequest,pResponse,tSC)
				$$$ThrowOnError(tSC)
				#; for Async requests take response and run through again to send to target end point
				If isAsync {
					Do pResponse.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("RelatesTo"),"RelatesTo")
					Set tSC = ..InvokeWebService(,pRequest.AdditionalInfo.GetAt("ReplyAddress"),$$$XDSbQueryResponseAction(..IHEVersion),pResponse,.tResponse,1) $$$ThrowOnError(tSC)
				}
			} ElseIf (pRequest.Name = $$$XDSbRegisterOnDemandRequest) {
				Set tSC=..RegisterRequest(pRequest,.pResponse)
				If pRequest.AdditionalInfo.GetAt("AuditRegistration")'=0 { //must be explicitly set
					Do $$$ATNAEvent("XDSbRegistry",pRequest,pResponse,tSC)
				}
				$$$ThrowOnError(tSC)
				#; for Async requests take response and run through again to send to target end point
				If isAsync {
					Do pResponse.AdditionalInfo.SetAt(pRequest.AdditionalInfo.GetAt("RelatesTo"),"RelatesTo")
					Set tSC = ..InvokeWebService(,pRequest.AdditionalInfo.GetAt("ReplyAddress"),$$$XDSbRegisterOnDemandResponseAction(..IHEVersion),pResponse,.tResponse,1) $$$ThrowOnError(tSC)
				}	
			}
			#; for Query / RegisterResponse it is a async response just send to the target 
			ElseIf pRequest.Name=$$$XDSbRegisterResponse || (pRequest.Name=$$$XDSbQueryResponse) || (pRequest.Name=$$$XDSbRegisterOnDemandResponse) {
				Set tAction = $Case(pRequest.Name
					,$$$XDSbQueryResponse:$$$XDSbQueryResponseAction(..IHEVersion)
					,$$$XDSbRegisterResponse:$$$XDSbRegisterResponseAction(..IHEVersion)
					,$$$XDSbRegisterOnDemandResponse:$$$XDSbRegisterOnDemandResponseAction(..IHEVersion)
					,:"")
				Set tSC	=..InvokeWebService(,pRequest.AdditionalInfo.GetAt("ReplyAddress"), tAction, pRequest, .tResponse,1)
			} Else {
				$$$LOGERROR("Unknown request "_pRequest.Name)
			}
		}
	}
	Catch eOnMessage {
		Set pResponse = $$$NULLOREF	
		Set tSC = eOnMessage.AsStatus()
	}
	If ..lockedEntries]"" Do ..lockEntries()  // release all locks
	Kill %SAX  // remove any SAX parser errors related to prodlog #126331
	Quit tSC
}

/// Internal method used to lock any id's being updated so that multiple operations can run concurrently
/// release any locks held, build a list of new entries into ..lockedEntries and issue lock
Method lockEntries(pType = "N", pIDs...) As %Status [ Internal ]
{
	#define B64(%id) $system.Encryption.Base64Encode(%id)
	#; don't add the same entry again
	If pType="A" && (..lockedEntries[($c(34)_$$$B64($g(pIDs(1)))_$c(34))) Quit $$$OK
	If ..lockedEntries]"" X ("Lock -("_..lockedEntries_")")
	If pType="A" {
		Set tLocks=..lockedEntries
		Set:tLocks]"" tLocks=","_tLocks
	} Else {
		Set tLocks=""  Set ..lockedEntries=""
	}
	For tIdx=1:1:$g(pIDs) {
		Set tID=$$$B64($G(pIDs(tIdx))) continue:tID=""
		Set tLocks = tLocks_",^HS.Registry.Document.Patient("""_tID_""")"
	}
	If tLocks]"" Set ..lockedEntries=$e(tLocks,2,*) X ("Lock +("_..lockedEntries_")")
	Quit $$$OK
}

/// Update Document.PatientID and ID in ExternalIdentifiers for Document/SubmissionSet/Folders
/// this could be called by receiving a ADT^A43 or by setting the MergeMPIID to By XPID (2) setting
Method MergeByXPID(pRequest As HS.Message.IDUpdateNotificationRequest, pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	try {
		Set tSC=$$$OK
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set pResponse=##class(HS.Message.AddUpdateHubResponse).%New()
		Set tContentCode = ..XPIDContentCode
		Set:$TR(tContentCode,"|")="" tContentCode = ##class(HS.Registry.Config).GetKeyValue("\IHE\Registry\XPID\ContentCode\Code")_"||||"_##class(HS.Registry.Config).GetKeyValue("\IHE\Registry\XPID\ContentCode\Scheme")_"||||"_##class(HS.Registry.Config).GetKeyValue("\IHE\Registry\XPID\ContentCode\Description")
		If $P(tContentCode,"||||")="" || ($P(tContentCode,"||||",2)="") Set tSC = $$$ERROR($$$GeneralError,"No XPID content code or coding scheme is specified in \IHE\Registry\XPID\ContentCode") Quit
		Set ..XPIDContentCode = tContentCode
		Set tSourceOID = pRequest.AdditionalInfo.GetAt("SourceOID") 
		Set:tSourceOID="" tSourceOID=$$$AffinityDomainOID

		#; locate documents with source patient id where the patient id is not the new MPIID
		#; (unless it's a local ID update from true XPID, then look for patient ID equal to the old MPIID)
		#; query for each documentuuid and then issue metadata updates for each	
		#; for true XPID there will only be one source patient identifier, for internal requests all identifiers (moving) are sent
		Do ..lockEntries("N",pRequest.MPIID,pRequest.PriorMPIID)
		Set tNewPatientID = pRequest.MPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
		Set tPriorPatientID = pRequest.PriorMPIID_"^^^&"_$$$AffinityDomainOID_"&ISO"
		Set tMetadataRequest=##class(HS.Types.IHE.Submission).%New()
		Set tSubmission=##class(HS.Registry.Document.RegistryPackage).%New()
		Set tSubmission.Type="SS"
		Set tSubmission.PatientIdentifier.Value=tNewPatientID
		Set tSubmission.PatientIdentifier.IID="SSPatientIdentifer"
		Set tSubmission.ContentTypeCode=##class(HS.Types.IHE.XDSb.SerialClassification).%New($P(tContentCode,"||||"),$P(tContentCode,"||||",2),$P(tContentCode,"||||",3))
		Set tSubmission.ContentTypeCode.IID="ContentType"
		Set tSubmission.SubmissionTime = $tr($zdt($ztimestamp,8),": ")  ;utc?
		Set tSubmission.SourceIdentifier.Value=tSourceOID
		Set tSubmission.SourceIdentifier.IID="SSSourceIdentifier"
		Set tSubmission.UniqueIdentifier.Value=##class(HS.Util.XSLTHelper).uuid2oid($ZCVT($SYSTEM.Util.CreateGUID(),"L"))
		Set tSubmission.UniqueIdentifier.IID="SSUniqueIdentifier"
		Set tSubmission.IID="SS"
		Do tMetadataRequest.RegistryPackages.Insert(tSubmission)
		For tIdx = 1:1:pRequest.Identifiers.Count() {
			Set tIdentifier = pRequest.Identifiers.GetAt(tIdx)
			If pRequest.AdditionalInfo.GetAt("XPID")&&pRequest.PriorIdentifiers.Count(){//true XPID only, updating a local identifier
				Set tPriorIdentifier = pRequest.PriorIdentifiers.GetAt(1)
				Set tSourcePatient = tPriorIdentifier.Extension_"^^^&"_##class(HS.Data.OIDMap).OIDForType(tPriorIdentifier.Root)_"&ISO"
				Set tNewSourcePatient = tIdentifier.Extension_"^^^&"_##class(HS.Data.OIDMap).OIDForType(tIdentifier.Root)_"&ISO"
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select ID,IID from HS_Registry.Document where SourcePatientID=? and Status='Approved' and PatientIdentifier_Value=? Group by LogicalIID order by Version Desc",tSourcePatient,tPriorPatientID)
			}
			Else{
				Set tSourcePatient = tIdentifier.Extension_"^^^&"_##class(HS.Data.OIDMap).OIDForType(tIdentifier.Root)_"&ISO"
				Set tNewSourcePatient = tSourcePatient
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select ID,IID from HS_Registry.Document where SourcePatientID=? and Status='Approved' and PatientIdentifier_Value<>? Group by LogicalIID order by Version Desc",tSourcePatient,tNewPatientID)
			}
			If tRS.SQLCODE Set tSC =$$$ERROR($$$GeneralError,"Error updating patient ID SQLERROR:"_tRS.SQLCODE) Quit
			
			While tRS.%Next() {
				#; verify that there are no other patients in the folder
				#; for a local identifier update, the folder could include either the old or the new sourcePatientId
				Set tSC = ..ManageXPIDAssociations(tRS.%Get("IID"),tSourcePatient,.tMetadataRequest,tNewSourcePatient)
				Quit:$$$ISERR(tSC)
				#; locate the document, clone and update the patient identifer
				Set tDocumentID=tRS.%Get("ID")
				Set tDocument = ##class(HS.Registry.Document).%OpenId(tDocumentID)
				#dim tUpdate as HS.Registry.Document = tDocument.%ConstructClone(1)
				Set tUpdate.IID="x"_$p(tUpdate.IID,"urn:uuid:",2)  //"Document"_tRS.%Get("ID")  ; needs a different IID 
				Set tUpdate.PatientID=tNewPatientID
				Set tUpdate.PatientIdentifier.Value=tNewPatientID
				Set tUpdate.PatientIdentifier.IID="x"_$p(tUpdate.PatientIdentifier.IID,"urn:uuid:",2) //"PatientDocument"_tRS.%Get("ID")
				If pRequest.AdditionalInfo.GetAt("XPID")&&pRequest.PriorIdentifiers.Count(){//true XPID only, updating a local identifier
					Set tUpdate.SourcePatientID=tNewSourcePatient
				}
				For tProperty = "DocumentUniqueIdentifier","ClassCode","FormatCode","HealthCareFacilityTypeCode","PatientIdentifier","PracticeSettingCode","SourceIdentifier","TypeCode" {
					Set $property(tUpdate,tProperty)="urn:uuid:"_$zcvt($System.Util.CreateGUID(),"l")
				}
				For tIdx=1:1: tUpdate.Classifications.Count() {
					Set tUpdate.Classifications.GetAt(tIdx).IID="urn:uuid:"_$zcvt($System.Util.CreateGUID(),"l")
				}
				For tIdx=1:1: tUpdate.ExternalIdentifiers.Count() {
					Set tUpdate.ExternalIdentifiers.GetAt(tIdx).IID="urn:uuid:"_$zcvt($System.Util.CreateGUID(),"l")
					Set tUpdate.ExternalIdentifiers.GetAt(tIdx).RegistryObject=tUpdate.IID
				}
				Do tMetadataRequest.Documents.Insert(tUpdate)
				Set tAssociation = ##class(HS.Registry.Document.Association).%New()
				Set tAssociation.AssociationType="HasMember"
				Set tAssociation.SourceObject=tSubmission.IID
				Set tAssociation.TargetObject=tUpdate.IID
				Set tAssociation.IID="AssociationForDoc"_tRS.%Get("ID")
				Do tMetadataRequest.Associations.Insert(tAssociation)
			}
			
		}
		#; continue if none are found
		Quit:'tMetadataRequest.Documents.Count()
		$$$HSTRACE("update request","tMetadataRequest",tMetadataRequest)
		Set tSC = ..ValidateUpdateRequest(tMetadataRequest,$$$XDSbUpdateDocumentSetRequest,1)
		If ..OutputSet.Errors.Count() {
			$$$HSTRACE("Errors","Errors",..OutputSet.Errors)
			Do ..OutputSet.XMLExportToString(.tErrors)
			$$$LOGERROR(tErrors)
		}
		If $$$ISERR(tSC) || ..OutputSet.Errors.Count() Quit
		/// maybe???? TODO
		Set ..info("RequestName")=$$$XDSbUpdateDocumentSetRequest
		Set tSC = ..registerProcess(tMetadataRequest)
		
		Quit:$$$ISERR(tSC)

		
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Set pResponse.ErrStatus=tSC
	If $$$ISERR(tSC) {
		$$$LOGSTATUS(tSC)
		Set pResponse.ErrStatus=tSC
	} ElseIf ..OutputSet.Errors.Count() {
		Set tErrors = ..OutputSet.getErrorText()
		Set pResponse.ErrStatus=$$$ERROR($$$GeneralError,tErrors)
	}
	
	Quit tSC
}

/// Document belongs to a folder which contains other documents of the same or different source patient id's (different fails)
/// Document linked to another document which is the same or different source patient id (different fails)
/// The source patient ID could be changing, so check against both the new and old source patient ID (matching either one is OK)
/// Document in Submission set as a Reference - Create association to document
Method ManageXPIDAssociations(pDocumentIID As %String, pSourcePatientID As %String, ByRef pMetadataRequest As HS.Types.IHE.Submission, pNewSourcePatientID As %String) As %Status
{
	Set tSC=$$$OK
	try {
		Set tNewDocumentIID="x"_$p(pDocumentIID,"urn:uuid:",2)
		If ('$D(pNewSourcePatientID) || (pNewSourcePatientID="")){
			Set pNewSourcePatientID = pSourcePatientID
		}
		
		#; update folders and submission sets(reference)
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select A.ID,RP.ID as RPID from HS_Registry_Document.Association A,HS_Registry_Document.RegistryPackage RP where A.TargetObject=? and A.Status='Approved' and RP.IID=A.SourceObject ",pDocumentIID)
		If tRS.SQLCODE Set tSC =$$$ERROR($$$GeneralError,"Error with query for folders and submissions SQLERROR:"_tRS.SQLCODE) Quit
		While tRS.%Next() {
			Set tRPID=tRS.%Get("RPID")
			Set tRP = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tRPID)
			If tRP.Type="SS" {
				For tIdx=1:1:tRP.Slots.Count() {
					Set tSlot=tRP.Slots.GetAt(tIdx)
					if tSlot.Name = "SubmissionSetStatus" && (tSlot.ValueList.GetAt(1).Value="Reference") {
						#; for Reference Submission Sets, create a new association
						Set tAssociation = ##class(HS.Registry.Document.Association).%New()
						Set tAssociation.AssociationType="HasMember"
						Set tAssociation.SourceObject=tRP.IID
						Set tAssociation.TargetObject=tNewDocumentIID
						Set tAssociation.IID="AssociationForSS"_tNewDocumentIID
						Set tAssociation.Status="Approved"
						Do pMetadataRequest.Associations.Insert(tAssociation)
						Quit
					}
				}
			} Else {
				#; for folders look for other documents in the folder where the sourcepatient id is not the same
				Set tRSFolders = ##class(%SQL.Statement).%ExecDirect(,"Select DOC.SourcePatientID as SourcePatientID from HS_Registry_Document.Association A,HS_Registry.Document DOC where A.SourceObject=? and A.TargetObject=DOC.IID and A.Status='Approved' and DOC.SourcePatientID<>? and DOC.SourcePatientID<>?",tRPID,pSourcePatientID,pNewSourcePatientID)
				If tRSFolders.SQLCODE Set tSC =$$$ERROR($$$GeneralError,"Error with query for folder documents SQLERROR:"_tRS.SQLCODE) Quit
				If tRSFolders.%Next() {
					Set tSC = $$$ERROR($$$GeneralError,"Folder contains multiple source patient identifiers "_tRSFolders.%Get("SourcePatientID"))
					Quit
				}
				Set tAssociation = ##class(HS.Registry.Document.Association).%New()
				Set tAssociation.AssociationType="HasMember"
				Set tAssociation.SourceObject=tRP.IID
				Set tAssociation.TargetObject=tNewDocumentIID
				Set tAssociation.IID="AssociationForFolder"_tNewDocumentIID
				Set tAssociation.Status="Approved"
				Do pMetadataRequest.Associations.Insert(tAssociation)
			}
		}
		
			
		#; update document to document references (ChangingDocument=SourceObject)
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select A.AssociationType,DOC.SourcePatientID SourcePatientID,A.TargetObject from HS_Registry_Document.Association A,HS_Registry.Document DOC where A.SourceObject=? and A.Status='Approved' and Doc.IID=A.TargetObject",pDocumentIID)
		If tRS.SQLCODE Set tSC =$$$ERROR($$$GeneralError,"Error with query for document to document references SQLERROR:"_tRS.SQLCODE) Quit
		If tRS.%Next() {
			If (tRS.%Get("SourcePatientID")'=pSourcePatientID)&&(tRS.%Get("SourcePatientID")'=pNewSourcePatientID) {
				Set tSC = $$$ERROR($$$GeneralError,"Document source patient identifiers don't match "_tRS.%Get("SourcePatientID"))
				Quit
			}
			Set tAssociation = ##class(HS.Registry.Document.Association).%New()
			Set tAssociation.AssociationType=tRS.%Get("AssociationType")
			Set tAssociation.SourceObject=tNewDocumentIID
			Set tAssociation.TargetObject=tRS.%Get("TargetObject")
			Set tAssociation.IID="AssociationForDocToDoc"_tRS.%Get("TargetObject")
			Set tAssociation.Status="Approved"
			Do pMetadataRequest.Associations.Insert(tAssociation)
		}
		#; update document to document references (ChangingDocument=TargetObject)
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select A.AssociationType,DOC.SourcePatientID SourcePatientID,A.SourceObject from HS_Registry_Document.Association A,HS_Registry.Document DOC where A.TargetObject=? and A.Status='Approved' and Doc.IID=A.SourceObject",pDocumentIID)
		If tRS.SQLCODE Set tSC =$$$ERROR($$$GeneralError,"Error with query for document to document references SQLERROR:"_tRS.SQLCODE) Quit
		If tRS.%Next() {
			If (tRS.%Get("SourcePatientID")'=pSourcePatientID)&&(tRS.%Get("SourcePatientID")'=pNewSourcePatientID) {
				Set tSC = $$$ERROR($$$GeneralError,"Document source patient identifiers don't match "_tRS.%Get("SourcePatientID"))
				Quit
			}
			Set tAssociation = ##class(HS.Registry.Document.Association).%New()
			Set tAssociation.AssociationType=tRS.%Get("AssociationType")
			Set tAssociation.SourceObject=tRS.%Get("SourceObject")
			Set tAssociation.TargetObject=tNewDocumentIID
			Set tAssociation.IID="AssociationForDocToDoc"_tRS.%Get("SourceObject")
			Set tAssociation.Status="Approved"
			Do pMetadataRequest.Associations.Insert(tAssociation)
		}

	} catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
	Quit tSC
}

/// Update Document.PatientID and ID in ExternalIdentifiers for Document/SubmissionSet/Folders
Method MergeNotification(pRequest As HS.Message.IDUpdateNotificationRequest, pResponse As HS.Message.AddUpdateHubResponse) As %Status
{
	#define GetStatement(%stmt,%sql) Set %stmt=##class(%SQL.Statement).%New() Set tSC = %stmt.%Prepare(%sql) Quit:$$$ISERR(tSC)

	try {
		Set tSC=$$$OK
		Set ..Errors = ##class(HS.Types.IHE.Errors).%New()
		Set pResponse=##class(HS.Message.AddUpdateHubResponse).%New()
		Set pResponse.MPIID=pRequest.MPIID
		Set pResponse.ErrStatus=tSC

		#; Merge by XPID (using metadata update)
		If ..MergeByMPIID=2 {
			#; since XPID only handles one ID at a time, split them up 
			For tIdx=1:1:pRequest.Identifiers.Count() {
				Set tNewRequest = pRequest.%ConstructClone(1)
				Do tNewRequest.Identifiers.Clear()
				Do tNewRequest.Identifiers.Insert(pRequest.Identifiers.GetAt(tIdx))
				Set tSC=..MergeByXPID(tNewRequest,.pResponse) Quit:$$$ISERR(tSC)
			}
			Quit
		}
		Set tAffinityDomain=$$$AffinityDomainOID
		Set tNew = pRequest.MPIID_"^^^&"_tAffinityDomain_"&ISO"
		Set tPrior = pRequest.PriorMPIID_"^^^&"_tAffinityDomain_"&ISO"
		#; nothing to do
		If tNew=tPrior Quit
		Do ..lockEntries("N",pRequest.MPIID,pRequest.PriorMPIID)
		If ..MergeByMPIID {
			try {
				$$$HSTRACE("Executing registry merge ","tNew,tPrior",tNew,tPrior)
				TSTART
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select ID from HS_Registry.Document where IID in (select distinct(registryobject) from HS_Registry_Document.ExternalIdentifier where IdentificationValue=? and IdentificationScheme in ('urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446','urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427','urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a') )",tPrior)
				If tRS.SQLCODE Set tSC =$$$ERROR($$$GeneralError,"SQLERROR:"_tRS.SQLCODE) Quit
				While tRS.%Next() {
					Set tID=tRS.%Get("ID")
					&sql(Update HS_Registry.Document Set PatientID = :tNew where ID=:tID)
					If SQLCODE '= 0 && (SQLCODE'=100) Set tSC=$$$ERROR($$$GeneralError,"Unable to process merge") Quit
				}
				Quit:$$$ISERR(tSC)
			
				#; for SubmissionSetScheme, DocumentScheme
				&sql(update HS_Registry_Document.ExternalIdentifier Set IdentificationValue = :tNew where IdentificationValue=:tPrior and IdentificationScheme in ('urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446','urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427','urn:uuid:f64ffdf0-4b97-4e06-b79f-a52b38ec2f8a'))
				If SQLCODE '= 0 && (SQLCODE'=100) Set tSC=$$$ERROR($$$GeneralError,"Unable to process merge") Quit
				#; support for old PatientID field - deprecated - does not get updated by above query because the entry is not in external identifier
				&sql(update HS_Registry.document set PatientIdentifier_Value=:tNew,PatientID=:tNew where PatientIdentifier_Value=:tPrior)
				If SQLCODE '= 0 && (SQLCODE'=100) Set tSC=$$$ERROR($$$GeneralError,"Unable to process merge") Quit
				&sql(update HS_Registry_document.RegistryPackage set PatientIdentifier_Value=:tNew where PatientIdentifier_Value=:tPrior)
				If SQLCODE '= 0 && (SQLCODE'=100) Set tSC=$$$ERROR($$$GeneralError,"Unable to process merge - RegistryPackage") Quit
			} Catch ex {
				Set tSC=ex.AsStatus()
			}
			IF $$$ISERR(tSC) {
				TROLLBACK
			} Else {TCOMMIT}
			$$$HSTRACE("registry merge "_$S(tSC:"Successful",1:"Unsuccessful"),"tSC",tSC)
			Quit
		} Else {
			/*  Providing merge capability, moving specified MRN's documents from patient ID to another
				**** this process fails if more than one MRN exists in a submission set or folder and not all are moved in one transaction ****
			
				For each document where the source patient ID matches 
						(associations target = document source will give submission set)
					find the submission set and ensure any other documents match the same source patient id
					find any folders and ensure any other documents match the same source patient id

			*/
			#; validate there is only the specified MRN's (generally one) in the submission set / folders
			#; but if there is more than one and they all move together then we can update the patientid
			Set tMRNString = ""
			Set txParam = 0
			For tIdx = 1:1:pRequest.Identifiers.Count() {
				Set tIdent = pRequest.Identifiers.GetAt(tIdx)
				Set tAA = ##class(HS.Data.OIDMap).OIDForType(tIdent.Root)
				Set tMRN = tIdent.Extension_"^^^&"_tAA_"&ISO"
				Set txParam($i(txParam))=tMRN
				Set:tMRNString]"" tMRNString=tMRNString_","
				Set tMRNString=tMRNString_"?"
			}
			If (tMRNString=""){
				Set tSC = $$$ERROR($$$GeneralError,"At least one identifier must be present in the request")
				Quit
			}
			#; Verify one MRN at a time. If we find a submission set
			#; that has an MRN other than the MRN(s) that are to be
			#; merged then quit and return a failure status.
			#; While looping through the documents for each MRN,
			#; gather the document IDs and IIDs into an array, so we
			#; can use them to increase the efficiency of the UPDATE
			#; queries.
			$$$GetStatement(tStmt1,"SELECT Slot->Document,Slot->Document->IID FROM HS_Registry_Document.Slot_ValueList WHERE ValueList = ? AND Slot->Name='sourcePatientId' and Slot->Document->IID IN (SELECT RegistryObject FROM HS_Registry_Document.ExternalIdentifier WHERE IdentificationValue = ?) UNION (select ID,IID from HS_Registry.Document where sourcepatientid=? and PatientIdentifier_Value=?)")

			Set tSQL = "SELECT slot->document->ID FROM HS_Registry_Document.Slot_ValueList WHERE Slot->Name='sourcePatientId' AND ValueList NOT IN ("_tMRNString_") AND Slot->Document->IID IN (" _
					"SELECT TargetObject FROM HS_Registry_Document.Association WHERE TargetObject <> ? AND SourceObject IN (" _
					"SELECT SourceObject FROM HS_Registry_Document.Association WHERE TargetObject = ?))"_
					" UNION select ID from HS_Registry.Document where sourcepatientid not in ("_tMRNString_") and IID in (" _
					"SELECT TargetObject FROM HS_Registry_Document.Association WHERE TargetObject <> ? AND SourceObject IN (" _
					"SELECT SourceObject FROM HS_Registry_Document.Association WHERE TargetObject = ?))"
					
			$$$GetStatement(tStmt2,tSQL)

			For tIdx = 1:1:txParam {
				Set tMRN = txParam(tIdx)
				Set tRS1 = tStmt1.%Execute(tMRN,tPrior,tMRN,tPrior)
				If tRS1.SQLCODE'=0 Set tSC = $$$ERROR($$$GeneralError, "Unable to process merge, SELECT Document,IID FROM HS_Registry_Document.Slot_ValueList failed - SQLCODE="_tRS1.SQLCODE_" - "_tRS1.%Message) Quit
				While tRS1.%Next() {
					Kill tParam
					Merge tParam = txParam
					Set tParam($i(tParam))=tRS1.IID
					Set tParam($i(tParam))=tRS1.IID
					#; copy list for union statement
					Set tTop=tParam
					For tIdx2=1:1:tTop Set tParam($i(tParam))=tParam(tIdx)
					Set tAryDocs(tRS1.Document)=tRS1.IID
					Set tRS2 = tStmt2.%Execute(tParam...)
					If tRS2.SQLCODE'=0 Set tSC = $$$ERROR($$$GeneralError, "Unable to process merge, SELECT * FROM HS_Registry_Document.Slot_ValueList failed - SQLCODE="_tRS2.SQLCODE_" - "_tRS2.%Message) Quit
					If tRS2.%Next() Set tSC=$$$ERROR($$$GeneralError,"Unable to process merge, registry package has MRN's related which are not in merge request") Quit
				}
				If '$$$ISOK(tSC) Quit
			}
			If '$$$ISOK(tSC) Quit


			Set tSQL ="UPDATE HS_Registry.Document SET PatientID = ?,PatientIdentifier_Value=? WHERE ID = ?"
			$$$GetStatement(tStmt3,tSQL)

			Set tSQL = "UPDATE HS_Registry_Document.ExternalIdentifier SET IdentificationValue = ? WHERE IdentificationValue = ? AND IdentificationScheme ='urn:uuid:58a6f841-87b3-4a3e-92fd-a8ffeff98427' AND RegistryObject = ?"
			$$$GetStatement(tStmt4,tSQL)
	
			Set tSQL = "UPDATE HS_Registry_Document.ExternalIdentifier SET IdentificationValue = ? WHERE IdentificationValue = ? AND RegistryObject IN (SELECT SourceObject FROM HS_Registry_Document.Association WHERE TargetObject = ?)"
			$$$GetStatement(tStmt5,tSQL)

			Set tSQL = "SELECT SourceObject from HS_Registry_Document.Association where TargetObject=?"
			$$$GetStatement(tStmt6,tSQL)

			Set tSQL = "UPDATE HS_Registry_Document.RegistryPackage Set PatientIdentifier_Value=? WHERE IID =?"
			$$$GetStatement(tStmt7,tSQL)

			Try {
				Set tID=""
				For  {
					Set tID=$O(tAryDocs(tID),1,tIID)
					Quit:tID=""
					$$$HSTRACE("Update doc ","tNew,tID,tIID",tNew,tID,tIID)
					TSTART
		
					Set tRS3=tStmt3.%Execute(tNew,tNew,tID)
					If tRS3.SQLCODE'=0 Set tSC = $$$ERROR($$$GeneralError, "UPDATE HS_Registry.Document failed - SQLCODE="_tRS3.SQLCODE_" - "_tRS3.%Message) Quit

					#; We might get SQLCODE=100 if re-trying a failed merge.
					#; Just consider SQLCODE=100 to be okay.
					Set tRS4=tStmt4.%Execute(tNew,tPrior,tIID)
					If tRS4.SQLCODE'=0,tRS4.SQLCODE'=100 Set tSC = $$$ERROR($$$GeneralError, "UPDATE HS_Registry_Document.ExternalIdentifier 1 failed - SQLCODE="_tRS4.SQLCODE_" - "_tRS4.%Message) Quit

					#; This query might try to update an ExternalIdentifier that was
					#; already updated as part of updating an earlier doc in tAryDocs.
					#; In that case, just consider SQLCODE=100 to be okay.
					Set tRS5=tStmt5.%Execute(tNew,tPrior,tIID)
					If tRS5.SQLCODE'=0,tRS5.SQLCODE'=100 Set tSC = $$$ERROR($$$GeneralError, "UPDATE HS_Registry_Document.ExternalIdentifier 2 failed - SQLCODE="_tRS5.SQLCODE_" - "_tRS5.%Message) Quit

					Set tRS6=tStmt6.%Execute(tIID)
					If tRS6.SQLCODE'=0,tRS6.SQLCODE'=100 Set tSC = $$$ERROR($$$GeneralError, "Locating RegistryPackage Associations failed - "_tIID_"- SQLCODE="_tRS6.SQLCODE_" - "_tRS6.%Message) Quit
					While tRS6.%Next() {
						Set tRS7=tStmt7.%Execute(tNew,tRS6.%GetData(1))
						If tRS7.SQLCODE'=0,tRS7.SQLCODE'=100 Set tSC = $$$ERROR($$$GeneralError, "UPDATE HS_Registry_Document.RegistryPackage PatientIdentifier failed - SQLCODE="_tRS7.SQLCODE_" - "_tRS7.%Message) Quit
					}
					If $$$ISERR(tSC) Quit
					TCOMMIT
				}
				If $$$ISERR(tSC) TROLLBACK
				
			} Catch ex {
				Set tSC = ex.AsStatus()
				TROLLBACK
			}
		}
		
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	If ..lockedEntries]"" Do ..lockEntries()  // release all locks
	Set:$$$ISERR(tSC) pResponse.ErrStatus=tSC
	Quit tSC
}

/// take the SubmitObjectRequest
Method RegisterRequest(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	Set tSC=$$$OK
	Try {
		Set ..OutputSet = ##class(HS.Types.IHE.Submission).%New()
		#dim tConvertedRequest as HS.Message.IHE.XDSb.Metadata = ..info("ConvertedRequest")
		If $$$ISERR(..info("ConvertedRequestSC")) {
			/// properly report error transforming inbound message into object (datatype validation on fields for example)
			/// currently there are issues with some tranformed objects (like folders)
			//Do ..OutputSet.logError("XDSbRegistryMetadataError","Error",$system.Status.GetErrorText(..info("ConvertedRequestSC")))
			//Quit
		}
		If 'tConvertedRequest.Submissions.Count(){//Check here before we try to take out a lock based on the submission set
			Do ..OutputSet.logError("XDSbRegistryMetadataError","Error","Submission set is missing")
			Quit
		}
		Do ..lockEntries("N",$p(tConvertedRequest.Submissions.GetAt(1).PatientIdentifier.Value,"^"))
		Set tInput = pRequest.ContentStream
		$$$HSTRACE("RegisterDocumentSetb","tInput",tInput)
		$$$HSTRACESTARTCALL
		Set tSC=..Transformer.TransformIntoObject(tInput,..RegisterToDocumentTransform /*"IHE/XDSb/Version1/RegisterToDocument.xsl"*/,.tSubmission,,"HS.Types.IHE.Submission","Submission") 
		$$$HSTRACEENDCALL
		If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to transform request "_$system.Status.GetErrorText(tSC)) Quit
		$$$HSTRACE("Submission","tSubmission",tSubmission)
		Set tValidatePatientId = (pRequest.AdditionalInfo.GetAt("ValidatePatientID")'=0) //must be explicitly set to skip validation
		#; Pre-process -> Update any object id to be a uuid if not already assigned and move classifications from outside reg package to inside
		Set tSC = ..registerUpdateUUIDs(.tSubmission) 
		If $$$ISERR(tSC) {
			Do ..OutputSet.logError("Internal","Error","Internal error "_$system.Status.GetErrorText(tSC))
			Quit
		}
		If pRequest.Name=$$$RMUDocumentSetRequest {
			Set tSC = ..RegistryValidateRMURequest(..OutputSet,tSubmission,..info("ConvertedRequest"))
		} ElseIf pRequest.Name=$$$XDSbUpdateDocumentSetRequest {
			Set tSC = ..ValidateUpdateRequest(tSubmission,pRequest.Name,tValidatePatientId)
		}
		If $$$ISERR(tSC) || ..OutputSet.Errors.Count() Quit
		Set tSC = ..ValidateRegisterRequest(tSubmission,pRequest.Name,tValidatePatientId)
		If $$$ISERR(tSC) || ..OutputSet.Errors.Count() Quit
		Set tSC = ..registerProcess(tSubmission)
		Quit:$$$ISERR(tSC)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
		$$$LOGSTATUS(tSC)
	}
	try {
		/// convert pErrors into new input document to be used to produce errorlist section
		$$$HSTRACE("Status after Filing","tSC,..OutputSet",tSC,..OutputSet)
		Set tXSLArguments("status")	= $S(..OutputSet.Errors.Count():"Failure",tSC:"Success",1:"Failure")
		Do ..OutputSet.XMLExportToStream(.tOutput)
		Do tOutput.Rewind()
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tOutput,..RegistryAddResponseTransform /*"IHE/XDSb/Version1/RegistryAddResponse.xsl"*/,.tResponse,.tXSLArguments)
		$$$HSTRACEENDCALL
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name=$$$XDSbRegisterResponse
		Set pResponse.ContentStream=tResponse
		Do pResponse.ContentStream.Rewind()
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	If ..OutputSet.Errors.Count()=0 {
		$$$HSTRACE("Update Document status")
		Set:$$$ISOK(tSC) tSC=..UpdateDocumentStatus(tSubmission)
		$$$HSTRACE("Update RP status")
		Set:$$$ISOK(tSC) tSC=..UpdateRegistryPackageStatus(tSubmission)
		$$$HSTRACE("Before Post processor")
		If $$$ISOK(tSC) {
			If ..RegisterPostProcessor]"" {
				For i=1:1:$L(..RegisterPostProcessor,",") {
					Set tTarget = $ZStrip($P(..RegisterPostProcessor,",",i),"<>W")
					If tTarget]"" {
						Set tPostSC = ..SendRequestAsync(tTarget,pRequest)
						If $$$ISERR(tPostSC) $$$LOGSTATUS(tPostSC)
					}
				}	
			}
		}
		$$$HSTRACE("Post Processor completed")
	}
	Quit tSC
}

ClassMethod NormalizeAA(ByRef pArray)
{
	Set tIdx=$o(pArray("$XDSDocumentEntryPatientId",""))
	Quit:tIdx=""
	Set tPatientID=$o(pArray("$XDSDocumentEntryPatientId",tIdx,""))
	Quit:tPatientID=""
	Set tOldID = tPatientID
	Set tVal = $g(pArray("$XDSDocumentEntryPatientId",tIdx,tPatientID))
	Set tAA = $p(tPatientID,"^",4)
	Set tAAName = $p(tAA,"&",1)
	Set tAAOID = $p(tAA,"&",2)
	Set tAAType = $p(tAA,"&",3)
	Set tChanged = 0
	If ((tAAOID = "") && (tAAType = "")){
		Set tAAOID = ##class(HS.Data.OIDMap).GetOIDForCode(tAAName)
		Set tAAType = "ISO"
		Set tChanged = 1
	}
	If ((tAAOID'="")&&(tAAType'="")){
		Set tAAName = ""
		Set tChanged = 1
	}
	Quit:'tChanged
	Set $p(tPatientID,"^",4) = tAAName_"&"_tAAOID_"&"_tAAType
	Kill pArray("$XDSDocumentEntryPatientId",tIdx,tOldID)
	Set pArray("$XDSDocumentEntryPatientId",tIdx,tPatientID) = tVal
}

Method QueryRequest(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	Set tSC = $$$OK

	Try {
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name=$$$XDSbQueryResponse

		Set ..OutputSet=##class(HS.Types.IHE.Submission).%New()
		Set tRequestStream = pRequest.ContentStream
		Set tSC = ..QueryParameters(tRequestStream,.tAry,.tQueryType,.tReturnType)
		Do ..NormalizeAA(.tAry)
		Set ..QueryReturnType=tReturnType
		If ",ObjectRef,LeafClass,"'[(","_tReturnType_",") {
			Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown Query return type") Quit
		}

		$$$HSTRACE("Evaluation values","tQueryType,tAry,tReturnType",tQueryType,..aryToList(.tAry),tReturnType)
		If tQueryType=$$$XDSbQueryFindDocuments {
			Do ..queryFindDocuments(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryFindDocumentsMultiPatients {
			Do ..queryFindDocumentsMultiPatients(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryFindSubmissionSets {
			Do ..queryFindSubmissionSets(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryFindFolders {
			Do ..queryFindFolders(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetDocuments {
			Do ..queryGetDocuments(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetFolders {
			Do ..queryGetFolders(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetAssociations {
			Do ..queryGetAssociations(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetDocsAndAssociations {
			Do ..queryGetDocsAndAssociations(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetSubmissionSets {
			Do ..queryGetSubmissionSets(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetSubSetsAndContents {
			Do ..queryGetSubSetsAndContents(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetFolderAndContents {
			Do ..queryGetFolderAndContents(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetFoldersForDocument {
			Do ..queryGetFoldersForDocument(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetRelatedDocuments {
			Do ..queryGetRelatedDocuments(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryGetAll {
			Do ..queryGetAll(.tAry)
		} 
		ElseIf tQueryType=$$$XDSbQueryFindFoldersMultiPatients {
			Do ..queryFindFoldersMultiPatients(.tAry)
		}
		ElseIf tQueryType=$$$XDSbQueryFindDocumentsByReferenceId {
			Do ..queryFindDocumentsByReferenceId(.tAry)
		}
		Else {
			try {
				Set tSC = $method($this,"queryUUID"_$tr($p(tQueryType,"urn:uuid:",2),"-"),.tAry)
			} catch ex {
				Set tSC = ex.AsStatus()
				Do ..OutputSet.logError("InternalError","Error","Unknown query type:"_tQueryType)
			}			
		}
		$$$HSTRACE("Output set","..OutputSet",..OutputSet)

		If ..OutputSet.Errors.Count()=0 {
			#; GetAll query requires the object refs be collected so that the associations can be found, but don't output them if not a ObjectRef query
			If ..QueryReturnType'="ObjectRef" { Do ..OutputSet.ObjectRefs.Clear() }
			Kill tXSLArguments
			Set tXSLArguments("status") = "Success"
			d ..OutputSet.XMLExportToStream(.tOutputSetStream) 
			d tOutputSetStream.Rewind()
			$$$HSTRACESTARTCALL
			Set tSC=..Transformer.Transform(tOutputSetStream,..RegistryStoredQueryResponseTransform /*"IHE/XDSb/Version1/RegistryStoredQueryResponse.xsl"*/,.tQueryResponseStream) $$$ThrowOnError(tSC)
			$$$HSTRACEENDCALL
			Do pResponse.ContentStream.CopyFrom(tQueryResponseStream)
			Do pResponse.ContentStream.Rewind()
			
			#; Apply consent (not needed later since failure never returns documents)		
			//%HS_NotifyAndQueryOperations is only used for an internal message - no consent
			If ..XDSbQueryConsentTarget ] "", pRequest.SAMLData.HSRoles'="%HS_NotifyAndQueryOperations" {
				Set pResponse.AdditionalInfo = pRequest.AdditionalInfo
				Set pResponse.SAMLData = pRequest.SAMLData.%ConstructClone()
				Set tSC = ..SendRequestSync(..XDSbQueryConsentTarget, pResponse, .tConsentedResponse) $$$ThrowOnError(tSC)
				Set pResponse = tConsentedResponse
			}
		}

	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	If $$$ISERR(tSC) || ..OutputSet.Errors.Count() {
		$$$HSTRACE("outputset","..OutputSet,Errors",..OutputSet,..OutputSet.Errors)
		#; Respond with "Failure" status
		Kill tXSLArguments
		Set tXSLArguments("status") = "Failure"
		Do ..OutputSet.XMLExportToStream(.tOutput) Do tOutput.Rewind()
		$$$HSTRACESTARTCALL
		Set tSC = ..Transformer.Transform(tOutput, ..RegistryStoredQueryResponseTransform /*"IHE/XDSb/Version1/RegistryStoredQueryResponse.xsl"*/,.tResponse,.tXSLArguments)
		$$$HSTRACEENDCALL
		If $$$ISERR(tSC) $$$HSTRACE("Problem transforming failure","tSC,tOutput",tSC,tOutput)
		Set pResponse=##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name="XDSb_QueryResponse"
		Set pResponse.ContentStream=tResponse
		Do pResponse.ContentStream.Rewind()
		If $$$ISERR(tSC) {
			$$$LOGSTATUS(tSC)
		} Else {
			$$$LOGERROR("Errors reported (first is) "_..OutputSet.Errors.GetAt(1).Description)
		}
		#; switch status code, we are returning the correct message
		Set tSC=$$$OK
	}
	Quit tSC
}

/// This method is specifically for messages from HS.Gateway.XDSb.NotifyAndQuery.Operations, and should not be used for messages from any other source.
/// <br> If the query request comes from there, then we can streamline the processing a bit, and we know to skip consent and auditing.
Method XDSbQueryRequest(pRequest As HS.Message.IHE.XDSb.QueryRequest, pResponse As HS.Message.IHE.XDSb.QueryResponse) As %Status [ Internal ]
{
	#dim eException As %Exception.AbstractException
	Set tSC = $$$OK

	Try {
		Do{
			Set tResponse=##class(HS.Message.XMLMessage).%New()
			Set tResponse.Name=$$$XDSbQueryResponse
			set pResponse = ##class(HS.Message.IHE.XDSb.QueryResponse).%New()
			; copy into SAMLData if it's empty
			Set:pRequest.SAMLData.UserName="" pRequest.SAMLData.UserName=pRequest.RequestingUser
			Set:pRequest.SAMLData.HSRoles="" pRequest.SAMLData.HSRoles=pRequest.RequestingUserRoles
			Set:pRequest.SAMLData.BreakTheGlass="" pRequest.SAMLData.BreakTheGlass=pRequest.BreakTheGlass
			Set ..OutputSet=##class(HS.Types.IHE.Submission).%New()
			Set tSC = ..XDSbQueryParameters(pRequest,.tAry,.tQueryType,.tReturnType)
			Quit:$$$ISERR(tSC)
			Do ..NormalizeAA(.tAry)
			Set ..QueryReturnType=tReturnType
			If ",ObjectRef,LeafClass,"'[(","_tReturnType_",") {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown Query return type") Quit
			}
			$$$HSTRACE("Evaluation values","tQueryType,tAry,tReturnType",tQueryType,..aryToList(.tAry),tReturnType)
			If tQueryType=$$$XDSbQueryFindDocuments {
				Do ..queryFindDocuments(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryFindDocumentsMultiPatients {
				Do ..queryFindDocumentsMultiPatients(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryFindSubmissionSets {
				Do ..queryFindSubmissionSets(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryFindFolders {
				Do ..queryFindFolders(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetDocuments {
				Do ..queryGetDocuments(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetFolders {
				Do ..queryGetFolders(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetAssociations {
				Do ..queryGetAssociations(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetDocsAndAssociations {
				Do ..queryGetDocsAndAssociations(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetSubmissionSets {
				Do ..queryGetSubmissionSets(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetSubSetsAndContents {
				Do ..queryGetSubSetsAndContents(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetFolderAndContents {
				Do ..queryGetFolderAndContents(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetFoldersForDocument {
				Do ..queryGetFoldersForDocument(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetRelatedDocuments {
				Do ..queryGetRelatedDocuments(.tAry)
			} 
			ElseIf tQueryType=$$$XDSbQueryGetAll {
				Do ..queryGetAll(.tAry)
			} 

			$$$HSTRACE("Output set","..OutputSet",..OutputSet)
			If ..OutputSet.Errors.Count()=0 {
				#; GetAll query requires the object refs be collected so that the associations can be found, but don't output them if not a ObjectRef query
				If ..QueryReturnType'="ObjectRef" { Do ..OutputSet.ObjectRefs.Clear() }
				Kill tXSLArguments
				Set tXSLArguments("status") = "Success"
				d ..OutputSet.XMLExportToStream(.tOutputSetStream) 
				d tOutputSetStream.Rewind()
				$$$HSTRACESTARTCALL
				Set tSC=..Transformer.Transform(tOutputSetStream,..RegistryStoredQueryResponseTransform /*"IHE/XDSb/Version1/RegistryStoredQueryResponse.xsl"*/,.tQueryResponseStream) $$$ThrowOnError(tSC)
				$$$HSTRACEENDCALL
				Do tResponse.ContentStream.CopyFrom(tQueryResponseStream)
				Do tResponse.ContentStream.Rewind()
				
				#; Apply consent (not needed later since failure never returns documents)
				//%HS_NotifyAndQueryOperations is only used for an internal message - no consent - so this should always be skipped
				If ((..XDSbQueryConsentTarget ] "") && (pRequest.SAMLData.HSRoles'="%HS_NotifyAndQueryOperations") && (pRequest.RequestingUserRoles'="%HS_NotifyAndQueryOperations")) {
					Set tResponse.AdditionalInfo = pRequest.AdditionalInfo
					Set tResponse.SAMLData = pRequest.SAMLData.%ConstructClone()
					Set tSC = ..SendRequestSync(..XDSbQueryConsentTarget, tResponse, .tConsentedResponse) $$$ThrowOnError(tSC)
					Set tResponse = tConsentedResponse
				}
			}
		} While 0
		If $$$ISERR(tSC) || ..OutputSet.Errors.Count() {
			$$$HSTRACE("outputset","..OutputSet,Errors",..OutputSet,..OutputSet.Errors)
			#; Respond with "Failure" status
			Kill tXSLArguments
			Set tXSLArguments("status") = "Failure"
			Do ..OutputSet.XMLExportToStream(.tOutput) Do tOutput.Rewind()
			$$$HSTRACESTARTCALL
			Set tSC = ..Transformer.Transform(tOutput, ..RegistryStoredQueryResponseTransform /*"IHE/XDSb/Version1/RegistryStoredQueryResponse.xsl"*/,.tErrResponse,.tXSLArguments)
			$$$HSTRACEENDCALL
			If $$$ISERR(tSC) $$$HSTRACE("Problem transforming failure","tSC,tOutput",tSC,tOutput)
			Set tResponse=##class(HS.Message.XMLMessage).%New()
			Set tResponse.Name="XDSb_QueryResponse"
			Set tResponse.ContentStream=tErrResponse
			Do tResponse.ContentStream.Rewind()
			
			If $$$ISERR(tSC) {
				$$$LOGSTATUS(tSC)
			} Else {
				$$$LOGERROR("Errors reported (first is) "_..OutputSet.Errors.GetAt(1).Description)
			}
			#; switch status code, we are returning the correct message
			Set tSC=$$$OK
		}

		// Transform back from HS.Message.XMLMessage to HS.Message.IHE.XDSb.QueryResponse - copied from HS.IHE.XDSb.Consumer.Operations
		Set tParams("includeSlots")=1
		Set tSC = ##class(HS.IHE.Util).GetXPathExpression(tResponse.ContentStream,"/query:AdhocQueryResponse/rim:RegistryObjectList/rim:ExtrinsicObject","@id",.value,.tDocument)

		If value.Count()<..MaximumDocumentsToProcess {
			Set tSC=..Transformer.TransformIntoObject(tResponse.ContentStream, ..TransformToMetadata /*"IHE/XDSb/Version1/Message-to-Metadata.xsl"*/, .pResponse,.tParams, "HS.Message.IHE.XDSb.QueryResponse","Metadata",1)
			For tIdx=1:1:pRequest.Parameters.Count() {
				Set tItem = pRequest.Parameters.GetAt(tIdx)
				Set tName=tItem.ItemName
				If $e(tName,1,4)'="urn:" Continue
				Set tCustom($zcvt(tName,"U")_" ",tIdx)=tItem.Values  ;# conditions for slot
			}
			Set tItemsRemoved=0
			;# only check if the query contained custom requests #SlotName with Values
			If $D(tCustom) {
				$$$HSTRACE("Begin Custom Filters","pResponse",pResponse)
				For tIdx=pResponse.Documents.Count():-1:1 {
					Merge tFoundCustom=tCustom
					Set tDocument = pResponse.Documents.GetAt(tIdx)
					For tIdx3=1:1:tDocument.DocumentSlots.Count() {
						Set tSlot=tDocument.DocumentSlots.GetAt(tIdx3)
						Set tUName = $zcvt(tSlot.Name,"U")_" "
						Continue:'$D(tFoundCustom(tUName))
						Set tIdx2=""
						For  {
							Set tIdx2=$O(tFoundCustom(tUName,tIdx2)) Quit:tIdx2=""
							Set tValueList = tFoundCustom(tUName,tIdx2)
							For tIdx4=1:1:tSlot.ValueList.Count() {
								Set tValue=tSlot.ValueList.GetAt(tIdx4).Value
								If tValueList.Find(tValue) Kill tFoundCustom(tUName,tIdx2) Quit
							}
						}
						If $D(tFoundCustom(tUName)) {
							Set tValues="",i="" For { Set i=$o(tFoundCustom(tUName,i)) q:i=""  f j=1:1:tFoundCustom(tUName,i).Count() s tValues=tValues_","_tFoundCustom(tUName,i).GetAt(j) }
							$$$HSTRACE("Document removed","uuid,slot,value",tDocument.EntryUUID,tSlot.Name,tValues)
						}
					}
					If $D(tFoundCustom) {
						Do pResponse.Documents.RemoveAt(tIdx) Set tItemsRemoved=1  ;# did not match all critera - remove it
						For i=1:1:pResponse.ObjectRefs.Count() {
							$$$HSTRACE("ObjRefCheck","oref",pResponse.ObjectRefs.GetAt(i).EntryUUID)
							If pResponse.ObjectRefs.GetAt(i).EntryUUID=tDocument.EntryUUID {
								Do pResponse.ObjectRefs.RemoveAt(i)	
								Quit
							}	
						}
					}
				}			
			}
			If tItemsRemoved  {
				#; since items were removed we need to cleanup the query response (removing any entries from the response)
				Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
				Set tSC=..Transformer.TransformFromObject(pResponse, ..TransformResponseCleanup /*"IHE/XDSb/Version1/QueryResponseCleanup.xsl"*/, .tStream,"", "QueryResponse",1)
				Do pResponse.ContentStream.CopyFrom(tStream)
			} 
			Else { Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)}
		} else {
			Set pResponse=##class(HS.Message.IHE.XDSb.QueryResponse).%New()
			Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
			Do pResponse.Errors.logError("XDSbRegistry","Error","Unable to parse due to number of results ("_value.Count()_" results, with maximum "_..MaximumDocumentsToProcess _")")
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
		$$$LOGSTATUS(tSC)
		Set pResponse=##class(HS.Message.IHE.XDSb.QueryResponse).%New()
		If $isObject($g(tResponse)) {
			Do pResponse.ContentStream.CopyFrom(tResponse.ContentStream)
		}
		Do pResponse.Errors.logError("XDSbConsumer","Error",$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

Method QueryParameters(pRequestStream, Output pAry, ByRef pQueryType, ByRef pReturnType) As %Status
{
	try {
		Set tSC = ..ParseQueryParameters(pRequestStream,.pAry,..OutputSet,.pQueryType,.pReturnType)
		Set tM=1
		Set tIdx = $O(pAry("$MetadataLevel","")) Set:tIdx]"" tM=$o(pAry("$MetadataLevel",tIdx,""))
		Kill pAry("$MetadataLevel") Set ..info("$MetadataLevel")=tM
	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

/// This method is also called by XCA.RespondingGateway.Process
ClassMethod ParseQueryParameters(pRequestStream, Output pAry, ByRef pErrors As HS.Types.IHE.Errors, ByRef pQueryType, ByRef pReturnType) As %Status
{
	try {
		Set tSC=$$$OK
		set tSC=##class(%XML.XPATH.Document).CreateFromStream(pRequestStream,.tDocument,,,,,"rim urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0,ihe urn:ihe:iti:xds-b:2007,xop http://www.w3.org/2004/08/xop/include,query urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0")
		If $$$ISERR(tSC) Do pErrors.logError("XDSRegistryMetadataError","Error","Unable to transform source request "_$system.Status.GetOneErrorText(tSC)) Quit
		Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/rim:AdhocQuery","@id",.tQueryTypes)
		If $$$ISERR(tSC) Do pErrors.logError("XDSRegistryMetadataError","Error","Unable to obtain query type "_$system.Status.GetOneErrorText(tSC)) Quit
		Set pQueryType=tQueryTypes.GetAt(1).Value
		Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/query:ResponseOption","@returnType",.tReturn) 
		If $$$ISERR(tSC) Do pErrors.logError("XDSRegistryMetadataError","Error","Unable to obtain return type "_$system.Status.GetOneErrorText(tSC)) Quit
		Set pReturnType=tReturn.GetAt(1).Value
		Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot","@name",.tSlots)
		If $$$ISERR(tSC) Do pErrors.logError("XDSRegistryMetadataError","Error","Unable to evaluate query parameters "_$system.Status.GetOneErrorText(tSC)) Quit
		#; get query parameters and store in pAry
		For tIdx=1:1:tSlots.Count() {
			Set tValue=tSlots.GetAt(tIdx).Value
			If tValue="" do pErrors.logError("XDSRegistryMetadataError","Error","Empty parameter in slot "_tIdx_" value item:"_tIdx) Continue 
			Set tSC = tDocument.EvaluateExpression("/query:AdhocQueryRequest/rim:AdhocQuery/rim:Slot["_tIdx_"]/rim:ValueList/rim:Value","text()",.tValues)
			For tIdxVal=1:1:tValues.Count() {
				Set tItemValue=tValues.GetAt(tIdxVal).Value
				If tItemValue="" do pErrors.logError("XDSRegistryMetadataError","Error","Unknown parameter in slot "_tIdx_" value item:"_tIdxVal) continue
				#; remove leading trailing ()
				Set tItemValue=$zstrip(tItemValue,"<>W",$c(10))
				If $E(tItemValue)="(" {
					If $E(tItemValue,*)'=")" { do pErrors.logError("XDSRegistryMetadataError","Error","Unknown parameter in slot "_tIdx_" value item:"_tIdxVal_" with value "_tItemValue) continue }  /// bad value some sort of error
					Set tItemValue=$e(tItemValue,2,*-1)
				}
				
				For tIdx1=1:1:$l(tItemValue,",") {
					Set pAry(tValue,tIdx,$zstrip($p(tItemValue,",",tIdx1),"<>W",$c(10)_"'"))=""
				}
			}
		}
		#; If $XDSDocumentEntryType filter not present, the following queries must return only stable documents
		If $Case(pQueryType
			,$$$XDSbQueryFindDocuments:1
			,$$$XDSbQueryGetAll:1
			,$$$XDSbQueryGetSubSetsAndContents:1
			,$$$XDSbQueryGetFolderAndContents:1
			,$$$XDSbQueryGetRelatedDocuments:1
			,:0) {
			If '$D(pAry("$XDSDocumentEntryType")) {
				Set pAry("$XDSDocumentEntryType",tSlots.Count()+1,$$$XDSbStableDocument)=""
			}
		}
	} catch eException {
		Set tSC=eException.AsStatus()
		Do pErrors.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

Method XDSbQueryParameters(pRequest As HS.Message.IHE.XDSb.QueryRequest, Output pAry, ByRef pQueryType, ByRef pReturnType) As %Status
{
	try {
		Set tSC=$$$OK
		Set pQueryType = "urn:uuid:"_##class(HS.Message.IHE.XDSb.QueryRequest).QueryTypeLogicalToDisplay(pRequest.QueryType)
		Set pReturnType = $case(pRequest.ReturnType,"LC":"LeafClass","OR":"ObjectRef",:"UNKNOWN")
		
		#; get query parameters and store in pAry
		Set tIdx=""
		set tParamCount=0
		for{
			set tQueryItem=pRequest.Parameters.GetNext(.tIdx)
			quit:tIdx=""
			set tParamCount=tParamCount+1
			set tValue=tQueryItem.ItemName
			If tValue="" do ..OutputSet.logError("XDSRegistryMetadataError","Error","Empty parameter in slot "_tIdx) Continue 
			set tIdxVal=""
			for{
				set tItemValue=tQueryItem.Values.GetNext(.tIdxVal)
				quit:tIdxVal=""
				If tItemValue="" do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown parameter in slot "_tIdx_" value item:"_tIdxVal) continue
				If $E(tItemValue)="(" {; for an HS.Message.IHE.XDSb.QueryRequest object there should be no parens in the first place
					If $E(tItemValue,*)'=")" { do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown parameter in slot "_tIdx_" value item:"_tIdxVal_" with value "_tItemValue) continue }  /// bad value some sort of error
					Set tItemValue=$e(tItemValue,2,*-1)
				}
				For tIdx1=1:1:$l(tItemValue,",") {
					Set pAry(tValue,tIdx,$zstrip($p(tItemValue,",",tIdx1),"<>W",$c(10)_"'"))=""
				}
			}
			set tIdxVal=""
			for{
				set tCodedValue=tQueryItem.CodedValues.GetNext(.tIdxVal)
				quit:tIdxVal=""
				set tItemValue=tCodedValue.Code_"^^"_tCodedValue.Scheme
				If tItemValue="^^" do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown parameter in slot "_tIdx_" codedvalue item:"_tIdxVal) continue
				If $E(tItemValue)="(" {; for an HS.Message.IHE.XDSb.QueryRequest object there should be no parens in the first place
					If $E(tItemValue,*)'=")" { do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown parameter in slot "_tIdx_" value item:"_tIdxVal_" with value "_tItemValue) continue }  /// bad value some sort of error
					Set tItemValue=$e(tItemValue,2,*-1)
				}
				For tIdx1=1:1:$l(tItemValue,",") {
					Set pAry(tValue,tIdx,$zstrip($p(tItemValue,",",tIdx1),"<>W",$c(10)_"'"))=""
				}
				
			}			
		}
		
		#; If $XDSDocumentEntryType filter not present, the following queries must return only stable documents
		If $Case(pQueryType
			,$$$XDSbQueryFindDocuments:1
			,$$$XDSbQueryGetAll:1
			,$$$XDSbQueryGetSubSetsAndContents:1
			,$$$XDSbQueryGetFolderAndContents:1
			,$$$XDSbQueryGetRelatedDocuments:1
			,:0) {
			If '$D(pAry("$XDSDocumentEntryType")) {
				Set pAry("$XDSDocumentEntryType",tParamCount+1,$$$XDSbStableDocument)=""
			}
		}
		Set tM=1
		Set tIdx = $O(pAry("$MetadataLevel","")) Set:tIdx]"" tM=$o(pAry("$MetadataLevel",tIdx,""))
		Kill pAry("$MetadataLevel") Set ..info("$MetadataLevel")=tM
	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

/// once register is successful mark documents as approved
Method UpdateDocumentStatus(pSubmission) As %Status
{
	Set tSC=$$$OK
	try {
		For tIdx=1:1:pSubmission.Documents.Count() {
			Set tDocument=pSubmission.Documents.GetAt(tIdx)
			Set:tDocument.Status="Submitted" tDocument.Status="Approved"
			Set tSC=tDocument.%Save()
		}

	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

/// once register is successful mark registrypackage as approved
Method UpdateRegistryPackageStatus(pSubmission, tOutputSet As %RegisteredObject) As %Status
{
	Set tSC=$$$OK
	try {
		For tIdx=1:1:pSubmission.RegistryPackages.Count() {
			Set tObject=pSubmission.RegistryPackages.GetAt(tIdx)
			Set:tObject.Status="Submitted" tObject.Status="Approved"
			Set tSC=tObject.%Save()
			Quit:$$$ISERR(tSC)
		}

	} catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

Method ValidateRegisterRequest(pSubmission As HS.Types.IHE.Submission, pRequestName As %String, pValidatePatientId As %Boolean = 1) As %Status
{
	try {
		#dim tRP As HS.Registry.Document.RegistryPackage
		#; update RegistryPackage type / find submission set
		Set tSSEntryUUID=" "
		For tIdx=1:1:pSubmission.RegistryPackages.Count() {
			Set tRP=pSubmission.RegistryPackages.GetAt(tIdx)
			Set tRP.Type=$S(tRP.Node.Value="urn:uuid:d9d542f3-6cc4-48b6-8870-ea235fbc94c2":"F",1:"SS")
			If tRP.Type="SS" {
				If $d(..info("SubmissionSet")) && (..info("SubmissionSet").IID'=tRP.IID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Multiple submission sets found")
				Set ..info("SubmissionSet")=tRP,tSSEntryUUID=tRP.IID

				// check whether submission set already exists
				Set tSSUniqueId = tRP.UniqueIdentifier.Value
				Set tSubmissionSet = ##class(HS.Registry.Document.RegistryPackage).ItemForUniqueID(tSSUniqueId)
				Set tSubmissionSetExists = tSubmissionSet]""
				$$$HSTRACE("Checking for submission set uniqueness", "tSSUniqueId,tSubmissionSet,tSubmissionSetExists",tSSUniqueId,tSubmissionSet, tSubmissionSetExists)
				if (tSubmissionSetExists) {
					Set tSC = $$$ERROR($$$GeneralError ,"SubmissionSet uniqueId is already present in the registry")	
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error",$system.Status.GetErrorText(tSC))
					return tSC
				}					
			}
		}
		#; ensure ExternalIdentifiers correctly point to RegistryPackage
		For tIdx=1:1:pSubmission.RegistryPackages.Count() {
			#;ensure ExternalIdentifiers correctly point to RegistryPackage
			For tIdxE=1:1:tRP.ExternalIdentifiers.Count() {
				If tRP.ExternalIdentifiers.GetAt(tIdxE).RegistryObject'=tRP.IID Do ..OutputSet.logError("XDSRegistryMetadataError","Error","ExtrinsicObject.id "_tRP.IID_" does not match ExternalIdentifier.registryObject "_tRP.ExternalIdentifiers.GetAt(tIdxE).RegistryObject)
			}

			If '..IgnoreMissingRequiredItems {
				If tRP.PatientIdentifier.Value="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Registry Package Patient Identifer:"_tRP.IID,"RegistryPackage["_tIdx_"]")
				If tRP.UniqueIdentifier.Value="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Registry Package Unique Identifier:"_tRP.IID,"RegistryPackage["_tIdx_"]")
				If tRP.Type="SS" {
					If tRP.ContentTypeCode.Code="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Registry Package ContentTypeCode:"_tRP.IID,"RegistryPackage["_tIdx_"]")
					If tRP.SourceIdentifier.Value="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Source Identifier:"_tRP.IID,"RegistryPackage["_tIdx_"]")
					If tRP.SubmissionTime="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Registry Package Submission Time:"_tRP.IID,"RegistryPackage["_tIdx_"]")
				} Else {
					Set tHaveCodeList=0
					For tIdx1=1:1:tRP.Classifications.Count() {
						Set tClassObj=tRP.Classifications.GetAt(tIdx1)
						If tClassObj.ClassificationScheme="urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5" Set tHaveCodeList=1
					}
					If 'tHaveCodeList Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Folder CodeList for RegistryPackage IID:"_tRP.IID,"RegistryPackage["_tIdx_"]")
				}
			}
			If '..IgnoreInvalidClassifications {
				If tRP.ContentTypeCode.Code]"" {
					Set tScheme = "urn:uuid:aa543740-bdda-424e-8c96-df4873be8500"
					Set tSC=##class(HS.IHE.CodedEntry).ValidateEntry(tScheme,tRP.ContentTypeCode.Code,tRP.ContentTypeCode.CodingScheme,.tValid)
					If 'tValid {
						Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error Validating Classification scheme:ContentTypeCode:"_tScheme_" node:"_tRP.ContentTypeCode.Code_" codingscheme:"_tRP.ContentTypeCode.CodingScheme)
					}
				}
				For tIdx1=1:1:tRP.Classifications.Count() {
					Set tClassObj=tRP.Classifications.GetAt(tIdx1)
					Do:'..IgnoreInvalidClassifications tClassObj.Validate(..OutputSet)
				}
			}
			If tRP.Type="" {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to determine Registry Package type for:"_tRP.IID) Continue
			}
			If tRP.Type'="SS" Set tRequiredHasMember(tRP.IID,tSSEntryUUID)=""  // Any folder must have a hasmember to the submission set

		}
		If '$D(..info("SubmissionSet")) Do ..OutputSet.logError("XDSbRegistryMetadataError","Error","Submission set is missing")

		Set tDocCount=pSubmission.Documents.Count()  // take count as we may add documents
		For tIdx=1:1:tDocCount {
			#dim tDocument As HS.Registry.Document
			Set tDocument = pSubmission.Documents.GetAt(tIdx)
			If tDocument.DocumentUniqueIdentifier.Value="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","UniqueId.id "_tDocument.IID_" required ","ExtrinsicObject["_tIdx_"]")

			Set tRequiredHasMember(tDocument.IID,tSSEntryUUID)=""  // Any document must have a hasmember to the submission set
			#; ensure external identifier references the document
			For tIdxE=1:1:tDocument.ExternalIdentifiers.Count() {
				If tDocument.ExternalIdentifiers.GetAt(tIdxE).RegistryObject'=tDocument.IID Do ..OutputSet.logError("XDSRegistryMetadataError","Error","ExtrinsicObject.id "_tDocument.IID_" does not match ExternalIdentifier.registryObject "_tDocument.ExternalIdentifiers.GetAt(tIdxE).RegistryObject)
			}

			#; ensure classifications have valid codes
			If '..IgnoreInvalidClassifications {
				For tIdxC = 1:1:tDocument.Classifications.Count() {
					Set tClassObj=tDocument.Classifications.GetAt(tIdxC)
					//If tClassObj.ClassificationScheme="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document ClassificationScheme.id "_tClassObj.IID_" has an empty classification scheme","/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject["_tIdx_"]/rim:Classification["_tIdx1_"]/@classificationScheme")
					Set tType=tClassObj.ClassificationNode
					Do tClassObj.Validate(..OutputSet)
				}
				For tProperty="ClassCode","FormatCode","HealthCareFacilityTypeCode","PracticeSettingCode","TypeCode" {
					Set tSerialObj=$property(tDocument,tProperty)
					If tSerialObj.Code]"" {
						Set tSC=##class(HS.IHE.CodedEntry).ValidateEntry(,tSerialObj.Code,tSerialObj.CodingScheme,.tValid,tProperty)
						If 'tValid {
							Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error Validating Classification scheme: "_tProperty_" node:"_tSerialObj.Code_" codingscheme:"_tSerialObj.CodingScheme)
						}
					}
					
				}
			}
			If '..IgnoreMissingRequiredItems {
				If tDocument.ClassCode.Code="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document ClassCode:"_tDocument.IID)
				If tDocument.FormatCode.Code="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document FormatCode:"_tDocument.IID)
				If tDocument.HealthCareFacilityTypeCode.Code="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document HealthCareFacilityTypeCode:"_tDocument.IID)
				If tDocument.PracticeSettingCode.Code="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document PracticeSettingCode:"_tDocument.IID)
				If tDocument.TypeCode.Code="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document TypeCode:"_tDocument.IID)
				If tDocument.ObjectType'=$$$XDSbOnDemandDocument {
					/// Validate Size Hash and Creation time for stable documents
					If tDocument.CreationTime="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document Creation Time:"_tDocument.IID)
					If +tDocument.Size = 0 {
						Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing size value Document:"_tDocument.IID)
					}
					If tDocument.Hash = "" {
						Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing hash value Document:"_tDocument.IID)
					}
				}
				If tDocument.LanguageCode="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document Language Code:"_tDocument.IID)
				If tDocument.MimeType="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document MimeType:"_tDocument.IID)
				If tDocument.PatientIdentifier.Value="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document Patient Identifier:"_tDocument.IID)
				If tDocument.SourcePatientID="" {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document Source Patient Identifier:"_tDocument.IID)
				} Else {
					If ..ValidateSourcePatientID {
						#; check format Table 4.1.3 Rev. 8.0 Final Text 2011-08-11 Page 13
						Set tSourcePatientIDText=tDocument.SourcePatientID
						Set tSourcePatientID=$p(tSourcePatientIDText,"^")
						Set tSourcePatientAA = $p($p(tSourcePatientIDText,"^",4),"&",2)
						If (tSourcePatientID_"^^^&"_tSourcePatientAA_"&ISO")'=tSourcePatientIDText {
							Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Poorly formatted Source Patient ID, expected "_(tSourcePatientID_"^^^&"_tSourcePatientAA_"&ISO"))
						}
						If ##class(HS.Data.OIDMap).GetCodeForOID(tSourcePatientAA,"")="" {
							Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown Source Patient domain "_tSourcePatientAA)
						}
						If tSourcePatientID="" {
							Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Source Patient ID is empty")
						}
					}
				}
				If tDocument.DocumentUniqueIdentifier.Value="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document Unique Identifier:"_tDocument.IID)

				Set tHaveConfidentialityCode=0
				For tIdxC = 1:1:tDocument.Classifications.Count() {
					Set tClassObj=tDocument.Classifications.GetAt(tIdxC)
					///confidentiality code from classification collection  urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f
					If tClassObj.ClassificationScheme = "urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f" Set tHaveConfidentialityCode=1  // have the code subsequent code will validate it
				}
				If 'tHaveConfidentialityCode Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing Document Confidentiality Code:"_tDocument.IID)
			}

			Set tRepositoryOID = tDocument.SlotValueForObject("repositoryUniqueId") 
			If tRepositoryOID ="" {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Repository oid is required but missing")
			} ElseIf ..settings("ValidateRepository") {
				Set tRepository = ##class(HS.Data.OIDMap).GetCodeForOID(tRepositoryOID,"")
				If tRepository ="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown repository oid "_tRepositoryOID)
			}
			
			#; Check on-demand restrictions
			#;  - Either all stable or all on-demand (can use request name for enforcement)
			#;  - no size/hash/time for on-demand
			If tDocument.ObjectType=$$$XDSbOnDemandDocument {
				If pRequestName'=$$$XDSbRegisterOnDemandRequest  && (pRequestName'= $$$XDSbUpdateDocumentSetRequest) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document "_tDocument.IID_" indicates on-demand but action is not on-demand.  Action should be "_$$$XDSbRegisterOnDemandAction(1))
				
				Set tSize = tDocument.SlotValueForObject("size") 
				If tSize]"" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Size not allowed for on-demand document "_tDocument.IID)

				Set tHash = tDocument.SlotValueForObject("hash") 
				If tHash]"" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Hash not allowed for on-demand document "_tDocument.IID)

				Set tTime = tDocument.SlotValueForObject("creationTime") 
				If tTime]"" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Creation time not allowed for on-demand document "_tDocument.IID)
				
			}
			If tDocument.UniqueIDForObject() ="" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unique ID not found for object "_tDocument.IID)
		}

		/*
			Associations
				Source: SubmissionSet	Target: Document
				Source:	SubmissionSet	Target:	Folder
				Source:	SubmissionSet	Target:	Association
				Source:	Folder			Target:	Document
				Source:	Document		Target:	Document [original doc] (RPLC)
		
		*/
		For tIdx=1:1:pSubmission.Associations.Count() {
			Set tAssociation = pSubmission.Associations.GetAt(tIdx)
			Set tAssociationType=tAssociation.AssociationType
			Set tTargetObject=tAssociation.TargetObject
			Set tSourceObject=tAssociation.SourceObject
			Set tSource = $g(..substitutionAry("Object",tSourceObject))
			
			If '$IsObject(tSource) {
				Set tSource = $g(..substitutionAry("Object",tSourceObject))
				If '$IsObject(tSource) {
					Set tSourceID = ##class(HS.Registry.Document.RegistryPackage).ItemForIID(tSourceObject)
					If tSourceID]"" {
						Set tSource = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tSourceID)
						If '$IsObject(tSource) {
							Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open registry package (folder) to update time :"_tSourceID)
							Continue
						}
						Do tSource.UpdateTime()
						Do pSubmission.RegistryPackages.Insert(tSource)
					} Else {
						Set tSource = ##class(HS.Registry.Document).ObjectForIID(tSourceObject)
						// Updated Error Code per CP-ITI-952, and handle specific case of Source as a Document Entry.  Registry Package is handled below, outside of the loop
						If '$IsObject(tSource) do ..OutputSet.logError("UnresolvedReferenceException","Error","Association refers to "_tSourceObject_" which is not found") continue
					}
				}
			}
			// Handle invalid source Registry Package (Document Entry case handled above)
			If '$IsObject(tSource) do ..OutputSet.logError("XDSRegistryMetadataError","Error","Association refers to "_tSourceObject_" which is not found") continue

			If tSource.%IsA("HS.Registry.Document.RegistryPackage") && (tSource.Type="F") Set tSC=tSource.UpdateTime()
	
			Set tTarget = $g(..substitutionAry("Object",tTargetObject))
			If '$IsObject(tTarget) {
				Set tTarget = ##class(HS.Registry.Document).ObjectForIID(tTargetObject)
				If '$isObject(tTarget) {
					Set tTargetID = ##class(HS.Registry.Document.RegistryPackage).ItemForIID(tSourceObject)
					Set tTarget = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tTargetID)
					If '$IsObject(tTarget) do ..OutputSet.logError("XDSRegistryMetadataError","Error","Registry Package refers to "_tTargetObject_" which is not found") continue
					Do pSubmission.RegistryPackages.Insert(tTarget)
				} Else { 
					Do pSubmission.Documents.Insert(tTarget)
					$$$HSTRACE("TargetObject is a document "_tTargetObject)
				}
			}
			If tTarget.%IsA("HS.Registry.Document.RegistryPackage") && (tTarget.Type="F") &&(tTarget'=tSource) Set tSC=tTarget.UpdateTime()
			
			If tAssociationType="HasMember" {
				Kill tRequiredHasMember(tTarget.IID,tSource.IID)  // found required has member

				/// if a document check the hash for a match (but not for metadata update)
				If tTarget.%IsA("HS.Registry.Document") && (pRequestName'=$$$XDSbUpdateDocumentSetRequest) {
					Set tDocUniqueID = tTarget.UniqueIDForObject()
					$$$HSTRACE("Looking for existing document with unique ID:"_tDocUniqueID)
					k tAry
					Set tSC = ##class(HS.Registry.Document).DocumentForUniqueID(tDocUniqueID,.tAry,0,1)
					// Updated Error Code per CP-ITI-952
					If $$$ISERR(tSC) do ..OutputSet.logError("UnresolvedReferenceException","Error",$system.Status.GetErrorText(tSC)) continue
					Set tNewHash=tTarget.SlotValueForObject("hash")
					Set tID=""
					For  {
						Set tID=$o(tAry(tID)) Quit:tID=""
						Set tExistingDoc = ##class(HS.Registry.Document).%OpenId(tID)
						Set tCurrentHash=tExistingDoc.SlotValueForObject("hash")
						$$$HSTRACE("checking existing hash with new hash","tNewHash,tCurrentHash",tNewHash,tCurrentHash)
						If tNewHash '= tCurrentHash Do ..OutputSet.logError("XDSNonIdenticalHash","Error","Existing Document hash "_tCurrentHash_" does not match "_tNewHash) Continue
					}
				}
			} 
			ElseIf tAssociationType="Replaces" || (tAssociationType ="TransformsAndReplaces") {
				#; TargetObject is the document being replaced / SourceObject is the new document (in submission set)
				#; target is document and must be status approved to be valid
				// Updated Error Code per CP-ITI-952
				If tTarget.Status '="Approved" Do ..OutputSet.logError("XDSRegistryDeprecatedDocumentError","Error","Document status "_tTargetObject_" not Approved") continue
				Set tTarget.Status="Deprecated"
				$$$HSTRACE("In RPLC","tTargetObject,Status",tTargetObject,tTarget.Status)
				#; if source and target uniqueID's are the same the Hash values must match
				If tTarget.UniqueIDForObject() = tSource.UniqueIDForObject() {
					Set tNewHash=tSource.SlotValueForObject("hash")
					Set tCurrentHash=tTarget.SlotValueForObject("hash")
					$$$HSTRACE("checking existing hash with new hash","tNewHash,tCurrentHash",tNewHash,tCurrentHash)
					If tNewHash '= tCurrentHash Do ..OutputSet.logError("XDSNonIdenticalHash","Error","Existing Document hash "_tCurrentHash_" does not match "_tNewHash) Continue
				}

				Do:..Publisher]"" ..AddRelatedDocument(tTarget),..info("ConvertedRequest").AdditionalInfo.SetAt(1,"UpdateAvailabilityStatus"_tTarget.IID)
				Set tSC=..AddToFolders(pSubmission, tTargetObject, tSourceObject)
				If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update folders "_$system.Status.GetErrorText(tSC))
				
				Set tSC = ##class(HS.Registry.Document.Association).SourceIDsForTargetIID(tTargetObject,.tAryIDs,"Transforms")
				Set tSC = ##class(HS.Registry.Document.Association).SourceIDsForTargetIID(tTargetObject,.tAryIDs,"Appends")
				Set tIID=""
				For  {
					Set tIID=$O(tAryIDs(tIID)) Quit:tIID=""
					Set tOtherTarget=##class(HS.Registry.Document).ObjectForIID(tIID)
					If '$IsObject(tOtherTarget) $$$LOGSTATUS($$$ERROR($$$GeneralError,$$$FormatText($$$Text("Source Object %1 found by Association ID %2 referencing TargetObject %3 not found"),tIID,tAryIIDS(tIID),tTargetObject))) continue
					If tOtherTarget.Status '="Approved" continue
					Set tOtherTarget.Status="Deprecated"
					Do pSubmission.Documents.Insert(tOtherTarget)
					Do:..Publisher]"" ..AddRelatedDocument(tOtherTarget),..info("ConvertedRequest").AdditionalInfo.SetAt(1,"UpdateAvailabilityStatus"_tOtherTarget.IID)
				}
				
			} ElseIf tAssociationType="Appends" || (tAssociationType="Transforms") || (tAssociationType="Signs") {
				#; original is unchanged
				#; TargetObject is the document being appended / SourceObject is the new document (in submission set)
				
				Set tDocObject = ##class(HS.Registry.Document).ObjectForIID(tTargetObject)
				$$$HSTRACE("In APND / XFRM","tTargetObject,tDocObject",tTargetObject,tDocObject)
				// Updated Error Code per CP-ITI-952
				If '$isObject(tDocObject) do ..OutputSet.logError("UnresolvedReferenceException","Error","Document TargetObject:"_tTargetObject_" not found") continue
				// Updated Error Code per CP-ITI-952
				If tDocObject.Status '="Approved" Do ..OutputSet.logError("XDSRegistryDeprecatedDocumentError","Error","Document status "_tTargetObject_" not Approved") continue
				If tSource.IID '= tSourceObject {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document SourceObject"_tSourceObject_" not found") continue
				}
			} ElseIf tAssociationType="IsSnapshotOf" {
				#; ITI TF 3: 4.1.6.4.1.3 The Document Registry actor shall verify upon submission:
				#; - The sourceObject references a DocumentEntry in the submission
				// done above
				
				#; - The targetObject references a DocumentEntry in the Registry
				Set tDocObject = ##class(HS.Registry.Document).ObjectForIID(tTargetObject)
				$$$HSTRACE("In IsSnapshotOf","tTargetObject,tDocObject",tTargetObject,tDocObject)
				// Updated Error Code per CP-ITI-952
				If '$isObject(tDocObject) do ..OutputSet.logError("UnresolvedReferenceException","Error","Document "_tTargetObject_" not found") continue
				
				#; - The targetObject DocumentEntry has availabilityStatus of Approved
				// Updated Error Code per CP-ITI-952
				If tTarget.Status '="Approved" Do ..OutputSet.logError("XDSRegistryDeprecatedDocumentError","Error","Document status "_tTargetObject_" not Approved") continue

				#; - Verify that the objectType attribute of the sourceObject DocumentEntry is urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1 (Stable)
				If tSource.ObjectType'="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document objectType "_tSourceObject_" not Stable") continue

				#; - Verify that the objectType attribute of the targetObject DocumentEntry is urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248 (On-Demand)
				If tTarget.ObjectType'="urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248" Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document objectType "_tTargetObject_" not On-Demand") continue
			} ElseIf tAssociationType="UpdateAvailabilityStatus" {
				/// not really a RequiredHasMember - this document was artifically added
				Kill tRequiredHasMember(tTarget.IID,tSource.IID)  
			} Else {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown AssociationType ("_tAssociation.AssociationTypeLogicalToDisplay(tAssociation.AssociationType)_")")
			}
		}
		If $O(tRequiredHasMember(""))]"" {
			Set tIID=""
			For  {
				Set tIID=$O(tRequiredHasMember(tIID)) quit:tIID=""
				If pSubmission.AddedItems.IsDefined(tIID) Continue  /// added this item for processing don't need an association
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Missing hasmember association for "_tIID)
			}
			
		}


		#; during testing it is possible to turn off patient validation
		Set tSC=..CheckPatientIDs(pSubmission,.tPatientID,pValidatePatientId)
		Quit:$$$ISERR(tSC)

	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

/// specific requirements for update requests - then call ValidateRegisterRequest
Method ValidateUpdateRequest(pSubmission As HS.Types.IHE.Submission, pRequestName As %String, pValidatePatientId As %Boolean = 1) As %Status
{
	try {
		Set tSC = $$$OK
		#;A single Update Document Set transaction shall not contain multiple Update (DocumentEntry or Folder or Association) Status operations targeting the same logical object.
		#;At any point in time there shall be at most one version of a logical DocumentEntry object with status Approved in the registry/recipient. If this version exists it shall always be the most recent version.  At any point in time there shall be at most one version of a logical Folder object with status Approved in the registry/recipient. If this version exists it shall always be the most recent version.
		
		For tIdx=1:1:pSubmission.Documents.Count() {
			#dim tDocument As HS.Registry.Document
			Set tDocument = pSubmission.Documents.GetAt(tIdx)
			Set tLogicalIID=tDocument.LogicalIID
			If tLogicalIID'?1"urn:uuid:"8AN1"-"4AN1"-"4AN1"-"4AN1"-"12AN Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document Logical Entry UUID format incorrect for document ["_tIdx_"]:'"_tLogicalIID_"'") continue
			If tLogicalIID=tDocument.IID Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document Logical Entry UUID cannot be equal Entry UUID:"_tLogicalIID) continue
			If $D(tAryHaveDoc(tLogicalIID)) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Document Logical Entry UUID appears more than once in submission for:"_tLogicalIID) continue
			Set tAryHaveDoc(tLogicalIID)=tDocument.Version
			&sql(select Version,ID INTO :tVersion,:tID from HS_Registry.Document Where LogicalIID=:tLogicalIID AND (Status='Approved' or Version=:tDocument.Version) order by Version Desc)
			If SQLCODE {
				Do ..OutputSet.logError("XDSMetadataUpdateError","Error","Document version "_tDocument.Version_" was not located") continue
			}
			If (tVersion'=tDocument.Version) {
				Do ..OutputSet.logError("XDSMetadataUpdateError","Error","Document version "_tDocument.Version_" is not the most recent") continue
			} 
		}
		
		For tIdx=1:1:pSubmission.Associations.Count() {
			Set tAssociation=pSubmission.Associations.GetAt(tIdx)
			If tAssociation.AssociationType="UpdateAvailabilityStatus" {
				Set (tNewStatus,tOriginalStatus,tObject)=""
				For tIdxSlot=1:1:tAssociation.Slots.Count() {
					Set tSlot=tAssociation.Slots.GetAt(tIdxSlot)
					If tSlot.Name="NewStatus" Set tNewStatus=##class(HS.Types.IHE.Status).DisplayToLogical(tSlot.ValueList.GetAt(1).Value)
					If tSlot.Name="OriginalStatus" Set tOriginalStatus=##class(HS.Types.IHE.Status).DisplayToLogical(tSlot.ValueList.GetAt(1).Value)
				}
				Set tSC = ##class(HS.Registry.Document).ObjectForIIDOfHighestVersion(tAssociation.TargetObject,.tObject)
				If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error",$system.Status.GetErrorText(tSC)) continue
				Set:'$IsObject(tObject) tSC = ##class(HS.Registry.Document.RegistryPackage).ObjectForIIDOfHighestVersion(tAssociation.TargetObject,.tObject)
				If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error",$system.Status.GetErrorText(tSC)) continue
				Set:'$IsObject(tObject) tObject=##class(HS.Registry.Document.Association).IIDIndexOpen(tAssociation.TargetObject)
				
				If '$IsObject(tObject) Do ..OutputSet.logError("UnresolvedReferenceException","Error","Object not found for "_tAssociation.TargetObject) continue
				If tObject.Status '= tOriginalStatus Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Status does not match expected:"_##class(HS.Types.IHE.Status).LogicalToDisplay(tOriginalStatus)_" found "_tObject.StatusLogicalToDisplay(tObject.Status)) continue
				Set tObject.Status=tNewStatus
				If tObject.%IsA("HS.Registry.Document") {
					Do pSubmission.Documents.Insert(tObject)
					#; if publishing track the original document
					Do:..Publisher]"" ..AddRelatedDocument(tObject),..info("ConvertedRequest").AdditionalInfo.SetAt(1,"UpdateAvailabilityStatus"_tObject.IID)
				} ElseIf tObject.%IsA("HS.Registry.Document.RegistryPackage") {
					Do pSubmission.RegistryPackages.Insert(tObject)
				} ElseIf tObject.%IsA("HS.Registry.Document.Association") {
					#; if target object is a folder or document the folder or document must be the most recent version 4.1.6.4.3.1
					Set tSC = ##class(HS.Registry.Document).ObjectForIIDOfHighestVersion(tObject.TargetObject,.tAssociatedObject)
					If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error",$system.Status.GetErrorText(tSC)) continue
					Set:'$IsObject(tAssociatedObject) tSC = ##class(HS.Registry.Document.RegistryPackage).ObjectForIIDOfHighestVersion(tObject.TargetObject,.tAssociatedObject)
					If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error",$system.Status.GetErrorText(tSC)) continue
					Do pSubmission.Associations.Insert(tObject)
				}
				#; since we've added the item to the submission set we won't want to validate realtionships to it later
				Do pSubmission.AddedItems.SetAt("",tObject.IID)
			} ElseIf tAssociation.AssociationType="Submit" {
				//***todo (4.1.6.4.1.4) 
				/*
				<Association
id=”ID_01” associationType=”urn:ihe:iti:2010:AssociationType:SubmitAssociation” sourceObject=”SubmissionSet”
targetObject=”apnd_assoc”/>
<Association
id=”apnd_assoc” associationType=”urn:ihe:iti:2007:AssociationType:APND” sourceObject=”urn:uuid:8ace0e1c-7dd9-47a0-9e7d-d673beb052e0” targetObject=”urn:uuid:aa0da13b-51b0-4c2e-868c-cef8d7e1bc3d”/>
				
				Set tSC = ##class(HS.Registry.Document).ObjectForIIDOfHighestVersion(tAssociation.TargetObject,.tObject)
				If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error",$system.Status.GetErrorText(tSC)) continue
				Set:'$IsObject(tObject) tSC = ##class(HS.Registry.Document.RegistryPackage).ObjectForIIDOfHighestVersion(tAssociation.TargetObject,.tObject)
				If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error",$system.Status.GetErrorText(tSC)) continue
				*/
			}
		}
	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

/// Transaction is marked as self propagation
Method ValidateAdministratorPropagation(pSubmission As HS.Types.IHE.Submission) As %Status
{
	Quit $$$OK
}

/// typically we'll be responsible for propagating the Documents/Folders and associations related to changes from MetadataUpdate
/// 3.57.4.1.3.1 Common Rules for Metadata Update
/// build array of tObjects(logicaliid)=object logical to handle multiple object updates and maintaining correct relationships - see 3.57.4.1.3.1.1 Rules for Update Planning
Method Propagate(pSubmission As HS.Types.IHE.Submission) As %Status
{
	Set tSC=$$$OK
	try {
		Set tSubmissionSet = ..info("SubmissionSet")
		Set tPropagate=1
		For tSlotIdx=1:1:tSubmissionSet.Slots.Count() {
			Set tSlot=tSubmissionSet.Slots.GetAt(tSlotIdx)
			if tSlot.Name="AssociationPropagation" Set tPropagate=$S($zcvt(tSlot.ValueList.GetAt(1),"l")="no":0,1:1)
		}
		#; typically we'll be responsible for propagating the Documents/Folders and associations - Administrator may do it though
		If 'tPropagate {
			Set tSC = ..ValidateAdministratorPropagation(pSubmission)
			Quit
		}

		#; we only care about specific association types - for instance if a new document version is created,
		#; specifically Transform, append, transformandreplace, signs, build a new association where there is one for one of the types below
		For tIdx=1:1:pSubmission.Documents.Count() {
			Set tDocument = pSubmission.Documents.GetAt(tIdx)
			If tDocument.Status = "Deprecated" {
				/// No need to propagate changes for a deprecated document
				Continue
			}
			/// Find the IID of the document with the highest version for the LogicalID
			Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT top 1 ID from HS_Registry.Document where LogicalIID = ? Order by Version DESC",tDocument.LogicalIID)
			Continue:'tRS.%Next()
			Set tRefDocument = ##class(HS.Registry.Document).%OpenId(tRS.ID)
			Set tObjects(tDocument.LogicalIID)=tDocument
			Set tDocumentIID = tRefDocument.IID
			Kill tAryAssoc
			Do ##class(HS.Registry.Document.Association).IDsForIID(tDocumentIID,.tAryAssoc,"")
			
			#; association could be:
			#; 		Source:Submission Set / Target:Document - ignore
			#; 		Anything else create a new association and mark this one as deprecated
			#; 		But keep track of logical id so that if we have a new object for that logical id we use that
			#;			- this case new document and new XFRM doc, both are replaced (instead of just one)
			Set tAssocID=""
			For  {
				Set tAssocID=$O(tAryAssoc(tAssocID)) Quit:tAssocID=""
				Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssocID)
				If tAssociation.Status'="Approved" Continue
				#; don't care about replacement / submission associations
				If ",Transforms,Appends,TransformsAndReplaces,Signs,IsSnapshotOf,HasMember,"'[(","_tAssociation.AssociationType_",") Continue
				Set tOtherIID = $S(tAssociation.TargetObject=tDocumentIID:tAssociation.SourceObject,1:tAssociation.TargetObject)
				Set tOtherObject = ##class(HS.Registry.Document.RegistryPackage).IIDIndexOpen(tOtherIID)

				If $IsObject(tOtherObject) {
					Continue:tOtherObject.Type="SS"
				} Else {
					Set tOtherObject = ##class(HS.Registry.Document).IIDIndexOpen(tOtherIID)
				}
				Set tObjects(tOtherObject.LogicalIID)=tOtherObject
				Set tSourceObject = $S(tAssociation.TargetObject=tDocumentIID:tOtherObject,1:tDocument)
				Set tTargetObject = $S(tAssociation.TargetObject=tDocumentIID:tDocument,1:tOtherObject)
				Set tAssociation.Status="Deprecated"
				/// need to save because if the association is re-opened we'll lose the status
				Set tSC = tAssociation.%Save()
				If $$$ISERR(tSC) {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error saving association:"_$system.Status.GetErrorText(tSC))
				}
				Set tNewAssociation = tAssociation.%New()
				Set tNewAssociation.Status="Approved"
				Set tNewAssociation.AssociationType=tAssociation.AssociationType
				Set tNewAssociation.IID="urn:uuid:"_$zcvt($System.Util.CreateGUID(),"l")
				Set tNewAssociation.LogicalIID=tNewAssociation.IID
				Set tAryNewAssoc(tSourceObject.LogicalIID,tTargetObject.LogicalIID)=tNewAssociation
			}
		}

		For tIdx=1:1:pSubmission.RegistryPackages.Count() {
			Set tRP = pSubmission.RegistryPackages.GetAt(tIdx)
			Continue:tRP.Type="SS"
			/// Find associations for last version of folder
			Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT top 1 IID from HS_Registry_Document.RegistryPackage where LogicalIID = ? Order by Version DESC",tRP.LogicalIID)
			If tRS.SQLCODE && (tRS.SQLCODE'=100) {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: executing resultset"_tRS.SQLCODE)
				Quit
			}
			Continue:'tRS.%Next()

			Kill tAryAssoc
			Do ##class(HS.Registry.Document.Association).IDsForIID(tRS.IID,.tAryAssoc,"HasMember")
			#; association could be:
			#; 		Submission Set / Document - ignore
			#; 		Anything else create a new association and mark this one as deprecated
			#; 		But keep track of logical id so that if we have a new object for that logical id we use that
			#;			- this case new document and new XFRM doc, both are replaced (instead of just one)
			Set tObjects($S(tRP.LogicalIID="":tRP.IID,1:tRP.LogicalIID))=tRP
			Set tAssocID=""
			For  {
				Set tAssocID=$O(tAryAssoc(tAssocID)) Quit:tAssocID=""
				Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssocID)
				If tAssociation.Status'="Approved" || (tAssociation.AssociationType'="HasMember") || (tAssociation.SourceObject'=tRS.IID) Continue
				Set tAssociation.Status="Deprecated"
				/// need to save because if the association is re-opened we'll lose the status
				Set tSC = tAssociation.%Save()
				If $$$ISERR(tSC) {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error saving association:"_$system.Status.GetErrorText(tSC))
				}
				Set tTargetObject = ##class(HS.Registry.Document).IIDIndexOpen(tAssociation.TargetObject)
				Set tObjects(tTargetObject.LogicalIID)=tTargetObject
				Set tNewAssociation = tAssociation.%New()
				Set tNewAssociation.Status="Approved"
				Set tNewAssociation.AssociationType=tAssociation.AssociationType
				Set tNewAssociation.IID="urn:uuid:"_$zcvt($System.Util.CreateGUID(),"l")
				Set tNewAssociation.LogicalIID=tNewAssociation.IID
				Set tAryNewAssoc(tRP.LogicalIID,tTargetObject.LogicalIID)=tNewAssociation
			}
		}
		Set (tSourceIID,tTargetIID)=""
		For  {
			Set tSourceIID=$o(tAryNewAssoc(tSourceIID)) Quit:tSourceIID=""
			For  {
				Set tTargetIID=$o(tAryNewAssoc(tSourceIID,tTargetIID),1,tAssociation) Quit:tTargetIID=""
				Set tAssociation.SourceObject=tObjects(tSourceIID).IID
				Set tAssociation.TargetObject=tObjects(tTargetIID).IID
				Do pSubmission.Associations.Insert(tAssociation)
				Do pSubmission.AddedItems.SetAt("",tAssociation.IID)
			}
		}
		
	} catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

/// need to move registry packages to either submission sets or folders
Method registerProcess(pSubmission As HS.Types.IHE.Submission) As %Status
{
	Set tSC=$$$OK
	try {
		tstart
		If $g(..info("RequestName"))=$$$XDSbUpdateDocumentSetRequest { Set tSC = ..Propagate(.pSubmission) Quit:$$$ISERR(tSC) }
	
		#; update RegistryPackage type / ensure ExternalIdentifiers correctly point to RegistryPackage
		For tIdx=1:1:pSubmission.RegistryPackages.Count() {
			Set tRP=pSubmission.RegistryPackages.GetAt(tIdx)
			If tRP.Type="F" && (tRP.%Id()="") {
				/// folders need a new version, unless we've added it to the collection to get an updated time (document Replaces/Transforms)
				&sql(select top 1 Version,ID INTO :tVersion,:tID from HS_Registry_Document.RegistryPackage where LogicalIID=:tRP.LogicalIID Order By Version desc)
				If SQLCODE {
					#; first folder
					Set tRP.Version=1
				} Else {
					#; previous version +1
					Set tRP.Version=tVersion+1
					Set tOldRP = tRP.%OpenId(tID)
					Set tOldRP.Status="Deprecated"
					Set tSC = tOldRP.%Save()
					If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to save registry package:"_$system.Status.GetErrorText(tSC))
				}
				Set:(tRP.Status="Submitted"||(tRP.Status="")) tRP.Status="Approved"
			}
			/*  update done in associations 
			ElseIf tRP.Type="F" {
				#; for folders update the lastUpdateTime
				If tRP.Type="F" Do tRP.UpdateTime() 
			}
			*/
			Set:tRP.LogicalIID="" tRP.LogicalIID=tRP.IID
			Set tSC=tRP.%Save()
			If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to save registry package:"_$system.Status.GetErrorText(tSC))
		}

		For tIdx=1:1:pSubmission.Documents.Count() {
			Set tDocument = pSubmission.Documents.GetAt(tIdx)
			Set:tDocument.LogicalIID="" tDocument.LogicalIID=tDocument.IID
			&sql(select top 1 Version,ID INTO :tVersion,:tID from HS_Registry.Document where LogicalIID=:tDocument.LogicalIID Order By Version desc)
			If SQLCODE {
				#; first document
				Set tDocument.Version=1
			} Else {
				#; previous version +1 - unless UpdateDocumentStatus then don't change it
				Set:tDocument.%Id()'=tID tDocument.Version=tVersion+1
			}
			Set:(tDocument.Status="Submitted"||(tDocument.Status="")) tDocument.Status="Approved"

			// Open the original Document from the Registry and add as RelatedDocument
			If $g(..info("RequestName"))=$$$XDSbUpdateDocumentSetRequest {
				Set tOriginalDoc=##class(HS.Registry.Document).%OpenId(tID)
				Do ..AddRelatedDocument(tOriginalDoc)
			}
			
			Set tSC=tDocument.%Save()
			If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to save document"_$system.Status.GetErrorText(tSC)) Continue
			&sql(update HS_Registry.Document Set Status='Deprecated' where Status='Approved' and LogicalIID=:tDocument.LogicalIID and IID<>:tDocument.IID)
		}
		

		/*
			If we see a document in a folder (source:folder / target:document) then grab the ID because we will need to check for
			that association id in the set.
			Folders are in submission sets, update the time if creating a folder
		*/
		For tIdx=1:1:pSubmission.Associations.Count() {
			Set tAssociation=pSubmission.Associations.GetAt(tIdx)
			Set:tAssociation.LogicalIID="" tAssociation.LogicalIID=tAssociation.IID
			Set:tAssociation.Status="" tAssociation.Status="Approved"
			Set tSC=tAssociation.%Save()
			If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to save association:"_tIdx_"  IID:"_pSubmission.Associations.GetAt(tIdx).IID_":"_$system.Status.GetErrorText(tSC))
		}
	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
	}
	If ..OutputSet.Errors.Count() Set tSC=$$$ERROR($$$GeneralError,"Errors reported")
	IF $$$ISERR(tSC) { 
		trollback 
		$$$HSTRACE("Error","tSC",tSC)
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
		Set tSC=$$$OK
	}
	Else {tcommit}
	$$$HSTRACE("outputset","ErrorCount,..OutputSet",..OutputSet.Errors.Count(),..OutputSet)
	Quit tSC
}

/// Update any object id to be a uuid if not already assigned and move classifications from outside reg package to inside
Method registerUpdateUUIDs(pSubmission As HS.Types.IHE.Submission) As %Status
{
	try {
		#; generate uuid's for items that don't have them and build a mapping
		For tItem="Documents","RegistryPackages","Associations","Classifications" {
			Set tCollection = $Method(pSubmission,tItem_"Get")
			For tIdx=1:1:tCollection.Count() {
				Set tObject=tCollection.GetAt(tIdx)
				Set tSC=$$checkid(tObject)
				If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id "_tItem_"["_tIdx_"]"_$system.Status.GetErrorText(tSC))
				#; for these items we have collections of classifications
				If "Documents,RegistryPackages,ExternalIdentifiers,Associations"[tItem {
					#; update any classification id's
					For tIdxC=1:1:tObject.Classifications.Count() {
						Set tSC=$$checkid(tObject.Classifications.GetAt(tIdxC))
						If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id "_tItem_"["_tIdx_"]Classification["_tIdxC_"]"_$system.Status.GetErrorText(tSC))
					}
					If tItem="Documents" || (tItem="RegistryPackages") {
						For tIdxE=1:1:tObject.ExternalIdentifiers.Count() {
							Set tExtIdent = tObject.ExternalIdentifiers.GetAt(tIdxE)
							Set tSC=$$checkid(tExtIdent)
							If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id "_tItem_"["_tIdx_"]ExternalIdentifiers["_tIdxE_"]"_$system.Status.GetErrorText(tSC)) Continue
						}
					}
				}
				If tItem="RegistryPackages" {
					For tProperty = "ContentTypeCode" {
						Set tCode=$property(tObject,tProperty)
						If tCode.Code]"" Set tSC=$$checkid(tCode)
						If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id "_tItem_"["_tIdx_"]"_tProperty_"[1]"_$system.Status.GetErrorText(tSC)) Continue
					}
					For tProperty = "PatientIdentifier","UniqueIdentifier","SourceIdentifier","Node" {
						Set tCode=$property(tObject,tProperty)
						If tCode.Value]"" Set tSC=$$checkid(tCode)
						If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id "_tItem_"["_tIdx_"]"_tProperty_"[1]"_$system.Status.GetErrorText(tSC)) Continue
					}

				}
				If tItem="Documents" {
					For tProperty = "ClassCode","FormatCode","HealthCareFacilityTypeCode","PracticeSettingCode","TypeCode" {
						Set tCode=$property(tObject,tProperty)
						If tCode.Code]"" Set tSC=$$checkid(tCode)
						If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id "_tItem_"["_tIdx_"]"_tProperty_"[1]"_$system.Status.GetErrorText(tSC)) Continue
					}
					For tProperty = "PatientIdentifier","DocumentUniqueIdentifier","SourceIdentifier" {
						Set tCode=$property(tObject,tProperty)
						If tCode.Value]"" Set tSC=$$checkid(tCode)
						If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id "_tItem_"["_tIdx_"]"_tProperty_"[1]"_$system.Status.GetErrorText(tSC)) Continue
					}
					
				}
			}
		}
		#; move classifications from outside registry package to inside
		If pSubmission.Classifications.Count()>0 {
			For tIdx=1:1:pSubmission.Classifications.Count() {
				Set tObject=pSubmission.Classifications.GetAt(tIdx)
				Set tClassifiedObject=tObject.ClassifiedObject
				Set tSC=$$checkid(tClassifiedObject)
				If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to update id Submission Classification["_tIdx_"]"_$system.Status.GetErrorText(tSC)) Continue
				Set tAryCls("ID",tClassifiedObject)=tObject
			}
			For tIdx=pSubmission.RegistryPackages.Count():-1:1 {
				#; move outer classifications to the proper registry package
				Set tIID=pSubmission.RegistryPackages.GetAt(tIdx).IID
				Set tClassification=$g(tAryCls("ID",tIID))
				If $isObject(tClassification) {
					Do pSubmission.RegistryPackages.GetAt(tIdx).Classifications.Insert(tClassification)
					Set tAryCls("ID",tIID,"USED")=""
				}
			}
		}
		#; ensure all classification objects are accounted for
		Set tCO=""
		for {
			Set tCO=$o(tAryCls("ID",tCO)) Quit:tCO=""
			If '$D(tAryCls("ID",tCO,"USED")) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown classification object "_tCO)
		}
	} catch eException {
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
		Set tSC=eException.AsStatus()
	}
	Quit tSC
checkid(tObject) // 
	If '$IsObject(tObject) Quit $$$OK
	Set id=tObject.IID
	If id="" Quit $$$ERROR($$$GeneralError,"ID is null")
	Set tObjectType=tObject.%ClassName(0)
	If id'?1"urn:uuid:"8AN1"-"4AN1"-"4AN1"-"4AN1"-"12AN {
		Set tNewID=$zcvt("urn:uuid:"_$System.Util.CreateGUID(),"l")
		Set ..substitutionAry("ID",id)=tNewID
		Set ..substitutionAry("ID",tNewID)=tNewID
		Set ..substitutionAry("ID",tNewID,"OLD")=id
		Set tObject.IID=tNewID
		If tObjectType["Association,RegistryPackage,Document" Set:tObject.LogicalIID=id tObject.LogicalIID=tNewID
	} Else {
		Set ..substitutionAry("ID",id)=id,tNewID=id
	}
	If tObjectType="Association" {
		Set tObject.SourceObject=$g(..substitutionAry("ID",tObject.SourceObject),tObject.SourceObject)
		Set tObject.TargetObject=$g(..substitutionAry("ID",tObject.TargetObject),tObject.TargetObject)
	} ElseIf "ExternalIdentifier"=tObjectType {
		Set tObject.RegistryObject=$g(..substitutionAry("ID",tObject.RegistryObject),tObject.RegistryObject)
	}
	Set ..substitutionAry("Object",tNewID)=tObject
	Quit $$$OK
}

Method CheckPatientIDs(pSubmission As HS.Types.IHE.Submission, ByRef pPatientID, pValidatePatientId As %Boolean = 1) As %Status
{
	try {
		Set tSC=$$$OK,pPatientID=""
		For tIdx=1:1:pSubmission.RegistryPackages.Count() {
			Set tRP = pSubmission.RegistryPackages.GetAt(tIdx)
			Set tPID=tRP.PatientIDForObject()
			If pPatientID]"" && (tPID '= pPatientID) {
				Do ..OutputSet.logError("XDSPatientIdDoesNotMatch","Error","ID's do not match RP "_pPatientID_"'="_tPID)
			}
			If tPID="" Do ..OutputSet.logError("XDSUnknownPatientId","Error","Patient ID is empty for registry package ["_tIdx_"]")
			Set pPatientID=tPID
		}
		For tIdx=1:1:pSubmission.Documents.Count() {
			Set tDoc = pSubmission.Documents.GetAt(tIdx)
			Set tPID=tDoc.PatientIDForObject()
			If pPatientID]"" && (tPID '= pPatientID) {
				Do ..OutputSet.logError("XDSPatientIdDoesNotMatch","Error","ID's do not match DOC "_pPatientID_"'="_tPID)
			}
			If tPID="" Do ..OutputSet.logError("XDSUnknownPatientId","Error","Patient ID is empty for document ["_tIdx_"]")
			Set pPatientID=tPID
		}
		If pValidatePatientId,..ValidatePatientID { //allows message to turn off validation
			#; check format Table 4.1.3 Rev. 8.0 Final Text 2011-08-11 Page 13
			Set tPatientIDText=pPatientID
			Set tPatientID=$p(tPatientIDText,"^")
			Set tPatientAA = $p($p(tPatientIDText,"^",4),"&",2)
			If (tPatientID_"^^^&"_tPatientAA_"&ISO")'=tPatientIDText {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Poorly formated Patient ID, expected "_(tPatientID_"^^^&"_tPatientAA_"&ISO"))
			}
			If $g(..settings("Connectathon911")),tPatientID=911 {
			} ElseIf ##class(HS.Data.OIDMap).GetCodeForOID(tPatientAA,"")="" {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown Patient domain "_tPatientAA)
			}

			Set:pPatientID]"" tSC=..QueryPatientID(pPatientID)
			If $$$ISERR(tSC) Do ..OutputSet.logError("XDSUnknownPatientId","Error","Patient not found "_tPID) Set tSC=$$$OK  // don't double log errors
		}
		If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
	} Catch eException {
		Set tSC = eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
}

/// since we have the patient registry always, we can query directly
Method QueryPatientID(tPatientID) As %Status
{
	Set tSC=$$$OK
	try {
		Set tID=$p(tPatientID,"^^^",1)
		If $zstrip(tID,"*WC")'=tID Set tSC = $$$ERROR($$$GeneralError,"Patient ID contains invalid characters") Quit
		If tID="" Set tSC = $$$ERROR($$$GeneralError,"Patient ID not found") Quit
		#; connectathon only check
		If $g(..settings("Connectathon911")),tID=911 Quit
		Set tAAoid=$p($p(tPatientID,"^^^",2),"&",2)
		Set tAA=##class(HS.Data.OIDMap).GetCodeForOID(tAAoid)
		#; if no AffinityDomain is defined allow any valid patient id
		If tAA '= $S(..AffinityDomain]"":..AffinityDomain,1:tAA) Set tSC = $$$ERROR($$$GeneralError,"Unknown affinity domain:"_tAA) Quit
		If $e(tPatientID,*-3,*)'="&ISO" Set tSC = $$$ERROR($$$GeneralError,"Badly formatted Patient ID") Quit
		If tAA = $$$AffinityDomain {
			&sql(select ID into :ID from HS_registry.patient where MPIID=:tID)
			If SQLCODE Set tSC=$$$ERROR($$$GeneralError,"XDSUnknownPatientId") 
		} Else {
			&sql(select ID into :ID from HS_registry.patient where MRN=:tID and AssigningAuthority=:tAA)
			If SQLCODE Set tSC=$$$ERROR($$$GeneralError,"XDSUnknownPatientId") 
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

/// / Classification Codes
Method GetFilterCodes(ByRef pFilterCodes) As %Status
{
	Set pFilterCodes("$XDSDocumentEntryPracticeSettingCode")="urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead"
	Set pFilterCodes("$XDSDocumentEntryClassificationNode")="urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1"
	Set pFilterCodes("$XDSDocumentEntryClassCode")="urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a"
	Set pFilterCodes("$XDSDocumentEntryConfidentialityCode")="urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f"
	Set pFilterCodes("$XDSDocumentEntryEventCodeList")="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4"
	Set pFilterCodes("$XDSDocumentEntryFormatCode")="urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d"
	Set pFilterCodes("$XDSDocumentEntryHealthcareFacilityTypeCode")="urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1"
	Set pFilterCodes("$XDSDocumentEntryTypeCode")="urn:uuid:f0306f51-975f-434e-a61c-c59651d33983"
	Quit $$$OK
}

Method FilterDocument(pDocument As HS.Registry.Document, ByRef pQueryParams, ByRef pFilter = 0, ByRef pFilterCodes) As %Status
{
	Try {
		Set tSC=$$$OK,pFilter=0
		If '$d(pFilterCodes) Do ..GetFilterCodes(.pFilterCodes)	
		Kill pQueryParams("$XDSDocumentEntryPatientId")  /// we've already restricted by this 
		Set tAryItem="",tDocumentID=pDocument.%Id(),tDocumentIID=pDocument.IID
		Set tIsOnDemand=(pDocument.ObjectType=$$$XDSbOnDemandDocument)
		For  {
			Set tAnd="",tOr=""
			Set tAryItem=$o(pQueryParams(tAryItem)) Quit:tAryItem=""
			If $e(tAryItem,$l(tAryItem)-5,*)="Scheme" Continue
			If $e(tAryItem,1,5)="Code:" Continue
			If $D(pFilterCodes(tAryItem)) {
				Set tCodedItem=$g(pFilterCodes(tAryItem))
				Set tSC = ..FilterByClassification(tDocumentID,tAryItem,tCodedItem,.pQueryParams,tDocumentIID,.pFilter,pDocument)
				$$$HSTRACE("Checking classification","tDocumentIID,tAryItem,tCodedItem,pQueryParams,pFilter,tSC",tDocumentIID,tAryItem,tCodedItem,..aryToList(.pQueryParams),pFilter,tSC)
			} Else {
				#define paddedVal(%value) $e(%value_"000000000000000",1,14)
				If tAryItem="$XDSDocumentEntryAuthorPerson" {
					Set tSQL="select ID from hs_registry_document.slot_valuelist where slot->classification in (select ID from hs_registry_document.classification where ClassificationScheme='urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d' and document=? )"
					Set tSC=..FilterByAuthor(tDocumentID,tAryItem,tSQL,.pQueryParams,.pFilter)
				} ElseIf tAryItem="$XDSDocumentEntryStatus" {
					Set tSC=..FilterByStatus(pDocument,tAryItem,.pQueryParams,.pFilter)
				} ElseIf tAryItem="$XDSDocumentEntryUniqueId" {
					Set tEUIDx=""
					For  {
						Set tEUIDx=$o(pQueryParams("$XDSDocumentEntryUniqueId",tEUIDx)) Quit:tEUIDx=""
						Set tID="",tOrHave=0
						For  {
							Set tID=$o(pQueryParams("$XDSDocumentEntryUniqueId",tEUIDx,tID)) Quit:tID=""
							If tID=pDocument.DocumentUniqueIdentifier.Value Set tOrHave=1
						}
						If 'tOrHave Set pFilter=1
					}
				} ElseIf tAryItem="$XDSDocumentEntryCreationTimeFrom" {
					If 'tIsOnDemand {
						Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
						Set tStoredValue = pDocument.SlotValueForObject("creationTime")
						//Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameDocument("creationTime",pDocument.%Id())
						If $$$paddedVal(tStoredValue)<=$$$paddedVal(tValue) Set pFilter=1 Quit
					}
				} ElseIf tAryItem="$XDSDocumentEntryCreationTimeTo" {
					If 'tIsOnDemand {
						Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
						Set tStoredValue = pDocument.SlotValueForObject("creationTime")
						//Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameDocument("creationTime",pDocument.%Id())
						If $$$paddedVal(tValue)<=$$$paddedVal(tStoredValue) Set pFilter=1 Quit
					}
				} ElseIf tAryItem="$XDSDocumentEntryServiceStartTimeFrom" {
					Set tStoredValue = pDocument.SlotValueForObject("serviceStartTime")
					If tStoredValue="" Quit
					Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
					//Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameDocument("serviceStartTime",pDocument.%Id())
					If $$$paddedVal(tStoredValue)<$$$paddedVal(tValue) Set pFilter=1 $$$HSTRACE("Filtered "_$$$paddedVal(tStoredValue)_"<"_$$$paddedVal(tValue)) Quit
				} ElseIf tAryItem="$XDSDocumentEntryServiceStartTimeTo" {
					Set tStoredValue = pDocument.SlotValueForObject("serviceStartTime")
					If tStoredValue="" Quit
					Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
					//Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameDocument("serviceStartTime",pDocument.%Id())
					If $$$paddedVal(tValue)<$$$paddedVal(tStoredValue) Set pFilter=1 $$$HSTRACE("Filtered "_$$$paddedVal(tValue)_"<"_$$$paddedVal(tStoredValue)) Quit
				} ElseIf tAryItem="$XDSDocumentEntryServiceStopTimeFrom" {
					Set tStoredValue = pDocument.SlotValueForObject("serviceStopTime")
					If tStoredValue="" Quit
					Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
					//Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameDocument("serviceStopTime",pDocument.%Id())
					If $$$paddedVal(tStoredValue)<$$$paddedVal(tValue) Set pFilter=1 $$$HSTRACE("Filtered "_$$$paddedVal(tStoredValue)_"<"_$$$paddedVal(tValue)) Quit
				} ElseIf tAryItem="$XDSDocumentEntryServiceStopTimeTo" {
					Set tStoredValue = pDocument.SlotValueForObject("serviceStopTime")
					If tStoredValue="" Quit
					Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
					//Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameDocument("serviceStopTime",pDocument.%Id())
					If $$$paddedVal(tValue)<$$$paddedVal(tStoredValue) Set pFilter=1 $$$HSTRACE("Filtered "_$$$paddedVal(tValue)_"<"_$$$paddedVal(tStoredValue)) Quit
				} ElseIf tAryItem="$XDSDocumentEntryType" {
					Set tSC=..FilterByDocumentType(pDocument,tAryItem,.pQueryParams,.pFilter)
				} ElseIf tAryItem="$XDSDocumentEntryDocumentAvailability" {
					Set tCounter=""
					For {
						Set tMatched=0
						Set tCounter=$o(pQueryParams(tAryItem,tCounter)) Quit:tCounter=""
						Set tValue=""
						For  {
							Set tValue=$o(pQueryParams(tAryItem,tCounter,tValue)) Quit:tValue=""
							If pDocument.Availability=$S(tValue["Online":1,1:0) Set tMatched=1
						}
						If 'tMatched Set pFilter=1
					}
				}
			}
			$$$HSTRACE("Checking tAryItem:"_tAryItem,"tDocumentIID,pQueryParams,pFilter,tSC",tDocumentIID,..aryToList(.pQueryParams),pFilter,tSC)
		}
		If ..info("$MetadataLevel")=1 && ('pFilter) && (pDocument.Status = "Deprecated") {
			/// if not the latest version, not already filtered, and metdatalevel is 1 don't return it
			Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select ID from HS_Registry.Document where LogicalIID=? and Version>?",pDocument.LogicalIID,pDocument.Version)
			If tRS.%Next() Set pFilter=1
		}
	} catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
	}
	$$$HSTRACE("Filter document","pDocument,pFilter",pDocument,pFilter)
	Quit tSC
}

/// copy the folder specifications from the target into the source used during a RPLC operation
/// If the Document being replaced is a member of one or more Folders, generate HasMember Associations connecting the replacement Document with each of the Folders holding the original Document. This makes the replacement Document a member of all Folders where the original Document is a member.
Method AddToFolders(pSubmission As HS.Types.IHE.Submission, pTargetObject, pSourceObject) As %Status
{
	//// find all associations where the sourceObject is a folder clone it and assign the new target
	Set tRS=##class(%ResultSet).%New()
	Set tSC=tRS.Prepare("select ID,SourceObject from hs_registry_document.association where targetObject = ? and sourceobject in (select iid from hs_registry_document.registrypackage where type='F')")
	Quit:$$$ISERR(tSC) tSC
	Set tSC=tRS.Execute(pTargetObject) Quit:$$$ISERR(tSC)
	While tRS.%Next() {
		Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tRS.GetData(1))
		Set tClone=tAssociation.%ConstructClone(0)
		Set tClone.IID = $zcvt("urn:uuid:"_$System.Util.CreateGUID(),"l")
		Set tClone.TargetObject=pSourceObject
		Do pSubmission.Associations.Insert(tClone)
		Set tRPID = ##class(HS.Registry.Document.RegistryPackage).ItemForEntryID(tRS.GetData(2),"F")
		Set tRP=##class(HS.Registry.Document.RegistryPackage).%OpenId(tRPID)
		If '$isObject(tRP) {
			Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open folder in AddToFolders:"_tRPID_":"_tRS.GetData(2)_":"_pTargetObject)
			Continue
		}
		#; adding document to folder need to update the folder time
		Set tSC=tRP.UpdateTime()
		#; need to add the folder (tRP) to make sure the update time is saved
		Do pSubmission.RegistryPackages.Insert(tRP)
	}
	Quit tSC
}

Method OnInit() As %Status
{
	#dim tSC As %Status
	#dim eException as %Exception.AbstractException

	Set tSC=$$$OK
	try {
		If (..Transformer="") {
			Set ..Transformer = ##class(HS.Util.XSLTTransformer).%New()
		}
		Set ..settings("ValidateRepository")=+$S(..ValidateRepositoryOID]"":..ValidateRepositoryOID,1:##class(HS.Registry.Config).GetKeyValue("\IHE\XDSb\Registry\ValidateRepositoryOID",0))
		Set ..settings("Connectathon911")=##class(HS.Registry.Config).GetKeyValue("\IHE\XDSb\Registry\AllowConnectathon911",0)
		$$$ThrowOnError(..ValidateCustomProcessor())
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}

Method queryFindDocuments(ByRef pQueryParams) As %Status
{
	Try {
		Set tSC=$$$OK
		#; find documents
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSDocumentEntryPatientId",1,0),
																$lb("$XDSDocumentEntryStatus",1,1),
																$lb("$XDSDocumentEntryClassCode",0,1),
																$lb("$XDSDocumentEntryTypeCode",0,1),
																$lb("$XDSDocumentEntryPracticeSettingCode",0,1),
																$lb("$XDSDocumentEntryCreationTimeFrom",0,0),
																$lb("$XDSDocumentEntryCreationTimeTo",0,0),
																$lb("$XDSDocumentEntryServiceStartTimeFrom",0,0),
																$lb("$XDSDocumentEntryServiceStartTimeTo",0,0),
																$lb("$XDSDocumentEntryServiceStopTimeFrom",0,0),
																$lb("$XDSDocumentEntryServiceStopTimeTo",0,0),
																$lb("$XDSDocumentEntryHealthcareFacilityTypeCode",0,1),
																$lb("$XDSDocumentEntryEventCodeList",0,1),
																$lb("$XDSDocumentEntryConfidentialityCode",0,1),
																$lb("$XDSDocumentEntryAuthorPerson",0,1),
																$lb("$XDSDocumentEntryFormatCode",0,1),
																$lb("$XDSDocumentEntryType",0,1)),
																.tType) {
			Quit
		}
		Do ..documentSQLFromQueryParams(.pQueryParams,.tDocList,.tIIDList)
		If ..OutputSet.Errors.Count() Quit
		$$$HSTRACE("Documents for patient","tDocList,tSC",tDocList,tSC)
		Do ..FilterDocuments(tDocList,tIIDList,.pQueryParams)
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

Method queryFindDocumentsByReferenceId(ByRef pQueryParams) As %Status
{
	Try {
		Set tSC=$$$OK
		#; find documents
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSDocumentEntryPatientId",1,0),
																$lb("$XDSDocumentEntryStatus",1,1),
																$lb("$XDSDocumentEntryReferenceIdList",1,1)),
																.tType) {
			Quit
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	If ..OutputSet.Errors.Count() Quit tSC
	Quit ..queryFindDocuments(.pQueryParams)
}

Method FilterDocuments(pDocList, pIIDList, ByRef pQueryParams)
{
	Set tIID=""
	#; no other query parameters and just an objectref list return the list.  If MetadataLevel=1 can't automatically include the reference
	#; might need to remove due to document availability but we need to open the document to determine that
	$$$HSTRACE("Filter documents","pQueryParams",..aryToList(.pQueryParams))
	If ($O(pQueryParams(""))="") && (..info("$MetadataLevel")'=1)  && (..QueryReturnType="ObjectRef") {
		For tIdx=1:1:$ll(pIIDList) { Do ..OutputSet.ObjectRefs.Insert($li(pIIDList,tIdx))}
		Quit
	}
	For tDocIdx=1:1:$ll(pDocList) {
		Set tID = $li(pDocList,tDocIdx)
		Set tDocument = ##class(HS.Registry.Document).%OpenId(tID)
		If '$IsObject(tDocument) {
			If ##class(HS.Registry.Document).%ExistsId(tID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open document:"_tID)
			#; could be object has been deleted between query and open
			Continue
		}
		If ..info("$MetadataLevel")=1 && (tDocument.Availability]"" && 'tDocument.Availability) Continue
		Set pQueryParams=1
		Set tSC = ..FilterDocument(tDocument,.pQueryParams,.tFilter,.tFilterCodes)  /// check for error
		Do:'tFilter ..AddToOutputSet(tDocument)
	}
}

/// Export document or object to DocumentsStream
Method AddToOutputSet(pDocument = "", pRegistryPackage = "", pAssociation = "") As %Status
{
	try {
		Set tSC=$$$OK
		#; always add object to ObjectRefs if not objectref return type add object to output stream
		If $isObject(pDocument) {
			Do ..OutputSet.ObjectRefs.Insert(pDocument.IID)
			Do:..QueryReturnType="LeafClass" pDocument.XMLExportToStream(..OutputSet.DocumentsStream)
		}
		If $isObject(pRegistryPackage) {
			Do ..OutputSet.ObjectRefs.Insert(pRegistryPackage.IID)
			Do:..QueryReturnType="LeafClass" pRegistryPackage.XMLExportToStream(..OutputSet.RegistryPackagesStream)
		}
		If $isObject(pAssociation) {
			Do ..OutputSet.ObjectRefs.Insert(pAssociation.IID)
			Do:..QueryReturnType="LeafClass" pAssociation.XMLExportToStream(..OutputSet.AssociationsStream)
		}

	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Build query based on pQueryParams, returning pDocList and pIIDS for further processing
/// If the basic criteria return more than QueryMaxRows{type} return an error.  The only issue being that the EventCodeList 
/// could reduce the number but due to query performance we won't check the EventCodeList if the other criteria exceeds the QueryMaxRows{type}
Method olddocumentSQLFromQueryParams(ByRef pQueryParams, ByRef pDocList, ByRef pIIDS) As %Status
{
	#define paddedVal(%value) $e(%value_"000000000000000",1,14)
	Set tMAX=100
	Set:..QueryReturnType]"" tMAX=$property($this,"QueryMaxRows"_..QueryReturnType)
	try {
		Set tSC=$$$OK
		Set pIIDS="",pDocList="",tSQLAND="",tSQLOR=""
		Set tSQL($I(tSQL))="SELECT Top("_(tMAX+1)_") ID,IID,Count(*) as C FROM HS_Registry.Document WHERE "
		For tItem="V||$XDSDocumentEntryPatientId","VS||$XDSDocumentEntryFormatCode","VS||$XDSDocumentEntryClassCode","VS||$XDSDocumentEntryHealthcareFacilityTypeCode","V||$XDSDocumentEntryStatus","VS||$XDSDocumentEntryTypeCode","VS||$XDSDocumentEntryPracticeSettingCode","V||$XDSDocumentEntryCreationTimeFrom||CreationTime","V||$XDSDocumentEntryCreationTimeTo||CreationTime","V||$XDSDocumentEntryType||ObjectType","V||$XDSDocumentEntryServiceStartTimeFrom||ServiceStartTime","V||$XDSDocumentEntryServiceStartTimeTo||ServiceStartTime" {
			Set tIsValue=($p(tItem,"||",1)="V"),tNode=$p(tItem,"||",2),tField=$p(tItem,"||",3) Set:tField="" tField=$p(tNode,"$XDSDocumentEntry",2)
			If $d(pQueryParams(tNode)) {
				Set tIdx="",tCount=0,tSQLNode=""
				For  {
					Set tIdx=$o(pQueryParams(tNode,tIdx)) Quit:tIdx=""
					Set tValue="" 
					Set tSQL($I(tSQL))=tSQLAND,tSQLAND=" AND ",tSQLOR="",tSQLNode=""
					For {
						Set tValue=$o(pQueryParams(tNode,tIdx,tValue)) Quit:tValue=""
						If 'tIsValue {
							#; not a value but instead a code^^scheme
							Set tValueCode=$p(tValue,"^")
							Set tValueScheme=$p(tValue,"^",3)
							If (tValueCode="") || (tValueScheme="") {
								Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
								Quit
							}
							Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
							// EventCodeList kills performance do it separately
							Set tSQLNode=tSQLNode_tSQLOR_" ("_tField_"_Code"_tEval_"? AND "_tField_"_CodingScheme=?)",tParams($i(tParams))=$tr(tValueCode,"_","%"),tParams($i(tParams))=tValueScheme,tSQLOR=" OR "
						} Else {
							#; a single value (NOT a code^^scheme)
							Set tEval="="
							Set tQueryValue=tValue
							If tNode="$XDSDocumentEntryStatus" {
								Set tQueryValue=$p(tValue,":",$l(tValue,":"))
							} ElseIf tNode="$XDSDocumentEntryCreationTimeFrom" {
								Set tEval=">=",tQueryValue=$$$paddedVal(tValue)
							} ElseIf tNode="$XDSDocumentEntryCreationTimeTo" {
								Set tEval="<=",tQueryValue=$$$paddedVal(tValue)
							} ElseIf tNode="$XDSDocumentEntryServiceStartTimeTo"||(tNode="$XDSDocumentEntryServiceStartTimeFrom") {
								#; ServiceStartTimes can be shortened so use the extract to compare
								Set tEval=$S(tNode="$XDSDocumentEntryServiceStartTimeTo":"<=",1:">=")
								Set tSQLNode=tSQLNode_tSQLOR_" ServiceStartTime"_tEval_"$EXTRACT(?,1,$LENGTH(ServiceStartTime))",tParams($i(tParams))=$$$paddedVal(tValue),tSQLOR=" OR "
								Continue
							}
							Set tSQLNode=tSQLNode_tSQLOR_" "_tField_tEval_"?",tParams($i(tParams))=tQueryValue,tSQLOR=" OR "
						}
					}
					Set tSQL($I(tSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
				}
				Kill pQueryParams(tNode)
	
			} 
		}
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,.tSQL,tParams...)
		If tRS.SQLCODE&&(tRS.SQLCODE'=100) {
			Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: executing resultset"_tRS.SQLCODE)
			Quit
		}
		Set tIIDS="",tDocList=""
		While tRS.%Next() {
			If tRS.C>tMAX {
				Do ..OutputSet.logError("XDSTooManyResults","Error","Refine criteria or increase QueryMaxRows"_..QueryReturnType) Quit
			}
			Set tIIDS=tIIDS_$lb(tRS.IID)
			Set tDocList=tDocList_$lb(tRS.ID)
		}


		/// Calculate DocumentEntryEventCodeList if there are any parameters 
		If $ll(tIIDS)&&($D(pQueryParams("$XDSDocumentEntryEventCodeList"))) {
			Kill tSQL,tParams
			Set tSQLAND="",tSQLOR=""
			Set tSQL($I(tSQL))="SELECT slot->classification->classifiedObject as IID FROM HS_Registry_Document.Slot_valuelist WHERE slot->classification->classificationscheme='urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4' AND"
			For tItem="VS||$XDSDocumentEntryEventCodeList" {
				Set tIsValue=($p(tItem,"||",1)="V"),tNode=$p(tItem,"||",2),tField=$p(tItem,"||",3) Set:tField="" tField=$p(tNode,"$XDSDocumentEntry",2)
				If $d(pQueryParams(tNode)) {
					Set tIdx="",tCount=0,tSQLNode=""
					For  {
						Set tIdx=$o(pQueryParams(tNode,tIdx)) Quit:tIdx=""
						Set tValue="" 
						Set tSQL($I(tSQL))=tSQLAND,tSQLAND=" AND ",tSQLOR="",tSQLNode=""
						For {
							Set tValue=$o(pQueryParams(tNode,tIdx,tValue)) Quit:tValue=""
							#; not a value but instead a code^^scheme
							Set tValueCode=$p(tValue,"^")
							Set tValueScheme=$p(tValue,"^",3)
							If (tValueCode="") || (tValueScheme="") {
								Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
								Quit
							}
							Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
							Set tSQLNode=tSQLNode_tSQLOR_" ( slot->classification->noderepresentation"_tEval_"? AND valuelist=? AND slot->classification->classifiedObject %INLIST ?)",tParams($i(tParams))=$tr(tValueCode,"_","%"),tParams($i(tParams))=tValueScheme,tParams($i(tParams))=tIIDS,tSQLOR=" OR "
						}
						Set tSQL($I(tSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
					}
					Kill pQueryParams(tNode)
		
				} 
			}

			Set tRS = ##class(%SQL.Statement).%ExecDirect(,.tSQL,tParams...)
			If tRS.SQLCODE&&(tRS.SQLCODE'=100) {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: executing resultset"_tRS.SQLCODE)
				Quit
			}
			Set tTemp="^[""^""]HS.RegistryFindMP" Kill @tTemp@("Docs") 
			For tIdx=1:1:$ll(tIIDS) {
				Set @tTemp@("Docs",$li(tIIDS,tIdx))=$li(tDocList,tIdx)
			}
			For {
				Quit:'tRS.%Next()
				Set pIIDS=pIIDS_$lb(tRS.IID)
				Set pDocList=pDocList_$lb(@tTemp@("Docs",tRS.IID))
			}
			Kill @tTemp@("Docs") 
		} Else {
			#; no EventCodeList items return top
			Set pIIDS=tIIDS,pDocList=tDocList
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error:"_$ze)
	}
	Quit tSC
}

/// rewritten to handle large systems executing multipatient queries.  Query bitmap indexed fields and using the count (if too high) query dates to try to reduce the number.<br>
/// The example was 63 million rows in bitmapped fields, and thousands in the creationtime span specified which intersected with 1340 rows.  Query the date spans into a temp table
/// and delete the rows from the temp table where they are not in the bitmapped rows, then add the id's in the temp table as a condition when checking the remainder of the query paramters.
Method documentSQLFromQueryParams(ByRef pQueryParams, ByRef pDocList = "", ByRef pIIDS = "") As %Status
{
	#define RSCheck(%RS) If %RS.SQLCODE&&(%RS.SQLCODE'=100) { Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: executing resultset:"_%RS.SQLCODE) $$$HSTRACE("ResultSetError","tRS",%RS.SQLCODE) Return $$$OK }
	try {
		Set tSC=$$$OK
		Merge tQueryParams = pQueryParams
		/// bitmapped fields
		Set tListBitmapFields=$lb(
			$lb("","V","$XDSDocumentEntryPatientId"),
			$lb("","V","$XDSDocumentEntryUniqueId","DocumentUniqueIdentifier_Value"),
			$lb("NoIndex","VS","$XDSDocumentEntryFormatCode"),
			$lb("NoIndex","VS","$XDSDocumentEntryClassCode"),
			$lb("NoIndex","VS","$XDSDocumentEntryHealthcareFacilityTypeCode"),
			$lb("NoIndex","V","$XDSDocumentEntryStatus"),
			$lb("NoIndex","VS","$XDSDocumentEntryTypeCode"),
			$lb("NoIndex","VS","$XDSDocumentEntryPracticeSettingCode"),
			$lb("NoIndex","V","$XDSDocumentEntryType","ObjectType")
			)

		Set tListFields=tListBitmapFields
		Set tOnDemand = 0
		Set tCount = ""
		For {
			Set tCount=$O(pQueryParams("$XDSDocumentEntryType",tCount)) Quit:tCount=""
			If $D(pQueryParams("$XDSDocumentEntryType",tCount,"urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248")) Set tOnDemand=1 Quit
		}
			
		Set tMaxCount=100
		Set:..QueryReturnType]"" tMaxCount=$property($this,"QueryMaxRows"_..QueryReturnType)
		Set tMaxCountDates=..QueryMaxCountDateParam
		
		Do ..documentBuildSQL(tListFields,.tQueryParams,.tNoIndex,.tSQL,.tParams,tMaxCount)
		Merge tSQLCount=tSQL
		Set tSQLCount(1)="SELECT *,Count(*) C from ("_tSQLCount(1),tSQLCount(tSQLCount)=tSQLCount(tSQLCount)_")"
		
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,.tSQLCount,tParams...)
		$$$RSCheck(tRS)
		If 'tRS.%Next() { Quit }  /// no results
		Set tDatesSQL=""
		
		If (tRS.C>..QueryMaxCountBitmapParam) {
			$$$HSTRACE("Bitmapped fields","count,QueryMaxCountBitmapParam,tSQL,tParams,tQueryParams,pQueryParams",tRS.C,..QueryMaxCountBitmapParam,..aryToList(.tSQL,1),..aryToList(.tParams),..aryToList(.tQueryParams),..aryToList(.pQueryParams))
			Set tNoIndex=" %NOINDEX "
			Kill tSQL,tParams
			Merge tQueryParams = pQueryParams
			If 'tOnDemand {
				/// if OnDemand you can't query by CreationTime
				Set tDateFields=$lb(
					$lb("","V","$XDSDocumentEntryCreationTimeFrom","CreationTime"),
					$lb("","V","$XDSDocumentEntryCreationTimeTo","CreationTime")
					)
				// insert top(tMaxCountDates) documents into temp table based on date range creation / service
				Do ..documentBuildSQL(tDateFields,.tQueryParams,.tNoIndex,.tSQLDates,.tSQLParamsDates,tMaxCountDates,"INSERT INTO HS_Registry_Document.TempQueryTable (DocumentID,DocumentIID) ")
			}
			If '$D(tSQLParamsDates) {
				/// Likely no date criteria
				Do ..OutputSet.logError("XDSTooManyResults","Error","Refine criteria. Try using date ranges.")
				Quit
			} Else {
				/// Have date criteria, get the first (tMaxCountDates+1) rows
				Do ##class(HS.Registry.Document.TempQueryTable).%KillExtent()
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,.tSQLDates,tSQLParamsDates...)
				$$$RSCheck(tRS)
				$$$HSTRACE("temp table","tSQLDates,tSQLParamsDates",..aryToList(.tSQLDates,1),..aryToList(.tSQLParamsDates))
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT Count(*) C from HS_Registry_Document.TempQueryTable")
				$$$RSCheck(tRS)
				If 'tRS.%Next()||(tRS.C=0) {
					$$$HSTRACE("Date parameters returned no results")
					Quit
				}
				//If we have More than MaxCountDates (with the +1) then there are rows we are not include and we need to bail
				If tRS.C>$G(tMaxCountDates) {
					Do ..OutputSet.logError("XDSTooManyResults","Error","Refine criteria.  Try a smaller date span.")
					Quit
				}
				Set tDatesSQL=" ID IN (SELECT DocumentID FROM HS_Registry_Document.TempQueryTable)"

				If (..TraceOperations'="") {
					/// if tracing log the count
					Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT Count(*) C from HS_Registry_Document.TempQueryTable") do tRS.%Next()
					$$$HSTRACE("Temp table count","count",tRS.C)
				}
				/// Remove any ID from the temp table that is not in the original bitmap query
				Kill tSQLD
				Set tSQLAND=""
				Set tSQLD($i(tSQLD))="Delete FROM HS_Registry_Document.TempQueryTable where not ID in ("
				Set tSQLD($I(tSQLD))="SELECT ID FROM HS_Registry.Document WHERE "
				
				Do ..documentBuildSQL(tListBitmapFields,.tQueryParams,"",.tSQLD,.tParamsD,tMaxCount) 
				Set tSQLD($i(tSQLD))=")"
				$$$HSTRACE("delete","tSQLD,tParamsD",..aryToList(.tSQLD,1),..aryToList(.tParamsD))
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,.tSQLD,tParamsD...)
				$$$RSCheck(tRS)
				Do tRS.%Next()
				If ..TraceOperations'="" {
					/// if tracing log the count
					Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT Count(*) C from HS_Registry_Document.TempQueryTable") do tRS.%Next()
					$$$HSTRACE("Temp table count","count",tRS.C)
				}
			}
			
		} Else {
			/// first query is good just add additional fields
			Set tListFields=""
		}
		If tDatesSQL="" && 'tOnDemand {
			// can't include ServiceStart/ServiceStop times as documents are not required to have them and not excluded based on null values
			Set tListFields=tListFields_$lb(
				$lb("","V","$XDSDocumentEntryCreationTimeFrom","CreationTime"),
				$lb("","V","$XDSDocumentEntryCreationTimeTo","CreationTime")
				)
		}
		Do ..documentBuildSQL(tListFields,.tQueryParams,.tNoIndex,.tSQL,.tParams,tMaxCount)
		If tDatesSQL]"" {
			If '$G(tParams) {
				Set tDatesSQL="WHERE "_tDatesSQL
			} Else {
				Set tDatesSQL="AND "_tDatesSQL
			}
			Set tSQL($i(tSQL))=tDatesSQL
		}
		///
		Do ..addClassification("$XDSDocumentEntryEventCodeList","urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4",.tQueryParams,.tSQL,.tParams)
		Do ..addClassification("$XDSDocumentEntryClassificationNode","urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1",.tQueryParams,.tSQL,.tParams)
		Do ..addClassification("$XDSDocumentEntryConfidentialityCode","urn:uuid:f4f85eac-e6cb-4883-b524-f2705394840f",.tQueryParams,.tSQL,.tParams)
		Do ..addClassificationDocumentAuthorPerson("$XDSDocumentEntryAuthorPerson","urn:uuid:93606bcf-9494-43ec-9b4e-a7748d1a838d",.tQueryParams,.tSQL,.tParams)
		
		Do ..addCustomSlots(.tQueryParams,.tSQL,.tParams)
		Do ..addReferenceByIdList(.tQueryParams,.tSQL,.tParams)
		$$$HSTRACE("Query Evaluation","tSQL,tParams,tQueryParams,pQueryParams",..aryToList(.tSQL,1),..aryToList(.tParams),..aryToList(.tQueryParams),..aryToList(.pQueryParams))	
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,.tSQL,tParams...)
		$$$RSCheck(tRS)	
		Set tCount=0
		While tRS.%Next() {
			If $i(tCount)>tMaxCount {
				Set (pIIDS,pDocList)=""
				Do ..OutputSet.logError("XDSTooManyResults","Error","Refine criteria or increase QueryMaxRows"_..QueryReturnType) 
				Quit
			}
			Set pIIDS=pIIDS_$lb(tRS.IID)
			Set pDocList=pDocList_$lb(tRS.ID)
		}
	} catch ex {
		Set tSC=ex.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Do ##class(HS.Registry.Document.TempQueryTable).%KillExtent()
	Kill pQueryParams Merge pQueryParams=tQueryParams
	Quit tSC
}

/// Additional sql for filtering custom slots
Method addCustomSlots(pQueryParams, ByRef pSQL, ByRef pParams)
{
	Set tNode="$XDSDocumentEntryCustomSlot"
	Quit:'$D(pQueryParams(tNode))
	Set tSQLAND="",tSQLOR=""
	Set pSQL($I(pSQL))="AND ID IN (SELECT slot->document FROM HS_Registry_Document.Slot_valuelist WHERE "
	Set tIdx="",tSQLNode=""
	For  {
		Set tIdx=$o(pQueryParams(tNode,tIdx)) Quit:tIdx=""
		Set tValue="" 
		Set:tSQLAND]"" pSQL($I(pSQL))=tSQLAND
		Set tSQLAND=" AND ",tSQLOR="",tSQLNode=""
		For {
			Set tValue=$o(pQueryParams(tNode,tIdx,tValue)) Quit:tValue=""
			#; not a value but instead a code^^scheme
			Set tSlotName=$p(tValue,"^")
			Set tSlotValue=$p(tValue,"^",3,99999)
			If (tSlotName="") || (tSlotValue="") {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown slot name/value pair for "_tValue)
				Quit
			}
			Set tEval="=" If tSlotValue["%" || (tSlotValue["_") Set tEval=" LIKE "
			Set tSQLNode=tSQLNode_tSQLOR_" ( slot->name=? AND valuelist"_tEval_"?)",pParams($i(pParams))=tSlotName,pParams($i(pParams))=$tr(tSlotValue,"_","%"),tSQLOR=" OR "
		}
		Set pSQL($I(pSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
	}
	Set pSQL(pSQL)=pSQL(pSQL)_")"  /// add trailing ) for the IN clause
	Kill pQueryParams(tNode)
	Quit $$$OK
}

/// Additional sql for filtering referenceidlist slots
Method addReferenceByIdList(pQueryParams, ByRef pSQL, ByRef pParams)
{
	Set tNode="$XDSDocumentEntryReferenceIdList"
	Quit:'$D(pQueryParams(tNode))
	Set tSQLAND="",tSQLOR="",tSlotName="urn:ihe:iti:xds:2013:referenceIdList"
	Set pSQL($I(pSQL))="AND ID IN (SELECT slot->document FROM HS_Registry_Document.Slot_valuelist WHERE "
	Set tIdx="",tSQLNode=""
	For  {
		Set tIdx=$o(pQueryParams(tNode,tIdx)) Quit:tIdx=""
		Set tValue="" 
		Set:tSQLAND]"" pSQL($I(pSQL))=tSQLAND
		Set tSQLAND=" AND ",tSQLOR="",tSQLNode=""
		For {
			Set tValue=$o(pQueryParams(tNode,tIdx,tValue)) Quit:tValue=""
			#; not a value but instead a code^^scheme
			Set tSlotValue=tValue
			If (tSlotValue="") {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown slot value for ReferenceIdList")
				Quit
			}
			Set tEval="=" If tSlotValue["%" || (tSlotValue["_") Set tEval=" LIKE "
			Set tSQLNode=tSQLNode_tSQLOR_" ( slot->name=? AND valuelist"_tEval_"?)",pParams($i(pParams))=tSlotName,pParams($i(pParams))=$tr(tSlotValue,"_","%"),tSQLOR=" OR "
		}
		Set pSQL($I(pSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
	}
	Set pSQL(pSQL)=pSQL(pSQL)_")"  /// add trailing ) for the IN clause
	Kill pQueryParams(tNode)
	Quit $$$OK
}

/// Additional SQL for classification
Method addClassification(pNode, pScheme, pQueryParams, ByRef pSQL, ByRef pParams)
{
	Quit:'$D(pQueryParams(pNode))
	Set tSQLAND="",tSQLOR=""
	Set pParams($i(pParams))=pScheme
	Set pSQL($I(pSQL))="AND ID IN (SELECT slot->classification->document FROM HS_Registry_Document.Slot_valuelist WHERE %NOINDEX slot->classification->classificationscheme=? AND"
	Set tIdx="",tSQLNode=""
	For  {
		Set tIdx=$o(pQueryParams(pNode,tIdx)) Quit:tIdx=""
		Set tValue="" 
		Set:tSQLAND]"" pSQL($I(pSQL))=tSQLAND
		Set tSQLAND=" AND ",tSQLOR="",tSQLNode=""
		For {
			Set tValue=$o(pQueryParams(pNode,tIdx,tValue)) Quit:tValue=""
			#; not a value but instead a code^^scheme
			Set tValueCode=$p(tValue,"^")
			Set tValueScheme=$p(tValue,"^",3)
			If (tValueCode="") || (tValueScheme="") {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
				Quit
			}
			Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
			Set tSQLNode=tSQLNode_tSQLOR_" ( slot->classification->noderepresentation"_tEval_"? AND valuelist=?)",pParams($i(pParams))=$tr(tValueCode,"_","%"),pParams($i(pParams))=tValueScheme,tSQLOR=" OR "
		}
		Set pSQL($I(pSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
	}
	Set pSQL(pSQL)=pSQL(pSQL)_")"  /// add trailing ) for the IN clause
	Kill pQueryParams(pNode)
	Quit $$$OK
}

/// Additional SQL for classification
Method addClassificationDocumentAuthorPerson(pNode, pScheme, pQueryParams, ByRef pSQL, ByRef pParams)
{
	Quit:'$D(pQueryParams(pNode))
	Set tSQLAND="",tSQLOR=""
	Set pParams($i(pParams))=pScheme
	Set pSQL($I(pSQL))="AND ID IN (SELECT slot->classification->document FROM HS_Registry_Document.Slot_valuelist WHERE %NOINDEX slot->classification->classificationscheme=? AND"
	Set tIdx="",tSQLNode=""
	For  {
		Set tIdx=$o(pQueryParams(pNode,tIdx)) Quit:tIdx=""
		Set tValue="" 
		Set:tSQLAND]"" pSQL($I(pSQL))=tSQLAND
		Set tSQLAND=" AND ",tSQLOR="",tSQLNode=""
		For {
			Set tValue=$o(pQueryParams(pNode,tIdx,tValue)) Quit:tValue=""
			#; not a code^^scheme but a value
			Set tValueCode=tValue
			If (tValueCode="") {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
				Quit
			}
			Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
			Set tSQLNode=tSQLNode_tSQLOR_" ( valuelist "_tEval_"? )",pParams($i(pParams))=$tr(tValueCode,"_","%"),tSQLOR=" OR "
		}
		Set pSQL($I(pSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
	}
	Set pSQL(pSQL)=pSQL(pSQL)_")"  /// add trailing ) for the IN clause
	Kill pQueryParams(pNode)
	Quit $$$OK
}

/// Build query based on pQueryParams, returning pDocList and pIIDS for further processing
/// If the basic criteria return more than QueryMaxRows{type} return an error.  The only issue being that the EventCodeList 
/// could reduce the number but due to query performance we won't check the EventCodeList if the other criteria exceeds the QueryMaxRows{type}
Method documentBuildSQL(pListFields As %String, ByRef pQueryParams, Output pNoIndex, Output pSQL, Output pParams, pMaxCount, pInto = "") As %Status
{
	#define paddedVal(%value) $e(%value_"000000000000000",1,14)
	try {
		Set tSC=$$$OK
		Set tCheckCount='$D(pNoIndex)
		Set tSQLCount=$S(tCheckCount:",Count(*) as C",1:"")
		Set pIIDS="",pDocList="",tSQLAND=$S($G(pParams):" AND ",1:""),tSQLOR="",tSQLWHERE=""
		If '$G(pSQL) {
			Set pSQL($I(pSQL))=pInto_"SELECT Top("_(pMaxCount+1)_") ID,IID FROM HS_Registry.Document",tSQLWHERE=" WHERE "
		}
		For tItemIdx=1:1:$ll(pListFields) {
			Set tItem=$li(pListFields,tItemIdx)
			Set tIsValue=($li(tItem,2)="V"),tNode=$li(tItem,3),tField=$lg(tItem,4) Set:tField="" tField=$p(tNode,"$XDSDocumentEntry",2)
			Set tNoIndex=$S(($g(pNoIndex)]""&&($li(tItem)]"")):" %NOINDEX ",1:"")
			If $d(pQueryParams(tNode)) {
				Set tIdx="",tCount=0,tSQLNode=""
				For  {
					Set tIdx=$o(pQueryParams(tNode,tIdx)) Quit:tIdx=""
					Set tValue="" 
					Set pSQL($I(pSQL))=tSQLWHERE_tSQLAND,tSQLAND=" AND ",tSQLOR="",tSQLNode="",tSQLWHERE=""
					For {
						Set tValue=$o(pQueryParams(tNode,tIdx,tValue)) Quit:tValue=""
						If 'tIsValue {
							#; not a value but instead a code^^scheme
							Set tValueCode=$p(tValue,"^")
							Set tValueScheme=$p(tValue,"^",3)
							If (tValueCode="") || (tValueScheme="") {
								Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
								Quit
							}
							Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
							// EventCodeList kills performance do it separately
							Set tSQLNode=tSQLNode_tSQLOR_" ("_tNoIndex_tField_"_Code"_tEval_"? AND "_tNoIndex_tField_"_CodingScheme=?)",pParams($i(pParams))=$tr(tValueCode,"_","%"),pParams($i(pParams))=tValueScheme,tSQLOR=" OR "
						} Else {
							#; a single value (NOT a code^^scheme)
							Set tEval="="
							Set tQueryValue=tValue
							If tNode="$XDSDocumentEntryStatus" {
								Set tQueryValue=$p(tValue,":",$l(tValue,":"))
							} ElseIf tNode="$XDSDocumentEntryCreationTimeFrom" {
								Set tEval=">=",tQueryValue=$$$paddedVal(tValue)
							} ElseIf tNode="$XDSDocumentEntryCreationTimeTo" {
								Set tEval="<=",tQueryValue=$$$paddedVal(tValue)
							} ElseIf tNode="$XDSDocumentEntryServiceStartTimeTo"||(tNode="$XDSDocumentEntryServiceStartTimeFrom") {
								#; ServiceStartTimes can be shortened so use the extract to compare
								Set tEval=$S(tNode="$XDSDocumentEntryServiceStartTimeTo":"<=",1:">=")
								Set tSQLNode=tSQLNode_tSQLOR_" ServiceStartTime"_tEval_"$EXTRACT(?,1,$LENGTH(ServiceStartTime))",pParams($i(pParams))=$$$paddedVal(tValue),tSQLOR=" OR "
								Continue
							}
							Set tSQLNode=tSQLNode_tSQLOR_" "_tNoIndex_tField_tEval_"?",pParams($i(pParams))=tQueryValue,tSQLOR=" OR "
						}
					}
					Set pSQL($I(pSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
				}
				Kill pQueryParams(tNode)
	
			} 
		}
		$$$HSTRACE("Query","pSQL,pParams",..aryToList(.pSQL,1),..aryToList(.pParams))
	} Catch eException {
		Set tSC=eException.AsStatus()  break
		Do:$isObject(..OutputSet) ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// Same as Find Documents except may have 0 -> many Patient ID's
/// Must have one of ClassCode, EventCodeList, HealthcareFacilityTypeCode specified returns XDSDocumentEntry or ObjectRef
Method queryFindDocumentsMultiPatients(ByRef pQueryParams) As %Status
{
	Try {
		Set tSC=$$$OK
		#; find documents
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSDocumentEntryPatientId",0,1),
																$lb("$XDSDocumentEntryStatus",1,1),
																$lb("$XDSDocumentEntryClassCode",0,1),
																$lb("$XDSDocumentEntryTypeCode",0,1),
																$lb("$XDSDocumentEntryPracticeSettingCode",0,1),
																$lb("$XDSDocumentEntryCreationTimeFrom",0,0),
																$lb("$XDSDocumentEntryCreationTimeTo",0,0),
																$lb("$XDSDocumentEntryServiceStartTimeFrom",0,0),
																$lb("$XDSDocumentEntryServiceStartTimeTo",0,0),
																$lb("$XDSDocumentEntryServiceStopTimeFrom",0,0),
																$lb("$XDSDocumentEntryServiceStopTimeTo",0,0),
																$lb("$XDSDocumentEntryHealthcareFacilityTypeCode",0,1),
																$lb("$XDSDocumentEntryEventCodeList",0,1),
																$lb("$XDSDocumentEntryConfidentialityCode",0,1),
																$lb("$XDSDocumentEntryAuthorPerson",0,1),
																$lb("$XDSDocumentEntryFormatCode",0,1),
																$lb("$XDSDocumentEntryType",0,1)),
															.tType) {
			Quit
		}
		If '($D(pQueryParams("$XDSDocumentEntryEventCodeList")) || $D(pQueryParams("$XDSDocumentEntryClassCode")) || 
				$D(pQueryParams("$XDSDocumentEntryHealthcareFacilityTypeCode"))) {
					Do ..OutputSet.logError("XDSStoredQueryMissingParam","Error","One of $XDSDocumentEntryEventCodeList, $XDSDocumentEntryClassCode, or $XDSDocumentEntryHealthcareFacilityTypeCode must be specified") 
					Quit
		} 
		Do ..documentSQLFromQueryParams(.pQueryParams,.tDocList,.tIIDList)
		If ..OutputSet.Errors.Count() Quit
		$$$HSTRACE("Evaluation values","pQueryParams",..aryToList(.pQueryParams))
		Do ..FilterDocuments(tDocList,tIIDList,.pQueryParams)
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do:$isObject(..OutputSet) ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

Method queryFindSubmissionSets(ByRef pQueryParams) As %Status
{
	Try {
		#; find submission sets
		Set tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSSubmissionSetPatientId",1,0),
																$lb("$XDSSubmissionSetSourceId",0,1),
																$lb("$XDSSubmissionSetSubmissionTimeFrom",0,0),
																$lb("$XDSSubmissionSetSubmissionTimeTo",0,0),
																$lb("$XDSSubmissionSetAuthorPerson",0,0),
																$lb("$XDSSubmissionSetContentType",0,1),
																$lb("$XDSSubmissionSetStatus",1,1)),
															.tType) {
			Quit
		}

 

		Set tIdx=$o(pQueryParams("$XDSSubmissionSetPatientId",""))
		Set tPatientID=$o(pQueryParams("$XDSSubmissionSetPatientId",tIdx,""))
		Kill pQueryParams("$XDSSubmissionSetPatientId")
		Set tSC=##class(HS.Registry.Document.RegistryPackage).SubmissionSetsForPatient(tPatientID,.tArySetIDs,.pQueryParams)
		$$$HSTRACE("SubmissionSets for patient")
		If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error gathering registry packages:"_$system.Status.GetErrorText(tSC)) Quit
		$$$HSTRACE("SubmissionSets for patient","tPatientID,tArySetIDs,tSC",tPatientID,..aryToList(.tArySetIDs),tSC)
		Set tID=""
		For  {
			Set tID=$o(tArySetIDs(tID)) Quit:tID=""
			Set tSet = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tID)
			If '$IsObject(tSet) {
				If ##class(HS.Registry.Document.RegistryPackage).%ExistsId(tID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open submission set:"_tID)
				#; could be object has been deleted between query and open
				Continue
			}
			Set tFilter=0
			Set:$O(pQueryParams(""))]"" tSC = ..FilterSubmissionSet(tSet,.pQueryParams,.tFilter)
			If '$$$ISERR(tSC) {
				Do:'tFilter ..AddToOutputSet(,tSet)
			} Else {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error filtering registry package:"_$system.Status.GetErrorText(tSC)) Continue
			}
		}

	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

Method FilterSubmissionSets(pDocList, pIIDList, ByRef pQueryParams)
{
	Set tIID=""
	#; no other query parameters and just an objectref list return the list.
	If $O(pQueryParams(""))="" && (..QueryReturnType="ObjectRef") {
		For tIdx=1:1:$ll(pIIDList) { Do ..OutputSet.ObjectRefs.Insert($li(pIIDList,tIdx))}
		Quit
	}
	For tDocIdx=1:1:$ll(pDocList) {
		Set tID = $li(pDocList,tDocIdx)
		Set tDocument = ##class(HS.Registry.Document).%OpenId(tID)
		Set pQueryParams=1
		Set tSC = ..FilterDocument(tDocument,.pQueryParams,.tFilter,.tFilterCodes)  /// check for error
		Do:'tFilter ..AddToOutputSet(tDocument)
	}
}

Method FilterSubmissionSet(pSubmissionSet As HS.Registry.Document.RegistryPackage, ByRef pQueryParams, ByRef pFilter) As %Status
{
	Set pFilter=0,tSC=$$$OK
	try {
		#define paddedVal(%value) $e(%value_"000000000000000",1,14)
		Kill pQueryParams("$XDSSubmissionSetPatientId")  /// we've already restricted by this 
		Set tAryItem="",tSubmissionSetID=pSubmissionSet.%Id(),tSubmissionSetIID=pSubmissionSet.IID
		For  {
			Set tAryItem=$o(pQueryParams(tAryItem)) Quit:tAryItem=""
			If $e(tAryItem,1,5)="Code:" Continue
			$$$HSTRACE("Filtering SubmissionSet for:"_tAryItem)
			If tAryItem = "$XDSSubmissionSetSubmissionTimeFrom" {
				Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
				Set tStoredValue = pSubmissionSet.SlotValueForObject("submissionTime")
				If $$$paddedVal(tStoredValue)<$$$paddedVal(tValue) Set pFilter=1 Quit
			} ElseIf tAryItem="$XDSSubmissionSetSubmissionTimeTo" {
				Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
				Set tStoredValue = pSubmissionSet.SlotValueForObject("submissionTime")
				If $$$paddedVal(tValue)<$$$paddedVal(tStoredValue) Set pFilter=1 Quit
			} ElseIf tAryItem="$XDSSubmissionSetStatus" {
				Do ..FilterByStatus(pSubmissionSet,tAryItem,.pQueryParams,.pFilter)
			} ElseIf tAryItem="$XDSSubmissionSetSourceId" {
				Set tCounter=""
				For  {
					/// each tCounter is an and condition
					Set tCounter=$o(pQueryParams(tAryItem,tCounter))
					Quit:tCounter=""
					Set tHave=0
					Set tValue=""
					For  {
						/// each tValue is an OR condition
						Set tValue=$o(pQueryParams(tAryItem,tCounter,tValue))
						Quit:tValue=""
						If pSubmissionSet.SourceIdentifier.Value=tValue {
							$$$HSTRACE("$XDSSubmissionSetSourceId have "_tValue)
							Set tHave=1
							Quit
						}
					}
					Set pFilter='tHave
					Quit:pFilter
				}
			} ElseIf tAryItem="$XDSSubmissionSetAuthorPerson" {
				Set tSQL="select ID from hs_registry_document.slot_valuelist where slot->classification in (select ID from hs_registry_document.classification where classificationscheme='urn:uuid:a7058bb9-b4e4-4307-ba5b-e3f0ab85e12d' and RegistryPackage=? )"
				Do ..FilterByAuthor(tSubmissionSetID,tAryItem,tSQL,.pQueryParams,.pFilter)
			} ElseIf tAryItem="$XDSSubmissionSetContentType" {
				Set tCodedItem="urn:uuid:aa543740-bdda-424e-8c96-df4873be8500"
				Set tSC = ..FilterByClassification(tSubmissionSetID,tAryItem,tCodedItem,.pQueryParams,tSubmissionSetIID,.pFilter,pSubmissionSet)
			}
		}
		$$$HSTRACE("FilterSubmission Set finished ","tSubmissionSetID,pFilter,pQueryParams",tSubmissionSetID,pFilter,..aryToList(.pQueryParams))
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do:$isObject(..OutputSet) ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

Method FilterByStatus(pObject, pAryItem, ByRef pQueryParams, ByRef pFilter) As %Status
{
	try {
		Set tFound=0,tSC=$$$OK
		Set tCounter=$o(pQueryParams(pAryItem,""))
		Set tValue=""
		For  {
			Set tValue=$o(pQueryParams(pAryItem,tCounter,tValue)) Quit:tValue=""
			If tValue = ("urn:oasis:names:tc:ebxml-regrep:StatusType:"_pObject.Status) Set tFound=1 Quit
		}
		Set:'tFound pFilter=1
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do:$isObject(..OutputSet) ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

Method FilterByAuthor(tID, pAryItem, tSQL, ByRef pQueryParams, ByRef pFilter) As %Status
{
	try {
		Set tSC=$$$OK,tFound=0,tCounter="",tAnd=" and "
		For {
			Set tCounter=$o(pQueryParams(pAryItem,tCounter)) Quit:tCounter=""
			Set tOr=""
			Set tValue="",tSQLOR=""
			For  {
				Set tValue=$o(pQueryParams(pAryItem,tCounter,tValue)) Quit:tValue=""
				Set tValueCode=tValue
				If (tValueCode="")  {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","empty value:"_tValue)
					Set pFilter=1
					Continue
				}
				Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
				Set tSQLOR=tSQLOR_tOr_" (valuelist"_tEval_"'"_tValueCode_"') "
				Set tOr=" OR "
		
			}
			Continue:pFilter
			Set tSQL=tSQL_" and ("_tSQLOR_") "
			Set tRS=##class(%ResultSet).%New()
			Set tSC=tRS.Prepare(tSQL) 
			If $$$ISERR(tSC) {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to process query for "_tSQL)
				Set pFilter=1
				Continue
			}
			Set tSC=tRS.Execute(tID,tID)
			If $$$ISERR(tSC) {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to process query for "_tSQL)
				Set pFilter=1
				Continue
			}
			Set tNext = tRS.%Next()
			If 'tNext Set pFilter=1 Quit
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

Method FilterByExternalIdentifier(tID, pAryItem, pCodedItem, ByRef pQueryParams, pRegistryObject, ByRef pFilter) As %Status
{
	try {
		Set tSC=$$$OK,tCounter=""
		For {
			Set tFound=0
			Set tCounter=$o(pQueryParams(pAryItem,tCounter)) Quit:tCounter=""
			Set tValue=""
			For  {
				Set tValue=$o(pQueryParams(pAryItem,tCounter,tValue)) Quit:tValue=""
				Set tEval="=" If tValue["%" || (tValue["_") Set tEval=" LIKE "
				Set tSQL="select * from hs_registry_document.externalidentifier where identificationscheme =? and registryobject=? and identificationvalue "_tEval_"?" 
				Set tRS=##class(%ResultSet.SQL).%Prepare(tSQL,.tER,"",pCodedItem,pRegistryObject,tValue)
				If $isObject(tER) {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to process query for "_tSQL)
					Set pFilter=1
					Continue
				}
				Set tNext=tRS.%Next()
				If tNext Set tFound=1 Quit
				
			}
			Set:'tFound pFilter=1
			Continue:pFilter
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

/// pObject may be a Document or a SubmissionSet
Method FilterByClassification(tID, pAryItem, pCodedItem, ByRef pQueryParams, pRegistryObject, ByRef pFilter, pObject) As %Status
{
	try {
		Set tSC=$$$OK,tCounter=""
		For {
			Set tFound=0
			Set tCounter=$o(pQueryParams(pAryItem,tCounter)) Quit:tCounter=""
			Set tValue=""
			For  {
				Set tValue=$o(pQueryParams(pAryItem,tCounter,tValue)) Quit:tValue=""
				Set tValueCode=$p(tValue,"^")
				Set tValueScheme=$p(tValue,"^",3)
				If (tValueCode="") || (tValueScheme="") {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
					Set pFilter=1
					Continue
				}
				Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
				Set tField=$Case(pCodedItem,"urn:uuid:41a5887f-8865-4c09-adf7-e362475b143a":"ClassCode","urn:uuid:a09d5840-386c-46f2-b5ad-9c3699a4309d":"FormatCode","urn:uuid:f33fb8ac-18af-42cc-ae0e-ed0b0bdb91e1":"HealthCareFacilityTypeCode","urn:uuid:cccf5598-8b07-4b77-a05e-ae952c785ead":"PracticeSettingCode","urn:uuid:f0306f51-975f-434e-a61c-c59651d33983":"TypeCode","urn:uuid:aa543740-bdda-424e-8c96-df4873be8500":"ContentTypeCode",:"")
				$$$HSTRACE("In "_pAryItem_" with field "_tField)
				If tField]"" {
					Set tCode=$property(pObject,tField)
					$$$HSTRACE("In "_pAryItem_" with field "_tField,"pObject",pObject)
					#; if we have a value - new structure continue checking
					If tCode.Code]"" {
						If tCode.CodingScheme'=tValueScheme Continue
						If tEval="=" {
							If tCode.Code'=tValueCode Continue
						} Else {
							#; like - cheating using sql to do the like comparison
							Set tSQL="select top 1 %ID from hs_registry.document where ? LIKE ?"
							Set tRS=##class(%ResultSet.SQL).%Prepare(tSQL,.tER,"",tCode.Code,tValueCode)
							If 'tRS.%Next() Continue
						}
						Set tFound=1
						$$$HSTRACE("found "_pAryItem_" "_tValueCode_"/"_tValueScheme)
						Quit
					}
				}
				Set tSQL="select ID from hs_registry_document.Slot_valuelist where slot->classification->classificationscheme =? and slot->classification->classifiedobject=? and slot->classification->noderepresentation "_tEval_"? and valuelist=?"
				Set tRS=##class(%ResultSet.SQL).%Prepare(tSQL,.tER,"",pCodedItem,pRegistryObject,tValueCode,tValueScheme)
				If $isObject(tER) {
					Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to process query for "_tSQL)
					Set pFilter=1
					Continue
				}
				If tRS.%Next() Set tFound=1 $$$HSTRACE("found "_pAryItem_" "_tValueCode_"/"_tValueScheme,"tSQL",tSQL) Quit
			}
			Set:'tFound pFilter=1
			//If pFilter $$$HSTRACE("filtered by","pAryItem",pAryItem)
			Quit:pFilter
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

Method FilterByDocumentType(pObject, pAryItem, ByRef pQueryParams, ByRef pFilter) As %Status
{
	try {
		Set tFound=0,tSC=$$$OK
		Set tCounter=$o(pQueryParams(pAryItem,""))
		Set tValue=""
		For  {
			Set tValue=$o(pQueryParams(pAryItem,tCounter,tValue)) Quit:tValue=""
			If tValue = pObject.ObjectType Set tFound=1 Quit
		}
		Set:'tFound pFilter=1
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

Method queryFindFolders(ByRef pQueryParams) As %Status
{
	Try {
		#; find folders
		Set tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSFolderPatientId",1,0),
																$lb("$XDSFolderStatus",1,1),
																$lb("$XDSFolderLastUpdateTimeFrom",0,0),
																$lb("$XDSFolderLastUpdateTimeTo",0,0),
																$lb("$XDSFolderCodeList",0,1)),
															.tType) {
			Quit
		}
		Do ..folderSQLFromQueryParams(.pQueryParams)
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

Method queryFindFoldersMultiPatients(ByRef pQueryParams) As %Status
{
	Try {
		#; find folders
		Set tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSFolderPatientId",0,1),
																$lb("$XDSFolderStatus",1,1),
																$lb("$XDSFolderLastUpdateTimeFrom",0,0),
																$lb("$XDSFolderLastUpdateTimeTo",0,0),
																$lb("$XDSFolderCodeList",1,1)),
															.tType) {
			Quit
		}
		Do ..folderSQLFromQueryParams(.pQueryParams)
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

ClassMethod getSingleQueryParamValue(pQueryParams, pType, pExists) As %String
{
	Set pExists = 0
	Set tNode1 = $O(pQueryParams(pType,""))
	If tNode1="" Quit ""
	Set tNode2 = $O(pQueryParams(pType,tNode1,""))
	If tNode2="" Quit ""
	Set pExists = 1
	Quit tNode2
}

Method folderSQLFromQueryParams(ByRef pQueryParams) As %Status
{
	#define RSCheck(%RS) If %RS.SQLCODE&&(%RS.SQLCODE'=100) { Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: executing resultset:"_%RS.SQLCODE) $$$HSTRACE("ResultSetError","tRS",%RS.SQLCODE) Return $$$OK }
	try {
		Set tSC=$$$OK
		Set tSQL($I(tSQL))="SELECT ID,IID FROM HS_Registry_Document.RegistryPackage WHERE Type='F'"

		Do ..folderAddSQLField(.pQueryParams,.tParams,.tSQL,$lb("","V","$XDSFolderPatientId","PatientIdentifier_Value"),"$XDSFolder","")
		Do ..folderAddSQLField(.pQueryParams,.tParams,.tSQL,$lb("","V","$XDSFolderEntryUniqueId","UniqueIdentifier_Value"),"$XDSFolder","")
		Do ..folderAddSQLField(.pQueryParams,.tParams,.tSQL,$lb("","V","$XDSFolderStatus"),"$XDSFolder","")
		KILL pQueryParams("$XDSFolderStatus")
		Do ..folderAddClassification("$XDSFolderCodeList","urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5",.pQueryParams,.tSQL,.tParams)

		Set tLastUpdateFrom = ..getSingleQueryParamValue(.pQueryParams, "$XDSFolderLastUpdateTimeFrom")
		If tLastUpdateFrom ]"" {
			Set tSQL($I(tSQL))=" AND ID IN (SELECT Slot->RegistryPackage FROM HS_Registry_Document.Slot_ValueList where Slot->Name = 'lastUpdateTime' and $EXTRACT(ValueList,1,"_$l(tLastUpdateFrom)_") > ?)"
			Set tParams($I(tParams))=tLastUpdateFrom
			Kill pQueryParams("$XDSFolderLastUpdateTimeFrom")
		}
	
		Set tLastUpdateTo = ..getSingleQueryParamValue(.pQueryParams, "$XDSFolderLastUpdateTimeTo")
		If tLastUpdateTo ]"" {
			Set tSQL($I(tSQL))=" AND ID IN (SELECT Slot->RegistryPackage FROM HS_Registry_Document.Slot_ValueList where Slot->Name = 'lastUpdateTime' and $EXTRACT(ValueList,1,"_$l(tLastUpdateTo)_") < ?)"
			Set tParams($I(tParams))=tLastUpdateTo
			Kill pQueryParams("$XDSFolderLastUpdateTimeTo")
		}

		$$$HSTRACE("Query Evaluation","tSQL,tParams,pQueryParams",..aryToList(.tSQL,1),..aryToList(.tParams),..aryToList(.pQueryParams))	
		Set tRS = ##class(%SQL.Statement).%ExecDirect(,.tSQL,tParams...)
		$$$RSCheck(tRS)	
		Set tCount=0
		While tRS.%Next() {
			Set tID = tRS.ID
			Set tSet = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tID,0,tSC)
			If '$IsObject(tSet) {
				If ##class(HS.Registry.Document.RegistryPackage).%ExistsId(tID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open folder:"_tID _ "  "_ $system.Status.GetErrorText(tSC))  $$$HSTRACE("Unable to open folder","tID,tSC",tID,tSC)
				#; with multiple processes, it could have been deleted between query and filter
				Continue  
			}
			Set tFilter=0
			Set:$O(pQueryParams(""))]"" tSC = ..queryFilterFolders(tSet,.pQueryParams,.tFilter) 
			If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error filtering folders"_ $system.Status.GetErrorText(tSC)) continue
			$$$HSTRACE("Checking Folder ","tID,tFilter",tID,tFilter)
			Do:'tFilter ..AddToOutputSet(,tSet)
		}
	} catch ex {
		Set tSC=ex.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

Method folderAddSQLField(ByRef pQueryParams, Output pParams, Output pSQL, pItem, pPrefix = "$XDSFolder", pNoIndex)
{
	Set tIsValue=($li(pItem,2)="V"),tNode=$li(pItem,3),tField=$lg(pItem,4) Set:tField="" tField=$p(tNode,pPrefix,2)
	Set tNoIndex=$S(($g(pNoIndex)]""&&($li(tItem)]"")):" %NOINDEX ",1:"")
	Set tSQLAND=" AND "
	If $d(pQueryParams(tNode)) {
		Set tIdx="",tCount=0,tSQLNode=""
		For  {
			Set tIdx=$o(pQueryParams(tNode,tIdx)) Quit:tIdx=""
			Set tValue="" 
			Set pSQL($I(pSQL))=tSQLAND,tSQLAND=" AND ",tSQLOR="",tSQLNode="",tSQLWHERE=""
			For {
				Set tValue=$o(pQueryParams(tNode,tIdx,tValue)) Quit:tValue=""
				If 'tIsValue {
					#; not a value but instead a code^^scheme
					Set tValueCode=$p(tValue,"^")
					Set tValueScheme=$p(tValue,"^",3)
					If (tValueCode="") || (tValueScheme="") {
						Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
						Quit
					}
					Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
					// EventCodeList kills performance do it separately
					Set tSQLNode=tSQLNode_tSQLOR_" ("_tNoIndex_tField_"_Code"_tEval_"? AND "_tNoIndex_tField_"_CodingScheme=?)",pParams($i(pParams))=$tr(tValueCode,"_","%"),pParams($i(pParams))=tValueScheme,tSQLOR=" OR "
				} Else {
					#; a single value (NOT a code^^scheme)
					Set tEval="="
					Set tQueryValue=tValue
					Set tNodeNoPrefix = $p(tNode,pPrefix,2)
					If tNodeNoPrefix="Status" {
						Set tQueryValue=$p(tValue,":",$l(tValue,":"))
					} ElseIf tNodeNoPrefix="CreationTimeFrom" {
						Set tEval=">=",tQueryValue=$$$paddedVal(tValue)
					} ElseIf tNodeNoPrefix="CreationTimeTo" {
						Set tEval="<=",tQueryValue=$$$paddedVal(tValue)
					} ElseIf tNodeNoPrefix="ServiceStartTimeTo"||(tNodeNoPrefix="ServiceStartTimeFrom") {
						#; ServiceStartTimes can be shortened so use the extract to compare
						Set tEval=$S(tNodeNoPrefix="ServiceStartTimeTo":"<=",1:">=")
						Set tSQLNode=tSQLNode_tSQLOR_" ServiceStartTime"_tEval_"$EXTRACT(?,1,$LENGTH(ServiceStartTime))",pParams($i(pParams))=$$$paddedVal(tValue),tSQLOR=" OR "
						Continue
					}
					Set tSQLNode=tSQLNode_tSQLOR_" "_tNoIndex_tField_tEval_"?",pParams($i(pParams))=tQueryValue,tSQLOR=" OR "
				}
			}
			Set pSQL($I(pSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
		}
		Kill pQueryParams(tNode)

	}
}

/// Additional SQL for classification
Method folderAddClassification(pNode, pScheme, pQueryParams, ByRef pSQL, ByRef pParams)
{
	Quit:'$D(pQueryParams(pNode))
	Set tSQLAND="",tSQLOR=""
	Set pParams($i(pParams))=pScheme
	Set pSQL($I(pSQL))="AND ID IN (SELECT slot->classification->RegistryPackage FROM HS_Registry_Document.Slot_valuelist WHERE %NOINDEX slot->classification->classificationscheme=? AND"
	Set tIdx="",tSQLNode=""
	For  {
		Set tIdx=$o(pQueryParams(pNode,tIdx)) Quit:tIdx=""
		Set tValue="" 
		Set:tSQLAND]"" pSQL($I(pSQL))=tSQLAND
		Set tSQLAND=" AND ",tSQLOR="",tSQLNode=""
		For {
			Set tValue=$o(pQueryParams(pNode,tIdx,tValue)) Quit:tValue=""
			#; not a value but instead a code^^scheme
			Set tValueCode=$p(tValue,"^")
			Set tValueScheme=$p(tValue,"^",3)
			If (tValueCode="") || (tValueScheme="") {
				Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unknown value / scheme pair for "_tValue)
				Quit
			}
			Set tEval="=" If tValueCode["%" || (tValueCode["_") Set tEval=" LIKE "
			Set tSQLNode=tSQLNode_tSQLOR_" ( slot->classification->noderepresentation"_tEval_"? AND valuelist=?)",pParams($i(pParams))=$tr(tValueCode,"_","%"),pParams($i(pParams))=tValueScheme,tSQLOR=" OR "
		}
		Set pSQL($I(pSQL))="("_tSQLNode_")",tSQLAND=" AND ",tSQLOR=""
	}
	Set pSQL(pSQL)=pSQL(pSQL)_")"  /// add trailing ) for the IN clause
	Kill pQueryParams(pNode)
	Quit $$$OK
}

/// test 11899
Method queryFilterFolders(pFolder, ByRef pQueryParams, ByRef pFilter) As %Status
{
	try {
		Set pFilter=0,tSC=$$$OK
		#define paddedVal(%value) $e(%value_"000000000000000",1,14)
		Kill pQueryParams("$XDSFolderPatientId")  /// we've already restricted by this 
		Set tAryItem="",tFolderID=pFolder.%Id(),tFolderIID=pFolder.IID
		For  {
			Set tAryItem=$o(pQueryParams(tAryItem)) Quit:tAryItem=""
			If $e(tAryItem,1,5)="Code:" Continue
			If tAryItem = "$XDSFolderLastUpdateTimeFrom" {
				Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
				Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameRegistryPackage("lastUpdateTime",tFolderID)
				If $$$paddedVal(tStoredValue)<=$$$paddedVal(tValue) {
					$$$HSTRACE("Filtered Update Time From ","tStoredValue,tValue",tStoredValue,tValue)
					Set pFilter=1 Quit
				}
			} ElseIf tAryItem="$XDSFolderLastUpdateTimeTo" {
				Set tCounter=$o(pQueryParams(tAryItem,"")),tValue=$o(pQueryParams(tAryItem,tCounter,""))
				Set tStoredValue = ##class(HS.Registry.Document.Slot).ValueForNameRegistryPackage("lastUpdateTime",tFolderID)
				If $$$paddedVal(tValue)<=$$$paddedVal(tStoredValue) {
					$$$HSTRACE("Filtered Update Time To ","tStoredValue,tValue",tStoredValue,tValue)
					Set pFilter=1 Quit
				}
			} ElseIf tAryItem="$XDSFolderCodeList" {
				Set tCodedItem="urn:uuid:1ba97051-7806-41a8-a48b-8fce7af683c5"
				Set tSC = ..FilterByClassification(tFolderID,tAryItem,tCodedItem,.pQueryParams,tFolderIID,.pFilter)
			} ElseIf tAryItem="$XDSFolderStatus" {
				Set tSC=..FilterByStatus(pFolder,tAryItem,.pQueryParams,.pFilter)
			}
		}
		/// filter
		If ..info("$MetadataLevel")=1 && (pFolder.Status = "Deprecated") {
			//Set pFilter=1
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}
	Quit tSC
}

/// test 11901
Method queryGetDocuments(ByRef pQueryParams, ByRef pListDocIIDs) As %Status
{
	Try {
		#; find document
		Set tSC=$$$OK,pListDocIIDs=""
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSDocumentEntryEntryUUID","Only1",1),
																$lb("$XDSDocumentEntryUniqueId","Only1",1),
																$lb("$XDSDocumentEntryLogicalID","Only1",1)),
															.tType) {
			Quit
		}
		Set tPatientID=""
		Set tIdx=""
		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				If tType="$XDSDocumentEntryUniqueId" {
					Set tSC = ##class(HS.Registry.Document).DocumentForUniqueID(tID,.tAryDocIDs)
				} ElseIf tType = "$XDSDocumentEntryEntryUUID" {
					Set tDocumentID = ##class(HS.Registry.Document).DocumentForEntryID(tID)
					If tDocumentID ]"" {
						Set tAryDocIDs(tDocumentID)=""
					}
				} ElseIf tType = "$XDSDocumentEntryLogicalID" {
					Set tSC = ##class(HS.Registry.Document).DocumentsForLogicalID(tID,.tAryDocIDs)
				}
				Kill pQueryParams(tType,tIdx,tID)
			}
		}

		$$$HSTRACE("Array","atl",..aryToList(.tAryDocIDs))
		Set tDocumentID=""
		For  {
			Set tDocumentID = $o(tAryDocIDs(tDocumentID)) Quit:tDocumentID=""
			Set tDocument = ##class(HS.Registry.Document).%OpenId(tDocumentID)
			If '$IsObject(tDocument) {
				If ##class(HS.Registry.Document).%ExistsId(tDocumentID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open document:"_tDocumentID)
				#; With multiple processes running the object could be deleted before opening
				Continue  
			}			
			If ..info("$MetadataLevel")=1 && (tDocument.Status = "Deprecated") {
				/// if not the latest version and metdatalevel is 1 don't return it
				Set tRS = ##class(%SQL.Statement).%ExecDirect(,"Select ID from HS_Registry.Document where LogicalIID=? and Version>?",tDocument.LogicalIID,tDocument.Version)
				If tRS.%Next() Continue
			}

			If ..QueryReturnType="LeafClass" {
				Set:tPatientID="" tPatientID=tDocument.PatientID
				If tPatientID'=tDocument.PatientID Do ..OutputSet.logError("XDSResultNotSinglePatient","Error","Patient ID "_tPatientID_" not the same as "_tDocument.PatientID) Continue
			}
			Do ..AddToOutputSet(tDocument)
			Set pListDocIIDs=pListDocIIDs_$lb(tDocument.IID)
		}


	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// test 11902
Method queryGetFolders(ByRef pQueryParams) As %Status
{
	Try {
		#; get Folders
		Set tSC=$$$OK,tPatientID=""
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSFolderEntryUUID","Only1",1),
																$lb("$XDSFolderUniqueId","Only1",1),
																$lb("$XDSFolderLogicalID","Only1",1)),
															.tType) {
			Quit
		}
		Set tIdx=""
		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				If tType="$XDSFolderEntryUUID" {
					Set tFolderID =##class(HS.Registry.Document.RegistryPackage).ItemForEntryID(tID,"F")
					If tFolderID]"" {
						Set tAry(tFolderID)=""
					}
				} ElseIf tType="$XDSFolderUniqueId" {
					Set tFolderID =##class(HS.Registry.Document.RegistryPackage).ItemForUniqueID(tID,"F")
					If tFolderID]"" {
						Set tAry(tFolderID)=""
					}
				} ElseIf tType="$XDSFolderLogicalID" {
					Set tSC=##class(HS.Registry.Document.RegistryPackage).ItemsForLogicalID(tID,"F",.tAry)
				}
				Kill pQueryParams(tType,tIdx,tID)
			}
		}
		Set tFolderID="" 
		For  {
			Set tFolderID=$o(tAry(tFolderID)) Quit:tFolderID=""
			Set tFolder = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tFolderID)
			If '$IsObject(tFolder) {
				If ##class(HS.Registry.Document.RegistryPackage).%ExistsId(tFolderID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open folder:"_tFolderID)
				#; could be object has been deleted between query and open
				Continue
			}
			
			If ..QueryReturnType="LeafClass" {
				Set tFolderPatientID = tFolder.PatientIDForObject()
				Set:tPatientID="" tPatientID=tFolderPatientID
				If tPatientID'=tFolderPatientID Do ..OutputSet.logError("XDSResultNotSinglePatient","Error","Patient ID "_tPatientID_" not the same as "_tFolderPatientID) Continue
			}
			
			$$$HSTRACE("Adding folder","tFolderID,tFolder",tFolderID,tFolder)
			Do ..AddToOutputSet(,tFolder)
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// test 11903
Method queryGetAssociations(ByRef pQueryParams) As %Status
{
	Try {
		Set tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$uuid","Only1",1)),.tType) {
			Quit
		}
		Set tIdx=""
		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				Kill tAryIDs
				Set tSC = ##class(HS.Registry.Document.Association).IDsForIID(tID,.tAryIDs,"")
				Kill pQueryParams(tType,tIdx,tID)
				Set tAssociationID=""
				For  {
					Set tAssociationID=$o(tAryIDs(tAssociationID)) Quit:tAssociationID=""
					Set tAssociation = ##class(HS.Registry.Document.Association).%OpenId(tAssociationID)
					If '$IsObject(tAssociation) {
						If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to open Association:"_tAssociationID)
						Continue  
					}
					If ..filterAssociation(.pQueryParams,"",tAssociation) Continue
					$$$HSTRACE("Adding Association","tAssociationID,tAssociation",tAssociationID,tAssociation)
					Do ..AddToOutputSet(,,tAssociation)

				}
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// test 11904
Method queryGetDocsAndAssociations(ByRef pQueryParams) As %Status
{
	Try {
		Set tError="",tSC=$$$OK
		Set tSC=..queryGetDocuments(.pQueryParams,.tListDocIIDs) 
		Quit:$$$ISERR(tSC)
		If $ll(tListDocIIDs)=0 {
			Quit
		}
		For tIdx=1:1:$ll(tListDocIIDs) {
			Set pQueryParams("$uuid",1,$li(tListDocIIDs,tIdx))=""
		}
		If $D(pQueryParams("$uuid")) {
			Set tSC=..queryGetAssociations(.pQueryParams) Quit:$$$ISERR(tSC)
			If $$$ISERR(tSC) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Unable to run query get associations "_$system.Status.GetErrorText(tSC)) Quit
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// Retrieve submission sets based on the uuid identifier of document or folder - return submission sets and associations
/// test 11905
Method queryGetSubmissionSets(ByRef pQueryParams) As %Status
{
	Try {
		Set tError="",tSC=$$$OK
		Set tPatientID=""
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$uuid","Only1",1)),.tType) {
			Quit
		}
		Set tIdx=""
		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			Kill tAryIDs
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				Set tSC = ##class(HS.Registry.Document.Association).IDsForTargetIID(tID,.tAryIDs)
				Kill pQueryParams(tType,tIdx,tID)
			}
			Set tAssociationID=""
			For  {
				Set tAssociationID=$o(tAryIDs(tAssociationID)) Quit:tAssociationID=""
				Set tAssociation = ##class(HS.Registry.Document.Association).%OpenId(tAssociationID)
				If '$isobject(tAssociation) {
					If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error adding association "_tAssociationID)
					#; could be that with multiple processes the object has been deleted
					Continue
				}
				If tAssociation.AssociationType'="HasMember" Continue
				If ..filterAssociation(.pQueryParams,"",tAssociation) Continue

				Set tSubmissionSetID = ##class(HS.Registry.Document.RegistryPackage).ItemForEntryID(tAssociation.SourceObject,"SS")
				If tSubmissionSetID="" Continue
				Set tSubmissionSet = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tSubmissionSetID)
				If '$isobject(tSubmissionSet) {
					If ##class(HS.Registry.Document.RegistryPackage).%ExistsId(tSubmissionSetID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error adding submission set "_tSubmissionSetID) 
					#; could be that with multiple processes the object has been deleted
					Continue
				}
				Set tSubmissionPatientID=tSubmissionSet.PatientIDForObject()
				Set:tPatientID="" tPatientID=tSubmissionPatientID
				If ..QueryReturnType="LeafClass" {
					If tPatientID'=tSubmissionPatientID Do ..OutputSet.logError("XDSResultNotSinglePatient","Error","Patient ID "_tPatientID_" not the same as "_tSubmissionPatientID) Continue
				}
					
				Do ..AddToOutputSet(,,tAssociation)
				Do:'$d(tAryHave("SS",tSubmissionSetID)) ..AddToOutputSet(,tSubmissionSet)
				Set tAryHave("SS",tSubmissionSetID)=""
				$$$HSTRACE("Adding Submission Set","tSubmissionSetID,tSubmissionSet",tSubmissionSetID,tSubmissionSet)
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// Locate submission sets based on EntryID or uniqueID of set - Return Documents / Folders / Submission Sets / Associations
/// after filtering docs by format code and confidentiality code
/// test 11906
/// for the associations:
///   any association submission set
///   any association between document and folder and also the association which links document and folder
Method queryGetSubSetsAndContents(ByRef pQueryParams) As %Status
{
	Try {
		Set tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSSubmissionSetEntryUUID","Only1",0),
																$lb("$XDSSubmissionSetUniqueId","Only1",0),
																$lb("$XDSDocumentEntryFormatCode",0,1),
																$lb("$XDSDocumentEntryConfidentialityCode",0,1),
																$lb("XDSDocumentEntryType",0,1)),
															.tType) {
			Quit
		}
		Set tIdx=""
		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				If tType="$XDSSubmissionSetEntryUUID" {
					Set tSubmissionID = ##class(HS.Registry.Document.RegistryPackage).ItemForEntryID(tID,"SS")
				} Else {
					Set tSubmissionID = ##class(HS.Registry.Document.RegistryPackage).ItemForUniqueID(tID,"SS")
				}
				Kill pQueryParams(tType,tIdx,tID)
				#; submission set may have been rolled back due to filing problems (test is replace on deprecated document)
				If tSubmissionID = "" Continue
				Set tSubmission = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tSubmissionID)
				If '$IsObject(tSubmission) {
					If ##class(HS.Registry.Document.RegistryPackage).%ExistsId(tSubmissionID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open submission set:"_tSubmissionID)
					Continue
				}
				Do ..AddToOutputSet(,tSubmission)
				Set tSC=##class(HS.Registry.Document.Association).TargetIDsForSourceIID(tSubmission.IID,.tTargetIDs) 
				$$$HSTRACE("Adding Submission ","tSubmission,tSubmissionID,AssociationsForSS",tSubmission,tSubmissionID,..aryToList(.tTargetIDs))
				
				Set tTargetID="" 
				For  {
					Set tFilter=0
					Set tTargetID=$o(tTargetIDs(tTargetID)) Quit:tTargetID=""
					Set tAssociationID=tTargetIDs(tTargetID)
					#; check to see if association should be filtered (metadata update)
					Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssociationID)
					If '$IsObject(tAssociation) {
						If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open association:"_tAssociationID)
						Continue
					}
					If ..filterAssociation(.pQueryParams,"",tAssociation) Continue
					If $d(tAryHave("D",tTargetID)) Continue
					Set tDocument = ##class(HS.Registry.Document).ObjectForIID(tTargetID)
					Set tTargetIID=""
					If $IsObject(tDocument) {
						Set tSC = ..FilterDocument(tDocument,.pQueryParams,.tFilter,.tFilterCodes)  /// check for error
						If 'tFilter {
							Do ..AddToOutputSet(tDocument)
							Set tTargetIID=tDocument.IID
							$$$HSTRACE("Adding Document","tDocument",tDocument)
							Set tAryHave("D",tTargetIID)=""
						}
						Set tTargetIDs(tTargetID,"D")=tDocument.%Id()
					} Else {
						Set tFolderID = ##class(HS.Registry.Document.RegistryPackage).ItemForEntryID(tTargetID,"F")
						If tFolderID = "" {
							Kill tTargetIDs(tTargetID)
							Set tFilter=1
						} Else {
							Set tFolder=##class(HS.Registry.Document.RegistryPackage).%OpenId(tFolderID)
							Continue:'$IsObject(tFolder)
							Do ..AddToOutputSet(,tFolder)
							Set tTargetIID=tFolder.IID
							$$$HSTRACE("Adding Folder","tFolder",tFolder)
							Set tAryHave("F",tTargetIID)=""
						}
					}
					If 'tFilter {
						Kill tAssociationIDs
						Set tSC=##class(HS.Registry.Document.Association).IDsForSourceAndTargetIID(tSubmission.IID,tTargetIID,.tAssociationIDs) 
						Set tAssociationID=""
						For  {
							Set tAssociationID=$o(tAssociationIDs(tAssociationID)) Quit:tAssociationID=""
							Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssociationID)	
							If '$IsObject(tAssociation) {
								If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open association:"_tAssociationID)
								Continue
							}
							If ..filterAssociation(.pQueryParams,"",tAssociation) Continue
							$$$HSTRACE("Adding Association","tAssociationID",tAssociationID)
							Do ..AddToOutputSet(,,tAssociation)
						}
					}
				}
				Set tDoc="",tFolder=""
				Kill tAssociationIDs
				$$$HSTRACE("Checking Doc Folder associations","tAryHave",..aryToList(.tAryHave))
				For  {
					Set tDoc=$O(tAryHave("D",tDoc)) Quit:tDoc=""
					For  {
						Set tFolder=$O(tAryHave("F",tFolder)) Quit:tFolder=""
						Set tSC=##class(HS.Registry.Document.Association).IDsForSourceAndTargetIID(tFolder,tDoc,.tAssociationIDs) 
					}

				}
				Set tAssociationID=""
				If $d(tAssociationIDs) $$$HSTRACE("Have Doc Folder associations","tAssociationIDs",..aryToList(.tAssociationIDs))
				For  {
					Set tAssociationID=$o(tAssociationIDs(tAssociationID)) Quit:tAssociationID=""
					$$$HSTRACE("Adding Association","tAssociationID",tAssociationID)
					Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssociationID)	
					If '$IsObject(tAssociation) {
						If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open association:"_tAssociationID)
						Continue
					}
					Do ..AddToOutputSet(,,tAssociation)
					Set tSC=##class(HS.Registry.Document.Association).IDsForTargetIID(tAssociation.IID,.tOtherAssociations) 
				}

				For  {
					Set tAssociationID=$o(tOtherAssociations(tAssociationID)) Quit:tAssociationID=""
					$$$HSTRACE("Adding Association","tAssociationID",tAssociationID)
					Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssociationID)	
					If '$IsObject(tAssociation) {
						If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open association:"_tAssociationID)
						Continue
					}
					Do ..AddToOutputSet(,,tAssociation)
				}
				Set tAryHave("SS",tSubmissionID)=""
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// For consumer not aware of MetadataUpdate filter associations not of status Approved, for those aware, filter by status specified, where not specified,
/// the default is approved
Method filterAssociation(ByRef pQueryParams, pAssociationID As %String = "", pAssociation As HS.Registry.Document.Association = "") As %Boolean
{
	Set tFilter=0
	Set tStatus = $S($IsObject(pAssociation):pAssociation.Status,1:##class(HS.Registry.Document.Association).StatusGetStored(pAssociationID))
	If ..info("$MetadataLevel")=1 || '$D(pQueryParams("$XDSAssociationStatus")) {
		Set:tStatus'="Approved" tFilter=1
	} Else {
		Set tChoices="",tCounter="",tMatch=1,tStatusDisplay=##class(HS.Types.IHE.Status).StatusLogicalToDisplay(tStatus)
		For  {
			Set tCounter=$o(pQueryParams("$XDSAssociationStatus",tCounter)) Quit:tCounter=""
			Set tValue="",tMatch=0 
			For  {
				Set tValue=$o(pQueryParams("$XDSAssociationStatus",tCounter,tValue)) Quit:tValue=""
				If tStatusDisplay=tValue Set tMatch=1
			}
			Quit:'tMatch
		}
		Set:'tMatch tFilter=1
	}
	Quit tFilter
}

/// pParameters is a list of requirements for the query in the form of $lb(param,param,param) where each param is a list<br>
/// param = $lb(parametername, required (1/0/Only1), multivalue (1/0)) <br>
/// the Only1 indicates that only 1 item with "Only1" requirement set can have a value
Method validateRequiredQueryParameters(ByRef pQueryParams, pParameters = "", Output pType = "") As %Boolean
{
	Set tValid = 1
	Set tOnly1 = 0
	Set tCountOnly1 = 0
	Set tListOnly1 = ""
	Set tListMissing = ""
	For tEntryCount = 1:1:$ll(pParameters) {
		Set tParameter = $li(pParameters,tEntryCount)
		Set tItem = $li(tParameter,1)
		Set tRequired = $li(tParameter,2)
		If tRequired = "Only1" {
			Set tOnly1 = 1
			Set tListOnly1 = tListOnly1 _ $lb(tItem)
		}
		Set tMultiple = $li(tParameter,3)
		If $D(pQueryParams(tItem)) {
			Set tCountValues = $$CountItems(tItem)
			If 'tMultiple && (tCountValues>1) {
				Do ..OutputSet.logError("XDSStoredQueryParamNumber","Error","Miscoded, "_tItem_" is a single value")
				Set tValid = 0
			}
			If tRequired = "Only1" {
				Set tCountOnly1 = tCountOnly1 + 1
				Set pType = tItem
			}
		} Else { 
			If tRequired {
				Set tListMissing = tListMissing _ $lb(tItem)
				Set tValid = 0
			}
		}
	}
	If $ll(tListMissing) {
		Set tEachOf = $S($ll(tListMissing)=1:"",1:"each of ")
		Do ..OutputSet.logError("XDSStoredQueryMissingParam","Error","Miscoded, must specify "_tEachOf_$listtoString(tListMissing,",")) 
		Set tValid = 0
	}
	If $ll(tListOnly1) {
		Set tOneOf = $S($ll(tListOnly1)=1:"",1:"one of ")  /// could be a single entry like $uuid
		If tCountOnly1 = 0 {
			Do ..OutputSet.logError("XDSStoredQueryMissingParam","Error","Miscoded, must specify "_tOneOf_$listtoString(tListOnly1,",")) 
			Quit 0
		} ElseIf tCountOnly1>1 {
			Do ..OutputSet.logError("XDSStoredQueryParamNumber","Error","Miscoded, must specify "_tOneOf_$listtoString(tListOnly1,",")) 
			Quit 0
		}
	}
	Quit tValid
	///
CountItems(tItem) //
	Set tItemCount = 0
	Set tAndNode=""
	For  {
		Set tAndNode = $O(pQueryParams(tItem,tAndNode)) 
		Quit:tAndNode=""
		Set tOrNode=""
		For  {
			Set tOrNode = $O(pQueryParams(tItem,tAndNode,tOrNode),1,tDataValue)
			Quit:tOrNode=""
			Set tItemCount = tItemCount + 1
		}
	}
	Quit tItemCount
}

/// test 11907
Method queryGetFolderAndContents(ByRef pQueryParams) As %Status
{
	Try {
		Set tError="",tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSFolderEntryUUID","Only1",0),
																$lb("$XDSFolderUniqueId","Only1",0),
																$lb("$XDSDocumentEntryFormatCode",0,1),
																$lb("$XDSDocumentEntryConfidentialityCode",0,1),
																$lb("$XDSDocumentEntryType",0,1)),
																.tType) 
			{
			Quit
		}
		Set tIdx=""

		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				If tType="$XDSFolderEntryUUID" {
					Set tRegistryPackageID = ##class(HS.Registry.Document.RegistryPackage).ItemForEntryID(tID,"F")
				} Else {
					Set tRegistryPackageID = ##class(HS.Registry.Document.RegistryPackage).ItemForUniqueID(tID,"F")
				}
				Kill pQueryParams(tType,tIdx,tID)
				If tRegistryPackageID="" continue
				Set tRegistryPackage = ##class(HS.Registry.Document.RegistryPackage).%OpenId(tRegistryPackageID)
				If '$isObject(tRegistryPackage) {
					If ##class(HS.Registry.Document.RegistryPackage).%ExistsId(tRegistryPackageID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Error opening folder:"_tRegistryPackageID) 
					Continue
				}
				Do ..AddToOutputSet(,tRegistryPackage)
				Set tAryHave("F",tRegistryPackage.IID)=""
				
				Set tSC=##class(HS.Registry.Document.Association).TargetIDsForSourceIID(tRegistryPackage.IID,.tTargetIDs) 
				Set tTargetID="" 
				For  {
					Set tFilter=0
					Set tTargetID=$o(tTargetIDs(tTargetID)) Quit:tTargetID=""
					Set tAssociationID=tTargetIDs(tTargetID)
					Set tDocument = ##class(HS.Registry.Document).ObjectForIID(tTargetID)
					Set tTargetIID=""
					If $IsObject(tDocument) {
						Set tSC = ..FilterDocument(tDocument,.pQueryParams,.tFilter,.tFilterCodes)  /// check for error
						If 'tFilter {
							Do ..AddToOutputSet(tDocument)
							Set tAryHave("D",tDocument.IID)=""
							Set tTargetIDs(tTargetID,"D")=tDocument.%Id()
						}
						
					}
				}
				Set tAryHave("SS",tRegistryPackageID)=""
				Set tDoc="",tFolder=""
				Kill tAssociationIDs
				$$$HSTRACE("Checking Doc Folder associations","tAryHave",..aryToList(.tAryHave))
				For  {
					Set tDoc=$O(tAryHave("D",tDoc)) Quit:tDoc=""
					For  {
						Set tFolder=$O(tAryHave("F",tFolder)) Quit:tFolder=""
						Set tSC=##class(HS.Registry.Document.Association).IDsForSourceAndTargetIID(tFolder,tDoc,.tAssociationIDs) 
					}
				}
				Set tAssociationID=""
				If $d(tAssociationIDs) $$$HSTRACE("Have Doc Folder associations","tAssociationIDs",..aryToList(.tAssociationIDs))
				For  {
					Set tAssociationID=$o(tAssociationIDs(tAssociationID)) Quit:tAssociationID=""
					$$$HSTRACE("Adding Association","tAssociationID",tAssociationID)
					Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssociationID)	
					If '$IsObject(tAssociation) {
						If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open association:"_tAssociationID)
						Continue
					}
					Do ..AddToOutputSet(,,tAssociation)
					Set tSC=##class(HS.Registry.Document.Association).IDsForTargetIID(tAssociation.IID,.tOtherAssociations) 
				}
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

Method queryGetAll(ByRef pQueryParams) As %Status
{
	Try {
		Set tSC = $$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$patientId",1,0),
																$lb("$XDSDocumentEntryStatus",1,1),
																$lb("$XDSSubmissionSetStatus",1,1),
																$lb("$XDSFolderStatus",1,1),
																$lb("$XDSDocumentEntryFormatCode",0,1),
																$lb("$XDSDocumentEntryConfidentialityCode",0,1),
																$lb("$XDSDocumentEntryType",0,1)),
																.tType) {
			Quit
		}
		Set tPatientID = ..getSingleQueryParamValue(.pQueryParams,"$patientId")
		Kill pQueryParams("$patientId")
		Set pQueryParams("$XDSDocumentEntryPatientId",1,tPatientID)=""
		Set pQueryParams("$XDSFolderPatientId",1,tPatientID)=""
		Set pQueryParams("$XDSSubmissionSetPatientId",1,tPatientID)=""
		Set tSC = ..queryFindDocuments(.pQueryParams) Quit:$$$ISERR(tSC)
		Set tSC = ..queryFindFolders(.pQueryParams) Quit:$$$ISERR(tSC)
		Set tSC = ..queryFindSubmissionSets(.pQueryParams) Quit:$$$ISERR(tSC)
		If ..OutputSet.ObjectRefs.Count() {
			Do ..addAssociations(.pQueryParams)
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

Method addAssociations(ByRef pQueryParams)
{
	Set tSC=$$$OK
	
	For tIdx=1:1:..OutputSet.ObjectRefs.Count() {
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%ObjectSelectMode=1
		If ..info("$MetadataLevel")=1 || '$D(pQueryParams("$XDSAssociationStatus")) {
			Set tAND=" AND Status='Approved'"
		} Else {
			Set tCounter="",tAND=""
			For  {
				Set tAND=" AND ",tORS=""
				Set tCounter=$o(pQueryParams("$XDSAssociationStatus",tCounter)) Quit:tCounter=""
				Set tValue="" 
				For  {
					Set tValue=$o(pQueryParams("$XDSAssociationStatus",tCounter,tValue)) Quit:tValue=""
					Set tOR="Status='"_$S(tValue["Approved":"Approved",1:"Deprecated")
					Set tORS=tORS_$S(tORS="":"",1:" OR ")_tOR
				}
				Set tAND=tAND_" ("_tORS_")"
			}
		}
		Do tStatement.%Prepare("SELECT ID From HS_Registry_Document.Association where SourceObject=? or TargetObject=?"_tAND)
		Set tIID=..OutputSet.ObjectRefs.GetAt(tIdx)
		Set tRS=tStatement.%Execute(tIID,tIID)
		While tRS.%Next() {
			Set tID = tRS.ID.%Id()
			/// only include the association once
			If '$D(tFilterDuplicates(tID)) {
				Set tFilterDuplicates(tID)=""
				Do ..AddToOutputSet(,,tRS.ID)
			}
		}
			
	}
	Quit tSC
}

/// test 11908
/// locate folders for specified document using associations
Method queryGetFoldersForDocument(ByRef pQueryParams) As %Status
{
	Try {
		Set tError="",tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSDocumentEntryEntryUUID","Only1",0),
																$lb("$XDSDocumentEntryUniqueId","Only1",0)),
															.tType) {
			Quit
		}
		Set tIdx=""
		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				If tType="$XDSDocumentEntryEntryUUID" {
					Set tAryDocIDs(tID) = ""
				} Else {
					Set tSC = ##class(HS.Registry.Document).IIDForUniqueID(tID,.tAryDocIDs)
				}
				Set tDocumentIID=""
				For  {
					Set tDocumentIID=$O(tAryDocIDs(tDocumentIID)) Quit:tDocumentIID=""
					Set tSC=##class(HS.Registry.Document.Association).SourceIDsForTargetIID(tDocumentIID,.tSourceIDs) 
					
					Set tSourceID="" 
					For  {
						Set tFilter=0
						Set tSourceID=$o(tSourceIDs(tSourceID)) Quit:tSourceID=""
						Set tAssociationID=tSourceIDs(tSourceID)
						//Set tAssociationStatus = ##class(HS.Registry.Document.Association).StatusGetStored(tAssociationID)
						If ..filterAssociation(.pQueryParams,tAssociationID) Continue

						Set tFolderID = ##class(HS.Registry.Document.RegistryPackage).ItemForEntryID(tSourceID,"F")
						If tFolderID="" Continue
						Set tFolder=##class(HS.Registry.Document.RegistryPackage).%OpenId(tFolderID)
						If '$IsObject(tFolder) {
							If ##class(HS.Registry.Document.RegistryPackage).%ExistsId(tFolderID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open folder:"_tFolderID)
							Continue
						}
						Do ..AddToOutputSet(,tFolder)
					}
				}
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// test 11909
/// find associations for specified document then return documents related to associations (including the document found)
Method queryGetRelatedDocuments(ByRef pQueryParams) As %Status
{
	Try {
		Set tSC=$$$OK
		If '..validateRequiredQueryParameters(.pQueryParams,$lb($lb("$XDSDocumentEntryEntryUUID","Only1",0),
																$lb("$XDSDocumentEntryUniqueId","Only1",0),
																$lb("$AssociationTypes",1,1),
																$lb("$XDSDocumentEntryType",0,1)),
															.tType) {
			Quit
		}
		Set tIdx=""
		For  {
			Set tIdx=$o(pQueryParams(tType,tIdx))
			Quit:tIdx=""
			Set tID=""
			For  {
				Set tID=$o(pQueryParams(tType,tIdx,tID))
				Quit:tID=""
				If tType="$XDSDocumentEntryEntryUUID" {
					Set tDocumentID = ##class(HS.Registry.Document).DocumentForEntryID(tID)
					Set:tDocumentID]"" tAryDocIDs(tDocumentID)=""
				} Else {
					Set tSC = ##class(HS.Registry.Document).DocumentForUniqueID(tID,.tAryDocIDs,0)
				}
				
				Set tDocumentID="" 
				For  {
					Set tDocumentID=$o(tAryDocIDs(tDocumentID)) Quit:tDocumentID=""
					Set tDocument = ##class(HS.Registry.Document).%OpenId(tDocumentID)
					If $D(pQueryParams("$XDSDocumentEntryType")) {
						Set tFilter = 0
						Set tSC = ..FilterByDocumentType(tDocument,"$XDSDocumentEntryType",.pQueryParams,.tFilter)
						If tFilter Continue
					}
					$$$HSTRACE("Locating Associations for Document","tDocumentID,tDocument",tDocumentID,tDocument)
					Set tAssociationType=""
					For  {
						Set tCounter=$o(pQueryParams("$AssociationTypes","")) Quit:tCounter=""
						Set tAssociationType=$o(pQueryParams("$AssociationTypes",tCounter,tAssociationType)) Quit:tAssociationType=""
						#; get the association ID's for associated documents
						$$$HSTRACE("Checking Associations for Document and type","tDocumentID,tDocument",tDocumentID,tDocument,tAssociationType)
						Set tLogicalType = ##class(HS.Types.IHE.Association).LogicalToDisplay(tAssociationType)
						Set tSC=##class(HS.Registry.Document.Association).IDsForIID(tDocument.IID,.tAssociations,tLogicalType)
					}
					Set tAssociationID="" 
					$$$HSTRACE("Adding document and associations","tDocumentID,tDocument,tAssociations",tDocumentID,tDocument,..aryToList(.tAssociations))
					For  {
						Set tAssociationID=$o(tAssociations(tAssociationID)) Quit:tAssociationID=""
						Set tAssociation=##class(HS.Registry.Document.Association).%OpenId(tAssociationID)
						If '$IsObject(tAssociation) {
							If ##class(HS.Registry.Document.Association).%ExistsId(tAssociationID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open association:"_tAssociationID)
							Continue
						}
						If ..filterAssociation(.pQueryParams,,tAssociation) Continue

						#; Check other document type before inserting association/document
						Set tSourceID = ##class(HS.Registry.Document).DocumentForEntryID(tAssociation.SourceObject)
						Set tTargetID = ##class(HS.Registry.Document).DocumentForEntryID(tAssociation.TargetObject)
						Set tOtherID = $S(tSourceID=tDocumentID:tTargetID,1:tSourceID)
						If tOtherID = "" Continue  //the association is not a document
						Set tOtherDoc = ##class(HS.Registry.Document).%OpenId(tOtherID)
						If '$IsObject(tOtherDoc) {
							If ##class(HS.Registry.Document).%ExistsId(tOtherID) Do ..OutputSet.logError("XDSRegistryMetadataError","Error","unable to open document:"_tOtherID)
							Continue
						}
						
						If $D(pQueryParams("$XDSDocumentEntryType")) {
							Set tFilter = 0
							Set tSC = ..FilterByDocumentType(tOtherDoc,"$XDSDocumentEntryType",.pQueryParams,.tFilter)
							If tFilter Continue
						}
						#; Only insert associations/documents once
						If '$D(tAddedA(tAssociationID)) Do ..AddToOutputSet(,,tAssociation) Set tAddedA(tAssociationID)=""
						If '$D(tAddedD(tDocumentID)) Do ..AddToOutputSet(tDocument) Set tAddedD(tDocumentID)=""
						If '$D(tAddedD(tOtherID)) Do ..AddToOutputSet(tOtherDoc) Set tAddedD(tOtherID)=""
					}
				}
			}
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..OutputSet.logError("XDSRegistryMetadataError","Error","Internal Error: "_$ze)
	}		
	Quit tSC
}

/// Adding related document to the metadata request - where the original is updated or deleted
Method AddRelatedDocument(pObj As HS.Registry.Document) As %Status
{
	Try {
		Set tSC=$$$OK
		Set tDocument = ##class(HS.Types.IHE.XDSb.Document).%New()
		Do tDocument.CopyFrom(pObj,tDocument)
		/// ***todo fix the objecttype
		Set tDocument.ObjectType= tDocument.ObjectTypeDisplayToLogical(tDocument.ObjectType)
		Set tDocument.EntryUUID=pObj.IID
		Set tDocument.LogicalUUID=pObj.LogicalIID
		Set tDocument.RepositoryUniqueId=pObj.RepositoryUniqueID
		Set tDocument.SourcePatientId=pObj.SourcePatientID
		Set tDocument.DocumentUniqueIdentifier=pObj.DocumentUniqueIdentifier
		Set tDocument.SourceIdentifier=pObj.SourceIdentifier
		Set tDocument.AvailabilityStatus=pObj.Status
		Do tDocument.Names.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(pObj.Title))
		Do tDocument.Descriptions.Insert(##class(HS.Types.IHE.XDSb.ValueType).%New(pObj.Comments))
		Set tDocument.PatientIdentifier=pObj.PatientIdentifier

		For tI=1:1:pObj.Slots.Count() {
			Set tSlot=pObj.Slots.GetAt(tI)
			Continue:tSlot.Name'="sourcePatientInfo"
			For tJ=1:1:tSlot.ValueList.Count() {
				Set tSlotType=##class(HS.Types.IHE.XDSb.SlotValue).%New()
				Set tSlotType.Value=tSlot.ValueList.GetAt(tJ)
				Do tDocument.SourcePatientInfo.Insert(tSlotType)
			}
			Quit
		}
		
		Set tAuthObj=##class(HS.IHE.XDSb.Types.Author).%New()
		Set tAuthObj.AuthorPerson=pObj.SlotValueForObject("authorPerson")
		Set tAuthObj.AuthorInstitution=pObj.SlotValueForObject("authorInstitution")
		Do tDocument.Author.Insert(tAuthObj)
				
		Do ..info("ConvertedRequest").RelatedDocuments.Insert(tDocument)
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

/// build a string with the array values, if pComplete=1 build the string without the array node, just the value
Method aryToList(ByRef %pAry, pComplete = 0) As %String
{
	New %q
	Set tID="",tString="",%q="%pAry("""")"
	For  {
		Set %q=$q(@%q) Quit:%q=""
		If pComplete {
			Set tString=tString_@%q
		} Else {
			Set tString=tString_""""_%q_"="_@%q_""","
		}
	}
	Quit tString
}

}
