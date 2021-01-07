Class HS.AU.Types.HI.IHINumberStatusGroupType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0";

Parameter XMLNAME = "ihiNumberStatusGroup";

Property IHINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", XMLNAME = "ihiNumber", XMLREF = 1) [ Required ];

Property IHIRecordStatus As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", VALUELIST = ",Provisional,Unverified,Verified", XMLNAME = "ihiRecordStatus", XMLREF = 1) [ Required ];

Property IHIStatus As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", VALUELIST = ",Active,Deceased,Expired,Resolved,Retired", XMLNAME = "ihiStatus", XMLREF = 1) [ Required ];

Storage Default
{
<Data name="IHINumberStatusGroupTypeState">
<Value name="1">
<Value>IHINumber</Value>
</Value>
<Value name="2">
<Value>IHIRecordStatus</Value>
</Value>
<Value name="3">
<Value>IHIStatus</Value>
</Value>
</Data>
<State>IHINumberStatusGroupTypeState</State>
<StreamLocation>^HS.AU.Type3554.IHINumberSt7B0DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
