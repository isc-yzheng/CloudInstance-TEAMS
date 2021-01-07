/// Created from: C:\InterSystems\esignature.xsd
Class HS.AU.SMD.PersonNameType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/cdaPackage/xsd/eSignature/2012";

Parameter XMLNAME = "PersonNameType";

Parameter XMLSEQUENCE = 1;

Property NameTitle As list Of %String(MAXLEN = "", XMLNAME = "nameTitle", XMLPROJECTION = "ELEMENT");

Property GivenName As list Of %String(MAXLEN = "", XMLNAME = "givenName", XMLPROJECTION = "ELEMENT");

Property FamilyName As %String(MAXLEN = "", XMLNAME = "familyName") [ Required ];

Property NameSuffix As list Of %String(MAXLEN = "", XMLNAME = "nameSuffix", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="PersonNameTypeState">
<Value name="1">
<Value>NameTitle</Value>
</Value>
<Value name="2">
<Value>GivenName</Value>
</Value>
<Value name="3">
<Value>FamilyName</Value>
</Value>
<Value name="4">
<Value>NameSuffix</Value>
</Value>
</Data>
<State>PersonNameTypeState</State>
<StreamLocation>^HS.AU.SMD.PersonNameTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
