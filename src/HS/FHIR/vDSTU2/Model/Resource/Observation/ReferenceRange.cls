Class HS.FHIR.vDSTU2.Model.Resource.Observation.ReferenceRange Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Observation.ReferenceRange";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Observation.ReferenceRange";

/// The value of the low bound of the reference range.  The low bound of the reference range endpoint is inclusive of the value (e.g.  reference range is>=5 -<=9).   If the low bound is omitted,  it is assumed to be meaningless (e.g. reference range is<=2.3).
Property low As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "low");

/// The value of the high bound of the reference range.  The high bound of the reference range endpoint is inclusive of the value (e.g.  reference range is>=5 -<=9).   If the high bound is omitted,  it is assumed to be meaningless (e.g. reference range is>= 2.3).
Property high As HS.FHIR.vDSTU2.Model.Base.SimpleQuantity(XMLNAME = "high");

/// Code for the meaning of the reference range.
Property meaning As HS.FHIR.vDSTU2.Model.Base.CodeableConcept(XMLNAME = "meaning");

/// The age at which this reference range is applicable. This is a neonatal age (e.g. number of weeks at term) if the meaning says so.
Property age As HS.FHIR.vDSTU2.Model.Base.Range(XMLNAME = "age");

/// Text based reference range in an observation which may be used when a quantitative range is not appropriate for an observation.  An example would be a reference value of"Negative" or a list or table of 'normals'.
Property text As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "text");

/// Set method for the "meaning" property.
Method SetMeaning(pCode As %String = "", pDisplay As %String = "", pSystem As %String = "", pText As %String = "", pVersion As %String = "", pUserSelected As %String = "", pId As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CodeableConcept).%New(pCode, pDisplay, pSystem, pText, pVersion, pUserSelected, pId, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CodeableConcept object failed") Quit
		Set ..meaning = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "text" property.
Method SetText(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..text = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
