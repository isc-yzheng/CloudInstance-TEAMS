Class HS.Types.IHE.DSUB.SubscriptionItems Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// $XDSDocumentEntryHealthcareFacilityTypeCode
Property Item As %String(MAXLEN = 512);

/// list of 'Emergency Department^^^CodingScheme'
Property Values As list Of %String(MAXLEN = "");

Storage Default
{
<Data name="SubscriptionItemsState">
<Value name="1">
<Value>Item</Value>
</Value>
<Value name="2">
<Value>Values</Value>
</Value>
</Data>
<State>SubscriptionItemsState</State>
<StreamLocation>^HS.Types.ID0AB.Subscriptio3DE9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
