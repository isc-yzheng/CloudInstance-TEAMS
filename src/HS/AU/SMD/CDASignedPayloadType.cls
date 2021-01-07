Include %soap

/// Implementation of Australian E-health XML secured payload profiles.<br>
/// Document ATS 5821-2010<br><br>
/// 
/// To create a signedPayload just call the Create class method with a data object
/// and %SYS.X509Credentials object that contains the certificate and private key of the sender.
/// Additional signatures may be added using the AddSignature method.<br><br>
/// 
/// To validate a signedPayload call the Validate method of the SignedPayloadType object.
Class HS.AU.SMD.CDASignedPayloadType Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "signedPayload";

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/SignedPayload/2010";

Parameter XMLPREFIX = "sp";

Property Signatures As HS.AU.SMD.SignatureListType(XMLNAME = "signatures") [ Required ];

Property SignedPayloadData As HS.AU.SMD.eSignatureType(XMLNAME = "signedPayloadData") [ Required ];

Property payloadStream As %BinaryStream(XMLPROJECTION = "none") [ Internal ];

/// Create a SignedPayload and sign using a Signature.<br>
/// - data is the subclass of HS.AU.SMD.BaseDataType that contains the payload.<br>
/// - credentials contains the X.509 credentials used to sign the data.<br>
/// - If error, error %Status is stored in status argument.
ClassMethod Create(data As HS.AU.SMD.BaseDataType, credentials As %SYS.X509Credentials = "", Output status As %Status) As HS.AU.SMD.SignedPayloadType
{
	// Create the SignedPayload object
	Set payload=..%New()
	
	// Save the data as both object and stream
	Set payload.Signatures=##class(HS.AU.SMD.SignatureListType).%New()
	Set payload.SignedPayloadData=##class(HS.AU.SMD.SignedPayloadDataType).Create()
	Set payload.SignedPayloadData.Content=data
	Set writer=##class(%XML.Writer).%New()
	set writer.NoXMLDeclaration=1
	Set status=writer.OutputToStream(.str)
	If $$$ISOK(status) Set status=writer.StartDocument()
	If $$$ISOK(status) Set status=writer.RootObject(payload)
	If $$$ISOK(status) Set status=writer.EndDocument()
	If $$$ISOK(status) Set payload.payloadStream=str
	
	// Sign the data
	If $$$ISOK(status),credentials'="" {
		Set status=payload.AddSignature(credentials)
	}
	
	If $$$ISOK(status) {
		Quit payload
	} Else {
		Quit ""
	}
}

/// Add an additional signature and sign payload with this signature.
/// AddSignature method should be called after Create.
Method AddSignature(credentials As %SYS.X509Credentials) As %Status
{
	Set status=$$$OK
	Set signature=##class(%XML.Security.Signature).CreateX509(credentials,$$$SOAPWSIncludeNone,$$$KeyInfoX509Certificate,.status)
	// Allow override of SHA version to use SHA1 when required for AU services.  
	// This allows simpler changing when AU services update to use SHA256
	Set tSHAVer = ##class(HS.Registry.Config).GetKeyValue("\AustralianCustomisations\SHAVersion","")
	If tSHAVer = "SHA1"
	{
		Do signature.SetSignatureMethod($$$SOAPWSrsasha1)
		Do signature.SetDigestMethod($$$SOAPWSsha1)
	}
	If $isobject(signature) {
		Do signature.AddReference(##class(%XML.Security.Reference).Create(..SignedPayloadData.ID))
		Do ..Signatures.Signature.Insert(signature)
		Set status=signature.SignStream(..payloadStream)
	}
	Quit status
}

/// Validate the signatures in a signedPayload.
/// The document argument is the DOM for the document which contains the payload.
/// For SOAP messages, the document is in the ImportHandler property of the client or service.
/// Otherwise the payload may be exported and then the %XML.Reader OpenStream method will
/// convert the stream to a document in its Document property.
Method Validate(document As %XML.Document) As %Status
{
	Set status=$$$OK
	If ..Signatures="" Quit status
	
	For i=1:1:..Signatures.Signature.Count() {
		Set sig=..Signatures.Signature.GetAt(i)
		Set status=sig.ValidateDocument(document)
		If $$$ISERR(status) Quit
	}
	
	Quit status
}

}
