Class HS.Message.AddUpdateHubEncounterInfo Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Property EncounterType As %String;

Property EncounterNumber As %String(MAXLEN = 220);

Property IdentifiedClinicians As list Of HS.Types.IdentifiedClinician;

Property FromTime As HS.Types.TimeStamp;

Property ToTime As HS.Types.TimeStamp;

Storage Default
{
<Data name="AddUpdateHubEncounterInfoState">
<Value name="1">
<Value>EncounterType</Value>
</Value>
<Value name="2">
<Value>EncounterNumber</Value>
</Value>
<Value name="3">
<Value>IdentifiedClinicians</Value>
</Value>
<Value name="4">
<Value>FromTime</Value>
</Value>
<Value name="5">
<Value>ToTime</Value>
</Value>
</Data>
<State>AddUpdateHubEncounterInfoState</State>
<StreamLocation>^HS.Message.AddUpdateHuF83AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
