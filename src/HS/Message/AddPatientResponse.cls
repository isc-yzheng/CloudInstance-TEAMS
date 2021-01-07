Class HS.Message.AddPatientResponse Extends HS.Message.RLSResponse [ ClassType = persistent, ProcedureBlock ]
{

Property PatientId As %String(MAXLEN = 100);

/// MPI Update flag
Property MPIUpdateFlag As %String(DISPLAYLIST = ",No Change,Added,Updated,Deleted", VALUELIST = ",0,1,2,3");

Storage Default
{
<Data name="AddPatientResponseDefaultData">
<Subscript>"AddPatientResponse"</Subscript>
<Value name="1">
<Value>PatientId</Value>
</Value>
<Value name="2">
<Value>MPIUpdateFlag</Value>
</Value>
</Data>
<DefaultData>AddPatientResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
