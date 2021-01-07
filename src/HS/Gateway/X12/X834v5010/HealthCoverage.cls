/// This corresponds to a SDA3 MemberEnrollment
Class HS.Gateway.X12.X834v5010.HealthCoverage Extends (%SerialObject, %XML.Adaptor)
{

Property NationalPlanID As %String;

Property PrimaryCareProvider As HS.SDA3.CodeTableDetail.CareProvider;

Property PrimaryCareFacility As HS.SDA3.CodeTableDetail.HealthCareFacility;

Storage Default
{
<Data name="HealthCoverageState">
<Value name="1">
<Value>NationalPlanID</Value>
</Value>
<Value name="2">
<Value>PrimaryCareProvider</Value>
</Value>
<Value name="3">
<Value>PrimaryCareFacility</Value>
</Value>
</Data>
<State>HealthCoverageState</State>
<StreamLocation>^HS.Gateway3B4E.HealthCoverageS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
