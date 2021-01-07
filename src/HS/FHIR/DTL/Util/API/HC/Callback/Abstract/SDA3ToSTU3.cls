Class HS.FHIR.DTL.Util.API.HC.Callback.Abstract.SDA3ToSTU3 Extends %RegisteredObject [ Abstract ]
{

/// This method may be overridden to modify how duplicates are determined. If it is a duplicate, <var>id</var>
/// must be set to the resource id of the original resource. If it isn't a duplicate it doesn't need to be used,
/// but it can be. The method shall return true if the resource is a duplicate and false if the resource isn't.
Method IsDuplicate(resource As HS.FHIR.DTL.vSTU3.Model.Base.Resource, Output id As %String) As %Boolean [ Abstract ]
{
}

/// This method may be overridden to modify how resource ids are assigned
/// in the SDA3 to STU3 transformations. This method also has <var>identifier</var>
/// as one of its parameters. <var>identifier</var> is a unique identifier for a streamlet
/// that will be referenced by other streamlets, for example, EncounterNumber
/// on an Encounter streamlet. This parameter is provided so that the 
/// GetIdByIdentifier method can then perform a lookup and find the resource id
/// generated for the Encounter using only an EncounterNumber.
/// eg. an Encounter streamlet has EncounterNumber '1' (passed into <var>identifier</var>)
/// and is assigned resource id '672'. This method should link EncounterNumber '1' with
/// resource id '672' so when an Observation streamlet also has EncounterNumber '1' it can do a lookup in the
/// GetIdByIdentifier method and see the Encounter reference it should create is 'Encounter/672'.
Method AssignResourceId(resourceType As %String, identifier As %String = "") As %String [ Abstract ]
{
}

/// This method may be overridden to modify how the SDA3 to STU3 transformation
/// finds a resource id when attempting to link resources using an SDA3 identifier
/// (eg. EncounterNumber or ExternalId). The identifier is provided so a lookup can be performed.
/// It shall also handle the case where the resource hasn't already been
/// assigned (by calling out to the AssignResourceId method).
Method GetIdByIdentifier(resourceType As %String, identifier As %String) As %String [ Abstract ]
{
}

/// This method may be overridden to modify how the SDA3 to STU3 transformation
/// finds the Patient resource id when attempting to link resources to the
/// Patient resource. It should also handle the case where the Patient
/// resource hasn't already been assigned (by calling out to the AssignResourceId method).
Method GetPatientId() As %String [ Abstract ]
{
}

/// This method may be overridden to provide a URL prefix to be used in the fullURL
/// element in the bundle entry.
Method GetURLPrefix() As %String [ Abstract ]
{
}

}
