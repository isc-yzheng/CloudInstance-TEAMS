Class HS.IHE.XDSb.Types.Association Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Type As HS.Types.IHE.Association(XMLNAME = "type", XMLPROJECTION = "ATTRIBUTE");

Property ID As %String(MAXLEN = "", XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

/// sourceObject
Property ParentUUID As %String(MAXLEN = "", XMLNAME = "parent", XMLPROJECTION = "ATTRIBUTE");

/// targetObject
Property ChildUUID As %String(MAXLEN = "", XMLNAME = "child", XMLPROJECTION = "ATTRIBUTE");

/// For document entries - Either Original or Reference (when creating a submission set referring to a document which exists)
Property SubmissionSetStatus As %String [ InitialExpression = "Original" ];

/// Metadata Update - Version of document existing in registry (document to be replaced)
Property PreviousVersion As %String;

/// Metadata Update - default is yes, to propagate associations during an update
Property AssociationPropagation As %String;

Property OriginalStatus As HS.Types.IHE.Status(XMLNAME = "originalStatus", XMLPROJECTION = "ATTRIBUTE");

Property NewStatus As HS.Types.IHE.Status(XMLNAME = "newStatus", XMLPROJECTION = "ATTRIBUTE");

/// Association status
Property Status As HS.Types.IHE.Status(XMLNAME = "status", XMLPROJECTION = "ATTRIBUTE");

Method %OnNew(type, parent, child) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set i%Type=$G(type)
	Set i%ParentUUID=$G(parent)
	Set i%ChildUUID=$G(child)
	Quit $$$OK
}

ClassMethod Create(pType = "", pParent = "", pChild = "") As CodedValue
{
	Quit ..%New(pType,pParent,pChild)
}

Storage Default
{
<Data name="AssociationState">
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>ParentUUID</Value>
</Value>
<Value name="3">
<Value>ChildUUID</Value>
</Value>
<Value name="4">
<Value>PreviousVersion</Value>
</Value>
<Value name="5">
<Value>AssociationPropagation</Value>
</Value>
<Value name="6">
<Value>SubmissionSetStatus</Value>
</Value>
<Value name="7">
<Value>OriginalStatus</Value>
</Value>
<Value name="8">
<Value>NewStatus</Value>
</Value>
<Value name="9">
<Value>ID</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
</Data>
<State>AssociationState</State>
<StreamLocation>^HS.IHE.XDSb.Types.AssociationS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
