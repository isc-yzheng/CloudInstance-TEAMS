/// This resource allows for the definition of various types of plans as a sharable, consumable, and executable artifact. The resource is general enough to support the description of a broad range of clinical artifacts such as clinical decision support rules, order sets and protocols.
Class HS.FHIR.vSTU3.Model.Resource.PlanDefinition.Action Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "PlanDefinition.Action";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "PlanDefinition.Action";

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

/// A description of why this action is necessary or appropriate.
Property reason As list Of HS.FHIR.vSTU3.Model.Base.CodeableConcept(XMLNAME = "reason", XMLPROJECTION = "ELEMENT");

/// Didactic or other informational resources associated with the action that can be provided to the CDS recipient. Information resources can include inline text commentary and links to web resources.
Property documentation As list Of HS.FHIR.vSTU3.Model.Base.RelatedArtifact(XMLNAME = "documentation", XMLPROJECTION = "ELEMENT");

/// Identifies goals that this action supports. The reference must be to a goal element defined within this plan definition.
Property goalId As list Of HS.FHIR.vSTU3.Model.Datatype.Id(XMLNAME = "goalId", XMLPROJECTION = "ELEMENT");

/// A description of when the action should be triggered.
Property triggerDefinition As list Of HS.FHIR.vSTU3.Model.Base.TriggerDefinition(XMLNAME = "triggerDefinition", XMLPROJECTION = "ELEMENT");

/// An expression that describes applicability criteria, or start/stop conditions for the action.
Property condition As list Of HS.FHIR.vSTU3.Model.Resource.PlanDefinition.Condition(XMLNAME = "condition", XMLPROJECTION = "ELEMENT");

/// Defines input data requirements for the action.
Property input As list Of HS.FHIR.vSTU3.Model.Base.DataRequirement(XMLNAME = "input", XMLPROJECTION = "ELEMENT");

/// Defines the outputs of the action, if any.
Property output As list Of HS.FHIR.vSTU3.Model.Base.DataRequirement(XMLNAME = "output", XMLPROJECTION = "ELEMENT");

/// A relationship to another action such as "before" or "30-60 minutes after start of".
Property relatedAction As list Of HS.FHIR.vSTU3.Model.Resource.PlanDefinition.RelatedAction(XMLNAME = "relatedAction", XMLPROJECTION = "ELEMENT");

Property timingDateTime As HS.FHIR.vSTU3.Model.Datatype.DateTime(XMLNAME = "timingDateTime", XMLPROJECTION = "ELEMENT");

Property timingPeriod As HS.FHIR.vSTU3.Model.Base.Period(XMLNAME = "timingPeriod", XMLPROJECTION = "ELEMENT");

Property timingDuration As HS.FHIR.vSTU3.Model.Base.Duration(XMLNAME = "timingDuration", XMLPROJECTION = "ELEMENT");

Property timingRange As HS.FHIR.vSTU3.Model.Base.Range(XMLNAME = "timingRange", XMLPROJECTION = "ELEMENT");

Property timingTiming As HS.FHIR.vSTU3.Model.Base.Timing(XMLNAME = "timingTiming", XMLPROJECTION = "ELEMENT");

/// Indicates who should participate in performing the action described.
Property participant As list Of HS.FHIR.vSTU3.Model.Resource.PlanDefinition.Participant(XMLNAME = "participant", XMLPROJECTION = "ELEMENT");

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

/// A reference to an ActivityDefinition that describes the action to be taken in detail, or a PlanDefinition that describes a series of actions to be taken.
Property definition As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "definition", XMLPROJECTION = "ELEMENT");

/// A reference to a StructureMap resource that defines a transform that can be executed to produce the intent resource using the ActivityDefinition instance as the input.
Property transform As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "transform", XMLPROJECTION = "ELEMENT");

/// Customizations that should be applied to the statically defined resource. For example, if the dosage of a medication must be computed based on the patient's weight, a customization would be used to specify an expression that calculated the weight, and the path on the resource that would contain the result.
Property dynamicValue As list Of HS.FHIR.vSTU3.Model.Resource.PlanDefinition.DynamicValue(XMLNAME = "dynamicValue", XMLPROJECTION = "ELEMENT");

/// Sub actions that are contained within the action. The behavior of this action determines the functionality of the sub-actions. For example, a selection behavior of at-most-one indicates that of the sub-actions, at most one may be chosen as part of realizing the action definition.
Property action As list Of HS.FHIR.vSTU3.Model.Resource.PlanDefinition.Action(XMLNAME = "action", XMLPROJECTION = "ELEMENT");

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

/// Insert method for the "reason" property.
Method SetReason(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..reason.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "goalId" property.
Method SetGoalId(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Id).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Id object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..goalId.Insert(tObj) Quit:$$$ISERR(tSC)
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

/// Set method for the "definition" property.
Method SetDefinition(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..definition = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "transform" property.
Method SetTransform(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..transform = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
