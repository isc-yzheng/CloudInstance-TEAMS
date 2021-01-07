/// IHE XDSb Document Source Actor 
/// Given a CDA stream extract relevant data and build ProvideAndRegister transaction
/// 
Class HS.IHE.XDM.PortableMediaCreator.Process Extends (Ens.BusinessProcess, HS.Util.BaseHost, HS.IHE.XDSb.DocumentSource.Abstract)
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "PIXv3ConsumerOperations:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},CustomProcessor:Basic,AssumeMinimal:Basic,ReadMe:Basic,HTMLHeader:Basic,HTMLFooter:Basic,PostCreationOperation:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},ZipOperation::selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},MetadataTransform,DocumentTransform";

/// The PIXv3 Consumer operation - if the patientId is not defined in the request use the sourceId and query the pix manager
Property PIXv3ConsumerOperations As %String [ InitialExpression = "HS.IHE.PIXv3.Consumer.Operations" ];

/// See %HSHOME%/csp/xslt/IHE/XDSb/Version1/DocumentToDistributeDocumentSetOnMedia.xsl for an example
Property DocumentTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/MetadataObject-to-Message.xsl" ];

Property MetadataTransform As %String(MAXLEN = 255) [ InitialExpression = "IHE/XDSb/Version1/Message-to-MetadataObject.xsl" ];

/// Optionally create a zip file of the output - Operation to send message to be zipped
Property ZipOperation As Ens.DataType.ConfigName;

/// An optional operation to send the created XDM file 
Property PostCreationOperation As Ens.DataType.ConfigName [ InitialExpression = "HS.IHE.XDM.FileOutputOperation" ];

/// Path to Generic Readme file to insert into XDM (such as /pathtofile/file.txt), or override the GetReadMe method to customize this behavior.
Property ReadMe As %String;

/// Path to custom HTML header (such as /pathtofile/headerfile.txt) for INDEX.HTM file in the XDM. 
Property HTMLHeader As %String(MAXLEN = 2048);

/// Path to custom HTML footer (such as /pathtofile/footerfile.txt) for INDEX.HTM file in the XDM. 
Property HTMLFooter As %String(MAXLEN = 2048);

/// Assume XDS Minimal Metadata -- If set to true, will assume XDM is intended to comply with XDS Minimal Metadata Requirements instead of full XDS Metdata
Property AssumeMinimal As %Boolean [ InitialExpression = 1 ];

/* ***  Common Properties (Internal)  *** */
Property Errors As HS.Types.IHE.Errors [ Internal ];

Property DefaultAuthorTelecommunication As %String [ Internal ];

