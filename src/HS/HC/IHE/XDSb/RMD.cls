Include (HS.HC, HS.IHE.XDSb, HS.HC.TraceHelper, HS.IHE.ATNA, HS.HC.IHE.XDSb.RMD)

Class HS.HC.IHE.XDSb.RMD Extends HS.Util.BaseHost [ Abstract ]
{

/// pRequest could be either an internal message (from our administrator) or an IHE external message
Method ExecuteDeleteDocumentSet(pRequest As Ens.Request, ByRef pResponse As Ens.Response) As %Status
{
	Set tSC = $$$OK
	try {
		Set pRequest.Name = $$$XDSbDeleteDocumentSetRequest
		Set tInternal=0
		If pRequest.%IsA("HS.Message.IHE.XDSb.DeleteDocumentSetRequest") {
			/// internal from administrator
			Set tInternal=1
			Set pResponse=##class(HS.Message.IHE.XDSb.DeleteDocumentSetResponse).%New()
			/// Build array of items to delete, because this is internal we also include Submission sets and Associations and validate appends/transforms/signs
			Do ..BuildDeleteDocumentArray(pRequest,.tAry)
			$$$HSTRACE("Errors","Errors",..Errors)
			If ..Errors.HighestError'="Error" {
				/// move SS entries into those being deleted
				Merge tmp = tAry("DE") 
				Kill tAry("I")
				Kill tAry("DE")
				Merge tAry=tmp
				If '$D(tAry) {
					Do ..Errors.logError("UnresolvedReferenceException","Error","item not located")
				} Else {
					Do ..ProcessDelete(.tAry,pRequest,.pResponse)
				}
			}
			/// either an error up front or processing could have caused the error
			If ..Errors.Errors.Count() {
				For tIdx = 1:1:..Errors.Errors.Count() {
					Do pResponse.Errors.Errors.Insert(..Errors.Errors.GetAt(tIdx))
				}
			}
		} ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			Set pResponse = ##class(HS.Message.XMLMessage).%New()
			/// Given the request (external) build a list of items which also must be included submission sets, associations and validate appends/transforms/signs
			Do ..ExternalCalculateObjects(pRequest,.tAry)
			Set tUUID = ""
			Merge tmp = tAry("DE")
			Kill tAry("DE")
			Merge tAry=tmp
			For  {
				Set tUUID = $O(tAry(tUUID),1,tIdx) Quit:tUUID=""
				Continue:tUUID="I"
				If '$D(tAry("I",tUUID)) {
					Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT ID From HS_Registry_Document.Association where IID=?",tUUID)
					If tRS.%Next() {
						Set tType = "Association"
					} Else {
						Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT Type From HS_Registry_Document.RegistryPackage where IID=?",tUUID)
						If tRS.%Next() {
							Set tType=tRS.Type
						} Else {
								Set tRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT Type From HS_Registry.Document where IID=?",tUUID)
							If tRS.%Next() {
								Set tType="Document"
							} Else {
								Set tType="UNKNOWN"
							}
						}
					}
					Do ..Errors.logError("UnresolvedReferenceException","Error","Expected "_tType_" UUID "_tUUID_" but it was not found ","") 
					Continue
				}
			}
			Kill tAry("I")
			If ..Errors.HighestError'="Error" {
				Do ..ProcessDelete(.tAry,pRequest,.pResponse)
			} Else {
				Do ..GenerateResponse(.pResponse)
			}

		}
		//Do ..GenerateExternalMessages(.tAry,.pRequest,.pResponse)  /// For auditing generate the external request/response content stream

	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method GenerateResponse(pResponse As HS.Message.XMLMessage)
{
	Set tStream=##class(%Stream.GlobalCharacter).%New()
	Do ..Errors.XMLExportToString(.tErrors)
	Do tStream.Write("<Submission>"_tErrors_"</Submission>")
	Set tParam("status")=$S(..Errors.Errors.Count()=0:"Success",1:"Failure")
	Do tStream.Rewind()
	$$$HSTRACESTARTCALL
	Set tSC = ..Transformer.Transform(tStream,..RegisterResponseTransform /*"IHE/XDSb/Version1/RegisterResponse.xsl"*/,.tResponseStream,.tParam)
	$$$HSTRACEENDCALL
	If $$$ISERR(tSC) {
		$$$LOGSTATUS(tSC)
	} Else {
		Do pResponse.ContentStream.CopyFrom(tResponseStream)
	}
	Set pResponse.Name = $$$XDSbDeleteDocumentSetResponse

	Quit tSC
}

