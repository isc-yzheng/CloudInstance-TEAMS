/// The Viewer Cache table for HealthCareFacility, CTLoc, is not constrained to<br>
/// have unique Codes or Descriptions. HealthCareFacilities are matched in the<br>
/// Viewer Cache on Code, SDACodingStandard, and Organization.
Class HS.SDA3.CodeTableDetail.HealthCareFacility Extends HS.SDA3.CodeTableDetail
{

Property Extension As HS.Local.SDA3.CodeTableDetail.HealthCareFacilityExtension;

/// VIEWERLIB: User.HS.CTLoc(CTLOCCode)
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// VIEWERLIB: User.HS.CTLoc(CTLOCDesc)
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

/// Organization to which the facility belongs<br>
/// The Code for HealthCareFacility is only unique within an Organization, so<br>
/// there can be, for example, "LAB" at two different hospitals<br>
/// (Organizations).<br><br>
/// Viewer Cache:<br>
/// If the HealthCareFacility has no Organization, one is defaulted in with<br>
/// Code = [SendingFacility of the SDA Container]. This is done before<br>
/// matching, so the Organization used for matching may be defaulted.<br><br>
/// SDATableName=Organization, ViewerClass=User.HS.CTHospital<br>
/// VIEWERLIB: User.HS.CTLoc(CTLOCHospitalDR)<br>
Property Organization As HS.SDA3.CodeTableDetail.Organization;

/// Type of location (e.g. Clinic, ER, Department, Ward, Other)<br><br>
/// VIEWERLIB: Not stored
Property LocationType As %String(VALUELIST = ",CLINIC,ER,DEPARTMENT,WARD,OTHER");

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
<Value>Organization</Value>
</Value>
<Value name="8">
<Value>LocationType</Value>
</Value>
<Value name="9">
<Value>EId</Value>
</Value>
<Value name="10">
<Value>CodeSystemVersionId</Value>
</Value>
<Value name="11">
<Value>Extension</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
