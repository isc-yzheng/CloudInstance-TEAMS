/// 
/// This is the list of documents to archive
Class HS.Registry.Document.Archive.Queue Extends (%Persistent, %XML.Adaptor)
{

Property LogicalIID As %String;

Property PlanPurgeDate As %Date;

Property SourceID As %String;

Index SourceIDDateIndex On (SourceID, PlanPurgeDate);

Index LogicalIIDIndex On LogicalIID [ Unique ];

Storage Default
{
<Data name="ArchiveQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogicalIID</Value>
</Value>
<Value name="3">
<Value>PlanPurgeDate</Value>
</Value>
<Value name="4">
<Value>SourceID</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.D50B9.ArchiveQueueD</DataLocation>
<DefaultData>ArchiveQueueDefaultData</DefaultData>
<IdLocation>^HS.Registry.D50B9.ArchiveQueueD</IdLocation>
<IndexLocation>^HS.Registry.D50B9.ArchiveQueueI</IndexLocation>
<StreamLocation>^HS.Registry.D50B9.ArchiveQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
