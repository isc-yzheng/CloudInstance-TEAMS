/// A resource that includes narrative, extensions, and contained resources.
Class HS.FHIR.vSTU3.Model.Base.DomainResource Extends HS.FHIR.vSTU3.Model.Base.Resource [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DomainResource";

Parameter XMLSEQUENCE = 1;

/// A human-readable narrative that contains a summary of the resource, and may be used to represent the content of the resource to a human. The narrative need not encode all the structured data, but is required to contain sufficient detail to make it "clinically safe" for a human to just read the narrative. Resource definitions may define what content should be represented in the narrative to ensure clinical safety.
Property text As HS.FHIR.vSTU3.Model.Base.Narrative(XMLNAME = "text", XMLPROJECTION = "ELEMENT");

/// These resources do not have an independent existence apart from the resource that contains them - they cannot be identified independently, and nor can they have their own independent transaction scope.
Property contained As list Of HS.FHIR.vSTU3.Model.Base.ResourceContainer(XMLNAME = "contained", XMLPROJECTION = "ELEMENT");

/// May be used to represent additional information that is not part of the basic definition of the resource. In order to make the use of extensions safe and manageable, there is a strict set of governance  applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension.
Property extension As list Of HS.FHIR.vSTU3.Model.Base.Extension(XMLNAME = "extension", XMLPROJECTION = "ELEMENT");

/// May be used to represent additional information that is not part of the basic definition of the resource, and that modifies the understanding of the element that contains it. Usually modifier elements provide negation or qualification. In order to make the use of extensions safe and manageable, there is a strict set of governance applied to the definition and use of extensions. Though any implementer is allowed to define an extension, there is a set of requirements that SHALL be met as part of the definition of the extension. Applications processing a resource are required to check for modifier extensions.
Property modifierExtension As list Of HS.FHIR.vSTU3.Model.Base.Extension(XMLNAME = "modifierExtension", XMLPROJECTION = "ELEMENT");

/// Set method for the "text" property.
Method SetText(pStatus As %String = "", pDiv As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Narrative).%New(pStatus, pDiv)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Narrative object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "contained" property.
Method SetContained(pResource As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ResourceContainer).%New(pResource)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceContainer object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..contained.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
