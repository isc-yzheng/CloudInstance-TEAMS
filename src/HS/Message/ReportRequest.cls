/// This class is used to transport a report request
/// The conditions are all copied in from a temp global when the request is made,
/// and stuck back into a temp global when the request is received
Class HS.Message.ReportRequest Extends HS.Util.EnsRequest
{

Property Gateway As %String(MAXLEN = 500);

/// The name of the zen report class
Property ReportClass As %String(MAXLEN = "");

/// XML, HTML, or PDF or Excel
Property ContentType As %String;

Property BooleanConditions As list Of %String;

Property ComparisonConditions As list Of HS.Reports.SerialCondition;

Property InlistConditions As list Of HS.Reports.SerialCondition;

Storage Default
{
<Data name="ReportRequestDefaultData">
<Subscript>"ReportRequest"</Subscript>
<Value name="1">
<Value>ReportClass</Value>
</Value>
<Value name="2">
<Value>ContentType</Value>
</Value>
<Value name="3">
<Value>BooleanConditions</Value>
</Value>
<Value name="4">
<Value>ComparisonConditions</Value>
</Value>
<Value name="5">
<Value>InlistConditions</Value>
</Value>
<Value name="6">
<Value>Gateway</Value>
</Value>
</Data>
<DefaultData>ReportRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
