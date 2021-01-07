/// Map OID to facility / endpoint
Class HS.IHE.PIXv3.Manager.DomainsOfInterest Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Code for OID of the Consumer interested in notification ie PIXv3ConsumerDevice
Property ConsumerID As %String(MAXLEN = "") [ Required ];

/// Code for OID of the Domain as in External, CGH, etc
Property Domains As list Of %String(STORAGEDEFAULT = "array");

/// If true, any domain update will be sent and the Domains list will be ignored
Property AllDomains As %Boolean [ InitialExpression = 1 ];

Index DomainsIndex On Domains(ELEMENTS);

Index AllDomainsIndex On AllDomains [ Type = bitmap ];

ClassMethod ConsumersToNotify(pDomain As %String, ByRef pConsumerOIDs As %String) As %Status
{
	&sql(DECLARE curConsumers CURSOR FOR 
			select ConsumerID into :tID FROM DomainsOfInterest WHERE AllDomains=1)
	&sql(OPEN curConsumers)
	for  {
		&sql(FETCH curConsumers)
		Quit:SQLCODE
		Set pConsumerOIDs(tID,pDomain)=""
	}
	&sql(CLOSE curConsumers)
	&sql(DECLARE curConsumersDomain CURSOR FOR 
			select DomainsOfInterest->ConsumerID into :tID FROM DomainsOfInterest_Domains WHERE Domains=:pDomain)
	&sql(OPEN curConsumersDomain)
	for  {
		&sql(FETCH curConsumersDomain)
		Quit:SQLCODE
		Set pConsumerOIDs(tID,pDomain)=""
	}
	&sql(CLOSE curConsumersDomain)
	Quit $$$OK
}

Query QueryConsumers() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ConsumerID FROM DomainsOfInterest
}

ClassMethod ConsumerFound(pConsumer, pID) As %Boolean
{
	IF pID]"" {
		&sql(SELECT %ID FROM DomainsOfInterest WHERE ConsumerID=:pConsumer and (%ID<>:pID ))
	} Else {
		&sql(SELECT %ID FROM DomainsOfInterest WHERE ConsumerID=:pConsumer)
	}
	Quit $S(SQLCODE=0:1,1:0)
}

Query AvailableConsumers() As %SQLQuery
{
	select OIDMapCode from HS_registry_service.abstract_oidmapcode where abstract->devicefunction='PIXv3.Consumer' or abstract->devicefunction='PIXv2.Consumer'
}

Storage Default
{
<Data name="Domains">
<Attribute>Domains</Attribute>
<Structure>subnode</Structure>
<Subscript>"Domains"</Subscript>
</Data>
<Data name="DomainsOfInterestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsumerOID</Value>
</Value>
<Value name="3">
<Value>AllDomains</Value>
</Value>
<Value name="4">
<Value>ConsumerID</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.PIXEBC7.DomainsOfInE811D</DataLocation>
<DefaultData>DomainsOfInterestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.PIXEBC7.DomainsOfInE811D</IdLocation>
<IndexLocation>^HS.IHE.PIXEBC7.DomainsOfInE811I</IndexLocation>
<StreamLocation>^HS.IHE.PIXEBC7.DomainsOfInE811S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
