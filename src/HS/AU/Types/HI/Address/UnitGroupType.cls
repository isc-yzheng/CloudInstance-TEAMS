Class HS.AU.Types.HI.Address.UnitGroupType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property UnitType As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",ANT,APT,ATM,BBQ,BTSD,BLDG,BNGW,CAGE,CARP,CARS,CLUB,COOL,CTGE,DUP,FY,F,GRGE,HALL,HSE,KSK,LSE,LBBY,LOFT,LOT,MSNT,MB,OFF,PTHS,RESV,RM,SHED,SHOP,SIGN,SITE,SL,STOR,STR,STU,SUBS,SE,TNCY,TWR,TNHS,U,VLLA,WARD,WE,WKSH", XMLNAME = "unitType", XMLREF = 1);

Property UnitNumber As %String(MAXLEN = 6, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "unitNumber", XMLREF = 1);

Storage Default
{
<Data name="UnitGroupTypeState">
<Value name="1">
<Value>UnitType</Value>
</Value>
<Value name="2">
<Value>UnitNumber</Value>
</Value>
</Data>
<State>UnitGroupTypeState</State>
<StreamLocation>^HS.AU.Types.H2A5.UnitGroupTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
