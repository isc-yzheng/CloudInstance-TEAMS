/// Created from: /schema/common/pcehr_commontypes.xsd
Class HS.AU.PCEHR.ProductType Extends %SOAP.Header
{

/// The header element name and key name for HeadersIn and HeadersOut arrays.
Parameter XMLNAME = "product";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLFORMAT = "literal";

Parameter XMLPREFIX = "cce";

Property Vendor As %String(MAXLEN = "", XMLNAME = "vendor") [ Required ];

Property ProductName As %String(MAXLEN = "", XMLNAME = "productName") [ Required ];

Property ProductVersion As %String(MAXLEN = "", XMLNAME = "productVersion") [ Required ];

Property Platform As %String(MAXLEN = "", XMLNAME = "platform") [ Required ];

}
