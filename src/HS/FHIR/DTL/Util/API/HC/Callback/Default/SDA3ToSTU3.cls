Class HS.FHIR.DTL.Util.API.HC.Callback.Default.SDA3ToSTU3 Extends HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3
{

Property resourceIds As %String [ MultiDimensional ];

Property resourceHash As %String [ MultiDimensional ];

/// Check to see if the resource is a duplicate by hashing up to the first 32KB 
/// of the resource stream and searching for a direct match. Only then will the
/// resources be marked as duplicates. This is also only applied to "shared"
/// resources such as Organization, Practitioner, Medication, etc...
Method IsDuplicate(resource As HS.FHIR.DTL.vSTU3.Model.Base.Resource, Output id As %String) As %Boolean
{
	set duplicate = 0
	set id = ""
	set resourceStream = resource.ToJSON()
	if ##class(HS.FHIR.vSTU3.Repository.Storage).IsSharedResourceType(resource.resourceType) {
		do $system.Encryption.SHA1HashResult()
		//Hash will be computed on first 32KB of resource stream
		do $system.Encryption.SHA1HashInput(resourceStream.Read())
		set hash = $system.Encryption.Base64Encode($system.Encryption.SHA1HashResult())
		if $get(..resourceHash(hash)) '= "" {
			set id = ..resourceHash(hash)
			set duplicate = 1
		}
		else {
			set id = ..AssignResourceId(resource.resourceType)
			set ..resourceHash(hash) = id
		}
	}
	quit duplicate
}

/// Ids will be assigned using a random UUID per FHIR convention when a temporary id
/// is needed. If an additional identifier is passed in in <var>identifier</var>,
/// the newly created id will be saved in the class property resourceIds so that a lookup
/// can be done on that identifier in GetIdByIdentifier or GetPatientId
Method AssignResourceId(resourceType As %String, identifier As %String = "") As %String
{
	set id = $zconvert($system.Util.CreateGUID(), "L")
	
	if identifier '= "" {
		set ..resourceIds(resourceType, identifier) = id
	}
	if resourceType = "Patient" {
		set ..resourceIds(resourceType) = id
	}
	quit id
}

/// Perform a lookup in the resourceIds object property, specifying resource type
/// and identifier.
Method GetIdByIdentifier(resourceType As %String, identifier As %String) As %String
{
	if $get(..resourceIds(resourceType, identifier)) = "" {
		quit ..AssignResourceId(resourceType, identifier)
	}
	else {
		quit ..resourceIds(resourceType, identifier)
	}
}

/// Perform a lookup in the resourceIds object property, specifying a resource type
/// of "Patient" (there will be only one).
Method GetPatientId() As %String
{
	if $get(..resourceIds("Patient")) = "" {
		quit ..AssignResourceId("Patient")
	}
	else {
		quit ..resourceIds("Patient")
	}
}

/// Default is no prefix
Method GetURLPrefix() As %String
{
	quit ""
}

}
