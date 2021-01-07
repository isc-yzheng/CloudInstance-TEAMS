Class HS.Types.IHE.XDSb.Document Extends (HS.Types.IHE.XDSb.DocumentStored, HS.Types.IHE.XDSb.DocumentAdditional, HS.Util.CopyFrom)
{

/// If XMLIGNORENULL is set = "inputonly", then both missing tags in the XML and empty
/// strings are input as "".  Output of "" and $c(0) are for XMLIGNORENULL = 0:
/// $c(0) is output as an empty tag (i.e. &lt;tag&gt;&lt;/tag&gt;) and "" is output as no tag.<br><br>
Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
/// <p>It is passed the arguments provided in the %New call.
/// When customizing this method, override the arguments with whatever variables and types you expect to receive from %New().
/// For example, if you're going to call %New, passing 2 arguments, %OnNew's signature could be:
/// <p>Method %OnNew(dob as %Date = "", name as %Name = "") as %Status
/// If instead of returning a %Status code this returns an oref and this oref is a subclass of the current
/// class then this oref will be the one returned to the caller of %New method.
Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	Set tEntryUUID = ##class(HS.Util.XSLTHelper).createUUID()
	Set ..DocumentUniqueIdentifier.Value=##class(HS.Util.XSLTHelper).uuid2oid(tEntryUUID)
	Set ..EntryUUID="urn:uuid:"_tEntryUUID
	Quit $$$OK
}

Method GetSourcePatientPID(pPID) As %String
{
	Set tReturn=""
	For tIdx=1:1:..SourcePatientInfo.Count() {
		Set tValue=..SourcePatientInfo.GetAt(tIdx).Value
		If $E(tValue,1,$l(pPID))=pPID Set tReturn=$p(tValue,"|",2,999)
	}
	Quit tReturn
}

Storage Default
{
<Data name="DocumentStoredState">
<Value name="1">
<Value>LogicalUUID</Value>
</Value>
<Value name="2">
<Value>EntryUUID</Value>
</Value>
<Value name="3">
<Value>Availability</Value>
</Value>
<Value name="4">
<Value>AvailabilityStatus</Value>
</Value>
<Value name="5">
<Value>ClassCode</Value>
</Value>
<Value name="6">
<Value>Classifications</Value>
</Value>
<Value name="7">
<Value>Comments</Value>
</Value>
<Value name="8">
<Value>CreationTime</Value>
</Value>
<Value name="9">
<Value>DocumentUniqueIdentifier</Value>
</Value>
<Value name="10">
<Value>FormatCode</Value>
</Value>
<Value name="11">
<Value>Hash</Value>
</Value>
<Value name="12">
<Value>HealthCareFacilityTypeCode</Value>
</Value>
<Value name="13">
<Value>LanguageCode</Value>
</Value>
<Value name="14">
<Value>LegalAuthenticator</Value>
</Value>
<Value name="15">
<Value>MimeType</Value>
</Value>
<Value name="16">
<Value>ObjectType</Value>
</Value>
<Value name="17">
<Value>PatientIdentifier</Value>
</Value>
<Value name="18">
<Value>PracticeSettingCode</Value>
</Value>
<Value name="19">
<Value>RepositoryUniqueId</Value>
</Value>
<Value name="20">
<Value>ServiceStartTime</Value>
</Value>
<Value name="21">
<Value>ServiceStopTime</Value>
</Value>
<Value name="22">
<Value>Size</Value>
</Value>
<Value name="23">
<Value>Slots</Value>
</Value>
<Value name="24">
<Value>SourcePatientId</Value>
</Value>
<Value name="25">
<Value>SourcePatientInfo</Value>
</Value>
<Value name="26">
<Value>SourceIdentifier</Value>
</Value>
<Value name="27">
<Value>SubmissionTime</Value>
</Value>
<Value name="28">
<Value>Title</Value>
</Value>
<Value name="29">
<Value>TypeCode</Value>
</Value>
<Value name="30">
<Value>Version</Value>
</Value>
<Value name="31">
<Value>Author</Value>
</Value>
<Value name="32">
<Value>ConfidentialityCode</Value>
</Value>
<Value name="33">
<Value>EventCodeList</Value>
</Value>
<Value name="34">
<Value>URI</Value>
</Value>
<Value name="35">
<Value>XOP</Value>
</Value>
<Value name="36">
<Value>HomeCommunityId</Value>
</Value>
<Value name="37">
<Value>Body</Value>
</Value>
<Value name="38">
<Value>BodyCharacter</Value>
</Value>
<Value name="39">
<Value>ExternalIdentifiers</Value>
</Value>
<Value name="40">
<Value>ReplaceSource</Value>
</Value>
<Value name="41">
<Value>Descriptions</Value>
</Value>
<Value name="42">
<Value>Names</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
