Class HS.Util.Status.Metadata.Wrapper Extends (%RegisteredObject, %XML.Adaptor) [ System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/util/status";

Parameter XMLNAME = "Metadata";

Property Elements As list Of HS.Util.Status.Metadata.AbstractMessageContainer(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "SUBSTITUTIONGROUP");

}
