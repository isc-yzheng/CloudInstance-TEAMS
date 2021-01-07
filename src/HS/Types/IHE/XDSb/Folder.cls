Class HS.Types.IHE.XDSb.Folder Extends (%SerialObject, %XML.Adaptor, HS.Util.CopyFrom)
{

Parameter XMLIGNORENULL = "inputonly";

/// known as lid in the provide and register / register
Property LogicalUUID As %String(MAXLEN = 256, XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

/// known as id in the provide and register / register
Property EntryUUID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property AvailabilityStatus As HS.Types.IHE.Status(XMLNAME = "AvailabilityStatus", XMLPROJECTION = "Element");

/// List of serial classifications
Property Classifications As list Of HS.Types.IHE.XDSb.SerialClassification(XMLNAME = "Classification", XMLPROJECTION = "ELEMENT");

/// External identifiers not including PatientId or UniqueId
Property ExternalIdentifiers As list Of HS.Types.IHE.XDSb.SerialExternalIdentifierFull(XMLNAME = "ExternalIdentifier", XMLPROJECTION = "ELEMENT");

Property LastUpdateTime As %String(MAXLEN = "");

Property PatientIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property Title As HS.Types.IHE.XDSb.ValueType(XMLNAME = "Title", XMLPROJECTION = "ELEMENT");

Property Comments As HS.Types.IHE.XDSb.ValueType(XMLNAME = "Comments", XMLPROJECTION = "ELEMENT");

Property UniqueIdentifier As HS.Types.IHE.XDSb.SerialExternalIdentifier;

Property Node As HS.Types.IHE.XDSb.SerialClassification;

Property CodeList As list Of HS.Types.IHE.XDSb.SerialClassification;

Storage Default
{
<Data name="FolderState">
<Value name="1">
<Value>LogicalUUID</Value>
</Value>
<Value name="2">
<Value>EntryUUID</Value>
</Value>
<Value name="3">
<Value>AvailabilityStatus</Value>
</Value>
<Value name="4">
<Value>Classifications</Value>
</Value>
<Value name="5">
<Value>Comments</Value>
</Value>
<Value name="6">
<Value>LastUpdateTime</Value>
</Value>
<Value name="7">
<Value>PatientIdentifier</Value>
</Value>
<Value name="8">
<Value>Title</Value>
</Value>
<Value name="9">
<Value>UniqueIdentifier</Value>
</Value>
<Value name="10">
<Value>ExternalIdentifiers</Value>
</Value>
<Value name="11">
<Value>Node</Value>
</Value>
<Value name="12">
<Value>CodeList</Value>
</Value>
</Data>
<State>FolderState</State>
<StreamLocation>^HS.Types.IHE.XDSb.FolderS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
