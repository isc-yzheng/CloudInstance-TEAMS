Class HS.Types.IHE.XDSb.Author Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property EntryUUID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "Attribute");

Property AuthorPerson As %String(MAXLEN = "");

Property AuthorInstitution As list Of HS.Types.IHE.XDSb.SlotValue(XMLITEMNAME = "Value");

Property AuthorRole As list Of HS.Types.IHE.XDSb.SlotValue(XMLITEMNAME = "Value");

Property AuthorSpecialty As list Of HS.Types.IHE.XDSb.SlotValue(XMLITEMNAME = "Value");

// Added for XDR Direct Support -- Contains the sender email address of a Direct XDR Message

Property AuthorTelecommunication As list Of HS.Types.IHE.XDSb.SlotValue(XMLITEMNAME = "Value");

Storage Default
{
<Data name="AuthorState">
<Value name="1">
<Value>AuthorPerson</Value>
</Value>
<Value name="2">
<Value>AuthorInstitution</Value>
</Value>
<Value name="3">
<Value>AuthorRole</Value>
</Value>
<Value name="4">
<Value>AuthorSpecialty</Value>
</Value>
<Value name="5">
<Value>AuthorTelecommunication</Value>
</Value>
<Value name="6">
<Value>EntryUUID</Value>
</Value>
</Data>
<State>AuthorState</State>
<StreamLocation>^HS.Types.IHE.XDSb.AuthorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
