Class HS.AU.Types.HI.Address.AustralianStreetAddressType Extends (%SerialObject, %XML.Adaptor) [ CompileAfter = (HS.AU.Types.HI.Address.UnitGroupType, HS.AU.Types.HI.Address.LevelGroupType), ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0";

Parameter ELEMENTQUALIFIED = 1;

Property State As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",ACT,NSW,NT,QLD,SA,TAS,VIC,WA", XMLNAME = "state", XMLREF = 1);

Property Postcode As %String(MAXLEN = 4, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "postcode", XMLREF = 1);

Property Suburb As %String(MAXLEN = 30, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "suburb", XMLREF = 1);

Property AddressSiteName As %String(MAXLEN = 30, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "addressSiteName", XMLREF = 1);

Property UnitGroup As HS.AU.Types.HI.Address.UnitGroupType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "unitGroup", XMLREF = 1);

Property LevelGroup As HS.AU.Types.HI.Address.LevelGroupType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "levelGroup", XMLREF = 1);

Property LotNumber As %String(MAXLEN = 15, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "lotNumber", XMLREF = 1);

Property StreetNumber As %String(MAXLEN = 12, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "streetNumber", XMLREF = 1);

Property StreetName As %String(MAXLEN = 30, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "streetName", XMLREF = 1);

Property StreetType As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",ACCS,ALLY,ALWY,AMBL,ANCG,APP,ARC,ART,AVE,BASN,BCH,BEND,BLK,BWLK,BVD,BRCE,BRAE,BRK,BDGE,BDWY,BROW,BYPA,BYWY,CAUS,CTR,CNWY,CH,CIR,CLT,CCT,CRCS,CL,CLDE,CMMN,CON,CPS,CNR,CSO,CT,CTYD,COVE,CRES,CRST,CRSS,CRSG,CRD,COWY,CUWY,CDS,CTTG,DALE,DELL,DEVN,DIP,DSTR,DR,DRWY,EDGE,ELB,END,ENT,ESP,EST,EXP,EXTN,FAWY,FTRK,FITR,FLAT,FOLW,FTWY,FSHR,FORM,FWY,FRNT,FRTG,GAP,GDN,GDNS,GTE,GTES,GLD,GLEN,GRA,GRN,GRND,GR,GLY,HTS,HRD,HWY,HILL,INTG,INTN,JNC,KEY,LDG,LANE,LNWY,LEES,LINE,LINK,LT,LKT,LOOP,LWR,MALL,MNDR,MEW,MEWS,MWY,MT,NOOK,OTLK,PDE,PARK,PKLD,PKWY,PART,PASS,PATH,PHWY,PIAZ,PL,PLAT,PLZA,PKT,PNT,PORT,PROM,QUAD,QDGL,QDRT,QY,QYS,RMBL,RAMP,RNGE,RCH,RES,REST,RTT,RIDE,RDGE,RGWY,ROWY,RING,RISE,RVR,RVWY,RVRA,RD,RDS,RDSD,RDWY,RNDE,RSBL,RTY,RND,RTE,ROW,RUE,RUN,SWY,SHUN,SDNG,SLPE,SND,SPUR,SQ,STRS,SHWY,STPS,STRA,ST,STRP,SBWY,TARN,TCE,THOR,TLWY,TOP,TOR,TWRS,TRK,TRL,TRLR,TRI,TKWY,TURN,UPAS,UPR,VALE,VDCT,VIEW,VLLS,VSTA,WADE,WALK,WKWY,WAY,WHRF,WYND,YARD", XMLNAME = "streetType", XMLREF = 1);

Property StreetSuffix As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",CN,E,EX,LR,N,NE,NW,S,SE,SW,UP,W", XMLNAME = "streetSuffix", XMLREF = 1);

Storage Default
{
<Data name="AustralianStreetAddressTypeState">
<Value name="1">
<Value>State</Value>
</Value>
<Value name="2">
<Value>Postcode</Value>
</Value>
<Value name="3">
<Value>Suburb</Value>
</Value>
<Value name="4">
<Value>AddressSiteName</Value>
</Value>
<Value name="5">
<Value>UnitGroup</Value>
</Value>
<Value name="6">
<Value>LevelGroup</Value>
</Value>
<Value name="7">
<Value>LotNumber</Value>
</Value>
<Value name="8">
<Value>StreetNumber</Value>
</Value>
<Value name="9">
<Value>StreetName</Value>
</Value>
<Value name="10">
<Value>StreetType</Value>
</Value>
<Value name="11">
<Value>StreetSuffix</Value>
</Value>
</Data>
<State>AustralianStreetAddressTypeState</State>
<StreamLocation>^HS.AU.Types2A5.AustralianS4E87S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
