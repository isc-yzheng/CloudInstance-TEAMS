Class HS.Types.AuthDomainInfo Extends (%RegisteredObject, %XML.Adaptor, HS.Util.CopyFrom)
{

/// %HS* domains are internal to HealthShare.  Authentication and Authorization data is maintained in
/// the UserLogin table.  Other domains are maintained externally
Property DomainCode As %String [ Required ];

Property Description As %String;

/// Roles (which includes consent groups) that this domain is allowed to assign
Property Roles As list Of %String(MAXLEN = 64);

/// One domain is designated as the default
Property DefaultFlag As %Boolean;

/// For non-%HS* domains
/// Name of the (SOAP) service registry entry that is used to authenticate this domain,
Property AuthenticationServiceName As %String(MAXLEN = 255);

/// For non-%HS* domains
/// Name of the (SOAP) service registry entry that is used to get authorization info for this domain,
Property AuthorizationServiceName As %String(MAXLEN = 255);

/// Facility Code, IDKEY to Facility Table
Property FacilityCode As %String;

/// This is the name of the class that will contain the callback methods OnAuthenticate and OnAuthorize
/// It should extend HS.Registry.Person.User.HSAuth
Property CallbackClass As %String [ InitialExpression = "HS.Registry.Person.User.HSAuth" ];

/// Two factor is only supported starting with 2015.1.
/// If turned on for a domain, it means that users logging in on that domain will be required
/// to provide a second factor
Property UseTwoFactor As %Boolean;

}
