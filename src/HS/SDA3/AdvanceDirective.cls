/// HS.SDA3.AdvanceDirective corresponds to the CDA Advance Directives section.
Class HS.SDA3.AdvanceDirective Extends HS.SDA3.SuperClass
{

Property Extension As HS.Local.SDA3.AdvanceDirectiveExtension;

/// Type of alert - can be used for grouping<br><br>
/// SDATableName=AlertType, ViewerClass=User.HS.PACAlertCategory<br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMAlertCategoryDR)<br>
Property AlertType As HS.SDA3.CodeTableDetail.AlertType;

/// Alert code (e.g. Advanced Directive, Patient Information)<br><br>
/// Streamlet cache:<br>
/// If the AdvanceDirective does not have an Alert, then in the OnValidate<br>
/// method of the Streamlet class, an error will be logged to the Ensemble<br>
/// Event Log and the streamlet will not be saved.<br><br>
/// SDATableName=Alert, ViewerClass=User.HS.PACPatientAlert<br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMAlertDR)<br>
Property Alert As HS.SDA3.CodeTableDetail.Alert;

/// Comments on the alert<br>
/// CRLF-delimited string<br><br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMMessage)
Property Comments As %String(MAXLEN = "");

/// Alert status<br>
/// Possible values are "A" for "Active", "I" for "Inactive", and "C" for "To<br>
/// Be Confirmed".<br><br>
/// Streamlet cache:<br>
/// In the OnBeforeMatch method of the Streamlet class, if the Status is<br>
/// not "A", "I", or "C" (or null or the delete instruction), it will be<br>
/// set to null and an alert logged.<br><br>
/// Viewer cache:<br>
/// The value that appears in the viewer does not come from the DISPLAYLIST<br>
/// of the ALMStatus property, but rather the Description for the corresponding<br>
/// AlertStatus Standard Type Item.  See the HS documentation for guidance on<br>
/// configuring this.<br><br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMStatus)
Property Status As %String;

/// SDATableName=User, ViewerClass=User.HS.SSUser<br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMCreateUser)
Property EnteredBy As HS.SDA3.CodeTableDetail.User;

/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMLastUpdateHospitalDR)
Property EnteredAt As HS.SDA3.CodeTableDetail.Organization;

/// VIEWERLIB: User.HS.PAAlertMsg(ALMCreateDate) + User.HS.PAAlertMsg(ALMCreateTime)
Property EnteredOn As HS.SDA3.TimeStamp;

/// Beginning of effective time range<br><br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMOnsetDate) + User.HS.PAAlertMsg(ALMOnsetTime)<br>
Property FromTime As HS.SDA3.TimeStamp;

/// End of effective time range<br><br>
/// VIEWERLIB: User.HS.PAAlertMsg(ALMClosedDate) + User.HS.PAAlertMsg(ALMClosedTime)<br>
Property ToTime As HS.SDA3.TimeStamp;

/// VIEWERLIB: User.HS.PAAlertMsg(ALMExternalId)
Property ExternalId As %String(MAXLEN = 220);

/// Supported values:<br>
/// D = Delete<br>
/// I = Inactivate All (set Status="I")<br>
/// C = Clear All<br>
/// Any other value = Add or Update<br>
/// See the annotation on the superclass property for more information on how<br>
/// ActionCode is used.<br><br>
/// VIEWERLIB: Not stored
Property ActionCode As %String;

/// Not used.
Property ActionScope As %String;

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
<Value>AlertType</Value>
</Value>
<Value name="12">
<Value>Alert</Value>
</Value>
<Value name="13">
<Value>Comments</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>UpdatedOn</Value>
</Value>
<Value name="16">
<Value>CustomPairs</Value>
</Value>
<Value name="17">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
