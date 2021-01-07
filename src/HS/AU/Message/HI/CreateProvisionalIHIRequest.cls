Class HS.AU.Message.HI.CreateProvisionalIHIRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.CreateProvisionalIHIResponse";

Parameter XMLNAME = "createProvisionalIHI";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerCreateProvisionalIHI/3.0";

Property FamilyName As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", TRUNCATE = 1, XMLNAME = "familyName", XMLREF = 1);

Property GivenName As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", TRUNCATE = 1, XMLNAME = "givenName", XMLREF = 1);

Property Sex As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,I,M,N", XMLNAME = "sex", XMLREF = 1);

Property DateOfBirth As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfBirth", XMLREF = 1);

Property DateOfBirthAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfBirthAccuracyIndicator", XMLREF = 1);

Property DateOfDeath As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfDeath", XMLREF = 1);

Property DateOfDeathAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfDeathAccuracyIndicator", XMLREF = 1);

Property SourceOfDeathNotification As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",H", XMLNAME = "sourceOfDeathNotification", XMLREF = 1);

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.CreateProvisionalIHIRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CreateProvisionalIHIRequestDefaultData">
<Subscript>"CreateProvisionalIHIRequest"</Subscript>
<Value name="1">
<Value>FamilyName</Value>
</Value>
<Value name="2">
<Value>GivenName</Value>
</Value>
<Value name="3">
<Value>Sex</Value>
</Value>
<Value name="4">
<Value>DateOfBirth</Value>
</Value>
<Value name="5">
<Value>DateOfBirthAccuracyIndicator</Value>
</Value>
<Value name="6">
<Value>DateOfDeath</Value>
</Value>
<Value name="7">
<Value>DateOfDeathAccuracyIndicator</Value>
</Value>
<Value name="8">
<Value>SourceOfDeathNotification</Value>
</Value>
<Value name="9">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>CreateProvisionalIHIRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
