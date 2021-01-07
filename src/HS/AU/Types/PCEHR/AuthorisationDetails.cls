Class HS.AU.Types.PCEHR.AuthorisationDetails Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter XMLNAME = "authorisationDetails";

Parameter XMLSEQUENCE = 1;

Property AccessType As %String(MAXLEN = "", VALUELIST = ",AccessCode,EmergencyAccess", XMLNAME = "accessType");

Property AccessCode As %String(MAXLEN = "", XMLNAME = "accessCode");

Storage Default
{
<Data name="AuthorisationDetailsState">
<Value name="1">
<Value>AccessType</Value>
</Value>
<Value name="2">
<Value>AccessCode</Value>
</Value>
</Data>
<State>AuthorisationDetailsState</State>
<StreamLocation>^HS.AU.Type72D3.AuthorisatiC67CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
