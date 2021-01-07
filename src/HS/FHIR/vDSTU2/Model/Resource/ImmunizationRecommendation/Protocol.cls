Class HS.FHIR.vDSTU2.Model.Resource.ImmunizationRecommendation.Protocol Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "ImmunizationRecommendation.Protocol";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "ImmunizationRecommendation.Protocol";

/// Indicates the nominal position in a series of the next dose.  This is the recommended dose number as per a specified protocol.
Property doseSequence As HS.FHIR.vDSTU2.Model.Datatype.Integer(XMLNAME = "doseSequence");

/// Contains the description about the protocol under which the vaccine was administered.
Property description As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "description");

/// Indicates the authority who published the protocol.  For example, ACIP.
Property authority As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "authority");

/// One possible path to achieve presumed immunity against a disease - within the context of an authority.
Property series As HS.FHIR.vDSTU2.Model.Datatype.String(XMLNAME = "series");

/// Set method for the "doseSequence" property.
Method SetDoseSequence(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.Integer).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Integer object failed") Quit
		Set ..doseSequence = tObj
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
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..description = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "authority" property.
Method SetAuthority(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..authority = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "series" property.
Method SetSeries(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.String).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR String object failed") Quit
		Set ..series = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
