Include HS.HC

Class HS.Registry.Person.UserLoginID Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Relationship UserClinician As HS.Registry.Person.User [ Cardinality = parent, Inverse = LoginIDs ];

Relationship PasswordHistory As HS.Registry.Person.UserPWHistory [ Cardinality = children, Inverse = LoginID ];

/// Login ID in HealthShare or external registry.
Property LoginID As %String(MAXLEN = 128);

/// Domain Code, IDKEY to Domain Registry
Property DomainCode As %String(MAXLEN = 128);

Index LoginIDIndex On (DomainCode, LoginID);

/// %HS* domains, copied from Security.Users
/// PBKDF2 hashed password for Cache Authentication.<br>
/// This is used with a salt function obtained from 
/// $System.Encryption.GenCryptRand. This property is set by the class when the
/// PasswordExternal property is modified. Do not set this property directly.
Property Password As HS.Registry.Person.UserPassword(MAXLEN = 20);

/// %HS* domains, copied from Security.Users
/// Clear text password.<br>
/// This property is not stored in permanent storage. It is initially set to
/// the value of $c(0). When it is modified, the Password property is updated
/// to the PBKDF2 salted hashed value.
Property PasswordExternal As %String(MAXLEN = 128, XMLPROJECTION = "NONE") [ InitialExpression = {$c(0)}, Transient ];

/// %HS* domains, copied from Security.Users
/// Method to set the password.<br>
/// Input is a clear text string that is hashed into the Password property.
/// If the input argument is prefixed with $c(0), don't validate the password pattern.
/// PasswordExternal begins as $c(0).  If it changes, the password pattern will be validated.
Method PasswordExternalSet(Arg As %String) As %Status [ Internal ]
{
 s i%PasswordExternal=Arg
 i $a(Arg,1)=0 s Arg=$e(Arg,2,$l(Arg))
 s i%Salt=$System.Encryption.GenCryptRand($$$CachePWSaltLength)
 s i%Password=$System.Encryption.PBKDF2(Arg,$$$CachePWIterations,i%Salt,$$$CachePWHashLength)
 Quit $$$OK
}

/// %HS* domains, copied from Security.Users
/// Salt value for Hashed password from $System.Encryption.GenCryptRand.<br>
Property Salt As %Binary(MAXLEN = 8);

/// %HS* domains
/// Change password on next login.<br>
/// 0 - Password change not required.<br>
/// 1 - Password change required before next login.<br>
Property ChangePassword As %Boolean [ InitialExpression = 0 ];

/// For enforcing entry of a new password after a period of time
Property DatePasswordChanged As %Integer;

/// %HS* domains, copied from Security.Users
/// Last date an account can be used.<br>
/// $H date value of when an account becomes disabled.<br>
Property ExpirationDate As %Integer;

/// %HS* domains, copied from Security.Users
/// Include special consent-group roles (HSGROUP*)
/// Roles assigned to the user.<br>
Property Roles As list Of %String(MAXLEN = 64);

/// Count of how many bad logins have happened since the last successful login
/// Maintained as needed by HSAuth or its descendents
Property BadLoginCount As %Integer;

/// Required for use of "Forgot Password"
Property ChallengeQuestion As %String(MAXLEN = 256);

Property ChallengeAnswer As %String(MAXLEN = 256);

/// If the domain uses two factor authentication, this will be the phone provider
Property PhoneProvider As %String(MAXLEN = 128);

/// If the domain uses two factor authentication, this will be the phone number (usually a mobile phone)
Property PhoneNumber As %String(MAXLEN = 64);

/// The user who most recently changed this login ID - for auditing purposes
Property LastModifiedBy As %String(MAXLEN = 128, TRUNCATE = 1) [ Transient ];

/// List login IDs via web service call
Query ListUserLoginIDs(pRegistryId As %String) As %Query(ROWSPEC = "ID:%String,Domain:%String,LoginID:%String,UserClinician:%String")
{
}

