Class HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3 Extends %RegisteredObject [ Abstract ]
{

/// This method may be overridden to modify how the values are assigned
/// for the EncounterNumber property of Encounter streamlets.
Method AssignEncounterNumber() As %String [ Abstract ]
{
}

/// This method may be overridden to modify how the values are assigned
/// for the ExternalId property for CarePlan related streamlets,
/// HealthConcern and Goal.
Method AssignExternalId(streamletType As %String) As %String [ Abstract ]
{
}

/// This method may be overridden to modify the SDA3 SendingFacility
/// property for the Container.
Method GetSendingFacility(bundle As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle) As %String [ Abstract ]
{
}

}
