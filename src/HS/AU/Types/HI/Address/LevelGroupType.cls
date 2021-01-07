Class HS.AU.Types.HI.Address.LevelGroupType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property LevelType As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",B,FL,G,L,LG,M,OD,P,PTHS,PLF,PLZA,PDM,RT,SB,UG", XMLNAME = "levelType", XMLREF = 1);

Property LevelNumber As %String(MAXLEN = 4, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "levelNumber", XMLREF = 1);

Storage Default
{
<Data name="LevelGroupTypeState">
<Value name="1">
<Value>LevelType</Value>
</Value>
<Value name="2">
<Value>LevelNumber</Value>
</Value>
</Data>
<State>LevelGroupTypeState</State>
<StreamLocation>^HS.AU.Types2A5.LevelGroupTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
