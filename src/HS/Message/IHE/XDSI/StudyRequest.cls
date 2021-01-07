Class HS.Message.IHE.XDSI.StudyRequest Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Property StudyInstanceUID As %String(MAXLEN = 512);

Property Series As list Of HS.Message.IHE.XDSI.SeriesRequest;

Storage Default
{
<Data name="StudyRequestState">
<Value name="1">
<Value>StudyInstanceUID</Value>
</Value>
<Value name="2">
<Value>Series</Value>
</Value>
</Data>
<State>StudyRequestState</State>
<StreamLocation>^HS.Message.IHDBE8.StudyRequestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
