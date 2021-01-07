Class HS.AU.Types.PCEHR.Individual Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter XMLNAME = "individual";

Parameter XMLSEQUENCE = 1;

Property MedicareCardNumber As %String(MAXLEN = 10, MINLEN = 10, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "medicareCardNumber", XMLREF = 1);

Property MedicareIRN As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "medicareIRN", XMLREF = 1);

Property DVAFileNumber As %String(MAXLEN = 9, MINLEN = 2, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "dvaFileNumber", XMLREF = 1);

Property MilitaryHealthNumber As %String(MAXLEN = "", REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "militaryHealthNumber", XMLREF = 1);

Property DateOfBirth As %Date(XMLNAME = "dateOfBirth");

Property Sex As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", VALUELIST = ",M,F,I,N", XMLNAME = "sex", XMLREF = 1);

Property Name As HS.AU.Types.PCEHR.NameType(XMLNAME = "name");

Storage Default
{
<Data name="IndividualState">
<Value name="1">
<Value>MedicareCardNumber</Value>
</Value>
<Value name="2">
<Value>MedicareIRN</Value>
</Value>
<Value name="3">
<Value>DVAFileNumber</Value>
</Value>
<Value name="4">
<Value>MilitaryHealthNumber</Value>
</Value>
<Value name="5">
<Value>DateOfBirth</Value>
</Value>
<Value name="6">
<Value>Sex</Value>
</Value>
<Value name="7">
<Value>Name</Value>
</Value>
</Data>
<State>IndividualState</State>
<StreamLocation>^HS.AU.Types.PCEHR.IndividualS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
