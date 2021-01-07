/// IHE XDSb Document Source Actor 
/// Given a CDA stream extract relevant data and build ProvideAndRegister transaction
Class HS.AU.IHE.XDSb.DocumentSource.Operations Extends HS.IHE.XDSb.DocumentSource.Operations [ Inheritance = right, ProcedureBlock ]
{

Parameter SETTINGS = "ZipOperations";

Property ZipOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.Util.Zip.Operations" ];

/// Send documents inline instead of as attachments
Property DocumentsInline As %Boolean [ InitialExpression = 1 ];

/// See %HSHOME%/csp/xslt/IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl for an example
Property DocumentTransform As %String(MAXLEN = 255) [ InitialExpression = "AU/IHE/XDSb/Version1/DocumentToProvideAndRegister.xsl" ];

/// Allow a different header class by overriding paramter value
Parameter HEADERCLASS = "HS.AU.PCEHR.WebRequest";

/// The XDSb Consumer operation - if the document(s) is replacing an other document locate the existing document using a query with the ReplacementContext
Property XDSbConsumerOperations As %String [ InitialExpression = "HS.AU.IHE.XDSb.Consumer.Operations" ];

/// Australian specific Provide and Register
/// 	Only a single document is permitted
/// In the Australian Standard the document needs to be signed and zipped
/// If the document is in the Body versus BodyCharacter we will assume it is already the zipped document
/// 	and the correct metadata is set and this code is just doing the P&R
/// 	If the document is in the BodyCharacter we are signing and zipping the document and updating the metadata where required (when not set already)
Method AttachDocuments(pUpdatedRequest As HS.AU.Message.IHE.XDSb.ProvideAndRegisterRequest, pOutboundRequest As HS.Message.XMLMessage) As %Status
{
	try {
		Set tSC = $$$OK
		$$$HSTRACE("Requests","pOutboundRequest,pUpdatedRequest",pOutboundRequest,pUpdatedRequest)
		#; only 1 document in the Australian Standard
		Set tDocument = pUpdatedRequest.Documents.GetAt(1)
		Set tAttach = ##class(HS.IHE.Common.Messages.MIMEAttachment).%New()
		Set tAttach.ContentId=tDocument.EntryUUID
		#; if we have a body inbound, then the manifest is already created and signed
		If tDocument.Body.Size {
			If '..DocumentsInline {Do tAttach.Body.CopyFrom(tDocument.Body)}
		} Else {
			#; build a manifest, sign it and zip it
			Set tServiceName = pOutboundRequest.AdditionalInfo.GetAt("ServiceName")
			Set tService=##class(HS.Registry.Service.SOAP).EndPointForNameType(tServiceName,"SOAP")
			If '$ISObject(tService) Set tSC=$$$ERROR($$$GeneralError,"Unknown service registry entry - required for signing") Quit
			Set tCredentials = ##class(%SYS.X509Credentials).%OpenId(tService.SignX509TokenProfile)
			Set tReference=##class(%XML.Security.Reference).%New()
			Set tReference.URI="CDA_ROOT.XML"
			// Allow override of SHA version to use SHA1 when required for AU services.  
			// This allows simpler changing when AU services update to use SHA256
			Set tSHAVer = ##class(HS.Registry.Config).GetKeyValue("\AustralianCustomisations\SHAVersion","")
			If tSHAVer = "SHA1"
			{
				Set tReference.DigestMethod.Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"
				Set tReference.DigestValue=$system.Encryption.SHA1HashStream(tDocument.BodyCharacter)
			}
			Else
			{
				// Default to SHA256
				Set tReference.DigestMethod.Algorithm="http://www.w3.org/2000/09/xmldsig#sha256"
				Set tReference.DigestValue=$system.Encryption.SHAHashStream(256,tDocument.BodyCharacter)
			}
			Set tManifest = ##class(HS.AU.SMD.ManifestType).%New()
			Do tManifest.Reference.Insert(tReference)
			Set teSig=##class(HS.AU.SMD.eSignatureDataType).%New()
			Set teSig.Manifest=tManifest
			Set tDateTime=pUpdatedRequest.SubmissionTime
			If tDateTime="" {
				Set tDateTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(##class(HS.Util.XSLTHelper).timestamp())_"Z"
				Set tDateTime=$e(tDateTime,1,4)_"-"_$e(tDateTime,5,6)_"-"_$e(tDateTime,7,8)_"T"_$E(tDateTime,9,10)_":"_$E(tDateTime,11,12)_":"_$E(tDateTime,13,14)
			}
			Set teSig.SigningTime=tDateTime
			Set teSig.Approver=("http://ns.electronichealth.net.au/id/hi/hpii/1.0/"_pUpdatedRequest.Approver)
			Set tSPD=##class(HS.AU.SMD.SignedPayloadType).Create(teSig,tCredentials,.tSC)
			Set tWriter=##class(%XML.Writer).%New()
			set tWriter.NoXMLDeclaration=1
			Set tSC=tWriter.OutputToStream(.tSign)
			If $$$ISOK(tSC) Set tSC=tWriter.StartDocument()
			If $$$ISOK(tSC) Set tSC=tWriter.RootObject(tSPD)
			If $$$ISOK(tSC) Set tSC=tWriter.EndDocument()
						
			Set tZipMessage=##class(HS.Message.ZipRequest).%New()
			Set tZipMessage.Operation="ToZip"
			Set tZipItem = ##class(HS.Types.ZipItem).%New()
			Set tZipItem.Path="/IHE_XDM/SUBSET01/"
			Set tZipItem.Filename="CDA_ROOT.xml"
			Do tZipItem.File.CopyFrom(tDocument.BodyCharacter)
			Do tZipMessage.Items.Insert(tZipItem)

			Set tZipItem = ##class(HS.Types.ZipItem).%New()
			Set tZipItem.Path="/IHE_XDM/SUBSET01/"
			Set tZipItem.Filename="CDA_SIGN.xml"
			Do tZipItem.File.CopyFrom(tSign)
			Do tZipMessage.Items.Insert(tZipItem)
			
			// Add in attachments from tDocument.ZipItems if present
			Set tIdx=1
			For tIdx=1:1:tDocument.ZipItems.Count() {
				Set tAttachmentItem=tDocument.ZipItems.GetAt(tIdx)
				Set tZipItem = ##class(HS.Types.ZipItem).%New()
				// Ignores the Path property of the AttachmentItem, as all files go into the same path in the zip archive
				Set tZipItem.Path="/IHE_XDM/SUBSET01/"
				Set tZipItem.Filename=tAttachmentItem.Filename
				Do tZipItem.File.CopyFrom(tAttachmentItem.File)
				Do tZipMessage.Items.Insert(tZipItem)
			}
			
			Set tSC = ..SendRequestSync(..ZipOperations,tZipMessage,.tZipResponse)
			If '..DocumentsInline {Do tAttach.Body.CopyFrom(tZipResponse.File)}
			Else {
				Do tDocument.BodyCharacter.Clear()
				Do tDocument.Body.Clear()
				Do tDocument.Body.CopyFrom(tZipResponse.File)
			}
		}
		Do:'..DocumentsInline pOutboundRequest.StreamCollection.Insert(tAttach)
	} Catch ex { 
		Set tSC=ex.AsStatus() 
	}
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	Quit tSC
}

/// Take the inbound request fetch any missing values and build outbound request
Method BuildRequest(pInboundRequest As HS.AU.Message.IHE.XDSb.ProvideAndRegisterRequest, pOutboundRequest As HS.Message.XMLMessage, ByRef pUpdatedRequest As HS.AU.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	If pInboundRequest.Documents.Count()'=1 Set tSC = $$$ERROR($$$GeneralError,"One document entry is required / allowed") Quit tSC
	Quit ##super(pInboundRequest,.pOutboundRequest,.pUpdatedRequest)
}

Method XDSbProvideAndRegisterRequest(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, Output pResponse As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest) As %Status
{
	Set pWebRequest = $classMethod(..#HEADERCLASS,"%New")
	Quit ##super(pRequest,.pResponse,pWebRequest)
}

/// if the request is CDA we may need to extract values from the document and update the request
/// for this reason tUdpatedRequest is used so that the original transaction is not updated
Method GetUpdatedProvideRequest(pRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest, Output pUpdatedRequest As HS.Message.IHE.XDSb.ProvideAndRegisterRequest) As %Status
{
	#define CloneObject Set tDocument=pUpdatedRequest.Documents.GetAt(tIdx)
	try {
		Set pUpdatedRequest=pRequest.%ConstructClone(1) 
		Set tSC=$$$OK
		$$$HSTRACE("patientid","patientid",pRequest.PatientId)
		If pRequest.PatientId="" Set tSC = ..GetUpdatedPatientId(pRequest,.pUpdatedRequest) Quit:$$$ISERR(tSC)

		For tIdx=1:1:pUpdatedRequest.Documents.Count() {
			#dim tDocument as HS.Message.IHE.XDSb.Document = pUpdatedRequest.Documents.GetAt(tIdx)
			
			// Validate that HealthcareFacilityTypeCode and PracticeSettingCode are defined by the source, as these cannot be 
			// extracted from the document.
			If tDocument.HealthcareFacilityTypeCode.Code="" {
				Set tSC = $$$ERROR($$$GeneralError,"HealthcareFacilityTypeCode is required.")
				Quit
			}
			If tDocument.PracticeSettingCode.Code="" {
				Set tSC = $$$ERROR($$$GeneralError,"PracticeSettingCode is required.")
				Quit
			}
			
			Set tDocObject=""
			Set:tDocument.PatientId="" tDocument.PatientId=$S($isObject(pUpdatedRequest):pUpdatedRequest.PatientId,1:pRequest.PatientId)
			#; locate document to replace
			$$$HSTRACE("ReplacementContext.Count() - "_tDocument.ReplacementContext.Count())
			If tDocument.ReplacementContext.Count() $$$CloneObject Set tSC=..GetReplacementId(tDocument,pUpdatedRequest.PatientId) Quit:$$$ISERR(tSC)

			#; if it is binary we will not extract values
			If 'tDocument.BodyCharacter.Size Continue
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:typeId","@root",.tValue,.tDocObject)
			/// if there is no value for the typeId it is not CDA
			If $$$ISERR(tSC) || (tValue="") Continue
			
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:id","@root",.tValue,.tDocObject)
			If tValue'="" {
				Set tDocument.UniqueId=tValue
				Set pUpdatedRequest.UniqueId=tValue
			}
			Set pUpdatedRequest.EntryUUID="SUBSET_SYMBOLICID_01"
			Set tDocument.EntryUUID="DOCUMENT_SYMBOLICID_01"
			
			If tDocument.CreationTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tValue,.tDocObject)
				#; if there is a value, it probably has an offset, we need to drop the offset for creation time
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.CreationTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tValue)
			}
			/*
				A= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/@value"
				B= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low/@value"
				C= "/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value"
				D= "/cda:ClinicalDocument/cda:effectiveTime/@value"
 
				The UTC date we will use is the first one that has a value.
 
					serviceStartTime = B,A,D (only going to get A or B, never both, defaulting back to D which is mandatory)
					serviceEndTime   = C,A,D (only going to get A or C, never both, defaulting back to D which is mandatory)
			*/
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime","@value",.tA,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:low","@value",.tB,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:high","@value",.tC,.tDocObject)
			Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:effectiveTime","@value",.tD,.tDocObject)
			If tDocument.ServiceStartTime="" {
				Set tTime=$S($G(tB)]"":tB,$G(tA)]"":tA,1:$g(tD))
				Set tDocument.ServiceStartTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
			}
			If tDocument.ServiceStopTime="" {
				Set tTime=$S($G(tC)]"":tC,$G(tA)]"":tA,1:$g(tD))
				Set tDocument.ServiceStopTime=##class(HS.Util.XSLTHelper).xmltimestampToUTC(tTime)
			}

			If tDocument.LanguageCode="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:languageCode","@code",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.LanguageCode=tValue
			}
			If tDocument.SourcePatientId="" {
				// If this is a AU CDA document, look down in ext:asEntityIdentifier for an IHI.
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@root",.tValueRoot,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/ext:asEntityIdentifier[ext:id/@assigningAuthorityName='IHI']/ext:id","@extension",.tValueExtension,.tDocObject)
				If $Extract(tValueRoot,1,27)="1.2.36.1.2001.1003.0.800360",tValueExtension="" Set tValueExtension=$Extract(tValueRoot,22,*),tValueRoot="1.2.36.1.2001.1003.0"
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && (tValueExtension]"") && (tValueRoot]"") $$$CloneObject Set tDocument.SourcePatientId=tValueExtension_"^^^&"_tValueRoot_"&ISO"
			}
			If tDocument.ServiceStartTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:low","@value",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.ServiceStartTime=tValue
			}
			If tDocument.ServiceStopTime="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:documentationOf/hl7:serviceEvent/hl7:effectiveTime/hl7:high","@value",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.ServiceStopTime=tValue
			}
			If tDocument.Title="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:title","text()",.tValue,.tDocObject)
				If $$$ISOK(tSC) && (tValue]"") $$$CloneObject Set tDocument.Title=tValue
			}
			If tDocument.ConfidentialityCode.Count()=0 {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@code",.tCode,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@codeSystem",.tScheme,.tDocObject)
				Set tSC3 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:confidentialityCode","@displayName",.tDescription,.tDocObject)
				// Document-level confidentialityCode is a fixed value of "NA", default in the coded entry value:
				If tCode="",tScheme="" Set tCode="GENERAL",tScheme="PCEHR_DocAccessLevels",tDescription="NA"
				If $$$ISOK(tSC) && $$$ISOK(tSC2) && $$$ISOK(tSC3) $$$CloneObject Do tDocument.ConfidentialityCode.Insert(##class(HS.IHE.XDSb.Types.CodedValue).Create(tCode,tScheme,tDescription))
			}
			
			/* Do not need to send SourcePatientInfo
			If tDocument.SourcePatientInfo.Count()=0 {
				$$$CloneObject
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-3|"_tDocument.SourcePatientId))
				#; patient name
				Set tPID="PID-5|"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:family","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue_"^"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[1]","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue_"^"
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:name/hl7:given[2]","text()",.tValue,.tDocObject)
				Set tPID=tPID_tValue
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New(tPID))
				#; BirthDate
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime","@value",.tValue,.tDocObject)
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-7|"_tValue))
				#; Gender
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode","@code",.tValue,.tDocObject)
				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-8|"_tValue))
				#; Address

				Set tStreet=""				
				Set tSC = tDocObject.EvaluateExpression("/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:streetAddressLine", "text()", .tResults)
				For tIdx=1:1:tResults.Count() { Set tStreet=tStreet_";"_tResults.GetAt(tIdx).Value}
				Set tPID=$e(tStreet,2,*)
				
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:additionalLocator","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:city","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:state","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:recordTarget/hl7:patientRole/hl7:addr[1]/hl7:postalCode","text()",.tValue,.tDocObject)
				Set tPID=tPID_"^"_tValue

				Do tDocument.SourcePatientInfo.Insert(##class(HS.IHE.XDSb.Types.SlotValue).%New("PID-11|"_tPID))

			}
			*/
			If tDocument.Author.Count()=0 {
				///cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']/@root
				
				Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
				Set tSC1 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']","@root",.tHPII,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']","@root",.tHPIO,.tDocObject)
    			Set tAuthor.AuthorPerson = "^"_pRequest.SAMLData.UserName_"^^^^^^^&"_tHPII_"&ISO"
    			
				If $$$ISOK(tSC1) && $$$ISOK(tSC2) {
					Do tAuthor.AuthorInstitution.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New(pRequest.SAMLData.Organization_"^^^^^^^^^"_tHPIO))
					Do tDocument.Author.Insert(tAuthor)
				}
			}
						
			If tDocument.TypeCode.Code="" {
				// A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set tDocCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tDocCodeSystem)
				Set tDocCodeSystemNameUp = $ZCVT(tDocCodeSystemName,"U")
				
				// First look for the Code with the OID as the CodingScheme.
				// If not found then look for the Code with the OID's IdentityCode (case-insensitive) as the CodingScheme.
				If tDocCode'="",tDocCodeSystem'="" {
					Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='typeCode' AND Code=?"
					Set tStatement = ##class(%SQL.Statement).%New()
					Set tStatement.%SelectMode = 2
					Set tStatus = tStatement.%Prepare(tSQL)
					Set tResultSet = tStatement.%Execute(tDocCode)
					While tResultSet.%Next() {
						Set tCodeSchemes($ZCVT(tResultSet.CodingScheme,"U"))=tResultSet.CodingScheme_"|"_tResultSet.Description
					}
					Kill tResultSet
					Kill tStatement
					If $Data(tCodeSchemes(tDocCodeSystem))#10 {
						Set tDocument.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystem),"|",1),$Piece(tCodeSchemes(tDocCodeSystem),"|",2))
					} Else {
						If $Data(tCodeSchemes(tDocCodeSystemNameUp))#10 Set tDocument.TypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",1),$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",2))
					}
					Kill tCodeSchemes
				}
			}
			
			If tDocument.ClassCode.Code="" {
				If $Get(tDocCode)="" {
					// A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
					Quit:$$$ISERR(tSC)
					Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
					Quit:$$$ISERR(tSC)
					Set tDocCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tDocCodeSystem)
					Set tDocCodeSystemNameUp = $ZCVT(tDocCodeSystemName,"U")
				}
				
				// First look for the Code with the OID as the CodingScheme.
				// If not found then look for the Code with the OID's IdentityCode (case-insensitive) as the CodingScheme.
				If tDocCode'="",tDocCodeSystem'="" {
					Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='classCode' AND Code=? AND CodingScheme='LOINC'"
					Set tStatement = ##class(%SQL.Statement).%New()
					Set tStatement.%SelectMode = 2
					Set tStatus = tStatement.%Prepare(tSQL)
					Set tResultSet = tStatement.%Execute(tDocCode)
					While tResultSet.%Next() {
						Set tClassCodeScheme=tResultSet.CodingScheme
						Set tClassCodeDesc=tResultSet.Description
						Set tCodeSchemes($ZCVT(tClassCodeScheme,"U"))=tClassCodeScheme_"|"_tClassCodeDesc
					}
					Kill tResultSet
					Kill tStatement
					If $Data(tCodeSchemes(tDocCodeSystem))#10 {
						Set tDocument.ClassCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystem),"|",1),$Piece(tCodeSchemes(tDocCodeSystem),"|",2))
					} Else {
						If $Data(tCodeSchemes(tDocCodeSystemNameUp))#10 Set tDocument.ClassCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",1),$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",2))
					}
					Kill tCodeSchemes
				}
			}
			
			// Attempt to determine FormatCode from ClassCode.  
			// SRF - May need to dump this, and force source to specify their formatCode, since it identifies the template package ID for the CDA document
			// 		And there is nothing in the CDA that gives this information.  
			If tDocument.FormatCode.Code="" {
				// Get FormatCode if needed by using ClassCode as a reference.  The ClassCode's Description matches the start of the FormatCode's Description
				// Except for Referral Summary, which has a ClassCode Desc of "e-Referral".
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
				Quit:$$$ISERR(tSC)
				If tClassCodeDesc="e-Referral" Set tClassCodeDesc="Referral"
				&SQL(Select Description into :tClassCodeDesc from HS_IHE.CodedEntry WHERE CodeType='classCode' AND Code=:tDocCode and CodingScheme='LOINC')
				Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='formatCode' and CodingScheme='PCEHR_FormatCodes' and Description like '"_tClassCodeDesc_"%'"
				Set tStatement = ##class(%SQL.Statement).%New()
				Set tStatement.%SelectMode = 2
				Set tStatus = tStatement.%Prepare(tSQL)
				Set tResultSet = tStatement.%Execute()
				Do tResultSet.%Next()
								
				Set tDocument.FormatCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tResultSet.Code,tResultSet.CodingScheme,tResultSet.Description)
				
				Kill tResultSet
				Kill tStatement
			}
			
			// Submission Author
			If pUpdatedRequest.Author.Count()=0 {
				///cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']/@root
				
				Set tAuthor = ##class(HS.IHE.XDSb.Types.Author).%New()
				Set tSC1 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']","@root",.tHPII,.tDocObject)
				Set tSC2 = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']","@root",.tHPIO,.tDocObject)
    			Set tAuthor.AuthorPerson = "^"_pRequest.SAMLData.UserName_"^^^^^^^&"_tHPII_"&ISO"
    			If $$$ISOK(tSC1) && $$$ISOK(tSC2) {
	    			Do tAuthor.AuthorInstitution.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New(pRequest.SAMLData.Organization_"^^^^^^^^^"_tHPIO))
					Do pUpdatedRequest.Author.Insert(tAuthor)
    			}
			}
			
			// Submission ContentTypeCode
			If pUpdatedRequest.ContentTypeCode.Code="" {
				// A valid CDA document has an OID for document level code/@codeSystem, so assume it's an OID.
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@code",.tDocCode,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:code","@codeSystem",.tDocCodeSystem,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set tDocCodeSystemName = ##class(HS.Data.OIDMap).GetCodeForOID(tDocCodeSystem)
				Set tDocCodeSystemNameUp = $ZCVT(tDocCodeSystemName,"U")
				
				// First look for the Code with the OID as the CodingScheme.
				// If not found then look for the Code with the OID's IdentityCode (case-insensitive) as the CodingScheme.
				If tDocCode'="",tDocCodeSystem'="" {
					Set tSQL = "SELECT ID,Code,CodingScheme,Description FROM HS_IHE.CodedEntry WHERE CodeType='contentTypeCode' AND Code=? AND CodingScheme='LOINC'"
					Set tStatement = ##class(%SQL.Statement).%New()
					Set tStatement.%SelectMode = 2
					Set tStatus = tStatement.%Prepare(tSQL)
					Set tResultSet = tStatement.%Execute(tDocCode)
					While tResultSet.%Next() {
						Set tCodeSchemes($ZCVT(tResultSet.CodingScheme,"U"))=tResultSet.CodingScheme_"|"_tResultSet.Description
					}
					Kill tResultSet
					Kill tStatement
					If $Data(tCodeSchemes(tDocCodeSystem))#10 {
						Set pUpdatedRequest.ContentTypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystem),"|",1),$Piece(tCodeSchemes(tDocCodeSystem),"|",2))
					} Else {
						If $Data(tCodeSchemes(tDocCodeSystemNameUp))#10 Set pUpdatedRequest.ContentTypeCode = ##class(HS.IHE.XDSb.Types.CodedValue).Create(tDocCode,$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",1),$Piece(tCodeSchemes(tDocCodeSystemNameUp),"|",2))
					}
					Kill tCodeSchemes
				}
			}
			// Submission SourceId
			If pUpdatedRequest.SourceId="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']","@root",.tHPIO,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set pUpdatedRequest.SourceId=tHPIO
			}
			// Review SAMLData for any missing security header values
			// IHINumber = Patient Id
			If pUpdatedRequest.SAMLData.IHINumber="" {
				Set pUpdatedRequest.SAMLData.IHINumber=$p(pUpdatedRequest.PatientId,"^",1)
			}
			// NPI = HPII
			If pUpdatedRequest.SAMLData.NPI="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-I']","@root",.tHPII,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set pUpdatedRequest.SAMLData.NPI=tHPII
			}
			// OrganizationID = HPIO
			If pUpdatedRequest.SAMLData.OrganizationID="" {
				Set tSC = ##class(HS.IHE.Util).GetXPathValue(tDocument.BodyCharacter,"/hl7:ClinicalDocument/hl7:author/hl7:assignedAuthor/hl7:assignedPerson/ext:asEmployment/ext:employerOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='HPI-O']","@root",.tHPIO,.tDocObject)
				Quit:$$$ISERR(tSC)
				Set pUpdatedRequest.SAMLData.OrganizationID=tHPIO
			}
			// Set Approver for eSig.  Approver Id is HPII, Name is UserName
			If pUpdatedRequest.Approver.PersonId="" {
				Set pUpdatedRequest.Approver.PersonId=tHPII
				Set pUpdatedRequest.Approver.PersonName=pRequest.SAMLData.UserName
			}
			
			
		}
		Quit:$$$ISERR(tSC)		
		$$$HSTRACE("About to call update associations"_pUpdatedRequest.Associations.Count())
		Set tSC=..UpdateAssociations(pUpdatedRequest)
	} catch ex {
		Set tSC = ex.AsStatus()
		$$$HSTRACE("Error","tSC",tSC)
	}
	Quit tSC
}

