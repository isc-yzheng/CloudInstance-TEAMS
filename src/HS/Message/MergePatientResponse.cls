Class HS.Message.MergePatientResponse Extends HS.Message.RLSResponse [ ClassType = persistent, ProcedureBlock ]
{

Property PriorMPIID As %String;

Property TargetMPIID As %String;

Property LinkedMPIIDBecame As %String;

Storage Default
{
<Data name="MergePatientResponseDefaultData">
<Subscript>"MergePatientResponse"</Subscript>
<Value name="1">
<Value>PriorMPIID</Value>
</Value>
<Value name="2">
<Value>TargetMPIID</Value>
</Value>
<Value name="3">
<Value>LinkedMPIIDBecame</Value>
</Value>
</Data>
<DefaultData>MergePatientResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
