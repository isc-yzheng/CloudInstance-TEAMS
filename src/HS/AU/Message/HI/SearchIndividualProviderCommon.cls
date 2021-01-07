Class HS.AU.Message.HI.SearchIndividualProviderCommon Extends %XML.Adaptor [ Abstract ]
{

Parameter XMLTYPE = "SearchIndividualProviderCommon";

Property HPIINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/ProviderCoreElements/5.0.0", XMLNAME = "hpiiNumber", XMLREF = 1);

Property RegistrationId As %String(MAXLEN = 20, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/ProviderType/5.0.0", XMLNAME = "RegistrationId", XMLREF = 1);

Property FamilyName As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", TRUNCATE = 1, XMLNAME = "familyName", XMLREF = 1);

Property OnlyNameIndicator As %Boolean(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/IndividualName/5.0.0", XMLNAME = "onlyNameIndicator", XMLREF = 1);

Property GivenName As list Of %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", TRUNCATE = 1, XMLNAME = "givenName", XMLPROJECTION = "ELEMENTREF", XMLREF = 1);

Property DateOfBirth As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/PersonalDetails/5.0.0", XMLNAME = "dateOfBirth", XMLREF = 1);

Property Sex As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,I,M,N", XMLNAME = "sex", XMLREF = 1);

Property State As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",ACT,NSW,NT,QLD,SA,TAS,VIC,WA", XMLNAME = "state", XMLREF = 1);

Property Postcode As %String(MAXLEN = 4, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "postcode", XMLREF = 1);

Property SearchAustralianAddress As HS.AU.Message.HI.Address.SearchAustralianAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/5.0.0", XMLNAME = "searchAustralianAddress", XMLREF = 1);

Property SearchInternationalAddress As HS.AU.Types.HI.Address.InternationalAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/5.0.0", XMLNAME = "searchInternationalAddress", XMLREF = 1);

}
