Class HS.IHE.XDSb.Types.AddressBlockHeader Extends %SOAP.Header
{

Parameter NAMESPACE = "urn:direct:addressing";

Parameter XMLTYPE = "addressBlock";

Property role As %String(MAXLEN = "", XMLPROJECTION = "attribute") [ InitialExpression = "urn:direct:addressing:destination" ];

Property relay As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 1 ];

Property from As %String(MAXLEN = "", XMLPROJECTION = "element");

Property to As list Of %String(MAXLEN = "", XMLPROJECTION = "element");

Property Level As %String(MAXLEN = "", XMLNAME = "metadata-level", XMLPROJECTION = "element");

Property xDirectFinalDestinationDelivery As %String(MAXLEN = "", XMLNAME = "x-direct-final-destination-delivery", XMLPROJECTION = "element");

Property xDirectFinalDestinationDeliveryUpper As %String(MAXLEN = "", XMLNAME = "X-DIRECT-FINAL-DESTINATION-DELIVERY", XMLPROJECTION = "element");

}
