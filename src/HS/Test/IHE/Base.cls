Class HS.Test.IHE.Base Extends HS.HC.Test.TestCase [ Abstract ]
{

/// Class where the base XData Items exists
Parameter BaseClassItems;

Method Setup()
{
	#define XData(%val,%node) Do ..getStream(%val,.%node) if %node]"" 
	try {
		Do ##class(HS.Util.SystemAPI).CreateServiceUser(1)  /// force enable HS_Services
		Set tSC = ..SetupCSPNSApp($namespace)
		$$$HSTestAssertTrueOrBail(tSC)
		Set tSC = ..SetupFirst()
		$$$HSTestAssertTrueOrBail(tSC)
		Set tSC = ..SetupMain()
		$$$HSTestAssertTrueOrBail(tSC)
		Set tSC = ..SetupLast()
		$$$HSTestAssertTrueOrBail(tSC)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod SetupCSPNSApp(pNS)
{
	Set tSC=$$$OK
	try {
		New $namespace
		set $namespace="%SYS"
		Set tSLASH = $S($$$isUNIX:"/",1:"\")
		Set tApp = "/csp/healthshare/"_pNS_"/services"
		Set tSourceDir=$system.Util.InstallDirectory()_$tr($E(tApp,2,*),"/",tSLASH)

		set tExists=##class(Security.Applications).Exists(tApp)
		// Note: This does not update an existing application !
		If 'tExists {
			Set tSC = ##class(%EnsembleMgr).createPortalApp(tApp,pNS,tSourceDir,"testing app","",1,"",$g(tRoles),tApp,32,0)
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SetupFirst()
{
	Try {
		Set tSC = ##class(Ens.Director).StopProduction(,1)
		Quit:'$$$AssertStatusOK(tSC,"Production Stopped")
		Do ..CleanupProductionChanges("Test")
		$$$HSTestAssertTrueOrBail(tSC)
		Do ##class(HS.Data.OIDMap).FileOID("HomeCommunity","AssigningAuthority","1.3.6.1.4.1.21367.2010.1.2.300","Home Community")
		Do ##class(HS.IHE.Util).SetAffinityDomain("HomeCommunity")
		Do ##class(HS.IHE.Util).SetHomeCommunity("HomeCommunity")
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method SetupMain()
{
	Set tSC=$$$OK
	Quit tSC
}

Method SetupLast()
{
	try {
		Set pNS=$namespace
		Set tSC = $$$OK
		$$$XData("Items",node) Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods(pNS,node,1) 
		Quit:'$$$AssertStatusOK(tSC,"Production Modifications "_node)
		$$$XData("AdditionalItems",node) Set tSC= ##class(HS.Util.Installer.Kit.Base).ProductionMods(pNS,node,1)
		Quit:'$$$AssertStatusOK(tSC,"Production Modifications AdditionalItems "_node)
		$$$XData("OIDEntries",node) Set tSC = ##class(HS.Util.Installer.Kit.Base).AddOIDEntries(pNS,node)
		Quit:'$$$AssertStatusOK(tSC,"OID Entries "_node)
		$$$XData("AdditionalOIDEntries",node) Set tSC = ##class(HS.Util.Installer.Kit.Base).AddOIDEntries(pNS,node)
		Quit:'$$$AssertStatusOK(tSC,"Additional OID Entries "_node)
		$$$XData("RegistryEntries",node) Set tSC = ##class(HS.Util.Installer.Kit.Base).AddRegistryEntries(pNS,node)
		Quit:'$$$AssertStatusOK(tSC,"Registry Entries "_node)
		$$$XData("AdditionalRegistryEntries",node) Set tSC = ##class(HS.Util.Installer.Kit.Base).AddRegistryEntries(pNS,node) 
		Quit:'$$$AssertStatusOK(tSC,"Additional Registry Entries "_node)
		Set tSC = ##class(Ens.Director).StartProduction()
		$$$HSTestAssertTrueOrBail(tSC)
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Look in current class for XData node, if not found look in HS.Test.IHE.XDSb.Base
Method getStream(pXData, Output pNode)
{
	Set pNode=""
	Set tNodes=$lb("xdata://"_..%ClassName(1)_":"_pXData)
	If ..#BaseClassItems]"" {
		Set tNodes=tNodes_$lb("xdata://"_..#BaseClassItems_":"_pXData)
	}
	For tNodeIdx=1:1:$ll(tNodes) {
		Set tNode=$li(tNodes,tNodeIdx)
		Set tSC = ##class(HS.Util.Installer.Kit.Base).getStream(tNode,.tStream)
		If $$$ISOK(tSC) && $IsObject(tStream) && tStream.Size Quit
	}
	Quit:'$IsObject($G(tStream)) 
	Quit:tStream.Size=0
	Set pNode=tNode
}

ClassMethod GetCurrentCodeDatabase(pNamespace As %String = {$namespace}, pClassName As %Dictionary.CacheClassname = {$classname($this)}) As %String
{
	New $namespace
	Set tCodeDatabase = ""
	If (pNamespace '= "") && (pClassName '= "") {
		Set tFullDatabase = ##class(%SYS.Namespace).GetRoutineDest(pNamespace,pClassName _ ".0","OBJ")
		If (tFullDatabase '= "") {
			Set $namespace = "%SYS"
			
			Set tDatabaseServer = $piece(tFullDatabase,"^",1)
			Set tDatabaseDirectory = $piece(tFullDatabase,"^",2)
			Set tStatus = ##class(Config.Databases).DatabasesByDirectory(tDatabaseServer,tDatabaseDirectory,.tDatabaseNames)
			$$$ThrowOnError(tStatus)
			
			Set tCodeDatabase = $listget(tDatabaseNames,1)
		}
	}
	
	If (tCodeDatabase = "") {
		$$$ThrowStatus($$$ERROR($$$GeneralError,$$$FormatText("Unable to resolve code database for class '%1' in namespace '%2'"),pClassName,pNamespace))
	}
	Else {
		Quit tCodeDatabase
	}
}

ClassMethod SaveCerts() As %Status
{
	New $namespace
	/*
	Check dates and info about certificate (on osx using) 
	echo ^d|openssl s_client -connect localhost:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | openssl x509 -noout -subject -dates -fingerprint
	openssl x509 -text -in cert.pem
	
	testing certificates 
		http://gazelle.ihe.net/content/pre-connectathon-tests/atna/11109
		http://gazelle.ihe.net/tls-na
		or http://gazelle.ihe.net/tls
		
	removing passkey from http://askubuntu.com/questions/500371/how-to-make-apache-2-stop-asking-for-a-password-for-an-ssl-certificate
		umask 077
		mv your.key old-with-pass.key
		openssl rsa -in old-with-pass.key -out your.key
	but they suggest using 
		If you only have one SSL site on your server, the simplest form of this would be:

		# either of these will work
		SSLPassPhraseDialog |/path/to/passphrase-script
		SSLPassPhraseDialog exec:/path/to/passphrase-script
		You would then create a very simple script called  /path/to/passphrase-script that contains something like the following:

			#!/bin/sh
			echo "put the passphrase here"	
	*/
	Set tSC= ..SaveCert("xdata://"_$classname()_":certISC","isc_IHE_cert.pem")
	Set tSC= ..SaveCert("xdata://"_$classname()_":ISCkey","isc_IHE_cert_key.pem")
	Set tSC= ..SaveCert("xdata://"_$classname()_":certCA","isc_IHE_CA.cer")
	Set tWhere=$Namespace
	Set $namespace="%SYS"
	If '##class(Security.SSLConfigs).%ExistsId("Server") {
		Set tServer=##class(Security.SSLConfigs).%New()
		Set tServer.Name="Server"
		Set tServer.Enabled = 1
		Set tServer.Protocols = 4
		Set tServer.VerifyPeer = 3
		Set tServer.CAFile = $zu(12)_"isc_IHE_CA.cer"
		Set tServer.CertificateFile = $zu(12)_"isc_IHE_cert.pem"
		Set tServer.PrivateKeyFile = $zu(12)_"isc_IHE_cert_key.pem"
		Set tServer.Type = 1  /// server
		Set tSC = tServer.%Save()
	}
	If '##class(Security.SSLConfigs).%ExistsId("Client") {
		Set tConfig=##class(Security.SSLConfigs).%New()
		Set tConfig.Name="Client"
		Set tConfig.Enabled = 1
		Set tConfig.Protocols = 4
		Set tConfig.CAFile = $zu(12)_"isc_IHE_CA.cer"
		Set tConfig.CertificateFile = $zu(12)_"isc_IHE_cert.pem"
		Set tConfig.PrivateKeyFile = $zu(12)_"isc_IHE_cert_key.pem"
		Set tConfig.VerifyPeer = 1
		Set tConfig.Type = 0  /// client
		Set tSC = tConfig.%Save()
	}
	Set $namespace=tWhere

	If '##class(%SYS.X509Credentials).%ExistsId("X509") {
		Set tContainer = ##class(%SYS.X509Credentials).%New()
		Set tContainer.Alias = "X509"
		Set tSC = tContainer.LoadCertificate($zu(12)_"isc_IHE_cert.pem")
		Do tContainer.LoadPrivateKey($zu(12)_"isc_IHE_cert_key.pem")
		Set tContainer.PrivateKeyType = "RSA"
		Set tSC = tContainer.Save()
	}
	Quit tSC
}

ClassMethod SAMLSetup() As %Status
{
	/*
	&sql(SELECT * from HS_Registry.AuthDomain WHERE ID='SAML')
	IF SQLCODE {
		Set obj=##class(HS.Registry.AuthDomain).%New()
		Set obj.CallbackClass="HS.IHE.XUA.SAMLAuth"
		Set obj.DomainCode="SAML"
		Set obj.Description="SAML"
		Set tSC=obj.%Save()
	}
	&sql(select * from hs_registry_person.userloginid where userclinician->userid='sfarrell' and DOMAINCode='SAML')
	If SQLCODE {
		&sql(select ID INTO :ID from hs_registry_person.userclinician where userid='sfarrell')
		If 'ID {
			Set clin=##class(HS.Registry.Person.User).%New()
			Set clin.Active=1
			Set clin.Description="Sam Farrell"
			Set clin.Name="Sam Farrell"
			Set clin.Type="C"
			Set clin.UserID="SFarrell"
		} Else {
			Set clin=##class(HS.Registry.Person.User).%OpenId(ID)
		}
		Set LID=##class(HS.Registry.Person.UserLoginID).%New()
		Set LID.UserClinician=clin
		Set LID.DomainCode="SAML"
		Set LID.LoginID="SFarrell"
		Set tSC=LID.%Save()	
	}
	*/
	&sql(SELECT ID INTO :ID from HS_IHE_XUA.Config where name='BASE')
	IF SQLCODE {
		Set xua=##class(HS.IHE.XUA.Config).%New()
	} Else {
		Set xua=##class(HS.IHE.XUA.Config).%OpenId(ID)
	}
	Set xua.Name="BASE"
	Set xua.Issuer="ISC"
	Set xua.IssuerX509="X509"
	Set xua.CheckSignerIdentity=0
	Set xua.OrganizationOID=##class(HS.Data.OIDMap).ObjectForOID(##class(HS.Data.OIDMap).GetOIDForCode("ISC-HealthShare"))
	Set xua.SAMLCreatorClass="HS.HC.IHE.XUA.Creator"
	Set xua.SAMLProcessorClass="HS.HC.IHE.XUA.Processor"
	Set tSC = xua.%Save()
	
	Quit tSC
}

ClassMethod SaveCert(xdata, filename, location = {$zu(12)}) As %Status
{
	Set tSC = ##class(Ens.Util.URLStream).GetURLStream(xdata, .tStream) break:$$$ISERR(tSC)	
	Set tFile=##class(%FileCharacterStream).%New()
	Set tFile.Filename=location_filename
	Set tReader = ##class(%XML.Reader).%New()
	Do tReader.Correlate("XMLMessage","HS.Message.XMLMessage")
	Set tSC = tReader.OpenStream(.tStream) $$$ThrowOnError(tSC)
	If tReader.Next(.tObject,.tSC) {
		$$$ThrowOnError(tSC)
		Do tFile.CopyFrom(tObject.ContentStream)
	}
	Set tSC=tFile.%Save()
	Quit tSC
}

/// openssl x509 -text -in isc_IHE_cert.pem
/// Not After : Dec  5 18:43:07 2027 GMT
XData certISC
{
<XMLMessage>
<ContentStream><![CDATA[-----BEGIN CERTIFICATE-----
MIIDmTCCAwKgAwIBAgICBlIwDQYJKoZIhvcNAQENBQAwOjELMAkGA1UEBhMCRlIx
EzARBgNVBAoMCklIRSBFdXJvcGUxFjAUBgNVBAMMDUlIRSBFdXJvcGUgQ0EwHhcN
MTcxMjA1MTg0MzA3WhcNMjcxMjA1MTg0MzA3WjCBgjELMAkGA1UEBhMCVVMxFTAT
BgNVBAoMDEludGVyU3lzdGVtczETMBEGA1UEAwwKaW50ZXJzeXMxMDEOMAwGA1UE
KgwFQ3JhaWcxDDAKBgNVBAQMA0xlZTEpMCcGCSqGSIb3DQEJARYaY3JhaWcubGVl
QGludGVyc3lzdGVtcy5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAITh
2xW9O7JpPgDe1hIPLXKF1RZzsha3MODZFaULlu0/lYT7FortrDeNVJMe2aOWerkY
6NsEYWT3zqLGtV1OMRLZYTOanoXXBo4S5d2pyL9j1WzVtg64fh01zafc3xbM55Ix
MRMKFoPElrcocna4Y1t5N9HIfXPBSssZ3XdzrSALAgMBAAGjggFjMIIBXzA+BgNV
HR8ENzA1MDOgMaAvhi1odHRwczovL2dhemVsbGUuaWhlLm5ldC9wa2kvY3JsLzY0
My9jYWNybC5jcmwwPAYJYIZIAYb4QgEEBC8WLWh0dHBzOi8vZ2F6ZWxsZS5paGUu
bmV0L3BraS9jcmwvNjQzL2NhY3JsLmNybDA8BglghkgBhvhCAQMELxYtaHR0cHM6
Ly9nYXplbGxlLmloZS5uZXQvcGtpL2NybC82NDMvY2FjcmwuY3JsMAkGA1UdEwQC
MAAwDgYDVR0PAQH/BAQDAgTwMBEGCWCGSAGG+EIBAQQEAwIF4DAdBgNVHQ4EFgQU
MRMngDiS2vfWMzNxyLx5FKC+SPcwHwYDVR0jBBgwFoAU7DMOE8giXqLha69De3pd
0ndzHX4wMwYDVR0lBCwwKgYIKwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3FAIC
BggrBgEFBQcDATANBgkqhkiG9w0BAQ0FAAOBgQCX/4SkVG3QNVt8REw6B222tGJC
7/ArFd1aZ3Uw4WzVkAo5D5Q45DcB2+pQ+XcoR0O1wgdw5HANyPl8sEOfuWrANxbU
/3+yYFOP3BkssQlP5t95cWE1Q0tX3SqrgHeRAulthb5T+uXd1/3DHp/RDVV7PIuB
sjdpbvea108bhl6Gyg==
-----END CERTIFICATE-----
]]></ContentStream>
</XMLMessage>
}

/// openssl x509 -text -in isc_IHE_CA.cer
/// Not After : Sep 28 11:19:29 2022 GMT
XData certCA
{
<XMLMessage>
<ContentStream><![CDATA[-----BEGIN CERTIFICATE-----
MIIDHTCCAoagAwIBAgIBATANBgkqhkiG9w0BAQ0FADA6MQswCQYDVQQGEwJGUjET
MBEGA1UECgwKSUhFIEV1cm9wZTEWMBQGA1UEAwwNSUhFIEV1cm9wZSBDQTAeFw0x
MjA5MjgxMTE5MjlaFw0yMjA5MjgxMTE5MjlaMDoxCzAJBgNVBAYTAkZSMRMwEQYD
VQQKDApJSEUgRXVyb3BlMRYwFAYDVQQDDA1JSEUgRXVyb3BlIENBMIGfMA0GCSqG
SIb3DQEBAQUAA4GNADCBiQKBgQCuLWUWgF2L5igJIQ1pWFw/Yk5ZcMG4JPw13GLx
n+7nufHHq/xgzxJxFLoY/kL8WUgg+QiCBv6yecXy3qJeb6DjuQJ+k2KHSKQxyN4f
pfZdeNVc6w5qNOmMFKixS0ntax/4RXNBgP7IbKq2+fr1QscFZo0X6qWdO9OvL9Rg
SmGMNQIDAQABo4IBMTCCAS0wPQYDVR0fBDYwNDAyoDCgLoYsaHR0cDovL2dhemVs
bGUuaWhlLm5ldC9wa2kvY3JsLzY0My9jYWNybC5jcmwwOwYJYIZIAYb4QgEEBC4W
LGh0dHA6Ly9nYXplbGxlLmloZS5uZXQvcGtpL2NybC82NDMvY2FjcmwuY3JsMDsG
CWCGSAGG+EIBAwQuFixodHRwOi8vZ2F6ZWxsZS5paGUubmV0L3BraS9jcmwvNjQz
L2NhY3JsLmNybDAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNV
HQ4EFgQU7DMOE8giXqLha69De3pd0ndzHX4wHwYDVR0jBBgwFoAU7DMOE8giXqLh
a69De3pd0ndzHX4wEQYJYIZIAYb4QgEBBAQDAgAHMA0GCSqGSIb3DQEBDQUAA4GB
AFfPfr/Cjk/ZBsDI9SdHGYqlHAJaJaJX/fpXIu3akEZxCPzMJkTeDDHvUOGaaP7b
AHGnTBsS8rR9CD6gyUVJmrC/fk6/QoYFVaPNOGG2M1KnA14bwhriYLXV1INsUwj/
jUTdSSvrPgV8XddgM8VgBLAX59VH94jufDPOPqwV1++P
-----END CERTIFICATE-----
]]></ContentStream>
</XMLMessage>
}

XData ISCkey
{
<XMLMessage>
<ContentStream><![CDATA[-----BEGIN RSA PRIVATE KEY-----
MIICWwIBAAKBgQCE4dsVvTuyaT4A3tYSDy1yhdUWc7IWtzDg2RWlC5btP5WE+xaK
7aw3jVSTHtmjlnq5GOjbBGFk986ixrVdTjES2WEzmp6F1waOEuXdqci/Y9Vs1bYO
uH4dNc2n3N8WzOeSMTETChaDxJa3KHJ2uGNbeTfRyH1zwUrLGd13c60gCwIDAQAB
AoGAXvKzBLmOKlEgyKZw9754jtgqBjztB2YmOsNiv+ekFCnWwIpY9TQWVitaPzVP
9Z/UWOX/nF9o6ChZMd4iQWVZkkLFQo3dLhG/mFKbYJI7E2oFv5uMGYkATz6gmbyS
EGRXejHFXEdLRf/xrG4SqP0ymQy3YVhFrAzUG+PX2wFTBcECQQC4j7kyGSLoTf9p
8IsvOCuqys8Kfhwch4GKhx+k1t5qvIQ8+1jMAUWZXVxU4sH/ExiVc3/9vb/ody67
5rciiDBTAkEAuFE4LVmFZrKN54tFPYNnaetb8cWp2dDR8wtx3Tft6YyRkO9Y85Vr
8Piw9oKc0uDsO8e9y9j6tIEUcL/OG9e6aQJAF9dpIxGgMsYwomzSbg0hhvSf/kkA
NKdEkrKV4eNn4/3qTz5g4Cmh5gfrb4PDb8H1wQiklhC3A76xqNBLBAj3xQJAF2kZ
fYkVTIn5RCOIU9vQ0r82GmtEu4muYPRfLf3glf1or8P2xFmCMEUmFOlaCd7Pongo
Py/8B9ktQ3TZNOgdoQJAU3J+Racnyy+yGcW8N5gOWlMM8PZW5eWkgKNZr00P9hDc
A5f10x0po5aBvGmM+Ng8spye3jc3b2ugYWiJBil7rQ==
-----END RSA PRIVATE KEY-----
]]></ContentStream>
</XMLMessage>
}

XData Items
{
}

XData AdditionalItems
{
}

XData OIDEntries
{
}

XData AdditionalOIDEntries
{
}

XData RegistryEntries
{
}

XData AdditionalRegistryEntries
{
}

}
