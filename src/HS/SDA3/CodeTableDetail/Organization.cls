/// In the Viewer Cache, Organizations are matched on Code and<br>
/// SDACodingStandard only. Other properties stored in the Viewer Cache,<br>
/// including Description, will be updated if they are different in the inbound<br>
/// Organization versus the matched CTHospital.
Class HS.SDA3.CodeTableDetail.Organization Extends HS.SDA3.CodeTableDetail.OrganizationA
{

/// VIEWERLIB: Not stored
Property MedicalDirector As HS.SDA3.CodeTableDetail.CareProvider;

Storage Default
{
<Data name="CodeTableDetailState">
<Value name="1">
<Value>SDATableName</Value>
</Value>
<Value name="2">
<Value>SDACodingStandard</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="6">
<Value>InternalReference</Value>
</Value>
<Value name="7">
<Value>EId</Value>
</Value>
<Value name="8">
<Value>ErrorStatus</Value>
</Value>
<Value name="9">
<Value>Address</Value>
</Value>
<Value name="10">
<Value>ContactInfo</Value>
</Value>
<Value name="11">
<Value>Trusts</Value>
</Value>
<Value name="12">
<Value>MedicalDirector</Value>
</Value>
<Value name="13">
<Value>Extension</Value>
</Value>
<Value name="14">
<Value>IsActive</Value>
</Value>
<Value name="15">
<Value>Identifiers</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