/// Generate response message
Method GenerateExternalMessages(ByRef pAry As %String, pRequest As HS.Message.IHE.XDSb.DeleteDocumentSetRequest, pResponse As HS.Message.IHE.XDSb.DeleteDocumentSetResponse)
{
	Set tStream = pRequest.ContentStream
	Set tID = "" 
	For {
		Set tID = $O(pAry(tID)) Quit:tID=""
		If tStream.Size=0 {
			Do tStream.WriteLine("<lcm:RemoveObjectsRequest xmlns:lcm='urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0'><rim:ObjectRefList xmlns:rim='urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0'>")
		}
		Do tStream.WriteLine("<rim:ObjectRef id='"_tID_"'/>")
	}
	Do tStream.WriteLine("</rim:ObjectRefList></lcm:RemoveObjectsRequest>")
	For tIdx = 1:1:..Errors.Errors.Count() {
		Do pResponse.Errors.Errors.Insert(..Errors.Errors.GetAt(tIdx))
	}
}

/// Given internal HS.Message.IHE.XDSb.DeleteDocumentSetRequest extract IIDs from ObjectRefs or calcualte IIDs from UniqueIdentifiers
/// Add any errors or warnings to Errors collection
Method BuildDeleteDocumentArray(pRequest As HS.Message.IHE.XDSb.DeleteDocumentSetRequest, Output pAryToDelete) As %Status
{
	#dim eException As %Exception.AbstractException
	Try {
		Set tSC = $$$OK
		For tIdx = 1:1:pRequest.ObjectRefs.Count() {
			Set (tUUID,tSourceUUID)=pRequest.ObjectRefs.GetAt(tIdx)
			If tUUID="" Do ..Errors.logError("UnresolvedReferenceException","Error","UUID is null "_tIdx,"/lcm:RemoveObjectsRequest/rim:ObjectRefList/rim:ObjectRef["_tIdx_"]/@id") Continue
			If $e($zcvt(tUUID,"l"),1,9)'="urn:uuid:" {
				Do ..Errors.logError("XDSbRegistry","Warning","urn:uuid: missing from entry","/lcm:RemoveObjectsRequest/rim:ObjectRefList/rim:ObjectRef["_tIdx_"]/@id")
				Set tUUID="urn:uuid:"_tUUID
			} 
			Set pAryToDelete("I",tUUID)=$lb(tIdx)
		}
		If pRequest.UniqueIdentifiers.Count() {
			Set tSQL = "SELECT IID From HS_Registry.Document Where DocumentUniqueIdentifier_Value = ?"
			Set tSQLAssociation = "SELECT IID,SourceObject,AssociationType from HS_Registry_Document.Association where SourceObject=? or TargetObject=?"
			Set tUniqueId = ""
			For {
				Set tValue = pRequest.UniqueIdentifiers.GetNext(.tUniqueId)
				Quit:tUniqueId=""
				Set tRS = ##class(%SQL.Statement).%ExecDirect(.tStmtUniqueId,tSQL,tUniqueId)
				If 'tRS.%Next() {
					Do ..Errors.logError("XDSbRegistry","Error","Document not found for "_tUniqueId_" at ["_tIdx_"]")
				} Else {
					/// A single unique id may have multiple versions, remove each item and associations
					For {
						Set pAryToDelete("I",tRS.IID)=$lb(tIdx,tUniqueId)
						Set tRSAssociation = ##class(%SQL.Statement).%ExecDirect(.tStmtAssociation,tSQLAssociation,tRS.IID,tRS.IID)
						While tRSAssociation.%Next() {
							/// check to see that source object is a registry package and not a document
							Set tRSRP = ##class(%SQL.Statement).%ExecDirect(.tStmtRP,"SELECT ID FROM HS_Registry_Document.RegistryPackage WHERE IID=?",tRSAssociation.SourceObject)
							If tRSRP.%Next() {
								Set pAryToDelete("I",tRSAssociation.IID)=$lb(tIdx)
							}
						}
						Quit:'tRS.%Next()
					}
				}
			}
		}
		Do ..CalculateDeleteObjects(.pAryToDelete)
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

