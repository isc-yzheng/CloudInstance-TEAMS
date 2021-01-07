/// 
Class HS.AU.PCEHR.HeaderType Extends %SOAP.Header [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLFORMAT = "literal";

Parameter XMLNAME = "PCEHRHeader";

Parameter XMLSEQUENCE = 1;

Property User As HS.AU.PCEHR.User(XMLNAME = "User") [ Required, SqlFieldName = _User ];

Property IHINumber As HS.AU.PCEHR.IHINumber(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "ihiNumber", XMLREF = 1);

Property ProductType As HS.AU.PCEHR.ProductType(XMLNAME = "productType") [ Required ];

Property ClientSystemType As %String(MAXLEN = "", VALUELIST = ",CIS,CSP,CRP,HI,Medicare,CPP,CCP,Other", XMLNAME = "clientSystemType") [ Required ];

Property AccessingOrganisation As HS.AU.PCEHR.AccessingOrganisation(XMLNAME = "accessingOrganisation");

}
