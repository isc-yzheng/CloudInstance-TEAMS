Include (%soap, Ensemble, HS.HC, %occInclude)

/// IHE class for creating SAML tokens.
/// This class is subject to change and should not be presumed to be final.
/// Creating HS.IHE.XUA.Config entries to control properties of the Creator class
/// to control specific settings for their environment. 
Class HS.HC.IHE.XUA.Creator Extends %RegisteredObject [ LegacyInstanceContext ]
{

Parameter HSDEPLOY = 0;

/// Parameter to define additional settings stored in the configuration
Parameter UISETTINGS;

Parameter SubjectNameFormat = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified";

Parameter IssuerFormat = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified";

Parameter AudienceRestriction = "http://ihe.connectathon.XUA/X-ServiceProvider-IHE-Connectathon";

/// Optionally use $$$KeyInfoRSAKey or $$$SOAPWSReferenceIssuerSerial
Parameter SignAssertionCreateOption As COSEXPRESSION = "$$$KeyInfoX509Certificate";

/// Property retrieved from the HS.IHE.XUA.Config which is a
/// string to use for the SAML Issuer's name.
/// Either Issuer should be set to a string containing the
/// distinguished name of the RHIO's certificate, OR IssuerX509 should
/// contain the alias of an X.509 certificate which references the RHIO's certificate.
/// If both are set to "", an error will be reported when creating new tokens.
/// IssuerX509 takes precedence over Issuer.
Property Issuer As %String;

/// Property retrieved from the HS.IHE.XUA.Config which is an
/// Alias for an X.509 certificate object which will be used for the SAML Issuer,
/// and for signing the created token if the SignCreatedAssertion parameter is true.
/// Either Issuer should be set to a string containing the
/// distinguished name of the RHIO's certificate, OR IssuerX509 should
/// contain the alias of an X509 certificate which references the RHIO's certificate.
/// If both are set to "", an error will be reported when creating new tokens.
Property IssuerX509 As %String;

/// Property retrieved from the HS.IHE.XUA.Config which 
/// controls whether created Assertions will be signed. This requires the
/// IssuerX509 parameter to refer to a valid set of X.509 credentials.
Property SignCreatedAssertion As %Boolean [ InitialExpression = 0 ];

/// Property retrieved from the HS.IHE.XUA.Config which 
/// controls whether created Assertions will be signed with the WSSecuritySignature
/// or the Signature.  Signing still requires SignCreatedAssertion to be set to true,
///  and the IssuerX509 parameter to refer to a valid set of X.509 credentials.
Property UseWSSSignature As %Boolean [ InitialExpression = 1 ];

Property CurrentSAMLData As HS.IHE.XUA.SAMLData;

/// Classmethod for creating SAML Assertions from XMLMessage objects.
/// OUSTANDING ITEMS:
/// 		- User login time [DUMMY VALUE = (now - 5 minutes) ]
/// 		- User login IP (i.e. from system) [ DUMMY VALUE = "10.0.1.123" ]
/// 		- User login DSN Name (i.e. from DNS name) [ DUMMY VALUE = "test.intersystems.com" ]
/// 		- User organization - should this be primary Facility? Defaults to UserRHIO if not found
/// 		- Purpose for use - where should this come from? BTG = Emergency, but otherwise...?
/// 		- Role and Category mapping - more specificity needed, will need user/implementation input to map HS roles
Method CreateSAML(pRequest As %Persistent, Output pAssertion As %SAML.Assertion) As %Status
{
	#Dim tX509Cert As %SYS.X509Credentials
	try {
		#; Build the (signed / unsigned) Assertion (Issuer / Signature)
		Set tSC = ..NewAssertion(.pAssertion) Quit:$$$ISERR(tSC)

		#; extract user information from pRequest either SAML: USER: or pRequest.User

		Set tSC = ..UserInformationToData(pRequest) Quit:$$$ISERR(tSC)
		
		#; Subject.NameID
		Set tSC = ..AddSubject(pAssertion,pRequest.SAMLData) Quit:$$$ISERR(tSC)

		#; empty method - optional subject confirmation (extend and override)
		Set tSC = ..AddSubjectConfirmation(pAssertion) Quit:$$$ISERR(tSC)

		#; Add Conditions  (valid from / to times) Audience restriction
		Set tSC = ..AddConditions(pAssertion) Quit:$$$ISERR(tSC)
		
		Set tSC = ..AddAuthorizationStatement(pAssertion,pRequest.SAMLData) Quit:$$$ISERR(tSC)

		#; add user assertion from tData
		Set tSC = ..AddAttributes(pAssertion,pRequest.SAMLData) Quit:$$$ISERR(tSC)
		
		#; Empty method in default IHE specification, but can be overridden in extended class
		Set tSC = ..AuthzConsent(pAssertion,pRequest) Quit:$$$ISERR(tSC)

		#; any additions required (override in user class)
		Set tSC = ..Additions(pAssertion,pRequest) Quit:$$$ISERR(tSC)

		#; Sign the assertion - This adds a <Signature> element after Issuer (in addition to the <Signature> element after Statement, just before IssueInstant)
		If ((..SignCreatedAssertion) && ('..UseWSSSignature)) {
			Set tSC = ..SignAssertion(pAssertion) Quit:$$$ISERR(tSC)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) $$$LOGWARNING("Error creating SAML Assertion: "_tSC)
	Quit tSC
}

/// Build the Assertion signed or not signed
Method NewAssertion(pAssertion) As %Status
{
	try {
		Set pAssertion = "",tSC=$$$OK
		Set (tIssuerCert,tIssuerName) = ""
		If ..IssuerX509 '= "" {
			#dim tIssuerCert As %SYS.X509Credentials
			Set tIssuerCert = ##class(%SYS.X509Credentials).GetByAlias(..IssuerX509)
			If '$IsObject(tIssuerCert) {
				Set tSC=$$$ERROR($$$EnsErrGeneral, "Unable to open %SYS.X509Credentials object with alias '"_..IssuerX509_"'.") Quit
			} 
			Set tIssuerName = tIssuerCert.SubjectDN
		}
		Set:tIssuerName="" tIssuerName = ..Issuer
		If tIssuerName="" {
			Set tSC=$$$ERROR($$$EnsErrGeneral, "No SAML Issuer or SAML Issuer Certificate parameters defined") Quit
		}
		
		If $IsObject(tIssuerCert) && ..SignCreatedAssertion && ..UseWSSSignature{
			Set pAssertion = ##class(%SAML.Assertion).CreateX509(tIssuerCert, ..#SignAssertionCreateOption)
		} Else {
			Set pAssertion = ##class(%SAML.Assertion).Create()
		}
		
		Set pAssertion.IssueInstant = $zdatetime($ztimestamp,3,,3)
		Set pAssertion.Issuer = ##class(%SAML.NameID).%New()
		Set pAssertion.Issuer.Format = ..#IssuerFormat
		Set pAssertion.Issuer.NameID = tIssuerName

	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method AddSubject(pAssertion, pData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		Set tSC=$$$OK
		Set pAssertion.Subject = ##class(%SAML.Subject).%New()
		Set pAssertion.Subject.NameID = ##class(%SAML.NameID).%New()
		Set pAssertion.Subject.NameID.Format = ..#SubjectNameFormat
		Set pAssertion.Subject.NameID.NameID = $G(pData.Working("UserFullName"),pData.UserName)
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Conditions
Method AddConditions(pAssertion) As %Status
{
	try {
		Set tSC=$$$OK
		Set tCondition = ##class(%SAML.Conditions).%New()
		Set pAssertion.Conditions = tCondition
		Set tNow=$ztimestamp
		Set tCondition.NotBefore=$zdatetime(tNow-1_",0",3,,3)
		Set tCondition.NotOnOrAfter=$zdatetime(tNow+10_",0",3,,3)
		Set tAudienceRestriction = ..AudienceRestriction()
		Do pAssertion.Conditions.Condition.Insert(tAudienceRestriction)
	} catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Audience restriction
Method AudienceRestriction(pAssertion) As %SAML.AudienceRestriction
{
	try {
		Set tSC=$$$OK
		Set tAudienceRestriction=##class(%SAML.AudienceRestriction).%New()
		Do tAudienceRestriction.Audience.Insert(..#AudienceRestriction)
	} catch ex {
		Set tSC=ex.AsStatus()
		Set tAudienceRestriction=""
	}
	Quit tAudienceRestriction
}

/// Additional modifiers - override as required
Method Additions(pAssertion, pRequest As %Persistent) As %Status
{
	Quit $$$OK
}

/// Method to add AuthorizationConsent to the assertion
Method AuthzConsent(pAssertion, pRequest) As %Status
{
	Quit $$$OK
	/* sample code if a policy was stored
	#dim authz As %SAML.AuthzDecisionStatement = ##class(%SAML.AuthzDecisionStatement).%New()
	do pAssertion.Statement.Insert(authz)
	#dim action As %SAML.Action = ##class(%SAML.Action).%New()
	do authz.Action.Insert(action)
	set action.Action="Execute"
	Set action.Namespace="urn:oasis:names:tc:SAML:1.0:action:rwedc"
	
	#dim evidenceList As %SAML.Evidence = ##class(%SAML.Evidence).%New()
	set authz.Evidence=evidenceList
	#dim evidence As %SAML.Assertion = ##class(%SAML.Assertion).Create()
	do evidenceList.Evidence.Insert(evidence)
	set authz.Decision="Permit"
	set authz.Resource=""
	set evidence.IssueInstant=pAssertion.IssueInstant
	Set evidence.Issuer=pAssertion.Issuer
	
	set attrs=##class(%SAML.AttributeStatement).%New()
	do evidence.Statement.Insert(attrs)
	set attr=##class(%SAML.Attribute).%New()
	do attrs.Attribute.Insert(attr)
	set attr.Name="AccessConsentPolicy"
	set attr.NameFormat="urn:ihe:iti:xua:acp"
	set avalue=##class(%SAML.AttributeValue).%New()
	do attr.AttributeValue.Insert(avalue)
	Do avalue.SetString("urn:oid:1.2.3.4")

	set attr=##class(%SAML.Attribute).%New()
	do attrs.Attribute.Insert(attr)
	set attr.Name="InstanceAccessConsentPolicy"
	set attr.NameFormat="urn:ihe:iti:bppc:2007"
	set avalue=##class(%SAML.AttributeValue).%New()
	do attr.AttributeValue.Insert(avalue)
	Do avalue.SetString("urn:oid:1.2.3.4.123456789")
	
	*/
	Quit $$$OK
}

Method AddAuthorizationStatement(pAssertion, pData)
{
	try {
		Set tSC = $$$OK
		// Put data into AuthnStatement
		Set tAuthnStatement = ##class(%SAML.AuthnStatement).%New()

		Set tAuthnStatement.AuthnInstant = $S($g(pData.Working("UserLoginTime"))]"":pData.Working("UserLoginTime"),pData.SAMLInfo.GetAt("UserLoginTime")="":$system.SQL.DATEADD("mi", -5, $zdatetime($ztimestamp, 3,,3)),1:pData.SAMLInfo.GetAt("UserLoginTime"))
		Set tAuthnStatement.SubjectLocality = ##class(%SAML.SubjectLocality).%New()
		Set tAuthnStatement.SubjectLocality.DNSName = $S($g(pData.Working("UserDNSName"))]"":pData.Working("UserDNSName"),pData.SAMLInfo.GetAt("UserDNSName")="":..GetNodeName(),1:pData.SAMLInfo.GetAt("UserDNSName"))
		Set tAuthnStatement.SubjectLocality.Address = $S($g(pData.Working("UserIPAddress"))]"":pData.Working("UserIPAddress"),pData.SAMLInfo.GetAt("UserIPAddress")="":##class(%SYSTEM.INetInfo).HostNameToAddr(tAuthnStatement.SubjectLocality.DNSName),1:pData.SAMLInfo.GetAt("UserIPAddress"))
		Set tAuthnStatement.AuthnContext = ##class(%SAML.AuthnContext).%New()
		Set tAuthnStatement.AuthnContext.AuthnContextClassRef = $s($g(pData.Working("UserAuthorizationMode"))]"":pData.Working("UserAuthorizationMode"),pData.SAMLInfo.GetAt("UserAuthorizationMode")="":"urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport",1:pData.SAMLInfo.GetAt("UserAuthorizationMode"))
		Do pAssertion.Statement.Insert(tAuthnStatement)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Not required for IHE specification but used in NY SHINNY implementation
Method AddSubjectConfirmation(pAssertion, ByRef pData) As %Status
{
	Set tSC = $$$OK
	Set tSubjectConfirmation = ##class(%SAML.SubjectConfirmation).%New()
	Set tSubjectConfirmation.Method = "urn:oasis:names:tc:SAML:2.0:cm:bearer"
	Set tSC = pAssertion.Subject.SubjectConfirmation.Insert(tSubjectConfirmation) 
	Quit tSC
}

Method UserInformationToData(pRequest) As %Status
{
	Set tSC=$$$OK
	try {
		Set ..CurrentSAMLData = pRequest.SAMLData
		
		If pRequest.%Extends("HS.Types.RequestInfo") {
			Set tSC=..RequestUserInformationToData(pRequest,..CurrentSAMLData)
		}
		If pRequest.%Extends("HS.Message.XMLMessage") {
			If pRequest.AdditionalInfo.IsDefined("SAML:UserName") {Set tSC=..AdditionalUserInformationToData(pRequest,..CurrentSAMLData)}
			Else {
				If ..CurrentSAMLData.HSRoles="" Set ..CurrentSAMLData.HSRoles=pRequest.AdditionalInfo.GetAt("USER:Roles")
				If ..CurrentSAMLData.UserName="" Set ..CurrentSAMLData.UserName=pRequest.AdditionalInfo.GetAt("USER:UserID")
				Set tSC=..CommonInternalUserInformation(..CurrentSAMLData)
			}
		}
	} catch ex {
		Set tSC=ex.AsStatus() 
	}
	Quit tSC
}

Method AdditionalUserInformationToData(pRequest, pData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		Set tSC = $$$OK
		#; this data must exist in the inbound transaction ... defaulting it for now
	// !!!!!! TODO: Authorization Context:
	//		(1) User IP
	//		(2) User DNS Name
	//		(3) Logon time
	//		(4) Logon method (most probably "PasswordProtectedTransport" - i.e. password over SSL)

		If pData.UserName="" {
			For tKey = "SAML:UserName", "USER:UserID" {
				If pRequest.AdditionalInfo.IsDefined(tKey) { 
					Set pData.UserName = pRequest.AdditionalInfo.GetAt(tKey)
					Quit
				}
			}
		}
		
		If pData.Organization="" {
			For tKey = "SAML:UserOrganization", "USER:UserOrganization" {
				If pRequest.AdditionalInfo.IsDefined(tKey) { 
					Set pData.Organization = pRequest.AdditionalInfo.GetAt(tKey)
					Quit
				}
			}
		}
		If pData.RHIO="" {
			For tKey = "SAML:UserRHIO", "USER:UserRHIO" {
				If pRequest.AdditionalInfo.IsDefined(tKey) { 
					Set pData.RHIO = pRequest.AdditionalInfo.GetAt(tKey)
					Quit
				}
			}
			Set:pData.RHIO="" pData.RHIO=$$$HomeCommunity
		}
	
		Set tSC = ..MapRoles(pData)
		Set tSC = ..MapPurposeOfUse(pData)

	}Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Convert HS.Types.RequestInfo into pData
Method RequestUserInformationToData(pRequest, pData As HS.IHE.XUA.SAMLData) As %Status
{
	Set pData.UserName = pRequest.RequestingUser
	Set pData.HSRoles = pRequest.RequestingUserRoles
	Set pData.BreakTheGlass = pRequest.BreakTheGlass
	Set tSC=..CommonInternalUserInformation(pData)
	Quit tSC
}

/// Called when there is no SAML in the request, therefore building information from the request
Method CommonInternalUserInformation(pData As HS.IHE.XUA.SAMLData) As %Status
{
	Set tSC = $$$OK
	try {
		Set tSC = ..MapRoles(pData)
		Set:pData.RHIO="" pData.RHIO=$$$HomeCommunity
		
		#; convert BreakTheGlass into PurposeOfUse
		Set tSC = ..MapPurposeOfUse(pData) Quit:$$$ISERR(tSC)

		#; execute query to user registry to get common user information
		Set tSC = ..FetchUser(pData) Quit:$$$ISERR(tSC)

		Set pData.RHIO=$$$HomeCommunity
		//Set pData.Working("HomeCommunityOID")="urn:oid:" _ $$$HomeCommunityOID

		#; define UserOrganization by lookup
		Set:pData.Organization="" tSC = ..FetchUserOrganization(pData) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// called by CommonInternalUserInformation 
Method MapPurposeOfUse(pData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		Set tSC=$$$OK
		Set pData.Working("PurposeOfUse") = ##class(HS.IHE.XUA.PurposeOfUse).%New()
		If pData.BreakTheGlass=1 {
			Set pData.Working("PurposeOfUse").code = "99-102"
			Set pData.Working("PurposeOfUse").codeSystem = "1.3.6.1.4.1.21367.3000.4.1"
			Set pData.Working("PurposeOfUse").codeSystemName = "connectathon PurposeOfUse codes"
			Set pData.Working("PurposeOfUse").displayName = "Emergency"
		} ElseIf pData.BreakTheGlass=-1  {
			Set pData.Working("PurposeOfUse").code = "99-104"
			Set pData.Working("PurposeOfUse").codeSystem = "1.3.6.1.4.1.21367.3000.4.1"
			Set pData.Working("PurposeOfUse").codeSystemName = "connectathon PurposeOfUse codes"
			Set pData.Working("PurposeOfUse").displayName = "Research"
		} Else {
			#;pData.BreakTheGlass=0
			Set pData.Working("PurposeOfUse").code = "99-101"
			Set pData.Working("PurposeOfUse").codeSystem = "1.3.6.1.4.1.21367.3000.4.1"
			Set pData.Working("PurposeOfUse").codeSystemName = "connectathon PurposeOfUse codes"
			Set pData.Working("PurposeOfUse").displayName = "TREATMENT"
		}
		; overwrite if we have an actual PurposeOfUse value
		Set tPurposeOfUse = pData.PurposeOfUse
		If $IsObject(tPurposeOfUse){
			Set:(tPurposeOfUse.code'="") pData.Working("PurposeOfUse").code = tPurposeOfUse.code
			Set:(tPurposeOfUse.codeSystem'="") pData.Working("PurposeOfUse").codeSystem = tPurposeOfUse.codeSystem
			Set:(tPurposeOfUse.codeSystemName'="") pData.Working("PurposeOfUse").codeSystemName = tPurposeOfUse.codeSystemName
			Set:(tPurposeOfUse.displayName'="") pData.Working("PurposeOfUse").displayName = PurposeOfUse.displayName
		}
	}Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Override this method to provide customized organization lookup.<br>
/// called by CommonInternalUserInformation<br>
/// Update<br>
/// 	pData.OrganizationOID<br>
/// 	pData.Organization<br>
Method FetchUserOrganization(pData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		Set tSC = $$$OK
		Set pData.OrganizationOID = ##class(HS.Data.OIDMap).GetOIDForCode(pData.RHIO,"undefined")
		Set pData.Organization = pData.RHIO
	}Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Override this method to provide customized individual lookup.<br>
/// called by CommonInternalUserInformation<br>
/// Update<br>
/// 	pData.Working("EmailAddress")<br>
/// 	pData.Working("UserFullName")<br>
/// 	pData.Working("NPI")<br>
Method FetchUser(pData As HS.IHE.XUA.SAMLData) As %Status
{
	try {
		Set tSC = $$$OK
		#; todo:
		#; if user logs into multiple systems, how do we know what the time was / what machine it was 
		#; how do we know the authorization mode?
		Set pData.Working("UserLoginTime")=$system.SQL.DATEADD("mi", -5, $zdatetime($ztimestamp, 3,,3))
		#; select this node name or one defined in the config
		Set pData.Working("UserDNSName")=..GetNodeName()
		Set pData.Working("UserIPAddress")=##class(%SYSTEM.INetInfo).HostNameToAddr(pData.Working("UserDNSName"))
		Set pData.Working("UserAuthorizationMode")="urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
		Set pData.Working("UserFullName") = pData.UserName
		Set pData.Working("UserToken") = ""
		Set pData.Working("EmailAddress")=""
		Set pData.Working("NPI")=""
	}Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method AddAttributes(pAssertion, pData As HS.IHE.XUA.SAMLData) As %Status
{
	// Put data into AttributeStatement
	#; The various specifications use different attribute names / formats
	Set tAttribStatement = ##class(%SAML.AttributeStatement).%New()
	#define AddAttribute(%key,%value,%nf) Set tAttribute = ##class(%SAML.Attribute).%New(),tAttribute.Name=%key,tAttribValue = ##class(%SAML.AttributeValue).%New() Set tAttribute.NameFormat = %nf Do tAttribute.AttributeValue.Insert(tAttribValue),tAttribStatement.Attribute.Insert(tAttribute)
	#define AddStringAttribute(%key,%value,%nf) $$$AddAttribute(%key,%value,%nf) Do tAttribValue.SetString(%value)
	#define AddElementAttribute(%key,%value,%nf) $$$AddAttribute(%key,%value,%nf) Do tAttribValue.SetElement(%value)
	#; qualified string comes from testing with some partners where they lose the s namespace through processing
	#define AddQualifiedString(%key,%value,%nf) $$$AddAttribute(%key,%value,%nf) Set tAttribute.AttributeValueOverride=tAttribute.AttributeValueOverride_"<saml:AttributeValue xmlns:s=""http://www.w3.org/2001/XMLSchema"" xsi:type=""s:string"">"_%value_"</saml:AttributeValue>"

	$$$AddStringAttribute("urn:oasis:names:tc:xspa:1.0:subject:subject-id",pData.UserName,"")
	$$$AddStringAttribute("urn:oasis:names:tc:xspa:1.0:subject:organization",pData.Organization,"")
	$$$AddStringAttribute("urn:oasis:names:tc:xspa:1.0:subject:organization-id",pData.OrganizationOID,"")
	$$$AddElementAttribute("urn:oasis:names:tc:xacml:2.0:subject:role",pData.Working("UserRole"),"")
	$$$AddElementAttribute("urn:oasis:names:tc:xspa:1.0:subject:purposeofuse",pData.Working("PurposeOfUse"),"")
	$$$AddStringAttribute("urn:ihe:iti:xca:2010:homeCommunityId",##class(HS.Data.OIDMap).GetOIDForCode(pData.RHIO),"")
	Do pAssertion.Statement.Insert(tAttribStatement)
	Quit $$$OK
}

/// Map internal HealthShare roles into an Role object which uses SNOMED CT as the code system.
/// Implementations should override this method and use their own mapping based on their roles and user data.
ClassMethod MapRoles(pData) As %Status
{
	Set tRoles=pData.HSRoles
	Set tRole = ##class(HS.IHE.XUA.Role).%New()
	Set tRole.codeSystem = "2.16.840.1.113883.6.96"
	Set tRole.codeSystemName = "SNOMED CT"
	If tRoles [ "%HS_Nurse" {
		Set tRole.displayName = "Nursing occupation"
		Set tRole.code = 265937000
	}
	ElseIf tRoles [ "%HS_Clinician" {
		Set tRole.displayName = "Medical practitioner"
		Set tRole.code = 158965000
	}
	ElseIf tRoles [ "%HS_Clerical" {
		Set tRole.displayName = "Administrative healthcare staff"
		Set tRole.code = 224608005
	} ElseIf tRoles [ "%HS_SocialWorker" {
		Set tRole.displayName = "Social Worker"
		Set tRole.code = 106328005
	}
	Else { // Generic healthcare professional
		Set tRole.displayName = "Healthcare professional"
		Set tRole.code = 223366009
	}
	Set pData.Working("UserRole")=tRole
	Quit $$$OK
}

ClassMethod ForwardSAML(pRequest As HS.Message.XMLMessage, Output pAssertion As %SAML.Assertion) As %Status
{
	If pRequest.SAMLData.Token]"" {
		Set tTokenString = pRequest.SAMLData.Token
		Set tReader = ##class(%XML.Reader).%New()
		Do tReader.OpenString(tTokenString)
		Do tReader.Correlate("Assertion", "%SAML.Assertion")
		Do tReader.Next(.pAssertion, .tSC)
		If $$$ISERR(tSC) Quit tSC
		// Ensure that attribute values are correctly exported
		For i=1:1:pAssertion.Statement.Count() {
			Set tStatement = pAssertion.Statement.GetAt(i)
			If ('$IsObject(tStatement))||('tStatement.%IsA("%SAML.AttributeStatement")) Continue
			For j=1:1:tStatement.Attribute.Count() {
				Set tAttribute = tStatement.Attribute.GetAt(j)
				If '$IsObject(tAttribute) Continue
				Set tAttributeValue = tAttribute.AttributeValue.GetAt(1)
				If ('$IsObject(tAttributeValue))||('tAttributeValue.%IsA("%SAML.AttributeStringValue")) Continue
				Set tNewValue = ##class(%SAML.AttributeValue).%New()
				Do tNewValue.SetString(tAttributeValue.GetString())
				Do tAttribute.AttributeValue.SetAt(tNewValue, 1)
			}
		}
	} Else {
		Set pAssertion = ""
	}

	Quit $$$OK
}

Method SignAssertion(pAssertion) As %Status
{
	try {
    	set xml = ##class(%Stream.GlobalCharacter).%New()
    	set writer = ##class(%XML.Writer).%New()
   		set tSC = writer.OutputToStream(.xml)

    	//Create the Signature and Reference
      	if $system.Status.IsOK( tSC ) {
	     	if ..IssuerX509 '= "" {
         		#dim tIssuerCert As %SYS.X509Credentials
         		set tIssuerCert = ##class(%SYS.X509Credentials).GetByAlias(..IssuerX509)
	     	}
			quit:'$d(tIssuerCert) ; don't try to sign if we have no certificate			
         	set tSignature=##class(%XML.Security.Signature).CreateX509(tIssuerCert,$$$SOAPWSIncludeNone,..#SignAssertionCreateOption,tSC)
      	}

      	if $system.Status.IsOK( tSC ) {
         	set tRef = ##class(%XML.Security.Reference).Create(pAssertion.SAMLID, $$$SOAPWSEnvelopedSignature_","_$$$SOAPWSexcc14n)
         	do tSignature.AddReference(tRef)
        	set pAssertion.Signature = tSignature
         	set pAssertion.X509Credentials = tIssuerCert
      	}

	  	//output XML to sign
      	if $system.Status.IsOK( tSC ) {
	      	do writer.AddNamespace("http://www.w3.org/2001/XMLSchema-instance","xsi")
         	do writer.RootElement("Envelope")
			do writer.Element("Header")
			set tSC = writer.Object(pAssertion)
			do writer.EndElement()
			do writer.EndRootElement()
      	}

      	//Perform signature
      	if $system.Status.IsOK( tSC ){
         	set tSC = tSignature.SignStream(xml)
      	}

	} Catch ex {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

/// This attempts to get the domain name from %SYS.System to return something like MyHost.Mydomain.Com
/// If no domain can be found, it defaults to MyHost
ClassMethod GetNodeName() As %String
{
	Set tNode=##class(%SYS.System).GetNodeName()
	If $E(tNode,*-5,*)=".LOCAL" {
		/// On a Mac the node name ends in .LOCAL strip it if this is the case as $zu(54,0) in the $$$HSNetworkHostName will return it
		Set tNode=$E(tNode,1,*-6)
	}
	If tNode["." {
		Quit $$$HSNetworkHostName_"."_$P(tNode,".",2,999)
	} Else {
		Quit $$$HSNetworkHostName
	}
}

}
