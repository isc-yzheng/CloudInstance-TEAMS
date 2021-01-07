Include (HS.HC.Errors, HS.HC.Invoke)

/// Include (HS.Common, %ZHSLIB)
Class HS.Registry.Person.User Extends (%Persistent, HS.Push.Registry.Recipient, HS.Registry.Person.Base) [ Inheritance = right, SqlTableName = UserClinician ]
{

Parameter DSTIME = "AUTO";

Parameter DSINTERVAL = 5;

Relationship LoginIDs As HS.Registry.Person.UserLoginID [ Cardinality = children, Inverse = UserClinician ];

Relationship Facilities As HS.Registry.Person.UserFacility [ Cardinality = children, Inverse = UserClinician ];

Relationship Idents As HS.Registry.Person.UserIdentifier [ Cardinality = children, Inverse = UserClinician ];

Relationship Folders As HS.Push.MessageCenter.Folder [ Cardinality = many, Inverse = OwnerUser ];

Relationship Emails As HS.Registry.Person.UserEmail [ Cardinality = children, Inverse = UserClinician ];

/// The set of users who are allowed to be a proxy for this user
/// Proxies act on behalf of this user, and implicitly get their consent groups
/// This is an array of UserID strings
Property Proxies As array Of %String;

/// Will end up as $username.  It's not an IDKEY - that's an internalID
Property UserID As %String(MAXLEN = 128, SELECTIVITY = 1) [ Required ];

Property Description As %String(MAXLEN = "");

Property MessageRepository As %String(MAXLEN = 256);

/// Set to True to prevent recipient from being selected
Property Active As %Boolean [ InitialExpression = 1 ];

/// If this is a Cache User, then the UserID is their Cache User ID, and their
/// authentication cannot be delegated
Property CacheUser As %Boolean [ InitialExpression = 0 ];

/// Used to check for inactivity
Property LastLoginDate As %Date;

Property Specialty As %String(MAXLEN = 256);

Property SubSpecialty As %String(MAXLEN = 256);

/// Free text, site specific meaning
Property Location As %String(MAXLEN = 256);

/// The UniqueID of the Home Provider created for the User
Property ProviderID As %String(MAXLEN = 128);

/// When true and syncing with provider directory , will ignore demographic, telecom and identifier updates sent from HSPD
Property IgnoreProviderUpdates As %Boolean [ InitialExpression = 0 ];

/// Will be used when we create a UI for Home Providers, to update corresponding users
Index ProviderIndex On ProviderID;

Index NameIndex On NameParts.Family;

Index UserID On UserID;

Index Proxies On Proxies(KEYS);

ClassMethod SessionUserClinician(pUser As %String = "") As %String
{
	IF $D(%session.Data("ClinicianId"),tClinicianId) Quit:tClinicianId]"" tClinicianId
	Set:pUser="" pUser=$UserName
	Set tResponse=##Class(HS.Registry.Person.User.WebServices.Containers.SessionInfo).%New()
	Set tSC=##Class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","GetUserSessionInfo",.tResponse,pUser)
	IF $$$ISERR(tSC) $$$LOGERROR($System.Status.GetErrorText(tSC))
	Set %session.Data("ClinicianId")=tResponse.UserInternalID
	Set %session.Data("CanProxy")=tResponse.CanProxy
	Set %session.Data("AtFacility")=tResponse.PrimaryFacility
	Set %session.Data("Facilities")=tResponse.Facilities
	Set %session.Data("UserType")=tResponse.UserType
	Set %session.Data("MessageRepository")=tResponse.MessageRepository
	Set ClassCode=##class(HS.Registry.Config).GetKeyValue("\UserLogin\PostLoginCode","")
	If ClassCode]"" {
		try {
			Do $classmethod($p(ClassCode,":"),$p(ClassCode,":",2),pUser,tResponse)
		} catch {}
	}
	Quit tResponse.UserInternalID
}

