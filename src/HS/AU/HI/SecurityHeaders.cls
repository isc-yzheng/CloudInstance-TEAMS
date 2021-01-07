Class HS.AU.HI.SecurityHeaders Extends HS.Util.SOAPClient.Base
{

/// defaulted value of "http://ns.electronichealth.net.au/id/hi/vendorid/1.0"
Property VendorQualifier As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\AU\HI\SecurityHeader\VendorQualifier","http://ns.electronichealth.net.au/id/hi/vendorid/1.0")} ];

/// Deprecated parameter, use property instead
Parameter VendorQualifier As %String;

/// Vendor Id who has submitted the message. This field is used to validate that the software has been successfully tested as part of the NOI process.
/// For example: "4561237"
Property VendorID As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\AU\HI\SecurityHeader\VendorID","ISA00001")} ];

/// Deprecated parameter, use property instead
Parameter VendorID As %String;

/// Name of the software product used to submit the message. This field is used to validate that the software has been successfully tested as part of the NOI process.
/// For example: "National.eHealth.Transition.Authority.ReferencePlatform.1st.Edition"
Property ProductName As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\AU\SecurityHeader\ProductName","HealthShare")} ];

/// Deprecated parameter, use property instead
Parameter ProductName As %String;

/// Version of the software product used to submit the message. This field is used to validate that the software has been successfully tested as part of the NOI process.
/// For Example: "1.0.r1234"
Property ProductVersion As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\AU\SecurityHeader\ProductVersion","PCEHR Module 1.2")} ];

/// Deprecated parameter, use property instead
Parameter ProductVersion As %String;

/// Platform on which the software product used to submit the message was hosted
/// For Example: "Windows XP SP3"
Property ProductPlatform As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\AU\SecurityHeader\ProductPlatform",$system.Version.GetPlatform())} ];

/// Deprecated parameter, use property instead
Parameter ProductPlatform As %String;

/// Default Qualifier for Userid. 
/// For Example: "http://ns.organisation.org.au/id/hiclientname/userid/1.0"
Property DefaultUserQualifier As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\AU\HI\SecurityHeader\DefaultUserQualifier","http://www.intersystems.com/id/healthshare/userid/1.0")} ];

/// Deprecated parameter, use property instead
Parameter DefaultUserQualifier As %String;

/// User id. User must be authorised (by the organisation) to invoke the service.
/// For Example: "p08158"
Property DefaultUserID As %String [ InitialExpression = {##class(HS.Registry.Config).GetKeyValue("\AU\SecurityHeader\DefaultUserID")} ];

/// Deprecated parameter, use property instead
Parameter DefaultUserID As %String;

/// Header to be included in SOAP request
Property HIHeader As HS.AU.HI.Headers [ Final ];

/// X509 Credientials object for signing the SOAP Request
Property X509ForSigning As %SYS.X509Credentials [ Final ];

/// For signatures and encryption it is possible to override this code since there are different options - this is the standard Healthshare mechanism
/// To define specific Security for a web service Create a class which extends HS.Util.SOAPClient.Base and Override the AddSecurity Class Method
/// Add your class name to the Service Registry entry which you would like to run different security
ClassMethod AddSecurity(pWebRequest As %SOAP.WebRequest = "", pEndPoint As HS.Registry.Service.SOAP, pRequest As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	try {
		Set tAction = pWebRequest.AddressingOut.Action
		Set tThis = ..%New()

		; Set SSL Configuration name 
		if pEndPoint.SSLConfig="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Missing TLS/SSL Configuration (SSLConfig property) needed to establish connection."))
		}
		If pEndPoint.SignX509TokenProfile="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Missing or Incorrect X509 Certificate alias details ("_pEndPoint.SignX509TokenProfile_") for signing SOAP Requests."))
		}
		
		Set tSC = tThis.SetX509(pEndPoint.SignX509TokenProfile)
		; Do we have the common HI Header
		$$$THROWONERROR(tSC,tThis.SetHeaderValues(pRequest)) 
		
		; Prepare HIHeaders per standard, and, add to SOAP Client
		do tThis.HIHeader.AddRequestHeaders(pWebRequest,tThis.X509ForSigning,60)
	
	} Catch errVar {
		set tSC=errVar.AsStatus()
	}
    	
    quit tSC
}

Method MoveParameters()
{
	Set:..#DefaultUserQualifier]"" ..DefaultUserQualifier=..#DefaultUserQualifier
	Set:..#DefaultUserID]"" ..DefaultUserID=..#DefaultUserID
	Set:..#ProductPlatform]"" ..ProductPlatform=..#ProductPlatform
	Set:..#ProductName]"" ..ProductName=..#ProductName
	Set:..#ProductVersion]"" ..ProductVersion=..#ProductVersion
	Set:..#VendorID]"" ..VendorID=..#VendorID
	Set:..#VendorQualifier]"" ..VendorQualifier=..#VendorQualifier
}

/// Defines SOAP Header object from settings
Method SetHeaderValues(pRequest As HS.Message.XMLMessage) As %Status
{
	#; If someone is still using Parameters instead of properties
	Do ..MoveParameters()
	set ..HIHeader=##class(HS.AU.HI.Headers).%New()
			
	; User making the request (including User Qualifier string and User ID) is lifted from Adapter's settings. 
	set user=##class(HS.AU.HI.UserType).%New()
	set user.Qualifier=..DefaultUserQualifier 
	
	set user.ID=..DefaultUserID
	set:pRequest.SAMLData.UserName'="" user.ID=pRequest.SAMLData.UserName
	
	; Complete HIHeader values 
	set product=##class(HS.AU.HI.ProductType).%New()
	set qid=##class(HS.AU.HI.QualifiedId).%New()
	set qid.Qualifier=..VendorQualifier
	set qid.ID=..VendorID
	set product.Vendor=qid
	set product.ProductName=..ProductName
	set product.ProductVersion=..ProductVersion
	set product.Platform=..ProductPlatform
	set ..HIHeader.Product=product
	set ..HIHeader.User=user
	
	quit $$$OK
}

/// Set X509 credentials to use for signing request.
Method SetX509(pX509Alias) As %Status
{
	set tSC=$$$OK
	set ..X509ForSigning=##class(%SYS.X509Credentials).GetByAlias(pX509Alias)
	quit tSC
}

/// Validates the header siganture, and calls a custom validation method callback.
ClassMethod ValidateResponse(pWebRequest As %SOAP.WebClient, pSOAPAction As %String) As %Status
{
	set tSC=$$$OK
	; Validate the header signature.	
	set validator=##class(HS.AU.HI.Headers).%New()
	set tSC=validator.ValidateHeaders(pWebRequest) Quit:$$$ISERR(tSC) tSC	

	; Validate Header values
	set tSC=..OnValidateResponseHeaderValues(validator,pSOAPAction)
	quit tSC
}

/// Customise this method if you want to check for specific values within 
/// the returning headers.
/// For Example:
/// 	; check the returned header values here
/// 		If validator.product.platform'="MedicareAustralia" {
/// 			set tSC=$$$ERROR($$$GeneralError,"Unexpected product platform: "_validator.product.platform)
/// 		}
ClassMethod OnValidateResponseHeaderValues(validator As HS.AU.HI.Headers, webMethod As %String) As %Status
{
	quit $$$OK
}

}