/// For an external message determine extract the uuid's and from that determine which UUID's should be in the list
Method ExternalCalculateObjects(pRequest As HS.Message.XMLMessage, Output pAryToDelete) As %Status
{
	#dim eException As %Exception.AbstractException
	Try {
		Set tSC = ##class(HS.IHE.Util).GetXPathExpression(pRequest.ContentStream,"/lcm:RemoveObjectsRequest/rim:ObjectRefList/rim:ObjectRef","@id",.tObjectRefs,.tDocument)
		Quit:$$$ISERR(tSC)
		If tObjectRefs.Count()=0 {
			Do ..Errors.logError("UnresolvedReferenceException","Error","No UUID's found","/lcm:RemoveObjectsRequest/rim:ObjectRefList/rim:ObjectRef/@id")
		} Else {
			For tIdx = 1:1:tObjectRefs.Count() {
				Set (tUUID,tSourceUUID)=tObjectRefs.GetAt(tIdx).Value
				If tUUID="" Do ..Errors.logError("UnresolvedReferenceException","Error","UUID is null CDDSO "_tIdx,"/lcm:RemoveObjectsRequest/rim:ObjectRefList/rim:ObjectRef["_tIdx_"]/@id") Continue
				If $e($zcvt(tUUID,"l"),1,9)'="urn:uuid:" {
					Do ..Errors.logError("XDSbRegistry","Warning","urn:uuid: missing from entry","/lcm:RemoveObjectsRequest/rim:ObjectRefList/rim:ObjectRef["_tIdx_"]/@id")
					Set tUUID="urn:uuid:"_tUUID
				} 
				Set pAryToDelete("I",tUUID)=$lb(tIdx)
			}
			Do ..CalculateDeleteObjects(.pAryToDelete)

		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
		$$$LOGSTATUS(tSC)
	}
	Quit tSC
}

Method RemoveNonEmptySubmissionSets(ByRef pAryToDelete)
{
	/// For submission sets check to see if they are empty after removal of all items
	Set tSQL="select IID,AssociationType,SourceObject,TargetObject FROM HS_Registry_Document.Association where SourceObject=? "
	Set tUUID = ""
	For {
		Set tUUID=$O(pAryToDelete("DE",tUUID)) Quit:tUUID=""
		Set tRS = ##class(%SQL.Statement).%ExecDirect(.tStatement2,tSQL,tUUID)
		Set tEmpty=1
		While tRS.%Next() {
			Set tTargetObject = tRS.TargetObject
			If '$D(pAryToDelete("I",tTargetObject)) && '$D(pAryToDelete(tTargetObject)) {
				Kill pAryToDelete("DE",tUUID) 
				Quit
			}
		}
	}
}

