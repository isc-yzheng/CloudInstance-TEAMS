Class HS.AU.IHE.XDSb.Consumer.Operations Extends HS.HC.IHE.XDSb.Consumer.Operations
{

Parameter SETTINGS = "-ServiceName,XDSbRegistryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},XDSbRepositoryServiceName:Basic:selector?Select=1&context={HS.Util.ContextSearch/ServiceNameItems},-SOAPVersion,-SSLConfiguration,-SOAPCredentials,ResponseTimeout,-SendSAMLAssertion,-SAMLCreator,ZipOperations:Basic,RequireSignature:Basic,HTMLTransformer:Basic,RequireValidHash:Basic,PayloadValidator:Basic,CDAToSDA3Transform";

Property ZipOperations As Ens.DataType.ConfigName [ InitialExpression = "HS.Util.Zip.Operations" ];

/// Whether a valid signature is required 
Property RequireSignature As %Boolean [ InitialExpression = 1 ];

/// Whether a valid hash is required 
Property RequireValidHash As %Boolean [ InitialExpression = 1 ];

Property HTMLTransformer As Ens.DataType.ConfigName [ InitialExpression = "HS.Util.HTMLTransformer" ];

Property PayloadValidator As %String(MAXLEN = 255) [ InitialExpression = "HS.AU.SMD.CDASignedPayloadType" ];

/// Allow a different header class by overriding paramter value
Parameter HEADERCLASS = "HS.AU.PCEHR.WebRequest";

Property CDAToSDA3Transform As %String(MAXLEN = 250) [ InitialExpression = "SDA3/CDA-to-SDA.xsl" ];

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HS.Message.ECRQueryRequest"> 
		<Method>ECRQueryRequest</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.IHE.XDSb.QueryRequest"> 
		<Method>XDSbQueryRequest</Method>
	</MapItem>
	<MapItem MessageType="HS.Message.IHE.XDSb.RetrieveRequest"> 
		<Method>XDSbRetrieveRequest</Method>
	</MapItem>
</MapItems>
}

Method ECRQueryRequest(pRequest As HS.Message.ECRQueryRequest, Output pResponse As HS.Message.ECRQueryResponse) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tMode = pRequest.AdditionalInfo.GetAt("Mode")
		Set tSC=..GetCombined(pRequest,.pResponse) Quit:$$$ISERR(tSC)
		Quit
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

