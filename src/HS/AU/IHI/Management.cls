Class HS.AU.IHI.Management Extends HS.AU.HI.Management
{

Parameter XMLTYPE = "IHIManagement";

Property AssigningAuthority As %String;

/// This patient's MRN (from the above assigning authority)
Property MRN As HS.Types.MRN;

/// Facility for this patient info - use the facility as the demographics could swap back and forth given same patient at different facilities 
Property Facility As HS.Types.Facility;

/// Verified, Unverified, Provisional
Property RecordStatus As %String;

Property History As list Of HS.AU.IHI.Management.History(CLASSNAME = 1, STORAGEDEFAULT = "array");

Index MRNIndex On (MRN, AssigningAuthority, Facility) [ Data = (Number, Status, Alert), Unique ];

Storage Default
{
<Data name="ManagementDefaultData1">
<Subscript>"Management"</Subscript>
<Value name="1">
<Value>AssigningAuthority</Value>
</Value>
<Value name="2">
<Value>MRN</Value>
</Value>
<Value name="3">
<Value>Facility</Value>
</Value>
<Value name="4">
<Value>RecordStatus</Value>
</Value>
</Data>
<DefaultData>ManagementDefaultData1</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
