Class HS.SDA3.AbstractIdentifier Extends HS.SDA3.DataType [ Abstract, NoExtent ]
{

/// <p>
/// The identifier.
/// </p>
Property Number As %String(MAXLEN = 220);

/// <p>
/// The coding system or assigning authority for the Number.
/// </p><p>
/// This identifies who actually assigned the Number. So if the NumberType is an MRN, 
/// this could be the URI of the health network which assigned that MRN to the patient.
/// Or, if the number comes from a coding system, this property can be set to a URI
/// to that coding system specification, or to an IdentityCode value from a row in the OID registry table 
/// that has its Type set to "CodeSystem" and other values in the row could provide 
/// further details about that coding system.
/// </p><p>
/// MAXLEN = 50 for compatibility with HS.SDA3.PatientNumber.
/// </p>
Property ISOAssigningAuthority As %String(MAXLEN = 50);

/// <p>
/// A label indicating the identifier type.
/// </p><p>
/// Patient identifier examples: 
/// Medical record number (MRN), social security number (SSN),
/// national identifier, driver's license, etc.
/// Organization identifier examples: 
/// National Provider Identifier (NPI), tax ID number,
/// Clinical Laboratory Improvement Amendments (CLIA) Number.
/// </p><p>
/// MAXLEN = 50 for compatibility with HS.SDA3.PatientNumber.
/// </p>
Property NumberType As %String(MAXLEN = 50);

/// The coding system for the identifier NumberType.
/// This property describes the coding system for the NumberType, not the Number.
/// This property can provide a URI that links to a description of the coding system.
/// Or, this property can be set to an IdentityCode value from a row in the OID registry table 
/// that has its Type set to "CodeSystem" and other values in the row could provide 
/// further details about that coding system.
Property NumberTypeCodeSystem As %String(MAXLEN = 220);

}
