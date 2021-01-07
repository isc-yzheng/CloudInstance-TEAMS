Class HS.Registry.Person.User.WebServices.Containers.User Extends (%Persistent, HS.Util.WebServices.ServiceStatus, HS.Util.WebServices.ListItem) [ ClassType = persistent, Inheritance = right ]
{

/*
 * NOTE: ALL MAXLEN taken from <class>HS.Registry.Person.User</class>.
 */
/// Overridden from <class>%JSON.Adaptor</class>. <br />
/// Is set to 0 in other intermediate superclasses so must be 1 here. <br />
Parameter %JSONENABLED = 1;

Property UserID As %String(MAXLEN = 128);

/// Corresponds to NameParts.Family in <class>HS.Registry.Person.User</class>.
Property LastName As %String(MAXLEN = 64);

/// Corresponds to NameParts.First in <class>HS.Registry.Person.User</class>.
Property FirstName As %String(MAXLEN = 64);

/// Corresponds to NameParts.Middle in <class>HS.Registry.Person.User</class>.
Property MiddleName As %String(MAXLEN = 64);

/// Corresponds to NameParts.Suffix in <class>HS.Registry.Person.User</class>.
Property Suffix As %String(MAXLEN = 64);

Property Description As %String(MAXLEN = "");

Property MessageRepository As %String(MAXLEN = 256);

/// Corresponds to Addresses.StreetLine in <class>HS.Registry.Person.User</class>.
Property Street As %String(MAXLEN = "");

/// Corresponds to Addresses.City in <class>HS.Registry.Person.User</class>.
Property City As %String(MAXLEN = 64);

/// Corresponds to Addresses.State in <class>HS.Registry.Person.User</class>.
Property State As %String(MAXLEN = 64);

/// Corresponds to Addresses.PostalCode in <class>HS.Registry.Person.User</class>.
Property Zip As %String(MAXLEN = 64);

/// Corresponds to Addresses.Country in <class>HS.Registry.Person.User</class>.
Property Country As %String(MAXLEN = 64);

Property EmailAddress As %String(MAXLEN = 500);

Property Phone As HS.Types.Telecom;

Property Mobile As HS.Types.Telecom;

Property Fax As HS.Types.Telecom;

Property Pager As HS.Types.Telecom;

Property Active As %Boolean;

Property CacheUser As %Boolean;

/// This property, when set through UI, will guarantee to have a value. </br>
/// For backward compatibility, however, is not restricted as required here. </br>
/// It gets set as default 'U' in AddEditUser() method of <class>HS.Registry.Person.User.WebServices</class> in certain cases. </br>
/// See detail comments in AddEditUser()
Property Type As %String;

Property Identifiers As list Of HS.Types.Identifier;

/// No longer used.
Property Number As %String(MAXLEN = "") [ Deprecated ];

/// No longer used
Property AssigningAuthority As %String(MAXLEN = "") [ Deprecated ];

/// Keys are full names so have the MAXLEN of Name.
Property Proxies As array Of %String(MAXLEN = 256);

Property Specialty As %String(MAXLEN = 256);

Property SubSpecialty As %String(MAXLEN = 256);

Property Location As %String(MAXLEN = 256);

Property AdditionalInfo As array Of %String(MAXLEN = 1024);

Property Email As list Of HS.Types.Telecom;

Property IgnoreProviderUpdates As %Boolean;

/// Base JSON translations.
/// Each property of type HS.Types.Telecom overrides with their own mapping.
/// Identifiers uses its own mapping.
/// Number - isn't used by WebServices API or by persistence.
/// AssigningAuthority - isn't used by WebServices API or by persistence.
/// EmailAddress - only used by custom UI. Not needed in API.
XData BasicReference [ Internal, XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping Mapping="BasicReference" IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="ID" FieldName="key"/>
<Property Name="UserID" FieldName="user_id"/>
<Property Name="LastName" FieldName="last_name"/>
<Property Name="FirstName" FieldName="first_name"/>
<Property Name="MiddleName" FieldName="middle_name"/>
<Property Name="Suffix" FieldName="suffix"/>
<Property Name="Description" FieldName="description"/>
<Property Name="MessageRepository" FieldName="message_repository"/>
<Property Name="Street" FieldName="street"/>
<Property Name="City" FieldName="city"/>
<Property Name="State" FieldName="state"/>
<Property Name="Zip" FieldName="zip"/>
<Property Name="Country" FieldName="country"/>
<Property Name="EmailAddress" Include="NONE"/>
<Property Name="Phone" FieldName="phone" Mapping="Phone"/>
<Property Name="Mobile" FieldName="mobile" Mapping="Phone"/>
<Property Name="Fax" FieldName="fax" Mapping="Phone"/>
<Property Name="Pager" FieldName="pager" Mapping="Phone"/>
<Property Name="Active" FieldName="active"/>
<Property Name="CacheUser" FieldName="system_user"/>
<Property Name="Type" FieldName="type"/>
<Property Name="Identifiers" FieldName="identifiers" Mapping="ClinicianIdentifier"/>
<Property Name="Number" Include="NONE"/>
<Property Name="AssigningAuthority" Include="NONE"/>
<Property Name="Proxies" FieldName="proxies"/>
<Property Name="Specialty" FieldName="specialty"/>
<Property Name="SubSpecialty" FieldName="sub_specialty"/>
<Property Name="Location" FieldName="location"/>
<Property Name="AdditionalInfo" FieldName="additional_info"/>
<Property Name="Email" FieldName="email_ids" Mapping="Email"/>
<Property Name="IgnoreProviderUpdates" FieldName="ignore_provider_updates"/>
</Mapping>
}

/// Overridden from <class>%Library.Persistent</class>.
/// Validate all fields that have a dropdown in the UI.
Method %OnValidateObject() As %Status [ Private, ServerOnly = 1 ]
{
	#dim ex As %Exception.AbstractException
	Set sc = $$$OK
	Try {
		If (..MessageRepository '= "") {
			Do ..ValidateMessageRepository(..MessageRepository)
		}
		If (..Proxies.Count() > 0) {
			// The values are set in validation. Validation only done on keys (user ids)
			Set ..Proxies = ..ValidateProxies(..Proxies)
		}
		// Set "Type" for phone telecom properties
		// The following Telecoms need the Type property set to be added to persistence in HS.Registry.Person.User.WebServices:AddEditUser
		// The values for Type are obtained from HS.UI.Registry.User.Manager:SaveUserData
		// NOTE: $Data checks must happen on i% variables because if you use .. syntax, the object gets swizzled.
		If $Data(i%Phone) {
			Set ..Phone.Type = "L"
		}
		If $Data(i%Mobile) {
			Set ..Mobile.Type = "M"
		}
		If $Data(i%Fax) {
			Set ..Fax.Type = "F"
		}
		If $Data(i%Pager) {
			Set ..Pager.Type = "P"
		}
		// Validation for properties that are list of objects (not present natively in %Validate object as of IRIS 2019.1.1)
		For i = 1:1:..Identifiers.Count() {
			// No general validation provided in %OnValidateObject() because HS.Types.Identifier is used in other features as well.
			Do ..Identifiers.GetAt(i).ValidateAssigningAuthorityName("DN")
		}
		For i = 1:1:..Email.Count() {
			$$$ThrowOnError(..Email.GetAt(i).%ValidateObject())
		}
	} Catch ex {
		Set sc = ex.AsStatus()
	}
	Quit sc
}

/// Do validation on property <property>MessageRepository</property>. <br />
ClassMethod ValidateMessageRepository(pMessageRepository As %String) [ Internal, Private ]
{
	/*
	 * Message Repository comes from HS_Gateway.Config table as per HS.UI.Registry.User.Util:%InitializePage
	 */
	If ##class(HS.Gateway.Config).NameIndexExists(pMessageRepository, .id) {
		// Make sure its an edge gateway
		If (##class(HS.Gateway.Config).TypeGetStored(id) = "E") {
			Return
		}
	}
	$$$ThrowStatus($$$ERROR($$$GeneralError, "Non-existent message repository provided: "_pMessageRepository))
}

