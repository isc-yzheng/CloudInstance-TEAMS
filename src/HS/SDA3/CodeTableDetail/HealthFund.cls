/// In the Viewer Cache, HealthFunds are matched on Code and SDACodingStandard<br>
/// only. If a match is found on Code and SDACodingStandard and the<br>
/// Descriptions are different, the Description in the Viewer Cache is updated.<br>
/// Note that the Description must still be unique and therefore may have a<br>
/// uniqueness suffix added.
Class HS.SDA3.CodeTableDetail.HealthFund Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.HealthFundExtension;

Parameter XMLTYPE = "HealthFundCode";

Parameter XMLNAME = "HealthFund";

/// VIEWERLIB: User.HS.ARCInsuranceType(INSTCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.ARCInsuranceType(INSTDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: Not stored
Property Address As HS.SDA3.Address;

/// VIEWERLIB: Not stored
Property ContactPerson As HS.SDA3.Name;

/// VIEWERLIB: Not stored
Property ContactInfo As HS.SDA3.ContactInfo;

/// Whether the organization's record is still in active use.
Property IsActive As HS.SDA3.Boolean;

Storage Default
{
<Data name="CodeTableDetailState">
<Value name="1">
<Value>SDATableName</Value>
</Value>
<Value name="2">
<Value>SDACodingStandard</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>InternalReference</Value>
</Value>
<Value name="6">
<Value>ErrorStatus</Value>
</Value>
<Value name="7">
<Value>Address</Value>
</Value>
<Value name="8">
<Value>ContactPerson</Value>
</Value>
<Value name="9">
<Value>ContactInfo</Value>
</Value>
<Value name="10">
<Value>EId</Value>
</Value>
<Value name="11">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="12">
<Value>Extension</Value>
</Value>
<Value name="13">
<Value>OriginalText</Value>
</Value>
<Value name="14">
<Value>PriorCodes</Value>
</Value>
<Value name="15">
<Value>IsActive</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
