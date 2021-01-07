/// Request object which will be used with a transformation to produce valid metadata for the XDSb.Registry Provide and Register Request
Class HS.Message.IHE.XDSb.Metadata Extends (HS.Message.XMLMessage, HS.Util.EnsRequest, HS.Types.RequestInfo) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// If XMLIGNORENULL is set = "inputonly", then both missing tags in the XML and empty
/// strings are input as "".  Output of "" and $c(0) are for XMLIGNORENULL = 0:
/// $c(0) is output as an empty tag (i.e. &lt;tag&gt;&lt;/tag&gt;) and "" is output as no tag.<br><br>
Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

/// Default response class
Parameter RESPONSECLASSNAME As %String = "HS.Message.IHE.XDSb.Metadata";

/// The system will automatically calculate associations, document to submission, additional associations (folders / signs) can be inserted and will be included
Property Associations As list Of HS.Types.IHE.XDSb.Association(XMLNAME = "Association", XMLPROJECTION = "ELEMENT");

Property Documents As list Of HS.Types.IHE.XDSb.Document(XMLNAME = "Document", XMLPROJECTION = "ELEMENT");

/// Any folders inserted will also require associations
Property Folders As list Of HS.Types.IHE.XDSb.Folder(XMLNAME = "Folder", XMLPROJECTION = "ELEMENT");

/// Used for converting Message to Provide & Register - could be multiple submissions (in error)
Property Submissions As list Of HS.Types.IHE.XDSb.Submission(XMLNAME = "Submission", XMLPROJECTION = "ELEMENT");

/// One example - when trying to generate a signature, the P&R request is required to generate it and insert as another document
Property GenerateProvideAndRegisterOnly As %Boolean [ InitialExpression = 0 ];

/// Language used for LocalizedString elements
Property Language As %String;

/// optional direct from (email) address when sending to a HISP - which will be inserted into the soap header on a P&R request
Property DirectFrom As %String(MAXLEN = "");

/// optional direct to (email) address when sending to a HISP - which will be inserted into the soap header on a P&R request
Property DirectTo As list Of %String(MAXLEN = "");

Property DirectMetadataLevel As %String;

Property ObjectRefs As list Of HS.Message.IHE.XDSb.ObjectRef(XMLNAME = "ObjectRef", XMLPROJECTION = "ELEMENT");

Property RelatedDocuments As list Of HS.Types.IHE.XDSb.Document(XMLNAME = "RelatedDocument", XMLPROJECTION = "ELEMENT");

/// Upper level status value for some responses
Property Status As %String(MAXLEN = 255);

Property Errors As HS.Types.IHE.Errors;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.Metadata.AdditionalInfo"</Subscript>
</Data>
<Data name="MetadataDefaultData">
<Subscript>"Metadata"</Subscript>
<Value name="1">
<Value>BreakTheGlass</Value>
</Value>
<Value name="2">
<Value>Consent</Value>
</Value>
<Value name="3">
<Value>Associations</Value>
</Value>
<Value name="4">
<Value>AuthType</Value>
</Value>
<Value name="5">
<Value>BTGReason</Value>
</Value>
<Value name="6">
<Value>RequestingForProxyUserID</Value>
</Value>
<Value name="7">
<Value>GenerateProvideAndRegisterOnly</Value>
</Value>
<Value name="8">
<Value>Language</Value>
</Value>
<Value name="9">
<Value>DirectFrom</Value>
</Value>
<Value name="10">
<Value>DirectTo</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>SAMLData</Value>
</Value>
<Value name="13">
<Value>AuthBy</Value>
</Value>
<Value name="14">
<Value>ClinicalTypes</Value>
</Value>
<Value name="15">
<Value>Documents</Value>
</Value>
<Value name="16">
<Value>Folders</Value>
</Value>
<Value name="17">
<Value>RequestId</Value>
</Value>
<Value name="18">
<Value>RequestingForProxyID</Value>
</Value>
<Value name="19">
<Value>RequestingGateway</Value>
</Value>
<Value name="20">
<Value>RequestingUser</Value>
</Value>
<Value name="21">
<Value>RequestingUserRoles</Value>
</Value>
<Value name="22">
<Value>Signature</Value>
</Value>
<Value name="23">
<Value>Submissions</Value>
</Value>
<Value name="24">
<Value>RelatedDocuments</Value>
</Value>
<Value name="25">
<Value>HSCoreVersion</Value>
</Value>
<Value name="26">
<Value>HSMinVersion</Value>
</Value>
<Value name="27">
<Value>ObjectRefs</Value>
</Value>
<Value name="28">
<Value>Errors</Value>
</Value>
<Value name="29">
<Value>Status</Value>
</Value>
<Value name="30">
<Value>DirectMetadataLevel</Value>
</Value>
<Value name="31">
<Value>%ClearFields</Value>
</Value>
</Data>
<DefaultData>MetadataDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
