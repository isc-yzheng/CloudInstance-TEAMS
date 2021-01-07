Include HS.HC

/// Utility methods for setting up a simple starter set of OAuth 2.0 Configuration items within a single instance.
Class HS.HC.Util.Installer.OAuth2 Extends %RegisteredObject
{

/// SSL Configuration Name used throughout this utility.
Parameter OAuthSSLConfigName As %String = "OAuth2.SSLConfig";

/// Name in the HTTP Service Registry for obtaining the OAuth2 Issuer URL.
Parameter OAuthIssuerServiceName As %String = "OAuth2.Issuer";

/// ConfigureSampleOAuth sets up sample definitions for an OAuth 2.0 authorization
/// server and two OAuth 2.0 clients, all set up in the current instance. To force
/// the deletion of existing definitions before adding the sample definitions,
/// provide an input parameter value of 1.
ClassMethod ConfigureSampleOAuth(pForceDelete As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set %calledfrommain = 1
		
		Set tSC = ..ConfigureAuthServer(pForceDelete)
		If $$$ISERR(tSC) Quit
		
		If $$$WriteProg Write !
		
		Set tSC = ..ConfigureAuthClients()
		If $$$ISERR(tSC) Quit
		
		If $$$WriteProg Write !
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$WriteProg {
		If $$$ISERR(tSC) {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC)
		} Else {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" completed successfully"
		}
	}
	
	Kill %calledfrommain
	
	Quit tSC
}

/// ConfigureAuthServer configures the OAuth 2.0 authorization server for this
/// instance with some sample starter definitions. This method creates the
/// authorization server anew if it does not already exist. If an authorization
/// server is already defined, it will be overwritten only if the pForceDelete
/// parameter is passed in as 1.
ClassMethod ConfigureAuthServer(pForceDelete As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		Set tOrigNS = $Namespace
		
		Set tSSLConfigName = ..#OAuthSSLConfigName
		
		If tSSLConfigName="" {
			Set tSC = $$$ERROR($$$GeneralError,"SSL Configuration Name not specified")
		} ElseIf '$$$HSSecureIsActive {
			Set tSC = $$$ERROR($$$GeneralError,"No active Installer Wizard SSL Access definition found")
		} Else {
			Set tSC = ..CreateSSLConfig(tSSLConfigName)
		}
		If $$$ISERR(tSC) Quit
		
		Set tHost = $$$HSSecureHostName
		Set tPort = $$$HSSecurePort
		Set tPathPrefix = $$$HSSecurePrefix
		Set tSSLSecureRootURL = $$$HSSecureRootURL
		
		Set $Namespace = "%SYS"

		// Delete the existing Server configuration, or bail.
		Set server = ##class(OAuth2.Server.Configuration).Open()
		If $IsObject(server) {
			If pForceDelete {
				$$$ThrowOnError(server.Delete())
				Set server = ""
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "OAuth 2.0 Server Configuration already exists in this instance. To delete and re-create the OAuth 2.0 Server Configuration, specify an input parameter value of 1.")
				Quit
			}
		}
		
		Set server=##class(OAuth2.Server.Configuration).%New()
		Set server.Description = "InterSystems Authorization Server"
		Set server.IssuerEndpoint.Host       = tHost
		Set server.IssuerEndpoint.Port       = tPort
		Set server.IssuerEndpoint.Prefix     = tPathPrefix
		Set server.IssuerEndpoint.UseSSL     = 1
		Set server.AllowUnsupportedScope     = 0
		Set server.AudRequired               = 1
		Set server.SupportSession            = 0
		Set server.ReturnRefreshToken        = "a"
		Set server.SupportedGrantTypes       = "APC"
		Set server.GenerateTokenClass        = "%OAuth2.Server.JWT"
		Set server.CustomizationNamespace    = "%SYS"
		Set server.CustomizationRoles        = "%All"
		Set server.DefaultScope = "user/*.read"
		Do server.SupportedScopes.SetAt("Permission to obtain launch context when app is launched from an EHR",   "launch")
		Do server.SupportedScopes.SetAt("Permission to select patient at launch time",                            "launch/patient")
		Do server.SupportedScopes.SetAt("Permission to read any resource for the current patient",                "patient/*.read")
		Do server.SupportedScopes.SetAt("Permission to read all resources that the current user can access",      "user/*.read")
		Do server.SupportedScopes.SetAt("Display patient demographics header with app data",                      "need_patient_banner")
		Do server.SupportedScopes.SetAt("Permission to retrieve information about the current logged-in user",    "openid")
		Do server.SupportedScopes.SetAt("Permission to retrieve information about the current logged-in user",    "profile")
		Set server.SSLConfiguration          = tSSLConfigName
		Set tSC = server.Save()
		Kill server
		
		Set $Namespace = tOrigNS
		
		#dim tOAuthService As HS.Registry.Service.HTTP
		
		Set tOAuthService = ##class(HS.Registry.Service.Abstract).EndPointForNameType(..#OAuthIssuerServiceName, "HTTP")
		If '$IsObject(tOAuthService) {
			Set tOAuthService = ##class(HS.Registry.Service.HTTP).%New()
			Set tOAuthService.Type = "HTTP"
			Set tOAuthService.Name = ..#OAuthIssuerServiceName
		}
		Set tOAuthService.Host = tHost
		Set tOAuthService.Port = tPort
		Set tOAuthService.URL = $Select(tPathPrefix'="":"/"_tPathPrefix,1:"")_"/oauth2"
		Set tOAuthService.SSLConfig = tSSLConfigName
		Set tSC = tOAuthService.%Save()
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$WriteProg {
		If $$$ISERR(tSC) {
			If '$Get(%calledfrommain) Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC)
		} Else {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" completed successfully"
		}
	}
	
	Quit tSC
}