Method OnRequest(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Try {
		Set tSC=$$$OK
		Do ..Errors.Errors.Clear()
		Set tRequest=pRequest
		
		If tRequest.%IsA("HS.Message.IHE.XDM.DistributeDocumentSetRequest") {
			set tRequest.Name = $$$XDMDistributeDocumentSetOnMediaRequest
			Set tSC= ..BuildDistributionSet(tRequest,.pResponse)
			set tSC = $$$ATNAEvent("XDMPMC",tRequest,pResponse,tSC)
			$$$ThrowOnError(tSC)
		} ElseIf pRequest.%IsA("HS.Message.XMLMessage") {
			Set tSC = ..ConvertToDistributeDocumentSet(pRequest,.tRequest)
			$$$ThrowOnError(tSC)
		} Else {
			$$$LOGERROR("Unsupported Message Type: "_ pRequest.Name)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method ConvertToDistributeDocumentSet(pRequest, Output pNewRequest) As %Status
{
	Try {
		Set tSC=$$$OK		
		
		Set pNewRequest = ##class(HS.Message.IHE.XDM.DistributeDocumentSetRequest).%New()
		Set tSC = ..TransformIntoObject(pRequest.ContentStream,..MetadataTransform /*"IHE/XDSb/Version1/Message-to-MetadataObject.xsl"*/,.tMetadata,,"HS.Message.IHE.XDSb.Metadata","Metadata",1)
		Quit:$$$ISERR(tSC)
		Do pNewRequest.Submissions.Insert(tMetadata)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br><br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to other business hosts using pHost.SendRequestAsync or pHost.SendRequest.Sync<br><br>
/// BuildDistributionSet takes the inbound HS.Message.IHE.XDM.DistributeDocumentSetRequest and
///  <li>Calls ValidateRequest</li>
///  <li>For each submission calls UpdateRequest</li>
/// 	 <li>calls IndexAndHeaders</li>
/// 	 <li>calls ZipOperation host if defined</li>
/// 	 <li>calls PostCreationOperation host (if defined) with a new HS.Message.IHE.XDM.DistributeDocumentSetRequest</li>
/// 
///   <Method>ClassMethod OnPreBuildDistributionSet(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest, Output pResponse as HS.Message.IHE.XDM.DistributeDocumentSetResponse) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error). </li>
/// 	<li>Updates can be done to the DistributeDocumentSet object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostBuildDistributionSet(pHost As Ens.Host, pRequest as HS.Message.IHE.XDM.DistributeDocumentSetRequest, pResponse as HS.Message.IHE.XDM.DistributeDocumentSetResponse) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method BuildDistributionSet(pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest, Output pResponse As HS.Message.IHE.XDM.DistributeDocumentSetResponse) As %Status
{
	Try {
		Set pResponse=##class(HS.Message.IHE.XDM.DistributeDocumentSetResponse).%New()
		#dim tRequest as HS.Message.IHE.XDM.DistributeDocumentSetRequest = pRequest.%ConstructClone(1)
		$$$OnPre(.tStop,tRequest,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)||..Errors.Errors.Count()
		Set tSC = ..ValidateRequest(tRequest,.pResponse) Quit:$$$ISERR(tSC)||..Errors.Errors.Count()
		
		///Iterate through each Provide and Register request to process attachment and metadata.
		for i=1:1:tRequest.Submissions.Count() {
			Set tOutboundRequest = ##class(HS.Message.XMLMessage).%New()
			Set tSC = ..UpdateRequest(tRequest.Submissions.GetAt(i)) 
			$$$ThrowOnError(tSC)
		}
		
		///Pass the submission set collection to the buildzip method which returns a message of type HS.Message.ZipRequest
		set tSC = ..IndexAndHeaders(tRequest, .pResponse)
		$$$ThrowOnError(tSC)
		
		///Pass the zip request message to the Zip operation which will create the zip file and return a HS.Message.ZipResponse
		If ..ZipOperation]"" {
			Set tZipRequest = pResponse.Files
			Set tZipRequest.Operation = "ToZip"
			#dim tZipResponse As HS.Message.ZipResponse
			set tSC = ..SendRequestSync(..ZipOperation, tZipRequest, .tZipResponse)
			$$$ThrowOnError(tSC)
			$$$HSTRACE("tZipResponse","tZipResponse",tZipResponse)
			Set pResponse.Files.File=tZipResponse.File
			Do pResponse.Files.Items.Clear()
		} 

		///If defined, send the original request message (with the new zip file) to an operation
		///Valid output methods for XDM are: ZIP file, uncompressed on CD-R/USB drive, email attachment (requires S/MIME encryption)
		If ..PostCreationOperation]"" {
			Set tMRequest = ##class(HS.Message.IHE.XDM.DistributeDocumentSetRequest).%New()
			Set tMRequest.FilePath = tRequest.FilePath
			Set tMRequest.Files = pResponse.Files
			set tSC = ..SendRequestSync(..PostCreationOperation,tMRequest, .tMResponse)
			$$$ThrowOnError(tSC)
		}
		$$$OnPost(tRequest,.pResponse)
	} 
	Catch eException 
	{ 
		$$$LOGERROR(eException.DisplayString())
		Set tSC=eException.AsStatus() 
	}
	Set:$IsObject(pResponse) pResponse.Status = tSC
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	Quit tSC
}

/// ValidateRequest takes the inbound HS.Message.IHE.XDM.DistributeDocumentSetRequest and can optionally update the newly created response (HS.Message.IHE.XDM.DistributeDocumentSetResponse) 
///  <li>Validates there are Submissions in the request</li>
///  <li>Validates each submission (HS.Message.IHE.XDSb.Metadata) has a submission set</li><br>
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br><br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to other business hosts using pHost.SendRequestAsync or pHost.SendRequest.Sync<br><br>
/// 
///   <Method>ClassMethod OnPreValidateRequest(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest, Output pResponse as HS.Message.IHE.XDM.DistributeDocumentSetResponse) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error). </li>
///   <Method>ClassMethod OnPostBuildDistributionSet(pHost As Ens.Host, pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest, Output pResponse as HS.Message.IHE.XDM.DistributeDocumentSetResponse) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method ValidateRequest(pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest, pResponse As HS.Message.IHE.XDM.DistributeDocumentSetResponse) As %Status
{
	Try {
		$$$OnPre(.tStop,pRequest,.pResponse) Quit:$G(tStop)||$$$ISERR(tSC)||..Errors.Errors.Count()
		If 'pRequest.Submissions.Count() {
			$$$ThrowStatus($$$ERROR($$$GeneralError,$$$Text("Metadata group is empty")))
		}

		For tIdx = 1:1:pRequest.Submissions.Count() {
			If 'pRequest.Submissions.GetAt(tIdx).Submissions.Count() {
				$$$HSTRACE("pRequest","Metadata group ["_tIdx_"] is missing the submission set",pRequest)
				$$$ThrowStatus($$$ERROR($$$GeneralError,$$$FormatText("Metadata group [%1] is missing the submission set",tIdx)))
			}
		}
		$$$OnPost(pRequest,.pResponse)
	} Catch eException { 
		$$$LOGERROR(eException.DisplayString())
		Set tSC=eException.AsStatus() 
		Set pResponse.Status=tSC
	}
	If $$$ISERR(tSC) $$$HSTRACE("error","tSC",tSC)
	Quit tSC
}

/// Take the inbound request, update the metadata with any missing values <br><br>
/// BuildDistributionSet takes the inbound HS.Message.IHE.XDM.DistributeDocumentSetRequest and
///  <li>Calls ValidateRequest</li>
///  <li>For each submission calls UpdateRequest</li>
/// 	 <li>calls IndexAndHeaders</li>
/// 	 <li>calls ZipOperation host if defined</li>
/// 	 <li>calls PostCreationOperation host (if defined) with a new HS.Message.IHE.XDM.DistributeDocumentSetRequest</li><br>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br><br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to other business hosts using pHost.SendRequestAsync or pHost.SendRequest.Sync<br><br>
/// 
///   <Method>ClassMethod OnPreUpdateRequest(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error). </li>
/// 	<li>Updates can be done to the DistributeDocumentSet object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostUpdateRequest(pHost As Ens.Host, pRequest as HS.Message.IHE.XDM.DistributeDocumentSetRequest) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method UpdateRequest(pRequest As HS.Message.IHE.XDSb.Metadata) As %Status
{
	try {
		Set tSC=$$$OK
		$$$OnPre(.tStop,pRequest) Quit:$G(tStop)||$$$ISERR(tSC)||..Errors.Errors.Count()
		#; if the request is CDA we may need to extract values from the document and update the request
		Set tSC =..GetUpdatedRequest(pRequest) Quit:$$$ISERR(tSC)
		
		#; Move attachments into outbound message 
		#;  need to do this before transforming this as we'll move documents around
		Set tSC = ##class(HS.IHE.XDSb.Util).AttachDocuments(0,pRequest,pRequest) Quit:$$$ISERR(tSC)
		
		///Iterate through the documents and set the file name in the request message. 
		///The URI slot points to the relative physical location of the file within the XDM
		//File names are limited to 8 characters so must be trimmed
		#dim tDoc as HS.Types.IHE.XDSb.Document
		for tIdx=1:1:pRequest.Documents.Count() {
			set tDoc = pRequest.Documents.GetAt(tIdx)
			if $l(tDoc.URI) {
				set tURI = tDoc.URI
				set tURI = $tr(tURI," ","")
				set tExtLength = $l($p(tURI,".",$l(tURI,".")))
				set tFileNameLength = $l(tURI) - 1 - tExtLength
				if tFileNameLength>8 {
					if $IsObject(tDoc.Names.GetAt(1)) && (tDoc.Names.GetAt(1).ValueText]"") { set tDoc.Names.GetAt(1).ValueText=tDoc.URI }
					set tURI = $e(tURI,0,6)_"~1."_$p(tURI,".",($l(tURI,".")))
				}
				set tDoc.URI = $zcvt(tURI,"U")	
			} else {
				set tDoc.URI = "DOC"_$tr($justify(tIdx,5)," ",0)_"."_$zcvt(##class(HS.Data.MimeTypes).ExtensionForMimeType(tDoc.MimeType),"U")
			}
			If $D(tHaveURI(tDoc.URI)) Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("Multiple documents with the URI value of %1",tDoc.URI)) Quit
			Set tHaveURI(tDoc.URI)=tIdx
		}
		Quit:$$$ISERR(tSC)
		#dim tSubmission As HS.Types.IHE.XDSb.Submission = pRequest.Submissions.GetAt(1)
		
		///Meet required minimum metadata, provide an AuthorTelecommunication value if none is provided
		if ..AssumeMinimal {
			Set tTelecom = ..DefaultAuthorTelecommunication
			Set:tTelecom="" (..DefaultAuthorTelecommunication,tTelecom)=##class(HS.Registry.Config).GetKeyValue("\IHE\XDM\DefaultAuthorTelecommunication")
			if tSubmission.Author.Count() = 0 {
				set tAuthor = ##class(HS.Types.IHE.XDSb.Author).%New()
				set tSC = tAuthor.AuthorTelecommunication.Insert(##class(HS.Types.IHE.XDSb.SlotValue).%New(tTelecom))
				set tSC = tSubmission.Author.Insert(tAuthor)
				$$$ThrowOnError(tSC)
			}
			set:tSubmission.Author.GetAt(1).AuthorTelecommunication="" tSubmission.Author.GetAt(1).AuthorTelecommunication = tTelecom
			If tSubmission.Author.GetAt(1).AuthorTelecommunication="" $$$ThrowStatus($$$ERROR($$$GeneralError,$$$Text("No default author telecommunication defined in registry key \IHE\XDM\DefaultAuthorTelecommunication")))
			Do ..UpdatePatientIdentifier(pRequest)
			Do ..UpdateCreationTime(pRequest)			
		}
		
		#; Meet required minimum metadata, provide a Source ID if none in original request
		if tSubmission.SourceIdentifier.Value = "" set tSubmission.SourceIdentifier.Value = $$$AffinityDomainOID
		
		Set pRequest.Name=$$$XDMDistributeDocumentSetOnMediaRequest
		Set tSC=..TransformFromObject(pRequest, ..DocumentTransform /*"IHE/XDSb/Version1/MetadataObject-to-Message.xsl"*/,.tStream) Quit:$$$ISERR(tSC)
		Do pRequest.ContentStream.CopyFrom(tStream)
		$$$HSTRACE("UpdatedRequest","pRequest",pRequest)
		$$$OnPost(pRequest)
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method UpdatePatientIdentifiers(pRequest As HS.Message.IHE.XDSb.Metadata) As %Status [ Private ]
{
	#dim tSubmission As HS.Types.IHE.XDSb.Submission = pRequest.Submissions.GetAt(1)
	//Provide patient identifier if none is provided
	if tSubmission.PatientIdentifier.Value="" { 
		for tIdx=1:1:pRequest.Documents.Count() {
			set tDoc = pRequest.Documents.GetAt(tIdx)
			if (tDoc.PatientIdentifier '="") {
				Set tSubmission.PatientIdentifier = tDoc.PatientIdentifier
				quit
			}
		}
	}
	// if we failed to find one on a document fail over to source patient identifier
	if tSubmission.PatientIdentifier.Value="" { 
		for tIdx=1:1:pRequest.Documents.Count() {
			set tDoc = pRequest.Documents.GetAt(tIdx)
			if (tDoc.SourcePatientId '="") {
				Set id = ##class(HS.Types.IHE.XDSb.SerialExternalIdentifier).%New()
				Set id.Value = tDoc.SourcePatientId
				Set tSubmission.PatientIdentifier = id
				quit
			}
		}
	}
	// finally,cascade down to documents
	if tSubmission.PatientIdentifier.Value'="" { 
		for tIdx=1:1:pRequest.Documents.Count() {
			set tDoc = pRequest.Documents.GetAt(tIdx)
			Set tDoc.PatientIdentifier.Value = tSubmission.PatientIdentifier.Value
		}				
	}
	quit $$$OK
}

/// This method accepts a HS.Message.IHE.XDM.DistributeDocumentSetRequest object as its input and will move the transformed metadata objects into files,
/// transform CDA to HTML where possible and attach.  Build and insert the index, the readme, and the header/footer.
/// Returns a new HS.Message.IHE.XDM.DistributeDocumentSetResponse which contains the Files as a HS.Types.ZipResponse<br>
/// <br><br>Note: all files in the XDM archive must have uppercase names and cannot exceed 8 characters + 3 character extension
/// <br>Examples<br>
/// <ul><li>DOCUMENT.TXT = Correct</li>
/// <li>Document.txt = Incorrect - Not all uppercase</li>
/// <li>DOCUMENT.txt = Incorrect - Not all uppercase</li>
/// <li>DOCUMENT01.TXT = Incorrect - Exceeds 8 character limit for file name</li>
/// <li>DOCUMENT.TEXT = Incorrect - Exceeds 3 character limit for file extension</li></ul>
///  
/// Optionally define customization class by setting CustomProcessor to class name and define either method<br><br>
/// Tracing in the methods with HSTRACECALLED, HSTRACECALLEDMIN, HSTRACECALLEDERROR<br>
/// Call out to other business hosts using pHost.SendRequestAsync or pHost.SendRequest.Sync<br><br>
/// 
///   <Method>ClassMethod OnPreIndexAndHeaders(pHost As Ens.Host , Output pStopProcessing as %Boolean, pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest) as %Status</Method>
/// 	<li>if pStopProcessing is true processing will terminate with tSC (either ok or error). </li>
/// 	<li>Updates can be done to the DistributeDocumentSet object prior to any additional processing, such as providing necessary missing fields</li>
///   <Method>ClassMethod OnPostIndexAndHeaders(pHost As Ens.Host, pRequest as HS.Message.IHE.XDM.DistributeDocumentSetRequest) as %Status</Method>
/// 	<li>Additional processing can be done to the response, or the response itself can be updated</li>
Method IndexAndHeaders(pRequest As HS.Message.IHE.XDM.DistributeDocumentSetRequest, pResponse As HS.Message.IHE.XDM.DistributeDocumentSetResponse) As %Status
{
	#dim tSubSet as HS.Message.XMLMessage
	#define HIX(%1) d tIndexHTML.WriteLine(%1)
	set tZipRequest = ##class(HS.Message.ZipRequest).%New()
	
	//Add the readme file to the XDM archive
	//Note: the file must be named README.TXT
	set tZipItem = ##class(HS.Types.ZipItem).%New()
	set tZipItem.File = ..GetReadMe()
	set tZipItem.Path = ""
	set tZipItem.Filename = "README.TXT"
	set tSC = tZipRequest.Items.Insert(tZipItem)
	
	set tIndexHTML = ##class(%Stream.FileCharacter).%New()
	
	//Write out the HTML header elements
	do ..IndexHeader(.tIndexHTML)

	$$$HIX("<ul>")
	try {
		$$$HSTRACE("Updated submission","pRequest",pRequest)
		for tIdx=1:1:pRequest.Submissions.Count() {
			set tSubSetName = "SUBSET"_$tr($justify(tIdx,2)," ",0)
			Set tZipItemPath = $zcvt("IHE_XDM/"_tSubSetName,"U")
			set tMetadataObject = pRequest.Submissions.GetAt(tIdx)
			
			$$$HIX("<li>"_tSubSetName_"</li>")
			$$$HIX("<ul>")
			
			set tZipItem = ##class(HS.Types.ZipItem).%New()
			set tZipItem.File = tMetadataObject.ContentStream
			set tZipItem.Filename = "METADATA.XML"
			set tZipItem.Path = tZipItemPath
			set tSC = tZipRequest.Items.Insert(tZipItem)
			$$$HIX("<li><a href='"_tZipItem.Path_"/"_tZipItem.Filename_"'>"_tZipItem.Filename_"</a> - Machine processable metadata about folder contents</li>")
			
			for tIdxDoc=1:1:tMetadataObject.StreamCollection.Count() {
				Set tMIMEAttachment = tMetadataObject.StreamCollection.GetAt(tIdxDoc)
				$$$HSTRACE("Adding attachment","tMIMEAttachment.ContentId",tMIMEAttachment.ContentId)
				Set tAryStreams(tMIMEAttachment.ContentId)=tMIMEAttachment
			}
				
			$$$HSTRACE("For Documents","tMetadataObject.Documents",tMetadataObject.Documents)
			for tIdxDoc=1:1:tMetadataObject.Documents.Count() {
				#dim tDocument as HS.Types.IHE.XDSb.Document = tMetadataObject.Documents.GetAt(tIdxDoc)
				set tZipItem = ##class(HS.Types.ZipItem).%New()
				set (tZipItem.Filename,tFilename) = $zcvt(tDocument.URI,"U")
				set tZipItem.Path = tZipItemPath
				$$$HSTRACE("Searching attachment by ContentID","tDocument",tDocument)
				Set tMIMEAttachment = tAryStreams(##class(HS.IHE.XDSb.Util).XOPToContentID(tDocument.XOP))
				Do tZipItem.File.CopyFrom(tMIMEAttachment.Body)
				set tSC = tZipRequest.Items.Insert(tZipItem)
				$$$ThrowOnError(tSC)

				#;Get patient demographics
				Set tSourcePatientId = tDocument.SourcePatientId
				
				Set tName = tDocument.GetSourcePatientPID("PID-5")
				Set tDOB =  tDocument.GetSourcePatientPID("PID-7")
				Set tGender =  tDocument.GetSourcePatientPID("PID-8")
				Set tAddress = tDocument.GetSourcePatientPID("PID-11")

				#;Get toHTML value (if applicable)
				set tFormatCode="",tCodingScheme="",tToHTML=""
				set tSC = ##class(HS.IHE.CodedEntry).GetFormatToHTML(tDocument.FormatCode.Code, tDocument.FormatCode.CodingScheme, .tToHtml)
				
				$$$HSTRACE("To HTML Transform - Transforms Found - Format Code: "_tDocument.FormatCode.Code_" - Coding Scheme: "_tDocument.FormatCode.CodingScheme_ " - To HTML: "_tToHtml)
				
				//Output demographics for the source patient info... Connectathon requirement.
				$$$HIX("<li><a href='"_tZipItem.Path_"/"_tZipItem.Filename_"'>"_tZipItem.Filename_"</a> - "_tFilename_" - "_tDocument.FormatCode.Code_"^"_tDocument.FormatCode.CodingScheme_"</li>")
				$$$HSTRACE("b4 $L tName["_tIdxDoc_"]","tName,x",tName )
				if ($l(tName) || $l(tDOB) || $l(tGender) || $l(tAddress)) {
					$$$HIX("<ul>")
					$$$HIX("<li>Source System Patient ID: "_$p(tSourcePatientId,"^",1)_" - "_$p(tSourcePatientId,"&",2)_"</li>")
					$$$HIX("<li>"_"Name: "_$tr(tName,"^",",")_"</li>")
					$$$HIX("<li>"_"DOB: "_$e(tDOB,0,8)_"</li>")
					$$$HIX("<li>"_"Gender: "_tGender_"</li>")
					$$$HIX("<li>"_"Address: "_$tr(tAddress,"^",",")_"</li>")
					$$$HIX("</ul>")
				}
				
				//If we found a toHTML value, we will create a new file by applying the transform, inserting it into the XDM and
				//then adding a row to the table of contents				
				if $l(tToHtml) > 5  {
					set tSC = ..Transform(tZipItem.File,tToHtml,.tCDAHTML)
					$$$ThrowOnError(tSC)
					set tZipItem = ##class(HS.Types.ZipItem).%New()
					set tZipItem.Filename = $p($zcvt(tFilename,"U"),".",1,$l($zcvt(tFilename,"U"),".")-1)_".HTM"
					set tZipItem.Path = tZipItemPath
					set tZipItem.File = tCDAHTML
					set tSC = tZipRequest.Items.Insert(tZipItem)
					$$$ThrowOnError(tSC)
					
					$$$HIX("<li><a href='"_tZipItem.Path_"/"_tZipItem.Filename_"'>"_tZipItem.Filename_"</a> - "_"Human Readable Version of: "_tFilename_"</li>")										
				}
			}
			$$$HIX("</ul>")
		}
		$$$HIX("</ul>")
	
		do ..IndexFooter(.tIndexHTML)
		
		set tZipItem = ##class(HS.Types.ZipItem).%New()
		set tZipItem.File = tIndexHTML
		set tZipItem.Filename = "INDEX.HTM"
		set tZipItem.Path = ""
		set tSC = tZipRequest.Items.Insert(tZipItem)
		$$$ThrowOnError(tSC)

		$$$HSTRACE("Items","tZipRequest,pResponse",tZipRequest,pResponse)
		Set pResponse.Files = tZipRequest
		
	} Catch eException { 
		$$$LOGERROR(eException.DisplayString())
		Set tSC=eException.AsStatus() 
	}

	Set pResponse.Status = tSC	
	Quit tSC
}

/// OnResponse must be overridden here to avoid error upon response from async request.
Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallrequest As Ens.Request, pCallresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Quit $$$OK
}

/// Method for loading the README.TXT file contents in the root directory of the XDM. Override this method for more robust README.TXT file creation.
Method GetReadMe() As %Stream.FileCharacter
{
	Set tStream = ##class(%Stream.FileCharacter).%New()
	Set tStream.Filename = ..ReadMe
	if tStream.Size=0 { do tStream.Write("The README.TXT file has not been configured. Please configure the ReadMe property on the XDM Portable Media Creator Process to refer to a valid README.TXT file on the server.") }
	quit tStream
}

/// If HTMLHeader file is defined, this method will output that information. Otherwise, it will generate a generic HealthShare header. 
/// Override this method and pass in extra Args to customize the output for content specific settings.
Method IndexHeader(ByRef pIndexHTML As %Stream.FileCharacter, Args...)
{
	do pIndexHTML.WriteLine("<html>")
	do pIndexHTML.WriteLine("<head>")
	do pIndexHTML.WriteLine("<title>Table of Contents</title>")
	do pIndexHTML.WriteLine("</head>")
	do pIndexHTML.WriteLine("<body>")
	if ..HTMLHeader]"" {
		set tStream = ##class(%Stream.FileCharacter).%New()
		set tStream.Filename = ..HTMLHeader
		
		while 'tStream.AtEnd {
			do pIndexHTML.WriteLine(tStream.ReadLine())	
		}
	} else {
		do pIndexHTML.WriteLine("<h1>IHE XDM Portable Media</h1><p>"_
			"The table of contents below lists all files included."_
			"For more information on IHE XDM, please refer to <a href='http://www.ihe.net'>http://www.ihe.net</a></p>"_
			"<h2>Table of Contents</h2>")
		
	}
}

