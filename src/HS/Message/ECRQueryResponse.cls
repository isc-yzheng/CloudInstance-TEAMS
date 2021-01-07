Class HS.Message.ECRQueryResponse Extends HS.Util.EnsResponse
{

Parameter XMLIGNORENULL = "inputonly";

/// Flag to control when the MPI should be updated.  If unspecified, it's left up to the ECR
Property MPIUpdateFlag As %String;

/// The SDA3 contents returned by the query
Property ContentStream As %Stream.GlobalCharacter;

/// Instead of populating a single ContentStream, the data source can populate a list of
/// SDA3 streams which can be loaded sequentially.  This is used, for instance, from
/// an XDSb document repository.
Property ContentStreamList As list Of %Stream.GlobalCharacter;

/// This is a message returned by the external system when we query this record, which
/// will be passed back the next time we query, so that they can give us selective updates.
/// It typically would have some sort of timestamp.
/// For CacheType=NotifyAndQuery or ExpireAndQuery
Property ResponseString As %String(MAXLEN = "");

/// For an external system that can do selective updates, if there's nothing to update, it can
/// set this instead of returning a ContentStream
Property NoChange As %Boolean;

/// For a pure query edge that is not returning any data, set Action=0
/// This is for use cases where we are querying even if we don't know if a record exists
Property Action As %String;

Storage Default
{
<Data name="ECRQueryResponseDefaultData">
<Subscript>"ECRQueryResponse"</Subscript>
<Value name="1">
<Value>ContentStream</Value>
</Value>
<Value name="2">
<Value>ResponseString</Value>
</Value>
<Value name="3">
<Value>NoChange</Value>
</Value>
<Value name="4">
<Value>ContentStreamList</Value>
</Value>
<Value name="5">
<Value>MPIUpdateFlag</Value>
</Value>
<Value name="6">
<Value>Action</Value>
</Value>
</Data>
<DefaultData>ECRQueryResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