ClassMethod ListUserLoginIDsExecute(ByRef qHandle As %Binary, pRegistryId As %String) As %Status [ ServerOnly = 1 ]
{
	Set tSC=##class(HS.Util.HubServices).InvokeHubService("HS.Registry.Person.User.WebServices","HS.Registry.Person.User.WebServicesClient","ListUserLoginIDs",.tObj,pRegistryId)
	If '$$$ISOK(tSC) Quit tSC
	If '$$$ISOK(tObj.Status) Quit tObj.Status
	Set qHandle=tObj
	Set qHandle("POS")=0
	Set qHandle("UserClinician")=pRegistryId
	Quit $$$OK
}

ClassMethod ListUserLoginIDsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListUserLoginIDsExecute, ServerOnly = 1 ]
{
	Kill qHandle
	Quit $$$OK
}

ClassMethod ListUserLoginIDsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListUserLoginIDsExecute, ServerOnly = 1 ]
{
	Set Row=""
	Set pos=qHandle("POS")+1
	If pos>qHandle.Items.Count() {Set AtEnd=1}
	Else {
		Set tItem=qHandle.Items.GetAt(pos)
		Set Row=$Lb(tItem.ID,tItem.Domain,tItem.LoginID,qHandle("UserClinician"))
	}
	Set qHandle("POS")=pos	
	Quit $$$OK
}

/// Validation before save
Method %OnValidateObject() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	
	// Domain/login ID must be unique
	Set tLogin=..LoginID,tDomain=..DomainCode
	&sql(Select Login.ID,Usr.Name INTO :tId,:tName From HS_Registry_Person.UserLoginID Login, HS_Registry_Person.UserClinician Usr Where LoginID = :tLogin And DomainCode=:tDomain And UserClinician = Usr.ID And Usr.Active=1)
	If SQLCODE = 0,tId'=..%Id() {
		Set tSC = $$$HSError($$$HSErrLoginIdAlreadyExists,..LoginID,tName)
	}	
	
	Quit tSC
}

/// Delete after validating (none currently)
ClassMethod DeleteData(id As %String, concurrency As %Integer = -1) As %Status
{
	Quit ..%DeleteId(id,concurrency)
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	Set tComment=$S(insert:"Create",1:"Modify")_" Login "_..LoginID_"@"_..DomainCode
	Set tUser=..UserClinician.UserID Set:tUser'="" tComment=$E(tComment_" for User "_tUser,1,128)
	Set tResult=$SYSTEM.Security.Audit("%System","%Security","UserChange",..LastModifiedBy,tComment)
	Set:'tResult tSC=$$$ERROR($$$GeneralError,"Save failed due to inability to audit.  Please ensure that auditing is enabled in the Management Portal.")
	Quit tSC
}

Storage Default
{
<Data name="UserLoginIDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LoginID</Value>
</Value>
<Value name="3">
<Value>DomainCode</Value>
</Value>
<Value name="4">
<Value>Password</Value>
</Value>
<Value name="5">
<Value>Salt</Value>
</Value>
<Value name="6">
<Value>ChangePassword</Value>
</Value>
<Value name="7">
<Value>ExpirationDate</Value>
</Value>
<Value name="8">
<Value>Roles</Value>
</Value>
<Value name="9">
<Value>DatePasswordChanged</Value>
</Value>
<Value name="10">
<Value>BadLoginCount</Value>
</Value>
<Value name="11">
<Value>ChallengeQuestion</Value>
</Value>
<Value name="12">
<Value>ChallengeAnswer</Value>
</Value>
<Value name="13">
<Value>PhoneProvider</Value>
</Value>
<Value name="14">
<Value>PhoneNumber</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("LoginIDs")</DataLocation>
<DefaultData>UserLoginIDDefaultData</DefaultData>
<IdLocation>^HS.Registry.Person.UserC("LoginIDs")</IdLocation>
<IndexLocation>^HS.Registry.PeBAF2.UserLoginIDI</IndexLocation>
<StreamLocation>^HS.Registry.PeBAF2.UserLoginIDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
