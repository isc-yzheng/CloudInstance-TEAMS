Class HS.Registry.Person.User.WebServices.Containers.QueryItem Extends (%Persistent, %XML.Adaptor, HS.Util.CopyFrom) [ ClassType = persistent ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Query type can be:
/// U - User.  Pass in the UserID
/// L - Login.  Pass in the LoginID and Domain
/// I - Identifier (generic clinician identifiers).  Pass in the AssigningAuthorityName and the Identifier.
Property QueryType As %String;

Property LoginID As %String;

Property Domain As %String;

Property AssigningAuthorityName As %String;

Property Identifier As %String;

Property UserID As %String;

/// This can be set to 0 to allow a fetch of inactive users.  Note that it is possible to have
/// multiple inactive users with the same deterministic identifier(s) - in this case, it will
/// return the first one it encounters.
Property Active As %Boolean [ InitialExpression = 1 ];

/// This is populated in the query response, if the query finds a user/clinician
Property InternalID As %String;

/// This is populated in the query response, if the query finds a user/clinician
/// It is needed if the API user wants to issue updates, and expires after 15 minutes
Property AccessToken As %String;

Storage Default
{
<Data name="QueryItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryType</Value>
</Value>
<Value name="3">
<Value>LoginID</Value>
</Value>
<Value name="4">
<Value>Domain</Value>
</Value>
<Value name="5">
<Value>AssigningAuthorityName</Value>
</Value>
<Value name="6">
<Value>Identifier</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>InternalID</Value>
</Value>
<Value name="9">
<Value>AccessToken</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^HS.Registry.Pers1585.QueryItemD</DataLocation>
<DefaultData>QueryItemDefaultData</DefaultData>
<IdLocation>^HS.Registry.Pers1585.QueryItemD</IdLocation>
<IndexLocation>^HS.Registry.Pers1585.QueryItemI</IndexLocation>
<StreamLocation>^HS.Registry.Pers1585.QueryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
