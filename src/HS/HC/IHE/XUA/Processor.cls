Include (%soap, HS.HC)

/// SOAPServer.Base calls (in OnPreWebMethod - ValidateSAML, ProcessSAML) then ProcessRequest
/// 
Class HS.HC.IHE.XUA.Processor Extends %RegisteredObject
{

Parameter HSDEPLOY = 0;

Parameter UISETTINGS;

/// Domain used for localization.
Parameter DOMAIN = "HS";

/// Boolean whether the SAML user should be validated against the user registry
Parameter ValidateUser As %Boolean = 0;

/// Optional: A prefix to append to the security domain name. Use this to use "internal"
/// HealthShare security domains which allow assigning roles/groups to a user
Property DomainPrefix As %String [ InitialExpression = "%HS " ];

Property DefaultSecurityDomain As %String [ InitialExpression = "SAML" ];

Property RequireSignature As %Boolean [ InitialExpression = 0 ];

/// If this property is true and RequireSignature is true, inspect the KeyInfo on the signature
/// as part of the signature validation.  The assertion will only pass validation if it is
/// possible to identify the signer from the KeyInfo and the signer's credentials are trusted.<br>
/// If this setting is false, a signature which includes a reference to an X.509 certificate
/// will still have the certificate checked against Caché's list of trusted certificates, but
/// signatures which are signed with only an RSA public key, or with symmetric encryption,
/// will pass validation without attempting to identify the signer.<br>
/// It is strongly recommended to set CheckSignerIdentity to true if RequireSignature is set to true.
Property CheckSignerIdentity As %Boolean [ InitialExpression = 1 ];

/// Validate incoming SAML Assertion based on XUA specifications.
Method ValidateSAML(pAssertion As %SAML.Assertion = "", Output pReason As %String, pImportHandler As %SOAP.WebBase, Output pSAMLData As HS.IHE.XUA.SAMLData) As %Boolean
{
	Try {
		Set pReason = ""
		If '$IsObject(pAssertion) {
			Set pReason = "NO ASSERTION"
			Quit
		}
		Set tSC = ..CreateSAMLData(pAssertion,pImportHandler,.pSAMLData)
		If $$$ISERR(tSC) Set pReason=$system.Status.GetErrorText(tSC) Quit

		If (pAssertion.Version '= "2.0")&&(pAssertion.Version '= "20") {
			Set pReason = "Invalid SAML Version: '"_pAssertion.Version_"' encountered"
			Quit
		}
		
		Set tSC = ..validateStatements(pAssertion,.pReason) If pReason]"" || $$$ISERR(tSC) Quit

		Set tSC = ..validateSubject(pAssertion,.pReason) If pReason]"" || $$$ISERR(tSC) Quit
				
		Set:..RequireSignature tSC = ..ValidateSignature(pAssertion,.pReason) If pReason]"" || $$$ISERR(tSC) Quit
		
	}
	Catch ex {
		Set pReason = $system.Status.GetErrorText(ex.AsStatus())
	}
	If pReason '= "" Quit 0
	
	Quit 1
}

