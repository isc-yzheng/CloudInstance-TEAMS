/// A group of related requests that can be used to capture intended activities that have inter-dependencies such as "give this medication after that one".
Class HS.FHIR.vSTU3.Model.Resource.RequestGroup.Action Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "RequestGroup.Action";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "RequestGroup.Action";

Parameter JSONTYPEFIELD;

/// A user-visible label for the action.
Property label As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "label", XMLPROJECTION = "ELEMENT");

/// The title of the action displayed to a user.
Property title As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "title", XMLPROJECTION = "ELEMENT");

/// A short description of the action used to provide a summary to display to the user.
Property description As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "description", XMLPROJECTION = "ELEMENT");

/// A text equivalent of the action to be performed. This provides a human-interpretable description of the action when the definition is consumed by a system that may not be capable of interpreting it dynamically.
Property textEquivalent As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "textEquivalent", XMLPROJECTION = "ELEMENT");

/// A code that provides meaning for the action or action group. For example, a section may have a LOINC code for a the section of a documentation template.
Property code As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "code", XMLPROJECTION = "ELEMENT");

/// Didactic or other informational resources associated with the action that can be provided to the CDS recipient. Information resources can include inline text commentary and links to web resources.
Property documentation As list Of HS.FHIR.vSTU3.Model.Base.RelatedArtifact(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// An expression that describes applicability criteria, or start/stop conditions for the action.
Property condition As list Of HS.FHIR.vSTU3.Model.Resource.RequestGroup.Condition(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// A relationship to another action such as "before" or "30-60 minutes after start of".
Property relatedAction As list Of HS.FHIR.vSTU3.Model.Resource.RequestGroup.RelatedAction(XMLNAME = "relatedAction", XMLPROJECTION = "ELEMENT");

Property timingDateTime As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "timingDateTime", XMLPROJECTION = "ELEMENT");

Property timingPeriod As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

Property timingDuration As HS.FHIR.vSTU3.Model.Base.Duration(XMLNAME = "timingDuration", XMLPROJECTION = "ELEMENT");

Property timingRange As HS.FHIR.vSTU3.Model.Base.Range(XMLNAME = "timingRange", XMLPROJECTION = "ELEMENT");

Property timingTiming As HS.FHIR.vSTU3.Model.Base.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

/// The participant that should perform or be responsible for this action.
Property participant As list Of HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

/// The type of action to perform (create, update, remove).
Property type As HS.FHIR.vSTU3.Model.Base.Coding(XMLNAME = "type", XMLPROJECTION = "ELEMENT");

/// Defines the grouping behavior for the action and its children.
Property groupingBehavior As HS.FHIR.vSTU3.Model.Base.ActionGroupingBehavior(XMLNAME = "groupingBehavior", XMLPROJECTION = "ELEMENT");

/// Defines the selection behavior for the action and its children.
Property selectionBehavior As HS.FHIR.vSTU3.Model.Base.ActionSelectionBehavior(XMLNAME = "selectionBehavior", XMLPROJECTION = "ELEMENT");

/// Defines the requiredness behavior for the action.
Property requiredBehavior As HS.FHIR.vSTU3.Model.Base.ActionRequiredBehavior(XMLNAME = "requiredBehavior", XMLPROJECTION = "ELEMENT");

/// Defines whether the action should usually be preselected.
Property precheckBehavior As HS.FHIR.vSTU3.Model.Base.ActionPrecheckBehavior(XMLNAME = "precheckBehavior", XMLPROJECTION = "ELEMENT");

/// Defines whether the action can be selected multiple times.
Property cardinalityBehavior As HS.FHIR.vSTU3.Model.Base.ActionCardinalityBehavior(XMLNAME = "cardinalityBehavior", XMLPROJECTION = "ELEMENT");

/// The resource that is the target of the action (e.g. CommunicationRequest).
Property resource As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "resource", XMLPROJECTION = "ELEMENT");

/// Sub actions.
Property action As list Of HS.FHIR.vSTU3.Model.Resource.RequestGroup.Action(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

/// Set method for the "label" property.
Method SetLabel(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..label = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "title" property.
Method SetTitle(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..title = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "description" property.
Method SetDescription(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "textEquivalent" property.
Method SetTextEquivalent(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..textEquivalent = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "code" property.
Method SetCode(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..code.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "timingDateTime" property.
Method SetTimingDateTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..timingDateTime = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "timingPeriod" property.
Method SetTimingPeriod(pStart As %String = "", pEnd As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Period).%New(pStart, pEnd, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Period object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..timingPeriod = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "participant" property.
Method SetParticipant(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..participant.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

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

/// Set method for the "groupingBehavior" property.
Method SetGroupingBehavior(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ActionGroupingBehavior).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ActionGroupingBehavior object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..groupingBehavior = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "selectionBehavior" property.
Method SetSelectionBehavior(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ActionSelectionBehavior).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ActionSelectionBehavior object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..selectionBehavior = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "requiredBehavior" property.
Method SetRequiredBehavior(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ActionRequiredBehavior).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ActionRequiredBehavior object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..requiredBehavior = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "precheckBehavior" property.
Method SetPrecheckBehavior(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ActionPrecheckBehavior).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ActionPrecheckBehavior object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..precheckBehavior = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "cardinalityBehavior" property.
Method SetCardinalityBehavior(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ActionCardinalityBehavior).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ActionCardinalityBehavior object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..cardinalityBehavior = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "resource" property.
Method SetResource(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..resource = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
