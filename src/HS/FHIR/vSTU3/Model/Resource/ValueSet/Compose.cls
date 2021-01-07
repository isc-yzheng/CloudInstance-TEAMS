/// A value set specifies a set of codes drawn from one or more code systems.
Class HS.FHIR.vSTU3.Model.Resource.ValueSet.Compose Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Compose";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Compose";

Parameter JSONTYPEFIELD;

/// If a locked date is defined, then the Content Logical Definition must be evaluated using the current version as of the locked date for referenced code system(s) and value set instances where ValueSet.compose.include.version is not defined.
Property lockedDate As HS.FHIR.vSTU3.Model.Datatype.Date(XMLNAME = "lockedDate", XMLPROJECTION = "ELEMENT");

/// Whether inactive codes - codes that are not approved for current use - are in the value set. If inactive = true, inactive codes are to be included in the expansion, if inactive = false, the inactive codes will not be included in the expansion. If absent, the behavior is determined by the implementation, or by the applicable ExpansionProfile (but generally, inactive codes would be expected to be included).
Property inactive As HS.FHIR.vSTU3.Model.Datatype.Boolean(XMLNAME = "inactive", XMLPROJECTION = "ELEMENT");

/// Include one or more codes from a code system or other value set(s).
Property include As list Of HS.FHIR.vSTU3.Model.Resource.ValueSet.Include(XMLNAME = "include", XMLPROJECTION = "ELEMENT");

/// Exclude one or more codes from the value set based on code system filters and/or other value sets.
Property exclude As list Of HS.FHIR.vSTU3.Model.Resource.ValueSet.Include(XMLNAME = "exclude", XMLPROJECTION = "ELEMENT");

/// Set method for the "lockedDate" property.
Method SetLockedDate(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Date).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Date object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..lockedDate = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "inactive" property.
Method SetInactive(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Boolean).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Boolean object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..inactive = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
