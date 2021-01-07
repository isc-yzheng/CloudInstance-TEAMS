Class HS.Types.IHE.XDSb.SerialExternalIdentifier Extends (%SerialObject, %XML.Adaptor)
{

/// If XMLIGNORENULL is set = "inputonly", then both missing tags in the XML and empty
/// strings are input as "".  Output of "" and $c(0) are for XMLIGNORENULL = 0:
/// $c(0) is output as an empty tag (i.e. &lt;tag&gt;&lt;/tag&gt;) and "" is output as no tag.<br><br>
Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

Property IID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property Value As %String(MAXLEN = 256);

Storage Default
{
<Data name="SerialExternalIdentifierState">
<Value name="1">
<Value>IID</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
</Data>
<State>SerialExternalIdentifierState</State>
<StreamLocation>^HS.Types.I3C1E.SerialExterEB19S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