/// CreateSSLConfig creates a basic SSL/TLS config.  It does not overwrite an existing definition.
ClassMethod CreateSSLConfig(pSSLConfigName As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		New $Namespace
		Set $Namespace = "HSLIB"
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateSSLConfig", "%", pSSLConfigName, "")
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ConfigureAuthClients configures a sample confidential client and a sample resource
/// server client for the current instance.
ClassMethod ConfigureAuthClients() As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSSLConfigName = ..#OAuthSSLConfigName
		
		// First verify that the OAuth Server has been registered in the Service Registry
		Set tOAuthService = ##class(HS.Registry.Service.Abstract).EndPointForNameType(..#OAuthIssuerServiceName, "HTTP")
		If '$IsObject(tOAuthService) {
			Set tSC = $$$ERROR($$$GeneralError,"The OAuth 2.0 Server issuer endpoint is not configured in the Service Registry in this namespace. Please rerun the ConfigureAuthServer method")
			Quit
		}
		Set tOAuthIssuerURL = tOAuthService.EndPoint
		Kill tOAuthService
		
		// Now Ensure that the ServerDefinition for this instances matches
		// the metadata received from the OAuth Server.
		Set tSC = ..OAuthServerDiscoverAndSave(tOAuthIssuerURL, tSSLConfigName)
		if $$$ISERR(tSC) Quit
		
		// Now Create our Confidential Client and Resource Server Client and Register
		// with the OAuth Server
		Set tSC = ..EnsureClients(tOAuthIssuerURL, tSSLConfigName, $$$HSSecureHostName, $$$HSSecurePort, $$$HSSecurePrefix)
		If $$$ISERR(tSC) Quit

	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$WriteProg {
		If $$$ISERR(tSC) {
			If '$Get(%calledfrommain) Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC)
		} Else {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" completed successfully"
		}
	}
	
	Quit tSC
}