Method GetReplacementId(pDocument As HS.Message.IHE.XDSb.Document, pPatientId) As %Status
{
	try {
		Set tSC=$$$OK
		$$$HSTRACE("in GetReplacementId")
		Set tReplacementQuery=##class(HS.Message.IHE.XDSb.QueryRequest).%New(),tHavePatientID=0,tHaveStatus=0
		Set tReplacementQuery.ReturnType="LC"  //needs to be LC so consumer can filter on custom slots
		If pDocument.ReplacementContext.Count()=1,pDocument.ReplacementContext.GetAt(1).ItemName="$XDSDocumentEntryUniqueId" {
			Set tReplacementQuery.QueryType="GetDocuments"
			Do tReplacementQuery.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).SingleParam(pDocument.ReplacementContext.GetAt(1).Values.GetAt(1),"$XDSDocumentEntryUniqueId"))
		} else {
			For tIdx=1:1:pDocument.ReplacementContext.Count() {
				Set tItem = pDocument.ReplacementContext.GetAt(tIdx)
				Do tReplacementQuery.Parameters.Insert(tItem)
				If tItem.ItemName="$XDSDocumentEntryPatientId" Set tHavePatientID=1
				If tItem.ItemName="$XDSDocumentEntryStatus" Set tHaveStatus=1
			}
			If 'tHaveStatus Do tReplacementQuery.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).StatusValues("Approved"))
			If 'tHavePatientID Do tReplacementQuery.Parameters.Insert(##class(HS.Message.IHE.XDSb.QueryItem).PatientId(pPatientId))
		}
		Do tRequest.AdditionalInfo.SetAt(tServiceObject.Name,"ServiceName")
		
		Set tSC = ..SendRequestSync(..XDSbConsumerOperations,tReplacementQuery,.tReplacementResponse)
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
		Set tCount=tReplacementResponse.Documents.Count()
		If tCount>1 $$$LOGWARNING("Registry returned more than one document with the same context, unable to issue replacement using document "_pDocument.EntryUUID) Quit
		Set:tCount pDocument.ReplaceSource=$p(tReplacementResponse.Documents.GetAt(1).EntryUUID,"urn:uuid:",2)
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
/// 	$XDSDocumentEntryEntryUUID
///		$XDSDocumentEntryUniqueId
///		$XDSDocumentEntryPracticeSettingCode
///		$XDSDocumentEntryClassificationNode
///		$XDSDocumentEntryClassCode
///		$XDSDocumentEntryConfidentialityCode
///		$XDSDocumentEntryEventCodeList
///		$XDSDocumentEntryFormatCode
///		$XDSDocumentEntryHealthcareFacilityTypeCode
///		$XDSDocumentEntryTypeCode
///		$XDSDocumentEntryType
///		$XDSDocumentEntryPatientId
///		$XDSDocumentEntryAuthorPerson
///		$XDSDocumentEntryServiceStartTimeFrom
///		$XDSDocumentEntryServiceStartTimeTo
///		$XDSDocumentEntryServiceStopTimeFrom
///		$XDSDocumentEntryServiceStopTimeTo
///		$XDSDocumentEntryStatus (will default to Approved)
}

}
