/// This class is defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br>
/// The class name is derived from the type definition in CommonQualifiedIdentifier.xsd.
Class HS.AU.HI.QualifiedId Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/QualifiedIdentifier/3.0";

Parameter XMLPREFIX = "qid";

Property Qualifier As %xsd.anyURI(XMLNAME = "qualifier") [ Required ];

Property ID As %String(MAXLEN = "", XMLNAME = "id") [ Required ];

}
