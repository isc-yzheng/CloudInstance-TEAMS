Class HS.AU.Types.HI.ElectronicCommunicationType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "electronicCommunicationType";

Property Medium As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/ElectronicCommunicationCore/3.0", VALUELIST = ",E,F,M,O,P,T,U", XMLNAME = "medium", XMLREF = 1);

Property Usage As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/ElectronicCommunicationCore/3.0", VALUELIST = ",A,B,P", XMLNAME = "usage", XMLREF = 1);

Property Details As %String(MAXLEN = 80, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ElectronicCommunication/3.0", XMLNAME = "details", XMLREF = 1);

Property Preferred As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,T", XMLNAME = "preferred", XMLREF = 1);

Storage Default
{
<Data name="ElectronicCommunicationTypeState">
<Value name="1">
<Value>Medium</Value>
</Value>
<Value name="2">
<Value>Usage</Value>
</Value>
<Value name="3">
<Value>Details</Value>
</Value>
<Value name="4">
<Value>Preferred</Value>
</Value>
</Data>
<State>ElectronicCommunicationTypeState</State>
<StreamLocation>^HS.AU.Type3554.ElectronicCo84AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
