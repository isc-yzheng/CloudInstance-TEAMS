/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Stores the list of different Applications that can send a Web Request to ITK. This is used for Sender authentication.
Class EnsLib.ITK.Setup.SenderRegistry Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: Stores the list of different Applications that can send Web Request to ITK. This is used for Sender authentication.   
Update history:

2011-01-18  RequestResponseProviders returns only Asychronous senders
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property BusinessServiceName As %String [ Required ];

Property ValidatePayload As %Boolean [ InitialExpression = 0 ];

Property SourceAppName As %String [ Required ];

Property WebServiceName As %String [ Required ];

Property InvocationPattern As %String(VALUELIST = ",Asynchronous,Synchronous,Derived") [ Required ];

Index U1 On (BusinessServiceName, SourceAppName, WebServiceName) [ Unique ];

ClassMethod CheckSenderPermission(pSourceAppName As %String, pWebServiceName As %String, pBusinessServiceName As %String, Output pInvocationPattern As %String) As %Boolean
{
	set o = ..U1Open(pBusinessServiceName,pSourceAppName,pWebServiceName)
	#dim o As EnsLib.ITK.Setup.SenderRegistry

	if '$IsObject(o) Quit 0
	
	set pInvocationPattern = o.InvocationPattern
	Quit 1
}

ClassMethod IsValidationRequired(pBusinessServiceName As %String, pSourceAppName As %String, pWebServiceName As %String) As %Boolean
{
	set o = ..U1Open(pBusinessServiceName,pSourceAppName,pWebServiceName)
	#dim o As EnsLib.ITK.Setup.SenderRegistry
	
	if '$IsObject(o) Quit 0
	Quit o.ValidatePayload
}

ClassMethod GetAsyncResponseHandler(pSourceAppName As %String) As %String
{
	set rs = ##class(%ResultSet).%New("EnsLib.ITK.Setup.ServiceDefinition:GetResponseHandlers")
	do rs.Execute()
	set o=""
	while rs.Next()
	{
		set tWebServiceName = rs.GetData(1)
		&sql(select BusinessServiceName into :tBusinessServiceName from SenderRegistry where (SourceAppName = :pSourceAppName) AND (WebServiceName = :tWebServiceName))
		
		continue:SQLCODE'=0
		
		set o = ..U1Open(tBusinessServiceName,pSourceAppName,tWebServiceName)
		#dim o As EnsLib.ITK.Setup.SenderRegistry
		Quit:$IsObject(o)
	}
	Quit:$IsObject(o) o.BusinessServiceName
	Quit ""
}

ClassMethod GetAsyncFaultHandler(pSourceAppName As %String) As %String
{
	set rs = ##class(%ResultSet).%New("EnsLib.ITK.Setup.ServiceDefinition:GetFaultHandlers")
	do rs.Execute()
	set o=""
	while rs.Next()
	{
		set tWebServiceName = rs.GetData(1)
		&sql(select BusinessServiceName into :tBusinessServiceName from SenderRegistry where (SourceAppName = :pSourceAppName) AND (WebServiceName = :tWebServiceName))
		
		continue:SQLCODE'=0
		
		set o = ..U1Open(tBusinessServiceName,pSourceAppName,tWebServiceName)
		#dim o As EnsLib.ITK.Setup.SenderRegistry
		Quit:$IsObject(o)
	}
	Quit:$IsObject(o) o.BusinessServiceName
	Quit ""
}

Query QuerySourceRegistry(pSourceAppName As %String, pWebServiceName As %String, pBusinessServiceName As %String) As %SQLQuery
{
SELECT * FROM SenderRegistry
WHERE (SourceAppName = :pSourceAppName) AND (WebServiceName = :pWebServiceName) AND (BusinessServiceName = :pBusinessServiceName)
}

Query QueueEnabledSubscripers() As %SQLQuery
{
SELECT SourceAppName FROM EnsLib_ITK_Setup.SenderRegistry  a,EnsLib_ITK_Setup.ServiceDefinition b
WHERE (a.WebServiceName = b.ServiceName)
AND (b.BehaviourType='Queue Collection')
}

Query RequestResponseProviders() As %SQLQuery
{
SELECT SourceAppName FROM EnsLib_ITK_Setup.SenderRegistry  a,EnsLib_ITK_Setup.ServiceDefinition b
WHERE (a.WebServiceName = b.ServiceName)
AND (b.BehaviourType='Request-Response')
AND (a.InvocationPattern = 'Asynchronous')
}

Storage Default
{
<Data name="SenderRegistryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BusinessServiceName</Value>
</Value>
<Value name="3">
<Value>ValidatePayload</Value>
</Value>
<Value name="4">
<Value>SourceAppName</Value>
</Value>
<Value name="5">
<Value>WebServiceName</Value>
</Value>
<Value name="6">
<Value>InvocationPattern</Value>
</Value>
</Data>
<DataLocation>^EnsITK.SenderRegistryD</DataLocation>
<DefaultData>SenderRegistryDefaultData</DefaultData>
<IdLocation>^EnsITK.SenderRegistryD</IdLocation>
<IndexLocation>^EnsITK.SenderRegistryI</IndexLocation>
<StreamLocation>^EnsITK.SenderRegistryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
