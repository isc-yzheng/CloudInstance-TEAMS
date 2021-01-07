Class HS.IHE.ATNA.Repository.DICOMData.MediaIdentifier Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Property MediaType As EventTypeCode(XMLNAME = "MediaType");

Storage Default
{
<Data name="MediaIdentifierDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MediaType</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.ATN494C.MediaIdentiA133D</DataLocation>
<DefaultData>MediaIdentifierDefaultData</DefaultData>
<IdLocation>^HS.IHE.ATN494C.MediaIdentiA133D</IdLocation>
<IndexLocation>^HS.IHE.ATN494C.MediaIdentiA133I</IndexLocation>
<StreamLocation>^HS.IHE.ATN494C.MediaIdentiA133S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