Method CreateSAMLData(pAssertion As %SAML.Assertion = "", pImportHandler As %SOAP.WebBase, Output pSAMLData As HS.IHE.XUA.SAMLData) As %Status
{
	Try {
		Set tSC=$$$OK
		Set pSAMLData=##class(HS.IHE.XUA.SAMLData).%New()
		Set tSC = ##class(HS.IHE.XUA.SecurityElement).AssertionXML(pAssertion,pImportHandler,.tAssertionXML)
		If $$$ISERR(tSC) {
			Set pReason=$system.Status.GetErrorText(tSC)
		} Else {
			Set pSAMLData.Token=tAssertionXML
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method GetExpectedAttributes(ByRef pExpected)
{
	#; Format of tExpected: tExpected(<Name>) = $listbuild(<iselement>,<elementName>,<NameFormat>,<required 1/0>,<PropertyName>)
	#; Property name prefaced with a - indicates store it in .Working array
	#; Property name prefaced with a + indicates store it in .SAMLInfo array
	Set pExpected("urn:oasis:names:tc:xspa:1.0:subject:subject-id") = $lb(0,"",,1,"UserName")
	Set pExpected("urn:oasis:names:tc:xspa:1.0:subject:organization") =	$lb(0,"",,1,"Organization")
	Set pExpected("urn:oasis:names:tc:xspa:1.0:subject:organization-id") =	$lb(0,"",,1,"OrganizationOID")
	Set pExpected("urn:ihe:iti:xca:2010:homeCommunityId") =	$lb(0,"",,1,"-RHIOID")
	Set pExpected("urn:oasis:names:tc:xacml:2.0:subject:role") = $lb(1, "hl7:Role",,1,"-Roles")
	Set pExpected("urn:oasis:names:tc:xspa:1.0:subject:purposeofuse") = $lb(1, "hl7:PurposeOfUse",,1,"-PurposeOfUse")
	Set pExpected("urn:oasis:names:tc:xspa:2.0:subject:npi")=$lb(1,"",,0,"NPI")
}

/// Called during the OnPreWeb method of SOAPServer.Base
/// Extract the Attribute fields insert them into pSAMLData to be returned and assigned to ..SAMLData which 
/// will be copied to the pRequest
Method ProcessSAML(pAssertion As %SAML.Assertion = "", Output pSAMLData As HS.IHE.XUA.SAMLData = "") As %Status
{
	try {
		Set tSC=$$$OK
		// Create simple result for now
		Set:'$IsObject(pSAMLData) pSAMLData = ##class(HS.IHE.XUA.SAMLData).%New()
	
		// Skip processing if valid assertion not present
		Quit:'$IsObject(pAssertion)
	
		#; Using the assersion
		Set tSC=..BuildSAMLData(pAssertion,pSAMLData) Quit:$$$ISERR(tSC)
		#; Extended validation on parsed values
		Set tSC=..ExtendedValidation(pAssertion,pSAMLData) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Override this method to provide customized user authentication<br>
/// Authenticate user and determine roles.  Return an error status if user is not authenticated<br>
/// Update<br>
/// 	pRequest.AdditionalInfo.SetAt(username,"USER:UserID")<br>
/// 	pRequest.AdditionalInfo.SetAt(username,"USER:Roles")<br>
Method ProcessRequest(pRequest As HS.Message.XMLMessage) As %Status
{
	Set tSC = $$$OK
	Do pRequest.AdditionalInfo.SetAt(pRequest.SAMLData.UserName,"USER:UserID")
	Do pRequest.AdditionalInfo.SetAt(pRequest.SAMLData.HSRoles,"USER:Roles")
	Quit tSC
}

/// Build the HS.IHE.XUA.SAMLData which will be stored in the ..SAMLData in the web server request
Method BuildSAMLData(ByRef pAssertion As %SAML.Assertion, ByRef pSAMLData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		Set tSC=$$$OK
		Do ..GetExpectedAttributes(.tExpected)

		// We simply want the values from saml2:Assertion/saml2:AttributeStatement/saml2:Attribute
		For i=1:1:pAssertion.Statement.Count() {
			Set tStatement = pAssertion.Statement.GetAt(i)
			If '$IsObject(tStatement) Continue
		
			If tStatement.%IsA("%SAML.AuthnStatement") {
				Set pSAMLData.Working("DNSName")=tStatement.SubjectLocality.DNSName
			}
			
			If 'tStatement.%IsA("%SAML.AttributeStatement") Continue

			#dim tStatement As %SAML.AttributeStatement
			For j=1:1:tStatement.Attribute.Count() {
				Set tAttribute = tStatement.Attribute.GetAt(j)
				If '$IsObject(tAttribute) Continue
				#; Format of tExpected: tExpected(<Name>) = $listbuild(<iselement>,<elementName>,NameFormat,<required 1/0>,<PropertyName>)
				#; Note that <isstring>=0 implies a coded element
				Set tData = $g(tExpected(tAttribute.Name))
			
				If tData]"" {
					Set tPropNode = $li(tData,5)
					Set tAttributeValue = tAttribute.AttributeValue.GetAt(1)
					If '$IsObject(tAttributeValue) Continue
					If '$li(tData) {
						If $e(tPropNode)="-" {
							Set pSAMLData.Working($e(tPropNode,2,*))=tAttributeValue.GetString()
						} ElseIf $e(tPropNode)="+" {
							Do pSAMLData.SAMLInfo.SetAt(tAttributeValue.GetString(),$e(tPropNode,2,*))
						} Else {
							Set $Property(pSAMLData,tPropNode)=tAttributeValue.GetString()
						}
						
					}
					Else {
						Set tCodedElement = tAttributeValue.GetElement()
						If '$IsObject(tCodedElement) Continue
						Set tPropNode=$e(tPropNode,2,*)
						If tCodedElement.%Extends("HS.IHE.XUA.CodedElement") {
							For tProperty = "code","codeSystem","codeSystemName","displayName" {
								Set pSAMLData.Working(tPropNode_"."_tProperty)=$property(tCodedElement, tProperty)
							}
						}
					}
				} 
				// Replace all %SAML.AttributeStringValue instances with %SAML.AttributeValue instances for export
				Set tAttributeValue = tAttribute.AttributeValue.GetAt(1)
				If $IsObject(tAttributeValue) && (tAttributeValue.%IsA("%SAML.AttributeStringValue")) {
					Set tReplacementValue = ##class(%SAML.AttributeValue).%New()
					Do tReplacementValue.SetString(tAttributeValue.GetString())
					Do tAttribute.AttributeValue.SetAt(tReplacementValue, 1)
				}
			}
		}
		Set:..RequireSignature tSC = ..ProcessSignature(pAssertion,pSAMLData) Quit:$$$ISERR(tSC)

		/// Extract values required for XUA ATNA logging
		S pSAMLData.Issuer = pAssertion.Issuer.NameID
		S tNameId = pAssertion.Subject.NameID
		if $IsObject(tNameId) && tNameId.%IsA("%SAML.NameID") {
			#dim tNameId As %SAML.NameID
			S pSAMLData.SubjectSPProvidedID = tNameId.SPProvidedID
			S pSAMLData.Subject = tNameId.NameID
		} else {
			/// Not really sure what to do here.
			S pSAMLData.Subject = tNameId
		}

		Set pSAMLData.RHIO=##class(HS.Data.OIDMap).GetCodeForOID($g(pSAMLData.Working("RHIOID")),$g(pSAMLData.Working("RHIOID")))
		Set tSC = ..MapRoles(pSAMLData) Quit:$$$ISERR(tSC)
		Set tSC = ..MapPurposeOfUse(pSAMLData) Quit:$$$ISERR(tSC)
	}
	Catch ex {
		Set tSC =ex.AsStatus()
	}
	Quit tSC
}

/// Called by BuildSAMLData
Method ProcessSignature(pAssertion, pSAMLData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		Set tSC=$$$OK
		//Do pSAMLData.SAMLInfo.SetAt(pAssertion.WSSecuritySignature.Id,"SignatureID")
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Called by ValidateSAML
Method validateStatements(pAssertion, Output pReason As %String, Output pData) As %Status
{
	try {
		Set tSC = $$$OK
		Set tAryNeed("AttributeStatement")="validateAttributes"
		Set tAryNeed("AuthnStatement")="validateAuthnStatement"
		
		For tIdx=1:1:pAssertion.Statement.Count() {
			Set tStatement = pAssertion.Statement.GetAt(tIdx)
			If '$IsObject(tStatement) Continue
			Set tClass = tStatement.%ClassName() 
			Set tMethod = $g(tAryNeed(tClass)) Continue:tMethod=""
			Kill tAryNeed(tClass)  // only process the first entry
			Set tSC = $method($this,tMethod,tStatement,.pReason,.pData)
		}
		Set tNode=$O(tAryNeed(""))
		Set:tNode]"" pReason=$p(tNode,".",2)_" is needed"
	} Catch ex {
		Set tSC = ex.AsStatus()
		Set pReason = $system.Status.GetErrorText(tSC)
	}
	Quit tSC
}

/// called by validateStatements
Method validateAttributes(pStatement, Output pReason, Output pData) As %Status
{
	try {
		Set tSC = $$$OK
		Do ..GetExpectedAttributes(.tExpected)
							
		For j=1:1:pStatement.Attribute.Count() {
			Set tAttribute = pStatement.Attribute.GetAt(j)
			Set tName = tAttribute.Name
			If $data(tExpected(tName)) {
				If tAttribute.NameFormat ] "" {
					If tAttribute.NameFormat '= $Lg(tExpected(tName),3) {
						Set pReason = "Invalid value for saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']@NameFormat attribute; '"_tAttribute.NameFormat_"' encountered, '"_$lg(tExpected(tName),3)_"' required"
						Quit 
					}
				}
				If $listget(tExpected(tName)) { // Coded Element
					Set tAttributeValue = tAttribute.AttributeValue.GetAt(1)
					If '$IsObject(tAttributeValue) {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue/"_$listget(tExpected(tName),2)_" element required"
						Quit
					}
					Set tCodedElement = tAttributeValue.GetElement()
					If '$IsObject(tCodedElement) {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue/"_$listget(tExpected(tName),2)_" element is missing"
						Quit
					}
					If tCodedElement.code = "" {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue/"_$listget(tExpected(tName),2)_"@code attribute required"
						Quit
					}
					If tCodedElement.codeSystem = "" {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue/"_$listget(tExpected(tName),2)_"@codeSystem attribute required"
						Quit
					}
					If tCodedElement.codeSystemName = "" {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue/"_$listget(tExpected(tName),2)_"@codeSystemName attribute required"
						Quit
					}
					If tCodedElement.displayName = "" {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue/"_$listget(tExpected(tName),2)_"@displayName attribute required"
						Quit
					}
				} Else { // String value
					Set tAttributeValue = tAttribute.AttributeValue.GetAt(1)
					If '$IsObject(tAttributeValue) {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue element required"
						Quit
					}
					If "" = tAttributeValue.GetString() {
						Set pReason = "saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tName_"']/saml2:AttributeValue element is empty"
						Quit
					}
				}
				#; Clear found elements
				Kill tExpected(tName)
			}
		}
		If pReason '= "" Quit
		// Check we got all the required attributes
		Set tExpected=""
		For {
			Set tExpected=$o(tExpected(tExpected)) Quit:tExpected="" 
			If '$lg(tExpected(tExpected),4) continue  // not required
			Set pReason = pReason_";saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name='"_tExpected_"'] element required"
		
		}
		Set pReason=$e(pReason,2,*)
		If pReason '= "" Quit
	} Catch ex {
		Set tSC = ex.AsStatus()
		Set pReason = $system.Status.GetErrorText(tSC)
	}
	Quit tSC
}

