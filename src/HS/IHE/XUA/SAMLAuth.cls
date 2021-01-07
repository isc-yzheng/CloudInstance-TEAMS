/// Authentication / authorization from SAML tokens
Class HS.IHE.XUA.SAMLAuth Extends HS.Registry.Person.User.HSAuth
{

/// Same as base class without password checking
/// Token will be set to the SAML Assertion for use by authorization method
ClassMethod OnAuthenticate(pServ, pDomain, pLoginID, pPassword, Output pUserName, Output pToken, Output pFullName, Output pChangePW, Output pChallengeQ) As %String [ Internal ]
{
	Quit 0
}

ClassMethod SAMLAuthenticate(pServ, pDomain, pLoginID, pPassword, Output pUserName, Output pToken, Output pFullName, Output pChangePW, Output pChallengeQ) As %String [ Internal ]
{
	Set tReturn="", pUserName="",pToken="", pChangePW=0, pChallengeQ="", pFullName=""
	DO {
		// use default domain if not sent
		IF pDomain="" {
			Set pDomain = ##class(HS.Registry.Person.User.HSAuth).ExtractDomainFromLoginID(.pLoginID)
		}
		
		//Does the user exist?
		&SQL(Select ID, UserClinician->UserID, UserClinician->Name, UserClinician->ID
		 INTO :tLoginID, :tUser, :tFullName, :tRegistryID
		 from HS_Registry_Person.UserLoginID
		 WHERE DomainCode=:pDomain AND LoginID=:pLoginID And UserClinician->Active = 1 And IsNull(ExpirationDate,CURRENT_DATE)>=CURRENT_DATE)
		If SQLCODE'=0 || (tUser="") d $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeLogin,$$$NameLoginFail,"User "_pLoginID_"@"_pDomain_" does not exist","User "_pLoginID_"@"_pDomain_" does not exist")
		Quit:SQLCODE'=0
		Quit:tUser=""

		Set pUserName=tUser,pFullName=tFullName,pToken=tLoginID _ "," _ tRegistryID
		Do $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeLogin,$$$NameLogin,"User "_pLoginID_"@"_pDomain_" login","User "_pLoginID_"@"_pDomain_" login")
	} While 0
	
	Quit tReturn
}

/// Merges the roles from the user registry and SAML token
/// If the SAML role is already specified in the user registry, it is not duplicated.
ClassMethod OnAuthorize(pServ, pDomain, pLoginID, pPassword, pUserName, pToken, Output pRoles) As %String [ Internal ]
{
	Quit ""
}

/// Merges the roles from the user registry and SAML token
/// If the SAML role is already specified in the user registry, it is not duplicated.
ClassMethod SAMLAuthorize(pServ, pDomain, pLoginID, pPassword, pUserName, pToken, Output pRoles) As %String [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tID=$P(pToken, ",", 1)
		Set tSAML=pPassword
	
		#; Build up an array of roles 
		Set tUserLogin=##Class(HS.Registry.Person.UserLoginID).%OpenId(tID)
		If '$IsObject(tUserLogin) $$$ThrowStatus($$$ERROR($$$GeneralError, $$$Text("User Login ID Not Found")))
		For i=1:1:tUserLogin.Roles.Count() {
			Set tRole = tUserLogin.Roles.GetAt(i) 
			If tRole ] "" Set tRoles(tRole) = 1
		}
		If $e($zstrip(tSAML,"<>W"))'="<" Set tSAML = $system.Encryption.Base64Decode(tSAML)
		Set tSC = ..ExtractRoles(tSAML,.tRoles)

		#; Join the roles array into a string for return
		Set (pRoles, i) = "" For { Set i=$o(tRoles(i)) Quit:i=""  Set pRoles = pRoles _ $S(pRoles'="":",",1:"") _ i }
		
	} Catch ex { Set tSC = ex.AsStatus() }
	
	If $$$ISERR(tSC) Quit $SYSTEM.Status.GetErrorText(tSC)
	Quit ""
}

/// Extract the Roles from the SAML message
ClassMethod ExtractRoles(pSAML, ByRef pRoles) As %Status [ Internal ]
{
	try {
		Set tSC=$$$OK
		#; Add SAML role
		Set tSC=##class(%XML.XPATH.Document).CreateFromString(pSAML, .tDocument, , , , , "saml2 urn:oasis:names:tc:SAML:2.0:assertion,hl7 urn:hl7-org:v3") 
		Quit:$$$ISERR(tSC)
		Set tSC = tDocument.EvaluateExpression("/saml2:Assertion/saml2:AttributeStatement/saml2:Attribute[@Name = 'urn:oasis:names:tc:xacml:2.0:subject:role']/saml2:AttributeValue/hl7:Role", "@code", .tRoleCode) 
		Quit:$$$ISERR(tSC)
		If tRoleCode.Count() {
			Set tRole = ..MapRoleCodeToHSRole(tRoleCode.GetAt(1).Value)
			If tRole ] "" Set pRoles(tRole) = 1
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Map Role to HS Role - assumes codeSystem="2.16.840.1.113883.6.96" (SNOMED CT)
ClassMethod MapRoleCodeToHSRole(pRoleCode As %String = "") As %String [ Internal ]
{
	#;TODO - this should be in a lookup table somewhere
	Quit $Case(pRoleCode
		,309418004:""	//Audiologist
		,26042002:""	//Dental Hygienist
		,106289002:""	//Dentist
		,159033005:""	//Dietitian
		,224609002:""	//Complementary Healthcare worker
		,106292003:"%HS_Nurse"	//Professional nurse
		,405278004:"%HS_Nurse"	//Certified registered nurse anesthetist
		,224571005:"%HS_Nurse"	//Nurse practitioner
		,224570006:"%HS_Nurse"	//Clinical nurse specialist
		,28229004:""	//Optometrist
		,46255001:""	//Pharmacist
		,3842006:""	//Chiropractor
		,76231001:""	//Osteopath
		,112247003:"%HS_Clinician"	//Medical doctor
		,61207006:""	//Medical pathologist
		,159034004:""	//Podiatrist
		,80584001:""	//Psychiatrist
		,22515006:""	//Medical Assistant
		,59944000:""	//Psychologist
		,106328005:""	//Social worker
		,159026005:""	//Speech therapist
		,307988006:""	//Medical Technician
		,309428008:""	//Orthotist
		,36682004:""	//Physiotherapist
		,80546007:""	//Occupational therapist
		,106290006:""	//Veterinarian
		,397897005:""	//Paramedic/EMT
		,106311007:""	//Minister of religion AND/OR related member of religious order
		,106330007:""	//Philologist, translator AND/OR interpreter
		,159483005:"%HS_Clerical"	//clerical occupation
		,224608005:"%HS_Clerical"	//Administrative healthcare staff
		,224546007:"%HS_Nurse"	//Infection control nurse
		,307785004:"%HS_Clerical"	//insurance specialist (health insurance/payor)
		,116154003:""	//Patient
		,429577009:""	//Patient advocate
		,309398001:""	//Profession allied to medicine (non-licensed care giver)
		,265950004:"%HS_Administrator"	//IT Professional
		,271554005:""	//law occupation
		,307969004:""	//Public health officer
		,265937000:"%HS_Nurse" //Nursing occupation       
		,158965000:"%HS_Clinician" //Medical practitioner
	,:"")
}

}
