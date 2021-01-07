/// Embedded in the AddUpdateHubResponse, this contains everything needed to
/// process the message using a subscription
Class HS.Types.SubscriptionSerialInfo Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property SubscriptionId As %String;

/// C - Clinician, S - System
Property RecipientType As %String;

/// for the clinician or the system
Property RecipientID As %String;

/// Deprecated - newer use will use AccessGWID and EndPoint
Property AccessGateway As %String(MAXLEN = 500);

/// the ID of the access gateway in the HS.Gateway.Config table
Property AccessGWID As %String;

/// Calculation will contain the endpoint URL to get to the access gateway to contact the delivery manager
Property AccessGWEndPoint As %String(MAXLEN = 500) [ Calculated, SqlComputeCode = {Set {AccessGWEndPoint} = ##Class(HS.Types.SubscriptionSerialInfo).GetAccessGWEndPoint({AccessGWID}) }, SqlComputed ];

/// Whether to schedule notification
Property BatchNotification As %Boolean;

ClassMethod GetAccessGWEndPoint(pGWID)
{
	Quit:pGWID="" ""
	Quit ##Class(HS.Gateway.Config).%OpenId(pGWID).EndPoint
}

/// This will contain the endpoint ID from the delivery policy (ID in the service registry)
/// For EDI policies, it gets passed into the custom delivery operation
/// For Email policies, it gets passed into the custom email construction operation, where it's
/// available for constructing a link to some external system
Property EndPoint As %String(MAXLEN = 500);

Property EmailAddress As %String(MAXLEN = 500);

Property FaxNumber As %String(MAXLEN = 80);

Property UserId As %String;

/// EMAIL or OTHER (future - FAX)
Property DeliveryType As %String(VALUELIST = ",EMAIL,FAX,EDI,XDR,XDSb.Stable,XDSb.OnDemand");

Property DeliveryOperation As Ens.DataType.ConfigName;

Property EmailOperation As Ens.DataType.ConfigName;

/// Included here so we can eliminate duplicate transmissions using the same delivery
Property DeliveryPolicyID As %String;

/// XSLT, PDF, HTML, or CUSTOM, or nil (for plain SDA)
Property TransformationType As %String;

Property XSLTFileSpec As %String;

Property PatientReportId As %String;

Property TransformCustomOperation As Ens.DataType.ConfigName;

Property Subject As %String(MAXLEN = 256);

Property DetailFilters As list Of HS.Push.Types.FilterSerialInfo;

/// Determines the SDA container sent to the transform
Property ContentScope As %String(VALUELIST = ",Msg,Enc,MRN,MPI");

/// The roles for this recipient used to determine the RecipientConsent
/// If null, consent evaluation is skipped
Property RecipientRoles As %String(MAXLEN = "");

/// The consent for this recipient applied on the SDA container before transformation.
/// If null, consent evaluation is skipped
Property RecipientConsent As %String(MAXLEN = "");

/// Terminology Translation Profile
Property TransProfile As %String(MAXLEN = 256);

Property AnalyticsFilters As list Of HS.Push.Types.FilterSerialInfo;

Storage Default
{
<Data name="SubscriptionSerialInfoState">
<Value name="1">
<Value>SubscriptionId</Value>
</Value>
<Value name="2">
<Value>RecipientType</Value>
</Value>
<Value name="3">
<Value>RecipientID</Value>
</Value>
<Value name="4">
<Value>AccessGateway</Value>
</Value>
<Value name="5">
<Value>AccessGWID</Value>
</Value>
<Value name="6">
<Value>BatchNotification</Value>
</Value>
<Value name="7">
<Value>EndPoint</Value>
</Value>
<Value name="8">
<Value>EmailAddress</Value>
</Value>
<Value name="9">
<Value>FaxNumber</Value>
</Value>
<Value name="10">
<Value>UserId</Value>
</Value>
<Value name="11">
<Value>DeliveryType</Value>
</Value>
<Value name="12">
<Value>DeliveryOperation</Value>
</Value>
<Value name="13">
<Value>EmailOperation</Value>
</Value>
<Value name="14">
<Value>DeliveryPolicyID</Value>
</Value>
<Value name="15">
<Value>TransformationType</Value>
</Value>
<Value name="16">
<Value>XSLTFileSpec</Value>
</Value>
<Value name="17">
<Value>PatientReportId</Value>
</Value>
<Value name="18">
<Value>TransformCustomOperation</Value>
</Value>
<Value name="19">
<Value>Subject</Value>
</Value>
<Value name="20">
<Value>DetailFilters</Value>
</Value>
<Value name="21">
<Value>ContentScope</Value>
</Value>
<Value name="22">
<Value>RecipientRoles</Value>
</Value>
<Value name="23">
<Value>RecipientConsent</Value>
</Value>
<Value name="24">
<Value>TransProfile</Value>
</Value>
<Value name="25">
<Value>AnalyticsFilters</Value>
</Value>
</Data>
<State>SubscriptionSerialInfoState</State>
<StreamLocation>^HS.Types.SubscriptioC23BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
