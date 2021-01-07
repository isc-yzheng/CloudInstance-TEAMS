/// A collection of tests with a name and a testing class
Class HS.Test.UI.TestGroup Extends (%Persistent, %XML.Adaptor)
{

Property Name As %String(MAXLEN = 255) [ InitialExpression = {"Run: "_$ZDT($H,3)} ];

Property Tests As list Of HS.Test.UI.Test(STORAGEDEFAULT = "array");

Property ClassName As %String;

Property RunTime As %TimeStamp [ InitialExpression = {$ZDT($H,3)} ];

Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

Index RunTimeIndex On RunTime;

Index NameIndex On Name;

Method %OnNew(pClassName As %String = "", pName As %String = "") As %Status [ Private, ServerOnly = 1 ]
{
	Set:pClassName]"" i%ClassName=pClassName
	Set:pName]"" i%Name=pName
	Quit $$$OK
}

Method NewTest(pRequest As %RegisteredObject, pLogTransaction As %Boolean = 1, pCode As %String = "", pComment As %String = "") As HS.Test.UI.Test
{
	Set tTest=##class(HS.Test.UI.Test).%New()
	Set tTest.Request=$G(pRequest)
	Set tTest.Code=pCode
	Set tTest.Comment=pComment
	try {Do:($isObject(pRequest)&&pLogTransaction) pRequest.AdditionalInfo.SetAt(1,"NoSSL")} catch {}
	Set tTest.LogTransaction=pLogTransaction
	Do ..Tests.Insert(tTest)
	Quit tTest
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="TestGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ClassName</Value>
</Value>
<Value name="4">
<Value>RunTime</Value>
</Value>
</Data>
<Data name="Tests">
<Attribute>Tests</Attribute>
<Structure>subnode</Structure>
<Subscript>"Tests"</Subscript>
</Data>
<DataLocation>^HS.Test.UI.TestGroupD</DataLocation>
<DefaultData>TestGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Test.UI.TestGroupD</IdLocation>
<IndexLocation>^HS.Test.UI.TestGroupI</IndexLocation>
<StreamLocation>^HS.Test.UI.TestGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
