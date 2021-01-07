Class HS.FHIR.DTL.Util.SDA3.Handler.CareTeam
{

/// A CareTeam resource is created from a list of Organizations, Providers, and SupportContacts in the CarePlan streamlet.
/// The CareTeam is then saved and linked to the CarePlan resource.
/// source - Either an Organization, Provider, or SupportContact
/// target - The target CareTeam resource, where the newly created resources will be saved to so they
/// can be added to the repository later
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object.
ClassMethod Participant(source As %RegisteredObject, target As %RegisteredObject, ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Element.CareTeam.participant
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	if source.%ClassName(0) = "DocumentOrganization" {
		set member = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Organization", "%New")
		set DTL = aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".DocumentOrganization.Organization")
	}
	elseif source.%ClassName(0) = "DocumentProvider" {
		set member = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Practitioner", "%New")
		set DTL = aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".DocumentProvider.Practitioner")
	}
	elseif source.%ClassName(0) = "SupportContact" {
		set member = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.RelatedPerson", "%New")
		set DTL = aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".SupportContact.RelatedPerson")
	}
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", source, .member, .aux))
	
	set reference = aux("transformer").AddResource(source, member)
	set participant = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.CareTeam.participant", "%New")
	set participant.member = reference
	
 	quit participant
}

}