/// This method Ensures that there is a ServerDefinition for the OAuth2 Server on this instance
ClassMethod OAuthServerDiscoverAndSave(pIssuerEndpoint As %String, pSSLConfigName As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		New $Namespace
		
		Set tSC = ..CreateSSLConfig(pSSLConfigName)
		If $$$ISERR(tSC) Quit
		
		Set $Namespace = "%SYS"
		
		#; Issuer index is case-sensitive and trailing slash-sensitive.  Casing, and
		#; presence or absence of trailing slash on the issuer endpoint is assumed
		#; to be intentional.
		Set sys = ##class(OAuth2.ServerDefinition).OpenByIssuer(pIssuerEndpoint, .tSC)
		If $$$ISERR(tSC) Quit
		#; This method will re-run Discover and Save on an existing server definition WITHOUT
		#; deleting it first.
		Set tId = $Select($IsObject($Get(sys)):sys.%Id(),1:"")
		
		#; Setting these explicitly just to indicate that we know these items exist but we are
		#; not providing values.
		Set tServerCredentials = ""
		Set tInitialAccessToken = ""
		
		// Get metadata from the Server's Discovery Endpoint
		Set tSC = ##class(OAuth2.ServerDefinition).GetServerMetadata(pIssuerEndpoint, pSSLConfigName, .metadata)

		If $$$ISERR(tSC) Quit
		
		If (tId'="")&&(##class(OAuth2.ServerDefinition).%ExistsId(tId)) {
			Set sys = ##class(OAuth2.ServerDefinition).Open(tId)
		} Else {
			Set sys = ##class(OAuth2.ServerDefinition).%New()
		}
		// Update or populate Important Fields
		Set sys.IssuerEndpoint = pIssuerEndpoint
		Set sys.SSLConfiguration = pSSLConfigName
		Set sys.ServerCredentials = tServerCredentials
		Set sys.InitialAccessToken = tInitialAccessToken

		Tstart
		// Update with the current metadata from the server
		If $isobject(sys.Metadata) {
			Do ##class(OAuth2.Server.Metadata).%DeleteId(sys.Metadata.%Id())
		}
		Set sys.Metadata = metadata

		Set tSC = sys.%Save()

		If $$$ISERR(tSC) {
			Trollback
			If $$$GETERRORCODE(tSC)=$$$ERRORCODE($$$KeyNotUnique) {
				Set tSC = $$$ERROR($$$GeneralError,"Not saved.  Issuer endpoint is not unique.")
			}
		} Else {
			Tcommit
		}
		
		Kill sys
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Get Client Name for Confidential Client
ClassMethod GetOAuthConClientName() [ Internal ]
{
	Set tInstanceName = ##class(%SYS.System).GetInstanceName()
	Quit tInstanceName_".Client"
}

/// Get Client Name for Resource Server Client
ClassMethod GetOAuthRSClientName() [ Internal ]
{
	Set tInstanceName = ##class(%SYS.System).GetInstanceName()
	Quit tInstanceName_".RSClient"
}

ClassMethod EnsureClients(pIssuerEndpoint As %String, pSSLConfig As %String, pRedirectHost As %String, pRedirectPort As %String, pRedirectPrefix As %String) As %Boolean [ Internal ]
{
	Set tSC = $$$OK
	If '..HasConfidentialClient(pIssuerEndpoint, pSSLConfig, pRedirectHost, pRedirectPort, pRedirectPrefix) {
		Set tSC = ..CreateConfidentialClient(pIssuerEndpoint, pSSLConfig, pRedirectHost, pRedirectPort, pRedirectPrefix)
	}
	If ($$$ISOK(tSC))&&('..HasResourceServerClient(pIssuerEndpoint, pSSLConfig)) {
		Set tSC = ..CreateResourceServerClient(pIssuerEndpoint, pSSLConfig)	
	}
	Quit tSC
}

