Class HS.AU.Types.HI.Address.InternationalAddressType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0";

Property InternationalStateProvince As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "internationalStateProvince", XMLREF = 1);

Property Country As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",1601,7201,3201,4101,3101,9201,8401,8402,8201,1602,7202,8403,1101,1603,1199,2301,7203,8404,4201,7101,8405,3301,2302,8301,9101,8101,7102,8202,3202,9202,8203,1604,5201,3203,9102,5101,9203,5102,9103,8102,9104,8406,9105,9106,2101,8204,1605,6101,8205,9204,9107,9108,1501,8302,9111,3204,8407,3205,3302,2401,9205,8408,8411,5206,8206,4102,8303,2102,9112,9206,3303,9207,2402,8207,1502,2403,3206,2303,8208,1503,9113,9114,4202,7204,2304,9115,3102,3207,2404,8412,8413,1401,8304,9116,9117,8211,8414,3103,8305,6102,3304,2405,7103,5202,4203,4204,2103,4205,3104,8415,6201,4206,7205,9208,1402,6202,6203,4207,7206,5103,3305,4208,9211,9118,4103,2305,3306,2306,6103,9212,9213,5203,7104,9121,3105,1403,8416,9122,9214,9215,8306,1404,3208,2307,6104,8417,4104,9216,9217,1405,7105,2308,8418,1301,1201,8307,9123,9124,1504,1102,4199,2104,1406,2406,4211,OTHE,7106,1407,8308,1302,8212,8213,5204,3307,1599,3106,8421,4212,1606,2201,9218,3211,1607,3308,9221,1505,1506,3107,9125,4213,2105,9126,9223,9127,5205,3311,3212,1303,9224,9225,8299,9299,3108,7107,9222,8422,8423,8103,8424,4105,8214,9226,2407,2311,4214,6105,7207,9227,5104,9128,1507,1508,8425,4106,4215,7208,8426,1511,9228,3312,4216,8104,8215,7211,1304,8216,5105,8427,8428,2106,1512,4107,4217,3213,9231,9232", XMLNAME = "country", XMLREF = 1);

Property InternationalPostcode As %String(MAXLEN = 10, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "internationalPostcode", XMLREF = 1);

Property InternationalAddressLine As %String(MAXLEN = 80, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "internationalAddressLine", XMLREF = 1);

Storage Default
{
<Data name="InternationalAddressTypeState">
<Value name="1">
<Value>InternationalStateProvince</Value>
</Value>
<Value name="2">
<Value>Country</Value>
</Value>
<Value name="3">
<Value>InternationalPostcode</Value>
</Value>
<Value name="4">
<Value>InternationalAddressLine</Value>
</Value>
</Data>
<State>InternationalAddressTypeState</State>
<StreamLocation>^HS.AU.Types2A5.InternationA5A7S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
