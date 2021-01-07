Class HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.ContactInfo.ContactPoint [ DependsOn = (HS.SDA3.ContactInfo, %Library.ListOfObjects) ]
{

ClassMethod Transform(source As %RegisteredObject, Output target As %RegisteredObject, Output aux = "") As %Status
{
	set tSC = $$$OK
	try {
		set packageModel = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageModelName("vSTU3")
		if (packageModel = "") quit
		set target = ##class(%ListOfObjects).%New()
		for prop = "EmailAddress", "HomePhoneNumber", "MobilePhoneNumber", "WorkPhoneNumber" {
			if $property(source, prop) '= "" {
				set entry = $classmethod(packageModel _ ".Datatype.ContactPoint", "%New")
				set entry.value = $property(source, prop)
				set entry.system = $select(prop="EmailAddress":"email", 1:"phone")
				set entry.use = $select(prop="EmailAddress":"", prop="HomePhoneNumber":"home", prop="MobilePhoneNumber":"mobile", prop="WorkPhoneNumber":"work")
				
				//Add extensions (if any have been mapped)
				if (##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.ContactInfo.ContactPoint")) {
					lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.ContactInfo.ContactPoint")
					set entry = ##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.ContactInfo.ContactPoint).Transform(source.Extension, .entry, .aux)
					lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.ContactInfo.ContactPoint") 
				}
				do target.Insert(entry) 
			}
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod GetTargetType(create) As %String
{
	quit "HS.FHIR.DTL.vSTU3.Model.Datatype.ContactPoint"
}

}