ClassMethod ReturnSessionInfoResponse(pUserName) As HS.Registry.Person.User.WebServices.Containers.SessionInfo
{
	Set tResponse=##Class(HS.Registry.Person.User.WebServices.Containers.SessionInfo).%New()
	&SQL(Select ID into :tID FROM HS_Registry_Person.UserClinician Where UserID=:pUserName AND Active=1)
	Quit:SQLCODE'=0 tResponse
	Set tResponse.UserInternalID=tID
	Set tUser=##Class(HS.Registry.Person.User).%OpenId(tID)
	Set tResponse.UserType=tUser.Type
	Set tResponse.MessageRepository=tUser.MessageRepository
	Set tKey="", tFacilities=""
	#dim tFacil As HS.Registry.Person.UserFacility
	DO {
		Set tFacil=tUser.Facilities.GetNext(.tKey)
		If tFacil'="" {
			Set:tFacil.PrimaryFlag tResponse.PrimaryFacility=tFacil.FacilityCode
			Set tFacilities=tFacilities_$S(tFacilities]"":",",1:"")_tFacil.FacilityCode
		}
	} While tKey'=""
	Set tResponse.Facilities=tFacilities
	&SQL(Select Count(*) into :tProxCount FROM HS_Registry_Person.UserClinician_Proxies WHERE element_key=:pUserName)
	Set:tProxCount tResponse.CanProxy=1
	Quit tResponse
}

/// Search for users
Query FindUsers(pActiveOnly As %String, pLastName As %String, pFirstName As %String, pUserId As %String, pNumber As %String, pAssignAuth As %String, pCliniciansOnly As %Boolean, pFilterFlag As %Boolean, pFacilities As %String, pRelationshipId As %String, pMPIID As %String, pDelivery As %Boolean = 0) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,UserId:%String,Description:%String,Number:%String,AssigningAuthority:%String,ClinicianFlag:%Boolean,Active:%Boolean")
{
}

ClassMethod FindUsersExecute(ByRef qHandle As %Binary, pActiveOnly As %Boolean = 1, pLastName As %String, pFirstName As %String, pUserId As %String, pNumber As %String, pAssignAuth As %String, pCliniciansOnly As %Boolean, pFilterFlag As %Boolean, pFacilities As %String, pRelationshipId As %String, pMPIID As %String, pDelivery As %Boolean) As %Status [ ServerOnly = 1 ]
{
	
	#dim ex As %Exception.AbstractException
	#define AccessError $$$ERROR($$$AccessToResourceDenied,$$$HSUserManagement_":USE")
	Set tSC = $$$OK
	Set tGivenFacilitiesList = $ListFromString(pFacilities)
	
	Try {
		
		// Check to Make Sure that the User has necessary security credential 
		// For %HS_UserManager no further security checks are necessary
		If ($System.Security.Check($$$HSUserManagement,"USE")) {
			// Do nothing
		} 
		ElseIf ($System.Security.Check($$$HSFacilityUserManagement,"USE")) {
			// For %HS_FacilityUserManager, check if pFilterFlag=0 and throw error
			If 'pFilterFlag {
				$$$ThrowStatus($$$AccessError)
			}			
			// Check user facilities to make sure that it contains the facilities that are returned when a user is found
			If $IsObject($Get(%session)) {
				Do ..SessionUserClinician()
				
				Set tUserClinicianFacilitiesList = $ListFromString(%session.Data("Facilities"))
				
				// Create subscripted arrays of tUserClinicianFacilitiesList
				Set i = 0
				While $ListNext(tUserClinicianFacilitiesList, i, value) {
					Set tUserClinicianFacilitiesArray(value) = ""
				}
				
				// Check that tGivenFacilitiesList is a subset of tUserClinicianFacilitiesList
				Set i = 0
				While $ListNext(tGivenFacilitiesList, i, value) {
					If '$Data(tUserClinicianFacilitiesArray(value)) {
						$$$ThrowStatus($$$AccessError)
					}
				}
			}
		}
		
		// Once all security checks have been done, execute the query
		Set tSC = ##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","FindUsers",.tObj,pActiveOnly,pLastName,pFirstName,pUserId,pNumber,pAssignAuth,pCliniciansOnly,pFilterFlag,pFacilities,pRelationshipId,pMPIID,pDelivery)
		$$$ThrowOnError(tSC)
		$$$ThrowOnError(tObj.Status)
		Set qHandle = tObj
		Set qHandle("POS") = 0
					 	
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Return tSC
}

