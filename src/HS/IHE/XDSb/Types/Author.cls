Class HS.IHE.XDSb.Types.Author Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property AuthorPerson As %String(MAXLEN = "");

Property AuthorInstitution As list Of HS.IHE.XDSb.Types.SlotValue(XMLITEMNAME = "Value");

Property AuthorRole As list Of HS.IHE.XDSb.Types.SlotValue(XMLITEMNAME = "Value");

Property AuthorSpecialty As list Of HS.IHE.XDSb.Types.SlotValue(XMLITEMNAME = "Value");

// Added for XDR Direct Support -- Contains the sender email address of a Direct XDR Message

Property AuthorTelecommunication As list Of HS.IHE.XDSb.Types.SlotValue(XMLITEMNAME = "Value");

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
</Data>
<State>AuthorState</State>
<StreamLocation>^HS.IHE.XDSb.Types.AuthorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
