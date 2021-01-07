Class HS.FHIR.DTL.SubXFrm.vR4.SDA3.ContactPoint.ContactInfo [ DependsOn = (HS.SDA3.ContactInfo, %Library.ListOfObjects) ]
{

/// Populates a ContactInfo element from a list of ContactPoints. If a phone system doesn't have a use, it will default to
/// HomePhoneNumber, unless that field already has a value.
ClassMethod Transform(source As %RegisteredObject, Output target As %RegisteredObject, Output aux = "") As %Status
{
	set tSC = $$$OK
	try {
		for i=1:1:source.Count() {
			if source.GetAt(i).system = "phone" {
				if source.GetAt(i).use = "home" {
					set target.HomePhoneNumber = source.GetAt(i).value
				}
				elseif source.GetAt(i).use = "mobile" {
					set target.MobilePhoneNumber = source.GetAt(i).value
				}
				elseif source.GetAt(i).use = "work" {
					set target.WorkPhoneNumber = source.GetAt(i).value
				}
				elseif (source.GetAt(i).use = "") && (target.HomePhoneNumber = "") {
					set target.HomePhoneNumber = source.GetAt(i).value
				}
			}
			elseif source.GetAt(i).system = "email" {
				set target.EmailAddress = source.GetAt(i).value
			}
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
