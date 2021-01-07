Class HS.Message.IHE.XDM.DistributeDocumentSetRequest Extends HS.Message.XMLMessage
{

/// An XDM archive can contain multiple submission sets with each subset contained within a separate directory under IHE_XDM. 
/// For example, three separate submission sets are contained as:
/// <ul><li>IHE_XDM\SUBSET01\[...]</li><li>IHE_XDM\SUBSET02\[...]</li><li>IHE_XDM\SUBSET03\[...]</li></ul>.<p>
/// Because when converting a multi-subset XDM to XDR, each subset must be converted to a separate XDR transaction, the same
/// treatment is applied converting to XDM, each subset is created from a separate Provide and Register Request.
Property Submissions As list Of HS.Message.IHE.XDSb.Metadata;

/// Ability to override the output filepath
Property FilePath As %String(MAXLEN = 512);

/// Files - sent to FileOutputOperation
Property Files As HS.Message.ZipRequest;

Storage Default
{
<Data name="DistributeDocumentSetRequestDefaultData">
<Subscript>"DistributeDocumentSetRequest"</Subscript>
<Value name="1">
<Value>Submissions</Value>
</Value>
<Value name="2">
<Value>FilePath</Value>
</Value>
<Value name="3">
<Value>Files</Value>
</Value>
</Data>
<DefaultData>DistributeDocumentSetRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
