Class HS.IHE.XDSb.Types.MetadataLevelHeader Extends %SOAP.Header
{

Parameter NAMESPACE = "urn:direct:addressing";

Parameter XMLTYPE = "metadata-level";

Property Level As %String(MAXLEN = "", XMLPROJECTION = "content");

}
