Class HS.AU.Types.HI.NameUpdateGroupType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Name/3.2.0";

Parameter XMLNAME = "NameUpdateGroupType";

Parameter XMLSEQUENCE = 1;

Property CurrentName As HS.AU.Types.HI.CurrentNameType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Name/3.2.0", XMLNAME = "currentName", XMLREF = 1) [ Required ];

Property UpdateName As HS.AU.Types.HI.NameType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Name/3.2.0", XMLNAME = "updateName", XMLREF = 1) [ Required ];

Storage Default
{
<Data name="NameUpdateGroupTypeState">
<Value name="1">
<Value>CurrentName</Value>
</Value>
<Value name="2">
<Value>UpdateName</Value>
</Value>
</Data>
<State>NameUpdateGroupTypeState</State>
<StreamLocation>^HS.AU.Type3554.NameUpdateG21BDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
