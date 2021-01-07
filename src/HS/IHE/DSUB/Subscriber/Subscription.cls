Class HS.IHE.DSUB.Subscriber.Subscription Extends (%Persistent, HS.Types.IHE.DSUB.Subscription, HS.Util.CopyFrom)
{

Property CancellationAddress As %String(MAXLEN = "") [ Required ];

Index PatientTerminationIndex On (PatientID, TerminationTime);

Index CancellationAddressIndex On CancellationAddress [ Unique ];

ClassMethod PatientIDForSubscriptionURL(pSubscriptionURL As %String) As %String
{
	&sql(select PatientID into :tPatientID from Subscription where CancellationAddress=:pSubscriptionURL)
	Quit $S(SQLCODE:"",1:tPatientID)
}

ClassMethod SubscriptionForURL(pSubscriptionURL As %String) As %String
{
	&sql(select ID into :tID from Subscription where CancellationAddress=:pSubscriptionURL)
	Quit $S(SQLCODE:"",1:..%OpenId(tID))
}

/// Subscriptions for pPatientID = ID^^^&oid&ISO where pTerminationTime = now 
Query SubscriptionsForPatient(pPatientID As %String, pTerminationTime As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Subscription
 WHERE (PatientID = :pPatientID AND ((TerminationTime is null) or TerminationTime>:pTerminationTime))
}

Storage Default
{
<Data name="SubscriptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CancellationAddress</Value>
</Value>
<Value name="3">
<Value>Topic</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>TerminationTime</Value>
</Value>
<Value name="6">
<Value>SubscriptionID</Value>
</Value>
<Value name="7">
<Value>FilterItems</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>RecipientAddress</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.DSUB.SC158.SubscriptionD</DataLocation>
<DefaultData>SubscriptionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.DSUB.SC158.SubscriptionD</IdLocation>
<IndexLocation>^HS.IHE.DSUB.SC158.SubscriptionI</IndexLocation>
<StreamLocation>^HS.IHE.DSUB.SC158.SubscriptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
