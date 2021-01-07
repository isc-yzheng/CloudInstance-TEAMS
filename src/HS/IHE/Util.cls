Include Ensemble

/// IHE Utility Functions
Class HS.IHE.Util [ Abstract ]
{

Parameter FOUNDATION = 1;

/// The name of the affinity domain in the OID registry
Parameter KEYAffinityDomain = "\IHE\AffinityDomain";

Parameter KEYHomeCommunity = "\IHE\HomeCommunity";

/// XML namespaces used by IHE
ClassMethod GetNamespaces() As %ArrayOfDataTypes
{
	Set tArray=##class(%ArrayOfDataTypes).%New()
	Do tArray.SetAt("urn:oasis:names:tc:ebxml-regrep:xsd:lcm:3.0","lcm")
	Do tArray.SetAt("urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0","rim")
	Do tArray.SetAt("urn:ihe:iti:xds-b:2007","xdsb")
	Do tArray.SetAt("http://www.w3.org/2004/08/xop/include","xop")
	Do tArray.SetAt("urn:oasis:names:tc:ebxml-regrep:xsd:query:3.0","query")
	Do tArray.SetAt("urn:oasis:names:tc:ebxml-regrep:xsd:rs:3.0","rs")
	Do tArray.SetAt("urn:ihe:iti:xds-b:2007","ihe")
	Do tArray.SetAt("http://www.w3.org/2005/08/addressing","wsa")
	Do tArray.SetAt("urn:ihe:iti:dsub:2009","dsub")
	Do tArray.SetAt("urn:hl7-org:v3","hl7")
	Do tArray.SetAt("http://docs.oasis-open.org/wsn/b-2","wsnt")
	Do tArray.SetAt("urn:ihe:rad:xdsi-b:2009", "iherad")
	Do tArray.SetAt("urn:ihe:iti:rmd:2017", "rmd")
	Quit tArray
}

/// IHE namespaces string for XPath documents
/// For example: "xdsb urn:ihe:iti:xds-b:2007,xop http://www.w3.org/2004/08/xop/include"
ClassMethod XPathNamespaces() As %String
{
	Set tNamespaces=""
	Set tArray=..GetNamespaces()
	Set tKey="" For { Set tXMLNS=tArray.GetNext(.tKey) Quit:tKey=""
		If tXMLNS]"" {
			If tNamespaces]"" Set tNamespaces=tNamespaces_","
			Set tNamespaces=tNamespaces_tKey_" "_tXMLNS
		}
	}
	Quit tNamespaces
}

