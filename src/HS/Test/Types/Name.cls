/// Person Name
Class HS.Test.Types.Name Extends HS.Test.Types.Base
{

Property Last As %String(MAXLEN = "", XMLNAME = "last", XMLPROJECTION = "ATTRIBUTE");

Property First As %String(MAXLEN = "", XMLNAME = "first", XMLPROJECTION = "ATTRIBUTE");

Property Middle As %String(MAXLEN = "", XMLNAME = "middle", XMLPROJECTION = "ATTRIBUTE");

Property Suffix As HS.Test.Types.Value;

Property Prefix As HS.Test.Types.Value;

}
