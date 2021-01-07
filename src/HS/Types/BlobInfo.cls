/// Used for fetching blobs during analytics feed
Class HS.Types.BlobInfo Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property HSBlobStream As %Stream.GblBinCompress;

Property HSBlobId As %Integer;

Storage Default
{
<Data name="BlobInfoState">
<Value name="1">
<Value>HSBlobStream</Value>
</Value>
<Value name="2">
<Value>HSBlobId</Value>
</Value>
</Data>
<State>BlobInfoState</State>
<StreamLocation>^HS.Types.BlobInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
