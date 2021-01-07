Class HS.Util.Status.Metadata.AbstractMessageContainer Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/util/status";

Property Name As %String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property ViolationMessages As list Of HS.Util.Status.Metadata.ViolationMessage(XMLNAME = "ViolationMessage", XMLPROJECTION = "ELEMENT");

}