/// IHE namespaces string for XML elements
/// For example: "xmlns:xdsb='urn:ihe:iti:xds-b:2007' xmlns:xop='http://www.w3.org/2004/08/xop/include'"
ClassMethod XMLNamespaces(pDefaultNamespace As %String = "") As %String
{
	Set tNamespaces=""
	Set tArray=..GetNamespaces()
	If pDefaultNamespace]"" {
		Set tXMLNS=tArray.GetAt(pDefaultNamespace)
		If tXMLNS]"" Set tNamespaces="xmlns:"_tXMLNS
	}
	Set tKey="" For { Set tXMLNS=tArray.GetNext(.tKey) Quit:tKey=""
		If tXMLNS]"" {
			If tNamespaces]"" Set tNamespaces=tNamespaces_" "
			Set tNamespaces=tNamespaces_"xmlns:"_tKey_"="""_tXMLNS_""""
		}
	}
	Quit tNamespaces
}

/// Set tSC = ..GetXPathValue(pRequest.ContentStream,"/query:AdhocQueryResponse","@status",.tValue)
ClassMethod GetXPathValue(pStream, pExpression, pItem, ByRef pValue, ByRef pDocument = "") As %Status
{
	try {
		If '$isObject(pDocument) Set tSC = ..GetXPathDocument(.pDocument,pStream) $$$ThrowOnError(tSC)
		Set tSC = pDocument.EvaluateExpression(pExpression, pItem, .tResults) $$$ThrowOnError(tSC)
		If '$isObject(tResults) Throw $$$ERROR($$$GeneralError,"No node")
		Set pValue=$S($isObject(tResults.GetAt(1)):tResults.GetAt(1).Value,1:"")
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod GetXPathDocument(ByRef pDocument, pStream) As %XML.XPATH.Document
{
	try {
		If '$isObject(pDocument) {
			Do pStream.Rewind()
			Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(pStream, .pDocument) $$$ThrowOnError(tSC)
			Set pDocument.PrefixMappings=##class(HS.IHE.Util).XPathNamespaces()
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set tSC = ..GetXPathExpression(pRequest.ContentStream,"/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:ExtrinsicObject/rim:ExternalIdentifier[@identificationScheme='urn:uuid:2e82c1f6-a085-4c72-9da3-8640a32e42ab']","@value",.tDocuments,.tDocument)
ClassMethod GetXPathExpression(pStream, pExpression, pItem, ByRef pValue, ByRef pDocument = "") As %Status
{
	try {
		Set pValue=""
		If '$isObject(pDocument) Set tSC = ..GetXPathDocument(.pDocument,pStream) $$$ThrowOnError(tSC)
		Set tSC = pDocument.EvaluateExpression(pExpression, pItem, .pValue) $$$ThrowOnError(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Return the Affinity Domain ID (and Name/OID) from the given MPI search
/// If there is no explicit affinity domain ID in the MRN list, the MPI ID is returned.
ClassMethod FindAffinityDomainID(pResponse As HS.Message.PatientSearchResponse, Output pID As %String = "", Output pADOID As %String = "") As %Status
{
	Set tSC=$$$OK
	Try {
		#; Abort if there are no results
		If '$IsObject($G(pResponse)) Quit
		If pResponse.Results.Count()<1 Quit
		
		#; Grab the affinity domain name		
		#; As a convience, return the affinity domain OID too 		
		Set tADName=..GetAffinityDomain()
		Set pADOID=##class(HS.Data.OIDMap).OIDForType(tADName,"AssigningAuthority")

		#; Typically the MPI ID is the affinity domain ID. However, during IHE
		#; testing, the affinity domain ID is explicitly set using the affinity
		#; domain name as the Facility/Assigninging authority. 
		For i=1:1:pResponse.Results.Count() {
			Set tMatch=pResponse.Results.GetAt(i)
			If tMatch.Facility=tADName,tMatch.AssigningAuthority=tADName {
				#; found a match, use this MRN and abort scan
				Set pID=tMatch.MRN
				Quit	
			} Else {
				#; default to the first MPI ID found during scan
				If pID="" Set pID=tMatch.MPIID
			}
		}		
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// Dump XMLMessage attachments as character streams rather than binary
ClassMethod TraceXMLMessage(pHost As HS.HC.Util.Trace.Helper, pClass As %String, pMethod As %String, pCaption As %String, pVarName As %String, pMessage As HS.Message.XMLMessage)
{
	If pHost.TraceOperations'="" {
		Do pHost.HSTrace(pClass,pMethod,pCaption,pVarName,pMessage)
		If $IsObject($G(pMessage)) {
			Set i="" For { Set tItem=pMessage.StreamCollection.GetNext(.i) Quit:i=""
				Set tItem=pMessage.StreamCollection.GetAt(i)
				Set tCharStream=##class(%GlobalCharacterStream).%New() 
				Do tCharStream.CopyFrom(tItem.Body)
				Do tCharStream.Rewind()
				Do pHost.HSTrace(pClass,pMethod,pCaption_": Attachment "_i,"Attachment"_i,tCharStream)
				Do pMessage.StreamCollection.GetAt(i).Body.Rewind()
			}
		}
	}
}

/// Returns the OID for this Affinity Domain assigning authority
ClassMethod GetAffinityDomain() As %String
{
	Quit ##class(HS.Registry.Config).GetKeyValue(..#KEYAffinityDomain)
}

/// Sets the OID for this affinity domain assigning authority
ClassMethod SetAffinityDomain(pName As %String = "") As %Status
{
	Quit ##class(HS.Registry.Config).AddUpdateKeyValue(..#KEYAffinityDomain,pName)
}

/// Returns the OID for this Affinity Domain assigning authority
ClassMethod GetHomeCommunity() As %String
{
	Quit ##class(HS.Registry.Config).GetKeyValue(..#KEYHomeCommunity)
}

/// Sets the OID for this affinity domain assigning authority
ClassMethod SetHomeCommunity(pName As %String = "") As %Status
{
	Quit ##class(HS.Registry.Config).AddUpdateKeyValue(..#KEYHomeCommunity,pName)
}

/// Gets all HomeCommunity OIDs in a delimited string
ClassMethod GetHomeCommunityOIDs() As %String
{
	Set tDelim = "|"
	Set tOIDs = ""
	Set tRS = ##class(%Library.ResultSet).%New()
	Set tRS.ClassName = "HS.Data.OIDMap"
	Set tRS.QueryName = "OIDItems"
	Set tSC = tRS.Execute("HomeCommunity")
	While tRS.%Next() { Set:tOIDs="" tOIDs=tDelim Set tOIDs=tOIDs_tRS.OID_tDelim }
	Do tRS.Close()
	Quit tOIDs
}

/// Merge AdditionInfo arrays, optionally overwriting existing values
ClassMethod MergeAdditionalInfo(pSource As HS.Message.XMLMessage, pTarget As HS.Message.XMLMessage, pOverwrite As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tKey = "" For { Set tValue = pSource.AdditionalInfo.GetNext(.tKey) Quit:tKey=""
			If 'pOverwrite, pTarget.AdditionalInfo.IsDefined(tKey) Continue
			Set tSC = pTarget.AdditionalInfo.SetAt(tValue, tKey)
		}
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Convert a XML stream into an object
ClassMethod XMLToObject(pStream As %Stream.Object, Output pObject As %XML.Adaptor, pClassname As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tReader = ##class(%XML.Reader).%New()
		Do tReader.CorrelateRoot(pClassname)
		Set tSC = tReader.OpenStream(pStream) $$$ThrowOnError(tSC)
		Set tOK = tReader.Next(.pObject, .tSC) $$$ThrowOnError(tSC)
		If 'tOK $$$ThrowStatus($$$ERROR($$$GeneralError,"Failed to correlate XML into object of type "_pClassname))
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

/// Convert an object into XML
ClassMethod ObjectToXML(pObject As %XML.Adaptor, Output pStream As %Stream.Object) As %Status
{
	#;FUTURE: perhaps use the XML writer instead
	Quit pObject.XMLExportToStream(.pStream)
}

/// Get a unique (to this instance) Id for PIXv2 or PDQv2 HL7 MSH:10 (Message ID) or QPD:2 (Query Tag).
ClassMethod GetIdForHL7() As %String
{
	// Maximum length for Id is 20.  With current scheme there is no need to check for max length.
	Quit $Increment(^HS.IHE.v2MessageID)
}

ClassMethod GetSendingApplication(pOverride As %String = "") As %String
{
	If pOverride'="" Quit pOverride
	Set tValue = ""
	Set tSC = ##class(HS.Registry.Config).FindByName("\IHE\SendingApplication", .tValue)
	If $$$ISERR(tSC) Quit "ISC-HealthShare"
	If tValue="" Quit "ISC-HealthShare"
	Quit tValue
}

/// AATypeForCode returns an Assigning Authority Type for the specified
/// code when there is one and only one instance of the code found in
/// the Assigning Authority Registry.  Currently Codes of IdentifierType
/// By default DN or LN are ignored (pExcludeTypes)
ClassMethod AAIdentifierTypeForCode(pCode As %String, ByRef pIdentifierType As %String, pExcludeTypes = "DN,DL") As %Status
{
	Set tSC = $$$OK
	
	Set pIdentifierType = ""
	
	Try {
		// Ignore AA types defined by pExcludeTypes
		For tIdx=1:1:$l(pExcludeTypes,",") {
			Set tType=$p(pExcludeTypes,",",tIdx)
			If tType]"" {
				Set tTypes($i(tTypes))=tType
			}
		}
		Set tSQL = "SELECT IdentifierType,Count(*) C FROM HS_AssignAuth.Config WHERE Code=?"
		If tTypes {
			Set tSQL=tSQL_" AND not(IdentifierType in ("
			For tIdx=1:1:tTypes {
				Set tSQL=tSQL_$S(tIdx=1:"",1:",")_"?"
			}
			Set tSQL=tSQL_"))"
			Set tRS1 = ##class(%SQL.Statement).%ExecDirect(,tSQL,pCode,tTypes...)
		} Else {
			Set tRS1 = ##class(%SQL.Statement).%ExecDirect(,tSQL,pCode)
		}

		If tRS1.%Next() {
			If tRS1.C=1 Set pIdentifierType = tRS1.IdentifierType
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod IsAsync(pMessage As HS.Message.XMLMessage) As %Boolean
{
	Set tReplyTo = pMessage.AdditionalInfo.GetAt("ReplyAddress")
	Quit ((tReplyTo]"") && (tReplyTo'["anonymous"))
}

}
