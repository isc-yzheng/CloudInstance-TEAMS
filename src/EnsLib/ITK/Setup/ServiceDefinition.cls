/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This is a master for all Web Services supported by ITK. It holds several Service attributes such as SOAP Action, Client Class etc.
Class EnsLib.ITK.Setup.ServiceDefinition Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/******************************************************************************
$Id$

Description: This is a master for all Web Services supported by ITK. It holds several Service attributes such as SOAP Action, Client Class etc.
   
Update history:
2011-01-10  Release 1.1.10 Baseline
******************************************************************************/
Parameter SrcVer = "$Id$";

Property ServiceName As %String(MAXLEN = "") [ Required ];

Index U1 On ServiceName [ IdKey, Unique ];

Property SOAPAction As %String(MAXLEN = "") [ Required ];

Index U2 On SOAPAction [ Unique ];

Property BehaviourType As %String(VALUELIST = ",Request-Response,Post,Queue Collection,Fault Handler,Asynch Response Handler,Acknowledged") [ Required ];

Index NU1 On BehaviourType;

/// Contains the HL7 DocType for this message (if it is a HL7 message)
Property DocumentType As %String;

/// Contains the direction of this service to/from a master system
Property Direction As %String(VALUELIST = ",FromMaster,ToMaster") [ InitialExpression = "FromMaster" ];

Index NU2 On (DocumentType, Direction);

Property RequestClass As %String(MAXLEN = "");

Property ResponseClass As %String(MAXLEN = "");

Property WebClientClass As %String(MAXLEN = "");

Property WebServiceClass As %String(MAXLEN = "");

ClassMethod ImportFromFile(pFileName As %String, pDelim As %String = "|") As %Status
{
	If ((pFileName = "") || (##class(%File).Exists(pFileName) = 0)) Quit $$$OK

 Set $ZTRAP = "OnError"
 
	Set tIOStream = ##class(%IO.FileStream).%New()  
	Do tIOStream.Open(pFileName,,10,,.tSC)  

	While ('tIOStream.AtEnd) {
		
		Set tLine = tIOStream.ReadLine(32000, , .sc)
		Set tServiceDef = ##class(EnsLib.ITK.Setup.ServiceDefinition).%New()
		Set tServiceDef.ServiceName = $P(tLine, pDelim, 1)
		Set tServiceDef.SOAPAction = $P(tLine, pDelim, 2)
		Set tServiceDef.BehaviourType = $P(tLine, pDelim, 3)
		Set tServiceDef.RequestClass = $P(tLine, pDelim, 4)
		Set tServiceDef.ResponseClass = $P(tLine, pDelim, 5)
		Set tServiceDef.WebClientClass = $P(tLine, pDelim, 6)
		Set tServiceDef.WebServiceClass = $P(tLine, pDelim, 7)
		
		Set tSc = tServiceDef.%ValidateObject(1)
		If $$$ISOK(tSc) {
			Set tStatus = tServiceDef.%Save()
		} else {
			Do $SYSTEM.Status.DisplayError(tSc)
			W !, "Skipping record: "_tLine,!
		}
	}	
	Set $ZTRAP = ""
	
Exit
	Do tIOStream.Close()
	Quit $$$OK
OnError	
	Set $ZTRAP = ""
	W !, $ZERROR
	Goto Exit
}

ClassMethod FromAction(action As %String) As EnsLib.ITK.Setup.ServiceDefinition
{
	Quit ..U2Open(action)
}

Query GetServiceList() As %SQLQuery
{
SELECT ServiceName FROM ServiceDefinition
 ORDER BY ServiceName
}

Query GetResponseHandlers() As %SQLQuery
{
SELECT ServiceName FROM ServiceDefinition
WHERE BehaviourType = 'Asynch Response Handler'
 ORDER BY ServiceName
}

Query GetFaultHandlers() As %SQLQuery
{
SELECT ServiceName FROM ServiceDefinition
WHERE BehaviourType = 'Fault Handler'
 ORDER BY ServiceName
}

Query GetServiceListUI() As %SQLQuery
{
SELECT ServiceName, SOAPAction, BehaviourType, DocumentType, Direction, RequestClass,
	ResponseClass, WebClientClass, WebServiceClass FROM ServiceDefinition
 ORDER BY ServiceName
}

Query GetServicForDocType(pDoctype As %String, pDirection As %String) As %SQLQuery
{
SELECT ServiceName FROM ServiceDefinition
WHERE DocumentType = :pDoctype and Direction = :pDirection
ORDER BY ServiceName
}

Storage Default
{
<Data name="ServiceDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SOAPAction</Value>
</Value>
<Value name="3">
<Value>BehaviourType</Value>
</Value>
<Value name="4">
<Value>RequestClass</Value>
</Value>
<Value name="5">
<Value>ResponseClass</Value>
</Value>
<Value name="6">
<Value>WebClientClass</Value>
</Value>
<Value name="7">
<Value>WebServiceClass</Value>
</Value>
<Value name="8">
<Value>DocumentType</Value>
</Value>
<Value name="9">
<Value>Direction</Value>
</Value>
</Data>
<DataLocation>^EnsITK.ServiceDefinitionD</DataLocation>
<DefaultData>ServiceDefinitionDefaultData</DefaultData>
<IdLocation>^EnsITK.ServiceDefinitionD</IdLocation>
<IndexLocation>^EnsITK.ServiceDefinitionI</IndexLocation>
<StreamLocation>^EnsITK.ServiceDefinitionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
