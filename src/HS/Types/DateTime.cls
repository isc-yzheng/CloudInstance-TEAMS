/// *** DEPRECATED *** this class is deprecated as of 2018.1
Class HS.Types.DateTime Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property DateTime As %TimeStamp;

Property Date As %Date(XMLPROJECTION = "NONE") [ Transient ];

Property Time As %Time(XMLPROJECTION = "NONE") [ Transient ];

Property TimezoneOffset As %String [ InitialExpression = {$ZTIMEZONE} ];

Storage Default
{
<Data name="DateTimeState">
<Value name="1">
<Value>DateTime</Value>
</Value>
<Value name="2">
<Value>TimezoneOffset</Value>
</Value>
</Data>
<State>DateTimeState</State>
<StreamLocation>^HS.Types.DateTimeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
