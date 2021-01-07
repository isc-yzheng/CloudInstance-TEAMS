Class HS.FHIR.vSTU3.MHD.Responder.Process Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper, HS.FHIR.vSTU3.MHD.Common) [ ClassType = persistent, Inheritance = right ]
{

Parameter HSDEPLOY = 1;

Parameter SETTINGS = "RetrieveTarget,QueryTarget,XDSbRetrieveConsentTarget,DocumentBodyInQueryResponse";

Property RetrieveTarget As Ens.DataType.ConfigName;

Property QueryTarget As Ens.DataType.ConfigName;

Property Errors As HS.Types.FHIR.Errors;

Property RepositoryOID As %String(MAXLEN = 64);

/// ConfigName of the business host for consent evaluation for retrieve responses.
/// By default, consent is not evaluated for retrieve.
Property XDSbRetrieveConsentTarget As Ens.DataType.ConfigName;

/// When this setting is True, a DocumentReference that is found by Document Query
/// (Find Document References, FHIR search) is returned with the document body stream
/// included in the Attachment data property.
Property DocumentBodyInQueryResponse As %Boolean [ InitialExpression = 0 ];

/// Defaults to \IHE\AffinityDomain [##class(HS.IHE.Util).GetAffinityDomain()]
/// if "" any patient will be accepted (versus turning off patient id validation) the AA in the request is sent to the 
Property AffinityDomain As %String [ InitialExpression = {##class(HS.IHE.Util).GetAffinityDomain()} ];

Property ResourceIdIndex As %Integer [ InitialExpression = 0 ];

/// Class package that is the root of all resource schemas for the desired data model.
Property ResourceSchemaRoot As %String(MAXLEN = 256) [ InitialExpression = "HS.FHIR.vSTU3.Model.Resource" ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set ..Errors = ##class(HS.Types.FHIR.Errors).%New()
		Set ..RepositoryOID = ##class(HS.Data.OIDMap).GetOIDForCode($namespace,"")
		Set ..ResourceIdIndex = 0
		If pRequest.%IsA("HS.Message.FHIR.Request") {
			If pRequest.Interaction'="capabilities" {
				Set tSC = ..ProcessMHDMessage(pRequest, .pResponse)
			} Else {
				Set tSC = ..ProcessMetadataRequest(pRequest, .pResponse)
			}
		} Else {
			Set tText = "Message class "_pRequest.%ClassName(1)_" not handled by MHD responder"
			Do ..Errors.logError("invalid", "error", tText, , , , tText) 
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
		Do ..Errors.logError("exception", "error", $system.Status.GetErrorText(tSC), , , , $system.Status.GetErrorText(tSC)) 	
	}
	
	If ..Errors.Errors.Count() {
		Set tSC = ..FHIRMHDErrorResponse(pRequest, .pResponse)
	} ElseIf $$$ISERR(tSC) {
		Set tSC = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tSC, pRequest.ContentType, .pResponse, pRequest.FormatFHIROutput)
		Set pResponse.Status = 500
	}
	
	Quit tSC
}

Method ProcessMHDMessage(pRequest As HS.Message.FHIR.Request, Output pResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		// If invalid ContentType per STU3 then change it to a valid ContentType.
		Set pRequest.ContentType = ##class(HS.FHIR.Utils).EnsureContentType(pRequest.ContentType, "STU3")
		
		Set tHostAndPort = ##class(HS.FHIR.Utils).GetHttpHostPort(pRequest)
		
		Set tSC = ##class(HS.FHIR.InteractionMetadata).InteractionByName(pRequest.Interaction, .tMetadata)
		If $$$ISERR(tSC) Quit
		Set tSC = tMetadata.BuildUrlFromMessage(pRequest, pRequest.BaseURL, .tURL)
		If $$$ISERR(tSC) Quit
		Set tSC = ##class(HS.FHIR.Utils).BuildQueryString(pRequest, .tURL)
		If $$$ISERR(tSC) Quit
		
		Set tFullRequestURI = tHostAndPort_tURL
		
		$$$HSTRACE("Reconstructed full URI", "tFullRequestURI", tFullRequestURI)
		
		If (pRequest.Type'="")&&('((pRequest.Type="DocumentManifest")||(pRequest.Type="DocumentReference")||(pRequest.Type="Binary"))) {
			Set tCode = "not-supported"
			Set tText = "Resource type "_pRequest.Type_" not supported on this end point"
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, tCode, tText)
			Set pResponse.Status = 404
		} ElseIf pRequest.Interaction="transaction" {
			Set tCode = "invalid"
			Set tText = "FHIR interaction "_pRequest.Interaction_" not supported on this end point"
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, tCode, tText)
		} ElseIf pRequest.Interaction="search" {
			Set tSC = ..QueryRequestMHD(pRequest, tFullRequestURI, .pResponse)
		} ElseIf (pRequest.Interaction="read")&&((pRequest.Type="")||(pRequest.Type="DocumentManifest")||(pRequest.Type="DocumentReference")) {
			Set tCode = "invalid"
			Set tText = "Read interaction on "_$Select(pRequest.Type="":"(blank)",1:pRequest.Type)_" resource type not supported on this end point"
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, tCode, tText)
		} ElseIf pRequest.Interaction="read" {
			Set tSC = ..RetrieveRequestMHD(pRequest, tFullRequestURI, .pResponse)
		} Else {
			Set tCode = "invalid"
			Set tText = "FHIR interaction "_pRequest.Interaction_" not supported on this end point"
			Set tSC = ##class(HS.FHIR.Utils).BadRequest(pRequest, .pResponse, tCode, tText)
		}
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ..Errors.Errors.Count() {
		Set tSC = ..FHIRMHDErrorResponse(pRequest, .pResponse)
	} ElseIf $$$ISERR(tSC) {
		Set tSC = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tSC, pRequest.ContentType, .pResponse, pRequest.FormatFHIROutput)
		Set pResponse.Status = 500
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

