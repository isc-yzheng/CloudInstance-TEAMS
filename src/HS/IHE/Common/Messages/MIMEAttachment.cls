Class HS.IHE.Common.Messages.MIMEAttachment Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// HealthShare Foundation
Parameter FOUNDATION = 1;

Property ContentId As %String(MAXLEN = "");

Property ContentType As %String(MAXLEN = "");

Property ContentTransferEncoding As %String(MAXLEN = "");

Property Body As %CSP.BinaryStream;

/// Optional: path to temporary file instead of storing <propety>Body</property> stream
/// This file will be deleted when the persistent object is deleted.
/// 
Property FilePath As %String(MAXLEN = "");

/// Get the body (either from stream or file)
/// 
/// <p>Throws error if using files and read file fails
/// 
Method GetBody() As %CSP.BinaryStream
{
	If ..FilePath="" Quit ..Body
	Set tBody = ##class(%CSP.BinaryStream).%New()
	$$$ThrowOnError(##class(HS.Util.StreamUtils).ReadFromFile(..FilePath, tBody))
	Quit tBody
}

/// Save body to file
/// <dl>
/// <dt>pBody     <dd>The stream to save
/// <dt>pFilePath <dd>Where to save the file; defaults to temp file
/// </dl>
/// 
Method SaveBodyToFile(pBody As %CSP.BinaryStream, pFilePath As %String = "") As %Status
{
	Set:pFilePath="" pFilePath = ##class(HS.Util.StreamUtils).GetTempFilename()
	Set ..FilePath = pFilePath
	Quit ##class(HS.Util.StreamUtils).CopyToFile(..FilePath, pBody)
}

/// Deletes temp file on object delete (but will not fail if file cannot be deleted)
/// 
ClassMethod OnDeleteHandler(id) As %Status [ ServerOnly = 1 ]
{
	Set tSC=$$$OK
	Try {
		Set tObj = ..%OpenId(id) Quit:'$IsObject(tObj)
		If tObj.FilePath'="" Do ##class(%File).Delete(tObj.FilePath)
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
<Data name="MIMEAttachmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContentId</Value>
</Value>
<Value name="3">
<Value>ContentType</Value>
</Value>
<Value name="4">
<Value>ContentTransferEncoding</Value>
</Value>
<Value name="5">
<Value>Body</Value>
</Value>
<Value name="6">
<Value>FilePath</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.Comm8F7E.MIMEAttachmentD</DataLocation>
<DefaultData>MIMEAttachmentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.Comm8F7E.MIMEAttachmentD</IdLocation>
<IndexLocation>^HS.IHE.Comm8F7E.MIMEAttachmentI</IndexLocation>
<StreamLocation>^HS.IHE.Comm8F7E.MIMEAttachmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
