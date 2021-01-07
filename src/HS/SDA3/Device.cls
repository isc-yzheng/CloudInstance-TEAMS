/// Class to represent device for MU3 UDI requirements
Class HS.SDA3.Device Extends HS.SDA3.DataType
{

Property Extension As HS.Local.SDA3.DeviceExtension;

/// Coded value for device type (e.g. implantable pacemaker)
Property Device As HS.SDA3.CodeTableDetail.Device;

/// Root of Unique Device Identifier, typically FDA OID
Property UDIRoot As %String;

/// Extension of Unique Device Identifier, a globally unique string that identifies device
Property UDIExtension As %String;

/// Assigning Authority for Unique Device Identifier, typically FDA
Property UDIAssigningAuthority As %String;

Storage Default
{
<Data name="DeviceState">
<Subscript>"Device"</Subscript>
<Value name="1">
<Value>Extension</Value>
</Value>
<Value name="2">
<Value>Device</Value>
</Value>
<Value name="3">
<Value>UDIRoot</Value>
</Value>
<Value name="4">
<Value>UDIExtension</Value>
</Value>
<Value name="5">
<Value>UDIAssigningAuthority</Value>
</Value>
</Data>
<State>DeviceState</State>
<Type>%Storage.Serial</Type>
}

}
