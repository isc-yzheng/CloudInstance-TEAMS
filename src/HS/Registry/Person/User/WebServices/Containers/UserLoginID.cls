Class HS.Registry.Person.User.WebServices.Containers.UserLoginID Extends (%Persistent, HS.Util.WebServices.ServiceStatus, HS.Util.WebServices.SuperContainerListItem) [ ClassType = persistent, Inheritance = right ]
{

/*
 * NOTE: ALL MAXLEN taken from <class>HS.Registry.Person.UserLoginID</class>.
 */
/// If this parameter is true then JSON-enabling methods will be generated. 
/// Otherwise, the method generators do not produce a runnable method.
Parameter %JSONENABLED = 1;

Property UserClinician As %String(MAXLEN = "");

/// This property is flagged as required from UI, please also ensure to check it as required when using server side API
Property LoginID As %String(MAXLEN = 128);

/// This property is flagged as required from UI, please also ensure to check it as required when using server side API
/// To avoid confusion, this is DomainCode as in HS.Registry.Person.UserLoginID
Property Domain As %String(MAXLEN = 128);

/// This is the encrypted password, and is generated when you invoke method EncryptPassword
Property Password As %Binary;

/// This is generated when you encrypt the password
Property Salt As %Binary;

Property ChangePassword As %Boolean;

/// $H date value of when an account becomes disabled.<br>
Property ExpirationDate As %Integer;

Property Roles As list Of %String(MAXLEN = 64);

Property ChallengeQuestion As %String(MAXLEN = 256);

Property ChallengeAnswer As %String(MAXLEN = 256);

/// If the domain uses two factor authentication, this will be the phone provider
Property PhoneProvider As %String(MAXLEN = 128);

/// If the domain uses two factor authentication, this will be the phone number (usually a mobile phone)
Property PhoneNumber As %String(MAXLEN = 64);

/// The user who most recently changed this login ID - for auditing purposes
Property LastModifiedBy As %String(MAXLEN = 128, TRUNCATE = 1);

/// API Method: Call this to generate the encryption salt and encrypted password
Method EncryptPassword(pPasswordExternal)
{
	Set tUser=##Class(HS.Registry.Person.UserLoginID).%New()
	Set tUser.PasswordExternal=pPasswordExternal
	Set ..Salt=tUser.Salt
	Set ..Password=tUser.Password
	Quit
}

/// Base JSON translations.
/// Salt - never want to provide access. Purely internal
/// Password - never want to provide access. Purely internal (this is the encrypted password)
/// Challenge Answer - only allowed to be set. Never viewed again
/// LastModifiedBy - set internally and only returned
XData BasicReference [ Internal, XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping Mapping="BasicReference" IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="ID" FieldName="user_login_id_key"/>
<Property Name="UserClinician" FieldName="user_key"/>
<Property Name="LoginID" FieldName="login_id"/>
<Property Name="Domain" FieldName="domain"/>
<Property Name="ChangePassword" FieldName="change_password"/>
<Property Name="ExpirationDate" FieldName="expiration_date"/>
<Property Name="Roles" FieldName="roles"/>
<Property Name="PhoneProvider" FieldName="phone_provider"/>
<Property Name="PhoneNumber" FieldName="phone_number"/>
<Property Name="ChallengeQuestion" FieldName="challenge_question"/>
<Property Name="ChallengeAnswer" FieldName="challenge_answer" Include="INPUTONLY"/>
<Property Name="Password" FieldName="password" Include="NONE"/>
<Property Name="Salt" Include="NONE"/>
<Property Name="LastModifiedBy" FieldName="last_modified_by" Include="OUTPUTONLY"/>
</Mapping>
}

/// Overridden from <class>%Library.Persistent</class>
Method %OnValidateObject() As %Status [ Private, ServerOnly = 1 ]
{
	#dim ex As %Exception.AbstractException
	Set sc = $$$OK
	Try {
		If (..Domain '= "") {
			Do ..ValidateDomain(..Domain)
		}
		If (..LoginID '= "") {
			Do ..ValidateLoginID(..LoginID)
		}
	} Catch ex {
		Set sc = ex.AsStatus()
	}
	Quit sc
}

/// Do validation on property <property>ValidateDomain</property>. <br />
ClassMethod ValidateDomain(pDomain As %String) [ Internal, Private ]
{
	/*
	 * Domain comes from HS_Registry.AuthDomain as per HS.UI.Registry.User.Util:%InitializePage 
	 */
	 
	If '##class(HS.Registry.AuthDomain).%ExistsId(pDomain) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Non-existent domain code provided: "_pDomain))
	}
}

/// Do validation on property <property>LoginID</property>. <br />
ClassMethod ValidateLoginID(pLoginID As %String) [ Internal, Private ]
{
	// Only allow word characters and non-consecutive . and - characters if not the first/last character.
	If '$Match(pLoginID,"\w+([.-]?\w+)*") {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Login ID cannot contain special characters. '.' and '-' cannot be used consecutively or as the first/last character."))
	}
}

Storage Default
{
<Data name="UserLoginIDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>%User</Value>
</Value>
<Value name="4">
<Value>%Roles</Value>
</Value>
<Value name="5">
<Value>%Gateway</Value>
</Value>
<Value name="6">
<Value>Salt</Value>
</Value>
<Value name="7">
<Value>ChangePassword</Value>
</Value>
<Value name="8">
<Value>ExpirationDate</Value>
</Value>
<Value name="9">
<Value>Roles</Value>
</Value>
<Value name="10">
<Value>ChallengeQuestion</Value>
</Value>
<Value name="11">
<Value>ChallengeAnswer</Value>
</Value>
<Value name="12">
<Value>Domain</Value>
</Value>
<Value name="13">
<Value>ID</Value>
</Value>
<Value name="14">
<Value>LoginID</Value>
</Value>
<Value name="15">
<Value>Name</Value>
</Value>
<Value name="16">
<Value>Password</Value>
</Value>
<Value name="17">
<Value>Status</Value>
</Value>
<Value name="18">
<Value>UserClinician</Value>
</Value>
<Value name="19">
<Value>PhoneProvider</Value>
</Value>
<Value name="20">
<Value>PhoneNumber</Value>
</Value>
<Value name="21">
<Value>LastModifiedBy</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Pe1585.UserLoginIDD</DataLocation>
<DefaultData>UserLoginIDDefaultData</DefaultData>
<IdLocation>^HS.Registry.Pe1585.UserLoginIDD</IdLocation>
<IndexLocation>^HS.Registry.Pe1585.UserLoginIDI</IndexLocation>
<StreamLocation>^HS.Registry.Pe1585.UserLoginIDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
