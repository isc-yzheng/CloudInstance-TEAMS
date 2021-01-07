/// Used to do a deterministic lookup
Class HS.Registry.Person.User.WebServices.Containers.Query Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// The query passes in a list of deterministic identifiers.  For each one, it checks to see if it can find
/// the user/clinician in the registry, and if so, set the InternalId for that queryitem in the response object
Property QueryItems As list Of HS.Registry.Person.User.WebServices.Containers.QueryItem;

/// will be non-null if an error happened
Property ErrMessage As %String;

Storage Default
{
<Data name="QueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryItems</Value>
</Value>
<Value name="3">
<Value>ErrMessage</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Person.U1585.QueryD</DataLocation>
<DefaultData>QueryDefaultData</DefaultData>
<IdLocation>^HS.Registry.Person.U1585.QueryD</IdLocation>
<IndexLocation>^HS.Registry.Person.U1585.QueryI</IndexLocation>
<StreamLocation>^HS.Registry.Person.U1585.QueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
