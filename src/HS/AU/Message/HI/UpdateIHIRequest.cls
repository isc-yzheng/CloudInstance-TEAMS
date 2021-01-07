Class HS.AU.Message.HI.UpdateIHIRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerUpdateIHI/3.2.0";

Parameter XMLNAME = "updateIHI";

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.UpdateIHIResponse";

Property IHINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", XMLNAME = "ihiNumber", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property DateOfBirth As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfBirth", XMLREF = 1);

Property DateOfBirthAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfBirthAccuracyIndicator", XMLREF = 1);

Property Sex As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,I,M,N", XMLNAME = "sex", XMLREF = 1);

Property BirthPlurality As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",1,2,3,4,5,6,8,9", XMLNAME = "birthPlurality", XMLREF = 1);

Property BirthOrder As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",1,2,3,4,5,6,8,9", XMLNAME = "birthOrder", XMLREF = 1);

Property DateOfDeath As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfDeath", XMLREF = 1);

Property DateOfDeathAccuracyIndicator As %String(MAXLEN = 3, MINLEN = 3, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateOfDeathAccuracyIndicator", XMLREF = 1);

Property SourceOfDeathNotification As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", VALUELIST = ",H", XMLNAME = "sourceOfDeathNotification", XMLREF = 1);

Property ElectronicCommunication As list Of HS.AU.Types.HI.ElectronicCommunicationType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ElectronicCommunication/3.0", XMLNAME = "electronicCommunication", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property Name As list Of HS.AU.Types.HI.NameType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Name/3.2.0", XMLNAME = "name", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property NameUpdateGroup As list Of HS.AU.Types.HI.NameUpdateGroupType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Name/3.2.0", XMLNAME = "nameUpdateGroup", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property Address As list Of HS.AU.Types.HI.AddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "address", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.UpdateIHIRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="UpdateIHIRequestDefaultData">
<Subscript>"UpdateIHIRequest"</Subscript>
<Value name="1">
<Value>IHINumber</Value>
</Value>
<Value name="2">
<Value>DateOfBirth</Value>
</Value>
<Value name="3">
<Value>DateOfBirthAccuracyIndicator</Value>
</Value>
<Value name="4">
<Value>Sex</Value>
</Value>
<Value name="5">
<Value>BirthPlurality</Value>
</Value>
<Value name="6">
<Value>BirthOrder</Value>
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
<Value name="10">
<Value>ElectronicCommunication</Value>
</Value>
<Value name="11">
<Value>Name</Value>
</Value>
<Value name="12">
<Value>NameUpdateGroup</Value>
</Value>
<Value name="13">
<Value>Address</Value>
</Value>
<Value name="14">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>UpdateIHIRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