/// If HTMLFooter file is defined, this method will output that information. Otherwise, it will generate a generic HealthShare header. 
/// Override this method and pass in extra Args to customize the output for content specific settings.
Method IndexFooter(ByRef pIndexHTML As %Stream.FileCharacter, Args...)
{
	if ..HTMLFooter]"" {
		set tStream = ##class(%Stream.FileCharacter).%New()
		set tStream.Filename = ..HTMLFooter
		
		while 'tStream.AtEnd {
			do pIndexHTML.WriteLine(tStream.ReadLine())	
		}
	} else {
		do pIndexHTML.WriteLine("<h3>XDM archive created by InterSystems HealthShare</h3>")
	}
	do pIndexHTML.WriteLine("</body>")
	do pIndexHTML.WriteLine("</html>")
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	Quit ..ValidateCustomProcessor()
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>DocumentsInline</Value>
</Value>
<Value name="2">
<Value>TraceOperations</Value>
</Value>
<Value name="3">
<Value>DocumentTransform</Value>
</Value>
<Value name="4">
<Value>XSLTErrorHandlerClass</Value>
</Value>
<Value name="5">
<Value>PostCreationOperation</Value>
</Value>
<Value name="6">
<Value>CallbackHandler</Value>
</Value>
<Value name="7">
<Value>ErrorHandler</Value>
</Value>
<Value name="8">
<Value>HTMLFooter</Value>
</Value>
<Value name="9">
<Value>AssumeMinimal</Value>
</Value>
<Value name="10">
<Value>DoHSTrace</Value>
</Value>
<Value name="11">
<Value>ClearCallbackVariables</Value>
</Value>
<Value name="12">
<Value>HTMLHeader</Value>
</Value>
<Value name="13">
<Value>Initialized</Value>
</Value>
<Value name="14">
<Value>ReadMe</Value>
</Value>
<Value name="15">
<Value>XSLTCacheMode</Value>
</Value>
<Value name="16">
<Value>XSLTCallbackHandlerClass</Value>
</Value>
<Value name="17">
<Value>XSLTDirectory</Value>
</Value>
<Value name="18">
<Value>ZipOperation</Value>
</Value>
<Value name="19">
<Value>PostCreationOperation</Value>
</Value>
<Value name="20">
<Value>CustomProcessor</Value>
</Value>
<Value name="21">
<Value>CustomProcessorIsValid</Value>
</Value>
<Value name="22">
<Value>Errors</Value>
</Value>
<Value name="23">
<Value>DefaultAuthorTelecommunication</Value>
</Value>
<Value name="24">
<Value>PIXv3ConsumerOperations</Value>
</Value>
<Value name="25">
<Value>MetadataTransform</Value>
</Value>
<Value name="26">
<Value>AddNewPatients</Value>
</Value>
<Value name="27">
<Value>MPIOperations</Value>
</Value>
<Value name="28">
<Value>UseXSLT2</Value>
</Value>
</Data>
<Data name="StyleSheets">
<Attribute>StyleSheets</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.IHE.XDM.PortableMediaCreator.Process.StyleSheets"</Subscript>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
