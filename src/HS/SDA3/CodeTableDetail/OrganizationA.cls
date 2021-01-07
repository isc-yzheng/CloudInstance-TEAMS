/// In the Viewer Cache, Organizations are matched on Code and<br>
/// SDACodingStandard only. Other properties stored in the Viewer Cache,<br>
/// including Description, will be updated if they are different in the inbound<br>
/// Organization versus the matched CTHospital.
/// This class is used in place of HS.SDA3.CodeTableDetail.Organization in order to avoid a dependency look
/// caused by the MedicalDirector property referencing a CareProvider, which now has an AtOrganization property
Class HS.SDA3.CodeTableDetail.OrganizationA Extends HS.SDA3.CodeTableDetail
{

Property Extension As HS.Local.SDA3.CodeTableDetail.OrganizationExtension;

/// VIEWERLIB: User.HS.CTHospital(HOSPCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTHospital(HOSPDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// Viewer cache:<br>
/// If an inbound Organization matches an existing CTHospital on Code and<br>
/// SDACodingStandard, then if the Street, City, State, and Zip are not all<br>
/// null, then the Street, City, State, Zip, County, and Country of the<br>
/// Organization will be compared to the corresponding properties of the<br>
/// CTHospital, and if any are found to be different, the CTHospital is<br>
/// determined to need an update (of all properties, not just Address).<br>
/// If the CTHospital is determined to need an update, then as long as the<br>
/// Street, City, State, Zip, County, and Country properties of the inbound<br>
/// Organization are not all null, they will all be inserted into the Viewer<br>
/// Cache, even if some of them are are null, and even if they overwrite<br>
/// non-null values.<br><br>
/// .Street<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPAddress)<br>
/// .City<br>
/// SDATableName=City, ViewerClass=User.HS.CTCity<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCity)<br>
/// .State<br>
/// SDATableName=State, ViewerClass=User.HS.CTProvince<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPProvinceDR)<br>
/// .Zip<br>
/// SDATableName=Zip, ViewerClass=User.HS.CTZip<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPZipDR)<br>
/// .County<br>
/// SDATableName=County, ViewerClass=User.HS.CTCountyParish<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCountyParishDR)<br>
/// .Country<br>
/// SDATableName=Country, ViewerClass=User.HS.CTCountry<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPCountryDR)
Property Address As HS.SDA3.Address;

/// Viewer cache:<br>
/// If an inbound Organization matches an existing CTHospital on Code and<br>
/// SDACodingStandard, then if the EmailAddress or WorkPhoneNumber of the<br>
/// Organization is not null and different from the corresponding property of<br>
/// the CTHospital, then the CTHospital is determined to need an update (of all<br>
/// properties, not just ContactInfo).<br>
/// If the CTHospital is determined to need an update, then the EmailAddress<br>
/// and WorkPhoneNumber will be inserted into the Viewer Cache if not null.<br><br>
/// .WorkPhoneNumber<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPPhone)<br>
/// .EmailAddress<br>
/// VIEWERLIB: User.HS.CTHospital(HOSPEmail)
Property ContactInfo As HS.SDA3.ContactInfo;

/// The trusts to which this organization belongs<br><br>
/// Viewer cache:<br>
/// If an inbound Organization matches an existing CTHospital on Code and<br>
/// SDACodingStandard, then if the Organization has Trusts and if the inbound<br>
/// list of Trusts is not the same as the existing list (note that order of the<br>
/// list matters), then the CTHospital is determined to need an update (of all<br>
/// properties, not just Trusts).<br>
/// If the CTHospital is determined to need an update, then if the inbound<br>
/// Organization has any Trusts, they will update the Viewer Cache in<br>
/// "snapshot" mode.  That is, the existing Trusts will be cleared, and the<br>
/// inbound ones inserted.<br><br>
/// VIEWERLIB: User.HS.CTHospital(ChildCTHospitalTrusts)->User.HS.CTHospitalTrusts(TRUSTTrustDR)
Property Trusts As list Of HS.SDA3.CodeTableDetail.Trust;

/// Identifiers for the organization. Examples:
/// National Provider Identifier (NPI), tax ID number,
/// Clinical Laboratory Improvement Amendments (CLIA) Number.
Property Identifiers As list Of HS.SDA3.Identifier;

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
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="6">
<Value>InternalReference</Value>
</Value>
<Value name="7">
<Value>EId</Value>
</Value>
<Value name="8">
<Value>ErrorStatus</Value>
</Value>
<Value name="9">
<Value>Extension</Value>
</Value>
<Value name="10">
<Value>Address</Value>
</Value>
<Value name="11">
<Value>ContactInfo</Value>
</Value>
<Value name="12">
<Value>Trusts</Value>
</Value>
<Value name="13">
<Value>Identifiers</Value>
</Value>
<Value name="14">
<Value>IsActive</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
