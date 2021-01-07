/// 
Class HS.IHE.ATNA.Repository.EventCube Extends %DeepSee.CubeDefinition [ DependsOn = HS.IHE.ATNA.Repository.Aggregation, ProcedureBlock ]
{

Parameter DOMAIN = "HS";

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Audit Events" displayName="Audit Events" disabled="false" abstract="false" sourceClass="HS.IHE.ATNA.Repository.Aggregation" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0">
  <dimension name="Event Type" disabled="false" hasAll="true" allCaption="All EventType" allDisplayName="EventType" type="data" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="EventType" name="Event Type" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false">
      <level sourceProperty="EventSubType" name="Event SubType" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false">
      <level sourceProperty="IsSource" sourceExpression="$Case(%source.IsSource,1:&quot;True&quot;,0:&quot;False&quot;,:&quot;&quot;)" name="Is Source" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EventTimeD" disabled="false" hasAll="false" allCaption="All LocalDateTime" allDisplayName="LocalDateTime" sourceProperty="LocalDateTime" type="time" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
      <level name="Quarter Year" disabled="false" timeFunction="QuarterYear" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
      <level name="Month Year" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
      <level name="WeekYear" disabled="false" timeFunction="WeekYear" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
      <level name="Date" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false">
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false">
      <level name="Hour of Day" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Event Weekday" disabled="false" hasAll="false" allCaption="All Event Weekday" allDisplayName="Event Weekday" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false">
      <level sourceExpression="$system.SQL.DAYNAME(%source.LocalDateTime)" name="Event Weekday" disabled="false" list="false" useDisplayValue="false" useAsFilter="true">
        <member name="Sunday" displayName="Sunday" disabled="false"></member>
        <member name="Monday" displayName="Monday" disabled="false"></member>
        <member name="Tuesday" displayName="Tuesday" disabled="false"></member>
        <member name="Wednesday" displayName="Wednesday" disabled="false"></member>
        <member name="Thursday" displayName="Thursday" disabled="false"></member>
        <member name="Friday" displayName="Friday" disabled="false"></member>
        <member name="Saturday" displayName="Saturday" disabled="false"></member>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="User" disabled="false" hasAll="false" allCaption="All UserName" allDisplayName="UserName" type="data" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="UserName" name="User Name" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false">
      <level sourceProperty="PrimaryFacility" name="Facility" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Audit Source" disabled="false" hasAll="false" allCaption="All AuditSourceID" allDisplayName="AuditSourceID" type="data" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="AuditSourceID" name="Audit Source ID" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false">
      <level sourceProperty="InitiatedAt" name="Initiated At" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Source" disabled="false" hasAll="false" allCaption="All SourceURI" allDisplayName="SourceURI" type="data" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="SourceURI" name="Source URI" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false">
      <level sourceProperty="SourceNetworkAccess" name="Source Network Access Point" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Destination" disabled="false" hasAll="false" allCaption="All DestinationURI" allDisplayName="DestinationURI" type="data" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="DestinationURI" name="Destination URI" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false">
      <level sourceProperty="DestinationNetworkAccess" name="Destination Network Access Point" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Outcome" disabled="false" hasAll="false" allCaption="All Outcome" allDisplayName="Outcome" type="data" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="Outcome" name="Outcome" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Action Code" disabled="false" hasAll="false" allCaption="All ActionCode" allDisplayName="ActionCode" type="data" iKnowType="entity" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="ActionCode" name="Action Code" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="SubmissionSetUniqueID" disabled="false" hasAll="false" allCaption="All SubmissionSetUniqueID" allDisplayName="SubmissionSetUniqueID" type="data" hidden="false" showHierarchies="false">
    <hierarchy name="H1" disabled="false">
      <level sourceProperty="SubmissionSetUniqueID" name="SubmissionSetUniqueID" disabled="false" list="false" useDisplayValue="true" useAsFilter="true">
      </level>
    </hierarchy>
  </dimension>
  <measure sourceExpression="%cube.GetPatientCount(%source.%ID)" name="Number of Patients" disabled="false" aggregate="SUM" type="integer" hidden="false" searchable="false" iKnowSource="string"></measure>
  <measure sourceExpression="%cube.GetDocumentCount(%source.%ID)" name="Number of Documents" disabled="false" aggregate="SUM" type="integer" hidden="false" searchable="false" iKnowSource="string"></measure>
  <listing name="Basic Audit Data" disabled="false" listingType="table" fieldList="EventType,EventSubType,IsSource,LocalDateTime,UserName,PrimaryFacility,AuditSourceID,InitiatedAt,SourceURI,DestinationURI,ActionCode,Outcome"></listing>
  <listing name="Patient Listing" disabled="false" listingType="table" sql="SELECT source.EventType, source.LocalDateTime, P.PatientName, P.Identifier FROM $$$SOURCE, HS_IHE_ATNA_Repository.Patient P WHERE $$$RESTRICT  AND source.ID=P.AggregationID"></listing>
  <listing name="Document Listing" disabled="false" listingType="table" sql="SELECT source.EventType, source.LocalDateTime, D.DocumentID, D.RepositoryID, D.HomeCommunityID FROM $$$SOURCE, HS_IHE_ATNA_Repository.Document D WHERE $$$RESTRICT  AND source.ID=D.AggregationID"></listing>
</cube>
}

ClassMethod GetPatientCount(pID) As %Boolean
{
	Set tEvent=##class(HS.IHE.ATNA.Repository.Aggregation).%OpenId(pID)
	Quit $S($IsObject(tEvent):tEvent.Patients.Count(),1:0)
}

ClassMethod GetDocumentCount(pID) As %Boolean
{
	Set tEvent=##class(HS.IHE.ATNA.Repository.Aggregation).%OpenId(pID)
	Quit $S($IsObject(tEvent):tEvent.Documents.Count(),1:0)
}

}
