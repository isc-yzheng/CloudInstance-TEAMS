/// A set of rules of how FHIR is used to solve a particular problem. This resource is used to gather all the parts of an implementation guide into a logical whole and to publish a computable definition of all the parts.
Class HS.FHIR.vSTU3.Model.Resource.ImplementationGuide.Global Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImplementationGuide.Global";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImplementationGuide.Global";

Parameter JSONTYPEFIELD;

/// The type of resource that all instances must conform to.
Property type As HS.FHIR.vSTU3.Model.Base.ResourceType(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// A reference to the profile that all instances must conform to.
Property profile As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "profile", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ResourceType).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceType object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "profile" property.
Method SetProfile(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..profile = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