/// Called by validateStatements
Method validateAuthnStatement(pStatement, Output pReason, Output pData) As %Status
{
	try {
		Set tSC=$$$OK
		If pStatement.AuthnInstant = "" {
			Set pReason = "saml2:Assertion/saml2:AuthnStatement/@AuthnInstant element required"
			Quit
		}
		If (pStatement.AuthnContext.AuthnContextClassRef = "") {
			Set pReason = "saml2:Assertion/saml2:AuthnStatement/saml2:AuthnContext/saml2:AuthnContextClassRef element is required"
			Quit
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
		Set pReason = $system.Status.GetErrorText(tSC)
	}
	Quit tSC
}

/// Called by ValidateSAML
Method validateSubject(pAssertion, Output pReason) As %Status
{
	try {
		Set tSC=$$$OK
		If '$IsObject(pAssertion.Subject) {
			Set pReason = "saml2:Assertion/saml2:Subject element required"
			Quit
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
		Set pReason = $system.Status.GetErrorText(tSC)
	}
	Quit tSC
}

/// Called by ValidateSAML
Method ValidateSignature(pAssertion, Output pReason) As %Status
{
	try {
		Set tSC=$$$OK
		Set pReason=""
		If '$IsObject(pAssertion.WSSecuritySignature) {
			Set pReason = "saml2:Assertion/saml2:Signature element required"
			Quit
		}
		If ..CheckSignerIdentity{
			Set pReason = ..CheckSignerId(pAssertion.WSSecuritySignature,pAssertion)
			Quit:(pReason'="")
		}
		//Check that the signature is signing the entire assertion
		Set tRefCount = pAssertion.WSSecuritySignature.SignedInfo.Reference.Count()
		If (tRefCount=0){
			Set pReason="saml2:Assertion/Signature/SignedInfo/Reference element required"
			Quit
		}
		Set tWSSSigRef = pAssertion.WSSecuritySignature.SignedInfo.Reference.GetAt(1).URI
		If $e(tWSSSigRef)="#" { Set tWSSSigRef = $e(tWSSSigRef,2,*) } // URI "#ID-123" needs to match assertion ID "ID-123"
		If (tWSSSigRef'=pAssertion.SAMLID){
			Set pReason="Signature must sign the root element of the assertion"
			Quit
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
		Set pReason = $system.Status.GetErrorText(tSC)
	}
	Quit tSC
}

Method CheckSignerId(pSignature As %XML.Security.Signature, pAssertion As %SAML.Assertion) As %String
{
	Set tReason=""
	Try{
		Set tError = pSignature.KeyInfo.ValidateTokenRef()
		If (tError'=""){
			Set tReason=tError
			Quit
		}
		If (pSignature.KeyInfo.KeyType=$$$SOAPWSX509v3){ //RSA key or X.509 certificate
			If ($zobjclass(pSignature.KeyInfo.X509Credentials)="%XML.Security.RSAKeyValue"){
				Set tCreds = ##class(%SYS.X509Credentials).GetByRSAKeyValue(pSignature.KeyInfo.X509Credentials)
				If (tCreds'=""){
					Set tSC = ..ValidateX509(tCreds)	//In Cache 2016.4 and up, can call tCreds.Validate() instead
					If ($$$ISERR(tSC)){
						Set tReason = "Invalid certificate"
						Quit
					}
				}
				Else{
					Set tSigCreds = pSignature.KeyInfo.X509Credentials
					#dim sigCreds As %XML.Security.RSAKeyValue
					Set tCreds = ##class(HS.Registry.RSAKey).GetByRSAKeyValue(tSigCreds.Modulus,tSigCreds.Exponent)
					If (tCreds=""){
						Set tReason = "RSA key not recognized"
						Quit
					}
				}
			}
			Else{
				//X.509 certificate validation happens when Cache validates the WSSecuritySignature
			}
		}
		Else{ //Other key types are not currently supported
			Set tSC = ..ValidateOtherKeyInfo(pAssertion,.tReason)
			Set:$$$ISERR(tSC) tReason=$System.Status.GetErrorText(tSC)
			Quit
		}
	}
	Catch ex{
		Set tSC = ex.AsStatus()
		Set tReason = $System.Status.GetErrorText(tSC)
	}
	Quit tReason
}

Method ValidateOtherKeyInfo(pAssertion As %SAML.Assertion, Output pReason) As %Status
{
	Set tSC = $$$OK
	//Other KeyInfo types are not currently supported; to add support, extend HS.IHE.XUA.Processor and overwrite this method
	Set pReason = "Unsupported KeyInfo type, cannot identify signer"
	Quit tSC
}

/// Copied from %SYS.X509Credentials::Validate in Cache 2016.4 for use in earlier versions
ClassMethod ValidateX509(pCreds As %SYS.X509Credentials) As %Status
{
	s $ZT="Error"
	// Certificate must be present.
	If (pCreds.Certificate="") Quit $$$ERROR($$$GeneralError,"The X.509 certificate is missing")
	// CAFile must exist and be readable if specified.
	 If (pCreds.CAFile'="") {
		 If '##class(%File).Exists(pCreds.CAFile) q $$$ERROR($$$FileDoesNotExist,pCreds.CAFile)
		 Set cafile=pCreds.CAFile
	 } Else {
		 // default CA File
		 Set cafile=##class(%File).NormalizeFilename("iris.cer",$zu(12))
		 If '##class(%File).Exists(cafile) Set cafile="" 
	 }

	Set notAfter="",notBefore="",expired=0,tooSoon=0	//notBefore isn't in the Cache method but we should check it
	Try {
		Set notAfter=$System.Encryption.X509GetField(pCreds.Certificate,"ValidityNotAfter")
		Set notBefore=$System.Encryption.X509GetField(pCreds.Certificate,"ValidityNotBefore")
		If ($zdt($zts,3)]notAfter) Set expired=1
		If (notBefore]$zdt($zts,3)) Set tooSoon=1
	}
	Catch {
	}
	If ((notAfter="")||(notBefore="")) q $$$ERROR($$$GeneralError,"Certificate in X.509 Credentials is not valid")
	If expired q $$$ERROR($$$CertificateExpired,$$$Text("in X.509 Credentials"))
	If tooSoon q $$$ERROR($$$GeneralError,"Certificate in X.509 Credentials is not yet valid")

	if cafile'="" {
		s rc = $SYSTEM.Encryption.X509VerifyCertChain(pCreds.Certificate,cafile)	//X509VerifyCertChain was also introduced in 2014.2.0, so only run this method if ValidityNotAfter is defined
		if rc'="OK" q $$$ERROR($$$CertVerifyFailed,$$$Text("in X.509 Credentials"),cafile,rc)
	}
	Quit $$$OK	//%SYS.X509Credentials::Validate goes on to check the private key but skip that here
