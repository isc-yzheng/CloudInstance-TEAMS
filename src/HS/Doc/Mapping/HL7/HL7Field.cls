Class HS.Doc.Mapping.HL7.HL7Field Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter NAMESPACE = "http://www.intersystems.com/healthshare/mapping";

Parameter XMLTYPE = "HL7Path";

Property structure As %String(XMLPROJECTION = "ATTRIBUTE");

Property Number As %String;

Property Name As %String(MAXLEN = 500);

Property Note As %String(MAXLEN = 4000);

}