Method XDSbRetrieveRequest(pRequest As HS.Message.IHE.XDSb.RetrieveRequest, Output pResponse As HS.Message.XMLMessage) As %Status
{
	Set tSC=$$$OK
	Try {
		#; do the retrieve and then unpack and verify the response
		Set pWebRequest = $classMethod(..#HEADERCLASS,"%New")
		Set tSC = ##super(pRequest,.pResponse) Quit:$$$ISERR(tSC)
		For tIdx=1:1:pResponse.Documents.Count() {
			Set tDocument = pResponse.Documents.GetAt(tIdx)
			If $zcvt(tDocument.MimeType,"l")="application/zip" {
				Set tZipRequest=##class(HS.Message.ZipRequest).%New()
				Set tZipRequest.Operation="FromZip"
				Set tMA = pResponse.StreamCollection.GetAt(tIdx)
				Set tSC= tZipRequest.File.CopyFrom(tMA.Body) Quit:$$$ISERR(tSC)
				Set tSC = ..SendRequestSync(..ZipOperations,tZipRequest,.tZipResponse) Quit:$$$ISERR(tSC)
				For tIdx2=1:1:tZipResponse.Items.Count() {
					Do tDocument.ZipItems.Insert(tZipResponse.Items.GetAt(tIdx2).%ConstructClone(1))
				}
			}
		}
		$$$HSTRACE("going to validate","pResponse",pResponse)
		Set tSC=..ValidateSignatures(pResponse) 
		If $$$ISERR(tSC) {
			$$$HSTRACEERROR("Validate Response failed","tSC",tSC)
			Quit:..RequireSignature
			Set tSC=$$$OK
		}
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

Method ValidateSignatures(pResponse As HS.Message.IHE.XDSb.RetrieveResponse) As %Status
{
	Set tSC=$$$OK
	Try {
		#; do the retrieve and then unpack and verify the response
		Set tCDA=""
		For tIdx=1:1:pResponse.Documents.Count() {
			Set tDocument = pResponse.Documents.GetAt(tIdx)
			For tIdx1=1:1:tDocument.ZipItems.Count() {
				Set tItem=tDocument.ZipItems.GetAt(tIdx1)
				If $zcvt(tItem.Filename,"l")="cda_root.xml" {
					Set tCDA=tItem
				} ElseIf $zcvt(tItem.Filename,"l")="cda_sign.xml" {
					Set tSIGN=tItem
				}
		
			}
			If '$isObject(tCDA) {
				If ..RequireSignature Set tSC=$$$ERROR($$$GeneralError,"No manifest found for Document:"_tIdx1) Quit
				Continue
			}
			Set tHash = $system.Encryption.Base64Encode($system.Encryption.SHA1HashStream(tCDA.File))
			Set tReader = ##class(%XML.Reader).%New()
			Do tSIGN.File.Rewind()
			Do tReader.Correlate("signedPayload",..PayloadValidator /* HS.AU.SMD.CDASignedPayloadType */)
			Set tSC = tReader.OpenStream(tSIGN.File) Quit:'tSC
			If 'tReader.Next(.tSig, .tSC) { 
				If ..RequireSignature {
					Set tSC=$$$ERROR($$$GeneralError,"No signature") 
				} Else {
					$$$HSTRACEERROR("No signature found") 
					Set tSC=$$$OK
				}
				Quit
			}
			Quit:$$$ISERR(tSC)
			Set tSC=tSig.Validate(tReader.Document) 
			If $$$ISERR(tSC) {
				$$$HSTRACEERROR("Validate document signature failed","tSC,tDocument.ID",tSC,tDocument.UniqueId) 
				Quit:..RequireSignature
				Set tSC=$$$OK
			} Else {
				$$$HSTRACE("Signature validated")
			}
			Set tManifestHash = $system.Encryption.Base64Encode(tSig.SignedPayloadData.Signature.Manifest.Reference.GetAt(1).DigestValue)
			If tManifestHash'=tHash {
				If ..RequireValidHash {
					Set tSC=$$$ERROR($$$GeneralError,"Manifest hash does not match calculated hash for Document:"_tIdx1_"["_tManifestHash_"'="_tHash) Quit
				} Else {
					$$$HSTRACEERROR("Manifest hash does not match calculated hash for Document:"_tIdx1_"["_tManifestHash_"'="_tHash) 
				}
			} Else {$$$HSTRACE("Hash validated")}
		}
	} Catch ex { 
		Set tSC=ex.AsStatus() 
	}

	Quit tSC
}

