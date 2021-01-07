Class HS.Types.Telecom Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor, HS.Util.CopyFrom) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property PhoneNumberFull As %String [ SqlComputeCode = { Set {*}={PhoneCountryCode}_$S({PhoneCountryCode}]"":"-",1:"")_{PhoneAreaCode}_$S({PhoneAreaCode}]"":"-",1:"")_{PhoneNumber}}, SqlComputed ];

Property PhoneCountryCode As %String(MAXLEN = 64);

Property PhoneAreaCode As %String(MAXLEN = 64);

Property PhoneNumber As %String(MAXLEN = 64);

Property URL As %String(MAXLEN = "");

Property Email As %String(MAXLEN = 500);

/// Possible values in HS_Codes.EmailType table.
Property EmailType As %String(MAXLEN = 64);

/// Whether the provided email is the primary one
Property PrimaryFlag As %Boolean;

/// Used to specify what kind of telecom this is:  Fax, Pager, Land, or Mobile
/// Do not export to JSON by default
Property Type As %String(DISPLAYLIST = ",Fax,Pager,Land,Mobile,Other", VALUELIST = ",F,P,L,M,O");

/// Used to specify how this telecom will be used:  Primary Home, Vacation Home, Work Place, etc...
/// Values taken from HL7v3 TelecommunicationAddressUse Domain (OID: 2.16.840.1.113883.1.11.201)
/// Also see:	http://www.hl7.org/documentcenter/public_temp_77F950A7-1C23-BA17-0C5765ECF9A9F9C5/standards/vocabulary/vocabulary_tables/infrastructure/vocabulary/vs_AddressUse.html#TelecommunicationAddressUse
Property Use As %String(DISPLAYLIST = ",Answering Service,Bad,Direct,Emergency Contact,Home,Primary Home,Vacation Home,Mobile Contact,Pager,Public,Temporary,Work Place,", VALUELIST = ",AS,BAD,DIR,EC,H,HP,HV,MC,PG,PUB,TMP,WP,");

Property Status As %String(DISPLAYLIST = ",Active,Inactive", VALUELIST = ",A,I");

/// Base JSON translations.
/// Type is internal only so not exported.
/// PhoneNumberFull is SqlComputed so not exported.
XData BasicReference [ XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="PhoneNumberFull" Include="NONE"/>
<Property Name="PhoneCountryCode" FieldName="phone_country_code"/>
<Property Name="PhoneAreaCode" FieldName="phone_area_code"/>
<Property Name="PhoneNumber" FieldName="phone_number"/>
<Property Name="URL" FieldName="url"/>
<Property Name="Email" FieldName="email"/>
<Property Name="EmailType" FieldName="email_type"/>
<Property Name="PrimaryFlag" FieldName="primary_flag"/>
<Property Name="Type" Include="NONE"/>
<Property Name="Use" FieldName="use"/>
<Property Name="Status" FieldName="status"/>
</Mapping>
}

/// Mapping Block for JSON projection of any property that requires only the Phone properties from this class
XData Phone [ XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="PhoneCountryCode" FieldName="phone_country_code"/>
<Property Name="PhoneAreaCode" FieldName="phone_area_code"/>
<Property Name="PhoneNumber" FieldName="phone_number"/>
<Property Name="Use" FieldName="use"/>
</Mapping>
}

/// Mapping Block for JSON projection of any property that requires only the Email properties from this class
XData Email [ XMLNamespace = "http://www.intersystems.com/jsonmapping" ]
{
<Mapping IgnoreNull="true" Null="true" xmlns="http://www.intersystems.com/jsonmapping">
<Property Name="Email" FieldName="email"/>
<Property Name="EmailType" FieldName="email_type"/>
<Property Name="PrimaryFlag" FieldName="primary_flag"/>
</Mapping>
}

Storage Default
{
<Data name="TelecomState">
<Value name="1">
<Value>PhoneNumberFull</Value>
</Value>
<Value name="2">
<Value>PhoneCountryCode</Value>
</Value>
<Value name="3">
<Value>PhoneAreaCode</Value>
</Value>
<Value name="4">
<Value>PhoneNumber</Value>
</Value>
<Value name="5">
<Value>URL</Value>
</Value>
<Value name="6">
<Value>Email</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Use</Value>
</Value>
<Value name="9">
<Value>EmailType</Value>
</Value>
<Value name="10">
<Value>PrimaryFlag</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
</Data>
<State>TelecomState</State>
<StreamLocation>^HS.Types.TelecomS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
