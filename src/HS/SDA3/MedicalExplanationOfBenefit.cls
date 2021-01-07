Class HS.SDA3.MedicalExplanationOfBenefit Extends (HS.SDA3.SuperClass, HS.SDA3.AbstractExplanationOfBenefit)
{

Property Extension As HS.Local.SDA3.MedicalExplanationOfBenefitExtension;

/// Information about diagnoses relevant to the claim items. ICD-10 or ICD-9.
Property Diagnoses As list Of HS.SDA3.Diagnosis;

/// Unique identifier within the payer's system that applies to the entire claim.
Property MedicalClaimNumber As %String(MAXLEN = 450);

/// Details of the products or services provided.
Property MedicalEOBLines As list Of HS.SDA3.MedicalEOBLine;

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>AdjudicatedCoverage</Value>
</Value>
<Value name="14">
<Value>AdjudicationStatus</Value>
</Value>
<Value name="15">
<Value>BillingProvider</Value>
</Value>
<Value name="16">
<Value>ClaimProcessedDate</Value>
</Value>
<Value name="17">
<Value>ClaimType</Value>
</Value>
<Value name="18">
<Value>InOutNetwork</Value>
</Value>
<Value name="19">
<Value>OtherCoverage</Value>
</Value>
<Value name="20">
<Value>Payer</Value>
</Value>
<Value name="21">
<Value>Status</Value>
</Value>
<Value name="22">
<Value>Use</Value>
</Value>
<Value name="23">
<Value>Diagnoses</Value>
</Value>
<Value name="24">
<Value>Extension</Value>
</Value>
<Value name="25">
<Value>MedicalClaimNumber</Value>
</Value>
<Value name="26">
<Value>MedicalEOBLines</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
