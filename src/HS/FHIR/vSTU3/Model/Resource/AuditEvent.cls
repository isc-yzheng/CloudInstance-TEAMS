/// A record of an event made for purposes of maintaining a security log. Typical uses include detection of intrusion attempts and monitoring for inappropriate usage.<br>
/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Resource.AuditEvent Extends HS.FHIR.vSTU3.Model.Base.DomainResource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "AuditEvent";

Parameter XMLSEQUENCE = 1;

/// Identifier for a family of the event.  For example, a menu item, program, rule, policy, function code, application name or URL. It identifies the performed function.
Property type As HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// Identifier for the category of event.
Property subtype As list Of HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "subtype", XMLPROJECTION = "ELEMENT");

/// Indicator for type of action performed during the event that generated the audit.
Property action As HS.FHIR.vSTU3.Model.Base.AuditEventAction(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// The time when the event occurred on the source.
Property recorded As HS.FHIR.vSTU3.Model.Datatype.Instant(XMLNAME = "recorded", XMLPROJECTION = "ELEMENT") [ Required ];

/// Indicates whether the event succeeded or failed.
Property outcome As HS.FHIR.vSTU3.Model.Base.AuditEventOutcome(XMLNAME = "outcome", XMLPROJECTION = "ELEMENT");

/// A free text description of the outcome of the event.
Property outcomeDesc As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "outcomeDesc", XMLPROJECTION = "ELEMENT");

/// The purposeOfUse (reason) that was used during the event being recorded.
Property purposeOfEvent As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "purposeOfEvent", XMLPROJECTION = "ELEMENT");

/// An actor taking an active role in the event or activity that is logged.
Property agent As list Of HS.FHIR.vSTU3.Model.Resource.AuditEvent.Agent(XMLNAME = "agent", XMLPROJECTION = "ELEMENT");

/// The system that is reporting the event.
Property source As HS.FHIR.vSTU3.Model.Resource.AuditEvent.Source(XMLNAME = "source", XMLPROJECTION = "ELEMENT") [ Required ];

/// Specific instances of data or objects that have been accessed.
Property entity As list Of HS.FHIR.vSTU3.Model.Resource.AuditEvent.Entity(XMLNAME = "entity", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "subtype" property.
Method SetSubtype(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Coding).%New(pCode, pDisplay, pSystem, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Coding object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..subtype.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "action" property.
Method SetAction(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.AuditEventAction).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR AuditEventAction object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..action = tObj
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

/// Set method for the "outcome" property.
Method SetOutcome(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.AuditEventOutcome).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR AuditEventOutcome object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..outcome = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "outcomeDesc" property.
Method SetOutcomeDesc(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..outcomeDesc = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "purposeOfEvent" property.
Method SetPurposeOfEvent(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..purposeOfEvent.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
