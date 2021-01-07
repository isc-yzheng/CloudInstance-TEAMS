Class HS.IHE.XDSb.Repository.Documents Extends %Persistent
{

Property Document As %Stream.GlobalBinary;

Property DocumentID As %String(MAXLEN = 1024);

Property DocumentName As %String(MAXLEN = 1024);

Property DocumentDescription As %String(MAXLEN = 1024);

Property DocumentSize As %Integer;

Property DocumentHash As %String;

Property DocumentMimeType As %String(MAXLEN = "");

Index DocumentIDIndex On DocumentID [ IdKey, PrimaryKey, Unique ];

ClassMethod DocumentObjectForID(pDocumentID, pDocument) As %Status
{
	If '..%ExistsId(pDocumentID) Quit $$$ERROR($$$GeneralError,"Unable to locate document")
	Set tSC=$$$OK
	Set pDocument=..%OpenId(pDocumentID,0,.tSC)
	Quit tSC
}

Storage Default
{
<Data name="DocumentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Document</Value>
</Value>
<Value name="3">
<Value>DocumentName</Value>
</Value>
<Value name="4">
<Value>DocumentDescription</Value>
</Value>
<Value name="5">
<Value>DocumentSize</Value>
</Value>
<Value name="6">
<Value>DocumentHash</Value>
</Value>
<Value name="7">
<Value>DocumentMimeType</Value>
</Value>
</Data>
<DataLocation>^HS.IHE.XDSb.RepoBDA5.DocumentsD</DataLocation>
<DefaultData>DocumentsDefaultData</DefaultData>
<IdLocation>^HS.IHE.XDSb.RepoBDA5.DocumentsD</IdLocation>
<IndexLocation>^HS.IHE.XDSb.RepoBDA5.DocumentsI</IndexLocation>
<StreamLocation>^HS.IHE.XDSb.RepoBDA5.DocumentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