/// QueryRequestMHD converts an MHD Find Document Manifests or
/// Find Document References request into an XDSb FindSubmissions
/// or FindDocuments, forwards that request to an XDSb query
/// target, converts the XDSb response to a FHIR Bundle of
/// DocumentManifest resources or DocumentReference resources,
/// and returns the Bundle in the MHD Response.
Method QueryRequestMHD(pMHDRequest As HS.Message.FHIR.Request, pFullURI As %String, Output pMHDResponse As HS.Message.FHIR.Response) As %Status
{
	Try {
		#dim tXDSbQueryRequest As HS.Message.IHE.XDSb.QueryRequest
		#dim tXDSbQueryResponse As HS.Message.IHE.XDSb.QueryResponse
		
		If pMHDRequest.Type="DocumentManifest" {
			$$$HSTRACE("Message is Find Submissions request")
			Set tSC = ..RequestToFindSubmissions(pMHDRequest, .tXDSbQueryRequest)
		} Else {
			$$$HSTRACE("Message is Find Documents request")
			Set tSC = ..RequestToFindDocuments(pMHDRequest, .tXDSbQueryRequest)
		}
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
		Set tSC = ..SendRequestSync(..QueryTarget, tXDSbQueryRequest, .tXDSbQueryResponse)
		If $$$ISERR(tSC) Quit
		If '$IsObject($Get(tXDSbQueryResponse)) Set tSC = $$$ERROR($$$GeneralError,"Response object from XDSb query request not found") Quit
		If ..Errors.Errors.Count() Quit
		
		#; Create FHIR Query Response
		If pMHDRequest.Type="DocumentManifest" {
			Set tSC = ..QueryResponseToDocManifest(pMHDRequest, pFullURI, tXDSbQueryResponse, .pMHDResponse)
		} Else {
			Set tSC = ..QueryResponseToDocReference(pMHDRequest, pFullURI, tXDSbQueryResponse, .pMHDResponse)
		}
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method RetrieveRequestMHD(pMHDRequest As HS.Message.FHIR.Request, pFullURI As %String, Output pMHDResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		$$$HSTRACE("Message is Document Retrieve request")
		
		Set pMHDResponse = ##class(HS.Message.FHIR.Response).%New()
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pMHDResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tXDSbRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
		Set tXDSbRetrieveRequest.Name = "XDSb_RetrieveRequest"
		Set tContentStream = ##class(%Stream.GlobalCharacter).%New()
		Set tSC = tContentStream.Write("<RetrieveDocumentSetRequest xmlns=""urn:ihe:iti:xds-b:2007"">")
		Set tSC = tContentStream.Write("<DocumentRequest>")
		Set tObj = ##class(HS.Registry.Document.FHIR).FHIRIndexOpen("STU3", pMHDRequest.Id)
		If '$IsObject(tObj) {
			Set tText = pMHDRequest.Type_" resource id '"_pMHDRequest.Id_"' not found"
			Set tSC = ##class(HS.FHIR.Utils).CreateOutcomeSingleIssueStream(pMHDRequest.ContentType, .tResponseStream, "error", "not-found", tText, , , tText)
			If $$$ISERR(tSC) Quit
			Set pMHDResponse.Status = 404
			Quit
		}
		Set tSC = tContentStream.Write("<RepositoryUniqueId>"_tObj.RepositoryUniqueID_"</RepositoryUniqueId>")
		Set tSC = tContentStream.Write("<DocumentUniqueId>"_tObj.DocumentUniqueID_"</DocumentUniqueId>")
		Set tSC = tContentStream.Write("</DocumentRequest>")
		Set tSC = tContentStream.Write("</RetrieveDocumentSetRequest>")
		Set tSC = tXDSbRetrieveRequest.ContentStream.CopyFrom(tContentStream)
		Set tSC = tXDSbRetrieveRequest.AdditionalInfo.SetAt("urn:ihe:iti:2007:RetrieveDocumentSet","SOAPAction")
		
		If pMHDRequest.AdditionalInfo.GetAt("USER:UserID")'="" {
			Set tXDSbRetrieveRequest.SAMLData.UserName = pMHDRequest.AdditionalInfo.GetAt("USER:UserID")
		}
		If pMHDRequest.AdditionalInfo.GetAt("USER:Roles")'="" {
			Set tXDSbRetrieveRequest.SAMLData.HSRoles = pMHDRequest.AdditionalInfo.GetAt("USER:Roles")
		}
		
		#dim tXDSbRetrieveResponse As HS.Message.XMLMessage
		
		Set tSC=..SendRequestSync(..RetrieveTarget, tXDSbRetrieveRequest, .tXDSbRetrieveResponse)
		If $$$ISERR(tSC) {
			If $system.Status.GetErrorText(tSC)["Unable to locate document" {
				Do ..Errors.Errors.Clear()
				Do ..Errors.logError("not-found", "error", $system.Status.GetErrorText(tSC), , , , $system.Status.GetErrorText(tSC))
				Set tSC = $$$OK
				Quit
			}
		}
		If $$$ISERR(tSC) Quit
		If ..Errors.Errors.Count() {
			If ..Errors.Errors.GetAt(1).Description["Unable to locate document" {
				Do ..Errors.Errors.Clear()
				Do ..Errors.logError("not-found", "error", $system.Status.GetErrorText(tSC), , , , $system.Status.GetErrorText(tSC))
				Set tSC = $$$OK
				Quit
			}
		}
		If ..Errors.Errors.Count() Quit
		If '$IsObject($Get(tXDSbRetrieveResponse)) Set tSC = $$$ERROR($$$GeneralError,"Response object from XDSb retrieve request not found") Quit
		
		#dim tStreamCollection As HS.IHE.Common.Messages.MIMEAttachment
		
		Set tStreamCollection = tXDSbRetrieveResponse.StreamCollection.GetAt(1)
		
		// If the request specified to return the document as a FHIR resource, then
		// handle that here.
		Set tContentType = pMHDRequest.ContentType
		If (tContentType["application/fhir+xml")||(tContentType["application/fhir+json")||(tContentType["application/xml+fhir")||(tContentType["application/json+fhir") {
			Set pMHDResponse.ContentType = tContentType
			Set tBinary = ##class(HS.FHIR.vSTU3.Model.Resource.Binary).%New()
			Set tSC = tBinary.SetId(pMHDRequest.Id) Quit:$$$ISERR(tSC)
			Set tSC = tBinary.SetContentType(tStreamCollection.ContentType) Quit:$$$ISERR(tSC)
			Set tSC = tBinary.SetContent(tStreamCollection.Body.Read($$$MaxLocalLength)) Quit:$$$ISERR(tSC)
			Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pMHDRequest.ContentType, tBinary, .tResponseStream, pMHDRequest.FormatFHIROutput)
			Quit
		}
		
		#; Request ContentType property should never be null string.
		#; For MHD Retrieve, request ContentType property is a direct
		#; copy of the Accept header.  Loop through all of the mime
		#; types in the Accept header and find one that matches the
		#; mime type of the document, or find */* in the Accept header.
		Set tIsValidCT = 0
		For i = 1:1:$Length(pMHDRequest.ContentType, ",") {
			Set tCP = $Piece($Piece(pMHDRequest.ContentType, ",", i), ";", 1)
			If (tStreamCollection.ContentType=tCP)||(tCP="*/*") {
				Set tIsValidCT = 1
				Quit
			}
		}
		If 'tIsValidCT {
			Set pMHDResponse.Status = 406
			Quit
		}
		
		Set pMHDResponse.ContentType = tStreamCollection.ContentType
		Set tSC = tResponseStream.CopyFrom(tStreamCollection.Body)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// RequestToFindSubmissions uses the URL parameters of the MHD
/// request to formulate an HS.Message.IHE.XDSb.QueryRequest
/// object for a FindSubmissions query.
Method RequestToFindSubmissions(pMHDQueryRequest As HS.Message.FHIR.Request, ByRef pXDSbQueryRequest As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pXDSbQueryRequest = ##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		
		Set pXDSbQueryRequest.QueryType = "FindSubmissionSets"
		
		If pMHDQueryRequest.AdditionalInfo.GetAt("USER:UserID")'="" {
			Set pXDSbQueryRequest.RequestingUser = pMHDQueryRequest.AdditionalInfo.GetAt("USER:UserID")
			Set pXDSbQueryRequest.SAMLData.UserName = pMHDQueryRequest.AdditionalInfo.GetAt("USER:UserID")
		}
		If pMHDQueryRequest.AdditionalInfo.GetAt("USER:Roles")'="" {
			Set pXDSbQueryRequest.RequestingUserRoles = pMHDQueryRequest.AdditionalInfo.GetAt("USER:Roles")
			Set pXDSbQueryRequest.SAMLData.HSRoles = pMHDQueryRequest.AdditionalInfo.GetAt("USER:Roles")
		}
		
		#; This MHD Responder currently does NOT support Find DocumentManifests by patient.
		
		#; This MHD Responder DOES support Find DocumentManifests by patient.identifier. 
		
		
		#; URL param patient.identifier - Submission Set Patient Id (MPIID)
		Set tSC = ..AddSubjectIdentifier("$XDSSubmissionSetPatientId", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; Submission Set Unique Id
		If pMHDQueryRequest.GetParameterCount("identifier")>0 {
			Set tIdentifier = pMHDQueryRequest.GetParameterValue("identifier", 1)
			For i = 1:1:$Length(tIdentifier, ",") {
				Set tP = $Piece(tIdentifier, ",", i)
				If tP'="" Set tSC = pXDSbQueryRequest.AddParam(tP, "$XDSSubmissionSetUniqueId")
				If $$$ISERR(tSC) Quit
			}
		}
		If $$$ISERR(tSC) Quit
		
		#; URL param created - Submission Set Submission Start Date and/or End Date
		Set tSC = ..AddCreated("$XDSSubmissionSetSubmission", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL params author.given and author.family - Submission Set Author Name
		Set tSC = ..AddAuthorName("$XDSSubmissionSetAuthorPerson", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param type - Submission Set Document Content Type
		Set tSC = ..AddSingleToken("type", "$XDSSubmissionSetContentType", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param source - Submission Set Source Id
		Set tSC = ..AddSourceId("$XDSSubmissionSetSourceId", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param status - Submission Set Status
		Set tSC = ..AddStatus("$XDSSubmissionSetStatus", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

/// RequestToFindDocuments uses the URL parameters of the MHD
/// request to formulate an HS.Message.IHE.XDSb.QueryRequest
/// object for a FindDocuments query.
Method RequestToFindDocuments(pMHDQueryRequest As HS.Message.FHIR.Request, ByRef pXDSbQueryRequest As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Instantiate target message
		Set pXDSbQueryRequest = ##class(HS.Message.IHE.XDSb.QueryRequest).%New()
		
		Set pXDSbQueryRequest.QueryType = "FindDocuments"
		
		//return both stable and on-demand documents
		Do pXDSbQueryRequest.AddDocumentType(3)
		
		If pMHDQueryRequest.AdditionalInfo.GetAt("USER:UserID")'="" {
			Set pXDSbQueryRequest.RequestingUser = pMHDQueryRequest.AdditionalInfo.GetAt("USER:UserID")
			Set pXDSbQueryRequest.SAMLData.UserName = pMHDQueryRequest.AdditionalInfo.GetAt("USER:UserID")
		}
		If pMHDQueryRequest.AdditionalInfo.GetAt("USER:Roles")'="" {
			Set pXDSbQueryRequest.RequestingUserRoles = pMHDQueryRequest.AdditionalInfo.GetAt("USER:Roles")
			Set pXDSbQueryRequest.SAMLData.HSRoles = pMHDQueryRequest.AdditionalInfo.GetAt("USER:Roles")
		}
		
		#; This MHD Responder currently does NOT support Find DocumentReferences by patient.
		
		#; This MHD Responder DOES support Find DocumentReferences by patient.identifier. 
		
		
		#; URL param patient.identifier - Document Entry Patient Id (MPIID)
		Set tSC = ..AddSubjectIdentifier("$XDSDocumentEntryPatientId", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; Document Unique Id
		If pMHDQueryRequest.GetParameterCount("identifier")>0 {
			Set tIdentifier = pMHDQueryRequest.GetParameterValue("identifier", 1)
			For i = 1:1:$Length(tIdentifier, ",") {
				Set tP = $Piece(tIdentifier, ",", i)
				If tP'="" Set tSC = pXDSbQueryRequest.AddParam(tP, "$XDSDocumentEntryUniqueId")
				If $$$ISERR(tSC) Quit
			}
		}
		If $$$ISERR(tSC) Quit
		
		#; URL param indexed - Document Entry Creation Start Date and/or End Date
		Set tSC = ..AddCreated("$XDSDocumentEntryCreation", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL params author.given and author.family - Document Entry Author Name
		Set tSC = ..AddAuthorName("$XDSDocumentEntryAuthorPerson", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param status - Document Entry Status
		Set tSC = ..AddStatus("$XDSDocumentEntryStatus", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param class - Document Entry Class Code
		Set tSC = ..AddSingleToken("class", "$XDSDocumentEntryClassCode", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param type - Document Entry Type Code
		Set tSC = ..AddSingleToken("type", "$XDSDocumentEntryTypeCode", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param setting - Document Entry Practice Setting Code
		Set tSC = ..AddSingleToken("setting", "$XDSDocumentEntryPracticeSettingCode", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		
		#; URL param period - Currently not supported.

		
		#; URL param facility - Document Entry Facility Type Code
		Set tSC = ..AddSingleToken("facility", "$XDSDocumentEntryHealthcareFacilityTypeCode", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param event - Document Entry Event Code
		Set tSC = ..AddSingleToken("event", "$XDSDocumentEntryEventCodeList", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param securityLabel - Document Entry Confidentiality Code
		Set tSC = ..AddSingleToken("securityLabel", "$XDSDocumentEntryConfidentialityCode", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param format - Document Entry Format Code
		Set tSC = ..AddSingleToken("format", "$XDSDocumentEntryFormatCode", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
		#; URL param related-id - Document Entry Reference Id
		Set tSC = ..AddSingleToken("related-id", "$XDSDocumentEntryReferenceIdList", pMHDQueryRequest, .pXDSbQueryRequest)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

Method AddSingleToken(pParamURLName As %String, pParamXDSName As %String, pSource As HS.Message.FHIR.Request, pTarget As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tValue = pSource.GetParameterValue(pParamURLName)
		If tValue'="" {
			Set tScheme = $Piece(tValue,"|",1)
			If $Extract($ZConvert(tScheme,"L"),1,8)="urn:oid:" {
				Set tSchemeCode = $Extract(tScheme,9,*)
			} ElseIf ($Extract(tScheme,1,7)="http://")||($Extract(tScheme,1,8)="https://") {
				Set tSchemeCode = ##class(HS.Data.OIDMap).GetOIDForURL(tScheme)
			} Else {
				Set tSchemeCode = tScheme
			}
			Set tCode = $Piece(tValue,"|",2)
			Do pTarget.AddSingleParam(tCode_"^^"_tSchemeCode , pParamXDSName)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

Method AddSubjectIdentifier(pParamXDSName As %String, pSource As HS.Message.FHIR.Request, pTarget As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Document Entry Patient Id (MPIID)
		#; Piece 1 by vertical bar is assigning authority or patient domain.
		#; Piece 2 by vertical bar is the identifier.
		Set tIdentifier = pSource.GetParameterValue("patient.identifier")
		If tIdentifier'="" {
			Set tAA = $Piece(tIdentifier,"|",1)
			Set tId = $Piece(tIdentifier,"|",2)
			If $Extract(tAA,1,8)="urn:oid:" {
				Set tAA = $Extract(tAA,9,*)
			} ElseIf ($Extract(tAA,1,7)="http://")||($Extract(tAA,1,8)="https://") {
				Set tAA = ##class(HS.Data.OIDMap).GetOIDForURL(tAA)
			}
			Do pTarget.AddParam(tId_"^^^&"_tAA_"&ISO", pParamXDSName)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

Method AddSubjectIdentifierFromId(pParamXDSName As %String, pIdentifier As %String, pTarget As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; Document Entry Patient Id (MPIID)
		#; Piece 1 by vertical bar is assigning authority or patient domain.
		#; Piece 2 by vertical bar is the identifier.
		Set tAA = $Piece(pIdentifier,"|",1)
		Set tId = $Piece(pIdentifier,"|",2)
		If $Extract(tAA,1,8)="urn:oid:" {
			Set tAA = $Extract(tAA,9,*)
		} ElseIf ($Extract(tAA,1,7)="http://")||($Extract(tAA,1,8)="https://") {
			Set tAA = ##class(HS.Data.OIDMap).GetOIDForURL(tAA)
		}
		Do pTarget.AddParam(tId_"^^^&"_tAA_"&ISO", pParamXDSName)
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

Method AddCreated(pParamXDSNamePrefix As %String, pSource As HS.Message.FHIR.Request, pTarget As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		#; In IHE MHD, the parameter name used by Find Submissions is "created",
		#; and the parameter name used by Find Documents is "indexed".
		Set tParamName = $Select(pParamXDSNamePrefix="$XDSSubmissionSetSubmission":"created",pParamXDSNamePrefix="$XDSDocumentEntryCreation":"indexed",1:"created")
		
		If pSource.GetParameterValue(tParamName)'="" {
			Set tStartDateTime = ""
			Set tEndDateTime = ""
			
			#; Convert the FHIR date time based search parameters into XDSb inclusive search boundaries.
			
			#; The format of a FHIR dateTime search parameter is yyyy-mm-ddThh:mm:ss[Z|(+|-)hh:mm]
			
			#; XDSb start and end times are supposed to be stored in UTC.
			
			#; If the search value is a dateTime, as opposed to just a date, then convert it to UTC.
			
			For i = 1:1:pSource.GetParameterCount(tParamName) {
				Set tDateTime = pSource.GetParameterValue(tParamName,i)
				Set tDt12 = $Extract(tDateTime,1,2)
				If ((tDt12=">=")||(tDt12="ge")||(tDt12="<=")||(tDt12="le")||(tDt12="gt")||(tDt12="lt")||(tDt12="eq")||(tDt12="sa")||(tDt12="eb")) {
					Set tDateTime = $Extract(tDateTime,3,*)
					Set tDateTimePre = tDt12
				} ElseIf (tDt12=">")||(tDt12="<") {
					Set tDateTimePre = $Extract(tDateTime)
					Set tDateTime = $Extract(tDateTime,2,*)
				} Else {
					Set tDateTime = tDateTime
					Set tDateTimePre = "eq"
				}
				Set tDateTime = ##class(HS.FHIR.Utils).ConvertToUTC(tDateTime)
				Set tDateTime = $Extract(tDateTime,1,19)
				If '((tDateTime?4N)||(tDateTime?4N1"-"2N)||(tDateTime?4N1"-"2N1"-"2N)||(tDateTime?4N1"-"2N1"-"2N1"T"2N1":"2N)||(tDateTime?4N1"-"2N1"-"2N1"T"2N1":"2N1":"2N)) {
					$$$ThrowStatus($$$ERROR($$$GeneralError,"Invalid date format for "_tParamName_" - "_tDateTime))
				}
				Set tDateTime = $Translate(tDateTime,":-T")
				Set tDateTimeLen = $Length(tDateTime)
				Set tYear = $Extract(tDateTime,1,4)
				Set tMonth = $Extract(tDateTime,5,6)
				Set tDay = $Extract(tDateTime,7,8)
				Set tHour = $Extract(tDateTime,9,10)
				Set tMin = $Extract(tDateTime,11,12)
				Set tSec = $Extract(tDateTime,13,14)
				If ((tYear<1000)||(tMonth>12)||(tHour>23)||(tMin>59)||(tSec>59)) {
					$$$ThrowStatus($$$ERROR($$$GeneralError,"Invalid date for "_tParamName_" - "_tDateTime))
				}
				Set tLastDayOfMonth = ..LastDayOfMonth(tYear, tMonth)
				If (tMonth'="")&&(tDay'="")&&(tDay>tLastDayOfMonth) {
					$$$ThrowStatus($$$ERROR($$$GeneralError,"Invalid date for "_tParamName_" - "_tDateTime))
				}
				
				If (tDateTimePre=">=")||(tDateTimePre="ge") {
					If tDateTimeLen=14 {
						Set tStartDateTime = tDateTime
					} ElseIf tDateTimeLen=12 {
						Set tStartDateTime = tDateTime_"00"
					} ElseIf tDateTimeLen=8 {
						Set tStartDateTime = tDateTime_"000000"
					} ElseIf tDateTimeLen=6 {
						Set tStartDateTime = tDateTime_"01000000"
					} ElseIf tDateTimeLen=4 {
						Set tStartDateTime = tDateTime_"0101000000"
					}					
				} ElseIf (tDateTimePre=">")||(tDateTimePre="gt")||(tDateTimePre="sa") {
					Set tStartDateTime = ..GetGtValue(tYear, tMonth, tDay, tHour, tMin, tSec, tLastDayOfMonth)
				} ElseIf (tDateTimePre="<")||(tDateTimePre="lt")||(tDateTimePre="eb") {
					Set tEndDateTime = ..GetLtValue(tYear, tMonth, tDay, tHour, tMin, tSec)
				} ElseIf (tDateTimePre="<=")||(tDateTimePre="le") {
					If tDateTimeLen=14 {
						Set tEndDateTime = tDateTime
					} ElseIf tDateTimeLen=12 {
						Set tEndDateTime = tDateTime_"59"
					} ElseIf tDateTimeLen=8 {
						Set tEndDateTime = tDateTime_"235959"
					} ElseIf tDateTimeLen=6 {
						Set tEndDateTime = tDateTime_tLastDayOfMonth_"235959"
					} ElseIf tDateTimeLen=4 {
						Set tEndDateTime = tDateTime_"1231235959"
					}					
				} ElseIf (tDateTimePre="eq") {
					If tDateTimeLen=14 {
						Set tStartDateTime = tDateTime
						Set tEndDateTime = tDateTime
					} ElseIf tDateTimeLen=12 {
						Set tStartDateTime = tDateTime_"00"
						Set tEndDateTime = tDateTime_"59"
					} ElseIf tDateTimeLen=8 {
						Set tStartDateTime = tDateTime_"000000"
						Set tEndDateTime = tDateTime_"235959"
					} ElseIf tDateTimeLen=6 {
						Set tStartDateTime = tDateTime_"01000000"
						Set tEndDateTime = tDateTime_tLastDayOfMonth_"235959"
					} ElseIf tDateTimeLen=4 {
						Set tStartDateTime = tDateTime_"0101000000"
						Set tEndDateTime = tDateTime_"1231235959"
					}					
				} ElseIf (tDateTimePre="ne") {
					#; Not supported, can't convert to a single date range.					
				}
			}
			If tStartDateTime'="" Do pTarget.AddSingleParam(tStartDateTime, pParamXDSNamePrefix_"TimeFrom")
			If tEndDateTime'="" Do pTarget.AddSingleParam(tEndDateTime,  pParamXDSNamePrefix_"TimeTo")
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

ClassMethod LastDayOfMonth(pYear, pMonth) As %String
{
	If pMonth="" {
		Quit ""
	} ElseIf ((pMonth="01")||(pMonth="03")||(pMonth="05")||(pMonth="07")||(pMonth="08")||(pMonth="10")||(pMonth="12")) {
		Quit 31
	} ElseIf ((pMonth="04")||(pMonth="06")||(pMonth="09")||(pMonth="11")) {
		Quit 30
	} ElseIf ((pMonth="02")&&((pYear#4)>0)) {
		Quit 28
	} Else {
		Quit 29
	}
	Quit ""
}

/// Take the date time search value and add a second.
ClassMethod GetGtValue(pYear As %String, pMonth As %String, pDay As %String, pHour As %String, pMin As %String, pSec As %String, pLastDayOfMonth As %String) As %String [ Internal ]
{
	Set tStartDateTime = ""
	
	Set tDateTimeLen = $Length(pYear_pMonth_pDay_pHour_pMin_pSec)
	
	If tDateTimeLen=14 {
		If pSec<59 {
			Set pSec = pSec + 1
			If pSec<10 Set pSec = "0"_pSec
			Set tStartDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
		} Else {
			Set pSec = "00"
			If pMin<59 {
				Set pMin = pMin + 1
				If pMin<10 Set pMin = "0"_pMin
				Set tStartDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
			} Else {
				Set pMin = "00"
				If pHour<23 {
					Set pHour = pHour + 1
					If pHour<10 Set pHour = "0"_pHour
					Set tStartDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
				} Else {
					Set pHour = "00"
					If pDay<pLastDayOfMonth {
						Set pDay = pDay + 1
						If pDay<10 Set pDay = "0"_pDay
						Set tStartDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
					} Else {
						Set pDay = "01"
						If pMonth<12 {
							Set pMonth = pMonth + 1
							If pMonth<10 Set pMonth = "0"_pMonth
							Set tStartDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
						} Else {
							Set pMonth = "01"
							Set pYear = pYear + 1
							Set tStartDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
						}
					}
				}
			}
		}
	} ElseIf tDateTimeLen=12 {
		Set tStartDateTime = pYear_pMonth_pDay_pHour_pMin_"01"
	} ElseIf tDateTimeLen=8 {
		If pDay<pLastDayOfMonth {
			Set pDay = pDay + 1
			If pDay<10 Set pDay = "0"_pDay
			Set tStartDateTime = pYear_pMonth_pDay_"000000"
		} Else {
			Set pDay = "01"
			If pMonth<12 {
				Set pMonth = pMonth + 1
				If pMonth<10 Set pMonth = "0"_pMonth
			} Else {
				Set pYear = pYear + 1
				Set pMonth = "01"
			}
			Set tStartDateTime = pYear_pMonth_pDay_"000000"
		}
	} ElseIf tDateTimeLen=6 {
		If pMonth<12 {
			Set pMonth = pMonth + 1
			If pMonth<10 Set pMonth = "0"_pMonth
			Set tStartDateTime = pYear_pMonth_"01000000"
		} Else {
			Set pYear = pYear + 1
			Set pMonth = "01"
			Set tStartDateTime = pYear_pMonth_"01000000"
		}
	} ElseIf tDateTimeLen=4 {
		Set tStartDateTime = (pYear+1)_"0101000000"
	}
	
	Quit tStartDateTime
}

/// Take the date time search value and reduce it by a second.
ClassMethod GetLtValue(pYear As %String, pMonth As %String, pDay As %String, pHour As %String, pMin As %String, pSec As %String) As %String [ Internal ]
{
	Set tEndDateTime = ""
	
	Set tDateTimeLen = $Length(pYear_pMonth_pDay_pHour_pMin_pSec)
	
	If tDateTimeLen=14 {
		If pSec>0 {
			Set pSec = pSec - 1
			If pSec<10 Set pSec = "0"_pSec
			Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
		} Else {
			Set pSec = "59"
			If pMin>0 {
				Set pMin = pMin - 1
				If pMin<10 Set pMin = "0"_pMin
				Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
			} Else {
				Set pMin = "59"
				If pHour>0 {
					Set pHour = pHour - 1
					If pHour<10 Set pHour = "0"_pHour
					Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
				} Else {
					Set pHour = "23"
					If pDay>1 {
						Set pDay = pDay - 1
						If pDay<10 Set pDay = "0"_pDay
						Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
					} Else {
						If pMonth>1 {
							Set pMonth = pMonth - 1
							If pMonth<10 Set pMonth = "0"_pMonth
							Set pDay = ..LastDayOfMonth(pYear, pMonth)
							Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
						} Else {
							Set pDay = "31"
							Set pMonth = "12"
							Set pYear = pYear - 1
							Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
						}
					}
				}
			}
		}
	} ElseIf tDateTimeLen=12 {
		Set pSec = "59"
		If pMin>0 {
			Set pMin = pMin - 1
			If pMin<10 Set pMin = "0"_pMin
			Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
		} Else {
			Set pMin = "59"
			If pHour>0 {
				Set pHour = pHour - 1
				If pHour<10 Set pHour = "0"_pHour
				Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
			} Else {
				Set pHour = "23"
				If pDay>1 {
					Set pDay = pDay - 1
					If pDay<10 Set pDay = "0"_pDay
					Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
				} Else {
					If pMonth>1 {
						Set pMonth = pMonth - 1
						If pMonth<10 Set pMonth = "0"_pMonth
						Set pDay = ..LastDayOfMonth(pYear, pMonth)
						Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
					} Else {
						Set pDay = "31"
						Set pMonth = "12"
						Set pYear = pYear - 1
						Set tEndDateTime = pYear_pMonth_pDay_pHour_pMin_pSec
					}
				}
			}
		}
	} ElseIf tDateTimeLen=8 {
		If pDay>1 {
			Set pDay = pDay - 1
			If pDay<10 Set pDay = "0"_pDay
			Set tEndDateTime = pYear_pMonth_pDay_"235959"
		} Else {
			If pMonth>1 {
				Set pMonth = pMonth - 1
				If pMonth<10 Set pMonth = "0"_pMonth
				Set pDay = ..LastDayOfMonth(pYear, pMonth)
			} Else {
				Set pYear = pYear - 1
				Set pMonth = "12"
				Set pDay = "31"
			}
			Set tEndDateTime = pYear_pMonth_pDay_"235959"
		}
	} ElseIf tDateTimeLen=6 {
		If pMonth>1 {
			Set pMonth = pMonth - 1
			If pMonth<10 Set pMonth = "0"_pMonth
			Set tEndDateTime = pYear_pMonth_..LastDayOfMonth(pYear,pMonth)_"235959"
		} Else {
			Set pYear = pYear - 1
			Set pMonth = "12"
			Set tEndDateTime = pYear_pMonth_"31235959"
		}
	} ElseIf tDateTimeLen=4 {
		Set tEndDateTime = (pYear-1)_"1231235959"
	}
	
	Quit tEndDateTime
}

Method AddAuthorName(pParamXDSName As %String, pSource As HS.Message.FHIR.Request, pTarget As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tLastName = pSource.GetParameterValue("author.family")
		Set tFirstName = pSource.GetParameterValue("author.given")
		If (tLastName'="")||(tFirstName'="") {
			Do pTarget.AddParam("^"_tLastName_"^"_tFirstName_"^^^", pParamXDSName)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

Method AddSourceId(pParamXDSName As %String, pSource As HS.Message.FHIR.Request, pTarget As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	#; source is a uri type of parameter.
	Try {
		If pSource.GetParameterValue("source",1)'="" {
			Set tSources = ""
			For n = 1:1:pSource.GetParameterCount("source") {
				Set tSource = ""
				Set tSourceN = pSource.GetParameterValue("source",n)
				If $Extract(tSourceN, 1, 8)="urn:oid:" {
					Set tSourceN = $Extract(tSourceN, 9, *)
				}
			}
			Do pTarget.AddSingleParam(tSourceN, pParamXDSName)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

Method AddStatus(pParamXDSName As %String, pSource As HS.Message.FHIR.Request, pTarget As HS.Message.IHE.XDSb.QueryRequest) As %Status
{
	Set tSC = $$$OK
	
	#; status is a token type of parameter, but the status property
	#; is code.  If the parameter value includes a vertical bar then
	#; piece 1 by vertical bar must be empty.
	Try {
		If pSource.GetParameterValue("status",1)'="" {
			Set tStatuses = ""
			For n = 1:1:pSource.GetParameterCount("status") {
				Set tStatus = ""
				Set tStatusN = pSource.GetParameterValue("status",n)
				Set tStatusN1 = $Piece(tStatusN,"|",1)
				Set tStatusN2 = $Piece(tStatusN,"|",2)
				If (tStatusN1="")&&(tStatusN2'="") {
					Set tStatus = tStatusN2
				} ElseIf (tStatusN1'="")&&(tStatusN2="") {
					Set tStatus = tStatusN1
				}
				#; If the value was just a vertical bar, or both pieces
				#; by vertical bar have a value, then that is invalid.
				If tStatus="current" {
					Set tStatus = "Approved"
				} ElseIf tStatus="superseded" {
					Set tStatus = "Deprecated"
				} Else {
					Set tText = "Invalid status parameter value "_tStatusN
					Do ..Errors.logError("invalid", "error", tText, , , , tText)
					Quit
				}
				If tStatuses'="" Set tStatuses = tStatuses_","
				Set tStatuses = tStatuses_tStatus
			}
			If ..Errors.Errors.Count() Quit
			Do pTarget.AddStatusValues(tStatuses, pParamXDSName)
		} Else {
			Set tStatuses = "Approved,Deprecated"
			Do pTarget.AddStatusValues(tStatuses, pParamXDSName)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

/// QueryResponseToDocManifest converts the Submissions from an XDSb
/// Find Submissions response into FHIR DocumentManifest resource
/// objects, puts them into a FHIR Bundle and returns the Bundle in
/// an HS.Message.FHIR.Response message.
Method QueryResponseToDocManifest(pMHDRequest As HS.Message.FHIR.Request, pFullURI As %String, pXSDbQueryResponse As HS.Message.IHE.XDSb.QueryResponse, pMHDResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tBundle = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle).%New()
		
		Set tSC = tBundle.SetId($ZConvert($SYSTEM.Util.CreateGUID(),"L"))
		Set tSC = tBundle.SetTotal(pXSDbQueryResponse.Submissions.Count())
		Set tSC = tBundle.SetType("searchset")
		Set tSC = tBundle.SetLink("self",pFullURI)
		
		#dim tSubmission As HS.Message.IHE.XDSb.Submission
		
		For tSubmissionIndex = 1:1:pXSDbQueryResponse.Submissions.Count() {
			
			Set tSubmission = pXSDbQueryResponse.Submissions.GetAt(tSubmissionIndex)
			
			#dim tSubResponse As HS.Message.IHE.XDSb.QueryResponse
			
			#; FHIR requires that DocumentManifest contain references to the
			#; submission set's documents in the content collection property.
			#; Query the registry for the documents for this submission set.
			Set tSubQuery = ##class(HS.Message.IHE.XDSb.QueryRequest).%New()
			Set tSubQuery.QueryType = "GetSubSetsAndContents"
			Do tSubQuery.AddSingleParam(tSubmission.EntryUUID, "$XDSSubmissionSetEntryUUID")
			Set tSC = ..SendRequestSync(..QueryTarget, tSubQuery, .tSubResponse)
			If $$$ISERR(tSC) Quit			
			If '$IsObject($Get(tSubResponse)) Set tSC = $$$ERROR($$$GeneralError,"Response object from XDSb GetSubSetsAndContents request not found") Quit
			
			Set tDocumentManifest = ##class(HS.FHIR.vSTU3.Model.Resource.DocumentManifest).%New()
			
			Set tPatient = ##class(HS.FHIR.vSTU3.Model.Resource.Patient).%New()
			Set ..ResourceIdIndex = ..ResourceIdIndex + 1
			Set tContainedPatientResourceId = "contained-Patient-"_..ResourceIdIndex
			Set tSC = tPatient.SetId(tContainedPatientResourceId)
			
			Set tPatientId = $Piece(tSubmission.PatientId,"^",1)
			Set tPatientIdOID = $Piece(tSubmission.PatientId,"&",2)
			Set tPatientIdAA = ##class(HS.Data.OIDMap).GetCodeForOID(tPatientIdOID,tPatientIdOID)
			Set tSC = tPatient.SetIdentifier(tPatientId, "urn:oid:"_tPatientIdOID, "usual", , , "MPIID", , , , , , tPatientIdAA) Quit:$$$ISERR(tSC)
			
			Set tSC = tDocumentManifest.SetContained(tPatient) Quit:$$$ISERR(tSC)
			Set tSC = tDocumentManifest.SetSubject("#"_tContainedPatientResourceId,tPatientId) Quit:$$$ISERR(tSC)
			
			#dim tSubDocument As HS.Message.IHE.XDSb.Document
			
			Set tHostAndPort = ##class(HS.FHIR.Utils).GetHttpHostPort(pMHDRequest)
			Set tDocumentBaseURI = tHostAndPort_pMHDRequest.BaseURL
			If $Extract(tDocumentBaseURI,*)'="/" Set tDocumentBaseURI = tDocumentBaseURI_"/"
			
			Set tSC = tDocumentManifest.SetIdentifier(tSubmission.EntryUUID,,"official",,,"EntryUUID") Quit:$$$ISERR(tSC)
			
			For i = 1:1:tSubResponse.Documents.Count() {
				Set tSubDocument = tSubResponse.Documents.GetAt(i)
				Set tSC = ##class(HS.Registry.Document.FHIR).GetFHIRResourceId(tSubDocument.UniqueId, tSubDocument.RepositoryUniqueId, "STU3", .tResourceId)
				If $$$ISERR(tSC) Quit
				Set tContent = ##class(HS.FHIR.vSTU3.Model.Resource.DocumentManifest.Content).%New()
				Set tSC = tContent.SetPReference(tDocumentBaseURI_"DocumentReference/"_tResourceId)
				If $$$ISERR(tSC) Quit
				Do tDocumentManifest.content.Insert(tContent.%ConstructClone(1))
			}
			If $$$ISERR(tSC) Quit
			
			#; It is unclear how we can get to this point with 0 contents, but provide for it anyway.
			If tDocumentManifest.content.Count()=0 {
				Kill tDocumentManifest
				Set tPatientIdWarn = $Select(tSubmission.PatientId'="":tSubmission.PatientId,1:"(blank)")
				Set tEntryUUIDWarn = $Select(tSubmission.EntryUUID'="":tSubmission.EntryUUID,1:"(blank)")
				$$$LOGWARNING("No content objects extracted to FHIR DocumentManifest from XDSb submission set UUID="_tEntryUUIDWarn_" PatientId="_tPatientIdWarn_" - submission set skipped")
				Continue
			}
			
			Set tSC = tDocumentManifest.SetId(tSubmission.UniqueId) Quit:$$$ISERR(tSC)
			
			Set tSC = tDocumentManifest.SetDescription(tSubmission.Title) Quit:$$$ISERR(tSC)
			
			Set tSC = tDocumentManifest.SetMasterIdentifier("urn:oid:"_tSubmission.UniqueId,"urn:ietf:rfc:3986")
			
			#; subject not included because HS.Message.IHE.XDSb.Submission
			#; does not include patient demographics.
			
			Set tSC = tDocumentManifest.SetType(tSubmission.ContentTypeCode.Code, tSubmission.ContentTypeCode.Description, tSubmission.ContentTypeCode.Scheme)
			
			If ($IsObject(tSubmission.Author))&&(tSubmission.Author.Count()>0) {
				Set tPractitioner = ##class(HS.FHIR.vSTU3.Model.Resource.Practitioner).%New()
				Set ..ResourceIdIndex = ..ResourceIdIndex + 1
				Set tContainedPractitionerResourceId = "contained-Practitioner-"_..ResourceIdIndex
				Set tSC = tPractitioner.SetId(tContainedPractitionerResourceId)
				Set tSC = tPractitioner.SetName($Piece(tSubmission.Author.GetAt(1).AuthorPerson,"^",2),$Piece(tSubmission.Author.GetAt(1).AuthorPerson,"^",3),$Piece(tSubmission.Author.GetAt(1).AuthorPerson,"^",4))
				Set tSC = tDocumentManifest.SetContained(tPractitioner)
				Set tSC = tDocumentManifest.SetAuthor("#"_tContainedPractitionerResourceId) Quit:$$$ISERR(tSC)
			}
			
			#; XDSb SubmissionTime is supposed to be HL7v2 DTM format YYYYMMDDHHMMSS, in UTC.
			If tSubmission.SubmissionTime'="" {
				#; Convert to FHIR DateTime format, in the local time zone.
				Set tSubmissionTime = ##class(HS.FHIR.Utils).V2ToFHIRDateTime(tSubmission.SubmissionTime,1,1)
				Set tSC = tDocumentManifest.SetCreated(tSubmissionTime) Quit:$$$ISERR(tSC)
			}
			
			Set tSource = tSubmission.SourceId
			#; If tSource is an OID but lacks urn:oid: prefix then add it.
			If (##class(HS.HC.Util).IsOID(tSource))&&($Extract(tSource,1,8)'="urn:oid:") {
				Set tSource = "urn:oid:"_tSource
			}
			Set tSC = tDocumentManifest.SetSource(tSource)
			
			Set tStatus = $Select(tSubmission.AvailabilityStatus="Approved":"current",1:"superseded")
			Set tSC = tDocumentManifest.SetStatus(tStatus)
			
			Set tManifestURI = tHostAndPort_pMHDRequest.BaseURL_"/DocumentManifest/"_tSubmission.UniqueId
			
			Set tSC = tBundle.SetEntry(tDocumentManifest, , , tManifestURI)
		}
		If $$$ISERR(tSC) Quit
		
		#; Instantiate target message
		Set pMHDResponse = ##class(HS.Message.FHIR.Response).%New()
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pMHDResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pMHDRequest.ContentType, tBundle, .tResponseStream, pMHDRequest.FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		Set pMHDResponse.ContentType = "application/"_$Select($ZConvert(pMHDRequest.ContentType,"L")["json":"json",1:"xml")_"+fhir;charset=UTF-8"
		Set pMHDResponse.Type = pMHDRequest.Type
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// QueryResponseToDocReference converts the Documents from an XDSb
/// Find Documents response into FHIR DocumentReference resource
/// objects, puts them into a FHIR Bundle and returns the Bundle in
/// an HS.Message.FHIR.Response message.
Method QueryResponseToDocReference(pMHDRequest As HS.Message.FHIR.Request, pFullURI As %String, pXSDbQueryResponse As HS.Message.IHE.XDSb.QueryResponse, pMHDResponse As HS.Message.FHIR.Response) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tBundle = ##class(HS.FHIR.vSTU3.Model.Resource.Bundle).%New()
		
		Do tBundle.SetId($ZConvert($SYSTEM.Util.CreateGUID(),"L"))
		Do tBundle.SetTotal(pXSDbQueryResponse.Documents.Count())
		Do tBundle.SetType("searchset")
		Do tBundle.SetLink("self", pFullURI)
		
		#; tXDSbDocument      = XDSb Query Response document object
		#; tDocumentReference = FHIR Document Reference resource object
		
		#dim tXDSbDocument As HS.Message.IHE.XDSb.Document
		
		For tDocumentIndex = 1:1:pXSDbQueryResponse.Documents.Count() {
			
			Set tXDSbDocument = pXSDbQueryResponse.Documents.GetAt(tDocumentIndex)
			
			Set tDocumentReference = ##class(HS.FHIR.vSTU3.Model.Resource.DocumentReference).%New()
			
			Set tSC = ##class(HS.Registry.Document.FHIR).GetFHIRResourceId(tXDSbDocument.UniqueId, tXDSbDocument.RepositoryUniqueId, "STU3", .tResourceId)
			If $$$ISERR(tSC) Quit
			
			Set tHostAndPort = $Piece(pFullURI,"/",1,3)
			
			Set tSC = ..XDSbDocumentToDocReference(tXDSbDocument, tHostAndPort_pMHDRequest.BaseURL, pMHDRequest.ContentType, tResourceId, .tDocumentReference, pMHDRequest.AdditionalInfo.GetAt("USER:UserID"), pMHDRequest.AdditionalInfo.GetAt("USER:Roles"))
			If $$$ISERR(tSC) Quit
			
			// Because we are using XDSb registry and repository, the
			// BaseURL of the document is actually that of the CSP
			// app that was used to access this FHIR server.
			Set tDocumentBaseURL = tHostAndPort_pMHDRequest.BaseURL
			If $Extract(tDocumentBaseURL,*)'="/" Set tDocumentBaseURL = tDocumentBaseURL_"/"
			Set tDocumentURI = tDocumentBaseURL_"DocumentReference/"_tResourceId
			
			Set tSC = tBundle.SetEntry(tDocumentReference, , , tDocumentURI)
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit
		
		#; Instantiate target message
		Set pMHDResponse = ##class(HS.Message.FHIR.Response).%New()
		
		// Unconditionally create a QuickStream for the response message to use for
		// the response payload content.
		Set tResponseStream = ##class(HS.SDA3.QuickStream).%New()
		Set pMHDResponse.QuickStreamId = tResponseStream.%Id()
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(pMHDRequest.ContentType, tBundle, .tResponseStream, pMHDRequest.FormatFHIROutput)
		If $$$ISERR(tSC) Quit
		
		Set pMHDResponse.ContentType = "application/"_$Select($ZConvert(pMHDRequest.ContentType,"L")["json":"json",1:"xml")_"+fhir;charset=UTF-8"
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// XDSbDocumentToDocReference converts a single Document from an
/// XDSb Find Documents response into a FHIR DocumentReference
/// resource object.
Method XDSbDocumentToDocReference(pXDSbDocument As HS.Message.IHE.XDSb.Document, pBaseURL As %String, pContentType As %String, pResourceId As %String, ByRef pDocumentReference As HS.FHIR.vSTU3.Model.Resource.DocumentReference, pUserID As %String = "", pUserRoles As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = pDocumentReference.SetId(pResourceId) Quit:$$$ISERR(tSC)
		
		// Per IHE Appendix on HL7 FHIR for HL7 FHIR STU3, Rev 1.2, Section Z.9.1.1,
		// Document Entry UniqueId can be an OID or OID^extension. If UniqueId is
		// just OID, then the OID goes into masterIdentfier.value and "urn:ietf:rfc:3986"
		// goes into masterIdentifier.system. Otherwise if UniqueId is OID^extension,
		// then the OID goes into masterIdentifier.system and the extension goes into
		// masterIdentifier.value.
		If pXDSbDocument.UniqueId'["^" {
			Set tSC = pDocumentReference.SetMasterIdentifier("urn:oid:"_pXDSbDocument.UniqueId,"urn:ietf:rfc:3986")
			If $$$ISERR(tSC) Quit
		} Else {
			Set tSystem = $Piece(pXDSbDocument.UniqueId,"^",1)
			Set tValue = $Piece(pXDSbDocument.UniqueId,"^",2)
			If (##class(HS.HC.Util).IsOID(tSystem))&&($Extract(tSystem,1,8)'="urn:oid:") {
				Set tSystem = "urn:oid:"_tSystem
			} ElseIf (##class(HS.HC.Util).IsUUID(tSystem))&&($Extract(tSystem,1,9)'="urn:uuid:") {
				Set tSystem = "urn:uuid:"_tSystem
			}
			Set tSC = pDocumentReference.SetMasterIdentifier(tValue, tSystem)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = pDocumentReference.SetIdentifier(pXDSbDocument.EntryUUID,,"official",,,"EntryUUID") Quit:$$$ISERR(tSC)
		Set tSC = pDocumentReference.SetIdentifier(pXDSbDocument.LogicalUUID,,"usual",,,"LogicalUUID") Quit:$$$ISERR(tSC)
		
		Set tObjectType = $Select(pXDSbDocument.ObjectType="Stable":"urn:uuid:7edca82f-054d-47f2-a032-9b2a5b5186c1",pXDSbDocument.ObjectType="OnDemand":"urn:uuid:34268e47-fdf5-41a6-ba33-82133c465248",1:"")
		Set tSC = pDocumentReference.SetIdentifier(tObjectType,,"usual",,,"ObjectType") Quit:$$$ISERR(tSC)
		
		Set tPatient = ##class(HS.FHIR.vSTU3.Model.Resource.Patient).%New()
		Set ..ResourceIdIndex = ..ResourceIdIndex + 1
		Set tContainedPatientResourceId = "contained-Patient-"_..ResourceIdIndex
		Set tSC = tPatient.SetId(tContainedPatientResourceId) Quit:$$$ISERR(tSC)
		
		Set tSourcePatientId = $Piece(pXDSbDocument.SourcePatientId,"^",1)
		Set tSourcePatientIdOID = $Piece(pXDSbDocument.SourcePatientId,"&",2)
		Set tSourcePatientIdAA = ##class(HS.Data.OIDMap).GetCodeForOID(tSourcePatientIdOID,tSourcePatientIdOID)
		Set tSC = tPatient.SetIdentifier(tSourcePatientId, "urn:oid:"_tSourcePatientIdOID, "usual", , , "MRN", , , , , , tSourcePatientIdAA) Quit:$$$ISERR(tSC)
		
		Set tPatientId = $Piece(pXDSbDocument.PatientId,"^",1)
		Set tPatientIdOID = $Piece(pXDSbDocument.PatientId,"&",2)
		Set tPatientIdAA = ##class(HS.Data.OIDMap).GetCodeForOID(tPatientIdOID,tPatientIdOID)
		Set tSC = tPatient.SetIdentifier(tPatientId, "urn:oid:"_tPatientIdOID, "official", , , "MPIID", , , , , , tSourcePatientIdAA) Quit:$$$ISERR(tSC)
		
		For tSrcPatInfoIndex = 1:1:pXDSbDocument.SourcePatientInfo.Count() {
			Set tStr = pXDSbDocument.SourcePatientInfo.GetAt(tSrcPatInfoIndex).Value
			If $Extract(tStr,1,6)="PID-5|" {
				Set tStr2 = $Extract(tStr,7,*)
				If $Translate(tStr2,"^")'="" {
					Set tSC = tPatient.SetName($Piece(tStr2,"^",1),$Piece(tStr2,"^",2),$Piece(tStr2,"^",3))
				}
			} ElseIf $Extract(tStr,1,6)="PID-7|" {
				Set tStr2 = $Extract(tStr,7,*)
				Set tDOB = $Extract(tStr2,1,4)_"-"_$Extract(tStr2,5,6)_"-"_$Extract(tStr2,7,8)
				Set tSC = tPatient.SetBirthDate(tDOB)
			} ElseIf $Extract(tStr,1,6)="PID-8|" {
				Set tStr2 = $ZConvert($Extract(tStr,7,*),"U")
				Set tGender = $Select(tStr2="M":"male",tStr2="F":"female",tStr2'="":"other",1:"unknown")
				Set tSC = tPatient.SetGender(tGender)
			} ElseIf $Extract(tStr,1,7)="PID-11|" {
				Set tStr2 = $Extract(tStr,8,*)
				Set tLines = 0
				Set tLine = $Piece(tStr2,"^",1)
				For tLineIndex = 1:1:$Length(tLine,";") {
					Set tP = $Piece(tLine,";",tLineIndex)
					If tP'="" If $i(tLines) Set tLines(tLines) = tP
				}
				Set tLine = $Piece(tStr2,"^",2)
				If tLine'="" If $i(tLines) Set tLines(tLines) = tLine
				Set tAddress = ##class(HS.FHIR.vSTU3.Model.Base.Address).%New()
				Set tSC = tAddress.SetUse("home")
				For tLineIndex = 1:1:tLines Set tSC = tAddress.SetLine(tLines(tLineIndex))
				Set tSC = tAddress.SetCity($Piece(tStr2,"^",3))
				Set tSC = tAddress.SetState($Piece(tStr2,"^",4))
				Set tSC = tAddress.SetPostalCode($Piece(tStr2,"^",5))
				If $Piece(tStr2,"^",6)'="" Set tSC = tAddress.SetCountry($Piece(tStr2,"^",6))
				Set tSC = tPatient.address.Insert(tAddress)
			}
		}
		
		Set tSC = pDocumentReference.SetContained(tPatient) Quit:$$$ISERR(tSC)
		
		Set tSC = pDocumentReference.SetSubject("#"_tContainedPatientResourceId) Quit:$$$ISERR(tSC)
		
		Set tCode = pXDSbDocument.TypeCode.Code
		Set tDescription = pXDSbDocument.TypeCode.Description
		Set tScheme = pXDSbDocument.TypeCode.Scheme
		Set tSystem = ..GetCodeSystem("typeCode", tScheme, tCode, tScheme)
		Set tSC = pDocumentReference.SetType(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
		
		Set tCode = pXDSbDocument.ClassCode.Code
		Set tDescription = pXDSbDocument.ClassCode.Description
		Set tScheme = pXDSbDocument.ClassCode.Scheme
		Set tSystem = ..GetCodeSystem("classCode", tScheme, tCode, tScheme)
		Set tSC = pDocumentReference.SetClass(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
		
		If ($IsObject(pXDSbDocument.Author))&&(pXDSbDocument.Author.Count()>0) {
			Set tPractitioner = ##class(HS.FHIR.vSTU3.Model.Resource.Practitioner).%New()
			Set ..ResourceIdIndex = ..ResourceIdIndex + 1
			Set tContainedPractitionerResourceId = "contained-Practitioner-"_..ResourceIdIndex
			Set tSC = tPractitioner.SetId(tContainedPractitionerResourceId) Quit:$$$ISERR(tSC)
			Set tSC = tPractitioner.SetName($Piece(pXDSbDocument.Author.GetAt(1).AuthorPerson,"^",2),$Piece(pXDSbDocument.Author.GetAt(1).AuthorPerson,"^",3),$Piece(pXDSbDocument.Author.GetAt(1).AuthorPerson,"^",4)) Quit:$$$ISERR(tSC)
			Set tSC = pDocumentReference.SetContained(tPractitioner) Quit:$$$ISERR(tSC)
			Set tSC = pDocumentReference.SetAuthor("#"_tContainedPractitionerResourceId) Quit:$$$ISERR(tSC)
		}
		
		#; XDSb Document CreationTime is supposed to be HL7v2 DTM format YYYYMMDDHHMMSS, in UTC.
		#; Convert to FHIR Instant format, in the local time zone.
		Set tCreationTimeForIndexed = ##class(HS.FHIR.Utils).V2ToFHIRInstant(pXDSbDocument.CreationTime,1,1)
		Set tSC = pDocumentReference.SetIndexed(tCreationTimeForIndexed) Quit:$$$ISERR(tSC)
		
		Set tStatus = $Select(pXDSbDocument.AvailabilityStatus="Approved":"current",1:"superseded")
		Set tSC = pDocumentReference.SetStatus(tStatus) Quit:$$$ISERR(tSC)
		
		Set tSC = pDocumentReference.SetDescription(pXDSbDocument.Title) Quit:$$$ISERR(tSC)
		
		For i = 1:1:pXDSbDocument.ConfidentialityCode.Count() {
			Set tConfidentiality = pXDSbDocument.ConfidentialityCode.GetAt(i)
			Set tCode = tConfidentiality.Code
			Set tDescription = tConfidentiality.Description
			Set tScheme = tConfidentiality.Scheme
			Set tSystem = ..GetCodeSystem("confidentialityCode", tScheme, tCode, tScheme)
			Set tSC = pDocumentReference.SetSecurityLabel(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
		}
		Quit:$$$ISERR(tSC)
		
		// Because we are using XDSb registry and repository, the
		// BaseURL of the document is actually that of the CSP
		// app that was used to access this FHIR server.
		Set tDocumentBaseURL = pBaseURL
		If $Extract(tDocumentBaseURL,*)'="/" Set tDocumentBaseURL = tDocumentBaseURL_"/"
		Set tDocumentURI = tDocumentBaseURL_"Binary/"_pResourceId
		
		Set tContent = ##class(HS.FHIR.vSTU3.Model.Resource.DocumentReference.Content).%New()
		
		Set tCode = pXDSbDocument.FormatCode.Code
		Set tDescription = pXDSbDocument.FormatCode.Description
		Set tScheme = pXDSbDocument.FormatCode.Scheme
		Set tSystem = ..GetCodeSystem("formatCode", tScheme, tCode, tScheme)
		Set tSC = tContent.SetFormat(tCode, tDescription, tSystem) Quit:$$$ISERR(tSC)
		
		Set tAttachment = ##class(HS.FHIR.vSTU3.Model.Base.Attachment).%New()
		Set tSC = tAttachment.SetContentType(pXDSbDocument.MimeType) Quit:$$$ISERR(tSC)
		Set tSC = tAttachment.SetLanguage(pXDSbDocument.LanguageCode) Quit:$$$ISERR(tSC)
		Set tSC = tAttachment.SetUrl(tDocumentURI) Quit:$$$ISERR(tSC)
		Set tSC = tAttachment.SetSize(pXDSbDocument.Size) Quit:$$$ISERR(tSC)
		Set tSC = tAttachment.SetHash($system.Encryption.Base64Decode(pXDSbDocument.Hash)) Quit:$$$ISERR(tSC)
		Set tSC = tAttachment.SetTitle(pXDSbDocument.Comments) Quit:$$$ISERR(tSC)
		
		If ..DocumentBodyInQueryResponse=1 {
			Set tXDSbRetrieveRequest = ##class(HS.Message.XMLMessage).%New()
			Set tXDSbRetrieveRequest.Name = "XDSb_RetrieveRequest"
			Set tContentStream = ##class(%Stream.GlobalCharacter).%New()
			Set tSC = tContentStream.Write("<RetrieveDocumentSetRequest xmlns=""urn:ihe:iti:xds-b:2007"">")
			Set tSC = tContentStream.Write("<DocumentRequest>")
			Set tSC = tContentStream.Write("<RepositoryUniqueId>"_pXDSbDocument.RepositoryUniqueId_"</RepositoryUniqueId>")
			Set tSC = tContentStream.Write("<DocumentUniqueId>"_pXDSbDocument.UniqueId_"</DocumentUniqueId>")
			Set tSC = tContentStream.Write("</DocumentRequest>")
			Set tSC = tContentStream.Write("</RetrieveDocumentSetRequest>")
			Set tSC = tXDSbRetrieveRequest.ContentStream.CopyFrom(tContentStream)
			Set tSC = tXDSbRetrieveRequest.AdditionalInfo.SetAt("urn:ihe:iti:2007:RetrieveDocumentSet","SOAPAction")
			Set tXDSbRetrieveRequest.SAMLData.UserName = pUserID
			Set tXDSbRetrieveRequest.SAMLData.HSRoles = pUserRoles
			
			#dim tXDSbRetrieveResponse As HS.Message.XMLMessage
			
			Set tSC = ..SendRequestSync(..RetrieveTarget, tXDSbRetrieveRequest, .tXDSbRetrieveResponse)
			If $$$ISERR(tSC) Quit
			If ..Errors.Errors.Count() Quit
			If '$IsObject($Get(tXDSbRetrieveResponse)) Set tSC = $$$ERROR($$$GeneralError,"Response object from XDSb retrieve request not found") Quit
			
			#dim tStreamCollection As HS.IHE.Common.Messages.MIMEAttachment
			
			Set tStreamCollection = tXDSbRetrieveResponse.StreamCollection.GetAt(1)
			
			Set tSC = tAttachment.SetData(tStreamCollection.Body.Read($$$MaxLocalLength))
			If $$$ISERR(tSC) Quit
		}
		
		Set tContent.attachment = tAttachment
		
		Set tSC = pDocumentReference.content.Insert(tContent) Quit:$$$ISERR(tSC)
		
		Set tContext = ##class(HS.FHIR.vSTU3.Model.Resource.DocumentReference.Context).%New()
		
		#; XDSb Document ServiceStartTime is supposed to be HL7v2 DTM format YYYYMMDDHHMMSS, in UTC.
		Set tStartTime = ""
		If pXDSbDocument.ServiceStartTime'="" {
			#; Convert to FHIR DateTime format, in the local time zone.
			Set tStartTime = ##class(HS.FHIR.Utils).V2ToFHIRDateTime(pXDSbDocument.ServiceStartTime,1,1)
		}
		
		#; XDSb Document ServiceStopTime is supposed to be HL7v2 DTM format YYYYMMDDHHMMSS, in UTC.
		Set tStopTime = ""
		If pXDSbDocument.ServiceStopTime'="" {
			#; Convert to FHIR DateTime format, in the local time zone.
			Set tStopTime = ##class(HS.FHIR.Utils).V2ToFHIRDateTime(pXDSbDocument.ServiceStopTime,1,1)
		}
		
		Set tSC = tContext.SetPeriod(tStartTime, tStopTime) Quit:$$$ISERR(tSC)
		
		Set tCode = pXDSbDocument.HealthcareFacilityTypeCode.Code
		Set tDescription = pXDSbDocument.HealthcareFacilityTypeCode.Description
		Set tScheme = pXDSbDocument.HealthcareFacilityTypeCode.Scheme
		Set tSystem = ..GetCodeSystem("healthcareFacilityTypeCode", tScheme, tCode, tScheme)
		Set tSC = tContext.SetFacilityType(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
		
		Set tCode = pXDSbDocument.PracticeSettingCode.Code
		Set tDescription = pXDSbDocument.PracticeSettingCode.Description
		Set tScheme = pXDSbDocument.PracticeSettingCode.Scheme
		Set tSystem = ..GetCodeSystem("practiceSettingCode", tScheme, tCode, tScheme)
		Set tSC = tContext.SetPracticeSetting(tCode, tDescription, tSystem, tDescription) Quit:$$$ISERR(tSC)
		
		Set tSC = tContext.SetSourcePatientInfo("#"_tContainedPatientResourceId) Quit:$$$ISERR(tSC)
		
		#dim tSlot As HS.IHE.XDSb.Types.Slot
		If pXDSbDocument.DocumentSlots.Count()>0 {
			Set tHasRefIdList = 0
			For j = 1:1:pXDSbDocument.DocumentSlots.Count() {
				If pXDSbDocument.DocumentSlots.GetAt(j).Name="urn:ihe:iti:xds:2013:referenceIdList" {
					Set tHasRefIdList = 1
					Quit
				}
			}
			If tHasRefIdList {
				For j = 1:1:pXDSbDocument.DocumentSlots.Count() {
					Set tSlot = pXDSbDocument.DocumentSlots.GetAt(j)
					If tSlot.Name="urn:ihe:iti:xds:2013:referenceIdList" {
						For m = 1:1:tSlot.ValueList.Count() {
							Set tRelated = ##class(HS.FHIR.vSTU3.Model.Resource.DocumentReference.Related).%New()
							Set tSlotValue = tSlot.ValueList.GetAt(m).Value
							Set tSlotType = $Piece(tSlotValue,"^",5)
							Set tIdentifier = ##class(HS.FHIR.vSTU3.Model.Base.Identifier).%New()
							If tSlotType'="" {
								Set tIdentifierType = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New()
								Do tIdentifierType.SetCoding(tSlotType, , "urn:ietf:rfc:3986")
								Set tIdentifier.type = tIdentifierType
							}
							Set tSlotValueValue = $Piece(tSlotValue,"^",1)
							Set tSlotValueSystem = $Piece($Piece(tSlotValue,"^",4),"&",2)
							If tSlotValueValue'="" Do tIdentifier.SetValue(tSlotValueValue)
							If tSlotValueSystem'="" Do tIdentifier.SetSystem(tSlotValueSystem)
							Set tRelated.identifier = tIdentifier
							Do tContext.related.Insert(tRelated)
						}
					}
				}
			}
		}
		
		Set pDocumentReference.context = tContext
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod GetCodeSystem(pCodeType As %String, pScheme As %String, pCode As %String, pDefault As %String = "") As %String
{
	Set tSystem = ""
	
	If ##class(HS.HC.Util).IsOID(pScheme) {
		// It's an OID. Look in the OID Registry for a corresponding URL.
		// If no URL found then use the OID.
		Set tURL = ##class(HS.Data.OIDMap).GetURLForOID(pScheme)
		If tURL'=pScheme {
			Set tSystem = tURL
		} Else {
			Set tSystem = pScheme
			If $Extract(tSystem,1,8)'="urn:oid:" Set tSystem = "urn:oid:"_tSystem
		}
	} ElseIf ##class(HS.HC.Util).IsURL(pScheme) {
		// Unlikely we'll get scheme as a URL, but if we do, just use it.
		Set tSystem = pScheme
	} ElseIf ##class(HS.HC.Util).IsUUID(pScheme) {
		// Unlikely we'll get scheme as a UUID, but if we do, just use it.
		Set tSystem = pScheme
		If $Extract(tSystem,1,9)'="urn:uuid:" Set tSystem = "urn:uuid:"_tSystem
	} Else {
		// Otherwise, it's text.
		If pScheme["Connect-a-thon " {
			Set tSystem = "http://connectathon.ihe"
		} ElseIf (pScheme="2.16.840.1.113883.6.96")||(pScheme="SNOMED")||(pScheme="SRT")||(pScheme="SNM3") {
			Set tSystem = "http://snomed.info/sct"
		} ElseIf (pScheme="2.16.840.1.113883.6.1")||($ZConvert(pScheme,"U")="LOINC") {
			Set tSystem = "http://loinc.org"
		} ElseIf (pScheme="1.2.840.10008.2.6.1")||(pScheme="DCM") {
			Set tSystem = "http://dicom.nema.org/resources/ontology/DCM"
		} ElseIf pScheme="2.16.840.1.113883.3.86" {
			Set tSystem = "http://www.intersystems.com"
		} ElseIf pScheme="2.16.840.1.113883.5.25" {
			Set tSystem = "http://hl7.org/fhir/v3/Confidentiality"
		} ElseIf (pScheme="2.16.840.1.113883.3.88")||(pScheme="HITSP") {
			Set tSystem = "urn:oid:2.16.840.1.113883.3.88"
		} ElseIf (pScheme="1.3.6.1.4.1.19376.1.2.3")||($Extract(pScheme,1,4)="IHE ")||($Extract(pScheme,1,4)="IHE-") {
			Set tSystem = "urn:oid:1.3.6.1.4.1.19376.1.2.3"
		} ElseIf pScheme="MPQ Testing" {
			Set tSystem = "http://connectathon.ihe"
		} ElseIf $Extract(pScheme,1,8)="RSNA2008" {
			Set tSystem = "http://connectathon.ihe"
		}
	}
	
	If tSystem="" Set tSystem = pDefault
	
	Quit tSystem
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
		Set tXDataName = "ISCMHDDocumentResponder"
		
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

XData ISCMHDDocumentResponder
{
<CapabilityStatement xmlns="http://hl7.org/fhir">
  <placeholder>resource_id</placeholder>
  <text>
    <status value="additional" />
    <div xmlns="http://www.w3.org/1999/xhtml">
	CapabilityStatement for the Document Responder actor in the 
    IHE IT Infrastructure Technical Framework Supplement <a href="http://wiki.ihe.net/index.php/Mobile_access_to_Health_Documents_(MHD)">Mobile access to Health Documents (MHD) Rev. 2.3</a></div>
  </text>
  <placeholder>url</placeholder>
  <name value="IHE.MHD.DocumentResponder" />
  <title value="IHE ITI Mobile access to Health Documents (MHD) - InterSystems Document Responder" />
  <status value="draft" />
  <experimental value="false" />
  <date value="2017-12-18" />
  <publisher value="InterSystems Corporation" />
  <description value="see http://wiki.ihe.net/index.php/Mobile_access_to_Health_Documents_(MHD)" />
  <kind value="instance" />
  <placeholder>software</placeholder>
  <implementation>
    <description value="InterSystems MHD Document Responder"/>
    <placeholder>implementation_url</placeholder>
  </implementation>
  <fhirVersion value="3.0.1" />
  <acceptUnknown value="no" />
  <format value="xml" />
  <format value="application/fhir+xml" />
  <format value="json" />
  <format value="application/fhir+json" />
  <profile>
    <reference value="http://ihe.net/fhir/StructureDefinition/IHE.MHD.Query.Minimal.DocumentReference" />
  </profile>
  <profile>
    <reference value="http://ihe.net/fhir/StructureDefinition/IHE.MHD.Query.Comprehensive.DocumentReference" />
  </profile>
  <profile>
    <reference value="http://ihe.net/fhir/StructureDefinition/IHE.MHD.DocumentManifest" />
  </profile>
  <rest>
    <mode value="server" />
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
      <type value="DocumentReference" />
      <profile>
        <reference value="http://ihe.net/fhir/StructureDefinition/IHE.MHD.Query.Comprehensive.DocumentReference" />
      </profile>
      <interaction>
        <code value="search-type" />
      </interaction>
      <searchParam>
        <name value="_id" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-_id" />
        <type value="token" />
        <documentation value="Logical id of this artifact" />
      </searchParam>
      <searchParam>
        <name value="author" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-author" />
        <type value="reference" />
        <documentation value="Who and/or what authored the document" />
      </searchParam>
      <searchParam>
        <name value="class" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-class" />
        <type value="token" />
        <documentation value="Categorization of document" />
      </searchParam>
      <searchParam>
        <name value="event" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-event" />
        <type value="token" />
        <documentation value="Main clinical acts documented" />
      </searchParam>
      <searchParam>
        <name value="facility" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-facility" />
        <type value="token" />
        <documentation value="Kind of facility where patient was seen" />
      </searchParam>
      <searchParam>
        <name value="format" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-format" />
        <type value="token" />
        <documentation value="Format/content rules for the document" />
      </searchParam>
      <searchParam>
        <name value="indexed" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-indexed" />
        <type value="date" />
        <documentation value="When this document reference was created" />
      </searchParam>
      <searchParam>
        <name value="period" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-period" />
        <type value="date" />
        <documentation value="Time of service that is being documented" />
      </searchParam>
      <searchParam>
        <name value="related-id" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-related-id" />
        <type value="token" />
        <documentation value="Identifier of related objects or events" />
      </searchParam>
      <searchParam>
        <name value="related-ref" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-related-ref" />
        <type value="reference" />
        <documentation value="Related Resource" />
      </searchParam>
      <searchParam>
        <name value="securitylabel" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-securitylabel" />
        <type value="token" />
        <documentation value="Document security-tags" />
      </searchParam>
      <searchParam>
        <name value="setting" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-setting" />
        <type value="token" />
        <documentation value="Additional details about where the content was created (e.g. clinical specialty)" />
      </searchParam>
      <searchParam>
        <name value="status" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-status" />
        <type value="token" />
        <documentation value="current | superseded | entered-in-error" />
      </searchParam>
      <searchParam>
        <name value="type" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentReference-type" />
        <type value="token" />
        <documentation value="Kind of document (LOINC if possible)" />
      </searchParam>
    </resource>
    <resource>
      <type value="DocumentManifest" />
      <profile>
        <reference value="http://ihe.net/fhir/StructureDefinition/IHE.MHD.DocumentManifest" />
      </profile>
      <interaction>
        <code value="search-type" />
      </interaction>
      <searchParam>
        <name value="author" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentManifest-author" />
        <type value="reference" />
        <documentation value="Who and/or what authored the manifest" />
      </searchParam>
      <searchParam>
        <name value="created" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentManifest-created" />
        <type value="date" />
        <documentation value="When this document manifest created" />
      </searchParam>
      <searchParam>
        <name value="recipient" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentManifest-recipient" />
        <type value="reference" />
        <documentation value="Intended to get notified about this set of documents" />
      </searchParam>
      <searchParam>
        <name value="source" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentManifest-source" />
        <type value="uri" />
        <documentation value="The source system/application/software" />
      </searchParam>
      <searchParam>
        <name value="status" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentManifest-status" />
        <type value="token" />
        <documentation value="current | superseded | entered-in-error" />
      </searchParam>
      <searchParam>
        <name value="type" />
        <definition value="http://hl7.org/fhir/SearchParameter/DocumentManifest-type" />
        <type value="token" />
        <documentation value="Kind of document set" />
      </searchParam>
    </resource>
    <resource>
      <type value="Binary" />
      <interaction>
        <code value="read" />
      </interaction>
    </resource>
    <interaction>
      <code value="search-system" />
    </interaction>
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
<Value>RetrieveTarget</Value>
</Value>
<Value name="3">
<Value>QueryTarget</Value>
</Value>
<Value name="4">
<Value>Errors</Value>
</Value>
<Value name="5">
<Value>RepositoryOID</Value>
</Value>
<Value name="6">
<Value>XDSbRetrieveConsentTarget</Value>
</Value>
<Value name="7">
<Value>DocumentBodyInQueryResponse</Value>
</Value>
<Value name="8">
<Value>AffinityDomain</Value>
</Value>
<Value name="9">
<Value>ResourceIdIndex</Value>
</Value>
<Value name="10">
<Value>ResourceSchemaRoot</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
