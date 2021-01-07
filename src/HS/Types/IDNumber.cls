/// Identification numbers with assigning authority
Class HS.Types.IDNumber Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// ID number
Property Number As %String(TRUNCATE = 1);

/// Organization that assigned the number
Property AssigningAuthority As %String;

Storage Default
{
<Data name="IDNumberState">
<Value name="1">
<Value>Number</Value>
</Value>
<Value name="2">
<Value>AssigningAuthority</Value>
</Value>
</Data>
<State>IDNumberState</State>
<StreamLocation>^HS.Types.IDNumberS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
