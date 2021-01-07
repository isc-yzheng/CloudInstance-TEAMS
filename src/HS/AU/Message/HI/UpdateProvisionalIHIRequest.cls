Class HS.AU.Message.HI.UpdateProvisionalIHIRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.UpdateProvisionalIHIResponse";

Parameter XMLTYPE = "updateProvisionalIHI";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerUpdateProvisionalIHI/3.0";

Property IHINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "ihiNumber", XMLPROJECTION = "ELEMENT", XMLREF = 1);

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
<Data name="UpdateProvisionalIHIRequestDefaultData">
<Subscript>"UpdateProvisionalIHIRequest"</Subscript>
<Value name="1">
<Value>IHINumber</Value>
</Value>
<Value name="2">
<Value>FamilyName</Value>
</Value>
<Value name="3">
<Value>GivenName</Value>
</Value>
<Value name="4">
<Value>Sex</Value>
</Value>
<Value name="5">
<Value>DateOfBirth</Value>
</Value>
<Value name="6">
<Value>DateOfBirthAccuracyIndicator</Value>
</Value>
<Value name="7">
<Value>DateOfDeath</Value>
</Value>
<Value name="8">
<Value>DateOfDeathAccuracyIndicator</Value>
</Value>
<Value name="9">
<Value>SourceOfDeathNotification</Value>
</Value>
</Data>
<DefaultData>UpdateProvisionalIHIRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
