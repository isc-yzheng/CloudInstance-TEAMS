Include HS.HC

/// General Area for storage of information
/// Configuration items for things like:
/// 	\General\ThisSystemOID = 1.2.3.4.5.6
/// 	\General\ThisOrganisationName = Company Name
/// 
Class HS.Registry.Config Extends (%Persistent, HS.Sync.BaseClass) [ ClassType = persistent, Inheritance = right ]
{

Parameter SYNCORDER = 10;

Property RegKey As %String(MAXLEN = 1000, TRUNCATE = 0);

Property RegValue As %String(MAXLEN = 1000, TRUNCATE = 0);

Index RegKeyIndex On RegKey [ Data = RegValue ];

ClassMethod FindByName(KeyName As %String, ByRef RegValue, ByRef ID As %Integer) As %Status
{
	&SQL(SELECT ID,RegValue INTO :ID,:RegValue FROM HS_Registry.Config WHERE RegKey=:KeyName)
	If SQLCODE {
		Set (ID,RegValue)="" 
		If SQLCODE'=100 Quit $$$HSError($$$HSErrGatewayNotFound,KeyName)
	}
	Quit $$$OK
}

ClassMethod DeleteByName(KeyName As %String) As %Status
{
	Set tID = 0
	&SQL(SELECT ID INTO :tID FROM HS_Registry.Config WHERE RegKey=:KeyName)
	If SQLCODE=0 {
		Quit ..%DeleteId(tID)
	}
	Quit $$$OK
}

ClassMethod GetKeyValue(KeyName As %String, pDefault As %String = "") As %String
{
	&SQL(SELECT RegValue INTO :RegValue FROM HS_Registry.Config WHERE RegKey=:KeyName)
	Set:SQLCODE=100 RegValue=pDefault
	If SQLCODE<0 {
		THROW ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
	}
	Set:SQLCODE RegValue=pDefault
	Quit RegValue
}

/// Add or Update a key in the registry config
ClassMethod AddUpdateKeyValue(pKey As %String = "", pValue As %String = "") As %Status
{
	Set tSC=$$$OK
	Try {			
		#; Must be on the HUB
		If '$$$IsHub $$$ThrowStatus($$$ERROR($$$GeneralError,"This command must be run from the hub/registry"))

		#; Get (or create) the config entry
		Set tSC=..FindByName(pKey,.tValue,.tID) Quit:$$$ISERR(tSC)
		If tID]"",..%ExistsId(tID) {
			Set tConfig=..%OpenId(tID,4,.tSC) Quit:$$$ISERR(tSC)
		}	Else {
			Set tConfig=..%New()
			Set tConfig.RegKey=pKey
		}
		
		#; Update value
		Set tConfig.RegValue=pValue
		Set tSC=tConfig.%Save()
		Kill tConfig
	} Catch ex { Set tSC=ex.AsStatus() }
	Quit tSC
}

/// Add a key/value only if one doesn't exist
ClassMethod AddNewKey(pKey As %String = "", pValue As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		If pKey = "" Quit
		If ..RegKeyIndexExists(pKey) Quit
		Set tConfig = ..%New()
		Set tConfig.RegKey = pKey
		Set tConfig.RegValue = pValue
		Set tSC = tConfig.%Save()
	} Catch ex { Set tSC = ex.AsStatus() }
	Quit tSC
}

Query ConfigItems(pType As %Integer = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,RegKey as "Key",RegValue as "Value"
FROM Config
ORDER BY RegKey
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegKey</Value>
</Value>
<Value name="3">
<Value>RegValue</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Registry.ConfigD</IdLocation>
<IndexLocation>^HS.Registry.ConfigI</IndexLocation>
<StreamLocation>^HS.Registry.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
