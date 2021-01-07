Class HS.Message.IHE.XDSb.Folder Extends (%SerialObject, HS.IHE.XDSb.Types.Folder) [ Inheritance = right ]
{

Parameter XMLTYPE = "StoredFolder";

/// calculated UUID for the folder
Property EntryUUID As %String(MAXLEN = "", XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = {##class(HS.Util.XSLTHelper).createUUID()} ];

/// logicalUUID is the common id for documents when using metadata update - no default
Property LogicalUUID As %String(MAXLEN = "", XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

/// calculated OID for the document (based on the UUID)
Property UniqueId As %String(MAXLEN = "") [ InitialExpression = {##class(HS.Util.XSLTHelper).uuid2oid(..EntryUUID)} ];

Storage Default
{
<Data name="FolderState">
<Value name="1">
<Value>AvailabilityStatus</Value>
</Value>
<Value name="2">
<Value>CodeList</Value>
</Value>
<Value name="3">
<Value>Comments</Value>
</Value>
<Value name="4">
<Value>LastUpdateTime</Value>
</Value>
<Value name="5">
<Value>PatientId</Value>
</Value>
<Value name="6">
<Value>Title</Value>
</Value>
<Value name="7">
<Value>UniqueId</Value>
</Value>
<Value name="8">
<Value>EntryUUID</Value>
</Value>
<Value name="9">
<Value>HomeCommunityId</Value>
</Value>
<Value name="10">
<Value>LogicalEntryUUID</Value>
</Value>
<Value name="11">
<Value>LogicalUUID</Value>
</Value>
<Value name="12">
<Value>Version</Value>
</Value>
</Data>
<State>FolderState</State>
<StreamLocation>^HS.Message.IHE.XDSb.FolderS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