ClassMethod HasConfidentialClient(pIssuerEndpoint As %String, pSSLConfig As %String, pRedirectHost As %String, pRedirectPort As %String, pRedirectPrefix As %String) As %Boolean [ Internal ]
{
	#dim tExists as %Boolean = 0
	Set applicationName = ..GetOAuthConClientName()
	try {
		New $Namespace
		Set $Namespace = "%SYS"
		
		Set client = ##class(OAuth2.Client).%OpenId(applicationName)
		If '$IsObject($Get(client)) {
			Quit
		}
		Quit:client.ClientType'="confidential" 
		Quit:client.RedirectionEndpoint.Host'=pRedirectHost
		Quit:client.RedirectionEndpoint.Port'=pRedirectPort
		Quit:client.RedirectionEndpoint.Prefix'=pRedirectPrefix
		Quit:client.SSLConfiguration'=pSSLConfig
		Quit:client.ServerDefinition.IssuerEndpoint'=pIssuerEndpoint
		Set tExists = 1
		
	} Catch eException {
	}
	Kill client
	Quit tExists
}

ClassMethod HasResourceServerClient(pIssuerEndpoint As %String, pSSLConfig As %String) As %Boolean [ Internal ]
{
	#dim tExists as %Boolean = 0
	Set applicationName = ..GetOAuthRSClientName()
	try {
		New $Namespace
		Set $Namespace = "%SYS"
		
		Set client = ##class(OAuth2.Client).%OpenId(applicationName)
		If '$IsObject($Get(client)) {
			Quit
		}
		Quit:client.ClientType'="resource" 
		Quit:client.SSLConfiguration'=pSSLConfig
		Quit:client.ServerDefinition.IssuerEndpoint'=pIssuerEndpoint
		Set tExists = 1
		
	} Catch eException {
	}
	Kill client
	Quit tExists
}

/// Specialized dynamic registration of the sample confidential client,
/// which has many specific settings to include.
ClassMethod CreateConfidentialClient(pIssuerEndpoint As %String, pSSLConfig As %String, pRedirectHost As %String, pRedirectPort As %String, pRedirectPrefix As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Do ##class(%Net.URLParser).Parse(pIssuerEndpoint, .urlparts)
	Set applicationName = ..GetOAuthConClientName()
	Set tOAuthServerRoot = "https://"_urlparts("netloc")	
	
	Try {
		New $Namespace
		Set $Namespace = "%SYS"
		
				
		Set client = ##class(OAuth2.Client).%OpenId(applicationName)
		If $IsObject($Get(client)) {
			Set tSC = client.DeleteId(applicationName)
			If $$$ISERR(tSC) Quit
			kill client
		}
		
		Set sys = ##class(OAuth2.ServerDefinition).OpenByIssuer(pIssuerEndpoint, .tSC)
		If '$IsObject($Get(sys)) {
			Set tSC = $$$ERROR($$$GeneralError, "No server definition found for "_pIssuerEndpoint)
			Quit
		}
		Set tServerDefinition = sys.%Id()
		
		Set client = ##class(OAuth2.Client).%New()
		Set client.ApplicationName = applicationName
		Set client.ServerDefinition = sys
		Set client.Enabled = 1
		Set client.ClientType = "confidential"
		Set client.Description = "OAuth Confidential Client for Instance "_##class(%SYS.System).GetInstanceName()
		Set client.SSLConfiguration = pSSLConfig
		Set client.RedirectionEndpoint.UseSSL = 1
		Set client.RedirectionEndpoint.Host = pRedirectHost
		Set client.RedirectionEndpoint.Port = pRedirectPort
		Set client.RedirectionEndpoint.Prefix = pRedirectPrefix
		Set client.DefaultScope = "user/*.read"
		
		Set clientMetadata = ##class(OAuth2.Client.Metadata).%New()
		Set clientMetadata."token_endpoint_auth_method" = "client_secret_post"
		Set clientMetadata."token_endpoint_auth_signing_alg" = "RS512"
		Set clientMetadata."grant_types"    = $lb("authorization_code","password","client_credentials")
		Set clientMetadata."response_types" = $lb("code","id_token","id_token token","token")
		Set clientMetadata."client_name"    = applicationName
		set clientMetadata."jwks_uri" = tOAuthServerRoot_"/csp/sys/oauth2/OAuth2.JWTServer.cls?client_name="_applicationName

		Set clientMetadata."id_token_signed_response_alg" = "RS512"
		Set clientMetadata."id_token_encrypted_response_alg" = "RSA-OAEP"
		Set clientMetadata."id_token_encrypted_response_enc" = "A256CBC-HS512"
		
		Set clientMetadata."userinfo_signed_response_alg" = "RS512"
		Set clientMetadata."userinfo_encrypted_response_alg" = "RSA-OAEP"
		Set clientMetadata."userinfo_encrypted_response_enc" = "A256CBC-HS512"

		Set clientMetadata."access_token_signed_response_alg" = "RS512"
		Set clientMetadata."access_token_encrypted_response_alg" = "RSA-OAEP"
		Set clientMetadata."access_token_encrypted_response_enc" = "A256CBC-HS512"

		Set clientMetadata."request_object_signing_alg" = "RS512"
		Set clientMetadata."request_object_encryption_alg" = "RSA-OAEP"
		Set clientMetadata."request_object_encryption_enc" = "A256CBC-HS512"
		
		Set client.Metadata = clientMetadata
		
		Set tSC = client.RegisterClient()
		
		Kill client
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($$$WriteProg)&&($$$ISOK(tSC)) {
		Write !,..%ClassName(1)_" "_$$$CurrentMethod_" successfully added confidential client '"_applicationName_"'"
		Write !
	}
	
	Quit tSC
}

