Include %soap

/// HS.AU.HI.Headers supports adding, signing and validating headers
/// that are defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br><br>
/// See AddRequestHeaders and AddResponseHeaders for details of how to add and sign headers.<br>
/// See ValidateHeaders for details of how to validate headers.
Class HS.AU.HI.Headers Extends %RegisteredObject
{

/// product SOAP header is to be supplied by caller for creating request and response.
/// product SOAP header will reference header after validating.
Property Product As HS.AU.HI.ProductType;

/// user SOAP header is to be supplied by caller for creating request.
/// user SOAP header will reference header after validating received request.
Property User As HS.AU.HI.UserType;

/// timestamp SOAP header will be created request.
/// timestamp SOAP header will reference header after validating received request.
Property Timestamp As HS.AU.HI.TimestampType;

/// signature SOAP header will be created for request and response and will sign other headers.
/// signature SOAP header will reference header after validating received request or response.
Property Signature As HS.AU.HI.SignatureContainerType;

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
	If $isobject(..Product) {
		Do service.HeadersOut.SetAt(..Product,"product")
	}

	If $isobject(..User) {
		Do service.HeadersOut.SetAt(..User,"user")
	}
	
	Set ..Timestamp=##class(HS.AU.HI.TimestampType).Create(.interval)
	Do service.HeadersOut.SetAt(..Timestamp,"timestamp")
	
	Set ..Signature=##class(HS.AU.HI.SignatureContainerType).Create(service,credentials)
	Do service.HeadersOut.SetAt(..Signature,"signature")
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
	If $isobject(..Product) {
		Do service.HeadersOut.SetAt(..Product,"product")
	}

	Set ..Signature=##class(HS.AU.HI.SignatureContainerType).Create(service,credentials)
	Do service.HeadersOut.SetAt(..Signature,"signature")
}

/// Validate the signature and other HI required headers.<br>
/// If called from a web service, a fault is issued in case of error and this method does not return.<br>
/// If called from a web client, a %Status is returned in case of error.<br>
/// In order to valdate the headers the web service or client must be told to import the headers.<br>
/// Web service needs request headers defined in SOAPHEADERS parameter<br><br>
///    Parameter SOAPHEADERS = &nbsp;&nbsp;&nbsp;"signature:HS.AU.HI.SignatureContainerType,product:HS.AU.HI.ProductType,user:HS.AU.HI.UserType,timestamp:HS.AU.HI.TimestampType"<br>
/// Web client needs response headers defined in SOAPHEADERS parameter<br>
///    Parameter SOAPHEADERS = &nbsp;&nbsp;&nbsp;"signature:HS.AU.HI.SignatureContainerType,product:HS.AU.HI.ProductType"<br>
Method ValidateHeaders(service As %SOAP.WebBase) As %Status
{
	Set sc=$$$OK
	// Get header instances
	Set ..Product=service.HeadersIn.GetAt("product")
	Set ..User=service.HeadersIn.GetAt("user")
	Set ..Timestamp=service.HeadersIn.GetAt("timestamp")
	Set ..Signature=service.HeadersIn.GetAt("signature")

	// Validate presence of a signature and validate the signature
	If '$isobject(..Signature) || '$isobject(..Signature.Signature) {
		Set error="No signature header"
		Set code="badSignature"
	} Else {
		Set error=..Signature.Validate(service.ImportHandler,service)
		Set code="badSignature"
	}
	
	// Validate presence of product header
	If error="",'$isobject(..Product) {
		Set error="No product header"
		Set code="badlyFormedMsg"
	}
	
	If service.%Extends("%SOAP.WebClient") {
		// For web client just return any error as %Status
		If error'="" {
			Set sc=$$$ERROR($$$SOAPBadLogin,error)
		}
	} Else {
		// Validate presence of user header for web service
		If error="",'$isobject(..User) {
			Set error="No user header"
			Set code="notAuthenticated"
		}
		// Validate presence and expiration of tiomestamp header
		If error="" {
			If '$isobject(..Timestamp) {
				Set error="No timestamp header"
				Set code="badTimestamp"
			} Else {
				Set error=..Timestamp.Validate(service.ImportHandler,service)
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
