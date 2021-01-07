/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This business process takes an input of a HL7 Message and turns it into 
/// a ITK XML Message
Class EnsLib.ITK.AdapterKit.Process.HL7ToITK Extends Ens.BusinessProcess [ ProcedureBlock, System = 4 ]
{

/// The Audit Identity URI to add into ITK messages
Property AuditIdentity As %String;

/// The business component to send onto
Property TargetConfigName As %String;

/// Direction in relationship to master record
/// FromMaster - messages are being received via the ITK from the master source
/// ToMaster - messages are being set via the ITK to the master source
Property Direction As %String(VALUELIST = ",FromMaster,ToMaster") [ InitialExpression = "FromMaster", Required ];

Parameter SETTINGS = "TargetConfigName,Direction,AuditIdentity";

Method OnRequest(pHL7Message As EnsLib.HL7.Message, Output pResponse As EnsLib.ITK.AdapterKit.Request) As %Status
{
	// Convert
	set xmlStream=##class(EnsLib.ITK.AdapterKit.ConvertUtil).HL7ToXML(pHL7Message)
	
	// Create request
	Set tToITK=##class(EnsLib.ITK.AdapterKit.Request).%New()
    set pResponse=tToITK
    
    // Determine Service Name
    set tToITK.ServiceName=""
    set rs = ##class(%ResultSet).%New("EnsLib.ITK.Setup.ServiceDefinition:GetServicForDocType")
    set sc = rs.Execute(pHL7Message.DocType,..Direction)
    if $$$ISOK(sc) && rs.Next() {
		set tToITK.ServiceName = rs.Get("ServiceName")
	}
    
    // Create Distribution Envelope
    set tToITK.Stream=##class(EnsLib.ITK.AdapterKit.ConvertUtil).WrapStreamDistributionEnvelope(xmlStream, tToITK.ServiceName, ..AuditIdentity)
        
    // Send onwards
    Set:..TargetConfigName'="" sc=..SendRequestAsync(..TargetConfigName,tToITK)
	
	quit $$$OK
	
OnExit	
	Quit sc
}

Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
	quit $$$OK
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigName",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

Storage Default
{
<Data name="HL7ToITKDefaultData">
<Subscript>"HL7ToITK"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
<Value name="2">
<Value>Direction</Value>
</Value>
<Value name="3">
<Value>AuditIdentity</Value>
</Value>
</Data>
<DefaultData>HL7ToITKDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
