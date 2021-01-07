Class HS.Types.IHE.XDSb.DocumentAdditional Extends (%SerialObject, %XML.Adaptor)
{

Property Author As list Of HS.Types.IHE.XDSb.Author(XMLPROJECTION = "ELEMENT");

/// The level of confidentiality - to be addressed in future IHE specifications
Property ConfidentialityCode As list Of HS.Types.IHE.XDSb.SerialClassification(XMLPROJECTION = "ELEMENT");

/// Optional list of the main clinical acts
Property EventCodeList As list Of HS.Types.IHE.XDSb.SerialClassification(XMLPROJECTION = "ELEMENT");

Property URI As %String(MAXLEN = "");

Property XOP As %String(MAXLEN = "");

Property HomeCommunityId As %String(MAXLEN = "", XMLNAME = "home", XMLPROJECTION = "ATTRIBUTE");

/// Binary document stream
Property Body As %Stream.GlobalBinary;

/// Character document stream, if present, will be used to extract CDA information and copied to the submission attachments, unless a Body stream is defined.
Property BodyCharacter As %Stream.GlobalCharacter;

/// if the document uuid is known assign it to the ReplaceSource, otherwise the ReplacementContext can be used to locate the document
Property ReplaceSource As %String(MAXLEN = 75);

Storage Default
{
<Data name="DocumentAdditionalState">
<Value name="1">
<Value>Author</Value>
</Value>
<Value name="2">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="3">
<Value>EventCodeList</Value>
</Value>
<Value name="4">
<Value>URI</Value>
</Value>
<Value name="5">
<Value>XOP</Value>
</Value>
<Value name="6">
<Value>HomeCommunityId</Value>
</Value>
<Value name="7">
<Value>Body</Value>
</Value>
<Value name="8">
<Value>BodyCharacter</Value>
</Value>
<Value name="9">
<Value>ReplaceSource</Value>
</Value>
</Data>
<State>DocumentAdditionalState</State>
<StreamLocation>^HS.Types.I3C1E.DocumentAdd9F97S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
