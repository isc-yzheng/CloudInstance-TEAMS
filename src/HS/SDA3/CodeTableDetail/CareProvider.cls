/// In the Viewer Cache, CareProviders are matched on Code, SDACodingStandard,<br>
/// Description, and CareProviderType (which is itself a code table). Other<br>
/// properties are updated if different.
Class HS.SDA3.CodeTableDetail.CareProvider Extends HS.SDA3.CodeTableDetail
{

Property Extension As HS.Local.SDA3.CodeTableDetail.CareProviderExtension;

/// VIEWERLIB: User.HS.CTCareProv(CTPCPCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTCareProv(CTPCPDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// Viewer cache:<br>
/// If the inbound CareProvider has a Name defined, then if the inbound<br>
/// FamilyName, GivenName, MiddleName, NamePrefix, FamilyNamePrefix,<br>
/// NameSuffix, and ProfessionalSuffix are not all null and if any differ from<br>
/// the corresponding properties of the matched CTCareProv, then the CTCareProv<br>
/// is determined to need an update (of all properties, not just Name).<br>
/// On add or update, the properties of Name listed below will only be inserted<br>
/// into the Viewer Cache if at least one of the properties is not null. If so,<br>
/// then the properties will all be inserted into the Viewer Cache, even nulls,<br>
/// and even if they overwrite non-null values.<br><br>
/// .FamilyName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPSurname)<br>
/// .GivenName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPFirstName)<br>
/// .MiddleName<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPOtherName)<br>
/// .NamePrefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTitle)<br>
/// .FamilyNamePrefix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextOne)<br>
/// .NameSuffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextTwo)<br>
/// .ProfessionalSuffix<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTextThree)<br>
Property Name As HS.SDA3.Name;

/// Viewer cache:<br>
/// If the inbound CareProvider has an Address defined, then if the inbound<br>
/// Street, City, and Zip are not all null and if any differ from the<br>
/// corresponding properties of the matched CTCareProv, then the CTCareProv<br>
/// is determined to need an update (of all properties, not just Address).<br>
/// On add or update, the properties of Address listed below will only be<br>
/// inserted into the Viewer Cache if at least one of the properties is not<br>
/// null. If so, then the properties will all be inserted into the Viewer<br>
/// Cache, even nulls, and even if they overwrite non-null values.<br>
/// Note that CTPCPStName is of type List of %String. HealthShare will only<br>
/// ever populate the first entry in the list.<br><br>
/// .Street<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPStName)<br>
/// .City<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCityDR)<br>
/// .Zip<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPZipDR)
Property Address As HS.SDA3.Address;

/// Viewer cache:<br>
/// For each of the properties of ContactInfo, if the inbound property is<br>
/// non-null and does not match the corresponding property of the matched<br>
/// CTCareProv, then the CTCareProv is determined to need an update (of all<br>
/// properties, not just ContactInfo).<br>
/// On add or update, for each of the properties of ContactInfo, the inbound<br>
/// property will only be inserted into the Viewer Cache if it is non-null.<br><br>
/// .HomePhoneNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTelH)<br>
/// .WorkPhoneNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPTelO)<br>
/// .MobilePhoneNumber<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPMobilePhone)<br>
/// .EmailAddress<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPEmail)
Property ContactInfo As HS.SDA3.ContactInfo;

/// This field may either refer to the specialty of the clinician<br>
/// (cardiologist, radiologist, etc.) or to his role in a given scenario<br>
/// (admitting, attending, etc.).<br><br>
/// Viewer cache:<br>
/// CareProviderType is a match property for CareProvider in the Viewer Cache.<br>
/// That is, it must match the existing CTPCPCarPrvTpDR for the CareProviders<br>
/// to be considered a match. A null value (either inbound or existing) will<br>
/// not match a non-null value.<br><br>
/// SDATableName=CareProviderType, ViewerClass=User.HS.CTCarPrvTp<br>
/// VIEWERLIB: User.HS.CTCareProv(CTPCPCarPrvTpDR)
Property CareProviderType As HS.SDA3.CodeTableDetail.CareProviderType;

/// A code that represents the type of name. For example: "L"\"Legal",<br>
/// "M"\"Maiden", "A"\"Alias". See HL7 table 200.<br><br>
/// VIEWERLIB: Not stored
Property NameTypeCode As %String;

/// A code corresponding to the type of identifier. For example: "NPI" for<br>
/// "National provider identifier".  See HL7 table 203.<br><br>
/// VIEWERLIB: Not stored
Property IdentifierTypeCode As %String;

/// This is to support use cases such as "individual provider at organization",
/// which is needed for care community.
/// VIEWERLIB: Not stored
Property AtOrganization As HS.SDA3.CodeTableDetail.OrganizationA;

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
<Value>Name</Value>
</Value>
<Value name="8">
<Value>Address</Value>
</Value>
<Value name="9">
<Value>ContactInfo</Value>
</Value>
<Value name="10">
<Value>CareProviderType</Value>
</Value>
<Value name="11">
<Value>EId</Value>
</Value>
<Value name="12">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="13">
<Value>NameTypeCode</Value>
</Value>
<Value name="14">
<Value>IdentifierTypeCode</Value>
</Value>
<Value name="15">
<Value>Extension</Value>
</Value>
<Value name="16">
<Value>AtOrganization</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
