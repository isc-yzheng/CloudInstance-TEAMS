/// Used for passing information about detail filters as part of SubscriptionSerialInfo
Class HS.Push.Types.FilterSerialInfo Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Name of filter
Property Name As %String;

/// XPath context for the expression
Property Context As %String(MAXLEN = 500);

/// XPath expression to be applied to the SDA. May contain parameters expressed as %1, %2, etc.
Property XPathExpression As %String(MAXLEN = 500);

/// The operator to be used in the filter
Property Operator As %String(DISPLAYLIST = ",Contains,Custom,Equals,Exists,Greater Than,In,Less Than,Starts With,Not Contain,Not Equal,Not Exist,Not Greater Than,Not In,Not Less Than,Not Start With", VALUELIST = ",CON,CUS,EQ,EX,GT,IN,LT,ST,NCN,NEQ,NEX,NGT,NIN,NLT,NST");

/// Name of the method to use for a custom filter (in the custom class in the \Push\Filter\Custom setting in HS.Registry.Config
Property CustomMethod As %String;

/// Names of parameters to be filled into the XPath expression of the filter or compared against the result
Property Parameters As list Of %String(MAXLEN = 256);

/*
		Analytics Filter Properties
*/
/// Name of the query registry item to run
/// 
Property QueryName As %String(MAXLEN = 256);

/// Analytics service name to send the query to
/// 
Property QueryService As %String(MAXLEN = 255);

/// When to execute the filter
/// 
Property QueryType As %String(DISPLAYLIST = ",Immediate,Transfer,Sync", VALUELIST = ",I,T,S");

/// The result column to evaluate
/// 
Property QueryColumn As %String(MAXLEN = 500);

/// The result row to evaluate
/// 
Property QueryRow As %String(MAXLEN = 500);

/// The operator to apply to the result
/// 
Property QueryOperator As HS.Types.Grid.Operator;

/// The class name if the operator is custom
/// 
Property QueryCustomClass As %String(MAXLEN = 256);

/// The method name if the operator is custom
/// 
Property QueryCustomMethod As %String(MAXLEN = 256);

/// List of query parameter names, parallel to the values list
/// 
Property QueryParameterNames As list Of %String(MAXLEN = 256);

/// List of query parameter values, parallel to the names list
/// 
Property QueryParameterValues As list Of %String(MAXLEN = 256);

/// The value for the result operator
/// 
Property QueryResultValue As %String(MAXLEN = 256);

/// The minimum count for 'true' result evaluations
/// 
Property QueryResultMinimum As %Integer;

/// The maximum count for 'true' result evaluations
/// 
Property QueryResultMaximum As %Integer;

Storage Default
{
<Data name="FilterSerialInfoState">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Context</Value>
</Value>
<Value name="3">
<Value>XPathExpression</Value>
</Value>
<Value name="4">
<Value>Operator</Value>
</Value>
<Value name="5">
<Value>Parameters</Value>
</Value>
<Value name="6">
<Value>CustomMethod</Value>
</Value>
<Value name="7">
<Value>QueryName</Value>
</Value>
<Value name="8">
<Value>QueryService</Value>
</Value>
<Value name="9">
<Value>QueryType</Value>
</Value>
<Value name="10">
<Value>QueryColumn</Value>
</Value>
<Value name="11">
<Value>QueryRow</Value>
</Value>
<Value name="12">
<Value>QueryOperator</Value>
</Value>
<Value name="13">
<Value>QueryCustomClass</Value>
</Value>
<Value name="14">
<Value>QueryCustomMethod</Value>
</Value>
<Value name="15">
<Value>QueryParameterNames</Value>
</Value>
<Value name="16">
<Value>QueryParameterValues</Value>
</Value>
<Value name="17">
<Value>QueryResultValue</Value>
</Value>
<Value name="18">
<Value>QueryResultMinimum</Value>
</Value>
<Value name="19">
<Value>QueryResultMaximum</Value>
</Value>
</Data>
<State>FilterSerialInfoState</State>
<StreamLocation>^HS.Push.Types.FilterSeriaC374S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
