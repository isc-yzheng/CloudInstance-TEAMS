/// Created from: c:/users/spisani/documents/aacompleted pocs or customer work/nehta/pcehr/pcehr_schemas-20120417_tss_1.1-withmod/schema/common/pcehr_commontypes.xsd
Class HS.AU.Types.PCEHR.NameType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLNAME = "nameType";

Parameter XMLSEQUENCE = 1;

Property NameTitle As %String(MAXLEN = 40, XMLNAME = "nameTitle");

Property FamilyName As %String(MAXLEN = 40, MINLEN = 1, XMLNAME = "familyName");

Property GivenName As list Of %String(MAXLEN = 40, MINLEN = 1, XMLNAME = "givenName", XMLPROJECTION = "ELEMENT");

Property NameSuffix As %String(MAXLEN = 40, XMLNAME = "nameSuffix");

Property NameAlias As %String(MAXLEN = 40, XMLNAME = "nameAlias");

Storage Default
{
<Data name="NameTypeState">
<Value name="1">
<Value>NameTitle</Value>
</Value>
<Value name="2">
<Value>FamilyName</Value>
</Value>
<Value name="3">
<Value>GivenName</Value>
</Value>
<Value name="4">
<Value>NameSuffix</Value>
</Value>
<Value name="5">
<Value>NameAlias</Value>
</Value>
</Data>
<State>NameTypeState</State>
<StreamLocation>^HS.AU.Types.PCEHR.NameTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
