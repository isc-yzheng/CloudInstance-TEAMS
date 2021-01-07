/// This class represents each dosage step for a Medication or Vaccination.<br>
/// There may be only one step, where the drug is prescribed with just one<br>
/// dosage, or there can be several steps, such 20mg QID for 3 days, then 10mg<br>
/// BID for 5 days. DosageSteps are captured in snapshot mode.  This means that<br>
/// any time DosageSteps are passed in for a Medication or Vaccination, the<br>
/// existing list is cleared before the inbound DosageSteps are saved.
Class HS.SDA3.DosageStep Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.DosageStepExtension;

/// Text instructions/directions<br>
/// Length subject to the total streamlet size limit - 3,000,000<br><br>
/// Viewer cache:<br>
/// OEORIDepProcNotes is also where the TextInstruction of the parent order is<br>
/// stored. However, if the TextInstruction of the first DosageStep in the list<br>
/// is not null, it will overwrite this value.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDepProcNotes)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREDesc)<br>
Property TextInstruction As %String(MAXLEN = "");

/// How often (e.g. Code=QID, Desc=QID, Factor=4)<br>
/// QID is Latin, meaning 4x a day.  BID means 2x day, etc.<br><br>
/// Viewer cache:<br>
/// OEORIPHFreqDR is also where the Frequency of the parent order is stored.<br>
/// However, if the Frequency of the first DosageStep in the list is not null,<br>
/// it will overwrite this value.<br><br>
/// SDATableName=Frequency, ViewerClass=User.HS.PHCFreq<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIPHFreqDR)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREPHCFreqDR)<br>
Property Frequency As HS.SDA3.CodeTableDetail.Frequency;

/// Size of dose (e.g. the 20 in 20mg)<br><br>
/// Viewer cache:<br>
/// OEORIDoseQty is also where the DoseQuantity of the parent order is stored.<br>
/// However, if the DoseQuantity of the first DosageStep in the list is not<br>
/// null, it will overwrite this value.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDoseQty)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREPhQtyOrd)<br>
Property DoseQuantity As HS.SDA3.Numeric;

/// Units for DoseQuantity (e.g. the mg in 20mg)<br><br>
/// Viewer cache:<br>
/// OEORIUnitDR is also where the DoseUoM of the parent order is stored.<br>
/// However, if the DoseUoM of the first DosageStep in the list is not null, it<br>
/// will overwrite this value.<br><br>
/// SDATableName=UoM, ViewerClass=User.HS.CTUOM<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIUnitDR)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEORECTUOMDR)<br>
Property DoseUoM As HS.SDA3.CodeTableDetail.UoM;

/// Duration of the step (e.g. input could be start time and duration)<br><br>
/// Viewer cache:<br>
/// OEORIDuratDR is also where the Duration of the parent order is stored.<br>
/// However if the Duration of the first DosageStep in the list is not null, it<br>
/// will overwrite this value.<br><br>
/// SDATableName=Duration, ViewerClass=User.HS.PHCDuration<br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIDuratDR)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREPHCDurationDR)<br>
Property Duration As HS.SDA3.CodeTableDetail.Duration;

/// The Start Date/Time of the step<br><br>
/// Viewer cache:<br>
/// OEORISttDat and OEORISttTim are where the FromTime of the parent order is<br>
/// stored. However if the FromTime of the first DosageStep in the list is not<br>
/// null, it will overwrite these values.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORISttDat) + User.HS.OEOrdItem(OEORISttTim)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREExSttDat)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREExSttTim)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// The End Date/Time of the step<br><br>
/// Viewer cache:<br>
/// OEORIEndDat and OEORIEndTim are where the ToTime of the parent order is<br>
/// stored. However if the ToTime of the first DosageStep in the list is not<br>
/// null, it will overwrite these values.<br><br>
/// VIEWERLIB: User.HS.OEOrdItem(OEORIEndDat) + User.HS.OEOrdItem(OEORIEndTim)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREExEnDat)<br>
/// VIEWERLIB: User.HS.OEOrdItem(ChildOEOrdExec)->User.HS.OEOrdExec(OEOREExEnTim)<br>
Property ToTime As HS.SDA3.TimeStamp;

/// Not used.
Property ActionCode As %String(XMLIO = "OUT");

/// Not used.
Property ActionScope As %String;

/// Not used.
Property UpdatedOn As HS.SDA3.TimeStamp;

/// Not used.
Property ExternalId As %String(MAXLEN = 220);

/// Not used.
Property EncounterNumber As %String(MAXLEN = 220);

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
<Value>StartTime</Value>
</Value>
<Value name="9">
<Value>EndTime</Value>
</Value>
<Value name="10">
<Value>TextInstruction</Value>
</Value>
<Value name="11">
<Value>Frequency</Value>
</Value>
<Value name="12">
<Value>DoseQuantity</Value>
</Value>
<Value name="13">
<Value>DoseUoM</Value>
</Value>
<Value name="14">
<Value>Duration</Value>
</Value>
<Value name="15">
<Value>FromTime</Value>
</Value>
<Value name="16">
<Value>ToTime</Value>
</Value>
<Value name="17">
<Value>Deleted</Value>
</Value>
<Value name="18">
<Value>UpdatedOn</Value>
</Value>
<Value name="19">
<Value>CustomPairs</Value>
</Value>
<Value name="20">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