Method DocumentQuery(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage, pIgnoreSecondaryMPI As %Boolean, pWebRequest As %SOAP.WebRequest) As %Status
{
	Set pWebRequest = $classMethod(..#HEADERCLASS,"%New")
	Quit ##super(pRequest,.pResponse,.pIgnoreSecondaryMPI,pWebRequest)
}

Method DocumentRetrieve(pRequest As HS.Message.XMLMessage, pResponse As HS.Message.XMLMessage, pWebRequest As %SOAP.WebRequest) As %Status
{
	Set pWebRequest = $classMethod(..#HEADERCLASS,"%New")
	Quit ##super(pRequest,.pResponse,pWebRequest)
}

/// Return list of patient documents in a silent encounter SDA
/// Used to provide links from the "Documents" tab in the viewer
Method GetCombined(pRequest As HS.Message.ECRQueryRequest, Output pResponse As HS.Message.ECRQueryResponse) As %Status
{
	Set tSC=$$$OK
	Try {
		Set pResponse = ##class(HS.Message.ECRQueryResponse).%New()
		#; Fetch the document metadata for normal patient fetch requests
		Set tRequest=##class(HS.AU.Message.IHE.XDSb.QueryRequest).%New()
		Set tRequest.SAMLData=pRequest.SAMLData
		Set tRequest.SAMLData.IHINumber=pRequest.MRN
		Do tRequest.AddPatientId(pRequest.MRN_"^^^&"_##class(HS.Data.OIDMap).GetOIDForCode(pRequest.AssigningAuthority)_"&ISO")
		Do tRequest.AddStatusValues("Approved")
		#dim tResponse as HS.Message.IHE.XDSb.QueryResponse
		Set tSC=..XDSbQueryRequest(tRequest,.tResponse) Quit:$$$ISERR(tSC)
		
		#; if no documents we're done
		If 'tResponse.Documents.Count() Set pResponse.Action=0 Quit

		Set tRetrieveRequest = ##class(HS.AU.Message.IHE.XDSb.RetrieveRequest).%New()
		Set tRetrieveRequest.Documents=tResponse.Documents
		Set tRetrieveRequest.SAMLData=tRequest.SAMLData
		#dim tRetrieveResponse as HS.Message.IHE.XDSb.RetrieveResponse
		Set tSC= ..XDSbRetrieveRequest(tRetrieveRequest,.tRetrieveResponse)
		If $$$ISERR(tSC) {  
			//|| (tRetrieveResponse.Errors.Errors.Count()) {
			Set tHighestError = ""
			//If $ISObject(tRetrieveResponse) Set tHighestError = tRetrieveResponse.Errors.Errors.GetAt(1).Description
			$$$HSTRACEERROR("Retrieve failed","tSC,Error",tSC,tHighestError)
			Quit
		}
		Set tStream = ##class(%Stream.GlobalCharacter).%New()
		Do tStream.WriteLine("<Root><Documents>")

		For tIdxDoc = 1:1:tRetrieveResponse.Documents.Count() {
			Set tDocument = tRetrieveResponse.Documents.GetAt(tIdxDoc)
			Set tZipResponse = ##class(HS.Message.ZipResponse).%New()
			Set tZipResponse.Items=tDocument.ZipItems
			Set tSC = ..SendRequestSync(..HTMLTransformer,tZipResponse,.tHTMLMessage)
			Set tItem=""
			
			For tIdx=1:1:tDocument.ZipItems.Count() {
				If $zcvt(tDocument.ZipItems.GetAt(tIdx).Filename,"l")'="cda_root.xml" continue
				Set tItem = tDocument.ZipItems.GetAt(tIdx).File
			}
			Do tStream.WriteLine("<Document id='"_tDocument.UniqueId_"' repo='"_tDocument.RepositoryUniqueId_"' mimeType='text/xml'>")
			While 'tHTMLMessage.ContentStream.AtEnd {
				Do tStream.Write($system.Encryption.Base64Encode(tHTMLMessage.ContentStream.Read()))
			}
			Do tStream.WriteLine("</Document>")
			Set tSDAStream = ##class(%Stream.GlobalCharacter).%New()
			Set tSC = ..Transform(tItem,..CDAToSDA3Transform /*"SDA3/AU-CDA-to-SDA.xsl"*/,.tSDAStream)
			Do pResponse.ContentStreamList.Insert(tSDAStream)
		}

		Do tStream.WriteLine("</Documents>")
		#; Convert document list to SDA		
		Set tParams("patientId")=pRequest.MRN
		Set tParams("facility")=pRequest.Facility
		Set tParams("assigningAuthority")=pRequest.AssigningAuthority
		Do tResponse.ContentStream.Rewind()
		While 'tResponse.ContentStream.AtEnd {
				Do tStream.Write(tResponse.ContentStream.Read())
		}
		
		Do tStream.WriteLine("</Root>")
		Set tSC=..Transform(tStream,..TransformFindDocumentResultToSDA /*"IHE/XDSb/Version1/FindDocumentsResult-to-SDA.xsl"*/,.tStream,.tParams) Quit:$$$ISERR(tSC)
		Do pResponse.ContentStreamList.Insert(tStream)

	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

}