Error Set $zt=""
 Quit $$$ERROR($$$ObjectScriptError,$ze)
}

/// Optionally validate values parsed from assertion and return status
Method ExtendedValidation(pAssertion, pSAMLData) As %Status
{
	#; for instance if pSAMLData.SAMLInfo.GetAt("DNSName") is not a domain name supported, reject the transaction
	Quit $$$OK
}

/// Called by HS.IHE.XUA.Config:GetProcessor once the processor class is determined
ClassMethod GetProcessor(pXUAConfig As HS.IHE.XUA.Config) As Processor
{
	try {
		Set tProcessor = ..%New()
		Set:pXUAConfig.DomainPrefix]"" tProcessor.DomainPrefix=pXUAConfig.DomainPrefix
		Set:pXUAConfig.DefaultSecurityDomain]"" tProcessor.DefaultSecurityDomain=pXUAConfig.DefaultSecurityDomain
		Set:pXUAConfig.RequireSignature]"" tProcessor.RequireSignature=pXUAConfig.RequireSignature
		Set:pXUAConfig.CheckSignerIdentity]"" tProcessor.CheckSignerIdentity=pXUAConfig.CheckSignerIdentity
	} catch ex {
		$$$LOGERROR(ex.AsStatus())
	}
	Quit $g(tProcessor)
}

