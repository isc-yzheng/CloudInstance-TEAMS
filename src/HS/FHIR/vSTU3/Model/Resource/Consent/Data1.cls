/// A record of a healthcare consumer’s policy choices, which permits or denies identified recipient(s) or recipient role(s) to perform one or more actions within a given policy context, for specific purposes and periods of time.
Class HS.FHIR.vSTU3.Model.Resource.Consent.Data1 Extends HS.FHIR.vSTU3.Model.Base.BackboneElement [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "Consent.Data1";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Consent.Data1";

Parameter JSONTYPEFIELD;

/// How the resource reference is interpreted when testing consent restrictions.
Property meaning As HS.FHIR.vSTU3.Model.Base.ConsentDataMeaning(XMLNAME = "meaning", XMLPROJECTION = "ELEMENT") [ Required ];

/// A reference to a specific resource that defines which resources are covered by this consent.
Property reference As HS.FHIR.vSTU3.Model.Base.Reference(XMLNAME = "reference", XMLPROJECTION = "ELEMENT") [ Required ];

/// Set method for the "meaning" property.
Method SetMeaning(pValue As %String = "", pExtension As %RegisteredObject = "", pId As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.ConsentDataMeaning).%New(pValue, pExtension, pId)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ConsentDataMeaning object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..meaning = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Set method for the "reference" property.
Method SetReference(pReference As %String = "", pDisplay As %String = "", pExtension As %RegisteredObject = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror
		Set tObj = ##class(HS.FHIR.vSTU3.Model.Base.Reference).%New(pReference, pDisplay, pExtension)
		If '$IsObject($Get(tObj)) Set err=$Select($Get(%objlasterror)="":"",1:$system.Status.GetErrorText(%objlasterror)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR Reference object failed"_$Select(err="":"",1:" - "_err)) Quit
		Set ..reference = tObj
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
