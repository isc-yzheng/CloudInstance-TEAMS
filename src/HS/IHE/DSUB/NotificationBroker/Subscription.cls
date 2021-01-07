Class HS.IHE.DSUB.NotificationBroker.Subscription Extends (%Persistent, HS.Types.IHE.DSUB.Subscription, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property SubscriptionID As %String [ Required ];

Index SubscriptionIDIndex On SubscriptionID [ Unique ];

Index PatientTerminationIndex On (PatientID, TerminationTime);

/// where pTerminationTime is in UTC 
Query SubscriptionsForPatient(pPatientID As %String, pTerminationTime As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Subscription
 WHERE (PatientID = :pPatientID AND ((TerminationTime is null) or TerminationTime>:pTerminationTime))
}

/// It's unlikely that there are customers with existing DSUB data, but if there is data, convert it
ClassMethod Conversion()
{
	/*
	^HS.IHE.DSUB.NE69C.SubscriptionD=1
	^HS.IHE.DSUB.NE69C.SubscriptionD(1)=$lb("","","",1111,"","")
	^HS.IHE.DSUB.NE69C.SubscriptionD(1,"QueryItems",1)=$lb("","foo",$lb("bar"))
	^HS.IHE.DSUB.NE69C.SubscriptionD(2)=$lb("","","","456","","",$lb($lb($lb("foo",$lb("bar","soap")))))

	*/
	Tstart
	Set tID="" 
	For  {
		Set tID=$o(^HS.IHE.DSUB.NE69C.SubscriptionD(tID)) Quit:tID=""
		Set tItems=""
		For  {
			Set tItems=$O(^HS.IHE.DSUB.NE69C.SubscriptionD(tID,"QueryItems",tItems),1,tItem) Quit:tItems=""
			Set tNewItem=$lb($lb($lb($li(tItem,2),$li(tItem,3))))
			Set $li(^HS.IHE.DSUB.NE69C.SubscriptionD(tID),7)=tNewItem
			Kill ^HS.IHE.DSUB.NE69C.SubscriptionD(tID,"QueryItems",tItems)
			#; update querytype to be document
			Set:$lg(^HS.IHE.DSUB.NE69C.SubscriptionD(tID),8)="" $li(^HS.IHE.DSUB.NE69C.SubscriptionD(tID),8)="Document"
		}
	}
	Do ..%BuildIndices($lb("PatientTerminationIndex"))
	Tcommit
	Quit $$$OK
}

Storage Default
{
<Data name="SubscriptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecipientAddress</Value>
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
</Data>
<DataLocation>^HS.IHE.DSUB.NE69C.SubscriptionD</DataLocation>
<DefaultData>SubscriptionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.DSUB.NE69C.SubscriptionD</IdLocation>
<IndexLocation>^HS.IHE.DSUB.NE69C.SubscriptionI</IndexLocation>
<StreamLocation>^HS.IHE.DSUB.NE69C.SubscriptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