ClassMethod FindUsersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUsersExecute, ServerOnly = 1 ]
{
	Kill qHandle
	Quit $$$OK
}

ClassMethod FindUsersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUsersExecute, ServerOnly = 1 ]
{
	Set Row=""
	Set pos=qHandle("POS")+1
	If pos>qHandle.Items.Count() {Set AtEnd=1}
	Else {
		Set tItem=qHandle.Items.GetAt(pos)
		Set Row=$Lb(tItem.ID,tItem.Name,tItem.UserID,tItem.Description,tItem.Number,tItem.AssigningAuthority,tItem.Type="C",tItem.Active)
	}
	Set qHandle("POS")=pos	
	Quit $$$OK
}

ClassMethod ResolveUserClinician(ByRef pClinicianId As %String = "", pRequestingUser As %String = "") As %Status
{
	Set tSC=$$$OK
	If (pClinicianId="")&&(pRequestingUser'="") {
		Set pClinicianId=..GetUserClinicianFromRequest(pRequestingUser)
	}
	If pClinicianId="" Set tSC=$$$HSError($$$HSErrClinicianNotFound,"",pRequestingUser)
	Quit tSC
}

/// Resolve a clinician group ID
ClassMethod ResolveClinicianGroup(ByRef pClinicianId As %String = "") As %String
{
	If pClinicianId?1A.N {
		Set tType=$E(pClinicianId)
		Set pClinicianId=$E(pClinicianId,2,*)
	}
	Quit $G(tType)
}

ClassMethod GetUserClinicianFromRequest(pRequestingUser As %String) As %String
{
	&SQL(Select ID INTO :tClinician FROM UserClinician
	 WHERE UserId=:pRequestingUser)
	IF SQLCODE=0 {
		Do ##Class(HS.Push.MessageCenter.Folder).SysFolders(tClinician)
		Quit tClinician
	}
	Quit ""
}

/// Validation before save
Method %OnValidateObject() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set tSC=$$$OK

	// User ID must be unique
	Set tUserID=..UserID
	&sql(Select ID,Name INTO :tId,:tName FROM HS_Registry_Person.UserClinician Where UserID = :tUserID And Active=1)
	If SQLCODE = 0,tId'=..%Id() {
		Set tSC = $$$HSError($$$HSErrUserIdAlreadyExists,tUserID,tName)
	}	

	Quit tSC
}

/// After save, cleanup user preferences and filters if user was inactivated
Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	If ..Active=0 {
		Set tUserID=..UserID
		$$$HCInvoke(tSC,$$$OK,"DeleteFilters",tUserID)
		Quit:$$$ISERR(tSC) tSC
		$$$HCInvoke(tSC,$$$OK,"DeletePreferences",tUserID)
		Quit:$$$ISERR(tSC) tSC
		$$$HCInvoke(tSC,$$$OK,"InactivatePrivatePrograms",tUserID)
		Quit:$$$ISERR(tSC) tSC
	}
	Quit $$$OK
}

Method GetExistingData(Output pId As %String) As %Status
{
	Set tUserID = ..UserID
	&sql(SELECT ID into :tId from HS_Registry_Person.UserClinician where UserID = :tUserID)
	Set pId=$S(SQLCODE:"",1:tId)
	Quit $$$OK
}

ClassMethod FindByEmail(pEmail As %String, Output pId As %String, Output pName As %String, Output pUserId As %String) As %Status
{
	Set pId="",pName="",pUserId="",tSC=$$$OK
	&SQL(select UserClinician, UserClinician->Name,  UserClinician->UserID Into :tId,:tName, :tUserID from HS_Registry_Person.UserEmail Where Email=:pEmail
	 And %Internal(UserClinician->Type)='C'
	 Order by $Find(String('-',EmailType,'-'),'-DR-')Desc,PrimaryFlag Desc)
	If SQLCODE=0 {Set pId=tId,pName=tName, pUserId=tUserID}
	Quit $$$OK
}

