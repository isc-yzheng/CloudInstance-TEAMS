/// Provenance of a resource is a record that describes entities and processes involved in producing and delivering or otherwise influencing that resource. Provenance provides a critical foundation for assessing authenticity, enabling trust, and allowing reproducibility. Provenance assertions are a form of contextual metadata and can themselves become important records with their own provenance. Provenance statement indicates clinical significance in terms of confidence in authenticity, reliability, and trustworthiness, integrity, and stage in lifecycle (e.g. Document Completion - has the artifact been legally authenticated), all of which may impact security, privacy, and trust policies.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.Provenance Extends HS.FHIR.vSTU3.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Provenance";

Parameter XMLSEQUENCE = 1;

/// The Reference(s) that were generated or updated by  the activity described in this resource. A provenance can point to more than one target if multiple resources were created/updated by the same activity.
Property target As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "target", XMLPROJECTION = "ELEMENT");

/// The period during which the activity occurred.
Property period As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "period", XMLPROJECTION = "ELEMENT");

/// The instant of time at which the activity was recorded.
Property recorded As HS.FHIR.vSTU3.Model.Datatype.Instant(XMLNAME = "recorded", XMLPROJECTION = "ELEMENT") [ Required ];

/// Policy or plan the activity was defined by. Typically, a single activity may have multiple applicable policy documents, such as patient consent, guarantor funding, etc.
Property policy As list Of HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "policy", XMLPROJECTION = "ELEMENT");

/// Where the activity occurred, if relevant.
Property location As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "location", XMLPROJECTION = "ELEMENT");

/// The reason that the activity was taking place.
Property reason As list Of HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// An activity is something that occurs over a period of time and acts upon or with entities; it may include consuming, processing, transforming, modifying, relocating, using, or generating entities.
Property activity As HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "activity", XMLPROJECTION = "ELEMENT");

/// An actor taking a role in an activity  for which it can be assigned some degree of responsibility for the activity taking place.
Property agent As list Of HS.FHIR.vSTU3.Model.Resource.Provenance.Agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT");

/// An entity used in this activity.
Property entity As list Of HS.FHIR.vSTU3.Model.Resource.Provenance.Entity(XMLNAME = "entity", XMLPROJECTION = "ELEMENT");

/// A digital signature on the target Reference(s). The signer should match a Provenance.agent. The purpose of the signature is indicated.
Property signature As list Of HS.FHIR.vSTU3.Model.Base.Signature(XMLNAME = "signature", XMLPROJECTION = "ELEMENT");

/// Insert method for the "target" property.
Method SetTarget(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..target.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "period" property.
Method SetPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..period = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "recorded" property.
Method SetRecorded(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Instant).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Instant object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..recorded = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "policy" property.
Method SetPolicy(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..policy.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "location" property.
Method SetLocation(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..location = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "reason" property.
Method SetReason(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..reason.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "activity" property.
Method SetActivity(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..activity = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
