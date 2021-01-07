Class HS.SDA3.PharmacyExplanationOfBenefit Extends (HS.SDA3.SuperClass, HS.SDA3.AbstractExplanationOfBenefit)
{

Property Extension As HS.Local.SDA3.PharmacyExplanationOfBenefitExtension;

/// Unique identifier within the payer's system that applies to the entire claim.
Property PharmacyClaimNumber As %String(MAXLEN = 450);

/// Number of days supply of medication dispensed by the pharmacy.
Property DaysSupply As HS.SDA3.Numeric;

/// Prescriber's instruction regarding substitution of generic equivalents
/// or order to dispense the specific prescribed medication.
Property DispensedAsWritten As HS.SDA3.CodeTableDetail.DispensedAsWritten;

/// The number fill of the current dispensed supply (0, 1, 2, etc.)
Property RefillNumber As HS.SDA3.Numeric;

/// Whether the prescription was transmitted as an electronic prescription, 
/// by phone, by fax, or as a written paper copy.
Property PrescriptionOrigin As HS.SDA3.CodeTableDetail.PrescriptionOrigin;

/// Whether the plan adjudicated the claim as a brand or generic drug.
Property BrandGenericIndicator As HS.SDA3.CodeTableDetail.BrandGenericIndicator;

/// NCPDP Compound Code.
Property CompoundCode As HS.SDA3.CodeTableDetail.CompoundCode;

/// Details of the drugs provided.
Property PharmacyEOBLines As list Of HS.SDA3.PharmacyEOBLine;

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
<Value>BrandGenericIndicator</Value>
</Value>
<Value name="20">
<Value>CompoundCode</Value>
</Value>
<Value name="21">
<Value>PharmacyEOBLines</Value>
</Value>
<Value name="22">
<Value>Use</Value>
</Value>
<Value name="23">
<Value>DaysSupply</Value>
</Value>
<Value name="24">
<Value>DispensedAsWritten</Value>
</Value>
<Value name="25">
<Value>Extension</Value>
</Value>
<Value name="26">
<Value>OtherCoverage</Value>
</Value>
<Value name="27">
<Value>Payer</Value>
</Value>
<Value name="28">
<Value>PharmacyClaimNumber</Value>
</Value>
<Value name="29">
<Value>PrescriptionOrigin</Value>
</Value>
<Value name="30">
<Value>RefillNumber</Value>
</Value>
<Value name="31">
<Value>Status</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