/// for each "I",UUID find associations, submission sets, folders, documents (transforms, appends, signs)
Method CalculateDeleteObjects(ByRef pAryToDelete) As %Status
{
	Set tSC = $$$OK
	Set tSQL="select IID,AssociationType,SourceObject,TargetObject FROM HS_Registry_Document.Association where (SourceObject=? or TargetObject=?) "
	Set tUUID=""
	For {
		Set tUUID = $O(pAryToDelete("I",tUUID),1,tIdx) Quit:tUUID=""
		Set tObject = ##class(HS.Registry.Document).IIDIndexOpen(tUUID,0,.tSC)
		If $IsObject(tObject) {
			Set tType = "D",tAdditional = $lb(tType,tObject.ObjectType,tObject.PatientIdentifier.Value,tObject.DocumentUniqueIdentifier.Value,tObject.RepositoryUniqueID)
		} Else {
			Set tObject = ##class(HS.Registry.Document.RegistryPackage).IIDIndexOpen(tUUID,0,.tSC)
			If $IsObject(tObject) {
				Set tType = tObject.Type,tAdditional=$lb(tType,tObject.Node.Value,tObject.PatientIdentifier.Value)
			} ElseIf '$IsObject(tObject) {
				Set tObject = ##class(HS.Registry.Document.Association).IIDIndexOpen(tUUID,0,.tSC)
				If $IsObject(tObject) {
					/// object is association
					Set tType = "A",tAdditional=$lb(tType,tObject.AssociationType,tObject.SourceObject,tObject.TargetObject)
					If tObject.AssociationType="HasMember" {
						Set tRPObject = ##class(HS.Registry.Document.RegistryPackage).IIDIndexOpen(tObject.SourceObject,0,.tSC)
						If tRPObject.Type = "F" {
							/// For folders it's okay to delete the association without deleting the target object
							Set pAryToDelete(tUUID)=tAdditional
							Continue
						}
					}
					If '$D(pAryToDelete("I",tObject.TargetObject)) {
						Do ..Errors.logError("UnresolvedReferenceException","Error","Expected UUID "_tObject.TargetObject_" from "_tObject.AssociationType_" for "_tUUID,"") 
					}
				} Else {
					$$$ThrowStatus($$$ERROR($$$GeneralError,"UUID not found at position "_$lg(tIdx)))
				}
			}
		}
		Set pAryToDelete(tUUID)=tAdditional
		Set tRS = ##class(%SQL.Statement).%ExecDirect(.tStatement,tSQL,tUUID,tUUID)
		If tRS.SQLCODE $$$ThrowStatus( $$$ERROR($$$GeneralError,tRS.%Message))

		While tRS.%Next() {
			/// document & document - replacement,transform or update
			/// SS & document (hasmember)
			/// Folder & document (hasmember)
			/// SS & Folder (hasmember)
			Set pAryToDelete(tRS.IID)=$lb("A",tRS.AssociationType,tRS.SourceObject,tRS.TargetObject)  /// add association to delete list
			Continue:tType="A"

			/// for Documents or RegistryPackage (SS or F)
			/// "I"nbound document is source object in this association, the target object must also be deleted
			If tUUID = tRS.SourceObject {

				If tType="F" && ($Data(pAryToDelete("I",tRS.IID))) {
					/// if a folder and the assocation is targetted for delete it's taken care of
					Continue
				}
				If '$D(pAryToDelete("I",tRS.TargetObject)) {
					Do ..Errors.logError("UnresolvedReferenceException","Error","For "_$S(tType="D":"Document",tType="SS":"Submission Set",tType="F":"Folder",1:tType)_" expected UUID "_tRS.TargetObject_" based on association "_tRS.IID_" with "_tRS.AssociationType,"") 
					Continue
				}
			} Else {
				/// tUUID = tRS.TargetObject
				/// document is target object, source could be SS,F, or a document
				If tRS.AssociationType = "HasMember" || (tRS.AssociationType = "UpdateAvailabilityStatus") {
					/// folder or SS
					Set tRPObject = ##class(HS.Registry.Document.RegistryPackage).IIDIndexOpen(tRS.SourceObject,0)
					If '$isObject(tRPObject) {
						Do ..Errors.logError("XDSbRegistry","Error","Missing Registry Package for association "_tRS.IID,"") 
						Continue
					}
					If tRPObject.Type="SS" {
						Set pAryToDelete("DE",tRS.SourceObject)=$lb(tRPObject.Type,tRPObject.Node.Value,tRPObject.PatientIdentifier.Value)
					}
				} Else {
					If '$D(pAryToDelete("I",tRS.SourceObject)) {
						Do ..Errors.logError("UnresolvedReferenceException","Error","For Document expected UUID "_tRS.SourceObject_" based on association "_tRS.IID_" with "_tRS.AssociationType,"") 
						Continue
					}
				}
			}
		}

	}
	Do ..RemoveNonEmptySubmissionSets(.pAryToDelete)
	Quit tSC
}

