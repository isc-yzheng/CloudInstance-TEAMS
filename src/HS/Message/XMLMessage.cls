Class HS.Message.XMLMessage Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter FOUNDATION = 1;

Property DocType As %String(MAXLEN = "");

Property Name As %String;

/// XML Content Stream, for cases > 3.8MB
Property ContentStream As %Stream.GlobalCharacter(CONTENT = "MIXED");

Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

/// Used to handle soap messages with attachments
Property StreamCollection As list Of HS.IHE.Common.Messages.MIMEAttachment;

Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

Property SOAPFault As %Binary(MAXLEN = "");

/// Contains SAML user / rhio / token 
Property SAMLData As HS.IHE.XUA.SAMLData;

/// Data passed in here will be copied to CustomPairs when audited
Property CustomAuditInfo As array Of %String(MAXLEN = "");

/// Deletes persisent mime attachemnts on object delete
ClassMethod OnDeleteHandler(id) As %Status [ ServerOnly = 1 ]
{
	Try {
		Set tSC=$$$OK
		Set tObj=..%OpenId(id) quit:'$IsObject(tObj)
		For tIdx=tObj.StreamCollection.Count():-1:1 {
			Set tMimeAtt = tObj.StreamCollection.GetAt(tIdx)
			If '$IsObject(tMimeAtt) Continue
			Set tSC=tMimeAtt.%DeleteId(tMimeAtt.%Id()) Quit:$$$ISERR(tSC)
		}
		Quit:$$$ISERR(tSC)
		If $IsObject(tObj.ContentStream) && (tObj.ContentStream.%Id()) Set tSC=tObj.ContentStream.%Delete(tObj.ContentStream.%Oid())
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
    Quit tSC
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
     Quit ..OnDeleteHandler($LG(oid))
}

Trigger OnDeleteSQL [ Event = DELETE ]
{
     New class,id
     Set class={%%CLASSNAMEQ} Quit:class=""
     Set id={%%ID} Quit:id=""
     Do $classmethod(class,"OnDeleteHandler",id)
     Quit
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"CustomAuditInfo"</Subscript>
</Data>
<Data name="Values">
<Attribute>Values</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.XMLMessage.Values"</Subscript>
</Data>
<Data name="XMLMessageDefaultData">
<Subscript>"XMLMessage"</Subscript>
<Value name="1">
<Value>Content</Value>
</Value>
<Value name="2">
<Value>DocType</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Source</Value>
</Value>
<Value name="5">
<Value>Action</Value>
</Value>
<Value name="6">
<Value>ContentStream</Value>
</Value>
<Value name="7">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="8">
<Value>StreamCollection</Value>
</Value>
<Value name="9">
<Value>SOAPFault</Value>
</Value>
<Value name="10">
<Value>SAMLData</Value>
</Value>
<Value name="11">
<Value>UseQuickStream</Value>
</Value>
</Data>
<DataLocation>^HS.Message.XMLMessageD</DataLocation>
<DefaultData>XMLMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.Message.XMLMessageD</IdLocation>
<IndexLocation>^HS.Message.XMLMessageI</IndexLocation>
<StreamLocation>^HS.Message.XMLMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
