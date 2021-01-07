Class HS.AU.Types.HI.IndividualHealthcareIdentityType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property DateOfBirth As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfBirth", XMLREF = 1);

Property DateOfBirthAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfBirthAccuracyIndicator", XMLREF = 1);

Property Sex As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,I,M,N", XMLNAME = "sex", XMLREF = 1);

Property BirthPlurality As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",1,2,3,4,5,6,8,9", XMLNAME = "birthPlurality", XMLREF = 1);

Property BirthOrder As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",1,2,3,4,5,6,8,9", XMLNAME = "birthOrder", XMLREF = 1);

Property DateOfDeath As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfDeath", XMLREF = 1);

Property DateOfDeathAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfDeathAccuracyIndicator", XMLREF = 1);

Property SourceOfDeathNotification As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",H", XMLNAME = "sourceOfDeathNotification", XMLREF = 1);

Storage Default
{
<Data name="IndividualHealthcareIdentityTypeState">
<Value name="1">
<Value>DateOfBirth</Value>
</Value>
<Value name="2">
<Value>DateOfBirthAccuracyIndicator</Value>
</Value>
<Value name="3">
<Value>Sex</Value>
</Value>
<Value name="4">
<Value>BirthPlurality</Value>
</Value>
<Value name="5">
<Value>BirthOrder</Value>
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
</Data>
<State>IndividualHealthcareIdentityTypeState</State>
<StreamLocation>^HS.AU.Type3554.IndividualHF3F7S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
