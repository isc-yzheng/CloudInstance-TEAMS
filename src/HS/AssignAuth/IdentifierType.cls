Class HS.AssignAuth.IdentifierType Extends (%Persistent, HS.Sync.BaseClass) [ ClassType = persistent, Inheritance = right ]
{

Parameter SYNCORDER = 150;

Index TypeIndex On Type [ IdKey, Unique ];

/// legacy list, no longer used
/// Property Type As %String(DISPLAYLIST = ",Driver's license number,Doctor number,License number,Medical record number,Patient internal identifier,Passport number,Patient external identifier,Subscriber Number,Social Security number,Organization identifier", VALUELIST = ",DL,DN,LN,MR,PI,PPN,PT,SN,SS,XX");
Property Type As %String;

Property Name As %String;

/// Whether to be use for a deterministic or probablistic search
Property ExactMatch As %Boolean [ InitialExpression = 0 ];

/// Controls whether the Identifier type appears in a list of identifiers in the Patient Search UI,
/// and if we're not operating in legacy identifier restrict mode, then also controls what additional
/// identifiers are allowed.
Property InSearchList As %Boolean [ InitialExpression = 0 ];

Property Active As %Boolean [ InitialExpression = 1 ];

Query ListIdentifierTypes(pActiveOnly As %Boolean = 1) As %SQLQuery
{
SELECT %Internal(ID) As ID,Name,Type,ExactMatch,InSearchList,Active FROM IdentifierType
 WHERE  (Active = 1 OR :pActiveOnly = 0)
 ORDER BY Name
}

/// the default case is that we ignore ExactMatch, but we have kept it in the
/// query for backwards compatibility
Query ListTypesForSearch(pExactMatch As %Integer = -1) As %SQLQuery
{
SELECT %Internal(ID) As ID,Name FROM IdentifierType
 WHERE  Active = 1 AND InSearchList = 1 AND ((ExactMatch = :pExactMatch) OR (:pExactMatch= -1))
 ORDER BY Name
}

Storage Default
{
<Data name="IdentifierTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ExactMatch</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>InSearchList</Value>
</Value>
</Data>
<DataLocation>^HS.AssignAuth.IdentifierTypeD</DataLocation>
<DefaultData>IdentifierTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HS.AssignAuth.IdentifierTypeD</IdLocation>
<IndexLocation>^HS.AssignAuth.IdentifierTypeI</IndexLocation>
<StreamLocation>^HS.AssignAuth.IdentifierTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