/// Checks permissions (parameter-based) on a particular operation + object. <br />
/// If <var>pHandled</var> is set to true, <method>CheckPermission</method> will be bypassed. <br />
/// <var>pOperation</var> is "C" (create), "R" (read), "U" (update), or "D" (delete) <br />
/// <var>pID</var> is the ID of the object being operated on (empty for new objects) <br />
/// <var>pObject</var> is the object being operated on (for create/read/update; empty for delete) <br />
/// Returns <code>$$$ERROR($$$AccessDenied)</code> if the user does not have the requisite permission.
ClassMethod OnCheckPermission(Output pHandled As %Boolean = 0, pOperation As %String, pID As %Integer, pObject As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Set pHandled = 1
	Try {
		If $System.Security.Check($$$HSUserManagement,"USE") {
			// Automatic if user has $$$HSUserManagement
			Quit
		}
		If '$System.Security.Check($$$HSFacilityUserManagement,"USE") {
			Set tSC = $$$ERROR($$$AccessToResourceDenied,$$$HSFacilityUserManagement_":USE")
			Quit
		}
		
		If pOperation = "C" {
			// If has $$$HSFacilityUserManagement:USE, can create new users.
			Quit
		}
		
		// For Read/Update/Delete, active user must be associated with a facility also associated with the user in question.
		If $IsObject($Get(%session)) {
			// Get active user's facilities
			Do ..SessionUserClinician()
			Set tFacilities = $ListFromString($Get(%session.Data("Facilities")))
			
			// See if current user is associated with any of them
			&sql(SELECT TOP 1 1 FROM HS_Registry_Person.UserFacility WHERE UserClinician = :pID AND FacilityCode %INLIST :tFacilities)
			If SQLCODE < 0 {
				Throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
			} ElseIf SQLCODE = 100 {
				// Report access to $$$HSUserManagement:USE denied: attempting to work with a user at a different facility.
				Set tSC = $$$ERROR($$$AccessToResourceDenied,$$$HSUserManagement_":USE")
			} Else {
				// Found a match. Pass through.
			}
		}
	} Catch e {
		Set tSC = e.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="Addresses">
<Attribute>Addresses</Attribute>
<Structure>subnode</Structure>
<Subscript>"Addresses"</Subscript>
</Data>
<Data name="Identifiers">
<Attribute>Identifiers</Attribute>
<Structure>subnode</Structure>
<Subscript>"Identifiers"</Subscript>
</Data>
<Data name="Proxies">
<Attribute>Proxies</Attribute>
<Structure>subnode</Structure>
<Subscript>"Proxies"</Subscript>
</Data>
<Data name="Telecoms">
<Attribute>Telecoms</Attribute>
<Structure>subnode</Structure>
<Subscript>"Telecoms"</Subscript>
</Data>
<Data name="UserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NameParts</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>BirthDateTime</Value>
</Value>
<Value name="6">
<Value>BirthPlace</Value>
</Value>
<Value name="7">
<Value>AdministrativeGender</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>CacheUser</Value>
</Value>
<Value name="10">
<Value>Race</Value>
</Value>
<Value name="11">
<Value>EthnicGroup</Value>
</Value>
<Value name="12">
<Value>LanguageCommunication</Value>
</Value>
<Value name="13">
<Value>VIPIndicator</Value>
</Value>
<Value name="14">
<Value>Description</Value>
</Value>
<Value name="15">
<Value>MaritalStatus</Value>
</Value>
<Value name="16">
<Value>MessageRepository</Value>
</Value>
<Value name="17">
<Value>ReligiousAffiliation</Value>
</Value>
<Value name="18">
<Value>UserID</Value>
</Value>
<Value name="19">
<Value>LastLoginDate</Value>
</Value>
<Value name="20">
<Value>Specialty</Value>
</Value>
<Value name="21">
<Value>SubSpecialty</Value>
</Value>
<Value name="22">
<Value>Location</Value>
</Value>
<Value name="23">
<Value>Roles</Value>
</Value>
<Value name="24">
<Value>ProviderID</Value>
</Value>
<Value name="25">
<Value>IgnoreProviderUpdates</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Person.UserD</DataLocation>
<DefaultData>UserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.Person.UserD</IdLocation>
<IndexLocation>^HS.Registry.Person.UserI</IndexLocation>
<StreamLocation>^HS.Registry.Person.UserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