/// order by type so that they are deleted in the correct order
Method ProcessDelete(ByRef pAryToDelete, pRequest As Ens.Request, ByRef pResponse As Ens.Response)
{
	Kill $$$RMDTemp
	Set tUUID = ""
	For  {
		Set tUUID = $O(pAryToDelete(tUUID),1,tData) Quit:tUUID=""
		continue:$l(tUUID)=1
		Set tType = $li(tData)
		If tType="A" {
			Set tParent = $lg(tData,3)
			Set tPatientID = ""
			If $D(pAryToDelete(tParent),tOtherData) {
				Set tPatientID = $LI(tOtherData,3)

			} Else  {
				Set tChild = $lg(tData,4)
				If $D(pAryToDelete(tChild),tOtherData) {
					Set tPatientID = $LI(tOtherData,3)
				}
			}
		} Else {
			Set tType = $Case(tType,"SS":"R","F":"R",:tType)
			Set tPatientID = $LI(tData,3)
		}
		If tPatientID]"" Do ..lockEntries("A",tPatientID)
		Set $$$RMDTemp(tPatientID_" ",tType,tUUID)=tData
	}
	Do ..DeleteDocumentSetEntries(.pRequest,.pResponse)
	Kill $$$RMDTemp
}

/// Called by DeleteDocumentSet to be an atomic transaction
///  
/// <Method>DeleteDocumentSetEntries</Method> is called after preparing the list of uuid's by patient common for both internal and external requests.
///  <li>At this point the request has been validated, the items are about to be deleted, removed document objects will be sent to the publisher</li>
/// 	 <Parameter>pRequest as Ens.Request, could be either HS.Message.IHE.XDSb.DeleteDocumentSetRequest or HS.Message.XMLMessage</Parameter>
/// 	 <Parameter>pResponse as Ens.Response, could be either HS.Message.IHE.XDSb.DeleteDocumentSetResponse or HS.Message.XMLMessage</Parameter>
/// </Method>
/// 
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br><br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to other business hosts using pHost.SendRequestAsync or pHost.SendRequest.Sync<br><br>
///  
///   <Method>ClassMethod OnPreDeleteDocumentSetEntries(pHost As Ens.Host ,ByRef pStop as %Boolean, pRequest As Ens.Request, ByRef pResponse as %Ens.Response) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error). </li>
/// 	<li>Objects (uuids) to be deleted are in $$$RMDTemp(patient_id _ " ", type, uuid) which contains the list of uuid's to be deleted,where PatientID may be null, type is A(ssociation),R(egistryPackage),D(ocument)</li>
/// 	<li>Complete processing can be done and set pStopProcessing=1 with a return status of $$$OK</li>
/// 	<li>Updates can be done to $$$RMDTemp and set pStopProcessing=0 with a return status of $$$OK</li>
/// 	<li>Errors can be thrown with pStopProcessing=1 and a return value error status</li>
/// 
Method DeleteDocumentSetEntries(pRequest As Ens.Request, ByRef pResponse As Ens.Response) As %Status [ Private ]
{
	try {
		Set tSC = $$$OK
		$$$OnPre(.tStop,pRequest,.pResponse)
		If $G(tStop) || $$$ISERR(tSC) {
			Quit
		}
		TSTART
		Set tPatientID = ""
		For {
			Quit:$$$ISERR(tSC)
			Set tPatientID = $O($$$RMDTemp(tPatientID)) Quit:tPatientID=""
			Kill tAryToDelete
			Merge tAryToDelete = $$$RMDTemp(tPatientID)
			#; delete the entries in order
			For tType = "A","D","R" {
				Quit:$$$ISERR(tSC)
				Set tClass = $S(tType="A":"Document.Association",tType="R":"Document.RegistryPackage",1:"Document")
				Set tUUID="" 
				For  {
					Set tUUID=$O(tAryToDelete(tType,tUUID),1,tData) Quit:tUUID=""
					Set tExists = $classMethod("HS.Registry."_tClass,"IIDIndexExists",tUUID,.id) 
					If 'tExists Set tSC = $$$ERROR($$$GeneralError,"IID specified does not exist "_tUUID) Quit
					Set pOutput(tUUID)=tData
					If tType="D" && (..Publisher]"") {
						If '$D(tPublished(id)) {
							Set tDocument = ##class(HS.Registry.Document).%OpenId(id)
							Set tPublished(id)=""
							Do ..AddRelatedDocument(tDocument)
						}
					}
					Set tSC = $classMethod("HS.Registry."_tClass,"%DeleteId",id)
					If $$$ISERR(tSC) {
						Do ..Errors.logError("XDSRegistryMetadataError","Error","Internal Error:"_$system.Status.GetErrorText(tSC))
						Quit
					}
				}
			}
			Kill tAryToDelete
		}
	}
	Catch eException {
		Set tSC = eException.AsStatus()
		Do ..Errors.logError("XDSRegistryMetadataError","Error","Internal Error: "_$system.Status.GetErrorText(tSC))
	}
	If $$$ISERR(tSC) {
		If $Tlevel {
			TROLLBACK 
		}
		$$$LOGSTATUS(tSC)
	} Else {
		If $Tlevel {
			TCOMMIT
		}
	}
	Do ..GenerateResponse(pResponse)
	If $$$ISOK(tSC) {
		If 'pRequest.AdditionalInfo.IsDefined("SOAPAction") {Do pResponse.AdditionalInfo.SetAt($$$XDSbDeleteDocumentSetAction(1),"SOAPAction")}
		If 'pRequest.AdditionalInfo.IsDefined("WSA:From") {Do pResponse.AdditionalInfo.SetAt("http://"_$$$HSNetworkHostName_"/Internal","WSA:From")}
		If 'pRequest.AdditionalInfo.IsDefined("WSA:To") {Do pResponse.AdditionalInfo.SetAt("http://"_$$$HSNetworkHostName_"/Internal","WSA:To")}
		Set tClone = pResponse.%ConstructClone(1)
		Set tPatientID = ""
		For  {
			Set tPatientID = $Order($$$RMDTemp(tPatientID)) Quit:tPatientID=""
			Set tResponse = tClone.%ConstructClone(1)
			Do tResponse.AdditionalInfo.SetAt(tPatientID,"$patient")
			Do pResponse.AdditionalInfo.SetAt(tPatientID,$E(100000+$I(tOverallCount),2,6)_"_$patient")
			Set tCount = 0 
			For tType = "A","D","R" {
				Set tUUID = ""
				For  {
					Set tUUID = $O($$$RMDTemp(tPatientID,tType,tUUID),1,tData) Quit:tUUID=""
					Do tResponse.AdditionalInfo.SetAt($lg(tData,2),"$uuid_"_tUUID)
					Do pResponse.AdditionalInfo.SetAt($LTS(tData,"|^|^|"),$e(100000+$I(tOverallCount),2,6)_"_$uuid")
					If tType="D" {
						/// if the document still exists (multiple versions) don't return it in the collection so that the administrator doesn't issue the delete to the repository
						Set tDocumentID = $lg(tData,4)
						Set tRepositoryUniqueID = $lg(tData,5)
						Set tRS = ##class(%SQL.Statement).%ExecDirect(.tDocExistsStatemnt,"Select TOP 1 ID FROM HS_Registry.Document where DocumentUniqueIdentifier_Value=?",tDocumentID)
						If 'tRS.%Next() {
							Do pResponse.AdditionalInfo.SetAt(tRepositoryUniqueID,"$documents_"_$li(tData,4))
						}
					}
				}
			}
			$$$HSTRACE("audit","pRequest,tResponse",pRequest,tResponse)
			Do $$$ATNAEvent("XDSbRegistry",pRequest,tResponse,tSC)
		}
	}
	Quit tSC
}

}
