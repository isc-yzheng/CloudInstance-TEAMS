/// Medical device to satistisfy MU3 UDI requirements
Class HS.SDA3.CodeTableDetail.Device Extends HS.SDA3.CodeTableDetail
{

Property Extension As HS.Local.SDA3.CodeTableDetail.DeviceExtension;

Parameter XMLTYPE = "DeviceCode";

Parameter XMLNAME = "Device";

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
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
