/// *** THIS CLASS, ALONG WITH ALL OTHER QRDA FUNCTIONALITY INITIALLY INCLUDED IN<br>
/// *** HEALTHSHARE CORE 13, IS DEPRECATED AS OF HEALTH CONNECT / HEALTHSHARE 2018.1.
Class HS.Registry.QualityMeasure Extends (%Persistent, HS.Types.QualityMeasureInfo, HS.Util.CopyFrom, %XML.Adaptor)
{

Index CodeIndex On Code [ Unique ];

ClassMethod ObjectForCode(pCode As %String = "") As HS.Registry.QualityMeasure
{
	Set tSC = ..CodeRow(pCode, .tID)
	If $$$ISERR(tSC) Quit ""
	Quit ..%OpenId(tID)
}

/// Find an IdentityCode / IdentityType for an OID when not found the OID will be returned in the
/// IdentityCode but an error will be returned in the Status
ClassMethod CodeRow(pCode As %String = "", ByRef pID As %Integer) As %Status
{
	Set pID="",SQLCODE=100
	If pCode]""  {
		&sql(select ID,Code into :tID,:tCode from HS_Registry.QualityMeasure where Code=:pCode)
	}
	If 'SQLCODE Set pID=tID
	
	Quit $S(SQLCODE:$$$ERROR($$$GeneralError,"Measure not found"),1:$$$OK)
}

Storage Default
{
<Data name="QualityMeasureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>VersionSpecificId</Value>
</Value>
<Value name="4">
<Value>NQFNumber</Value>
</Value>
<Value name="5">
<Value>AuthoringToolIdRoot</Value>
</Value>
<Value name="6">
<Value>AuthoringToolIdExtension</Value>
</Value>
<Value name="7">
<Value>Title</Value>
</Value>
<Value name="8">
<Value>VersionNeutralId</Value>
</Value>
<Value name="9">
<Value>VersionNumber</Value>
</Value>
</Data>
<Data name="TemplateIds">
<Attribute>TemplateIds</Attribute>
<Structure>subnode</Structure>
<Subscript>"TemplateIds"</Subscript>
</Data>
<DataLocation>^HS.Registry.QualityMeasureD</DataLocation>
<DefaultData>QualityMeasureDefaultData</DefaultData>
<IdLocation>^HS.Registry.QualityMeasureD</IdLocation>
<IndexLocation>^HS.Registry.QualityMeasureI</IndexLocation>
<StreamLocation>^HS.Registry.QualityMeasureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
