Class HS.Util.Installer.Kit.Namespace Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Type As %String(MAXLEN = 220);

Property Name As %String;

Property Template As %String(MAXLEN = 255);

Property AdditionalKit As list Of HS.Util.Installer.Kit.RunableClass(XMLNAME = "AdditionalKit", XMLPROJECTION = "ELEMENT");

Property PostInstallKit As list Of HS.Util.Installer.Kit.RunableClass(XMLNAME = "PostInstallKit", XMLPROJECTION = "ELEMENT");

Property Options As list Of %String(MAXLEN = 255, XMLNAME = "Options", XMLPROJECTION = "ELEMENT");

Property Vars As array Of %String(MAXLEN = 255);

Property Items As %String(MAXLEN = "", XMLPROJECTION = "ELEMENT");

Property BaseNamespaceTemplate As %String;

}
