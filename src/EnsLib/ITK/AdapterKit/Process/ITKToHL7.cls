/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This business process takes an input of a ITK XML ADT Message and
/// converts it to a basic HL7 Message
Class EnsLib.ITK.AdapterKit.Process.ITKToHL7 Extends Ens.BusinessProcess [ ProcedureBlock, System = 4 ]
{

Property TargetConfigName As %String;

Parameter SETTINGS = "TargetConfigName";

Method OnRequest(pRequest As EnsLib.ITK.Framework.RequestData, Output pResponse As EnsLib.HL7.Message) As %Status
{
	// Extract XML Payload from ITKXML Message
	set rdr=##class(%XML.Reader).%New()
	do rdr.OpenStream(pRequest.Payload)
	set xml=##class(EnsLib.ITK.Util.XML).%New()
	set xml.Document=rdr.Document
	// do xml.PercolateNamespaces("payload","urn:nhs-itk:ns:201005")
	do xml.PercolateNamespaces("payload","")
	do xml.Next(.hl7)
	
	// Convert
	set pResponse=##class(EnsLib.ITK.AdapterKit.ConvertUtil).XMLStreamToHL7(hl7)
	
	// Send on and set response
	do:(pResponse'="")&&(..TargetConfigName'="") ..SendRequestSync(..TargetConfigName, pResponse)
	
	Quit $$$OK
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
<Data name="ITKToHL7DefaultData">
<Subscript>"ITKToHL7"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
</Data>
<DefaultData>ITKToHL7DefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
