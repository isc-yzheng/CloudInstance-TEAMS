Class HS.FHIR.vDSTU2.Model.Resource.ValueSet.Expansion Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ValueSet.Expansion";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ValueSet.Expansion";

/// An identifier that uniquely identifies this expansion of the valueset. Systems may re-use the same identifier as long as the expansion and the definition remain the same, but are not required to do so.
Property identifier As HS.FHIR.vDSTU2.Model.Datatype.Uri(XMLNAME = "identifier") [ Required ];

/// The time at which the expansion was produced by the expanding system.
Property timestamp As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "timestamp") [ Required ];

/// The total number of concepts in the expansion. If the number of concept nodes in this resource is less than the stated number, then the server can return more using the offset parameter.
Property total As HS.FHIR.vDSTU2.Model.Datatype.Integer(XMLNAME = "total");

/// If paging is being used, the offset at which this resource starts.  I.e. this resource is a partial view into the expansion. If paging is not being used, this element SHALL not be present.
Property offset As HS.FHIR.vDSTU2.Model.Datatype.Integer(XMLNAME = "offset");

/// A Parameter that controlled the expansion process. These parameters may be used by users of expanded value sets to check whether the expansion is suitable for a particular purpose, or to pick the correct expansion.
Property parameter As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Parameter(XMLNAME = "parameter", XMLPROJECTION = "ELEMENT");

/// The codes that are contained in the value set expansion.
Property contains As list Of HS.FHIR.vDSTU2.Model.Resource.ValueSet.Contains(XMLNAME = "contains", XMLPROJECTION = "ELEMENT");

/// Set method for the "identifier" property.
Method SetIdentifier(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Uri).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Uri object failed") Quit
		Set ..identifier = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "timestamp" property.
Method SetTimestamp(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..timestamp = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "total" property.
Method SetTotal(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..total = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "offset" property.
Method SetOffset(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..offset = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
