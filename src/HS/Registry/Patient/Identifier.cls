Class HS.Registry.Patient.Identifier Extends (%Persistent, HS.Types.Identifier, %Populate)
{

Parameter XMLTYPE = "PatIdentifier";

Relationship Patient As HS.Registry.Patient [ Cardinality = parent, Inverse = Identifiers ];

Index SearchIdx On (Use, Extension, AssigningAuthorityName);

Index IDIndex On Idx [ IdKey ];

Property Idx As %Integer;

Method %OnAddToSaveSet(depth As %Integer, insert As %Integer, callcount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	// To guarantee ordering per patient
	Set:..Idx="" ..Idx=$I(^HS.Registry.Patient.MainC("Identifiers"))
		
	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	Set tMRN=..Patient.FacilityGetObjectId()_"^"_..Patient.AssigningAuthority_"^"_..Patient.MRN
	Set tIdent=..Use_"^"_..AssigningAuthorityName_"^"_..Extension
	IF tMRN'="",tIdent'="" Set ^HS.Registry.Patient.IdentifierH(tIdent,tMRN)=""
	Quit $$$OK
}

Storage Default
{
<Data name="IdentifierDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Root</Value>
</Value>
<Value name="3">
<Value>Extension</Value>
</Value>
<Value name="4">
<Value>AssigningAuthorityName</Value>
</Value>
<Value name="5">
<Value>Use</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Identifiers")</DataLocation>
<DefaultData>IdentifierDefaultData</DefaultData>
<IdLocation>^HS.Registry.Patient.MainC("Identifiers")</IdLocation>
<IndexLocation>^HS.Registry.Pat3C95.IdentifierI</IndexLocation>
<StreamLocation>^HS.Registry.Pat3C95.IdentifierS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
