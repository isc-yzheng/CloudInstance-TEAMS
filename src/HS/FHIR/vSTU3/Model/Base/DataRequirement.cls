/// Describes a required data item for evaluation in terms of the type of data, and optional code or date-based filters of the data.<br>
/// If the element is present, it must have a value for at least one of the defined elements, an @id referenced from the Narrative, or extensions
Class HS.FHIR.vSTU3.Model.Base.DataRequirement Extends HS.FHIR.vSTU3.Model.Base.Element [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "DataRequirement";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

/// The type of the required data, specified as the type name of a resource. For profiles, this value is set to the type of the base resource of the profile.
Property type As HS.FHIR.vSTU3.Model.Datatype.Code(XMLNAME = "type", XMLPROJECTION = "ELEMENT") [ Required ];

/// The profile of the required data, specified as the uri of the profile definition.
Property profile As list Of HS.FHIR.vSTU3.Model.Datatype.Uri(XMLNAME = "profile", XMLPROJECTION = "ELEMENT");

/// Indicates that specific elements of the type are referenced by the knowledge module and must be supported by the consumer in order to obtain an effective evaluation. This does not mean that a value is required for this element, only that the consuming system must understand the element and be able to provide values for it if they are available. Note that the value for this element can be a path to allow references to nested elements. In that case, all the elements along the path must be supported.
Property mustSupport As list Of HS.FHIR.vSTU3.Model.Datatype.String(XMLNAME = "mustSupport", XMLPROJECTION = "ELEMENT");

/// Code filters specify additional constraints on the data, specifying the value set of interest for a particular element of the data.
Property codeFilter As list Of HS.FHIR.vSTU3.Model.Base.DataRequirement.CodeFilter(XMLNAME = "codeFilter", XMLPROJECTION = "ELEMENT");

/// Date filters specify additional constraints on the data in terms of the applicable date range for specific elements.
Property dateFilter As list Of HS.FHIR.vSTU3.Model.Base.DataRequirement.DateFilter(XMLNAME = "dateFilter", XMLPROJECTION = "ELEMENT");

/// Set method for the "type" property.
Method SetType(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Code).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Code object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..type = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "profile" property.
Method SetProfile(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..profile.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Insert method for the "mustSupport" property.
Method SetMustSupport(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set tSC = ..mustSupport.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
