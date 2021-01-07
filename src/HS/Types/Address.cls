Class HS.Types.Address Extends (%SerialObject, %XML.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property StreetLine As %String(MAXLEN = "");

Property StreetNumber As %String(MAXLEN = "") [ SqlComputeCode = { Set {*}=$Piece($ZStrip({StreetLine}, "<>W"), " ", 1)}, SqlComputed ];

Property StreetName As %String(MAXLEN = "") [ SqlComputeCode = { Set {*}=$Piece($ZStrip({StreetLine}, "<>W"), " ", 2, $Length({StreetLine}, " ") - 1)}, SqlComputed ];

Property StreetType As %String(MAXLEN = "") [ SqlComputeCode = { Set {*}=$Piece($ZStrip({StreetLine}, "<>W"), " ", $Length({StreetLine}, " "))}, SqlComputed ];

Property UnitNumber As %String;

Property POBox As %String;

Property County As %String(MAXLEN = 64);

Property City As %String(MAXLEN = 64);

Property State As %String(MAXLEN = 64);

Property PostalCode As %String(MAXLEN = 64);

Property Precinct As %String(MAXLEN = 64);

Property Country As %String(MAXLEN = 64);

/// Values taken from HL7v3 TelecommunicationAddressUse Domain (OID: 2.16.840.1.113883.1.11.201)
/// Also see:	http://aurora.regenstrief.org/v3dt/datatypes-its-xml.html#comp-AD.use
Property Use As %String(DISPLAYLIST = ",Alphabetic,Bad Address,Home,Primary Home,Vacation Home,Ideographic,Visit Address,Postal Address,Syllabic,Temporary Address,Work Place,Billing,Mailing", VALUELIST = ",ABC,BAD,H,HP,HV,IDE,PHYS,PST,SYL,TMP,WP,BIL,ML");

Property PrimaryFlag As HS.Types.Boolean;

Property Status As %String(DISPLAYLIST = ","""",Active,Inactive", VALUELIST = ","""",A,I") [ InitialExpression = "A" ];

Property Description As %String(MAXLEN = "");

Storage Default
{
<Data name="AddressState">
<Value name="1">
<Value>StreetLine</Value>
</Value>
<Value name="2">
<Value>StreetNumber</Value>
</Value>
<Value name="3">
<Value>StreetName</Value>
</Value>
<Value name="4">
<Value>StreetType</Value>
</Value>
<Value name="5">
<Value>UnitNumber</Value>
</Value>
<Value name="6">
<Value>POBox</Value>
</Value>
<Value name="7">
<Value>County</Value>
</Value>
<Value name="8">
<Value>City</Value>
</Value>
<Value name="9">
<Value>State</Value>
</Value>
<Value name="10">
<Value>PostalCode</Value>
</Value>
<Value name="11">
<Value>Precinct</Value>
</Value>
<Value name="12">
<Value>Country</Value>
</Value>
<Value name="13">
<Value>Use</Value>
</Value>
<Value name="14">
<Value>PrimaryFlag</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>Description</Value>
</Value>
</Data>
<State>AddressState</State>
<StreamLocation>^HS.Types.AddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
