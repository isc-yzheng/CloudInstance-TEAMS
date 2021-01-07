Class HS.AU.Types.PCEHR.PersonRecord Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/PCEHRProfile/1.0";

Parameter XMLNAME = "PCEHRRecord";

Parameter XMLSEQUENCE = 1;

Property AuthorisationDetails As HS.AU.Types.PCEHR.AuthorisationDetails(XMLNAME = "authorisationDetails");

Property Individual As HS.AU.Types.PCEHR.Individual(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "individual", XMLREF = 1);

Storage Default
{
<Data name="PersonRecordState">
<Value name="1">
<Value>AuthorisationDetails</Value>
</Value>
<Value name="2">
<Value>Individual</Value>
</Value>
</Data>
<State>PersonRecordState</State>
<StreamLocation>^HS.AU.Types.P72D3.PersonRecordS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
