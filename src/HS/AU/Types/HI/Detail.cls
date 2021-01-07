Class HS.AU.Types.HI.Detail Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0";

Parameter XMLNAME = "detail";

Parameter XMLSEQUENCE = 1;

Property Any As list Of %XML.String(XMLNAME = "any", XMLPROJECTION = "ANY") [ SqlFieldName = _any ];

Storage Default
{
<Data name="DetailState">
<Value name="1">
<Value>Any</Value>
</Value>
</Data>
<State>DetailState</State>
<StreamLocation>^HS.AU.Types.HI.DetailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
