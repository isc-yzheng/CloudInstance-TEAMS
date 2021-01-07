Class HS.IHE.ATNA.Repository.Document Extends (%Persistent, %XML.Adaptor)
{

Relationship AggregationID As HS.IHE.ATNA.Repository.Aggregation [ Cardinality = parent, Inverse = Documents ];

/// Document ID in XDS repository (unique id for XDSb / entryUUID for DSUB)
Property DocumentID As %String(MAXLEN = "");

/// For DSUB it's important to have the object type (ondemand or stable uuid)
Property ObjectType As %String(MAXLEN = "");

/// XDS repository ID
Property RepositoryID As %String(MAXLEN = "");

/// Only needed for XCA documents?
Property HomeCommunityID As %String(MAXLEN = "");

Storage Default
{
<Data name="DocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentID</Value>
</Value>
<Value name="3">
<Value>RepositoryID</Value>
</Value>
<Value name="4">
<Value>HomeCommunityID</Value>
</Value>
<Value name="5">
<Value>ObjectType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Documents")</DataLocation>
<DefaultData>DocumentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.IHE.Audit("Documents")</IdLocation>
<IndexLocation>^HS.IHE.Audit("DocumentsI")</IndexLocation>
<StreamLocation>^HS.IHE.Audit("DocumentsS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
