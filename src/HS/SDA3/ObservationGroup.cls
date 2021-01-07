/// Observation groups are not created from inbound data. <br>
/// They can only be automatically created from Observations. <br>
/// ObservationGroup may appear along with Observation: <br>
/// currently only Blood Pressure observation is grouped. <br>
/// If an observation has the non empty ObservationGroup property then it is duplicated in the corresponding group<br><br>
Class HS.SDA3.ObservationGroup Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.ObservationGroupExtension;

Property Observations As list Of HS.SDA3.Observation;

/// Common time for observation members
Property ObservationTime As HS.SDA3.TimeStamp;

Property ObservationGroupCode As HS.SDA3.CodeTableDetail.Observation;

Property EncounterNumber As %String(MAXLEN = 220);

/// Internal method for testing
ClassMethod test() As ObservationGroup
{
	set tO1 = ##class(Observation).%New()
	set tO1.ObservationId = "streamletId1"
	set tO1.EncounterNumber = "HSVN00012"
	set tO1.ObservationTime = "2025-10-23 10:10:10"
	set tO1.ObservationCode.Code = "8480-6"
	set tO1.ObservationValue = "180"
	set tO1.ObservationCode.Description ="BP Systolic"
	set tO1.ObservationGroup =1
	set tO1.ObservationValueType = "NM"
	set tO2 = ##class(Observation).%New()
	set tO2.ObservationValue = "120"
	set tO2.ObservationId = "streamletId2"
	set tO2.ObservationTime = "2025-10-23 10:10:10"
	set tO2.EncounterNumber = "HSVN00012"
	set tO2.ObservationCode.Code = "8462-4"
	set tO2.ObservationCode.Description ="BP Diastolic"
	//<Observation><EncounterNumber>HSVN00012</EncounterNumber><ObservationTime>2018-02-15T12:00:00Z</ObservationTime><ObservationCode>
	//<Code>8462-4</Code><Description>BP Diastolic</Description></ObservationCode><ObservationValue>100</ObservationValue>
	//<ObservationValueType>NM</ObservationValueType></Observation>
	set tO2.ObservationGroup =1
	set tO2.ObservationValueType = "NM"

	set tOG = ..%New()
	set tOG.EncounterNumber = "HSVN00012"

	do tOG.Observations.Insert(tO1)
	do tOG.Observations.Insert(tO2)
	set tOG.ObservationTime ="2025-10-23 10:10:10"
	set tOG.ObservationGroupCode.Code = "85354-9"
	set tOG.ObservationGroupCode.Description ="Blood pressure panel with all children optional"
	d tOG.XMLExportToString(.str)
	w str
}

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>Extension</Value>
</Value>
<Value name="14">
<Value>Observations</Value>
</Value>
<Value name="15">
<Value>ObservationTime</Value>
</Value>
<Value name="16">
<Value>ObservationGroupCode</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
