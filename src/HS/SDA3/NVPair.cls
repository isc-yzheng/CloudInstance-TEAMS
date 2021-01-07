/// Generic name-value pair object for inclusion in SDA3 objects<br>
/// NVPair appears in the SDA as a list property (CustomPairs) of every class<br>
/// that extends HS.SDA3.SuperClass. For every SDA3 class corresponding to a<br>
/// streamlet type except CustomObject, the CustomPairs are loaded into the<br>
/// Viewer Cache as web.SDA3.NVPairs. See HS.SDA3.SuperClass:CustomPairs for<br>
/// more info. See HS.SDA3.CustomObject:CustomPairs for information on how<br>
/// CustomObject CustomPairs get loaded into the Viewer Cache. For SDA3 classes<br>
/// that extend SuperClass but do not correspond to streamlet types,<br>
/// CustomPairs is not loaded into the Viewer Cache, with one exception:<br>
/// HS.SDA3.SupportContact. Though not a streamlet type, SupportContacts of a<br>
/// Patient are inserted into the Viewer Cache as NVPairs with InfoType="NOK".
Class HS.SDA3.NVPair Extends HS.SDA3.DataType
{

/// The name of the property this NVPair represents<br>
/// Ex: "Status"
Property Name As %String;

/// The value of the property this NVPair represents<br>
/// Ex: "Active"
Property Value As %String(MAXLEN = "");

Storage Default
{
<Data name="NVPairState">
<Subscript>"NVPair"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
</Data>
<State>NVPairState</State>
<Type>%Storage.Serial</Type>
}

}