Method GetDomain(pSAMLData As HS.IHE.XUA.SAMLData) As %String
{
	#define stripOID(%oid)	$S($zcvt($E(%oid,1,8),"l")="urn:oid:":$E(%oid,9,*),1:%oid)
	
	#; Look for domains in descending order, else use default domain
	Set tDomainCode = ""
	For tDomainSuffix = ##class(HS.Data.OIDMap).GetCodeForOID($$$stripOID(pSAMLData.OrganizationOID),""), pSAMLData.Organization, ##class(HS.Data.OIDMap).GetCodeForOID($$$stripOID(pSAMLData.RHIO),"") {
		If (tDomainSuffix = "") {
			Continue
		}
		Set tTestDomain = ..DomainPrefix _ tDomainSuffix
		If (tTestDomain ] "") {
			If '$get(tCheckedDomains(tTestDomain)) {
				If ##class(HS.Registry.AuthDomain).DomainIndexExists(tTestDomain) {
					Set tDomainCode = tTestDomain
					Quit
				}
				Else {
					Set tCheckedDomains(tTestDomain) = 1
				}
			}
		}
	}

	If (tDomainCode ] "") {
		Quit tDomainCode
	}
	Else {
		Quit ..DefaultSecurityDomain
	}
}

Method MapRoles(pSAMLData As HS.IHE.XUA.SAMLData) As %Status
{
	#define AddRole(%role) if (","_pSAMLData.HSRoles_",")'[(","_%role_",") Set pSAMLData.HSRoles=$S(pSAMLData.HSRoles="":%role,1:pSAMLData.HSRoles_","_%role)
	If $g(pSAMLData.Working("Roles.codeSystem"))="2.16.840.1.113883.6.96" {
		Set tCode = $g(pSAMLData.Working("Roles.code"))
		If tCode=265937000 $$$AddRole("%HS_Nurse")
		If tCode=112247003 || (tCode=158965000) || (tCode=223366009) $$$AddRole("%HS_Clinician")
		If tCode=224608005 $$$AddRole("%HS_Clerical")
		If tCode=106328005 $$$AddRole("%HS_SocialWorker")
		If tCode=106328005 $$$AddRole("%HS_Clerical")
	}
	Quit $$$OK
}

