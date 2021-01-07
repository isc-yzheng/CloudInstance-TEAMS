/// Once IMT is in the kits, add the following line back in
/// Include %Identity.common
Class HS.Registry.Person.Base Extends %XML.Adaptor [ Abstract ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property NameParts As HS.Types.PersonName;

Property Identifiers As list Of HS.Types.Identifier(STORAGEDEFAULT = "array");

Property Addresses As list Of HS.Types.Address(STORAGEDEFAULT = "array");

Property Telecoms As list Of HS.Types.Telecom(STORAGEDEFAULT = "array");

/// *** DEPRECATED *** this property is deprecated as of 2018.1 as it's not been used.
Property BirthDateTime As HS.Types.DateTime;

Property BirthPlace As HS.Types.Address;

Property AdministrativeGender As %String;

Property MaritalStatus As %String;

Property ReligiousAffiliation As %String;

Property Race As %String;

Property EthnicGroup As %String;

Property LanguageCommunication As %String;

Property VIPIndicator As %Boolean;

/// Additional person information
Property AdditionalInfo As array Of %String(MAXLEN = 1024);

}
