Class HS.FHIR.DTL.Util.SDA3.Handler.ExternalId
{

/// Generate the resource id for a resource given the external id and source mrn for the streamlet.
/// The resource id is the hashed, base32 encoded, concatenated string of MRN and external id.
/// The = symbol will be replaced with a - symbol as it is valid for the FHIR resource id data type.
ClassMethod GenerateId(externalId As %String, MPIID As %String, sourceMRN As %String, Output id As %String) As %String
{
	set hashString = MPIID _ ";" _ sourceMRN _ ";" _ externalId
	do $system.Encryption.SHA1HashResult()
	do $system.Encryption.SHA1HashInput(hashString)
	set hashResult = $system.Encryption.Base32Encode($system.Encryption.SHA1HashResult())
	return $extract($replace(hashResult, "=", "-"), 1, 64)
}

/// Transform an ExternalId into a FHIR identifier element. If there exists a system portion of the ExternalId
/// and an entry in the OID registry exists, that will be used. In addition, the system portion
/// will be preserved in an extension
ClassMethod Identifier(externalId As %String) As %RegisteredObject
{
	set tSC = $$$OK
	try {
		if externalId = "" set identifier = "" quit
		
		set identifier = ##class(HS.FHIR.DTL.vSTU3.Model.Datatype.Identifier).%New()
		
		if (externalId [ "|") {
			set systemExtension = ##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()
			set systemExtension.url = "http://intersystems.com/fhir/extn/sda3/lib/external-id-system"
			set systemExtension.valueString = $piece(externalId, "|", 1)
			
			do identifier.extension.Insert(systemExtension)
		}
		
		set identifier.value = ..GetValue(externalId)
		set identifier.system = ..GetSystem(externalId)
		set identifier.type = ##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()
		set identifier.type.text = "ExternalId"
		set identifier.use = "official"
	} catch ex {
		set identifier = ""
	}
	quit identifier
}

/// If there is a |, that means the first section is the system and the second
/// section is the value. We will attempt to get a URI for the system if one exists. If none
/// are returned, we will assume it is already a URI.
ClassMethod GetSystem(externalId As %String) As %String
{
	if externalId '[ "|" quit ""
	set system = $piece(externalId, "|", 1)
	set uri = ##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(system)
	if uri '= "" {
		// If uri has a value then it is already a properly formed URI.
		quit uri
	}
	elseif ##class(HS.HC.Util).IsURI(system) {
		// If system is a URI but is an OID or UUID without the prefix,
		// then add the prefix now.
		if '(($extract(system,1,8)="urn:oid:")||($extract(system,1,9)="urn:uuid:")||($extract(system,1,4)="http")) {
			if ##class(HS.HC.Util).IsOID(system) {
				set system = "urn:oid:"_system
			} elseif ##class(HS.HC.Util).IsUUID((system)) {
				set system = "urn:uuid:"_system
			}
		}
		quit system
	}
	else {
		quit ""
	}
}

ClassMethod GetValue(externalId As %String) As %String
{
	quit $piece(externalId, "|", *)
}

/// Combine the value and system from an identifier to reconstruct the external id. The inverse operation as
/// above will be used to choose the system, and a | will be used to separate the system and value.
ClassMethod GenerateExternalId(value As %String, system As %String, Output externalId) As %Status
{
	set tSC = $$$OK
	try {
		if system '= "" {
			set externalId = system _ "|" _ value
		}
		else {
			set externalId = value
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
