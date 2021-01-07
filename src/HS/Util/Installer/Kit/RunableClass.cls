Class HS.Util.Installer.Kit.RunableClass Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "Item";

Property Class As %String(MAXLEN = 255, XMLPROJECTION = "ATTRIBUTE");

Property When As %String(MAXLEN = 255, XMLPROJECTION = "ATTRIBUTE");

Property Method As %String(MAXLEN = 255, XMLPROJECTION = "ATTRIBUTE");

Property Arguments As list Of %String(MAXLEN = 255, XMLNAME = "Argument", XMLPROJECTION = "ELEMENT");

Property Options As list Of %String(MAXLEN = 255, XMLNAME = "Options", XMLPROJECTION = "ELEMENT");

/// Alternate Namespace (allows setting to values like HSLIB) which will not move code to upper namespace
Property Namespace As %String(MAXLEN = 255, XMLPROJECTION = "ATTRIBUTE");

}
