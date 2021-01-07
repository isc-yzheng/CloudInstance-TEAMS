/// Contact information
Class HS.Types.Contact Extends (%SerialObject, %ZEN.DataModel.Adaptor, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// if OBJJOURNAL is TRUE then inserts, updates and deletes will be logged in ^OBJ.JournalT
/// if OBJJOURNAL = 2 then the entire object will also be journaled in ^OBJ.Journal
Parameter OBJJOURNAL As INTEGER [ Constraint = "0,1,2", Flags = ENUM ] = 1;

Property FirstName As %String(MAXLEN = 60);

Property LastName As %String(MAXLEN = 80);

Property Organization As %String;

Property EMail As %String;

Property Telephone As %String;

Property Role As %String;

Storage Default
{
<Data name="ContactState">
<Value name="1">
<Value>EMail</Value>
</Value>
<Value name="2">
<Value>FirstName</Value>
</Value>
<Value name="3">
<Value>LastName</Value>
</Value>
<Value name="4">
<Value>Organization</Value>
</Value>
<Value name="5">
<Value>Telephone</Value>
</Value>
<Value name="6">
<Value>Role</Value>
</Value>
</Data>
<State>ContactState</State>
<StreamLocation>^HS.Types.ContactS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
