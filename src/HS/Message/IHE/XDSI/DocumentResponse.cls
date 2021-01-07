Class HS.Message.IHE.XDSI.DocumentResponse Extends HS.Message.IHE.XDSI.DocumentRequest [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property MimeType As %String(MAXLEN = 255);

Property XOP As %String(MAXLEN = 255);

/// temporary document stream to support inline attachments
Property Body As %Stream.TmpBinary [ Transient ];

Storage Default
{
<Data name="DocumentRequestState">
<Value name="1">
<Value>HomeCommunityId</Value>
</Value>
<Value name="2">
<Value>RepositoryUniqueId</Value>
</Value>
<Value name="3">
<Value>DocumentUniqueId</Value>
</Value>
<Value name="4">
<Value>AdditionalInfo</Value>
</Value>
<Value name="5">
<Value>MimeType</Value>
</Value>
<Value name="6">
<Value>XOP</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
