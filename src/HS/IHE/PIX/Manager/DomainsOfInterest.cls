/// Map OID to facility / endpoint
Class HS.IHE.PIX.Manager.DomainsOfInterest Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Code for OID of the Consumer interested in notification ie PIXv3ConsumerDevice
Property ConsumerID As %String(MAXLEN = "") [ Required ];

/// Code for OID of the Domain as in External, CGH, etc
Property Domains As list Of %String(STORAGEDEFAULT = "array");

/// If true, any domain update will be sent and the Domains list will be ignored
Property AllDomains As %Boolean [ InitialExpression = 1 ];

/// If true, send all domain updates if and only if the patient has an MRN in one of the Assigning Authorities listed in Domains
Property RegisteredPatientsOnly As %Boolean [ InitialExpression = 0 ];

Index DomainsIndex On Domains(ELEMENTS);

Index AllDomainsIndex On AllDomains [ Type = bitmap ];

/// Given a list of identifiers, outputs a list of consumer IDs for consumers.  
/// Returns a consumer ID if at least one domain from the list of identifiers matches a domain from the consumer's Domains property,
/// and the consumer has RegisteredPatientsOnly=1.
/// <br> This method should be called before ConsumersToNotify, with pRegisteredConsumers should be passed as input to the latter method.
ClassMethod RegisteredOnlyConsumers(pIdentifiers As %Library.ListOfDataTypes, ByRef pRegisteredOnlyConsumers As %String) As %Status
{
	set tSC=$$$OK
	set tI=""
	for{
		set tIdentifier=pIdentifiers.GetNext(.tI)
		quit:tI=""
		set tDomain=tIdentifier.Root
		&sql(DECLARE curConsumersDomainRegOnly CURSOR FOR 
				select DomainsOfInterest->ConsumerID into :tID FROM DomainsOfInterest_Domains WHERE Domains=:tDomain
				AND DomainsOfInterest->RegisteredPatientsOnly=1)
		&sql(OPEN curConsumersDomainRegOnly)
		for  {
			&sql(FETCH curConsumersDomainRegOnly)
			Quit:SQLCODE
			set pRegisteredOnlyConsumers(tID)=""
		}
		&sql(CLOSE curConsumersDomainRegOnly)
	}
	quit tSC
}

ClassMethod ConsumersToNotify(pDomain As %String, ByRef pConsumerOIDs As %String, ByRef pRegisteredOnlyConsumers As %String) As %Status
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
	set tID=""
	for{
		set tID = $order(pRegisteredOnlyConsumers(tID))
		quit:tID=""
		Set pConsumerOIDs(tID,pDomain)=""
	}
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

ClassMethod IDForConsumer(pConsumer) As %String
{
	Set SQLCODE=100,ID=""
	&sql(SELECT %ID into :ID FROM DomainsOfInterest WHERE ConsumerID=:pConsumer)
	Quit $S(SQLCODE:"",1:ID)
}

Query AvailableConsumers() As %SQLQuery
{
	select OIDMapCode from HS_registry_service.abstract_oidmapcode where abstract->devicefunction='PIXv3.Consumer' or abstract->devicefunction='PIXv2.Consumer' and element_key='Device'
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
<Value>ConsumerID</Value>
</Value>
<Value name="3">
<Value>AllDomains</Value>
</Value>
<Value name="4">
<Value>RegisteredPatientsOnly</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.PIX7F2F.DomainsOfInE811D</DataLocation>
<DefaultData>DomainsOfInterestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.PIX7F2F.DomainsOfInE811D</IdLocation>
<IndexLocation>^HS.IHE.PIX7F2F.DomainsOfInE811I</IndexLocation>
<StreamLocation>^HS.IHE.PIX7F2F.DomainsOfInE811S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