/// Do validation on property <property>Proxies</property>. <br />
/// Returns the input proxy array with values set. <br />
ClassMethod ValidateProxies(pProxyArray As %Library.ArrayOfDataTypes) As %Library.ArrayOfDataTypes [ Internal, Private ]
{
	/*
	 * ALL proxy User Id's MUST exist in UserClinician table
	 */
	// Keys are user ids. Values are lastname, firstname
	Set proxyUserIdList = ""
	Set key = ""
	While 1 {
		Set value = pProxyArray.GetNext(.key)
		If (key = "") {
			Quit
		}
		Set proxyUserIdList = proxyUserIdList _ $ListBuild(key)
	}
	#dim resultSet As %SQL.StatementResult
	Set query = "SELECT UserID, NameParts_Family As LastName, NameParts_Given As FirstName "_
				"FROM HS_Registry_Person.UserClinician "_
				"WHERE UserID %INLIST ?"
	Set statement = ##class(%SQL.Statement).%New()
	$$$ThrowOnError(statement.%Prepare(query))
	Set resultSet = statement.%Execute(proxyUserIdList)
	If (resultSet.%SQLCODE < 0) {
		Throw ##class(%Exception.SQL).CreateFromSQLCODE(resultSet.%SQLCODE, resultSet.%Message)
	}
	#dim foundUserIdArray As %String
	While resultSet.%Next(.sc) {
		$$$ThrowOnError(sc)
		// Check if user id and last name,first name matches
		Set userId = resultSet.UserID
		Set name = resultSet.LastName_","_resultSet.FirstName
		$$$ThrowOnError(pProxyArray.SetAt(name, userId))
		Set foundUserIdArray(userId) = ""
	}
	$$$ThrowOnError(sc)
	Set badUserIdList = ""
	Set ptr = 0
	While $ListNext(proxyUserIdList, ptr, proxyUserId) {
		If '$Data(foundUserIdArray(proxyUserId)) {
			Set badUserIdList = badUserIdList _ $ListBuild(proxyUserId)
		}
	}
	If ($ListLength(badUserIdList) > 0) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Non-existent proxy id's provided: "_$ListToString(badUserIdList, ",")))
	}
	Return pProxyArray
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="Proxies">
<Attribute>Proxies</Attribute>
<Structure>subnode</Structure>
<Subscript>"Proxies"</Subscript>
</Data>
<Data name="UserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>LastName</Value>
</Value>
<Value name="4">
<Value>FirstName</Value>
</Value>
<Value name="5">
<Value>%User</Value>
</Value>
<Value name="6">
<Value>%Roles</Value>
</Value>
<Value name="7">
<Value>%Gateway</Value>
</Value>
<Value name="8">
<Value>MessageRepository</Value>
</Value>
<Value name="9">
<Value>Street</Value>
</Value>
<Value name="10">
<Value>City</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>Zip</Value>
</Value>
<Value name="13">
<Value>Country</Value>
</Value>
<Value name="14">
<Value>EmailAddress</Value>
</Value>
<Value name="15">
<Value>Phone</Value>
</Value>
<Value name="16">
<Value>Mobile</Value>
</Value>
<Value name="17">
<Value>Fax</Value>
</Value>
<Value name="18">
<Value>Pager</Value>
</Value>
<Value name="19">
<Value>Active</Value>
</Value>
<Value name="20">
<Value>CacheUser</Value>
</Value>
<Value name="21">
<Value>Type</Value>
</Value>
<Value name="22">
<Value>Identifiers</Value>
</Value>
<Value name="23">
<Value>Number</Value>
</Value>
<Value name="24">
<Value>AssigningAuthority</Value>
</Value>
<Value name="25">
<Value>Specialty</Value>
</Value>
<Value name="26">
<Value>SubSpecialty</Value>
</Value>
<Value name="27">
<Value>Location</Value>
</Value>
<Value name="28">
<Value>Email</Value>
</Value>
<Value name="29">
<Value>AssociateProvider</Value>
</Value>
<Value name="30">
<Value>Gender</Value>
</Value>
<Value name="31">
<Value>ProviderTypes</Value>
</Value>
<Value name="32">
<Value>Languages</Value>
</Value>
<Value name="33">
<Value>Specialties</Value>
</Value>
<Value name="34">
<Value>Services</Value>
</Value>
<Value name="35">
<Value>MemberOf</Value>
</Value>
<Value name="36">
<Value>Practices</Value>
</Value>
<Value name="37">
<Value>ProviderID</Value>
</Value>
<Value name="38">
<Value>Description</Value>
</Value>
<Value name="39">
<Value>ID</Value>
</Value>
<Value name="40">
<Value>MiddleName</Value>
</Value>
<Value name="41">
<Value>Name</Value>
</Value>
<Value name="42">
<Value>Status</Value>
</Value>
<Value name="43">
<Value>Suffix</Value>
</Value>
<Value name="44">
<Value>IgnoreProviderUpdates</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Person.Us1585.UserD</DataLocation>
<DefaultData>UserDefaultData</DefaultData>
<IdLocation>^HS.Registry.Person.Us1585.UserD</IdLocation>
<IndexLocation>^HS.Registry.Person.Us1585.UserI</IndexLocation>
<StreamLocation>^HS.Registry.Person.Us1585.UserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
