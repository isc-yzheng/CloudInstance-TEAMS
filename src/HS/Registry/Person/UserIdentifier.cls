Include HS.HC

Class HS.Registry.Person.UserIdentifier Extends (%Persistent, HS.Types.Identifier)
{

Relationship UserClinician As HS.Registry.Person.User [ Cardinality = parent, Inverse = Idents ];

Index IdentifierIndex On (Extension, AssigningAuthorityName);

Index AAIndex On (AssigningAuthorityName, Extension);

Property AssigningAuthorityName As %String(MAXLEN = "") [ Required ];

Property Extension As %String(MAXLEN = 512) [ Required ];

Property Use As %String [ Required ];

/// Delete after validating (none currently)
ClassMethod DeleteData(id As %String, concurrency As %Integer = -1) As %Status
{
	Quit ..%DeleteId(id,concurrency)
}

/// Validation before save
Method %OnValidateObject() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set tSC=$$$OK
	
	// Assigning Authority/Identifier must be unique to this user if active
	Set tAA=..AssigningAuthorityName,tNum=..Extension
	If ..UserClinician.Active {
		&sql(SELECT UserClinician,UserClinician->Name INTO :tId,:tName FROM HS_Registry_Person.UserIdentifier WHERE AssigningAuthorityName = :tAA And Extension=:tNum And UserClinician->Active=1)
		If SQLCODE = 0,tId'=..UserClinician.%Id() {
			Set tSC = $$$HSError($$$HSErrClinicianNumberNotUnique,tNum,tName)
		}	
	}
	Quit tSC
}

Storage Default
{
<Data name="UserIdentifierDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Root</Value>
</Value>
<Value name="3">
<Value>Extension</Value>
</Value>
<Value name="4">
<Value>AssigningAuthorityName</Value>
</Value>
<Value name="5">
<Value>Use</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^HS.RegistryBAF2.UserIdentifierD</DataLocation>
<DefaultData>UserIdentifierDefaultData</DefaultData>
<IdLocation>^HS.RegistryBAF2.UserIdentifierD</IdLocation>
<IndexLocation>^HS.RegistryBAF2.UserIdentifierI</IndexLocation>
<StreamLocation>^HS.RegistryBAF2.UserIdentifierS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
