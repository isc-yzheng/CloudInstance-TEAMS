Class HS.AU.Message.CommonRequest Extends Ens.Request
{

/// If XMLIGNORENULL is set = "inputonly", then both missing tags in the XML and empty
/// strings are input as "".  Output of "" and $c(0) are for XMLIGNORENULL = 0:
/// $c(0) is output as an empty tag (i.e. &lt;tag&gt;&lt;/tag&gt;) and "" is output as no tag.<br><br>
Parameter XMLIGNORENULL As STRING = "inputonly";

/// Additional request information
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

/// Contains SAML user / rhio / token 
Property SAMLData As HS.IHE.XUA.SAMLData;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.CommonRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="CommonRequestDefaultData">
<Subscript>"CommonRequest"</Subscript>
<Value name="1">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>CommonRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
