Class HS.FHIR.vDSTU2.Model.Resource.Composition.Attester Extends HS.FHIR.vDSTU2.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter JSONTYPEFIELD;

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Composition.Attester";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Composition.Attester";

/// The type of attestation the authenticator offers.
Property mode As list Of HS.FHIR.vDSTU2.Model.Base.CompositionAttestationMode(XMLNAME = "mode", XMLPROJECTION = "ELEMENT") [ Required ];

/// When composition was attested by the party.
Property time As HS.FHIR.vDSTU2.Model.Datatype.DateTime(XMLNAME = "time") [ SqlFieldName = _time ];

/// Who attested the composition in the specified way.
Property party As HS.FHIR.vDSTU2.Model.Base.Reference(XMLNAME = "party");

/// Insert method for the "mode" property.
Method SetMode(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.CompositionAttestationMode).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR CompositionAttestationMode object failed") Quit
		Set tSC = ..mode.Insert(tObj) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "time" property.
Method SetTime(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Datatype.DateTime).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR DateTime object failed") Quit
		Set ..time = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "party" property.
Method SetParty(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tObj = ##class(HS.FHIR.vDSTU2.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed") Quit
		Set ..party = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