Method MapPurposeOfUse(pSAMLData As HS.IHE.XUA.SAMLData) As %Status
{
	If $g(pSAMLData.Working("PurposeOfUse.codeSystem"))="1.3.6.1.4.1.21367.3000.4.1" {
		Set tCode = $g(pSAMLData.Working("PurposeOfUse.code"))
		If tCode="99-102" {Set pSAMLData.BreakTheGlass=1}
		Else {Set pSAMLData.BreakTheGlass=0}
	}
	Set tPurposeOfUse = ##class(HS.IHE.XUA.PurposeOfUse).%New()
	Set tPurposeOfUse.code=$g(pSAMLData.Working("PurposeOfUse.code"))
	Set tPurposeOfUse.codeSystem = $g(pSAMLData.Working("PurposeOfUse.codeSystem"))
	Set tPurposeOfUse.codeSystemName = $g(pSAMLData.Working("PurposeOfUse.codeSystemName"))
	Set tPurposeOfUse.displayName = $g(pSAMLData.Working("PurposeOfUse.displayName"))
	Set pSAMLData.PurposeOfUse = tPurposeOfUse
	Quit $$$OK
}

/// Utility method to return an assertion from a token within a XMLMessage
ClassMethod GetAssertionFromMessage(pMessageId) As %SAML.Assertion
{
	try {
		Set tAssertion=""
		Set tMessage=##class(HS.Message.XMLMessage).%OpenId(pMessageId)
		If '$isObject(tMessage) || ('tMessage.%IsA("HS.Message.XMLMessage")) Write NoObjectForId
		Set tAssertion = ..GetAssertion(tMessage.SAMLData.Token)
	} catch ex {
		
	}
	Quit tAssertion
}

/// Utility method to return an assertion object from a stream or string token
ClassMethod GetAssertion(pStreamOrString) As %SAML.Assertion
{
	Set tAssertion=""
	try {
		If '$IsObject(pStreamOrString) {
			Set tStream = ##class(%Stream.GlobalCharacter).%New()
			Do tStream.Write(pStreamOrString)
			Do tStream.Rewind()
		} Else {
			Set tStream = pStreamOrString
		}
		Set tReader = ##class(%XML.Reader).%New()
		Do tReader.Correlate("Assertion","%SAML.Assertion")
		Set tSC = tReader.OpenStream(.tStream) $$$ThrowOnError(tSC)
		While tReader.Next(.tObject, .tSC) { $$$ThrowOnError(tSC)
			If '$IsObject($G(tObject)) Continue
			Set tAssertion=tObject
		}
	}Catch ex {
	}
	Quit tAssertion
}

}
