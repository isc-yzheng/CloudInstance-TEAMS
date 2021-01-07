Class HS.AU.SMD.Configuration Extends (%Persistent, HS.Util.DataModel.Adaptor)
{

/// If specified, this RESOURCE:PERMISSION is checked before any operation on this class via Zen MVC. (Create, Read, Update, or Delete.)
Parameter RESOURCE As STRING = {$$$HSInstallationManagement};

/// Organisation IHI number: example: http://ns.electronichealth.net.au/id/hi/hpio/1.0/8003620000030515
Property HPIO As %String(MAXLEN = 250) [ Required ];

Property SigningX509Alias As %String(MAXLEN = 150) [ Required ];

Property SSLConfig As %String(MAXLEN = 150) [ Required ];

Index HPIOIndex On HPIO [ Unique ];

/// This method returns an X509 Credentials object by looking at the HPIO configurations 
Method GetSigningX509(ByRef x509Cert As %SYS.X509Credentials) As %Status
{
	set tSC=$$$OK
	Try {
		set x509Cert=##Class(%SYS.X509Credentials).GetByAlias(..SigningX509Alias)
		if x509Cert="" {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"Unable to get Default Certificiate for signing using alias: '"_..SigningX509Alias_"'"))
		}
	} catch ex {
		set tSC=ex.AsStatus()
	}	
	quit tSC
}

Query Items() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,HPIO,SigningX509Alias,SSLConfig FROM Configuration
}

Storage Default
{
<Data name="ConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HPIO</Value>
</Value>
<Value name="3">
<Value>IHIQualifier</Value>
</Value>
<Value name="4">
<Value>SigningX509Alias</Value>
</Value>
<Value name="5">
<Value>SSLConfig</Value>
</Value>
</Data>
<DataLocation>^HS.AU.SMD.ConfigurationD</DataLocation>
<DefaultData>ConfigurationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.AU.SMD.ConfigurationD</IdLocation>
<IndexLocation>^HS.AU.SMD.ConfigurationI</IndexLocation>
<StreamLocation>^HS.AU.SMD.ConfigurationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
