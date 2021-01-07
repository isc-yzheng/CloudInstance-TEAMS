/// Resource to define constraints on the Expansion of a FHIR ValueSet.
Class HS.FHIR.vSTU3.Model.Resource.ExpansionProfile.FixedVersion Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ExpansionProfile.FixedVersion";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ExpansionProfile.FixedVersion";

Parameter JSONTYPEFIELD;

/// The specific system for which to fix the version.
Property system As HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "system", XMLPROJECTION = "ELEMENT") [ Required ];

/// The version of the code system from which codes in the expansion should be included.
Property version As HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "version", XMLPROJECTION = "ELEMENT") [ Required ];

/// How to manage the intersection between a fixed version in a value set, and this fixed version of the system in the expansion profile.
Property mode As HS.FHIR.vSTU3.Model.Base.SystemVersionProcessingMode(XMLNAME = "mode", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "system" property.
Method SetSystem(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..system = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "version" property.
Method SetVersion(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..version = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.SystemVersionProcessingMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR SystemVersionProcessingMode object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..mode = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
