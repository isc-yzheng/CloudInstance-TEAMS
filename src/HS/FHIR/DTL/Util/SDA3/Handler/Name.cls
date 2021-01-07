Class HS.FHIR.DTL.Util.SDA3.Handler.Name
{

/// Concatenate the family name prefix with the family name to adhere
/// to the FHIR spec for family name representations
ClassMethod FamilyName(familyName As %String, familyNamePrefix As %String = "") As %String
{
	if familyNamePrefix '= "" {
		quit familyNamePrefix _ " " _ familyName
	}
	else {
		quit familyName
	}
}

/// Return the entire contents of the name as one string, to be saved in a single 'text' element.
ClassMethod Text(familyName As %String, namePrefix As %String, nameSuffix As %String, givenName As %String, middleName As %String, professionalSuffix As %String, familyNamePrefix As %String) As %String
{
	quit $s(namePrefix'="":namePrefix_" ",1:"")_givenName_$s(middleName'="":" "_middleName,1:"")_$s(familyName'="":" "_..FamilyName(familyName, familyNamePrefix),1:"")_$s(nameSuffix'="":" "_nameSuffix,1:"")_$s(professionalSuffix'="":" "_professionalSuffix,1:"")
}

}
