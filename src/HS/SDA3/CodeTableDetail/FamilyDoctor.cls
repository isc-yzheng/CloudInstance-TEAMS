/// In the Viewer Cache, FamilyDoctors are matched on Code and<br>
/// SDACodingStandard only. Other properties stored in the Viewer Cache,<br>
/// including Description, will be updated if they are different in the inbound<br>
/// FamilyDoctor versus the matched PACRefDoctor.<br><br>
/// Note that both ReferralDoctor and FamilyDoctor CodeTableDetails populate<br>
/// the PACRefDoctor table in the Viewer Cache.
Class HS.SDA3.CodeTableDetail.FamilyDoctor Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.FamilyDoctorExtension;

/// VIEWERLIB: User.HS.PACRefDoctor(REFDCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.PACRefDoctor(REFDDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// Viewer cache:<br>
/// If the inbound FamilyDoctor matches a PACRefDoctor on Code and<br>
/// SDACodingStandard, then if the FamilyDoctor has a Name defined and<br>
/// FamilyName, GivenName, MiddleName, and NamePrefix are not all null, then<br>
/// they will be compared to the corresponding properties of the matched<br>
/// PACRefDoctor. If any property does not match, then the PACRefDoctor is<br>
/// determined to need an update (of all properties, not just the mismatched<br>
/// property).<br>
/// If the matched PACRefDoctor is determined to need an update, then if the<br>
/// FamilyDoctor has a Name defined, then FamilyName, GivenName, MiddleName,<br>
/// and NamePrefix are all inserted into the Viewer Cache, even if any of them<br>
/// are null, and even if they overwrite non-null values.<br><br>
/// .FamilyName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDFamilyName)<br>
/// .GivenName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDForename)<br>
/// .MiddleName<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDMiddleName)<br>
/// .NamePrefix<br>
/// VIEWERLIB: User.HS.PACRefDoctor(REFDTitle)
Property Name As HS.SDA3.Name;

/// VIEWERLIB: Not stored
Property Address As HS.SDA3.Address;

/// VIEWERLIB: Not stored
Property ContactInfo As HS.SDA3.ContactInfo;

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
<Value>Factor</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Address</Value>
</Value>
<Value name="10">
<Value>ContactInfo</Value>
</Value>
<Value name="11">
<Value>EId</Value>
</Value>
<Value name="12">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="13">
<Value>Extension</Value>
</Value>
<Value name="14">
<Value>OriginalText</Value>
</Value>
<Value name="15">
<Value>PriorCodes</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
