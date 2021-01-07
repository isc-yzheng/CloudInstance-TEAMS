Include %soap

/// HS.AU.PCEHR.Headers supports adding, signing and validating headers
/// that are defined as part of Australia Government's Department of Health and Ageing (Federal Agency)
/// NEHTA standards for the PCEHR B2B Gateway services.
/// Standards for the PCEHR Core System are accessible here: https://vendors.nehta.gov.au <br><br>
/// See AddRequestHeaders and AddResponseHeaders for details of how to add and sign headers.<br>
/// See ValidateHeaders for details of how to validate headers.
Class HS.AU.PCEHR.Headers Extends %RegisteredObject [ CompileAfter = HS.AU.PCEHR.IHINumber ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLFORMAT = "literal";

Parameter XMLNAME = "PCEHRHeader";

Parameter XMLSEQUENCE = 1;

Property Header As HS.AU.PCEHR.HeaderType(XMLNAME = "PCEHRHeader") [ Required ];

/// timestamp SOAP header will be created request.
/// timestamp SOAP header will reference header after validating received request.
Property timestamp As HS.AU.PCEHR.TimestampType;

/// signature SOAP header will be created for request and response and will sign other headers.
/// signature SOAP header will reference header after validating received request or response.
Property signature As HS.AU.PCEHR.SignatureContainerType;

/// Add request headers.
/// <ul>
/// <li>SOAP addressing headers will be created and added.</li>
/// <li>product header will be as supplied by caller by setting product property.</li>
/// <li>user header will be as supplied by caller by setting product property.</li>
/// <li>timestamp and signature headers will be created by this method.</li>
/// </ul>
/// 
/// AddRequestHeaders interface:
/// <ul>
/// <li>The service argument is required and is the web client or service for which to add the headers.</li>
/// <li>The credentials argument is the X.509 credentials object used for signing.
/// See %SYS.X509Credentials class documentation for details.</li>
/// <li>The optional interval argument is used to create the timestamp header,
/// if the optional expires field is desired.</li>
/// </ul>
Method AddRequestHeaders(service As %SOAP.WebBase, credentials As %SYS.X509Credentials, interval As %Integer)
{
			
	If $isobject(..Header) {
		Do service.HeadersOut.SetAt(..Header,"PCEHRHeader")
	}
	
	Set ..timestamp=##class(HS.AU.PCEHR.TimestampType).Create(.interval)
	Do service.HeadersOut.SetAt(..timestamp,"timestamp")
	
	Set ..signature=##class(HS.AU.PCEHR.SignatureContainerType).Create(service,credentials)
	Do service.HeadersOut.SetAt(..signature,"signature")
}

/// Add response headers.
/// <ul>
/// <li>SOAP addressing headers will be created and added.</li>
/// <li>product header will be as supplied by caller by setting product property.</li>
/// <li>signature header will be created by this method.</li>
/// </ul>
/// 
/// AddResponseHeaders interface:
/// <ul>
/// <li>The service argument is required and is the web client or service for which to add the headers.</li>
/// <li>The credentials argument is the X.509 credentials object used for signing.
/// See %SYS.X509Credentials class documentation for details.</li>
/// </ul>
Method AddResponseHeaders(service As %SOAP.WebBase, credentials As %SYS.X509Credentials)
{

	Set ..signature=##class(HS.AU.PCEHR.SignatureContainerType).Create(service,credentials)
	Do service.HeadersOut.SetAt(..signature,"signature")
}

/// Validate the signature and other Header required headers.<br>
/// If called from a web service, a fault is issued in case of error and this method does not return.<br>
/// If called from a web client, a %Status is returned in case of error.<br>
/// In order to valdate the headers the web service or client must be told to import the headers.<br>
/// Web service needs request headers defined in SOAPHEADERS parameter<br><br>
///    Parameter SOAPHEADERS = &nbsp;&nbsp;&nbsp;"signature:HS.AU.PCEHR.SignatureContainerType,User:HS.AU.PCEHR.UserType,IHINumber:HS.AU.PCEHR.IHINumber,ProductType:HS.AU.PCEHR.ProductType,ClientSystemType:HS.AU.PCEHR.ClientsystemType,AccessingOrganisation:HS.AU.PCEHR.AccessingOrganisation,timestamp:HS.AU.PCEHR.TimestampType"<br>
/// Web client needs response headers defined in SOAPHEADERS parameter<br>
///    Parameter SOAPHEADERS = &nbsp;&nbsp;&nbsp;"signature:HS.AU.PCEHR.SignatureContainerType"<br>
Method ValidateHeaders(service As %SOAP.WebBase) As %Status
{
	Set sc=$$$OK
	// Get header instances
	Set ..Header=service.HeadersIn.GetAt("PCEHRHeader")

	Set ..timestamp=service.HeadersIn.GetAt("timestamp")
	Set ..signature=service.HeadersIn.GetAt("signature")

	// Validate presence of a signature and validate the signature
	If '$isobject(..signature) || '$isobject(..signature.Signature) {
		Set error="No signature header"
		Set code="badSignature"
	} Else {
		Set error=..signature.Validate(service.ImportHandler,service)
		Set code="badSignature"
	}
	
	// Validate presence of specific headers here 
	/* Eg:
	If error="",'$isobject(..productType) {
		Set error="No product header"
		Set code="badlyFormedMsg"
	}
	*/
	If service.%Extends("%SOAP.WebClient") {
		// For web client just return any error as %Status
		If error'="" {
			Set sc=$$$ERROR($$$SOAPBadLogin,error)
		}
	} Else {
		
		// Validate presence of specific header for web service here
		/* Eg:
		If error="",'$isobject(..user) {
			Set error="No user header"
			Set code="notAuthenticated"
		}
		*/
		
		// Validate presence and expiration of timestamp header
		If error="" {
			If '$isobject(..timestamp) {
				Set error="No timestamp header"
				Set code="badTimestamp"
			} Else {
				Set error=..timestamp.Validate(service.ImportHandler,service)
				Set code="badTimestamp"
			}
		}
		// For web service error issue fault and do not return.
		If error'="" {
			Set fault=service.MakeFault($$$FAULTServer,code,error)
			Do service.ReturnFault(fault)
		}
	}
	
	Quit sc
}

}
