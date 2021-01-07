/// Basic information about a person
Class HS.Types.PersonInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Person's lastname
Property LastName As %String(MAXLEN = 80);

/// Person's middlename
Property MiddleName As %String(MAXLEN = 220);

/// Person's firstname
Property FirstName As %String(MAXLEN = 60);

/// Person's name prefix
Property Prefix As %String(MAXLEN = 60);

/// Person's name suffix
Property Suffix As %String(MAXLEN = 60);

/// Person gender
Property Sex As %String(MAXLEN = 220);

/// Person's  date-of-birth
Property DOB As HS.Types.Date(FORMAT = 3);

/// Person's street address
Property Street As %String(MAXLEN = 128);

/// Person's city
Property City As %String(MAXLEN = 64);

/// Person's state or province
Property State As %String(MAXLEN = 64);

/// Person's postal code
Property Zip As %String(MAXLEN = 16);

/// Person's social security or government id
///  (made long to support hashed SSNs)
Property SSN As %String(MAXLEN = 220);

/// Person's home telephone number
Property Telephone As %String;

/// Person's business telephone number
Property BusinessPhone As %String;

/// Person's race
Property Race As %String;

/// Person's city of birth
Property CityOfBirth As %String(MAXLEN = 64);

/// Drivers' license number
Property DriversLicenseNumber As %String(MAXLEN = 64);

/// Mothers Maiden Surname
Property MothersMaidenSurname As %String(MAXLEN = 80);

/// Birth order, if in a multiple birth, else 0, or NULL if unknown
Property BirthOrder As HS.Types.Numeric;

Property BirthPlace As HS.Types.Address;

Property MaritalStatus As %String;

Property ReligiousAffiliation As %String;

Property EthnicGroup As %String;

Property Language As %String;

Property VIP As HS.Types.Boolean;

/// Home and work phone also listed above, for backwards compatability
Property Telecoms As list Of HS.Types.Telecom(STORAGEDEFAULT = "list");

/// Main address also listed above, for backwards compatability
Property Addresses As list Of HS.Types.Address(STORAGEDEFAULT = "list");

/// Main name also listed above
Property Names As list Of HS.Types.PersonName(STORAGEDEFAULT = "list");

/// For MU2
Property CommunicationPreference As %String(VALUELIST = ","""",Email,Phone,Mail");

Property CreatedBy As %String(MAXLEN = 200);

Property CreatedOn As %TimeStamp;

Property LastEnteredBy As %String(MAXLEN = 200);

Property LastEnteredOn As %TimeStamp;

Property DeathStatus As HS.Types.Boolean;

/// Time of death<br>
/// Must be an SDA timestamp to allow the delete instruction (two double
/// quotes) to be passed to the Registry.
Property DeathTime As HS.Types.TimeStamp;

Property FathersName As HS.Types.PersonName;

Property MothersName As HS.Types.PersonName;

Property SpousesName As HS.Types.PersonName;

}
