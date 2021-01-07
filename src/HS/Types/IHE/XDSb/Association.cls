Class HS.Types.IHE.XDSb.Association Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

/// If XMLIGNORENULL is set = "inputonly", then both missing tags in the XML and empty
/// strings are input as "".  Output of "" and $c(0) are for XMLIGNORENULL = 0:
/// $c(0) is output as an empty tag (i.e. &lt;tag&gt;&lt;/tag&gt;) and "" is output as no tag.<br><br>
Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

/// sourceObject
/// For document entries - Either Original or Reference (when creating a submission set referring to a document which exists)
Property SubmissionSetStatus As %String [ InitialExpression = "Original" ];

/// Metadata Update - Version of document existing in registry (document to be replaced)
Property PreviousVersion As %String;

/// Metadata Update - default is yes, to propagate associations during an update
Property AssociationPropagation As %String;

Property OriginalStatus As HS.Types.IHE.Status(XMLNAME = "originalStatus", XMLPROJECTION = "ATTRIBUTE");

Property NewStatus As HS.Types.IHE.Status(XMLNAME = "newStatus", XMLPROJECTION = "ATTRIBUTE");

Property EntryUUID As %String(MAXLEN = 256, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

Property LogicalUUID As %String(MAXLEN = 256, XMLNAME = "lid", XMLPROJECTION = "ATTRIBUTE");

Property AssociationType As HS.Types.IHE.Association(MAXLEN = "");

Property SourceObject As %String(MAXLEN = "", XMLNAME = "sourceObject", XMLPROJECTION = "ATTRIBUTE");

Property TargetObject As %String(MAXLEN = "", XMLNAME = "targetObject", XMLPROJECTION = "ATTRIBUTE");

Property Classifications As list Of HS.Types.IHE.XDSb.SerialClassification(XMLNAME = "Classification", XMLPROJECTION = "ELEMENT");

Property Status As HS.Types.IHE.Status(XMLNAME = "Status", XMLPROJECTION = "Element");

/// Hold on to OriginalStatus and NewStatus for MetadataUpdate
Property Slots As list Of HS.Types.IHE.XDSb.Slot(XMLNAME = "Slot", XMLPROJECTION = "ELEMENT");

Method %OnNew(pType = "", pSource = "", pTarget = "") As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set i%AssociationType=pType
	Set i%SourceObject=pSource
	Set i%TargetObject=pTarget
	Set i%EntryUUID="urn:uuid:"_##class(HS.Util.XSLTHelper).createUUID()
	Quit $$$OK
}

ClassMethod Create(pType = "", pSource = "", pTarget = "") As Association
{
	IF '..AssociationTypeIsValid(pType) $$$ThrowStatus($$$ERROR($$$GeneralError,"Unknown type:"_pType))
	Quit ..%New(pType,pSource,pTarget)
}

Storage Default
{
<Data name="AssociationState">
<Value name="1">
<Value>SubmissionSetStatus</Value>
</Value>
<Value name="2">
<Value>PreviousVersion</Value>
</Value>
<Value name="3">
<Value>AssociationPropagation</Value>
</Value>
<Value name="4">
<Value>OriginalStatus</Value>
</Value>
<Value name="5">
<Value>NewStatus</Value>
</Value>
<Value name="6">
<Value>EntryUUID</Value>
</Value>
<Value name="7">
<Value>LogicalUUID</Value>
</Value>
<Value name="8">
<Value>AssociationType</Value>
</Value>
<Value name="9">
<Value>SourceObject</Value>
</Value>
<Value name="10">
<Value>TargetObject</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>Slots</Value>
</Value>
<Value name="13">
<Value>Classifications</Value>
</Value>
</Data>
<State>AssociationState</State>
<StreamLocation>^HS.Types.IHE.XDSb.AssociationS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
