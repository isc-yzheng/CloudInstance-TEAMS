/// This SOAP header is defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br>
/// The class name is derived from the type definition in CommonCoreElements.xsd.<br>
/// The SOAP header element name is "product".<br>
/// See HS.AU.HI.Headers class for adding and validating headers.
Class HS.AU.HI.ProductType Extends %SOAP.Header
{

/// The header element name and key name for HeadersIn and HeadersOut arrays.
Parameter XMLNAME = "product";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0";

Parameter XMLFORMAT = "literal";

Parameter XMLPREFIX = "cce";

Property Vendor As HS.AU.HI.QualifiedId(XMLNAME = "vendor") [ Required ];

Property ProductName As %String(MAXLEN = "", XMLNAME = "productName") [ Required ];

Property ProductVersion As %String(MAXLEN = "", XMLNAME = "productVersion") [ Required ];

Property Platform As %String(MAXLEN = "", XMLNAME = "platform") [ Required ];

}