/// Specialized dynamic registration of the sample resource server client,
/// which has many specific settings to include.
ClassMethod CreateResourceServerClient(pIssuerEndpoint As %String, pSSLConfig As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Do ##class(%Net.URLParser).Parse(pIssuerEndpoint, .urlparts)
	Set applicationName = ..GetOAuthRSClientName()
	Set tOAuthServerRoot = "https://"_urlparts("netloc")	
	
	Try {
		New $Namespace
		Set $Namespace = "%SYS"
		
				
		Set client = ##class(OAuth2.Client).%OpenId(applicationName)
		If $IsObject($Get(client)) {
			Set tSC = client.DeleteId(applicationName)
			If $$$ISERR(tSC) Quit
			kill client
		}
		
		Set sys = ##class(OAuth2.ServerDefinition).OpenByIssuer(pIssuerEndpoint, .tSC)
		If '$IsObject($Get(sys)) {
			Set tSC = $$$ERROR($$$GeneralError, "No server definition found for "_pIssuerEndpoint)
			Quit
		}
		Set tServerDefinition = sys.%Id()
		
		Set client = ##class(OAuth2.Client).%New()
		Set client.ApplicationName = applicationName
		Set client.ServerDefinition = sys
		Set client.Enabled = 1
		Set client.ClientType = "resource"
		Set client.Description = "OAuth Resource Server Client for Instance "_##class(%SYS.System).GetInstanceName()
		Set client.SSLConfiguration = pSSLConfig
		Set client.DefaultScope = "user/*.read"
		
		Set clientMetadata = ##class(OAuth2.Client.Metadata).%New()
		Set clientMetadata."token_endpoint_auth_method" = "client_secret_post"
		Set clientMetadata."token_endpoint_auth_signing_alg" = "RS512"
		Set clientMetadata."grant_types"    = $lb("authorization_code","password","client_credentials")
		Set clientMetadata."response_types" = $lb("code","id_token","id_token token","token")
		Set clientMetadata."client_name"    = applicationName
		set clientMetadata."jwks_uri" = tOAuthServerRoot_"/csp/sys/oauth2/OAuth2.JWTServer.cls?client_name="_applicationName

		Set clientMetadata."id_token_signed_response_alg" = "RS512"
		Set clientMetadata."id_token_encrypted_response_alg" = "RSA-OAEP"
		Set clientMetadata."id_token_encrypted_response_enc" = "A256CBC-HS512"
		
		Set clientMetadata."userinfo_signed_response_alg" = "RS512"
		Set clientMetadata."userinfo_encrypted_response_alg" = "RSA-OAEP"
		Set clientMetadata."userinfo_encrypted_response_enc" = "A256CBC-HS512"

		Set clientMetadata."access_token_signed_response_alg" = "RS512"
		Set clientMetadata."access_token_encrypted_response_alg" = "RSA-OAEP"
		Set clientMetadata."access_token_encrypted_response_enc" = "A256CBC-HS512"

		Set clientMetadata."request_object_signing_alg" = "RS512"
		Set clientMetadata."request_object_encryption_alg" = "RSA-OAEP"
		Set clientMetadata."request_object_encryption_enc" = "A256CBC-HS512"
		
		Set client.Metadata = clientMetadata
		
		Set tSC = client.RegisterClient()
		
		Kill client
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($$$WriteProg)&&($$$ISOK(tSC)) {
		Write !,..%ClassName(1)_" "_$$$CurrentMethod_" successfully added resource server client '"_applicationName_"'"
		Write !
	}
	
	Quit tSC
}

