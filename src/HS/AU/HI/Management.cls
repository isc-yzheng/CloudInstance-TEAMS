Class HS.AU.HI.Management Extends (%Persistent, %XML.Adaptor) [ Abstract ]
{

Property Alert As %String(MAXLEN = "");

Property Number As %String(MAXLEN = 255);

/// Active, Deceased, Retired, Expired, Resolved
Property Status As %String;

Property LastValidation As %TimeStamp;

Property History As list Of HS.AU.HI.Management.History(CLASSNAME = 1, STORAGEDEFAULT = "array");

Index NumberIndex On Number;

Index AlertIndex On (AlertIndex, LastValidation);

Property AlertIndex As %String [ Calculated, SqlComputeCode = {	Set {*}=$E({Alert},1,50)}, SqlComputed ];

Method AlertIndexGet() As %String [ ServerOnly = 1 ]
{
	Quit $e(..Alert,1,50)
}

Storage Default
{
<Data name="History">
<Attribute>History</Attribute>
<Structure>subnode</Structure>
<Subscript>"History"</Subscript>
</Data>
<Data name="ManagementDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Alert</Value>
</Value>
<Value name="3">
<Value>Number</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>LastValidation</Value>
</Value>
</Data>
<DataLocation>^HS.AU.HI.ManagementD</DataLocation>
<DefaultData>ManagementDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.AU.HI.ManagementD</IdLocation>
<IndexLocation>^HS.AU.HI.ManagementI</IndexLocation>
<StreamLocation>^HS.AU.HI.ManagementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
