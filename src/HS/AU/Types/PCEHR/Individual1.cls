Class HS.AU.Types.PCEHR.Individual1 Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter XMLNAME = "individual";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "individual";

Property IHINumber As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "ihiNumber", XMLREF = 1);

Property MedicareCardNumber As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "medicareCardNumber", XMLREF = 1);

Property MedicareIRN As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "medicareIRN", XMLREF = 1);

Property DVAFileNumber As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "dvaFileNumber", XMLREF = 1);

Property MilitaryHealthNumber As %String(MAXLEN = "", REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "militaryHealthNumber", XMLREF = 1);

Property IHIRecordStatus As %String(VALUELIST = ",Verified,Unverified", XMLNAME = "ihiRecordStatus");

Property IHIStatus As %String(VALUELIST = ",Active,Deceased,Retired,Resolved,Expired", XMLNAME = "ihiStatus");

Property DateOfBirth As %Date(XMLNAME = "dateOfBirth");

Property DateAccuracyIndicatorType As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", VALUELIST = ",AAA,AAE,AAU,AEA,AEE,AEU,AUA,AUE,AUU,EAA,EAE,EAU,EEA,EEE,EEU,EUA,EUE,EUU,UAA,UAE,UAU,UEA,UEE,UEU,UUA,UUE,UUU", XMLNAME = "dateAccuracyIndicatorType", XMLREF = 1);

Property Sex As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", VALUELIST = ",M,F,I,N", XMLNAME = "sex", XMLREF = 1);

Property Name As HS.AU.Types.PCEHR.NameType(XMLNAME = "name");

Storage Default
{
<Data name="Individual1State">
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
<Value>MilitaryHealthNumber</Value>
</Value>
<Value name="6">
<Value>IHIRecordStatus</Value>
</Value>
<Value name="7">
<Value>IHIStatus</Value>
</Value>
<Value name="8">
<Value>DateOfBirth</Value>
</Value>
<Value name="9">
<Value>DateAccuracyIndicatorType</Value>
</Value>
<Value name="10">
<Value>Sex</Value>
</Value>
<Value name="11">
<Value>Name</Value>
</Value>
</Data>
<State>Individual1State</State>
<StreamLocation>^HS.AU.Types.PCEHR.Individual1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
