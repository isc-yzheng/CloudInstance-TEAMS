/// <p>
/// Identifies the status of a financial resource.
/// </p><p>
/// To conform to the FHIR CARIN Blue Button Implementation Profiles, 
/// the Code property in this class requires the value set defined at http://hl7.org/fhir/ValueSet/fm-status. 
/// Refer to the HealthShare documentation for information on translating local codes into defined value sets.
/// </p><p>
/// Examples of FHIR financial resources that use the FHIR ValueSet
/// http://hl7.org/fhir/fm-status to supply values for their "code" property:
/// </p><p>
/// Resource: EnrollmentRequest.status (code / Required) <br/>
/// Resource: CoverageEligibilityResponse.status (code / Required) <br/>
/// Resource: PaymentNotice.status (code / Required) <br/>
/// Resource: VisionPrescription.status (code / Required) <br/>
/// Resource: EnrollmentResponse.status (code / Required) <br/>
/// Resource: ClaimResponse.status (code / Required) <br/>
/// Resource: PaymentReconciliation.status (code / Required) <br/>
/// Resource: Coverage.status (code / Required) <br/>
/// Resource: CoverageEligibilityRequest.status (code / Required) <br/>
/// Resource: Claim.status (code / Required) <br/>
/// </p>
Class HS.SDA3.CodeTableDetail.FinancialResourceStatus Extends HS.SDA3.CodeTableTranslated
{

Property Extension As HS.Local.SDA3.CodeTableDetail.FinancialResourceStatusExtension;

/// <p>
/// Identifies the status of a financial FHIR resource. 
/// </p><p>
/// To conform to the FHIR CARIN Blue Button Implementation Profiles, 
/// this property requires the value set defined at http://hl7.org/fhir/ValueSet/fm-status. 
/// Refer to the HealthShare documentation for information on translating local codes into defined value sets.
/// </p>
Property Code As HS.SDA3.StrippedString(MAXLEN = 32000);

/// <p>
/// Display text for the status of a financial FHIR resource. 
/// </p><p>
/// As is normal behavior for HS.SDA3.CodeTableDetail subclasses,
/// if no Description is provided, the Code value is displayed.
/// </p>
Property Description As HS.SDA3.StrippedString(MAXLEN = 32000);

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
<Value>EId</Value>
</Value>
<Value name="8">
<Value>OriginalText</Value>
</Value>
<Value name="9">
<Value>PriorCodes</Value>
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
