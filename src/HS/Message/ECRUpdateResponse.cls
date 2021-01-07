Class HS.Message.ECRUpdateResponse Extends HS.Util.EnsResponse [ ClassType = persistent, ProcedureBlock ]
{

/// The patientid returned from the ECR ($lg(token,1))
Property PatientID As %String;

/// The encounterlist returned from the ECR ($lg(token,2))
Property EncounterList As %String(MAXLEN = 32000);

/// The encounterid returned from the ECR ($lg(token,3))
Property EncounterId As %String;

/// MPI Update flag
Property MPIUpdateFlag As %String(DISPLAYLIST = ",Disabled,No Change,Added,Updated,Deleted,Merged", VALUELIST = ",-1,0,1,2,3,4");

Storage Default
{
<Data name="ECRUpdateResponseDefaultData">
<Subscript>"ECRUpdateResponse"</Subscript>
<Value name="1">
<Value>Token</Value>
</Value>
<Value name="2">
<Value>MPIUpdateFlag</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>EncounterList</Value>
</Value>
<Value name="5">
<Value>EncounterId</Value>
</Value>
</Data>
<DefaultData>ECRUpdateResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
