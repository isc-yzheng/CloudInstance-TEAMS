Class HS.SDA3.AbstractClaim [ Abstract, NoExtent ]
{

/// The date the claim was processed by the carrier or its designee for adjudication.<br>
Property ClaimProcessedDate As HS.SDA3.TimeStamp;

/// The Payer Claim Control Number previously assigned to this claim line in a prior reporting period.<br>
Property FormerClaimNumber As %String;

Property ReceivedDate As HS.SDA3.TimeStamp;

Property MedicalClaimLines As list Of HS.SDA3.MedicalClaimLine;

}