/// "Vanilla" client registration, does not include setup of special values for
/// items beyond what is available to define via this method's parameter list.
ClassMethod DynamicClientRegister(pIssuerEndpoint As %String, pApplicationName As %String, pSSLConfigName As %String, pClientType As %String, pRedirectHost As %String, pRedirectPort As %String = "", pRedirectPrefix As %String = "", pRedirectUseSSL As %Boolean = 0, pOverwrite As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		New $Namespace
		Set $Namespace = "%SYS"
		
		Set client = ##class(OAuth2.Client).%OpenId(pApplicationName)
		If $IsObject($Get(client)) {
			If pOverwrite=0 {
				Set tSC = $$$ERROR($$$GeneralError, "Client already defined for application name "_pApplicationName)
				Quit
			} Else {
				Set tSC = client.DeleteId(pApplicationName)
				If $$$ISERR(tSC) Quit
			}
		}
		
		#; This method expects the presence or absence of trailing slash on the issuer endpoint
		#; to be intentional.
		Set sys = ##class(OAuth2.ServerDefinition).OpenByIssuer(pIssuerEndpoint, .tSC)
		If $$$ISERR(tSC) Quit
		If '$IsObject($Get(sys)) Set tSC = $$$ERROR($$$GeneralError, "No server definition found for "_pIssuerEndpoint) Quit
		Set tServerDefinition = sys.%Id()
		
		Set client = ##class(OAuth2.Client).%New()
		Set client.ApplicationName = pApplicationName
		Set client.ServerDefinition = sys
		Set client.Enabled = 1
		Set client.ClientType = pClientType
		Set client.Description = ""
		Set client.SSLConfiguration = pSSLConfigName
		if pClientType'="resource" {
			Set client.RedirectionEndpoint.UseSSL = pRedirectUseSSL
			Set client.RedirectionEndpoint.Host = pRedirectHost
			Set client.RedirectionEndpoint.Port = pRedirectPort
			Set client.RedirectionEndpoint.Prefix = pRedirectPrefix
		}
		Set client.DefaultScope = "user/*.read"
		
		Set clientMetadata = ##class(OAuth2.Client.Metadata).%New()
		Set clientMetadata."token_endpoint_auth_method" = "client_secret_basic"
		Set clientMetadata."grant_types"    = $lb("authorization_code","password","client_credentials")
		Set clientMetadata."response_types" = $lb("code","id_token","id_token token","token")
		Set clientMetadata."client_name" = pApplicationName
		
		Set client.Metadata = clientMetadata
		
		Set tSC = client.RegisterClient()
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

}
