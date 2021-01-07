Class HS.AU.Message.HI.SearchIHIResult Extends HS.AU.Message.CommonResponse [ ClassType = persistent, ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/SearchIHI/3.0";

Parameter XMLNAME = "searchIHIResult";

Property IHINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "ihiNumber", XMLREF = 1);

Property MedicareCardNumber As %String(MAXLEN = 10, MINLEN = 10, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "medicareCardNumber", XMLREF = 1);

Property MedicareIRN As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "medicareIRN", XMLREF = 1);

Property DVAFileNumber As %String(MAXLEN = 9, MINLEN = 2, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "dvaFileNumber", XMLREF = 1);

Property IHIRecordStatus As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",Provisional,Unverified,Verified", XMLNAME = "ihiRecordStatus", XMLREF = 1);

Property IHIStatus As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",Active,Deceased,Expired,Resolved,Retired", XMLNAME = "ihiStatus", XMLREF = 1);

Property GivenName As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", XMLNAME = "givenName", XMLREF = 1);

Property FamilyName As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", XMLNAME = "familyName", XMLREF = 1);

Property DateOfBirth As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfBirth", XMLREF = 1);

Property Sex As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,I,M,N", XMLNAME = "sex", XMLREF = 1);

Property DateOfBirthAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfBirthAccuracyIndicator", XMLREF = 1);

Property DateOfDeath As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfDeath", XMLREF = 1);

Property DateOfDeathAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfDeathAccuracyIndicator", XMLREF = 1);

Property ServiceMessages As HS.AU.Types.HI.ServiceMessagesType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "serviceMessages", XMLREF = 1);

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.SearchIHIResult.AdditionalInfo"</Subscript>
</Data>
<Data name="SearchIHIResultDefaultData">
<Subscript>"SearchIHIResult"</Subscript>
<Value name="1">
<Value>IHINumber</Value>
</Value>
<Value name="2">
<Value>MedicareCardNumber</Value>
</Value>
<Value name="3">
<Value>MedicareIRN</Value>
</Value>
<Value name="4">
<Value>DVAFileNumber</Value>
</Value>
<Value name="5">
<Value>IHIRecordStatus</Value>
</Value>
<Value name="6">
<Value>IHIStatus</Value>
</Value>
<Value name="7">
<Value>GivenName</Value>
</Value>
<Value name="8">
<Value>FamilyName</Value>
</Value>
<Value name="9">
<Value>DateOfBirth</Value>
</Value>
<Value name="10">
<Value>Sex</Value>
</Value>
<Value name="11">
<Value>DateOfBirthAccuracyIndicator</Value>
</Value>
<Value name="12">
<Value>DateOfDeath</Value>
</Value>
<Value name="13">
<Value>DateOfDeathAccuracyIndicator</Value>
</Value>
<Value name="14">
<Value>ServiceMessages</Value>
</Value>
</Data>
<DefaultData>SearchIHIResultDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
