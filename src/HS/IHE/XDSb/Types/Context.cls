Class HS.IHE.XDSb.Types.Context Extends (%RegisteredObject, %XML.Adaptor, HS.Util.CopyFrom)
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Patient MPI ID
Property MPIID As %String(MAXLEN = "");

/// Patient MRN, if any
Property MRN As %String(MAXLEN = "");

/// Patient Assigning Authority for the MRN, if any
Property AssigningAuthority As %String(MAXLEN = "");

/// Patient Facility for the MRN, if any
Property Facility As %String(MAXLEN = "");

/// Encounter for the content, if any (null if multiple encounters)
Property VisitNumber As %String(MAXLEN = "");

/// The type of document: XML, CCD, PDF, HTML, CUSTOM
Property TransformType As %String(MAXLEN = "");

/// The transform sub-type: C32, CCR, ReportID, CustomOperation
Property TransformOption As %String(MAXLEN = "");

/// The ID of the service (registry or repository) responsible for the document
Property ServiceId As %String(MAXLEN = "");

/// Terminology Translation Profile
Property TransProfile As %String(MAXLEN = 256);

Storage Default
{
<Data name="ContextState">
<Value name="1">
<Value>MPIID</Value>
</Value>
<Value name="2">
<Value>MRN</Value>
</Value>
<Value name="3">
<Value>AssigningAuthority</Value>
</Value>
<Value name="4">
<Value>Facility</Value>
</Value>
<Value name="5">
<Value>VisitNumber</Value>
</Value>
<Value name="6">
<Value>TransformType</Value>
</Value>
<Value name="7">
<Value>TransformOption</Value>
</Value>
<Value name="8">
<Value>ServiceId</Value>
</Value>
<Value name="9">
<Value>TransProfile</Value>
</Value>
</Data>
<State>ContextState</State>
<StreamLocation>^HS.IHE.XDSb.Types.ContextS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
