/// Address appears in the SDA as properties of the Guarantor, HealthFund,<br>
/// Patient, and SupportContact, as well as CareProvider, FamilyDoctor,<br>
/// HealthFund, Organization, and ReferralDoctor in the HS.SDA3.CodeTableDetail<br>
/// package. How Address is parsed from HL7 and what fields, if any, are<br>
/// inserted into the Viewer Cache will depend on the specific property the<br>
/// Address is being used for, and are documented in the annotations for that<br>
/// property.
Class HS.SDA3.Address Extends HS.SDA3.DataType
{

Property Extension As HS.Local.SDA3.AddressExtension;

/// Effective start date for this address
Property FromTime As HS.SDA3.TimeStamp;

/// Effective end date for this address
Property ToTime As HS.SDA3.TimeStamp;

/// Everything in the address before city<br>
/// For multi-line street addresses, the suggested format is:<br>
/// "[firstline]; [secondline]; [thirdline]..."<br>
/// For example: "144/89; Moo 10; Soi 6"
Property Street As %String(MAXLEN = 220);

/// SDATableName=City, ViewerClass=User.HS.CTCity
Property City As HS.SDA3.CodeTableDetail.City;

/// SDATableName=State, ViewerClass=User.HS.CTProvince
Property State As HS.SDA3.CodeTableDetail.State;

/// ZIP or postal code<br><br>
/// SDATableName=Zip, ViewerClass=User.HS.CTZip
Property Zip As HS.SDA3.CodeTableDetail.Zip;

/// SDATableName=Country, ViewerClass=User.HS.CTCountry
Property Country As HS.SDA3.CodeTableDetail.Country;

/// SDATableName=County, ViewerClass=User.HS.CTCountyParish
Property County As HS.SDA3.CodeTableDetail.County;

Storage Default
{
<Data name="AddressState">
<Subscript>"Address"</Subscript>
<Value name="1">
<Value>StartDate</Value>
</Value>
<Value name="2">
<Value>EndDate</Value>
</Value>
<Value name="3">
<Value>Street</Value>
</Value>
<Value name="4">
<Value>City</Value>
</Value>
<Value name="5">
<Value>State</Value>
</Value>
<Value name="6">
<Value>Zip</Value>
</Value>
<Value name="7">
<Value>Country</Value>
</Value>
<Value name="8">
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>CountyCode</Value>
</Value>
<Value name="11">
<Value>County</Value>
</Value>
<Value name="12">
<Value>Extension</Value>
</Value>
</Data>
<State>AddressState</State>
<Type>%Storage.Serial</Type>
}

}
